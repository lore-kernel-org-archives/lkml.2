Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1JSUDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:03:14 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55543 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab1JSUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:03:11 -0400
X-Sasl-enc: GGWHaKdvKJbHmg9xdA2N5SjCn1rLeKh5Ei6DYJX4xHAC 1319054590
Date: Wed, 19 Oct 2011 13:01:24 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Simon Kirby <sim@hostway.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Patch Upstream: cputimer: Cure lock inversion
Message-ID: <20111019200124.GA16108@kroah.com>
References: <20111019153914.9153A2188@git.kroah.org>
 <20111019154910.GA9361@kroah.com>
 <alpine.LFD.2.02.1110192140270.3197@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110192140270.3197@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 09:41:52PM +0200, Thomas Gleixner wrote:
> On Wed, 19 Oct 2011, Greg KH wrote:
> 
> > On Wed, Oct 19, 2011 at 11:39:14AM -0400, Gregs git-bot wrote:
> > > commit: bcd5cff7216f9b2de0a148cc355eac199dc6f1cf
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date: Mon, 17 Oct 2011 11:50:30 +0200
> > > Subject: cputimer: Cure lock inversion
> > > 
> > > There's a lock inversion between the cputimer->lock and rq->lock;
> > > notably the two callchains involved are:
> > > 
> > >  update_rlimit_cpu()
> > >    sighand->siglock
> > >    set_process_cpu_timer()
> > >      cpu_timer_sample_group()
> > >        thread_group_cputimer()
> > >          cputimer->lock
> > >          thread_group_cputime()
> > >            task_sched_runtime()
> > >              ->pi_lock
> > >              rq->lock
> > > 
> > >  scheduler_tick()
> > >    rq->lock
> > >    task_tick_fair()
> > >      update_curr()
> > >        account_group_exec()
> > >          cputimer->lock
> > > 
> > > Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and
> > > the second one is keeping up-to-date.
> > > 
> > > This problem was introduced by e8abccb7193 ("posix-cpu-timers: Cure
> > > SMP accounting oddities").
> > 
> > There is no such patch in Linus's tree that I can find.  So, what
> > problem is this really trying to cure here and what kernel did it show
> > up in?
> 
> Oops. It's in 3.0.7
> 
> commit 249cf808ba1a0d403fe7c476a74b66e2bc0a8e53
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Sep 1 12:42:04 2011 +0200
> 
>     posix-cpu-timers: Cure SMP wobbles
>     
>     commit d670ec13178d0fd8680e6742a2bc6e04f28f87d8 upstream.
> 
> and that patch introduced the above deadlock, which is cured by:
> 
> commit bcd5cff7216f9b2de0a148cc355eac199dc6f1cf
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Oct 17 11:50:30 2011 +0200
> 
>     cputimer: Cure lock inversion

Thanks for the explanation.  I should have it all straightened out now.

greg k-h
