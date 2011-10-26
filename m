Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1JZTtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:49:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab1JZTtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:49:02 -0400
Date: Wed, 26 Oct 2011 15:48:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] block, cfq: unlink cfq_io_context's immediately
Message-ID: <20111026194857.GF355@redhat.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319593719-19132-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 06:48:36PM -0700, Tejun Heo wrote:

[..]
> +/*
> + * Slow path for ioc release in put_io_context().  Performs double-lock
> + * dancing to unlink all cic's and then frees ioc.
> + */
> +static void ioc_release_fn(struct work_struct *work)
>  {
> -	if (!hlist_empty(&ioc->cic_list)) {
> -		struct cfq_io_context *cic;
> +	struct io_context *ioc = container_of(work, struct io_context,
> +					      release_work);
> +	struct request_queue *last_q = NULL;
> +
> +	spin_lock_irq(&ioc->lock);
> +
> +	while (!hlist_empty(&ioc->cic_list)) {
> +		struct cfq_io_context *cic = hlist_entry(ioc->cic_list.first,
> +							 struct cfq_io_context,
> +							 cic_list);
> +		if (cic->q != last_q) {
> +			struct request_queue *this_q = cic->q;
> +
> +			/*
> +			 * Need to switch to @this_q.  Once we release
> +			 * @ioc->lock, it can go away along with @cic.
> +			 * Hold on to it.
> +			 */
> +			__blk_get_queue(this_q);
> +
> +			/*
> +			 * blk_put_queue() might sleep thanks to kobject
> +			 * idiocy.  Always release both locks, put and
> +			 * restart.
> +			 */
> +			if (last_q) {
> +				spin_unlock(last_q->queue_lock);
> +				spin_unlock_irq(&ioc->lock);
> +				blk_put_queue(last_q);
> +			} else {
> +				spin_unlock_irq(&ioc->lock);
> +			}
> +
> +			last_q = this_q;
> +			spin_lock_irq(this_q->queue_lock);
> +			spin_lock(&ioc->lock);
> +			continue;
> +		}
> +		ioc_release_depth_inc(cic->q);
> +		cic->exit(cic);
> +		cic->release(cic);
> +		ioc_release_depth_dec(cic->q);

cic->release(cic) can free the cic? Are we accessing cic after freeing it
up in ioc_release_depth_dec(cic->q);

Thanks
Vivek
