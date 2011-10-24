Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1JXMrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:32 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/24] GFS2: Fix inode allocation error path
Date: Mon, 24 Oct 2011 13:48:19 +0100
Message-Id: <1319460518-9046-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have got far enough through the inode allocation code
path that an inode has already been allocated, then we must
call iput to dispose of it, if an error occurs during a
later part of the process. This will always be the final iput
since there will be no other references to the inode.

Unlike when the inode has been unlinked, its block state will
be GFS2_BLKST_INODE rather than GFS2_BLKST_UNLINKED so we need
to skip the test in ->evict_inode() for this one case in order
to ensure that it will be deallocated correctly. This patch adds
a new flag in order to ensure that this will happen correctly.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 892ac37..be5801a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -267,6 +267,7 @@ struct gfs2_alloc {
 enum {
 	GIF_INVALID		= 0,
 	GIF_QD_LOCKED		= 1,
+	GIF_ALLOC_FAILED	= 2,
 	GIF_SW_PAGED		= 3,
 };
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 900cf98..044efe2 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -736,10 +736,12 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 fail_gunlock2:
 	gfs2_glock_dq_uninit(ghs + 1);
-	if (inode && !IS_ERR(inode))
-		iput(inode);
 fail_gunlock:
 	gfs2_glock_dq_uninit(ghs);
+	if (inode && !IS_ERR(inode)) {
+		set_bit(GIF_ALLOC_FAILED, &GFS2_I(inode)->i_flags);
+		iput(inode);
+	}
 fail:
 	if (bh)
 		brelse(bh);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index afb8761..9961de7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1471,9 +1471,11 @@ static void gfs2_evict_inode(struct inode *inode)
 		goto out;
 	}
 
-	error = gfs2_check_blk_type(sdp, ip->i_no_addr, GFS2_BLKST_UNLINKED);
-	if (error)
-		goto out_truncate;
+	if (!test_bit(GIF_ALLOC_FAILED, &ip->i_flags)) {
+		error = gfs2_check_blk_type(sdp, ip->i_no_addr, GFS2_BLKST_UNLINKED);
+		if (error)
+			goto out_truncate;
+	}
 
 	if (test_bit(GIF_INVALID, &ip->i_flags)) {
 		error = gfs2_inode_refresh(ip);
@@ -1513,6 +1515,10 @@ static void gfs2_evict_inode(struct inode *inode)
 	goto out_unlock;
 
 out_truncate:
+	gfs2_log_flush(sdp, ip->i_gl);
+	write_inode_now(inode, 1);
+	gfs2_ail_flush(ip->i_gl);
+
 	/* Case 2 starts here */
 	error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
 	if (error)
-- 
1.7.4.4

