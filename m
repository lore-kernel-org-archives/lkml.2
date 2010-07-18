Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0GRHpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:45:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0GRHpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:45:38 -0400
Date: Sun, 18 Jul 2010 03:45:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 16/16] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100718074536.GA1191@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
 <1279284312-2411-17-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279284312-2411-17-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		if (wb_has_dirty_io(wb) && dirty_writeback_interval) {
> +			unsigned long wait;
>  
> -			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
> -			schedule_timeout(wait_jiffies);
> +			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
> +			schedule_timeout(wait);

No need for a local variable.  If you want to shorten things a bit a
schedule_timeout_msecs helper in generic code would be nice, as there
are lots of patterns like this in various kernel threads.

>  void __mark_inode_dirty(struct inode *inode, int flags)
>  {
> +	bool wakeup_bdi;
>  	struct super_block *sb = inode->i_sb;
> +	struct backing_dev_info *uninitialized_var(bdi);

Just initialize wakeup_bdi and bdi here - a smart compiler will defer
them until we need them, and it makes the code a lot easier to read, as
well as getting rid of the uninitialized_var hack.

>  		 */
>  		if (!was_dirty) {
> -			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
> -			struct backing_dev_info *bdi = wb->bdi;
> +			bdi = inode_to_bdi(inode);
>  
>  			WARN(bdi_cap_writeback_dirty(bdi) &&
>  			     !test_bit(BDI_registered, &bdi->state),
>  			     "bdi-%s not registered\n", bdi->name);
>  
> +			/*
> +			 * If this is the first dirty inode for this bdi, we
> +			 * have to wake-up the corresponding bdi thread to make
> +			 * sure background write-back happens later.
> +			 */
> +			if (!wb_has_dirty_io(&bdi->wb) &&
> +			    bdi_cap_writeback_dirty(bdi))
> +				wakeup_bdi = true;

How about redoing this as:

			if (bdi_cap_writeback_dirty(bdi)) {
				WARN(!test_bit(BDI_registered, &bdi->state),
				     "bdi-%s not registered\n", bdi->name);

				/*
				 * If this is the first dirty inode for this
				 * bdi, we have to wake-up the corresponding
				 * flusher thread to make sure background
				 * writeback happens later.
				 */
				if (!wb_has_dirty_io(&bdi->wb))
					wakeup_bdi = true;
			}

> +	if (wakeup_bdi) {
> +		bool wakeup_default = false;
> +
> +		spin_lock(&bdi->wb_lock);
> +		if (unlikely(!bdi->wb.task))
> +			wakeup_default = true;
> +		else
> +			wake_up_process(bdi->wb.task);
> +		spin_unlock(&bdi->wb_lock);
> +
> +		if (wakeup_default)
> +			wake_up_process(default_backing_dev_info.wb.task);

Same comment about just keeping wb_lock over the
default_backing_dev_info wakup as for one of the earlier patches applies
here.


Except for these nitpicks the patch looks good to me.

> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 65cb88a..818f934 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -326,7 +326,7 @@ static unsigned long bdi_longest_inactive(void)
>  	unsigned long interval;
>  
>  	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
> -	return max(5UL * 60 * HZ, wait_jiffies);
> +	return max(5UL * 60 * HZ, interval);

So previously we just ignored interval here? 

