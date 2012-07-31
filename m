Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2GaEug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48673 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502Ab2GaEu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:29 -0400
Message-Id: <20120731044321.590062175@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>,
        Brian Foster <bfoster@redhat.com>
Subject: [ 64/73] ext4: undo ext4_calc_metadata_amount if we fail to claim space
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 25f809d..89b59cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1182,6 +1182,17 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
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
@@ -1190,32 +1201,31 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
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


