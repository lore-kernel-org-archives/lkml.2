Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2I0Mwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab2I0Mwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:32 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] fs/namei.c: introduce macro AT_FDINV
Date: Thu, 27 Sep 2012 20:51:53 +0800
Message-Id: <1348750316-4138-5-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File descriptor is irrelevent when LOOKUP_ROOT is set.
Introduce AT_FDINV to avoid using hard coded value or reusing
existing macro.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/namei.c            |   11 ++++++-----
 include/linux/fcntl.h |    2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c5b85b3..5ffd97d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2034,8 +2034,8 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 	nd.root.dentry = dentry;
 	nd.root.mnt = mnt;
 	BUG_ON(flags & LOOKUP_PARENT);
-	/* the first argument of do_path_lookup() is ignored with LOOKUP_ROOT */
-	err = do_path_lookup(AT_FDCWD, name, flags | LOOKUP_ROOT, &nd);
+
+	err = do_path_lookup(AT_FDINV, name, flags | LOOKUP_ROOT, &nd);
 	if (!err)
 		*path = nd.path;
 	return err;
@@ -2969,11 +2969,12 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	if (dentry->d_inode->i_op->follow_link && op->intent & LOOKUP_OPEN)
 		return ERR_PTR(-ELOOP);
 
-	file = path_openat(-1, name, &nd, op, flags | LOOKUP_RCU);
+	file = path_openat(AT_FDINV, name, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(file == ERR_PTR(-ECHILD)))
-		file = path_openat(-1, name, &nd, op, flags);
+		file = path_openat(AT_FDINV, name, &nd, op, flags);
 	if (unlikely(file == ERR_PTR(-ESTALE)))
-		file = path_openat(-1, name, &nd, op, flags | LOOKUP_REVAL);
+		file = path_openat(AT_FDINV, name, &nd, op,
+						flags | LOOKUP_REVAL);
 	return file;
 }
 
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index f550f89..abd94fe 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -41,6 +41,8 @@
 #define AT_FDCWD		-100    /* Special value used to indicate
                                            openat should use the current
                                            working directory. */
+#define AT_FDINV		-200	/* Special value used when LOOKUP_ROOT
+					   is set. */
 #define AT_SYMLINK_NOFOLLOW	0x100   /* Do not follow symbolic links.  */
 #define AT_REMOVEDIR		0x200   /* Remove directory instead of
                                            unlinking file.  */
-- 
1.7.9.5

