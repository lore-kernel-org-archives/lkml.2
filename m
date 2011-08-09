Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1HIRqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:46:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1HIRqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:46:43 -0400
Date: Tue, 9 Aug 2011 13:46:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
Message-ID: <20110809174621.GF6482@redhat.com>
References: <20110806084447.388624428@intel.com>
 <20110806094527.002914580@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806094527.002914580@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 04:44:51PM +0800, Wu Fengguang wrote:

[..]
>   * balance_dirty_pages() must be called by processes which are generating dirty
>   * data.  It looks at the number of dirty pages in the machine and will force
>   * the caller to perform writeback if the system is over `vm_dirty_ratio'.
> @@ -1008,6 +1005,9 @@ static void balance_dirty_pages(struct a
>  	if (clear_dirty_exceeded && bdi->dirty_exceeded)
>  		bdi->dirty_exceeded = 0;
>  
> +	current->nr_dirtied = 0;
> +	current->nr_dirtied_pause = ratelimit_pages(nr_dirty, dirty_thresh);
> +
>  	if (writeback_in_progress(bdi))
>  		return;
>  
> @@ -1034,8 +1034,6 @@ void set_page_dirty_balance(struct page 
>  	}
>  }
>  
> -static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
> -
>  /**
>   * balance_dirty_pages_ratelimited_nr - balance dirty memory state
>   * @mapping: address_space which was dirtied
> @@ -1055,30 +1053,17 @@ void balance_dirty_pages_ratelimited_nr(
>  {
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  	unsigned long ratelimit;
> -	unsigned long *p;
>  
>  	if (!bdi_cap_account_dirty(bdi))
>  		return;
>  
> -	ratelimit = ratelimit_pages;
> -	if (mapping->backing_dev_info->dirty_exceeded)
> +	ratelimit = current->nr_dirtied_pause;
> +	if (bdi->dirty_exceeded)
>  		ratelimit = 8;

Should we make sure that ratelimit is more than 8? It could be that
ratelimit is 1 and we set it higher (just reverse of what we wanted?)

Thanks
Vivek
