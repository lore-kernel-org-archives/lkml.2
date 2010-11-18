Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0KRTVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:21:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36921 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0KRTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:21:12 -0500
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, Milton Miller <miltonm@bga.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] print_cfq_rq: per_cpu(xx, 0) may not exist
Date: Thu, 18 Nov 2010 04:23:14 -0600
Message-Id: <1290075796-2975-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
X-Xagent-From: sonnyrao@linux.vnet.ibm.com
X-Xagent-To: sonnyrao@linux.vnet.ibm.com
X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGENTU2 at VMSDVMA)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per cpu variables only exist for possible cpus.  On some architectures
and platforms, cpu 0 may not be possible, and this debug code generates
an oops.

As a variable for the boot cpu seems to be architecture dependent, replace
this aparently arbitrary choice of reference for spread of min vruntime
across run queues from that of cpu 0 to that of the first online cpu.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
 kernel/sched_debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..be586db 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -163,7 +163,7 @@ static void task_group_path(struct task_group *tg, char *buf, int buflen)
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
-		spread, rq0_min_vruntime, spread0;
+		spread, spread0;
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_entity *last;
 	unsigned long flags;
@@ -188,7 +188,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (last)
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
-	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
@@ -199,7 +198,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	spread = max_vruntime - MIN_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread",
 			SPLIT_NS(spread));
-	spread0 = min_vruntime - rq0_min_vruntime;
+	spread0 = min_vruntime - per_cpu(runqueues,
+			cpumask_first(cpu_online_mask)).cfs.min_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
-- 
1.5.6.5

