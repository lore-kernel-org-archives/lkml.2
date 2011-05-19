Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab1ESJN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933Ab1ESJK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/32] GFS2: Double check link count under glock
Date: Thu, 19 May 2011 09:47:13 +0100
Message-Id: <1305794847-3291-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid any possible races relating to the link count, we need to
recheck it under the inode's glock in all cases where it matters.
Also to ensure we never get any nasty surprises, this patch also
ensures that once the link count has hit zero it can never be
elevated by rereading in data from disk.

The only place we cannot provide a proper solution is in rename
in the case where we are removing a target inode and we discover
that the target inode has been already unlinked on another node.
The race window is very small, and we return EAGAIN in this case
to indicate what has happened. The proper solution would be to move
the lookup parts of rename from the vfs into library calls which
the fs could call directly, but that is potentially a very big job
and this fix should cover most cases for now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 94c3a7d..5a02606 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -248,6 +248,32 @@ fail_iput:
 	goto fail;
 }
 
+/**
+ * gfs2_set_nlink - Set the inode's link count based on on-disk info
+ * @inode: The inode in question
+ * @nlink: The link count
+ *
+ * If the link count has hit zero, it must never be raised, whatever the
+ * on-disk inode might say. When new struct inodes are created the link
+ * count is set to 1, so that we can safely use this test even when reading
+ * in on disk information for the first time.
+ */
+
+static void gfs2_set_nlink(struct inode *inode, u32 nlink)
+{
+	/*
+	 * We will need to review setting the nlink count here in the
+	 * light of the forthcoming ro bind mount work. This is a reminder
+	 * to do that.
+	 */
+	if ((inode->i_nlink != nlink) && (inode->i_nlink != 0)) {
+		if (nlink == 0)
+			clear_nlink(inode);
+		else
+			inode->i_nlink = nlink;
+	}
+}
+
 static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
 	const struct gfs2_dinode *str = buf;
@@ -269,12 +295,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 
 	ip->i_inode.i_uid = be32_to_cpu(str->di_uid);
 	ip->i_inode.i_gid = be32_to_cpu(str->di_gid);
-	/*
-	 * We will need to review setting the nlink count here in the
-	 * light of the forthcoming ro bind mount work. This is a reminder
-	 * to do that.
-	 */
-	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
+	gfs2_set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
 	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
@@ -484,7 +505,7 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 
 	/*  Don't create entries in an unlinked directory  */
 	if (!dip->i_inode.i_nlink)
-		return -EPERM;
+		return -ENOENT;
 
 	error = gfs2_dir_check(&dip->i_inode, name, NULL);
 	switch (error) {
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 09e436a..1005f9e 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -162,6 +162,10 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out_child;
 
+	error = -ENOENT;
+	if (inode->i_nlink == 0)
+		goto out_gunlock;
+
 	error = gfs2_permission(dir, MAY_WRITE | MAY_EXEC, 0);
 	if (error)
 		goto out_gunlock;
@@ -335,6 +339,10 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	if (error)
 		goto out_child;
 
+	error = -ENOENT;
+	if (ip->i_inode.i_nlink == 0)
+		goto out_rgrp;
+
 	error = gfs2_glock_nq(ghs + 2); /* rgrp */
 	if (error)
 		goto out_rgrp;
@@ -589,6 +597,10 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	if (error)
 		goto out_child;
 
+	error = -ENOENT;
+	if (ip->i_inode.i_nlink == 0)
+		goto out_rgrp;
+
 	error = gfs2_glock_nq(ghs + 2); /* rgrp */
 	if (error)
 		goto out_rgrp;
@@ -792,6 +804,10 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock;
 	}
 
+	error = -ENOENT;
+	if (ip->i_inode.i_nlink == 0)
+		goto out_gunlock;
+
 	/* Check out the old directory */
 
 	error = gfs2_unlink_ok(odip, &odentry->d_name, ip);
@@ -805,6 +821,11 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_gunlock;
 
+		if (nip->i_inode.i_nlink == 0) {
+			error = -EAGAIN;
+			goto out_gunlock;
+		}
+
 		if (S_ISDIR(nip->i_inode.i_mode)) {
 			if (nip->i_entries < 2) {
 				if (gfs2_consist_inode(nip))
@@ -835,7 +856,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 
 		if (odip != ndip) {
 			if (!ndip->i_inode.i_nlink) {
-				error = -EINVAL;
+				error = -ENOENT;
 				goto out_gunlock;
 			}
 			if (ndip->i_entries == (u32)-1) {
-- 
1.7.4

