Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1JSQSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1JSQSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:18:44 -0400
Date: Wed, 19 Oct 2011 12:18:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 10/10] block: fix request_queue lifetime handling by
 making blk_queue_cleanup() proper shutdown
Message-ID: <20111019161840.GG1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318998384-22525-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 09:26:24PM -0700, Tejun Heo wrote:

[..]
>  void blk_cleanup_queue(struct request_queue *q)
>  {
> -	/*
> -	 * We know we have process context here, so we can be a little
> -	 * cautious and ensure that pending block actions on this device
> -	 * are done before moving on. Going into this function, we should
> -	 * not have processes doing IO to this device.
> -	 */
> -	blk_sync_queue(q);
> -
> -	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
> +	/* mark @q DEAD, no new request or merges will be allowed afterwards */
>  	mutex_lock(&q->sysfs_lock);
> -	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
> +	spin_lock_irq(q->queue_lock);
> +	queue_flag_set(QUEUE_FLAG_NOMERGES, q);
> +	queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
> +	queue_flag_set(QUEUE_FLAG_DEAD, q);
> +	spin_unlock_irq(q->queue_lock);
>  	mutex_unlock(&q->sysfs_lock);
>  
> +	/* drain all requests queued before DEAD marking */
> +	blk_drain_queue(q, true);
> +
> +	/* @q won't process any more request, flush async actions */
> +	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
> +	blk_sync_queue(q);
> +
> +	/* @q is and will stay empty, shutdown and put */
>  	if (q->elevator)
>  		elevator_exit(q->elevator);
> -
>  	blk_throtl_exit(q);

This is based on for-next tree? I am cloning it now. In Linus tree, 
I see that blk_throtl_exit() has been moved to blk_release_queue() again.
So now we probably need to bring it back in blk_cleanup_queue(). That


[..]
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 900a0c9..8edb949 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -309,6 +309,10 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
>  	struct blkio_cgroup *blkcg;
>  	struct request_queue *q = td->queue;
>  
> +	/* no throttling for dead queue */
> +	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
> +		return NULL;
> +

May be blk_throtl_bio() is probably a better place to do this check, just
before callig throtl_get_tg().

Thanks
Vivek
