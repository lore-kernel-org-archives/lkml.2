Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab2FENL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:11:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104Ab2FENLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:11:22 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 19/21] vfs: do_last(): clean up bool
Date: Tue,  5 Jun 2012 15:10:30 +0200
Message-Id: <1338901832-14049-20-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Consistently use bool for boolean values in do_last().

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e57cec2..7d87c63 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2187,7 +2187,7 @@ static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
 static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 				struct path *path, struct opendata *od,
 				const struct open_flags *op,
-				int *want_write, bool need_lookup,
+				bool *want_write, bool need_lookup,
 				bool *created)
 {
 	struct inode *dir =  nd->path.dentry->d_inode;
@@ -2229,7 +2229,7 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	    (open_flag & O_ACCMODE) != O_RDONLY) {
 		error = mnt_want_write(nd->path.mnt);
 		if (!error) {
-			*want_write = 1;
+			*want_write = true;
 		} else if (!(open_flag & O_CREAT)) {
 			/*
 			 * No O_CREATE -> atomicity not a requirement -> fall
@@ -2351,7 +2351,7 @@ looked_up:
 static struct file *lookup_open(struct nameidata *nd, struct path *path,
 				struct opendata *od,
 				const struct open_flags *op,
-				int *want_write, bool *created)
+				bool *want_write, bool *created)
 {
 	struct dentry *dir = nd->path.dentry;
 	struct inode *dir_inode = dir->d_inode;
@@ -2396,7 +2396,7 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 		error = mnt_want_write(nd->path.mnt);
 		if (error)
 			goto out_dput;
-		*want_write = 1;
+		*want_write = true;
 		*created = true;
 		error = security_path_mknod(&nd->path, dentry, mode, 0);
 		if (error)
@@ -2424,13 +2424,13 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 {
 	struct dentry *dir = nd->path.dentry;
 	int open_flag = op->open_flag;
-	int will_truncate = open_flag & O_TRUNC;
-	int want_write = 0;
+	bool will_truncate = (open_flag & O_TRUNC) != 0;
+	bool want_write = false;
 	int acc_mode = op->acc_mode;
 	struct file *filp;
 	struct inode *inode;
 	bool created;
-	int symlink_ok = 0;
+	bool symlink_ok = false;
 	struct path save_parent = { .dentry = NULL, .mnt = NULL };
 	bool retried = false;
 	int error;
@@ -2467,7 +2467,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		if (nd->last.name[nd->last.len])
 			nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 		if (open_flag & O_PATH && !(nd->flags & LOOKUP_FOLLOW))
-			symlink_ok = 1;
+			symlink_ok = true;
 		/* we _can_ be in RCU mode here */
 		error = lookup_fast(nd, &nd->last, path, &inode);
 		if (likely(!error))
@@ -2505,7 +2505,7 @@ retry_lookup:
 			goto out;
 
 		if (created || !S_ISREG(filp->f_path.dentry->d_inode->i_mode))
-			will_truncate = 0;
+			will_truncate = false;
 
 		audit_inode(pathname, filp->f_path.dentry);
 		goto opened;
@@ -2514,7 +2514,7 @@ retry_lookup:
 	if (created) {
 		/* Don't check for write permission, don't truncate */
 		open_flag &= ~O_TRUNC;
-		will_truncate = 0;
+		will_truncate = false;
 		acc_mode = MAY_OPEN;
 		path_to_nameidata(path, nd);
 		goto finish_open_created;
@@ -2532,7 +2532,7 @@ retry_lookup:
 	 */
 	if (want_write) {
 		mnt_drop_write(nd->path.mnt);
-		want_write = 0;
+		want_write = false;
 	}
 
 	error = -EEXIST;
@@ -2591,13 +2591,13 @@ finish_lookup:
 	audit_inode(pathname, nd->path.dentry);
 finish_open:
 	if (!S_ISREG(nd->inode->i_mode))
-		will_truncate = 0;
+		will_truncate = false;
 
 	if (will_truncate) {
 		error = mnt_want_write(nd->path.mnt);
 		if (error)
 			goto exit;
-		want_write = 1;
+		want_write = true;
 	}
 finish_open_created:
 	error = may_open(&nd->path, acc_mode, open_flag);
@@ -2614,7 +2614,7 @@ finish_open_created:
 		save_parent.dentry = NULL;
 		if (want_write) {
 			mnt_drop_write(nd->path.mnt);
-			want_write = 0;
+			want_write = false;
 		}
 		retried = true;
 		goto retry_lookup;
-- 
1.7.7

