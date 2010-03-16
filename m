Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257Ab0CPN5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:57:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab0CPN5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:57:39 -0400
Date: Tue, 16 Mar 2010 14:56:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nick Piggin <npiggin@suse.de>,
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
Message-ID: <20100316135617.GC575@elte.hu>
References: <20100225232316.GA30196@Krystal>
 <20100304122304.GA6864@elte.hu>
 <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain>
 <20100304175659.GA3255@Krystal>
 <20100315205312.GA31231@Krystal>
 <20100316073635.GC18448@elte.hu>
 <20100316075709.GL2869@laptop>
 <20100316131336.GB24808@elte.hu>
 <20100316133534.GB22578@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316133534.GB22578@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > On Tue, Mar 16, 2010 at 08:36:35AM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > > 
> > > > > Unless this question is answered, Ingo's SA_RUNNING signal proposal, as 
> > > > > appealing as it may look at a first glance, falls into the 
> > > > > "fundamentally broken" category. [...]
> > > > 
> > > > How is it different from your syscall? I.e. which lines of code make the 
> > > > difference? We could certainly apply the (trivial) barrier change to 
> > > > context_switch().
> > > 
> > > I think it is just easy for userspace to misuse or think it does something 
> > > that it doesn't (because of races).
> > 
> > That wasnt my question though. The question i asked Mathieu was to show how 
> > SA_RUNNING is "fundamentally broken" for librcu use while sys_membarrier() is 
> > not?
> > 
> > This is really what he claims above. (i preserved the quote)
> > 
> > It must be a misunderstanding either on my side or on his side. (Once that is 
> > cleared we can discuss further usecases for SA_RUNNING.)
> 
> Well, it's not broken for sys_membarrier() specifically if we add the proper 
> memory barriers to the scheduler, but it's broken when we try to use it for 
> anything else. [...]

That's quite an important distinction to an unqualified "fundamentally 
broken", right?

> [...]  What makes it broken is that it requires that the scheduler switch 
> guarantee to have the same side-effect on a running thread than execution on 
> the per-running-thread signal handler.
> 
> What's different with the sys_membarrier system call is that it does not try 
> to make generic something that should probably stay case-specific due to its 
> close coupling with the scheduler.

Yeah, that's a fair point.

Without another realistic usecase SA_RUNNING would just essentially be a 
SA_BARRIER special-case. (IMO even in that case signal handling speedups 
driven via this usecase would still be tempting though.)

But note that some other usecase is possible as well:

In theory we could inject signals at context-switch time (if that signal is 
not pending yet) - signals are fairly atomic [with a preallocated pool] and 
the 'wakeup' property of signals is not needed as the to-be-running task is 
obviously up to execution. (so there's no deadlock. It doesnt have to run with 
the rq lock taken in any case - it can run from sched_tail() i suspect.)

So all this could be done via the ret-to-user framework that KVM uses at 
essentially no extra scheduler overhead. I think :-) It would be a bit like 
SIGALRM for timers.

Plus another performance optimization would be useful as well: signals could 
be turned on/off without having to enter the kernel. This could be done via a 
in-user-memory enable/disable-signals flag/mask associated with each task. (it 
would pin a page of memory.)

The question is, do we want to enable user-space to trigger a signal upon 
context-switches?

It probably cannot be a queued one, as preemption from the signal handler 
itself would be rather yucky. As long as concurrency control is involved, 
user-space only wants a callback for the _first_ reschedule - subsequent 
reschedules dont need to trigger a signal, until the signal handler has 
finished.

	Ingo
