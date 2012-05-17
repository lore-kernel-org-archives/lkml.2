Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966288Ab2EQMvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:51:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761823Ab2EQMso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrew Price <anprice@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/24] GFS2: Remove unused argument from gfs2_internal_read
Date: Thu, 17 May 2012 13:23:20 +0100
Message-Id: <1337257411-3173-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

gfs2_internal_read accepts an unused ra_state argument, left over from
when we did readahead on the rindex. Since there are currently no plans
to add back this readahead, this patch removes the ra_state parameter
and updates the functions which call gfs2_internal_read accordingly.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index a627b3e..695bbe1 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -517,15 +517,14 @@ out:
 /**
  * gfs2_internal_read - read an internal file
  * @ip: The gfs2 inode
- * @ra_state: The readahead state (or NULL for no readahead)
  * @buf: The buffer to fill
  * @pos: The file position
  * @size: The amount to read
  *
  */
 
-int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
-                       char *buf, loff_t *pos, unsigned size)
+int gfs2_internal_read(struct gfs2_inode *ip, char *buf, loff_t *pos,
+                       unsigned size)
 {
 	struct address_space *mapping = ip->i_inode.i_mapping;
 	unsigned long index = *pos / PAGE_CACHE_SIZE;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 5d345b4..c53c747 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -17,7 +17,6 @@
 
 extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
 extern int gfs2_internal_read(struct gfs2_inode *ip,
-			      struct file_ra_state *ra_state,
 			      char *buf, loff_t *pos, unsigned size);
 extern void gfs2_set_aops(struct inode *inode);
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6019da3..45d9171 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -652,7 +652,7 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	}
 
 	memset(&q, 0, sizeof(struct gfs2_quota));
-	err = gfs2_internal_read(ip, NULL, (char *)&q, &loc, sizeof(q));
+	err = gfs2_internal_read(ip, (char *)&q, &loc, sizeof(q));
 	if (err < 0)
 		return err;
 
@@ -852,7 +852,7 @@ static int update_qd(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd)
 
 	memset(&q, 0, sizeof(struct gfs2_quota));
 	pos = qd2offset(qd);
-	error = gfs2_internal_read(ip, NULL, (char *)&q, &pos, sizeof(q));
+	error = gfs2_internal_read(ip, (char *)&q, &pos, sizeof(q));
 	if (error < 0)
 		return error;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7a1cf67..b550e5c 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -541,16 +541,14 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 	struct inode *inode = sdp->sd_rindex;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	char buf[sizeof(struct gfs2_rindex)];
-	struct file_ra_state ra_state;
 	int error, rgrps;
 
-	file_ra_state_init(&ra_state, inode->i_mapping);
 	for (rgrps = 0;; rgrps++) {
 		loff_t pos = rgrps * sizeof(struct gfs2_rindex);
 
 		if (pos + sizeof(struct gfs2_rindex) > i_size_read(inode))
 			break;
-		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
+		error = gfs2_internal_read(ip, buf, &pos,
 					   sizeof(struct gfs2_rindex));
 		if (error != sizeof(struct gfs2_rindex))
 			break;
@@ -586,14 +584,12 @@ static int rgd_insert(struct gfs2_rgrpd *rgd)
 
 /**
  * read_rindex_entry - Pull in a new resource index entry from the disk
- * @ip: The GFS2 inode
- * @ra_state: The read-ahead state
+ * @ip: Pointer to the rindex inode
  *
  * Returns: 0 on success, > 0 on EOF, error code otherwise
  */
 
-static int read_rindex_entry(struct gfs2_inode *ip,
-			     struct file_ra_state *ra_state)
+static int read_rindex_entry(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	loff_t pos = sdp->sd_rgrps * sizeof(struct gfs2_rindex);
@@ -604,7 +600,7 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 	if (pos >= i_size_read(&ip->i_inode))
 		return 1;
 
-	error = gfs2_internal_read(ip, ra_state, (char *)&buf, &pos,
+	error = gfs2_internal_read(ip, (char *)&buf, &pos,
 				   sizeof(struct gfs2_rindex));
 
 	if (error != sizeof(struct gfs2_rindex))
@@ -660,13 +656,10 @@ fail:
 static int gfs2_ri_update(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct inode *inode = &ip->i_inode;
-	struct file_ra_state ra_state;
 	int error;
 
-	file_ra_state_init(&ra_state, inode->i_mapping);
 	do {
-		error = read_rindex_entry(ip, &ra_state);
+		error = read_rindex_entry(ip);
 	} while (error == 0);
 
 	if (error < 0)
-- 
1.7.4

