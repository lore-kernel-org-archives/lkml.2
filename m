Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2GSOiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:38:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab2GSOhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:37:05 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: "Linux-MM <linux-mm"@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 30/34] mm: vmscan: Do not force kswapd to scan small targets
Date: Thu, 19 Jul 2012 15:36:40 +0100
Message-Id: <1342708604-26540-31-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342708604-26540-1-git-send-email-mgorman@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ad2b8e601099a23dffffb53f91c18d874fe98854 upstream - WARNING: partial backport only

Stable note: Not tracked in Bugzilla. This patch is very controversial for
	-stable. The upstream patch is addressing a completely different
	issue but accidentally contained an important fix. The workload
	in question was running memcached and then started IO in the
	background. memcached should stay resident but without this patch
	it gets swapped. Sometimes this manifests as a drop in throughput
	but mostly it was observed through /proc/vmstat.

Commit [246e87a9: memcg: fix get_scan_count() for small targets] was
meant to fix a problem whereby small scan targets on memcg were ignored
causing priority to raise too sharply. It forced scanning to take place
if the target was small, memcg or kswapd.

>From the time it was introduced it cause excessive reclaim by kswapd
with workloads being pushed to swap that previously would have stayed
resident. This was accidentally fixed by commit [ad2b8e60: mm: memcg:
remove optimization of keeping the root_mem_cgroup LRU lists empty] but
that patchset is not suitable for backporting.

The original patch came with no information on what workloads it benefits
but the cost of it is obvious in that it forces scanning to take place
on lists that would otherwise have been ignored such as small anonymous
inactive lists. This patch partially reverts 246e87a9 so that small lists
are not force scanned which means that IO-intensive workloads with small
amounts of anonymous memory will not be swapped.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e5382ad..49d8547 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1849,9 +1849,6 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
 	bool force_scan = false;
 	unsigned long nr_force_scan[2];
 
-	/* kswapd does zone balancing and needs to scan this zone */
-	if (scanning_global_lru(sc) && current_is_kswapd())
-		force_scan = true;
 	/* memcg may have small limit and need to avoid priority drop */
 	if (!scanning_global_lru(sc))
 		force_scan = true;
-- 
1.7.9.2

