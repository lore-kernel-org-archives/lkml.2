Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2IZIwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:52:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab2IZIwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/27] GFS2: Stop block extents at the end of bitmaps
Date: Wed, 26 Sep 2012 09:25:43 +0100
Message-Id: <1348647948-3219-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch stops multiple block allocations if a nonzero
return code is received from gfs2_rbm_from_block. Without
this patch, if enough pressure is put on the file system,
you get a kernel warning quickly followed by:
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa04f47e8>] gfs2_alloc_blocks+0x2c8/0x880 [gfs2]
With this patch, things run normally.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8869541..defb826 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1834,8 +1834,7 @@ static void gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 	block++;
 	while (*n < elen) {
 		ret = gfs2_rbm_from_block(&pos, block);
-		WARN_ON(ret);
-		if (gfs2_testbit(&pos) != GFS2_BLKST_FREE)
+		if (ret || gfs2_testbit(&pos) != GFS2_BLKST_FREE)
 			break;
 		gfs2_trans_add_bh(pos.rgd->rd_gl, pos.bi->bi_bh, 1);
 		gfs2_setbit(&pos, true, GFS2_BLKST_USED);
-- 
1.7.4

