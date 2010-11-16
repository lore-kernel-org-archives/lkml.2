Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab0KPL7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:59:04 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:28118 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933802Ab0KPL7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:59:00 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: w9P.HuAVM1mzfmTHiHrjghG4VozF6KoSojtox3cK9l_NB02
 lNbF1AuKVfDYcT9HrzhnRbTjYQm_gI0tZ5MFL3I26FGcuogMwjH7wNHyjO6.
 WMgKRKTIk8Tw8JrUQqIlGwYSbeyDgjRP3pXKw8AEg6EIb2Wywl6.Ldz9O5nq
 rqe9PQzGjq1Xwu93YRBvQ7EExaFluVV.3ZzttE_fclhx6NfYG_sLlVeuYpKR
 le5POz0QbLStgMDHubJ.vVKwjzRhzjRpyfP3T04LmAtPgE8oyHRLteeHb0oq
 rP3O.UpOEhLBaKf5EXMkKLtDvVddgRdHFyruv2zrwWn1wClzjJ8AGVZoB5cK
 QpZlUYcidIHUahKc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CE271FC.4080307@schaufler-ca.com>
Date: Tue, 16 Nov 2010 03:58:52 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        torvalds@linux-foundation.org, joe@perches.com,
        drosenberg@vsecurity.com, mingo@elte.hu, eugeneteo@kernel.org,
        kees.cook@canonical.com, akpm@linux-foundation.org, jmorris@namei.org,
        morgan@kernel.org, serge@hallyn.com
Subject: Re: [PATCH] capabilities/syslog: open code cap_syslog logic to fix
 build	failure
References: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 3:36 PM, Eric Paris wrote:
> The addition of CONFIG_SECURITY_DMESG_RESTRICT resulted in a build failure
> when CONFIG_PRINTK=n.  This is because the capabilities code which used the
> new option was built even though the variable in question didn't exist.  The
> patch here fixes this by moving the capabilities checks out of the LSM and
> into the caller.  All (known) LSMs should have been calling the capabilities
> hook already so it actually makes the code organization better to eliminate
> the hook altogether.
>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: James Morris <jmorris@namei.org>
> ---
>
>  include/linux/security.h   |    9 ++++-----
>  kernel/printk.c            |   15 ++++++++++++++-
>  security/capability.c      |    5 +++++
>  security/commoncap.c       |   21 ---------------------
>  security/security.c        |    4 ++--
>  security/selinux/hooks.c   |    6 +-----
>  security/smack/smack_lsm.c |    8 ++------
>  7 files changed, 28 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index aee3b8f..d42619e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -77,7 +77,6 @@ extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  extern int cap_task_setscheduler(struct task_struct *p);
>  extern int cap_task_setioprio(struct task_struct *p, int ioprio);
>  extern int cap_task_setnice(struct task_struct *p, int nice);
> -extern int cap_syslog(int type, bool from_file);
>  extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
>  
>  struct msghdr;
> @@ -1389,7 +1388,7 @@ struct security_operations {
>  	int (*sysctl) (struct ctl_table *table, int op);
>  	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
>  	int (*quota_on) (struct dentry *dentry);
> -	int (*syslog) (int type, bool from_file);
> +	int (*syslog) (int type);
>  	int (*settime) (struct timespec *ts, struct timezone *tz);
>  	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
>  
> @@ -1675,7 +1674,7 @@ int security_real_capable_noaudit(struct task_struct *tsk, int cap);
>  int security_sysctl(struct ctl_table *table, int op);
>  int security_quotactl(int cmds, int type, int id, struct super_block *sb);
>  int security_quota_on(struct dentry *dentry);
> -int security_syslog(int type, bool from_file);
> +int security_syslog(int type);
>  int security_settime(struct timespec *ts, struct timezone *tz);
>  int security_vm_enough_memory(long pages);
>  int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
> @@ -1907,9 +1906,9 @@ static inline int security_quota_on(struct dentry *dentry)
>  	return 0;
>  }
>  
> -static inline int security_syslog(int type, bool from_file)
> +static inline int security_syslog(int type)
>  {
> -	return cap_syslog(type, from_file);
> +	return 0;
>  }
>  
>  static inline int security_settime(struct timespec *ts, struct timezone *tz)
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 38e7d58..9a2264f 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -274,7 +274,20 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  	char c;
>  	int error = 0;
>  
> -	error = security_syslog(type, from_file);
> +	/*
> +	 * If this is from /proc/kmsg we only do the capabilities checks
> +	 * at open time.
> +	 */
> +	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> +		if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		if ((type != SYSLOG_ACTION_READ_ALL &&
> +		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
> +		    !capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +	}
> +
> +	error = security_syslog(type);
>  	if (error)
>  		return error;
>  
> diff --git a/security/capability.c b/security/capability.c
> index d6d613a..778a28f 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -17,6 +17,11 @@ static int cap_sysctl(ctl_table *table, int op)
>  	return 0;
>  }
>  
> +static int cap_syslog(int type)
> +{
> +	return 0;
> +}
> +
>  static int cap_quotactl(int cmds, int type, int id, struct super_block *sb)
>  {
>  	return 0;
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 04b80f9..64c2ed9 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -27,7 +27,6 @@
>  #include <linux/sched.h>
>  #include <linux/prctl.h>
>  #include <linux/securebits.h>
> -#include <linux/syslog.h>
>  
>  /*
>   * If a non-root user executes a setuid-root binary in
> @@ -884,26 +883,6 @@ error:
>  }
>  
>  /**
> - * cap_syslog - Determine whether syslog function is permitted
> - * @type: Function requested
> - * @from_file: Whether this request came from an open file (i.e. /proc)
> - *
> - * Determine whether the current process is permitted to use a particular
> - * syslog function, returning 0 if permission is granted, -ve if not.
> - */
> -int cap_syslog(int type, bool from_file)
> -{
> -	if (type != SYSLOG_ACTION_OPEN && from_file)
> -		return 0;
> -	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -	if ((type != SYSLOG_ACTION_READ_ALL &&
> -	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -	return 0;
> -}
> -
> -/**
>   * cap_vm_enough_memory - Determine whether a new virtual mapping is permitted
>   * @mm: The VM space in which the new mapping is to be made
>   * @pages: The size of the mapping
> diff --git a/security/security.c b/security/security.c
> index 259d3ad..639a72a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -197,9 +197,9 @@ int security_quota_on(struct dentry *dentry)
>  	return security_ops->quota_on(dentry);
>  }
>  
> -int security_syslog(int type, bool from_file)
> +int security_syslog(int type)
>  {
> -	return security_ops->syslog(type, from_file);
> +	return security_ops->syslog(type);
>  }
>  
>  int security_settime(struct timespec *ts, struct timezone *tz)
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 8ba5001..e066bc2 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1971,14 +1971,10 @@ static int selinux_quota_on(struct dentry *dentry)
>  	return dentry_has_perm(cred, NULL, dentry, FILE__QUOTAON);
>  }
>  
> -static int selinux_syslog(int type, bool from_file)
> +static int selinux_syslog(int type)
>  {
>  	int rc;
>  
> -	rc = cap_syslog(type, from_file);
> -	if (rc)
> -		return rc;
> -
>  	switch (type) {
>  	case SYSLOG_ACTION_READ_ALL:	/* Read last kernel messages */
>  	case SYSLOG_ACTION_SIZE_BUFFER:	/* Return size of the log buffer */
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 6cc47ef..f7b8bee 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -157,15 +157,11 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
>   *
>   * Returns 0 on success, error code otherwise.
>   */
> -static int smack_syslog(int type, bool from_file)
> +static int smack_syslog(int typefrom_file)
>  {
> -	int rc;
> +	int rc = 0;
>  	char *sp = current_security();
>  
> -	rc = cap_syslog(type, from_file);
> -	if (rc != 0)
> -		return rc;
> -
>  	if (capable(CAP_MAC_OVERRIDE))
>  		return 0;

I haven't tried the patch, but I don't see any problem with it.
I am withholding ACK only because I haven't actually tried it, and I
would not suggest that the patch be held up on my account.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

