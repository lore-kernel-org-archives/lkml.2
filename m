Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2JBATF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:19:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62758 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2JBASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:18:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 47/49] vfs: make llistxattr retry once on ESTALE error
Date: Mon,  1 Oct 2012 20:16:56 -0400
Message-Id: <1349137018-21948-48-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xattr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 6be45cd..db6c528 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -590,12 +590,17 @@ SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
 {
 	struct path path;
 	ssize_t error;
+	unsigned int try = 0;
+	unsigned int lookup_flags = 0;
 
-	error = user_lpath(pathname, &path);
-	if (error)
-		return error;
-	error = listxattr(path.dentry, list, size);
-	path_put(&path);
+	do {
+		error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+		if (error)
+			break;
+		error = listxattr(path.dentry, list, size);
+		path_put(&path);
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

