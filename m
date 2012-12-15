Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2LOKwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:52:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53642 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab2LOKws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:52:48 -0500
Message-ID: <50CC54E6.9000601@gmail.com>
Date: Sat, 15 Dec 2012 11:45:58 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/21] sysv: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/sysv/file.c  |    5 +++--
 fs/sysv/itree.c |   17 ++++++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/sysv/file.c b/fs/sysv/file.c
index 0a65939..9d4dc68 100644
--- a/fs/sysv/file.c
+++ b/fs/sysv/file.c
@@ -41,9 +41,11 @@ static int sysv_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+		truncate_setsize(inode, attr->ia_size);
+		sysv_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -52,7 +54,6 @@ static int sysv_setattr(struct dentry *dentry, struct iattr *attr)
 }
 
 const struct inode_operations sysv_file_inode_operations = {
-	.truncate	= sysv_truncate,
 	.setattr	= sysv_setattr,
 	.getattr	= sysv_getattr,
 };
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 90b54b4..c1a591a 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -464,6 +464,16 @@ int sysv_prepare_chunk(struct page *page, loff_t pos, unsigned len)
 	return __block_write_begin(page, pos, len, get_block);
 }
 
+static void sysv_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		sysv_truncate(inode);
+	}
+}
+
 static int sysv_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -471,11 +481,8 @@ static int sysv_write_begin(struct file *file, struct address_space *mapping,
 	int ret;
 
 	ret = block_write_begin(mapping, pos, len, flags, pagep, get_block);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		sysv_write_failed(mapping, pos + len);
 
 	return ret;
 }
-- 
1.7.3.4
