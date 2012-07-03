Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab2GCVHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 17:07:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab2GCVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 17:07:06 -0400
Date: Tue, 3 Jul 2012 14:07:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
Message-Id: <20120703140705.af23d4d3.akpm@linux-foundation.org>
In-Reply-To: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com>
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012 17:07:54 +0800
Jiang Liu <jiang.liu@huawei.com> wrote:

> From: Xishi Qiu <qiuxishi@huawei.com>
> 
> On architectures with CONFIG_HUGETLB_PAGE_SIZE_VARIABLE set, such as Itanium,
> pageblock_order is a variable with default value of 0. It's set to the right
> value by set_pageblock_order() in function free_area_init_core().
> 
> But pageblock_order may be used by sparse_init() before free_area_init_core()
> is called along path:
> sparse_init()
>     ->sparse_early_usemaps_alloc_node()
> 	->usemap_size()
> 	    ->SECTION_BLOCKFLAGS_BITS
> 		->((1UL << (PFN_SECTION_SHIFT - pageblock_order)) *
> NR_PAGEBLOCK_BITS)
> 
> The uninitialized pageblock_size will cause memory wasting because usemap_size()
> returns a much bigger value then it's really needed.
> 
> For example, on an Itanium platform,
> sparse_init() pageblock_order=0 usemap_size=24576
> free_area_init_core() before pageblock_order=0, usemap_size=24576
> free_area_init_core() after pageblock_order=12, usemap_size=8
> 
> That means 24K memory has been wasted for each section, so fix it by calling
> set_pageblock_order() from sparse_init().
> 
> ...
>
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -485,6 +485,9 @@ void __init sparse_init(void)
>  	struct page **map_map;
>  #endif
>  
> +	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
> +	set_pageblock_order();
> +
>  	/*
>  	 * map is using big page (aka 2M in x86 64 bit)
>  	 * usemap is less one page (aka 24 bytes)

It's a bit ugly calling set_pageblock_order() from both sparse_init()
and from free_area_init_core().  Can we find a single place from which
to call it?  It looks like here:

--- a/init/main.c~a
+++ a/init/main.c
@@ -514,6 +514,7 @@ asmlinkage void __init start_kernel(void
 		   __stop___param - __start___param,
 		   -1, -1, &unknown_bootoption);
 
+	set_pageblock_order();
 	jump_label_init();
 
 	/*

would do the trick?

(free_area_init_core is __paging_init and set_pageblock_order() is
__init.  I'm too lazy to work out if that's wrong)
