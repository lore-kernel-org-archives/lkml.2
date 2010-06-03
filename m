Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0FCQJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:09:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34251 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0FCQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:09:07 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 11/11] vfs: Support null pathname in linkat
Date: Thu,  3 Jun 2010 21:38:41 +0530
Message-Id: <1275581321-5861-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.236.g81fa0
In-Reply-To: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use linkat to create hardlinks from a
file descriptor pointing to the file. This can be used
with open_by_handle syscall that returns a file descriptor.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 417bf53..8b1cc23 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2533,16 +2533,27 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 {
 	struct dentry *new_dentry;
 	struct nameidata nd;
-	struct path old_path;
+	struct path old_path, *old_pathp;
+	struct file *file = NULL;
 	int error;
 	char *to;
 
 	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
 		return -EINVAL;
 
-	error = user_path_at(olddfd, oldname,
-			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
-			     &old_path);
+	if (oldname == NULL && olddfd != AT_FDCWD) {
+		file = fget(olddfd);
+		if (file) {
+			old_pathp = &file->f_path;
+			error = 0;
+		} else
+			error = -EBADF;
+	} else {
+		error = user_path_at(olddfd, oldname,
+				flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
+				&old_path);
+		old_pathp = &old_path;
+	}
 	if (error)
 		return error;
 
@@ -2550,7 +2561,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_path.mnt != nd.path.mnt)
+	if (old_pathp->mnt != nd.path.mnt)
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
@@ -2559,10 +2570,11 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
+	error = security_path_link(old_pathp->dentry, &nd.path, new_dentry);
 	if (error)
 		goto out_drop_write;
-	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
+	error = vfs_link(old_pathp->dentry,
+			nd.path.dentry->d_inode, new_dentry);
 out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 out_dput:
@@ -2573,7 +2585,10 @@ out_release:
 	path_put(&nd.path);
 	putname(to);
 out:
-	path_put(&old_path);
+	if (file)
+		fput(file);
+	else
+		path_put(&old_path);
 
 	return error;
 }
-- 
1.7.1.236.g81fa0

