Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab0JMFFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:05:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40096 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0JMFFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:05:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20101013140546.ADB7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Oct 2010 14:05:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> No big change since the previous version but divided into 3 patches.
> This patch is based onto mmotm-1008 and just works, IOW, mot tested in
> very-bad-situation.
> 
> What this wants to do: 
>   allocates a contiguous chunk of pages larger than MAX_ORDER.
>   for device drivers (camera? etc..)
>   My intention is not for allocating HUGEPAGE(> MAX_ORDER).
>   
> What this does:
>   allocates a contiguous chunk of page with page migration,
>   based on memory hotplug codes. (memory unplug is for isolating
>   a chunk of page from buddy allocator.)
> 
> Consideration:
>   Maybe more codes can be shared with other functions
>   (memory hotplug, compaction..)
> 
> Status:
>   Maybe still needs more updates, works on small test.
>   [1/3] ... move some codes from memory hotplug. (no functional changes)
>   [2/3] ... a code for searching contiguous pages.
>   [3/3] ... a code for allocating contig memory.
> 
> Thanks,
> -Kame
> ==
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Memory hotplug is a logic for making pages unused in the specified range
> of pfn. So, some of core logics can be used for other purpose as
> allocating a very large contigous memory block.
> 
> This patch moves some functions from mm/memory_hotplug.c to
> mm/page_isolation.c. This helps adding a function for large-alloc in
> page_isolation.c with memory-unplug technique.
> 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/page-isolation.h |    7 ++
>  mm/memory_hotplug.c            |  109 ---------------------------------------
>  mm/page_isolation.c            |  114 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 121 insertions(+), 109 deletions(-)
> 
> Index: mmotm-1008/include/linux/page-isolation.h
> ===================================================================
> --- mmotm-1008.orig/include/linux/page-isolation.h
> +++ mmotm-1008/include/linux/page-isolation.h
> @@ -33,5 +33,12 @@ test_pages_isolated(unsigned long start_
>  extern int set_migratetype_isolate(struct page *page);
>  extern void unset_migratetype_isolate(struct page *page);
>  
> +/*
> + * For migration.
> + */
> +
> +int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn);
> +int scan_lru_pages(unsigned long start, unsigned long end);

offtopic: scan_lru_pages() return type should be unsined long. it return
pfn.




