Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1IZWui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:50:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45347 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab1IZWuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:50:37 -0400
Date: Mon, 26 Sep 2011 15:50:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110926225032.GQ2399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110925002409.GA24220@shutemov.name>
 <20110925050826.GC2995@linux.vnet.ibm.com>
 <20110925112637.GA19298@shutemov.name>
 <20110925130622.GA9205@somewhere.redhat.com>
 <20110925164804.GD2995@linux.vnet.ibm.com>
 <20110926010418.GA18553@somewhere>
 <CAFTL4hy4t4z2GX=Tj5wjVv=BSGaSbcspDw3FGUy_2uK=9HU_2A@mail.gmail.com>
 <20110926012611.GJ2995@linux.vnet.ibm.com>
 <20110926092052.GD18553@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110926092052.GD18553@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 11:20:55AM +0200, Frederic Weisbecker wrote:
> On Sun, Sep 25, 2011 at 06:26:11PM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 26, 2011 at 03:10:33AM +0200, Frederic Weisbecker wrote:
> > > 2011/9/26 Frederic Weisbecker <fweisbec@gmail.com>:
> > > > On Sun, Sep 25, 2011 at 09:48:04AM -0700, Paul E. McKenney wrote:
> > > >> This is required for RCU_FAST_NO_HZ, which checks to see whether the
> > > >> current CPU can accelerate the current grace period so as to enter
> > > >> dyntick-idle mode sooner than it would otherwise.  This takes effect
> > > >> in the situation where rcu_needs_cpu() sees that there are callbacks.
> > > >> It then notes a quiescent state (which is illegal in an RCU read-side
> > > >> critical section), calls force_quiescent_state(), and so on.  For this
> > > >> to work, the current CPU must be in an RCU read-side critical section.
> > > >
> > > > You mean it must *not* be in an RCU read-side critical section (ie: in a
> > > > quiescent state)?
> > > >
> > > > That assumption at least fails anytime in idle for the RCU
> > > > sched flavour given that preemption is disabled in the idle loop.
> > > >
> > > >> If this cannot be made to work, another option is to call a new RCU
> > > >> function in the case where rcu_needs_cpu() returned false, but after
> > > >> the RCU read-side critical section has exited.
> > > >
> > > > You mean when rcu_needs_cpu() returns true (when we have callbacks
> > > > enqueued)?
> > > >
> > > >> This new RCU function
> > > >> could then attempt to rearrange RCU so as to allow the CPU to enter
> > > >> dyntick-idle mode more quickly.  It is more important for this to
> > > >> happen when the CPU is going idle than when it is executing a user
> > > >> process.
> > > >>
> > > >> So, is this doable?
> > > >
> > > > At least not when we have RCU sched callbacks enqueued, given preemption
> > > > is disabled. But that sounds plausible in order to accelerate the switch
> > > > to dyntick-idle mode when we only have rcu and/or rcu bh callbacks.
> > > 
> > > But the RCU sched case could be dealt with if we embrace every use of
> > > it with rcu_read_lock_sched() and rcu_read_unlock_sched(), or some light
> > > version that just increases a local counter that rcu_needs_cpu() could check.
> > > 
> > > It's an easy thing to add: we can ensure preempt is disabled when we call it
> > > and we can force rcu_dereference_sched() to depend on it.
> > 
> > Or just check to see if this is the first level of interrupt from the
> > idle task after the scheduler is up.
> 
> I believe it's always the case. tick_nohz_stop_sched_tick() is only called
> from the first level of interrupt in irq_exit().

OK, good, let me see if I really understand this...

Case 1: The interrupt interrupted non-dyntick-idle code.  In this case,
	rcu_needs_cpu() can look at the dyntick-idle state and determine
	that it might not be in a quiescent state.

Case 2: The interrupt interrupted dyntick-idle code.  In this case,
	the interrupted code had better not be in an RCU read-side
	critical section, and rcu_needs_cpu() should be able to
	detect this as well.

Case 3: The interrupt interrupted the process of transitioning to
	or from dyntick-idle mode.  This should be prohibited by
	the local_irq_save() calls, right?

> There is always some race window, as it's based on preempt offset: between
> the sub_preempt_count and the softirqs begin and between softirqs end and the end
> of the interrupt. But an "idle_cpu() || in_interrupt()" check in rcu_read_lock_sched_held()
> should catch those offenders.

But all of this stuff looks to me to be called from the context
of the idle task, so that idle_cpu() will always return "true"...

							Thanx, Paul
