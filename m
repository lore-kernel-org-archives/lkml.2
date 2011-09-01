Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1IAQ3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:29:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab1IAQ3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:29:53 -0400
Date: Thu, 1 Sep 2011 18:29:50 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: fix BDI_WRITTEN accounting disturbing
 bdi->completions
Message-ID: <20110901162950.GD2070@quack.suse.cz>
References: <20110901144041.GA5681@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901144041.GA5681@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-09-11 22:40:41, Wu Fengguang wrote:
> Peter,
> 
> This is an amazing bug. I'm not sure how the accounting goes wrong in
> some tricky way. But you can compare the exact bdi proportions pattern
> before/after patch. The gray "bdi setpoint" lines are vastly different.
> 
> ---
> When increasing BDI_WRITTEN together with bdi->completions inside the
> same local irq disabling block, bdi_thresh is found to go wild in the
> 1 disk + 1 usb stick writeback test case. Fix it by moving BDI_WRITTEN
> accounting out.
  I don't understand this - the patch is just NOP. The change in
test_clear_page_writeback() does absolutely nothing and the change in
bdi_writeout_inc() just changes:
  	local_irq_save(flags);
  	__inc_bdi_stat(bdi);
  	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
  			      bdi->max_prop_frac);
  	local_irq_restore(flags);

to:
  	local_irq_save(flags);
  	__inc_bdi_stat(bdi);
  	local_irq_restore(flags);
  	local_irq_save(flags);
  	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
  			      bdi->max_prop_frac);
  	local_irq_restore(flags);

So the difference must be in something else...

								Honza
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux.orig/mm/page-writeback.c	2011-09-01 21:43:45.312000020 +0800
> +++ linux/mm/page-writeback.c	2011-09-01 21:46:10.656000006 +0800
> @@ -230,7 +230,6 @@ int dirty_bytes_handler(struct ctl_table
>   */
>  static inline void __bdi_writeout_inc(struct backing_dev_info *bdi)
>  {
> -	__inc_bdi_stat(bdi, BDI_WRITTEN);
>  	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
>  			      bdi->max_prop_frac);
>  }
> @@ -239,6 +238,7 @@ void bdi_writeout_inc(struct backing_dev
>  {
>  	unsigned long flags;
>  
> +	inc_bdi_stat(bdi, BDI_WRITTEN);
>  	local_irq_save(flags);
>  	__bdi_writeout_inc(bdi);
>  	local_irq_restore(flags);
> @@ -1577,6 +1577,7 @@ int test_clear_page_writeback(struct pag
>  						PAGECACHE_TAG_WRITEBACK);
>  			if (bdi_cap_account_writeback(bdi)) {
>  				__dec_bdi_stat(bdi, BDI_WRITEBACK);
> +				__inc_bdi_stat(bdi, BDI_WRITTEN);
>  				__bdi_writeout_inc(bdi);
>  			}
>  		}



-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
