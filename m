Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0ICXGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:06:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0ICXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:06:14 -0400
Date: Fri, 3 Sep 2010 16:05:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, stable@kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] Reduce watermark-related problems with the per-cpu
 allocator V4
Message-Id: <20100903160551.05db4a92.akpm@linux-foundation.org>
In-Reply-To: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Sep 2010 10:08:43 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> The noteworthy change is to patch 2 which now uses the generic
> zone_page_state_snapshot() in zone_nr_free_pages(). Similar logic still
> applies for *when* zone_page_state_snapshot() to avoid ovedhead.
> 
> Changelog since V3
>   o Use generic helper for NR_FREE_PAGES estimate when necessary
> 
> Changelog since V2
>   o Minor clarifications
>   o Rebase to 2.6.36-rc3
> 
> Changelog since V1
>   o Fix for !CONFIG_SMP
>   o Correct spelling mistakes
>   o Clarify a ChangeLog
>   o Only check for counter drift on machines large enough for the counter
>     drift to breach the min watermark when NR_FREE_PAGES report the low
>     watermark is fine
> 
> Internal IBM test teams beta testing distribution kernels have reported
> problems on machines with a large number of CPUs whereby page allocator
> failure messages show huge differences between the nr_free_pages vmstat
> counter and what is available on the buddy lists. In an extreme example,
> nr_free_pages was above the min watermark but zero pages were on the buddy
> lists allowing the system to potentially livelock unable to make forward
> progress unless an allocation succeeds. There is no reason why the problems
> would not affect mainline so the following series mitigates the problems
> in the page allocator related to to per-cpu counter drift and lists.
> 
> The first patch ensures that counters are updated after pages are added to
> free lists.
> 
> The second patch notes that the counter drift between nr_free_pages and what
> is on the per-cpu lists can be very high. When memory is low and kswapd
> is awake, the per-cpu counters are checked as well as reading the value
> of NR_FREE_PAGES. This will slow the page allocator when memory is low and
> kswapd is awake but it will be much harder to breach the min watermark and
> potentially livelock the system.
> 
> The third patch notes that after direct-reclaim an allocation can
> fail because the necessary pages are on the per-cpu lists. After a
> direct-reclaim-and-allocation-failure, the per-cpu lists are drained and
> a second attempt is made.
> 
> Performance tests against 2.6.36-rc3 did not show up anything interesting. A
> version of this series that continually called vmstat_update() when
> memory was low was tested internally and found to help the counter drift
> problem. I described this during LSF/MM Summit and the potential for IPI
> storms was frowned upon. An alternative fix is in patch two which uses
> for_each_online_cpu() to read the vmstat deltas while memory is low and
> kswapd is awake. This should be functionally similar.
> 
> This patch should be merged after the patch "vmstat : update
> zone stat threshold at onlining a cpu" which is in mmotm as
> vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch .
> 
> If we can agree on it, this series is a stable candidate.

(cc stable@kernel.org)

>  include/linux/mmzone.h |   13 +++++++++++++
>  include/linux/vmstat.h |   22 ++++++++++++++++++++++
>  mm/mmzone.c            |   21 +++++++++++++++++++++
>  mm/page_alloc.c        |   29 +++++++++++++++++++++--------
>  mm/vmstat.c            |   15 ++++++++++++++-
>  5 files changed, 91 insertions(+), 9 deletions(-)

For the entire patch series I get

 include/linux/mmzone.h |   13 +++++++++++++
 include/linux/vmstat.h |   22 ++++++++++++++++++++++
 mm/mmzone.c            |   21 +++++++++++++++++++++
 mm/page_alloc.c        |   33 +++++++++++++++++++++++----------
 mm/vmstat.c            |   16 +++++++++++++++-
 5 files changed, 94 insertions(+), 11 deletions(-)

The patches do apply OK to 2.6.35.

Give the extent and the coreness of it all, it's a bit more than I'd
usually push at the -stable guys.  But I guess that if the patches fix
all the issues you've noted, as well as David's "minute-long livelocks
in memory reclaim" then yup, it's worth backporting it all.



