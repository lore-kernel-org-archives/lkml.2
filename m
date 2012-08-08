Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2HHVic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:38:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2HHVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:29 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] workqueue: clean up delayed_work initializers and add missing one
Date: Wed,  8 Aug 2012 14:37:58 -0700
Message-Id: <1344461882-10149-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement delayed_work initializers using new timer initializers
which take timer flags.  This reduces code duplications and will ease
further initializer changes.  This patch also adds a missing
initializer - INIT_DEFERRABLE_WORK_ONSTACK().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   48 +++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 1c1a65b..83755f4 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -133,26 +133,20 @@ struct execute_work {
 	__WORK_INIT_LOCKDEP_MAP(#n, &(n))				\
 	}
 
-#define __DELAYED_WORK_INITIALIZER(n, f) {				\
+#define __DELAYED_WORK_INITIALIZER(n, f, tflags) {			\
 	.work = __WORK_INITIALIZER((n).work, (f)),			\
-	.timer = TIMER_INITIALIZER(delayed_work_timer_fn,		\
-				0, (unsigned long)&(n)),		\
-	}
-
-#define __DEFERRABLE_WORK_INITIALIZER(n, f) {				\
-	.work = __WORK_INITIALIZER((n).work, (f)),			\
-	.timer = TIMER_DEFERRED_INITIALIZER(delayed_work_timer_fn,	\
-				0, (unsigned long)&(n)),		\
+	.timer = __TIMER_INITIALIZER(delayed_work_timer_fn,		\
+			0, (unsigned long)&(n), (tflags)),		\
 	}
 
 #define DECLARE_WORK(n, f)						\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
 #define DECLARE_DELAYED_WORK(n, f)					\
-	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
+	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, 0)
 
 #define DECLARE_DEFERRABLE_WORK(n, f)					\
-	struct delayed_work n = __DEFERRABLE_WORK_INITIALIZER(n, f)
+	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f, TIMER_DEFERRABLE)
 
 /*
  * initialize a work item's function pointer
@@ -216,29 +210,33 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 		__INIT_WORK((_work), (_func), 1);			\
 	} while (0)
 
-#define INIT_DELAYED_WORK(_work, _func)					\
+#define __INIT_DELAYED_WORK(_work, _func, _tflags)			\
 	do {								\
 		INIT_WORK(&(_work)->work, (_func));			\
-		init_timer(&(_work)->timer);				\
-		(_work)->timer.function = delayed_work_timer_fn;	\
-		(_work)->timer.data = (unsigned long)(_work);		\
+		__setup_timer(&(_work)->timer, delayed_work_timer_fn,	\
+			      (unsigned long)(_work), (_tflags));	\
 	} while (0)
 
-#define INIT_DELAYED_WORK_ONSTACK(_work, _func)				\
+#define __INIT_DELAYED_WORK_ONSTACK(_work, _func, _tflags)		\
 	do {								\
 		INIT_WORK_ONSTACK(&(_work)->work, (_func));		\
-		init_timer_on_stack(&(_work)->timer);			\
-		(_work)->timer.function = delayed_work_timer_fn;	\
-		(_work)->timer.data = (unsigned long)(_work);		\
+		__setup_timer_on_stack(&(_work)->timer,			\
+				       delayed_work_timer_fn,		\
+				       (unsigned long)(_work),		\
+				       (_tflags));			\
 	} while (0)
 
+#define INIT_DELAYED_WORK(_work, _func)					\
+	__INIT_DELAYED_WORK(_work, _func, 0)
+
+#define INIT_DELAYED_WORK_ONSTACK(_work, _func)				\
+	__INIT_DELAYED_WORK_ONSTACK(_work, _func, 0)
+
 #define INIT_DEFERRABLE_WORK(_work, _func)				\
-	do {								\
-		INIT_WORK(&(_work)->work, (_func));			\
-		init_timer_deferrable(&(_work)->timer);			\
-		(_work)->timer.function = delayed_work_timer_fn;	\
-		(_work)->timer.data = (unsigned long)(_work);		\
-	} while (0)
+	__INIT_DELAYED_WORK(_work, _func, TIMER_DEFERRABLE)
+
+#define INIT_DEFERRABLE_WORK_ONSTACK(_work, _func)			\
+	__INIT_DELAYED_WORK_ONSTACK(_work, _func, TIMER_DEFERRABLE)
 
 /**
  * work_pending - Find out whether a work item is currently pending
-- 
1.7.7.3

