Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1KUWu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:50:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1KUWu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:50:57 -0500
Date: Mon, 21 Nov 2011 23:50:49 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] writeback: balanced_rate cannot exceed write
 bandwidth
Message-ID: <20111121225049.GE4017@quack.suse.cz>
References: <20111121130342.211953629@intel.com>
 <20111121131215.645601798@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121131215.645601798@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-11-11 21:03:43, Wu Fengguang wrote:
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
  The change makes sense, but do we understand why there are such huge
singular points? Are they due to errors in estimation of bandwidth or due
to errors in dirtying rate computations (e.g. due to truncates), or
something else?

								Honza

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
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
