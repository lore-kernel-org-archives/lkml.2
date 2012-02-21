Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2BUUGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:06:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab2BUTwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 60/73] union-mount: Implement union-aware access()/faccessat()
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:05:01 +0000
Message-ID: <20120221180501.25235.58527.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

For union mounts, a file located on the lower layer will incorrectly
return EROFS on an access check.  To fix this, use the new
path_permission() call, which ignores a read-only lower layer file
system if the target will be copied up to the topmost file system.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/open.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3c44148..d3be9e3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -32,6 +32,7 @@
 #include <linux/dnotify.h>
 
 #include "internal.h"
+#include "union.h"
 
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
@@ -301,7 +302,11 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	const struct cred *old_cred;
 	struct cred *override_cred;
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
 	struct inode *inode;
+	umode_t i_mode;
+	char *tmp;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
@@ -325,25 +330,47 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	old_cred = override_creds(override_cred);
 
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	res = user_path_nd(dfd, filename, LOOKUP_FOLLOW, &nd, &path, &tmp);
 	if (res)
 		goto out;
 
+	/* For union mounts, use the topmost mnt's permissions */
+	mnt = path.mnt;
+	if (IS_MNT_LOWER(mnt))
+		mnt = nd.path.mnt;
+
 	inode = path.dentry->d_inode;
+	i_mode = inode->i_mode;
 
-	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+	if ((mode & MAY_EXEC) && S_ISREG(i_mode)) {
 		/*
 		 * MAY_EXEC on regular files is denied if the fs is mounted
 		 * with the "noexec" flag.
 		 */
 		res = -EACCES;
-		if (path.mnt->mnt_flags & MNT_NOEXEC)
+		if (mnt->mnt_flags & MNT_NOEXEC)
+			goto out_path_release;
+	}
+
+	mode |= MAY_ACCESS;
+	if ((mode & MAY_WRITE) && unlikely(IS_MNT_LOWER(path.mnt))) {
+		/* If we need to copy up, then the upperfs of a union must be
+		 * writable.  The lowerfs must be mounted read-only for the
+		 * union to exist, but we don't care about that.
+		 */
+		res = -EROFS;
+		if ((mnt->mnt_sb->s_flags & MS_RDONLY) &&
+		    (S_ISREG(i_mode) || S_ISDIR(i_mode) || S_ISLNK(i_mode)))
 			goto out_path_release;
+
+		/* We do need write permission on the lower inode, however */
+		res = __inode_permission(inode, mode);
+	} else {
+		res = inode_permission(inode, mode);
 	}
 
-	res = inode_permission(inode, mode | MAY_ACCESS);
 	/* SuS v2 requires we report a read only fs too */
-	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
+	if (res || !(mode & MAY_WRITE) || special_file(inode->i_mode))
 		goto out_path_release;
 	/*
 	 * This is a rare case where using __mnt_is_readonly()
@@ -355,11 +382,13 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
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

