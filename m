Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795Ab2IGOTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:19:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38547 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678Ab2IGOSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:18:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v6 06/20] vfs: fix mkdir to retry on ESTALE errors
Date: Fri,  7 Sep 2012 10:18:13 -0400
Message-Id: <1347027507-20956-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
References: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 11fc388..9068375 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3249,17 +3249,20 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 	struct dentry *dentry;
 	struct path path;
 	int error;
+	unsigned int try = 0;
 
-	dentry = user_path_create(dfd, pathname, &path, true, false);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+	do {
+		dentry = user_path_create(dfd, pathname, &path, true, false);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mkdir(&path, dentry, mode);
-	if (!error)
-		error = vfs_mkdir(path.dentry->d_inode, dentry, mode);
-	done_path_create(&path, dentry);
+		if (!IS_POSIXACL(path.dentry->d_inode))
+			mode &= ~current_umask();
+		error = security_path_mkdir(&path, dentry, mode);
+		if (!error)
+			error = vfs_mkdir(path.dentry->d_inode, dentry, mode);
+		done_path_create(&path, dentry);
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

