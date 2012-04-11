Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2DKJVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab2DKJVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:21:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Make sure rindex is uptodate before starting transactions
Date: Wed, 11 Apr 2012 09:56:53 +0100
Message-Id: <1334134614-19805-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
References: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removes the call from gfs2_blk2rgrd to function
gfs2_rindex_update and replaces it with individual calls.
The former way turned out to be too problematic.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 197c5c4..03c04fe 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -724,7 +724,11 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	int metadata;
 	unsigned int revokes = 0;
 	int x;
-	int error = 0;
+	int error;
+
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
 
 	if (!*top)
 		sm->sm_first = 0;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c35573a..a836056 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1844,6 +1844,10 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	unsigned int x, size = len * sizeof(u64);
 	int error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	memset(&rlist, 0, sizeof(struct gfs2_rgrp_list));
 
 	ht = kzalloc(size, GFP_NOFS);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c98a60e..a9ba244 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1031,7 +1031,13 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct gfs2_holder ghs[3];
 	struct gfs2_rgrpd *rgd;
-	int error = -EROFS;
+	int error;
+
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
+	error = -EROFS;
 
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
@@ -1224,6 +1230,10 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			return 0;
 	}
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	if (odip != ndip) {
 		error = gfs2_glock_nq_init(sdp->sd_rename_gl, LM_ST_EXCLUSIVE,
 					   0, &r_gh);
@@ -1345,7 +1355,6 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	error = alloc_required;
 	if (error < 0)
 		goto out_gunlock;
-	error = 0;
 
 	if (alloc_required) {
 		struct gfs2_qadata *qa = gfs2_qadata_get(ndip);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 19354a2..3df65c9 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -332,9 +332,6 @@ struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk, bool exact)
 	struct rb_node *n, *next;
 	struct gfs2_rgrpd *cur;
 
-	if (gfs2_rindex_update(sdp))
-		return NULL;
-
 	spin_lock(&sdp->sd_rindex_spin);
 	n = sdp->sd_rindex_tree.rb_node;
 	while (n) {
@@ -928,6 +925,10 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	} else if (copy_from_user(&r, argp, sizeof(r)))
 		return -EFAULT;
 
+	ret = gfs2_rindex_update(sdp);
+	if (ret)
+		return ret;
+
 	rgd = gfs2_blk2rgrpd(sdp, r.start, 0);
 	rgd_end = gfs2_blk2rgrpd(sdp, r.start + r.len, 0);
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 2e5ba42..927f4df 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -238,6 +238,10 @@ static int ea_dealloc_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	unsigned int x;
 	int error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	if (GFS2_EA_IS_STUFFED(ea))
 		return 0;
 
@@ -1330,6 +1334,10 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 	unsigned int x;
 	int error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	memset(&rlist, 0, sizeof(struct gfs2_rgrp_list));
 
 	error = gfs2_meta_read(ip->i_gl, ip->i_eattr, DIO_WAIT, &indbh);
@@ -1439,6 +1447,10 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	struct gfs2_holder gh;
 	int error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_eattr, 1);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
-- 
1.7.4

