Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2JFISC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:18:02 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64291 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2JFIR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:17:59 -0400
Message-ID: <506FE7A8.4000605@gmail.com>
Date: Sat, 06 Oct 2012 10:11:20 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 02/22] sysv: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/sysv/file.c  |    5 +++--
 fs/sysv/itree.c |    7 +++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

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
index 90b54b4..0d9c9c8 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -473,8 +473,11 @@ static int sysv_write_begin(struct file *file, struct address_space *mapping,
 	ret = block_write_begin(mapping, pos, len, flags, pagep, get_block);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			sysv_truncate(mapping->host);
+		}
 	}
 
 	return ret;
-- 
1.7.3.4
