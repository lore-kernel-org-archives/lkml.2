Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1LGPRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:17:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51174 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab1LGPRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:17:03 -0500
Subject: [PATCH 2/2] mm: fix endless looping around false-positive
 too_many_isolated()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Date: Wed, 07 Dec 2011 19:16:47 +0300
Message-ID: <20111207151646.30334.75502.stgit@zurg>
In-Reply-To: <20111207151641.30334.84106.stgit@zurg>
References: <20111207151641.30334.84106.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to vmstat counters percpu drift result of too_many_isolated() check
can be false-positive. Unfortunately it can be stable false-positive:
for example if zone at the one moment hasn't active/inactive pages at all
(for small zones like "DMA" this is very likely) but its atomic part of
isolated-pages counter is non-zero. In this sutuation shrink_inactive_list()
and isolate_migratepages() will loop forever around too_many_isolated().

After this patch too_many_isolated() will sum percpu fractions of
isolated pages counter if atomic part above watermark, but not higher than
watermark plus possible percpu drift.

We can ignore drift for active/inactive pages counters, because sooner or later
isolate pages counter drops to zero.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/compaction.c |   11 +++++++++--
 mm/vmscan.c     |    5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 899d956..2d6fced 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -231,7 +231,7 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
 /* Similar to reclaim, but different enough that they don't share logic */
 static bool too_many_isolated(struct zone *zone)
 {
-	unsigned long active, inactive, isolated;
+	unsigned long active, inactive, isolated, watermark;
 
 	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
 					zone_page_state(zone, NR_INACTIVE_ANON);
@@ -240,7 +240,14 @@ static bool too_many_isolated(struct zone *zone)
 	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
 					zone_page_state(zone, NR_ISOLATED_ANON);
 
-	return isolated > (inactive + active) / 2;
+	watermark = (inactive + active) / 2;
+
+	if (isolated > watermark &&
+	    isolated - watermark <= zone->percpu_drift * 2)
+		isolated = zone_page_state_snapshot(zone, NR_ISOLATED_FILE) +
+			   zone_page_state_snapshot(zone, NR_ISOLATED_ANON);
+
+	return isolated > watermark;
 }
 
 /* possible outcome of isolate_migratepages */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 393ebce..3918c5f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1320,6 +1320,11 @@ static int too_many_isolated(struct zone *zone, int file,
 		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
 	}
 
+	if (isolated > inactive &&
+	    isolated - inactive <= zone->percpu_drift)
+		isolated = zone_page_state_snapshot(zone,
+				file ? NR_ISOLATED_FILE : NR_ISOLATED_ANON);
+
 	return isolated > inactive;
 }
 

