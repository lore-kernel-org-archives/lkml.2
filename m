Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1ANMXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:23:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1ANMXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:23:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ce4pxeGBv0Ns06YUveOErB/Up+/Er/C7soBUqfYo+VZpLx+CIWf2YGwYImiLeuRdD0
         qVk1iQxZkRJDwE9s9g5yT5QUZz7nPI2m78nhsyj6Lk97HIK8Bp+JoMj3i3qVxoV5QhCV
         yhgFp5k4LbWG/Sk5JB4fWdY9/w/uGnn7llzzk=
MIME-Version: 1.0
In-Reply-To: <20110114120931.GP23189@cmpxchg.org>
References: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114190909.d396cdf4.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114120931.GP23189@cmpxchg.org>
Date: Fri, 14 Jan 2011 21:23:05 +0900
Message-ID: <AANLkTimRQ25xbCA4hFxsYfiO2Z7RJZUhJuhYei5Twy1N@mail.gmail.com>
Subject: Re: [PATCH 2/4] [BUGFIX] dont set USED bit on tail pages
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>, aarcange@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

2011/1/14 Johannes Weiner <hannes@cmpxchg.org>:
> On Fri, Jan 14, 2011 at 07:09:09PM +0900, KAMEZAWA Hiroyuki wrote:
>> --- mmotm-0107.orig/mm/memcontrol.c
>> +++ mmotm-0107/mm/memcontrol.c
>
>> @@ -2154,6 +2139,23 @@ static void __mem_cgroup_commit_charge(s
>>        */
>>       memcg_check_events(mem, pc->page);
>>  }
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +/*
>> + * Because tail pages are not mared as "used", set it. We're under
>
> marked
>
will fix.

>> + * compund_lock and don't need to take care of races.
>> + * Statistics are updated properly at charging. We just mark Used bits.
>> + */
>> +void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
>> +{
>> +     struct page_cgroup *hpc = lookup_page_cgroup(head);
>> +     struct page_cgroup *tpc = lookup_page_cgroup(tail);
>
> I have trouble reading the code fluently with those names as they are
> just very similar random letter sequences.  Could you rename them so
> that they're better to discriminate?  headpc and tailpc perhaps?
>
ok. I'll use headpc,tailpc.

>> +     tpc->mem_cgroup = hpc->mem_cgroup;
>> +     smp_wmb(); /* see __commit_charge() */
>> +     SetPageCgroupUsed(tpc);
>> +     VM_BUG_ON(PageCgroupCache(hpc));
>
> Right now, this would be a bug due to other circumstances, but this
> function does not require the page to be anon to function correctly,
> does it?

No.

>  I don't think we should encode a made up dependency here.
>
Ok, I'll remove BUG_ON.


>> @@ -2602,8 +2603,7 @@ __mem_cgroup_uncharge_common(struct page
>>               break;
>>       }
>>
>> -     for (i = 0; i < count; i++)
>> -             mem_cgroup_charge_statistics(mem, file, -1);
>> +     mem_cgroup_charge_statistics(mem, file, -count);
>
> Pass PageCgroupCache(pc) instead, ditch the `file' variable?
>
will do.

>>       ClearPageCgroupUsed(pc);
>>       /*
>> Index: mmotm-0107/include/linux/memcontrol.h
>> ===================================================================
>> --- mmotm-0107.orig/include/linux/memcontrol.h
>> +++ mmotm-0107/include/linux/memcontrol.h
>> @@ -146,6 +146,10 @@ unsigned long mem_cgroup_soft_limit_recl
>>                                               gfp_t gfp_mask);
>>  u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
>>
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
>> +#endif
>> +
>>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>>  struct mem_cgroup;
>>
>> Index: mmotm-0107/mm/huge_memory.c
>> ===================================================================
>> --- mmotm-0107.orig/mm/huge_memory.c
>> +++ mmotm-0107/mm/huge_memory.c
>> @@ -1203,6 +1203,8 @@ static void __split_huge_page_refcount(s
>>               BUG_ON(!PageDirty(page_tail));
>>               BUG_ON(!PageSwapBacked(page_tail));
>>
>> +             mem_cgroup_split_huge_fixup(page, page_tail);
>
> You need to provide a dummy for non-memcg configurations.

Ahhh, yes. I'll add one.

Thanks,
-Kame
