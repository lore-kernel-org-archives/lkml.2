Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2BUUAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:00:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50247 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BUUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:00:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.239.229 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 21 Feb 2012 12:00:08 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] mm/memcg: take care over pc->mem_cgroup
In-Reply-To: <4F433418.3010401@openvz.org>
Message-ID: <alpine.LSU.2.00.1202211140330.1858@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201533260.23274@eggly.anvils> <4F433418.3010401@openvz.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Feb 2012, Konstantin Khlebnikov wrote:
> > 
> > Be particularly careful in compaction's isolate_migratepages() and
> > vmscan's lumpy handling in isolate_lru_pages(): those approach the
> > page by its physical location, and so can encounter pages which
> > would not be found by any logical lookup.  For those cases we have
> > to change __isolate_lru_page() slightly: it must leave ClearPageLRU
> > to the caller, because compaction and lumpy cannot safely interfere
> > with a page until they have first isolated it and then locked lruvec.
> 
> Yeah, this is most complicated part.

Yes, I found myself leaving this patch until last when commenting.

And was not entirely convinced by what I then said of move_account().
Indeed, I wondered if it might be improved and simplified by taking
lruvec locks itself, in the manner that commit_charge lrucare ends
up doing.

> I found one race here, see below.

Thank you!

> > @@ -386,10 +364,24 @@ static isolate_migrate_t isolate_migrate
> >                          continue;
> > 
> >                  page_relock_lruvec(page,&lruvec);
> 
> Here race with mem_cgroup_move_account() we hold lock for old lruvec,
> while move_account() recharge page and put page back into other lruvec.
> Thus we see PageLRU(), but below we isolate page from wrong lruvec.

I expect you'll prove right on that, but I'm going to think about it
more later.

> 
> In my patch-set this is fixed with __wait_lru_unlock() [ spin_unlock_wait() ]
> in mem_cgroup_move_account()

Right now, after finishing mail, I want to concentrate on getting your
series working under my swapping load.

It's possible that I screwed up rediffing it to my slightly later
base (though the only parts that appeared to need fixing up were as
expected, near update_isolated_counts and move_active_pages_to_lru);
but if so I'd expect that to show up differently.

At present, although it runs fine with cgroup_disable=memory, with memcg
two machines very soon hit that BUG at include/linux/mm_inline.h:41!
when the lru_size or pages_count wraps around; on another it hit that
precisely when I stopped the test.

In all cases it's in release_pages from free_pages_and_swap_cache from
tlb_flush_mmu from tlb_finish_mmu from exit_mmap from mmput from exit_mm
from do_exit (but different processes exiting).

Hugh
