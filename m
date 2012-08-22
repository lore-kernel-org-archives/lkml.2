Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab2HVIAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:00:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2HVIAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:00:05 -0400
Message-ID: <5034917E.2060800@gmail.com>
Date: Wed, 22 Aug 2012 15:59:58 +0800
From: qiuxishi <qiuxishi@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: akpm@linux-foundation.org, liuj97@gmail.com, paul.gortmaker@windriver.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bessel.wang@huawei.com, wujianguo@huawei.com, qiuxishi@huawei.com,
        jiang.liu@huawei.com, guohanjun@huawei.com, chenkeping@huawei.com,
        yinghai@kernel.org
Subject: Re: [PATCH] memory-hotplug: add build zonelists when offline pages
References: <5033843E.8000902@gmail.com> <50347906.4030101@cn.fujitsu.com>
In-Reply-To: <50347906.4030101@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-8-22 14:15, Wen Congyang wrote:
> At 08/21/2012 08:51 PM, qiuxishi Wrote:
>> From: Xishi Qiu <qiuxishi@huawei.com>
>>
>> online_pages() does build_all_zonelists() and zone_pcp_update(),
>> I think offline_pages() should do it too. The node has no memory
>> to allocate, so remove this node's zones form other nodes' zonelists.
>>
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> ---
>>  mm/memory_hotplug.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index bc7e7a2..5172bd4 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -979,7 +979,11 @@ repeat:
>>  	if (!node_present_pages(node)) {
>>  		node_clear_state(node, N_HIGH_MEMORY);
>>  		kswapd_stop(node);
>> -	}
>> +		mutex_lock(&zonelists_mutex);
>> +		build_all_zonelists(NODE_DATA(node), NULL);
> 
> The node is still onlined now, so there is no need to pass
> this node's pgdat to build_all_zonelists().
> 
> I think we should build all zonelists when the zone has no
> pages.
> 
>> +		mutex_unlock(&zonelists_mutex);
>> +	} else
>> +		zone_pcp_update(zone);
> 
> There is more than one zone in a node. So the zone can have
> no pages when the node has some pages.
> 

Yes, you are right. Here is the new patch,

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory_hotplug.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc7e7a2..5f6997f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -973,8 +973,13 @@ repeat:

 	init_per_zone_wmark_min();

-	if (!populated_zone(zone))
+	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
+		mutex_lock(&zonelists_mutex);
+		build_all_zonelists(NULL, NULL);
+		mutex_unlock(&zonelists_mutex);
+	} else
+		zone_pcp_update(zone);

 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
-- 
1.7.6.1

> And we have called drain_all_pages(), I think there is no need
> to call zone_pcp_update() here.
> 
> Thanks
> Wen Congyang
> 

In zone_pcp_update(), it calculates zone_batchsize() which does
not calculated in drain_all_pages().

Thanks
Xishi Qiu

>>
>>  	vm_total_pages = nr_free_pagecache_pages();
>>  	writeback_set_ratelimit();
> 
> 

