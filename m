Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0JROhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab0JROhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/22] GFS2: Add a bug trap in allocation code
Date: Mon, 18 Oct 2010 15:15:28 +0100
Message-Id: <1287411346-17855-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a check to ensure that if we reach the block allocator
that we don't try and proceed if there is no alloc structure
hanging off the inode. This should only happen if there is a bug
in GFS2. The error return code is distinctive in order that it
will be easily spotted.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 370c29b..66b6d4d 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1496,11 +1496,19 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
 	struct gfs2_alloc *al = ip->i_alloc;
-	struct gfs2_rgrpd *rgd = al->al_rgd;
+	struct gfs2_rgrpd *rgd;
 	u32 goal, blk;
 	u64 block;
 	int error;
 
+	/* Only happens if there is a bug in gfs2, return something distinctive
+	 * to ensure that it is noticed.
+	 */
+	if (al == NULL)
+		return -ECANCELED;
+
+	rgd = al->al_rgd;
+
 	if (rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
 	else
-- 
1.7.1.1

