Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338Ab1C3Vnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:43:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964882Ab1C3VHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447669"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: warns@pre-sense.de, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [129/275] fs/partitions: Validate map_count in Mac partition tables
Message-Id: <20110330210609.813FF3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Timo Warns <warns@pre-sense.de>

commit fa7ea87a057958a8b7926c1a60a3ca6d696328ed upstream.

Validate number of blocks in map and remove redundant variable.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/partitions/mac.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/fs/partitions/mac.c
===================================================================
--- linux-2.6.35.y.orig/fs/partitions/mac.c	2011-03-29 22:51:16.260307109 -0700
+++ linux-2.6.35.y/fs/partitions/mac.c	2011-03-29 23:03:00.969275369 -0700
@@ -29,10 +29,9 @@
 
 int mac_partition(struct parsed_partitions *state)
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
+	if (blocks_in_map < 0 || blocks_in_map >= DISK_MAX_PARTS) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	printk(" [mac]");
+	for (slot = 1; slot <= blocks_in_map; ++slot) {
+		int pos = slot * secsize;
 		put_dev_sector(sect);
 		data = read_part_sector(state, pos/512, &sect);
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
