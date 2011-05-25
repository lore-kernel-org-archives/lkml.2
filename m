Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1EYDQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:16:18 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:53911 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1EYDQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:16:17 -0400
Date: Wed, 25 May 2011 04:16:13 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Squashfs: move table allocation into
 squashfs_read_table()
Message-ID: <4ddc747d.YaR3W6cQHk2RNnIw%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This eliminates a lot of duplicate code.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/cache.c    |   29 +++++++++++++++++++++++------
 fs/squashfs/export.c   |   19 +------------------
 fs/squashfs/fragment.c |   19 +------------------
 fs/squashfs/id.c       |   18 +-----------------
 fs/squashfs/squashfs.h |    2 +-
 fs/squashfs/super.c    |   21 ++++++++-------------
 fs/squashfs/xattr_id.c |   34 +++++++++-------------------------
 7 files changed, 44 insertions(+), 98 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index c37b520..00d5739 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -393,19 +393,36 @@ struct squashfs_cache_entry *squashfs_get_datablock(struct super_block *sb,
 /*
  * Read a filesystem table (uncompressed sequence of bytes) from disk
  */
-int squashfs_read_table(struct super_block *sb, void *buffer, u64 block,
-	int length)
+void *squashfs_read_table(struct super_block *sb, u64 block, int length)
 {
 	int pages = (length + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	int i, res;
-	void **data = kcalloc(pages, sizeof(void *), GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
+	void *table, *buffer, **data;
+
+	table = buffer = kmalloc(length, GFP_KERNEL);
+	if (table == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	data = kcalloc(pages, sizeof(void *), GFP_KERNEL);
+	if (data == NULL) {
+		res = -ENOMEM;
+		goto failed;
+	}
 
 	for (i = 0; i < pages; i++, buffer += PAGE_CACHE_SIZE)
 		data[i] = buffer;
+
 	res = squashfs_read_data(sb, data, block, length |
 		SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length, pages);
+
 	kfree(data);
-	return res;
+
+	if (res < 0)
+		goto failed;
+
+	return table;
+
+failed:
+	kfree(table);
+	return ERR_PTR(res);
 }
diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index 7f93d5a..cc6dd90 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -124,27 +124,10 @@ __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
 		u64 lookup_table_start, unsigned int inodes)
 {
 	unsigned int length = SQUASHFS_LOOKUP_BLOCK_BYTES(inodes);
-	__le64 *inode_lookup_table;
-	int err;
 
 	TRACE("In read_inode_lookup_table, length %d\n", length);
 
-	/* Allocate inode lookup table indexes */
-	inode_lookup_table = kmalloc(length, GFP_KERNEL);
-	if (inode_lookup_table == NULL) {
-		ERROR("Failed to allocate inode lookup table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	err = squashfs_read_table(sb, inode_lookup_table, lookup_table_start,
-			length);
-	if (err < 0) {
-		ERROR("unable to read inode lookup table\n");
-		kfree(inode_lookup_table);
-		return ERR_PTR(err);
-	}
-
-	return inode_lookup_table;
+	return squashfs_read_table(sb, lookup_table_start, length);
 }
 
 
diff --git a/fs/squashfs/fragment.c b/fs/squashfs/fragment.c
index 7eef571..567093d 100644
--- a/fs/squashfs/fragment.c
+++ b/fs/squashfs/fragment.c
@@ -74,23 +74,6 @@ __le64 *squashfs_read_fragment_index_table(struct super_block *sb,
 	u64 fragment_table_start, unsigned int fragments)
 {
 	unsigned int length = SQUASHFS_FRAGMENT_INDEX_BYTES(fragments);
-	__le64 *fragment_index;
-	int err;
 
-	/* Allocate fragment lookup table indexes */
-	fragment_index = kmalloc(length, GFP_KERNEL);
-	if (fragment_index == NULL) {
-		ERROR("Failed to allocate fragment index table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	err = squashfs_read_table(sb, fragment_index, fragment_table_start,
-			length);
-	if (err < 0) {
-		ERROR("unable to read fragment index table\n");
-		kfree(fragment_index);
-		return ERR_PTR(err);
-	}
-
-	return fragment_index;
+	return squashfs_read_table(sb, fragment_table_start, length);
 }
diff --git a/fs/squashfs/id.c b/fs/squashfs/id.c
index d8f3245..2fdac67 100644
--- a/fs/squashfs/id.c
+++ b/fs/squashfs/id.c
@@ -69,24 +69,8 @@ __le64 *squashfs_read_id_index_table(struct super_block *sb,
 			u64 id_table_start, unsigned short no_ids)
 {
 	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
-	__le64 *id_table;
-	int err;
 
 	TRACE("In read_id_index_table, length %d\n", length);
 
-	/* Allocate id lookup table indexes */
-	id_table = kmalloc(length, GFP_KERNEL);
-	if (id_table == NULL) {
-		ERROR("Failed to allocate id index table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	err = squashfs_read_table(sb, id_table, id_table_start, length);
-	if (err < 0) {
-		ERROR("unable to read id index table\n");
-		kfree(id_table);
-		return ERR_PTR(err);
-	}
-
-	return id_table;
+	return squashfs_read_table(sb, id_table_start, length);
 }
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 1f2e608..d622e84 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -44,7 +44,7 @@ extern struct squashfs_cache_entry *squashfs_get_fragment(struct super_block *,
 				u64, int);
 extern struct squashfs_cache_entry *squashfs_get_datablock(struct super_block *,
 				u64, int);
-extern int squashfs_read_table(struct super_block *, void *, u64, int);
+extern void *squashfs_read_table(struct super_block *, u64, int);
 
 /* decompressor.c */
 extern const struct squashfs_decompressor *squashfs_lookup_decompressor(int);
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 5c8184c..d16c392 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -95,12 +95,6 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	msblk = sb->s_fs_info;
 
-	sblk = kzalloc(sizeof(*sblk), GFP_KERNEL);
-	if (sblk == NULL) {
-		ERROR("Failed to allocate squashfs_super_block\n");
-		goto failure;
-	}
-
 	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
@@ -114,10 +108,12 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * of bytes_used) we need to set it to an initial sensible dummy value
 	 */
 	msblk->bytes_used = sizeof(*sblk);
-	err = squashfs_read_table(sb, sblk, SQUASHFS_START, sizeof(*sblk));
+	sblk = squashfs_read_table(sb, SQUASHFS_START, sizeof(*sblk));
 
-	if (err < 0) {
+	if (IS_ERR(sblk)) {
 		ERROR("unable to read squashfs_super_block\n");
+		err = PTR_ERR(sblk);
+		sblk = NULL;
 		goto failed_mount;
 	}
 
@@ -222,6 +218,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->id_table = squashfs_read_id_index_table(sb,
 		le64_to_cpu(sblk->id_table_start), le16_to_cpu(sblk->no_ids));
 	if (IS_ERR(msblk->id_table)) {
+		ERROR("unable to read id index table\n");
 		err = PTR_ERR(msblk->id_table);
 		msblk->id_table = NULL;
 		goto failed_mount;
@@ -242,6 +239,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->fragment_index = squashfs_read_fragment_index_table(sb,
 		le64_to_cpu(sblk->fragment_table_start), fragments);
 	if (IS_ERR(msblk->fragment_index)) {
+		ERROR("unable to read fragment index table\n");
 		err = PTR_ERR(msblk->fragment_index);
 		msblk->fragment_index = NULL;
 		goto failed_mount;
@@ -256,6 +254,7 @@ allocate_lookup_table:
 	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
 		lookup_table_start, msblk->inodes);
 	if (IS_ERR(msblk->inode_lookup_table)) {
+		ERROR("unable to read inode lookup table\n");
 		err = PTR_ERR(msblk->inode_lookup_table);
 		msblk->inode_lookup_table = NULL;
 		goto failed_mount;
@@ -273,6 +272,7 @@ allocate_xattr_table:
 	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
 		xattr_id_table_start, &msblk->xattr_table, &msblk->xattr_ids);
 	if (IS_ERR(msblk->xattr_id_table)) {
+		ERROR("unable to read xattr id index table\n");
 		err = PTR_ERR(msblk->xattr_id_table);
 		msblk->xattr_id_table = NULL;
 		if (err != -ENOTSUPP)
@@ -318,11 +318,6 @@ failed_mount:
 	sb->s_fs_info = NULL;
 	kfree(sblk);
 	return err;
-
-failure:
-	kfree(sb->s_fs_info);
-	sb->s_fs_info = NULL;
-	return -ENOMEM;
 }
 
 
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index 05385db..51a7bd0 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -67,34 +67,18 @@ __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 start,
 		u64 *xattr_table_start, int *xattr_ids)
 {
 	unsigned int len;
-	__le64 *xid_table;
-	struct squashfs_xattr_id_table id_table;
-	int err;
+	struct squashfs_xattr_id_table *id_table;
+
+	id_table = squashfs_read_table(sb, start, sizeof(*id_table));
+	if (IS_ERR(id_table))
+		return (__le64 *) id_table;
 
-	err = squashfs_read_table(sb, &id_table, start, sizeof(id_table));
-	if (err < 0) {
-		ERROR("unable to read xattr id table\n");
-		return ERR_PTR(err);
-	}
-	*xattr_table_start = le64_to_cpu(id_table.xattr_table_start);
-	*xattr_ids = le32_to_cpu(id_table.xattr_ids);
+	*xattr_table_start = le64_to_cpu(id_table->xattr_table_start);
+	*xattr_ids = le32_to_cpu(id_table->xattr_ids);
+	kfree(id_table);
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
 
 	TRACE("In read_xattr_index_table, length %d\n", len);
 
-	/* Allocate xattr id lookup table indexes */
-	xid_table = kmalloc(len, GFP_KERNEL);
-	if (xid_table == NULL) {
-		ERROR("Failed to allocate xattr id index table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	err = squashfs_read_table(sb, xid_table, start + sizeof(id_table), len);
-	if (err < 0) {
-		ERROR("unable to read xattr id index table\n");
-		kfree(xid_table);
-		return ERR_PTR(err);
-	}
-
-	return xid_table;
+	return squashfs_read_table(sb, start + sizeof(*id_table), len);
 }
-- 
1.7.1

