Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2IZIv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2IZIv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/27] GFS2: Fall back to ignoring reservations, if there are no other blocks left
Date: Wed, 26 Sep 2012 09:25:40 +0100
Message-Id: <1348647948-3219-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we get to the stage of allocating blocks, we know that the
resource group in question must contain enough free blocks, otherwise
gfs2_inplace_reserve() would have failed. So if we are left with only
free blocks which are reserved, then we must use those. This can happen
if another node has sneeked in and use some blocks reserved on this
node, for example. Generally this will happen very rarely and only
when the resouce group is nearly full.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 55a2651..30c864e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2012,6 +2012,11 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	gfs2_rbm_from_block(&rbm, goal);
 	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, ip, false);
 
+	if (error == -ENOSPC) {
+		gfs2_rbm_from_block(&rbm, goal);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, NULL, false);
+	}
+
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (error) {
 		fs_warn(sdp, "error=%d, nblocks=%u, full=%d\n", error, *nblocks,
-- 
1.7.4

