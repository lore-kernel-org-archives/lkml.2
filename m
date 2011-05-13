Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab1EMHJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:09:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47765 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab1EMHI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:08:59 -0400
Date: Fri, 13 May 2011 09:08:39 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 3/6] mm: memcg-aware global reclaim
Message-ID: <20110513070839.GC18610@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
 <1305212038-15445-4-git-send-email-hannes@cmpxchg.org>
 <BANLkTimr1sCLTa2JuMUYUFQWGS2D8c9GEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimr1sCLTa2JuMUYUFQWGS2D8c9GEA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:19:45PM -0700, Ying Han wrote:
> On Thu, May 12, 2011 at 7:53 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > A page charged to a memcg is linked to a lru list specific to that
> > memcg.  At the same time, traditional global reclaim is obvlivious to
> > memcgs, and all the pages are also linked to a global per-zone list.
> >
> > This patch changes traditional global reclaim to iterate over all
> > existing memcgs, so that it no longer relies on the global list being
> > present.
> >
> 
> > This is one step forward in integrating memcg code better into the
> > rest of memory management.  It is also a prerequisite to get rid
> > of the global per-zone lru lists.
> >
> Sorry If i misunderstood something here. I assume this patch has not
> much to do with the global soft_limit reclaim, but only allow the
> system only scan per-memcg lru under global memory pressure.

I see you found 6/6 in the meantime :) Did it answer your question?

> > The algorithm implemented in this patch is very naive.  For each zone
> > scanned at each priority level, it iterates over all existing memcgs
> > and considers them for scanning.
> >
> > This is just a prototype and I did not optimize it yet because I am
> > unsure about the maximum number of memcgs that still constitute a sane
> > configuration in comparison to the machine size.
> 
> So we also scan memcg which has no page allocated on this zone? I
> will read the following patch in case i missed something here :)

The old hierarchy walk skipped a memcg if it had no local pages at
all.  I thought this was a rather unlikely situation and ripped it
out.

It will not loop persistently over a specific memcg and node
combination, like soft limit reclaim does at the moment.

Since this is much deeper integrated in memory reclaim now, it
benefits from all the existing mechanisms and will calculate the scan
target based on the number of lru pages on memcg->zone->lru, and do
nothing if there are no pages there.
