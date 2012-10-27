Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2J0MeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:34:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47879 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2J0Md6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:33:58 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 05/32] vfs: fix mknodat to retry on ESTALE errors
Date: Sat, 27 Oct 2012 08:33:12 -0400
Message-Id: <1351341219-17837-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a2bb283..7b0ca39 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3177,34 +3177,41 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
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
1.7.11.7

