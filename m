Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1I1Wjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab1I1Wje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220130.952109097@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Stefan Priebe <s.priebe@profihost.ag>
Subject: [054/244] mm: page allocator: reconsider zones for allocation after direct reclaim
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 76d3fbf8fbf6cc78ceb63549e0e0c5bc8a88f838 upstream.

With zone_reclaim_mode enabled, it's possible for zones to be considered
full in the zonelist_cache so they are skipped in the future.  If the
process enters direct reclaim, the ZLC may still consider zones to be full
even after reclaiming pages.  Reconsider all zones for allocation if
direct reclaim returns successfully.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1616,6 +1616,21 @@ static void zlc_mark_zone_full(struct zo
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
@@ -1632,6 +1647,10 @@ static int zlc_zone_worth_trying(struct
 static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 {
 }
+
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -1963,6 +1982,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
+	/* After successful reclaim, reconsider all zones for allocation */
+	if (NUMA_BUILD)
+		zlc_clear_zones_full(zonelist);
+
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,


