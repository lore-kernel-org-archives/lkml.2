Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1BREQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:16:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60535 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1BREQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nY47dt2ehSIoy//Djp3CVA6NAlfSLGHIn7AdKPflAX+3jroSZhdXJEY3iPUFxwkVNJ
         ANPULCNz7Avn6oFCNfPso8JYSNyXf6B1iU5x7UUlgsJVLvJTiZ4O2U8RrCrylogByjfJ
         SKAzes74Qd9UNwUTAw2WS4Uy/R9rD4QVXCs44=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2s0efMsByDKAdVTWaouk0r84RQJVrwn2h6DG_@mail.gmail.com>
References: <cover.1297940291.git.minchan.kim@gmail.com>
	<442221b243154ef2546cb921d53b774f2c8f5df5.1297940291.git.minchan.kim@gmail.com>
	<20110218010416.230a65df.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=2s0efMsByDKAdVTWaouk0r84RQJVrwn2h6DG_@mail.gmail.com>
Date: Fri, 18 Feb 2011 13:16:43 +0900
Message-ID: <AANLkTinqs1+2UJzv0PUQNF95Cs1WVuOZoDa=RXzty49g@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] memcg: move memcg reclaimable page into tail of
 inactive list
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/18 Minchan Kim <minchan.kim@gmail.com>:
> Hi Kame,
>
> On Fri, Feb 18, 2011 at 1:04 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Fri, 18 Feb 2011 00:08:20 +0900
>> Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>>> The rotate_reclaimable_page function moves just written out
>>> pages, which the VM wanted to reclaim, to the end of the
>>> inactive list.  That way the VM will find those pages first
>>> next time it needs to free memory.
>>> This patch apply the rule in memcg.
>>> It can help to prevent unnecessary working page eviction of memcg.
>>>
>>> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> Reviewed-by: Rik van Riel <riel@redhat.com>
>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>>> ---
>>> Changelog since v4:
>>>  - add acked-by and reviewed-by
>>>  - change description - suggested by Rik
>>>
>>>  include/linux/memcontrol.h |    6 ++++++
>>>  mm/memcontrol.c            |   27 +++++++++++++++++++++++++++
>>>  mm/swap.c                  |    3 ++-
>>>  3 files changed, 35 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 3da48ae..5a5ce70 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -62,6 +62,7 @@ extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>>>                                       gfp_t gfp_mask);
>>>  extern void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru);
>>>  extern void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru);
>>> +extern void mem_cgroup_rotate_reclaimable_page(struct page *page);
>>>  extern void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru);
>>>  extern void mem_cgroup_del_lru(struct page *page);
>>>  extern void mem_cgroup_move_lists(struct page *page,
>>> @@ -215,6 +216,11 @@ static inline void mem_cgroup_del_lru_list(struct page *page, int lru)
>>>       return ;
>>>  }
>>>
>>> +static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
>>> +{
>>> +     return ;
>>> +}
>>> +
>>>  static inline void mem_cgroup_rotate_lru_list(struct page *page, int lru)
>>>  {
>>>       return ;
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 686f1ce..ab8bdff 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -813,6 +813,33 @@ void mem_cgroup_del_lru(struct page *page)
>>>       mem_cgroup_del_lru_list(page, page_lru(page));
>>>  }
>>>
>>> +/*
>>> + * Writeback is about to end against a page which has been marked for immediate
>>> + * reclaim.  If it still appears to be reclaimable, move it to the tail of the
>>> + * inactive list.
>>> + */
>>> +void mem_cgroup_rotate_reclaimable_page(struct page *page)
>>> +{
>>> +     struct mem_cgroup_per_zone *mz;
>>> +     struct page_cgroup *pc;
>>> +     enum lru_list lru = page_lru_base_type(page);
>>> +
>>> +     if (mem_cgroup_disabled())
>>> +             return;
>>> +
>>> +     pc = lookup_page_cgroup(page);
>>> +     /*
>>> +      * Used bit is set without atomic ops but after smp_wmb().
>>> +      * For making pc->mem_cgroup visible, insert smp_rmb() here.
>>> +      */
>>> +     smp_rmb();
>>> +     /* unused or root page is not rotated. */
>>> +     if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
>>> +             return;
>>> +     mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
>>> +     list_move_tail(&pc->lru, &mz->lists[lru]);
>>> +}
>>> +
>>
>> Hmm, I'm sorry I misunderstand this. IIUC, page_lru_base_type() always returns
>> LRU_INACTIVE_XXX and this function may move page from active LRU to inactive LRU.
>>
>> Then, LRU counters for memcg should be updated.
>
> Goal of mem_cgroup_rotate_reclaimable_page is same with rotate_reclaimable_page.
> It means the page was already in inactive list.
> Look at the check !PageActive(page).

Hmm, ok. If so, could you change

page_lru_base_type() -> page_lru() ?

It's misleading.

Thanks,
-Kame
