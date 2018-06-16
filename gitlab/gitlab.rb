# Docker options
## Prevent Postgres from trying to allocate 25% of total memory
postgresql['shared_buffers'] = '1MB'

# Manage accounts with docker
manage_accounts['enable'] = false

# Get hostname from shell
host = `hostname`.strip
external_url "http://#{host}"


gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS' ###! **remember to close this block with 'EOS' below**
main: # 'main' is the GitLab 'provider ID' of this LDAP server
  label: 'LDAP'
  host: '49.4.7.224'
  port: 389
  uid: 'sAMAccountName'
  method: 'plain' # "tls" or "ssl" or "plain"
  bind_dn: 'CN=Administrator,CN=Users,DC=smartoam,DC=com'
  password: 'Tyz124!@$'
  active_directory: true
  allow_username_or_email_login: true
  block_auto_created_users: false
  base: 'ou=group,dc=smartoam,dc=com'
  user_filter: ''
EOS

# Load custom config from environment variable: GITLAB_OMNIBUS_CONFIG
# Disabling the cop since rubocop considers using eval to be security risk but
# we don't have an easy way out, atleast yet.
eval ENV["GITLAB_OMNIBUS_CONFIG"].to_s # rubocop:disable Security/Eval

# Load configuration stored in /etc/gitlab/gitlab.rb
from_file("/etc/gitlab/gitlab.rb")
