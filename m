Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2FRIZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:25:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60557 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2FRIZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:25:18 -0400
Message-ID: <4FDEE5EB.8040702@gmail.com>
Date: Mon, 18 Jun 2012 04:25:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] trivial, memory hotplug: add kswapd_is_running() for
 better readability
References: <4FD97718.6060008@kernel.org> <1339663776-196-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1206161913370.797@chino.kir.corp.google.com> <4FDE8081.1070500@kernel.org>
In-Reply-To: <4FDE8081.1070500@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/17/12 9:12 PM), Minchan Kim wrote:
> On 06/17/2012 11:19 AM, David Rientjes wrote:
>
>> On Thu, 14 Jun 2012, Jiang Liu wrote:
>>
>>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>>> index c84ec68..36249d5 100644
>>> --- a/include/linux/swap.h
>>> +++ b/include/linux/swap.h
>>> @@ -301,6 +301,11 @@ static inline void scan_unevictable_unregister_node(struct node *node)
>>>
>>>   extern int kswapd_run(int nid);
>>>   extern void kswapd_stop(int nid);
>>> +static inline bool kswapd_is_running(int nid)
>>> +{
>>> +	return !!(NODE_DATA(nid)->kswapd);
>>> +}
>>> +
>>>   #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>>>   extern int mem_cgroup_swappiness(struct mem_cgroup *mem);
>>>   #else
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 0d7e3ec..88e479d 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -522,7 +522,8 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
>>>   	init_per_zone_wmark_min();
>>>
>>>   	if (onlined_pages) {
>>> -		kswapd_run(zone_to_nid(zone));
>>> +		if (!kswapd_is_running(zone_to_nid(zone)))
>>> +			kswapd_run(zone_to_nid(zone));
>>>   		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
>>>   	}
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 7585101..3dafdbe 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -2941,8 +2941,7 @@ int kswapd_run(int nid)
>>>   	pg_data_t *pgdat = NODE_DATA(nid);
>>>   	int ret = 0;
>>>
>>> -	if (pgdat->kswapd)
>>> -		return 0;
>>> +	BUG_ON(pgdat->kswapd);
>>>
>>>   	pgdat->kswapd = kthread_run(kswapd, pgdat, "kswapd%d", nid);
>>>   	if (IS_ERR(pgdat->kswapd)) {
>>
>> This isn't better, there's no functional change and you've just added a
>> second conditional for no reason and an unnecessary kswapd_is_running()
>> function.
>
> Tend to agree.
> Now that I think about it, it's enough to add comment.

Ok, I'd like to handle this issue because now I have some mem-hotplug related tirivial
fixes. So, to add one more patch is not big bother to me.



