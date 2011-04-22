Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1DVKyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 06:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab1DVKyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 06:54:20 -0400
From: Xiaotian feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -tip v2] sched: more sched_domain iterations fix
Date: Fri, 22 Apr 2011 18:53:54 +0800
Message-Id: <1303469634-11678-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1303384893.2035.73.camel@laptop>
References: <1303384893.2035.73.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

sched_domain iterations needs to be protected by rcu_read_lock() now,
this patch adds another two places which needs the rcu lock, which is
spotted by following suspicious rcu_dereference_check() usage warnings.

kernel/sched_rt.c:1244 invoked rcu_dereference_check() without protection!
kernel/sched_stats.h:41 invoked rcu_dereference_check() without protection!

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_rt.c    |   10 ++++++++--
 kernel/sched_stats.h |    4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 19ecb31..46a9533 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1241,6 +1241,7 @@ static int find_lowest_rq(struct task_struct *task)
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
 			int best_cpu;
@@ -1250,15 +1251,20 @@ static int find_lowest_rq(struct task_struct *task)
 			 * remote processor.
 			 */
 			if (this_cpu != -1 &&
-			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd))) {
+				rcu_read_unlock();
 				return this_cpu;
+			}
 
 			best_cpu = cpumask_first_and(lowest_mask,
 						     sched_domain_span(sd));
-			if (best_cpu < nr_cpu_ids)
+			if (best_cpu < nr_cpu_ids) {
+				rcu_read_unlock();
 				return best_cpu;
+			}
 		}
 	}
+	rcu_read_unlock();
 
 	/*
 	 * And finally, if there were no matches within the domains
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 48ddf43..331e01b 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -37,7 +37,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 #ifdef CONFIG_SMP
 		/* domain-specific stats */
-		preempt_disable();
+		rcu_read_lock();
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
@@ -64,7 +64,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
 			    sd->ttwu_move_balance);
 		}
-		preempt_enable();
+		rcu_read_unlock();
 #endif
 	}
 	kfree(mask_str);
-- 
1.7.1

