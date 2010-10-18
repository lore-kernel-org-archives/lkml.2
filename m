Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab0JRPes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:34:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47619 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab0JRPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U1PgYryeZf/vm3fCkOkG38LD7KRIBlU5L6kyBx1De9UJ8a+DkYGXVmsvBIO+Wdaqrr
         KJJCIrjFqecOnIvLt/wKFXeyWVxUG4vzeCOm0A2Az1J2U9j/rjzv1rjUIkzpypAc1Y+n
         nbwBPASh+7m6S7muVyUaJIGlRMJHaay505IMA=
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext3: Update kernel-doc comments
Date: Tue, 19 Oct 2010 00:34:35 +0900
Message-Id: <1287416075-3783-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update missing/broken argument descriptions and fix formatting.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/balloc.c |   13 ++++++++-----
 fs/ext3/inode.c  |   19 ++++++++++++-------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a49ce4a..b3db226 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -810,8 +810,9 @@ find_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
 
 /**
  * claim_block()
+ * @lock:		the spin lock for this block group
  * @block:		the free block (group relative) to allocate
- * @bh:			the bufferhead containts the block group bitmap
+ * @bh:			the buffer_head contains the block group bitmap
  *
  * We think we can allocate this block in this bitmap.  Try to set the bit.
  * If that succeeds then check that nobody has allocated and then freed the
@@ -956,9 +957,11 @@ fail_access:
  *		but we will shift to the place where start_block is,
  *		then start from there, when looking for a reservable space.
  *
- *	@size: the target new reservation window size
+ *	@my_rsv: the reservation window
  *
- *	@group_first_block: the first block we consider to start
+ *	@sb: the super block
+ *
+ *	@start_block: the first block we consider to start
  *			the real search from
  *
  *	@last_block:
@@ -1084,7 +1087,7 @@ static int find_next_reservable_window(
  *
  *	failed: we failed to find a reservation window in this group
  *
- *	@rsv: the reservation
+ *	@my_rsv: the reservation window
  *
  *	@grp_goal: The goal (group-relative).  It is where the search for a
  *		free reservable space should start from.
@@ -1273,8 +1276,8 @@ static void try_to_extend_reservation(struct ext3_reserve_window_node *my_rsv,
  * @group:		given allocation block group
  * @bitmap_bh:		bufferhead holds the block bitmap
  * @grp_goal:		given target block within the group
- * @count:		target number of blocks to allocate
  * @my_rsv:		reservation window
+ * @count:		target number of blocks to allocate
  * @errp:		pointer to store the error code
  *
  * This is the main function used to allocate a new block and its reservation
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 90a9c3d..ef1c23a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -498,7 +498,7 @@ static ext3_fsblk_t ext3_find_goal(struct inode *inode, long block,
 }
 
 /**
- *	ext3_blks_to_allocate: Look up the block map and count the number
+ *	ext3_blks_to_allocate - Look up the block map and count the number
  *	of direct blocks need to be allocated for the given branch.
  *
  *	@branch: chain of indirect blocks
@@ -536,14 +536,18 @@ static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
 }
 
 /**
- *	ext3_alloc_blocks: multiple allocate blocks needed for a branch
+ *	ext3_alloc_blocks - multiple allocate blocks needed for a branch
+ *	@handle: handle for this transaction
+ *	@inode: owner
+ *	@goal: preferred place for allocation
  *	@indirect_blks: the number of blocks need to allocate for indirect
  *			blocks
- *
+ *	@blks:	number of blocks need to allocated for direct blocks
  *	@new_blocks: on return it will store the new block numbers for
  *	the indirect blocks(if needed) and the first direct block,
- *	@blks:	on return it will store the total number of allocated
- *		direct blocks
+ *	@err: here we store the error value
+ *
+ *	return the number of direct blocks allocated
  */
 static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int indirect_blks, int blks,
@@ -598,9 +602,11 @@ failed_out:
 
 /**
  *	ext3_alloc_branch - allocate and set up a chain of blocks.
+ *	@handle: handle for this transaction
  *	@inode: owner
  *	@indirect_blks: number of allocated indirect blocks
  *	@blks: number of allocated direct blocks
+ *	@goal: preferred place for allocation
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
  *
@@ -700,10 +706,9 @@ failed:
 
 /**
  * ext3_splice_branch - splice the allocated branch onto inode.
+ * @handle: handle for this transaction
  * @inode: owner
  * @block: (logical) number of block we are adding
- * @chain: chain of indirect blocks (with a missing link - see
- *	ext3_alloc_branch)
  * @where: location of missing link
  * @num:   number of indirect blocks we are adding
  * @blks:  number of direct blocks we are adding
-- 
1.7.0.4

