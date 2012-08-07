Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787Ab2HGXEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:04:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030692Ab2HGWkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:40:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian Foster <bfoster@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 076/109] ext4: undo ext4_calc_metadata_amount if we fail to claim space
Date: Tue,  7 Aug 2012 15:35:35 -0700
Message-Id: <20120807222049.778010006@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 03179fe92318e7934c180d96f12eff2cb36ef7b6 upstream.

The function ext4_calc_metadata_amount() has side effects, although
it's not obvious from its function name.  So if we fail to claim
space, regardless of whether we retry to claim the space again, or
return an error, we need to undo these side effects.

Otherwise we can end up incorrectly calculating the number of metadata
blocks needed for the operation, which was responsible for an xfstests
failure for test #271 when using an ext2 file system with delalloc
enabled.

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1113,6 +1113,17 @@ static int ext4_da_reserve_space(struct
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
 	int ret;
+	ext4_lblk_t save_last_lblock;
+	int save_len;
+
+	/*
+	 * We will charge metadata quota at writeout time; this saves
+	 * us from metadata over-estimation, though we may go over by
+	 * a small amount in the end.  Here we just reserve for data.
+	 */
+	ret = dquot_reserve_block(inode, EXT4_C2B(sbi, 1));
+	if (ret)
+		return ret;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1121,32 +1132,31 @@ static int ext4_da_reserve_space(struct
 	 */
 repeat:
 	spin_lock(&ei->i_block_reservation_lock);
+	/*
+	 * ext4_calc_metadata_amount() has side effects, which we have
+	 * to be prepared undo if we fail to claim space.
+	 */
+	save_len = ei->i_da_metadata_calc_len;
+	save_last_lblock = ei->i_da_metadata_calc_last_lblock;
 	md_needed = EXT4_NUM_B2C(sbi,
 				 ext4_calc_metadata_amount(inode, lblock));
 	trace_ext4_da_reserve_space(inode, md_needed);
-	spin_unlock(&ei->i_block_reservation_lock);
 
 	/*
-	 * We will charge metadata quota at writeout time; this saves
-	 * us from metadata over-estimation, though we may go over by
-	 * a small amount in the end.  Here we just reserve for data.
-	 */
-	ret = dquot_reserve_block(inode, EXT4_C2B(sbi, 1));
-	if (ret)
-		return ret;
-	/*
 	 * We do still charge estimated metadata to the sb though;
 	 * we cannot afford to run out of free blocks.
 	 */
 	if (ext4_claim_free_clusters(sbi, md_needed + 1, 0)) {
-		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
+		ei->i_da_metadata_calc_len = save_len;
+		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
+		spin_unlock(&ei->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
+		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		return -ENOSPC;
 	}
-	spin_lock(&ei->i_block_reservation_lock);
 	ei->i_reserved_data_blocks++;
 	ei->i_reserved_meta_blocks += md_needed;
 	spin_unlock(&ei->i_block_reservation_lock);


