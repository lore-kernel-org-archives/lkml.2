Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2K3KXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:23:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab2K3KS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:26 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/16] GFS2: Fix truncation of journaled data files
Date: Fri, 30 Nov 2012 09:52:12 +0000
Message-Id: <1354269141-3311-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an issue relating to not having enough revokes
available when truncating journaled data files. In order to ensure
that we do no run out, the truncation is broken into separate pieces
if it is large enough.

Tested using fsx on a journaled data file.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index de70e52..a68e91b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -991,6 +991,41 @@ unlock:
 	return err;
 }
 
+/**
+ * gfs2_journaled_truncate - Wrapper for truncate_pagecache for jdata files
+ * @inode: The inode being truncated
+ * @oldsize: The original (larger) size
+ * @newsize: The new smaller size
+ *
+ * With jdata files, we have to journal a revoke for each block which is
+ * truncated. As a result, we need to split this into separate transactions
+ * if the number of pages being truncated gets too large.
+ */
+
+#define GFS2_JTRUNC_REVOKES 8192
+
+static int gfs2_journaled_truncate(struct inode *inode, u64 oldsize, u64 newsize)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	u64 max_chunk = GFS2_JTRUNC_REVOKES * sdp->sd_vfs->s_blocksize;
+	u64 chunk;
+	int error;
+
+	while (oldsize != newsize) {
+		chunk = oldsize - newsize;
+		if (chunk > max_chunk)
+			chunk = max_chunk;
+		truncate_pagecache(inode, oldsize, oldsize - chunk);
+		oldsize -= chunk;
+		gfs2_trans_end(sdp);
+		error = gfs2_trans_begin(sdp, RES_DINODE, GFS2_JTRUNC_REVOKES);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 static int trunc_start(struct inode *inode, u64 oldsize, u64 newsize)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -1000,8 +1035,10 @@ static int trunc_start(struct inode *inode, u64 oldsize, u64 newsize)
 	int journaled = gfs2_is_jdata(ip);
 	int error;
 
-	error = gfs2_trans_begin(sdp,
-				 RES_DINODE + (journaled ? RES_JDATA : 0), 0);
+	if (journaled)
+		error = gfs2_trans_begin(sdp, RES_DINODE + RES_JDATA, GFS2_JTRUNC_REVOKES);
+	else
+		error = gfs2_trans_begin(sdp, RES_DINODE, 0);
 	if (error)
 		return error;
 
@@ -1026,7 +1063,16 @@ static int trunc_start(struct inode *inode, u64 oldsize, u64 newsize)
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_dinode_out(ip, dibh->b_data);
 
-	truncate_pagecache(inode, oldsize, newsize);
+	if (journaled)
+		error = gfs2_journaled_truncate(inode, oldsize, newsize);
+	else
+		truncate_pagecache(inode, oldsize, newsize);
+
+	if (error) {
+		brelse(dibh);
+		return error;
+	}
+
 out_brelse:
 	brelse(dibh);
 out:
-- 
1.7.4

