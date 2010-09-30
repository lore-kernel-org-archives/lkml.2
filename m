Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0I3CFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:05:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0I3CFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:05:18 -0400
Date: Wed, 29 Sep 2010 22:05:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] fs: Implement lazy LRU updates for inodes.
Message-ID: <20100930020517.GB1535@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-14-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1058,8 +1051,6 @@ static void wait_sb_inodes(struct super_block *sb)
>  	 */
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> -	spin_lock(&sb_inode_list_lock);
> -
>  	/*
>  	 * Data integrity sync. Must wait for all pages under writeback,
>  	 * because there may have been pages dirtied before our sync
> @@ -1067,6 +1058,7 @@ static void wait_sb_inodes(struct super_block *sb)
>  	 * In which case, the inode may not be on the dirty list, but
>  	 * we still have to wait for that writeout.
>  	 */
> +	spin_lock(&sb_inode_list_lock);

I think this should be folded back into the patch introducing
sb_inode_list_lock.

> @@ -1083,10 +1075,10 @@ static void wait_sb_inodes(struct super_block *sb)
>  		spin_unlock(&sb_inode_list_lock);
>  		/*
>  		 * We hold a reference to 'inode' so it couldn't have been
> -		 * removed from s_inodes list while we dropped the
> -		 * sb_inode_list_lock.  We cannot iput the inode now as we can
> -		 * be holding the last reference and we cannot iput it under
> -		 * spinlock. So we keep the reference and iput it later.
> +		 * removed from s_inodes list while we dropped the i_lock.  We
> +		 * cannot iput the inode now as we can be holding the last
> +		 * reference and we cannot iput it under spinlock. So we keep
> +		 * the reference and iput it later.

This also looks like a hunk that got in by accident and should be merged
into an earlier patch.

> @@ -431,11 +412,12 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
>  		invalidate_inode_buffers(inode);
>  		if (!inode->i_count) {
>  			spin_lock(&wb_inode_list_lock);
> -			list_move(&inode->i_list, dispose);
> +			list_del(&inode->i_list);
>  			spin_unlock(&wb_inode_list_lock);
>  			WARN_ON(inode->i_state & I_NEW);
>  			inode->i_state |= I_FREEING;
>  			spin_unlock(&inode->i_lock);
> +			list_add(&inode->i_list, dispose);

Moving the list_add out of the lock looks fine, but I can't really
see how it's related to the rest of the patch.

> +		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
> +			list_del_init(&inode->i_list);
> +			spin_unlock(&inode->i_lock);
> +			atomic_dec(&inodes_stat.nr_unused);
> +			continue;
> +		}
> +		if (inode->i_state) {

Slightly confusing but okay given the only i_state that will get us here
is I_REFERENCED.  Do we really care about the additional cycle or two a
dumb compiler might generate when writing

	if (inode->i_state & I_REFERENCED)

?

>  		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
> +			list_move(&inode->i_list, &inode_unused);

Why are we now moving the inode to the front of the list? 

> @@ -687,9 +652,6 @@ __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
>  	atomic_inc(&inodes_stat.nr_inodes);
>  	list_add(&inode->i_sb_list, &sb->s_inodes);
>  	spin_unlock(&sb_inode_list_lock);
> -	spin_lock(&wb_inode_list_lock);
> -	list_add(&inode->i_list, &inode_in_use);
> -	spin_unlock(&wb_inode_list_lock);
>  	if (b) {
>  		spin_lock_bucket(b);
>  		hlist_bl_add_head(&inode->i_hash, &b->head);

At some point it might be worth to split this into

	inode_add_to_sb_list

and

	__inode_add_to_hash

but that can be left for later.

