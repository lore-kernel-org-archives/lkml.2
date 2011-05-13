Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab1EMRCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:02:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1EMRCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:02:35 -0400
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
In-Reply-To: <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
References: <20110428161149.GA15658@redhat.com>
	 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
	 <20110502195657.2D68.A69D9226@jp.fujitsu.com>
	 <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com>
	 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 19:02:15 +0200
Message-ID: <1305306135.2466.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 14:42 +0800, Yong Zhang wrote:
> > - rcu_cpu_kthread_should_stop() call set_cpus_allowed_ptr() again
> > periodically.
> >  then, it can reset cpumask if cpuset_cpus_allowed_fallback() change it.
> >  my debug print obseve following cpumask change occur at boot time.
> >     1) kthread_bind: bind cpu1
> >     2) cpuset_cpus_allowed_fallback: bind possible cpu
> >     3) rcu_cpu_kthread_should_stop: rebind cpu1
> > - while tsk->rt.nr_cpus_allowed == 1, sched load balancer never be crash.
> 
> Seems rcu_spawn_one_cpu_kthread() call wake_up_process() directly,
> which is under hotplug event CPU_UP_PREPARE. Maybe it should be
> under CPU_ONLINE. 

IIRC I talked to Paul about this a while back and ONLINE is too late,
however STARTING should work. At the time he couldn't quite get that to
work, but the above situation is indeed the root cause of our problems.

We shouldn't try to run a cpu affine thread before the cpu in question
is actually able to run stuff.

I did me a little hackery and with the below patch my kernel still
boots...

Would that sort your issue?

---
 kernel/rcutree.c        |   44 ++++++++++++++++++++++++++++++++++++++------
 kernel/rcutree_plugin.h |    1 -
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..e0218ed 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1656,7 +1656,6 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;
@@ -1764,13 +1763,33 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->node_kthread_task = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		wake_up_process(t);
 		sp.sched_priority = 99;
 		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	}
 	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
 }
 
+static void __cpuinit rcu_wake_cpu_kthread(int cpu)
+{
+	struct task_struct *p = per_cpu(rcu_cpu_kthread_task, cpu);
+
+	if (p)
+		wake_up_process(p);
+}
+
+static void __cpuinit rcu_wake_node_kthread(struct rcu_node *rnp)
+{
+	if (!rnp)
+		return;
+
+	if (rnp->node_kthread_task)
+		wake_up_process(rnp->node_kthread_task);
+#ifdef CONFIG_RCU_BOOST
+	if (rnp->boost_kthread_task)
+		wake_up_process(rnp->boost_kthread_task);
+#endif
+}
+
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
@@ -1783,19 +1802,24 @@ static int __init rcu_spawn_kthreads(void)
 	for_each_possible_cpu(cpu) {
 		init_waitqueue_head(&per_cpu(rcu_cpu_wq, cpu));
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu))
+		if (cpu_online(cpu)) {
 			(void)rcu_spawn_one_cpu_kthread(cpu);
+			rcu_wake_cpu_kthread(cpu);
+		}
 	}
 	rnp = rcu_get_root(rcu_state);
 	init_waitqueue_head(&rnp->node_wq);
 	rcu_init_boost_waitqueue(rnp);
 	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	if (NUM_RCU_NODES > 1)
+	rcu_wake_node_kthread(rnp);
+	if (NUM_RCU_NODES > 1) {
 		rcu_for_each_leaf_node(rcu_state, rnp) {
 			init_waitqueue_head(&rnp->node_wq);
 			rcu_init_boost_waitqueue(rnp);
 			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+			rcu_wake_node_kthread(rnp);
 		}
+	}
 	return 0;
 }
 early_initcall(rcu_spawn_kthreads);
@@ -2206,7 +2230,7 @@ static void __cpuinit rcu_online_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
-static void __cpuinit rcu_online_kthreads(int cpu)
+static void __cpuinit rcu_prepare_kthreads(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
@@ -2233,7 +2257,15 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
-		rcu_online_kthreads(cpu);
+		rcu_prepare_kthreads(cpu);
+		break;
+	case CPU_STARTING:
+		rcu_wake_cpu_kthread(cpu);
+		do {
+			struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+		       	if (rdp)
+				rcu_wake_node_kthread(rdp->mynode);
+		} while (0);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ed339702..961a316 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1306,7 +1306,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	wake_up_process(t);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	return 0;

