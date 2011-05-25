Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1EYDTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:19:42 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:54101 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1EYDTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:19:41 -0400
Date: Wed, 25 May 2011 04:19:38 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Squashfs: add sanity checks to id reading at mount
 time
Message-ID: <4ddc754a.rUkSC+Fh8Nx3g9+6%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fsfuzzer generates corrupted filesystems which throw a warn_on in
kmalloc.  One of these is due to a corrupted superblock no_ids field.
Fix this by checking that the number of bytes to be read (and allocated)
does not extend into the next filesystem structure.

Also add a couple of other sanity checks of the mount-time id table
structures.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/id.c       |   30 ++++++++++++++++++++++++++++--
 fs/squashfs/squashfs.h |    2 +-
 fs/squashfs/super.c    |   10 +++++++---
 fs/squashfs/xattr.h    |    1 +
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/id.c b/fs/squashfs/id.c
index 2fdac67..8650cb0 100644
--- a/fs/squashfs/id.c
+++ b/fs/squashfs/id.c
@@ -66,11 +66,37 @@ int squashfs_get_id(struct super_block *sb, unsigned int index,
  * Read uncompressed id lookup table indexes from disk into memory
  */
 __le64 *squashfs_read_id_index_table(struct super_block *sb,
-			u64 id_table_start, unsigned short no_ids)
+		u64 id_table_start, u64 next_table, unsigned short no_ids)
 {
 	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
+	__le64 *table;
 
 	TRACE("In read_id_index_table, length %d\n", length);
 
-	return squashfs_read_table(sb, id_table_start, length);
+	/* Sanity check values */
+
+	/* there should always be at least one id */
+	if (no_ids == 0)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * length bytes should not extend into the next table - this check
+	 * also traps instances where id_table_start is incorrectly larger
+	 * than the next table start
+	 */
+	if (id_table_start + length > next_table)
+		return ERR_PTR(-EINVAL);
+
+	table = squashfs_read_table(sb, id_table_start, length);
+
+	/*
+	 * table[0] points to the first id lookup table metadata block, this
+	 * should be less than id_table_start
+	 */
+	if (table[0] >= id_table_start) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return table;
 }
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index d622e84..0e3d220 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -61,7 +61,7 @@ extern __le64 *squashfs_read_fragment_index_table(struct super_block *,
 
 /* id.c */
 extern int squashfs_get_id(struct super_block *, unsigned int, unsigned int *);
-extern __le64 *squashfs_read_id_index_table(struct super_block *, u64,
+extern __le64 *squashfs_read_id_index_table(struct super_block *, u64, u64,
 				unsigned short);
 
 /* inode.c */
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 401cc8c..8f5f278 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -83,7 +83,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	long long root_inode;
 	unsigned short flags;
 	unsigned int fragments;
-	u64 lookup_table_start, xattr_id_table_start;
+	u64 lookup_table_start, xattr_id_table_start, next_table;
 	int err;
 
 	TRACE("Entered squashfs_fill_superblock\n");
@@ -217,8 +217,10 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* Handle xattrs */
 	sb->s_xattr = squashfs_xattr_handlers;
 	xattr_id_table_start = le64_to_cpu(sblk->xattr_id_table_start);
-	if (xattr_id_table_start == SQUASHFS_INVALID_BLK)
+	if (xattr_id_table_start == SQUASHFS_INVALID_BLK) {
+		next_table = msblk->bytes_used;
 		goto allocate_id_index_table;
+	}
 
 	/* Allocate and read xattr id lookup table */
 	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
@@ -230,11 +232,13 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		if (err != -ENOTSUPP)
 			goto failed_mount;
 	}
+	next_table = msblk->xattr_table;
 
 allocate_id_index_table:
 	/* Allocate and read id index table */
 	msblk->id_table = squashfs_read_id_index_table(sb,
-		le64_to_cpu(sblk->id_table_start), le16_to_cpu(sblk->no_ids));
+		le64_to_cpu(sblk->id_table_start), next_table,
+		le16_to_cpu(sblk->no_ids));
 	if (IS_ERR(msblk->id_table)) {
 		ERROR("unable to read id index table\n");
 		err = PTR_ERR(msblk->id_table);
diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
index b634efc..9b3dd6c 100644
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -31,6 +31,7 @@ static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
 		u64 start, u64 *xattr_table_start, int *xattr_ids)
 {
 	ERROR("Xattrs in filesystem, these will be ignored\n");
+	*xattr_table_start = start;
 	return ERR_PTR(-ENOTSUPP);
 }
 
-- 
1.7.1

