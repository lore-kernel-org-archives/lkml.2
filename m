Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2IDOkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:40:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab2IDOkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:40:03 -0400
Date: Tue, 4 Sep 2012 16:39:47 +0200
From: Jan Kara <jack@suse.cz>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] UDF: Add support for O_DIRECT
Message-ID: <20120904143947.GC8656@quack.suse.cz>
References: <1343731212-4381-1-git-send-email-abbotti@mev.co.uk>
 <1346752179-28052-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346752179-28052-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  first, you have my address wrong (you had suze instead of suse) which is
why I wasn't getting your email and not replying (missed the patch in LKML
traffic). Second, it's good to CC also linux-fsdevel for UDF related
matters (I tend to use that for UDF announcements etc. so people caring
about UDF can watch there and don't have to read high-volume LKML).

On Tue 04-09-12 10:49:39, Ian Abbott wrote:
> Add support for the O_DIRECT flag.  There are two cases to deal with:
  Out of curiosity, do you have a use for this feature or is it mostly
academic interest?

> 1. Small files stored in the ICB (inode control block?): just return 0
> from the new udf_adinicb_direct_IO() handler to fall back to buffered
> I/O.  For direct writes, there is a "gotcha" to deal with when
> generic_file_direct_write() in mm/filemap.c invalidates the pages.  In
> the udf_adinicb_writepage() handler, only part of the page data will be
> valid and the rest will be zeroed out, so only copy the valid part into
> the ICB.  (This is actually a bit inefficient as udf_adinicb_write_end()
> will have already copied the data into the ICB once, but it's pretty
> likely that the file will grow to the point where its data can no longer
> be stored in the ICB and will be moved to a different area of the file
> system.  At that point, a different direct_IO handler will be used - see
> below.)
  Sorry, I didn't quite get this. What is the problem with copying all the
data to inode in udf_adinicb_writepage() as it is now?

								Honza

> 2. Larger files, not stored in the ICB: nothing special here.  Just call
> blockdev_direct_IO() from our new udf_direct_IO() handler and tidy up
> any blocks instantiated outside i_size on error.  This is pretty
> standard.  Factor error handling code out of udf_write_begin() into new
> function udf_write_failed() so it can also be called by udf_direct_IO().
> 
> Also change the whitespace in udf_aops and udf_adinicb_aops to make them
> a bit neater.
> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> v2: Rework error handling in udf_direct_IO to avoid calling deprecated
>     vmtruncate().
> v3: Rebased to next-20120904.
> ---
>  fs/udf/file.c  | 29 +++++++++++++++++++++++++----
>  fs/udf/inode.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 61 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 7f3f7ba..f5f9ddd 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -34,6 +34,7 @@
>  #include <linux/errno.h>
>  #include <linux/pagemap.h>
>  #include <linux/buffer_head.h>
> +#include <linux/writeback.h>
>  #include <linux/aio.h>
>  
>  #include "udf_i.h"
> @@ -64,12 +65,23 @@ static int udf_adinicb_writepage(struct page *page,
>  	struct inode *inode = page->mapping->host;
>  	char *kaddr;
>  	struct udf_inode_info *iinfo = UDF_I(inode);
> +	loff_t start, end, page_start, page_offset;
>  
>  	BUG_ON(!PageLocked(page));
>  
>  	kaddr = kmap(page);
> -	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
> -	mark_inode_dirty(inode);
> +	/* The beginning and/or end of the page data is likely to be invalid
> +	 * for O_DIRECT, so only copy the valid part. */
> +	page_start = (loff_t)page->index << PAGE_CACHE_SHIFT;
> +	start = max(page_start, wbc->range_start);
> +	end = min3(page_start + (loff_t)PAGE_CACHE_SIZE - 1,
> +		   wbc->range_end, inode->i_size - 1);
> +	if (likely(start <= end)) {
> +		page_offset = start - page_start;
> +		memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + start,
> +		       kaddr + page_offset, (end + 1 - start));
> +		mark_inode_dirty(inode);
> +	}
>  	SetPageUptodate(page);
>  	kunmap(page);
>  	unlock_page(page);
> @@ -95,11 +107,20 @@ static int udf_adinicb_write_end(struct file *file,
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
> -	.write_begin = simple_write_begin,
> -	.write_end = udf_adinicb_write_end,
> +	.write_begin	= simple_write_begin,
> +	.write_end	= udf_adinicb_write_end,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
