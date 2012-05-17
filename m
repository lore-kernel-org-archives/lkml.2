Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080Ab2EQVZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:25:19 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:55168 "HELO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759935Ab2EQVZO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120517004434.GX19697@redhat.com>
References: <1337020877-20087-1-git-send-email-pshelar@nicira.com>
	<20120517004434.GX19697@redhat.com>
Date: Thu, 17 May 2012 14:25:11 -0700
Message-ID: <CALnjE+oNQ6ny2EnyExz3UuetXRD8gQwa5rN8tGdSff9g78FY0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix slab->page flags corruption.
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

On Wed, May 16, 2012 at 5:44 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hi Pravin,
>
> On Mon, May 14, 2012 at 11:41:17AM -0700, Pravin B Shelar wrote:
>> Transparent huge pages can change page->flags (PG_compound_lock)
>> without taking Slab lock. Since THP can not break slab pages we can
>> safely access compound page without taking compound lock.
>>
>> Specificly this patch fixes race between compound_unlock and slab
>> functions which does page-flags update. This can occur when
>> get_page/put_page is called on page from slab object.
>
> DMA on slab running put_page concurrently with kmem_cache_free/kfree
> was unexpected. Is this the scenario where the race happens, right?
>
I have seen slab pages passed for DMA in many instances, e.g. in xfs, ocfs, etc.

>> diff --git a/mm/swap.c b/mm/swap.c
>> index 8ff73d8..d4eb9f6 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -82,6 +82,16 @@ static void put_compound_page(struct page *page)
>>               if (likely(page != page_head &&
>>                          get_page_unless_zero(page_head))) {
>>                       unsigned long flags;
>> +
>> +                     if (PageSlab(page_head)) {
>> +                             /* THP can not break up slab pages, avoid
>> +                              * taking compound_lock(). */
>> +                             if (put_page_testzero(page_head))
>> +                                     VM_BUG_ON(1);
>> +
>> +                             atomic_dec(&page->_mapcount);
>> +                             goto skip_lock;
>> +                     }
>
> If a THP is splitted before get_page_unless_zero runs, the head page
> may be then freed and reallocated as slab. The "page" then should not
> be freed as a tail page anymore, because it's not a tail page. The
> head just accidentally become a slab (maybe not even a compound slab).
>
> To avoid such scenario this should be enough:
>
>     if (PageSlab(page_head) && PageTail(page)) {
>     ...
>     }
>

right, I will send updated patch.

Thanks,
Pravin.
