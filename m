Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0ICXRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:17:52 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:33951 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752752Ab0ICXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:17:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NaqyXH4VM1lfWqWD3kjeHTB36K8t.wXQciF.t59_tilcuYV
 aXKROcgfeu0JZaZr596tGEweNEiQFVPNMTiwXcDZDzF3tDeMCH9n6D.xELdw
 AM.aiy2CVhK2Ulm7OYhcOfOoJGCDEXY75PjGHY6RSnK7qCn71fyomZ77k_39
 4JfSGNnghWdPEOV3kZ33nuWRP_zG.YE6o1b0pRoxrgww85XdDPqr905X2WRm
 _
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Sep 2010 18:17:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <20100903155537.41f1a3a7.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1009031811090.16264@router.home>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-3-git-send-email-mel@csn.ul.ie> <20100903155537.41f1a3a7.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Andrew Morton wrote:

> Can someone remind me why per_cpu_pageset went and reimplemented
> percpu_counters rather than just using them?

The vm counters are per zone and per cpu and have a flow from per cpu /
zone deltas to zone counters and then also into global counters.

> Is this really the best way of doing it?  The way we usually solve
> this problem (and boy, was this bug a newbie mistake!) is:
>
> 	foo = percpu_counter_read(x);
>
> 	if (foo says something bad) {
> 		/* Bad stuff: let's get a more accurate foo */
> 		foo = percpu_counter_sum(x);
> 	}
>
> 	if (foo still says something bad)
> 		do_bad_thing();
>
> In other words, don't do all this stuff with percpu_drift_mark and the
> kswapd heuristic.  Just change zone_watermark_ok() to use the more
> accurate read if it's about to return "no".

percpu counters must always be added up when their value is determined. We
cannot really affort that for the VM. Counters are always available
without looping over all cpus.

vm counters are continually kept up to date (but may have delta limited by
time and counter values).

This seems to be a special case here where Mel does not want to have to
cost to bring the counters up to date nor reduce the delta/time limits to
get some more accuracy but wants take some sort of snapshot of the whole
situation for this particular case.



