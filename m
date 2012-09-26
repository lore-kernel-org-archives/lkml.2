Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2IZIvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab2IZIve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:34 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/27] GFS2: Update gfs2_get_block_type() to use rbm
Date: Wed, 26 Sep 2012 09:25:26 +0100
Message-Id: <1348647948-3219-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new gfs2_rbm_from_block() function to replace an open
coded version of the same code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index bd3b926..0c1be38 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1824,27 +1824,14 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 
 static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
 {
-	struct gfs2_bitmap *bi = NULL;
-	u32 length, rgrp_block, buf_block;
-	unsigned int buf;
-	unsigned char type;
-
-	length = rgd->rd_length;
-	rgrp_block = block - rgd->rd_data0;
-
-	for (buf = 0; buf < length; buf++) {
-		bi = rgd->rd_bits + buf;
-		if (rgrp_block < (bi->bi_start + bi->bi_len) * GFS2_NBBY)
-			break;
-	}
-
-	gfs2_assert(rgd->rd_sbd, buf < length);
-	buf_block = rgrp_block - bi->bi_start * GFS2_NBBY;
+	struct gfs2_rbm rbm = { .rgd = rgd, };
+	int ret;
 
-	type = gfs2_testbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
-			   bi->bi_len, buf_block);
+	ret = gfs2_rbm_from_block(&rbm, block);
+	WARN_ON_ONCE(ret != 0);
 
-	return type;
+	return gfs2_testbit(rgd, rbm.bi->bi_bh->b_data + rbm.bi->bi_offset,
+			    rbm.bi->bi_len, rbm.offset);
 }
 
 
-- 
1.7.4

