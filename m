Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1HHXFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:05:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:36309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1HHXFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:05:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,340,1309762800"; 
   d="scan'208";a="36441988"
Date: Tue, 9 Aug 2011 07:05:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110808230535.GC7176@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312814501.10488.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312814501.10488.41.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:41:41PM +0800, Peter Zijlstra wrote:
> On Mon, 2011-08-08 at 22:11 +0800, Wu Fengguang wrote:
> > @@ -538,11 +538,6 @@ static unsigned long bdi_position_ratio(
> >         goal = thresh - thresh / DIRTY_SCOPE;
> >         origin = 4 * thresh;
> >  
> > -       if (unlikely(origin < limit && dirty > (goal + origin) / 2)) {
> > -               origin = limit;                 /* auxiliary control line */
> > -               goal = (goal + origin) / 2;
> > -               pos_ratio >>= 1;
> > -       }
> >         pos_ratio = origin - dirty;
> >         pos_ratio <<= BANDWIDTH_CALC_SHIFT;
> >         do_div(pos_ratio, origin - goal + 1); 

FYI I've updated the fix to the below one, so that @limit will be used
as the origin in the rare case of (4*thresh < dirty).

--- linux-next.orig/mm/page-writeback.c	2011-08-08 21:56:11.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-09 06:34:25.000000000 +0800
@@ -536,13 +536,8 @@ static unsigned long bdi_position_ratio(
 	 * global setpoint
 	 */
 	goal = thresh - thresh / DIRTY_SCOPE;
-	origin = 4 * thresh;
+	origin = max(4 * thresh, limit);
 
-	if (unlikely(origin < limit && dirty > (goal + origin) / 2)) {
-		origin = limit;			/* auxiliary control line */
-		goal = (goal + origin) / 2;
-		pos_ratio >>= 1;
-	}
 	pos_ratio = origin - dirty;
 	pos_ratio <<= BANDWIDTH_CALC_SHIFT;
 	do_div(pos_ratio, origin - goal + 1);

> So basically, pos_ratio = (4t - d) / (25/8)t, which if I'm not mistaken
> comes out at 32/25 - 8d/25t. Which simply doesn't make sense at all. 

This is the more meaningful view :)

                    origin - dirty
        pos_ratio = --------------
                    origin - goal

which comes from the below [*] control line, so that when (dirty == goal),
pos_ratio == 1.0:

 ^ pos_ratio
 |
 |
 |   *
 |      *
 |         *
 |            *
 |               *
 |                  *
 |                     *
 |                        *
 |                           *
 |                              *
 |                                 *
 .. pos_ratio = 1.0 ..................*
 |                                    .  *
 |                                    .     *
 |                                    .        *
 |                                    .           *
 |                                    .              *
 |                                    .                 *
 |                                    .                    *
 |                                    .                       *
 |                                    .                          *
 |                                    .                             *
 |                                    .                                *
 |                                    .                                   *
 |                                    .                                      *
 |                                    .                                         *
 |                                    .                                            *
 |                                    .                                               *
 +------------------------------------.--------------------------------------------------*---------------------->
 0                                   goal                                              origin         dirty pages

Thanks,
Fengguang
