Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2E1K0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:26:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60900 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2E1K0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:26:21 -0400
Date: Mon, 28 May 2012 19:26:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Avoid missed wakeup in request waitqueue
Message-ID: <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1338178743-16956-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338178743-16956-1-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 12:19:03PM +0800, Asias He wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1f61b74..1a45877 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -359,9 +359,10 @@ EXPORT_SYMBOL(blk_put_queue);
>   */
>  void blk_drain_queue(struct request_queue *q, bool drain_all)
>  {
> +	int i;
> +
>  	while (true) {
>  		bool drain = false;
> -		int i;
>  
>  		spin_lock_irq(q->queue_lock);
>  
> @@ -400,6 +401,14 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
>  			break;
>  		msleep(10);
>  	}
> +
> +	/* Wake up threads which are sleeping on get_request() */
> +	spin_lock_irq(q->queue_lock);
> +	for (i = 0; i < ARRAY_SIZE(q->rq.wait); i++) {
> +		if (waitqueue_active(&q->rq.wait[i]))
> +			wake_up_all(&q->rq.wait[i]);
> +	}
> +	spin_unlock_irq(q->queue_lock);

I don't think we need waitqueue_active() optimization here.  Let's
just do,

	/* please explain why this is necessary */
	for (i = 0; i < ARRAY_SIZE(q->rq.wait); i++)
		wake_up_all(&q->rq.wait[i]);

Thanks.

-- 
tejun
