Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab2KZRLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933621Ab2KZRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 178/270] ext4: fix metadata checksum calculation for the superblock
Date: Mon, 26 Nov 2012 14:57:48 -0200
Message-Id: <1353949160-26803-179-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 06db49e68ae70cf16819b85a14057acb2820776a upstream.

The function ext4_handle_dirty_super() was calculating the superblock
on the wrong block data.  As a result, when the superblock is modified
while it is mounted (most commonly, when inodes are added or removed
from the orphan list), the superblock checksum would be wrong.  We
didn't notice because the superblock *was* being correctly calculated
in ext4_commit_super(), and this would get called when the file system
was unmounted.  So the problem only became obvious if the system
crashed while the file system was mounted.

Fix this by removing the poorly designed function signature for
ext4_superblock_csum_set(); if it only took a single argument, the
pointer to a struct superblock, the ambiguity which caused this
mistake would have been impossible.

Reported-by: George Spelvin <linux@horizon.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ herton: backport for 3.5: s_dirt etc. still exists, adjust
  ext4_superblock_csum_set calls on ext4_mark_super_dirty and on
  __ext4_handle_dirty_super ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/ext4.h      |    7 ++-----
 fs/ext4/ext4_jbd2.c |    6 ++----
 fs/ext4/super.c     |    7 ++++---
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 01434f2..42f5a18 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2039,8 +2039,7 @@ extern int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count);
 extern int ext4_calculate_overhead(struct super_block *sb);
 extern int ext4_superblock_csum_verify(struct super_block *sb,
 				       struct ext4_super_block *es);
-extern void ext4_superblock_csum_set(struct super_block *sb,
-				     struct ext4_super_block *es);
+extern void ext4_superblock_csum_set(struct super_block *sb);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
@@ -2323,9 +2322,7 @@ static inline void ext4_unlock_group(struct super_block *sb,
 
 static inline void ext4_mark_super_dirty(struct super_block *sb)
 {
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-
-	ext4_superblock_csum_set(sb, es);
+	ext4_superblock_csum_set(sb);
 	if (EXT4_SB(sb)->s_journal == NULL)
 		sb->s_dirt =1;
 }
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 90f7c2e..f4f0ee6 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -145,15 +145,13 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
-		ext4_superblock_csum_set(sb,
-				(struct ext4_super_block *)bh->b_data);
+		ext4_superblock_csum_set(sb);
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
 	} else if (now) {
-		ext4_superblock_csum_set(sb,
-				(struct ext4_super_block *)bh->b_data);
+		ext4_superblock_csum_set(sb);
 		mark_buffer_dirty(bh);
 	} else
 		sb->s_dirt = 1;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 975405c..993392b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -144,9 +144,10 @@ int ext4_superblock_csum_verify(struct super_block *sb,
 	return es->s_checksum == ext4_superblock_csum(sb, es);
 }
 
-void ext4_superblock_csum_set(struct super_block *sb,
-			      struct ext4_super_block *es)
+void ext4_superblock_csum_set(struct super_block *sb)
 {
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		return;
@@ -4330,7 +4331,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 				&EXT4_SB(sb)->s_freeinodes_counter));
 	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
-	ext4_superblock_csum_set(sb, es);
+	ext4_superblock_csum_set(sb);
 	mark_buffer_dirty(sbh);
 	if (sync) {
 		error = sync_dirty_buffer(sbh);
-- 
1.7.9.5

