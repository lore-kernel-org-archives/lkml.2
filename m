Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0ECXO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab0ECXOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:14:01 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 29/39] union-mount: Implement union-aware access()/faccessat()
Date: Mon,  3 May 2010 16:12:28 -0700
Message-Id: <1272928358-20854-30-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For union mounts, a file located on the lower layer will incorrectly
return EROFS on an access check.  To fix this, use the new
path_permission() call, which ignores a read-only lower layer file
system if the target will be copied up to the topmost file system.
---
 fs/open.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..cb39b9d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
 #include <linux/ima.h>
+#include <linux/union.h>
 
 #include "internal.h"
 
@@ -454,7 +455,10 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	const struct cred *old_cred;
 	struct cred *override_cred;
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
 	struct inode *inode;
+	char *tmp;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
@@ -478,10 +482,17 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	old_cred = override_creds(override_cred);
 
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	res = user_path_nd(dfd, filename, LOOKUP_FOLLOW,
+				   &nd, &path, &tmp);
 	if (res)
 		goto out;
 
+	/* For union mounts, use the topmost mnt's permissions */
+	if (IS_UNIONED_DIR(&nd.path))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
 	inode = path.dentry->d_inode;
 
 	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
@@ -490,11 +501,11 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 		 * with the "noexec" flag.
 		 */
 		res = -EACCES;
-		if (path.mnt->mnt_flags & MNT_NOEXEC)
+		if (mnt->mnt_flags & MNT_NOEXEC)
 			goto out_path_release;
 	}
 
-	res = inode_permission(inode, mode | MAY_ACCESS);
+	res = path_permission(&path, &nd.path, mode | MAY_ACCESS);
 	/* SuS v2 requires we report a read only fs too */
 	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
 		goto out_path_release;
@@ -508,11 +519,13 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	 * inherently racy and know that the fs may change
 	 * state before we even see this result.
 	 */
-	if (__mnt_is_readonly(path.mnt))
+	if (__mnt_is_readonly(mnt))
 		res = -EROFS;
 
 out_path_release:
 	path_put(&path);
+	path_put(&nd.path);
+	putname(tmp);
 out:
 	revert_creds(old_cred);
 	put_cred(override_cred);
-- 
1.6.3.3

