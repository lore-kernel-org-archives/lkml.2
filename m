Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0HXWy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:54:26 -0400
Received: from kroah.org ([198.145.64.141]:52271 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab0HXWyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:15 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:25 2010
Message-Id: <20100824222525.886043417@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
        Andreas Dilger <adilger@sun.com>
Subject: [40/59] ext4: consolidate in_range() definitions
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 731eb1a03a8445cde2cb23ecfb3580c6fa7bb690 upstream.

There are duplicate macro definitions of in_range() in mballoc.h and
balloc.c.  This consolidates these two definitions into ext4.h, and
changes extents.c to use in_range() as well.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/balloc.c  |    3 ---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/extents.c |    4 ++--
 fs/ext4/mballoc.h |    2 --
 4 files changed, 4 insertions(+), 7 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -189,9 +189,6 @@ unsigned ext4_init_block_bitmap(struct s
  * when a file system is mounted (see ext4_fill_super).
  */
 
-
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /**
  * ext4_get_group_desc() -- load group descriptor from disk
  * @sb:			super block
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1888,6 +1888,8 @@ static inline void set_bitmap_uptodate(s
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1948,7 +1948,7 @@ ext4_ext_in_cache(struct inode *inode, e
 
 	BUG_ON(cex->ec_type != EXT4_EXT_CACHE_GAP &&
 			cex->ec_type != EXT4_EXT_CACHE_EXTENT);
-	if (block >= cex->ec_block && block < cex->ec_block + cex->ec_len) {
+	if (in_range(block, cex->ec_block, cex->ec_len)) {
 		ex->ee_block = cpu_to_le32(cex->ec_block);
 		ext4_ext_store_pblock(ex, cex->ec_start);
 		ex->ee_len = cpu_to_le16(cex->ec_len);
@@ -3302,7 +3302,7 @@ int ext4_ext_get_blocks(handle_t *handle
 		 */
 		ee_len = ext4_ext_get_actual_len(ex);
 		/* if found extent covers block, simply return it */
-		if (iblock >= ee_block && iblock < ee_block + ee_len) {
+		if (in_range(iblock, ee_block, ee_len)) {
 			newblock = iblock - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (iblock - ee_block);
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -221,8 +221,6 @@ struct ext4_buddy {
 #define EXT4_MB_BITMAP(e4b)	((e4b)->bd_bitmap)
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 					struct ext4_free_extent *fex)
 {


