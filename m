Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0GLAQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 20:16:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0GLAQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 20:16:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Jul 2010 09:11:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 02/11] blkiocg async: The main part of iotrack
Message-Id: <20100712091155.c379cfe4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C37AB74.7030401@ds.jp.nec.com>
References: <4C369009.80503@ds.jp.nec.com>
	<4C369452.2070103@ds.jp.nec.com>
	<20100709163552.3eef1d62.kamezawa.hiroyu@jp.fujitsu.com>
	<4C37AB74.7030401@ds.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jul 2010 19:06:28 -0400
Munehiro Ikeda <m-ikeda@ds.jp.nec.com> wrote:

> OK, we can do it like:
> 
> do {
> 	old =  pc->flags;
> 	new = old & ((1UL << PAGE_TRACKING_ID_SHIFT) - 1);
> 	new |= (unsigned long)(id << PAGE_TRACKING_ID_SHIFT);
> } while (cmpxchg(&pc->flags, old, new)  != old);
> 
> 
> > IIUC, there is an generic version now even if it's heavy.
> 
> I couldn't find it out...is there already?  Or you mean we should
> have generic one?
> 

generic cmpxchg in /include/asm-generic/cmpxchg.h
But...ahh...in some arch, you can't use cmpxchg, sorry.

How about start from "a new field" for I/O cgroup in page_cgroup ?

struct page_cgroup {
        unsigned long flags;
        struct mem_cgroup *mem_cgroup;
	unsigned short blkio_cgroup_id;
        struct page *page;
        struct list_head lru;           /* per cgroup LRU list */
};

We can consider how we optimize it out, later.
(And, it's easier to debug and make development smooth.)

For example, If we can create a vmalloced-array of mem_cgroup,
id->mem_cgroup lookup can be very fast and we can replace
pc->mem_cgroup link with pc->mem_cgroup_id.


> 
> >> +unsigned long page_cgroup_get_owner(struct page *page);
> >> +int page_cgroup_set_owner(struct page *page, unsigned long id);
> >> +int page_cgroup_copy_owner(struct page *npage, struct page *opage);
> >> +
> >>   void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
> >>
> >>   #ifdef CONFIG_SPARSEMEM
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index 2e40f2f..337ee01 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -650,7 +650,7 @@ endif # CGROUPS
> >>
> >>   config CGROUP_PAGE
> >>   	def_bool y
> >> -	depends on CGROUP_MEM_RES_CTLR
> >> +	depends on CGROUP_MEM_RES_CTLR || GROUP_IOSCHED_ASYNC
> >>
> >>   config MM_OWNER
> >>   	bool
> >> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> >> index 6c00814..69e080c 100644
> >> --- a/mm/page_cgroup.c
> >> +++ b/mm/page_cgroup.c
> >> @@ -9,6 +9,7 @@
> >>   #include<linux/vmalloc.h>
> >>   #include<linux/cgroup.h>
> >>   #include<linux/swapops.h>
> >> +#include<linux/blk-iotrack.h>
> >>
> >>   static void __meminit
> >>   __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
> >> @@ -74,7 +75,7 @@ void __init page_cgroup_init_flatmem(void)
> >>
> >>   	int nid, fail;
> >>
> >> -	if (mem_cgroup_disabled())
> >> +	if (mem_cgroup_disabled()&&  blk_iotrack_disabled())
> >>   		return;
> >>
> >>   	for_each_online_node(nid)  {
> >> @@ -83,12 +84,13 @@ void __init page_cgroup_init_flatmem(void)
> >>   			goto fail;
> >>   	}
> >>   	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
> >> -	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
> >> -	" don't want memory cgroups\n");
> >> +	printk(KERN_INFO "please try 'cgroup_disable=memory,blkio' option"
> >> +	" if you don't want memory and blkio cgroups\n");
> >>   	return;
> >>   fail:
> >>   	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
> >> -	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
> >> +	printk(KERN_CRIT
> >> +		"please try 'cgroup_disable=memory,blkio' boot option\n");
> >>   	panic("Out of memory");
> >>   }
> >
> > Hmm, io-track is always done if blkio-cgroup is used, Right ?
> 
> No, iotrack is enabled only when CONFIG_GROUP_IOSCHED_ASYNC=y.
> If =n, iotrack is disabled even if blkio-cgroup is enabled.
> 


> 
> > Then, why you have extra config as CONFIG_GROUP_IOSCHED_ASYNC ?
> > Is it necessary ?
> 
> Current purpose of the option is only for debug because it is
> experimental functionality.
> It can be removed if this work is completed, or dynamic switch
> might be useful.
> 
> In fact, just "cgroup_disable=memory" is enough for the failure
> case.  Let me think right messages.
> 

IMHO, once you add boot-option or sysctl, it's very hard to remove it, lator.
So, if you think you'll remove it lator, don't add it or just add CONFIG.

Regards,
-Kame

