Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab0G3S7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:59:31 -0400
Received: from kroah.org ([198.145.64.141]:51814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab0G3RTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.869879899@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [091/165] ext4: Fix quota accounting error with fallocate
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 5f634d064c709ea02c3cdaa850a08323a4a4bf28 upstream (as of v2.6.33-rc6)

When we fallocate a region of the file which we had recently written,
and which is still in the page cache marked as delayed allocated blocks
we need to make sure we don't do the quota update on writepage path.
This is because the needed quota updated would have already be done
by fallocate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/extents.c |   21 +++++++++++++++++++++
 fs/ext4/inode.c   |   44 +++++++++++++++++++++++++++++++-------------
 3 files changed, 54 insertions(+), 13 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1440,6 +1440,8 @@ extern int ext4_block_truncate_page(hand
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
+extern void ext4_da_update_reserve_space(struct inode *inode,
+					int used, int quota_claim);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3138,7 +3138,19 @@ out:
 		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
 					newblock + max_blocks,
 					allocated - max_blocks);
+		allocated = max_blocks;
 	}
+
+	/*
+	 * If we have done fallocate with the offset that is already
+	 * delayed allocated, we would have block reservation
+	 * and quota reservation done in the delayed write path.
+	 * But fallocate would have already updated quota and block
+	 * count for this offset. So cancel these reservation
+	 */
+	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+		ext4_da_update_reserve_space(inode, allocated, 0);
+
 map_out:
 	set_buffer_mapped(bh_result);
 out1:
@@ -3374,9 +3386,18 @@ int ext4_ext_get_blocks(handle_t *handle
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
+	if (allocated > max_blocks)
+		allocated = max_blocks;
 	set_buffer_new(bh_result);
 
 	/*
+	 * Update reserved blocks/metadata blocks after successful
+	 * block allocation which had been deferred till now.
+	 */
+	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+		ext4_da_update_reserve_space(inode, allocated, 1);
+
+	/*
 	 * Cache the extent and update transaction to commit on fdatasync only
 	 * when it is _not_ an uninitialized extent.
 	 */
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1095,11 +1095,12 @@ static int ext4_calc_metadata_amount(str
  * Called with i_data_sem down, which is important since we can call
  * ext4_discard_preallocations() from here.
  */
-static void ext4_da_update_reserve_space(struct inode *inode, int used)
+void ext4_da_update_reserve_space(struct inode *inode,
+					int used, int quota_claim)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	int mdb_free = 0;
+	int mdb_free = 0, allocated_meta_blocks = 0;
 
 	spin_lock(&ei->i_block_reservation_lock);
 	if (unlikely(used > ei->i_reserved_data_blocks)) {
@@ -1115,6 +1116,7 @@ static void ext4_da_update_reserve_space
 	ei->i_reserved_data_blocks -= used;
 	used += ei->i_allocated_meta_blocks;
 	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
+	allocated_meta_blocks = ei->i_allocated_meta_blocks;
 	ei->i_allocated_meta_blocks = 0;
 	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used);
 
@@ -1132,9 +1134,23 @@ static void ext4_da_update_reserve_space
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/* Update quota subsystem */
-	vfs_dq_claim_block(inode, used);
-	if (mdb_free)
-		vfs_dq_release_reservation_block(inode, mdb_free);
+	if (quota_claim) {
+		vfs_dq_claim_block(inode, used);
+		if (mdb_free)
+			vfs_dq_release_reservation_block(inode, mdb_free);
+	} else {
+		/*
+		 * We did fallocate with an offset that is already delayed
+		 * allocated. So on delayed allocated writeback we should
+		 * not update the quota for allocated blocks. But then
+		 * converting an fallocate region to initialized region would
+		 * have caused a metadata allocation. So claim quota for
+		 * that
+		 */
+		if (allocated_meta_blocks)
+			vfs_dq_claim_block(inode, allocated_meta_blocks);
+		vfs_dq_release_reservation_block(inode, mdb_free + used);
+	}
 
 	/*
 	 * If we have done all the pending block allocations and if
@@ -1334,18 +1350,20 @@ int ext4_get_blocks(handle_t *handle, st
 			 */
 			EXT4_I(inode)->i_state &= ~EXT4_STATE_EXT_MIGRATE;
 		}
-	}
 
+		/*
+		 * Update reserved blocks/metadata blocks after successful
+		 * block allocation which had been deferred till now. We don't
+		 * support fallocate for non extent files. So we can update
+		 * reserve space here.
+		 */
+		if ((retval > 0) &&
+			(flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
+			ext4_da_update_reserve_space(inode, retval, 1);
+	}
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		EXT4_I(inode)->i_delalloc_reserved_flag = 0;
 
-	/*
-	 * Update reserved blocks/metadata blocks after successful
-	 * block allocation which had been deferred till now.
-	 */
-	if ((retval > 0) && (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
-		ext4_da_update_reserve_space(inode, retval);
-
 	up_write((&EXT4_I(inode)->i_data_sem));
 	if (retval > 0 && buffer_mapped(bh)) {
 		int ret = check_block_validity(inode, "file system "


