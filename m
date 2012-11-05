Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab2KEPYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:24:15 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:61085 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab2KEPXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:23:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 32/34] vfs: ensure that forward progress is being made on pathwalks
Date: Mon,  5 Nov 2012 10:22:11 -0500
Message-Id: <1352128933-28526-33-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In operations that involve pathwalks (lookups and atomic opens), ensure
that the operations are making forward progress. Save a copy of the
current nd.path.dentry when retrying on an estale and ensure that it's
changing on each pass through the loop. If it isn't, then we're stuck.
Just return -ENOENT in that case.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c3582d4..f0916e6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2021,12 +2021,21 @@ static int filename_lookup(int dfd, struct filename *name,
 				unsigned int flags, struct nameidata *nd)
 {
 	unsigned int try = 0;
+	struct dentry *save = NULL;
 	int retval = path_lookupat(dfd, name->name, flags | LOOKUP_RCU, nd);
+
 	if (unlikely(retval == -ECHILD))
 		retval = path_lookupat(dfd, name->name, flags, nd);
-	while (retry_estale(retval, try++))
+
+	while (retry_estale(retval, try++)) {
+		if (nd->path.dentry == save) {
+			retval = -ENOENT;
+			break;
+		}
+		save = nd->path.dentry;
 		retval = path_lookupat(dfd, name->name,
 						flags | LOOKUP_REVAL, nd);
+	}
 
 	if (likely(!retval))
 		audit_inode(name, nd->path.dentry, flags & LOOKUP_PARENT);
@@ -3014,12 +3023,20 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 	struct nameidata nd;
 	struct file *filp;
 	unsigned int try = 0;
+	struct dentry *save = NULL;
 
 	filp = path_openat(dfd, pathname, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
 		filp = path_openat(dfd, pathname, &nd, op, flags);
-	while (retry_estale(PTR_ERR(filp), try++))
+
+	while (retry_estale(PTR_ERR(filp), try++)) {
+		if (nd.path.dentry == save) {
+			filp = ERR_PTR(-ENOENT);
+			break;
+		}
+		save = nd.path.dentry;
 		filp = path_openat(dfd, pathname, &nd, op, flags | LOOKUP_REVAL);
+	}
 	return filp;
 }
 
@@ -3030,6 +3047,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	struct file *file;
 	struct filename filename = { .name = name };
 	unsigned int try = 0;
+	struct dentry *save = NULL;
 
 	nd.root.mnt = mnt;
 	nd.root.dentry = dentry;
@@ -3042,8 +3060,15 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	file = path_openat(-1, &filename, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(file == ERR_PTR(-ECHILD)))
 		file = path_openat(-1, &filename, &nd, op, flags);
-	while (retry_estale(PTR_ERR(file), try++))
+
+	while (retry_estale(PTR_ERR(file), try++)) {
+		if (nd.path.dentry == save) {
+			file = ERR_PTR(-ENOENT);
+			break;
+		}
+		save = nd.path.dentry;
 		file = path_openat(-1, &filename, &nd, op, flags | LOOKUP_REVAL);
+	}
 	return file;
 }
 
-- 
1.7.11.7

