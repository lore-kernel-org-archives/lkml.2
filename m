Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1HIOzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1HIOzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:55:06 -0400
Date: Tue, 9 Aug 2011 10:54:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: dirty rate control
Message-ID: <20110809145438.GC6482@redhat.com>
References: <20110806084447.388624428@intel.com>
 <20110806094526.878435971@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806094526.878435971@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 04:44:50PM +0800, Wu Fengguang wrote:
> It's all about bdi->dirty_ratelimit, which aims to be (write_bw / N)
> when there are N dd tasks.
> 
> On write() syscall, use bdi->dirty_ratelimit
> ============================================
> 
>     balance_dirty_pages(pages_dirtied)
>     {
>         pos_bw = bdi->dirty_ratelimit * bdi_position_ratio();
>         pause = pages_dirtied / pos_bw;
>         sleep(pause);
>     }
> 
> On every 200ms, update bdi->dirty_ratelimit
> ===========================================
> 
>     bdi_update_dirty_ratelimit()
>     {
>         bw = bdi->dirty_ratelimit;
>         ref_bw = bw * bdi_position_ratio() * write_bw / dirty_bw;
>         if (dirty pages unbalanced)
>              bdi->dirty_ratelimit = (bw * 3 + ref_bw) / 4;
>     }
> 
> Estimation of balanced bdi->dirty_ratelimit
> ===========================================
> 
> When started N dd, throttle each dd at
> 
>          task_ratelimit = pos_bw (any non-zero initial value is OK)
> 
> After 200ms, we got
> 
>          dirty_bw = # of pages dirtied by app / 200ms
>          write_bw = # of pages written to disk / 200ms
> 
> For aggressive dirtiers, the equality holds
> 
>          dirty_bw == N * task_ratelimit
>                   == N * pos_bw                      	(1)
> 
> The balanced throttle bandwidth can be estimated by
> 
>          ref_bw = pos_bw * write_bw / dirty_bw       	(2)
> 
> >From (1) and (2), we get equality
> 
>          ref_bw == write_bw / N                      	(3)
> 
> If the N dd's are all throttled at ref_bw, the dirty/writeback rates
> will match. So ref_bw is the balanced dirty rate.

Hi Fengguang,

So how much work it is to extend all this to handle the case of cgroups?
IOW, I would imagine that you shall have to keep track of per cgroup/per
bdi state of many of the variables. For example, write_bw will become
per cgroup/per bdi entity instead of per bdi entity only. Same should
be true for position ratio, dirty_bw etc?

I am assuming that if some cgroup is low weight on end device, then
WRITE bandwidth of that cgroup should go down and that should be
accounted for at per bdi state and task throttling should happen
accordingly so that a lower weight cgroup tasks get throttled more
as compared to higher weight cgroup tasks?

Thanks
Vivek
