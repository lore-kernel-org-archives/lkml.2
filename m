Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1KKODr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:03:47 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:25292 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1KKODq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:03:46 -0500
From: Andrew Vagin <avagin@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: [PATCH] sched: don't call task_group() many times in set_task_rq()
Date: Fri, 11 Nov 2011 17:04:00 +0300
Message-Id: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It improves perfomance, especially if autogroup enabled.

The size of set_task_rq() was 0x180 and now it is 0xa0.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 kernel/sched.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d87c6e5..a740eec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -766,14 +766,18 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
+	struct task_group *tg = task_group(p);
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
+	p->se.cfs_rq = tg->cfs_rq[cpu];
+	p->se.parent = tg->se[cpu];
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
+	p->rt.rt_rq  = tg->rt_rq[cpu];
+	p->rt.parent = tg->rt_se[cpu];
 #endif
 }
 
-- 
1.7.1

