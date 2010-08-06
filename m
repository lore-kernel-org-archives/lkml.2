Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826Ab0HFWhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935126Ab0HFWhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:37:09 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 28/38] union-mount: Implement union-aware access()/faccessat()
Date: Fri,  6 Aug 2010 15:35:14 -0700
Message-Id: <1281134124-17041-29-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For union mounts, a file located on the lower layer will incorrectly
return EROFS on an access check.  To fix this, use the new
path_permission() call, which ignores a read-only lower layer file
system if the target will be copied up to the topmost file system.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/open.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5463266..fc56da0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -31,6 +31,7 @@
 #include <linux/ima.h>
 
 #include "internal.h"
+#include "union.h"
 
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
@@ -288,7 +289,10 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	const struct cred *old_cred;
 	struct cred *override_cred;
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
 	struct inode *inode;
+	char *tmp;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
@@ -312,10 +316,17 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	old_cred = override_creds(override_cred);
 
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	res = user_path_nd(dfd, filename, LOOKUP_FOLLOW,
+				   &nd, &path, &tmp);
 	if (res)
 		goto out;
 
+	/* For union mounts, use the topmost mnt's permissions */
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
 	inode = path.dentry->d_inode;
 
 	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
@@ -324,11 +335,11 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
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
@@ -342,11 +353,13 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
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

