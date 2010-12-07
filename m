Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0LGBcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:32:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43299 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0LGBcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:32:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b4ZPJSf2S21QeSIPNVfhtoApv8jwSapDLQ4y/JrysWC4NfcBMZUw+4XYSFrf36hyJ/
         3s7t2V5AtTdjte9fR/USo+VM9p7Qv1lVtI3GVghj05JZTLfFSClPo89JkSZmcLyn6N7W
         OZe9jOdL/96a7LIBHsue821HGafn0D9RhN538=
MIME-Version: 1.0
In-Reply-To: <20101206105558.GA21406@csn.ul.ie>
References: <1291376734-30202-1-git-send-email-mel@csn.ul.ie>
	<1291376734-30202-2-git-send-email-mel@csn.ul.ie>
	<AANLkTi=ZXBXS2m0WCTNWT1t6EFi=Vji5t-yQG=fTJQgs@mail.gmail.com>
	<20101206105558.GA21406@csn.ul.ie>
Date: Tue, 7 Dec 2010 10:32:45 +0900
Message-ID: <AANLkTimvmbvZ-9RcLsefTqbq1ktm6=-XD1N6z4JHBh=v@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm: kswapd: Stop high-order balancing when any
 suitable zone is balanced
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 7:55 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Mon, Dec 06, 2010 at 08:35:18AM +0900, Minchan Kim wrote:
>> Hi Mel,
>>
>> On Fri, Dec 3, 2010 at 8:45 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > When the allocator enters its slow path, kswapd is woken up to balance the
>> > node. It continues working until all zones within the node are balanced. For
>> > order-0 allocations, this makes perfect sense but for higher orders it can
>> > have unintended side-effects. If the zone sizes are imbalanced, kswapd may
>> > reclaim heavily within a smaller zone discarding an excessive number of
>> > pages. The user-visible behaviour is that kswapd is awake and reclaiming
>> > even though plenty of pages are free from a suitable zone.
>> >
>> > This patch alters the "balance" logic for high-order reclaim allowing kswapd
>> > to stop if any suitable zone becomes balanced to reduce the number of pages
>> > it reclaims from other zones. kswapd still tries to ensure that order-0
>> > watermarks for all zones are met before sleeping.
>> >
>> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>>
>> <snip>
>>
>> > -       if (!all_zones_ok) {
>> > +       if (!(all_zones_ok || (order && any_zone_ok))) {
>> >                cond_resched();
>> >
>> >                try_to_freeze();
>> > @@ -2361,6 +2366,31 @@ out:
>> >                goto loop_again;
>> >        }
>> >
>> > +       /*
>> > +        * If kswapd was reclaiming at a higher order, it has the option of
>> > +        * sleeping without all zones being balanced. Before it does, it must
>> > +        * ensure that the watermarks for order-0 on *all* zones are met and
>> > +        * that the congestion flags are cleared
>> > +        */
>> > +       if (order) {
>> > +               for (i = 0; i <= end_zone; i++) {
>> > +                       struct zone *zone = pgdat->node_zones + i;
>> > +
>> > +                       if (!populated_zone(zone))
>> > +                               continue;
>> > +
>> > +                       if (zone->all_unreclaimable && priority != DEF_PRIORITY)
>> > +                               continue;
>> > +
>> > +                       zone_clear_flag(zone, ZONE_CONGESTED);
>>
>> Why clear ZONE_CONGESTED?
>> If you have a cause, please, write down the comment.
>>
>
> It's because kswapd is the only mechanism that clears the congestion
> flag. If it's not cleared and kswapd goes to sleep, the flag could be
> left set causing hard-to-diagnose stalls. I'll add a comment.

Seems good.

>
>> <snip>
>>
>> First impression on this patch is that it changes scanning behavior as
>> well as reclaiming on high order reclaim.
>
> It does affect scanning behaviour for high-order reclaim. Specifically,
> it may stop scanning once a zone is balanced within the node. Previously
> it would continue scanning until all zones were balanced. Is this what
> you are thinking of or something else?

Yes. I mean page aging of high zones.

>
>> I can't say old behavior is right but we can't say this behavior is
>> right, too although this patch solves the problem. At least, we might
>> need some data that shows this patch doesn't have a regression.
>
> How do you suggest it be tested and this data be gathered? I tested a number of
> workloads that keep kswapd awake but found no differences of major significant
> even though it was using high-order allocations. The  problem with identifying
> small regressions for high-order allocations is that the state of the system
> when lumpy reclaim starts is very important as it determines how much work
> has to be done. I did not find major regressions in performance.
>
> For the tests I did run;
>
> fsmark showed nothing useful. iozone showed nothing useful either as it didn't
> even wake kswapd. sysbench showed minor performance gains and losses but it
> is not useful as it typically does not wake kswapd unless the database is
> badly configured.
>
> I ran postmark because it was the closest benchmark to a mail simulator I
> had access to. This sucks because it's no longer representative of a mail
> server and is more like a crappy filesystem benchmark. To get it closer to a
> real server, there was also a program running in the background that mapped
> a large anonymous segment and scanned it in blocks.
>
> POSTMARK
>            postmark-traceonly-v3r1-postmarkpostmark-kanyzone-v2r6-postmark
>                traceonly-v3r1     kanyzone-v2r6
> Transactions per second:                2.00 ( 0.00%)     2.00 ( 0.00%)
> Data megabytes read per second:         8.14 ( 0.00%)     8.59 ( 5.24%)
> Data megabytes written per second:     18.94 ( 0.00%)    19.98 ( 5.21%)
> Files created alone per second:         4.00 ( 0.00%)     4.00 ( 0.00%)
> Files create/transact per second:       1.00 ( 0.00%)     1.00 ( 0.00%)
> Files deleted alone per second:        34.00 ( 0.00%)    30.00 (-13.33%)

Do you know the reason only file deletion has a big regression?

> Files delete/transact per second:       1.00 ( 0.00%)     1.00 ( 0.00%)
>
> MMTests Statistics: duration
> User/Sys Time Running Test (seconds)         152.4    152.92
> Total Elapsed Time (seconds)               5110.96   4847.22
>
> FTrace Reclaim Statistics: vmscan
>            postmark-traceonly-v3r1-postmarkpostmark-kanyzone-v2r6-postmark
>                traceonly-v3r1     kanyzone-v2r6
> Direct reclaims                                  0          0
> Direct reclaim pages scanned                     0          0
> Direct reclaim pages reclaimed                   0          0
> Direct reclaim write file async I/O              0          0
> Direct reclaim write anon async I/O              0          0
> Direct reclaim write file sync I/O               0          0
> Direct reclaim write anon sync I/O               0          0
> Wake kswapd requests                             0          0
> Kswapd wakeups                                2177       2174
> Kswapd pages scanned                      34690766   34691473

Perhaps, in your workload, any_zone is highest zone.
If any_zone became low zone, kswapd pages scanned would have a big
difference because old behavior try to balance all zones.
Could we evaluate this situation? but I have no idea how we set up the
situation. :(

> Kswapd pages reclaimed                    34511965   34513478
> Kswapd reclaim write file async I/O             32          0
> Kswapd reclaim write anon async I/O           2357       2561
> Kswapd reclaim write file sync I/O               0          0
> Kswapd reclaim write anon sync I/O               0          0
> Time stalled direct reclaim (seconds)         0.00       0.00
> Time kswapd awake (seconds)                 632.10     683.34
>
> Total pages scanned                       34690766  34691473
> Total pages reclaimed                     34511965  34513478
> %age total pages scanned/reclaimed          99.48%    99.49%
> %age total pages scanned/written             0.01%     0.01%
> %age  file pages scanned/written             0.00%     0.00%
> Percentage Time Spent Direct Reclaim         0.00%     0.00%
> Percentage Time kswapd Awake                12.37%    14.10%

Is "kswapd Awake" correct?
AFAIR, In your implementation, you seems to account kswapd time even
though kswapd are schedule out.
I mean, for example,

kswapd
-> time stamp start
-> balance_pgdat
-> cond_resched(kswapd schedule out)
-> app 1 start
-> app 2 start
-> kswapd schedule in
-> time stamp end.

If it's right, kswapd awake doesn't have a big meaning.

>
> proc vmstat: Faults
>            postmark-traceonly-v3r1-postmarkpostmark-kanyzone-v2r6-postmark
>                traceonly-v3r1     kanyzone-v2r6
> Major Faults                                  1979      1741
> Minor Faults                              13660834  13587939
> Page ins                                     89060     74704
> Page outs                                    69800     58884
> Swap ins                                      1193      1499
> Swap outs                                     2403      2562
>
> Still, IO performance was improved (higher rates of read/write) and the test
> completed significantly faster with this patch series applied.  kswapd was
> awake for longer and reclaimed marginally more pages with more swap-ins and

Longer wake may be due to wrong gathering of time as I said.

> swap-outs which is unfortunate but it's somewhat balanced by fewer faults
> and fewer page-ins. Basically, in terms of reclaim the figures are so close
> that it is within the performance variations lumpy reclaim has depending on
> the exact state of the system when reclaim starts.

What I wanted to see is that when if zones above any_zone isn't aging
how it affect system performance.
This patch is changing balancing mechanism of kswapd so I think the
experiment is valuable.
I don't want to make contributors to be tired by bad reviewer.
What do you think about that?

>
>> It's
>> not easy but I believe you can do very well as like having done until
>> now. I didn't see whole series so I might miss something.
>>
>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Kind regards,
Minchan Kim
