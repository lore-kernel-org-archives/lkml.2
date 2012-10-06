Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2JFIgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:36:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48609 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2JFIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:36:02 -0400
Message-ID: <506FEBE3.5000504@gmail.com>
Date: Sat, 06 Oct 2012 10:29:23 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 11/22] hpfs: drop vmtruncate
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
index 804a9a8..5dc06c8 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -277,9 +277,12 @@ int hpfs_setattr(struct dentry *dentry, struct iattr *attr)
 
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
