Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0GFSkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:40:00 -0400
Received: from [202.81.31.141] ([202.81.31.141]:42202 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0GFSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:38:52 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/9] vfs: Support null pathname in faccessat
Date: Wed,  7 Jul 2010 00:08:08 +0530
Message-Id: <1278441491-12785-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc1
In-Reply-To: <1278441491-12785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278441491-12785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use faccessat to get the access check details
from a file descriptor pointing to the file. This can be used
with open_by_handle syscall that returns a file descriptor.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index fdf832c..8621889 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -288,9 +288,10 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 {
 	const struct cred *old_cred;
 	struct cred *override_cred;
-	struct path path;
+	struct file *file = NULL;
+	struct path path, *pp;
 	struct inode *inode;
-	int res;
+	int res, fput_needed;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
@@ -312,12 +313,21 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	}
 
 	old_cred = override_creds(override_cred);
-
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	if (filename == NULL  && dfd != AT_FDCWD) {
+		file = fget_light(dfd, &fput_needed);
+		if (file) {
+			pp = &file->f_path;
+			res = 0;
+		} else
+			res = -EBADF;
+	} else {
+		res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+		pp = &path;
+	}
 	if (res)
 		goto out;
 
-	inode = path.dentry->d_inode;
+	inode = pp->dentry->d_inode;
 
 	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
 		/*
@@ -325,7 +335,7 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 		 * with the "noexec" flag.
 		 */
 		res = -EACCES;
-		if (path.mnt->mnt_flags & MNT_NOEXEC)
+		if (pp->mnt->mnt_flags & MNT_NOEXEC)
 			goto out_path_release;
 	}
 
@@ -343,11 +353,14 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	 * inherently racy and know that the fs may change
 	 * state before we even see this result.
 	 */
-	if (__mnt_is_readonly(path.mnt))
+	if (__mnt_is_readonly(pp->mnt))
 		res = -EROFS;
 
 out_path_release:
-	path_put(&path);
+	if (file)
+		fput_light(file, fput_needed);
+	else
+		path_put(&path);
 out:
 	revert_creds(old_cred);
 	put_cred(override_cred);
-- 
1.7.2.rc1

