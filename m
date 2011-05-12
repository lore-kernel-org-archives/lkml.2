Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab1ELVz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:55:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968Ab1ELVzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:55:55 -0400
Date: Thu, 12 May 2011 23:55:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely callable
 from scheduler
Message-ID: <20110512215544.GC20939@elte.hu>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
 <20110512212810.GA17596@elte.hu>
 <20110512214336.GE7410@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512214336.GE7410@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, May 12, 2011 at 11:28:10PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Avoid potential scheduler recursion and deadlock from the
> > > stacktrace code by avoiding rescheduling when we re-enable
> > > preemption.
> > > 
> > > This robustifies some scheduler trace events like sched switch
> > > when they are used to produce callchains in perf or ftrace.
> > 
> > > -	put_cpu();
> > > +
> > > +	/* We want stacktrace to be computable anywhere, even in the scheduler */
> > > +	preempt_enable_no_resched();
> > 
> > So what happens if a callchain profiling happens to be interrupted by a hardirq 
> > and the interrupt reschedules the current task? We'll miss the reschedule, 
> > right?
> > 
> > preempt_enable_no_resched() is not a magic 'solve scheduler recursions' bullet 
> > - it's to be used only if something else will guarantee the preemption check! 
> > But nothing guarantees it here AFAICS.
> > 
> > A better fix would be to use local_irq_save()/restore().
> 
> Good point, but then lockdep itself might trigger a stacktrace from local_irq_save,
> leading to a stacktrace recursion.
> 
> I can use raw_local_irq_disable(), or may be have a stacktrace recursion 
> protection. I fear the second solution could lead us to potentially lose 
> useful information if a stacktrace interrupts another one. Ok these are 
> extreme cases...

i think raw_local_irq_disable() would be justified in this case.

Thanks,

	Ingo
