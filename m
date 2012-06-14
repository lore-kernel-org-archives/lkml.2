Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2FOAIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:08:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2FNX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:16 -0400
Message-Id: <20120614235624.699812699@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sander Eikelenboom <linux@eikelenboom.it>,
        Kees Cook <keescook@chromium.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 09/42] ext4: fix the free blocks calculation for ext3 file systems w/ uninit_bg
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b0dd6b70f0fda17ae9762fbb72d98e40a4f66556 upstream.

Ext3 filesystems that are converted to use as many ext4 file system
features as possible will enable uninit_bg to speed up e2fsck times.
These file systems will have a native ext3 layout of inode tables and
block allocation bitmaps (as opposed to ext4's flex_bg layout).
Unfortunately, in these cases, when first allocating a block in an
uninitialized block group, ext4 would incorrectly calculate the number
of free blocks in that block group, and then errorneously report that
the file system was corrupt:

EXT4-fs error (device vdd): ext4_mb_generate_buddy:741: group 30, 32254 clusters in bitmap, 32258 in gd

This problem can be reproduced via:

    mke2fs -q -t ext4 -O ^flex_bg /dev/vdd 5g
    mount -t ext4 /dev/vdd /mnt
    fallocate -l 4600m /mnt/test

The problem was caused by a bone headed mistake in the check to see if a
particular metadata block was part of the block group.

Many thanks to Kees Cook for finding and bisecting the buggy commit
which introduced this bug (commit fd034a84e1, present since v3.2).

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/balloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -90,8 +90,8 @@ unsigned ext4_num_overhead_clusters(stru
 	 * unusual file system layouts.
 	 */
 	if (ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp), block_group)) {
-		block_cluster = EXT4_B2C(sbi, (start -
-					       ext4_block_bitmap(sb, gdp)));
+		block_cluster = EXT4_B2C(sbi,
+					 ext4_block_bitmap(sb, gdp) - start);
 		if (block_cluster < num_clusters)
 			block_cluster = -1;
 		else if (block_cluster == num_clusters) {
@@ -102,7 +102,7 @@ unsigned ext4_num_overhead_clusters(stru
 
 	if (ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp), block_group)) {
 		inode_cluster = EXT4_B2C(sbi,
-					 start - ext4_inode_bitmap(sb, gdp));
+					 ext4_inode_bitmap(sb, gdp) - start);
 		if (inode_cluster < num_clusters)
 			inode_cluster = -1;
 		else if (inode_cluster == num_clusters) {
@@ -114,7 +114,7 @@ unsigned ext4_num_overhead_clusters(stru
 	itbl_blk = ext4_inode_table(sb, gdp);
 	for (i = 0; i < sbi->s_itb_per_group; i++) {
 		if (ext4_block_in_group(sb, itbl_blk + i, block_group)) {
-			c = EXT4_B2C(sbi, start - itbl_blk + i);
+			c = EXT4_B2C(sbi, itbl_blk + i - start);
 			if ((c < num_clusters) || (c == inode_cluster) ||
 			    (c == block_cluster) || (c == itbl_cluster))
 				continue;


