Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2AZBXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:23:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2AZBXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:23:21 -0500
Date: Wed, 25 Jan 2012 17:23:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Adrian Drzewieki <z@drze.net>
Subject: Re: [PATCH v4 -mm] make swapin readahead skip over holes
Message-Id: <20120125172319.edbbde73.akpm@linux-foundation.org>
In-Reply-To: <20120124141400.6d33b7c4@annuminas.surriel.com>
References: <20120124131351.05309a2a@annuminas.surriel.com>
	<20120124141400.6d33b7c4@annuminas.surriel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 14:14:00 -0500
Rik van Riel <riel@redhat.com> wrote:

> Ever since abandoning the virtual scan of processes, for scalability
> reasons, swap space has been a little more fragmented than before.
> This can lead to the situation where a large memory user is killed,
> swap space ends up full of "holes" and swapin readahead is totally
> ineffective.
> 
> On my home system, after killing a leaky firefox it took over an
> hour to page just under 2GB of memory back in, slowing the virtual
> machines down to a crawl.
> 
> This patch makes swapin readahead simply skip over holes, instead
> of stopping at them.  This allows the system to swap things back in
> at rates of several MB/second, instead of a few hundred kB/second.
> 
> The checks done in valid_swaphandles are already done in 
> read_swap_cache_async as well, allowing us to remove a fair amount
> of code.

Just to show that I'm paying attention...

> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -382,25 +382,23 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
> -	int nr_pages;
>  	struct page *page;
> -	unsigned long offset;
> -	unsigned long end_offset;
> +	unsigned long offset = swp_offset(entry);
> +	unsigned long start_offset, end_offset;
> +	unsigned long mask = (1 << page_cluster) - 1;

This is broken for page_cluster > 31.  Fix:

--- a/mm/swap_state.c~make-swapin-readahead-skip-over-holes-fix
+++ a/mm/swap_state.c
@@ -385,7 +385,7 @@ struct page *swapin_readahead(swp_entry_
 	struct page *page;
 	unsigned long offset = swp_offset(entry);
 	unsigned long start_offset, end_offset;
-	unsigned long mask = (1 << page_cluster) - 1;
+	unsigned long mask = (1UL << page_cluster) - 1;
 
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
_

