Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab0IYVck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 17:32:40 -0400
Received: from tuxonice.net ([74.207.252.127]:40210 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0IYVcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 17:32:39 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C9E6A75.8090702@tuxonice.net>
Date: Sun, 26 Sep 2010 07:32:37 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [PATCH 05/22] Hibernation: Switch to preallocating swap.
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> <1285388224-10012-6-git-send-email-nigel@tuxonice.net> <201009252324.39445.rjw@sisk.pl>
In-Reply-To: <201009252324.39445.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morning.

On 26/09/10 07:24, Rafael J. Wysocki wrote:
> On Saturday, September 25, 2010, Nigel Cunningham wrote:
>> Switch from allocating swap as the image is written to allocating
>> storage prior to writing the image.
>
> Hmm, I think I know what the patch does, but I don't really understand the
> changelog.  Care to explain/fix?

Sure. I was a little terse, wasn't I? :)

Prior to this patch, we allocated swap as we were writing the image. 
This patch changes things so that we instead allocate all the swap we'll 
need prior to starting to write the image. It lays groundwork for later 
patches that switch from doing I/O in batches.

Regards,

Nigel

> Thanks,
> Rafael
>
>
>> Signed-off-by: Nigel Cunningham<nigel@tuxonice.net>
>> ---
>>   kernel/power/swap.c |   62 ++++++++++++++++++++++++++++++--------------------
>>   1 files changed, 37 insertions(+), 25 deletions(-)
>>
>> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
>> index cebf91c..bebd2cf 100644
>> --- a/kernel/power/swap.c
>> +++ b/kernel/power/swap.c
>> @@ -202,6 +202,33 @@ int alloc_swapdev_blocks(int needed)
>>   }
>>
>>   /**
>> + *	allocate_swap - Allocate enough swap to save the image.
>> + *
>> + *	Calculates the number of swap pages actually needed and seeks
>> + *	to allocate that many from the resume partition. Returns TRUE
>> + *	or FALSE to indicate whether we got enough storage.
>> + */
>> +
>> +static int allocate_swap(unsigned int nr_pages)
>> +{
>> +	unsigned int free_swap = count_swap_pages(root_swap, 1);
>> +
>> +	nr_pages += DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES);
>> +
>> +	pr_debug("PM: Free swap pages: %u\n", free_swap);
>> +	if (free_swap<  nr_pages)
>> +		return 0;
>> +
>> +	if (alloc_swapdev_blocks(nr_pages)<  nr_pages) {
>> +		free_all_swap_pages(root_swap);
>> +		return 0;
>> +	}
>> +
>> +	reset_storage_pos();
>> +	return 1;
>> +}
>> +
>> +/**
>>    *	free_all_swap_pages - free swap pages allocated for saving image data.
>>    *	It also frees the extents used to register which swap entries had been
>>    *	allocated.
>> @@ -324,7 +351,7 @@ static void release_swap_writer(struct swap_map_handle *handle)
>>   	handle->cur = NULL;
>>   }
>>
>> -static int get_swap_writer(struct swap_map_handle *handle)
>> +static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages)
>>   {
>>   	int ret;
>>
>> @@ -340,7 +367,12 @@ static int get_swap_writer(struct swap_map_handle *handle)
>>   		ret = -ENOMEM;
>>   		goto err_close;
>>   	}
>> -	handle->cur_swap = alloc_swapdev_block(root_swap);
>> +	if (!allocate_swap(pages)) {
>> +		printk(KERN_ERR "PM: Not enough free swap\n");
>> +		ret = -ENOSPC;
>> +		goto err_close;
>> +	}
>> +	handle->cur_swap = next_swapdev_block();
>>   	if (!handle->cur_swap) {
>>   		ret = -ENOSPC;
>>   		goto err_rel;
>> @@ -363,7 +395,7 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
>>
>>   	if (!handle->cur)
>>   		return -EINVAL;
>> -	offset = alloc_swapdev_block(root_swap);
>> +	offset = next_swapdev_block();
>>   	error = write_page(buf, offset, bio_chain);
>>   	if (error)
>>   		return error;
>> @@ -372,7 +404,7 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
>>   		error = hib_wait_on_bio_chain(bio_chain);
>>   		if (error)
>>   			goto out;
>> -		offset = alloc_swapdev_block(root_swap);
>> +		offset = next_swapdev_block();
>>   		if (!offset)
>>   			return -ENOSPC;
>>   		handle->cur->next_swap = offset;
>> @@ -463,21 +495,6 @@ static int save_image(struct swap_map_handle *handle,
>>   }
>>
>>   /**
>> - *	enough_swap - Make sure we have enough swap to save the image.
>> - *
>> - *	Returns TRUE or FALSE after checking the total amount of swap
>> - *	space avaiable from the resume partition.
>> - */
>> -
>> -static int enough_swap(unsigned int nr_pages)
>> -{
>> -	unsigned int free_swap = count_swap_pages(root_swap, 1);
>> -
>> -	pr_debug("PM: Free swap pages: %u\n", free_swap);
>> -	return free_swap>  nr_pages + PAGES_FOR_IO;
>> -}
>> -
>> -/**
>>    *	swsusp_write - Write entire image and metadata.
>>    *	@flags: flags to pass to the "boot" kernel in the image header
>>    *
>> @@ -496,16 +513,11 @@ int swsusp_write(unsigned int flags)
>>   	int error;
>>
>>   	pages = snapshot_get_image_size();
>> -	error = get_swap_writer(&handle);
>> +	error = get_swap_writer(&handle, pages);
>>   	if (error) {
>>   		printk(KERN_ERR "PM: Cannot get swap writer\n");
>>   		return error;
>>   	}
>> -	if (!enough_swap(pages)) {
>> -		printk(KERN_ERR "PM: Not enough free swap\n");
>> -		error = -ENOSPC;
>> -		goto out_finish;
>> -	}
>>   	memset(&snapshot, 0, sizeof(struct snapshot_handle));
>>   	error = snapshot_read_next(&snapshot);
>>   	if (error<  PAGE_SIZE) {
>>
>
>

