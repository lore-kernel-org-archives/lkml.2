Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0HZSf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:35:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58033 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0HZSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:35:25 -0400
Message-Id: <20100826183459.657502358@szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 20:33:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
Subject: [PATCH 1/5] vfs: implement open "forwarding"
Content-Disposition: inline; filename=vfs-open-redirect.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new file operation f_op->open_other().  This acts just like
f_op->open() except the return value can be another open struct file
pointer.  In that case the original file is discarded and the
replacement file is used instead.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c          |   23 +++++++++++++++++------
 include/linux/fs.h |    1 +
 2 files changed, 18 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2010-08-19 09:45:50.000000000 +0200
+++ linux-2.6/fs/open.c	2010-08-19 09:46:27.000000000 +0200
@@ -657,6 +657,7 @@ static struct file *__dentry_open(struct
 					const struct cred *cred)
 {
 	struct inode *inode;
+	struct file *ret;
 	int error;
 
 	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
@@ -664,6 +665,7 @@ static struct file *__dentry_open(struct
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
 		error = __get_file_write_access(inode, mnt);
+		ret = ERR_PTR(error);
 		if (error)
 			goto cleanup_file;
 		if (!special_file(inode->i_mode))
@@ -678,15 +680,24 @@ static struct file *__dentry_open(struct
 	file_sb_list_add(f, inode->i_sb);
 
 	error = security_dentry_open(f, cred);
+	ret = ERR_PTR(error);
 	if (error)
 		goto cleanup_all;
 
-	if (!open && f->f_op)
-		open = f->f_op->open;
-	if (open) {
-		error = open(inode, f);
-		if (error)
+	if (!open && f->f_op && f->f_op->open_other) {
+		/* NULL means keep f, non-error non-null means replace */
+		ret = f->f_op->open_other(f);
+		if (IS_ERR(ret) || ret != NULL)
 			goto cleanup_all;
+	} else {
+		if (!open && f->f_op)
+			open = f->f_op->open;
+		if (open) {
+			error = open(inode, f);
+			ret = ERR_PTR(error);
+			if (error)
+				goto cleanup_all;
+		}
 	}
 	ima_counts_get(f);
 
@@ -728,7 +739,7 @@ cleanup_file:
 	put_filp(f);
 	dput(dentry);
 	mntput(mnt);
-	return ERR_PTR(error);
+	return ret;
 }
 
 /**
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-08-19 09:46:15.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-08-19 09:46:27.000000000 +0200
@@ -1494,6 +1494,7 @@ struct file_operations {
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
+	struct file *(*open_other) (struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
 	int (*fsync) (struct file *, int datasync);

-- 
