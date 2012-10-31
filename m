Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935476Ab2JaLso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:48:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab2JaLsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:48:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6108904"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, rjw@sisk.pl,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [Patch v4 3/8] memory-hotplug: fix NR_FREE_PAGES mismatch
Date: Wed, 31 Oct 2012 19:23:09 +0800
Message-Id: <1351682594-17347-4-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
References: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:16:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:16:54,
	Serialize complete at 2012/10/31 19:16:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NR_FREE_PAGES will be wrong after offlining pages.  We add/dec
NR_FREE_PAGES like this now:

1. move all pages in buddy system to MIGRATE_ISOLATE, and dec NR_FREE_PAGES

2. don't add NR_FREE_PAGES when it is freed and the migratetype is
   MIGRATE_ISOLATE

3. dec NR_FREE_PAGES when offlining isolated pages.

4. add NR_FREE_PAGES when undoing isolate pages.

When we come to step 3, all pages are in MIGRATE_ISOLATE list, and
NR_FREE_PAGES are right.  When we come to step4, all pages are not in
buddy system, so we don't change NR_FREE_PAGES in this step, but we change
NR_FREE_PAGES in step3.  So NR_FREE_PAGES is wrong after offlining pages.
So there is no need to change NR_FREE_PAGES in step3.

This patch also fixs a problem in step2: if the migratetype is
MIGRATE_ISOLATE, we should not add NR_FRR_PAGES when we remove pages from
pcppages.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5b74de6..a7cd2d1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -667,11 +667,13 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (is_migrate_cma(mt))
-				__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
+			if (likely(mt != MIGRATE_ISOLATE)) {
+				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
+				if (is_migrate_cma(mt))
+					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
+			}
 		} while (--to_free && --batch_free && !list_empty(list));
 	}
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
@@ -5987,8 +5989,6 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES,
-				      - (1UL << order));
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
-- 
1.8.0

