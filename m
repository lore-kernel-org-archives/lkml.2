Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0FFO5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:57:24 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18213 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab0FFOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:26 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 03/16] writeback: lessen sync_supers wakeup count
Date: Sun,  6 Jun 2010 17:50:16 +0300
Message-Id: <1275835829-1478-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:14.0318 (UTC) FILETIME=[FD92EEE0:01CB0587]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'sync_supers' thread wakes up every 5 seconds (by default) and
writes back all super blocks. It keeps waking up even if there
are no dirty super-blocks. For many file-systems the superblock
becomes dirty very rarely, if ever, so 'sync_supers' does not do
anything most of the time.

This patch improves 'sync_supers' and makes it sleep if all superblocks
are clean and there is nothing to do. This helps saving the power.
This optimization is important for small battery-powered devices.

The locking scheme was provided by Nick Piggin <npiggin@suse.de>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |    5 +----
 mm/backing-dev.c   |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1688464..ca1e993 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1783,10 +1783,7 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	struct vfsmount *mnt);
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 
-static inline void sb_mark_dirty(struct super_block *sb)
-{
-	sb->s_dirty = 1;
-}
+void sb_mark_dirty(struct super_block *sb);
 static inline void sb_mark_clean(struct super_block *sb)
 {
 	sb->s_dirty = 0;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 660a87a..d751284 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -45,6 +45,7 @@ LIST_HEAD(bdi_pending_list);
 
 static struct task_struct *sync_supers_tsk;
 static struct timer_list sync_supers_timer;
+static unsigned long supers_dirty __read_mostly;
 
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
@@ -251,7 +252,6 @@ static int __init default_bdi_init(void)
 
 	init_timer(&sync_supers_timer);
 	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
-	bdi_arm_supers_timer();
 
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
@@ -350,6 +350,21 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 	writeback_inodes_wbc(&wbc);
 }
 
+void sb_mark_dirty(struct super_block *sb)
+{
+	sb->s_dirty = 1;
+	/*
+	 * sb->s_dirty store must be visible to sync_supers before we load
+	 * supers_dirty in case we need to re-arm the timer.
+	 */
+	smp_mb();
+	if (likely(supers_dirty))
+		return;
+	supers_dirty = 1;
+	bdi_arm_supers_timer();
+}
+EXPORT_SYMBOL_GPL(sb_mark_dirty);
+
 /*
  * kupdated() used to do this. We cannot do it from the bdi_forker_task()
  * or we risk deadlocking on ->s_umount. The longer term solution would be
@@ -362,10 +377,20 @@ static int bdi_sync_supers(void *unused)
 
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (supers_dirty)
+			bdi_arm_supers_timer();
 		schedule();
 
+		supers_dirty = 0;
 		/*
-		 * Do this periodically, like kupdated() did before.
+		 * supers_dirty store must be visible to sb_mark_dirty() before
+		 * sync_supers runs (which loads ->s_dirty), so a barrier is
+		 * needed.
+		 */
+		smp_mb();
+		/*
+		 * sync_supers() used to do this periodically, but now we
+		 * wake up only if there are dirty superblocks.
 		 */
 		sync_supers();
 	}
@@ -373,6 +398,11 @@ static int bdi_sync_supers(void *unused)
 	return 0;
 }
 
+static void sync_supers_timer_fn(unsigned long unused)
+{
+	wake_up_process(sync_supers_tsk);
+}
+
 void bdi_arm_supers_timer(void)
 {
 	unsigned long next;
@@ -384,12 +414,6 @@ void bdi_arm_supers_timer(void)
 	mod_timer(&sync_supers_timer, round_jiffies_up(next));
 }
 
-static void sync_supers_timer_fn(unsigned long unused)
-{
-	wake_up_process(sync_supers_tsk);
-	bdi_arm_supers_timer();
-}
-
 static int bdi_forker_task(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
-- 
1.7.0.1

