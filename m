Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0EQFfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:35:31 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59711 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0EQFeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:34:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 5/9] vfs: Support null pathname in readlink
Date: Mon, 17 May 2010 11:03:48 +0530
Message-Id: <1274074432-29695-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

This enables to use readlink to get the link target name
from a file descriptor point to the link. This can be used
with open_by_handle syscall that returns a file descriptor for a link.
We can then use this file descriptor to get the target name.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/stat.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index c4ecd52..49b95a7 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -284,26 +284,40 @@ SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
 SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
 		char __user *, buf, int, bufsiz)
 {
-	struct path path;
-	int error;
+	int error = 0;
+	struct path path, *pp;
+	struct file *file = NULL;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
-	error = user_path_at(dfd, pathname, 0, &path);
+	if (pathname == NULL && dfd != AT_FDCWD) {
+		file = fget(dfd);
+
+		if (file)
+			pp = &file->f_path;
+		else
+			error = -EBADF;
+	} else {
+		error = user_path_at(dfd, pathname, 0, &path);
+		pp = &path;
+	}
 	if (!error) {
-		struct inode *inode = path.dentry->d_inode;
+		struct inode *inode = pp->dentry->d_inode;
 
 		error = -EINVAL;
 		if (inode->i_op->readlink) {
-			error = security_inode_readlink(path.dentry);
+			error = security_inode_readlink(pp->dentry);
 			if (!error) {
-				touch_atime(path.mnt, path.dentry);
-				error = inode->i_op->readlink(path.dentry,
+				touch_atime(pp->mnt, pp->dentry);
+				error = inode->i_op->readlink(pp->dentry,
 							      buf, bufsiz);
 			}
 		}
-		path_put(&path);
+		if (file)
+			fput(file);
+		else
+			path_put(&path);
 	}
 	return error;
 }
-- 
1.7.1.78.g212f0

