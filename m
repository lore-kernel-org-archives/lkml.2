Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1IFCKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 22:10:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:7727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab1IFCKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 22:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45318954"
Date: Tue, 6 Sep 2011 10:10:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/18] writeback: dirty position control
Message-ID: <20110906021042.GA11706@localhost>
References: <20110904015305.367445271@intel.com>
 <20110904020914.848566742@intel.com>
 <1315234979.3191.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315234979.3191.4.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 11:02:59PM +0800, Peter Zijlstra wrote:
> On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> > + * (o) bdi control lines
> > + *
> > + * The control lines for the global/bdi setpoints both stretch up to @limit.
> > + * The below figure illustrates the main bdi control line with an auxiliary
> > + * line extending it to @limit.
> > + *
> > + *   o
> > + *     o
> > + *       o                                      [o] main control line
> > + *         o                                    [*] auxiliary control line
> > + *           o
> > + *             o
> > + *               o
> > + *                 o
> > + *                   o
> > + *                     o
> > + *                       o--------------------- balance point, rate scale = 1
> > + *                       | o
> > + *                       |   o
> > + *                       |     o
> > + *                       |       o
> > + *                       |         o
> > + *                       |           o
> > + *                       |             o------- connect point, rate scale = 1/2
> > + *                       |               .*
> > + *                       |                 .   *
> > + *                       |                   .      *
> > + *                       |                     .         *
> > + *                       |                       .           *
> > + *                       |                         .              *
> > + *                       |                           .                 *
> > + *  [--------------------+-----------------------------.--------------------*]
> > + *  0              bdi_setpoint                    x_intercept           limit
> > + *
> > + * The auxiliary control line allows smoothly throttling bdi_dirty down to
> > + * normal if it starts high in situations like
> > + * - start writing to a slow SD card and a fast disk at the same time. The SD
> > + *   card's bdi_dirty may rush to many times higher than bdi_setpoint.
> > + * - the bdi dirty thresh drops quickly due to change of JBOD workload 
> 
> In light of the global control thing already having a hard stop at
> limit, what's the point of the auxiliary line? Why not simply run the
> bdi control between [0.5, 1.5] and leave it at that?

Good point! It helps remove one confusing concept.

This patch reduces the auxiliary control line to a flat y=0.25 line.
The comments will be further simplified, too.

Thanks,
Fengguang
---

 mm/page-writeback.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-09-06 09:59:50.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-09-06 10:05:31.000000000 +0800
@@ -676,18 +676,11 @@ static unsigned long bdi_position_ratio(
 	span = (thresh - bdi_thresh + 8 * write_bw) * (u64)x >> 16;
 	x_intercept = bdi_setpoint + span;
 
-	span >>= 1;
-	if (unlikely(bdi_dirty > bdi_setpoint + span)) {
-		if (unlikely(bdi_dirty > limit))
-			return 0;
-		if (x_intercept < limit) {
-			x_intercept = limit;	/* auxiliary control line */
-			bdi_setpoint += span;
-			pos_ratio >>= 1;
-		}
-	}
-	pos_ratio *= x_intercept - bdi_dirty;
-	do_div(pos_ratio, x_intercept - bdi_setpoint + 1);
+	if (bdi_dirty < x_intercept - span / 4) {
+		pos_ratio *= x_intercept - bdi_dirty;
+		do_div(pos_ratio, x_intercept - bdi_setpoint + 1);
+	} else
+		pos_ratio /= 4;
 
 	return pos_ratio;
 }
