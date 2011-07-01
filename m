Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab1GASdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:33:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab1GASdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:33:21 -0400
Date: Fri, 1 Jul 2011 14:32:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110701183252.GC28563@redhat.com>
References: <20110629145245.835998321@intel.com>
 <20110629145553.906668553@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145553.906668553@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:52:48PM +0800, Wu Fengguang wrote:
> The estimation value will start from 100MB/s and adapt to the real
> bandwidth in seconds.
> 
> It tries to update the bandwidth only when disk is fully utilized.
> Any inactive period of more than one second will be skipped.
> 
> The estimated bandwidth will be reflecting how fast the device can
> writeout when _fully utilized_, and won't drop to 0 when it goes idle.
> The value will remain constant at disk idle time. At busy write time, if
> not considering fluctuations, it will also remain high unless be knocked
> down by possible concurrent reads that compete for the disk time and
> bandwidth with async writes.
> 
> The estimation is not done purely in the flusher because there is no
> guarantee for write_cache_pages() to return timely to update bandwidth.
> 
> The bdi->avg_write_bandwidth smoothing is very effective for filtering
> out sudden spikes, however may be a little biased in long term.
> 
> The overheads are low because the bdi bandwidth update only occurs at
> 200ms intervals.
> 
> The 200ms update interval is suitable, becuase it's not possible to get
> the real bandwidth for the instance at all, due to large fluctuations.
> 
> The NFS commits can be as large as seconds worth of data. One XFS
> completion may be as large as half second worth of data if we are going
> to increase the write chunk to half second worth of data. In ext4,
> fluctuations with time period of around 5 seconds is observed. And there
> is another pattern of irregular periods of up to 20 seconds on SSD tests.
> 
> That's why we are not only doing the estimation at 200ms intervals, but
> also averaging them over a period of 3 seconds and then go further to do
> another level of smoothing in avg_write_bandwidth.

What IO scheduler have you used for testing? CFQ now a days almost chokes
async requests in presence of lots of sync IO. Have you done some testing
with that scenario and see how quickly you adjust to that change.

/me is trying to wrap his head around all the smoothing and bandwidth
calculation functions. Wished there was more explanation to it.

Thanks
Vivek
