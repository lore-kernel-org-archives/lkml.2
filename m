Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2K3WwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:52:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45817 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2K3WwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:52:07 -0500
Date: Fri, 30 Nov 2012 14:52:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
Message-ID: <20121130225200.GB6021@htj.dyndns.org>
References: <50A78AA9.5040904@iskon.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A78AA9.5040904@iskon.hr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Zlatko.

Sorry about the delay.  Your message was in my spam folder.  The
attachment seems to have confused the filter.

On Sat, Nov 17, 2012 at 02:01:29PM +0100, Zlatko Calusic wrote:
> This week I spent some hours tracking a regression in 3.7 kernel
> that was producing high context switch rate on one of my machines. I
> carefully bisected between 3.6 and 3.7-rc1 and eventually found this
> commit a culprit:
> 
> commit e7c2f967445dd2041f0f8e3179cca22bb8bb7f79
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Aug 21 13:18:24 2012 -0700
> 
>     workqueue: use mod_delayed_work() instead of __cancel + queue
...
> 
> Then I carefully reverted chunk by chunk to find out what exact
> change is responsible for the regression. You can find it attached
> as wq.patch (to preserve whitespace). Very simple modification with
> wildly different behavior on only one of my machines, weird. I'm
> also attaching ctxt/s graph that shows the impact nicely. I'll
> gladly provide any additional info that could help you resolve this.
> 
> Please Cc: on reply (not subscribed to lkml).
> 
> Regards,
> -- 
> Zlatko

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4b4dbdf..4b8b606 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -319,10 +319,8 @@ EXPORT_SYMBOL(__blk_run_queue);
>   */
>  void blk_run_queue_async(struct request_queue *q)
>  {
> -	if (likely(!blk_queue_stopped(q))) {
> -		__cancel_delayed_work(&q->delay_work);
> -		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
> -	}
> +	if (likely(!blk_queue_stopped(q)))
> +		mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>  }
>  EXPORT_SYMBOL(blk_run_queue_async);

That's intersting.  Is there anything else noticeably different than
the ctxsw counts?  e.g. CPU usage, IO throughput / latency, etc...
Also, can you please post the kernel boot log from the machine?  I
assume that the issue is readily reproducible?  Are you up for trying
some debug patches?

Thanks.

-- 
tejun
