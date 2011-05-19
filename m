Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab1ESJQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1ESJKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/32] GFS2: Make ->write_inode() really write
Date: Thu, 19 May 2011 09:47:01 +0100
Message-Id: <1305794847-3291-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GFS2 ->write_inode function should be more aggressive at writing
back to the filesystem. This adopts the XFS system of returning
-EAGAIN when the writeback has not been completely done. Also, we
now kick off in-place writeback when called with WB_SYNC_NONE,
but we only wait for it and flush the log when WB_SYNC_ALL is
requested.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b9f28e6..d827b93 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -704,7 +704,7 @@ void gfs2_unfreeze_fs(struct gfs2_sbd *sdp)
 /**
  * gfs2_write_inode - Make sure the inode is stable on the disk
  * @inode: The inode
- * @sync: synchronous write flag
+ * @wbc: The writeback control structure
  *
  * Returns: errno
  */
@@ -713,15 +713,16 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct address_space *metamapping = gfs2_glock2aspace(ip->i_gl);
 	struct gfs2_holder gh;
 	struct buffer_head *bh;
 	struct timespec atime;
 	struct gfs2_dinode *di;
-	int ret = 0;
+	int ret = -EAGAIN;
 
-	/* Check this is a "normal" inode, etc */
+	/* Skip timestamp update, if this is from a memalloc */
 	if (current->flags & PF_MEMALLOC)
-		return 0;
+		goto do_flush;
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	if (ret)
 		goto do_flush;
@@ -745,6 +746,11 @@ do_unlock:
 do_flush:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
+	filemap_fdatawrite(metamapping);
+	if (!ret && (wbc->sync_mode == WB_SYNC_ALL))
+		ret = filemap_fdatawait(metamapping);
+	if (ret)
+		mark_inode_dirty_sync(inode);
 	return ret;
 }
 
@@ -874,8 +880,9 @@ restart:
 
 static int gfs2_sync_fs(struct super_block *sb, int wait)
 {
-	if (wait && sb->s_fs_info)
-		gfs2_log_flush(sb->s_fs_info, NULL);
+	struct gfs2_sbd *sdp = sb->s_fs_info;
+	if (wait && sdp)
+		gfs2_log_flush(sdp, NULL);
 	return 0;
 }
 
-- 
1.7.4

