Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0HWQNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:13:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58457 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0HWQNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:13:33 -0400
Date: Mon, 23 Aug 2010 17:13:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
	NR_FREE_PAGES when memory is low and kswapd is awake
Message-ID: <20100823161317.GU19797@csn.ul.ie>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230750380.4094@router.home> <20100823130315.GQ19797@csn.ul.ie> <alpine.DEB.2.00.1008230838320.5750@router.home> <20100823135559.GS19797@csn.ul.ie> <alpine.DEB.2.00.1008231059580.8601@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231059580.8601@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:04:38AM -0500, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Mel Gorman wrote:
> 
> > > When the vm gets into a state where continual reclaim is necessary then
> > > the counters are not that frequently updated. If the machine is already
> > > slowing down due to reclaim then the vm can likely affort more frequent
> > > counter updates.
> > >
> >
> > Ok, but is that better than this patch? Decreasing the size of the window by
> > reducing the threshold still leaves a window. There is still a small amount
> > of drift by summing up all the deltas but you get a much more accurate count
> > at the point of time it was important to know.
> 
> In order to make that decision we would need to know what deltas make a
> significant difference.

A delta on the NR_FREE_PAGES is the obvious problem. The page allocation
failure report I saw clearly stated that free was a value above min watermark
where as the buddy lists just as clearly showed that the number of pages on
the list were 0.

> Would be also important to know if there are any
> other counters that have issues.

I am not aware of similar issues with another counter where drift causes
the system to make the wrong decision, are you?

> If so then the reduction of the
> thresholds is addressing these problems in a number of counters.
> 
> I have no objection against this approach here but it may just be bandaid
> on a larger issue that could be approached in a cleaner way.
> 

Unfortunately, I do not have access to a machine large enough to investigate
around this area. All I have to go on is a few bug reports showing the delta
problem with NR_FREE_PAGES and test results in a patch functionally similar
to this patch showing that the livelock problem went away.

At best all we can do is keep an eye out for problems one large machines
that could be explained by counter drift. If such a bug is found with a
reporter with regular access to the machine for test kernels, we can
investigate if reducing the thresholds fix the problem without affecting
general performance.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
