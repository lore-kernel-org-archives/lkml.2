Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0FGSLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab0FGSLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:11:07 -0400
Date: Mon, 7 Jun 2010 20:08:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
Message-ID: <20100607180855.GA6689@redhat.com>
References: <20100513155621.51ca77a4.akpm@linux-foundation.org> <1275855783-27316-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275855783-27316-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add selinux maintainers)

First of all, my apologies for the huge delay. And I still didn't
read the whole series, sorry.

On 06/06, Jiri Slaby wrote:
>
> +static int check_security_task_setrlimit_unlocked(struct task_struct *tsk,
> +		unsigned int resource, struct rlimit *new_rlim,
> +		struct rlimit *old_rlim)
> +{
> +	struct rlimit rlim;
> +	int ret;
> +
> +	memcpy(&rlim, old_rlim, sizeof(rlim));
> +
> +	task_unlock(tsk->group_leader);
> +	ret = security_task_setrlimit(tsk, resource, new_rlim);
> +	task_lock(tsk->group_leader);
> +
> +	if (!ret && memcmp(&rlim, old_rlim, sizeof(rlim)))
> +		return -EAGAIN;
> +	return ret;
> +}
> +
>  /* make sure you are allowed to change @tsk limits before calling this */
>  int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  		struct rlimit *new_rlim, struct rlimit *old_rlim)
>  {
>  	struct rlimit *rlim;
> -	int retval = 0;
> +	int retval;
>  
>  	if (resource >= RLIM_NLIMITS)
>  		return -EINVAL;
> @@ -1339,13 +1364,19 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  
>  	rlim = tsk->signal->rlim + resource;
>  	task_lock(tsk->group_leader);
> +again:
> +	retval = 0;
>  	if (new_rlim) {
>  		if ((new_rlim->rlim_max > rlim->rlim_max) &&
>  					!capable(CAP_SYS_RESOURCE))
>  			retval = -EPERM;
> -		if (!retval)
> -			retval = security_task_setrlimit(tsk, resource,
> -					new_rlim);
> +		if (!retval) {
> +			retval = check_security_task_setrlimit_unlocked(tsk,
> +					resource, new_rlim, rlim);
> +			if (retval == -EAGAIN) {
> +				goto again;
> +			}
> +		}

Oh. Can't we just ignore this (imho minor) race ? Or just verify/document that
current_has_perm() can be called under task_lock. Actually, I do not think
we have a race, selinux_task_setrlimit() only checks that the caller has
rights to change the rlimits.

And. Given that avc_has_perm() can be called from irq context (say,
selinux_file_send_sigiotask or selinux_task_kill), we can assume it is safe
to call it under task_lock() which is not irq-safe.

But. OTOH, if we are really worried about security_ ops, then we have another
reason to call this hook under task_lock(), and we probably want to modify
selinux_bprm_committing_creds() to take this lock too:

	--- security/selinux/hooks.c
	+++ security/selinux/hooks.c
	@@ -2333,11 +2333,14 @@ static void selinux_bprm_committing_cred
		rc = avc_has_perm(new_tsec->osid, new_tsec->sid, SECCLASS_PROCESS,
				  PROCESS__RLIMITINH, NULL);
		if (rc) {
	+		/* protects against do_prlimit() */
	+		task_lock(current);
			for (i = 0; i < RLIM_NLIMITS; i++) {
				rlim = current->signal->rlim + i;
				initrlim = init_task.signal->rlim + i;
				rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
			}
	+		task_unlock(current);
			update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
		}
	 }

Finally. selinux_task_setrlimit(p) uses __task_cred(p) for the check.
This looks a bit strange, different threads can have different creds
but obviously rlimits are per-process.

Perhaps it makes sense to do selinux_task_setrlimit(p->group_leader)?
At least in this case the result should be "consistent".

Oleg.

