Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2FOHTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:19:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59200 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2FOHTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:19:07 -0400
X-AuditID: 9c930179-b7bd3ae000000e80-78-4fdae1e8012c
Message-ID: <4FDAE1F0.4030708@kernel.org>
Date: Fri, 15 Jun 2012 16:19:12 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: kosaki.motohiro@gmail.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds pages
 to the buddy allocator again
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 01:16 AM, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
> to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
> another miuse still exist.
> 
> This patch fixes it.
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Minchan Kim <minchan@kernel.org>

Just nitpick.
Personally, I want to fix it follwing as 
It's more simple and reduce vulnerable error in future.

If you mind, go ahead with your version. I am not against with it, either.

barrios@bbox:~/linux-next$ git diff
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4403009..a32ac56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -637,6 +637,12 @@ static void free_pcppages_bulk(struct zone *zone, int count,
        int batch_free = 0;
        int to_free = count;
 
+       /*
+        * Let's avoid unnecessary reset of pages_scanned.
+        */
+       if (!count)
+               return;
+
        spin_lock(&zone->lock);
        zone->all_unreclaimable = 0;
        zone->pages_scanned = 0;
@@ -1175,6 +1181,7 @@ static void drain_pages(unsigned int cpu)
 {
        unsigned long flags;
        struct zone *zone;
+       int to_drain;
 
        for_each_populated_zone(zone) {
                struct per_cpu_pageset *pset;
@@ -1184,10 +1191,9 @@ static void drain_pages(unsigned int cpu)
                pset = per_cpu_ptr(zone->pageset, cpu);
 
                pcp = &pset->pcp;
-               if (pcp->count) {
-                       free_pcppages_bulk(zone, pcp->count, pcp);
-                       pcp->count = 0;
-               }
+               to_drain = pcp->count;
+               free_pcppages_bulk(zone, to_drain, pcp);
+               pcp->count -= to_drain;
                local_irq_restore(flags);
        }
 }

-- 
Kind regards,
Minchan Kim
