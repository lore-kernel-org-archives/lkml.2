Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2JBAWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:22:17 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40563 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2JBAR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 35/49] vfs: have chdir retry lookup and call once on ESTALE error
Date: Mon,  1 Oct 2012 20:16:44 -0400
Message-Id: <1349137018-21948-36-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index a5a5c9a..81ba325 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -389,20 +389,21 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 {
 	struct path path;
 	int error;
+	int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	unsigned int try = 0;
 
-	error = user_path_dir(filename, &path);
-	if (error)
-		goto out;
-
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_pwd(current->fs, &path);
+	do {
+		error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+		if (error)
+			break;
 
-dput_and_out:
-	path_put(&path);
-out:
+		error = inode_permission(path.dentry->d_inode,
+					 MAY_EXEC | MAY_CHDIR);
+		if (!error)
+			set_fs_pwd(current->fs, &path);
+		path_put(&path);
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

