Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab0J0Hzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:55:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab0J0Hz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:55:28 -0400
Date: Wed, 27 Oct 2010 03:55:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] fs: factor inode disposal
Message-ID: <20101027075520.GA11384@infradead.org>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288153384-8878-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
> + * Free the inode passed in, removing it from the lists it is still connected
> + * to but avoiding unnecessary lock round-trips for the lists it is no longer
> + * on.
> + *
> + * An inode must already be marked I_FREEING so that we avoid the inode being
> + * moved back onto lists if we race with other code that manipulates the lists
> + * (e.g. writeback_single_inode_inode). The caller is responsisble for setting this.

Too long line.

> + */
> +static void dispose_one_inode(struct inode *inode)
> +{
> +	BUG_ON(!(inode->i_state & I_FREEING));
> +
> +	spin_lock(&inode_lock);
> +	list_del_init(&inode->i_wb_list);
> +	__remove_inode_hash(inode);
> +	__inode_sb_list_del(inode);
> +	spin_unlock(&inode_lock);
> +
> +	evict(inode);
> +
> +	wake_up_inode(inode);
> +	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
> +	destroy_inode(inode);
> +}

As this is the only caller of evict left I think the code should just
be added to evict instead of a new function.  Also the hash removal
should happen after evict, so that __wait_on_freeing_inode still works.

