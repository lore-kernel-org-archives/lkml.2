Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1GKNBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:01:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab1GKNBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:01:19 -0400
From: Mel Gorman <mgorman@suse.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/3] mm: page allocator: Reconsider zones for allocation after direct reclaim
Date: Mon, 11 Jul 2011 14:01:14 +0100
Message-Id: <1310389274-13995-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310389274-13995-1-git-send-email-mgorman@suse.de>
References: <1310389274-13995-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With zone_reclaim_mode enabled, it's possible for zones to be considered
full in the zonelist_cache so they are skipped in the future. If the
process enters direct reclaim, the ZLC may still consider zones to be
full even after reclaiming pages. Reconsider all zones for allocation
if direct reclaim returns successfully.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6913854..149409c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1616,6 +1616,21 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 	set_bit(i, zlc->fullzones);
 }
 
+/*
+ * clear all zones full, called after direct reclaim makes progress so that
+ * a zone that was recently full is not skipped over for up to a second
+ */
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+	struct zonelist_cache *zlc;	/* cached zonelist speedup info */
+
+	zlc = zonelist->zlcache_ptr;
+	if (!zlc)
+		return;
+
+	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
+}
+
 #else	/* CONFIG_NUMA */
 
 static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
@@ -1963,6 +1978,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
+	/* After successful reclaim, reconsider all zones for allocation */
+	if (NUMA_BUILD)
+		zlc_clear_zones_full(zonelist);
+
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-- 
1.7.3.4

