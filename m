Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0JHKSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:18:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58451 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab0JHKSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:18:20 -0400
Date: Fri, 8 Oct 2010 11:18:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101008101819.GC19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-19-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:32PM +1100, Dave Chinner wrote:

> +			spin_unlock(&sb->s_inodes_lock);
>  
> -			spin_lock(&inode_lru_lock);
> -			list_move(&inode->i_lru, dispose);
> -			spin_unlock(&inode_lru_lock);
> +			dispose_one_inode(inode);
>  
> -			percpu_counter_dec(&nr_inodes_unused);
> +			spin_lock(&sb->s_inodes_lock);

And now you've unlocked the list and even blocked.  What's going to
keep next valid through that fun?

> +		spin_unlock(&inode_lru_lock);
> +
> +		dispose_one_inode(inode);
> +		cond_resched();
> +
> +		spin_lock(&inode_lru_lock);

Same, only worse - in the previous you might hope for lack of activity
on fs, in this one you really can't.
