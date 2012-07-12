Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761Ab2GLTjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:39:51 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:22889 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030747Ab2GLTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:39:50 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=sAPndErFKXR2iCEzombnEhs6KobJXuqaR8MC9YYgmky7aYunA3sFr/lfkbfe
	JSn72aBEKU/JY3f5GG8fwoDYVwYRYZPiFSbUvuJujZOXYvYEar83vgK8y
	Zas45Li5N5eUp1GXFi7nnQNv3ZkVv3tmhR9mV8QtuYqeR6w508ceHs=;
X-Spam-Processed: mail.digidescorp.com, Thu, 12 Jul 2012 14:39:48 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=15403394f6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1342121986.2156.20.camel@iscandar.digidescorp.com>
Subject: Re: mount -o loop with truncated dosdisk.img uses 100% cpu and
 can't be killed
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Date: Thu, 12 Jul 2012 14:39:46 -0500
In-Reply-To: <87k3y8yed3.fsf@devron.myhome.or.jp>
References: <20120712162828.3f561315@localhost>
	 <1342106206.2156.2.camel@iscandar.digidescorp.com>
	 <87k3y8yed3.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 04:21 +0900, OGAWA Hirofumi wrote: 
> > On Thu, 2012-07-12 at 16:28 +0200, Stevie Trujillo wrote: 
> >> Hello,
> >> 
> >> I was trying to create a bootdisk to update my BIOS, and accidentially
> >> made a 512byte image with only the FreeDOS header in it.
> >> 
> >> ( Linux 3.4.4 )
> >> # mount -o loop dosdisk.img /tmp
> >> ^C^C^C
> >> It uses 100% CPU and doesn't listen to me when I do ^C, kill -9 etc. I
> >> think this means it's stuck in the kernel?
> It looks like the bug of __getblk_slow(). If requested block was beyond
> end of device, __find_get_block() will find buffer_mapped()'s buffer,
> but block >= end_block is unmapped. So, it can be loop.
> 
> The following patch fixes it? If it fix, there are some options to check
> it.
> 
> a) Check it like this patch and warn.
> b) (a), but without warn.
> c) Check it in init_page_buffers() and return -EIO or such
> 
> Well, anyway, Cc to Jens.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/buffer.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff -puN fs/buffer.c~debug fs/buffer.c
> --- tux3fs/fs/buffer.c~debug	2012-07-13 04:10:40.000000000 +0900
> +++ tux3fs-hirofumi/fs/buffer.c	2012-07-13 04:11:50.000000000 +0900
> @@ -1055,6 +1055,13 @@ __getblk_slow(struct block_device *bdev,
>  		dump_stack();
>  		return NULL;
>  	}
> +	if (block >= blkdev_max_block(I_BDEV(bdev->bd_inode))) {
> +		printk(KERN_ERR "getblk(): block %llu, end_block %llu\n",
> +		       (unsigned long long)block,
> +		       (unsigned long long)blkdev_max_block(I_BDEV(bdev->bd_inode)));
> +		dump_stack();
> +		return NULL;
> +	}
>  
>  	for (;;) {
>  		struct buffer_head * bh;
> _

This fixes the hang, but I'm not sure dump_stack() is a good idea. I get
almost 100 lines of stack dumps and error messages in my kernel log.
Also, I was a little surprised to see that mount completes successfully.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


