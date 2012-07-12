Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128Ab2GLOCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161046Ab2GLOCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:02:37 -0400
Date: Thu, 12 Jul 2012 10:02:16 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <npiggin@kernel.dk>, LKML List <linux-kernel@vger.kernel.org>,
        torsten.hilbrich@secunet.com, Richard Jones <rjones@redhat.com>,
        stable@vger.kernel.org, Marcos Mello <marcosfrm@gmail.com>,
        Linux Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [patch] block: fix infinite loop in __getblk_slow
Message-ID: <20120712140215.GB1685@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x498vepjdsd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer <at> redhat.com> writes:
> 
> Hi, Linus,
> 
> Jens is still on vacation, and this is a pretty important patch to get
> merged.  Would you mind taking a look?
> 
> This commit:
> 
> commit 080399aaaf3531f5b8761ec0ac30ff98891e8686
> Author: Jeff Moyer <jmoyer <at> redhat.com>
> Date:   Fri May 11 16:34:10 2012 +0200
> 
>     block: don't mark buffers beyond end of disk as mapped
> 
> exposed a bug in __getblk_slow that causes mount to hang as it loops
> infinitely waiting for a buffer that lies beyond the end of the disk to
> become uptodate.  The problem was initially reported by Torsten Hilbrich
> here: https://lkml.org/lkml/2012/6/18/54, and also reported
> independently here:
> http://www.sysresccd.org/forums/viewtopic.php?f=13&t=4511, and then
> Richard W.M. Jones and Marcos Mello noted a few separate bugzillas also
> associated with the same issue.
> 
> The main problem is here, in __getblk_slow:
> 
>         for (;;) {
>                 struct buffer_head * bh;
>                 int ret;
> 
>                 bh = __find_get_block(bdev, block, size);
>                 if (bh)
>                         return bh;
> 
>                 ret = grow_buffers(bdev, block, size);
>                 if (ret < 0)
>                         return NULL;
>                 if (ret == 0)
>                         free_more_memory();
>         }
> 
> __find_get_block does not find the block, since it will not be marked as
> mapped, and so grow_buffers is called to fill in the buffers for the
> associated page.  I believe the for (;;) loop is there primarily to
> retry in the case of memory pressure keeping grow_buffers from
> succeeding.  However, we also continue to loop for other cases, like the
> block lying beond the end of the disk.  So, the fix I came up with is to
> only loop when grow_buffers fails due to memory allocation issues
> (return value of 0).
> 
> The attached patch was tested by myself, Torsten, and Rich, and was
> found to resolve the problem in call cases.
> 
> Comments, as always, are appreciated.
> 
> Signed-off-by: Jeff Moyer <jmoyer <at> redhat.com>
> Reported-and-Tested-by: Torsten Hilbrich <torsten.hilbrich <at> secunet.com>
> Tested-by: Richard W.M. Jones <rjones <at> redhat.com>
> Cc: Stable <stable <at> vger.kernel.org>

For what it's worth, we've been carrying this patch in Fedora for a
couple of weeks now.  It has been confirmed to fix:

https://bugzilla.redhat.com/show_bug.cgi?id=835019

Feel free to include a:

Reviewed-by: Josh Boyer <jwboyer@redhat.com>

if you'd like.

josh

> 
> --
> Stable Notes: this patch requires backport to 3.0, 3.2 and 3.3.
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 838a9cf..c7062c8 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1036,6 +1036,9 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>  static struct buffer_head *
>  __getblk_slow(struct block_device *bdev, sector_t block, int size)
>  {
> +	int ret;
> +	struct buffer_head *bh;
> +
>  	/* Size must be multiple of hard sectorsize */
>  	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
>  			(size < 512 || size > PAGE_SIZE))) {
> @@ -1048,20 +1051,21 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
>  		return NULL;
>  	}
> 
> -	for (;;) {
> -		struct buffer_head * bh;
> -		int ret;
> +retry:
> +	bh = __find_get_block(bdev, block, size);
> +	if (bh)
> +		return bh;
> 
> +	ret = grow_buffers(bdev, block, size);
> +	if (ret == 0) {
> +		free_more_memory();
> +		goto retry;
> +	} else if (ret > 0) {
>  		bh = __find_get_block(bdev, block, size);
>  		if (bh)
>  			return bh;
> -
> -		ret = grow_buffers(bdev, block, size);
> -		if (ret < 0)
> -			return NULL;
> -		if (ret == 0)
> -			free_more_memory();
>  	}
> +	return NULL;
>  }
> 
>  /*
> 
