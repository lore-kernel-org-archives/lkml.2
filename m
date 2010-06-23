Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0FWQOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:14:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab0FWQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:14:48 -0400
Date: Wed, 23 Jun 2010 18:12:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
Message-ID: <20100623161254.GA10098@redhat.com>
References: <20100513155621.51ca77a4.akpm@linux-foundation.org> <1275855783-27316-1-git-send-email-jslaby@suse.cz> <20100607180855.GA6689@redhat.com> <4C222644.4040601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C222644.4040601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Jiri Slaby wrote:
>
> On 06/07/2010 08:08 PM, Oleg Nesterov wrote:
> > First of all, my apologies for the huge delay. And I still didn't
> > read the whole series, sorry.
>
> Hi, never mind, my RTT of 2 weeks doesn't look like very short too :).
>
> > On 06/06, Jiri Slaby wrote:
> >> @@ -1339,13 +1364,19 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
> >>
> >>  	rlim = tsk->signal->rlim + resource;
> >>  	task_lock(tsk->group_leader);
> >> +again:
> >> +	retval = 0;
> >>  	if (new_rlim) {
> >>  		if ((new_rlim->rlim_max > rlim->rlim_max) &&
> >>  					!capable(CAP_SYS_RESOURCE))
>
> BTW this capable() has the exactly same problem with being called with
> task_lock held. Is it OK to move it completely out of critical section?
> I'm asking because it sets a current->flags SU bit used for accounting.
> If I move it out of the section, it will set the bit always.

Well, with all these delays I do not know what "exactly same problem"
means ;) Please explain?

> >>  			retval = -EPERM;
> >> -		if (!retval)
> >> -			retval = security_task_setrlimit(tsk, resource,
> >> -					new_rlim);
> >> +		if (!retval) {
> >> +			retval = check_security_task_setrlimit_unlocked(tsk,
> >> +					resource, new_rlim, rlim);
> >> +			if (retval == -EAGAIN) {
> >> +				goto again;
> >> +			}
> >> +		}
> >
> > Oh. Can't we just ignore this (imho minor) race ? Or just verify/document that
> > current_has_perm() can be called under task_lock. Actually, I do not think
> > we have a race, selinux_task_setrlimit() only checks that the caller has
> > rights to change the rlimits.
>
> But does so only if current limits are different to the new ones. My
> opinion is that we can ignore it anyway.

Or call it under task_lock(), see below

> > And. Given that avc_has_perm() can be called from irq context (say,
> > selinux_file_send_sigiotask or selinux_task_kill), we can assume it is safe
> > to call it under task_lock() which is not irq-safe.
> >
> > But. OTOH, if we are really worried about security_ ops, then we have another
> > reason to call this hook under task_lock(), and we probably want to modify
> > selinux_bprm_committing_creds() to take this lock too:
> >
> > 	--- security/selinux/hooks.c
> > 	+++ security/selinux/hooks.c
> > 	@@ -2333,11 +2333,14 @@ static void selinux_bprm_committing_cred
> > 		rc = avc_has_perm(new_tsec->osid, new_tsec->sid, SECCLASS_PROCESS,
> > 				  PROCESS__RLIMITINH, NULL);
> > 		if (rc) {
> > 	+		/* protects against do_prlimit() */
> > 	+		task_lock(current);
> > 			for (i = 0; i < RLIM_NLIMITS; i++) {
> > 				rlim = current->signal->rlim + i;
> > 				initrlim = init_task.signal->rlim + i;
> > 				rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
> > 			}
> > 	+		task_unlock(current);
> > 			update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
> > 		}
> > 	 }
>
> Makes sense to me.

see above ;)

> > Finally. selinux_task_setrlimit(p) uses __task_cred(p) for the check.
> > This looks a bit strange, different threads can have different creds
> > but obviously rlimits are per-process.
>
> Sorry I can't see it. Could you point out in which function this is done?

selinux_task_setrlimit()->current_has_perm()->current_sid()->current_cred()

Oleg.

