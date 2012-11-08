Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2KHMp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:45:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47820 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2KHMp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:45:27 -0500
Message-ID: <509BA96A.2070701@gmail.com>
Date: Thu, 08 Nov 2012 20:45:30 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        rientjes@google.com, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277696-21724-1-git-send-email-handai.szj@taobao.com> <20121107221709.GB26382@dhcp22.suse.cz>
In-Reply-To: <20121107221709.GB26382@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 06:17 AM, Michal Hocko wrote:
> On Wed 07-11-12 16:41:36, Sha Zhengju wrote:
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> Current, when a memcg oom is happening the oom dump messages is still global
>> state and provides few useful info for users. This patch prints more pointed
>> memcg page statistics for memcg-oom.
>>
>> Signed-off-by: Sha Zhengju<handai.szj@taobao.com>
>> Cc: Michal Hocko<mhocko@suse.cz>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: David Rientjes<rientjes@google.com>
>> Cc: Andrew Morton<akpm@linux-foundation.org>
>> ---
>>   mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>   mm/oom_kill.c   |    6 +++-
>>   2 files changed, 66 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 0eab7d5..2df5e72 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> [...]
>> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>>   }
>>
>> +#define K(x) ((x)<<  (PAGE_SHIFT-10))
>> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
>> +{
>> +	struct mem_cgroup *mi;
>> +	unsigned int i;
>> +
>> +	if (!memcg->use_hierarchy&&  memcg != root_mem_cgroup) {
>> +		for (i = 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
>> +			if (i == MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
>> +				continue;
>> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
>> +				K(mem_cgroup_read_stat(memcg, i)));
>> +		}
>> +
>> +		for (i = 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++)
>> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
>> +				mem_cgroup_read_events(memcg, i));
>> +
>> +		for (i = 0; i<  NR_LRU_LISTS; i++)
>> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
>> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
>> +	} else {
>> +
>> +		for (i = 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
>> +			long long val = 0;
>> +
>> +			if (i == MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
>> +				continue;
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val += mem_cgroup_read_stat(mi, i);
>> +			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
>> +		}
>> +
>> +		for (i = 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++) {
>> +			unsigned long long val = 0;
>> +
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val += mem_cgroup_read_events(mi, i);
>> +			printk(KERN_CONT "%s:%llu ",
>> +				mem_cgroup_events_names[i], val);
>> +		}
>> +
>> +		for (i = 0; i<  NR_LRU_LISTS; i++) {
>> +			unsigned long long val = 0;
>> +
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val += mem_cgroup_nr_lru_pages(mi, BIT(i));
>> +			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
>> +		}
>> +	}
> This is just plain ugly. for_each_mem_cgroup_tree is use_hierarchy aware
> and there is no need for if (use_hierarchy) part.
> memcg != root_mem_cgroup test doesn't make much sense as well because we
> call that a global oom killer ;)

Yes... bitterly did I repent the patch... The else-part of 
for_each_mem_cgroup_tree
is enough for hierarchy. I'll send a update one later.
Sorry for the noise. : (


Thanks,
Sha


