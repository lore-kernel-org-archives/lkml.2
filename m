Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1HISQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1HISQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:16:37 -0400
Date: Tue, 9 Aug 2011 14:15:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
Message-ID: <20110809181543.GG6482@redhat.com>
References: <20110806084447.388624428@intel.com>
 <20110806094527.136636891@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806094527.136636891@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 04:44:52PM +0800, Wu Fengguang wrote:

[..]
> -		trace_balance_dirty_start(bdi);
> -		if (bdi_nr_reclaimable > task_bdi_thresh) {
> -			pages_written += writeback_inodes_wb(&bdi->wb,
> -							     write_chunk);
> -			trace_balance_dirty_written(bdi, pages_written);
> -			if (pages_written >= write_chunk)
> -				break;		/* We've done our duty */
> +		if (unlikely(!writeback_in_progress(bdi)))
> +			bdi_start_background_writeback(bdi);
> +
> +		base_bw = bdi->dirty_ratelimit;
> +		bw = bdi_position_ratio(bdi, dirty_thresh, nr_dirty,
> +					bdi_thresh, bdi_dirty);

For the sake of consistency of usage of varibale naming how about using

pos_ratio = bdi_position_ratio()?

> +		if (unlikely(bw == 0)) {
> +			pause = MAX_PAUSE;
> +			goto pause;
>  		}
> +		bw = (u64)base_bw * bw >> BANDWIDTH_CALC_SHIFT;

So far bw had pos_ratio as value now it will be replaced with actual
bandwidth as value. It makes code confusing. So using pos_ratio will
help.

		bw = (u64)base_bw * pos_ratio >> BANDWIDTH_CALC_SHIFT;

Thanks
Vivek
