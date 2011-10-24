Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1JXMrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/24] GFS2: Call do_strip() directly from recursive_scan()
Date: Mon, 24 Oct 2011 13:48:28 +0100
Message-Id: <1319460518-9046-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recursive_scan() function only ever takes a single "bc"
argument, so we might as well just call do_strip() directly
from resource_scan() rather than pass it in as an argument.

Also the "data" argument is always a struct strip_mine, so
we can pass that in, rather than using a void pointer.

This also moves do_strip() ahead of recursive_scan() so that
we don't need to add a prototype.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e602961..9d3a0c2 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -36,11 +36,6 @@ struct metapath {
 	__u16 mp_list[GFS2_MAX_META_HEIGHT];
 };
 
-typedef int (*block_call_t) (struct gfs2_inode *ip, struct buffer_head *dibh,
-			     struct buffer_head *bh, __be64 *top,
-			     __be64 *bottom, unsigned int height,
-			     void *data);
-
 struct strip_mine {
 	int sm_first;
 	unsigned int sm_height;
@@ -668,76 +663,6 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 }
 
 /**
- * recursive_scan - recursively scan through the end of a file
- * @ip: the inode
- * @dibh: the dinode buffer
- * @mp: the path through the metadata to the point to start
- * @height: the height the recursion is at
- * @block: the indirect block to look at
- * @first: 1 if this is the first block
- * @bc: the call to make for each piece of metadata
- * @data: data opaque to this function to pass to @bc
- *
- * When this is first called @height and @block should be zero and
- * @first should be 1.
- *
- * Returns: errno
- */
-
-static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
-			  struct metapath *mp, unsigned int height,
-			  u64 block, int first, block_call_t bc,
-			  void *data)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct buffer_head *bh = NULL;
-	__be64 *top, *bottom;
-	u64 bn;
-	int error;
-	int mh_size = sizeof(struct gfs2_meta_header);
-
-	if (!height) {
-		error = gfs2_meta_inode_buffer(ip, &bh);
-		if (error)
-			return error;
-		dibh = bh;
-
-		top = (__be64 *)(bh->b_data + sizeof(struct gfs2_dinode)) + mp->mp_list[0];
-		bottom = (__be64 *)(bh->b_data + sizeof(struct gfs2_dinode)) + sdp->sd_diptrs;
-	} else {
-		error = gfs2_meta_indirect_buffer(ip, height, block, 0, &bh);
-		if (error)
-			return error;
-
-		top = (__be64 *)(bh->b_data + mh_size) +
-				  (first ? mp->mp_list[height] : 0);
-
-		bottom = (__be64 *)(bh->b_data + mh_size) + sdp->sd_inptrs;
-	}
-
-	error = bc(ip, dibh, bh, top, bottom, height, data);
-	if (error)
-		goto out;
-
-	if (height < ip->i_height - 1)
-		for (; top < bottom; top++, first = 0) {
-			if (!*top)
-				continue;
-
-			bn = be64_to_cpu(*top);
-
-			error = recursive_scan(ip, dibh, mp, height + 1, bn,
-					       first, bc, data);
-			if (error)
-				break;
-		}
-
-out:
-	brelse(bh);
-	return error;
-}
-
-/**
  * do_strip - Look for a layer a particular layer of the file and strip it off
  * @ip: the inode
  * @dibh: the dinode buffer
@@ -752,9 +677,8 @@ out:
 
 static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		    struct buffer_head *bh, __be64 *top, __be64 *bottom,
-		    unsigned int height, void *data)
+		    unsigned int height, struct strip_mine *sm)
 {
-	struct strip_mine *sm = data;
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrp_list rlist;
 	u64 bn, bstart;
@@ -886,6 +810,75 @@ out:
 }
 
 /**
+ * recursive_scan - recursively scan through the end of a file
+ * @ip: the inode
+ * @dibh: the dinode buffer
+ * @mp: the path through the metadata to the point to start
+ * @height: the height the recursion is at
+ * @block: the indirect block to look at
+ * @first: 1 if this is the first block
+ * @sm: data opaque to this function to pass to @bc
+ *
+ * When this is first called @height and @block should be zero and
+ * @first should be 1.
+ *
+ * Returns: errno
+ */
+
+static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
+			  struct metapath *mp, unsigned int height,
+			  u64 block, int first, struct strip_mine *sm)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct buffer_head *bh = NULL;
+	__be64 *top, *bottom;
+	u64 bn;
+	int error;
+	int mh_size = sizeof(struct gfs2_meta_header);
+
+	if (!height) {
+		error = gfs2_meta_inode_buffer(ip, &bh);
+		if (error)
+			return error;
+		dibh = bh;
+
+		top = (__be64 *)(bh->b_data + sizeof(struct gfs2_dinode)) + mp->mp_list[0];
+		bottom = (__be64 *)(bh->b_data + sizeof(struct gfs2_dinode)) + sdp->sd_diptrs;
+	} else {
+		error = gfs2_meta_indirect_buffer(ip, height, block, 0, &bh);
+		if (error)
+			return error;
+
+		top = (__be64 *)(bh->b_data + mh_size) +
+				  (first ? mp->mp_list[height] : 0);
+
+		bottom = (__be64 *)(bh->b_data + mh_size) + sdp->sd_inptrs;
+	}
+
+	error = do_strip(ip, dibh, bh, top, bottom, height, sm);
+	if (error)
+		goto out;
+
+	if (height < ip->i_height - 1)
+		for (; top < bottom; top++, first = 0) {
+			if (!*top)
+				continue;
+
+			bn = be64_to_cpu(*top);
+
+			error = recursive_scan(ip, dibh, mp, height + 1, bn,
+					       first, sm);
+			if (error)
+				break;
+		}
+
+out:
+	brelse(bh);
+	return error;
+}
+
+
+/**
  * gfs2_block_truncate_page - Deal with zeroing out data for truncate
  *
  * This is partly borrowed from ext3.
@@ -1024,7 +1017,7 @@ static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 		sm.sm_first = !!size;
 		sm.sm_height = height;
 
-		error = recursive_scan(ip, NULL, &mp, 0, 0, 1, do_strip, &sm);
+		error = recursive_scan(ip, NULL, &mp, 0, 0, 1, &sm);
 		if (error)
 			break;
 	}
-- 
1.7.4.4

