Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1JXMtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab1JXMrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/24] GFS2: speed up delete/unlink performance for large files
Date: Mon, 24 Oct 2011 13:48:34 +0100
Message-Id: <1319460518-9046-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch improves the performance of delete/unlink
operations in a GFS2 file system where the files are large
by adding a layer of metadata read-ahead for indirect blocks.
Mileage will vary, but on my system, deleting an 8.6G file
dropped from 22 seconds to about 4.5 seconds.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 22ad413..834cd94 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -831,7 +831,7 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *bh = NULL;
-	__be64 *top, *bottom;
+	__be64 *top, *bottom, *t2;
 	u64 bn;
 	int error;
 	int mh_size = sizeof(struct gfs2_meta_header);
@@ -859,7 +859,27 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 	if (error)
 		goto out;
 
-	if (height < ip->i_height - 1)
+	if (height < ip->i_height - 1) {
+		struct buffer_head *rabh;
+
+		for (t2 = top; t2 < bottom; t2++, first = 0) {
+			if (!*t2)
+				continue;
+
+			bn = be64_to_cpu(*t2);
+			rabh = gfs2_getbuf(ip->i_gl, bn, CREATE);
+			if (trylock_buffer(rabh)) {
+				if (buffer_uptodate(rabh)) {
+					unlock_buffer(rabh);
+					brelse(rabh);
+					continue;
+				}
+				rabh->b_end_io = end_buffer_read_sync;
+				submit_bh(READA | REQ_META, rabh);
+				continue;
+			}
+			brelse(rabh);
+		}
 		for (; top < bottom; top++, first = 0) {
 			if (!*top)
 				continue;
@@ -871,7 +891,7 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 			if (error)
 				break;
 		}
-
+	}
 out:
 	brelse(bh);
 	return error;
-- 
1.7.4.4

