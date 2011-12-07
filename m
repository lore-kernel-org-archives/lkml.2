Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1LGK5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:57:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1LGK5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:57:17 -0500
Date: Wed, 7 Dec 2011 11:57:15 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] writeback: comment on the bdi dirty threshold
Message-ID: <20111207105715.GG4622@quack.suse.cz>
References: <20111128135338.249672012@intel.com>
 <20111128140513.777795684@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128140513.777795684@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-11-11 21:53:45, Wu Fengguang wrote:
> We do "floating proportions" to let active devices to grow its target
> share of dirty pages and stalled/inactive devices to decrease its target
> share over time.
> 
> It works well except in the case of "an inactive disk suddenly goes
> busy", where the initial target share may be too small. To mitigate
> this, bdi_position_ratio() has the below line to raise a small
> bdi_thresh when it's safe to do so, so that the disk be feed with enough
> dirty pages for efficient IO and in turn fast rampup of bdi_thresh:
> 
>         bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
> 
> balance_dirty_pages() normally does negative feedback control which
> adjusts ratelimit to balance the bdi dirty pages around the target.
> In some extreme cases when that is not enough, it will have to block 
> the tasks completely until the bdi dirty pages drop below bdi_thresh.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Looks good.

  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-23 10:57:41.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-23 11:44:39.000000000 +0800
> @@ -411,8 +411,13 @@ void global_dirty_limits(unsigned long *
>   *
>   * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
>   * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
> - * And the "limit" in the name is not seriously taken as hard limit in
> - * balance_dirty_pages().
> + *
> + * Note that balance_dirty_pages() will only seriously take it as a hard limit
> + * when sleeping max_pause per page is not enough to keep the dirty pages under
> + * control. For example, when the device is completely stalled due to some error
> + * conditions, or when there are 1000 dd tasks writing to a slow 10MB/s USB key.
> + * In the other normal situations, it acts more gently by throttling the tasks
> + * more (rather than completely block them) when the bdi dirty pages go high.
>   *
>   * It allocates high/low dirty limits to fast/slow devices, in order to prevent
>   * - starving fast devices
> @@ -594,6 +599,13 @@ static unsigned long bdi_position_ratio(
>  	 */
>  	if (unlikely(bdi_thresh > thresh))
>  		bdi_thresh = thresh;
> +	/*
> +	 * It's very possible that bdi_thresh is close to 0 not because the
> +	 * device is slow, but that it has remained inactive for long time.
> +	 * Honour such devices a reasonable good (hopefully IO efficient)
> +	 * threshold, so that the occasional writes won't be blocked and active
> +	 * writes can rampup the threshold quickly.
> +	 */
>  	bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
>  	/*
>  	 * scale global setpoint to bdi's:
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
