Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab0FYTLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab0FYTGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:06:42 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 37/38] union-mount: Implement union-aware setxattr()
Date: Fri, 25 Jun 2010 12:05:27 -0700
Message-Id: <1277492728-11446-38-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
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

