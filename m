Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0JHHI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:08:59 -0400
Received: from canuck.infradead.org ([134.117.69.58]:49160 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0JHHI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:08:58 -0400
Date: Fri, 8 Oct 2010 03:08:56 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101008070856.GC23595@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

A few nipicks on the comments or lack thereof below:

> @@ -489,8 +484,15 @@ static void prune_icache(int nr_to_scan)
>  
>  		inode = list_entry(inode_unused.prev, struct inode, i_list);
>  
> -		if (inode->i_state || atomic_read(&inode->i_count)) {
> +		if (atomic_read(&inode->i_count) ||
> +		    (inode->i_state & ~I_REFERENCED)) {
> +			list_del_init(&inode->i_list);
> +			percpu_counter_dec(&nr_inodes_unused);
> +			continue;
> +		}
> +		if (inode->i_state & I_REFERENCED) {
>  			list_move(&inode->i_list, &inode_unused);
> +			inode->i_state &= ~I_REFERENCED;
>  			continue;

I think this code could use some comments explaining the lazy LRU
scheme.

> -			if (inode != list_entry(inode_unused.next,
> -						struct inode, i_list))
> -				continue;	/* wrong inode or list_empty */
> -			if (!can_unuse(inode))
> +			/*
> +			 * if we can't reclaim this inod immediately, give it
> +			 * another pass through the free list so we don't spin
> +			 * on it.

s/inod/inode/

> +
> +	/*
> +	 * We avoid moving dirty inodes back onto the LRU now because I_FREEING
> +	 * is set and hence writeback_single_inode() won't move the inode
> +	 * around.
> +	 */
> +	if (!list_empty(&inode->i_list)) {
> +		list_del_init(&inode->i_list);
> +		percpu_counter_dec(&nr_inodes_unused);
> +	}
> +

The comment is a bit misleading.  We do not only avoid moving it to the
LRU, but actively delete the inode from the LRU here.  I don't think the
I_FREEING check isn't the only reason - the LRU code traditionally
couldn't deal with unlinked inodes at all, although the switch to
->evict_inode probably has fixed that.


