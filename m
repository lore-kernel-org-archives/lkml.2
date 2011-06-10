Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab1FJTx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:53:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39740 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab1FJTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:53:55 -0400
Date: Fri, 10 Jun 2011 12:53:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 01/28] rcu: Simplify curing of load woes
Message-ID: <20110610195333.GK2230@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1307715512.3941.168.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307715512.3941.168.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:18:32PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-08 at 12:29 -0700, Paul E. McKenney wrote:
> > Make the functions creating the kthreads wake them up.  Leverage the
> > fact that the per-node and boost kthreads can run anywhere, thus
> > dispensing with the need to wake them up once the incoming CPU has
> > gone fully online.
> 
> Indeed, I failed to notice the node and boost threads weren't bound.

Hey, you did the big fix, so I cannot complain about doing a little
cleanup!  ;-)

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c        |   65 +++++++++++++++-------------------------------
> >  kernel/rcutree_plugin.h |   11 +-------
> >  2 files changed, 22 insertions(+), 54 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 4cc6a94..36e79d2 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1634,6 +1634,20 @@ static int rcu_cpu_kthread(void *arg)
> >   * to manipulate rcu_cpu_kthread_task.  There might be another CPU
> >   * attempting to access it during boot, but the locking in kthread_bind()
> >   * will enforce sufficient ordering.
> > + *
> > + * Please note that we cannot simply refuse to wake up the per-CPU
> > + * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
> > + * which can result in softlockup complaints if the task ends up being
> > + * idle for more than a couple of minutes.
> > + *
> > + * However, please note also that we cannot bind the per-CPU kthread to its
> > + * CPU until that CPU is fully online.  We also cannot wait until the
> > + * CPU is fully online before we create its per-CPU kthread, as this would
> > + * deadlock the system when CPU notifiers tried waiting for grace
> > + * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
> > + * is online.  If its CPU is not yet fully online, then the code in
> > + * rcu_cpu_kthread() will wait until it is fully online, and then do
> > + * the binding.
> >   */
> >  static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
> >  {
> > @@ -1646,12 +1660,14 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
> >         t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
> >         if (IS_ERR(t))
> >                 return PTR_ERR(t);
> > -       kthread_bind(t, cpu);
> > +       if (cpu_online(cpu))
> > +               kthread_bind(t, cpu);
> >         per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
> >         WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
> > -       per_cpu(rcu_cpu_kthread_task, cpu) = t;
> >         sp.sched_priority = RCU_KTHREAD_PRIO;
> >         sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
> > +       per_cpu(rcu_cpu_kthread_task, cpu) = t;
> > +       wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
> >         return 0;
> >  } 
> 
> I'm not quite seeing how this is working though, I cannot find any code
> in rcu_cpu_kthread() that sets the thread affinity (not a hunk in this
> patch that adds it).

This happens in rcu_cpu_kthread_should_stop(), which is called from
rcu_cpu_kthread() before it does any real work.

Here it is:

static int rcu_cpu_kthread_should_stop(int cpu)
{
	while (cpu_is_offline(cpu) ||
	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
	       smp_processor_id() != cpu) {
		if (kthread_should_stop())
			return 1;
		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
		local_bh_enable();
		schedule_timeout_uninterruptible(1);
		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
			set_cpus_allowed_ptr(current, cpumask_of(cpu));
		local_bh_disable();
	}
	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
	return 0;
}

Thoughts?

							Thanx, Paul
