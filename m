Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1GNGY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:24:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58223 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1GNGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:24:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 14 Jul 2011 15:17:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
 direct reclaim
Message-Id: <20110714151708.163a0c54.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110714061915.GN7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714061915.GN7529@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 07:19:15 +0100
Mel Gorman <mgorman@suse.de> wrote:

> On Thu, Jul 14, 2011 at 10:38:01AM +0900, KAMEZAWA Hiroyuki wrote:
> > > @@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> > >  		if (PageDirty(page)) {
> > >  			nr_dirty++;
> > >  
> > > +			/*
> > > +			 * Only kswapd can writeback filesystem pages to
> > > +			 * avoid risk of stack overflow
> > > +			 */
> > > +			if (page_is_file_cache(page) && !current_is_kswapd()) {
> > > +				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > > +				goto keep_locked;
> > > +			}
> > > +
> > 
> > 
> > This will cause tons of memcg OOM kill because we have no help of kswapd (now).
> > 
> > Could you make this
> > 
> > 	if (scanning_global_lru(sc) && page_is_file_cache(page) && !current_is_kswapd())
> > ...
> > 
> 
> I can, but as Christoph points out, the request is already being
> ignored so how will it help?
> 

Hmm, ok, please go as you do now. I'll do hurry up to implement dirty_ratio by myself
without waiting for original patch writer. I think his latest version was really
near to be merged... I'll start rebase his one to mmotm in this end of month.

Thanks,
-Kame

