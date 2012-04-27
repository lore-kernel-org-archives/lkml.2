Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097Ab2D0S0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:26:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39075 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022Ab2D0S0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F9AD455.9030306@parallels.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A34B2.8080103@jp.fujitsu.com>
	<4F9AD455.9030306@parallels.com>
Date: Fri, 27 Apr 2012 11:26:19 -0700
Message-ID: <CALWz4izAxDacXrHMbQh=q_WAcs6QeSuaRuma_dymuTvyk+VDSg@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in move_parent
From: Ying Han <yinghan@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 10:16 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 04/27/2012 02:54 AM, KAMEZAWA Hiroyuki wrote:
>> By using res_counter_uncharge_until(), we can avoid
>> unnecessary charging.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>   mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++++++++------------------
>>   1 files changed, 42 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 613bb15..ed53d64 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>>   }
>>
>>   /*
>> + * Cancel chages in this cgroup....doesn't propagates to parent cgroup.
>> + * This is useful when moving usage to parent cgroup.
>> + */
>> +static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
>> +                                     unsigned int nr_pages)
>> +{
>> +     if (!mem_cgroup_is_root(memcg)) {
>> +             unsigned long bytes = nr_pages * PAGE_SIZE;
>> +
>> +             res_counter_uncharge_until(&memcg->res,
>> +                                     memcg->res.parent, bytes);
>> +             if (do_swap_account)
>> +                     res_counter_uncharge_until(&memcg->memsw,
>> +                                             memcg->memsw.parent, bytes);
>> +     }
>> +}
>
> Kame, this is a nitpick, but I usually prefer to write this like:
>
> if (mem_cgroup_is_root(memcg))
>   return;
>
> res_counter...
>
> Specially with memcg, where function names are bigger than average, in
> comparison.
>
> the code itself seems fine.
>
>> +/*
>>    * A helper function to get mem_cgroup from ID. must be called under
>>    * rcu_read_lock(). The caller must check css_is_removed() or some if
>>    * it's concern. (dropping refcnt from swap can be called against removed
>> @@ -2677,16 +2695,28 @@ static int mem_cgroup_move_parent(struct page *page,
>>       nr_pages = hpage_nr_pages(page);
>>
>>       parent = mem_cgroup_from_cont(pcg);
>> -     ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages,&parent, false);
>> -     if (ret)
>> -             goto put_back;
>> +     if (!parent->use_hierarchy) {
> Can we avoid testing for use hierarchy ?
> Specially given this might go away.
>
> parent_mem_cgroup() already bundles this information. So maybe we can
> test for parent_mem_cgroup(parent) == NULL. It is the same thing after all.
>> +             ret = __mem_cgroup_try_charge(NULL,
>> +                                     gfp_mask, nr_pages,&parent, false);
>> +             if (ret)
>> +                     goto put_back;
>> +     }
>
> Why? If we are not hierarchical, we should not charge the parent, right?

This is how it is implemented today and I think he changed that to
move to root on the next patch.

>
>>       if (nr_pages>  1)
>>               flags = compound_lock_irqsave(page);
>>
>> -     ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent, true);
>> -     if (ret)
>> -             __mem_cgroup_cancel_charge(parent, nr_pages);
>> +     if (parent->use_hierarchy) {
>> +             ret = mem_cgroup_move_account(page, nr_pages,
>> +                                     pc, child, parent, false);
>> +             if (!ret)
>> +                     __mem_cgroup_cancel_local_charge(child, nr_pages);
>> +     } else {
>> +             ret = mem_cgroup_move_account(page, nr_pages,
>> +                                     pc, child, parent, true);
>> +
>> +             if (ret)
>> +                     __mem_cgroup_cancel_charge(parent, nr_pages);
>> +     }
>
> Calling move account also seems not necessary to me. If we are not
> uncharging + charging, we won't even touch the parent.

Today for user_hierarchy = 0, the charge is moved to parent as well as
the stats. But that is changed on the following patches.

--Ying
