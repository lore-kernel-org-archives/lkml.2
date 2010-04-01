Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0DAKmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:42:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44413 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0DAKmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jVgMgSfcBbcovmmFhZUwiuI5O5g1Xw6EVNIEdzjYvlMBVXWbXWT1RHxmCDUaT4BMBt
         l0qQB1uBgl/qIMVDn0V2i6XJLSpDkrqq/psGbJLM7FCZz2uCwLRHoI5a5lWn059Et2OU
         uvZh/shK1yhc97htlE4l1cIlV4nrQW5pJBT5Q=
MIME-Version: 1.0
In-Reply-To: <20100401093022.GA621@csn.ul.ie>
References: <1269940489-5776-1-git-send-email-mel@csn.ul.ie>
	 <1269940489-5776-15-git-send-email-mel@csn.ul.ie>
	 <20100331142623.62ac9175.kamezawa.hiroyu@jp.fujitsu.com>
	 <j2s28c262361003311943ke6d39007of3861743cef3733a@mail.gmail.com>
	 <20100401120123.f9f9e872.kamezawa.hiroyu@jp.fujitsu.com>
	 <n2k28c262361003312144k3a1a725aj1eb22efe6d360118@mail.gmail.com>
	 <20100401093022.GA621@csn.ul.ie>
Date: Thu, 1 Apr 2010 19:42:41 +0900
Message-ID: <w2v28c262361004010342ib071abc7h4c967a25dee135a2@mail.gmail.com>
Subject: Re: [PATCH 14/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
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

On Thu, Apr 1, 2010 at 6:30 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Thu, Apr 01, 2010 at 01:44:29PM +0900, Minchan Kim wrote:
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
>
> If I remove the check for (PageSwapCache(page) && !page_mapped(page))
> in rmap_walk(), then the bug below occurs. The first one is lockdep going
> bad because it's accessing a bad lock implying that anon_vma->lock is
> already invalid. The bug that triggers after it is the list walk.

Thanks. I think it's possible. It's subtle problem.
Assume !page_mapped  && PageAnon(page)  && PageSwapCache

0. PageAnon check
1. race window <---- anon_vma free!!!!
2. rcu_read_lock()
3. skip_unmap
4. move_to_new_page
5. newpage->mapping = page->mapping <--- !!!! It's invalid
6.     mapping->a_ops->migratepage
7.         radix tree change, copy page (still new page anon is NULL)
8.     remove_migrate_ptes
9.     rmap_walk
10.         PageAnon is true --> we are deceived.
11.         rmap_walk_anon -> go bomb!

Does it make sense?
-- 
Kind regards,
Minchan Kim
