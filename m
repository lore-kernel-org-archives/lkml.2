Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab2JTM3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:29:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59623 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2JTM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:29:37 -0400
Message-ID: <508297A3.9090601@gmail.com>
Date: Sat, 20 Oct 2012 14:22:59 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/21] jfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/jfs/file.c  |    6 ++++--
 fs/jfs/inode.c |   20 ++++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 9d3afd1..dd7442c 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -119,9 +119,12 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	    iattr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 
-		rc = vmtruncate(inode, iattr->ia_size);
+		rc = inode_newsize_ok(inode, iattr->ia_size);
 		if (rc)
 			return rc;
+
+		truncate_setsize(inode, iattr->ia_size);
+		jfs_truncate(inode);
 	}
 
 	setattr_copy(inode, iattr);
@@ -133,7 +136,6 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 }
 
 const struct inode_operations jfs_file_inode_operations = {
-	.truncate	= jfs_truncate,
 	.setxattr	= jfs_setxattr,
 	.getxattr	= jfs_getxattr,
 	.listxattr	= jfs_listxattr,
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4692bf3..b7dc47b 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -300,6 +300,16 @@ static int jfs_readpages(struct file *file, struct address_space *mapping,
 	return mpage_readpages(mapping, pages, nr_pages, jfs_get_block);
 }
 
+static void jfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		jfs_truncate(inode);
+	}
+}
+
 static int jfs_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -308,11 +318,8 @@ static int jfs_write_begin(struct file *file, struct address_space *mapping,
 
 	ret = nobh_write_begin(mapping, pos, len, flags, pagep, fsdata,
 				jfs_get_block);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		jfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -326,6 +333,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
@@ -341,7 +349,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 		loff_t end = offset + iov_length(iov, nr_segs);
 
 		if (end > isize)
-			vmtruncate(inode, isize);
+			jfs_write_failed(mapping, end);
 	}
 
 	return ret;
-- 
1.7.3.4
