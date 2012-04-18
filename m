Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2DRHZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:25:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35786 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2DRHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:25:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F8E6BDC.6050703@jp.fujitsu.com>
Date: Wed, 18 Apr 2012 16:23:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ying Han <yinghan@google.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC][PATCH 2/6] memcg: add pc_set_mem_cgroup_and_flags()
References: <4F72EB84.7080000@jp.fujitsu.com> <4F72ED25.60307@jp.fujitsu.com> <CALWz4izNDGdGYmkJzHCRFspCk9QwoZtvRWpKmn=0YZRaVrcVAA@mail.gmail.com>
In-Reply-To: <CALWz4izNDGdGYmkJzHCRFspCk9QwoZtvRWpKmn=0YZRaVrcVAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/18 6:17), Ying Han wrote:

> On Wed, Mar 28, 2012 at 3:51 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Consolidate a code for setting pc->mem_cgroup and USED bit which requires smp_wmb().
>> And remove a macro PCGF_NOCOPY_AT_SPLIT which isn't helpful to read code, now.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  include/linux/page_cgroup.h |   18 ++++++++++++++++++
>>  mm/memcontrol.c             |   18 ++++--------------
>>  2 files changed, 22 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
>> index 92768cb..2707809 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -1,6 +1,8 @@
>>  #ifndef __LINUX_PAGE_CGROUP_H
>>  #define __LINUX_PAGE_CGROUP_H
>>
>> +#include <linux/smp.h>
>> +
>>  enum {
>>        /* flags for mem_cgroup */
>>        PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
>> @@ -94,6 +96,22 @@ pc_set_mem_cgroup(struct page_cgroup *pc, struct mem_cgroup *memcg)
>>        pc->mem_cgroup = memcg;
>>  }
>>
>> +static inline void
>> +pc_set_mem_cgroup_and_flags(struct page_cgroup *pc, struct mem_cgroup *memcg,
>> +                       unsigned long flags)
>> +{
>> +       pc->mem_cgroup = memcg;
>> +       /*
>> +        * We access a page_cgroup asynchronously without lock_page_cgroup().
>> +        * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
>> +        * is accessed after testing USED bit. To make pc's mem_cgroup visible
>> +        * before USED bit, we need memory barrier here.
>> +        * See mem_cgroup_add_lru_list(), etc.
>> +        */
>> +       smp_wmb();
>> +       pc->flags = flags;
>> +}
>> +
>>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>>  struct page_cgroup;
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8077460..d366b60 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2511,16 +2511,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>>                }
>>        }
>>
>> -       pc_set_mem_cgroup(pc, memcg);
>> -       /*
>> -        * We access a page_cgroup asynchronously without lock_page_cgroup().
>> -        * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
>> -        * is accessed after testing USED bit. To make pc's mem_cgroup visible
>> -        * before USED bit, we need memory barrier here.
>> -        * See mem_cgroup_add_lru_list(), etc.
>> -        */
>> -       smp_wmb();
>> -       SetPageCgroupUsed(pc);
> 
> I might be confused. We removed this SetPageCgroupUsed() but not
> adding it back elsewhere ?
> 
> --Ying
> 
>> +       pc_set_mem_cgroup_and_flags(pc, memcg, BIT(PCG_USED) | BIT(PCG_LOCK));


Added here. This sets  

  | memcg pointer | Used | Locked |


Thanks,
-Kame




