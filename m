Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2FNM7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:59:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40987 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab2FNM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:59:47 -0400
Date: Thu, 14 Jun 2012 05:59:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614125939.GC2443@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206141234400.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061412-4242-0000-0000-000001F73567
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:20:39PM +0200, Thomas Gleixner wrote:
> B1;2601;0cOn Wed, 13 Jun 2012, Paul E. McKenney wrote:
> 
> > On Wed, Jun 13, 2012 at 01:47:25PM -0700, Paul E. McKenney wrote:
> > > On Wed, Jun 13, 2012 at 12:17:45PM -0700, Paul E. McKenney wrote:
> > > > On Wed, Jun 13, 2012 at 09:02:55PM +0200, Thomas Gleixner wrote:
> > > > > On Wed, 13 Jun 2012, Paul E. McKenney wrote:
> > > > > > On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> > > > > > >  	/* Now call notifier in preparation. */
> > > > > > >  	cpu_notify(CPU_ONLINE | mod, hcpu);
> > > > > > > +	smpboot_unpark_threads(cpu);
> > > > > > 
> > > > > > OK, RCU must use the lower-level interfaces, given that one of
> > > > > > then CPU_ONLINE notifiers might invoke synchronize_rcu().
> > > > > 
> > > > > We can start the threads before the notifiers. There is no
> > > > > restriction.
> > > > 
> > > > Sounds very good in both cases!
> > > 
> > > Just for reference, here is what I am using.
> > 
> > And here is a buggy first attempt to make RCU use the smpboot interfaces.
> > Probably still bugs in my adaptation, as it still hangs in the first
> > attempt to offline a CPU.  If I revert the softirq smpboot commit, the
> > offline still hangs somewhere near the __stop_machine() processing, but
> > the system continues running otherwise.  Will continue debugging tomorrow.
> 
> I gave it a quick shot, but I was not able to reproduce the hang yet.

Really?  I have a strictly Western-Hemisphere bug?  ;-)

> But looking at the thread function made me look into rcu_yield() and I
> really wonder what kind of drug induced that particular piece of
> horror.

When you are working on something like RCU priority boosting, no other
drug is in any way necessary.  ;-)

> I can't figure out why this yield business is necessary at all. The
> commit logs are as helpful as the missing code comments :)
> 
> I suspect that it's some starvation issue. But if we need it, then
> can't we replace it with something sane like the (untested) patch
> below?

Yep, starvation.  I will take a look at your approach after I wake
up a bit more.

							Thanx, Paul

> Thanks,
> 
> 	tglx
> ---
>  kernel/rcutree.h        |    2 -
>  kernel/rcutree_plugin.h |   89 ++++++++++--------------------------------------
>  2 files changed, 19 insertions(+), 72 deletions(-)
> 
> Index: tip/kernel/rcutree.h
> ===================================================================
> --- tip.orig/kernel/rcutree.h
> +++ tip/kernel/rcutree.h
> @@ -469,8 +469,6 @@ static void rcu_boost_kthread_setaffinit
>  static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
>  						 struct rcu_node *rnp,
>  						 int rnp_index);
> -static void invoke_rcu_node_kthread(struct rcu_node *rnp);
> -static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
>  static void __cpuinit rcu_prepare_kthreads(int cpu);
> Index: tip/kernel/rcutree_plugin.h
> ===================================================================
> --- tip.orig/kernel/rcutree_plugin.h
> +++ tip/kernel/rcutree_plugin.h
> @@ -1217,6 +1217,16 @@ static void rcu_initiate_boost_trace(str
> 
>  #endif /* #else #ifdef CONFIG_RCU_TRACE */
> 
> +static void rcu_wake_cond(struct task_struct *t, int status)
> +{
> +	/*
> +	 * If the thread is yielding, only wake it when this
> +	 * is invoked from idle
> +	 */
> +	if (status != RCU_KTHREAD_YIELDING || is_idle_task(current))
> +		wake_up_process(t);
> +}
> +
>  /*
>   * Carry out RCU priority boosting on the task indicated by ->exp_tasks
>   * or ->boost_tasks, advancing the pointer to the next task in the
> @@ -1289,17 +1299,6 @@ static int rcu_boost(struct rcu_node *rn
>  }
> 
>  /*
> - * Timer handler to initiate waking up of boost kthreads that
> - * have yielded the CPU due to excessive numbers of tasks to
> - * boost.  We wake up the per-rcu_node kthread, which in turn
> - * will wake up the booster kthread.
> - */
> -static void rcu_boost_kthread_timer(unsigned long arg)
> -{
> -	invoke_rcu_node_kthread((struct rcu_node *)arg);
> -}
> -
> -/*
>   * Priority-boosting kthread.  One per leaf rcu_node and one for the
>   * root rcu_node.
>   */
> @@ -1322,8 +1321,9 @@ static int rcu_boost_kthread(void *arg)
>  		else
>  			spincnt = 0;
>  		if (spincnt > 10) {
> +			rnp->boost_kthread_status = RCU_KTHREAD_YIELDING;
>  			trace_rcu_utilization("End boost kthread@rcu_yield");
> -			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
> +			schedule_timeout_interruptible(2);
>  			trace_rcu_utilization("Start boost kthread@rcu_yield");
>  			spincnt = 0;
>  		}
> @@ -1361,8 +1361,8 @@ static void rcu_initiate_boost(struct rc
>  			rnp->boost_tasks = rnp->gp_tasks;
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  		t = rnp->boost_kthread_task;
> -		if (t != NULL)
> -			wake_up_process(t);
> +		if (t)
> +			rcu_wake_cond(t, rnp->boost_kthread_status);
>  	} else {
>  		rcu_initiate_boost_trace(rnp);
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> @@ -1379,8 +1379,10 @@ static void invoke_rcu_callbacks_kthread
>  	local_irq_save(flags);
>  	__this_cpu_write(rcu_cpu_has_work, 1);
>  	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
> -	    current != __this_cpu_read(rcu_cpu_kthread_task))
> -		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
> +	    current != __this_cpu_read(rcu_cpu_kthread_task)) {
> +		rcu_wake_cond(__this_cpu_read(rcu_cpu_kthread_task),
> +			      __this_cpu_read(rcu_cpu_kthread_status));
> +	}
>  	local_irq_restore(flags);
>  }
> 
> @@ -1476,20 +1478,6 @@ static void rcu_kthread_do_work(void)
>  }
> 
>  /*
> - * Wake up the specified per-rcu_node-structure kthread.
> - * Because the per-rcu_node kthreads are immortal, we don't need
> - * to do anything to keep them alive.
> - */
> -static void invoke_rcu_node_kthread(struct rcu_node *rnp)
> -{
> -	struct task_struct *t;
> -
> -	t = rnp->node_kthread_task;
> -	if (t != NULL)
> -		wake_up_process(t);
> -}
> -
> -/*
>   * Set the specified CPU's kthread to run RT or not, as specified by
>   * the to_rt argument.  The CPU-hotplug locks are held, so the task
>   * is not going away.
> @@ -1514,45 +1502,6 @@ static void rcu_cpu_kthread_setrt(int cp
>  }
> 
>  /*
> - * Timer handler to initiate the waking up of per-CPU kthreads that
> - * have yielded the CPU due to excess numbers of RCU callbacks.
> - * We wake up the per-rcu_node kthread, which in turn will wake up
> - * the booster kthread.
> - */
> -static void rcu_cpu_kthread_timer(unsigned long arg)
> -{
> -	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
> -	struct rcu_node *rnp = rdp->mynode;
> -
> -	atomic_or(rdp->grpmask, &rnp->wakemask);
> -	invoke_rcu_node_kthread(rnp);
> -}
> -
> -/*
> - * Drop to non-real-time priority and yield, but only after posting a
> - * timer that will cause us to regain our real-time priority if we
> - * remain preempted.  Either way, we restore our real-time priority
> - * before returning.
> - */
> -static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
> -{
> -	struct sched_param sp;
> -	struct timer_list yield_timer;
> -	int prio = current->rt_priority;
> -
> -	setup_timer_on_stack(&yield_timer, f, arg);
> -	mod_timer(&yield_timer, jiffies + 2);
> -	sp.sched_priority = 0;
> -	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
> -	set_user_nice(current, 19);
> -	schedule();
> -	set_user_nice(current, 0);
> -	sp.sched_priority = prio;
> -	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
> -	del_timer(&yield_timer);
> -}
> -
> -/*
>   * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
>   * This can happen while the corresponding CPU is either coming online
>   * or going offline.  We cannot wait until the CPU is fully online
> @@ -1624,7 +1573,7 @@ static int rcu_cpu_kthread(void *arg)
>  		if (spincnt > 10) {
>  			*statusp = RCU_KTHREAD_YIELDING;
>  			trace_rcu_utilization("End CPU kthread@rcu_yield");
> -			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
> +			schedule_timeout_interruptible(2);
>  			trace_rcu_utilization("Start CPU kthread@rcu_yield");
>  			spincnt = 0;
>  		}
> 

