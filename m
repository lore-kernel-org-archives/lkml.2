Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2BUIkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:40:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44034 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2BUIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:40:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Feb 2012 17:38:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/10] mm/memcg: introduce page_relock_lruvec
Message-Id: <20120221173859.f57d00f5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202201532170.23274@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
	<alpine.LSU.2.00.1202201532170.23274@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 15:33:20 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Delete the mem_cgroup_page_lruvec() which we just added, replacing
> it and nearby spin_lock_irq or spin_lock_irqsave of zone->lru_lock:
> in most places by page_lock_lruvec() or page_relock_lruvec() (the
> former being a simple case of the latter) or just by lock_lruvec().
> unlock_lruvec() does the spin_unlock_irqrestore for them all.
> 

Wow..removed ;)

> page_relock_lruvec() is born from that "pagezone" pattern in swap.c
> and vmscan.c, where we loop over an array of pages, switching lock
> whenever the zone changes: bearing in mind that if we were to refine
> that lock to per-memcg per-zone, then we would have to switch whenever
> the memcg changes too.
> 
> page_relock_lruvec(page, &lruvec) locates the right lruvec for page,
> unlocks the old lruvec if different (and not NULL), locks the new,
> and updates lruvec on return: so that we shall have just one routine
> to locate and lock the lruvec, whereas originally it got re-evaluated
> at different stages.  But I don't yet know how to satisfy sparse(1).
> 

Ok, I like page_relock_lruvec().



> There are some loops where we never change zone, and a non-memcg kernel
> would not change memcg: use no-op mem_cgroup_page_relock_lruvec() there.
> 
> In compaction's isolate_migratepages(), although we do know the zone,
> we don't know the lruvec in advance: allow for taking the lock later,
> and reorganize its cond_resched() lock-dropping accordingly.
> 
> page_relock_lruvec() (and its wrappers) is actually an _irqsave operation:
> there are a few cases in swap.c where it may be needed at interrupt time
> (to free or to rotate a page on I/O completion).  Ideally(?) we would use
> straightforward _irq disabling elsewhere, but the variants get confusing,
> and page_relock_lruvec() will itself grow more complicated in subsequent
> patches: so keep it simple for now with just the one irqsaver everywhere.
> 
> Passing an irqflags argument/pointer down several levels looks messy
> too, and I'm reluctant to add any more to the page reclaim stack: so
> save the irqflags alongside the lru_lock and restore them from there.
> 
> It's a little sad now to be including mm.h in swap.h to get page_zone();
> but I think that swap.h (despite its name) is the right place for these
> lru functions, and without those inlines the optimizer cannot do so
> well in the !MEM_RES_CTLR case.
> 
> (Is this an appropriate place to confess? that even at the end of the
> series, we're left with a small bug in putback_inactive_pages(), one
> that I've not yet decided is worth fixing: reclaim_stat there is from
> the lruvec on entry, but we might update stats after dropping its lock.
> And do zone->pages_scanned and zone->all_unreclaimable need locking?
> page_alloc.c thinks zone->lock, vmscan.c thought zone->lru_lock,
> and that weakens if we now split lru_lock by memcg.)
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

No perforamce impact by replacing spin_lock_irq()/spin_unlock_irq() to
spin_lock_irqsave() and spin_unlock_irqrestore() ?

Thanks,
-Kame


