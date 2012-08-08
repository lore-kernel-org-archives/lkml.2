Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab2HHNWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:22:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63544 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab2HHNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:22:12 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v5 18/19] vfs: have chdir retry lookup and call once on ESTALE error
Date: Wed,  8 Aug 2012 09:21:41 -0400
Message-Id: <1344432102-22312-19-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344432102-22312-1-git-send-email-jlayton@redhat.com>
References: <1344432102-22312-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 147b232..59a7e9d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -401,20 +401,27 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 {
 	struct path path;
 	int error;
+	int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	unsigned int try = 0;
+	char *name;
 
-	error = user_path_dir(filename, &path);
-	if (error)
-		goto out;
-
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
-	if (error)
-		goto dput_and_out;
+	name = getname_flags(filename, lookup_flags, NULL);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
 
-	set_fs_pwd(current->fs, &path);
+	do {
+		error = kern_path_at(AT_FDCWD, name, lookup_flags, &path);
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
+	putname(name);
 	return error;
 }
 
-- 
1.7.11.2

