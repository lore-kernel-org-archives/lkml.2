Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab2IGOWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:22:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38547 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760746Ab2IGOTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:19:01 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v6 16/20] vfs: make chroot retry once on ESTALE error
Date: Fri,  7 Sep 2012 10:18:23 -0400
Message-Id: <1347027507-20956-17-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
References: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 81ba325..a015cb8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -437,27 +437,32 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
 	int error;
+	int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	unsigned int try = 0;
 
-	error = user_path_dir(filename, &path);
-	if (error)
-		goto out;
+	do {
+		error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+		if (error)
+			break;
 
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
-	if (error)
-		goto dput_and_out;
+		error = inode_permission(path.dentry->d_inode,
+					 MAY_EXEC | MAY_CHDIR);
+		if (error)
+			goto dput_and_out;
 
-	error = -EPERM;
-	if (!capable(CAP_SYS_CHROOT))
-		goto dput_and_out;
-	error = security_path_chroot(&path);
-	if (error)
-		goto dput_and_out;
+		error = -EPERM;
+		if (!capable(CAP_SYS_CHROOT))
+			goto dput_and_out;
+		error = security_path_chroot(&path);
+		if (error)
+			goto dput_and_out;
 
-	set_fs_root(current->fs, &path);
-	error = 0;
+		set_fs_root(current->fs, &path);
+		error = 0;
 dput_and_out:
-	path_put(&path);
-out:
+		path_put(&path);
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

