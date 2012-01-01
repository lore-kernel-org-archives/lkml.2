Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2AAHtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 02:49:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60554 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2AAHtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 02:49:15 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1325162352-24709-2-git-send-email-m.szyprowski@samsung.com>
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
	<1325162352-24709-2-git-send-email-m.szyprowski@samsung.com>
Date: Sun, 1 Jan 2012 09:49:13 +0200
Message-ID: <CAOtvUMeAVgDwRNsDTcG07ChYnAuNgNJjQ+sKALJ79=Ezikos-A@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm: page_alloc: set_migratetype_isolate: drain PCP
 prior to isolating
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 2:39 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> When set_migratetype_isolate() sets pageblock's migrate type, it does
> not change each page_private data.  This makes sense, as the function
> has no way of knowing what kind of information page_private stores.
...
>
>
> A side effect is that instead of draining pages from all zones,
> set_migratetype_isolate() now drain only pages from zone pageblock it
> operates on is in.
>
...


>
> +/* Caller must hold zone->lock. */
> +static void __zone_drain_local_pages(void *arg)
> +{
> +       struct per_cpu_pages *pcp;
> +       struct zone *zone = arg;
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       pcp = &per_cpu_ptr(zone->pageset, smp_processor_id())->pcp;
> +       if (pcp->count) {
> +               /* Caller holds zone->lock, no need to grab it. */
> +               __free_pcppages_bulk(zone, pcp->count, pcp);
> +               pcp->count = 0;
> +       }
> +       local_irq_restore(flags);
> +}
> +
> +/*
> + * Like drain_all_pages() but operates on a single zone.  Caller must
> + * hold zone->lock.
> + */
> +static void __zone_drain_all_pages(struct zone *zone)
> +{
> +       on_each_cpu(__zone_drain_local_pages, zone, 1);
> +}
> +

Please consider whether sending an IPI to all processors in the system
and interrupting them is appropriate here.

You seem to assume that it is probable that each CPU of the possibly
4,096 (MAXSMP on x86) has a per-cpu page
for the specified zone, otherwise you're just interrupting them out of
doing something useful, or save power idle
for nothing.

While that may or may not be a reasonable assumption for the general
drain_all_pages that drains pcps from
all zones, I feel it is less likely to be the right thing once you
limit the drain to a single zone.

Some background on my attempt to reduce "IPI noise" in the system in
this context is probably useful here as
well: https://lkml.org/lkml/2011/11/22/133

Thanks :-)
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
