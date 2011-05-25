Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1EYDVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:21:34 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:52633 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756360Ab1EYDVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:21:33 -0400
Date: Wed, 25 May 2011 04:21:30 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Squashfs: add sanity checks to fragment reading at
 mount time
Message-ID: <4ddc75ba.0NJiNjKRdOwf6Dc/%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fsfuzzer generates corrupted filesystems which throw a warn_on in
kmalloc.  One of these is due to a corrupted superblock fragments field.
Fix this by checking that the number of bytes to be read (and allocated)
does not extend into the next filesystem structure.

Also add a couple of other sanity checks of the mount-time fragment table
structures.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/fragment.c |   24 ++++++++++++++++++++++--
 fs/squashfs/squashfs.h |    2 +-
 fs/squashfs/super.c    |    3 ++-
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/fragment.c b/fs/squashfs/fragment.c
index 567093d..8f84049 100644
--- a/fs/squashfs/fragment.c
+++ b/fs/squashfs/fragment.c
@@ -71,9 +71,29 @@ int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
  * Read the uncompressed fragment lookup table indexes off disk into memory
  */
 __le64 *squashfs_read_fragment_index_table(struct super_block *sb,
-	u64 fragment_table_start, unsigned int fragments)
+	u64 fragment_table_start, u64 next_table, unsigned int fragments)
 {
 	unsigned int length = SQUASHFS_FRAGMENT_INDEX_BYTES(fragments);
+	__le64 *table;
 
-	return squashfs_read_table(sb, fragment_table_start, length);
+	/*
+	 * Sanity check, length bytes should not extend into the next table -
+	 * this check also traps instances where fragment_table_start is
+	 * incorrectly larger than the next table start
+	 */
+	if (fragment_table_start + length > next_table)
+		return ERR_PTR(-EINVAL);
+
+	table = squashfs_read_table(sb, fragment_table_start, length);
+
+	/*
+	 * table[0] points to the first fragment table metadata block, this
+	 * should be less than fragment_table_start
+	 */
+	if (table[0] >= fragment_table_start) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return table;
 }
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 3b705f1..647b81b 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -57,7 +57,7 @@ extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64, u64,
 /* fragment.c */
 extern int squashfs_frag_lookup(struct super_block *, unsigned int, u64 *);
 extern __le64 *squashfs_read_fragment_index_table(struct super_block *,
-				u64, unsigned int);
+				u64, u64, unsigned int);
 
 /* id.c */
 extern int squashfs_get_id(struct super_block *, unsigned int, unsigned int *);
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 80a7119..efa8118 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -261,6 +261,7 @@ allocate_id_index_table:
 		msblk->inode_lookup_table = NULL;
 		goto failed_mount;
 	}
+	next_table = msblk->inode_lookup_table[0];
 
 	sb->s_export_op = &squashfs_export_ops;
 
@@ -278,7 +279,7 @@ handle_fragments:
 
 	/* Allocate and read fragment index table */
 	msblk->fragment_index = squashfs_read_fragment_index_table(sb,
-		le64_to_cpu(sblk->fragment_table_start), fragments);
+		le64_to_cpu(sblk->fragment_table_start), next_table, fragments);
 	if (IS_ERR(msblk->fragment_index)) {
 		ERROR("unable to read fragment index table\n");
 		err = PTR_ERR(msblk->fragment_index);
-- 
1.7.1

