Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966181Ab2CAAnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:43:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52135 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab2CAAnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:43:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.212.130 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Wed, 29 Feb 2012 16:43:07 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: fix deadlock by inverting lrucare nesting
In-Reply-To: <20120229140458.c53352db.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1202291635000.11821@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils> <20120229140458.c53352db.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Andrew Morton wrote:
> On Tue, 28 Feb 2012 21:25:02 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > We have forgotten the rules of lock nesting: the irq-safe ones must be
> > taken inside the non-irq-safe ones, otherwise we are open to deadlock:
> 
> This patch makes rather a mess of "memcg: remove PCG_CACHE page_cgroup
> flag".

Sorry about that.

> 
> I did it this way:

Exactly right, thank you.  In my tree I end up with a blank line
in between the smp_wmb() and the SetPageCgroupUsed(pc), but I
prefer the way you have grouped it.

Hugh

> 
> static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
> 				       struct page *page,
> 				       unsigned int nr_pages,
> 				       struct page_cgroup *pc,
> 				       enum charge_type ctype,
> 				       bool lrucare)
> {
> 	struct zone *uninitialized_var(zone);
> 	bool was_on_lru = false;
> 	bool anon;
> 
> 	lock_page_cgroup(pc);
> 	if (unlikely(PageCgroupUsed(pc))) {
> 		unlock_page_cgroup(pc);
> 		__mem_cgroup_cancel_charge(memcg, nr_pages);
> 		return;
> 	}
> 	/*
> 	 * we don't need page_cgroup_lock about tail pages, becase they are not
> 	 * accessed by any other context at this point.
> 	 */
> 
> 	/*
> 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
> 	 * may already be on some other mem_cgroup's LRU.  Take care of it.
> 	 */
> 	if (lrucare) {
> 		zone = page_zone(page);
> 		spin_lock_irq(&zone->lru_lock);
> 		if (PageLRU(page)) {
> 			ClearPageLRU(page);
> 			del_page_from_lru_list(zone, page, page_lru(page));
> 			was_on_lru = true;
> 		}
> 	}
> 
> 	pc->mem_cgroup = memcg;
> 	/*
> 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
> 	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
> 	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
> 	 * before USED bit, we need memory barrier here.
> 	 * See mem_cgroup_add_lru_list(), etc.
>  	 */
> 	smp_wmb();
> 	SetPageCgroupUsed(pc);
> 
> 	if (lrucare) {
> 		if (was_on_lru) {
> 			VM_BUG_ON(PageLRU(page));
> 			SetPageLRU(page);
> 			add_page_to_lru_list(zone, page, page_lru(page));
> 		}
> 		spin_unlock_irq(&zone->lru_lock);
> 	}
> 
> 	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
> 		anon = true;
> 	else
> 		anon = false;
> 
> 	mem_cgroup_charge_statistics(memcg, anon, nr_pages);
> 	unlock_page_cgroup(pc);
> 
> 	/*
> 	 * "charge_statistics" updated event counter. Then, check it.
> 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
> 	 * if they exceeds softlimit.
> 	 */
> 	memcg_check_events(memcg, page);
> }
> 
> 
