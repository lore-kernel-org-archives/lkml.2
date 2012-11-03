Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2KCJgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:36:40 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52530 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2KCJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:36:38 -0400
Message-ID: <5094E41A.6010003@gmail.com>
Date: Sat, 03 Nov 2012 10:30:02 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 15/21] minix: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/minix/file.c  |    6 ++++--
 fs/minix/inode.c |   17 ++++++++++++-----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/minix/file.c b/fs/minix/file.c
index 4493ce6..adc6f54 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -34,9 +34,12 @@ static int minix_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		minix_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -45,7 +48,6 @@ static int minix_setattr(struct dentry *dentry, struct iattr *attr)
 }
 
 const struct inode_operations minix_file_inode_operations = {
-	.truncate	= minix_truncate,
 	.setattr	= minix_setattr,
 	.getattr	= minix_getattr,
 };
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 4fc5f8a..99541cc 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -395,6 +395,16 @@ int minix_prepare_chunk(struct page *page, loff_t pos, unsigned len)
 	return __block_write_begin(page, pos, len, minix_get_block);
 }
 
+static void minix_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		minix_truncate(inode);
+	}
+}
+
 static int minix_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -403,11 +413,8 @@ static int minix_write_begin(struct file *file, struct address_space *mapping,
 
 	ret = block_write_begin(mapping, pos, len, flags, pagep,
 				minix_get_block);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		minix_write_failed(mapping, pos + len);
 
 	return ret;
 }
-- 
1.7.3.4
