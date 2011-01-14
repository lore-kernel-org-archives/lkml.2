Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1ANMHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:07:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60630 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1ANMHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KSKFMzO26yvlIaCLDK6M9CK1DvCZXw2I69VuQL/felMKh9i8bZzppbOLLbBdXtxgkt
         RERYcwUnY25Wf8LDWbJZ4zYgzBmbnpfMSZqOMnLj3+w58HeHgL61kJ4zerG70yWRxyiq
         pfotcFmnk+bYiuGuQNHIsT+7P3unjSObYF4Mw=
MIME-Version: 1.0
In-Reply-To: <20110114115121.GO23189@cmpxchg.org>
References: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114190644.a222f60d.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114115121.GO23189@cmpxchg.org>
Date: Fri, 14 Jan 2011 21:07:08 +0900
Message-ID: <AANLkTinKFDn5oQE=xqjXC4XXO_sA3Xb_NOEXz_pU7FKn@mail.gmail.com>
Subject: Re: [PATCH 1/4] [BUGFIX] enhance charge_statistics function for
 fixising issues
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

2011/1/14 Johannes Weiner <hannes@cmpxchg.org>:
> On Fri, Jan 14, 2011 at 07:06:44PM +0900, KAMEZAWA Hiroyuki wrote:
>> mem_cgroup_charge_staistics() was designed for charging a page but
>> now, we have transparent hugepage. To fix problems (in following patch)
>> it's required to change the function to get the number of pages
>> as its arguments.
>>
>> The new function gets following as argument.
>>   - type of page rather than 'pc'
>>   - size of page which is accounted.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> I agree with the patch in general, below are only a few nitpicks.
>
Thanks, I think details should be updated, too.


>> --- mmotm-0107.orig/mm/memcontrol.c
>> +++ mmotm-0107/mm/memcontrol.c
>> @@ -600,23 +600,23 @@ static void mem_cgroup_swap_statistics(s
>>  }
>>
>>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>> -                                      struct page_cgroup *pc,
>> -                                      bool charge)
>> +                                      bool file,
>> +                                      int pages)
>
> I think 'nr_pages' would be a better name.  This makes me think of a
> 'struct page *[]'.
>
ok.

>>  {
>> -     int val = (charge) ? 1 : -1;
>> -
>>       preempt_disable();
>>
>> -     if (PageCgroupCache(pc))
>> -             __this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], val);
>> +     if (file)
>> +             __this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], pages);
>>       else
>> -             __this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], val);
>> +             __this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], pages);
>>
>> -     if (charge)
>> +     /* pagein of a big page is an event. So, ignore page size */
>> +     if (pages > 0)
>>               __this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
>>       else
>>               __this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
>> -     __this_cpu_inc(mem->stat->count[MEM_CGROUP_EVENTS]);
>> +
>> +     __this_cpu_add(mem->stat->count[MEM_CGROUP_EVENTS], pages);
>>
>>       preempt_enable();
>>  }
>> @@ -2092,6 +2092,7 @@ static void ____mem_cgroup_commit_charge
>>                                        struct page_cgroup *pc,
>>                                        enum charge_type ctype)
>>  {
>> +     bool file = false;
>>       pc->mem_cgroup = mem;
>>       /*
>>        * We access a page_cgroup asynchronously without lock_page_cgroup().
>> @@ -2106,6 +2107,7 @@ static void ____mem_cgroup_commit_charge
>>       case MEM_CGROUP_CHARGE_TYPE_SHMEM:
>>               SetPageCgroupCache(pc);
>>               SetPageCgroupUsed(pc);
>> +             file = true;
>>               break;
>>       case MEM_CGROUP_CHARGE_TYPE_MAPPED:
>>               ClearPageCgroupCache(pc);
>> @@ -2115,7 +2117,7 @@ static void ____mem_cgroup_commit_charge
>>               break;
>>       }
>>
>> -     mem_cgroup_charge_statistics(mem, pc, true);
>> +     mem_cgroup_charge_statistics(mem, file, 1);
>
> The extra local variable is a bit awkward, since there are already
> several sources of this information (ctype and pc->flags).
>
> Could you keep it like the other sites, just pass PageCgroupCache()
> here as well?
>
Ok.

>> @@ -2186,14 +2188,14 @@ static void __mem_cgroup_move_account(st
>>               __this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
>>               preempt_enable();
>>       }
>> -     mem_cgroup_charge_statistics(from, pc, false);
>> +     mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -1);
>>       if (uncharge)
>>               /* This is not "cancel", but cancel_charge does all we need. */
>>               mem_cgroup_cancel_charge(from, PAGE_SIZE);
>>
>>       /* caller should have done css_get */
>>       pc->mem_cgroup = to;
>> -     mem_cgroup_charge_statistics(to, pc, true);
>> +     mem_cgroup_charge_statistics(to, PageCgroupCache(pc), 1);
>>       /*
>>        * We charges against "to" which may not have any tasks. Then, "to"
>>        * can be under rmdir(). But in current implementation, caller of
>> @@ -2551,6 +2553,7 @@ __mem_cgroup_uncharge_common(struct page
>>       struct page_cgroup *pc;
>>       struct mem_cgroup *mem = NULL;
>>       int page_size = PAGE_SIZE;
>> +     bool file = false;
>>
>>       if (mem_cgroup_disabled())
>>               return NULL;
>> @@ -2578,6 +2581,9 @@ __mem_cgroup_uncharge_common(struct page
>>       if (!PageCgroupUsed(pc))
>>               goto unlock_out;
>>
>> +     if (PageCgroupCache(pc))
>> +             file = true;
>> +
>>       switch (ctype) {
>>       case MEM_CGROUP_CHARGE_TYPE_MAPPED:
>>       case MEM_CGROUP_CHARGE_TYPE_DROP:
>> @@ -2597,7 +2603,7 @@ __mem_cgroup_uncharge_common(struct page
>>       }
>>
>>       for (i = 0; i < count; i++)
>> -             mem_cgroup_charge_statistics(mem, pc + i, false);
>> +             mem_cgroup_charge_statistics(mem, file, -1);
>
> I see you get rid of this loop in the next patch, anyway.  Can you
> just use PageCgroupCache() instead of the extra variable?

will do.
Thanks,
-Kame
