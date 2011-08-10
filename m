Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1HJD0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 23:26:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:52779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab1HJD0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 23:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,348,1309762800"; 
   d="scan'208";a="36903250"
Date: Wed, 10 Aug 2011 11:26:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
Message-ID: <20110810032634.GB24486@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094527.136636891@intel.com>
 <20110809181543.GG6482@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809181543.GG6482@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 02:15:43AM +0800, Vivek Goyal wrote:
> On Sat, Aug 06, 2011 at 04:44:52PM +0800, Wu Fengguang wrote:
> 
> [..]
> > -		trace_balance_dirty_start(bdi);
> > -		if (bdi_nr_reclaimable > task_bdi_thresh) {
> > -			pages_written += writeback_inodes_wb(&bdi->wb,
> > -							     write_chunk);
> > -			trace_balance_dirty_written(bdi, pages_written);
> > -			if (pages_written >= write_chunk)
> > -				break;		/* We've done our duty */
> > +		if (unlikely(!writeback_in_progress(bdi)))
> > +			bdi_start_background_writeback(bdi);
> > +
> > +		base_bw = bdi->dirty_ratelimit;
> > +		bw = bdi_position_ratio(bdi, dirty_thresh, nr_dirty,
> > +					bdi_thresh, bdi_dirty);
> 
> For the sake of consistency of usage of varibale naming how about using
> 
> pos_ratio = bdi_position_ratio()?

OK!

> > +		if (unlikely(bw == 0)) {
> > +			pause = MAX_PAUSE;
> > +			goto pause;
> >  		}
> > +		bw = (u64)base_bw * bw >> BANDWIDTH_CALC_SHIFT;
> 
> So far bw had pos_ratio as value now it will be replaced with actual
> bandwidth as value. It makes code confusing. So using pos_ratio will
> help.
> 
> 		bw = (u64)base_bw * pos_ratio >> BANDWIDTH_CALC_SHIFT;

Yeah it makes good sense. I'll change to.

 		rate = (u64)base_rate * pos_ratio >> BANDWIDTH_CALC_SHIFT;

Thanks,
Fengguang
