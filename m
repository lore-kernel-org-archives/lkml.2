Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0IMNsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:48:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:54802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0IMNsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:48:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,359,1280732400"; 
   d="scan'208";a="656729326"
Date: Mon, 13 Sep 2010 21:48:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/10] vmscan: Kick flusher threads to clean pages when
 reclaim is encountering dirty pages
Message-ID: <20100913134845.GB12355@localhost>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-11-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283770053-18833-11-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * If reclaim is encountering dirty pages, it may be because
> +	 * dirty pages are reaching the end of the LRU even though the
> +	 * dirty_ratio may be satisified. In this case, wake flusher
> +	 * threads to pro-actively clean up to a maximum of
> +	 * 4 * SWAP_CLUSTER_MAX amount of data (usually 1/2MB) unless
> +	 * !may_writepage indicates that this is a direct reclaimer in
> +	 * laptop mode avoiding disk spin-ups
> +	 */
> +	if (file && nr_dirty_seen && sc->may_writepage)
> +		wakeup_flusher_threads(nr_writeback_pages(nr_dirty));

wakeup_flusher_threads() works, but seems not the pertinent one.

- locally, it needs some luck to clean the pages that direct reclaim is waiting on
- globally, it cleans up some dirty pages, however some heavy dirtier
  may quickly create new ones..

So how about taking the approaches in these patches?

- "[PATCH 4/4] vmscan: transfer async file writeback to the flusher"
- "[PATCH 15/17] mm: lower soft dirty limits on memory pressure"

In particular the first patch should work very nicely with memcg, as
all pages of an inode typically belong to the same memcg. So doing
write-around helps clean lots of dirty pages in the target LRU list in
one shot.

Thanks,
Fengguang
