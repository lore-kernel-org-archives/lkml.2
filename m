Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2G3RcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:32:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2G3RcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:32:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 17/41] mm: compaction: trivial clean up in acct_isolated()
Date: Mon, 30 Jul 2012 10:31:16 -0700
Message-Id: <20120730172902.654702674@linuxfoundation.org>
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

From: Minchan Kim <minchan.kim@gmail.com>

commit b9e84ac1536d35aee03b2601f19694949f0bd506 upstream.

Stable note: Not tracked in Bugzilla. This patch makes later patches
	easier to apply but has no other impact.

acct_isolated of compaction uses page_lru_base_type which returns only
base type of LRU list so it never returns LRU_ACTIVE_ANON or
LRU_ACTIVE_FILE.  In addtion, cc->nr_[anon|file] is used in only
acct_isolated so it doesn't have fields in conpact_control.

This patch removes fields from compact_control and makes clear function of
acct_issolated which counts the number of anon|file pages isolated.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -35,10 +35,6 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
 
-	/* Account for isolated anon and file pages */
-	unsigned long nr_anon;
-	unsigned long nr_file;
-
 	unsigned int order;		/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
@@ -223,17 +219,13 @@ static void isolate_freepages(struct zon
 static void acct_isolated(struct zone *zone, struct compact_control *cc)
 {
 	struct page *page;
-	unsigned int count[NR_LRU_LISTS] = { 0, };
+	unsigned int count[2] = { 0, };
 
-	list_for_each_entry(page, &cc->migratepages, lru) {
-		int lru = page_lru_base_type(page);
-		count[lru]++;
-	}
+	list_for_each_entry(page, &cc->migratepages, lru)
+		count[!!page_is_file_cache(page)]++;
 
-	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */


