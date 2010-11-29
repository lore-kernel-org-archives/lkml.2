Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0K2PD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:03:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0K2PD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:03:26 -0500
Date: Mon, 29 Nov 2010 10:03:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] fs: fsync optimisations
Message-ID: <20101129150325.GD26076@infradead.org>
References: <20101123140610.292941494@kernel.dk>
 <20101123140708.058372884@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123140708.058372884@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:06:16AM +1100, npiggin@kernel.dk wrote:
> Optimise fsync by adding a datasync parameter to sync_inode_metadata to
> DTRT with writing back the inode (->write_inode in theory should have a
> datasync parameter too perhaps, but that's for another time).
> 
> Also, implement the metadata sync optimally rather than reusing the
> normal data writeback path. This means less useless moving the inode around the
> writeback lists, and less dropping and retaking of inode_lock, and avoiding
> the data writeback call with nr_pages == 0.

This patch looks good to me, but a few minor comments below:

> @@ -1315,13 +1315,49 @@ EXPORT_SYMBOL(sync_inode);
>   *
>   * Note: only writes the actual inode, no associated data or other metadata.
>   */
> -int sync_inode_metadata(struct inode *inode, int wait)
> +int sync_inode_metadata(struct inode *inode, int datasync, int wait)
>  {
> +	struct address_space *mapping = inode->i_mapping;
>  	struct writeback_control wbc = {
>  		.sync_mode = wait ? WB_SYNC_ALL : WB_SYNC_NONE,
>  		.nr_to_write = 0, /* metadata-only */
>  	};
> +	unsigned dirty, mask;
> +	int ret = 0;
>  
> -	return sync_inode(inode, &wbc);
> +	/*
> +	 * This is a similar implementation to writeback_single_inode.
> +	 * Keep them in sync.
> +	 */

I'd move this comment to above the function.

> +	/*
> +	 * Generic write_inode doesn't distinguish between sync and datasync,
> +	 * so even a datasync can clear the sync state. Filesystems which
> +	 * distiguish these cases must only clear 'mask' in their metadata
> +	 * sync code.
> +	 */

I don't understand this comment.  Currenly filesystems never clear
i_state bits by themselves.

