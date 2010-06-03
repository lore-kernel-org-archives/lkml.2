Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0FCQJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:09:09 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34248 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0FCQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:09:05 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 10/11] vfs: Support null pathname in faccessat
Date: Thu,  3 Jun 2010 21:38:40 +0530
Message-Id: <1275581321-5861-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.236.g81fa0
In-Reply-To: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use faccessat to get the access check details
from a file descriptor pointing to the file. This can be used
with open_by_handle syscall that returns a file descriptor.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3cff394..8998f2e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -288,7 +288,8 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 {
 	const struct cred *old_cred;
 	struct cred *override_cred;
-	struct path path;
+	struct file *file = NULL;
+	struct path path, *pp;
 	struct inode *inode;
 	int res;
 
@@ -312,12 +313,21 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	}
 
 	old_cred = override_creds(override_cred);
-
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	if (filename == NULL  && dfd != AT_FDCWD) {
+		file = fget(dfd);
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
+		fput(file);
+	else
+		path_put(&path);
 out:
 	revert_creds(old_cred);
 	put_cred(override_cred);
-- 
1.7.1.236.g81fa0

