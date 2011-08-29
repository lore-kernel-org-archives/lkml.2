Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1H2EUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:20:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60289 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1H2EU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110827173421.GA2967@redhat.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
	<20110822213347.GF2507@redhat.com>
	<CANN689HE=TKyr-0yDQgXEoothGJ0Cw0HLB2iOvCKrOXVF2DNww@mail.gmail.com>
	<20110824000914.GH23870@redhat.com>
	<20110824002717.GI23870@redhat.com>
	<20110824133459.GP23870@redhat.com>
	<20110826062436.GA5847@google.com>
	<20110826161048.GE23870@redhat.com>
	<20110826185430.GA2854@redhat.com>
	<20110827094152.GA16402@google.com>
	<20110827173421.GA2967@redhat.com>
Date: Mon, 29 Aug 2011 13:20:26 +0900
Message-ID: <CAEwNFnDk0bQZKReKccuQMPEw_6EA2DxN4dm9cmjr01BVT4A7Dw@mail.gmail.com>
Subject: Re: [PATCH] thp: tail page refcounting fix #4
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 2:34 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Sat, Aug 27, 2011 at 02:41:52AM -0700, Michel Lespinasse wrote:
>> I understand you may have to remove the VM_BUG_ON(page_mapcount(page) <= 0)
>> that I had suggested in __get_page_tail() (sorry about that).
>
> The function doing that is snd_pcm_mmap_data_fault and it's doing what
> I described in prev email.
>
>> My only additional suggestion is about the put_page_testzero in
>> __get_page_tail(), maybe if you could just increment the tail page count
>> instead of calling __get_page_tail_foll(), then you wouldn't have to
>> release the extra head page count there. And it would even look kinda
>> natural, head page count gets acquired before compound_lock_irqsave(),
>> so we only have to acquire an extra tail page count after confirming
>> this is still a tail page.
>
> Ok, I added a param to __get_page_tail_foll, it is constant at build
> time and because it's inline the branch should be optimized away at
> build time without requiring a separate function. The bugchecks are
> the same so we can share and just skip the atomic_inc on the
> page_head in __get_page_tail_foll. Also it had to be moved into
> internal.h as a further cleanup.
>
>> Either way, the code looks OK by now.
>>
>> Reviewed-by: Michel Lespinasse <walken@google.com>
>
> Thanks. Incremental diff to correct the false positive bug on for
> drivers like alsa allocating __GFP_COMP and mapping subpages with page
> faults.
>
> diff --git a/mm/swap.c b/mm/swap.c
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -166,12 +166,6 @@ int __get_page_tail(struct page *page)
>                flags = compound_lock_irqsave(page_head);
>                /* here __split_huge_page_refcount won't run anymore */
>                if (likely(PageTail(page))) {
> -                       /*
> -                        * get_page() can only be called on tail pages
> -                        * after get_page_foll() taken a tail page
> -                        * refcount.
> -                        */
> -                       VM_BUG_ON(page_mapcount(page) <= 0);
>                        __get_page_tail_foll(page);
>                        got = 1;
>
>                        /*
>
> This is the optimization.
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -375,26 +375,6 @@ static inline int page_count(struct page
>        return atomic_read(&compound_head(page)->_count);
>  }
>
> -static inline void __get_page_tail_foll(struct page *page)
> -{
> -       /*
> -        * If we're getting a tail page, the elevated page->_count is
> -        * required only in the head page and we will elevate the head
> -        * page->_count and tail page->_mapcount.
> -        *
> -        * We elevate page_tail->_mapcount for tail pages to force
> -        * page_tail->_count to be zero at all times to avoid getting
> -        * false positives from get_page_unless_zero() with
> -        * speculative page access (like in
> -        * page_cache_get_speculative()) on tail pages.
> -        */
> -       VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
> -       VM_BUG_ON(atomic_read(&page->_count) != 0);
> -       VM_BUG_ON(page_mapcount(page) < 0);
> -       atomic_inc(&page->first_page->_count);
> -       atomic_inc(&page->_mapcount);
> -}
> -
>  extern int __get_page_tail(struct page *page);
>
>  static inline void get_page(struct page *page)
> diff --git a/mm/internal.h b/mm/internal.h
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -37,6 +37,28 @@ static inline void __put_page(struct pag
>        atomic_dec(&page->_count);
>  }
>
> +static inline void __get_page_tail_foll(struct page *page,
> +                                       bool get_page_head)
> +{
> +       /*
> +        * If we're getting a tail page, the elevated page->_count is
> +        * required only in the head page and we will elevate the head
> +        * page->_count and tail page->_mapcount.
> +        *
> +        * We elevate page_tail->_mapcount for tail pages to force
> +        * page_tail->_count to be zero at all times to avoid getting
> +        * false positives from get_page_unless_zero() with
> +        * speculative page access (like in
> +        * page_cache_get_speculative()) on tail pages.
> +        */
> +       VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
> +       VM_BUG_ON(atomic_read(&page->_count) != 0);
> +       VM_BUG_ON(page_mapcount(page) < 0);
> +       if (get_page_head)
> +               atomic_inc(&page->first_page->_count);
> +       atomic_inc(&page->_mapcount);
> +}
> +
>  static inline void get_page_foll(struct page *page)
>  {
>        if (unlikely(PageTail(page)))
> @@ -45,7 +67,7 @@ static inline void get_page_foll(struct
>                 * __split_huge_page_refcount() can't run under
>                 * get_page_foll() because we hold the proper PT lock.
>                 */
> -               __get_page_tail_foll(page);
> +               __get_page_tail_foll(page, true);
>        else {
>                /*
>                 * Getting a normal page or the head of a compound page
> diff --git a/mm/swap.c b/mm/swap.c
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -166,16 +166,8 @@ int __get_page_tail(struct page *page)
>                flags = compound_lock_irqsave(page_head);
>                /* here __split_huge_page_refcount won't run anymore */
>                if (likely(PageTail(page))) {
> -                       __get_page_tail_foll(page);
> +                       __get_page_tail_foll(page, false);
>                        got = 1;
> -                       /*
> -                        * We can release the refcount taken by
> -                        * get_page_unless_zero() now that
> -                        * __split_huge_page_refcount() is blocked on
> -                        * the compound_lock.
> -                        */
> -                       if (put_page_testzero(page_head))
> -                               VM_BUG_ON(1);
>                }
>                compound_unlock_irqrestore(page_head, flags);
>                if (unlikely(!got))
>
>
> ===
> Subject: thp: tail page refcounting fix
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> Michel while working on the working set estimation code, noticed that calling
> get_page_unless_zero() on a random pfn_to_page(random_pfn) wasn't safe, if the
> pfn ended up being a tail page of a transparent hugepage under splitting by
> __split_huge_page_refcount(). He then found the problem could also
> theoretically materialize with page_cache_get_speculative() during the
> speculative radix tree lookups that uses get_page_unless_zero() in SMP if the
> radix tree page is freed and reallocated and get_user_pages is called on it
> before page_cache_get_speculative has a chance to call get_page_unless_zero().
>
> So the best way to fix the problem is to keep page_tail->_count zero at all
> times. This will guarantee that get_page_unless_zero() can never succeed on any
> tail page. page_tail->_mapcount is guaranteed zero and is unused for all tail
> pages of a compound page, so we can simply account the tail page references
> there and transfer them to tail_page->_count in __split_huge_page_refcount() (in
> addition to the head_page->_mapcount).
>
> While debugging this s/_count/_mapcount/ change I also noticed get_page is
> called by direct-io.c on pages returned by get_user_pages. That wasn't entirely
> safe because the two atomic_inc in get_page weren't atomic. As opposed other
> get_user_page users like secondary-MMU page fault to establish the shadow
> pagetables would never call any superflous get_page after get_user_page
> returns. It's safer to make get_page universally safe for tail pages and to use
> get_page_foll() within follow_page (inside get_user_pages()). get_page_foll()
> is safe to do the refcounting for tail pages without taking any locks because
> it is run within PT lock protected critical sections (PT lock for pte and
> page_table_lock for pmd_trans_huge). The standard get_page() as invoked by
> direct-io instead will now take the compound_lock but still only for tail
> pages. The direct-io paths are usually I/O bound and the compound_lock is per
> THP so very finegrined, so there's no risk of scalability issues with it. A
> simple direct-io benchmarks with all lockdep prove locking and spinlock
> debugging infrastructure enabled shows identical performance and no overhead.
> So it's worth it. Ideally direct-io should stop calling get_page() on pages
> returned by get_user_pages(). The spinlock in get_page() is already optimized
> away for no-THP builds but doing get_page() on tail pages returned by GUP is
> generally a rare operation and usually only run in I/O paths.
>
> This new refcounting on page_tail->_mapcount in addition to avoiding new RCU
> critical sections will also allow the working set estimation code to work
> without any further complexity associated to the tail page refcounting
> with THP.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Reported-by: Michel Lespinasse <walken@google.com>
> Reviewed-by: Michel Lespinasse <walken@google.com>

There is a just nitpick at below but the code looks more clear than
old and even fixed bug I missed but Michel found.

Thanks!

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

> @@ -1156,6 +1156,7 @@ static void __split_huge_page_refcount(s
>        unsigned long head_index = page->index;
>        struct zone *zone = page_zone(page);
>        int zonestat;
> +       int tail_count = 0;
>
>        /* prevent PageLRU to go away from under us, and freeze lru stats */
>        spin_lock_irq(&zone->lru_lock);
> @@ -1164,11 +1165,14 @@ static void __split_huge_page_refcount(s
>        for (i = 1; i < HPAGE_PMD_NR; i++) {
>                struct page *page_tail = page + i;
>
> -               /* tail_page->_count cannot change */
> -               atomic_sub(atomic_read(&page_tail->_count), &page->_count);
> -               BUG_ON(page_count(page) <= 0);
> -               atomic_add(page_mapcount(page) + 1, &page_tail->_count);
> -               BUG_ON(atomic_read(&page_tail->_count) <= 0);
> +               /* tail_page->_mapcount cannot change */
> +               BUG_ON(page_mapcount(page_tail) < 0);
> +               tail_count += page_mapcount(page_tail);
> +               /* check for overflow */
> +               BUG_ON(tail_count < 0);
> +               BUG_ON(atomic_read(&page_tail->_count) != 0);
> +               atomic_add(page_mapcount(page) + page_mapcount(page_tail) + 1,
> +                          &page_tail->_count);

I doubt someone might try to change this with atomic_set for reducing
LOCK_PREFIX overhead in future although it's not fast path. Of course,
we can prevent that patch but can't prevent his wasted time. I hope
there is a comment why we use atomic_add like the errata PPro with
OOStore.





-- 
Kind regards,
Minchan Kim
