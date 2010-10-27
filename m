Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab0J0JFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:05:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab0J0JFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:05:32 -0400
Date: Wed, 27 Oct 2010 05:05:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fs: Lock the inode LRU list separately
Message-ID: <20101027090530.GB16443@infradead.org>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288153384-8878-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -30,10 +30,13 @@
>   *
>   * inode->i_lock protects:
>   *   i_state
> + * inode_lru_lock protects:
> + *   inode_lru, i_lru
>   *
>   * Lock ordering:
>   * inode_lock
>   *   inode->i_lock
> + *     inode_lru_lock
>   */

Always writing the inode fields as inode->i_foo might be better.

> @@ -537,15 +545,10 @@ void evict_inodes(struct super_block *sb)
>  		}
>  
>  		inode->i_state |= I_FREEING;
> -		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
> +		inode_lru_list_del(inode);
>  		spin_unlock(&inode->i_lock);
>  
> -		/*
> -		 * Move the inode off the IO lists and LRU once I_FREEING is
> -		 * set so that it won't get moved back on there if it is dirty.
> -		 */
> -		list_move(&inode->i_lru, &dispose);
> +		list_add(&inode->i_lru, &dispose);
>  	}
>  	spin_unlock(&inode_lock);
>  
> @@ -582,15 +585,10 @@ int invalidate_inodes(struct super_block *sb)
>  		}
>  
>  		inode->i_state |= I_FREEING;
> -		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
> +		inode_lru_list_del(inode);
>  		spin_unlock(&inode->i_lock);

with this scheme we now decrement nr_inodes_unused twice - once in
invalidate_inodes/evict_inodes and once in dispose_one_inode.  I think
you just want to use an opencoded list_move under the lru lock to
move the inode to the temporary list for now, similar to what
prune_icache does.

