Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1GNGTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:19:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab1GNGTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:19:19 -0400
Date: Thu, 14 Jul 2011 07:19:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
 direct reclaim
Message-ID: <20110714061915.GN7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
 <1310567487-15367-2-git-send-email-mgorman@suse.de>
 <20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 10:38:01AM +0900, KAMEZAWA Hiroyuki wrote:
> > @@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >  		if (PageDirty(page)) {
> >  			nr_dirty++;
> >  
> > +			/*
> > +			 * Only kswapd can writeback filesystem pages to
> > +			 * avoid risk of stack overflow
> > +			 */
> > +			if (page_is_file_cache(page) && !current_is_kswapd()) {
> > +				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > +				goto keep_locked;
> > +			}
> > +
> 
> 
> This will cause tons of memcg OOM kill because we have no help of kswapd (now).
> 
> Could you make this
> 
> 	if (scanning_global_lru(sc) && page_is_file_cache(page) && !current_is_kswapd())
> ...
> 

I can, but as Christoph points out, the request is already being
ignored so how will it help?

-- 
Mel Gorman
SUSE Labs
