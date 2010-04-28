Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab0D1Ecv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:32:51 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:57985 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0D1Ecc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:32:32 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: [PATCH 6/8] PM: Add suspend blocking work.
Date: Tue, 27 Apr 2010 21:31:57 -0700
Message-Id: <1272429119-12103-7-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1272429119-12103-6-git-send-email-arve@android.com>
References: <1272429119-12103-1-git-send-email-arve@android.com>
 <1272429119-12103-2-git-send-email-arve@android.com>
 <1272429119-12103-3-git-send-email-arve@android.com>
 <1272429119-12103-4-git-send-email-arve@android.com>
 <1272429119-12103-5-git-send-email-arve@android.com>
 <1272429119-12103-6-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow work to be queued that will block suspend while it is pending
or executing. To get the same functionality in the calling code often
requires a separate suspend_blocker for pending and executing work, or
additional state and locking. This implementation does add additional
state and locking, but this can be removed later if we add support for
suspend blocking work to the core workqueue code.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 include/linux/suspend_blocker.h |   67 ++++++++++++++++++++++++
 kernel/power/suspend_blocker.c  |  107 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+), 0 deletions(-)

diff --git a/include/linux/suspend_blocker.h b/include/linux/suspend_blocker.h
index c80764c..bf41a57 100755
--- a/include/linux/suspend_blocker.h
+++ b/include/linux/suspend_blocker.h
@@ -18,6 +18,7 @@
 
 #include <linux/list.h>
 #include <linux/ktime.h>
+#include <linux/workqueue.h>
 
 /**
  * struct suspend_blocker - the basic suspend_blocker structure
@@ -57,6 +58,38 @@ struct suspend_blocker {
 #endif
 };
 
+/**
+ * struct suspend_blocking_work - the basic suspend_blocking_work structure
+ * @work:		Standard work struct.
+ * @suspend_blocker:	Suspend blocker.
+ * @func:		Callback.
+ * @lock:		Spinlock protecting pending and running state.
+ * @active:		Number of cpu workqueues where work is pending or
+ *			callback is running.
+ *
+ * When suspend blocking work is pending or its callback is running it prevents
+ * the system from entering opportunistic suspend.
+ *
+ * The suspend_blocking_work structure must be initialized by
+ * suspend_blocking_work_init().
+ */
+
+struct suspend_blocking_work {
+	struct work_struct work;
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+	struct suspend_blocker suspend_blocker;
+	work_func_t func;
+	spinlock_t lock;
+	int active;
+#endif
+};
+
+static inline struct suspend_blocking_work *to_suspend_blocking_work(
+	struct work_struct *work)
+{
+	return container_of(work, struct suspend_blocking_work, work);
+}
+
 #ifdef CONFIG_OPPORTUNISTIC_SUSPEND
 
 void suspend_blocker_init(struct suspend_blocker *blocker, const char *name);
@@ -66,6 +99,14 @@ void suspend_unblock(struct suspend_blocker *blocker);
 bool suspend_blocker_is_active(struct suspend_blocker *blocker);
 bool suspend_is_blocked(void);
 
+void suspend_blocking_work_init(struct suspend_blocking_work *work,
+				work_func_t func, const char *name);
+void suspend_blocking_work_destroy(struct suspend_blocking_work *work);
+int queue_suspend_blocking_work(struct workqueue_struct *wq,
+				struct suspend_blocking_work *work);
+int schedule_suspend_blocking_work(struct suspend_blocking_work *work);
+int cancel_suspend_blocking_work_sync(struct suspend_blocking_work *work);
+
 #else
 
 static inline void suspend_blocker_init(struct suspend_blocker *blocker,
@@ -77,6 +118,32 @@ static inline bool suspend_blocker_is_active(struct suspend_blocker *bl)
 								{ return 0; }
 static inline bool suspend_is_blocked(void) { return 0; }
 
+static inline void suspend_blocking_work_init(
+	struct suspend_blocking_work *work, work_func_t func, const char *name)
+{
+	INIT_WORK(&work->work, func);
+}
+static inline void suspend_blocking_work_destroy(
+	struct suspend_blocking_work *work)
+{
+	cancel_work_sync(&work->work);
+}
+static inline int queue_suspend_blocking_work(
+	struct workqueue_struct *wq, struct suspend_blocking_work *work)
+{
+	return queue_work(wq, &work->work);
+}
+static inline int schedule_suspend_blocking_work(
+	struct suspend_blocking_work *work)
+{
+	return schedule_work(&work->work);
+}
+static inline int cancel_suspend_blocking_work_sync(
+	struct suspend_blocking_work *work)
+{
+	return cancel_work_sync(&work->work);
+}
+
 #endif
 
 #endif
diff --git a/kernel/power/suspend_blocker.c b/kernel/power/suspend_blocker.c
index 2d43f37..f9c6206 100644
--- a/kernel/power/suspend_blocker.c
+++ b/kernel/power/suspend_blocker.c
@@ -484,3 +484,110 @@ static int __init suspend_block_postcore_init(void)
 
 core_initcall(suspend_block_init);
 postcore_initcall(suspend_block_postcore_init);
+
+static void suspend_blocking_work_complete(struct suspend_blocking_work *work)
+{
+	unsigned long flags;
+
+	WARN_ON(!work->active);
+	spin_lock_irqsave(&work->lock, flags);
+	if (!--work->active)
+		suspend_unblock(&work->suspend_blocker);
+	spin_unlock_irqrestore(&work->lock, flags);
+}
+
+static void suspend_blocking_work_func(struct work_struct *work)
+{
+	struct suspend_blocking_work *sbwork = to_suspend_blocking_work(work);
+
+	sbwork->func(work);
+	suspend_blocking_work_complete(sbwork);
+}
+
+/**
+ * suspend_blocking_work_init - Initialize suspend_blocking_work
+ * @work: The work item in question.
+ * @func: Callback.
+ * @name: Name for suspend blocker.
+ *
+ */
+void suspend_blocking_work_init(struct suspend_blocking_work *work,
+				work_func_t func, const char *name)
+{
+	INIT_WORK(&work->work, suspend_blocking_work_func);
+	suspend_blocker_init(&work->suspend_blocker, name);
+	work->func = func;
+	spin_lock_init(&work->lock);
+	work->active = 0;
+}
+EXPORT_SYMBOL(suspend_blocking_work_init);
+
+/**
+ * cancel_suspend_blocking_work_sync - Cancel suspend_blocking_work
+ * @work: The work item in question
+ */
+int cancel_suspend_blocking_work_sync(struct suspend_blocking_work *work)
+{
+	int ret;
+
+	ret = cancel_work_sync(&work->work);
+	if (ret)
+		suspend_blocking_work_complete(work);
+	return ret;
+}
+EXPORT_SYMBOL(cancel_suspend_blocking_work_sync);
+
+/**
+ * suspend_blocking_work_destroy - Destroy suspend_blocking_work
+ * @work: The work item in question
+ *
+ * If the work was ever queued on more then one workqueue all but the last
+ * workqueue must be flushed before calling suspend_blocking_work_destroy.
+ */
+void suspend_blocking_work_destroy(struct suspend_blocking_work *work)
+{
+	cancel_suspend_blocking_work_sync(work);
+	WARN_ON(work->active);
+	suspend_blocker_destroy(&work->suspend_blocker);
+}
+EXPORT_SYMBOL(suspend_blocking_work_destroy);
+
+/**
+ * queue_suspend_blocking_work - Queue suspend blocking work
+ * @wq:		Workqueue to queue work on.
+ * @work:	The work item in question.
+ */
+int queue_suspend_blocking_work(struct workqueue_struct *wq,
+				struct suspend_blocking_work *work)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&work->lock, flags);
+	suspend_block(&work->suspend_blocker);
+	ret = queue_work(wq, &work->work);
+	if (ret)
+		work->active++;
+	spin_unlock_irqrestore(&work->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(queue_suspend_blocking_work);
+
+/**
+ * schedule_suspend_blocking_work - Queue suspend blocking work
+ * @work:	The work item in question.
+ */
+int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&work->lock, flags);
+	suspend_block(&work->suspend_blocker);
+	ret = schedule_work(&work->work);
+	if (ret)
+		work->active++;
+	spin_unlock_irqrestore(&work->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(schedule_suspend_blocking_work);
-- 
1.6.5.1

