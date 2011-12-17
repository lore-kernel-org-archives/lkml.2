Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab1LQAJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:09:55 -0500
Received: from forward3.mail.yandex.net ([77.88.46.8]:35002 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1LQAJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:09:47 -0500
X-Yandex-Spam: 1
Message-ID: <1324080587.3560.5.camel@hp>
Subject: [PATCH]sched: stop hrtick timer if running task is switching from
 fair scheduling class to another
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Kirill Tkhai <tkhai@yandex.ru>
Date: Sat, 17 Dec 2011 04:09:47 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]sched: stop hrtick timer if running task is switching from fair
scheduling class to another

We have to stop hrtick timer to avoid excess interrupt. Not-fair tasks
are not interested in fair's hrtick.

Kernel tree/version: next-20111216

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 211cdc5..7733ba7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -368,7 +368,7 @@ static struct rq *this_rq_lock(void)
  * rq->lock.
  */
 
-static void hrtick_clear(struct rq *rq)
+void hrtick_clear(struct rq *rq)
 {
 	if (hrtimer_active(&rq->hrtick_timer))
 		hrtimer_cancel(&rq->hrtick_timer);
@@ -480,10 +480,6 @@ static void init_rq_hrtick(struct rq *rq)
 	rq->hrtick_timer.function = hrtick;
 }
 #else	/* CONFIG_SCHED_HRTICK */
-static inline void hrtick_clear(struct rq *rq)
-{
-}
-
 static inline void init_rq_hrtick(struct rq *rq)
 {
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..b083a91 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5271,6 +5271,13 @@ static void switched_from_fair(struct rq *rq,
struct task_struct *p)
 		place_entity(cfs_rq, se, 0);
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
+
+	/*
+	 * Other scheduling classes are not interested in fair's hrtick timer.
+	 */
+	if (task_current(rq, p) && sched_feat(HRTICK))
+		hrtick_clear(rq);
+
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d8d3613..f3c177c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -936,6 +936,8 @@ static inline int hrtick_enabled(struct rq *rq)
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
+void hrtick_clear(struct rq *rq);
+
 void hrtick_start(struct rq *rq, u64 delay);
 
 #else
@@ -945,6 +947,10 @@ static inline int hrtick_enabled(struct rq *rq)
 	return 0;
 }
 
+static inline void hrtick_clear(struct rq *rq)
+{
+}
+
 #endif /* CONFIG_SCHED_HRTICK */
 
 #ifdef CONFIG_SMP


