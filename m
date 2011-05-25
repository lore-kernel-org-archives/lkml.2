Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1EYDSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:18:51 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:39820 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1EYDSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:18:50 -0400
Date: Wed, 25 May 2011 04:17:00 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Squashfs: reverse order of filesystem table reading
Message-ID: <4ddc74ac.7IK+8LBZrPnuKDZq%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reverse order of table reading from mostly first to last in placement
order, to last to first.  This is to enable extra superblock sanity
checks to be added in later patches.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/super.c |   71 ++++++++++++++++++++++++++------------------------
 1 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index d16c392..401cc8c 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -214,6 +214,24 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
+	/* Handle xattrs */
+	sb->s_xattr = squashfs_xattr_handlers;
+	xattr_id_table_start = le64_to_cpu(sblk->xattr_id_table_start);
+	if (xattr_id_table_start == SQUASHFS_INVALID_BLK)
+		goto allocate_id_index_table;
+
+	/* Allocate and read xattr id lookup table */
+	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
+		xattr_id_table_start, &msblk->xattr_table, &msblk->xattr_ids);
+	if (IS_ERR(msblk->xattr_id_table)) {
+		ERROR("unable to read xattr id index table\n");
+		err = PTR_ERR(msblk->xattr_id_table);
+		msblk->xattr_id_table = NULL;
+		if (err != -ENOTSUPP)
+			goto failed_mount;
+	}
+
+allocate_id_index_table:
 	/* Allocate and read id index table */
 	msblk->id_table = squashfs_read_id_index_table(sb,
 		le64_to_cpu(sblk->id_table_start), le16_to_cpu(sblk->no_ids));
@@ -224,9 +242,27 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
+	/* Handle inode lookup table */
+	lookup_table_start = le64_to_cpu(sblk->lookup_table_start);
+	if (lookup_table_start == SQUASHFS_INVALID_BLK)
+		goto handle_fragments;
+
+	/* Allocate and read inode lookup table */
+	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
+		lookup_table_start, msblk->inodes);
+	if (IS_ERR(msblk->inode_lookup_table)) {
+		ERROR("unable to read inode lookup table\n");
+		err = PTR_ERR(msblk->inode_lookup_table);
+		msblk->inode_lookup_table = NULL;
+		goto failed_mount;
+	}
+
+	sb->s_export_op = &squashfs_export_ops;
+
+handle_fragments:
 	fragments = le32_to_cpu(sblk->fragments);
 	if (fragments == 0)
-		goto allocate_lookup_table;
+		goto allocate_root;
 
 	msblk->fragment_cache = squashfs_cache_init("fragment",
 		SQUASHFS_CACHED_FRAGMENTS, msblk->block_size);
@@ -245,39 +281,6 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-allocate_lookup_table:
-	lookup_table_start = le64_to_cpu(sblk->lookup_table_start);
-	if (lookup_table_start == SQUASHFS_INVALID_BLK)
-		goto allocate_xattr_table;
-
-	/* Allocate and read inode lookup table */
-	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
-		lookup_table_start, msblk->inodes);
-	if (IS_ERR(msblk->inode_lookup_table)) {
-		ERROR("unable to read inode lookup table\n");
-		err = PTR_ERR(msblk->inode_lookup_table);
-		msblk->inode_lookup_table = NULL;
-		goto failed_mount;
-	}
-
-	sb->s_export_op = &squashfs_export_ops;
-
-allocate_xattr_table:
-	sb->s_xattr = squashfs_xattr_handlers;
-	xattr_id_table_start = le64_to_cpu(sblk->xattr_id_table_start);
-	if (xattr_id_table_start == SQUASHFS_INVALID_BLK)
-		goto allocate_root;
-
-	/* Allocate and read xattr id lookup table */
-	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
-		xattr_id_table_start, &msblk->xattr_table, &msblk->xattr_ids);
-	if (IS_ERR(msblk->xattr_id_table)) {
-		ERROR("unable to read xattr id index table\n");
-		err = PTR_ERR(msblk->xattr_id_table);
-		msblk->xattr_id_table = NULL;
-		if (err != -ENOTSUPP)
-			goto failed_mount;
-	}
 allocate_root:
 	root = new_inode(sb);
 	if (!root) {
-- 
1.7.1

