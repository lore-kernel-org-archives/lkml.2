Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2AEMQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab2AEMQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:20 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/16] GFS2: Add non-try locks back to get_local_rgrp
Date: Thu,  5 Jan 2012 11:51:52 +0000
Message-Id: <1325764322-10807-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This upstream patch had what I believe is an unintended consequence:

http://git.kernel.org/?p=linux/kernel/git/steve/gfs2-3.0-nmw.git;a=commitdiff;h=beca42486749c1538a5ed58fe9dcc9f26d428c93

The patch changed function get_local_rgrp such that it ONLY
used TRY locks for RGRP searches. Prior to that patch, the code
used TRY locks during the first loop, and if that was unsuccessful,
it used normal blocking locks on subsequent searches. This patch
changes it back to the old way.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 96bd6d7..a1a815b 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -978,7 +978,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
 	struct gfs2_alloc *al = ip->i_alloc;
-	int error, rg_locked;
+	int error, rg_locked, flags = LM_FLAG_TRY;
 	int loops = 0;
 
 	if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal))
@@ -997,7 +997,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			error = 0;
 		} else {
 			error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE,
-						   LM_FLAG_TRY, &al->al_rgd_gh);
+						   flags, &al->al_rgd_gh);
 		}
 		switch (error) {
 		case 0:
@@ -1012,8 +1012,10 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = gfs2_rgrpd_get_next(rgd);
-			if (rgd == begin)
+			if (rgd == begin) {
+				flags = 0;
 				loops++;
+			}
 			break;
 		default:
 			return error;
-- 
1.7.4

