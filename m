Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030728Ab2CSKwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030337Ab2CSKtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:51 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/12] GFS2: Eliminate sd_rindex_mutex
Date: Mon, 19 Mar 2012 10:25:23 +0000
Message-Id: <1332152728-4027-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Over time, we've slowly eliminated the use of sd_rindex_mutex.
Up to this point, it was only used in two places: function
gfs2_ri_total (which totals the file system size by reading
and parsing the rindex file) and function gfs2_rindex_update
which updates the rgrps in memory. Both of these functions have
the rindex glock to protect them, so the rindex is unnecessary.
Since gfs2_grow writes to the rindex via the meta_fs, the mutex
is in the wrong order according to the normal rules. This patch
eliminates the mutex entirely to avoid the problem.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4d546df..47d0bda 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -644,7 +644,6 @@ struct gfs2_sbd {
 
 	int sd_rindex_uptodate;
 	spinlock_t sd_rindex_spin;
-	struct mutex sd_rindex_mutex;
 	struct rb_root sd_rindex_tree;
 	unsigned int sd_rgrps;
 	unsigned int sd_max_rg_data;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a55baa7..ae5e0a4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -83,7 +83,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	spin_lock_init(&sdp->sd_statfs_spin);
 
 	spin_lock_init(&sdp->sd_rindex_spin);
-	mutex_init(&sdp->sd_rindex_mutex);
 	sdp->sd_rindex_tree.rb_node = NULL;
 
 	INIT_LIST_HEAD(&sdp->sd_jindex_list);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e09370e..6ff9f17 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -540,7 +540,6 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 	struct file_ra_state ra_state;
 	int error, rgrps;
 
-	mutex_lock(&sdp->sd_rindex_mutex);
 	file_ra_state_init(&ra_state, inode->i_mapping);
 	for (rgrps = 0;; rgrps++) {
 		loff_t pos = rgrps * sizeof(struct gfs2_rindex);
@@ -553,11 +552,10 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 			break;
 		total_data += be32_to_cpu(((struct gfs2_rindex *)buf)->ri_data);
 	}
-	mutex_unlock(&sdp->sd_rindex_mutex);
 	return total_data;
 }
 
-static void rgd_insert(struct gfs2_rgrpd *rgd)
+static int rgd_insert(struct gfs2_rgrpd *rgd)
 {
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	struct rb_node **newn = &sdp->sd_rindex_tree.rb_node, *parent = NULL;
@@ -573,11 +571,13 @@ static void rgd_insert(struct gfs2_rgrpd *rgd)
 		else if (rgd->rd_addr > cur->rd_addr)
 			newn = &((*newn)->rb_right);
 		else
-			return;
+			return -EEXIST;
 	}
 
 	rb_link_node(&rgd->rd_node, parent, newn);
 	rb_insert_color(&rgd->rd_node, &sdp->sd_rindex_tree);
+	sdp->sd_rgrps++;
+	return 0;
 }
 
 /**
@@ -631,10 +631,12 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 	if (rgd->rd_data > sdp->sd_max_rg_data)
 		sdp->sd_max_rg_data = rgd->rd_data;
 	spin_lock(&sdp->sd_rindex_spin);
-	rgd_insert(rgd);
-	sdp->sd_rgrps++;
+	error = rgd_insert(rgd);
 	spin_unlock(&sdp->sd_rindex_spin);
-	return error;
+	if (!error)
+		return 0;
+
+	error = 0; /* someone else read in the rgrp; free it and ignore it */
 
 fail:
 	kfree(rgd->rd_bits);
@@ -695,22 +697,18 @@ int gfs2_rindex_update(struct gfs2_sbd *sdp)
 
 	/* Read new copy from disk if we don't have the latest */
 	if (!sdp->sd_rindex_uptodate) {
-		mutex_lock(&sdp->sd_rindex_mutex);
 		if (!gfs2_glock_is_locked_by_me(gl)) {
 			error = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &ri_gh);
 			if (error)
-				goto out_unlock;
+				return error;
 			unlock_required = 1;
 		}
 		if (!sdp->sd_rindex_uptodate)
 			error = gfs2_ri_update(ip);
 		if (unlock_required)
 			gfs2_glock_dq_uninit(&ri_gh);
-out_unlock:
-		mutex_unlock(&sdp->sd_rindex_mutex);
 	}
 
-
 	return error;
 }
 
-- 
1.7.4

