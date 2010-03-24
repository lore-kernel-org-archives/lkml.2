Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab0CXUdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:33:42 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35054 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932366Ab0CXUdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:33:41 -0400
Date: Wed, 24 Mar 2010 21:33:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 06/15] PM / Hibernate: swap, remove swap_map_handle usages
Message-ID: <20100324203329.GG5798@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-6-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269361063-3341-6-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-23 17:17:34, Jiri Slaby wrote:
> Some code, which will be moved out of swap.c, needs know nothing about
> swap. There will be also other than swap writers later, so that it
> won't make sense at all.
> 
> Make it a global static in swap.c as a singleton.

I guess I just dislike global static. Logically, methods do operate on
handles, so...

I don't see a point and I do not think the change is an improvement.
									Pavel


> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/swap.c |   58 +++++++++++++++++++++++++-------------------------
>  1 files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 2edf742..ac1a351 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -70,6 +70,7 @@ struct swsusp_header {
>  	char	sig[10];
>  } __attribute__((packed));
>  
> +static struct swap_map_handle swap_map_handle;
>  static struct swsusp_header *swsusp_header;
>  
>  /**
> @@ -267,8 +268,9 @@ static void release_swap_writer(struct swap_map_handle *handle)
>  	handle->cur = NULL;
>  }
>  
> -static int get_swap_writer(struct swap_map_handle *handle)
> +static int get_swap_writer(void)
>  {
> +	struct swap_map_handle *handle = &swap_map_handle;
>  	int ret;
>  
>  	ret = swsusp_swap_check();
> @@ -278,6 +280,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
>  					"swapon -a.\n");
>  		return ret;
>  	}
> +	memset(handle, 0, sizeof(*handle));
>  	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
>  	if (!handle->cur) {
>  		ret = -ENOMEM;
> @@ -298,9 +301,9 @@ err_close:
>  	return ret;
>  }
>  
> -static int swap_write_page(struct swap_map_handle *handle, void *buf,
> -				struct bio **bio_chain)
> +static int swap_write_page(void *buf, struct bio **bio_chain)
>  {
> +	struct swap_map_handle *handle = &swap_map_handle;
>  	int error = 0;
>  	sector_t offset;
>  
> @@ -338,9 +341,10 @@ static int flush_swap_writer(struct swap_map_handle *handle)
>  		return -EINVAL;
>  }
>  
> -static int put_swap_writer(struct swap_map_handle *handle,
> -		unsigned int flags, int error)
> +static int put_swap_writer(unsigned int flags, int error)
>  {
> +	struct swap_map_handle *handle = &swap_map_handle;
> +
>  	if (!error) {
>  		flush_swap_writer(handle);
>  		printk(KERN_INFO "PM: S");
> @@ -360,8 +364,7 @@ static int put_swap_writer(struct swap_map_handle *handle,
>   *	save_image - save the suspend image data
>   */
>  
> -static int save_image(struct swap_map_handle *handle,
> -                      struct snapshot_handle *snapshot,
> +static int save_image(struct snapshot_handle *snapshot,
>                        unsigned int nr_to_write)
>  {
>  	unsigned int m;
> @@ -384,7 +387,7 @@ static int save_image(struct swap_map_handle *handle,
>  		ret = snapshot_read_next(snapshot);
>  		if (ret <= 0)
>  			break;
> -		ret = swap_write_page(handle, data_of(*snapshot), &bio);
> +		ret = swap_write_page(data_of(*snapshot), &bio);
>  		if (ret)
>  			break;
>  		if (!(nr_pages % m))
> @@ -430,14 +433,13 @@ static int enough_swap(unsigned int nr_pages)
>  
>  int swsusp_write(unsigned int flags)
>  {
> -	struct swap_map_handle handle;
>  	struct snapshot_handle snapshot;
>  	struct swsusp_info *header;
>  	unsigned long pages;
>  	int error;
>  
>  	pages = snapshot_get_image_size();
> -	error = get_swap_writer(&handle);
> +	error = get_swap_writer();
>  	if (error) {
>  		printk(KERN_ERR "PM: Cannot get swap writer\n");
>  		return error;
> @@ -456,11 +458,11 @@ int swsusp_write(unsigned int flags)
>  		goto out_finish;
>  	}
>  	header = (struct swsusp_info *)data_of(snapshot);
> -	error = swap_write_page(&handle, header, NULL);
> +	error = swap_write_page(header, NULL);
>  	if (!error)
> -		error = save_image(&handle, &snapshot, pages - 1);
> +		error = save_image(&snapshot, pages - 1);
>  out_finish:
> -	error = put_swap_writer(&handle, flags, error);
> +	error = put_swap_writer(flags, error);
>  	return error;
>  }
>  
> @@ -476,9 +478,9 @@ static void release_swap_reader(struct swap_map_handle *handle)
>  	handle->cur = NULL;
>  }
>  
> -static int get_swap_reader(struct swap_map_handle *handle,
> -		unsigned int *flags_p)
> +static int get_swap_reader(unsigned int *flags_p)
>  {
> +	struct swap_map_handle *handle = &swap_map_handle;
>  	int error;
>  
>  	*flags_p = swsusp_header->flags;
> @@ -486,6 +488,7 @@ static int get_swap_reader(struct swap_map_handle *handle,
>  	if (!swsusp_header->image) /* how can this happen? */
>  		return -EINVAL;
>  
> +	memset(handle, 0, sizeof(*handle));
>  	handle->cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
>  	if (!handle->cur)
>  		return -ENOMEM;
> @@ -499,9 +502,9 @@ static int get_swap_reader(struct swap_map_handle *handle,
>  	return 0;
>  }
>  
> -static int swap_read_page(struct swap_map_handle *handle, void *buf,
> -				struct bio **bio_chain)
> +static int swap_read_page(void *buf, struct bio **bio_chain)
>  {
> +	struct swap_map_handle *handle = &swap_map_handle;
>  	sector_t offset;
>  	int error;
>  
> @@ -525,22 +528,20 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
>  	return error;
>  }
>  
> -static int put_swap_reader(struct swap_map_handle *handle)
> +static int put_swap_reader(void)
>  {
> -	release_swap_reader(handle);
> +	release_swap_reader(&swap_map_handle);
>  
>  	return 0;
>  }
>  
>  /**
> - *	load_image - load the image using the swap map handle
> + *	load_image - load the image
>   *	@handle and the snapshot handle @snapshot
>   *	(assume there are @nr_pages pages to load)
>   */
>  
> -static int load_image(struct swap_map_handle *handle,
> -                      struct snapshot_handle *snapshot,
> -                      unsigned int nr_to_read)
> +static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
>  {
>  	unsigned int m;
>  	int error = 0;
> @@ -562,7 +563,7 @@ static int load_image(struct swap_map_handle *handle,
>  		error = snapshot_write_next(snapshot);
>  		if (error <= 0)
>  			break;
> -		error = swap_read_page(handle, data_of(*snapshot), &bio);
> +		error = swap_read_page(data_of(*snapshot), &bio);
>  		if (error)
>  			break;
>  		if (snapshot->sync_read)
> @@ -597,7 +598,6 @@ static int load_image(struct swap_map_handle *handle,
>  int swsusp_read(unsigned int *flags_p)
>  {
>  	int error;
> -	struct swap_map_handle handle;
>  	struct snapshot_handle snapshot;
>  	struct swsusp_info *header;
>  
> @@ -606,14 +606,14 @@ int swsusp_read(unsigned int *flags_p)
>  	if (error < PAGE_SIZE)
>  		return error < 0 ? error : -EFAULT;
>  	header = (struct swsusp_info *)data_of(snapshot);
> -	error = get_swap_reader(&handle, flags_p);
> +	error = get_swap_reader(flags_p);
>  	if (error)
>  		goto end;
>  	if (!error)
> -		error = swap_read_page(&handle, header, NULL);
> +		error = swap_read_page(header, NULL);
>  	if (!error)
> -		error = load_image(&handle, &snapshot, header->pages - 1);
> -	put_swap_reader(&handle);
> +		error = load_image(&snapshot, header->pages - 1);
> +	put_swap_reader();
>  end:
>  	if (!error)
>  		pr_debug("PM: Image successfully loaded\n");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
