Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab0HDCnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:43:00 -0400
Received: from tuxonice.net ([74.207.252.127]:44389 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0HDCm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:42:58 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C58D3B0.10602@tuxonice.net>
Date: Wed, 04 Aug 2010 12:42:56 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	 <1280486667.2608.1.camel@shrek.rexursive.com>	 <4C534C9D.8000600@tuxonice.net>	 <1280532174.2583.1.camel@shrek.rexursive.com>	 <4C5362E7.3000706@tuxonice.net>	 <1280538184.2583.11.camel@shrek.rexursive.com>	 <4C537A01.5040808@tuxonice.net>	 <1280540035.2658.5.camel@shrek.rexursive.com>	 <1280551286.3097.6.camel@shrek.rexursive.com>	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>	 <1280710453.2727.8.camel@shrek.rexursive.com>	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>	 <1280712068.2671.0.camel@shrek.rexursive.com>	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>	 <1280713381.2673.2.camel@shrek.rexursive.com>	 <1280800750.3305.4.camel@shrek.rexursive.com> <1280802642.2627.2.camel@shrek.rexursive.com>
In-Reply-To: <1280802642.2627.2.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 03/08/10 12:30, Bojan Smojver wrote:
> On Tue, 2010-08-03 at 11:59 +1000, Bojan Smojver wrote:
>> PS. I also enhanced the patch to use overlapping compression in order
>> to save memory. Looks like that's causing it to be slower on
>> compression (we go down from 130 - 150 MB/s to around 105 - 110 MB/s),
>> but still over 3 times faster than regular swsusp code. Decompression
>> remains roughly the same around 100+ MB/s (this is double the speed of
>> current swsusp code). I will post this a bit later on.
>
> As promised.

Round here, people generally like to see improvements split up into 
small patches that change just one thing. I'd therefore suggest 
splitting the removal of sync_read from the rest of the patch. Is it 
standalone? I'm not seeing the relationship between the two parts at the 
moment.

> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index ca6066a..cb57eb9 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -137,6 +137,8 @@ config SUSPEND_FREEZER
>   config HIBERNATION
>   	bool "Hibernation (aka 'suspend to disk')"
>   	depends on PM&&  SWAP&&  ARCH_HIBERNATION_POSSIBLE
> +	select LZO_COMPRESS
> +	select LZO_DECOMPRESS
>   	select SUSPEND_NVS if HAS_IOMEM
>   	---help---
>   	  Enable the suspend to disk (STD) functionality, which is usually
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 006270f..a760cf8 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -103,10 +103,6 @@ struct snapshot_handle {
>   	void		*buffer;	/* address of the block to read from
>   					 * or write to
>   					 */
> -	int		sync_read;	/* Set to one to notify the caller of
> -					 * snapshot_write_next() that it may
> -					 * need to call wait_on_bio_chain()
> -					 */
>   };
>
>   /* This macro returns the address from/to which the caller of
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 25ce010..f24ee24 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -2135,8 +2135,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
>   	if (handle->cur>  1&&  handle->cur>  nr_meta_pages + nr_copy_pages)
>   		return 0;
>
> -	handle->sync_read = 1;
> -
>   	if (!handle->cur) {
>   		if (!buffer)
>   			/* This makes the buffer be freed by swsusp_free() */
> @@ -2169,7 +2167,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
>   			memory_bm_position_reset(&orig_bm);
>   			restore_pblist = NULL;
>   			handle->buffer = get_buffer(&orig_bm,&ca);
> -			handle->sync_read = 0;
>   			if (IS_ERR(handle->buffer))
>   				return PTR_ERR(handle->buffer);
>   		}
> @@ -2178,8 +2175,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
>   		handle->buffer = get_buffer(&orig_bm,&ca);
>   		if (IS_ERR(handle->buffer))
>   			return PTR_ERR(handle->buffer);
> -		if (handle->buffer != buffer)
> -			handle->sync_read = 0;
>   	}
>   	handle->cur++;
>   	return PAGE_SIZE;
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index b0bb217..5a83fd3 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -24,6 +24,7 @@
>   #include<linux/swapops.h>
>   #include<linux/pm.h>
>   #include<linux/slab.h>
> +#include<linux/lzo.h>
>
>   #include "power.h"
>
> @@ -357,6 +358,18 @@ static int swap_writer_finish(struct swap_map_handle *handle,
>   	return error;
>   }
>
> +#define LZO_HEADER	sizeof(size_t)
> +#define LZO_UNC_PAGES	64
> +#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
> +#define LZO_CMP_PAGES	DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + \
> +			             LZO_HEADER, PAGE_SIZE)
> +#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
> +#define LZO_OVH_PAGES	DIV_ROUND_UP((LZO_UNC_SIZE > 0xBFFF ? \
> +			              0xBFFF : LZO_UNC_SIZE) + \
> +			             LZO_UNC_SIZE / 16 + 64 + 3 + \
> +			             LZO_HEADER, PAGE_SIZE)
> +#define LZO_OVH_SIZE	(LZO_OVH_PAGES + PAGE_SIZE)
> +

Some commenting for these #defines would be good, especially the 'magic' 
numbers 0xBFF, 16, 64 and 3. It's all a bit unreadable, too :) Maybe 
something like (untested...):

#define LZO_HEADER	sizeof(size_t)
#define LZO_UNC_PAGES	64
#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
#define LZO_CMP_PAGES	\
   DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + LZO_HEADER,
		PAGE_SIZE)
#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
#define LZO_MAGIC_1 0xBFFF /* Rename to whatever this is */
#define LZO_MAGIC_2 16 /* Rename */
#define LZO_MAGIC_3 (64 + 3) /* Rename */
#define LZO_OVH_PAGES
   DIV_ROUND_UP(min(LZO_UNC_SIZE, LZO_MAGIC_1) + \
		LZO_UNC_SIZE / LZO_MAGIC2 + \
		LZO_MAGIC_3 + \
		LZO_HEADER,
		PAGE_SIZE)
#define LZO_OVH_SIZE	(LZO_OVH_PAGES + PAGE_SIZE)


>   /**
>    *	save_image - save the suspend image data
>    */
> @@ -372,6 +385,29 @@ static int save_image(struct swap_map_handle *handle,
>   	struct bio *bio;
>   	struct timeval start;
>   	struct timeval stop;
> +	size_t ul, cl;

rename to bytes_in and bytes_out? I can guess they mean 
uncompressed/compressed length, but it's a little cryptic.

> +	unsigned char *buf, *wrk, *page;
> +
> +	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
> +	if (!page) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
> +		return -ENOMEM;
> +	}
> +
> +	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
> +	if (!wrk) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}
> +
> +	buf = vmalloc(LZO_UNC_SIZE + LZO_OVH_SIZE);
> +	if (!buf) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO buffer\n");
> +		vfree(wrk);
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}
>
>   	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
>   		nr_to_write);
> @@ -382,16 +418,50 @@ static int save_image(struct swap_map_handle *handle,
>   	bio = NULL;
>   	do_gettimeofday(&start);
>   	while (1) {
> -		ret = snapshot_read_next(snapshot);
> -		if (ret<= 0)
> +		for (ul = 0; ul<  LZO_UNC_SIZE; ul += PAGE_SIZE) {
> +			ret = snapshot_read_next(snapshot);
> +			if (ret<  0)

Not sure why my email client (Thunderbird) is shifting your comparison 
operators :(

> +				goto out_finish;
> +
> +			if (ret == 0)

if (!ret)

(Further down, too)

> +				break;
> +
> +			memcpy(buf + LZO_OVH_SIZE + ul,
> +			       data_of(*snapshot), PAGE_SIZE);
> +
> +			if (!(nr_pages % m))
> +				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
> +			nr_pages++;
> +		}
> +
> +		if (ul == 0)
> +			break;
> +
> +		ret = lzo1x_1_compress(buf + LZO_OVH_SIZE, ul,
> +		                       buf + LZO_HEADER,&cl, wrk);
> +		if (ret<  0) {
> +			printk(KERN_ERR "PM: LZO compression failed\n");
>   			break;
> -		ret = swap_write_page(handle, data_of(*snapshot),&bio);
> -		if (ret)
> +		}
> +
> +		if (unlikely(cl == 0 || LZO_HEADER + cl>  LZO_CMP_SIZE)) {
> +			printk(KERN_ERR "PM: Invalid LZO length\n");
> +			ret = -1;
>   			break;
> -		if (!(nr_pages % m))
> -			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
> -		nr_pages++;
> +		}
> +
> +		*(size_t *)buf = cl;
> +
> +		for (ul = 0; ul<  LZO_HEADER + cl; ul += PAGE_SIZE) {
> +			memcpy(page, buf + ul, PAGE_SIZE);
> +
> +			ret = swap_write_page(handle, page,&bio);
> +			if (ret)
> +				goto out_finish;
> +		}
>   	}
> +
> +out_finish:
>   	err2 = hib_wait_on_bio_chain(&bio);
>   	do_gettimeofday(&stop);
>   	if (!ret)
> @@ -401,6 +471,11 @@ static int save_image(struct swap_map_handle *handle,
>   	else
>   		printk(KERN_CONT "\n");
>   	swsusp_show_speed(&start,&stop, nr_to_write, "Wrote");
> +
> +	vfree(buf);
> +	vfree(wrk);
> +	free_page((unsigned long)page);
> +
>   	return ret;
>   }
>
> @@ -416,7 +491,8 @@ static int enough_swap(unsigned int nr_pages)
>   	unsigned int free_swap = count_swap_pages(root_swap, 1);
>
>   	pr_debug("PM: Free swap pages: %u\n", free_swap);
> -	return free_swap>  nr_pages + PAGES_FOR_IO;
> +	return free_swap>
> +	       (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + 1 + PAGES_FOR_IO;

PAGES_FOR_IO doesn't belong here, but that's not your problem :)

>   }
>
>   /**
> @@ -547,9 +623,22 @@ static int load_image(struct swap_map_handle *handle,
>   	int error = 0;
>   	struct timeval start;
>   	struct timeval stop;
> -	struct bio *bio;
> -	int err2;
>   	unsigned nr_pages;
> +	size_t ul, cl, off;

As per comments on ul and cl above.

[...]

Regards,

Nigel

