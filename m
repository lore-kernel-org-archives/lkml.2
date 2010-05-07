Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0EGJbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:31:24 -0400
Received: from crca.org.au ([74.207.252.120]:51919 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab0EGJbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:31:19 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 05:31:19 EDT
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE3DBD6.7070707@tuxonice.net>
Date: Fri, 07 May 2010 19:22:30 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add swap slot free callback to block_device_operations
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <1273217107-2023-3-git-send-email-ngupta@vflare.org>
In-Reply-To: <1273217107-2023-3-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/05/10 17:25, Nitin Gupta wrote:
> This callback is required when RAM based devices are used as swap disks.
> One such device is ramzswap which is used as compressed in-memory swap
> disk.  For such devices, we need a callback as soon as a swap slot is no
> longer used to allow freeing memory allocated for this slot.  Without this
> callback, stale data can quickly accumulate in memory defeating the whole
> purpose of such devices.
>
> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
> ---
>   include/linux/blkdev.h |    2 ++
>   mm/swapfile.c          |    4 ++++
>   2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6690e8b..413284a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1287,6 +1287,8 @@ struct block_device_operations {
>   						unsigned long long);
>   	int (*revalidate_disk) (struct gendisk *);
>   	int (*getgeo)(struct block_device *, struct hd_geometry *);
> +	/* this callback is with swap_lock and sometimes page table lock held */
> +	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
>   	struct module *owner;
>   };
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ecb069e..f5ccc47 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -574,6 +574,7 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
>
>   	/* free if no reference */
>   	if (!usage) {
> +		struct gendisk *disk = p->bdev->bd_disk;
>   		if (offset<  p->lowest_bit)
>   			p->lowest_bit = offset;
>   		if (offset>  p->highest_bit)
> @@ -583,6 +584,9 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
>   			swap_list.next = p->type;
>   		nr_swap_pages++;
>   		p->inuse_pages--;
> +		if ((p->flags&  SWP_BLKDEV)&&
> +				disk->fops->swap_slot_free_notify)
> +			disk->fops->swap_slot_free_notify(p->bdev, offset);

Is this p->flags & SWP_BLKDEV logic reversed? (Don't you want the 
notifier called for devices that aren't backed by a block device?)

I also wonder whether leaving the p->flags & SWP_BLKDEV part out might 
be a good idea. Other potential notifier users?

Regards,

Nigel
