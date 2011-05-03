Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1ECAtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:49:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58405 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1ECAtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sXh133U5ysNxAlLbdS9hFw371+o/Pvx/T340bjIUhP8vfDX0NQakJ4p4g++kCsT57q
         d6kl7ki6s3l+AGAhlgqWAmaqD6ggL0fNrl3ANcdhUXJNyHiTPUEYIvCgMCI5sWFBlfPN
         US7g+0WaGLyOjrONMdWnE7Y5SsJZaWK7PJ7yE=
MIME-Version: 1.0
In-Reply-To: <20110502102945.GA7688@localhost>
References: <20110426062535.GB19717@localhost>
	<BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
	<20110426063421.GC19717@localhost>
	<BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
	<20110426092029.GA27053@localhost>
	<20110426124743.e58d9746.akpm@linux-foundation.org>
	<20110428133644.GA12400@localhost>
	<20110429022824.GA8061@localhost>
	<20110430141741.GA4511@localhost>
	<20110501163542.GA3204@barrios-desktop>
	<20110502102945.GA7688@localhost>
Date: Tue, 3 May 2011 09:49:20 +0900
Message-ID: <BANLkTinXnhh5V0eH71=6PxZWpQxvti7QVw@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: cut down __GFP_NORETRY page allocation failures
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>,
        Li Shaohua <shaohua.li@intel.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu, Sorry for slow response.
I guess you know why I am slow. :)

On Mon, May 2, 2011 at 7:29 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Hi Minchan,
>
> On Mon, May 02, 2011 at 12:35:42AM +0800, Minchan Kim wrote:
>> Hi Wu,
>>
>> On Sat, Apr 30, 2011 at 10:17:41PM +0800, Wu Fengguang wrote:
>> > On Fri, Apr 29, 2011 at 10:28:24AM +0800, Wu Fengguang wrote:
>> > > > Test results:
>> > > >
>> > > > - the failure rate is pretty sensible to the page reclaim size,
>> > > >   from 282 (WMARK_HIGH) to 704 (WMARK_MIN) to 10496 (SWAP_CLUSTER_MAX)
>> > > >
>> > > > - the IPIs are reduced by over 100 times
>> > >
>> > > It's reduced by 500 times indeed.
>> > >
>> > > CAL:     220449     220246     220372     220558     220251     219740     220043     219968   Function call interrupts
>> > > CAL:         93        463        410        540        298        282        272        306   Function call interrupts
>> > >
>> > > > base kernel: vanilla 2.6.39-rc3 + __GFP_NORETRY readahead page allocation patch
>> > > > -------------------------------------------------------------------------------
>> > > > nr_alloc_fail 10496
>> > > > allocstall 1576602
>> > >
>> > > > patched (WMARK_MIN)
>> > > > -------------------
>> > > > nr_alloc_fail 704
>> > > > allocstall 105551
>> > >
>> > > > patched (WMARK_HIGH)
>> > > > --------------------
>> > > > nr_alloc_fail 282
>> > > > allocstall 53860
>> > >
>> > > > this patch (WMARK_HIGH, limited scan)
>> > > > -------------------------------------
>> > > > nr_alloc_fail 276
>> > > > allocstall 54034
>> > >
>> > > There is a bad side effect though: the much reduced "allocstall" means
>> > > each direct reclaim will take much more time to complete. A simple solution
>> > > is to terminate direct reclaim after 10ms. I noticed that an 100ms
>> > > time threshold can reduce the reclaim latency from 621ms to 358ms.
>> > > Further lowering the time threshold to 20ms does not help reducing the
>> > > real latencies though.
>> >
>> > Experiments going on...
>> >
>> > I tried the more reasonable terminate condition: stop direct reclaim
>> > when the preferred zone is above high watermark (see the below chunk).
>> >
>> > This helps reduce the average reclaim latency to under 100ms in the
>> > 1000-dd case.
>> >
>> > However nr_alloc_fail is around 5000 and not ideal. The interesting
>> > thing is, even if zone watermark is high, the task still may fail to
>> > get a free page..
>> >
>> > @@ -2067,8 +2072,17 @@ static unsigned long do_try_to_free_page
>> >                         }
>> >                 }
>> >                 total_scanned += sc->nr_scanned;
>> > -               if (sc->nr_reclaimed >= sc->nr_to_reclaim)
>> > -                       goto out;
>> > +               if (sc->nr_reclaimed >= min_reclaim) {
>> > +                       if (sc->nr_reclaimed >= sc->nr_to_reclaim)
>> > +                               goto out;
>> > +                       if (total_scanned > 2 * sc->nr_to_reclaim)
>> > +                               goto out;
>> > +                       if (preferred_zone &&
>> > +                           zone_watermark_ok_safe(preferred_zone, sc->order,
>> > +                                       high_wmark_pages(preferred_zone),
>> > +                                       zone_idx(preferred_zone), 0))
>> > +                               goto out;
>> > +               }
>> >
>> >                 /*
>> >                  * Try to write back as many pages as we just scanned.  This
>> >
>> > Thanks,
>> > Fengguang
>> > ---
>> > Subject: mm: cut down __GFP_NORETRY page allocation failures
>> > Date: Thu Apr 28 13:46:39 CST 2011
>> >
>> > Concurrent page allocations are suffering from high failure rates.
>> >
>> > On a 8p, 3GB ram test box, when reading 1000 sparse files of size 1GB,
>> > the page allocation failures are
>> >
>> > nr_alloc_fail 733     # interleaved reads by 1 single task
>> > nr_alloc_fail 11799   # concurrent reads by 1000 tasks
>> >
>> > The concurrent read test script is:
>> >
>> >       for i in `seq 1000`
>> >       do
>> >               truncate -s 1G /fs/sparse-$i
>> >               dd if=/fs/sparse-$i of=/dev/null &
>> >       done
>> >
>> > In order for get_page_from_freelist() to get free page,
>> >
>> > (1) try_to_free_pages() should use much higher .nr_to_reclaim than the
>> >     current SWAP_CLUSTER_MAX=32, in order to draw the zone out of the
>> >     possible low watermark state as well as fill the pcp with enough free
>> >     pages to overflow its high watermark.
>> >
>> > (2) the get_page_from_freelist() _after_ direct reclaim should use lower
>> >     watermark than its normal invocations, so that it can reasonably
>> >     "reserve" some free pages for itself and prevent other concurrent
>> >     page allocators stealing all its reclaimed pages.
>>
>> Do you see my old patch? The patch want't incomplet but it's not bad for showing an idea.
>> http://marc.info/?l=linux-mm&m=129187231129887&w=4
>> The idea is to keep a page at leat for direct reclaimed process.
>> Could it mitigate your problem or could you enhacne the idea?
>> I think it's very simple and fair solution.
>
> No it's not helping my problem, nr_alloc_fail and CAL are still high:

Unfortunately, my patch doesn't consider order-0 pages, as you mentioned below.
I read your mail which states it doesn't help although it considers
order-0 pages and drain.
Actually, I tried to look into that but in my poor system(core2duo, 2G
ram), nr_alloc_fail never happens. :(
I will try it in other desktop but I am not sure I can reproduce it.

>
> root@fat /home/wfg# ./test-dd-sparse.sh
> start time: 246
> total time: 531
> nr_alloc_fail 14097
> allocstall 1578332
> LOC:     542698     538947     536986     567118     552114     539605     541201     537623   Local timer interrupts
> RES:       3368       1908       1474       1476       2809       1602       1500       1509   Rescheduling interrupts
> CAL:     223844     224198     224268     224436     223952     224056     223700     223743   Function call interrupts
> TLB:        381         27         22         19         96        404        111         67   TLB shootdowns
>
> root@fat /home/wfg# getdelays -dip `pidof dd`
> print delayacct stats ON
> printing IO accounting
> PID     5202
>
>
> CPU             count     real total  virtual total    delay total
>                 1132     3635447328     3627947550   276722091605
> IO              count    delay total  delay average
>                    2      187809974             62ms
> SWAP            count    delay total  delay average
>                    0              0              0ms
> RECLAIM         count    delay total  delay average
>                 1334    35304580824             26ms
> dd: read=278528, write=0, cancelled_write=0
>
> I guess your patch is mainly fixing the high order allocations while
> my workload is mainly order 0 readahead page allocations. There are
> 1000 forks, however the "start time: 246" seems to indicate that the
> order-1 reclaim latency is not improved.

Maybe, 8K * 1000 isn't big footprint so I think reclaim doesn't happen.

>
> I'll try modifying your patch and see how it works out. The obvious
> change is to apply it to the order-0 case. Hope this won't create much
> more isolated pages.
>
> Attached is your patch rebased to 2.6.39-rc3, after resolving some
> merge conflicts and fixing a trivial NULL pointer bug.

Thanks!
I would like to see detail with it in my system if I can reproduce it.

>
>> >
>> > Some notes:
>> >
>> > - commit 9ee493ce ("mm: page allocator: drain per-cpu lists after direct
>> >   reclaim allocation fails") has the same target, however is obviously
>> >   costly and less effective. It seems more clean to just remove the
>> >   retry and drain code than to retain it.
>>
>> Tend to agree.
>> My old patch can solve it, I think.
>
> Sadly nope. See above.
>
>> >
>> > - it's a bit hacky to reclaim more than requested pages inside
>> >   do_try_to_free_page(), and it won't help cgroup for now
>> >
>> > - it only aims to reduce failures when there are plenty of reclaimable
>> >   pages, so it stops the opportunistic reclaim when scanned 2 times pages
>> >
>> > Test results:
>> >
>> > - the failure rate is pretty sensible to the page reclaim size,
>> >   from 282 (WMARK_HIGH) to 704 (WMARK_MIN) to 10496 (SWAP_CLUSTER_MAX)
>> >
>> > - the IPIs are reduced by over 100 times
>> >
>> > base kernel: vanilla 2.6.39-rc3 + __GFP_NORETRY readahead page allocation patch
>> > -------------------------------------------------------------------------------
>> > nr_alloc_fail 10496
>> > allocstall 1576602
>> >
>> > slabs_scanned 21632
>> > kswapd_steal 4393382
>> > kswapd_inodesteal 124
>> > kswapd_low_wmark_hit_quickly 885
>> > kswapd_high_wmark_hit_quickly 2321
>> > kswapd_skip_congestion_wait 0
>> > pageoutrun 29426
>> >
>> > CAL:     220449     220246     220372     220558     220251     219740     220043     219968   Function call interrupts
>> >
>> > LOC:     536274     532529     531734     536801     536510     533676     534853     532038   Local timer interrupts
>> > RES:       3032       2128       1792       1765       2184       1703       1754       1865   Rescheduling interrupts
>> > TLB:        189         15         13         17         64        294         97         63   TLB shootdowns
>> >
>> > patched (WMARK_MIN)
>> > -------------------
>> > nr_alloc_fail 704
>> > allocstall 105551
>> >
>> > slabs_scanned 33280
>> > kswapd_steal 4525537
>> > kswapd_inodesteal 187
>> > kswapd_low_wmark_hit_quickly 4980
>> > kswapd_high_wmark_hit_quickly 2573
>> > kswapd_skip_congestion_wait 0
>> > pageoutrun 35429
>> >
>> > CAL:         93        286        396        754        272        297        275        281   Function call interrupts
>> >
>> > LOC:     520550     517751     517043     522016     520302     518479     519329     517179   Local timer interrupts
>> > RES:       2131       1371       1376       1269       1390       1181       1409       1280   Rescheduling interrupts
>> > TLB:        280         26         27         30         65        305        134         75   TLB shootdowns
>> >
>> > patched (WMARK_HIGH)
>> > --------------------
>> > nr_alloc_fail 282
>> > allocstall 53860
>> >
>> > slabs_scanned 23936
>> > kswapd_steal 4561178
>> > kswapd_inodesteal 0
>> > kswapd_low_wmark_hit_quickly 2760
>> > kswapd_high_wmark_hit_quickly 1748
>> > kswapd_skip_congestion_wait 0
>> > pageoutrun 32639
>> >
>> > CAL:         93        463        410        540        298        282        272        306   Function call interrupts
>> >
>> > LOC:     513956     510749     509890     514897     514300     512392     512825     510574   Local timer interrupts
>> > RES:       1174       2081       1411       1320       1742       2683       1380       1230   Rescheduling interrupts
>> > TLB:        274         21         19         22         57        317        131         61   TLB shootdowns
>> >
>> > patched (WMARK_HIGH, limited scan)
>> > ----------------------------------
>> > nr_alloc_fail 276
>> > allocstall 54034
>> >
>> > slabs_scanned 24320
>> > kswapd_steal 4507482
>> > kswapd_inodesteal 262
>> > kswapd_low_wmark_hit_quickly 2638
>> > kswapd_high_wmark_hit_quickly 1710
>> > kswapd_skip_congestion_wait 0
>> > pageoutrun 32182
>> >
>> > CAL:         69        443        421        567        273        279        269        334   Function call interrupts
>>
>> Looks amazing.
>
> Yeah, I have strong feelings against drain_all_pages() in the direct
> reclaim path. The intuition is, once drain_all_pages() is called, the
> later on direct reclaims will have less chance to fill the drained
> buffers and therefore forced into drain_all_pages() again and again.
>
> drain_all_pages() is probably an overkill for preventing OOM.
> Generally speaking, it's questionable to "squeeze the last page before
> OOM".
>
> A typical desktop enters thrashing storms before OOM, as Hugh pointed
> out, this may well not the end users wanted. I agree with him and
> personally prefer some applications to be OOM killed rather than the
> whole system goes unusable thrashing like mad.

Tend to agree. The rule is applied to embedded system, too.
Couldn't we mitigate draining  just in case it is high order page.

>
>> > LOC:     514736     511698     510993     514069     514185     512986     513838     511229   Local timer interrupts
>> > RES:       2153       1556       1126       1351       3047       1554       1131       1560   Rescheduling interrupts
>> > TLB:        209         26         20         15         71        315        117         71   TLB shootdowns
>> >
>> > patched (WMARK_HIGH, limited scan, stop on watermark OK), 100 dd
>> > ----------------------------------------------------------------
>> >
>> > start time: 3
>> > total time: 50
>> > nr_alloc_fail 162
>> > allocstall 45523
>> >
>> > CPU             count     real total  virtual total    delay total
>> >                   921     3024540200     3009244668    37123129525
>> > IO              count    delay total  delay average
>> >                     0              0              0ms
>> > SWAP            count    delay total  delay average
>> >                     0              0              0ms
>> > RECLAIM         count    delay total  delay average
>> >                   357     4891766796             13ms
>> > dd: read=0, write=0, cancelled_write=0
>> >
>> > patched (WMARK_HIGH, limited scan, stop on watermark OK), 1000 dd
>> > -----------------------------------------------------------------
>> >
>> > start time: 272
>> > total time: 509
>> > nr_alloc_fail 3913
>> > allocstall 541789
>> >
>> > CPU             count     real total  virtual total    delay total
>> >                  1044     3445476208     3437200482   229919915202
>> > IO              count    delay total  delay average
>> >                     0              0              0ms
>> > SWAP            count    delay total  delay average
>> >                     0              0              0ms
>> > RECLAIM         count    delay total  delay average
>> >                   452    34691441605             76ms
>> > dd: read=0, write=0, cancelled_write=0
>> >
>> > patched (WMARK_HIGH, limited scan, stop on watermark OK, no time limit), 1000 dd
>> > --------------------------------------------------------------------------------
>> >
>> > start time: 278
>> > total time: 513
>> > nr_alloc_fail 4737
>> > allocstall 436392
>> >
>> >
>> > CPU             count     real total  virtual total    delay total
>> >                  1024     3371487456     3359441487   225088210977
>> > IO              count    delay total  delay average
>> >                     1      160631171            160ms
>> > SWAP            count    delay total  delay average
>> >                     0              0              0ms
>> > RECLAIM         count    delay total  delay average
>> >                   367    30809994722             83ms
>> > dd: read=20480, write=0, cancelled_write=0
>> >
>> >
>> > no cond_resched():
>>
>> What's this?
>
> I tried a modified patch that also removes the cond_resched() call in
> __alloc_pages_direct_reclaim(), between try_to_free_pages() and
> get_page_from_freelist(). It seems not helping noticeably.
>
> It looks safe to remove that cond_resched() as we already have such
> calls in shrink_page_list().

I tried similar thing but Andrew have a concern about it.
https://lkml.org/lkml/2011/3/24/138

>
>> >
>> > start time: 263
>> > total time: 516
>> > nr_alloc_fail 5144
>> > allocstall 436787
>> >
>> > CPU             count     real total  virtual total    delay total
>> >                  1018     3305497488     3283831119   241982934044
>> > IO              count    delay total  delay average
>> >                     0              0              0ms
>> > SWAP            count    delay total  delay average
>> >                     0              0              0ms
>> > RECLAIM         count    delay total  delay average
>> >                   328    31398481378             95ms
>> > dd: read=0, write=0, cancelled_write=0
>> >
>> > zone_watermark_ok_safe():
>> >
>> > start time: 266
>> > total time: 513
>> > nr_alloc_fail 4526
>> > allocstall 440246
>> >
>> > CPU             count     real total  virtual total    delay total
>> >                  1119     3640446568     3619184439   240945024724
>> > IO              count    delay total  delay average
>> >                     3      303620082            101ms
>> > SWAP            count    delay total  delay average
>> >                     0              0              0ms
>> > RECLAIM         count    delay total  delay average
>> >                   372    27320731898             73ms
>> > dd: read=77824, write=0, cancelled_write=0
>> >
>
>> > start time: 275
>>
>> What's meaing of start time?
>
> It's the time taken to start 1000 dd's.
>
>> > total time: 517
>>
>> Total time is elapsed time on your experiment?
>
> Yeah. They are generated with this script.
>
> $ cat ~/bin/test-dd-sparse.sh
>
> #!/bin/sh
>
> mount /dev/sda7 /fs
>
> tic=$(date +'%s')
>
> for i in `seq 1000`
> do
>        truncate -s 1G /fs/sparse-$i
>        dd if=/fs/sparse-$i of=/dev/null &>/dev/null &
> done
>
> tac=$(date +'%s')
> echo start time: $((tac-tic))
>
> wait
>
> tac=$(date +'%s')
> echo total time: $((tac-tic))
>
> egrep '(nr_alloc_fail|allocstall)' /proc/vmstat
> egrep '(CAL|RES|LOC|TLB)' /proc/interrupts
>
>> > nr_alloc_fail 4694
>> > allocstall 431021
>> >
>> >
>> > CPU             count     real total  virtual total    delay total
>> >                  1073     3534462680     3512544928   234056498221
>>
>> What's meaning of CPU fields?
>
> It's "waiting for a CPU (while being runnable)" as described in
> Documentation/accounting/delay-accounting.txt.

Thanks

>
>> > IO              count    delay total  delay average
>> >                     0              0              0ms
>> > SWAP            count    delay total  delay average
>> >                     0              0              0ms
>> > RECLAIM         count    delay total  delay average
>> >                   386    34751778363             89ms
>> > dd: read=0, write=0, cancelled_write=0
>> >
>>
>> Where is vanilla data for comparing latency?
>> Personally, It's hard to parse your data.
>
> Sorry it's somehow too much data and kernel revisions.. The base kernel's
> average latency is 29ms:
>
> base kernel: vanilla 2.6.39-rc3 + __GFP_NORETRY readahead page allocation patch
> -------------------------------------------------------------------------------
>
> CPU             count     real total  virtual total    delay total
>                 1122     3676441096     3656793547   274182127286
> IO              count    delay total  delay average
>                    3      291765493             97ms
> SWAP            count    delay total  delay average
>                    0              0              0ms
> RECLAIM         count    delay total  delay average
>                 1350    39229752193             29ms
> dd: read=45056, write=0, cancelled_write=0
>
> start time: 245
> total time: 526
> nr_alloc_fail 14586
> allocstall 1578343
> LOC:     533981     529210     528283     532346     533392     531314     531705     528983   Local timer interrupts
> RES:       3123       2177       1676       1580       2157       1974       1606       1696   Rescheduling interrupts
> CAL:     218392     218631     219167     219217     218840     218985     218429     218440   Function call interrupts
> TLB:        175         13         21         18         62        309        119         42   TLB shootdowns
>
>>
>> > CC: Mel Gorman <mel@linux.vnet.ibm.com>
>> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>> > ---
>> >  fs/buffer.c          |    4 ++--
>> >  include/linux/swap.h |    3 ++-
>> >  mm/page_alloc.c      |   20 +++++---------------
>> >  mm/vmscan.c          |   31 +++++++++++++++++++++++--------
>> >  4 files changed, 32 insertions(+), 26 deletions(-)
>> > --- linux-next.orig/mm/vmscan.c       2011-04-29 10:42:14.000000000 +0800
>> > +++ linux-next/mm/vmscan.c    2011-04-30 21:59:33.000000000 +0800
>> > @@ -2025,8 +2025,9 @@ static bool all_unreclaimable(struct zon
>> >   * returns:  0, if no pages reclaimed
>> >   *           else, the number of pages reclaimed
>> >   */
>> > -static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>> > -                                     struct scan_control *sc)
>> > +static unsigned long do_try_to_free_pages(struct zone *preferred_zone,
>> > +                                       struct zonelist *zonelist,
>> > +                                       struct scan_control *sc)
>> >  {
>> >       int priority;
>> >       unsigned long total_scanned = 0;
>> > @@ -2034,6 +2035,7 @@ static unsigned long do_try_to_free_page
>> >       struct zoneref *z;
>> >       struct zone *zone;
>> >       unsigned long writeback_threshold;
>> > +     unsigned long min_reclaim = sc->nr_to_reclaim;
>>
>> Hmm,
>>
>> >
>> >       get_mems_allowed();
>> >       delayacct_freepages_start();
>> > @@ -2041,6 +2043,9 @@ static unsigned long do_try_to_free_page
>> >       if (scanning_global_lru(sc))
>> >               count_vm_event(ALLOCSTALL);
>> >
>> > +     if (preferred_zone)
>> > +             sc->nr_to_reclaim += preferred_zone->watermark[WMARK_HIGH];
>> > +
>>
>> Hmm, I don't like this idea.
>> The goal of direct reclaim path is to reclaim pages asap, I beleive.
>> Many thing should be achieve of background kswapd.
>> If admin changes min_free_kbytes, it can affect latency of direct reclaim.
>> It doesn't make sense to me.
>
> Yeah, it does increase delays.. in the 1000 dd case, roughly from 30ms
> to 90ms. This is a major drawback.

Yes.

>
>> >       for (priority = DEF_PRIORITY; priority >= 0; priority--) {
>> >               sc->nr_scanned = 0;
>> >               if (!priority)
>> > @@ -2067,8 +2072,17 @@ static unsigned long do_try_to_free_page
>> >                       }
>> >               }
>> >               total_scanned += sc->nr_scanned;
>> > -             if (sc->nr_reclaimed >= sc->nr_to_reclaim)
>> > -                     goto out;
>> > +             if (sc->nr_reclaimed >= min_reclaim) {
>> > +                     if (sc->nr_reclaimed >= sc->nr_to_reclaim)
>> > +                             goto out;
>>
>> I can't understand the logic.
>> if nr_reclaimed is bigger than min_reclaim, it's always greater than
>> nr_to_reclaim. What's meaning of min_reclaim?
>
> In direct reclaim, min_reclaim will be the legacy SWAP_CLUSTER_MAX and
> sc->nr_to_reclaim will be increased to the zone's high watermark and
> is kind of "max to reclaim".
>
>>
>> > +                     if (total_scanned > 2 * sc->nr_to_reclaim)
>> > +                             goto out;
>>
>> If there are lots of dirty pages in LRU?
>> If there are lots of unevictable pages in LRU?
>> If there are lots of mapped page in LRU but may_unmap = 0 cases?
>> I means it's rather risky early conclusion.
>
> That test means to avoid scanning too much on __GFP_NORETRY direct
> reclaims. My assumption for __GFP_NORETRY is, it should fail fast when
> the LRU pages seem hard to reclaim. And the problem in the 1000 dd
> case is, it's all easy to reclaim LRU pages but __GFP_NORETRY still
> fails from time to time, with lots of IPIs that may hurt large
> machines a lot.

I don't have  enough time and a environment to test it.
So I can't make sure of it but my concern is a latency.
If you solve latency problem considering CPU scaling, I won't oppose it. :)



-- 
Kind regards,
Minchan Kim
