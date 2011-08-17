Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1HQCuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:50:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40853 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1HQCuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:50:37 -0400
Date: Tue, 16 Aug 2011 19:49:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 14/32] nohz/cpuset: Don't turn off the tick if rcu
 needs it
Message-ID: <20110817024914.GA2745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-15-git-send-email-fweisbec@gmail.com>
 <20110816201342.GG2404@linux.vnet.ibm.com>
 <20110817021024.GB32132@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817021024.GB32132@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 04:10:27AM +0200, Frederic Weisbecker wrote:
> On Tue, Aug 16, 2011 at 01:13:42PM -0700, Paul E. McKenney wrote:
> > On Mon, Aug 15, 2011 at 05:52:11PM +0200, Frederic Weisbecker wrote:
> > > If RCU is waiting for the current CPU to complete a grace
> > > period, don't turn off the tick. Unlike dynctik-idle, we
> > 
> > s/dynctik/dyntick/  ;-)
> 
> Heh! :)
> 
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index 99f9aa7..55a482a 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -133,6 +133,7 @@ static inline int rcu_preempt_depth(void)
> > >  extern void rcu_sched_qs(int cpu);
> > >  extern void rcu_bh_qs(int cpu);
> > >  extern void rcu_check_callbacks(int cpu, int user);
> > > +extern int rcu_pending(int cpu);
> > >  struct notifier_block;
> > > 
> > >  #ifdef CONFIG_NO_HZ
> > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > index ba06207..0009bfc 100644
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -205,7 +205,6 @@ int rcu_cpu_stall_suppress __read_mostly;
> > >  module_param(rcu_cpu_stall_suppress, int, 0644);
> > > 
> > >  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
> > > -static int rcu_pending(int cpu);
> > > 
> > >  /*
> > >   * Return the number of RCU-sched batches processed thus far for debug & stats.
> > > @@ -1729,7 +1728,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
> > >   * by the current CPU, returning 1 if so.  This function is part of the
> > >   * RCU implementation; it is -not- an exported member of the RCU API.
> > >   */
> > > -static int rcu_pending(int cpu)
> > > +int rcu_pending(int cpu)
> > >  {
> > >  	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
> > >  	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
> > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > index 0e1aa4e..353a66f 100644
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -2439,6 +2439,7 @@ DEFINE_PER_CPU(int, task_nohz_mode);
> > >  bool cpuset_nohz_can_stop_tick(void)
> > >  {
> > >  	struct rq *rq;
> > > +	int cpu;
> > > 
> > >  	rq = this_rq();
> > > 
> > > @@ -2446,6 +2447,19 @@ bool cpuset_nohz_can_stop_tick(void)
> > >  	if (rq->nr_running > 1)
> > >  		return false;
> > > 
> > > +	cpu = smp_processor_id();
> > > +
> > > +	/*
> > > +	 * FIXME: will probably be removed soon as it's
> > > +	 * already checked from tick_nohz_stop_sched_tick()
> > > +	 */
> > > +	if (rcu_needs_cpu(cpu))
> > > +		return false;
> > > +
> > > +	/* Is there a grace period to complete ? */
> > > +	if (rcu_pending(cpu))
> > 
> > This is from a quiescent state for both RCU and RCU-bh, right?
> > Or can their be RCU or RCU-bh read-side critical sections held
> > across here?  (It would be mildly bad if so.)
> 
> Yeah this can happen. This is called from the timer interrupt
> or from an IPI. We can be in any kind of rcu critical section.
> 
> > But force_quiescent_state() will catch cases where RCU needs
> > quiescent states from CPUs, so is this check really needed?
> 
> Yeah we should receive IPIs from CPUs that need us. This can
> be an optimization though. No need to run into a cycle of
> on timers shutdown/restart if we can complete something
> right away.

Never mind...  I was confusing this with rcu_needs_cpu(), which should not
be called from within an RCU-sched or RCU-bh read-side critical section.

It is plenty fine to call rcu_pending() from within RCU read-side
critical sections.

							Thanx, Paul
