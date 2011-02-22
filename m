Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1BVW3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:29:48 -0500
Received: from kroah.org ([198.145.64.141]:46768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab1BVWV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.820724319@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Subject: [38/70] fs/partitions: Validate map_count in Mac partition tables
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -29,10 +29,9 @@ static inline void mac_fix_string(char *
 
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
@@ -59,10 +58,14 @@ int mac_partition(struct parsed_partitio
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
 	blocks_in_map = be32_to_cpu(part->map_count);
-	for (blk = 1; blk <= blocks_in_map; ++blk) {
-		int pos = blk * secsize;
+	if (blocks_in_map < 0 || blocks_in_map >= DISK_MAX_PARTS) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
+	for (slot = 1; slot <= blocks_in_map; ++slot) {
+		int pos = slot * secsize;
 		put_dev_sector(sect);
 		data = read_part_sector(state, pos/512, &sect);
 		if (!data)
@@ -113,13 +116,11 @@ int mac_partition(struct parsed_partitio
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


