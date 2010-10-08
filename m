Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0JHHOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:14:18 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33209 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0JHHOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:14:17 -0400
Date: Fri, 8 Oct 2010 03:14:17 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] fs: inode split IO and LRU lists
Message-ID: <20101008071417.GD23595@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-6-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:19PM +1100, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> The use of the same inode list structure (inode->i_list) for two
> different list constructs with different lifecycles and purposes
> makes it impossible to separate the locking of the different
> operations. Therefore, to enable the separation of the locking of
> the writeback and reclaim lists, split the inode->i_list into two
> separate lists dedicated to their specific tracking functions.

> @@ -410,7 +410,11 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  			redirty_tail(inode);
>  		} else {
>  			/* The inode is clean */
> -			list_move(&inode->i_list, &inode_unused);
> +			list_del_init(&inode->i_io);
> +			if (list_empty(&inode->i_lru)) {
> +				list_add(&inode->i_lru, &inode_unused);
> +				percpu_counter_inc(&nr_inodes_unused);
> +			}

This looks like it belongs into the earlier patch.  Also instead of
making nr_inodes_unused non-static a helper to manipulate it might
be a better idea.

