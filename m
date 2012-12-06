Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2LFC1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:27:10 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:56051 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2LFC1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:27:08 -0500
Message-ID: <50C00259.50901@huawei.com>
Date: Thu, 6 Dec 2012 10:26:33 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Jiang Liu <liuj97@gmail.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
        <rob@landley.net>, <isimatu.yasuaki@jp.fujitsu.com>,
        <laijs@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <linfeng@cn.fujitsu.com>, <yinghai@kernel.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] page_alloc: Make movablecore_map has higher priority
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-5-git-send-email-tangchen@cn.fujitsu.com> <50BF6BA0.8060505@gmail.com> <50BFF443.3090504@cn.fujitsu.com>
In-Reply-To: <50BFF443.3090504@cn.fujitsu.com>
Content-Type: multipart/mixed;
	boundary="------------000405000507070407010101"
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000405000507070407010101
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 2012-12-6 9:26, Tang Chen wrote:
> On 12/05/2012 11:43 PM, Jiang Liu wrote:
>> If we make "movablecore_map" take precedence over "movablecore/kernelcore",
>> the logic could be simplified. I think it's not so attractive to support
>> both "movablecore_map" and "movablecore/kernelcore" at the same time.
> 
> Hi Liu,
> 
> Thanks for you advice. :)
> 
> Memory hotplug needs different support on different hardware. We are
> trying to figure out a way to satisfy as many users as we can.
> Since it is a little difficult, it may take sometime. :)
> 
> But I still think we need a boot option to support it. Just a metter of
> how to make it easier to use. :)
> 
> Thanks. :)
> 
>>
>> On 11/23/2012 06:44 PM, Tang Chen wrote:
>>> If kernelcore or movablecore is specified at the same time
>>> with movablecore_map, movablecore_map will have higher
>>> priority to be satisfied.
>>> This patch will make find_zone_movable_pfns_for_nodes()
>>> calculate zone_movable_pfn[] with the limit from
>>> zone_movable_limit[].
>>>
>>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>>> Reviewed-by: Wen Congyang<wency@cn.fujitsu.com>
>>> Reviewed-by: Lai Jiangshan<laijs@cn.fujitsu.com>
>>> Tested-by: Lin Feng<linfeng@cn.fujitsu.com>
>>> ---
>>>   mm/page_alloc.c |   35 +++++++++++++++++++++++++++++++----
>>>   1 files changed, 31 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index f23d76a..05bafbb 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -4800,12 +4800,25 @@ static void __init find_zone_movable_pfns_for_nodes(void)
>>>           required_kernelcore = max(required_kernelcore, corepages);
>>>       }
>>>
>>> -    /* If kernelcore was not specified, there is no ZONE_MOVABLE */
>>> -    if (!required_kernelcore)
>>> +    /*
>>> +     * No matter kernelcore/movablecore was limited or not, movable_zone
>>> +     * should always be set to a usable zone index.
>>> +     */
>>> +    find_usable_zone_for_movable();
>>> +
>>> +    /*
>>> +     * If neither kernelcore/movablecore nor movablecore_map is specified,
>>> +     * there is no ZONE_MOVABLE. But if movablecore_map is specified, the
>>> +     * start pfn of ZONE_MOVABLE has been stored in zone_movable_limit[].
>>> +     */
>>> +    if (!required_kernelcore) {
>>> +        if (movablecore_map.nr_map)
>>> +            memcpy(zone_movable_pfn, zone_movable_limit,
>>> +                sizeof(zone_movable_pfn));
>>>           goto out;
>>> +    }
>>>
>>>       /* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
>>> -    find_usable_zone_for_movable();
>>>       usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
>>>
>>>   restart:
>>> @@ -4833,10 +4846,24 @@ restart:
>>>           for_each_mem_pfn_range(i, nid,&start_pfn,&end_pfn, NULL) {
>>>               unsigned long size_pages;
>>>
>>> +            /*
>>> +             * Find more memory for kernelcore in
>>> +             * [zone_movable_pfn[nid], zone_movable_limit[nid]).
>>> +             */
>>>               start_pfn = max(start_pfn, zone_movable_pfn[nid]);
>>>               if (start_pfn>= end_pfn)
>>>                   continue;
>>>
>>> +            if (zone_movable_limit[nid]) {
>>> +                end_pfn = min(end_pfn, zone_movable_limit[nid]);
>>> +                /* No range left for kernelcore in this node */
>>> +                if (start_pfn>= end_pfn) {
>>> +                    zone_movable_pfn[nid] =
>>> +                            zone_movable_limit[nid];
>>> +                    break;
>>> +                }
>>> +            }
Hi Tang,
	I just to remove the above logic, so the implementation will be greatly
simplified. Please refer to the attachment.
Regards!
Gerry

>>> +
>>>               /* Account for what is only usable for kernelcore */
>>>               if (start_pfn<  usable_startpfn) {
>>>                   unsigned long kernel_pages;
>>> @@ -4896,12 +4923,12 @@ restart:
>>>       if (usable_nodes&&  required_kernelcore>  usable_nodes)
>>>           goto restart;
>>>
>>> +out:
>>>       /* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
>>>       for (nid = 0; nid<  MAX_NUMNODES; nid++)
>>>           zone_movable_pfn[nid] =
>>>               roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
>>>
>>> -out:
>>>       /* restore the node_state */
>>>       node_states[N_HIGH_MEMORY] = saved_node_state;
>>>   }
>>>
>>
>>
> 
> 
> .
> 


--------------000405000507070407010101
Content-Type: text/x-patch;
	name="0003-page_alloc-Introduce-zone_movable_limit-to-keep-mova.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0003-page_alloc-Introduce-zone_movable_limit-to-keep-mova.pa";
	filename*1="tch"

>From 120759daa8410e1bf61d19210ddeb52ef32d002a Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@huawei.com>
Date: Wed, 5 Dec 2012 23:58:42 +0800
Subject: [PATCH 3/6] page_alloc: Introduce zone_movable_limit[] to keep
 movable limit for nodes

This patch introduces a new array zone_movable_limit[] to store the
ZONE_MOVABLE limit from movablecore_map boot option for all nodes.
The function sanitize_zone_movable_limit() will find out to which
node the ranges in movable_map.map[] belongs, and calculates the
low boundary of ZONE_MOVABLE for each node.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>

page_alloc: Make movablecore_map has higher priority

If kernelcore or movablecore is specified at the same time
with movablecore_map, movablecore_map will have higher
priority to be satisfied.
This patch will make find_zone_movable_pfns_for_nodes()
calculate zone_movable_pfn[] with the limit from
zone_movable_limit[].

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/page_alloc.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e35ee27..41c3b51 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4338,6 +4338,60 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * Try to figure out zone_movable_pfn[] from movablecore_map.
+ */
+static int __init find_zone_movable_from_movablecore_map(void)
+{
+	int map_pos = 0, i, nid;
+	unsigned long start_pfn, end_pfn;
+
+	if (!movablecore_map.nr_map)
+		return 0;
+
+	/* Iterate all ranges from minimum to maximum */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		/*
+		 * If we have found lowest pfn of ZONE_MOVABLE of the node
+		 * specified by user, just go on to check next range.
+		 */
+		if (zone_movable_pfn[nid])
+			continue;
+
+#ifdef CONFIG_HIGHMEM
+		/* Skip lowmem if ZONE_MOVABLE is highmem */
+		if (zone_movable_is_highmem() &&
+		    start_pfn < arch_zone_lowest_possible_pfn[ZONE_HIGHMEM])
+			start_pfn = arch_zone_lowest_possible_pfn[ZONE_HIGHMEM];
+		if (start_pfn > end_pfn)
+			continue;
+#endif
+
+		while (map_pos < movablecore_map.nr_map) {
+			if (end_pfn < movablecore_map.map[map_pos].start)
+				break;
+
+			if (start_pfn > movablecore_map.map[map_pos].end) {
+				map_pos++;
+				continue;
+			}
+
+			/*
+			 * The start_pfn of ZONE_MOVABLE is either the minimum
+			 * pfn specified by movablecore_map, or 0, which means
+			 * the node has no ZONE_MOVABLE.
+			 */
+			start_pfn = max(start_pfn,
+					movablecore_map.map[map_pos].start);
+			zone_movable_pfn[nid] = roundup(zone_movable_pfn[nid],
+							MAX_ORDER_NR_PAGES);
+			break;
+		}
+	}
+
+	return 1;
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4356,6 +4410,11 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return zholes_size[zone_type];
 }
 
+static int __init find_zone_movable_from_movablecore_map(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4739,6 +4798,12 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
 
+	find_usable_zone_for_movable();
+
+	/* movablecore_map takes precedence over movablecore/kernelcore */
+	if (find_zone_movable_from_movablecore_map())
+		return;
+
 	/*
 	 * If movablecore was specified, calculate what size of
 	 * kernelcore that corresponds so that memory usable for
@@ -4766,7 +4831,6 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
-- 
1.7.9.5


--------------000405000507070407010101--
