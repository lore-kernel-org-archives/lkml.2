Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1E3VaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:30:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59879 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1E3VaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:30:02 -0400
Date: Mon, 30 May 2011 14:29:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Very high CPU load when idle with 3.0-rc1
Message-ID: <20110530212955.GT2668@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110530055924.GA9169@brouette>
 <1306755291.1200.2872.camel@twins>
 <20110530162354.GQ2668@linux.vnet.ibm.com>
 <1306773981.23844.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306773981.23844.2.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 06:46:21PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-05-30 at 09:23 -0700, Paul E. McKenney wrote:
> 
> > > @@ -1772,18 +1772,30 @@ static int __init rcu_spawn_kthreads(void)
> > >  {
> > >  	int cpu;
> > >  	struct rcu_node *rnp;
> > > +	struct task_struct *t;
> > >  
> > >  	rcu_kthreads_spawnable = 1;
> > >  	for_each_possible_cpu(cpu) {
> > >  		per_cpu(rcu_cpu_has_work, cpu) = 0;
> > > -		if (cpu_online(cpu))
> > > +		if (cpu_online(cpu)) {
> > >  			(void)rcu_spawn_one_cpu_kthread(cpu);
> > > +			t = per_cpu(rcu_cpu_kthread_task, cpu);
> > > +			if (t)
> > > +				wake_up_process(t);
> > > +		}
> > 
> > Would it be OK to simplify the code a bit by doing this initial wakeup
> > in rcu_spawn_one_cpu_kthread() itself?  My thought would be to rearrange
> > rcu_spawn_one_cpu_kthread() as follows:
> 
> well, no that would get us back to waking a task affine to an offline
> cpu :-)

My turn to say d'oh, then!

But I should be able to move them back in under "if (cpu_online(cpu))",
right?

> > > @@ -2209,6 +2221,31 @@ static void __cpuinit rcu_online_kthreads(int cpu)
> > >  }
> > >  
> > >  /*
> > > + * kthread_create() creates threads in TASK_UNINTERRUPTIBLE state,
> > > + * but the RCU threads are woken on demand, and if demand is low this
> > > + * could be a while triggering the hung task watchdog.
> > > + *
> > > + * In order to avoid this, poke all tasks once the CPU is fully
> > > + * up and running.
> > > + */
> > > +static void __cpuinit rcu_online_kthreads(int cpu)
> > > +{
> > > +	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
> > > +	struct rcu_node *rnp = rdp->mynode;
> > > +	struct task_struct *t;
> > > +
> > > +	t = per_cpu(rcu_cpu_kthread_task, cpu);
> > > +	if (t)
> > > +		wake_up_process(t);
> > > +
> > > +	t = rnp->node_kthread_task;
> > > +	if (t)
> > > +		wake_up_process(t);
> > > +
> > > +	rcu_wake_one_boost_kthread(rnp);
> > 
> > Interesting...  So we are really awakening them twice, once at creation
> > time to get them to sleep interruptibly, and a second time when the CPU
> > comes online.
> > 
> > What does this second set of wake_up_process() calls do?
> 
> Ah, not so, see the initial one is conditional on cpu_online() and will
> fail for the CPU_UP_PREPARE case, this new function will be ran from
> CPU_ONLINE to then issue the first wakeup.
> 
> The distinction comes from the initialize while cpus are already running
> vs hotplug.

OK, got it.

							Thanx, Paul
