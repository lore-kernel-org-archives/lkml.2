Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1GATUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1GATUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:20:09 -0400
Date: Fri, 1 Jul 2011 15:19:25 -0400
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
Message-ID: <20110701191925.GD28563@redhat.com>
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
> 
> CC: Li Shaohua <shaohua.li@intel.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c           |   13 +++++
>  include/linux/backing-dev.h |    5 ++
>  include/linux/writeback.h   |    3 +
>  mm/backing-dev.c            |   12 +++++
>  mm/page-writeback.c         |   81 ++++++++++++++++++++++++++++++++++
>  5 files changed, 114 insertions(+)
> 
> To get an idea of the adaption speed and fluctuation range, here are
> some real examples (check the red dots and the yellow line):
> 

IIUC, following examples are with dd workload only with variation in file
systems. How about variation of workload (mix of seq and random writes,
competining synchronous workload) and variation of io schedulers. All of the
above should change write bandwidth more unpredictably and it would be
interesting to see how well algorithm works in those cases.

Thanks
Vivek
 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/xfs-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:51/balance_dirty_pages-bandwidth.png
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext3-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.22:02/balance_dirty_pages-bandwidth.png
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext4-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:57/balance_dirty_pages-bandwidth.png
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/btrfs-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.22:07/balance_dirty_pages-bandwidth.png
> 
