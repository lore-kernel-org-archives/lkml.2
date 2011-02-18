Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1BRBvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:51:36 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48078 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1BRBve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:51:34 -0500
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
	<20110217150356.GH26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 17:51:25 -0800
In-Reply-To: <20110217150356.GH26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:03:56 +0000")
Message-ID: <m14o82cdpe.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Hgb8ScycGSX1Tl6s40W4xePmX07VHyZY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 8/9] user namespaces: convert several capable() calls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> CAP_IPC_OWNER and CAP_IPC_LOCK can be checked against current_user_ns(),
> because the resource comes from current's own ipc namespace.
>
> setuid/setgid are to uids in own namespace, so again checks can be
> against current_user_ns().

Some nits below.  But this generally looks good if a little bit all over
the map for a single patch.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>


> Changelog:
> 	Jan 11: Use task_ns_capable() in place of sched_capable().
> 	Jan 11: Use nsown_capable() as suggested by Bastian Blank.
> 	Jan 11: Clarify (hopefully) some logic in futex and sched.c
> 	Feb 15: use ns_capable for ipc, not nsown_capable
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  ipc/shm.c             |    2 +-
>  ipc/util.c            |    5 +++--
>  kernel/futex.c        |   11 ++++++++++-
>  kernel/futex_compat.c |   11 ++++++++++-
>  kernel/groups.c       |    2 +-
>  kernel/sched.c        |    9 ++++++---
>  kernel/uid16.c        |    2 +-
>  7 files changed, 32 insertions(+), 10 deletions(-)
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7d3bb22..e91e2e9 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -773,7 +773,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
>  
>  		audit_ipc_obj(&(shp->shm_perm));
>  
> -		if (!capable(CAP_IPC_LOCK)) {
> +		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
>  			uid_t euid = current_euid();
>  			err = -EPERM;
>  			if (euid != shp->shm_perm.uid &&
> diff --git a/ipc/util.c b/ipc/util.c
> index 69a0cc1..8e7ec6a 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -627,7 +627,7 @@ int ipcperms (struct kern_ipc_perm *ipcp, short flag)
>  		granted_mode >>= 3;
>  	/* is there some bit set in requested_mode but not in granted_mode? */
>  	if ((requested_mode & ~granted_mode & 0007) && 
> -	    !capable(CAP_IPC_OWNER))
> +	    !ns_capable(current->nsproxy->ipc_ns->user_ns, CAP_IPC_OWNER))
>  		return -1;

Serge can we please modify the code to pass the ns down from
ipcget_public to ipcperms.  It is passed in and dropping the value and
going back to current to get it just feels wrong.

Strictly speaking this code is correct but it requires an audit of all
of the callers to know that, which is unfortunate.

>  	return security_ipc_permission(ipcp, flag);
> @@ -800,7 +800,8 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
>  
>  	euid = current_euid();
>  	if (euid == ipcp->cuid ||
> -	    euid == ipcp->uid  || capable(CAP_SYS_ADMIN))
> +	    euid == ipcp->uid  ||
> +	    ns_capable(current->nsproxy->ipc_ns->user_ns, CAP_SYS_ADMIN))
>  		return ipcp;

Like the other ipc call can we please pass the ipc_ns into ipcctl_pre_down.

The code as constructed appears correct but because we are passing the
namespace into the caller of this function always using current to get
the ipc_ns seems confusing and unnecessary.

>  	err = -EPERM;
> diff --git a/kernel/futex.c b/kernel/futex.c
> index b766d28..1e876f1 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2421,10 +2421,19 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>  			goto err_unlock;
>  		ret = -EPERM;
>  		pcred = __task_cred(p);
> +		/* If victim is in different user_ns, then uids are not
> +		   comparable, so we must have CAP_SYS_PTRACE */
> +		if (cred->user->user_ns != pcred->user->user_ns) {
> +			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
> +				goto err_unlock;
> +			goto ok;
> +		}
> +		/* If victim is in same user_ns, then uids are comparable */
>  		if (cred->euid != pcred->euid &&
>  		    cred->euid != pcred->uid &&
> -		    !capable(CAP_SYS_PTRACE))
> +		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
>  			goto err_unlock;
> +ok:
>  		head = p->robust_list;
>  		rcu_read_unlock();
>  	}
> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
> index a7934ac..5f9e689 100644
> --- a/kernel/futex_compat.c
> +++ b/kernel/futex_compat.c
> @@ -153,10 +153,19 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>  			goto err_unlock;
>  		ret = -EPERM;
>  		pcred = __task_cred(p);
> +		/* If victim is in different user_ns, then uids are not
> +		   comparable, so we must have CAP_SYS_PTRACE */
> +		if (cred->user->user_ns != pcred->user->user_ns) {
> +			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
> +				goto err_unlock;
> +			goto ok;
> +		}
> +		/* If victim is in same user_ns, then uids are comparable */
>  		if (cred->euid != pcred->euid &&
>  		    cred->euid != pcred->uid &&
> -		    !capable(CAP_SYS_PTRACE))
> +		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
>  			goto err_unlock;
> +ok:
>  		head = p->compat_robust_list;
>  		rcu_read_unlock();
>  	}
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 253dc0f..1cc476d 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -233,7 +233,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  	struct group_info *group_info;
>  	int retval;
>  
> -	if (!capable(CAP_SETGID))
> +	if (!nsown_capable(CAP_SETGID))
>  		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
>  		return -EINVAL;
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 18d38e4..dc12bc2 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4761,8 +4761,11 @@ static bool check_same_owner(struct task_struct *p)
>  
>  	rcu_read_lock();
>  	pcred = __task_cred(p);
> -	match = (cred->euid == pcred->euid ||
> -		 cred->euid == pcred->uid);
> +	if (cred->user->user_ns == pcred->user->user_ns)
> +		match = (cred->euid == pcred->euid ||
> +			 cred->euid == pcred->uid);
> +	else
> +		match = false;
>  	rcu_read_unlock();
>  	return match;
>  }
> @@ -5088,7 +5091,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>  		goto out_free_cpus_allowed;
>  	}
>  	retval = -EPERM;
> -	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
> +	if (!check_same_owner(p) && !task_ns_capable(p, CAP_SYS_NICE))
>  		goto out_unlock;
>  
>  	retval = security_task_setscheduler(p);
> diff --git a/kernel/uid16.c b/kernel/uid16.c
> index 4192098..51c6e89 100644
> --- a/kernel/uid16.c
> +++ b/kernel/uid16.c
> @@ -189,7 +189,7 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
>  	struct group_info *group_info;
>  	int retval;
>  
> -	if (!capable(CAP_SETGID))
> +	if (!nsown_capable(CAP_SETGID))
>  		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
>  		return -EINVAL;
