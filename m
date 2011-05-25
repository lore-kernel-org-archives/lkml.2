Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1EYDUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:20:46 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:54175 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1EYDUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:20:45 -0400
Date: Wed, 25 May 2011 04:20:42 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Squashfs: add sanity checks to lookup table reading
 at mount time
Message-ID: <4ddc758a.DqyiUsz4x11Zbgnz%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fsfuzzer generates corrupted filesystems which throw a warn_on in
kmalloc.  One of these is due to a corrupted superblock inodes field.
Fix this by checking that the number of bytes to be read (and allocated)
does not extend into the next filesystem structure.

Also add a couple of other sanity checks of the mount-time lookup table
structures.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/export.c   |   29 +++++++++++++++++++++++++++--
 fs/squashfs/squashfs.h |    2 +-
 fs/squashfs/super.c    |    3 ++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index cc6dd90..e54e4cb 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -121,13 +121,38 @@ static struct dentry *squashfs_get_parent(struct dentry *child)
  * Read uncompressed inode lookup table indexes off disk into memory
  */
 __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
-		u64 lookup_table_start, unsigned int inodes)
+		u64 lookup_table_start, u64 next_table, unsigned int inodes)
 {
 	unsigned int length = SQUASHFS_LOOKUP_BLOCK_BYTES(inodes);
+	__le64 *table;
 
 	TRACE("In read_inode_lookup_table, length %d\n", length);
 
-	return squashfs_read_table(sb, lookup_table_start, length);
+	/* Sanity check values */
+
+	/* there should always be at least one inode */
+	if (inodes == 0)
+		return ERR_PTR(-EINVAL);
+
+	/* length bytes should not extend into the next table - this check
+	 * also traps instances where lookup_table_start is incorrectly larger
+	 * than the next table start
+	 */
+	if (lookup_table_start + length > next_table)
+		return ERR_PTR(-EINVAL);
+
+	table = squashfs_read_table(sb, lookup_table_start, length);
+
+	/*
+	 * table[0] points to the first inode lookup table metadata block,
+	 * this should be less than lookup_table_start
+	 */
+	if (table[0] >= lookup_table_start) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return table;
 }
 
 
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 0e3d220..3b705f1 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -51,7 +51,7 @@ extern const struct squashfs_decompressor *squashfs_lookup_decompressor(int);
 extern void *squashfs_decompressor_init(struct super_block *, unsigned short);
 
 /* export.c */
-extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64,
+extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64, u64,
 				unsigned int);
 
 /* fragment.c */
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 8f5f278..80a7119 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -245,6 +245,7 @@ allocate_id_index_table:
 		msblk->id_table = NULL;
 		goto failed_mount;
 	}
+	next_table = msblk->id_table[0];
 
 	/* Handle inode lookup table */
 	lookup_table_start = le64_to_cpu(sblk->lookup_table_start);
@@ -253,7 +254,7 @@ allocate_id_index_table:
 
 	/* Allocate and read inode lookup table */
 	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
-		lookup_table_start, msblk->inodes);
+		lookup_table_start, next_table, msblk->inodes);
 	if (IS_ERR(msblk->inode_lookup_table)) {
 		ERROR("unable to read inode lookup table\n");
 		err = PTR_ERR(msblk->inode_lookup_table);
-- 
1.7.1

