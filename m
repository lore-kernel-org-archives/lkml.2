Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2JXJ6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:58:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2JXJ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:58:51 -0400
Date: Wed, 24 Oct 2012 02:57:38 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-f4e26b120b9de84cb627bc7361ba43cfdc51341f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141507.422162369@google.com>
References: <20120823141507.422162369@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking
Git-Commit-ID: f4e26b120b9de84cb627bc7361ba43cfdc51341f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:57:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4e26b120b9de84cb627bc7361ba43cfdc51341f
Gitweb:     http://git.kernel.org/tip/f4e26b120b9de84cb627bc7361ba43cfdc51341f
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:31 +0200

sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking

While per-entity load-tracking is generally useful, beyond computing shares
distribution, e.g. runnable based load-balance (in progress), governors,
power-management, etc.

These facilities are not yet consumers of this data.  This may be trivially
reverted when the information is required; but avoid paying the overhead for
calculations we will not use until then.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141507.422162369@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    8 +++++++-
 kernel/sched/core.c   |    7 ++++++-
 kernel/sched/fair.c   |   13 +++++++++++--
 kernel/sched/sched.h  |    9 ++++++++-
 4 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e483ccb..e1581a0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1168,7 +1168,13 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
-#ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	/* Per-entity load-tracking */
 	struct sched_avg	avg;
 #endif
 };
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f268600..5dae0d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1526,7 +1526,12 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6ecf455..3e6a353 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -882,7 +882,8 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_SMP
+/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3174,6 +3175,12 @@ unlock:
 }
 
 /*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
@@ -3196,6 +3203,7 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
+#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -5773,8 +5781,9 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-
+#endif
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0a75a43..5eca173 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -225,6 +225,12 @@ struct cfs_rq {
 #endif
 
 #ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
@@ -234,7 +240,8 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
-
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+/* These always depend on CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u32 tg_runnable_contrib;
 	u64 tg_load_contrib;
