Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2EVWl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:41:26 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57248 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756591Ab2EVWlY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120522174842.GB4071@redhat.com>
References: <1337293069-22443-1-git-send-email-pshelar@nicira.com>
	<20120522174842.GB4071@redhat.com>
Date: Tue, 22 May 2012 15:41:22 -0700
Message-ID: <CALnjE+qwj5vUrR0ptO==MqpN8=eTTogxrYdY9t3eeWZEK8hpoQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: Fix slab->page flags corruption.
From: Pravin Shelar <pshelar@nicira.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: cl@linux.com, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:48 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, May 17, 2012 at 03:17:49PM -0700, Pravin B Shelar wrote:
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 8ff73d8..44a0f81 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -82,6 +82,19 @@ static void put_compound_page(struct page *page)
>>               if (likely(page != page_head &&
>>                          get_page_unless_zero(page_head))) {
>>                       unsigned long flags;
>> +
>> +                     if (PageSlab(page_head)) {
>> +                             if (PageTail(page)) {
>> +                                     /* THP can not break up slab pages, avoid
>> +                                      * taking compound_lock(). */
>> +                                     if (put_page_testzero(page_head))
>> +                                             VM_BUG_ON(1);
>> +
>> +                                     atomic_dec(&page->_mapcount);
>> +                                     goto skip_lock_tail;
>> +                             } else
>> +                                     goto skip_lock;
>> +                     }
>
> Some commentary on the fact slab prefers not using atomic ops on the
> page->flags could help here.
ok.

>
>>                       /*
>>                        * page_head wasn't a dangling pointer but it
>>                        * may not be a head page anymore by the time
>> @@ -93,6 +106,7 @@ static void put_compound_page(struct page *page)
>>                               /* __split_huge_page_refcount run before us */
>>                               compound_unlock_irqrestore(page_head, flags);
>>                               VM_BUG_ON(PageHead(page_head));
>
> Hmmm hmmm while reviewing this one, I've been thinking maybe the head
> page after the hugepage split, could have been freed and reallocated
> as order 1 or 2, and legitimately become an head page again.
>
> The whole point of the bug-on is that it cannot be reallocated as a
> THP beause the tail is still there and it's not free yet, but it
> doesn't take into account the head page could be allocated as a
> compound page of a smaller size and maybe the tail is the last subpage
> of the thp.
>
> So there's the risk of a false positive, in an extremely unlikely case
> (the fact slab goes in unmovable pageblocks and thp goes in movable
> further decreases the probability). All production kernels runs with
> VM_BUG_ON disabled so it's a very small concern, but maybe we should
> delete it. It has never triggered, just code reivew. Do you agree?
>
right, I will delete it.

>> +                     skip_lock:
>>                               if (put_page_testzero(page_head))
>>                                       __put_single_page(page_head);
>>                       out_put_single:
>> @@ -115,6 +129,8 @@ static void put_compound_page(struct page *page)
>>                       VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
>>                       VM_BUG_ON(atomic_read(&page->_count) != 0);
>>                       compound_unlock_irqrestore(page_head, flags);
>> +
>> +                     skip_lock_tail:
>>                       if (put_page_testzero(page_head)) {
>>                               if (PageHead(page_head))
>>                                       __put_compound_page(page_head);
>> @@ -162,6 +178,15 @@ bool __get_page_tail(struct page *page)
>>       struct page *page_head = compound_trans_head(page);
>>
>>       if (likely(page != page_head && get_page_unless_zero(page_head))) {
>> +
>> +             if (PageSlab(page_head)) {
>> +                     if (likely(PageTail(page))) {
>> +                             __get_page_tail_foll(page, false);
>> +                             return true;
>> +                     } else
>> +                             goto out;
>> +             }
>> +
>
> A comment here too would be nice.
>
>>               /*
>>                * page_head wasn't a dangling pointer but it
>>                * may not be a head page anymore by the time
>> @@ -175,6 +200,8 @@ bool __get_page_tail(struct page *page)
>>                       got = true;
>>               }
>>               compound_unlock_irqrestore(page_head, flags);
>> +
>> +             out:
>>               if (unlikely(!got))
>>                       put_page(page_head);
>
> out could go in the line below. Assuming we don't want to be cleaner
> and use put_page above instead of goto, that would also drop a branch
> probably (the goto place is such a slow path). I'm fine either ways.
>
> It's not the cleanest of the patches but it's clearly a performance
> tweak.
>
ok, I will post revised patch.
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
>
> Thanks,
> Andrea
