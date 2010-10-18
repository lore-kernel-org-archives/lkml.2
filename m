Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0JROiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab0JROh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:57 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/22] GFS2 fatal: filesystem consistency error on rename
Date: Mon, 18 Oct 2010 15:15:44 +0100
Message-Id: <1287411346-17855-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a GFS2 problem whereby the first rename after a
mount can result in a file system consistency error being flagged
improperly and cause the file system to withdraw.  The problem is
that the rename code tries to run the rgrp list with function
gfs2_blk2rgrpd before the rgrp list is guaranteed to be read in
from disk.  The patch makes the rename function hold the rindex
glock (as the gfs2_unlink code does today) which reads in the rgrp
list if need be.  There were a total of three places in the rename
code that improperly referenced the rgrp list without the rindex
glock and this patch fixes all three.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index fba0017..0534510 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -736,7 +736,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_inode *ip = GFS2_I(odentry->d_inode);
 	struct gfs2_inode *nip = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(odir);
-	struct gfs2_holder ghs[5], r_gh = { .gh_gl = NULL, };
+	struct gfs2_holder ghs[5], r_gh = { .gh_gl = NULL, }, ri_gh;
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
@@ -750,6 +750,9 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			return 0;
 	}
 
+	error = gfs2_rindex_hold(sdp, &ri_gh);
+	if (error)
+		return error;
 
 	if (odip != ndip) {
 		error = gfs2_glock_nq_init(sdp->sd_rename_gl, LM_ST_EXCLUSIVE,
@@ -879,7 +882,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 
 		al->al_requested = sdp->sd_max_dirres;
 
-		error = gfs2_inplace_reserve(ndip);
+		error = gfs2_inplace_reserve_ri(ndip);
 		if (error)
 			goto out_gunlock_q;
 
@@ -961,6 +964,7 @@ out_gunlock_r:
 	if (r_gh.gh_gl)
 		gfs2_glock_dq_uninit(&r_gh);
 out:
+	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f9ddcf4..fb67f59 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1200,7 +1200,8 @@ out:
  * Returns: errno
  */
 
-int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
+int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
+			   char *file, unsigned int line)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
@@ -1211,12 +1212,15 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 		return -EINVAL;
 
 try_again:
-	/* We need to hold the rindex unless the inode we're using is
-	   the rindex itself, in which case it's already held. */
-	if (ip != GFS2_I(sdp->sd_rindex))
-		error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
-	else if (!sdp->sd_rgrps) /* We may not have the rindex read in, so: */
-		error = gfs2_ri_update_special(ip);
+	if (hold_rindex) {
+		/* We need to hold the rindex unless the inode we're using is
+		   the rindex itself, in which case it's already held. */
+		if (ip != GFS2_I(sdp->sd_rindex))
+			error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
+		else if (!sdp->sd_rgrps) /* We may not have the rindex read
+					    in, so: */
+			error = gfs2_ri_update_special(ip);
+	}
 
 	if (error)
 		return error;
@@ -1227,7 +1231,7 @@ try_again:
 	   try to free it, and try the allocation again. */
 	error = get_local_rgrp(ip, &unlinked, &last_unlinked);
 	if (error) {
-		if (ip != GFS2_I(sdp->sd_rindex))
+		if (hold_rindex && ip != GFS2_I(sdp->sd_rindex))
 			gfs2_glock_dq_uninit(&al->al_ri_gh);
 		if (error != -EAGAIN)
 			return error;
@@ -1269,7 +1273,7 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 	al->al_rgd = NULL;
 	if (al->al_rgd_gh.gh_gl)
 		gfs2_glock_dq_uninit(&al->al_rgd_gh);
-	if (ip != GFS2_I(sdp->sd_rindex))
+	if (ip != GFS2_I(sdp->sd_rindex) && al->al_ri_gh.gh_gl)
 		gfs2_glock_dq_uninit(&al->al_ri_gh);
 }
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index f07119d..0e35c04 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -39,10 +39,12 @@ static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 	ip->i_alloc = NULL;
 }
 
-extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file,
-				  unsigned int line);
+extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
+				  char *file, unsigned int line);
 #define gfs2_inplace_reserve(ip) \
-gfs2_inplace_reserve_i((ip), __FILE__, __LINE__)
+	gfs2_inplace_reserve_i((ip), 1, __FILE__, __LINE__)
+#define gfs2_inplace_reserve_ri(ip) \
+	gfs2_inplace_reserve_i((ip), 0, __FILE__, __LINE__)
 
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
-- 
1.7.1.1

