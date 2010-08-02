Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0HBD0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 23:26:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46521 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab0HBD0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 23:26:34 -0400
Date: Mon, 2 Aug 2010 13:26:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the workqueues tree with the tip tree
Message-Id: <20100802132629.963c0275.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/workqueue.c between commit
a25909a4d4a29e272f953e12595bf2f04a292dbd ("lockdep: Add an
in_workqueue_context() lockdep-based test function") from the tip tree
and commit 098849516dd522a343e659740c8f1394a5b7fa69 ("workqueue: explain
for_each_*cwq_cpu() iterators") from the workqueues tree (alogn with a
few others that were previously reported).

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index 59fef15,e2eb351..0000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -68,21 -237,68 +237,83 @@@ struct workqueue_struct 
  #endif
  };
  
 +#ifdef CONFIG_LOCKDEP
 +/**
 + * in_workqueue_context() - in context of specified workqueue?
 + * @wq: the workqueue of interest
 + *
 + * Checks lockdep state to see if the current task is executing from
 + * within a workqueue item.  This function exists only if lockdep is
 + * enabled.
 + */
 +int in_workqueue_context(struct workqueue_struct *wq)
 +{
 +	return lock_is_held(&wq->lockdep_map);
 +}
 +#endif
 +
+ struct workqueue_struct *system_wq __read_mostly;
+ struct workqueue_struct *system_long_wq __read_mostly;
+ struct workqueue_struct *system_nrt_wq __read_mostly;
+ struct workqueue_struct *system_unbound_wq __read_mostly;
+ EXPORT_SYMBOL_GPL(system_wq);
+ EXPORT_SYMBOL_GPL(system_long_wq);
+ EXPORT_SYMBOL_GPL(system_nrt_wq);
+ EXPORT_SYMBOL_GPL(system_unbound_wq);
+ 
+ #define for_each_busy_worker(worker, i, pos, gcwq)			\
+ 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
+ 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
+ 
+ static inline int __next_gcwq_cpu(int cpu, const struct cpumask *mask,
+ 				  unsigned int sw)
+ {
+ 	if (cpu < nr_cpu_ids) {
+ 		if (sw & 1) {
+ 			cpu = cpumask_next(cpu, mask);
+ 			if (cpu < nr_cpu_ids)
+ 				return cpu;
+ 		}
+ 		if (sw & 2)
+ 			return WORK_CPU_UNBOUND;
+ 	}
+ 	return WORK_CPU_NONE;
+ }
+ 
+ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
+ 				struct workqueue_struct *wq)
+ {
+ 	return __next_gcwq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
+ }
+ 
+ /*
+  * CPU iterators
+  *
+  * An extra gcwq is defined for an invalid cpu number
+  * (WORK_CPU_UNBOUND) to host workqueues which are not bound to any
+  * specific CPU.  The following iterators are similar to
+  * for_each_*_cpu() iterators but also considers the unbound gcwq.
+  *
+  * for_each_gcwq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
+  * for_each_online_gcwq_cpu()	: online CPUs + WORK_CPU_UNBOUND
+  * for_each_cwq_cpu()		: possible CPUs for bound workqueues,
+  *				  WORK_CPU_UNBOUND for unbound workqueues
+  */
+ #define for_each_gcwq_cpu(cpu)						\
+ 	for ((cpu) = __next_gcwq_cpu(-1, cpu_possible_mask, 3);		\
+ 	     (cpu) < WORK_CPU_NONE;					\
+ 	     (cpu) = __next_gcwq_cpu((cpu), cpu_possible_mask, 3))
+ 
+ #define for_each_online_gcwq_cpu(cpu)					\
+ 	for ((cpu) = __next_gcwq_cpu(-1, cpu_online_mask, 3);		\
+ 	     (cpu) < WORK_CPU_NONE;					\
+ 	     (cpu) = __next_gcwq_cpu((cpu), cpu_online_mask, 3))
+ 
+ #define for_each_cwq_cpu(cpu, wq)					\
+ 	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, (wq));	\
+ 	     (cpu) < WORK_CPU_NONE;					\
+ 	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, (wq)))
+ 
  #ifdef CONFIG_DEBUG_OBJECTS_WORK
  
  static struct debug_obj_descr work_debug_descr;
