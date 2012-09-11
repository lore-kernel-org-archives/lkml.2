Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab2IKKqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:46:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab2IKKqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:46:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,404,1344182400"; 
   d="scan'208";a="5822588"
Message-ID: <504F07ED.3070502@cn.fujitsu.com>
Date: Tue, 11 Sep 2012 17:44:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "'FNST-Wen Congyang'" <wency@cn.fujitsu.com>
Subject: [V4 PATCH 27/27] memory,hotplug: Don't modify the zone_start_pfn
 outside of zone_span_writelock()
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com> <504E8874.5020605@jp.fujitsu.com>
In-Reply-To: <504E8874.5020605@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/11 17:41:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/11 17:41:48,
	Serialize complete at 2012/09/11 17:41:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 08:40 AM, Yasuaki Ishimatsu wrote:
> Hi Lai,
> 
> Using memory_online to hot-added node's memory, the following kernel messages
> were shown. Is this a known issue?

Fixed.

Subject: Don't modify the zone_start_pfn outside of zone_span_writelock()

Original __add_zone() and new online_movable/online_kernel
maybe call sleep-able init_currently_empty_zone() to init wait_table,

but this function also modifies the zone_start_pfn without lock. 
so we move this code out, and ensure the modification of zone_start_pfn is done
with zone_span_writelock() held or booting.

Since zone_start_pfn is not modified by init_currently_empty_zone()
grow_zone_span() needs to be updated to be aware of empty zone.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reported-by: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Wen Congyang <wency@cn.fujitsu.com>
---
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3ad25f9..c26a4ea 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -201,7 +201,7 @@ static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 	zone_span_writelock(zone);
 
 	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	if (start_pfn < zone->zone_start_pfn)
+	if (!zone->zone_start_pfn || start_pfn < zone->zone_start_pfn)
 		zone->zone_start_pfn = start_pfn;
 
 	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 009ac28..637b4f8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3991,8 +3991,6 @@ int __meminit init_currently_empty_zone(struct zone *zone,
 		return ret;
 	pgdat->nr_zones = zone_idx(zone) + 1;
 
-	zone->zone_start_pfn = zone_start_pfn;
-
 	mminit_dprintk(MMINIT_TRACE, "memmap_init",
 			"Initialising map node %d zone %lu pfns %lu -> %lu\n",
 			pgdat->node_id,
@@ -4459,6 +4457,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);
+		zone->zone_start_pfn = zone_start_pfn;
 		memmap_init(size, nid, j, zone_start_pfn);
 		zone_start_pfn += size;
 	}
