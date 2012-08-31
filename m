Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2HaOIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:08:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63843 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2HaOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:08:40 -0400
Message-ID: <5040C3DB.7090000@gmail.com>
Date: Fri, 31 Aug 2012 16:02:03 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/21] nilfs2: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/nilfs2/file.c     |    1 -
 fs/nilfs2/inode.c    |   18 +++++++++++++-----
 fs/nilfs2/recovery.c |    7 +++++--
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index a4d56ac..543554b 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -166,7 +166,6 @@ const struct file_operations nilfs_file_operations = {
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
-	.truncate	= nilfs_truncate,
 	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
 	.fiemap		= nilfs_fiemap,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6e2c3db..1f48ee8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -228,8 +228,11 @@ static int nilfs_write_begin(struct file *file, struct address_space *mapping,
 				nilfs_get_block);
 	if (unlikely(err)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			nilfs_truncate(mapping->host);
+		}
 
 		nilfs_transaction_abort(inode->i_sb);
 	}
@@ -277,8 +280,10 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			nilfs_truncate(inode);
+		}
 	}
 
 	return size;
@@ -787,9 +792,12 @@ int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	    iattr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 
-		err = vmtruncate(inode, iattr->ia_size);
+		err = inode_newsize_ok(inode, iattr->ia_size);
 		if (unlikely(err))
 			goto out_err;
+
+		truncate_setsize(inode, iattr->ia_size);
+		nilfs_truncate(inode);
 	}
 
 	setattr_copy(inode, iattr);
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index f1626f5..cec215e 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -526,8 +526,11 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 					0, &page, nilfs_get_block);
 		if (unlikely(err)) {
 			loff_t isize = inode->i_size;
-			if (pos + blocksize > isize)
-				vmtruncate(inode, isize);
+			if ((pos + blocksize > isize) &&
+				inode_newsize_ok(inode, isize) == 0) {
+				truncate_setsize(inode, isize);
+				nilfs_truncate(inode);
+			}
 			goto failed_inode;
 		}
 
-- 
1.7.3.4
