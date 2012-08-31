Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2HaOHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:07:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2HaOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:07:33 -0400
Message-ID: <5040C398.3070207@gmail.com>
Date: Fri, 31 Aug 2012 16:00:56 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>, Luca Tettamanti <kronos.it@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] minix: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/minix/file.c  |    6 ++++--
 fs/minix/inode.c |    7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/minix/file.c b/fs/minix/file.c
index 4493ce6..adc6f54 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -34,9 +34,12 @@ static int minix_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+
+		truncate_setsize(inode, attr->ia_size);
+		minix_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -45,7 +48,6 @@ static int minix_setattr(struct dentry *dentry, struct iattr *attr)
 }
 
 const struct inode_operations minix_file_inode_operations = {
-	.truncate	= minix_truncate,
 	.setattr	= minix_setattr,
 	.getattr	= minix_getattr,
 };
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 2a503ad..0837568 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -400,8 +400,11 @@ static int minix_write_begin(struct file *file, struct address_space *mapping,
 				minix_get_block);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			minix_truncate(mapping->host);
+		}
 	}
 
 	return ret;
-- 
1.7.3.4
