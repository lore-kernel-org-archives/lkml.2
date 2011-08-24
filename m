Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1HXGdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:33:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57992
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab1HXGc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:32:59 -0400
Date: Wed, 24 Aug 2011 02:32:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 13/13] dcache: convert to use new lru list infrastructure
Message-ID: <20110824063258.GE24077@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314089786-20535-14-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	struct list_head *freeable = arg;
> +	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
> +
> +
> +	/*

double empty line.

> +	 * we are inverting the lru lock/dentry->d_lock here,
> +	 * so use a trylock. If we fail to get the lock, just skip
> +	 * it
> +	 */
> +	if (!spin_trylock(&dentry->d_lock))
> +		return 2;
> +
> +	/*
> +	 * Referenced dentries are still in use. If they have active
> +	 * counts, just remove them from the LRU. Otherwise give them
> +	 * another pass through the LRU.
> +	 */
> +	if (dentry->d_count) {
> +		list_del_init(&dentry->d_lru);
> +		spin_unlock(&dentry->d_lock);
> +		return 0;
> +	}
> +
> +	if (dentry->d_flags & DCACHE_REFERENCED) {

The comment aove seems odd, given that it doesn't match the code.
I'd rather have something like:

	/*
	 * Used dentry, remove it from the LRU.
	 */

in its place, and a second one above the DCACHE_REFERENCED check:

	/*
	 * Referenced dentry, give it another pass through the LRU.
	 */

> +		dentry->d_flags &= ~DCACHE_REFERENCED;
> +		spin_unlock(&dentry->d_lock);
> +
> +		/*
> +		 * XXX: this list move should be be done under d_lock. Need to
> +		 * determine if it is safe just to do it under the lru lock.
> +		 */
> +		return 1;
> +	}
> +
> +	list_move_tail(&dentry->d_lru, freeable);

Another odd comment.  It talks about doing a list_move in the branch
that doesn't do the list_move, and the list_move outside the branch
actually has the d_lock, thus disagreeing with the comment.

> +	this_cpu_dec(nr_dentry_unused);
> +	spin_unlock(&dentry->d_lock);

No need to decrement the per-cpu counter while still having the lock
held.

> @@ -1094,11 +1069,10 @@ resume:
>  		/*
>  		 * move only zero ref count dentries to the dispose list.
>  		 */
> +		dentry_lru_del(dentry);
>  		if (!dentry->d_count) {
> -			dentry_lru_move_list(dentry, dispose);
> +			list_add_tail(&dentry->d_lru, dispose);
>  			found++;
> -		} else {
> -			dentry_lru_del(dentry);

I'd rather move this hunk to the previous patch, as it fits into the
logical change done there.

