Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2JBAXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:23:51 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61020 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2JBARo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:44 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 27/49] vfs: fix symlinkat to retry on ESTALE errors
Date: Mon,  1 Oct 2012 20:16:36 -0400
Message-Id: <1349137018-21948-28-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dd1d519..fb9d36f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3528,21 +3528,25 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	struct getname_info *from;
 	struct dentry *dentry;
 	struct path path;
+	unsigned int try = 0;
 
 	from = getname(oldname);
 	if (IS_ERR(from))
 		return PTR_ERR(from);
 
-	dentry = user_path_create(newdfd, newname, &path, false, false);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
-		goto out_putname;
+	do {
+		dentry = user_path_create(newdfd, newname, &path, false, false);
+		if (IS_ERR(dentry)) {
+			error = PTR_ERR(dentry);
+			break;
+		}
 
-	error = security_path_symlink(&path, dentry, from->name);
-	if (!error)
-		error = vfs_symlink(path.dentry->d_inode, dentry, from->name);
-	done_path_create(&path, dentry);
-out_putname:
+		error = security_path_symlink(&path, dentry, from->name);
+		if (!error)
+			error = vfs_symlink(path.dentry->d_inode, dentry,
+						from->name);
+		done_path_create(&path, dentry);
+	} while (retry_estale(error, try++));
 	putname(from);
 	return error;
 }
-- 
1.7.11.4

