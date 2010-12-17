Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0LQMqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab0LQMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:21 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/15] GFS2: fix recursive locking during rindex truncates
Date: Fri, 17 Dec 2010 12:24:17 +0000
Message-Id: <1292588661-14350-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

When you truncate the rindex file, you need to avoid calling gfs2_rindex_hold,
since you already hold it.  However, if you haven't already read in the
resource groups, you need to do that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 5476c06..ae7d205 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -780,7 +780,11 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	if (metadata)
 		revokes = (height) ? sdp->sd_inptrs : sdp->sd_diptrs;
 
-	error = gfs2_rindex_hold(sdp, &ip->i_alloc->al_ri_gh);
+	if (ip != GFS2_I(sdp->sd_rindex))
+		error = gfs2_rindex_hold(sdp, &ip->i_alloc->al_ri_gh);
+	else if (!sdp->sd_rgrps)
+		error = gfs2_ri_update(ip);
+
 	if (error)
 		return error;
 
@@ -879,7 +883,8 @@ out_rg_gunlock:
 out_rlist:
 	gfs2_rlist_free(&rlist);
 out:
-	gfs2_glock_dq_uninit(&ip->i_alloc->al_ri_gh);
+	if (ip != GFS2_I(sdp->sd_rindex))
+		gfs2_glock_dq_uninit(&ip->i_alloc->al_ri_gh);
 	return error;
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6375b38..25dbe5c 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -583,7 +583,7 @@ static int read_rindex_entry(struct gfs2_inode *ip,
  * Returns: 0 on successful update, error code otherwise
  */
 
-static int gfs2_ri_update(struct gfs2_inode *ip)
+int gfs2_ri_update(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 0e35c04..50c2bb0 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -48,6 +48,7 @@ extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
 
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
+extern int gfs2_ri_update(struct gfs2_inode *ip);
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
 extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
 
-- 
1.7.3.3

