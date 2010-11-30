Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0K3GSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 01:18:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52033 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0K3GSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 01:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FAcFzBsp5IEgk9poykC+QAuRV2SjptzuHEB4OleNjqxoiDoifCNER0GMpTKzHliqPh
         8m83cVvMuVqeQ2v/uotj5D3kp8sYkkJyVYG5qTHGxkzTlJ149b/GX6VBlaG9LvvmCmzU
         53DO6WC8Hp/At/fzh/8R1/OAfxgtKT0hykHxY=
MIME-Version: 1.0
In-Reply-To: <20101130052204.GB15564@cmpxchg.org>
References: <cover.1291043273.git.minchan.kim@gmail.com>
	<6e01d81a4b575dcaaacc6b3782c505103e024085.1291043274.git.minchan.kim@gmail.com>
	<20101130052204.GB15564@cmpxchg.org>
Date: Tue, 30 Nov 2010 15:18:41 +0900
Message-ID: <AANLkTikUq60GmqaUNSB8ipxG-+ezu8PYrdokAuAWQs1s@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] deactivate invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Tue, Nov 30, 2010 at 2:22 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Nov 30, 2010 at 12:23:19AM +0900, Minchan Kim wrote:
>> Recently, there are reported problem about thrashing.
>> (http://marc.info/?l=rsync&m=128885034930933&w=2)
>> It happens by backup workloads(ex, nightly rsync).
>> That's because the workload makes just use-once pages
>> and touches pages twice. It promotes the page into
>> active list so that it results in working set page eviction.
>>
>> Some app developer want to support POSIX_FADV_NOREUSE.
>> But other OSes don't support it, either.
>> (http://marc.info/?l=linux-mm&m=128928979512086&w=2)
>>
>> By other approach, app developers use POSIX_FADV_DONTNEED.
>> But it has a problem. If kernel meets page is writing
>> during invalidate_mapping_pages, it can't work.
>> It is very hard for application programmer to use it.
>> Because they always have to sync data before calling
>> fadivse(..POSIX_FADV_DONTNEED) to make sure the pages could
>> be discardable. At last, they can't use deferred write of kernel
>> so that they could see performance loss.
>> (http://insights.oetiker.ch/linux/fadvise.html)
>>
>> In fact, invalidation is very big hint to reclaimer.
>> It means we don't use the page any more. So let's move
>> the writing page into inactive list's head.
>>
>> Why I need the page to head, Dirty/Writeback page would be flushed
>> sooner or later. It can prevent writeout of pageout which is less
>> effective than flusher's writeout.
>>
>> Originally, I reused lru_demote of Peter with some change so added
>> his Signed-off-by.
>>
>> Reported-by: Ben Gamari <bgamari.foss@gmail.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Nick Piggin <npiggin@kernel.dk>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>>
>> Adnrew. Before applying this series, please drop below two patches.
>>  mm-deactivate-invalidated-pages.patch
>>  mm-deactivate-invalidated-pages-fix.patch
>>
>> Changelog since v2:
>>  - mapped page leaves alone - suggested by Mel
>>  - pass part related PG_reclaim in next patch.
>>
>> Changelog since v1:
>>  - modify description
>>  - correct typo
>>  - add some comment
>> ---
>>  include/linux/swap.h |    1 +
>>  mm/swap.c            |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  mm/truncate.c        |   16 +++++++--
>>  3 files changed, 93 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index eba53e7..84375e4 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>
> [...]
>
>> @@ -267,6 +270,63 @@ void add_page_to_unevictable_list(struct page *page)
>>  }
>>
>>  /*
>> + * This function is used by invalidate_mapping_pages.
>> + * If the page can't be invalidated, this function moves the page
>> + * into inative list's head. Because the VM expects the page would
>> + * be writeout by flusher. The flusher's writeout is much effective
>> + * than reclaimer's random writeout.
>
> The wording is a bit confusing, I find.  It sounds a bit like the
> flusher's chance is increased by moving it to the inactive list in the
> first place, but the key is that it is moved to the head instead of,
> what one would expect, the tail of the list.  How about:
>
>        If the page can not be invalidated, it is moved to the
>        inactive list to speed up its reclaim.  It is moved to the
>        head of the list, rather than the tail, to give the flusher
>        threads some time to write it out, as this is much more
>        effective than the single-page writeout from reclaim.
>

Looks good to me.
I will add your comment instead of my ugly comment.

>> +static void __lru_deactivate(struct page *page, struct zone *zone)
>
> Do you insist on the underscores? :)

Good point.

__lru_deactivate is self-contained.
It is valuable enough using other places.
I will remove underscores.

>
>> +{
>> +     int lru, file;
>> +     unsigned long vm_flags;
>> +
>> +     if (!PageLRU(page) || !PageActive(page))
>> +             return;
>> +
>> +     /* Some processes are using the page */
>> +     if (page_mapped(page))
>> +             return;
>> +
>> +     file = page_is_file_cache(page);
>> +     lru = page_lru_base_type(page);
>> +     del_page_from_lru_list(zone, page, lru + LRU_ACTIVE);
>> +     ClearPageActive(page);
>> +     ClearPageReferenced(page);
>> +     add_page_to_lru_list(zone, page, lru);
>> +     __count_vm_event(PGDEACTIVATE);
>> +
>> +     update_page_reclaim_stat(zone, page, file, 0);
>> +}
>> +
>> +/*
>> + * This function must be called with preemption disable.
>
> Why is that?  Unless I missed something, the only thing that needs
> protection is the per-cpu pagevec reference the only user of this
> function passes in.  But this should be the caller's concern and is
> not really a requirement of this function per-se, is it?

Yes. It's unnecessary.
I didn't consider enoughly.
Will fix.

>
>> +static void __pagevec_lru_deactivate(struct pagevec *pvec)
>
> More underscores!

Will fix.

>
>> +{
>> +     int i;
>> +     struct zone *zone = NULL;
>> +
>> +     for (i = 0; i < pagevec_count(pvec); i++) {
>> +             struct page *page = pvec->pages[i];
>> +             struct zone *pagezone = page_zone(page);
>> +
>> +             if (pagezone != zone) {
>> +                     if (zone)
>> +                             spin_unlock_irq(&zone->lru_lock);
>> +                     zone = pagezone;
>> +                     spin_lock_irq(&zone->lru_lock);
>> +             }
>> +             __lru_deactivate(page, zone);
>> +     }
>> +     if (zone)
>> +             spin_unlock_irq(&zone->lru_lock);
>> +
>> +     release_pages(pvec->pages, pvec->nr, pvec->cold);
>> +     pagevec_reinit(pvec);
>> +}
>> +
>> +/*
>>   * Drain pages out of the cpu's pagevecs.
>>   * Either "cpu" is the current CPU, and preemption has already been
>>   * disabled; or "cpu" is being hot-unplugged, and is already dead.
>> @@ -292,6 +352,26 @@ static void drain_cpu_pagevecs(int cpu)
>>               pagevec_move_tail(pvec);
>>               local_irq_restore(flags);
>>       }
>> +
>> +     pvec = &per_cpu(lru_deactivate_pvecs, cpu);
>> +     if (pagevec_count(pvec))
>> +             __pagevec_lru_deactivate(pvec);
>> +}
>> +
>> +/*
>> + * Forcefully deactivate a page.
>> + * This function is used for reclaiming the page ASAP when the page
>> + * can't be invalidated by Dirty/Writeback.
>
> How about:
>
> /**
>  * lru_deactivate_page - forcefully deactivate a page
>  * @page: page to deactivate
>  *
>  * This function hints the VM that @page is a good reclaim candidate,
>  * for example if its invalidation fails due to the page being dirty
>  * or under writeback.
>  */
>
>> +void lru_deactivate_page(struct page *page)
>
> I would love that lru_ prefix for most of the API in this file.  In
> fact, the file should probably be called lru.c.  But for now, can you
> keep the naming consistent and call it deactivate_page?

No matter. I can change it. but deactivate_page will be asymmetric
about that deactivate_page move active page into inactive
forcefully(two step) while activate_page does one step activation.
That's why I name it.

>
>> +     if (likely(get_page_unless_zero(page))) {
>> +             struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
>> +
>> +             if (!pagevec_add(pvec, page))
>> +                     __pagevec_lru_deactivate(pvec);
>> +             put_cpu_var(lru_deactivate_pvecs);
>> +     }
>>  }
>>
>>  void lru_add_drain(void)
>
> [...]
>
>> @@ -359,8 +360,15 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
>>                       if (lock_failed)
>>                               continue;
>>
>> -                     ret += invalidate_inode_page(page);
>> -
>> +                     ret = invalidate_inode_page(page);
>> +                     /*
>> +                      * If the page was dirty or under writeback we cannot
>> +                      * invalidate it now.  Move it to the head of the
>> +                      * inactive LRU for using deferred writeback of flusher.
>
> This would also be less confusing if it would say
>
>        Move it to the head of the inactive LRU (rather than the tail)
>        for using [...]
>
> But I am not sure that this detail is interesting at this point.  It
> would be more interesting to name the reasons for why the page is
> moved to the inactive list in the first place:
>
>        If the page is dirty or under writeback, we can not invalidate
>        it now.  But we assume that attempted invalidation is a hint
>        that the page is no longer of interest and try to speed up its
>        reclaim.
>

Will fix.
I hope listen you guys's opinions about [2/3], too. :)

Thanks, Hannes.

>> +                      */
>> +                     if (!ret)
>> +                             lru_deactivate_page(page);
>> +                     count += ret;
>>                       unlock_page(page);
>>                       if (next > end)
>>                               break;
>
>        Hannes
>



-- 
Kind regards,
Minchan Kim
