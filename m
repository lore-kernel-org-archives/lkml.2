Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2HaOCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:02:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2HaOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:02:32 -0400
Message-ID: <5040C269.5070807@gmail.com>
Date: Fri, 31 Aug 2012 15:55:53 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>, Luca Tettamanti <kronos.it@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/21] affs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/affs/file.c  |    8 +++++---
 fs/affs/inode.c |    5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 2f4c935..34ebe09 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -39,7 +39,6 @@ const struct file_operations affs_file_operations = {
 };
 
 const struct inode_operations affs_file_inode_operations = {
-	.truncate	= affs_truncate,
 	.setattr	= affs_notify_change,
 };
 
@@ -414,8 +413,11 @@ static int affs_write_begin(struct file *file, struct address_space *mapping,
 				&AFFS_I(mapping->host)->mmu_private);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			affs_truncate(mapping->host);
+		}
 	}
 
 	return ret;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 8bc4a59..135bc68 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -237,9 +237,12 @@ affs_notify_change(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		affs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
