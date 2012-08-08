Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2HHVjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:39:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59303 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2HHVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:36 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] workqueue: reimplement cancel_delayed_work() using try_to_grab_pending()
Date: Wed,  8 Aug 2012 14:38:01 -0700
Message-Id: <1344461882-10149-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cancel_delayed_work() can't be called from IRQ handlers due to its use
of del_timer_sync() and can't cancel work items which are already
transferred from timer to worklist.

Also, unlike other flush and cancel functions, a canceled delayed_work
would still point to the last associated cpu_workqueue.  If the
workqueue is destroyed afterwards and the work item is re-used on a
different workqueue, the queueing code can oops trying to dereference
already freed cpu_workqueue.

This patch reimplements cancel_delayed_work() using
try_to_grab_pending() and set_work_cpu_and_clear_pending().  This
allows the function to be called from IRQ handlers and makes its
behavior consistent with other flush / cancel functions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/workqueue.h |   17 +----------------
 kernel/workqueue.c        |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 093968e..6306157 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -417,6 +417,7 @@ extern bool cancel_work_sync(struct work_struct *work);
 
 extern bool flush_delayed_work(struct delayed_work *dwork);
 extern bool flush_delayed_work_sync(struct delayed_work *work);
+extern bool cancel_delayed_work(struct delayed_work *dwork);
 extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
@@ -426,22 +427,6 @@ extern unsigned int work_cpu(struct work_struct *work);
 extern unsigned int work_busy(struct work_struct *work);
 
 /*
- * Kill off a pending schedule_delayed_work().  Note that the work callback
- * function may still be running on return from cancel_delayed_work(), unless
- * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
- * cancel_work_sync() to wait on it.
- */
-static inline bool cancel_delayed_work(struct delayed_work *work)
-{
-	bool ret;
-
-	ret = del_timer_sync(&work->timer);
-	if (ret)
-		work_clear_pending(&work->work);
-	return ret;
-}
-
-/*
  * Like above, but uses del_timer() instead of del_timer_sync(). This means,
  * if it returns 0 the timer function may be running and the queueing is in
  * progress.
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9087599..7413242 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3031,6 +3031,36 @@ bool flush_delayed_work_sync(struct delayed_work *dwork)
 EXPORT_SYMBOL(flush_delayed_work_sync);
 
 /**
+ * cancel_delayed_work - cancel a delayed work
+ * @dwork: delayed_work to cancel
+ *
+ * Kill off a pending delayed_work.  Returns %true if @dwork was pending
+ * and canceled; %false if wasn't pending.  Note that the work callback
+ * function may still be running on return, unless it returns %true and the
+ * work doesn't re-arm itself.  Explicitly flush or use cancel_work_sync()
+ * to wait on it.
+ *
+ * This function is safe to call from any context including IRQ handler.
+ */
+bool cancel_delayed_work(struct delayed_work *dwork)
+{
+	unsigned long flags;
+	int ret;
+
+	do {
+		ret = try_to_grab_pending(&dwork->work, true, &flags);
+	} while (unlikely(ret == -EAGAIN));
+
+	if (unlikely(ret < 0))
+		return false;
+
+	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
+	local_irq_restore(flags);
+	return true;
+}
+EXPORT_SYMBOL(cancel_delayed_work);
+
+/**
  * cancel_delayed_work_sync - cancel a delayed work and wait for it to finish
  * @dwork: the delayed work cancel
  *
-- 
1.7.7.3

