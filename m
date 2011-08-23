Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1HWO4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:56:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1HWO4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:56:10 -0400
Date: Tue, 23 Aug 2011 16:55:24 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] thp: tail page refcounting fix
Message-ID: <20110823145524.GA23870@redhat.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
 <20110822213347.GF2507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822213347.GF2507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

[ Chris CC'ed ]

Chris, could you run this patch on one of yours hugetlbfs benchmarks to
verify there is no scalability issue in the spinlock of
__get_page_tail in your environment?

With this patch O_DIRECT on hugetlbfs will take the compound_lock even
if it doesn't need to for hugetlbfs. We could have made this special
for THP only, and in fact we could avoid the "tail_page" reference
counting completely for tail pages with hugetlbfs, but we didn't do
that so far because it's safer to have a single code path for all
compound pages and not make hugetlbfs special case there and have all
compound pages behave the same regardless if it's THP or hugetlbfs or
some driver allocating/freeing it, it keeps things much simpler and
the overhead AFIK is unmeasurable (I ask to benchmark just to be 100%
sure). The refcounting path is tricky and the more testing the better
so if it's the same for all compound pages it's best in my view (at
least for the mid term).

Also note, even if we were to ultraoptimize hugetlbfs the SMP locking
scalability would remain identical because the atomic_inc would be
still needed on the "head" page which is the only "shared" item. The
"superflous" for hugetlbfs is _only_ the write on the
"head_page->flags" locked op, and the tail_page->_mapcount atomic
inc/dec. We can't possibly eliminate the head_page->_count atomic
inc/dec, even if we were to ultraoptimize for hugetlbfs and that's the
only possibly troublesome bit in terms of SMP scalability (the
tail_page is so finegrined it can't be a scalability issue). This is
why I exclude these changes can be measurable and they should work as
great as before.

Also it'd be nice if somebody would look in direct-io to stop doing
that get_page there and relay only on the reference taken by
get_user_pages (KVM and all other get_user_page users never take
additional references on pages returned by get_user_pages and relays
exclusively on the refcount taken by get_user_pages). get_user_pages
is capable of taking the reference on the tail pages without having to
take the compound lock perfectly safely through get_page_foll() (which
is taken while the page_table_lock is still held, so it automatically
serializes with split_huge_page through the page_table_lock). Only
additional get_page(page[i]) done on the tail pages taken with
get_user_pages requires the compound_lock to be safe vs
split_huge_page (and normally there is no way to ever call get_page on
any tail page, only after get_user_pages you could run into that, so
that can be usually easily avoided, and so the compound_lock can be
better optimized away by not calling get_page on tail pages in the
first place which also avoids all other locked ops of get_page, not
just the compound_lock!).

Also note, the compound_lock was already taken for the put_page of the
tail pages. We only could avoid it in get_user_pages. So this isn't
making things much difference. I still kept my priority to avoid any
comound_lock for head pages. head compound pages, or regular pages
(not compound) just have 1 atomic ops like always. That is way more
important for performance I think because the head page refcounting
and regular page refcounting is in the real CPU bound fast paths (not
more I/O bound dealing with pci devices like O_DIRECT). And I still
also avoid compound_lock for the secondary MMU page fault in
get_user_pages (can't avoid it in put_page run after the spte is
established, just no way around it but it's always been like that).

So I loaded this patch on all my systems so far so good, torture
testing is also going without problems.

a git tree including patch is here.

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=summary

This is the actual patch you can apply to stock 3.0.0 (3.1 won't boot
here for me because I never use initrd on my development systems...).

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commit;h=41dc8190934cea22b8c8b3f89e82052610664fbb
