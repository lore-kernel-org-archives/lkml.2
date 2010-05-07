Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0EGJcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:32:55 -0400
Received: from crca.org.au ([74.207.252.120]:42623 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab0EGJcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:32:51 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE3DE3C.1090707@crca.org.au>
Date: Fri, 07 May 2010 19:32:44 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
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
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <1273217107-2023-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1273217107-2023-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 07/05/10 17:25, Nitin Gupta wrote:
> Added SWP_BLKDEV flag to distinguish block and regular file backed
> swap devices. We could also check if a swap is entire block device,
> rather than a file, by:
> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
> but, I think, simply checking this flag is more convenient.
>
> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
> ---
>   include/linux/swap.h |    1 +
>   mm/swapfile.c        |    1 +
>   2 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1f59d93..ec2b7a4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -146,6 +146,7 @@ enum {
>   	SWP_DISCARDING	= (1<<  3),	/* now discarding a free cluster */
>   	SWP_SOLIDSTATE	= (1<<  4),	/* blkdev seeks are cheap */
>   	SWP_CONTINUED	= (1<<  5),	/* swap_map has count continuation */
> +	SWP_BLKDEV	= (1<<  6),	/* its a block device */
>   					/* add others here before... */
>   	SWP_SCANNING	= (1<<  8),	/* refcount in scan_swap_map */
>   };
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6cd0a8f..ecb069e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1884,6 +1884,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>   		if (error<  0)
>   			goto bad_swap;
>   		p->bdev = bdev;
> +		p->flags |= SWP_BLKDEV;
>   	} else if (S_ISREG(inode->i_mode)) {
>   		p->bdev = inode->i_sb->s_bdev;
>   		mutex_lock(&inode->i_mutex);

The more I read your patches, the more I think either I'm seriously 
confused (entirely possible!) or you are.

Don't you want to distinguish RAM backed swap from swap that's either a 
partition or a file? If that's the case, you should also be setting 
SWP_BLKDEV in the S_ISREG part that follows iff the p->bdev is a regular 
file.

Regards,

Nigel
