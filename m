Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab0GOSMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:12:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999Ab0GOSM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:12:29 -0400
Date: Thu, 15 Jul 2010 14:12:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: track AGs with reclaimable inodes in per-ag
 radix tree
Message-ID: <20100715181228.GC14554@infradead.org>
References: <1279194418-16119-1-git-send-email-david@fromorbit.com>
 <1279194418-16119-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279194418-16119-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + */
> +static struct xfs_perag *
> +xfs_inode_ag_iter_next_pag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		*first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag = NULL;
> +
> +	if (tag == XFS_ICI_RECLAIM_TAG) {
> +		int found;
> +		int ref;
> +
> +		spin_lock(&mp->m_perag_lock);
> +		found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +				(void **)&pag, *first, 1, tag);
> +		if (found <= 0) {
> +			spin_unlock(&mp->m_perag_lock);
> +			return NULL;
> +		}
> +		*first = pag->pag_agno + 1;
> +		/* open coded pag reference increment */
> +		ref = atomic_inc_return(&pag->pag_ref);
> +		spin_unlock(&mp->m_perag_lock);
> +		trace_xfs_perag_get_reclaim(mp, pag->pag_agno, ref, _RET_IP_);
> +	} else {
> +		pag = xfs_perag_get(mp, *first);
> +		(*first)++;
> +	}

I wonder if we should just split the AG iterator for inode reclaim vs
the rest.  We now have this difference in addition to taking the per-AG
lock exclusive instead of shared.

Anyway, the patch looks good for now,


Reviewed-by: Christoph Hellwig <hch@lst.de>
