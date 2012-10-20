Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2JTM0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:26:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65247 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2JTM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:26:42 -0400
Message-ID: <508296F5.30204@gmail.com>
Date: Sat, 20 Oct 2012 14:20:05 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/21] affs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
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
