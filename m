Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1LGKVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:21:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1LGKVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:21:19 -0500
Date: Wed, 7 Dec 2011 11:21:17 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] writeback: balanced_rate cannot exceed write
 bandwidth
Message-ID: <20111207102117.GC4622@quack.suse.cz>
References: <20111128135338.249672012@intel.com>
 <20111128140513.038056015@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128140513.038056015@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-11-11 21:53:39, Wu Fengguang wrote:
> Add an upper limit to balanced_rate according to the below inequality.
> This filters out some rare but huge singular points, which at least
> enables more readable gnuplot figures.
> 
> When there are N dd dirtiers,
> 
> 	balanced_dirty_ratelimit = write_bw / N
> 
> So it holds that
> 
> 	balanced_dirty_ratelimit <= write_bw
> 
> The singular points originate from dirty_rate in the below formular:
> 
>         balanced_dirty_ratelimit = task_ratelimit * write_bw / dirty_rate
> where
> 	dirty_rate = (number of page dirties in the past 200ms) / 200ms
> 
> In the extreme case, if all dd tasks suddenly get blocked on something
> else and hence no pages are dirtied at all, dirty_rate will be 0 and
> balanced_dirty_ratelimit will be inf. This could happen in reality.
> 
> Note that these huge singular points are not a real threat, since they
> are _guaranteed_ to be filtered out by the
> 	min(balanced_dirty_ratelimit, task_ratelimit)
> line in bdi_update_dirty_ratelimit(). task_ratelimit is based on the
> number of dirty pages, which will never _suddenly_ fly away like
> balanced_dirty_ratelimit. So any weirdly large balanced_dirty_ratelimit
> will be cut down to the level of task_ratelimit.
> 
> There won't be tiny singular points though, as long as the dirty pages
> lie inside the dirty throttling region (above the freerun region).
> Because there the dd tasks will be throttled by balanced_dirty_pages()
> and won't be able to suddenly dirty much more pages than average.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  After your explanation I agree as well. So you can add
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-17 20:18:03.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-17 20:18:23.000000000 +0800
> @@ -804,6 +804,11 @@ static void bdi_update_dirty_ratelimit(s
>  	 */
>  	balanced_dirty_ratelimit = div_u64((u64)task_ratelimit * write_bw,
>  					   dirty_rate | 1);
> +	/*
> +	 * balanced_dirty_ratelimit ~= (write_bw / N) <= write_bw
> +	 */
> +	if (unlikely(balanced_dirty_ratelimit > write_bw))
> +		balanced_dirty_ratelimit = write_bw;
>  
>  	/*
>  	 * We could safely do this and return immediately:
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
