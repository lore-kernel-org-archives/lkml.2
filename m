Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203Ab2B1Lf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:35:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2B1Lf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:35:27 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Read in rindex if necessary during unlink
Date: Tue, 28 Feb 2012 11:11:03 +0000
Message-Id: <1330427465-5417-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
References: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a problem whereby you were unable to delete
files until other file system operations were done (such as
statfs, touch, writes, etc.) that caused the rindex to be
read in.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index a7d611b..c87faf4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1035,14 +1035,19 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
-	int error = -EROFS;
+	int error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
-	if (!rgd)
+	if (!rgd) {
+		error = -EROFS;
 		goto out_inodes;
+	}
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
 
-- 
1.7.4

