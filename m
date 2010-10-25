Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0JYODU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:03:20 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:35882 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0JYODS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:03:18 -0400
Date: Mon, 25 Oct 2010 09:03:16 -0500
From: scameron@beardog.cce.hp.com
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Mike Miller <mike.miller@hp.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com
Subject: Re: [PATCH 1/2] block: cciss: fix information leak to userland
Message-ID: <20101025140316.GO9901@beardog.cce.hp.com>
References: <1287822311-14783-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287822311-14783-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 12:25:11PM +0400, Vasiliy Kulikov wrote:
> Structure IOCTL_Command_struct is copied to userland with some
> padding fields at the end of the struct unitialized.
> It leads to leaking of stack memory.

leaking of contents of kernel stack memory to userland,
not a memory leak, just to be clear.

> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  drivers/block/cciss.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 762a81a..cd08324 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1142,6 +1142,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
>  	int err;
>  	u32 cp;
>  
> +	memset(&arg64, 0, sizeof(arg64));
>  	err = 0;
>  	err |=
>  	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
> -- 
> 1.7.0.4

Ack.  

Thanks.

I would think hpsa needs a similar fix, and also cciss_ioctl32_big_passthru().
I suppose it's possible the big passthru alignment just "works out", (I haven't
checked), but even if that is the case, probably best not to rely on such an
accident,

-- steve


