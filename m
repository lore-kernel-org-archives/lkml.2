Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2JFIhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:37:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62841 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2JFIhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:37:18 -0400
Message-ID: <506FEC2E.10301@gmail.com>
Date: Sat, 06 Oct 2012 10:30:38 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 13/22] hfsplus: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hfsplus/inode.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2172aa5..2562462 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -40,8 +40,11 @@ static int hfsplus_write_begin(struct file *file, struct address_space *mapping,
 				&HFSPLUS_I(mapping->host)->phys_size);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			hfsplus_file_truncate(mapping->host);
+		}
 	}
 
 	return ret;
@@ -130,8 +133,10 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			hfsplus_file_truncate(inode);
+		}
 	}
 
 	return ret;
@@ -301,9 +306,12 @@ static int hfsplus_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		hfsplus_file_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -358,7 +366,6 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
-	.truncate	= hfsplus_file_truncate,
 	.setattr	= hfsplus_setattr,
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
-- 
1.7.3.4
