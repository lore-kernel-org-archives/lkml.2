Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2BPG5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 01:57:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33167 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab2BPG5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 01:57:18 -0500
Message-ID: <4F3CA8CA.8020004@openvz.org>
Date: Thu, 16 Feb 2012 10:57:14 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: rework inactive_ratio logic
References: <20120215162442.13588.21790.stgit@zurg> <20120216103842.0c3e9258.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120216103842.0c3e9258.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Feb 2012 20:24:42 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> This patch adds mem_cgroup->inactive_ratio calculated from hierarchical memory limit.
>> It updated at each limit change before shrinking cgroup to this new limit.
>> Ratios for all child cgroups are updated too, because parent limit can affect them.
>> Update precedure can be greatly optimized if its performance becomes the problem.
>> Inactive ratio for unlimited or huge limit does not matter, because we'll never hit it.
>>
>> At global reclaim always use global ratio from zone->inactive_ratio.
>> At mem-cgroup reclaim use inactive_ratio from target memory cgroup,
>> this is cgroup which hit its limit and cause this reclaimer invocation.
>>
>> Thus, global memory reclaimer will try to keep ratio for all lru lists in zone
>> above one mark, this guarantee that total ratio in this zone will be above too.
>> Meanwhile mem-cgroup will do the same thing for its lru lists in all zones, and
>> for all lru lists in all sub-cgroups in hierarchy.
>>
>> Also this patch removes some redundant code.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> Hmm, the main purpose of this patch is to remove calculation per get_scan_ratio() ?

Technically, it was preparation for "mm: unify inactive_list_is_low()" from "memory book keeping" patchset.
So, actually its main purpose is moving all active/inactive size calculation to mm/vmscan.c

Also I trying to figure out most sane logic for inactive_ratio calculation,
currently global memory reclaimer sometimes uses memcg-calculated ratio, it looks strange.

>> ---
>>   include/linux/memcontrol.h |   16 ++------
>>   mm/memcontrol.c            |   85 ++++++++++++++++++++++++--------------------
>>   mm/vmscan.c                |   82 +++++++++++++++++++++++-------------------
>>   3 files changed, 93 insertions(+), 90 deletions(-)
>>   static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>                                unsigned long long val)
>>   {

<cut>

>> @@ -3422,6 +3416,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>                        else
>>                                memcg->memsw_is_minimum = false;
>>                }
>> +             mem_cgroup_update_inactive_ratio(memcg, val);
>>                mutex_unlock(&set_limit_mutex);
>>
>>                if (!ret)
>> @@ -3439,6 +3434,12 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>        if (!ret&&  enlarge)
>>                memcg_oom_recover(memcg);
>>
>> +     if (ret) {
>> +             mutex_lock(&set_limit_mutex);
>> +             mem_cgroup_update_inactive_ratio(memcg, RESOURCE_MAX);
>> +             mutex_unlock(&set_limit_mutex);
>> +     }
>
> Why RESOUECE_MAX ?

resize was failed, so we return back normal value calculated from the current limit.
target == RESOURCE_MAX isn't clip limit: min(RESOURCE_MAX, limit) == limit

>
> Thanks,
> -Kame
>
