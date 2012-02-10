Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab2BJM6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 07:58:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:16694 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2BJM6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 07:58:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105416390"
Date: Fri, 10 Feb 2012 20:47:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] writeback fixes
Message-ID: <20120210124759.GA11381@localhost>
MIME-Version: 1.0
Content-Type: text/PLAIN; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull 4 writeback fixes for

- 1 divide error
- 3 NULL dereference bugs in writeback tracing, when SD card is removed w/o umount

Thanks,
Fengguang

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-fixes

Rabin Vincent (1):
      backing-dev: fix wakeup timer races with bdi_unregister()

Wu Fengguang (3):
      writeback: fix NULL bdi->dev in trace writeback_single_inode
      lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel
      writeback: fix dereferencing NULL bdi->dev on trace_writeback_queue

 fs/fs-writeback.c                |   16 ++++++++--------
 include/linux/proportions.h      |    4 ++++
 include/trace/events/writeback.h |    7 +++++--
 mm/backing-dev.c                 |   23 ++++++++++++++++++-----
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f855916..5b4a936 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -53,14 +53,6 @@ struct wb_writeback_work {
 };
 
 /*
- * Include the creation of the trace points after defining the
- * wb_writeback_work structure so that the definition remains local to this
- * file.
- */
-#define CREATE_TRACE_POINTS
-#include <trace/events/writeback.h>
-
-/*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
 int nr_pdflush_threads;
@@ -92,6 +84,14 @@ static inline struct inode *wb_inode(struct list_head *head)
 	return list_entry(head, struct inode, i_wb_list);
 }
 
+/*
+ * Include the creation of the trace points after defining the
+ * wb_writeback_work structure and inline functions so that the definition
+ * remains local to this file.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/writeback.h>
+
 /* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
 static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
 {
diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index ef35bb7..26a8a4e 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -81,7 +81,11 @@ void prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl)
  * Limit the time part in order to ensure there are some bits left for the
  * cycle counter and fraction multiply.
  */
+#if BITS_PER_LONG == 32
 #define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
+#else
+#define PROP_MAX_SHIFT (BITS_PER_LONG/2)
+#endif
 
 #define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
 #define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 8588a89..5973410 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -47,7 +47,10 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		__field(int, reason)
 	),
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		struct device *dev = bdi->dev;
+		if (!dev)
+			dev = default_backing_dev_info.dev;
+		strncpy(__entry->name, dev_name(dev), 32);
 		__entry->nr_pages = work->nr_pages;
 		__entry->sb_dev = work->sb ? work->sb->s_dev : 0;
 		__entry->sync_mode = work->sync_mode;
@@ -426,7 +429,7 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 
 	TP_fast_assign(
 		strncpy(__entry->name,
-			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+			dev_name(inode_to_bdi(inode)->dev), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7ba8fea..dd8e2aa 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -318,7 +318,7 @@ static void wakeup_timer_fn(unsigned long data)
 	if (bdi->wb.task) {
 		trace_writeback_wake_thread(bdi);
 		wake_up_process(bdi->wb.task);
-	} else {
+	} else if (bdi->dev) {
 		/*
 		 * When bdi tasks are inactive for long time, they are killed.
 		 * In this case we have to wake-up the forker thread which
@@ -584,6 +584,8 @@ EXPORT_SYMBOL(bdi_register_dev);
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	struct task_struct *task;
+
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
@@ -602,8 +604,13 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * Finally, kill the kernel thread. We don't need to be RCU
 	 * safe anymore, since the bdi is gone from visibility.
 	 */
-	if (bdi->wb.task)
-		kthread_stop(bdi->wb.task);
+	spin_lock_bh(&bdi->wb_lock);
+	task = bdi->wb.task;
+	bdi->wb.task = NULL;
+	spin_unlock_bh(&bdi->wb_lock);
+
+	if (task)
+		kthread_stop(task);
 }
 
 /*
@@ -623,7 +630,9 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 
 void bdi_unregister(struct backing_dev_info *bdi)
 {
-	if (bdi->dev) {
+	struct device *dev = bdi->dev;
+
+	if (dev) {
 		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
@@ -632,8 +641,12 @@ void bdi_unregister(struct backing_dev_info *bdi)
 		if (!bdi_cap_flush_forker(bdi))
 			bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
-		device_unregister(bdi->dev);
+
+		spin_lock_bh(&bdi->wb_lock);
 		bdi->dev = NULL;
+		spin_unlock_bh(&bdi->wb_lock);
+
+		device_unregister(dev);
 	}
 }
 EXPORT_SYMBOL(bdi_unregister);
