Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab2KVXDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:03:48 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34811 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab2KVXDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:03:46 -0500
Date: Wed, 21 Nov 2012 17:01:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: kswapd endless loop for compaction
Message-ID: <20121121220126.GA2301@cmpxchg.org>
References: <20121120190440.GA24381@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120190440.GA24381@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be clear, this is not fixed by Dave's patch to NR_FREE_PAGES
accounting.

I can still get 3.7-rc5 + Dave's fix to drop into an endless loop in
kswapd within a couple of minutes on my test box.

As described below, the bug comes from contradicting conditions in
balance_pgdat(), not an accounting problem.

On Tue, Nov 20, 2012 at 02:04:41PM -0500, Johannes Weiner wrote:
> Hi guys,
> 
> while testing a 3.7-rc5ish kernel, I noticed that kswapd can drop into
> a busy spin state without doing reclaim.  printk-style debugging told
> me that this happens when the distance between a zone's high watermark
> and its low watermark is less than two huge pages (DMA zone).
> 
> 1. The first loop in balance_pgdat() over the zones finds all zones to
> be above their high watermark and only does goto out (all_zones_ok).
> 
> 2. pgdat_balanced() at the out: label also just checks the high
> watermark, so the node is considered balanced and the order is not
> reduced.
> 
> 3. In the `if (order)' block after it, compaction_suitable() checks if
> the zone's low watermark + twice the huge page size is okay, which
> it's not necessarily in a small zone, and so COMPACT_SKIPPED makes it
> it go back to loop_again:.
> 
> This will go on until somebody else allocates and breaches the high
> watermark and then hopefully goes on to reclaim the zone above low
> watermark + 2 * THP.
> 
> I'm not really sure what the correct solution is.  Should we modify
> the zone_watermark_ok() checks in balance_pgdat() to take into account
> the higher watermark requirements for reclaim on behalf of compaction?
> Change the check in compaction_suitable() / not use it directly?
> 
> Thanks,
> Johannes
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
