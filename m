Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966533Ab0GSTNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:13:10 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53057 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966503Ab0GSTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:13:03 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V17 07/12] vfs: Support null pathname in linkat
Date: Tue, 20 Jul 2010 00:42:02 +0530
Message-Id: <1279566727-16598-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc3.43.g24e7a
In-Reply-To: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use linkat to create hardlinks from a
file descriptor pointing to the file. This can be used
with open_by_handle syscall that returns a file descriptor.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6f4f9f6..002ee3d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2636,7 +2636,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
-	if (!inode)
+	if (!inode || inode->i_nlink == 0)
 		return -ENOENT;
 
 	error = may_create(dir, new_dentry);
@@ -2682,16 +2682,28 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 {
 	struct dentry *new_dentry;
 	struct nameidata nd;
-	struct path old_path;
-	int error;
+	struct path old_path, *old_pathp;
+	struct file *file = NULL;
+	int error, fput_needed;
 	char *to;
 
 	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
 		return -EINVAL;
 
-	error = user_path_at(olddfd, oldname,
-			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
-			     &old_path);
+	if (oldname == NULL && olddfd != AT_FDCWD) {
+		file = fget_light(olddfd, &fput_needed);
+		if (file) {
+			old_pathp = &file->f_path;
+			error = 0;
+		} else
+			error = -EBADF;
+	} else {
+		error = user_path_at(olddfd, oldname,
+				     flags & AT_SYMLINK_FOLLOW ?
+				     LOOKUP_FOLLOW : 0,
+				     &old_path);
+		old_pathp = &old_path;
+	}
 	if (error)
 		return error;
 
@@ -2699,7 +2711,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_path.mnt != nd.path.mnt)
+	if (old_pathp->mnt != nd.path.mnt)
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
@@ -2708,10 +2720,11 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
+	error = security_path_link(old_pathp->dentry, &nd.path, new_dentry);
 	if (error)
 		goto out_drop_write;
-	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
+	error = vfs_link(old_pathp->dentry,
+			 nd.path.dentry->d_inode, new_dentry);
 out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 out_dput:
@@ -2722,7 +2735,10 @@ out_release:
 	path_put(&nd.path);
 	putname(to);
 out:
-	path_put(&old_path);
+	if (file)
+		fput_light(file, fput_needed);
+	else
+		path_put(&old_path);
 
 	return error;
 }
-- 
1.7.2.rc3.43.g24e7a

