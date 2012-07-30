Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2G3Rcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:32:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38800 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2G3Rcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:32:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>, Mel Gorman <mgorman@suse.de>
Subject: [ 10/41] mm: vmscan: fix force-scanning small targets without swap
Date: Mon, 30 Jul 2012 10:31:09 -0700
Message-Id: <20120730172902.122939996@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <jweiner@redhat.com>

commit a4d3e9e76337059406fcf3ead288c0df22a790e9 upstream.

Stable note: Not tracked in Bugzilla. This patch augments an earlier commit
        that avoids scanning priority being artificially raised. The older
	fix was particularly important for small memcgs to avoid calling
	wait_iff_congested() unnecessarily.

Without swap, anonymous pages are not scanned.  As such, they should not
count when considering force-scanning a small target if there is no swap.

Otherwise, targets are not force-scanned even when their effective scan
number is zero and the other conditions--kswapd/memcg--apply.

This fixes 246e87a93934 ("memcg: fix get_scan_count() for small
targets").

[akpm@linux-foundation.org: fix comment]
Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1747,23 +1747,15 @@ static void get_scan_count(struct zone *
 	u64 fraction[2], denominator;
 	enum lru_list l;
 	int noswap = 0;
-	int force_scan = 0;
+	bool force_scan = false;
 	unsigned long nr_force_scan[2];
 
-
-	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
-
-	if (((anon + file) >> priority) < SWAP_CLUSTER_MAX) {
-		/* kswapd does zone balancing and need to scan this zone */
-		if (scanning_global_lru(sc) && current_is_kswapd())
-			force_scan = 1;
-		/* memcg may have small limit and need to avoid priority drop */
-		if (!scanning_global_lru(sc))
-			force_scan = 1;
-	}
+	/* kswapd does zone balancing and needs to scan this zone */
+	if (scanning_global_lru(sc) && current_is_kswapd())
+		force_scan = true;
+	/* memcg may have small limit and need to avoid priority drop */
+	if (!scanning_global_lru(sc))
+		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1776,6 +1768,11 @@ static void get_scan_count(struct zone *
 		goto out;
 	}
 
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,


