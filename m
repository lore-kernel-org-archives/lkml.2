Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2LOLB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 06:01:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52518 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2LOLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 06:01:57 -0500
Message-ID: <50CC570B.1000101@gmail.com>
Date: Sat, 15 Dec 2012 11:55:07 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/21] hfsplus: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hfsplus/inode.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2172aa5..799b336 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -28,6 +28,16 @@ static int hfsplus_writepage(struct page *page, struct writeback_control *wbc)
 	return block_write_full_page(page, hfsplus_get_block, wbc);
 }
 
+static void hfsplus_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		hfsplus_file_truncate(inode);
+	}
+}
+
 static int hfsplus_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -38,11 +48,8 @@ static int hfsplus_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				hfsplus_get_block,
 				&HFSPLUS_I(mapping->host)->phys_size);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		hfsplus_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -116,6 +123,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
@@ -131,7 +139,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 		loff_t end = offset + iov_length(iov, nr_segs);
 
 		if (end > isize)
-			vmtruncate(inode, isize);
+			hfsplus_write_failed(mapping, end);
 	}
 
 	return ret;
@@ -300,10 +308,8 @@ static int hfsplus_setattr(struct dentry *dentry, struct iattr *attr)
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
-
-		error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
+		truncate_setsize(inode, attr->ia_size);
+		hfsplus_file_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -358,7 +364,6 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
-	.truncate	= hfsplus_file_truncate,
 	.setattr	= hfsplus_setattr,
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
-- 
1.7.3.4
