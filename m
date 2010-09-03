Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0ICXaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:30:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0ICXaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:30:01 -0400
Date: Fri, 3 Sep 2010 16:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
Message-Id: <20100903162821.48ec57cc.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1009031811090.16264@router.home>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
	<1283504926-2120-3-git-send-email-mel@csn.ul.ie>
	<20100903155537.41f1a3a7.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1009031811090.16264@router.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 18:17:46 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> On Fri, 3 Sep 2010, Andrew Morton wrote:
> 
> > Can someone remind me why per_cpu_pageset went and reimplemented
> > percpu_counters rather than just using them?
> 
> The vm counters are per zone and per cpu and have a flow from per cpu /
> zone deltas to zone counters and then also into global counters.

hm.  percpu counters would require overflow-time hooks to do that. 
Might be worth looking at.

> > Is this really the best way of doing it?  The way we usually solve
> > this problem (and boy, was this bug a newbie mistake!) is:
> >
> > 	foo = percpu_counter_read(x);
> >
> > 	if (foo says something bad) {
> > 		/* Bad stuff: let's get a more accurate foo */
> > 		foo = percpu_counter_sum(x);
> > 	}
> >
> > 	if (foo still says something bad)
> > 		do_bad_thing();
> >
> > In other words, don't do all this stuff with percpu_drift_mark and the
> > kswapd heuristic.  Just change zone_watermark_ok() to use the more
> > accurate read if it's about to return "no".
> 
> percpu counters must always be added up when their value is determined.

Nope.  That's the difference between percpu_counter_read() and
percpu_counter_sum().

> This seems to be a special case here where Mel does not want to have to
> cost to bring the counters up to date nor reduce the delta/time limits to
> get some more accuracy but wants take some sort of snapshot of the whole
> situation for this particular case.

My suggestion didn't actually have anything to do with percpu_counters.


