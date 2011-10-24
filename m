Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1JXMxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab1JXMr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:28 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/24] GFS2: Split data write & wait in fsync
Date: Mon, 24 Oct 2011 13:48:16 +0100
Message-Id: <1319460518-9046-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the data writing is part of fsync proper, we can split
the waiting part out and do it later on. This reduces the
number of waits that we do during fsync on average.

There is also no need to take the i_mutex unless we are flushing
metadata to disk, so we can move that to within the metadata
flushing code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index edeb9e8..92c3db4 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -551,8 +551,16 @@ static int gfs2_close(struct inode *inode, struct file *file)
  * @end: the end position in the file to sync
  * @datasync: set if we can ignore timestamp changes
  *
- * The VFS will flush data for us. We only need to worry
- * about metadata here.
+ * We split the data flushing here so that we don't wait for the data
+ * until after we've also sent the metadata to disk. Note that for
+ * data=ordered, we will write & wait for the data at the log flush
+ * stage anyway, so this is unlikely to make much of a difference
+ * except in the data=writeback case.
+ *
+ * If the fdatawrite fails due to any reason except -EIO, we will
+ * continue the remainder of the fsync, although we'll still report
+ * the error at the end. This is to match filemap_write_and_wait_range()
+ * behaviour.
  *
  * Returns: errno
  */
@@ -560,30 +568,36 @@ static int gfs2_close(struct inode *inode, struct file *file)
 static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 		      int datasync)
 {
-	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
 	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
 	struct gfs2_inode *ip = GFS2_I(inode);
-	int ret;
+	int ret, ret1 = 0;
 
-	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret)
-		return ret;
-	mutex_lock(&inode->i_mutex);
+	if (mapping->nrpages) {
+		ret1 = filemap_fdatawrite_range(mapping, start, end);
+		if (ret1 == -EIO)
+			return ret1;
+	}
 
 	if (datasync)
 		sync_state &= ~I_DIRTY_SYNC;
 
 	if (sync_state) {
+		mutex_lock(&inode->i_mutex);
 		ret = sync_inode_metadata(inode, 1);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
 			return ret;
 		}
 		gfs2_ail_flush(ip->i_gl);
+		mutex_unlock(&inode->i_mutex);
 	}
 
-	mutex_unlock(&inode->i_mutex);
-	return 0;
+	if (mapping->nrpages)
+		ret = filemap_fdatawait_range(mapping, start, end);
+
+	return ret ? ret : ret1;
 }
 
 /**
-- 
1.7.4.4

