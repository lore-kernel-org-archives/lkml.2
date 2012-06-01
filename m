Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2FAFGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 01:06:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42065 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab2FAFGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 01:06:10 -0400
Date: Fri, 1 Jun 2012 14:06:01 +0900
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: avoid infinite loop in get_task_io_context()
Message-ID: <20120601050601.GF32121@google.com>
References: <4FC6189B.9080909@fusionio.com>
 <1338402812.2760.413.camel@edumazet-glaptop>
 <4FC66D3D.6080509@fusionio.com>
 <1338404902.2760.451.camel@edumazet-glaptop>
 <1338410107.2760.544.camel@edumazet-glaptop>
 <1338460706.2760.1330.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338460706.2760.1330.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric, Jens.

On Thu, May 31, 2012 at 12:38:26PM +0200, Eric Dumazet wrote:
> [PATCH] block: avoid infinite loop in get_task_io_context()
> 
> Calling get_task_io_context() on a exiting task which isn't %current can
> loop forever. This triggers at boot time on my dev machine.
> 
> BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
> 
> Fix this by making create_task_io_context() returns -EBUSY in this case
> to break the loop.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  block/blk-ioc.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 1e2d53b..893b800 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -235,6 +235,7 @@ void ioc_clear_queue(struct request_queue *q)
>  int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
>  {
>  	struct io_context *ioc;
> +	int ret;
>  
>  	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags | __GFP_ZERO,
>  				    node);
> @@ -262,9 +263,12 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
>  		task->io_context = ioc;
>  	else
>  		kmem_cache_free(iocontext_cachep, ioc);
> +
> +	ret = task->io_context ? 0 : -EBUSY;
> +
>  	task_unlock(task);
>  
> -	return 0;
> +	return ret;

Ah, right.  This seems correct to me.

FWIW-late-Acked-by: Tejun Heo <tj@kernel.org>

Thanks. :)

-- 
tejun
