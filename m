Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1ABHV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:34261 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1ABHVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 014/260] ext4: clean up inode bitmaps manipulation in ext4_free_inode
Date: Sun,  2 Jan 2011 02:15:10 -0500
Message-Id: <1293952756-15010-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:21.0741 (UTC) FILETIME=[843439D0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit d17413c08cd2b1dd2bf2cfdbb0f7b736b2b2b15c upstream.

- Reorganize locking scheme to batch two atomic operation in to one.
  This also allow us to state what healthy group must obey following rule
  ext4_free_inodes_count(sb, gdp) == ext4_count_free(inode_bitmap, NUM);
- Fix possible undefined pointer dereference.
- Even if group descriptor stats aren't accessible we have to update
  inode bitmaps.
- Move non-group members update out of group_lock.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/ialloc.c |   81 ++++++++++++++++++++++++-----------------------------
 1 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 57f6eef..52618d5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -240,56 +240,49 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	if (fatal)
 		goto error_return;
 
-	/* Ok, now we can actually update the inode bitmaps.. */
-	cleared = ext4_clear_bit_atomic(ext4_group_lock_ptr(sb, block_group),
-					bit, bitmap_bh->b_data);
-	if (!cleared)
-		ext4_error(sb, "bit already cleared for inode %lu", ino);
-	else {
-		gdp = ext4_get_group_desc(sb, block_group, &bh2);
-
+	fatal = -ESRCH;
+	gdp = ext4_get_group_desc(sb, block_group, &bh2);
+	if (gdp) {
 		BUFFER_TRACE(bh2, "get_write_access");
 		fatal = ext4_journal_get_write_access(handle, bh2);
-		if (fatal) goto error_return;
-
-		if (gdp) {
-			ext4_lock_group(sb, block_group);
-			count = ext4_free_inodes_count(sb, gdp) + 1;
-			ext4_free_inodes_set(sb, gdp, count);
-			if (is_directory) {
-				count = ext4_used_dirs_count(sb, gdp) - 1;
-				ext4_used_dirs_set(sb, gdp, count);
-				if (sbi->s_log_groups_per_flex) {
-					ext4_group_t f;
-
-					f = ext4_flex_group(sbi, block_group);
-					atomic_dec(&sbi->s_flex_groups[f].used_dirs);
-				}
+	}
+	ext4_lock_group(sb, block_group);
+	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	if (fatal || !cleared) {
+		ext4_unlock_group(sb, block_group);
+		goto out;
+	}
 
-			}
-			gdp->bg_checksum = ext4_group_desc_csum(sbi,
-							block_group, gdp);
-			ext4_unlock_group(sb, block_group);
-			percpu_counter_inc(&sbi->s_freeinodes_counter);
-			if (is_directory)
-				percpu_counter_dec(&sbi->s_dirs_counter);
-
-			if (sbi->s_log_groups_per_flex) {
-				ext4_group_t f;
-
-				f = ext4_flex_group(sbi, block_group);
-				atomic_inc(&sbi->s_flex_groups[f].free_inodes);
-			}
-		}
-		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
-		err = ext4_handle_dirty_metadata(handle, NULL, bh2);
-		if (!fatal) fatal = err;
+	count = ext4_free_inodes_count(sb, gdp) + 1;
+	ext4_free_inodes_set(sb, gdp, count);
+	if (is_directory) {
+		count = ext4_used_dirs_count(sb, gdp) - 1;
+		ext4_used_dirs_set(sb, gdp, count);
+		percpu_counter_dec(&sbi->s_dirs_counter);
 	}
-	BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
-	if (!fatal)
-		fatal = err;
-	sb->s_dirt = 1;
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_unlock_group(sb, block_group);
+
+	percpu_counter_inc(&sbi->s_freeinodes_counter);
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t f = ext4_flex_group(sbi, block_group);
+
+		atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+		if (is_directory)
+			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
+	}
+	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
+out:
+	if (cleared) {
+		BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
+		if (!fatal)
+			fatal = err;
+		sb->s_dirt = 1;
+	} else
+		ext4_error(sb, "bit already cleared for inode %lu", ino);
+
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, fatal);
-- 
1.7.3.3

