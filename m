Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0DWBKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:10:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46142 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab0DWBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:10:17 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>, Tejun Heo <tj@kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/9] PM: Add suspend blocking work.
Date: Thu, 22 Apr 2010 18:08:56 -0700
Message-Id: <1271984938-13920-8-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1271984938-13920-7-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <1271984938-13920-4-git-send-email-arve@android.com>
 <1271984938-13920-5-git-send-email-arve@android.com>
 <1271984938-13920-6-git-send-email-arve@android.com>
 <1271984938-13920-7-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow work to be queued that will block suspend while it is pending
or executing. To get the same functionality in the calling code often
requires a separate suspend_blocker for pending and executing work, or
additional state and locking.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 include/linux/workqueue.h |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/workqueue.c        |   19 +++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 9466e86..9c5a078 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
+#include <linux/suspend_blocker.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
@@ -26,7 +27,8 @@ struct work_struct {
 	atomic_long_t data;
 #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
 #define WORK_STRUCT_STATIC  1		/* static initializer (debugobjects) */
-#define WORK_STRUCT_FLAG_MASK (3UL)
+#define WORK_STRUCT_SUSPEND_BLOCKING  2	/* suspend blocking work */
+#define WORK_STRUCT_FLAG_MASK (7UL)
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
@@ -48,6 +50,23 @@ static inline struct delayed_work *to_delayed_work(struct work_struct *work)
 	return container_of(work, struct delayed_work, work);
 }
 
+struct suspend_blocking_work {
+	struct work_struct work;
+	struct suspend_blocker suspend_blocker;
+};
+
+static inline struct suspend_blocking_work *
+to_suspend_blocking_work(struct work_struct *work)
+{
+	return container_of(work, struct suspend_blocking_work, work);
+}
+
+static inline struct suspend_blocker *
+work_to_suspend_blocker(struct work_struct *work)
+{
+	return &to_suspend_blocking_work(work)->suspend_blocker;
+}
+
 struct execute_work {
 	struct work_struct work;
 };
@@ -157,6 +176,30 @@ static inline void destroy_work_on_stack(struct work_struct *work) { }
 		init_timer_deferrable(&(_work)->timer);		\
 	} while (0)
 
+static inline void suspend_blocking_work_init(
+	struct suspend_blocking_work *work, work_func_t func, const char *name)
+{
+	INIT_WORK(&work->work, func);
+	suspend_blocker_init(&work->suspend_blocker, name);
+	set_bit(WORK_STRUCT_SUSPEND_BLOCKING, work_data_bits(&work->work));
+}
+
+/**
+ * suspend_blocking_work_destroy - Destroy suspend_blocking_work
+ * @work: The work item in question
+ *
+ * If the work was ever queued on more then one workqueue or on a multithreaded
+ * workqueue all these workqueues must be flushed before calling
+ * suspend_blocking_work_destroy. If only a single singlethreaded workqueue
+ * was used flush_work or cancel_work_sync can be used instead.
+ */
+
+static inline void
+suspend_blocking_work_destroy(struct suspend_blocking_work *work)
+{
+	suspend_blocker_destroy(&work->suspend_blocker);
+}
+
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dee4865..b2aba90 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -68,6 +68,15 @@ struct workqueue_struct {
 #endif
 };
 
+static inline int work_blocks_suspend(struct work_struct *work)
+{
+#ifdef CONFIG_SUSPEND_BLOCKERS
+	return test_bit(WORK_STRUCT_SUSPEND_BLOCKING, work_data_bits(work));
+#else
+	return false;
+#endif
+}
+
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
 static struct debug_obj_descr work_debug_descr;
@@ -257,6 +266,10 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
 
 	debug_work_activate(work);
 	spin_lock_irqsave(&cwq->lock, flags);
+
+	if (work_blocks_suspend(work))
+		suspend_block(work_to_suspend_blocker(work));
+
 	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
@@ -379,6 +392,7 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
 		work_func_t f = work->func;
+		bool current_work_blocks_suspend = work_blocks_suspend(work);
 #ifdef CONFIG_LOCKDEP
 		/*
 		 * It is permissible to free the struct work_struct
@@ -416,6 +430,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		}
 
 		spin_lock_irq(&cwq->lock);
+		if (current_work_blocks_suspend &&
+		    (get_wq_data(work) == cwq) && !work_pending(work))
+			suspend_unblock(work_to_suspend_blocker(work));
 		cwq->current_work = NULL;
 	}
 	spin_unlock_irq(&cwq->lock);
@@ -671,6 +688,8 @@ static int __cancel_work_timer(struct work_struct *work,
 		wait_on_work(work);
 	} while (unlikely(ret < 0));
 
+	if (work_blocks_suspend(work))
+		suspend_unblock(work_to_suspend_blocker(work));
 	work_clear_pending(work);
 	return ret;
 }
-- 
1.6.5.1

