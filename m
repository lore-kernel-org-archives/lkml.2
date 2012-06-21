Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227Ab2FUUh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:37:29 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932Ab2FUUh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:37:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: PM: Print hibernation/thaw progress indicator one line at a time
Date: Thu, 21 Jun 2012 22:42:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <1340144178.29338.6.camel@shrek.rexursive.com>
In-Reply-To: <1340144178.29338.6.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206212242.49614.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 20, 2012, Bojan Smojver wrote:
> Hi Rafael,
> 
> Here is the final version of the patch, with your latest suggestion
> implemented.
> 
> ------------------------------
> PM: Print hibernation/thaw progress indicator one line at a time.
> 
> With the introduction of suspend to both into in-kernel hibernation
> code, dmesg was getting polluted with backspace characters printed as
> part of image saving progress indicator. This patch introduces printing
> of progress indicator on image save/load every 10% and one line at a
> time. As an additional benefit, all other messages emitted by the kernel
> during hibernation/thaw should now print cleanly as well.
> 
> Signed-off-by: Bojan Smojver <bojan@rexursive.com>

Thanks, queued up for 3.6 in linux-pm/linux-next.

Rafael


> ---
>  kernel/power/swap.c |   54 +++++++++++++++++++++++++--------------------------
>  1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 11e22c0..948f0d2 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -448,9 +448,9 @@ static int save_image(struct swap_map_handle *handle,
>  	struct timeval start;
>  	struct timeval stop;
>  
> -	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
> +	printk(KERN_INFO "PM: Saving image data pages (%u pages)...\n",
>  		nr_to_write);
> -	m = nr_to_write / 100;
> +	m = nr_to_write / 10;
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> @@ -464,7 +464,8 @@ static int save_image(struct swap_map_handle *handle,
>  		if (ret)
>  			break;
>  		if (!(nr_pages % m))
> -			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
> +			printk(KERN_INFO "PM: Image saving progress: %3d%%\n",
> +			       nr_pages / m * 10);
>  		nr_pages++;
>  	}
>  	err2 = hib_wait_on_bio_chain(&bio);
> @@ -472,9 +473,7 @@ static int save_image(struct swap_map_handle *handle,
>  	if (!ret)
>  		ret = err2;
>  	if (!ret)
> -		printk(KERN_CONT "\b\b\b\bdone\n");
> -	else
> -		printk(KERN_CONT "\n");
> +		printk(KERN_INFO "PM: Image saving done.\n");
>  	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
>  	return ret;
>  }
> @@ -668,9 +667,9 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  
>  	printk(KERN_INFO
>  		"PM: Using %u thread(s) for compression.\n"
> -		"PM: Compressing and saving image data (%u pages) ...     ",
> +		"PM: Compressing and saving image data (%u pages)...\n",
>  		nr_threads, nr_to_write);
> -	m = nr_to_write / 100;
> +	m = nr_to_write / 10;
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> @@ -690,8 +689,10 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  				       data_of(*snapshot), PAGE_SIZE);
>  
>  				if (!(nr_pages % m))
> -					printk(KERN_CONT "\b\b\b\b%3d%%",
> -				               nr_pages / m);
> +					printk(KERN_INFO
> +					       "PM: Image saving progress: "
> +					       "%3d%%\n",
> +				               nr_pages / m * 10);
>  				nr_pages++;
>  			}
>  			if (!off)
> @@ -761,11 +762,8 @@ out_finish:
>  	do_gettimeofday(&stop);
>  	if (!ret)
>  		ret = err2;
> -	if (!ret) {
> -		printk(KERN_CONT "\b\b\b\bdone\n");
> -	} else {
> -		printk(KERN_CONT "\n");
> -	}
> +	if (!ret)
> +		printk(KERN_INFO "PM: Image saving done.\n");
>  	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
>  out_clean:
>  	if (crc) {
> @@ -973,9 +971,9 @@ static int load_image(struct swap_map_handle *handle,
>  	int err2;
>  	unsigned nr_pages;
>  
> -	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
> +	printk(KERN_INFO "PM: Loading image data pages (%u pages)...\n",
>  		nr_to_read);
> -	m = nr_to_read / 100;
> +	m = nr_to_read / 10;
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> @@ -993,7 +991,8 @@ static int load_image(struct swap_map_handle *handle,
>  		if (ret)
>  			break;
>  		if (!(nr_pages % m))
> -			printk("\b\b\b\b%3d%%", nr_pages / m);
> +			printk(KERN_INFO "PM: Image loading progress: %3d%%\n",
> +			       nr_pages / m * 10);
>  		nr_pages++;
>  	}
>  	err2 = hib_wait_on_bio_chain(&bio);
> @@ -1001,12 +1000,11 @@ static int load_image(struct swap_map_handle *handle,
>  	if (!ret)
>  		ret = err2;
>  	if (!ret) {
> -		printk("\b\b\b\bdone\n");
> +		printk(KERN_INFO "PM: Image loading done.\n");
>  		snapshot_write_finalize(snapshot);
>  		if (!snapshot_image_loaded(snapshot))
>  			ret = -ENODATA;
> -	} else
> -		printk("\n");
> +	}
>  	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
>  	return ret;
>  }
> @@ -1185,9 +1183,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  
>  	printk(KERN_INFO
>  		"PM: Using %u thread(s) for decompression.\n"
> -		"PM: Loading and decompressing image data (%u pages) ...     ",
> +		"PM: Loading and decompressing image data (%u pages)...\n",
>  		nr_threads, nr_to_read);
> -	m = nr_to_read / 100;
> +	m = nr_to_read / 10;
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> @@ -1319,7 +1317,10 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  				       data[thr].unc + off, PAGE_SIZE);
>  
>  				if (!(nr_pages % m))
> -					printk("\b\b\b\b%3d%%", nr_pages / m);
> +					printk(KERN_INFO
> +					       "PM: Image loading progress: "
> +					       "%3d%%\n",
> +					       nr_pages / m * 10);
>  				nr_pages++;
>  
>  				ret = snapshot_write_next(snapshot);
> @@ -1344,7 +1345,7 @@ out_finish:
>  	}
>  	do_gettimeofday(&stop);
>  	if (!ret) {
> -		printk("\b\b\b\bdone\n");
> +		printk(KERN_INFO "PM: Image loading done.\n");
>  		snapshot_write_finalize(snapshot);
>  		if (!snapshot_image_loaded(snapshot))
>  			ret = -ENODATA;
> @@ -1357,8 +1358,7 @@ out_finish:
>  				}
>  			}
>  		}
> -	} else
> -		printk("\n");
> +	}
>  	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
>  out_clean:
>  	for (i = 0; i < ring_size; i++)
> ------------------------------
> 
> 

