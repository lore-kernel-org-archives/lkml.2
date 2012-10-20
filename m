Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2JTMY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:24:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34187 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2JTMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:24:56 -0400
Message-ID: <5082968A.9020602@gmail.com>
Date: Sat, 20 Oct 2012 14:18:18 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Bob Copeland <me@bobcopeland.com>, linux-karma-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/21] omfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/omfs/file.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 77e3cb2..e0d9b3e 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -306,6 +306,16 @@ omfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	return mpage_writepages(mapping, wbc, omfs_get_block);
 }
 
+static void omfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		omfs_truncate(inode);
+	}
+}
+
 static int omfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -314,11 +324,8 @@ static int omfs_write_begin(struct file *file, struct address_space *mapping,
 
 	ret = block_write_begin(mapping, pos, len, flags, pagep,
 				omfs_get_block);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		omfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -350,9 +357,11 @@ static int omfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+		truncate_setsize(inode, attr->ia_size);
+		omfs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -362,7 +371,6 @@ static int omfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 const struct inode_operations omfs_file_inops = {
 	.setattr = omfs_setattr,
-	.truncate = omfs_truncate
 };
 
 const struct address_space_operations omfs_aops = {
-- 
1.7.3.4
