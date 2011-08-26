Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HZR3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:29:19 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:54364 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1HZR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:29:15 -0400
Date: Fri, 26 Aug 2011 13:01:14 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        bblum@andrew.cmu.edu, lizf@cn.fujitsu.com, oleg@redhat.com,
        paul@paulmenage.org, tj@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cgroups: Don't attach task to subsystem if
 migration failed
Message-ID: <20110826170114.GA14508@unix33.andrew.cmu.edu>
References: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
 <20110826153843.GE3298@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826153843.GE3298@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __FRAUD_BODY_WEBMAIL 0, __FRAUD_INTRO 0, __FRAUD_WEBMAIL 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 05:38:44PM +0200, Frederic Weisbecker wrote:
> On Thu, Aug 25, 2011 at 01:44:36PM -0700, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      cgroups: fix ordering of calls in cgroup_attach_proc
> > has been added to the -mm tree.  Its filename is
> >      cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > 
> > ------------------------------------------------------
> > Subject: cgroups: fix ordering of calls in cgroup_attach_proc
> > From: Ben Blum <bblum@andrew.cmu.edu>
> > 
> > awaiting useful changelog...
> > 
> 
> Here is the patch with a (trial of a) useful changelog. Subject
> has been changed as well:

This description is much better than my original one - thanks!

I'd ack it, but my name is already there. :P

-- Ben

> 
> ---
> From a9b84e395a0355cd1aa5ee0f525cd682b16dad63 Mon Sep 17 00:00:00 2001
> From: Ben Blum <bblum@andrew.cmu.edu>
> Date: Thu, 25 Aug 2011 13:44:36 -0700
> Subject: [PATCH] cgroups: Don't attach task to subsystem if migration failed
> 
> If a task has exited to the point it has called cgroup_exit()
> already, then we can't migrate it to another cgroup anymore.
> 
> This can happen when we are attaching a task to a new cgroup
> between the call to ->can_attach_task() on subsystems and
> the migration that is eventually tried in cgroup_task_migrate().
> 
> In this case cgroup_task_migrate() returns -ESRCH and we don't
> want to attach the task to the subsystems because the attachment
> to the new cgroup itself failed.
> 
> Fix this by only calling ->attach_task() on the subsystems if
> the cgroup migration succeeded.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/cgroup.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1d2b6ce..84bdace 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2135,14 +2135,17 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  		oldcgrp = task_cgroup_from_root(tsk, root);
>  		if (cgrp == oldcgrp)
>  			continue;
> -		/* attach each task to each subsystem */
> -		for_each_subsys(root, ss) {
> -			if (ss->attach_task)
> -				ss->attach_task(cgrp, tsk);
> -		}
>  		/* if the thread is PF_EXITING, it can just get skipped. */
>  		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
> -		BUG_ON(retval != 0 && retval != -ESRCH);
> +		if (retval == 0) {
> +			/* attach each task to each subsystem */
> +			for_each_subsys(root, ss) {
> +				if (ss->attach_task)
> +					ss->attach_task(cgrp, tsk);
> +			}
> +		} else {
> +			BUG_ON(retval != -ESRCH);
> +		}
>  	}
>  	/* nothing is sensitive to fork() after this point. */
>  
> -- 
> 1.7.5.4
> 
> 
> 
