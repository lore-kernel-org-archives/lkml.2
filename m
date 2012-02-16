Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2BPFoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:44:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49485 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2BPFn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:43:56 -0500
Message-ID: <4F3C9798.7050800@openvz.org>
Date: Thu, 16 Feb 2012 09:43:52 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH RFC 00/15] mm: memory book keeping and lru_lock splitting
References: <20120215224221.22050.80605.stgit@zurg> <20120216110408.f35c3448.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120216110408.f35c3448.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 16 Feb 2012 02:57:04 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> There should be no logic changes in this patchset, this is only tossing bits around.
>> [ This patchset is on top some memcg cleanup/rework patches,
>>    which I sent to linux-mm@ today/yesterday ]
>>
>> Most of things in this patchset are self-descriptive, so here brief plan:
>>
>
> AFAIK, Hugh Dickins said he has per-zone-per-lru-lock and is testing it.
> So, please CC him and Johannes, at least.
>

Ok

>
>> * Transmute struct lruvec into struct book. Like real book this struct will
>>    store set of pages for one zone. It will be working unit for reclaimer code.
>> [ If memcg is disabled in config there will only one book embedded into struct zone ]
>>
>
> Why you need to add new structure rahter than enhancing lruvec ?
> "book" means a binder of pages ?
>

I responded to this in the reply to Hugh Dickins.

>
>> * move page-lru counters to struct book
>> [ this adds extra overhead in add_page_to_lru_list()/del_page_from_lru_list() for
>>    non-memcg case, but I believe it will be invisible, only one non-atomic add/sub
>>    in the same cacheline with lru list ]
>>
>
> This seems straightforward.
>
>> * unify inactive_list_is_low_global() and cleanup reclaimer code
>> * replace struct mem_cgroup_zone with single pointer to struct book
>
> Hm, ok.
>
>> * optimize page to book translations, move it upper in the call stack,
>>    replace some struct zone arguments with struct book pointer.
>>
>
> a page->book transrater from patch 2/15
>
> +struct book *page_book(struct page *page)
> +{
> +	struct mem_cgroup_per_zone *mz;
> +	struct page_cgroup *pc;
> +
> +	if (mem_cgroup_disabled())
> +		return&page_zone(page)->book;
> +
> +	pc = lookup_page_cgroup(page);
> +	if (!PageCgroupUsed(pc))
> +		return&page_zone(page)->book;
> +	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> +	smp_rmb();
> +	mz = mem_cgroup_zoneinfo(pc->mem_cgroup,
> +			page_to_nid(page), page_zonenum(page));
> +	return&mz->book;
> +}
>
> What happens when pc->mem_cgroup is rewritten by move_account() ?
> Where is the guard for lockless access of this ?

Initially this suppose to be protected with lru_lock, in final patch they are protected with rcu.
After final patch all page_book() calls are collected in [__re]lock_page_book[_irq]() functions.
They pick some book reference, lock its lru and recheck page -> book reference in loop till success.

Currently I found there only one potential problem: free_mem_cgroup_per_zone_info() in "mm: memory bookkeeping core"
maybe should call spin_unlock_wait(&zone->lru_lock), because some guy can pick page_book(pfn_to_page(pfn))
and try to isolate this page. But I not sure, how this is possible. In final patch it is totally fixed with rcu.

>
> Thanks,
> -Kame
>

