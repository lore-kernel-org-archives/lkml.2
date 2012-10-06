Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2JFIX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:23:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54247 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2JFIXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:23:53 -0400
Message-ID: <506FE909.20601@gmail.com>
Date: Sat, 06 Oct 2012 10:17:13 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Bob Copeland <me@bobcopeland.com>, linux-karma-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 05/22] omfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/omfs/file.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 77e3cb2..c10ab90 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -316,8 +316,11 @@ static int omfs_write_begin(struct file *file, struct address_space *mapping,
 				omfs_get_block);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			omfs_truncate(mapping->host);
+		}
 	}
 
 	return ret;
@@ -350,9 +353,11 @@ static int omfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+		truncate_setsize(inode, attr->ia_size);
+		omfs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
@@ -362,7 +367,6 @@ static int omfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 const struct inode_operations omfs_file_inops = {
 	.setattr = omfs_setattr,
-	.truncate = omfs_truncate
 };
 
 const struct address_space_operations omfs_aops = {
-- 
1.7.3.4
