Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2IZRzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:55:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab2IZRzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:55:40 -0400
Date: Wed, 26 Sep 2012 12:55:34 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] userns: On ia64 deal with current_uid and
 current_gid being kuid and kgid
Message-ID: <20120926175534.GD30620@sergelap>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-13-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348187330-6616-13-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> These ia64 uses of current_uid and current_gid slipped through the
> cracks when I was converting everything to kuids and kgids convert
> them now.
> 
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  arch/ia64/kernel/mca_drv.c |    3 ++-
>  arch/ia64/kernel/perfmon.c |   32 ++++++++++++++++----------------
>  arch/ia64/kernel/signal.c  |    4 ++--
>  3 files changed, 20 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
> index 1c2e894..9392e02 100644
> --- a/arch/ia64/kernel/mca_drv.c
> +++ b/arch/ia64/kernel/mca_drv.c
> @@ -158,7 +158,8 @@ mca_handler_bh(unsigned long paddr, void *iip, unsigned long ipsr)
>  	ia64_mlogbuf_dump();
>  	printk(KERN_ERR "OS_MCA: process [cpu %d, pid: %d, uid: %d, "
>  		"iip: %p, psr: 0x%lx,paddr: 0x%lx](%s) encounters MCA.\n",
> -	       raw_smp_processor_id(), current->pid, current_uid(),
> +	       raw_smp_processor_id(), current->pid,
> +		from_kuid(&init_user_ns, current_uid()),
>  		iip, ipsr, paddr, current->comm);
>  
>  	spin_lock(&mca_bh_lock);
> diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
> index 3fa4bc5..5a5c222 100644
> --- a/arch/ia64/kernel/perfmon.c
> +++ b/arch/ia64/kernel/perfmon.c
> @@ -2380,8 +2380,8 @@ static int
>  pfm_bad_permissions(struct task_struct *task)
>  {
>  	const struct cred *tcred;
> -	uid_t uid = current_uid();
> -	gid_t gid = current_gid();
> +	kuid_t uid = current_uid();
> +	kgid_t gid = current_gid();
>  	int ret;
>  
>  	rcu_read_lock();
> @@ -2389,20 +2389,20 @@ pfm_bad_permissions(struct task_struct *task)
>  
>  	/* inspired by ptrace_attach() */
>  	DPRINT(("cur: uid=%d gid=%d task: euid=%d suid=%d uid=%d egid=%d sgid=%d\n",
> -		uid,
> -		gid,
> -		tcred->euid,
> -		tcred->suid,
> -		tcred->uid,
> -		tcred->egid,
> -		tcred->sgid));
> -
> -	ret = ((uid != tcred->euid)
> -	       || (uid != tcred->suid)
> -	       || (uid != tcred->uid)
> -	       || (gid != tcred->egid)
> -	       || (gid != tcred->sgid)
> -	       || (gid != tcred->gid)) && !capable(CAP_SYS_PTRACE);
> +		from_kuid(&init_user_ns, uid),
> +		from_kgid(&init_user_ns, gid),
> +		from_kuid(&init_user_ns, tcred->euid),
> +		from_kuid(&init_user_ns, tcred->suid),
> +		from_kuid(&init_user_ns, tcred->uid),
> +		from_kgid(&init_user_ns, tcred->egid),
> +		from_kgid(&init_user_ns, tcred->sgid)));
> +
> +	ret = ((!uid_eq(uid, tcred->euid))
> +	       || (!uid_eq(uid, tcred->suid))
> +	       || (!uid_eq(uid, tcred->uid))
> +	       || (!gid_eq(gid, tcred->egid))
> +	       || (!gid_eq(gid, tcred->sgid))
> +	       || (!gid_eq(gid, tcred->gid))) && !capable(CAP_SYS_PTRACE);
>  
>  	rcu_read_unlock();
>  	return ret;
> diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
> index a199be1..37dd795 100644
> --- a/arch/ia64/kernel/signal.c
> +++ b/arch/ia64/kernel/signal.c
> @@ -220,7 +220,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
>  	si.si_errno = 0;
>  	si.si_code = SI_KERNEL;
>  	si.si_pid = task_pid_vnr(current);
> -	si.si_uid = current_uid();
> +	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
>  	si.si_addr = sc;
>  	force_sig_info(SIGSEGV, &si, current);
>  	return retval;
> @@ -317,7 +317,7 @@ force_sigsegv_info (int sig, void __user *addr)
>  	si.si_errno = 0;
>  	si.si_code = SI_KERNEL;
>  	si.si_pid = task_pid_vnr(current);
> -	si.si_uid = current_uid();
> +	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
>  	si.si_addr = addr;
>  	force_sig_info(SIGSEGV, &si, current);
>  	return 0;
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
