Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2AXQhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:37:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63859 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2AXQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:37:17 -0500
Subject: [PATCH] sched: Remove sched_switch completely from runqueue
 structure.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 22:33:56 +0600
Message-ID: <1327422836.27181.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't utilize sched_switch field properly for counting context switch numbers. We can remove it.
But, simply removing sched_switch field from sched_stat output will break ABI integrity. So, we make sure 
/proc/sched_stat output remains as it is by hardcoding zero in place of sched_switch field's output and remove
sched_switch from sched_debug output too. And update scheduler-stat documentation accordingly.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..8259b34 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
      1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
+     2) This field is a legacy array expiration count field used in the O(1)
+	scheduler. We kept it for ABI compatibility, but it is always set to zero.
      3) # of times schedule() was called
      4) # of times schedule() left the processor idle
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2a075e1..09acaa1 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -288,7 +288,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 	P(yld_count);
 
-	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..8a2c768 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -462,7 +462,6 @@ struct rq {
 	unsigned int yld_count;
 
 	/* schedule() stats */
-	unsigned int sched_switch;
 	unsigned int sched_count;
 	unsigned int sched_goidle;
 
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 2a581ba..903ffa9e 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -32,9 +32,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);




