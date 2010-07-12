Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0GLGgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:36:21 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47855 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0GLGgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:36:00 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V16 07/12] vfs: Support null pathname in linkat
Date: Mon, 12 Jul 2010 12:05:40 +0530
Message-Id: <1278916545-19751-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc1
In-Reply-To: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use linkat to create hardlinks from a
file descriptor pointing to the file. This can be used
with open_by_handle syscall that returns a file descriptor.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a6a8093..9a7b71a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2553,16 +2553,28 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
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
 
@@ -2570,7 +2582,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_path.mnt != nd.path.mnt)
+	if (old_pathp->mnt != nd.path.mnt)
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
@@ -2579,10 +2591,11 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
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
@@ -2593,7 +2606,10 @@ out_release:
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

