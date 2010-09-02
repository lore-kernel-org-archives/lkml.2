Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0IBAY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:24:59 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:27168 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752352Ab0IBAY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:24:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: S9g12wMVM1lgYwjng.gk82dFBw1rdF9sCdQdMhPfaw.bubX
 iLUnuaLUhGsxcbOA7VH8WJViLZ9Kmb9tpnGvu471lENOYRtL5Wu8kl_1S470
 MOpKSInZFtOn332U6uglfaod9qJ8r7VBAYkYRu3hrF9iP51LtQVFnDm.Qga8
 9KNmfHcVcrQa7ugb_jJLnR_QBeJXcYCnO6yWg2d_ccj3N7U6z9dQ1Af.khX0
 cvO0qkzRfhc_cZdqJsnqpYOXXj31Y
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Sep 2010 19:24:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <20100901203422.GA19519@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009011919110.20518@router.home>
References: <20100901083425.971F.A69D9226@jp.fujitsu.com> <20100901072402.GE13677@csn.ul.ie> <20100901163146.9755.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009011512190.16322@router.home> <20100901203422.GA19519@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Mel Gorman wrote:

> > > >         if (delta < 0 && abs(delta) > nr_free_pages)
> > > >                 delta = -nr_free_pages;
> >
> > Not sure what the point here is. If the delta is going below zero then
> > there was a concurrent operation updating the counters negatively while
> > we summed up the counters.
>
> The point is if the negative delta is greater than the current value of
> nr_free_pages then nr_free_pages would underflow when delta is applied to it.

Ok. then

	nr_free_pages += delta;
	if (nr_free_pages < 0)
		nr_free_pages = 0;

> > would be correct.
>
> Lets say the reading at the start for nr_free_pages is 120 and the delta is
> -20, then the estimated true value of nr_free_pages is 100. If we used your
> logic, the estimate would be 120. Maybe I'm missing what you're saying.

Well yes the sum of the counter needs to be checked not just the sum of
the deltas. This is the same as the counter determination in vmstat.h

> > See also handling of counter underflow in
> > vmstat.h:zone_page_state().
>
> I'm not seeing the relation. zone_nr_free_pages() is trying to
> reconcile the reading from zone_page_state() with the contents of
> vm_stat_diff[].

Both are determinations of a counter value. The global or zone counters
can also temporarily go below zero due to deferred updates. If
this happens then 0 will be returned(!). zonr_nr_free_pages need to work
in the same way.

> > As I have said before: I would rather have the
> > counter handling in one place to avoid creating differences in counter
> > handling.
> >
>
> And I'd rather not hurt the paths for every counter unnecessarily
> without good cause. I can move zone_nr_free_pages() to mm/vmstat.c if
> you'd prefer?

Generalize it on the way please to work with any counter?


