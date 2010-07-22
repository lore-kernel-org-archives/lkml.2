Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0GVDTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:19:31 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37567 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125Ab0GVDTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:19:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJNUR0x5Lc6U/2dsb2JhbACfdXLBZYUyBA
Date: Thu, 22 Jul 2010 13:19:22 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100722031922.GA3446@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:31:46PM +0300, Artem Bityutskiy wrote:
> @@ -973,22 +981,37 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 * reposition it (that would break b_dirty time-ordering).
>  		 */
>  		if (!was_dirty) {
> -			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
> -			struct backing_dev_info *bdi = wb->bdi;
> -
> -			if (bdi_cap_writeback_dirty(bdi) &&
> -			    !test_bit(BDI_registered, &bdi->state)) {
> -				WARN_ON(1);
> -				printk(KERN_ERR "bdi-%s not registered\n",
> -								bdi->name);
> +			bdi = inode_to_bdi(inode);
> +
> +			if (bdi_cap_writeback_dirty(bdi)) {
> +				WARN(!test_bit(BDI_registered, &bdi->state),
> +				     "bdi-%s not registered\n", bdi->name);
> +
> +				/*
> +				 * If this is the first dirty inode for this
> +				 * bdi, we have to wake-up the corresponding
> +				 * bdi thread to make sure background
> +				 * write-back happens later.
> +				 */
> +				if (!wb_has_dirty_io(&bdi->wb))
> +					wakeup_bdi = true;
>  			}
>  
>  			inode->dirtied_when = jiffies;
> -			list_move(&inode->i_list, &wb->b_dirty);
> +			list_move(&inode->i_list, &bdi->wb.b_dirty);
>  		}
>  	}
>  out:
>  	spin_unlock(&inode_lock);
> +
> +	if (wakeup_bdi) {
> +		spin_lock(&bdi->wb_lock);
> +		if (!bdi->wb.task)
> +			wake_up_process(default_backing_dev_info.wb.task);
> +		else
> +			wake_up_process(bdi->wb.task);
> +		spin_unlock(&bdi->wb_lock);
> +	}
>  }

We really want to wake up the bdi right away when first dirtying
the inode? I haven't looked at where the state of the bdi code is
now, but isn't it better to have a a delay there?

And rather than spreading details of how bdi tasks are managed
would you consider putting this into its own function?

Other than that, I like your patches. Out of interest, is 5 seconds
very detremental to power usage? What is a reasonable goal for
wakeups? (eg. 95%+ of possible efficiency)
