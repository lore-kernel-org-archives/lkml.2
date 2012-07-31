Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2GaEye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:54:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48845 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755695Ab2GaEvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:04 -0400
Message-Id: <20120731044316.133289495@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>
Subject: [ 30/73] ext4: pass a char * to ext4_count_free() instead of a buffer_head
 ptr
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

commit f6fb99cadcd44660c68e13f6eab28333653621e6 upstream.

Make it possible for ext4_count_free to operate on buffers and not
just data in buffer_heads.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/balloc.c |    3 ++-
 fs/ext4/bitmap.c |    8 +++-----
 fs/ext4/ext4.h   |    2 +-
 fs/ext4/ialloc.c |    3 ++-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -557,7 +557,8 @@ ext4_fsblk_t ext4_count_free_clusters(st
 		if (bitmap_bh == NULL)
 			continue;
 
-		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
+		x = ext4_count_free(bitmap_bh->b_data,
+				    EXT4_BLOCKS_PER_GROUP(sb) / 8);
 		printk(KERN_DEBUG "group %u: stored = %d, counted = %u\n",
 			i, ext4_free_group_clusters(sb, gdp), x);
 		bitmap_count += x;
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -15,15 +15,13 @@
 
 static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
-unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
+unsigned int ext4_count_free(char *bitmap, unsigned int numchars)
 {
 	unsigned int i, sum = 0;
 
-	if (!map)
-		return 0;
 	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
+		sum += nibblemap[bitmap[i] & 0xf] +
+			nibblemap[(bitmap[i] >> 4) & 0xf];
 	return sum;
 }
 
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1757,7 +1757,7 @@ struct mmpd_data {
 # define NORET_AND	noreturn,
 
 /* bitmap.c */
-extern unsigned int ext4_count_free(struct buffer_head *, unsigned);
+extern unsigned int ext4_count_free(char *bitmap, unsigned numchars);
 
 /* balloc.c */
 extern unsigned int ext4_block_group(struct super_block *sb,
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1057,7 +1057,8 @@ unsigned long ext4_count_free_inodes(str
 		if (!bitmap_bh)
 			continue;
 
-		x = ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
+		x = ext4_count_free(bitmap_bh->b_data,
+				    EXT4_INODES_PER_GROUP(sb) / 8);
 		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
 			(unsigned long) i, ext4_free_inodes_count(sb, gdp), x);
 		bitmap_count += x;


