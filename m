Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2LEQlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:41:08 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:19820 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LEQlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:41:06 -0500
Subject: [PATCH] fuse: Trust kernel i_size only - v2
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Wed, 05 Dec 2012 20:39:42 +0400
Message-ID: <20121205163857.19499.14256.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170731.3196.47157.stgit@maximpc.sw.ru>
References: <20121116170731.3196.47157.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make fuse think that when writeback is on the inode's i_size is always
up-to-date and not update it with the value received from the userspace.
This is done because the page cache code may update i_size without letting
the FS know.

This assumption implies fixing the previously introduced short-read helper --
when a short read occurs the 'hole' is filled with zeroes.

fuse_file_fallocate() is also fixed because now we should keep i_size up to
date, so it must be updated if FUSE_FALLOCATE request succeeded.

Changed in v2:
 - improved comment in fuse_short_read()
 - fixed fuse_file_fallocate() for KEEP_SIZE mode

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c   |    9 ++++++---
 fs/fuse/file.c  |   43 +++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/inode.c |    6 ++++--
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 324bc08..3e7250e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -827,7 +827,7 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 	stat->mtime.tv_nsec = attr->mtimensec;
 	stat->ctime.tv_sec = attr->ctime;
 	stat->ctime.tv_nsec = attr->ctimensec;
-	stat->size = attr->size;
+	stat->size = i_size_read(inode);
 	stat->blocks = attr->blocks;
 
 	if (attr->blksize != 0)
@@ -1388,6 +1388,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
 	bool is_truncate = false;
+	bool is_wb = fc->writeback_cache;
 	loff_t oldsize;
 	int err;
 
@@ -1460,7 +1461,8 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	fuse_change_attributes_common(inode, &outarg.attr,
 				      attr_timeout(&outarg));
 	oldsize = inode->i_size;
-	i_size_write(inode, outarg.attr.size);
+	if (!is_wb || is_truncate || !S_ISREG(inode->i_mode))
+		i_size_write(inode, outarg.attr.size);
 
 	if (is_truncate) {
 		/* NOTE: this may release/reacquire fc->lock */
@@ -1472,7 +1474,8 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	 * Only call invalidate_inode_pages2() after removing
 	 * FUSE_NOWRITE, otherwise fuse_launder_page() would deadlock.
 	 */
-	if (S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
+	if ((is_truncate || !is_wb) &&
+			S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
 		truncate_pagecache(inode, oldsize, outarg.attr.size);
 		invalidate_inode_pages2(inode->i_mapping);
 	}
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 0cc62f59..7db1736 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/compat.h>
 #include <linux/swap.h>
+#include <linux/falloc.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -543,9 +544,31 @@ static void fuse_short_read(struct fuse_req *req, struct inode *inode,
 			    u64 attr_ver)
 {
 	size_t num_read = req->out.args[0].size;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (fc->writeback_cache) {
+		/*
+		 * A hole in a file. Some data after the hole are in page cache,
+		 * but have not reached the client fs yet. So, the hole is not
+		 * present there.
+		 */
+		int i;
+		int start_idx = num_read >> PAGE_CACHE_SHIFT;
+		size_t off = num_read & (PAGE_CACHE_SIZE - 1);
 
-	loff_t pos = page_offset(req->pages[0]) + num_read;
-	fuse_read_update_size(inode, pos, attr_ver);
+		for (i = start_idx; i < req->num_pages; i++) {
+			struct page *page = req->pages[i];
+			void *mapaddr = kmap_atomic(page);
+
+			memset(mapaddr + off, 0, PAGE_CACHE_SIZE - off);
+
+			kunmap_atomic(mapaddr);
+			off = 0;
+		}
+	} else {
+		loff_t pos = page_offset(req->pages[0]) + num_read;
+		fuse_read_update_size(inode, pos, attr_ver);
+	}
 }
 
 static int fuse_readpage(struct file *file, struct page *page)
@@ -2216,6 +2239,8 @@ long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
+	bool change_i_size = fc->writeback_cache &&
+		!(mode & FALLOC_FL_KEEP_SIZE);
 
 	if (fc->no_fallocate)
 		return -EOPNOTSUPP;
@@ -2224,6 +2249,11 @@ long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	if (change_i_size) {
+		struct inode *inode = file->f_mapping->host;
+		mutex_lock(&inode->i_mutex);
+	}
+
 	req->in.h.opcode = FUSE_FALLOCATE;
 	req->in.h.nodeid = ff->nodeid;
 	req->in.numargs = 1;
@@ -2237,6 +2267,15 @@ long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	}
 	fuse_put_request(fc, req);
 
+	if (change_i_size) {
+		struct inode *inode = file->f_mapping->host;
+
+		if (!err)
+			fuse_write_update_size(inode, offset + length);
+
+		mutex_unlock(&inode->i_mutex);
+	}
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(fuse_file_fallocate);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f0eda12..b2d1a27 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -196,6 +196,7 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	bool is_wb = fc->writeback_cache;
 	loff_t oldsize;
 	struct timespec old_mtime;
 
@@ -209,10 +210,11 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 	fuse_change_attributes_common(inode, attr, attr_valid);
 
 	oldsize = inode->i_size;
-	i_size_write(inode, attr->size);
+	if (!is_wb || !S_ISREG(inode->i_mode))
+		i_size_write(inode, attr->size);
 	spin_unlock(&fc->lock);
 
-	if (S_ISREG(inode->i_mode)) {
+	if (!is_wb && S_ISREG(inode->i_mode)) {
 		bool inval = false;
 
 		if (oldsize != attr->size) {

