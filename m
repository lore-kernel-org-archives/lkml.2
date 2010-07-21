Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0GUNeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:34:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46601 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab0GUNeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:34:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/7] memcg: nid and zid can be calculated from zone
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100716105648.GG13117@csn.ul.ie>
References: <20100716191418.7372.A69D9226@jp.fujitsu.com> <20100716105648.GG13117@csn.ul.ie>
Message-Id: <20100721223349.870D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 21 Jul 2010 22:33:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static inline int zone_nid(struct zone *zone)
> > +{
> > +	return zone->zone_pgdat->node_id;
> > +}
> > +
> 
> hmm, adding a helper and not converting the existing users of
> zone->zone_pgdat may be a little confusing particularly as both types of
> usage would exist in the same file e.g. in mem_cgroup_zone_nr_pages.

I see. here is incrementa patch.

Thanks

>From 62cf765251af257c98fc92a58215d101d200e7ef Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 20 Jul 2010 11:30:14 +0900
Subject: [PATCH] memcg: convert to zone_nid() from bare zone->zone_pgdat->node_id

Now, we have zone_nid(). this patch convert all existing users of
zone->zone_pgdat.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 82e191f..3d5b645 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -951,7 +951,7 @@ unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru)
 {
-	int nid = zone->zone_pgdat->node_id;
+	int nid = zone_nid(zone);
 	int zid = zone_idx(zone);
 	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
 
@@ -961,7 +961,7 @@ unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone)
 {
-	int nid = zone->zone_pgdat->node_id;
+	int nid = zone_nid(zone);
 	int zid = zone_idx(zone);
 	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
 
@@ -1006,7 +1006,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 	LIST_HEAD(pc_list);
 	struct list_head *src;
 	struct page_cgroup *pc, *tmp;
-	int nid = z->zone_pgdat->node_id;
+	int nid = zone_nid(z);
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
 	int lru = LRU_FILE * file + active;
-- 
1.6.5.2



