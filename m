Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1KIMXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:23:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1KIMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:23:42 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.48+drm33.21
Date: Wed,  9 Nov 2011 13:23:39 +0100
Message-Id: <1320841419-8341-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.48+drm33.21 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm: radeon: fix sign bug
* drm/radeon/kms: prefer high post dividers in legacy pll algo
* drm: mm: fix range restricted allocations
* Linux 2.6.32.48+drm33.21

 Makefile                                |    2 +-
 drivers/gpu/drm/drm_mm.c                |   29 +++++++++++++++--------------
 drivers/gpu/drm/radeon/radeon_display.c |   10 ++++++----
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/Makefile b/Makefile
index 23da129..9b22b90 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .48+drm33.20
+EXTRAVERSION = .48+drm33.21
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index f1d3314..5a23a9b 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -330,21 +330,21 @@ void drm_mm_put_block(struct drm_mm_node *cur)

 EXPORT_SYMBOL(drm_mm_put_block);

-static int check_free_mm_node(struct drm_mm_node *entry, unsigned long size,
-			      unsigned alignment)
+static int check_free_hole(unsigned long start, unsigned long end,
+			   unsigned long size, unsigned alignment)
 {
 	unsigned wasted = 0;

-	if (entry->size < size)
+	if (end - start < size)
 		return 0;

 	if (alignment) {
-		register unsigned tmp = entry->start % alignment;
+		unsigned tmp = start % alignment;
 		if (tmp)
 			wasted = alignment - tmp;
 	}

-	if (entry->size >= size + wasted) {
+	if (end >= start + size + wasted) {
 		return 1;
 	}

@@ -369,7 +369,8 @@ struct drm_mm_node *drm_mm_search_free(const struct drm_mm *mm,
 	list_for_each(list, free_stack) {
 		entry = list_entry(list, struct drm_mm_node, fl_entry);

-		if (!check_free_mm_node(entry, size, alignment))
+		if (!check_free_hole(entry->start, entry->start + entry->size,
+				     size, alignment))
 			continue;

 		if (!best_match)
@@ -392,7 +393,6 @@ struct drm_mm_node *drm_mm_search_free_in_range(const struct drm_mm *mm,
 						unsigned long end,
 						int best_match)
 {
-	struct list_head *list;
 	const struct list_head *free_stack = &mm->fl_entry;
 	struct drm_mm_node *entry;
 	struct drm_mm_node *best;
@@ -403,13 +403,13 @@ struct drm_mm_node *drm_mm_search_free_in_range(const struct drm_mm *mm,
 	best = NULL;
 	best_size = ~0UL;

-	list_for_each(list, free_stack) {
-		entry = list_entry(list, struct drm_mm_node, fl_entry);
-
-		if (entry->start > end || (entry->start+entry->size) < start)
-			continue;
+	list_for_each_entry(entry, free_stack, fl_entry) {
+		unsigned long adj_start = entry->start < start ?
+			start : entry->start;
+		unsigned long adj_end = entry->start + entry->size > end ?
+			end : entry->start + entry->size;

-		if (!check_free_mm_node(entry, size, alignment))
+		if (!check_free_hole(adj_start, adj_end, size, alignment))
 			continue;

 		if (!best_match)
@@ -502,7 +502,8 @@ int drm_mm_scan_add_block(struct drm_mm_node *node)
 	node->fl_entry.prev = prev_free;
 	node->fl_entry.next = next_free;

-	if (check_free_mm_node(node, mm->scan_size, mm->scan_alignment)) {
+	if (check_free_hole(node->start, node->start + node->size,
+			    mm->scan_size, mm->scan_alignment)) {
 		mm->scan_hit_start = node->start;
 		mm->scan_hit_size = node->size;

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 567bd8e..60a51dc 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -464,7 +464,7 @@ void radeon_compute_pll(struct radeon_pll *pll,
 		max_fractional_feed_div = pll->max_frac_feedback_div;
 	}

-	for (post_div = min_post_div; post_div <= max_post_div; ++post_div) {
+	for (post_div = max_post_div; post_div >= min_post_div; --post_div) {
 		uint32_t ref_div;

 		if ((pll->flags & RADEON_PLL_NO_ODD_POST_DIV) && (post_div & 1))
@@ -519,15 +519,17 @@ void radeon_compute_pll(struct radeon_pll *pll,
 					current_freq = radeon_div(tmp, ref_div * post_div);

 					if (pll->flags & RADEON_PLL_PREFER_CLOSEST_LOWER) {
-						error = freq - current_freq;
-						error = error < 0 ? 0xffffffff : error;
+						if (freq < current_freq)
+							error = 0xffffffff;
+						else
+							error = freq - current_freq;
 					} else
 						error = abs(current_freq - freq);
 					vco_diff = abs(vco - best_vco);

 					if ((best_vco == 0 && error < best_error) ||
 					    (best_vco != 0 &&
-					     (error < best_error - 100 ||
+					     ((best_error > 100 && error < best_error - 100) ||
 					      (abs(error - best_error) < 100 && vco_diff < best_vco_diff)))) {
 						best_post_div = post_div;
 						best_ref_div = ref_div;
