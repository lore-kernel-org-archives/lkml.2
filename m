Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2HaOEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:04:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59322 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2HaOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:04:45 -0400
Message-ID: <5040C2F0.1030001@gmail.com>
Date: Fri, 31 Aug 2012 15:58:08 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
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

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/jfs/file.c  |    6 ++++--
 fs/jfs/inode.c |   13 +++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 844f946..bcd94e5 100644
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
index 4692bf3..895be2e 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -310,8 +310,11 @@ static int jfs_write_begin(struct file *file, struct address_space *mapping,
 				jfs_get_block);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			jfs_truncate(mapping->host);
+		}
 	}
 
 	return ret;
@@ -340,8 +343,10 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			jfs_truncate(inode);
+		}
 	}
 
 	return ret;
-- 
1.7.3.4
