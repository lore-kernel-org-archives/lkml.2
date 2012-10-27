Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2J0Me0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:34:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35968 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2J0MeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:34:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 16/32] vfs: make chroot retry once on ESTALE error
Date: Sat, 27 Oct 2012 08:33:23 -0400
Message-Id: <1351341219-17837-17-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5c2a973..a1331f1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -434,27 +434,32 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
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
1.7.11.7

