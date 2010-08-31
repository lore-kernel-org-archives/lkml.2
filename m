Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0HaBXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:23:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58970 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab0HaBXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eAqf86NlfyQH5eBClDJmn7CLiJOQBI99P6Ekx5ykVwTVLS3a6e8zPibn2ZpVOIcM4F
         1HamSYJPH5TNFEiAZiWw4+E6wVLUBYSr95ipwuRC5EDDc7LKhU+uhfh8+9uI7IyFFLpT
         CIQVdLpZqCJEFfRZPfI4sJk9KR+iZXNth65ZE=
MIME-Version: 1.0
In-Reply-To: <20100831095140.87C7.A69D9226@jp.fujitsu.com>
References: <AANLkTi==mQh31PzuNa1efH2WM1s-VPKyZX0f5iwb54PD@mail.gmail.com>
	<AANLkTinqm0o=AfmgFy+SpZ1mrdekRnjeXvs_7=OcLii8@mail.gmail.com>
	<20100831095140.87C7.A69D9226@jp.fujitsu.com>
Date: Tue, 31 Aug 2010 10:23:10 +0900
Message-ID: <AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 9:56 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Sun, Aug 29, 2010 at 5:18 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> > Hi Ying,
>> >
>> > On Mon, Aug 30, 2010 at 6:23 AM, Ying Han <yinghan@google.com> wrote:
>> >> On Sun, Aug 29, 2010 at 1:03 PM, Rik van Riel <riel@redhat.com> wrote:
>> >>> On 08/29/2010 01:45 PM, Ying Han wrote:
>> >>>
>> >>>> There are few other places in vmscan where we check nr_swap_pages and
>> >>>> inactive_anon_is_low. Are we planning to change them to use
>> >>>> total_swap_pages
>> >>>> to be consistent ?
>> >>>
>> >>> If that makes sense, maybe the check can just be moved into
>> >>> inactive_anon_is_low itself?
>> >>
>> >> That was the initial patch posted, instead we changed to use
>> >> total_swap_pages instead. How this patch looks:
>> >>
>> >> @@ -1605,6 +1605,9 @@ static int inactive_anon_is_low(struct zone
>> >> *zone, struct scan_control *sc)
>> >>  {
>> >>        int low;
>> >>
>> >> +       if (total_swap_pages <= 0)
>> >> +               return 0;
>> >> +
>> >>        if (scanning_global_lru(sc))
>> >>                low = inactive_anon_is_low_global(zone);
>> >>        else
>> >> @@ -1856,7 +1859,7 @@ static void shrink_zone(int priority, struct zone *zone,
>> >>         * Even if we did not try to evict anon pages at all, we want to
>> >>         * rebalance the anon lru active/inactive ratio.
>> >>         */
>> >> -       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>> >> +       if (inactive_anon_is_low(zone, sc))
>> >>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>> >>
>> >>        throttle_vm_writeout(sc->gfp_mask);
>> >>
>> >> --Ying
>> >>
>> >>>
>> >
>> > I did it intentionally since inactive_anon_is_low have been used both
>> > direct reclaim and background path. In this point, your patch could
>> > make side effect in swap enabled system when swap is full.
>> >
>> > I think we need aging in only background if system is swap full.
>> > That's because if the swap space is full, we don't reclaim anon pages
>> > in direct reclaim path with (nr_swap_pages < 0)  and even have been
>> > not rebalance it until now.
>> > I think direct reclaim path is important about latency as well as
>> > reclaim's effectiveness.
>> > So if you don't mind, I hope direct reclaim patch would be left just as it is.
>>
>> Minchan, I would prefer to make kswapd as well as direct reclaim to be
>> consistent if possible.
>> They both try to reclaim pages when system is under memory pressure,
>> and also do not make
>> much sense to look at anon lru if no swap space available. Either
>> because of no swapon or run
>> out of swap space.
>>
>> I think letting kswapd to age anon lru without free swap space is not
>> necessary neither. That leads
>> to my initial patch:
>>
>> @@ -1605,6 +1605,9 @@ static int inactive_anon_is_low(struct zone
>> *zone, struct scan_control *sc)
>>  {
>>        int low;
>>
>> +       if (nr_swap_pages <= 0)
>> +               return 0;
>> +
>>        if (scanning_global_lru(sc))
>>                low = inactive_anon_is_low_global(zone);
>>        else
>> @@ -1856,7 +1859,7 @@ static void shrink_zone(int priority, struct zone *zone,
>>         * Even if we did not try to evict anon pages at all, we want to
>>         * rebalance the anon lru active/inactive ratio.
>>         */
>> -       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>> +       if (inactive_anon_is_low(zone, sc))
>>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>>
>> What do you think ?
>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
>
> I think both Ying's and Minchan's opnion are right and makes sense.  however I _personally_
> like Ying version because 1) this version is simpler 2) swap full is very rarely event 3)
> no swap mounting is very common on HPC. so this version could have a chance to
> improvement hpc workload too.

I agree.

>
> In the other word, both avoiding unnecessary TLB flush and keeping proper page aging are
> performance matter. so when we are talking performance, we always need to think frequency
> of the event.

Ying's one and mine both has a same effect.
Only difference happens swap is full. My version maintains old
behavior but Ying's one changes the behavior. I admit swap full is
rare event but I hoped not changed old behavior if we doesn't find any
problem.
If kswapd does aging when swap full happens, is it a problem?
We have been used to it from 2.6.28.

If we regard a code consistency is more important than _unexpected_
result, Okay. I don't mind it. :)
But at least we should do more thing to make the patch to compile out
for non-swap configurable system.


>
> Anyway I'm very glad minchan who embedded developer pay attention server workload
> carefully. Very thanks.
>

Thanks for the good comment. KOSAKI. :)
-- 
Kind regards,
Minchan Kim
