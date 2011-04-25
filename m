Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab1DYUwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:52:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34097 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab1DYUY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:28 -0400
Message-Id: <20110425200235.160662723@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 050/173] fs/partitions: Validate map_count in Mac partition tables
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Timo Warns <warns@pre-sense.de>

commit fa7ea87a057958a8b7926c1a60a3ca6d696328ed upstream.

Validate number of blocks in map and remove redundant variable.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/mac.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: longterm-2.6.27/fs/partitions/mac.c
===================================================================
--- longterm-2.6.27.orig/fs/partitions/mac.c	2011-04-25 18:46:11.560278684 +0200
+++ longterm-2.6.27/fs/partitions/mac.c	2011-04-25 18:49:34.161384483 +0200
@@ -29,10 +29,9 @@
 
 int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-	int slot = 1;
 	Sector sect;
 	unsigned char *data;
-	int blk, blocks_in_map;
+	int slot, blocks_in_map;
 	unsigned secsize;
 #ifdef CONFIG_PPC_PMAC
 	int found_root = 0;
@@ -59,10 +58,14 @@
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	printk(" [mac]");
 	blocks_in_map = be32_to_cpu(part->map_count);
-	for (blk = 1; blk <= blocks_in_map; ++blk) {
-		int pos = blk * secsize;
+	if (blocks_in_map < 0 || blocks_in_map >= MAX_PART) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	printk(" [mac]");
+	for (slot = 1; slot <= blocks_in_map; ++slot) {
+		int pos = slot * secsize;
 		put_dev_sector(sect);
 		data = read_dev_sector(bdev, pos/512, &sect);
 		if (!data)
@@ -113,13 +116,11 @@
 			}
 
 			if (goodness > found_root_goodness) {
-				found_root = blk;
+				found_root = slot;
 				found_root_goodness = goodness;
 			}
 		}
 #endif /* CONFIG_PPC_PMAC */
-
-		++slot;
 	}
 #ifdef CONFIG_PPC_PMAC
 	if (found_root_goodness)


