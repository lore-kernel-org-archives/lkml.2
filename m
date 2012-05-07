Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2EGOO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:14:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38192 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab2EGOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:12:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
        michael.brantley@deshaw.com
Subject: [PATCH v1 RESEND 08/12] vfs: make rmdir retry on ESTALE errors
Date: Mon,  7 May 2012 10:12:07 -0400
Message-Id: <1336399931-20234-9-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336399931-20234-1-git-send-email-jlayton@redhat.com>
References: <1336399931-20234-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |   76 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 40 insertions(+), 36 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c8254de..58f5eae 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2762,50 +2762,54 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	char * name;
 	struct dentry *dentry;
 	struct nameidata nd;
+	unsigned int try = 0;
 
-	error = user_path_parent(dfd, pathname, &nd, &name, false);
-	if (error)
-		return error;
+	do {
+		error = user_path_parent(dfd, pathname, &nd, &name, try);
+		if (error)
+			break;
 
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
+		switch(nd.last_type) {
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
+		nd.flags &= ~LOOKUP_PARENT;
 
-	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
-		goto exit2;
-	if (!dentry->d_inode) {
-		error = -ENOENT;
-		goto exit3;
-	}
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto exit3;
-	error = security_path_rmdir(&nd.path, dentry);
-	if (error)
-		goto exit4;
-	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+		mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex,
+							I_MUTEX_PARENT);
+		dentry = lookup_hash(&nd);
+		error = PTR_ERR(dentry);
+		if (IS_ERR(dentry))
+			goto exit2;
+		if (!dentry->d_inode) {
+			error = -ENOENT;
+			goto exit3;
+		}
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto exit3;
+		error = security_path_rmdir(&nd.path, dentry);
+		if (error)
+			goto exit4;
+		error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
 exit4:
-	mnt_drop_write(nd.path.mnt);
+		mnt_drop_write(nd.path.mnt);
 exit3:
-	dput(dentry);
+		dput(dentry);
 exit2:
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
-	path_put(&nd.path);
-	putname(name);
+		path_put(&nd.path);
+		putname(name);
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.7.6

