Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3AJAwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:52:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3AJAwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:52:34 -0500
Date: Thu, 10 Jan 2013 01:52:32 +0100
From: David Sterba <dsterba@suse.cz>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND v1 05/16] vfs: add hooks to enable hot tracking
Message-ID: <20130110005232.GY20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
 <1356014615-15073-6-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356014615-15073-6-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:43:24PM +0800, zwu.kernel@gmail.com wrote:
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -37,6 +37,7 @@
>  #include <linux/uio.h>
>  #include <linux/atomic.h>
>  #include <linux/prefetch.h>
> +#include "hot_tracking.h"
>  
>  /*
>   * How many user pages to map in one call to get_user_pages().  This determines
> @@ -1299,6 +1300,11 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	prefetch(bdev->bd_queue);
>  	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
>  
> +	/* Hot data tracking */
> +	hot_update_freqs(inode, offset,
> +			iov_length(iov, nr_segs),
> +			rw & WRITE);

hot_update_freqs takes an 'int rw' directly, so you should pass plain
'rw' here and do the 'rw & WRITE' check in hot_freq_data_update itself.

> +
>  	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
>  				     nr_segs, get_block, end_io,
>  				     submit_io, flags);
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -35,6 +35,7 @@
>  #include <linux/buffer_head.h> /* __set_page_dirty_buffers */
>  #include <linux/pagevec.h>
>  #include <linux/timer.h>
> +#include <linux/hot_tracking.h>
>  #include <trace/events/writeback.h>
>  
>  /*
> @@ -1902,13 +1903,24 @@ EXPORT_SYMBOL(generic_writepages);
>  int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	int ret;
> +	loff_t start = 0;
> +	size_t count = 0;
>  
>  	if (wbc->nr_to_write <= 0)
>  		return 0;
> +
> +	start = mapping->writeback_index << PAGE_CACHE_SHIFT;
> +	count = wbc->nr_to_write;
> +
>  	if (mapping->a_ops->writepages)
>  		ret = mapping->a_ops->writepages(mapping, wbc);
>  	else
>  		ret = generic_writepages(mapping, wbc);
> +
> +	/* Hot data tracking */
> +	hot_update_freqs(mapping->host, start,
> +			(count - wbc->nr_to_write) * PAGE_CACHE_SIZE, 1);

I think the frequencies should not be updated in case of error returned
from writepages.

> +
>  	return ret;
>  }
>  
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -138,6 +139,12 @@ static int read_pages(struct address_space *mapping, struct file *filp,
>  out:
>  	blk_finish_plug(&plug);
>  
> +	/* Hot data tracking */
> +	hot_update_freqs(mapping->host,
> +		(loff_t)(list_entry(pages->prev, struct page, lru)->index)
> +			<< PAGE_CACHE_SHIFT,
> +		(size_t)nr_pages * PAGE_CACHE_SIZE, 0);

same comment here

> +
>  	return ret;
>  }


david
