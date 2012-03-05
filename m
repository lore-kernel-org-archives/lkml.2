Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2CEA0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:26:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47853 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2CEA0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:26:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 5 Mar 2012 09:24:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: fix GPF when cgroup removal races with last
 exit
Message-Id: <20120305092429.c3ba18a0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1203021030140.2094@eggly.anvils>
References: <alpine.LSU.2.00.1203021030140.2094@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 10:37:04 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> When moving tasks from old memcg (with move_charge_at_immigrate on new
> memcg), followed by removal of old memcg, hit General Protection Fault
> in mem_cgroup_lru_del_list() (called from release_pages called from
> free_pages_and_swap_cache from tlb_flush_mmu from tlb_finish_mmu from
> exit_mmap from mmput from exit_mm from do_exit).
> 
> Somewhat reproducible, takes a few hours: the old struct mem_cgroup has
> been freed and poisoned by SLAB_DEBUG, but mem_cgroup_lru_del_list() is
> still trying to update its stats, and take page off lru before freeing.
> 
> A task, or a charge, or a page on lru: each secures a memcg against
> removal.  In this case, the last task has been moved out of the old
> memcg, and it is exiting: anonymous pages are uncharged one by one
> from the memcg, as they are zapped from its pagetables, so the charge
> gets down to 0; but the pages themselves are queued in an mmu_gather
> for freeing.
> 
> Most of those pages will be on lru (and force_empty is careful to
> lru_add_drain_all, to add pages from pagevec to lru first), but not
> necessarily all: perhaps some have been isolated for page reclaim,
> perhaps some isolated for other reasons.  So, force_empty may find
> no task, no charge and no page on lru, and let the removal proceed.
> 
> There would still be no problem if these pages were immediately
> freed; but typically (and the put_page_testzero protocol demands it)
> they have to be added back to lru before they are found freeable,
> then removed from lru and freed.  We don't see the issue when adding,
> because the mem_cgroup_iter() loops keep their own reference to the
> memcg being scanned; but when it comes to mem_cgroup_lru_del_list().
> 
> I believe this was not an issue in v3.2: there, PageCgroupAcctLRU and
> PageCgroupUsed flags were used (like a trick with mirrors) to deflect
> view of pc->mem_cgroup to the stable root_mem_cgroup when neither set.
> 38c5d72f3ebe "memcg: simplify LRU handling by new rule" mercifully
> removed those convolutions, but left this General Protection Fault.
> 
> But it's surprisingly easy to restore the old behaviour: just check
> PageCgroupUsed in mem_cgroup_lru_add_list() (which decides on which
> lruvec to add), and reset pc to root_mem_cgroup if page is uncharged.
> A risky change? just going back to how it worked before; testing,
> and an audit of uses of pc->mem_cgroup, show no problem.
> 
> And there's a nice bonus: with mem_cgroup_lru_add_list() itself making
> sure that an uncharged page goes to root lru, mem_cgroup_reset_owner()
> no longer has any purpose, and we can safely revert 4e5f01c2b9b9
> "memcg: clear pc->mem_cgroup if necessary".
> 
> Calling update_page_reclaim_stat() after add_page_to_lru_list() in
> swap.c is not strictly necessary: the lru_lock there, with RCU before
> memcg structures are freed, makes mem_cgroup_get_reclaim_stat_from_page
> safe without that; but it seems cleaner to rely on one dependency less.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Thank you very much!!

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

