Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2IMKIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab2IMKIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:08:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/3] GFS2: Make write size hinting code common
Date: Thu, 13 Sep 2012 10:42:27 +0100
Message-Id: <1347529349-6704-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
References: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This collects up the write size hinting code which is used by the
block reservation subsystem into a single function. At the same
time this also corrects the rounding for this calculation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index d1d791e..382000f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -323,6 +323,29 @@ static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 }
 
 /**
+ * gfs2_size_hint - Give a hint to the size of a write request
+ * @file: The struct file
+ * @offset: The file offset of the write
+ * @size: The length of the write
+ *
+ * When we are about to do a write, this function records the total
+ * write size in order to provide a suitable hint to the lower layers
+ * about how many blocks will be required.
+ *
+ */
+
+static void gfs2_size_hint(struct file *filep, loff_t offset, size_t size)
+{
+	struct inode *inode = filep->f_dentry->d_inode;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	size_t blks = (size + sdp->sd_sb.sb_bsize - 1) >> sdp->sd_sb.sb_bsize_shift;
+	int hint = min_t(size_t, INT_MAX, blks);
+
+	atomic_set(&ip->i_res->rs_sizehint, hint);
+}
+
+/**
  * gfs2_allocate_page_backing - Use bmap to allocate blocks
  * @page: The (locked) page to allocate backing for
  *
@@ -382,8 +405,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (ret)
 		return ret;
 
-	atomic_set(&ip->i_res->rs_sizehint,
-		   PAGE_CACHE_SIZE >> sdp->sd_sb.sb_bsize_shift);
+	gfs2_size_hint(vma->vm_file, pos, PAGE_CACHE_SIZE);
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
@@ -663,7 +685,8 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (ret)
 		return ret;
 
-	atomic_set(&ip->i_res->rs_sizehint, writesize >> sdp->sd_sb.sb_bsize_shift);
+	gfs2_size_hint(file, pos, writesize);
+
 	if (file->f_flags & O_APPEND) {
 		struct gfs2_holder gh;
 
@@ -789,7 +812,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (unlikely(error))
 		goto out_uninit;
 
-	atomic_set(&ip->i_res->rs_sizehint, len >> sdp->sd_sb.sb_bsize_shift);
+	gfs2_size_hint(file, offset, len);
 
 	while (len > 0) {
 		if (len < bytes)
-- 
1.7.4

