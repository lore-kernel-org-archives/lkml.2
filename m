Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0JPJ3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:29:23 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48787 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab0JPJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:29:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGsKuUx5LcB2/2dsb2JhbAChMXK8X4VJBA
Date: Sat, 16 Oct 2010 20:29:16 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101016092916.GA32197@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287216853-17634-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:13:58PM +1100, Dave Chinner wrote:
> @@ -502,11 +527,15 @@ static void prune_icache(int nr_to_scan)
>  			iput(inode);
>  			spin_lock(&inode_lock);
>  
> -			if (inode != list_entry(inode_unused.next,
> -						struct inode, i_list))
> -				continue;	/* wrong inode or list_empty */
> -			if (!can_unuse(inode))
> +			/*
> +			 * if we can't reclaim this inode immediately, give it
> +			 * another pass through the free list so we don't spin
> +			 * on it.
> +			 */
> +			if (!can_unuse(inode)) {
> +				list_move(&inode->i_list, &inode_unused);
>  				continue;
> +			}
>  		}
>  		list_move(&inode->i_list, &freeable);
>  		WARN_ON(inode->i_state & I_NEW);

This is a bug, actually 2 bugs, which is why I omitted it in the version
you picked up. I agree we want the optimisation though, so I've added it
back in my tree.

After you iput() and then re take the inode lock, you can't reference
the inode because you don't know what happened to it. You need to keep
that pointer check to verify it is still there.

Secondly, iput sets I_REFERENCED, so you can't leave can_unuse
unmodified otherwise then it's basically always a false negative. It
needs to check for (i_state & ~I_REFERENCED)


