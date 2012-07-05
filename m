Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2GEKGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:06:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42335 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab2GEKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:05:59 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-1d-4ff5670596dc
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Rabin Vincent'" <rabin@rab.in>,
        "'Michal Nazarewicz'" <mina86@mina86.com>
Cc: "'Laura Abbott'" <lauraa@codeaurora.org>, linaro-mm-sig@lists.linaro.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, "'LKML'" <linux-kernel@vger.kernel.org>
References: <4FAC200D.2080306@codeaurora.org>
 <02fc01cd2f50$5d77e4c0$1867ae40$%szyprowski@samsung.com>
 <4FAD89DC.2090307@codeaurora.org>
 <CAH+eYFBhO9P7V7Nf+yi+vFPveBks7SFKRHfkz3JOQMBKqnkkUQ@mail.gmail.com>
In-reply-to: <CAH+eYFBhO9P7V7Nf+yi+vFPveBks7SFKRHfkz3JOQMBKqnkkUQ@mail.gmail.com>
Subject: RE: Bad use of highmem with buffer_migrate_page?
Date: Thu, 05 Jul 2012 12:05:45 +0200
Organization: SPRC
Message-id: <015f01cd5a95$c1525dc0$43f71940$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1akKOXwCV6DpmvQkipOOUiu/qjfwABHtTA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQV3W9K/+Bgd/aFpM3H+W3eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs+GFesECp4mqTZAPjYekuRk4OCQETiVlLN7FC2GIS
	F+6tZ+ti5OIQEpjOKHFh/w12COcno8SqPW2MIFVsAoYSXW+72EBsEQFviW/rjoJ1MAucY5Q4
	tPg9K0THZUaJXa1LmbsYOTg4BYIlpjxmAmkQFrCUWLLtO9g6FgFViSndHxlBSvgFhCQmzlIA
	CfMKuEjsf3CUDcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrdg0yUE1CUe/dWFOMdIYtGXE8wQ
	JSISdxues05gFJ6FZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	Yf5MagfjygaLQ4wCHIxKPLwLUr/6C7EmlhVX5h5ilOBgVhLh5Zj5xV+INyWxsiq1KD++qDQn
	tfgQozQHi5I4r7E3ULVAemJJanZqakFqEUyWiYNTqoGxscQrzD573ub75zNd7gtqfNHWjBQo
	VRA2W/HaTnfdySkSj4senHQqXb7jSK7BBbMacZUZGj1XJeTWWhn/V9KYZCgcuvHGv5e8SS07
	7NMMhXO1qnzrGIoucjI01S/9tIhvEfOJdVGrruxrPcAd5r7k3ct9W6yynnl9035aKSQ+WXdd
	0fTu/FQlluKMREMt5qLiRAACvwOSbwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, July 05, 2012 11:28 AM Rabin Vincent wrote:

> On Sat, May 12, 2012 at 3:21 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> > On 5/11/2012 1:30 AM, Marek Szyprowski wrote:
> >> On Thursday, May 10, 2012 10:08 PM Laura Abbott wrote:
> >>> I did a backport of the Contiguous Memory Allocator to a 3.0.8 tree. I
> >>> wrote fairly simple test case that, in 1MB chunks, allocs up to 40MB
> >>> from a reserved area, maps, writes, unmaps and then frees in an infinite
> >>> loop. When running this with another program in parallel to put some
> >>> stress on the filesystem, I hit data aborts in the filesystem/journal
> >>> layer, although not always the same backtrace. As an example:
> >>>
> >>> [<c02907a4>] (__ext4_check_dir_entry+0x20/0x184) from [<c029e1a8>]
> >>> (add_dirent_to_buf+0x70/0x2ac)
> >>> [<c029e1a8>] (add_dirent_to_buf+0x70/0x2ac) from [<c029f3f0>]
> >>> (ext4_add_entry+0xd8/0x4bc)
> >>> [<c029f3f0>] (ext4_add_entry+0xd8/0x4bc) from [<c029fe90>]
> >>> (ext4_add_nondir+0x14/0x64)
> >>> [<c029fe90>] (ext4_add_nondir+0x14/0x64) from [<c02a04c4>]
> >>> (ext4_create+0xd8/0x120)
> >>> [<c02a04c4>] (ext4_create+0xd8/0x120) from [<c022e134>]
> >>> (vfs_create+0x74/0xa4)
> >>> [<c022e134>] (vfs_create+0x74/0xa4) from [<c022ed3c>]
> >>> (do_last+0x588/0x8d4)
> >>> [<c022ed3c>] (do_last+0x588/0x8d4) from [<c022fe64>]
> >>> (path_openat+0xc4/0x394)
> >>> [<c022fe64>] (path_openat+0xc4/0x394) from [<c0230214>]
> >>> (do_filp_open+0x30/0x7c)
> >>> [<c0230214>] (do_filp_open+0x30/0x7c) from [<c0220cb4>]
> >>> (do_sys_open+0xd8/0x174)
> >>> [<c0220cb4>] (do_sys_open+0xd8/0x174) from [<c0105ea0>]
> >>> (ret_fast_syscall+0x0/0x30)
> >>>
> >>> Every panic had the same issue where a struct buffer_head [1] had a
> >>> b_data that was unexpectedly NULL.
> >>>
> >>> During the course of CMA, buffer_migrate_page could be called to migrate
> >>> from a CMA page to a new page. buffer_migrate_page calls set_bh_page[2]
> >>> to set the new page for the buffer_head. If the new page is a highmem
> >>> page though, the bh->b_data ends up as NULL, which could produce the
> >>> panics seen above.
> >>>
> >>> This seems to indicate that highmem pages are not not appropriate for
> >>> use as pages to migrate to. The following made the problem go away for
> >>> me:
> >>>
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -5753,7 +5753,7 @@ static struct page *
> >>>    __alloc_contig_migrate_alloc(struct page *page, unsigned long private,
> >>>                                int **resultp)
> >>>    {
> >>> -       return alloc_page(GFP_HIGHUSER_MOVABLE);
> >>> +       return alloc_page(GFP_USER | __GFP_MOVABLE);
> >>>    }
> >>>
> >>>
> >>> Does this seem like an actual issue or is this an artifact of my
> >>> backport to 3.0? I'm not familiar enough with the filesystem layer to be
> >>> able to tell where highmem can actually be used.
> >>
> >>
> >> I will need to investigate this further as this issue doesn't appear on
> >> v3.3+ kernels, but I remember I saw something similar when I tried CMA
> >> backported to v3.0.
> 
> The problem is still present on latest mainline.  The filesystem layer
> expects that the pages in the block device's mapping are not in highmem
> (the mapping's gfp mask is set in bdget()), but CMA replaces lowmem
> pages with highmem pages leading to the crashes.
> 
> The above fix should work, but perhaps the following is preferable since
> it should allow moving highmem pages to other highmem pages?

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4403009..4a4f921 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5635,7 +5635,12 @@ static struct page *
>  __alloc_contig_migrate_alloc(struct page *page, unsigned long private,
>  			     int **resultp)
>  {
> -	return alloc_page(GFP_HIGHUSER_MOVABLE);
> +	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
> +
> +	if (PageHighMem(page))
> +		gfp_mask |= __GFP_HIGHMEM;
> +
> +	return alloc_page(gfp_mask);
>  }
> 
>  /* [start, end) must belong to a single zone. */


The patch looks fine and does it job well. Could you resend it as a complete 
patch with commit message and signed-off-by/reported-by lines? I will handle
merging it to mainline then.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



