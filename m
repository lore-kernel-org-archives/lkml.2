Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1GVMyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:54:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1GVMyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:54:11 -0400
Subject: Re: [PATCH 7/8] mm: vmscan: Immediately reclaim end-of-LRU dirty
 pages when writeback completes
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <1311265730-5324-8-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	 <1311265730-5324-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Jul 2011 14:53:48 +0200
Message-ID: <1311339228.27400.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 17:28 +0100, Mel Gorman wrote:
> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim
> similar to deactivate_page() so that the page gets reclaimed almost
> immediately after the page gets cleaned. This is to avoid reclaiming
> clean pages that are younger than a dirty page encountered at the
> end of the LRU that might have been something like a use-once page.
> 

> @@ -834,7 +834,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  			 */
>  			if (page_is_file_cache(page) &&
>  					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
> -				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> +				/*
> +				 * Immediately reclaim when written back.
> +				 * Similar in principal to deactivate_page()
> +				 * except we already have the page isolated
> +				 * and know it's dirty
> +				 */
> +				inc_zone_page_state(page, NR_VMSCAN_INVALIDATE);
> +				SetPageReclaim(page);
> +

I find the invalidate name somewhat confusing. It makes me think we'll
drop the page without writeback, like invalidatepage().
