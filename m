Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1E1Qe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:34:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:32782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab1E1Qez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:34:55 -0400
Date: Sat, 28 May 2011 16:34:36 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Message-ID: <tip-cd4ae6adf8b1c21d88e83ed56afeeef97b28f356@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dfeng@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dfeng@redhat.com,
        mingo@elte.hu
In-Reply-To: <1303469634-11678-1-git-send-email-dfeng@redhat.com>
References: <1303469634-11678-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: More sched_domain iterations fixes
Git-Commit-ID: cd4ae6adf8b1c21d88e83ed56afeeef97b28f356
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:34:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd4ae6adf8b1c21d88e83ed56afeeef97b28f356
Gitweb:     http://git.kernel.org/tip/cd4ae6adf8b1c21d88e83ed56afeeef97b28f356
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Fri, 22 Apr 2011 18:53:54 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 17:02:54 +0200

sched: More sched_domain iterations fixes

sched_domain iterations needs to be protected by rcu_read_lock() now,
this patch adds another two places which needs the rcu lock, which is
spotted by following suspicious rcu_dereference_check() usage warnings.

kernel/sched_rt.c:1244 invoked rcu_dereference_check() without protection!
kernel/sched_stats.h:41 invoked rcu_dereference_check() without protection!

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1303469634-11678-1-git-send-email-dfeng@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c    |   10 ++++++++--
 kernel/sched_stats.h |    4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 64b2a37..88725c9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1263,6 +1263,7 @@ static int find_lowest_rq(struct task_struct *task)
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
 			int best_cpu;
@@ -1272,15 +1273,20 @@ static int find_lowest_rq(struct task_struct *task)
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
