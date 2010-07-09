Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0GIXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab0GIXJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:09:27 -0400
Message-ID: <4C37AB74.7030401@ds.jp.nec.com>
Date: Fri, 09 Jul 2010 19:06:28 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 02/11] blkiocg async: The main part of iotrack
References: <4C369009.80503@ds.jp.nec.com>	<4C369452.2070103@ds.jp.nec.com> <20100709163552.3eef1d62.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100709163552.3eef1d62.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote, on 07/09/2010 03:35 AM:
> On Thu, 08 Jul 2010 23:15:30 -0400
> Munehiro Ikeda<m-ikeda@ds.jp.nec.com>  wrote:
>
>> iotrack is a functionality to record who dirtied the
>> page.  This is needed for block IO controller cgroup
>> to support async (cached) write.
>>
>> This patch is based on a patch posted from Ryo Tsuruta
>> on Oct 2, 2009 titled as "The body of blkio-cgroup".
>> The patch added a new member on struct page_cgroup to
>> record cgroup ID, but this was given a negative opinion
>> from Kame, a maintainer of memory controller cgroup,
>> because this bloats the size of struct page_cgroup.
>>
>> Instead, this patch takes an approach proposed by
>> Andrea Righi, which records cgroup ID in flags
>> of struct page_cgroup with bit encoding.
>>
>> ToDo:
>> Cgroup ID of deleted cgroup will be recycled.  Further
>> consideration is needed.
>>
>> Signed-off-by: Hirokazu Takahashi<taka@valinux.co.jp>
>> Signed-off-by: Ryo Tsuruta<ryov@valinux.co.jp>
>> Signed-off-by: Andrea Righi<arighi@develer.com>
>> Signed-off-by: Munehiro "Muuhh" Ikeda<m-ikeda@ds.jp.nec.com>
>> ---
>>   block/Kconfig.iosched       |    8 +++
>>   block/Makefile              |    1 +
>>   block/blk-iotrack.c         |  129 +++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/blk-iotrack.h |   62 +++++++++++++++++++++
>>   include/linux/page_cgroup.h |   25 ++++++++
>>   init/Kconfig                |    2 +-
>>   mm/page_cgroup.c            |   91 +++++++++++++++++++++++++++---
>>   7 files changed, 309 insertions(+), 9 deletions(-)
>>   create mode 100644 block/blk-iotrack.c
>>   create mode 100644 include/linux/blk-iotrack.h

(snip, snip)

>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
>> index 6a21b0d..473b79a 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -17,6 +17,31 @@ struct page_cgroup {
>>   	struct list_head lru;		/* per cgroup LRU list */
>>   };
>>
>> +/*
>> + * use lower 16 bits for flags and reserve the rest for the page tracking id
>> + */
>> +#define PAGE_TRACKING_ID_SHIFT	(16)
>> +#define PAGE_TRACKING_ID_BITS \
>> +		(8 * sizeof(unsigned long) - PAGE_TRACKING_ID_SHIFT)
>> +
>> +/* NOTE: must be called with page_cgroup() lock held */
>> +static inline unsigned long page_cgroup_get_id(struct page_cgroup *pc)
>> +{
>> +	return pc->flags>>  PAGE_TRACKING_ID_SHIFT;
>> +}
>> +
>> +/* NOTE: must be called with page_cgroup() lock held */
>> +static inline void page_cgroup_set_id(struct page_cgroup *pc, unsigned long id)
>> +{
>> +	WARN_ON(id>= (1UL<<  PAGE_TRACKING_ID_BITS));
>> +	pc->flags&= (1UL<<  PAGE_TRACKING_ID_SHIFT) - 1;
>> +	pc->flags |= (unsigned long)(id<<  PAGE_TRACKING_ID_SHIFT);
>> +}
>
> I think that this is the 1st wall.
> Because ->flags is a "bit field" there are some places set/clear bit without
> locks. (please see mem_cgroup_del/add_lru())
>
> Then, I can't say this field operation is safe even if it's always done
> under locks. hmm. Can this be done by cmpxchg ?

OK, we can do it like:

do {
	old =  pc->flags;
	new = old & ((1UL << PAGE_TRACKING_ID_SHIFT) - 1);
	new |= (unsigned long)(id << PAGE_TRACKING_ID_SHIFT);
} while (cmpxchg(&pc->flags, old, new)  != old);


> IIUC, there is an generic version now even if it's heavy.

I couldn't find it out...is there already?  Or you mean we should
have generic one?


>> +unsigned long page_cgroup_get_owner(struct page *page);
>> +int page_cgroup_set_owner(struct page *page, unsigned long id);
>> +int page_cgroup_copy_owner(struct page *npage, struct page *opage);
>> +
>>   void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
>>
>>   #ifdef CONFIG_SPARSEMEM
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 2e40f2f..337ee01 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -650,7 +650,7 @@ endif # CGROUPS
>>
>>   config CGROUP_PAGE
>>   	def_bool y
>> -	depends on CGROUP_MEM_RES_CTLR
>> +	depends on CGROUP_MEM_RES_CTLR || GROUP_IOSCHED_ASYNC
>>
>>   config MM_OWNER
>>   	bool
>> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
>> index 6c00814..69e080c 100644
>> --- a/mm/page_cgroup.c
>> +++ b/mm/page_cgroup.c
>> @@ -9,6 +9,7 @@
>>   #include<linux/vmalloc.h>
>>   #include<linux/cgroup.h>
>>   #include<linux/swapops.h>
>> +#include<linux/blk-iotrack.h>
>>
>>   static void __meminit
>>   __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
>> @@ -74,7 +75,7 @@ void __init page_cgroup_init_flatmem(void)
>>
>>   	int nid, fail;
>>
>> -	if (mem_cgroup_disabled())
>> +	if (mem_cgroup_disabled()&&  blk_iotrack_disabled())
>>   		return;
>>
>>   	for_each_online_node(nid)  {
>> @@ -83,12 +84,13 @@ void __init page_cgroup_init_flatmem(void)
>>   			goto fail;
>>   	}
>>   	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>> -	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
>> -	" don't want memory cgroups\n");
>> +	printk(KERN_INFO "please try 'cgroup_disable=memory,blkio' option"
>> +	" if you don't want memory and blkio cgroups\n");
>>   	return;
>>   fail:
>>   	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
>> -	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
>> +	printk(KERN_CRIT
>> +		"please try 'cgroup_disable=memory,blkio' boot option\n");
>>   	panic("Out of memory");
>>   }
>
> Hmm, io-track is always done if blkio-cgroup is used, Right ?

No, iotrack is enabled only when CONFIG_GROUP_IOSCHED_ASYNC=y.
If =n, iotrack is disabled even if blkio-cgroup is enabled.


> Then, why you have extra config as CONFIG_GROUP_IOSCHED_ASYNC ?
> Is it necessary ?

Current purpose of the option is only for debug because it is
experimental functionality.
It can be removed if this work is completed, or dynamic switch
might be useful.

In fact, just "cgroup_disable=memory" is enough for the failure
case.  Let me think right messages.


>> @@ -251,7 +253,7 @@ void __init page_cgroup_init(void)
>>   	unsigned long pfn;
>>   	int fail = 0;
>>
>> -	if (mem_cgroup_disabled())
>> +	if (mem_cgroup_disabled()&&  blk_iotrack_disabled())
>>   		return;
>>
>>   	for (pfn = 0; !fail&&  pfn<  max_pfn; pfn += PAGES_PER_SECTION) {
>> @@ -260,14 +262,15 @@ void __init page_cgroup_init(void)
>>   		fail = init_section_page_cgroup(pfn);
>>   	}
>>   	if (fail) {
>> -		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
>> +		printk(KERN_CRIT
>> +			"try 'cgroup_disable=memory,blkio' boot option\n");
>>   		panic("Out of memory");
>>   	} else {
>>   		hotplug_memory_notifier(page_cgroup_callback, 0);
>>   	}
>>   	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>> -	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
>> -	" want memory cgroups\n");
>> +	printk(KERN_INFO "please try 'cgroup_disable=memory,blkio' option"
>> +	" if you don't want memory and blkio cgroups\n");
>>   }
>>
>>   void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
>> @@ -277,6 +280,78 @@ void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
>>
>>   #endif
>>
>> +/**
>> + * page_cgroup_get_owner() - get the owner ID of a page
>> + * @page:	the page we want to find the owner
>> + *
>> + * Returns the owner ID of the page, 0 means that the owner cannot be
>> + * retrieved.
>> + **/
>> +unsigned long page_cgroup_get_owner(struct page *page)
>> +{
>> +	struct page_cgroup *pc;
>> +	unsigned long ret;
>> +
>> +	pc = lookup_page_cgroup(page);
>> +	if (unlikely(!pc))
>> +		return 0;
>> +
>> +	lock_page_cgroup(pc);
>> +	ret = page_cgroup_get_id(pc);
>> +	unlock_page_cgroup(pc);
>> +	return ret;
>> +}
>
> Is this lock required ? Even if wrong ID is got by race, it just means
> this I/O is charged to other cgroup.
> I don't think it's an issue. Considering the user can move tasks while generating
> I/O without any interaction with I/O cgroup, the issue itself is invisible and
> cannot be handled. I love light wegiht here.

I agree.


>> +
>> +/**
>> + * page_cgroup_set_owner() - set the owner ID of a page
>> + * @page:	the page we want to tag
>> + * @id:		the ID number that will be associated to page
>> + *
>> + * Returns 0 if the owner is correctly associated to the page. Returns a
>> + * negative value in case of failure.
>> + **/
>> +int page_cgroup_set_owner(struct page *page, unsigned long id)
>> +{
>> +	struct page_cgroup *pc;
>> +
>> +	pc = lookup_page_cgroup(page);
>> +	if (unlikely(!pc))
>> +		return -ENOENT;
>> +
>> +	lock_page_cgroup(pc);
>> +	page_cgroup_set_id(pc, id);
>> +	unlock_page_cgroup(pc);
>> +	return 0;
>> +}
>> +
>
> Doesn't this function check overwrite ?

No it doesn't.  This function is called only when the info is
needed to be overwritten if I'm correct.
If you have another concern, please correct me.


>> +/**
>> + * page_cgroup_copy_owner() - copy the owner ID of a page into another page
>> + * @npage:	the page where we want to copy the owner
>> + * @opage:	the page from which we want to copy the ID
>> + *
>> + * Returns 0 if the owner is correctly associated to npage. Returns a negative
>> + * value in case of failure.
>> + **/
>> +int page_cgroup_copy_owner(struct page *npage, struct page *opage)
>> +{
>> +	struct page_cgroup *npc, *opc;
>> +	unsigned long id;
>> +
>> +	npc = lookup_page_cgroup(npage);
>> +	if (unlikely(!npc))
>> +		return -ENOENT;
>> +	opc = lookup_page_cgroup(opage);
>> +	if (unlikely(!opc))
>> +		return -ENOENT;
>> +	lock_page_cgroup(opc);
>> +	lock_page_cgroup(npc);
>> +	id = page_cgroup_get_id(opc);
>> +	page_cgroup_set_id(npc, id);
>> +	unlock_page_cgroup(npc);
>> +	unlock_page_cgroup(opc);
>> +
>> +	return 0;
>> +}
>
> you can remove lock here, too. (use cmpxchg for writer.)

OK.


>
> Thanks,
> -Kame


Thank you so much!
Muuhh


-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

