Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2CaU3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:29:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2CaU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:29:36 -0400
Date: Sat, 31 Mar 2012 13:29:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Arnd Bergmann <arnd@arndb.de>
cc: Rik van Riel <riel@redhat.com>, linaro-kernel@lists.linaro.org,
        linux-mm@kvack.org, "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        kernel-team@android.com
Subject: Re: swap on eMMC and other flash
In-Reply-To: <201203301850.22784.arnd@arndb.de>
Message-ID: <alpine.LSU.2.00.1203311230490.10965@eggly.anvils>
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Arnd Bergmann wrote:
> On Friday 30 March 2012, Arnd Bergmann wrote:
> 
>  We've had a discussion in the Linaro storage team (Saugata, Venkat and me,
>  with Luca joining in on the discussion) about swapping to flash based media
>  such as eMMC. This is a summary of what we found and what we think should
>  be done. If people agree that this is a good idea, we can start working
>  on it.
>  
>  The basic problem is that Linux without swap is sort of crippled and some
>  things either don't work at all (hibernate) or not as efficient as they
>  should (e.g. tmpfs). At the same time, the swap code seems to be rather
>  inappropriate for the algorithms used in most flash media today, causing
>  system performance to suffer drastically, and wearing out the flash hardware
>  much faster than necessary. In order to change that, we would be
>  implementing the following changes:
>  
>  1) Try to swap out multiple pages at once, in a single write request. My
>  reading of the current code is that we always send pages one by one to
>  the swap device, while most flash devices have an optimum write size of
>  32 or 64 kb and some require an alignment of more than a page. Ideally
>  we would try to write an aligned 64 kb block all the time. Writing aligned
>  64 kb chunks often gives us ten times the throughput of linear 4kb writes,
>  and going beyond 64 kb usually does not give any better performance.

My suspicion is that we suffer a lot from the "distance" between when
we allocate swap space (add_to_swap getting the swp_entry_t to replace
ptes by) and when we finally decide to write out a page (swap_writepage):
intervening decisions can jumble the sequence badly.

I've not investigated to confirm that, but certainly it was the case two
or three years ago, that we got much better behaviour in swapping shmem
to flash, when we stopped giving it a second pass round the lru, which
used to come in between the allocation and the writeout.

I believe that you'll want to start by implementing something like what
Rik set out a year ago in the mail appended below.  Adding another layer
of indirection isn't always a pure win, and I think none of us have taken
it any further since then; but sooner or later we shall need to, and your
flash case might be just the prod needed.

With that change made (so swap ptes are just pointers into an intervening
structure, where we record disk blocks allocated at the time of writeout),
some improvement should come just from traditional merging by the I/O
scheduler (deadline seems both better for flash and better for swap: one
day it would be nice to work out how cfq can be tweaked better for swap).

Some improvement, but probably not enough, and you'd want to do something
more proactive, like the mblk_io_submit stuff ext4 does these days.

Though they might prove to give the greatest benefit on flash,
these kind of changes should be good for conventional disk too.

>  
>  2) Make variable sized swap clusters. Right now, the swap space is
>  organized in clusters of 256 pages (1MB), which is less than the typical
>  erase block size of 4 or 8 MB. We should try to make the swap cluster
>  aligned to erase blocks and have the size match to avoid garbage collection
>  in the drive. The cluster size would typically be set by mkswap as a new
>  option and interpreted at swapon time.

That gets to sound more flash-specific, and I feel less enthusiastic
about doing things in bigger and bigger lumps.  But if it really proves
to be of benefit, it's easy enough to let you.

Decide the cluster size at mkswap time, or at swapon time, or by
/sys/block/sda/queue parameters?  Perhaps a /sys parameter should give
the size, but a swapon flag decide whether to participate or not.  Perhaps.

>  
>  3) As Luca points out, some eMMC media would benefit significantly from
>  having discard requests issued for every page that gets freed from
>  the swap cache, rather than at the time just before we reuse a swap
>  cluster. This would probably have to become a configurable option
>  as well, to avoid the overhead of sending the discard requests on
>  media that don't benefit from this.

I'm surprised, I wouldn't have contemplated a discard per page;
but if you have cases where it can be proved of benefit, fine.
I know nothing at all of eMMC.

Though as things stand, that swap_lock spinlock makes it difficult
to find a good safe moment to issue a discard (you want the spinlock
to keep it safe, but you don't want to issue "I/O" while holding a
spinlock).  Perhaps that difficulty can be overcome in a satisfactory
way, in the course of restructuring swap allocation as Rik set out
(Rik suggests freeing on swapin, that should make it very easy).

Hugh

>  
>  Does this all sound appropriate for the Linux memory management people?
>  
>  Also, does this sound useful to the Android developers? Would you
>  start using swap if we make it perform well and not destroy the drives?
>  
>  Finally, does this plan match up with the capabilities of the
>  various eMMC devices? I know more about SD and USB devices and
>  I'm quite convinced that it would help there, but eMMC can be
>  more like an SSD in some ways, and the current code should be fine
>  for real SSDs.
>  
>  	Arnd

>From riel@redhat.com Sun Apr 10 17:50:10 2011
Date: Sun, 10 Apr 2011 20:50:01 -0400
From: Rik van Riel <riel@redhat.com>
To: Linux Memory Management List <linux-mm@kvack.org>
Subject: [LSF/Collab] swap cache redesign idea

On Thursday after LSF, Hugh, Minchan, Mel, Johannes and I were
sitting in the hallway talking about yet more VM things.

During that discussion, we came up with a way to redesign the
swap cache.  During my flight home, I came with ideas on how
to use that redesign, that may make the changes worthwhile.

Currently, the page table entries that have swapped out pages
associated with them contain a swap entry, pointing directly
at the swap device and swap slot containing the data. Meanwhile,
the swap count lives in a separate array.

The redesign we are considering moving the swap entry to the
page cache radix tree for the swapper_space and having the pte
contain only the offset into the swapper_space.  The swap count
info can also fit inside the swapper_space page cache radix
tree (at least on 64 bits - on 32 bits we may need to get
creative or accept a smaller max amount of swap space).

This extra layer of indirection allows us to do several things:

1) get rid of the virtual address scanning swapoff; instead
    we just swap the data in and mark the pages as present in
    the swapper_space radix tree

2) free swap entries as the are read in, without waiting for
    the process to fault it in - this may be useful for memory
    types that have a large erase block

3) together with the defragmentation from (2), we can always
    do writes in large aligned blocks - the extra indirection
    will make it relatively easy to have special backend code
    for different kinds of swap space, since all the state can
    now live in just one place

4) skip writeout of zero-filled pages - this can be a big help
    for KVM virtual machines running Windows, since Windows zeroes
    out free pages;   simply discarding a zero-filled page is not
    at all simple in the current VM, where we would have to iterate
    over all the ptes to free the swap entry before being able to
    free the swap cache page (I am not sure how that locking would
    even work)

    with the extra layer of indirection, the locking for this scheme
    can be trivial - either the faulting process gets the old page,
    or it gets a new one, either way it'll be zero filled

5) skip writeout of pages the guest has marked as free - same as
    above, with the same easier locking

Only one real question remaining - how do we handle the swap count
in the new scheme?  On 64 bit systems we have enough space in the
radix tree, on 32 bit systems maybe we'll have to start overflowing
into the "swap_count_continued" logic a little sooner than we are
now and reduce the maximum swap size a little?

-- 
All rights reversed
