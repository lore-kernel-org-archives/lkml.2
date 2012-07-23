Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2GWI0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2GWI0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/16] GFS2: Eliminate 64-bit divides
Date: Mon, 23 Jul 2012 09:01:06 +0100
Message-Id: <1343030466-3053-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removes the 64-bit divides introduced in the previous patch
in favor of shifting, so that it will compile properly on 32-bit machines.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 9f94832..9aa6af1 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -384,7 +384,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		return ret;
 
 	atomic_set(&ip->i_res->rs_sizehint,
-		   PAGE_CACHE_SIZE / sdp->sd_sb.sb_bsize);
+		   PAGE_CACHE_SIZE >> sdp->sd_sb.sb_bsize_shift);
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
@@ -669,7 +669,7 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (ret)
 		return ret;
 
-	atomic_set(&ip->i_res->rs_sizehint, writesize / sdp->sd_sb.sb_bsize);
+	atomic_set(&ip->i_res->rs_sizehint, writesize >> sdp->sd_sb.sb_bsize_shift);
 	if (file->f_flags & O_APPEND) {
 		struct gfs2_holder gh;
 
@@ -795,7 +795,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (unlikely(error))
 		goto out_uninit;
 
-	atomic_set(&ip->i_res->rs_sizehint, len / sdp->sd_sb.sb_bsize);
+	atomic_set(&ip->i_res->rs_sizehint, len >> sdp->sd_sb.sb_bsize_shift);
 
 	while (len > 0) {
 		if (len < bytes)
-- 
1.7.4

