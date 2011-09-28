Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1I1Ova (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:51:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1I1Ov3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:51:29 -0400
Subject: Re: [PATCH 10/18] writeback: dirty position control - bdi reserve
 area
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 28 Sep 2011 16:50:35 +0200
In-Reply-To: <20110928140205.GA26617@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110904020915.942753370@intel.com> <1315318179.14232.3.camel@twins>
	 <20110907123108.GB6862@localhost> <1315822779.26517.23.camel@twins>
	 <20110918141705.GB15366@localhost> <20110918143721.GA17240@localhost>
	 <20110918144751.GA18645@localhost> <20110928140205.GA26617@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317221435.24040.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 22:02 +0800, Wu Fengguang wrote:

/me attempts to swap back neurons related to writeback

> After lots of experiments, I end up with this bdi reserve point
> 
> +       x_intercept = bdi_thresh / 2 + MIN_WRITEBACK_PAGES;
> 
> together with this chunk to avoid a bdi stuck in bdi_thresh=0 state:
> 
> @@ -590,6 +590,7 @@ static unsigned long bdi_position_ratio(
>          */
>         if (unlikely(bdi_thresh > thresh))
>                 bdi_thresh = thresh;
> +       bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
>         /*
>          * scale global setpoint to bdi's:
>          *      bdi_setpoint = setpoint * bdi_thresh / thresh

So you cap bdi_thresh at a minimum of (limit-dirty)/8 which can be
pretty close to 0 if we have a spike in dirty or a negative spike in
writeout bandwidth (sudden seeks or whatnot).


> The above changes are good enough to keep reasonable amount of bdi
> dirty pages, so the bdi underrun flag ("[PATCH 11/18] block: add bdi
> flag to indicate risk of io queue underrun") is dropped.

That sounds like goodness ;-)

> I also tried various bdi freerun patches, however the results are not
> satisfactory. Basically the bdi reserve area approach (this patch)
> yields noticeably more smooth/resilient behavior than the
> freerun/underrun approaches. I noticed that the bdi underrun flag
> could lead to sudden surge of dirty pages (especially if not
> safeguarded by the dirty_exceeded condition) in the very small
> window.. 

OK, so let me try and parse this magic:

+       x_intercept = bdi_thresh / 2 + MIN_WRITEBACK_PAGES;
+       if (bdi_dirty < x_intercept) {
+               if (bdi_dirty > x_intercept / 8) {
+                       pos_ratio *= x_intercept;
+                       do_div(pos_ratio, bdi_dirty);
+               } else
+                       pos_ratio *= 8;
+       }

So we set our target some place north of MIN_WRITEBACK_PAGES: if we're
short we add a factor of: x_intercept/bdi_dirty. 

Now, since bdi_dirty < x_intercept, this is > 1 and thus we promote more
dirties.

Additionally we don't let the factor get larger than 8 to avoid silly
large fluctuations (8 already seems quite generous to me).


Now I guess the only problem is when nr_bdi * MIN_WRITEBACK_PAGES ~
limit, at which point things go pear shaped.
