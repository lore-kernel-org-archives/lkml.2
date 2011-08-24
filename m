Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1HXG1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:27:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39477
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527Ab1HXG1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:27:07 -0400
Date: Wed, 24 Aug 2011 02:27:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 10/13] xfs: convert buftarg LRU to generic code
Message-ID: <20110824062706.GD24077@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314089786-20535-11-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -STATIC void
> +static inline void
>  xfs_buf_lru_add(
>  	struct xfs_buf	*bp)
>  {
> -	struct xfs_buftarg *btp = bp->b_target;
> -
> -	spin_lock(&btp->bt_lru_lock);
> -	if (list_empty(&bp->b_lru)) {
> +	if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
>  		atomic_inc(&bp->b_hold);
> -		list_add_tail(&bp->b_lru, &btp->bt_lru);
> -		btp->bt_lru_nr++;
> -	}
> -	spin_unlock(&btp->bt_lru_lock);
>  }

Is there any point in keeping this wrapper?

> +static inline void
>  xfs_buf_lru_del(
>  	struct xfs_buf	*bp)
>  {
>  	if (list_empty(&bp->b_lru))
>  		return;
>  
> +	list_lru_del(&bp->b_target->bt_lru, &bp->b_lru);
>  }

It seems like all callers of list_lru_del really want the unlocked
check.  Out of your current set only two of the inode.c callers
are missing it, but given that those set I_FREEING first they should
be safe to do it as well.  What do you think about pulling
the unlocked check into list_lru_del?

