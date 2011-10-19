Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1JSTmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 15:42:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:38683 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1JSTmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 15:42:02 -0400
Date: Wed, 19 Oct 2011 21:41:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: Dave Jones <davej@redhat.com>, Simon Kirby <sim@hostway.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Patch Upstream: cputimer: Cure lock inversion
In-Reply-To: <20111019154910.GA9361@kroah.com>
Message-ID: <alpine.LFD.2.02.1110192140270.3197@ionos>
References: <20111019153914.9153A2188@git.kroah.org> <20111019154910.GA9361@kroah.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Greg KH wrote:

> On Wed, Oct 19, 2011 at 11:39:14AM -0400, Gregs git-bot wrote:
> > commit: bcd5cff7216f9b2de0a148cc355eac199dc6f1cf
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Mon, 17 Oct 2011 11:50:30 +0200
> > Subject: cputimer: Cure lock inversion
> > 
> > There's a lock inversion between the cputimer->lock and rq->lock;
> > notably the two callchains involved are:
> > 
> >  update_rlimit_cpu()
> >    sighand->siglock
> >    set_process_cpu_timer()
> >      cpu_timer_sample_group()
> >        thread_group_cputimer()
> >          cputimer->lock
> >          thread_group_cputime()
> >            task_sched_runtime()
> >              ->pi_lock
> >              rq->lock
> > 
> >  scheduler_tick()
> >    rq->lock
> >    task_tick_fair()
> >      update_curr()
> >        account_group_exec()
> >          cputimer->lock
> > 
> > Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and
> > the second one is keeping up-to-date.
> > 
> > This problem was introduced by e8abccb7193 ("posix-cpu-timers: Cure
> > SMP accounting oddities").
> 
> There is no such patch in Linus's tree that I can find.  So, what
> problem is this really trying to cure here and what kernel did it show
> up in?

Oops. It's in 3.0.7

commit 249cf808ba1a0d403fe7c476a74b66e2bc0a8e53
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Sep 1 12:42:04 2011 +0200

    posix-cpu-timers: Cure SMP wobbles
    
    commit d670ec13178d0fd8680e6742a2bc6e04f28f87d8 upstream.

and that patch introduced the above deadlock, which is cured by:

commit bcd5cff7216f9b2de0a148cc355eac199dc6f1cf
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Oct 17 11:50:30 2011 +0200

    cputimer: Cure lock inversion

Thanks,

	tglx
