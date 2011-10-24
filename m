Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1JXMvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab1JXMrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/24] GFS2: Clean up gfs2_create
Date: Mon, 24 Oct 2011 13:48:22 +0100
Message-Id: <1319460518-9046-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass through knowledge of whether the creation is intended to be
exclusive or not, then we can deal with that in gfs2_create_inode
and remove one set of locking. Also this removes the loop in
gfs2_create and simplifies the code a bit.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index a0b53d3..2af6905 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -663,7 +663,7 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
 
 static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 			     unsigned int mode, dev_t dev, const char *symname,
-			     unsigned int size)
+			     unsigned int size, int excl)
 {
 	const struct qstr *name = &dentry->d_name;
 	struct gfs2_holder ghs[2];
@@ -683,6 +683,12 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail;
 
 	error = create_ok(dip, name, mode);
+	if ((error == -EEXIST) && S_ISREG(mode) && !excl) {
+		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
+		gfs2_glock_dq_uninit(ghs);
+		d_instantiate(dentry, inode);
+		return IS_ERR(inode) ? PTR_ERR(inode) : 0;
+	}
 	if (error)
 		goto fail_gunlock;
 
@@ -760,24 +766,10 @@ fail:
 static int gfs2_create(struct inode *dir, struct dentry *dentry,
 		       int mode, struct nameidata *nd)
 {
-	struct inode *inode;
-	int ret;
-
-	for (;;) {
-		ret = gfs2_create_inode(dir, dentry, S_IFREG | mode, 0, NULL, 0);
-		if (ret != -EEXIST || (nd && (nd->flags & LOOKUP_EXCL)))
-			return ret;
-
-		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
-		if (inode) {
-			if (!IS_ERR(inode))
-				break;
-			return PTR_ERR(inode);
-		}
-	}
-
-	d_instantiate(dentry, inode);
-	return 0;
+	int excl = 0;
+	if (nd && (nd->flags & LOOKUP_EXCL))
+		excl = 1;
+	return gfs2_create_inode(dir, dentry, S_IFREG | mode, 0, NULL, 0, excl);
 }
 
 /**
@@ -1135,7 +1127,7 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode) - 1)
 		return -ENAMETOOLONG;
 
-	return gfs2_create_inode(dir, dentry, S_IFLNK | S_IRWXUGO, 0, symname, size);
+	return gfs2_create_inode(dir, dentry, S_IFLNK | S_IRWXUGO, 0, symname, size, 0);
 }
 
 /**
@@ -1149,7 +1141,7 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 
 static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	return gfs2_create_inode(dir, dentry, S_IFDIR | mode, 0, NULL, 0);
+	return gfs2_create_inode(dir, dentry, S_IFDIR | mode, 0, NULL, 0, 0);
 }
 
 /**
@@ -1164,7 +1156,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 static int gfs2_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		      dev_t dev)
 {
-	return gfs2_create_inode(dir, dentry, mode, dev, NULL, 0);
+	return gfs2_create_inode(dir, dentry, mode, dev, NULL, 0, 0);
 }
 
 /*
-- 
1.7.4.4

