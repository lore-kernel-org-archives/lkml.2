Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab1LPCaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:30:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:25336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab1LPC36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:29:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86292714"
Date: Fri, 16 Dec 2011 10:19:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Sergei Trofimovich <slyich@gmail.com>,
        Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Re: [PATCH 3.2-rc5] block: don't kick empty queue in
 blk_drain_queue()
Message-ID: <20111216021955.GA20801@localhost>
References: <20111215185842.GB32002@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215185842.GB32002@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks! It fixed the problem for me.

On Fri, Dec 16, 2011 at 02:58:42AM +0800, Tejun Heo wrote:
> While probing, fd sets up queue, probes hardware and tears down the
> queue if probing fails.  In the process, blk_drain_queue() kicks the
> queue which failed to finish initialization and fd is unhappy about
> that.
> 
>   floppy0: no floppy controllers found
>   ------------[ cut here ]------------
>   WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
>   Hardware name: To Be Filled By O.E.M.
>   VFS: do_fd_request called on non-open device
>   Modules linked in:
>   Pid: 1, comm: swapper Not tainted 3.2.0-rc4-00077-g5983fe2 #2
>   Call Trace:
>    [<ffffffff81039a6a>] warn_slowpath_common+0x7a/0xb0
>    [<ffffffff81039b41>] warn_slowpath_fmt+0x41/0x50
>    [<ffffffff813d657f>] do_fd_request+0xbf/0xd0
>    [<ffffffff81322b95>] blk_drain_queue+0x65/0x80
>    [<ffffffff81322c93>] blk_cleanup_queue+0xe3/0x1a0
>    [<ffffffff818a809d>] floppy_init+0xdeb/0xe28
>    [<ffffffff818a72b2>] ? daring+0x6b/0x6b
>    [<ffffffff810002af>] do_one_initcall+0x3f/0x170
>    [<ffffffff81884b34>] kernel_init+0x9d/0x11e
>    [<ffffffff810317c2>] ? schedule_tail+0x22/0xa0
>    [<ffffffff815dbb14>] kernel_thread_helper+0x4/0x10
>    [<ffffffff81884a97>] ? start_kernel+0x2be/0x2be
>    [<ffffffff815dbb10>] ? gs_change+0xb/0xb
> 
> Avoid it by making blk_drain_queue() kick queue iff dispatch queue has
> something on it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Tested-by: Sergei Trofimovich <slyich@gmail.com>
> ---
>  block/blk-core.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ea70e6c..e9aa3d5 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -366,7 +366,14 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
>  		if (drain_all)
>  			blk_throtl_drain(q);
>  
> -		__blk_run_queue(q);
> +		/*
> +		 * This function might be called on a queue which failed
> +		 * driver init after queue creation.  Some drivers
> +		 * (e.g. fd) get unhappy in such cases.  Kick queue iff
> +		 * dispatch queue has something on it.
> +		 */
> +		if (!list_empty(&q->queue_head))
> +			__blk_run_queue(q);
>  
>  		if (drain_all)
>  			nr_rqs = q->rq.count[0] + q->rq.count[1];
