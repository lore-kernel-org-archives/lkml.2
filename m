Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937671Ab0CPNFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:05:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49485 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932211Ab0CPNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:05:45 -0400
Date: Tue, 16 Mar 2010 09:05:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
	barrier (v9)
Message-ID: <20100316130542.GA22259@Krystal>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu> <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain> <20100304175659.GA3255@Krystal> <20100315205312.GA31231@Krystal> <20100316073635.GC18448@elte.hu> <20100316075709.GL2869@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316075709.GL2869@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:59:01 up 52 days, 15:36,  5 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (npiggin@suse.de) wrote:
> On Tue, Mar 16, 2010 at 08:36:35AM +0100, Ingo Molnar wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > > * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > > > > >  - SA_RUNNING: a way to signal only running threads - as a way for user-space 
> > > > > >    based concurrency control mechanisms to deschedule running threads (or, like
> > > > > >    in your case, to implement barrier / garbage collection schemes).
> > > > > 
> > > > > Hmm. This sounds less fundamentally broken, but at the same time also 
> > > > > _way_ more invasive in the signal handling layer. It's already one of our 
> > > > > more "exciting" layers out there.
> > > > > 
> > > > 
> > > > Hrm, thinking about it a bit further, the only way I see we could provide a
> > > > usable SA_RUNNING flag would be to add hooks to the scheduler. These hooks would
> > > > somehow have to call user-space code (!) when scheduling in/out a thread. Yes,
> > > > this sounds utterly broken (since these hooks would have to be preemptable).
> > > > 
> > > > The idea is this: if we look, for instance, at the kernel preemptable RCU
> > > > implementations, they consist of two parts: one is iteration on all CPUs to
> > > > consider all active CPUs, and the other is a modification of the scheduler to
> > > > note all preempted tasks that were in a preemptable RCU C.S..
> > > > 
> > > > Just for the memory barrier we consider for sys_membarrier(), I had to ensure
> > > > that the scheduler issues memory barriers to order accesses to user-space memory
> > > > and mm_cpumask modifications. In reality, what we are doing is to ensure that
> > > > the operation required on the running thread is done by the scheduler too when
> > > > scheduling in/out the task.
> > > > 
> > > > As soon as we have signal handlers which perform more than a simple memory 
> > > > barrier (e.g. something that has side-effects outside of the processor), I 
> > > > doubt it would ever make sense to only run the handler on running threads 
> > > > unless we have hooks in the scheduler too.
> > > 
> > > Unless this question is answered, Ingo's SA_RUNNING signal proposal, as 
> > > appealing as it may look at a first glance, falls into the "fundamentally 
> > > broken" category. [...]
> > 
> > How is it different from your syscall? I.e. which lines of code make the 
> > difference? We could certainly apply the (trivial) barrier change to 
> > context_switch().
> 
> I think it is just easy for userspace to misuse or think it does
> something that it doesn't (because of races).
> 

Yep, this is exactly my point.

> If a context switch includes a barrier, then it is easy to know that
> either the task of interest will execute the barrier, or it will have
> context switched.
> 
> What more complex operation could be done in the signal handler that
> isn't broken by races? Programs that use realtime scheduling policies,
> and maybe some statistical or heuristic operations... Any cool use that
> would make anybody other than librcu bother using it?
> 

Yes, there seems to be no point in providing a nice flexible interface through
signals if the only race-less use we can find is to issue memory barriers
(which would be race-less because we add the proper barriers to the scheduler mm
switch code). And even if we find a userland use for such a signal, I tend to
think that the inherent risk of misuse and races would overweight its benefit.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
