Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab2J0Mmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:42:36 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54525 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2J0MeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:34:00 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 06/32] vfs: fix mkdir to retry on ESTALE errors
Date: Sat, 27 Oct 2012 08:33:13 -0400
Message-Id: <1351341219-17837-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7b0ca39..6e8db3d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3250,17 +3250,20 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
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
1.7.11.7

