Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2JTM1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:27:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41104 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab2JTM1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:27:47 -0400
Message-ID: <50829736.9060402@gmail.com>
Date: Sat, 20 Oct 2012 14:21:10 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 10/21] hfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hfs/inode.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 0b35903..d47f116 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -35,6 +35,16 @@ static int hfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page, hfs_get_block);
 }
 
+static void hfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		hfs_file_truncate(inode);
+	}
+}
+
 static int hfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -45,11 +55,8 @@ static int hfs_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				hfs_get_block,
 				&HFS_I(mapping->host)->phys_size);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		hfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -120,6 +127,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
@@ -135,7 +143,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 		loff_t end = offset + iov_length(iov, nr_segs);
 
 		if (end > isize)
-			vmtruncate(inode, isize);
+			hfs_write_failed(mapping, end);
 	}
 
 	return ret;
@@ -617,9 +625,12 @@ int hfs_inode_setattr(struct dentry *dentry, struct iattr * attr)
 	    attr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		hfs_file_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -668,7 +679,6 @@ static const struct file_operations hfs_file_operations = {
 
 static const struct inode_operations hfs_file_inode_operations = {
 	.lookup		= hfs_file_lookup,
-	.truncate	= hfs_file_truncate,
 	.setattr	= hfs_inode_setattr,
 	.setxattr	= hfs_setxattr,
 	.getxattr	= hfs_getxattr,
-- 
1.7.3.4
