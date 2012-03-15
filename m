Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390Ab2COSvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:51:02 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50999 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031066Ab2COSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:50:57 -0400
Date: Thu, 15 Mar 2012 14:50:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC] rcu: Make rcu_barrier() less disruptive
Message-ID: <20120315185054.GA1764@Krystal>
References: <20120315164839.GA1657@linux.vnet.ibm.com> <20120315174527.GA775@Krystal> <20120315182159.GJ2381@linux.vnet.ibm.com> <20120315183143.GA4472@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315183143.GA4472@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:50:16 up 477 days, 23:53,  5 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Mar 15, 2012 at 11:21:59AM -0700, Paul E. McKenney wrote:
> > On Thu, Mar 15, 2012 at 01:45:27PM -0400, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > The rcu_barrier() primitive interrupts each and every CPU, registering
> > > > a callback on every CPU.  Once all of these callbacks have been invoked,
> > > > rcu_barrier() knows that every callback that was registered before
> > > > the call to rcu_barrier() has also been invoked.
> > > > 
> > > > However, there is no point in registering a callback on a CPU that
> > > > currently has no callbacks, most especially if that CPU is in a
> > > > deep idle state.  This commit therefore makes rcu_barrier() avoid
> > > > interrupting CPUs that have no callbacks.  Doing this requires reworking
> > > > the handling of orphaned callbacks, otherwise callbacks could slip through
> > > > rcu_barrier()'s net by being orphaned from a CPU that rcu_barrier() had
> > > > not yet interrupted to a CPU that rcu_barrier() had already interrupted.
> > > > This reworking was needed anyway to take a first step towards weaning
> > > > RCU from the CPU_DYING notifier's use of stop_cpu().
> > > 
> > > Quoting Documentation/RCU/rcubarrier.txt:
> > > 
> > > "We instead need the rcu_barrier() primitive. This primitive is similar
> > > to synchronize_rcu(), but instead of waiting solely for a grace
> > > period to elapse, it also waits for all outstanding RCU callbacks to
> > > complete. Pseudo-code using rcu_barrier() is as follows:"
> > > 
> > > The patch you propose seems like a good approach to make rcu_barrier
> > > less disruptive, but everyone need to be aware that rcu_barrier() would
> > > quit having the side-effect of doing the equivalent of
> > > "synchronize_rcu()" from now on: within this new approach, in the case
> > > where there are no pending callbacks, rcu_barrier() could, AFAIU, return
> > > without waiting for the current grace period to complete.
> > > 
> > > Any use of rcu_barrier() that would assume that a synchronize_rcu() is
> > > implicit with the rcu_barrier() execution would be a bug anyway, but
> > > those might only show up after this patch is applied. I would therefore
> > > recommend to audit all rcu_barrier() users to ensure none is expecting
> > > rcu_barrier to act as a synchronize_rcu before pushing this change.
> > 
> > Good catch!
> > 
> > I am going to chicken out and explicitly wait for a grace period if there
> > were no callbacks.  Having rcu_barrier() very rarely be a quick no-op does
> > sound like a standing invitation for subtle non-reproducible bugs.  ;-)
> 
> I take it back...
> 
> After adopting callbacks (rcu_adopt_orphan_cbs()), _rcu_barrier()
> unconditionally posts a callback on the current CPU and waits for it.
> So _rcu_barrier() actually does always wait for a grace period.

Ah ok, that should handle it then.

> 
> Yes, I could be more dainty and make rcu_adopt_orphan_cbs() return an
> indication of whether there were any callbacks, and then post the callback
> only if either there were some callbacks adopted or if there were no calls
> to smp_call_function_single().  But that adds complexity for almost no
> benefit -- and no one can accuse _rcu_barrier() of being a fastpath!  ;-)
> 
> Or am I missing something here?

Nope, I think it all makes sense.

Thanks,

Mathieu

> 
> 							Thanx, Paul
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
