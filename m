Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2DXWHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:07:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35116 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab2DXWHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:07:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Wed, 25 Apr 2012 00:12:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204232359.14109.rjw@sisk.pl> <1335220840.2187.30.camel@shrek.rexursive.com>
In-Reply-To: <1335220840.2187.30.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204250012.00544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 24, 2012, Bojan Smojver wrote:
> On Mon, 2012-04-23 at 23:59 +0200, Rafael J. Wysocki wrote:
> > Please resend it with a better changelog.  I mean, please explain what
> > the regression is and why it is being fixed this way. 
> 
> ---------------------------------------
> Hibernation regression fix, since 3.2.
> 
> Calculate the number of required free pages based on non-high memory
> pages only, because that is where the buffers will come from.
> 
> Commit 081a9d043c983f161b78fdc4671324d1342b86bc introduced a new buffer
> page allocation logic during hibernation, in order to improve the
> performance. The amount of pages allocated was calculated based on total
> amount of pages available, although only non-high memory pages are
> usable for this purpose. This caused hibernation code to attempt to over
> allocate pages on platforms that have high memory, which led to hangs.
> 
> A more elaborate patch, which also addressed other hibernation/thaw
> issues, has been merged into linux-next, commit
> e9cbc5a6270be7aa9c42d9b15293ba9ac7161262.
> 
> Signed-off-by: Bojan Smojver <bojan@rexursive.com>

Applied to linux-pm/linux-next.  Will push to Linus later this week.

Thanks,
Rafael


> ---
>  kernel/power/swap.c |   33 +++++++++++++++++++++++++--------
>  1 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 8742fd0..fdf834f 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -51,6 +51,23 @@
>  
>  #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
>  
> +/*
> + * Number of free pages that are not high.
> + */
> +static inline unsigned long low_free_pages(void)
> +{
> +	return nr_free_pages() - nr_free_highpages();
> +}
> +
> +/*
> + * Number of pages required to be kept free while writing the image. Always
> + * half of all available low pages before the writing starts.
> + */
> +static inline unsigned long reqd_free_pages(void)
> +{
> +	return low_free_pages() / 2;
> +}
> +
>  struct swap_map_page {
>  	sector_t entries[MAP_PAGE_ENTRIES];
>  	sector_t next_swap;
> @@ -72,7 +89,7 @@ struct swap_map_handle {
>  	sector_t cur_swap;
>  	sector_t first_sector;
>  	unsigned int k;
> -	unsigned long nr_free_pages, written;
> +	unsigned long reqd_free_pages;
>  	u32 crc32;
>  };
>  
> @@ -316,8 +333,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
>  		goto err_rel;
>  	}
>  	handle->k = 0;
> -	handle->nr_free_pages = nr_free_pages() >> 1;
> -	handle->written = 0;
> +	handle->reqd_free_pages = reqd_free_pages();
>  	handle->first_sector = handle->cur_swap;
>  	return 0;
>  err_rel:
> @@ -352,11 +368,11 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
>  		handle->cur_swap = offset;
>  		handle->k = 0;
>  	}
> -	if (bio_chain && ++handle->written > handle->nr_free_pages) {
> +	if (bio_chain && low_free_pages() <= handle->reqd_free_pages) {
>  		error = hib_wait_on_bio_chain(bio_chain);
>  		if (error)
>  			goto out;
> -		handle->written = 0;
> +		handle->reqd_free_pages = reqd_free_pages();
>  	}
>   out:
>  	return error;
> @@ -618,7 +634,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  	 * Adjust number of free pages after all allocations have been done.
>  	 * We don't want to run out of pages when writing.
>  	 */
> -	handle->nr_free_pages = nr_free_pages() >> 1;
> +	handle->reqd_free_pages = reqd_free_pages();
>  
>  	/*
>  	 * Start the CRC32 thread.
> ---------------------------------------
> 
> 

