Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2BTQVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:21:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64189 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2BTQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:21:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.127.81 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F4272FA.9000004@openvz.org>
Date: Mon, 20 Feb 2012 20:21:14 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: replace per-cpu lru-add page-vectors with page-lists
References: <20120219212412.16861.36936.stgit@zurg> <20120219212417.16861.63119.stgit@zurg>
In-Reply-To: <20120219212417.16861.63119.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> This patch replaces page-vectors with page-lists in lru_cache_add*() functions.
> We can use page->lru for linking because page obviously not in lru.
>
> Now per-cpu batch limited with its pages total size, not pages count,
> otherwise it can be extremely huge if there many huge-pages inside:
> PAGEVEC_SIZE * HPAGE_SIZE = 28Mb, per-cpu!
> These pages are hidden from memory reclaimer for a while.
> New limit: LRU_CACHE_ADD_BATCH = 64 (* PAGE_SIZE = 256Kb)
>
> So, huge-page adding now will always drain per-cpu list. Huge-page allocation
> and preparation is long procedure, thus nobody will notice this draining.
>
> Draining procedure disables preemption only for pages list isolation,
> thus batch size can be increased without negative effect for latency.
>
> Plus this patch introduces new function lru_cache_add_list() and use it in
> mpage_readpages() and read_pages(). There pages already collected in list.
> Unlike to single-page lru-add, list-add reuse page-referencies from caller,
> thus we save one page_get()/page_put() per page.
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> ---
>   fs/mpage.c           |   21 +++++++----
>   include/linux/swap.h |    2 +
>   mm/readahead.c       |   15 +++++---
>   mm/swap.c            |   99 +++++++++++++++++++++++++++++++++++++++++++++-----
>   4 files changed, 114 insertions(+), 23 deletions(-)
>

>
>   	pvec =&per_cpu(lru_rotate_pvecs, cpu);
> @@ -765,6 +841,11 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
>   void __init swap_setup(void)
>   {
>   	unsigned long megs = totalram_pages>>  (20 - PAGE_SHIFT);
> +	int cpu, lru;
> +
> +	for_each_possible_cpu(cpu)
> +		for_each_lru(lru)
> +			INIT_LIST_HEAD(per_cpu(lru_add_pages, cpu) + lru);

As I afraid, here is is too late for this initialization.
This must be in core-initcall.

I'll send v2 together with update lru-lock splitting rebased to linux-next.

>
>   #ifdef CONFIG_SWAP
>   	bdi_init(swapper_space.backing_dev_info);
>

