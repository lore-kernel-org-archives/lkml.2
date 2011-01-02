Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1ABHtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:49:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:35840 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1ABHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 138/260] ext4: Fix remaining racy updates of EXT4_I(inode)->i_flags
Date: Sun,  2 Jan 2011 02:17:14 -0500
Message-Id: <1293952756-15010-139-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:41.0056 (UTC) FILETIME=[D73E0200:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 84a8dce2710cc425089a2b92acc354d4fbb5788d upstream.

A few functions were still modifying i_flags in a racy manner.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/inode.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3fd683f..4eced51 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4932,20 +4932,26 @@ void ext4_set_inode_flags(struct inode *inode)
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
 void ext4_get_inode_flags(struct ext4_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
-
-	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
-	if (flags & S_SYNC)
-		ei->i_flags |= EXT4_SYNC_FL;
-	if (flags & S_APPEND)
-		ei->i_flags |= EXT4_APPEND_FL;
-	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT4_IMMUTABLE_FL;
-	if (flags & S_NOATIME)
-		ei->i_flags |= EXT4_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT4_DIRSYNC_FL;
+	unsigned int vfs_fl;
+	unsigned long old_fl, new_fl;
+
+	do {
+		vfs_fl = ei->vfs_inode.i_flags;
+		old_fl = ei->i_flags;
+		new_fl = old_fl & ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
+				EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|
+				EXT4_DIRSYNC_FL);
+		if (vfs_fl & S_SYNC)
+			new_fl |= EXT4_SYNC_FL;
+		if (vfs_fl & S_APPEND)
+			new_fl |= EXT4_APPEND_FL;
+		if (vfs_fl & S_IMMUTABLE)
+			new_fl |= EXT4_IMMUTABLE_FL;
+		if (vfs_fl & S_NOATIME)
+			new_fl |= EXT4_NOATIME_FL;
+		if (vfs_fl & S_DIRSYNC)
+			new_fl |= EXT4_DIRSYNC_FL;
+	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
@@ -5182,7 +5188,7 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = 0;
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
@@ -5195,9 +5201,9 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 	} else {
-		ei->i_flags |= EXT4_HUGE_FILE_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		/* i_block is stored in file system block size */
 		i_blocks = i_blocks >> (inode->i_blkbits - 9);
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
-- 
1.7.3.3

