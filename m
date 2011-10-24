Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1JXMsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab1JXMsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:48:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/24] GFS2: Move readahead of metadata during deallocation into its own function
Date: Mon, 24 Oct 2011 13:48:38 +0100
Message-Id: <1319460518-9046-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the recently added readahead of the indirect pointer
tree during deallocation into its own function in order
that we can use it elsewhere in the future. Also this
fixes the resetting of the "first" variable in the
original patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 97b6195..41d494d 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -269,6 +269,30 @@ static inline __be64 *metapointer(unsigned int height, const struct metapath *mp
 	return ((__be64 *)(bh->b_data + head_size)) + mp->mp_list[height];
 }
 
+static void gfs2_metapath_ra(struct gfs2_glock *gl,
+			     const struct buffer_head *bh, const __be64 *pos)
+{
+	struct buffer_head *rabh;
+	const __be64 *endp = (const __be64 *)(bh->b_data + bh->b_size);
+	const __be64 *t;
+
+	for (t = pos; t < endp; t++) {
+		if (!*t)
+			continue;
+
+		rabh = gfs2_getbuf(gl, be64_to_cpu(*t), CREATE);
+		if (trylock_buffer(rabh)) {
+			if (!buffer_uptodate(rabh)) {
+				rabh->b_end_io = end_buffer_read_sync;
+				submit_bh(READA | REQ_META, rabh);
+				continue;
+			}
+			unlock_buffer(rabh);
+		}
+		brelse(rabh);
+	}
+}
+
 /**
  * lookup_metapath - Walk the metadata tree to a specific point
  * @ip: The inode
@@ -843,7 +867,7 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *bh = NULL;
-	__be64 *top, *bottom, *t2;
+	__be64 *top, *bottom;
 	u64 bn;
 	int error;
 	int mh_size = sizeof(struct gfs2_meta_header);
@@ -872,26 +896,9 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 		goto out;
 
 	if (height < ip->i_height - 1) {
-		struct buffer_head *rabh;
 
-		for (t2 = top; t2 < bottom; t2++, first = 0) {
-			if (!*t2)
-				continue;
+		gfs2_metapath_ra(ip->i_gl, bh, top);
 
-			bn = be64_to_cpu(*t2);
-			rabh = gfs2_getbuf(ip->i_gl, bn, CREATE);
-			if (trylock_buffer(rabh)) {
-				if (buffer_uptodate(rabh)) {
-					unlock_buffer(rabh);
-					brelse(rabh);
-					continue;
-				}
-				rabh->b_end_io = end_buffer_read_sync;
-				submit_bh(READA | REQ_META, rabh);
-				continue;
-			}
-			brelse(rabh);
-		}
 		for (; top < bottom; top++, first = 0) {
 			if (!*top)
 				continue;
-- 
1.7.4.4

