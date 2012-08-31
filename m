Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2HaOER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:04:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63851 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2HaOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:04:15 -0400
Message-ID: <5040C2D2.6010100@gmail.com>
Date: Fri, 31 Aug 2012 15:57:38 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/21] hpfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hpfs/file.c  |    8 +++++---
 fs/hpfs/inode.c |    5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 89d2a58..895871a 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -117,8 +117,11 @@ static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 				&hpfs_i(mapping->host)->mmu_private);
 	if (unlikely(ret)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			hpfs_truncate(mapping->host);
+		}
 	}
 
 	return ret;
@@ -166,6 +169,5 @@ const struct file_operations hpfs_file_ops =
 
 const struct inode_operations hpfs_file_iops =
 {
-	.truncate	= hpfs_truncate,
 	.setattr	= hpfs_setattr,
 };
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index ed671e0..4c57a50 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -274,9 +274,12 @@ int hpfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			goto out_unlock;
+
+		truncate_setsize(inode, attr->ia_size);
+		hpfs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
