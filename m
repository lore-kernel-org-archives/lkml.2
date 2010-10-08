Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0JHHmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:42:47 -0400
Received: from canuck.infradead.org ([134.117.69.58]:49863 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab0JHHmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:42:46 -0400
Date: Fri, 8 Oct 2010 03:42:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU lists
Message-ID: <20101008074243.GB24089@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-14-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:27PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the inode LRU and IO lists are split apart, we can separate
> the locking for them. The IO lists are only ever accessed in the
> context of writeback, so a per-BDI lock for those lists separates
> them out nicely.

I think this description needs some updates.  It seems like it's from
Nick's original patch that splits the lock, but at this point we still
have inode_lock anyway.

>  
> -static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
> -{
> -	struct super_block *sb = inode->i_sb;
> -
> -	if (strcmp(sb->s_type->name, "bdev") == 0)
> -		return inode->i_mapping->a_bdi;
> -
> -	return sb->s_bdi;
> -}

Please don't extent the scope of this one.  Just add a new inode_wb_del
or similar helper to remove and inode from the writeback list.

>  		struct inode *inode = list_entry(wb->b_io.prev,
> @@ -475,7 +475,6 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>  				redirty_tail(inode);
>  				continue;
>  			}
> -
>  			/*
>  			 * The inode belongs to a different superblock.
>  			 * Bounce back to the caller to unpin this and

spurious whitespace change.

> @@ -484,7 +483,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>  			return 0;
>  		}
>  
> -		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
> +		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
>  			requeue_io(inode);
>  			continue;
>  		}

What does this have to do with the rest of the patch?

> @@ -495,8 +494,11 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>  		if (inode_dirtied_after(inode, wbc->wb_start))
>  			return 1;
>  
> -		BUG_ON(inode->i_state & I_FREEING);
> +		spin_lock(&inode->i_lock);
>  		iref_locked(inode);
> +		spin_unlock(&inode->i_lock);

Shouldn't this become a plain iref now?

> +/*
> + * check against I_FREEING as inode writeback completion could race with
> + * setting the I_FREEING and removing the inode from the LRU.
> + */
> +void inode_lru_list_add(struct inode *inode)
> +{
> +	spin_lock(&inode_lru_lock);
> +	if (list_empty(&inode->i_lru) && !(inode->i_state & I_FREEING)) {
> +		list_add(&inode->i_lru, &inode_lru);
> +		percpu_counter_inc(&nr_inodes_unused);
> +	}
> +	spin_unlock(&inode_lru_lock);
> +}

Ah, here you introduce the lru list helpers I suggested earlier.  Moving
them earlier in the series probably is a good idea to avoid exporting
nr_inodes_unused, even if the locking for the helpers will change in
this patch.

