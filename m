Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2JFIk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:40:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61724 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2JFIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:40:24 -0400
Message-ID: <506FECE9.3020308@gmail.com>
Date: Sat, 06 Oct 2012 10:33:45 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 18/22] nilfs2: drop vmtruncate
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
index 4d31d2c..aed753a 100644
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
