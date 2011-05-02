Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1EBBXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:23:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1EBBTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=pHM92zFxKPNi2OqD/BNmhfaHYesTL8zvF2MoZdapyM3nApCKiFDwvzA+rpJi2+08O
	wZ2pXBw7UUVj0afa38BRA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 19/19] sched: convert atomic ops in shares update to use atomic64_t ops
Date: Sun,  1 May 2011 18:19:17 -0700
Message-Id: <1304299157-25769-20-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert uses of atomic_t to atomic64_t in shares update calculations. Total
task weight in a tg can overflow the atomic type on 32-bit systems.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c       |    2 +-
 kernel/sched_debug.c |    4 ++--
 kernel/sched_fair.c  |    8 +++-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e131225..af26b3e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -255,7 +255,7 @@ struct task_group {
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
 
-	atomic_t load_weight;
+	atomic64_t load_weight;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index b809651..2d0fff9 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -210,8 +210,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(cfs_rq->load_period));
 	SEQ_printf(m, "  .%-30s: %lld\n", "load_contrib",
 			cfs_rq->load_contribution);
-	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
-			atomic_read(&cfs_rq->tg->load_weight));
+	SEQ_printf(m, "  .%-30s: %ld\n", "load_tg",
+			atomic64_read(&cfs_rq->tg->load_weight));
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f56410..0152410 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -714,8 +714,7 @@ static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
 	load_avg -= cfs_rq->load_contribution;
 
 	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
-		/* TODO: fix atomics for 64-bit additions */
-		atomic_add(load_avg, &tg->load_weight);
+		atomic64_add(load_avg, &tg->load_weight);
 		cfs_rq->load_contribution += load_avg;
 	}
 }
@@ -779,8 +778,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 
 	load = cfs_rq->load.weight;
 
-	/* TODO: fixup atomics to handle u64 in 32-bit */
-	load_weight = atomic_read(&tg->load_weight);
+	load_weight = atomic64_read(&tg->load_weight);
 	load_weight += load;
 	load_weight -= cfs_rq->load_contribution;
 
@@ -1409,7 +1407,7 @@ static s64 effective_load(struct task_group *tg, int cpu, s64 wl, s64 wg)
 		w = se->my_q->load.weight;
 
 		/* use this cpu's instantaneous contribution */
-		lw = atomic_read(&tg->load_weight);
+		lw = atomic64_read(&tg->load_weight);
 		lw -= se->my_q->load_contribution;
 		lw += w + wg;
 
-- 
1.7.3.1

