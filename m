Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2KCJdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:33:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56923 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2KCJdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:33:22 -0400
Message-ID: <5094E356.4030305@gmail.com>
Date: Sat, 03 Nov 2012 10:26:46 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 08/21] affs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/affs/file.c  |   18 ++++++++++++------
 fs/affs/inode.c |    5 ++++-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 2f4c935..af3261b 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -39,7 +39,6 @@ const struct file_operations affs_file_operations = {
 };
 
 const struct inode_operations affs_file_inode_operations = {
-	.truncate	= affs_truncate,
 	.setattr	= affs_notify_change,
 };
 
@@ -402,6 +401,16 @@ static int affs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page, affs_get_block);
 }
 
+static void affs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		affs_truncate(inode);
+	}
+}
+
 static int affs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -412,11 +421,8 @@ static int affs_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				affs_get_block,
 				&AFFS_I(mapping->host)->mmu_private);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		affs_write_failed(mapping, pos + len);
 
 	return ret;
 }
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 15c4842..0e092d0 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -237,9 +237,12 @@ affs_notify_change(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		affs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
