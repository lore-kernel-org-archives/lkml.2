Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1DTUwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab1DTUwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=D6YvtG76ru/9dCO9G6ZeRCCCrR/MY+BuivPn4bCuJ/9Fv7q3keVze4MGIj0PF3KVv
	W66fWe9xuLy85385n4kWQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 18/18] sched: update shares distribution to use u64
Date: Wed, 20 Apr 2011 13:51:37 -0700
Message-Id: <1303332697-16426-19-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the shares distribution code to use u64. We still maintain tg->shares as
an unsigned long since sched entity weights can't exceed MAX_SHARES (2^28). This
patch updates all the calculations required to estimate shares to use u64.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c       |    2 +-
 kernel/sched_debug.c |    6 +++---
 kernel/sched_fair.c  |   13 ++++++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c1f3fc..a9e85a0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -367,7 +367,7 @@ struct cfs_rq {
 	u64 load_period;
 	u64 load_stamp, load_last, load_unacc_exec_time;
 
-	unsigned long load_contribution;
+	u64 load_contribution;
 #endif
 #endif
 };
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index d22b666..b809651 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -204,11 +204,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %lld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_avg",
+	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", "load_avg",
 			SPLIT_NS(cfs_rq->load_avg));
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_period",
+	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", "load_period",
 			SPLIT_NS(cfs_rq->load_period));
-	SEQ_printf(m, "  .%-30s: %ld\n", "load_contrib",
+	SEQ_printf(m, "  .%-30s: %lld\n", "load_contrib",
 			cfs_rq->load_contribution);
 	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
 			atomic_read(&cfs_rq->tg->load_weight));
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 33c36f1..6808f26 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -708,12 +708,13 @@ static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
 					    int global_update)
 {
 	struct task_group *tg = cfs_rq->tg;
-	long load_avg;
+	s64 load_avg;
 
 	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
 
 	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
+		/* TODO: fix atomics for 64-bit additions */
 		atomic_add(load_avg, &tg->load_weight);
 		cfs_rq->load_contribution += load_avg;
 	}
@@ -723,7 +724,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 	u64 period = sysctl_sched_shares_window;
 	u64 now, delta;
-	unsigned long load = cfs_rq->load.weight;
+	u64 load = cfs_rq->load.weight;
 
 	if (cfs_rq->tg == &root_task_group)
 		return;
@@ -745,6 +746,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	if (load) {
 		cfs_rq->load_last = now;
 		cfs_rq->load_avg += delta * load;
+		/* TODO: detect overflow and fix */
 	}
 
 	/* consider updating load contribution on each fold or truncate */
@@ -769,24 +771,25 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 
 static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
-	long load_weight, load, shares;
+	s64 load_weight, load, shares;
 
 	load = cfs_rq->load.weight;
 
+	/* TODO: fixup atomics to handle u64 in 32-bit */
 	load_weight = atomic_read(&tg->load_weight);
 	load_weight += load;
 	load_weight -= cfs_rq->load_contribution;
 
 	shares = (tg->shares * load);
 	if (load_weight)
-		shares /= load_weight;
+		shares = div64_u64(shares, load_weight);
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
 	if (shares > tg->shares)
 		shares = tg->shares;
 
-	return shares;
+	return (long)shares;
 }
 
 static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-- 
1.7.3.1

