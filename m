Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab2IGOS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:18:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62753 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581Ab2IGOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:18:40 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v6 03/20] vfs: fix readlinkat to retry on ESTALE
Date: Fri,  7 Sep 2012 10:18:10 -0400
Message-Id: <1347027507-20956-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
References: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/stat.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index d90258d..9719df1 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -300,14 +300,21 @@ SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
 	struct path path;
 	int error;
 	int empty = 0;
+	unsigned int try = 0;
+	unsigned int lookup_flags = LOOKUP_EMPTY;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
-	error = user_path_at_empty(dfd, pathname, LOOKUP_EMPTY, &path, &empty);
-	if (!error) {
-		struct inode *inode = path.dentry->d_inode;
+	do {
+		struct inode *inode;
+
+		error = user_path_at_empty(dfd, pathname, lookup_flags,
+					   &path, &empty);
+		if (error)
+			break;
 
+		inode = path.dentry->d_inode;
 		error = empty ? -ENOENT : -EINVAL;
 		if (inode->i_op->readlink) {
 			error = security_inode_readlink(path.dentry);
@@ -318,7 +325,8 @@ SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
 			}
 		}
 		path_put(&path);
-	}
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

