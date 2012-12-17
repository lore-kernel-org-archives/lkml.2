Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab2LQCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:25:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4587 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2LQCZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:25:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,297,1355068800"; 
   d="scan'208,223";a="6411524"
Message-ID: <50CE823F.7020700@cn.fujitsu.com>
Date: Mon, 17 Dec 2012 10:23:59 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rob Landley <rob@landley.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PART4 Patch v2 2/2] memory_hotplug: allow online/offline memory
 to result movable node
References: <1353067090-19468-1-git-send-email-wency@cn.fujitsu.com> <1353067090-19468-3-git-send-email-wency@cn.fujitsu.com> <20121120142928.0aaf8fc8.akpm@linux-foundation.org>
In-Reply-To: <20121120142928.0aaf8fc8.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/17 10:24:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/17 10:24:04,
	Serialize complete at 2012/12/17 10:24:04
Content-Type: multipart/mixed;
 boundary="------------080707040208070808070206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080707040208070808070206
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Hi Andrew,

So sorry for such a long delay. I missed this one.
Please check the attached patch if you still need it.
All comments are followed.

Thanks. :)

On 11/21/2012 06:29 AM, Andrew Morton wrote:
> On Fri, 16 Nov 2012 19:58:10 +0800
> Wen Congyang<wency@cn.fujitsu.com>  wrote:
>
>> From: Lai Jiangshan<laijs@cn.fujitsu.com>
>>
>> Now, memory management can handle movable node or nodes which don't have
>> any normal memory, so we can dynamic configure and add movable node by:
>> 	online a ZONE_MOVABLE memory from a previous offline node
>> 	offline the last normal memory which result a non-normal-memory-node
>>
>> movable-node is very important for power-saving,
>> hardware partitioning and high-available-system(hardware fault management).
>>
>> ...
>>
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -589,11 +589,19 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
>>   	return 0;
>>   }
>>
>> +#ifdef CONFIG_MOVABLE_NODE
>> +/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
>
> The comment is hard to understand.  Should it read "When
> CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
> normal memory"?
>
>> +static bool can_online_high_movable(struct zone *zone)
>> +{
>> +	return true;
>> +}
>> +#else /* #ifdef CONFIG_MOVABLE_NODE */
>>   /* ensure every online node has NORMAL memory */
>>   static bool can_online_high_movable(struct zone *zone)
>>   {
>>   	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
>>   }
>> +#endif /* #ifdef CONFIG_MOVABLE_NODE */
>>
>>   /* check which state of node_states will be changed when online memory */
>>   static void node_states_check_changes_online(unsigned long nr_pages,
>> @@ -1097,6 +1105,13 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
>>   	return offlined;
>>   }
>>
>> +#ifdef CONFIG_MOVABLE_NODE
>> +/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
>
> Ditto, after replacing "online" with offlining".
>
>> +static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
>> +{
>> +	return true;
>> +}
>> +#else /* #ifdef CONFIG_MOVABLE_NODE */
>>   /* ensure the node has NORMAL memory if it is still online */
>>   static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
>>   {
>> @@ -1120,6 +1135,7 @@ static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
>>   	 */
>>   	return present_pages == 0;
>>   }
>> +#endif /* #ifdef CONFIG_MOVABLE_NODE */
>
> Please, spend more time over the accuracy and completeness of the
> changelog and comments?  That will result in better and more
> maintainable code.  And it results in *much* more effective code
> reviewing.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


--------------080707040208070808070206
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0002-memory_hotplug-allow-online-offline-memory-to-result.patch"
Content-Disposition: attachment;
 filename*0="0002-memory_hotplug-allow-online-offline-memory-to-result.pa";
 filename*1="tch"

>From f03a9e6ce870b381482bcb1901361d784a9aee4a Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 12 Dec 2012 22:49:15 +0900
Subject: [PART4 Patch v2 2/2] memory_hotplug: allow online/offline memory to result movable node

Now, memory management can handle movable node or nodes which don't have
any normal memory, so we can dynamic configure and add movable node by:

	online a ZONE_MOVABLE memory from a previous offline node
	offline the last normal memory which result a non-normal-memory-node

movable-node is very important for power-saving, hardware partitioning and
high-available-system(hardware fault management).

Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/memory_hotplug.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5c19c83..db0e6fb 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -581,11 +581,22 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 	return 0;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/*
+ * When CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
+ * normal memory.
+ */
+static bool can_online_high_movable(struct zone *zone)
+{
+	return true;
+}
+#else /* #ifdef CONFIG_MOVABLE_NODE */
 /* ensure every online node has NORMAL memory */
 static bool can_online_high_movable(struct zone *zone)
 {
 	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
@@ -1089,6 +1100,16 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 	return offlined;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/*
+ * When CONFIG_MOVABLE_NODE, we permit offlining of a node which doesn't have
+ * normal memory.
+ */
+static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
+{
+	return true;
+}
+#else /* #ifdef CONFIG_MOVABLE_NODE */
 /* ensure the node has NORMAL memory if it is still online */
 static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 {
@@ -1112,6 +1133,7 @@ static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 	 */
 	return present_pages == 0;
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
-- 
1.7.1


--------------080707040208070808070206--
