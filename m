Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0DAKvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:51:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40476 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0DAKvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GIYQAGOezoxlQUe/F3Nxn/WPyccec19p8IHY6h1VvCVMLlc2MBn31Z8onZK6aRxRvs
         L+Xl615tFCyVnjxB4QDtl8bzTqo6kSdfQgRRU9P/qdJ5K+fOkUI+4UvWCBmNz6vmtlOB
         o71cZDxMflOFvl6SWC6Ai9SmpJzdcdK2tnYOs=
MIME-Version: 1.0
In-Reply-To: <20100401144234.e3848876.kamezawa.hiroyu@jp.fujitsu.com>
References: <1269940489-5776-1-git-send-email-mel@csn.ul.ie>
	 <1269940489-5776-15-git-send-email-mel@csn.ul.ie>
	 <20100331142623.62ac9175.kamezawa.hiroyu@jp.fujitsu.com>
	 <j2s28c262361003311943ke6d39007of3861743cef3733a@mail.gmail.com>
	 <20100401120123.f9f9e872.kamezawa.hiroyu@jp.fujitsu.com>
	 <n2k28c262361003312144k3a1a725aj1eb22efe6d360118@mail.gmail.com>
	 <20100401144234.e3848876.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 1 Apr 2010 19:51:31 +0900
Message-ID: <w2i28c262361004010351r605c897dzd2bdccac149dcc6b@mail.gmail.com>
Subject: Re: [PATCH 14/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 2:42 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 1 Apr 2010 13:44:29 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Thu, Apr 1, 2010 at 12:01 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Thu, 1 Apr 2010 11:43:18 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> >> On Wed, Mar 31, 2010 at 2:26 PM, KAMEZAWA Hiroyuki       /*
>> >> >> diff --git a/mm/rmap.c b/mm/rmap.c
>> >> >> index af35b75..d5ea1f2 100644
>> >> >> --- a/mm/rmap.c
>> >> >> +++ b/mm/rmap.c
>> >> >> @@ -1394,9 +1394,11 @@ int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
>> >> >>
>> >> >>       if (unlikely(PageKsm(page)))
>> >> >>               return rmap_walk_ksm(page, rmap_one, arg);
>> >> >> -     else if (PageAnon(page))
>> >> >> +     else if (PageAnon(page)) {
>> >> >> +             if (PageSwapCache(page))
>> >> >> +                     return SWAP_AGAIN;
>> >> >>               return rmap_walk_anon(page, rmap_one, arg);
>> >> >
>> >> > SwapCache has a condition as (PageSwapCache(page) && page_mapped(page) == true.
>> >> >
>> >>
>> >> In case of tmpfs, page has swapcache but not mapped.
>> >>
>> >> > Please see do_swap_page(), PageSwapCache bit is cleared only when
>> >> >
>> >> > do_swap_page()...
>> >> >       swap_free(entry);
>> >> >        if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
>> >> >                try_to_free_swap(page);
>> >> >
>> >> > Then, PageSwapCache is cleared only when swap is freeable even if mapped.
>> >> >
>> >> > rmap_walk_anon() should be called and the check is not necessary.
>> >>
>> >> Frankly speaking, I don't understand what is Mel's problem, why he added
>> >> Swapcache check in rmap_walk, and why do you said we don't need it.
>> >>
>> >> Could you explain more detail if you don't mind?
>> >>
>> > I may miss something.
>> >
>> > unmap_and_move()
>> >  1. try_to_unmap(TTU_MIGRATION)
>> >  2. move_to_newpage
>> >  3. remove_migration_ptes
>> >        -> rmap_walk()
>> >
>> > Then, to map a page back we unmapped we call rmap_walk().
>> >
>> > Assume a SwapCache which is mapped, then, PageAnon(page) == true.
>> >
>> >  At 1. try_to_unmap() will rewrite pte with swp_entry of SwapCache.
>> >       mapcount goes to 0.
>> >  At 2. SwapCache is copied to a new page.
>> >  At 3. The new page is mapped back to the place. Now, newpage's mapcount is 0.
>> >       Before patch, the new page is mapped back to all ptes.
>> >       After patch, the new page is not mapped back because its mapcount is 0.
>> >
>> > I don't think shared SwapCache of anon is not an usual behavior, so, the logic
>> > before patch is more attractive.
>> >
>> > If SwapCache is not mapped before "1", we skip "1" and rmap_walk will do nothing
>> > because page->mapping is NULL.
>> >
>>
>> Thanks. I agree. We don't need the check.
>> Then, my question is why Mel added the check in rmap_walk.
>> He mentioned some BUG trigger and fixed things after this patch.
>> What's it?
>> Is it really related to this logic?
>> I don't think so or we are missing something.
>>
> Hmm. Consiering again.
>
> Now.
>        if (PageAnon(page)) {
>                rcu_locked = 1;
>                rcu_read_lock();
>                if (!page_mapped(page)) {
>                        if (!PageSwapCache(page))
>                                goto rcu_unlock;
>                } else {
>                        anon_vma = page_anon_vma(page);
>                        atomic_inc(&anon_vma->external_refcount);
>                }
>
>
> Maybe this is a fix.
>
> ==
>        skip_remap = 0;
>        if (PageAnon(page)) {
>                rcu_read_lock();
>                if (!page_mapped(page)) {
>                        if (!PageSwapCache(page))
>                                goto rcu_unlock;
>                        /*
>                         * We can't convice this anon_vma is valid or not because
>                         * !page_mapped(page). Then, we do migration(radix-tree replacement)
>                         * but don't remap it which touches anon_vma in page->mapping.
>                         */
>                        skip_remap = 1;
>                        goto skip_unmap;
>                } else {
>                        anon_vma = page_anon_vma(page);
>                        atomic_inc(&anon_vma->external_refcount);
>                }
>        }
>        .....copy page, radix-tree replacement,....
>

It's not enough.
we uses remove_migration_ptes in  move_to_new_page, too.
We have to prevent it.
We can check PageSwapCache(page) in move_to_new_page and then
skip remove_migration_ptes.

ex)
static int move_to_new_page(....)
{
     int swapcache = PageSwapCache(page);
     ...
     if (!swapcache)
         if(!rc)
             remove_migration_ptes
         else
             newpage->mapping = NULL;
}

And we have to close race between PageAnon(page) and rcu_read_lock.
If we don't do it, anon_vma could be free in the middle of operation.
I means

         * of migration. File cache pages are no problem because of page_lock()
         * File Caches may use write_page() or lock_page() in migration, then,
         * just care Anon page here.
         */
        if (PageAnon(page)) {
                !!! RACE !!!!
                rcu_read_lock();
                rcu_locked = 1;

+
+               /*
+                * If the page has no mappings any more, just bail. An
+                * unmapped anon page is likely to be freed soon but worse,


-- 
Kind regards,
Minchan Kim
