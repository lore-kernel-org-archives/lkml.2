Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1IGRFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:05:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab1IGRFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:05:07 -0400
Subject: Re: [PATCH 11/18] block: add bdi flag to indicate risk of io queue
 underrun
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Sep 2011 09:31:09 +0200
In-Reply-To: <20110907023719.GC13755@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.070059502@intel.com> <1315318968.14232.6.camel@twins>
	 <20110907023719.GC13755@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315380669.11101.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 10:37 +0800, Wu Fengguang wrote:
> On Tue, Sep 06, 2011 at 10:22:48PM +0800, Peter Zijlstra wrote:
> > On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> > > +++ linux-next/mm/page-writeback.c      2011-08-31 14:40:58.000000000 +0800
> > > @@ -1067,6 +1067,9 @@ static void balance_dirty_pages(struct a
> > >                                      nr_dirty, bdi_thresh, bdi_dirty,
> > >                                      start_time);
> > >  
> > > +               if (unlikely(!dirty_exceeded && bdi_async_underrun(bdi)))
> > > +                       break;
> > > +
> > >                 dirty_ratelimit = bdi->dirty_ratelimit;
> > >                 pos_ratio = bdi_position_ratio(bdi, dirty_thresh,
> > >                                                background_thresh, nr_dirty,
> > 
> > So dirty_exceeded looks like:
> > 
> > 
> > 1109                 dirty_exceeded = (bdi_dirty > bdi_thresh) ||
> > 1110                                   (nr_dirty > dirty_thresh);
> > 
> > Would it make sense to write it as:
> > 
> > 	if (nr_dirty > dirty_thresh || 
> > 	    (nr_dirty > freerun && bdi_dirty > bdi_thresh))
> > 		dirty_exceeded = 1;
> > 
> > So that we don't actually throttle bdi thingies when we're still in the
> > freerun area?
> 
> Sounds not necessary -- (nr_dirty > freerun) is implicitly true
> because there is a big break early in the loop:
> 
>         if (nr_dirty > freerun)
>                 break;

Ah, totally didn't see that. Thanks!
