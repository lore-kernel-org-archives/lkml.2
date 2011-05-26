Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1EZBae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:30:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53954 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab1EZBad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:30:33 -0400
Date: Wed, 25 May 2011 18:30:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110526013029.GA28103@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110524011824.GL7428@linux.vnet.ibm.com>
 <4DDB093F.2060601@kernel.org>
 <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <4DDC48E3.1060108@kernel.org>
 <20110525045253.GB2262@linux.vnet.ibm.com>
 <4DDD7F96.3090408@kernel.org>
 <20110525223437.GO2341@linux.vnet.ibm.com>
 <4DDD8775.1000501@kernel.org>
 <20110526011310.GP2341@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526011310.GP2341@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 06:13:10PM -0700, Paul E. McKenney wrote:
> On Wed, May 25, 2011 at 03:49:25PM -0700, Yinghai Lu wrote:
> > On 05/25/2011 03:34 PM, Paul E. McKenney wrote:
> > > On Wed, May 25, 2011 at 03:15:50PM -0700, Yinghai Lu wrote:
> > >>> There is a new branch yinghai.2011.05.24a on:
> > >>>
> > >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > >>>
> > >>> Or will be as soon as kernel.org updates its mirrors.
> > >>>
> > >>> I am not sure I could call this "clean", but it does revert that commit
> > >>> and 11 of the subsequent commits that depend on it.  It does build,
> > >>> and I will test it once my currently running tests complete.
> > >>
> > >> yes, with those revert, there is no delay in 10 times booting.
> > > 
> > > Unfortunately, there are rcutorture test failures with the revert...
> > 
> > confused.
> 
> Given what I had to do to generate the revert, not exactly a surprise,
> I am afraid.  Just means that the resulting RCU sometimes fails to
> wait for all pre-existing readers, and rcutorture catches it.
> 
> > what is the next?
> 
> 1.	I send you a patch that I hope will fix the softlockup
> 	you saw.  I am testing this.
> 
> 2.	I am working on more detailed instrumentation, and will
> 	send a patch on that.
> 
> 3.	If time allows, break down the operations RCU is doing
> 	and test them in isolation.
> 
> Other thoughts?

And here is patch #1.  Could you please try applying this on top of
Peter Zijlstra's patch to see if it gets rid of the softlockups you saw?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state

Upon creation, kthreads are in TASK_UNINTERRUPTIBLE state, which can
result in softlockup warnings.  Because some of RCU's kthreads can
legitimately be idle indefinitely, start them in TASK_INTERRUPTIBLE
state in order to avoid those warnings.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a1a8bb6..40aab8d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1647,6 +1647,7 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	kthread_bind(t, cpu);
+	set_task_state(t, TASK_INTERRUPTIBLE);
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
@@ -1754,6 +1755,7 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		if (IS_ERR(t))
 			return PTR_ERR(t);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		set_task_state(t, TASK_INTERRUPTIBLE);
 		rnp->node_kthread_task = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		sp.sched_priority = 99;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 049f278..a767b7d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1295,6 +1295,7 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	set_task_state(t, TASK_INTERRUPTIBLE);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
