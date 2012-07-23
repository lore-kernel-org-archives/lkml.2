Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2GWI1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab2GWI01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/16] GFS2: Combine functions get_local_rgrp and gfs2_inplace_reserve
Date: Mon, 23 Jul 2012 09:01:02 +0100
Message-Id: <1343030466-3053-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This function combines rgrp functions get_local_rgrp and
gfs2_inplace_reserve so that the double retry loop is gone.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3c6f7ed..e53d0a1 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1207,25 +1207,30 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 }
 
 /**
- * get_local_rgrp - Choose and lock a rgrp for allocation
+ * gfs2_inplace_reserve - Reserve space in the filesystem
  * @ip: the inode to reserve space for
- * @last_unlinked: the last unlinked block
- *
- * Try to acquire rgrp in way which avoids contending with others.
+ * @requested: the number of blocks to be reserved
  *
  * Returns: errno
  */
 
-static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
+int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
 	struct gfs2_blkreserv *rs = ip->i_res;
-	int error, rg_locked, flags = LM_FLAG_TRY;
+	int error = 0, rg_locked, flags = LM_FLAG_TRY;
+	u64 last_unlinked = NO_BLOCK;
 	int loops = 0;
 
 	if (sdp->sd_args.ar_rgrplvb)
 		flags |= GL_SKIP;
+	rs = ip->i_res;
+	rs->rs_requested = requested;
+	if (gfs2_assert_warn(sdp, requested)) {
+		error = -EINVAL;
+		goto out;
+	}
 
 	if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal))
 		rgd = begin = ip->i_rgd;
@@ -1263,63 +1268,34 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			if (rgd->rd_flags & GFS2_RDF_CHECK) {
 				if (sdp->sd_args.ar_rgrplvb)
 					gfs2_rgrp_bh_get(rgd);
-				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
+				try_rgrp_unlink(rgd, &last_unlinked,
+						ip->i_no_addr);
 			}
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = gfs2_rgrpd_get_next(rgd);
-			if (rgd == begin) {
-				flags &= ~LM_FLAG_TRY;
-				loops++;
-			}
+			if (rgd != begin) /* If we didn't wrap */
+				break;
+
+			flags &= ~LM_FLAG_TRY;
+			loops++;
+			/* Check that fs hasn't grown if writing to rindex */
+			if (ip == GFS2_I(sdp->sd_rindex) &&
+			    !sdp->sd_rindex_uptodate) {
+				error = gfs2_ri_update(ip);
+				if (error)
+					goto out;
+			} else if (loops == 2)
+				/* Flushing the log may release space */
+				gfs2_log_flush(sdp, NULL);
 			break;
 		default:
-			return error;
+			goto out;
 		}
 	}
-
-	return -ENOSPC;
-}
-
-/**
- * gfs2_inplace_reserve - Reserve space in the filesystem
- * @ip: the inode to reserve space for
- * @requested: the number of blocks to be reserved
- *
- * Returns: errno
- */
-
-int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_blkreserv *rs;
-	int error = 0;
-	u64 last_unlinked = NO_BLOCK;
-	int tries = 0;
-
-	rs = ip->i_res;
-	rs->rs_requested = requested;
-	if (gfs2_assert_warn(sdp, requested)) {
-		error = -EINVAL;
-		goto out;
-	}
-
-	do {
-		error = get_local_rgrp(ip, &last_unlinked);
-		if (error != -ENOSPC)
-			break;
-		/* Check that fs hasn't grown if writing to rindex */
-		if (ip == GFS2_I(sdp->sd_rindex) && !sdp->sd_rindex_uptodate) {
-			error = gfs2_ri_update(ip);
-			if (error)
-				break;
-			continue;
-		}
-		/* Flushing the log may release space */
-		gfs2_log_flush(sdp, NULL);
-	} while (tries++ < 3);
+	error = -ENOSPC;
 
 out:
 	if (error)
-- 
1.7.4

