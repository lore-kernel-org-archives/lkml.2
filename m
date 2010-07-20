Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0GTErI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:47:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46826 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0GTEq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:46:56 -0400
Date: Tue, 20 Jul 2010 14:46:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the workqueues tree with the tip tree
Message-Id: <20100720144653.68d45bad.sfr@canb.auug.org.au>
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
and several commits from the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index 59fef15,aca9472..0000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -68,21 -216,55 +216,70 @@@ struct workqueue_struct 
  #endif
  };
  
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
  #ifdef CONFIG_DEBUG_OBJECTS_WORK
  
  static struct debug_obj_descr work_debug_descr;
