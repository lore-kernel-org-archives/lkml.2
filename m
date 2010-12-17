Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0LQMq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab0LQMqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:19 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/15] GFS2: reread rindex when necessary to grow rindex
Date: Fri, 17 Dec 2010 12:24:16 +0000
Message-Id: <1292588661-14350-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

When GFS2 grew the filesystem, it was never rereading the rindex file during
the grow. This is necessary for large grows when the filesystem is almost full,
and GFS2 needs to use some of the space allocated earlier in the grow to
complete it.  Now, if GFS2 fails to reserve the necessary space and the rindex
file is not uptodate, it rereads it.  Also, the only difference between
gfs2_ri_update() and gfs2_ri_update_special() was that gfs2_ri_update_special()
didn't clear out the existing resource groups, since you knew that it was only
called when there were no resource groups.  Attempting to clear out the
resource groups when there are none takes almost no time, and rarely happens,
so I simply removed gfs2_ri_update_special().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 33c8407..6375b38 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -614,46 +614,6 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 }
 
 /**
- * gfs2_ri_update_special - Pull in a new resource index from the disk
- *
- * This is a special version that's safe to call from gfs2_inplace_reserve_i.
- * In this case we know that we don't have any resource groups in memory yet.
- *
- * @ip: pointer to the rindex inode
- *
- * Returns: 0 on successful update, error code otherwise
- */
-static int gfs2_ri_update_special(struct gfs2_inode *ip)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct inode *inode = &ip->i_inode;
-	struct file_ra_state ra_state;
-	struct gfs2_rgrpd *rgd;
-	unsigned int max_data = 0;
-	int error;
-
-	file_ra_state_init(&ra_state, inode->i_mapping);
-	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
-		/* Ignore partials */
-		if ((sdp->sd_rgrps + 1) * sizeof(struct gfs2_rindex) >
-		    i_size_read(inode))
-			break;
-		error = read_rindex_entry(ip, &ra_state);
-		if (error) {
-			clear_rgrpdi(sdp);
-			return error;
-		}
-	}
-	list_for_each_entry(rgd, &sdp->sd_rindex_list, rd_list)
-		if (rgd->rd_data > max_data)
-			max_data = rgd->rd_data;
-	sdp->sd_max_rg_data = max_data;
-
-	sdp->sd_rindex_uptodate = 1;
-	return 0;
-}
-
-/**
  * gfs2_rindex_hold - Grab a lock on the rindex
  * @sdp: The GFS2 superblock
  * @ri_gh: the glock holder
@@ -1226,16 +1186,25 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
 			error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
 		else if (!sdp->sd_rgrps) /* We may not have the rindex read
 					    in, so: */
-			error = gfs2_ri_update_special(ip);
+			error = gfs2_ri_update(ip);
 		if (error)
 			return error;
 	}
 
+try_again:
 	do {
 		error = get_local_rgrp(ip, &last_unlinked);
 		/* If there is no space, flushing the log may release some */
-		if (error)
+		if (error) {
+			if (ip == GFS2_I(sdp->sd_rindex) &&
+			    !sdp->sd_rindex_uptodate) {
+				error = gfs2_ri_update(ip);
+				if (error)
+					return error;
+				goto try_again;
+			}
 			gfs2_log_flush(sdp, NULL);
+		}
 	} while (error && tries++ < 3);
 
 	if (error) {
-- 
1.7.3.3

