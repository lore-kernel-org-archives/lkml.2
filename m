Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1E1S6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:58:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33579 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1E1S6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rjx5zBWQid+WpaXaEueV96Uf4gpZq86V0Q3PfwwHm5tnbygJHDHDA9GdVD2CrBhziv
         wcg/4xyh4LV+HDtD33anzX7L4ttVkvDp09wW2QBIXD6pO64ObvUjUR0YuTRHZn13p5ou
         OYtRrvB9L4su1EXPrt97Vb74hDQ+L5egNbnzE=
From: Jonas Gorski <jonas.gorski@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] squashfs: Fix sanity checks for big endian systems
Date: Sat, 28 May 2011 20:57:32 +0200
Message-Id: <1306609052-11762-1-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression introduced in 37986f63c81bf23c856f65fc5e4830550e7f3d5b to
1094a4a6118019255bf0e4adaa96bb17ccec3a82 ("add sanity checks ..."):

squashfs_sb_info's id_table, fragment_index, xattr_id_table and
inode_lookup_table are stored in little endian and need to be read as such.
This was done correct mostly except when doing the sanity checks and
reading the superblock, resulting in squashfs aborting on big endian systems.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 fs/squashfs/export.c   |    2 +-
 fs/squashfs/fragment.c |    2 +-
 fs/squashfs/id.c       |    2 +-
 fs/squashfs/super.c    |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index 730c562..5e1101f 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -147,7 +147,7 @@ __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
 	 * table[0] points to the first inode lookup table metadata block,
 	 * this should be less than lookup_table_start
 	 */
-	if (!IS_ERR(table) && table[0] >= lookup_table_start) {
+	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= lookup_table_start) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/fs/squashfs/fragment.c b/fs/squashfs/fragment.c
index 1516a649..0ed6edb 100644
--- a/fs/squashfs/fragment.c
+++ b/fs/squashfs/fragment.c
@@ -90,7 +90,7 @@ __le64 *squashfs_read_fragment_index_table(struct super_block *sb,
 	 * table[0] points to the first fragment table metadata block, this
 	 * should be less than fragment_table_start
 	 */
-	if (!IS_ERR(table) && table[0] >= fragment_table_start) {
+	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= fragment_table_start) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/fs/squashfs/id.c b/fs/squashfs/id.c
index a70858e..d38ea3d 100644
--- a/fs/squashfs/id.c
+++ b/fs/squashfs/id.c
@@ -93,7 +93,7 @@ __le64 *squashfs_read_id_index_table(struct super_block *sb,
 	 * table[0] points to the first id lookup table metadata block, this
 	 * should be less than id_table_start
 	 */
-	if (!IS_ERR(table) && table[0] >= id_table_start) {
+	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= id_table_start) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 6f26abe..7438850 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -245,7 +245,7 @@ allocate_id_index_table:
 		msblk->id_table = NULL;
 		goto failed_mount;
 	}
-	next_table = msblk->id_table[0];
+	next_table = le64_to_cpu(msblk->id_table[0]);
 
 	/* Handle inode lookup table */
 	lookup_table_start = le64_to_cpu(sblk->lookup_table_start);
@@ -261,7 +261,7 @@ allocate_id_index_table:
 		msblk->inode_lookup_table = NULL;
 		goto failed_mount;
 	}
-	next_table = msblk->inode_lookup_table[0];
+	next_table = le64_to_cpu(msblk->inode_lookup_table[0]);
 
 	sb->s_export_op = &squashfs_export_ops;
 
@@ -286,7 +286,7 @@ handle_fragments:
 		msblk->fragment_index = NULL;
 		goto failed_mount;
 	}
-	next_table = msblk->fragment_index[0];
+	next_table = le64_to_cpu(msblk->fragment_index[0]);
 
 check_directory_table:
 	/* Sanity check directory_table */
-- 
1.7.2.5

