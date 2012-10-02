Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab2JBAT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:19:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59227 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2JBASG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:18:06 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 42/49] vfs: allow setxattr to retry once on ESTALE errors
Date: Mon,  1 Oct 2012 20:16:51 -0400
Message-Id: <1349137018-21948-43-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xattr.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 588455b..ba286ba 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -364,16 +364,21 @@ SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 {
 	struct path path;
 	int error;
+	unsigned int try = 0;
+	unsigned int lookup_flags = LOOKUP_FOLLOW;
 
-	error = user_path(pathname, &path);
-	if (error)
-		return error;
-	error = mnt_want_write(path.mnt);
-	if (!error) {
-		error = setxattr(path.dentry, name, value, size, flags);
-		mnt_drop_write(path.mnt);
-	}
-	path_put(&path);
+	do {
+		error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+		if (error)
+			break;
+		error = mnt_want_write(path.mnt);
+		if (!error) {
+			error = setxattr(path.dentry, name, value, size, flags);
+			mnt_drop_write(path.mnt);
+		}
+		path_put(&path);
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

