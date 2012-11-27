Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2K0QW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:22:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2K0QW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:22:28 -0500
Message-ID: <50B4E8AF.7050808@redhat.com>
Date: Tue, 27 Nov 2012 17:22:07 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] zram: reduce metadata overhead
References: <1354001201-25537-1-git-send-email-ngupta@vflare.org> <1354001201-25537-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1354001201-25537-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 08:26 AM, Nitin Gupta wrote:
> For every allocated object, zram maintains the the handle, size,
> flags and count fields. Of these, only the handle is required
> since zsmalloc now provides the object size given the handle.
> The flags field was needed only to mark a given page as zero-filled.
> Instead of this field, we now use an invalid value (-1) to mark such

Since the handle is unsigned, is this really an invalid value?

> pages. Lastly, the count field was unused, so was simply removed.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/zram/zram_drv.c |   80 ++++++++++++++-------------------------
>  drivers/staging/zram/zram_drv.h |   18 +--------
>  2 files changed, 31 insertions(+), 67 deletions(-)
> 

> [...]

> @@ -222,8 +202,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  
>  	page = bvec->bv_page;
>  
> -	if (unlikely(!zram->table[index].handle) ||
> -			zram_test_flag(zram, index, ZRAM_ZERO)) {
> +	if (unlikely(!zram->handle[index]) ||
> +			(zram->handle[index] == zero_page_handle)) {

This kind of comparison appears often. To my taste, an is_zero_page()
helper would be welcome.

>  		handle_zero_page(bvec);
>  		return 0;
>  	}

> [...]

> @@ -573,8 +551,8 @@ int zram_init_device(struct zram *zram)
>  	}
>  
>  	num_pages = zram->disksize >> PAGE_SHIFT;
> -	zram->table = vzalloc(num_pages * sizeof(*zram->table));
> -	if (!zram->table) {
> +	zram->handle = vzalloc(num_pages * sizeof(*zram->handle));
> +	if (!zram->handle) {
>  		pr_err("Error allocating zram address table\n");
>  		ret = -ENOMEM;
>  		goto fail_no_table;

Since the table goes away, for readability sake, we'd better remove all
reference to it in messages, labels and comment and write "handle"
instead.

Otherwise, the patch looks good to me.

Jerome

> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index df2eec4..8aa733c 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -54,24 +54,10 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
>  #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
>  	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
>  
> -/* Flags for zram pages (table[page_no].flags) */
> -enum zram_pageflags {
> -	/* Page consists entirely of zeros */
> -	ZRAM_ZERO,
> -
> -	__NR_ZRAM_PAGEFLAGS,
> -};
> +static const unsigned long zero_page_handle = (unsigned long)(-1);
>  
>  /*-- Data structures */
>  
> -/* Allocated for each disk page */
> -struct table {
> -	unsigned long handle;
> -	u16 size;	/* object size (excluding header) */
> -	u8 count;	/* object ref count (not yet used) */
> -	u8 flags;
> -} __aligned(4);
> -
>  struct zram_stats {
>  	u64 compr_size;		/* compressed size of pages stored */
>  	u64 num_reads;		/* failed + successful */
> @@ -90,7 +76,7 @@ struct zram {
>  	struct zs_pool *mem_pool;
>  	void *compress_workmem;
>  	void *compress_buffer;
> -	struct table *table;
> +	unsigned long *handle;	/* memory handle for each disk page */
>  	spinlock_t stat64_lock;	/* protect 64-bit stats */
>  	struct rw_semaphore lock; /* protect compression buffers and table
>  				   * against concurrent read and writes */
> 

