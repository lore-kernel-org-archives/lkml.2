Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab0FOSsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443Ab0FOSmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:08 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 37/38] union-mount: Implement union-aware setxattr()
Date: Tue, 15 Jun 2010 11:40:07 -0700
Message-Id: <1276627208-17242-38-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/xattr.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 46f87e8..66bb5c7 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -19,7 +19,7 @@
 #include <linux/fsnotify.h>
 #include <linux/audit.h>
 #include <asm/uaccess.h>
-
+#include "union.h"
 
 /*
  * Check permissions for extended attribute access.  This is a bit complicated
@@ -281,17 +281,37 @@ SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 		size_t, size, int, flags)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
+	char *tmp;
 	int error;
 
-	error = user_path(pathname, &path);
+	error = user_path_nd(AT_FDCWD, pathname, LOOKUP_FOLLOW, &nd, &path,
+			     &tmp);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
-	if (!error) {
-		error = setxattr(path.dentry, name, value, size, flags);
-		mnt_drop_write(path.mnt);
-	}
+
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
+	error = mnt_want_write(mnt);
+	if (error)
+		goto out;
+
+	error = union_copyup(&nd, &path);
+	if (error)
+		goto out_drop_write;
+
+	error = setxattr(path.dentry, name, value, size, flags);
+
+out_drop_write:
+	mnt_drop_write(mnt);
+out:
 	path_put(&path);
+	path_put(&nd.path);
+	putname(tmp);
 	return error;
 }
 
-- 
1.6.3.3

