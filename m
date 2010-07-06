Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0GFSjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:39:36 -0400
Received: from [202.81.31.147] ([202.81.31.147]:36517 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0GFSiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:38:55 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 7/9] vfs: Support null pathname in linkat
Date: Wed,  7 Jul 2010 00:08:09 +0530
Message-Id: <1278441491-12785-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc1
In-Reply-To: <1278441491-12785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278441491-12785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use linkat to create hardlinks from a
file descriptor pointing to the file. This can be used
with open_by_handle syscall that returns a file descriptor.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 417bf53..41d842f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2533,16 +2533,27 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
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
+		fput_light(file, fput_needed);
+	else
+		path_put(&old_path);
 
 	return error;
 }
-- 
1.7.2.rc1

