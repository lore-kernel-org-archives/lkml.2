Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2JXJv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:51:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2JXJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:51:56 -0400
Date: Wed, 24 Oct 2012 02:50:42 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-8165e145ceb62fc338e099c9b12b3239c83d2f8e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141506.855074415@google.com>
References: <20120823141506.855074415@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Compute load contribution by a group entity
Git-Commit-ID: 8165e145ceb62fc338e099c9b12b3239c83d2f8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:50:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8165e145ceb62fc338e099c9b12b3239c83d2f8e
Gitweb:     http://git.kernel.org/tip/8165e145ceb62fc338e099c9b12b3239c83d2f8e
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:25 +0200

sched: Compute load contribution by a group entity

Unlike task entities who have a fixed weight, group entities instead own a
fraction of their parenting task_group's shares as their contributed weight.

Compute this fraction so that we can correctly account hierarchies and shared
entity nodes.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141506.855074415@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db78822..e20cb26 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1117,22 +1117,43 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 		cfs_rq->tg_load_contrib += tg_contrib;
 	}
 }
+
+static inline void __update_group_entity_contrib(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = group_cfs_rq(se);
+	struct task_group *tg = cfs_rq->tg;
+	u64 contrib;
+
+	contrib = cfs_rq->tg_load_contrib * tg->shares;
+	se->avg.load_avg_contrib = div64_u64(contrib,
+					     atomic64_read(&tg->load_avg) + 1);
+}
 #else
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update) {}
+static inline void __update_group_entity_contrib(struct sched_entity *se) {}
 #endif
 
+static inline void __update_task_entity_contrib(struct sched_entity *se)
+{
+	u32 contrib;
+
+	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
+	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
+	contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.load_avg_contrib = scale_load(contrib);
+}
+
 /* Compute the current contribution to load_avg by se, return any delta */
 static long __update_entity_load_avg_contrib(struct sched_entity *se)
 {
 	long old_contrib = se->avg.load_avg_contrib;
 
-	if (!entity_is_task(se))
-		return 0;
-
-	se->avg.load_avg_contrib = div64_u64(se->avg.runnable_avg_sum *
-					     se->load.weight,
-					     se->avg.runnable_avg_period + 1);
+	if (entity_is_task(se)) {
+		__update_task_entity_contrib(se);
+	} else {
+		__update_group_entity_contrib(se);
+	}
 
 	return se->avg.load_avg_contrib - old_contrib;
 }
