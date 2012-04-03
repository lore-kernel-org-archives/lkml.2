Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab2DCE1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 00:27:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab2DCE1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 00:27:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v8]: Hibernation: lower/better control the amount of pages used for buffering
Date: Tue, 3 Apr 2012 06:31:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
References: <1333418527.2035.11.camel@shrek.rexursive.com>
In-Reply-To: <1333418527.2035.11.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204030631.24974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, April 03, 2012, Bojan Smojver wrote:
> Hi Rafael,
> 
> Here is another version of the same, this time with a hint of
> super-paranoia. The only change when compared to v7 is the test of free
> pages v. required free pages. This version will trigger BIO chain flush
> on less or equal, instead of just on less. Just in case required free
> pages becomes zero in the calculations.

OK, thanks.  I'll queue that up for 3.5 when I'm back from San Francisco
(most likely on Sunday if everything goes well).

Please let me know if you want to make any more updates by then.

Thanks,
Rafael


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
>  kernel/power/swap.c |   35 ++++++++++++++++++++++++-----------
>  1 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 8742fd0..26d304b 100644
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
> @@ -51,6 +51,15 @@
>  
>  #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
>  
> +/*
> + * Number of pages required to be kept free while writing the image. Always
> + * three quarters of all available pages before the writing starts.
> + */
> +static inline unsigned long reqd_free_pages(void)
> +{
> +	return (nr_free_pages() / 4) * 3;
> +}
> +
>  struct swap_map_page {
>  	sector_t entries[MAP_PAGE_ENTRIES];
>  	sector_t next_swap;
> @@ -72,7 +81,7 @@ struct swap_map_handle {
>  	sector_t cur_swap;
>  	sector_t first_sector;
>  	unsigned int k;
> -	unsigned long nr_free_pages, written;
> +	unsigned long reqd_free_pages;
>  	u32 crc32;
>  };
>  
> @@ -316,8 +325,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
>  		goto err_rel;
>  	}
>  	handle->k = 0;
> -	handle->nr_free_pages = nr_free_pages() >> 1;
> -	handle->written = 0;
> +	handle->reqd_free_pages = reqd_free_pages();
>  	handle->first_sector = handle->cur_swap;
>  	return 0;
>  err_rel:
> @@ -352,11 +360,15 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
>  		handle->cur_swap = offset;
>  		handle->k = 0;
>  	}
> -	if (bio_chain && ++handle->written > handle->nr_free_pages) {
> +	if (bio_chain && nr_free_pages() <= handle->reqd_free_pages) {
>  		error = hib_wait_on_bio_chain(bio_chain);
>  		if (error)
>  			goto out;
> -		handle->written = 0;
> +		/*
> +		 * Recalculate the number of required free pages, to make sure
> +		 * we never take more than a quarter.
> +		 */
> +		handle->reqd_free_pages = reqd_free_pages();
>  	}
>   out:
>  	return error;
> @@ -404,7 +416,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
>  #define LZO_THREADS	3
>  
>  /* Maximum number of pages for read buffering. */
> -#define LZO_READ_PAGES	(MAP_PAGE_ENTRIES * 8)
> +#define LZO_READ_PAGES	8192
>  
>  
>  /**
> @@ -615,10 +627,10 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  	}
>  
>  	/*
> -	 * Adjust number of free pages after all allocations have been done.
> -	 * We don't want to run out of pages when writing.
> +	 * Adjust the number of required free pages after all allocations have
> +	 * been done. We don't want to run out of pages when writing.
>  	 */
> -	handle->nr_free_pages = nr_free_pages() >> 1;
> +	handle->reqd_free_pages = reqd_free_pages();
>  
>  	/*
>  	 * Start the CRC32 thread.
> @@ -1129,8 +1141,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  
>  	/*
>  	 * Adjust number of pages for read buffering, in case we are short.
> +	 * Never take more than a quarter of all available pages.
>  	 */
> -	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1;
> +	read_pages = (nr_free_pages() - snapshot_get_image_size()) / 4;
>  	read_pages = clamp_val(read_pages, LZO_CMP_PAGES, LZO_READ_PAGES);
>  
>  	for (i = 0; i < read_pages; i++) {
> ---------------------------------------
> 
> 

