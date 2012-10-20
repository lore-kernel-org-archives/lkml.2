Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab2JTM2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:28:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50097 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab2JTM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:28:46 -0400
Message-ID: <50829770.5010507@gmail.com>
Date: Sat, 20 Oct 2012 14:22:08 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/21] hpfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hpfs/file.c  |   18 ++++++++++++------
 fs/hpfs/inode.c |    5 ++++-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 89d2a58..8b8b20d 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -105,6 +105,16 @@ static int hpfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page,hpfs_get_block);
 }
 
+static void hpfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		hpfs_truncate(inode);
+	}
+}
+
 static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -115,11 +125,8 @@ static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				hpfs_get_block,
 				&hpfs_i(mapping->host)->mmu_private);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		hpfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -166,6 +173,5 @@ const struct file_operations hpfs_file_ops =
 
 const struct inode_operations hpfs_file_iops =
 {
-	.truncate	= hpfs_truncate,
 	.setattr	= hpfs_setattr,
 };
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 804a9a8..5dc06c8 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -277,9 +277,12 @@ int hpfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			goto out_unlock;
+
+		truncate_setsize(inode, attr->ia_size);
+		hpfs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
