Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2JBAX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:23:29 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:56065 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2JBARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:46 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 28/49] vfs: fix linkat to retry on ESTALE errors
Date: Mon,  1 Oct 2012 20:16:37 -0400
Message-Id: <1349137018-21948-29-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fb9d36f..e0ee4b9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3616,6 +3616,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	struct path old_path, new_path;
 	int how = 0;
 	int error;
+	unsigned int try = 0;
 
 	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
@@ -3633,30 +3634,35 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 
-	error = user_path_at(olddfd, oldname, how, &old_path);
-	if (error)
-		return error;
+	do {
+		error = user_path_at(olddfd, oldname, how, &old_path);
+		if (error)
+			break;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path, false, false);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
-		goto out;
+		new_dentry = user_path_create(newdfd, newname, &new_path,
+						false, false);
+		error = PTR_ERR(new_dentry);
+		if (IS_ERR(new_dentry))
+			goto out;
 
-	error = -EXDEV;
-	if (old_path.mnt != new_path.mnt)
-		goto out_dput;
-	error = may_linkat(&old_path);
-	if (unlikely(error))
-		goto out_dput;
-	error = security_path_link(old_path.dentry, &new_path, new_dentry);
-	if (error)
-		goto out_dput;
-	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry);
+		error = -EXDEV;
+		if (old_path.mnt != new_path.mnt)
+			goto out_dput;
+		error = may_linkat(&old_path);
+		if (unlikely(error))
+			goto out_dput;
+		error = security_path_link(old_path.dentry, &new_path,
+						new_dentry);
+		if (error)
+			goto out_dput;
+		error = vfs_link(old_path.dentry, new_path.dentry->d_inode,
+						new_dentry);
 out_dput:
-	done_path_create(&new_path, new_dentry);
+		done_path_create(&new_path, new_dentry);
 out:
-	path_put(&old_path);
-
+		path_put(&old_path);
+		how |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

