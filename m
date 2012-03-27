Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2C0WmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:42:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab2C0WmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:42:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v4]: Hibernation: lower/better control the amount of pages used for buffering
Date: Wed, 28 Mar 2012 00:19:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
References: <1332463843.2021.3.camel@shrek.rexursive.com>
In-Reply-To: <1332463843.2021.3.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203280019.19241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 23, 2012, Bojan Smojver wrote:
> Hi Rafael,
> 
> One more version. This time we require that 3/4 of pages be available
> when writing the image, otherwise we flush. Just erring on the side of
> caution. Otherwise the same as v3.
> 
> ---------------------------------------
> Hibernation/thaw improvements:
> 
> 1. Set maximum number of pages for read buffering consistently, instead
> of inadvertently depending on the size of the sector type.
> 
> 2. Use at most one quarter of free pages for read buffering.
> 
> 3. Require that number of free pages when writing the image never falls
> below three quarters of total free pages available.
> 
> Signed-off-by: Bojan Smojver <bojan@rexursive.com>
> ---
>  kernel/power/swap.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 8742fd0..b06fed3 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -6,7 +6,7 @@
>   *
>   * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
>   * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
> - * Copyright (C) 2010 Bojan Smojver <bojan@rexursive.com>
> + * Copyright (C) 2010-2012 Bojan Smojver <bojan@rexursive.com>
>   *
>   * This file is released under the GPLv2.
>   *
> @@ -72,7 +72,7 @@ struct swap_map_handle {
>  	sector_t cur_swap;
>  	sector_t first_sector;
>  	unsigned int k;
> -	unsigned long nr_free_pages, written;
> +	unsigned long reqd_free_pages;
>  	u32 crc32;
>  };
>  
> @@ -316,8 +316,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
>  		goto err_rel;
>  	}
>  	handle->k = 0;
> -	handle->nr_free_pages = nr_free_pages() >> 1;
> -	handle->written = 0;
> +	handle->reqd_free_pages = (nr_free_pages() >> 2) * 3;

This computation is done in three different places in the same way.
Perhaps create a macro or a static inline function for that?

Also, I'm not sure if the microoptimization here actually helps a lot.
The compiler should be smart enough to optimize that properly.  So, I'd just
write (nr_free_pages() / 4) * 3 whose meaning is much more obvious. :-)

Apart from this, looks good.

Thanks,
Rafael


>  	handle->first_sector = handle->cur_swap;
>  	return 0;
>  err_rel:
> @@ -352,11 +351,15 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
>  		handle->cur_swap = offset;
>  		handle->k = 0;
>  	}
> -	if (bio_chain && ++handle->written > handle->nr_free_pages) {
> +	if (bio_chain && nr_free_pages() < handle->reqd_free_pages) {
>  		error = hib_wait_on_bio_chain(bio_chain);
>  		if (error)
>  			goto out;
> -		handle->written = 0;
> +		/*
> +		 * Recalculate the number of required free pages, to make sure
> +		 * we never take more than a quarter.
> +		 */
> +		handle->reqd_free_pages = (nr_free_pages() >> 2) * 3;
>  	}
>   out:
>  	return error;
> @@ -404,7 +407,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
>  #define LZO_THREADS	3
>  
>  /* Maximum number of pages for read buffering. */
> -#define LZO_READ_PAGES	(MAP_PAGE_ENTRIES * 8)
> +#define LZO_READ_PAGES	8192
>  
>  
>  /**
> @@ -615,10 +618,10 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  	}
>  
>  	/*
> -	 * Adjust number of free pages after all allocations have been done.
> -	 * We don't want to run out of pages when writing.
> +	 * Adjust the number of required free pages after all allocations have
> +	 * been done. We don't want to run out of pages when writing.
>  	 */
> -	handle->nr_free_pages = nr_free_pages() >> 1;
> +	handle->reqd_free_pages = (nr_free_pages() >> 2) * 3;
>  
>  	/*
>  	 * Start the CRC32 thread.
> @@ -1129,8 +1132,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  
>  	/*
>  	 * Adjust number of pages for read buffering, in case we are short.
> +	 * Never take more than a quarter of all available pages.
>  	 */
> -	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1;
> +	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 2;
>  	read_pages = clamp_val(read_pages, LZO_CMP_PAGES, LZO_READ_PAGES);
>  
>  	for (i = 0; i < read_pages; i++) {
> ---------------------------------------
> 
> 

