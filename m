Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1EOW6E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:58:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33016 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1EOW6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jrpcQYf3h9TIU1qsVffomCGGCCNXd7cKDgRX+W3N0ES8/EJjuOl0pIWoNrrkG6jeK+
         GZVbubYw5zGfmRdHPY3JV+hRRbdC13irCRWCt73tLDfwESi7ocUcC6ZRmoUDIuTHtBxc
         JbJqf/gxidsY6/itO7pbV7aagcdnv0C01VG20=
MIME-Version: 1.0
In-Reply-To: <BANLkTinYGwRa_7uGzbYq+pW3T7jL-nQ7sA@mail.gmail.com>
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com>
	<m2fwokj0oz.fsf@firstfloor.org>
	<BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
	<20110512054631.GI6008@one.firstfloor.org>
	<BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
	<BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTinYGwRa_7uGzbYq+pW3T7jL-nQ7sA@mail.gmail.com>
Date: Mon, 16 May 2011 07:58:01 +0900
Message-ID: <BANLkTinEC1uhZRXjjn1PzENNs7KtGcoQow@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:59 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> I have no clue, but this patch (from Minchan, whitespace-damaged) seems to help:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f6b435c..4d24828 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_data_t
> *pgdat, int order, long remaining,
>       unsigned long balanced = 0;
>       bool all_zones_ok = true;
>
> +       /* If kswapd has been running too long, just sleep */
> +       if (need_resched())
> +               return false;
> +
>       /* If a direct reclaimer woke kswapd within HZ/10, it's premature */
>       if (remaining)
>               return true;
> @@ -2286,7 +2290,7 @@ static bool sleeping_prematurely(pg_data_t
> *pgdat, int order, long remaining,
>        * must be balanced
>        */
>       if (order)
> -               return pgdat_balanced(pgdat, balanced, classzone_idx);
> +               return !pgdat_balanced(pgdat, balanced, classzone_idx);
>       else
>               return !all_zones_ok;
>  }
>
> I haven't tested it very thoroughly, but it's survived much longer
> than an unpatched kernel probably would have under moderate use.
>
> I have no idea what the patch does :)

The reason I sent this is that I think your problem is similar to
recent Jame's one.
https://lkml.org/lkml/2011/4/27/361

What the patch does is [1] fix of "wrong pgdat_balanced return value"
bug and [2] fix of "infinite kswapd bug of non-preemption kernel" on
high-order page.

About [1], kswapd have to sleep if zone balancing is completed but in
1741c877[mm: kswapd: keep kswapd awake for high-order allocations
until a percentage of the node is balanced], we made a mistake that
returns wrong return.
Then, although we complete zone balancing, kswapd doesn't sleep and
calls balance_pgdat. In this case, balance_pgdat rerurns without any
work and kswapd could repeat this work infinitely.


>
> I'm happy to run any tests.  I'm also planning to upgrade from 2GB to
> 8GB RAM soon, which might change something.
>
> --Andy
>



-- 
Kind regards,
Minchan Kim
