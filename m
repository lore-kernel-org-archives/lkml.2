Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1IGCha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:37:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:55217 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab1IGChY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,342,1312182000"; 
   d="scan'208";a="46213841"
Date: Wed, 7 Sep 2011 10:37:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/18] block: add bdi flag to indicate risk of io queue
 underrun
Message-ID: <20110907023719.GC13755@localhost>
References: <20110904015305.367445271@intel.com>
 <20110904020916.070059502@intel.com>
 <1315318968.14232.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315318968.14232.6.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 10:22:48PM +0800, Peter Zijlstra wrote:
> On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> > +++ linux-next/mm/page-writeback.c      2011-08-31 14:40:58.000000000 +0800
> > @@ -1067,6 +1067,9 @@ static void balance_dirty_pages(struct a
> >                                      nr_dirty, bdi_thresh, bdi_dirty,
> >                                      start_time);
> >  
> > +               if (unlikely(!dirty_exceeded && bdi_async_underrun(bdi)))
> > +                       break;
> > +
> >                 dirty_ratelimit = bdi->dirty_ratelimit;
> >                 pos_ratio = bdi_position_ratio(bdi, dirty_thresh,
> >                                                background_thresh, nr_dirty,
> 
> So dirty_exceeded looks like:
> 
> 
> 1109                 dirty_exceeded = (bdi_dirty > bdi_thresh) ||
> 1110                                   (nr_dirty > dirty_thresh);
> 
> Would it make sense to write it as:
> 
> 	if (nr_dirty > dirty_thresh || 
> 	    (nr_dirty > freerun && bdi_dirty > bdi_thresh))
> 		dirty_exceeded = 1;
> 
> So that we don't actually throttle bdi thingies when we're still in the
> freerun area?

Sounds not necessary -- (nr_dirty > freerun) is implicitly true
because there is a big break early in the loop:

        if (nr_dirty > freerun)
                break;

Thanks,
Fengguang
