Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab1FVWbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:31:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:7472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921Ab1FVWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:31:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,408,1304319600"; 
   d="scan'208";a="21638340"
Message-Id: <20110622222043.958750441@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 22 Jun 2011 15:20:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch 2/4] stop_machine: reorganize stop_cpus() implementation
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=reorganize_stop_cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

Refactor the queuing part of the stop cpus work from __stop_cpus() into
queue_stop_cpus_work().

The reorganization is to help future improvements to stop_machine()
and doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/stop_machine.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/kernel/stop_machine.c
===================================================================
--- linux-2.6-tip.orig/kernel/stop_machine.c
+++ linux-2.6-tip/kernel/stop_machine.c
@@ -136,10 +136,11 @@ DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
-int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+static void queue_stop_cpus_work(const struct cpumask *cpumask,
+				 cpu_stop_fn_t fn, void *arg,
+				 struct cpu_stop_done *done)
 {
 	struct cpu_stop_work *work;
-	struct cpu_stop_done done;
 	unsigned int cpu;
 
 	/* initialize works and done */
@@ -147,9 +148,8 @@ int __stop_cpus(const struct cpumask *cp
 		work = &per_cpu(stop_cpus_work, cpu);
 		work->fn = fn;
 		work->arg = arg;
-		work->done = &done;
+		work->done = done;
 	}
-	cpu_stop_init_done(&done, cpumask_weight(cpumask));
 
 	/*
 	 * Disable preemption while queueing to avoid getting
@@ -161,7 +161,15 @@ int __stop_cpus(const struct cpumask *cp
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
 	preempt_enable();
+}
 
+static int __stop_cpus(const struct cpumask *cpumask,
+		       cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+
+	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+	queue_stop_cpus_work(cpumask, fn, arg, &done);
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }


