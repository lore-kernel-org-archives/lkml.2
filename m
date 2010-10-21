Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0JUKHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:07:15 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36063 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab0JUKHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:07:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwEAP+rv0x5LdoFgWdsb2JhbAChVBYBARYiIr9WhUoE
Date: Thu, 21 Oct 2010 21:07:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] fs: Implement lazy LRU updates for inodes
Message-ID: <20101021100706.GA9797@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287622186-1935-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:49:29AM +1100, Dave Chinner wrote:
>  		} else {
>  			/*
> -			 * The inode is clean, unused
> +			 * The inode is clean. If it is unused, then make sure
> +			 * that it is put on the LRU correctly as iput_final()
> +			 * does not move dirty inodes to the LRU and dirty
> +			 * inodes are removed from the LRU during scanning.
>  			 */
> -			list_move(&inode->i_list, &inode_unused);
> +			list_del_init(&inode->i_list);
> +			if (!atomic_read(&inode->i_count))
> +				inode_lru_list_add(inode);

This "optimisation" is surely wrong. How could we have no reference
on the inode at this point?


> -static int can_unuse(struct inode *inode)
> -{
> -	if (inode->i_state)
> -		return 0;
> -	if (inode_has_buffers(inode))
> -		return 0;
> -	if (atomic_read(&inode->i_count))
> -		return 0;
> -	if (inode->i_data.nrpages)
> -		return 0;
> -	return 1;
> -}

Avoiding the reclaim optimisation? As I said, I noticed some increased
scanning in heavy reclaim from removing this.

