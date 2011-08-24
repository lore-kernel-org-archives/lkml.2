Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1HXAJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:09:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab1HXAJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:09:35 -0400
Date: Wed, 24 Aug 2011 02:09:14 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] thp: tail page refcounting fix
Message-ID: <20110824000914.GH23870@redhat.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
 <20110822213347.GF2507@redhat.com>
 <CANN689HE=TKyr-0yDQgXEoothGJ0Cw0HLB2iOvCKrOXVF2DNww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689HE=TKyr-0yDQgXEoothGJ0Cw0HLB2iOvCKrOXVF2DNww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michel,

On Tue, Aug 23, 2011 at 12:52:56PM -0700, Michel Lespinasse wrote:
> Adding Paul McKenney so he won't spend too much time on RCU cookie
> feature until there is a firmer user...

Yep, he already knew because I notified him privately for the same
reason.

> Looks like this scheme will work. I'm off in Yosemite for a few days
> with my family, but I should be able to review this more thoroughly on
> Thursday.

Take your time, and enjoy Yosemite :).

> From a few-minutes look, I have a few minor concerns:
> - When splitting THP pages, the old tail refcount will be visible as
> the _mapcount for a short while after PageTail is cleared; not clear
> yet to me if there are unintended side effects to that;

Well it was zero before and that was also wrong it is overwritten
later with the right value well after PageTail is cleared, so it's ok
if previous code was ok. All ptes are set as pmd_trans_splitting so
nothing should mess page_tail->_mapcount it as no mapping can be
created or go away for the duration of the split and regardless any
mapping that exists only exists for the pmd and the head page (tail
pages are invisible to rmap until later).

> - (not a concern, but an opportunity) when splitting pages, there are
> two atomic adds to the tail _count field, while we know the initial
> value is 0. Why not just one straight assignment ? Similarly, the
> adjustments to page head count could be added into a local variable
> and the page head count could be updated once after all tail pages
> have been split off.

That's an optimization I can look into agreed. I guess I just added
one line and not even think too much at optimizing this,
split_huge_page isn't in a fast path.

> - Not sure if we could/should add assertions to make sure people call
> the right get_page variant.

Not right now or it'd flood when anybody uses O_DIRECT. If O_DIRECT
gets fixes to stop doing this, it sounds definitely good idea.

I already tried adding a printk to the got=1 path and it floods with a
128M/sec dd bs=10M iflag=direct transfer.

> The other question I have is about the use of the pagemap.h RCU
> protocol for eventual page count stability. With your proposal, this
> would now affect only head pages, so THP splitting is fine :) . I'm
> not sure who else might use that protocol, but it looks like we should
> either make all get_pages_unless_zero call sites follow it (if the
> protocol matters to someone) or none (if the protocol turns out to be
> obsolete).

I don't see who is using synchronize_rcu to stabilize the page count
so at first sight it seems superfluous there too. Maybe it was a "if
anybody will ever need to stabilize the page count this can be
used". The only calls of synchronize_rcu in mm/* are in memcg and in
mmu notifier which is not meant to synchronize the page count but just
to walk the mmu notifier registration list lockless from the mm
struct.

I guess we need to ask who wrote that function for clarifications on
the page count stabilization. And if one needs really to stabilize the
page count he will also need Paul's rcu_sequence_t feature to do it
really efficiently (which is now on hold, so if that synchronize_rcu
caller really exists that would likely also mean we need
rcu_sequence_t to optimize it properly). My current feeling is if one
needs that feature he's doing something's wrong that could be achieved
somewhere else but I may be biased by the fact this one worked out.
