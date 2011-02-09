Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1BIXXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:23:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab1BIXXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=usz+CLZZ1GKNU9xViMwMPj0ho92EOLsUvDOBnFKqLyJA4Ozs7oqlUy29AOuB/k1irO
         0zzl4aoE8ChD1t0GSEMhyz4Hke0UfSh/1IqyhLQCIp7LCb+iEJh4ThiPD9wzJ9bBy+Nr
         XJg39iydjGONS3PUeSpSPMx0+400cz8EJL0N4=
MIME-Version: 1.0
In-Reply-To: <20110209134754.d28f018c.akpm@linux-foundation.org>
References: <1297257677-12287-1-git-send-email-namhyung@gmail.com>
	<20110209123803.4bb6291c.akpm@linux-foundation.org>
	<20110209213338.GK27110@cmpxchg.org>
	<20110209134754.d28f018c.akpm@linux-foundation.org>
Date: Thu, 10 Feb 2011 08:23:08 +0900
Message-ID: <AANLkTimG5Qnz39dj_D3C0-Ty1CanpnaWHQbKzT4miMSa@mail.gmail.com>
Subject: Re: [PATCH] mm: batch-free pcp list if possible
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Namhyung Kim <namhyung@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 6:47 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 9 Feb 2011 22:33:38 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
>
>> On Wed, Feb 09, 2011 at 12:38:03PM -0800, Andrew Morton wrote:
>> > On Wed,  9 Feb 2011 22:21:17 +0900
>> > Namhyung Kim <namhyung@gmail.com> wrote:
>> >
>> > > free_pcppages_bulk() frees pages from pcp lists in a round-robin
>> > > fashion by keeping batch_free counter. But it doesn't need to spin
>> > > if there is only one non-empty list. This can be checked by
>> > > batch_free == MIGRATE_PCPTYPES.
>> > >
>> > > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> > > ---
>> > >  mm/page_alloc.c |    4 ++++
>> > >  1 files changed, 4 insertions(+), 0 deletions(-)
>> > >
>> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> > > index a873e61e312e..470fb42e303c 100644
>> > > --- a/mm/page_alloc.c
>> > > +++ b/mm/page_alloc.c
>> > > @@ -614,6 +614,10 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>> > >                   list = &pcp->lists[migratetype];
>> > >           } while (list_empty(list));
>> > >
>> > > +         /* This is an only non-empty list. Free them all. */
>> > > +         if (batch_free == MIGRATE_PCPTYPES)
>> > > +                 batch_free = to_free;
>> > > +
>> > >           do {
>> > >                   page = list_entry(list->prev, struct page, lru);
>> > >                   /* must delete as __free_one_page list manipulates */
>> >
>> > free_pcppages_bulk() hurts my brain.
>>
>> Thanks for saying that ;-)
>
> My brain has a lot of scar tissue.
>
>> > What is it actually trying to do, and why?  It counts up the number of
>> > contiguous empty lists and then frees that number of pages from the
>> > first-encountered non-empty list and then advances onto the next list?
>> >
>> > What's the point in that?  What relationship does the number of
>> > contiguous empty lists have with the number of pages to free from one
>> > list?
>>
>> It at least recovers some of the otherwise wasted effort of looking at
>> an empty list, by flushing more pages once it encounters a non-empty
>> list.  After all, freeing to_free pages is the goal.
>>
>> That breaks the round-robin fashion, though.  If list-1 has pages,
>> list-2 is empty and list-3 has pages, it will repeatedly free one page
>> from list-1 and two pages from list-3.
>>
>> My initial response to Namhyung's patch was to write up a version that
>> used a bitmap for all lists.  It starts with all lists set and clears
>> their respective bit once the list is empty, so it would never
>> consider them again.  But it looked a bit over-engineered for 3 lists
>> and the resulting object code was bigger than what we have now.
>> Though, it would be more readable.  Attached for reference (untested
>> and all).
>>
>>       Hannes
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 60e58b0..c77ab28 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -590,8 +590,7 @@ static inline int free_pages_check(struct page *page)
>>  static void free_pcppages_bulk(struct zone *zone, int count,
>>                                       struct per_cpu_pages *pcp)
>>  {
>> -     int migratetype = 0;
>> -     int batch_free = 0;
>> +     unsigned long listmap = (1 << MIGRATE_PCPTYPES) - 1;
>>       int to_free = count;
>>
>>       spin_lock(&zone->lock);
>> @@ -599,31 +598,29 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>>       zone->pages_scanned = 0;
>>
>>       while (to_free) {
>> -             struct page *page;
>> -             struct list_head *list;
>> -
>> +             int migratetype;
>>               /*
>> -              * Remove pages from lists in a round-robin fashion. A
>> -              * batch_free count is maintained that is incremented when an
>> -              * empty list is encountered.  This is so more pages are freed
>> -              * off fuller lists instead of spinning excessively around empty
>> -              * lists
>> +              * Remove pages from lists in a round-robin fashion.
>> +              * Empty lists are excluded from subsequent rounds.
>>                */
>> -             do {
>> -                     batch_free++;
>> -                     if (++migratetype == MIGRATE_PCPTYPES)
>> -                             migratetype = 0;
>> -                     list = &pcp->lists[migratetype];
>> -             } while (list_empty(list));
>> +             for_each_set_bit (migratetype, &listmap, MIGRATE_PCPTYPES) {
>> +                     struct list_head *list;
>> +                     struct page *page;
>>
>> -             do {
>> +                     list = &pcp->lists[migratetype];
>> +                     if (list_empty(list)) {
>> +                             listmap &= ~(1 << migratetype);
>> +                             continue;
>> +                     }
>> +                     if (!to_free--)
>> +                             break;
>>                       page = list_entry(list->prev, struct page, lru);
>>                       /* must delete as __free_one_page list manipulates */
>>                       list_del(&page->lru);
>>                       /* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
>>                       __free_one_page(page, zone, 0, page_private(page));
>>                       trace_mm_page_pcpu_drain(page, 0, page_private(page));
>> -             } while (--to_free && --batch_free && !list_empty(list));
>> +             }
>>       }
>>       __mod_zone_page_state(zone, NR_FREE_PAGES, count);
>>       spin_unlock(&zone->lock);
>
> Well, it replaces one linear search with another one.  If you really
> want to avoid repeated walking over empty lists then create a local
> array `list_head *lists[MIGRATE_PCPTYPES]' (or MIGRATE_PCPTYPES+1 for
> null-termination), populate it on entry and compact it as lists fall
> empty.  Then the code can simply walk around the lists until to_free is
> satisfied or list_empty(lists[0]).  It's not obviously worth the effort
> though - the empty list_heads will be cache-hot and all the cost will
> be in hitting cache-cold pageframes.

Hannes's patch solves round-robin fairness as well as avoidance of
empty list although it makes rather bloated code.
I think it's enough to solve the fairness regardless of whether it's
Hannes's approach or your idea.

>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kind regards,
Minchan Kim
