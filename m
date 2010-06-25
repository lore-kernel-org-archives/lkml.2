Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0FYTGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab0FYTGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:06:43 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 38/38] union-mount: Implement union-aware lsetxattr()
Date: Fri, 25 Jun 2010 12:05:28 -0700
Message-Id: <1277492728-11446-39-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/xattr.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 66bb5c7..4e2b5f6 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -320,17 +320,36 @@ SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 		size_t, size, int, flags)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
+	char *tmp;
 	int error;
 
-	error = user_lpath(pathname, &path);
+	error = user_path_nd(AT_FDCWD, pathname, 0, &nd, &path, &tmp);
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

