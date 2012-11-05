Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab2KEPWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:22:46 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:48884 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab2KEPWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:40 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 10/34] vfs: make rmdir retry on ESTALE errors
Date: Mon,  5 Nov 2012 10:21:49 -0500
Message-Id: <1352128933-28526-11-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 79 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 37 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1569ccd..0b70e6d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3344,49 +3344,54 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	struct filename *name;
 	struct dentry *dentry;
 	struct nameidata nd;
+	unsigned int try = 0;
 
-	name = user_path_parent(dfd, pathname, &nd, 0);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
-	switch(nd.last_type) {
-	case LAST_DOTDOT:
-		error = -ENOTEMPTY;
-		goto exit1;
-	case LAST_DOT:
-		error = -EINVAL;
-		goto exit1;
-	case LAST_ROOT:
-		error = -EBUSY;
-		goto exit1;
-	}
+	do {
+		name = user_path_parent(dfd, pathname, &nd, try);
+		if (IS_ERR(name))
+			return PTR_ERR(name);
+
+		switch (nd.last_type) {
+		case LAST_DOTDOT:
+			error = -ENOTEMPTY;
+			goto exit1;
+		case LAST_DOT:
+			error = -EINVAL;
+			goto exit1;
+		case LAST_ROOT:
+			error = -EBUSY;
+			goto exit1;
+		}
 
-	nd.flags &= ~LOOKUP_PARENT;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto exit1;
+		nd.flags &= ~LOOKUP_PARENT;
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto exit1;
 
-	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
-		goto exit2;
-	if (!dentry->d_inode) {
-		error = -ENOENT;
-		goto exit3;
-	}
-	error = security_path_rmdir(&nd.path, dentry);
-	if (error)
-		goto exit3;
-	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+		mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex,
+					I_MUTEX_PARENT);
+		dentry = lookup_hash(&nd);
+		if (IS_ERR(dentry)) {
+			error = PTR_ERR(dentry);
+			goto exit2;
+		}
+		if (!dentry->d_inode) {
+			error = -ENOENT;
+			goto exit3;
+		}
+		error = security_path_rmdir(&nd.path, dentry);
+		if (error)
+			goto exit3;
+		error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
 exit3:
-	dput(dentry);
+		dput(dentry);
 exit2:
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	mnt_drop_write(nd.path.mnt);
+		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+		mnt_drop_write(nd.path.mnt);
 exit1:
-	path_put(&nd.path);
-	putname(name);
+		path_put(&nd.path);
+		putname(name);
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.7

