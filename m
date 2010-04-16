Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0DPOuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:50:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42939 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab0DPOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:50:43 -0400
Date: Fri, 16 Apr 2010 15:50:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 00/10] Reduce stack usage used by page reclaim V1
Message-ID: <20100416145023.GI19264@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:21:33PM +0100, Mel Gorman wrote:
> This is just an RFC to reduce some of the more obvious stack usage in page
> reclaim. It's a bit rushed and I haven't tested this yet but am sending
> it out as there may be others working on similar material and would rather
> avoid overlap. I built on some of Kosaki Motohiro's work.
> 

So the first pass seems to have been reasonably well received. Kosaki,
Rik and Johannes, how you do typically test reclaim-related patches for
regressions? My initial sniff-tests look ok with the page leak sorted out
but I typically am not searching for vmscan regressions other than lumpy
reclaim.

> On X86 bit, stack usage figures (generated using a modified bloat-o-meter

This should have been X86-64. The stack shrinkage is less on X86
obviously because of the difference size of pointers and the like.

> that uses checkstack.pl as its input) change in the following ways after
> the series of patches.
> 
> add/remove: 2/0 grow/shrink: 0/4 up/down: 804/-1688 (-884)
> function                                     old     new   delta
> putback_lru_pages                              -     676    +676
> update_isolated_counts                         -     128    +128
> do_try_to_free_pages                         172     128     -44
> kswapd                                      1324    1168    -156
> shrink_page_list                            1616    1224    -392
> shrink_zone                                 2320    1224   -1096
> 
> There are some growths there but critically they are no longer in the path
> that would call writepages. In the main path, there is about 1K of stack
> lopped off giving a small amount of breathing room.
> 
> KOSAKI Motohiro (3):
>   vmscan: kill prev_priority completely
>   vmscan: move priority variable into scan_control
>   vmscan: simplify shrink_inactive_list()
> 
> Mel Gorman (7):
>   vmscan: Remove useless loop at end of do_try_to_free_pages
>   vmscan: Remove unnecessary temporary vars in do_try_to_free_pages
>   vmscan: Split shrink_zone to reduce stack usage
>   vmscan: Remove unnecessary temporary variables in shrink_zone()
>   vmscan: Setup pagevec as late as possible in shrink_inactive_list()
>   vmscan: Setup pagevec as late as possible in shrink_page_list()
>   vmscan: Update isolated page counters outside of main path in
>     shrink_inactive_list()
> 
>  include/linux/mmzone.h |   15 --
>  mm/page_alloc.c        |    2 -
>  mm/vmscan.c            |  447 +++++++++++++++++++++++-------------------------
>  mm/vmstat.c            |    2 -
>  4 files changed, 210 insertions(+), 256 deletions(-)
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
