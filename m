Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2KHXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:25:56 -0500
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43988 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2KHXZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:25:55 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Puneet Kumar <puneetster@chromium.org>
Subject: [PATCH] mm: Fix calculation of dirtyable memory
Date: Thu,  8 Nov 2012 15:25:35 -0800
Message-Id: <1352417135-25122-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system uses global_dirtyable_memory() to calculate
number of dirtyable pages/pages that can be allocated
to the page cache.  A bug causes an underflow thus making
the page count look like a big unsigned number.  This in turn
confuses the dirty writeback throttling to aggressively write
back pages as they become dirty (usually 1 page at a time).

Fix is to ensure there is no underflow while doing the math.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Puneet Kumar <puneetster@chromium.org>
---
 mm/page-writeback.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 830893b..2a6356c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -194,11 +194,19 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 	unsigned long x = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
+		unsigned long nr_pages;
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
+		nr_pages = zone_page_state(z, NR_FREE_PAGES) +
+			zone_reclaimable_pages(z);
+		/*
+		 * Unreclaimable memory (kernel memory or anonymous memory
+		 * without swap) can bring down the dirtyable pages below
+		 * the zone's dirty balance reserve.
+		 */
+		if (nr_pages >= z->dirty_balance_reserve)
+			x += nr_pages - z->dirty_balance_reserve;
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -222,8 +230,9 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
-	    dirty_balance_reserve;
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	if (x >= dirty_balance_reserve)
+		x -= dirty_balance_reserve;
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
-- 
1.7.7.3

