Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab1BATFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:05:35 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:56545 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1BATFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:05:33 -0500
Subject: Re: [PATCH 2/2] security: remove unused security_sysctl hook
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <1296578696-5989-1-git-send-email-lucian.grijincu@gmail.com>
References: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
	 <1296578696-5989-1-git-send-email-lucian.grijincu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Tue, 01 Feb 2011 14:05:21 -0500
Message-ID: <1296587121.12605.30.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 18:44 +0200, Lucian Adrian Grijincu wrote:
> The only user for this hook was selinux. sysctl routes every call
> through /proc/sys/. Selinux and other security modules use the file
> system checks for sysctl too, so no need for this hook any more.
> 
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  include/linux/security.h |   13 -------------
>  kernel/sysctl.c          |    5 -----
>  security/capability.c    |    6 ------
>  security/security.c      |    5 -----
>  4 files changed, 0 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index c642bb8..e7b48dc 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1257,12 +1257,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@cap contains the capability <include/linux/capability.h>.
>   *	@audit: Whether to write an audit message or not
>   *	Return 0 if the capability is granted for @tsk.
> - * @sysctl:
> - *	Check permission before accessing the @table sysctl variable in the
> - *	manner specified by @op.
> - *	@table contains the ctl_table structure for the sysctl variable.
> - *	@op contains the operation (001 = search, 002 = write, 004 = read).
> - *	Return 0 if permission is granted.
>   * @syslog:
>   *	Check permission before accessing the kernel message ring or changing
>   *	logging to the console.
> @@ -1383,7 +1377,6 @@ struct security_operations {
>  		       const kernel_cap_t *permitted);
>  	int (*capable) (struct task_struct *tsk, const struct cred *cred,
>  			int cap, int audit);
> -	int (*sysctl) (struct ctl_table *table, int op);
>  	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
>  	int (*quota_on) (struct dentry *dentry);
>  	int (*syslog) (int type);
> @@ -1665,7 +1658,6 @@ int security_capset(struct cred *new, const struct cred *old,
>  int security_capable(int cap);
>  int security_real_capable(struct task_struct *tsk, int cap);
>  int security_real_capable_noaudit(struct task_struct *tsk, int cap);
> -int security_sysctl(struct ctl_table *table, int op);
>  int security_quotactl(int cmds, int type, int id, struct super_block *sb);
>  int security_quota_on(struct dentry *dentry);
>  int security_syslog(int type);
> @@ -1883,11 +1875,6 @@ int security_real_capable_noaudit(struct task_struct *tsk, int cap)
>  	return ret;
>  }
>  
> -static inline int security_sysctl(struct ctl_table *table, int op)
> -{
> -	return 0;
> -}
> -
>  static inline int security_quotactl(int cmds, int type, int id,
>  				     struct super_block *sb)
>  {
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0f1bd83..56f6fc1 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1685,13 +1685,8 @@ static int test_perm(int mode, int op)
>  
>  int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
>  {
> -	int error;
>  	int mode;
>  
> -	error = security_sysctl(table, op & (MAY_READ | MAY_WRITE | MAY_EXEC));
> -	if (error)
> -		return error;
> -
>  	if (root->permissions)
>  		mode = root->permissions(root, current->nsproxy, table);
>  	else
> diff --git a/security/capability.c b/security/capability.c
> index 2a5df2b..ebe3b5d 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -12,11 +12,6 @@
>  
>  #include <linux/security.h>
>  
> -static int cap_sysctl(ctl_table *table, int op)
> -{
> -	return 0;
> -}
> -
>  static int cap_syslog(int type)
>  {
>  	return 0;
> @@ -880,7 +875,6 @@ void __init security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, capable);
>  	set_to_cap_if_null(ops, quotactl);
>  	set_to_cap_if_null(ops, quota_on);
> -	set_to_cap_if_null(ops, sysctl);
>  	set_to_cap_if_null(ops, syslog);
>  	set_to_cap_if_null(ops, settime);
>  	set_to_cap_if_null(ops, vm_enough_memory);
> diff --git a/security/security.c b/security/security.c
> index 739e403..53d793a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -182,11 +182,6 @@ int security_real_capable_noaudit(struct task_struct *tsk, int cap)
>  	return ret;
>  }
>  
> -int security_sysctl(struct ctl_table *table, int op)
> -{
> -	return security_ops->sysctl(table, op);
> -}
> -
>  int security_quotactl(int cmds, int type, int id, struct super_block *sb)
>  {
>  	return security_ops->quotactl(cmds, type, id, sb);
> -- 
> 1.7.4.rc1.7.g2cf08.dirty

-- 
Stephen Smalley
National Security Agency

