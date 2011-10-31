Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab1JaTFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:05:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44251 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039Ab1JaTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:44 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/17] freezer: implement and use kthread_freezable_should_stop()
Date: Mon, 31 Oct 2011 12:05:15 -0700
Message-Id: <1320087928-32307-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writeback and thinkpad_acpi have been using thaw_process() to prevent
deadlock between the freezer and kthread_stop(); unfortunately, this
is inherently racy - nothing prevents freezing from happening between
thaw_process() and kthread_stop().

This patch implements kthread_freezable_should_stop() which enters
refrigerator if necessary but is guaranteed to return if
kthread_stop() is invoked.  Both thaw_process() users are converted to
use the new function.

Note that this deadlock condition exists for many of freezable
kthreads.  They need to be converted to use the new should_stop or
freezable workqueue.

Tested with synthetic test case.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   15 ++++++---------
 fs/fs-writeback.c                    |    4 +---
 include/linux/freezer.h              |    6 +++---
 include/linux/kthread.h              |    1 +
 kernel/freezer.c                     |    6 ++++--
 kernel/kthread.c                     |   25 +++++++++++++++++++++++++
 mm/backing-dev.c                     |    8 ++------
 7 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7b82868..4b11fc9 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2456,8 +2456,9 @@ static int hotkey_kthread(void *data)
 	u32 poll_mask, event_mask;
 	unsigned int si, so;
 	unsigned long t;
-	unsigned int change_detector, must_reset;
+	unsigned int change_detector;
 	unsigned int poll_freq;
+	bool was_frozen;
 
 	mutex_lock(&hotkey_thread_mutex);
 
@@ -2488,14 +2489,14 @@ static int hotkey_kthread(void *data)
 				t = 100;	/* should never happen... */
 		}
 		t = msleep_interruptible(t);
-		if (unlikely(kthread_should_stop()))
+		if (unlikely(kthread_freezable_should_stop(&was_frozen)))
 			break;
-		must_reset = try_to_freeze();
-		if (t > 0 && !must_reset)
+
+		if (t > 0 && !was_frozen)
 			continue;
 
 		mutex_lock(&hotkey_thread_data_mutex);
-		if (must_reset || hotkey_config_change != change_detector) {
+		if (was_frozen || hotkey_config_change != change_detector) {
 			/* forget old state on thaw or config change */
 			si = so;
 			t = 0;
@@ -2528,10 +2529,6 @@ exit:
 static void hotkey_poll_stop_sync(void)
 {
 	if (tpacpi_hotkey_task) {
-		if (frozen(tpacpi_hotkey_task) ||
-		    freezing(tpacpi_hotkey_task))
-			thaw_process(tpacpi_hotkey_task);
-
 		kthread_stop(tpacpi_hotkey_task);
 		tpacpi_hotkey_task = NULL;
 		mutex_lock(&hotkey_thread_mutex);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 04cf3b9..b36edb8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -922,7 +922,7 @@ int bdi_writeback_thread(void *data)
 
 	trace_writeback_thread_start(bdi);
 
-	while (!kthread_should_stop()) {
+	while (!kthread_freezable_should_stop(NULL)) {
 		/*
 		 * Remove own delayed wake-up timer, since we are already awake
 		 * and we'll take care of the preriodic write-back.
@@ -952,8 +952,6 @@ int bdi_writeback_thread(void *data)
 			 */
 			schedule();
 		}
-
-		try_to_freeze();
 	}
 
 	/* Flush any work that raced with us exiting */
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 984b367..4a73dd2 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -47,7 +47,7 @@ static inline bool should_send_signal(struct task_struct *p)
 /* Takes and releases task alloc lock using task_lock() */
 extern int thaw_process(struct task_struct *p);
 
-extern bool __refrigerator(void);
+extern bool __refrigerator(bool check_kthr_stop);
 extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
@@ -57,7 +57,7 @@ static inline bool try_to_freeze(void)
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
-	return __refrigerator();
+	return __refrigerator(false);
 }
 
 extern bool freeze_task(struct task_struct *p, bool sig_only);
@@ -185,7 +185,7 @@ static inline void set_freeze_flag(struct task_struct *p) {}
 static inline void clear_freeze_flag(struct task_struct *p) {}
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
-static inline bool __refrigerator(void) { return false; }
+static inline bool __refrigerator(bool check_kthr_stop) { return false; }
 static inline int freeze_processes(void) { return -ENOSYS; }
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 1e923e5..6c1903d 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -35,6 +35,7 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
 int kthread_should_stop(void);
+bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
 
 int kthreadd(void *unused);
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 8ab0bdb..57ba75f 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 /*
  * freezing is complete, mark current process as frozen
@@ -23,7 +24,7 @@ static inline void frozen_process(void)
 }
 
 /* Refrigerator is place where frozen processes are stored :-). */
-bool __refrigerator(void)
+bool __refrigerator(bool check_kthr_stop)
 {
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
@@ -50,7 +51,8 @@ bool __refrigerator(void)
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current))
+		if (!frozen(current) ||
+		    (check_kthr_stop && kthread_should_stop()))
 			break;
 		was_frozen = true;
 		schedule();
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4ba7ccc..a6cbeea 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -59,6 +59,31 @@ int kthread_should_stop(void)
 EXPORT_SYMBOL(kthread_should_stop);
 
 /**
+ * kthread_freezable_should_stop - should this freezable kthread return now?
+ * @was_frozen: optional out parameter, indicates whether %current was frozen
+ *
+ * kthread_should_stop() for freezable kthreads, which will enter
+ * refrigerator if necessary.  This function is safe from kthread_stop() /
+ * freezer deadlock and freezable kthreads should use this function instead
+ * of calling try_to_freeze() directly.
+ */
+bool kthread_freezable_should_stop(bool *was_frozen)
+{
+	bool frozen = false;
+
+	might_sleep();
+
+	if (unlikely(freezing(current)))
+		frozen = __refrigerator(true);
+
+	if (was_frozen)
+		*was_frozen = frozen;
+
+	return kthread_should_stop();
+}
+EXPORT_SYMBOL_GPL(kthread_freezable_should_stop);
+
+/**
  * kthread_data - return data value specified on kthread creation
  * @task: kthread task in question
  *
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a87da52..b08460c1 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -598,14 +598,10 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 
 	/*
 	 * Finally, kill the kernel thread. We don't need to be RCU
-	 * safe anymore, since the bdi is gone from visibility. Force
-	 * unfreeze of the thread before calling kthread_stop(), otherwise
-	 * it would never exet if it is currently stuck in the refrigerator.
+	 * safe anymore, since the bdi is gone from visibility.
 	 */
-	if (bdi->wb.task) {
-		thaw_process(bdi->wb.task);
+	if (bdi->wb.task)
 		kthread_stop(bdi->wb.task);
-	}
 }
 
 /*
-- 
1.7.3.1

