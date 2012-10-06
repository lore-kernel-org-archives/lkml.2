Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2JFI0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:26:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60538 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2JFI0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:26:07 -0400
Message-ID: <506FE990.6000901@gmail.com>
Date: Sat, 06 Oct 2012 10:19:28 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/22] affs: drop vmtruncate
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
index 15c4842..0e092d0 100644
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
