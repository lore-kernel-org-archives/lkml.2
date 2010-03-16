Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966289Ab0CPOQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:16:24 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53783 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966277Ab0CPOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:16:22 -0400
Date: Tue, 16 Mar 2010 10:16:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20100316141617.GC22578@Krystal>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu> <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain> <20100304175659.GA3255@Krystal> <20100315205312.GA31231@Krystal> <20100316073635.GC18448@elte.hu> <20100316075709.GL2869@laptop> <20100316131336.GB24808@elte.hu> <20100316133534.GB22578@Krystal> <20100316135617.GC575@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316135617.GC575@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:03:17 up 52 days, 16:40,  5 users,  load average: 0.22, 0.06,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > > On Tue, Mar 16, 2010 at 08:36:35AM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > > > 
> > > > > > Unless this question is answered, Ingo's SA_RUNNING signal proposal, as 
> > > > > > appealing as it may look at a first glance, falls into the 
> > > > > > "fundamentally broken" category. [...]
> > > > > 
> > > > > How is it different from your syscall? I.e. which lines of code make the 
> > > > > difference? We could certainly apply the (trivial) barrier change to 
> > > > > context_switch().
> > > > 
> > > > I think it is just easy for userspace to misuse or think it does something 
> > > > that it doesn't (because of races).
> > > 
> > > That wasnt my question though. The question i asked Mathieu was to show how 
> > > SA_RUNNING is "fundamentally broken" for librcu use while sys_membarrier() is 
> > > not?
> > > 
> > > This is really what he claims above. (i preserved the quote)
> > > 
> > > It must be a misunderstanding either on my side or on his side. (Once that is 
> > > cleared we can discuss further usecases for SA_RUNNING.)
> > 
> > Well, it's not broken for sys_membarrier() specifically if we add the proper 
> > memory barriers to the scheduler, but it's broken when we try to use it for 
> > anything else. [...]
> 
> That's quite an important distinction to an unqualified "fundamentally 
> broken", right?

OK, I guess "conceptually broken" would be more precise in this case. ;)

> 
> > [...]  What makes it broken is that it requires that the scheduler switch 
> > guarantee to have the same side-effect on a running thread than execution on 
> > the per-running-thread signal handler.
> > 
> > What's different with the sys_membarrier system call is that it does not try 
> > to make generic something that should probably stay case-specific due to its 
> > close coupling with the scheduler.
> 
> Yeah, that's a fair point.
> 
> Without another realistic usecase SA_RUNNING would just essentially be a 
> SA_BARRIER special-case. (IMO even in that case signal handling speedups 
> driven via this usecase would still be tempting though.)
> 
> But note that some other usecase is possible as well:
> 
> In theory we could inject signals at context-switch time (if that signal is 
> not pending yet) - signals are fairly atomic [with a preallocated pool] and 
> the 'wakeup' property of signals is not needed as the to-be-running task is 
> obviously up to execution. (so there's no deadlock. It doesnt have to run with 
> the rq lock taken in any case - it can run from sched_tail() i suspect.)
> 
> So all this could be done via the ret-to-user framework that KVM uses at 
> essentially no extra scheduler overhead. I think :-) It would be a bit like 
> SIGALRM for timers.

That could be an interesting approach to hook into the scheduler "return to
userspace" path. We have to consider that this signal should probably have a
very high priority if we expect it to effectively nest over other signal
handlers.

But it does not address the hook needed upon entry into the scheduler context
switch. I fear this one might be a bit harder to do without tons of extra
overhead.

> 
> Plus another performance optimization would be useful as well: signals could 
> be turned on/off without having to enter the kernel. This could be done via a 
> in-user-memory enable/disable-signals flag/mask associated with each task. (it 
> would pin a page of memory.)

Hrm, it makes we wonder if this optimization would not add a slight overhead to
the scheduler. By allowing this kind of enable/disable flag, we would have to
check for blocked signal delivery upon each return to userspace. With the
current system call used for masking signals, this check can accurately be done
only in the signal-related system calls. (but maybe the scheduler already has to
take part of this burden for other reasons I'm not aware of). But yes,
independently of the SA_RUNNING topic, this optimization might very well be
worth it. I've actually been thinking along the same lines for a enable-disable
"thread migration" flag too, but that's a completely different topic (and has
impact on scheduler migration and cpu hotplug, so it's not as easy as it seems).

> 
> The question is, do we want to enable user-space to trigger a signal upon 
> context-switches?
> 
> It probably cannot be a queued one, as preemption from the signal handler 
> itself would be rather yucky. As long as concurrency control is involved, 
> user-space only wants a callback for the _first_ reschedule - subsequent 
> reschedules dont need to trigger a signal, until the signal handler has 
> finished.

That could work for return to userspace, any clever idea about how to deal with
the hook to call upon entry into context switch ?

Thanks,

Mathieu


> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
