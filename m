Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab2JTMbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:31:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46677 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab2JTMbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:31:43 -0400
Message-ID: <50829822.2050805@gmail.com>
Date: Sat, 20 Oct 2012 14:25:06 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
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

Signed-off-by: Marco <marco.stornelli@gmail.com>
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
