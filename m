Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0H3ASs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:18:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61244 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0H3ASr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CFOPcrrekJHRDJY1teUrZ6/yt2pAh4inoW7MVT7NScFVpjvb7UdcFpUb8dxDKerGyb
         /XIAUxSqzytF1D0AeHwRYsZq5xqxXv0fcSapPoAH+wHcsMD0Ef7AkJOhR1+q8eVeSnhR
         iiZq4G3jQ7V7ezvKMrq0vtngh86j5gLnSt8zI=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjVHp1=Fc35xLnyPb2aa+ew7w1P9DC_0GfhZgY@mail.gmail.com>
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
	<AANLkTinCKJw2oaNgAvfm0RawbW4zuJMtMb2pUROeY2ij@mail.gmail.com>
	<4C7ABD14.9050207@redhat.com>
	<AANLkTimjVHp1=Fc35xLnyPb2aa+ew7w1P9DC_0GfhZgY@mail.gmail.com>
Date: Mon, 30 Aug 2010 09:18:46 +0900
Message-ID: <AANLkTi==mQh31PzuNa1efH2WM1s-VPKyZX0f5iwb54PD@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ying,

On Mon, Aug 30, 2010 at 6:23 AM, Ying Han <yinghan@google.com> wrote:
> On Sun, Aug 29, 2010 at 1:03 PM, Rik van Riel <riel@redhat.com> wrote:
>> On 08/29/2010 01:45 PM, Ying Han wrote:
>>
>>> There are few other places in vmscan where we check nr_swap_pages and
>>> inactive_anon_is_low. Are we planning to change them to use
>>> total_swap_pages
>>> to be consistent ?
>>
>> If that makes sense, maybe the check can just be moved into
>> inactive_anon_is_low itself?
>
> That was the initial patch posted, instead we changed to use
> total_swap_pages instead. How this patch looks:
>
> @@ -1605,6 +1605,9 @@ static int inactive_anon_is_low(struct zone
> *zone, struct scan_control *sc)
>  {
>        int low;
>
> +       if (total_swap_pages <= 0)
> +               return 0;
> +
>        if (scanning_global_lru(sc))
>                low = inactive_anon_is_low_global(zone);
>        else
> @@ -1856,7 +1859,7 @@ static void shrink_zone(int priority, struct zone *zone,
>         * Even if we did not try to evict anon pages at all, we want to
>         * rebalance the anon lru active/inactive ratio.
>         */
> -       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
> +       if (inactive_anon_is_low(zone, sc))
>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>
>        throttle_vm_writeout(sc->gfp_mask);
>
> --Ying
>
>>

I did it intentionally since inactive_anon_is_low have been used both
direct reclaim and background path. In this point, your patch could
make side effect in swap enabled system when swap is full.

I think we need aging in only background if system is swap full.
That's because if the swap space is full, we don't reclaim anon pages
in direct reclaim path with (nr_swap_pages < 0)  and even have been
not rebalance it until now.
I think direct reclaim path is important about latency as well as
reclaim's effectiveness.
So if you don't mind, I hope direct reclaim patch would be left just as it is.

-- 
Kind regards,
Minchan Kim
