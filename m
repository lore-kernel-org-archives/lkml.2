Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab1LOTBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:01:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46670 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab1LOTBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:01:49 -0500
Message-ID: <4EEA4412.6030505@kernel.dk>
Date: Thu, 15 Dec 2011 20:01:38 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>,
        Sergei Trofimovich <slyich@gmail.com>,
        Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 3.2-rc5] block: don't kick empty queue in blk_drain_queue()
References: <20111215185842.GB32002@google.com>
In-Reply-To: <20111215185842.GB32002@google.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-15 19:58, Tejun Heo wrote:
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

Thanks, I'll queue this up. Coincidentally, it also exposed a bug in the
fusion-io driver.

-- 
Jens Axboe

