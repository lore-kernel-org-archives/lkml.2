Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1GLIqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:46:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1GLIqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:46:44 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] bootmem: Reimplement __absent_pages_in_range() using for_each_mem_pfn_range()
Date: Tue, 12 Jul 2011 10:46:29 +0200
Message-Id: <1310460395-30913-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310460395-30913-1-git-send-email-tj@kernel.org>
References: <1310460395-30913-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__absent_pages_in_range() was needlessly complex.  Reimplement it
using for_each_mem_pfn_range().

Also, update zone_absent_pages_in_node() such that it doesn't call
__absent_pages_in_range() with @zone_start_pfn which is larger than
@zone_end_pfn.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/page_alloc.c |   54 ++++++++++++------------------------------------------
 1 files changed, 12 insertions(+), 42 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 69fffab..3092a97 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4044,46 +4044,16 @@ unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
-	int i = 0;
-	unsigned long prev_end_pfn = 0, hole_pages = 0;
-	unsigned long start_pfn;
-
-	/* Find the end_pfn of the first active range of pfns in the node */
-	i = first_active_region_index_in_nid(nid);
-	if (i == -1)
-		return 0;
-
-	prev_end_pfn = min(early_node_map[i].start_pfn, range_end_pfn);
-
-	/* Account for ranges before physical memory on this node */
-	if (early_node_map[i].start_pfn > range_start_pfn)
-		hole_pages = prev_end_pfn - range_start_pfn;
-
-	/* Find all holes for the zone within the node */
-	for (; i != -1; i = next_active_region_index_in_nid(i, nid)) {
-
-		/* No need to continue if prev_end_pfn is outside the zone */
-		if (prev_end_pfn >= range_end_pfn)
-			break;
-
-		/* Make sure the end of the zone is not within the hole */
-		start_pfn = min(early_node_map[i].start_pfn, range_end_pfn);
-		prev_end_pfn = max(prev_end_pfn, range_start_pfn);
+	unsigned long nr_absent = range_end_pfn - range_start_pfn;
+	unsigned long start_pfn, end_pfn;
+	int i;
 
-		/* Update the hole size cound and move on */
-		if (start_pfn > range_start_pfn) {
-			BUG_ON(prev_end_pfn > start_pfn);
-			hole_pages += start_pfn - prev_end_pfn;
-		}
-		prev_end_pfn = early_node_map[i].end_pfn;
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
+		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
+		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+		nr_absent -= end_pfn - start_pfn;
 	}
-
-	/* Account for ranges past physical memory on this node */
-	if (range_end_pfn > prev_end_pfn)
-		hole_pages += range_end_pfn -
-				max(range_start_pfn, prev_end_pfn);
-
-	return hole_pages;
+	return nr_absent;
 }
 
 /**
@@ -4104,14 +4074,14 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
 {
+	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
+	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
 	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
-	zone_start_pfn = max(arch_zone_lowest_possible_pfn[zone_type],
-							node_start_pfn);
-	zone_end_pfn = min(arch_zone_highest_possible_pfn[zone_type],
-							node_end_pfn);
+	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
+	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
 	adjust_zone_range_for_zone_movable(nid, zone_type,
 			node_start_pfn, node_end_pfn,
-- 
1.7.6

