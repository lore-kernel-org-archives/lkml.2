Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0KYP72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:59:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53588 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0KYP71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:59:27 -0500
MIME-Version: 1.0
In-Reply-To: <20101125011848.GB29511@hostway.ca>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
	<AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	<1290529171.2390.7994.camel@nimitz>
	<AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
	<AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
	<AANLkTimo1BR=mSJ6wPQwrL4FDNv=_TfanPPTT7uWx7hQ@mail.gmail.com>
	<AANLkTi=yV02oY5AmNAYr+ZF0RUgVv8gkeP+D9_CcOfLi@mail.gmail.com>
	<20101125011848.GB29511@hostway.ca>
Date: Thu, 25 Nov 2010 16:59:25 +0100
Message-ID: <AANLkTi=V55NMaTejNnnmY8KCfWDmMvJ-rh-wJ_8ixNnf@mail.gmail.com>
Subject: Re: Sudden and massive page cache eviction
From: =?UTF-8?Q?Peter_Sch=C3=BCller?= <scode@spotify.com>
To: Simon Kirby <sim@hostway.ca>
Cc: Pekka Enberg <penberg@kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your page cache dents don't seem quite as big, so it may be something
> else, but if it's the same problem we're seeing here, it seems to have to
> do with when an order=3 new_slab allocation comes in to grows the kmalloc
> slab cache for an __alloc_skb (network packet).  This is normal even
> without jumbo frames now.  When there are no zones with order=3
> zone_watermark_ok(), kswapd is woken, which frees things all over the
> place to try to get zone_watermark_ok(order=3) to be happy.
> We're seeing this throw out a huge number of pages, and we're seeing it
> happen even with lots of memory free in the zone.

Is there some way to observe this directly (the amount evicted for low
watermark reasons)?

If not, is logging/summing the return value of balance_pgdat() in
kswapd() (mm/vmscan.c) be the way to accomplish this?

My understanding (and I am saying it just so that people can tell my
if I'm wrong) is that what you're saying implies that kswapd keeps
getting woken up in wakeup_kswapd() due to zone_watermark_ok(), but
kswapd()'s invocation of balance_pgdat() is unable to bring levels
above the low water mark but but evicted large amounts of data while
trying?

> I reimplemented zone_pages_ok(order=3) in userspace, and I can see it
> happen:

(For the ML record/others: I believe that was meant to be
zone_watermark_ok(), not zone_pages_ok(). It's in mm/page_alloc.c)

> Code here: http://0x.ca/sim/ref/2.6.36/buddyinfo_scroll

[snip output]

> So, kswapd was woken up at the line that ends in "!!!" there, because
> free_pages(249) <= min(256), and so zone_watermark_ok() returned 0, when
> an order=3 allocation came in.
>
> Maybe try out that script and see if you see something similar.

Thanks! That looks great. I'll try to set up data collection where
this can be observed and then correlated with a graph and the
vmstat/slabinfo that I just posted, the next time we see an eviction.

(For the record it triggers constantly on my desktop, but that is with
2.6.32 and I'm assuming it is due to differences in that kernel, so
I'm not bothering investigating. It's not triggering constantly on the
2.6.26-rc6 kernel on the production system, and hopefully we can see
it trigger during the evictions.)

-- 
/ Peter Schuller aka scode
