Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1JSNw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1JSNw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:52:58 -0400
Date: Wed, 19 Oct 2011 09:52:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        ni@google.com
Subject: Re: [PATCH 05/10] block: drop unnecessary blk_get/put_queue() in
 scsi_cmd_ioctl() and blk_get_tg()
Message-ID: <20111019135254.GD1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318998384-22525-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 09:26:19PM -0700, Tejun Heo wrote:
> blk_get/put_queue() in scsi_cmd_ioctl() and throtl_get_tg() are
> completely bogus.  The caller must have a reference to the queue on
> entry and taking an extra reference doesn't change anything.

Tejun,

What makes sure that caller has the reference to the queue upon entry. If
that's the case, that's good. Just that I had not figured it out so
resorted to defensive programming as taking extra reference does not harm.

Is it due to the fact that now you are stashing a pointer to queue in
gendisk and that will make sure any opener of device has request queue
reference or something else?

Thanks
Vivek

> 
> For scsi_cmd_ioctl(), the only effect is that it ends up checking
> QUEUE_FLAG_DEAD on entry; however, this is bogus as queue can die
> right after blk_get_queue().  Dead queue should be and is handled in
> request issue path (it's somewhat broken now but that's a separate
> problem and doesn't affect this one much).
> 
> throtl_get_tg() incorrectly assumes that q is rcu freed.  Also, it
> doesn't check return value of blk_get_queue().  If the queue is
> already dead, it ends up doing an extra put.
> 
> Drop them.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |    8 +-------
>  block/scsi_ioctl.c   |    3 +--
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index f3f495e..ecba5fc 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -324,12 +324,8 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
>  	/*
>  	 * Need to allocate a group. Allocation of group also needs allocation
>  	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
> -	 * we need to drop rcu lock and queue_lock before we call alloc
> -	 *
> -	 * Take the request queue reference to make sure queue does not
> -	 * go away once we return from allocation.
> +	 * we need to drop rcu lock and queue_lock before we call alloc.
>  	 */
> -	blk_get_queue(q);
>  	rcu_read_unlock();
>  	spin_unlock_irq(q->queue_lock);
>  
> @@ -339,13 +335,11 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
>  	 * dead
>  	 */
>  	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
> -		blk_put_queue(q);
>  		if (tg)
>  			kfree(tg);
>  
>  		return ERR_PTR(-ENODEV);
>  	}
> -	blk_put_queue(q);
>  
>  	/* Group allocated and queue is still alive. take the lock */
>  	spin_lock_irq(q->queue_lock);
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 4f4230b..fbdf0d8 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -565,7 +565,7 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
>  {
>  	int err;
>  
> -	if (!q || blk_get_queue(q))
> +	if (!q)
>  		return -ENXIO;
>  
>  	switch (cmd) {
> @@ -686,7 +686,6 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
>  			err = -ENOTTY;
>  	}
>  
> -	blk_put_queue(q);
>  	return err;
>  }
>  EXPORT_SYMBOL(scsi_cmd_ioctl);
> -- 
> 1.7.3.1
