Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180Ab2IETCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:02:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab2IETCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:02:42 -0400
Date: Wed, 5 Sep 2012 21:02:39 +0200
From: Jan Kara <jack@suse.cz>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4] UDF: Add support for O_DIRECT
Message-ID: <20120905190239.GK18051@quack.suse.cz>
References: <20120905160019.GG18051@quack.suse.cz>
 <1346863471-3702-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346863471-3702-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-09-12 17:44:31, Ian Abbott wrote:
> Add support for the O_DIRECT flag.  There are two cases to deal with:
> 
> 1. Small files stored in the ICB (inode control block?): just return 0
> from the new udf_adinicb_direct_IO() handler to fall back to buffered
> I/O.
> 
> 2. Larger files, not stored in the ICB: nothing special here.  Just call
> blockdev_direct_IO() from our new udf_direct_IO() handler and tidy up
> any blocks instantiated outside i_size on error.  This is pretty
> standard.  Factor error handling code out of udf_write_begin() into new
> function udf_write_failed() so it can also be called by udf_direct_IO().
> 
> Also change the whitespace in udf_aops to make it a bit neater.
  Thanks! I've added the patch to my tree.

								Honza

> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> v2: Rework error handling in udf_direct_IO to avoid calling deprecated
>     vmtruncate().
> v3: Rebased to next-20120904.
> v4: Removed special handling in udf_adinicb_writepage() as that turned
>     out to be a bug in the handling of buffered writes for files in ICB,
>     fixed by Jan Kara's patch "udf: Fix data corruption for files in
>     ICB", dated 2012-09-05.  I've tested it with that patch and it seems
>     to work without corrupting file data in the ICB.
> ---
>  fs/udf/file.c  |  9 +++++++++
>  fs/udf/inode.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 45 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index d1c6093..77b5953 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -118,11 +118,20 @@ static int udf_adinicb_write_end(struct file *file,
>  	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
>  }
>  
> +static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
> +				     const struct iovec *iov,
> +				     loff_t offset, unsigned long nr_segs)
> +{
> +	/* Fallback to buffered I/O. */
> +	return 0;
> +}
> +
>  const struct address_space_operations udf_adinicb_aops = {
>  	.readpage	= udf_adinicb_readpage,
>  	.writepage	= udf_adinicb_writepage,
>  	.write_begin	= udf_adinicb_write_begin,
>  	.write_end	= udf_adinicb_write_end,
> +	.direct_IO	= udf_adinicb_direct_IO,
>  };
>  
>  static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 1a0588e..b905448 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -95,6 +95,22 @@ void udf_evict_inode(struct inode *inode)
>  	}
>  }
>  
> +static void udf_write_failed(struct address_space *mapping, loff_t to)
> +{
> +	struct inode *inode = mapping->host;
> +	struct udf_inode_info *iinfo = UDF_I(inode);
> +	loff_t isize = inode->i_size;
> +
> +	if (to > isize) {
> +		truncate_pagecache(inode, to, isize);
> +		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
> +			down_write(&iinfo->i_data_sem);
> +			udf_truncate_extents(inode);
> +			up_write(&iinfo->i_data_sem);
> +		}
> +	}
> +}
> +
>  static int udf_writepage(struct page *page, struct writeback_control *wbc)
>  {
>  	return block_write_full_page(page, udf_get_block, wbc);
> @@ -124,21 +140,24 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
>  	int ret;
>  
>  	ret = block_write_begin(mapping, pos, len, flags, pagep, udf_get_block);
> -	if (unlikely(ret)) {
> -		struct inode *inode = mapping->host;
> -		struct udf_inode_info *iinfo = UDF_I(inode);
> -		loff_t isize = inode->i_size;
> -
> -		if (pos + len > isize) {
> -			truncate_pagecache(inode, pos + len, isize);
> -			if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
> -				down_write(&iinfo->i_data_sem);
> -				udf_truncate_extents(inode);
> -				up_write(&iinfo->i_data_sem);
> -			}
> -		}
> -	}
> +	if (unlikely(ret))
> +		udf_write_failed(mapping, pos + len);
> +	return ret;
> +}
>  
> +static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
> +			     const struct iovec *iov,
> +			     loff_t offset, unsigned long nr_segs)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct address_space *mapping = file->f_mapping;
> +	struct inode *inode = mapping->host;
> +	ssize_t ret;
> +
> +	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
> +				  udf_get_block);
> +	if (unlikely(ret < 0 && (rw && WRITE)))
> +		udf_write_failed(mapping, offset + iov_length(iov, nr_segs));
>  	return ret;
>  }
>  
> @@ -152,8 +171,9 @@ const struct address_space_operations udf_aops = {
>  	.readpages	= udf_readpages,
>  	.writepage	= udf_writepage,
>  	.writepages	= udf_writepages,
> -	.write_begin		= udf_write_begin,
> -	.write_end		= generic_write_end,
> +	.write_begin	= udf_write_begin,
> +	.write_end	= generic_write_end,
> +	.direct_IO	= udf_direct_IO,
>  	.bmap		= udf_bmap,
>  };
>  
> -- 
> 1.7.12
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
