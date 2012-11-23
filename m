Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2KWMNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:13:42 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43306 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2KWMNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:13:36 -0500
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [RFC/PATCH] ubi: Replace wear leveling thread with a workqueue
Date: Fri, 23 Nov 2012 09:13:29 -0300
Message-Id: <1353672809-4768-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since workqueues are both cheaper and easier to use we
should prefer them, unless there's a strong reason to
prefer threads instead.

This patch replaces the background wear leveling thread
with a workqueue (one per device).
This is different from having one thread per device
because each new workqueue doesn't create a new thread.
However, wear leveling being a background task,
responsiveness is not the primary goal.

As an added benefit, the ubi_thread has been replaced by a
much simpler workqueue worker ubi_wl_do_work.
Some variables are renamed to make sense with the new
workqueue usage, except for the debugfs related ones
so to maintain userspace the same.

Due to lack of real hardware, tests have been performed on
an emulated environment on nandsim devices, using ubifs.

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/mtd/ubi/build.c |   30 +++++++-----------
 drivers/mtd/ubi/ubi.h   |   20 ++++++-----
 drivers/mtd/ubi/wl.c    |   79 +++++++++++++++--------------------------------
 3 files changed, 48 insertions(+), 81 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index fb59604..2342aea 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -38,7 +38,7 @@
 #include <linux/miscdevice.h>
 #include <linux/mtd/partitions.h>
 #include <linux/log2.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include "ubi.h"
@@ -373,7 +373,7 @@ static ssize_t dev_attribute_show(struct device *dev,
 	else if (attr == &dev_min_io_size)
 		ret = sprintf(buf, "%d\n", ubi->min_io_size);
 	else if (attr == &dev_bgt_enabled)
-		ret = sprintf(buf, "%d\n", ubi->thread_enabled);
+		ret = sprintf(buf, "%d\n", ubi->wq_enabled);
 	else if (attr == &dev_mtd_num)
 		ret = sprintf(buf, "%d\n", ubi->mtd->index);
 	else
@@ -1009,11 +1009,11 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	if (err)
 		goto out_uif;
 
-	ubi->bgt_thread = kthread_create(ubi_thread, ubi, ubi->bgt_name);
-	if (IS_ERR(ubi->bgt_thread)) {
-		err = PTR_ERR(ubi->bgt_thread);
-		ubi_err("cannot spawn \"%s\", error %d", ubi->bgt_name,
-			err);
+	ubi->workqueue = alloc_workqueue(ubi->wq_name, 0, 0);
+	if (!ubi->workqueue) {
+		err = -ENOMEM;
+		ubi_err("cannot create workqueue \"%s\", error %d",
+			 ubi->wq_name, err);
 		goto out_debugfs;
 	}
 
@@ -1036,14 +1036,8 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	ubi_msg("available PEBs: %d, total reserved PEBs: %d, PEBs reserved for bad PEB handling: %d",
 		ubi->avail_pebs, ubi->rsvd_pebs, ubi->beb_rsvd_pebs);
 
-	/*
-	 * The below lock makes sure we do not race with 'ubi_thread()' which
-	 * checks @ubi->thread_enabled. Otherwise we may fail to wake it up.
-	 */
-	spin_lock(&ubi->wl_lock);
-	ubi->thread_enabled = 1;
-	wake_up_process(ubi->bgt_thread);
-	spin_unlock(&ubi->wl_lock);
+	ubi->wq_enabled = 1;
+	INIT_WORK(&ubi->work, ubi_wl_do_work);
 
 	ubi_devices[ubi_num] = ubi;
 	ubi_notify_all(ubi, UBI_VOLUME_ADDED, NULL);
@@ -1119,11 +1113,11 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi_update_fastmap(ubi);
 #endif
 	/*
-	 * Before freeing anything, we have to stop the background thread to
+	 * Before freeing anything, we have to stop the background workqueue to
 	 * prevent it from doing anything on this device while we are freeing.
 	 */
-	if (ubi->bgt_thread)
-		kthread_stop(ubi->bgt_thread);
+	if (ubi->workqueue)
+		destroy_workqueue(ubi->workqueue);
 
 	/*
 	 * Get a reference to the device in order to prevent 'dev_release()'
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7d57469..e1888f6 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -59,8 +59,8 @@
 #define ubi_err(fmt, ...) pr_err("UBI error: %s: " fmt "\n",      \
 				 __func__, ##__VA_ARGS__)
 
-/* Background thread name pattern */
-#define UBI_BGT_NAME_PATTERN "ubi_bgt%dd"
+/* Background workqueue name pattern */
+#define UBI_WQ_NAME_PATTERN "ubi_workqueue%dd"
 
 /*
  * This marker in the EBA table means that the LEB is um-mapped.
@@ -411,9 +411,10 @@ struct ubi_wl_entry;
  * @move_to_put: if the "to" PEB was put
  * @works: list of pending works
  * @works_count: count of pending works
- * @bgt_thread: background thread description object
- * @thread_enabled: if the background thread is enabled
- * @bgt_name: background thread name
+ * @workqueue: background workqueue
+ * @work: background work item
+ * @wq_enabled: if the background workqueue is enabled
+ * @wq_name: background workqueue name
  *
  * @flash_size: underlying MTD device size (in bytes)
  * @peb_count: count of physical eraseblocks on the MTD device
@@ -513,9 +514,10 @@ struct ubi_device {
 	int move_to_put;
 	struct list_head works;
 	int works_count;
-	struct task_struct *bgt_thread;
-	int thread_enabled;
-	char bgt_name[sizeof(UBI_BGT_NAME_PATTERN)+2];
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+	int wq_enabled;
+	char wq_name[sizeof(UBI_WQ_NAME_PATTERN)+2];
 
 	/* I/O sub-system's stuff */
 	long long flash_size;
@@ -772,7 +774,7 @@ int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
 void ubi_wl_close(struct ubi_device *ubi);
-int ubi_thread(void *u);
+void ubi_wl_do_work(struct work_struct *work);
 struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor);
 int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e,
 		      int lnum, int torture);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index ae95517..3b98751 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -33,7 +33,7 @@
  *
  * When physical eraseblocks are returned to the WL sub-system by means of the
  * 'ubi_wl_put_peb()' function, they are scheduled for erasure. The erasure is
- * done asynchronously in context of the per-UBI device background thread,
+ * done asynchronously in context of the per-UBI device background workqueue,
  * which is also managed by the WL sub-system.
  *
  * The wear-leveling is ensured by means of moving the contents of used
@@ -101,7 +101,7 @@
 #include <linux/slab.h>
 #include <linux/crc32.h>
 #include <linux/freezer.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include "ubi.h"
 
 /* Number of physical eraseblocks reserved for wear-leveling purposes */
@@ -129,7 +129,7 @@
 #define WL_FREE_MAX_DIFF (2*UBI_WL_THRESHOLD)
 
 /*
- * Maximum number of consecutive background thread failures which is enough to
+ * Maximum number of consecutive workqueue failures which is enough to
  * switch to read-only mode.
  */
 #define WL_MAX_FAILURES 32
@@ -264,7 +264,7 @@ static int do_work(struct ubi_device *ubi)
  * @ubi: UBI device description object
  *
  * This function tries to make a free PEB by means of synchronous execution of
- * pending works. This may be needed if, for example the background thread is
+ * pending works. This may be needed if, for example the background workqueue is
  * disabled. Returns zero in case of success and a negative error code in case
  * of failure.
  */
@@ -836,8 +836,8 @@ static void __schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 	list_add_tail(&wrk->list, &ubi->works);
 	ubi_assert(ubi->works_count >= 0);
 	ubi->works_count += 1;
-	if (ubi->thread_enabled && !ubi_dbg_is_bgt_disabled(ubi))
-		wake_up_process(ubi->bgt_thread);
+	if (ubi->wq_enabled && !ubi_dbg_is_bgt_disabled(ubi))
+		queue_work(ubi->workqueue, &ubi->work);
 	spin_unlock(&ubi->wl_lock);
 }
 
@@ -1777,60 +1777,31 @@ static void tree_destroy(struct rb_root *root)
 }
 
 /**
- * ubi_thread - UBI background thread.
+ * ubi_wl_do_work - UBI background wl worker function.
  * @u: the UBI device description object pointer
  */
-int ubi_thread(void *u)
+void ubi_wl_do_work(struct work_struct *work)
 {
+	int err;
 	int failures = 0;
-	struct ubi_device *ubi = u;
-
-	ubi_msg("background thread \"%s\" started, PID %d",
-		ubi->bgt_name, task_pid_nr(current));
-
-	set_freezable();
-	for (;;) {
-		int err;
-
-		if (kthread_should_stop())
-			break;
+	struct ubi_device *ubi = container_of(work, struct ubi_device, work);
 
-		if (try_to_freeze())
-			continue;
-
-		spin_lock(&ubi->wl_lock);
-		if (list_empty(&ubi->works) || ubi->ro_mode ||
-		    !ubi->thread_enabled || ubi_dbg_is_bgt_disabled(ubi)) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock(&ubi->wl_lock);
-			schedule();
-			continue;
-		}
-		spin_unlock(&ubi->wl_lock);
+	err = do_work(ubi);
+	if (!err)
+		return;
 
-		err = do_work(ubi);
-		if (err) {
-			ubi_err("%s: work failed with error code %d",
-				ubi->bgt_name, err);
-			if (failures++ > WL_MAX_FAILURES) {
-				/*
-				 * Too many failures, disable the thread and
-				 * switch to read-only mode.
-				 */
-				ubi_msg("%s: %d consecutive failures",
-					ubi->bgt_name, WL_MAX_FAILURES);
-				ubi_ro_mode(ubi);
-				ubi->thread_enabled = 0;
-				continue;
-			}
-		} else
-			failures = 0;
-
-		cond_resched();
+	ubi_err("%s: work failed with error code %d",
+		ubi->wq_name, err);
+	if (failures++ > WL_MAX_FAILURES) {
+		/*
+		 * Too many failures, disable the workqueue and
+		 * switch to read-only mode.
+		 */
+		ubi_msg("%s: %d consecutive failures, switching to read-only",
+			ubi->wq_name, WL_MAX_FAILURES);
+		ubi_ro_mode(ubi);
+		ubi->wq_enabled = 0;
 	}
-
-	dbg_wl("background thread \"%s\" is killed", ubi->bgt_name);
-	return 0;
 }
 
 /**
@@ -1876,7 +1847,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	INIT_WORK(&ubi->fm_work, update_fastmap_work_fn);
 #endif
 
-	sprintf(ubi->bgt_name, UBI_BGT_NAME_PATTERN, ubi->ubi_num);
+	sprintf(ubi->wq_name, UBI_WQ_NAME_PATTERN, ubi->ubi_num);
 
 	err = -ENOMEM;
 	ubi->lookuptbl = kzalloc(ubi->peb_count * sizeof(void *), GFP_KERNEL);
-- 
1.7.8.6

