Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2JBAYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:24:07 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37625 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2JBARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 25/49] vfs: fix mknodat to retry on ESTALE errors
Date: Mon,  1 Oct 2012 20:16:34 -0400
Message-Id: <1349137018-21948-26-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6c75fc1..ac62973 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3180,34 +3180,41 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 	struct dentry *dentry;
 	struct path path;
 	int error;
+	unsigned int try = 0;
 
 	error = may_mknod(mode);
 	if (error)
 		return error;
 
-	dentry = user_path_create(dfd, filename, &path, false, false);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+	do {
+		dentry = user_path_create(dfd, filename, &path, false, try);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mknod(&path, dentry, mode, dev);
-	if (error)
-		goto out;
-	switch (mode & S_IFMT) {
-		case 0: case S_IFREG:
-			error = vfs_create(path.dentry->d_inode,dentry,mode,true);
+		if (!IS_POSIXACL(path.dentry->d_inode))
+			mode &= ~current_umask();
+		error = security_path_mknod(&path, dentry, mode, dev);
+		if (error)
+			goto out;
+		switch (mode & S_IFMT) {
+		case 0:
+		case S_IFREG:
+			error = vfs_create(path.dentry->d_inode, dentry,
+					mode, true);
 			break;
-		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(path.dentry->d_inode,dentry,mode,
+		case S_IFCHR:
+		case S_IFBLK:
+			error = vfs_mknod(path.dentry->d_inode, dentry, mode,
 					new_decode_dev(dev));
 			break;
-		case S_IFIFO: case S_IFSOCK:
-			error = vfs_mknod(path.dentry->d_inode,dentry,mode,0);
-			break;
-	}
+		case S_IFIFO:
+		case S_IFSOCK:
+			error = vfs_mknod(path.dentry->d_inode, dentry,
+					mode, 0);
+		}
 out:
-	done_path_create(&path, dentry);
+		done_path_create(&path, dentry);
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

