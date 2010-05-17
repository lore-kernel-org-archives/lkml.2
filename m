Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0EQM6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab0EQM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/11] GFS2: stuck in inode wait, no glocks stuck
Date: Mon, 17 May 2010 13:40:24 +0100
Message-Id: <1274100025-26629-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-10-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-7-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-8-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-9-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-10-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes the lock ordering when gfs2 reclaims
unlinked dinodes, thereby avoiding a livelock.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |   78 +++++++++++++++++++++----------------------------------
 1 files changed, 30 insertions(+), 48 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3739155..8bce73e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -952,16 +952,14 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
  *          The inode, if one has been found, in inode.
  */
 
-static int try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
-			   u64 skip, struct inode **inode)
+static u64 try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
+			   u64 skip)
 {
 	u32 goal = 0, block;
 	u64 no_addr;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	unsigned int n;
-	int error = 0;
 
-	*inode = NULL;
 	for(;;) {
 		if (goal >= rgd->rd_data)
 			break;
@@ -981,10 +979,7 @@ static int try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
 		if (no_addr == skip)
 			continue;
 		*last_unlinked = no_addr;
-		error = gfs2_unlinked_inode_lookup(rgd->rd_sbd->sd_vfs,
-						   no_addr, inode);
-		if (*inode || error)
-			return error;
+		return no_addr;
 	}
 
 	rgd->rd_flags &= ~GFS2_RDF_CHECK;
@@ -1069,11 +1064,12 @@ static void forward_rgrp_set(struct gfs2_sbd *sdp, struct gfs2_rgrpd *rgd)
  * Try to acquire rgrp in way which avoids contending with others.
  *
  * Returns: errno
+ *          unlinked: the block address of an unlinked block to be reclaimed
  */
 
-static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
+static int get_local_rgrp(struct gfs2_inode *ip, u64 *unlinked,
+			  u64 *last_unlinked)
 {
-	struct inode *inode = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
 	struct gfs2_alloc *al = ip->i_alloc;
@@ -1082,6 +1078,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	int loops = 0;
 	int error, rg_locked;
 
+	*unlinked = 0;
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_goal);
 
 	while (rgd) {
@@ -1103,29 +1100,19 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			   because that would require an iput which can only
 			   happen after the rgrp is unlocked. */
 			if (!rg_locked && rgd->rd_flags & GFS2_RDF_CHECK)
-				error = try_rgrp_unlink(rgd, last_unlinked,
-							ip->i_no_addr, &inode);
+				*unlinked = try_rgrp_unlink(rgd, last_unlinked,
+							   ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			if (inode) {
-				if (error) {
-					if (inode->i_state & I_NEW)
-						iget_failed(inode);
-					else
-						iput(inode);
-					return ERR_PTR(error);
-				}
-				return inode;
-			}
-			if (error)
-				return ERR_PTR(error);
+			if (*unlinked)
+				return -EAGAIN;
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = recent_rgrp_next(rgd);
 			break;
 
 		default:
-			return ERR_PTR(error);
+			return error;
 		}
 	}
 
@@ -1148,22 +1135,12 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			if (try_rgrp_fit(rgd, al))
 				goto out;
 			if (!rg_locked && rgd->rd_flags & GFS2_RDF_CHECK)
-				error = try_rgrp_unlink(rgd, last_unlinked,
-							ip->i_no_addr, &inode);
+				*unlinked = try_rgrp_unlink(rgd, last_unlinked,
+							    ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			if (inode) {
-				if (error) {
-					if (inode->i_state & I_NEW)
-						iget_failed(inode);
-					else
-						iput(inode);
-					return ERR_PTR(error);
-				}
-				return inode;
-			}
-			if (error)
-				return ERR_PTR(error);
+			if (*unlinked)
+				return -EAGAIN;
 			break;
 
 		case GLR_TRYFAILED:
@@ -1171,7 +1148,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			break;
 
 		default:
-			return ERR_PTR(error);
+			return error;
 		}
 
 		rgd = gfs2_rgrpd_get_next(rgd);
@@ -1180,7 +1157,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 
 		if (rgd == begin) {
 			if (++loops >= 3)
-				return ERR_PTR(-ENOSPC);
+				return -ENOSPC;
 			if (!skipped)
 				loops++;
 			flags = 0;
@@ -1200,7 +1177,7 @@ out:
 		forward_rgrp_set(sdp, rgd);
 	}
 
-	return NULL;
+	return 0;
 }
 
 /**
@@ -1216,7 +1193,7 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 	struct gfs2_alloc *al = ip->i_alloc;
 	struct inode *inode;
 	int error = 0;
-	u64 last_unlinked = NO_BLOCK;
+	u64 last_unlinked = NO_BLOCK, unlinked;
 
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
@@ -1232,14 +1209,19 @@ try_again:
 	if (error)
 		return error;
 
-	inode = get_local_rgrp(ip, &last_unlinked);
-	if (inode) {
+	error = get_local_rgrp(ip, &unlinked, &last_unlinked);
+	if (error) {
 		if (ip != GFS2_I(sdp->sd_rindex))
 			gfs2_glock_dq_uninit(&al->al_ri_gh);
-		if (IS_ERR(inode))
-			return PTR_ERR(inode);
-		iput(inode);
+		if (error != -EAGAIN)
+			return error;
+		error = gfs2_unlinked_inode_lookup(ip->i_inode.i_sb,
+						   unlinked, &inode);
+		if (inode)
+			iput(inode);
 		gfs2_log_flush(sdp, NULL);
+		if (error == GLR_TRYFAILED)
+			error = 0;
 		goto try_again;
 	}
 
-- 
1.6.2.5

