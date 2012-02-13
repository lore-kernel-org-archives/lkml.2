Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2BMX1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:27:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220Ab2BMX1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:27:47 -0500
Date: Mon, 13 Feb 2012 18:27:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-linus] block: blk-throttle should be drained
 regardless of q->elevator
Message-ID: <20120213232742.GH3130@redhat.com>
References: <20120213225248.GH12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213225248.GH12117@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 02:52:48PM -0800, Tejun Heo wrote:
> Currently, blk_cleanup_queue() doesn't call elv_drain_elevator() if
> q->elevator doesn't exist; however, bio based drivers don't have
> elevator initialized but can still use blk-throttle.  This patch moves
> q->elevator test inside blk_drain_queue() such that only
> elv_drain_elevator() is skipped if !q->elevator.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Vivek Goyal <vgoyal@redhat.com>

Thanks Tejun for fixing this. Looks good to me. Just a minor nit below.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

[..]
> @@ -428,13 +434,8 @@ void blk_cleanup_queue(struct request_qu
>  	spin_unlock_irq(lock);
>  	mutex_unlock(&q->sysfs_lock);
>  
> -	/*
> -	 * Drain all requests queued before DEAD marking.  The caller might
> -	 * be trying to tear down @q before its elevator is initialized, in
> -	 * which case we don't want to call into draining.
> -	 */
> -	if (q->elevator)
> -		blk_drain_queue(q, true);
> +	/* drain all requests queued before DEAD marking */

We have already marked the queue DEAD before we start draining the queue.
May be we need to fix the comment.

> +	blk_drain_queue(q, true);
