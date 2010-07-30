Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab0G3S73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:59:29 -0400
Received: from kroah.org ([198.145.64.141]:51820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420Ab0G3RTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171507.955182460@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [092/165] ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 1296cc85c26e94eb865d03f82140f27d598de467 upstream (as of v2.6.33-rc6)

We should update reserve space if it is delalloc buffer
and that is indicated by EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.
So use EXT4_GET_BLOCKS_DELALLOC_RESERVE in place of
EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE

[ Stable note: This fixes a corruption cuased by the following
  reproduction case:

  rm -f $TEST_FN
  touch $TEST_FN
  fallocate -n -o 656712 -l 858907 $TEST_FN
  dd if=/dev/zero of=$TEST_FN conv=notrunc bs=1 seek=1011020 count=36983
  sync
  dd if=/dev/zero of=$TEST_FN conv=notrunc bs=1 seek=332121 count=24005
  dd if=/dev/zero of=$TEST_FN conv=notrunc bs=1 seek=1040179 count=93319

  If the filesystem is then unmounted and e2fsck run forced, the
  i_blocks field for the file $TEST_FN will be found to be incorrect. ]

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h    |    7 ++-----
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    8 ++++----
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -361,14 +361,11 @@ struct ext4_new_group_data {
 	   so set the magic i_delalloc_reserve_flag after taking the 
 	   inode allocation semaphore for */
 #define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0004
-	/* Call ext4_da_update_reserve_space() after successfully 
-	   allocating the blocks */
-#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
 	/* caller is from the direct IO path, request to creation of an
 	unitialized extents if not allocated, split the uninitialized
 	extent if blocks has been preallocated already*/
-#define EXT4_GET_BLOCKS_DIO			0x0010
-#define EXT4_GET_BLOCKS_CONVERT			0x0020
+#define EXT4_GET_BLOCKS_DIO			0x0008
+#define EXT4_GET_BLOCKS_CONVERT			0x0010
 #define EXT4_GET_BLOCKS_DIO_CREATE_EXT		(EXT4_GET_BLOCKS_DIO|\
 					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
 	/* Convert extent to initialized after direct IO complete */
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3148,7 +3148,7 @@ out:
 	 * But fallocate would have already updated quota and block
 	 * count for this offset. So cancel these reservation
 	 */
-	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		ext4_da_update_reserve_space(inode, allocated, 0);
 
 map_out:
@@ -3394,7 +3394,7 @@ int ext4_ext_get_blocks(handle_t *handle
 	 * Update reserved blocks/metadata blocks after successful
 	 * block allocation which had been deferred till now.
 	 */
-	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		ext4_da_update_reserve_space(inode, allocated, 1);
 
 	/*
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1358,7 +1358,7 @@ int ext4_get_blocks(handle_t *handle, st
 		 * reserve space here.
 		 */
 		if ((retval > 0) &&
-			(flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
+			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
 			ext4_da_update_reserve_space(inode, retval, 1);
 	}
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
@@ -2261,10 +2261,10 @@ static int mpage_da_map_blocks(struct mp
 	 * variables are updated after the blocks have been allocated.
 	 */
 	new.b_state = 0;
-	get_blocks_flags = (EXT4_GET_BLOCKS_CREATE |
-			    EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+	get_blocks_flags = EXT4_GET_BLOCKS_CREATE;
 	if (mpd->b_state & (1 << BH_Delay))
-		get_blocks_flags |= EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE;
+		get_blocks_flags |= EXT4_GET_BLOCKS_DELALLOC_RESERVE;
+
 	blks = ext4_get_blocks(handle, mpd->inode, next, max_blocks,
 			       &new, get_blocks_flags);
 	if (blks < 0) {


