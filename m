Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab1ESJK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933Ab1ESJKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:20 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/32] GFS2: Make writeback more responsive to system conditions
Date: Thu, 19 May 2011 09:47:08 +0100
Message-Id: <1305794847-3291-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds writeback_control to writing back the AIL
list. This means that we can then take advantage of the
information we get in ->write_inode() in order to set off
some pre-emptive writeback.

In addition, the AIL code is cleaned up a bit to make it
a bit simpler to understand.

There is still more which can usefully be done in this area,
but this is a good start at least.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index b5a5e60..fe9945f 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -139,7 +139,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct inode *inode;
 
-	inode = gfs2_ilookup(sb, inum->no_addr);
+	inode = gfs2_ilookup(sb, inum->no_addr, 0);
 	if (inode) {
 		if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
 			iput(inode);
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index cb8776f..eed4b68 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -649,7 +649,7 @@ static void delete_work_func(struct work_struct *work)
 	/* Note: Unsafe to dereference ip as we don't hold right refs/locks */
 
 	if (ip)
-		inode = gfs2_ilookup(sdp->sd_vfs, no_addr);
+		inode = gfs2_ilookup(sdp->sd_vfs, no_addr, 1);
 	else
 		inode = gfs2_lookup_by_inum(sdp, no_addr, NULL, GFS2_BLKST_UNLINKED);
 	if (inode && !IS_ERR(inode)) {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 5067bea..69a6382 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -20,7 +20,6 @@
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
-#define DIO_ALL		0x00000100
 
 struct gfs2_log_operations;
 struct gfs2_log_element;
@@ -377,8 +376,6 @@ struct gfs2_ail {
 	unsigned int ai_first;
 	struct list_head ai_ail1_list;
 	struct list_head ai_ail2_list;
-
-	u64 ai_sync_gen;
 };
 
 struct gfs2_journal_extent {
@@ -657,7 +654,6 @@ struct gfs2_sbd {
 	spinlock_t sd_ail_lock;
 	struct list_head sd_ail1_list;
 	struct list_head sd_ail2_list;
-	u64 sd_ail_sync_gen;
 
 	/* Replay stuff */
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9b7b9e4..94c3a7d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -74,14 +74,14 @@ static int iget_set(struct inode *inode, void *opaque)
 	return 0;
 }
 
-struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr)
+struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr, int non_block)
 {
 	unsigned long hash = (unsigned long)no_addr;
 	struct gfs2_skip_data data;
 
 	data.no_addr = no_addr;
 	data.skipped = 0;
-	data.non_block = 0;
+	data.non_block = non_block;
 	return ilookup5(sb, hash, iget_test, &data);
 }
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 842346e..8d1344a 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -102,7 +102,7 @@ extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,
 extern struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 					 u64 *no_formal_ino,
 					 unsigned int blktype);
-extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
+extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr, int nonblock);
 
 extern int gfs2_inode_refresh(struct gfs2_inode *ip);
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 3ebafa1..03e0041 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -18,6 +18,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/bio.h>
+#include <linux/writeback.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -83,50 +84,90 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 /**
  * gfs2_ail1_start_one - Start I/O on a part of the AIL
  * @sdp: the filesystem
- * @tr: the part of the AIL
+ * @wbc: The writeback control structure
+ * @ai: The ail structure
  *
  */
 
-static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static void gfs2_ail1_start_one(struct gfs2_sbd *sdp,
+				struct writeback_control *wbc,
+				struct gfs2_ail *ai)
 __releases(&sdp->sd_ail_lock)
 __acquires(&sdp->sd_ail_lock)
 {
 	struct gfs2_glock *gl = NULL;
+	struct address_space *mapping;
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
-	int retry;
 
-	do {
-		retry = 0;
+restart:
+	list_for_each_entry_safe_reverse(bd, s, &ai->ai_ail1_list, bd_ail_st_list) {
+		bh = bd->bd_bh;
 
-		list_for_each_entry_safe_reverse(bd, s, &ai->ai_ail1_list,
-						 bd_ail_st_list) {
-			bh = bd->bd_bh;
+		gfs2_assert(sdp, bd->bd_ail == ai);
 
-			gfs2_assert(sdp, bd->bd_ail == ai);
+		if (!buffer_busy(bh)) {
+			if (!buffer_uptodate(bh))
+				gfs2_io_error_bh(sdp, bh);
+			list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
+			continue;
+		}
+
+		if (!buffer_dirty(bh))
+			continue;
+		if (gl == bd->bd_gl)
+			continue;
+		gl = bd->bd_gl;
+		list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+		mapping = bh->b_page->mapping;
+		spin_unlock(&sdp->sd_ail_lock);
+		generic_writepages(mapping, wbc);
+		spin_lock(&sdp->sd_ail_lock);
+		if (wbc->nr_to_write <= 0)
+			break;
+		goto restart;
+	}
+}
 
-			if (!buffer_busy(bh)) {
-				if (!buffer_uptodate(bh))
-					gfs2_io_error_bh(sdp, bh);
-				list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
-				continue;
-			}
 
-			if (!buffer_dirty(bh))
-				continue;
-			if (gl == bd->bd_gl)
-				continue;
-			gl = bd->bd_gl;
-			list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+/**
+ * gfs2_ail1_flush - start writeback of some ail1 entries 
+ * @sdp: The super block
+ * @wbc: The writeback control structure
+ *
+ * Writes back some ail1 entries, according to the limits in the
+ * writeback control structure
+ */
 
-			spin_unlock(&sdp->sd_ail_lock);
-			filemap_fdatawrite(gfs2_glock2aspace(gl));
-			spin_lock(&sdp->sd_ail_lock);
+void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
+{
+	struct list_head *head = &sdp->sd_ail1_list;
+	struct gfs2_ail *ai;
 
-			retry = 1;
+	spin_lock(&sdp->sd_ail_lock);
+	list_for_each_entry_reverse(ai, head, ai_list) {
+		if (wbc->nr_to_write <= 0)
 			break;
-		}
-	} while (retry);
+		gfs2_ail1_start_one(sdp, wbc, ai); /* This may drop ail lock */
+	}
+	spin_unlock(&sdp->sd_ail_lock);
+}
+
+/**
+ * gfs2_ail1_start - start writeback of all ail1 entries
+ * @sdp: The superblock
+ */
+
+static void gfs2_ail1_start(struct gfs2_sbd *sdp)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.nr_to_write = LONG_MAX,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+	};
+
+	return gfs2_ail1_flush(sdp, &wbc);
 }
 
 /**
@@ -136,7 +177,7 @@ __acquires(&sdp->sd_ail_lock)
  *
  */
 
-static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int flags)
+static void gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 {
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
@@ -144,71 +185,37 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int fl
 	list_for_each_entry_safe_reverse(bd, s, &ai->ai_ail1_list,
 					 bd_ail_st_list) {
 		bh = bd->bd_bh;
-
 		gfs2_assert(sdp, bd->bd_ail == ai);
-
-		if (buffer_busy(bh)) {
-			if (flags & DIO_ALL)
-				continue;
-			else
-				break;
-		}
-
+		if (buffer_busy(bh))
+			continue;
 		if (!buffer_uptodate(bh))
 			gfs2_io_error_bh(sdp, bh);
-
 		list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
 	}
 
-	return list_empty(&ai->ai_ail1_list);
 }
 
-static void gfs2_ail1_start(struct gfs2_sbd *sdp)
-{
-	struct list_head *head;
-	u64 sync_gen;
-	struct gfs2_ail *ai;
-	int done = 0;
-
-	spin_lock(&sdp->sd_ail_lock);
-	head = &sdp->sd_ail1_list;
-	if (list_empty(head)) {
-		spin_unlock(&sdp->sd_ail_lock);
-		return;
-	}
-	sync_gen = sdp->sd_ail_sync_gen++;
-
-	while(!done) {
-		done = 1;
-		list_for_each_entry_reverse(ai, head, ai_list) {
-			if (ai->ai_sync_gen >= sync_gen)
-				continue;
-			ai->ai_sync_gen = sync_gen;
-			gfs2_ail1_start_one(sdp, ai); /* This may drop ail lock */
-			done = 0;
-			break;
-		}
-	}
-
-	spin_unlock(&sdp->sd_ail_lock);
-}
+/**
+ * gfs2_ail1_empty - Try to empty the ail1 lists
+ * @sdp: The superblock
+ *
+ * Tries to empty the ail1 lists, starting with the oldest first
+ */
 
-static int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags)
+static int gfs2_ail1_empty(struct gfs2_sbd *sdp)
 {
 	struct gfs2_ail *ai, *s;
 	int ret;
 
 	spin_lock(&sdp->sd_ail_lock);
-
 	list_for_each_entry_safe_reverse(ai, s, &sdp->sd_ail1_list, ai_list) {
-		if (gfs2_ail1_empty_one(sdp, ai, flags))
+		gfs2_ail1_empty_one(sdp, ai);
+		if (list_empty(&ai->ai_ail1_list))
 			list_move(&ai->ai_list, &sdp->sd_ail2_list);
-		else if (!(flags & DIO_ALL))
+		else
 			break;
 	}
-
 	ret = list_empty(&sdp->sd_ail1_list);
-
 	spin_unlock(&sdp->sd_ail_lock);
 
 	return ret;
@@ -569,7 +576,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	set_buffer_uptodate(bh);
 	clear_buffer_dirty(bh);
 
-	gfs2_ail1_empty(sdp, 0);
+	gfs2_ail1_empty(sdp);
 	tail = current_tail(sdp);
 
 	lh = (struct gfs2_log_header *)bh->b_data;
@@ -864,7 +871,7 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 	gfs2_log_flush(sdp, NULL);
 	for (;;) {
 		gfs2_ail1_start(sdp);
-		if (gfs2_ail1_empty(sdp, DIO_ALL))
+		if (gfs2_ail1_empty(sdp))
 			break;
 		msleep(10);
 	}
@@ -900,17 +907,15 @@ int gfs2_logd(void *data)
 
 		preflush = atomic_read(&sdp->sd_log_pinned);
 		if (gfs2_jrnl_flush_reqd(sdp) || t == 0) {
-			gfs2_ail1_empty(sdp, DIO_ALL);
+			gfs2_ail1_empty(sdp);
 			gfs2_log_flush(sdp, NULL);
-			gfs2_ail1_empty(sdp, DIO_ALL);
 		}
 
 		if (gfs2_ail_flush_reqd(sdp)) {
 			gfs2_ail1_start(sdp);
 			io_schedule();
-			gfs2_ail1_empty(sdp, 0);
+			gfs2_ail1_empty(sdp);
 			gfs2_log_flush(sdp, NULL);
-			gfs2_ail1_empty(sdp, DIO_ALL);
 		}
 
 		wake_up(&sdp->sd_log_waitq);
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 0d007f9..ab06216 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -12,6 +12,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/writeback.h>
 #include "incore.h"
 
 /**
@@ -59,6 +60,7 @@ extern struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 extern void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
 extern void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
 extern void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
+extern void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc);
 
 extern void gfs2_log_shutdown(struct gfs2_sbd *sdp);
 extern void gfs2_meta_syncfs(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 215c37b..58fe3a4 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -23,6 +23,7 @@
 #include <linux/time.h>
 #include <linux/wait.h>
 #include <linux/writeback.h>
+#include <linux/backing-dev.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -714,6 +715,7 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct address_space *metamapping = gfs2_glock2aspace(ip->i_gl);
+	struct backing_dev_info *bdi = metamapping->backing_dev_info;
 	struct gfs2_holder gh;
 	struct buffer_head *bh;
 	struct timespec atime;
@@ -747,6 +749,8 @@ do_flush:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
 	filemap_fdatawrite(metamapping);
+	if (bdi->dirty_exceeded)
+		gfs2_ail1_flush(sdp, wbc);
 	if (!ret && (wbc->sync_mode == WB_SYNC_ALL))
 		ret = filemap_fdatawait(metamapping);
 	if (ret)
@@ -1366,7 +1370,8 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out_rindex_relse;
 
-	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA, 1);
+	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA,
+				 sdp->sd_jdesc->jd_blocks);
 	if (error)
 		goto out_rg_gunlock;
 
-- 
1.7.4

