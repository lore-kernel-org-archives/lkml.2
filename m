Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1IFOKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:10:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:38122 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1IFOKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:10:03 -0400
Subject: Re: [PATCH 10/18] writeback: dirty position control - bdi reserve
 area
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 16:09:39 +0200
In-Reply-To: <20110904020915.942753370@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020915.942753370@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315318179.14232.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> plain text document attachment (bdi-reserve-area)
> Keep a minimal pool of dirty pages for each bdi, so that the disk IO
> queues won't underrun.
> 
> It's particularly useful for JBOD and small memory system.
> 
> Note that this is not enough when memory is really tight (in comparison
> to write bandwidth). It may result in (pos_ratio > 1) at the setpoint
> and push the dirty pages high. This is more or less intended because the
> bdi is in the danger of IO queue underflow. However the global dirty
> pages, when pushed close to limit, will eventually conteract our desire
> to push up the low bdi_dirty.
> 
> In low memory JBOD tests we do see disks under-utilized from time to
> time. The additional fix may be to add a BDI_async_underrun flag to
> indicate that the block write queue is running low and it's time to
> quickly fill the queue by unthrottling the tasks regardless of the
> global limit.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-08-26 20:12:19.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-08-26 20:13:21.000000000 +0800
> @@ -487,6 +487,16 @@ unsigned long bdi_dirty_limit(struct bac
>   *   0 +------------.------------------.----------------------*------------->
>   *           freerun^          setpoint^                 limit^   dirty pages
>   *
> + * (o) bdi reserve area
> + *
> + * The bdi reserve area tries to keep a reasonable number of dirty pages for
> + * preventing block queue underrun.
> + *
> + * reserve area, scale up rate as dirty pages drop low
> + * |<----------------------------------------------->|
> + * |-------------------------------------------------------*-------|----------
> + * 0                                           bdi setpoint^       ^bdi_thresh


So why not call the thing bdi freerun ?

>   * (o) bdi control lines
>   *
>   * The control lines for the global/bdi setpoints both stretch up to @limit.
> @@ -634,6 +644,22 @@ static unsigned long bdi_position_ratio(
>  	pos_ratio *= x_intercept - bdi_dirty;
>  	do_div(pos_ratio, x_intercept - bdi_setpoint + 1);
>  
> +	/*
> +	 * bdi reserve area, safeguard against dirty pool underrun and disk idle
> +	 *
> +	 * It may push the desired control point of global dirty pages higher
> +	 * than setpoint. It's not necessary in single-bdi case because a
> +	 * minimal pool of @freerun dirty pages will already be guaranteed.
> +	 */
> +	x_intercept = min(write_bw, freerun);
> +	if (bdi_dirty < x_intercept) {

So the point of the freerun point is that we never throttle before it,
so basically all the below shouldn't be needed at all, right? 

> +		if (bdi_dirty > x_intercept / 8) {
> +			pos_ratio *= x_intercept;
> +			do_div(pos_ratio, bdi_dirty);
> +		} else
> +			pos_ratio *= 8;
> +	}
> +
>  	return pos_ratio;
>  }


So why not add:

	if (likely(dirty < freerun))
		return 2;

at the start of this function and leave it at that?


