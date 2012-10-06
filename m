Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2JFIc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:32:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51013 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2JFIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:32:53 -0400
Message-ID: <506FEB24.4010902@gmail.com>
Date: Sat, 06 Oct 2012 10:26:12 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/22] hfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hfs/inode.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 0b35903..e0b2c23 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -47,8 +47,11 @@ static int hfs_write_begin(struct file *file, struct address_space *mapping,
 				&HFS_I(mapping->host)->phys_size);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			hfs_file_truncate(mapping->host);
+		}
 	}
 
 	return ret;
@@ -134,8 +137,10 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			hfs_file_truncate(inode);
+		}
 	}
 
 	return ret;
@@ -617,9 +622,12 @@ int hfs_inode_setattr(struct dentry *dentry, struct iattr * attr)
 	    attr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		hfs_file_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -668,7 +676,6 @@ static const struct file_operations hfs_file_operations = {
 
 static const struct inode_operations hfs_file_inode_operations = {
 	.lookup		= hfs_file_lookup,
-	.truncate	= hfs_file_truncate,
 	.setattr	= hfs_inode_setattr,
 	.setxattr	= hfs_setxattr,
 	.getxattr	= hfs_getxattr,
-- 
1.7.3.4
