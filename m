Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1GXLcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 07:32:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33048
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab1GXLcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 07:32:05 -0400
Date: Sun, 24 Jul 2011 07:32:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 2/8] xfs: Warn if direct reclaim tries to writeback pages
Message-ID: <20110724113200.GA26332@infradead.org>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311265730-5324-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 05:28:44PM +0100, Mel Gorman wrote:
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -930,12 +930,13 @@ xfs_vm_writepage(
>  	 * random callers for direct reclaim or memcg reclaim.  We explicitly
>  	 * allow reclaim from kswapd as the stack usage there is relatively low.
>  	 *
> -	 * This should really be done by the core VM, but until that happens
> -	 * filesystems like XFS, btrfs and ext4 have to take care of this
> -	 * by themselves.
> +	 * This should never happen except in the case of a VM regression so
> +	 * warn about it.
>  	 */
> -	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
> +	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC) {
> +		WARN_ON_ONCE(1);
>  		goto redirty;

The nicer way to write this is

	if (WARN_ON(current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
		goto redirty;

