Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0HBAWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:22:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38695 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0HBAWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:22:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 09:17:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Bojan Smojver <bojan@rexursive.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
Message-Id: <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1280551286.3097.6.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	<1280486667.2608.1.camel@shrek.rexursive.com>
	<4C534C9D.8000600@tuxonice.net>
	<1280532174.2583.1.camel@shrek.rexursive.com>
	<4C5362E7.3000706@tuxonice.net>
	<1280538184.2583.11.camel@shrek.rexursive.com>
	<4C537A01.5040808@tuxonice.net>
	<1280540035.2658.5.camel@shrek.rexursive.com>
	<1280551286.3097.6.camel@shrek.rexursive.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010 14:41:26 +1000
Bojan Smojver <bojan@rexursive.com> wrote:

> On Sat, 2010-07-31 at 11:33 +1000, Bojan Smojver wrote:
> > I can go back to that easily. 
> 
> So, here is that whole enchilada one more time (it includes sync_read
> removal patch as well).
> 
> I did 3 hibernate/thaw cycles with it. Images varied from about 850 MB,
> 1.1 GB to 750 MB. I was getting 156/141 MB/s, 121/118 MBs and 141/130
> MBs speeds. Obviously, these things depend on compression ratios
> achieved etc.
> 
> I guess the number of pages (i.e. LZO_UNC_PAGES) could be made
> configurable as well.
> 
> PS. Inline, as requested.
> 


I'm sorry if I miss something.


> +	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
> +	if (!wrk) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}
> +
> +	unc = vmalloc(LZO_UNC_SIZE);
> +	if (!unc) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
> +		vfree(wrk);
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}

Now, vmallc() is used here. Then, following will happen.

1. vmalloc()
   -> vmalloc adds vmap objects and set page table entries.

2. saving image
   -> At taking snapshot of memory to the disk, above vmalloc() area is
      saved to disk as it is.
...
3. At restore
   Because you dont't remember which vmalloc() area was used for creating
   snapshot, you can't free it at swsusp_free().

memory leak ?

Thanks,
-Kame

> +
> +	cmp = vmalloc(LZO_CMP_SIZE);
> +	if (!cmp) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
> +		vfree(unc);
> +		vfree(wrk);
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}
>  
>  	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
>  		nr_to_write);
> @@ -382,16 +422,48 @@ static int save_image(struct swap_map_handle *handle,
>  	bio = NULL;
>  	do_gettimeofday(&start);
>  	while (1) {
> -		ret = snapshot_read_next(snapshot);
> -		if (ret <= 0)
> +		for (ul = 0; ul < LZO_UNC_SIZE; ul += PAGE_SIZE) {
> +			ret = snapshot_read_next(snapshot);
> +			if (ret < 0)
> +				goto out_finish;
> +
> +			if (ret == 0)
> +				break;
> +
> +			memcpy(unc + ul, data_of(*snapshot), PAGE_SIZE);
> +
> +			if (!(nr_pages % m))
> +				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
> +			nr_pages++;
> +		}
> +
> +		if (ul == 0)
> +			break;
> +
> +		ret = lzo1x_1_compress(unc, ul, cmp + LZO_HEADER, &cl, wrk);
> +		if (ret < 0) {
> +			printk(KERN_ERR "PM: LZO compression failed\n");
>  			break;
> -		ret = swap_write_page(handle, data_of(*snapshot), &bio);
> -		if (ret)
> +		}
> +
> +		if (unlikely(cl == 0 || LZO_HEADER + cl > LZO_CMP_SIZE)) {
> +			printk(KERN_ERR "PM: Invalid LZO length\n");
> +			ret = -1;
>  			break;
> -		if (!(nr_pages % m))
> -			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
> -		nr_pages++;
> +		}
> +
> +		*(size_t *)cmp = cl;
> +
> +		for (ul = 0; ul < LZO_HEADER + cl; ul += PAGE_SIZE) {
> +			memcpy(page, cmp + ul, PAGE_SIZE);
> +
> +			ret = swap_write_page(handle, page, &bio);
> +			if (ret)
> +				goto out_finish;
> +		}
>  	}
> +
> +out_finish:
>  	err2 = hib_wait_on_bio_chain(&bio);
>  	do_gettimeofday(&stop);
>  	if (!ret)
> @@ -401,6 +473,12 @@ static int save_image(struct swap_map_handle *handle,
>  	else
>  		printk(KERN_CONT "\n");
>  	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
> +
> +	vfree(cmp);
> +	vfree(unc);
> +	vfree(wrk);
> +	free_page((unsigned long)page);
> +
>  	return ret;
>  }
>  
> @@ -416,7 +494,8 @@ static int enough_swap(unsigned int nr_pages)
>  	unsigned int free_swap = count_swap_pages(root_swap, 1);
>  
>  	pr_debug("PM: Free swap pages: %u\n", free_swap);
> -	return free_swap > nr_pages + PAGES_FOR_IO;
> +	return free_swap >
> +	       (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + PAGES_FOR_IO;
>  }
>  
>  /**
> @@ -547,9 +626,30 @@ static int load_image(struct swap_map_handle *handle,
>  	int error = 0;
>  	struct timeval start;
>  	struct timeval stop;
> -	struct bio *bio;
> -	int err2;
>  	unsigned nr_pages;
> +	size_t ul, cl;
> +	unsigned char *unc, *cmp, *page;
> +
> +	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
> +	if (!page) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
> +		return -ENOMEM;
> +	}
> +
> +	unc = vmalloc(LZO_UNC_SIZE);
> +	if (!unc) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}
> +
> +	cmp = vmalloc(LZO_CMP_SIZE);
> +	if (!cmp) {
> +		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
> +		vfree(unc);
> +		free_page((unsigned long)page);
> +		return -ENOMEM;
> +	}
>  
>  	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
>  		nr_to_read);
> @@ -557,27 +657,60 @@ static int load_image(struct swap_map_handle *handle,
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> -	bio = NULL;
>  	do_gettimeofday(&start);
> +
> +	error = snapshot_write_next(snapshot);
> +	if (error <= 0)
> +		goto out_finish;
> +
>  	for ( ; ; ) {
> -		error = snapshot_write_next(snapshot);
> -		if (error <= 0)
> -			break;
> -		error = swap_read_page(handle, data_of(*snapshot), &bio);
> +		error = swap_read_page(handle, page, NULL); /* sync */
>  		if (error)
>  			break;
> -		if (snapshot->sync_read)
> -			error = hib_wait_on_bio_chain(&bio);
> -		if (error)
> +		memcpy(cmp, page, PAGE_SIZE);
> +
> +		cl = *(size_t *)cmp;
> +		if (unlikely(cl == 0 || LZO_HEADER + cl > LZO_CMP_SIZE)) {
> +			printk(KERN_ERR "PM: Invalid LZO length\n");
> +			error = -1;
> +			break;
> +		}
> +
> +		for (ul = PAGE_SIZE; ul < LZO_HEADER + cl; ul += PAGE_SIZE) {
> +			error = swap_read_page(handle, page, NULL); /* sync */
> +			if (error)
> +				goto out_finish;
> +			memcpy(cmp + ul, page, PAGE_SIZE);
> +		}
> +
> +		ul = LZO_UNC_SIZE;
> +		error = lzo1x_decompress_safe(cmp + LZO_HEADER, cl, unc, &ul);
> +		if (error < 0) {
> +			printk(KERN_ERR "PM: LZO decompression failed\n");
>  			break;
> -		if (!(nr_pages % m))
> -			printk("\b\b\b\b%3d%%", nr_pages / m);
> -		nr_pages++;
> +		}
> +
> +		if (unlikely(ul == 0 || ul > LZO_UNC_SIZE)) {
> +			printk(KERN_ERR "PM: Invalid LZO length\n");
> +			error = -1;
> +			break;
> +		}
> +
> +		for (cl = 0; cl < ul; cl += PAGE_SIZE) {
> +			memcpy(data_of(*snapshot), unc + cl, PAGE_SIZE);
> +
> +			if (!(nr_pages % m))
> +				printk("\b\b\b\b%3d%%", nr_pages / m);
> +			nr_pages++;
> +
> +			error = snapshot_write_next(snapshot);
> +			if (error <= 0)
> +				goto out_finish;
> +		}
>  	}
> -	err2 = hib_wait_on_bio_chain(&bio);
> +
> +out_finish:
>  	do_gettimeofday(&stop);
> -	if (!error)
> -		error = err2;
>  	if (!error) {
>  		printk("\b\b\b\bdone\n");
>  		snapshot_write_finalize(snapshot);
> @@ -586,6 +719,11 @@ static int load_image(struct swap_map_handle *handle,
>  	} else
>  		printk("\n");
>  	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
> +
> +	vfree(cmp);
> +	vfree(unc);
> +	free_page((unsigned long)page);
> +
>  	return error;
>  }
>  
> 
> -- 
> Bojan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

