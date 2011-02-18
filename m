Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1BRB5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:57:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48608 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1BRB5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:57:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150342.GF26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 17:57:15 -0800
In-Reply-To: <20110217150342.GF26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:03:42 +0000")
Message-ID: <m1r5b6ayv8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ME1R6Hdj55YbpKwRiXoJ3Iu5xeH1zgtM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 6/9] user namespaces: convert all capable checks in kernel/sys.c
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> This allows setuid/setgid in containers.  It also fixes some
> corner cases where kernel logic foregoes capability checks when
> uids are equivalent.  The latter will need to be done throughout
> the whole kernel.

Except for the extra printk in sethostname this looks good.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Changelog:
> 	Jan 11: Use nsown_capable() as suggested by Bastian Blank.
> 	Jan 11: Fix logic errors in uid checks pointed out by Bastian.
> 	Feb 15: allow prlimit to current (was regression in previous version)
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/sys.c |   74 ++++++++++++++++++++++++++++++++++++---------------------
>  1 files changed, 47 insertions(+), 27 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 7a1bbad..075370d 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -118,17 +118,29 @@ EXPORT_SYMBOL(cad_pid);
>  
>  void (*pm_power_off_prepare)(void);
>  
> +/* called with rcu_read_lock, creds are safe */
> +static inline int set_one_prio_perm(struct task_struct *p)
> +{
> +	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
> +
> +	if (pcred->user->user_ns == cred->user->user_ns &&
> +	    (pcred->uid  == cred->euid ||
> +	     pcred->euid == cred->euid))
> +		return 1;
> +	if (ns_capable(pcred->user->user_ns, CAP_SYS_NICE))
> +		return 1;
> +	return 0;
> +}
> +
>  /*
>   * set the priority of a task
>   * - the caller must hold the RCU read lock
>   */
>  static int set_one_prio(struct task_struct *p, int niceval, int error)
>  {
> -	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
>  	int no_nice;
>  
> -	if (pcred->uid  != cred->euid &&
> -	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
> +	if (!set_one_prio_perm(p)) {
>  		error = -EPERM;
>  		goto out;
>  	}
> @@ -502,7 +514,7 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
>  	if (rgid != (gid_t) -1) {
>  		if (old->gid == rgid ||
>  		    old->egid == rgid ||
> -		    capable(CAP_SETGID))
> +		    nsown_capable(CAP_SETGID))
>  			new->gid = rgid;
>  		else
>  			goto error;
> @@ -511,7 +523,7 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
>  		if (old->gid == egid ||
>  		    old->egid == egid ||
>  		    old->sgid == egid ||
> -		    capable(CAP_SETGID))
> +		    nsown_capable(CAP_SETGID))
>  			new->egid = egid;
>  		else
>  			goto error;
> @@ -546,7 +558,7 @@ SYSCALL_DEFINE1(setgid, gid_t, gid)
>  	old = current_cred();
>  
>  	retval = -EPERM;
> -	if (capable(CAP_SETGID))
> +	if (nsown_capable(CAP_SETGID))
>  		new->gid = new->egid = new->sgid = new->fsgid = gid;
>  	else if (gid == old->gid || gid == old->sgid)
>  		new->egid = new->fsgid = gid;
> @@ -613,7 +625,7 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
>  		new->uid = ruid;
>  		if (old->uid != ruid &&
>  		    old->euid != ruid &&
> -		    !capable(CAP_SETUID))
> +		    !nsown_capable(CAP_SETUID))
>  			goto error;
>  	}
>  
> @@ -622,7 +634,7 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
>  		if (old->uid != euid &&
>  		    old->euid != euid &&
>  		    old->suid != euid &&
> -		    !capable(CAP_SETUID))
> +		    !nsown_capable(CAP_SETUID))
>  			goto error;
>  	}
>  
> @@ -670,7 +682,7 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
>  	old = current_cred();
>  
>  	retval = -EPERM;
> -	if (capable(CAP_SETUID)) {
> +	if (nsown_capable(CAP_SETUID)) {
>  		new->suid = new->uid = uid;
>  		if (uid != old->uid) {
>  			retval = set_user(new);
> @@ -712,7 +724,7 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
>  	old = current_cred();
>  
>  	retval = -EPERM;
> -	if (!capable(CAP_SETUID)) {
> +	if (!nsown_capable(CAP_SETUID)) {
>  		if (ruid != (uid_t) -1 && ruid != old->uid &&
>  		    ruid != old->euid  && ruid != old->suid)
>  			goto error;
> @@ -776,7 +788,7 @@ SYSCALL_DEFINE3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
>  	old = current_cred();
>  
>  	retval = -EPERM;
> -	if (!capable(CAP_SETGID)) {
> +	if (!nsown_capable(CAP_SETGID)) {
>  		if (rgid != (gid_t) -1 && rgid != old->gid &&
>  		    rgid != old->egid  && rgid != old->sgid)
>  			goto error;
> @@ -836,7 +848,7 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
>  
>  	if (uid == old->uid  || uid == old->euid  ||
>  	    uid == old->suid || uid == old->fsuid ||
> -	    capable(CAP_SETUID)) {
> +	    nsown_capable(CAP_SETUID)) {
>  		if (uid != old_fsuid) {
>  			new->fsuid = uid;
>  			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
> @@ -869,7 +881,7 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
>  
>  	if (gid == old->gid  || gid == old->egid  ||
>  	    gid == old->sgid || gid == old->fsgid ||
> -	    capable(CAP_SETGID)) {
> +	    nsown_capable(CAP_SETGID)) {
>  		if (gid != old_fsgid) {
>  			new->fsgid = gid;
>  			goto change_okay;
> @@ -1177,8 +1189,11 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
>  	int errno;
>  	char tmp[__NEW_UTS_LEN];
>  
> -	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
> +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN)) {
> +		printk(KERN_NOTICE "%s: did not have CAP_SYS_ADMIN\n", __func__);
>  		return -EPERM;
> +	}
> +	printk(KERN_NOTICE "%s: did have CAP_SYS_ADMIN\n", __func__);

Ouch!  This new print statement could be really annoying if an
unprivileged user calls sethostname.  Could you remove it?

>  	if (len < 0 || len > __NEW_UTS_LEN)
>  		return -EINVAL;
>  	down_write(&uts_sem);
> @@ -1226,7 +1241,7 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
>  	int errno;
>  	char tmp[__NEW_UTS_LEN];
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
>  		return -EPERM;
>  	if (len < 0 || len > __NEW_UTS_LEN)
>  		return -EINVAL;
> @@ -1341,6 +1356,8 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  	rlim = tsk->signal->rlim + resource;
>  	task_lock(tsk->group_leader);
>  	if (new_rlim) {
> +		/* Keep the capable check against init_user_ns until
> +		   cgroups can contain all limits */
>  		if (new_rlim->rlim_max > rlim->rlim_max &&
>  				!capable(CAP_SYS_RESOURCE))
>  			retval = -EPERM;
> @@ -1384,19 +1401,22 @@ static int check_prlimit_permission(struct task_struct *task)
>  {
>  	const struct cred *cred = current_cred(), *tcred;
>  
> -	tcred = __task_cred(task);
> -	if (current != task &&
> -	    (cred->uid != tcred->euid ||
> -	     cred->uid != tcred->suid ||
> -	     cred->uid != tcred->uid  ||
> -	     cred->gid != tcred->egid ||
> -	     cred->gid != tcred->sgid ||
> -	     cred->gid != tcred->gid) &&
> -	     !capable(CAP_SYS_RESOURCE)) {
> -		return -EPERM;
> -	}
> +	if (current == task)
> +		return 0;
>  
> -	return 0;
> +	tcred = __task_cred(task);
> +	if (cred->user->user_ns == tcred->user->user_ns &&
> +	    (cred->uid == tcred->euid &&
> +	     cred->uid == tcred->suid &&
> +	     cred->uid == tcred->uid  &&
> +	     cred->gid == tcred->egid &&
> +	     cred->gid == tcred->sgid &&
> +	     cred->gid == tcred->gid))
> +		return 0;
> +	if (ns_capable(tcred->user->user_ns, CAP_SYS_RESOURCE))
> +		return 0;
> +
> +	return -EPERM;
>  }
>  
>  SYSCALL_DEFINE4(prlimit64, pid_t, pid, unsigned int, resource,
