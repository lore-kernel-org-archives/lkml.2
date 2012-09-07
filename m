Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab2IGOXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:23:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42139 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760726Ab2IGOS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:18:58 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v6 14/20] vfs: have faccessat retry once on an ESTALE error
Date: Fri,  7 Sep 2012 10:18:21 -0400
Message-Id: <1347027507-20956-15-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
References: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 64 +++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5dcee00..a5a5c9a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -312,6 +312,8 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	struct path path;
 	struct inode *inode;
 	int res;
+	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	unsigned int try = 0;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
@@ -335,42 +337,44 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	old_cred = override_creds(override_cred);
 
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
-	if (res)
-		goto out;
+	do {
+		res = user_path_at(dfd, filename, lookup_flags, &path);
+		if (res)
+			break;
 
-	inode = path.dentry->d_inode;
+		inode = path.dentry->d_inode;
+
+		if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+			/*
+			 * MAY_EXEC on regular files is denied if the fs is
+			 * mounted with the "noexec" flag.
+			 */
+			res = -EACCES;
+			if (path.mnt->mnt_flags & MNT_NOEXEC)
+				goto out_path_release;
+		}
 
-	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		res = inode_permission(inode, mode | MAY_ACCESS);
+		/* SuS v2 requires we report a read only fs too */
+		if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
+			goto out_path_release;
 		/*
-		 * MAY_EXEC on regular files is denied if the fs is mounted
-		 * with the "noexec" flag.
+		 * This is a rare case where using __mnt_is_readonly()
+		 * is OK without a mnt_want/drop_write() pair.  Since
+		 * no actual write to the fs is performed here, we do
+		 * not need to telegraph to that to anyone.
+		 *
+		 * By doing this, we accept that this access is
+		 * inherently racy and know that the fs may change
+		 * state before we even see this result.
 		 */
-		res = -EACCES;
-		if (path.mnt->mnt_flags & MNT_NOEXEC)
-			goto out_path_release;
-	}
-
-	res = inode_permission(inode, mode | MAY_ACCESS);
-	/* SuS v2 requires we report a read only fs too */
-	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
-		goto out_path_release;
-	/*
-	 * This is a rare case where using __mnt_is_readonly()
-	 * is OK without a mnt_want/drop_write() pair.  Since
-	 * no actual write to the fs is performed here, we do
-	 * not need to telegraph to that to anyone.
-	 *
-	 * By doing this, we accept that this access is
-	 * inherently racy and know that the fs may change
-	 * state before we even see this result.
-	 */
-	if (__mnt_is_readonly(path.mnt))
-		res = -EROFS;
+		if (__mnt_is_readonly(path.mnt))
+			res = -EROFS;
 
 out_path_release:
-	path_put(&path);
-out:
+		path_put(&path);
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(res, try++));
 	revert_creds(old_cred);
 	put_cred(override_cred);
 	return res;
-- 
1.7.11.4

