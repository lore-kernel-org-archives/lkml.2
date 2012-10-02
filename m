Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab2JBAZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:25:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43943 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2JBARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:36 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 22/49] vfs: make fstatat retry on ESTALE errors from getattr call
Date: Mon,  1 Oct 2012 20:16:31 -0400
Message-Id: <1349137018-21948-23-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/stat.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 4078022..7f1602a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -74,7 +74,8 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 {
 	struct path path;
 	int error = -EINVAL;
-	int lookup_flags = 0;
+	unsigned int try = 0;
+	unsigned int lookup_flags = 0;
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
 		      AT_EMPTY_PATH)) != 0)
@@ -85,12 +86,15 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
 
-	error = user_path_at(dfd, filename, lookup_flags, &path);
-	if (error)
-		goto out;
+	do {
+		error = user_path_at(dfd, filename, lookup_flags, &path);
+		if (error)
+			break;
 
-	error = vfs_getattr(path.mnt, path.dentry, stat);
-	path_put(&path);
+		error = vfs_getattr(path.mnt, path.dentry, stat);
+		path_put(&path);
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 out:
 	return error;
 }
-- 
1.7.11.4

