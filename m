Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1EIPOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:14:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45978 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1EIPO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:14:29 -0400
Date: Mon, 9 May 2011 17:14:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Vladimir Motyka <vladimir.motyka@gmail.com>
Cc: cjb@laptop.org, kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference
 'idata'
In-Reply-To: <4DC802C0.9040302@gmail.com>
Message-ID: <Pine.LNX.4.64.1105091713080.15483@pc-004.diku.dk>
References: <4DC7F4AB.90607@gmail.com> <Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk>
 <4DC802C0.9040302@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 May 2011, Vladimir Motyka wrote:

> On 05/09/2011 04:32 PM, Julia Lawall wrote:
> > On Mon, 9 May 2011, Vladimir Motyka wrote:
> > 
> >> When allocation of idata fails there was a null dereferece.
> > 
> > Why not have a different label for the two cases?  That would make the 
> > code easier to statically analyze, and perhaps be more understandable as 
> > well.
> > 
> > julia
> >
> I think You are right. So it could be better like this?
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 3dec493..a03cdc6 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -237,7 +237,7 @@ static struct mmc_blk_ioc_data
> *mmc_blk_ioctl_copy_from_user(
>  	idata = kzalloc(sizeof(*idata), GFP_KERNEL);
>  	if (!idata) {
>  		err = -ENOMEM;
> -		goto copy_err;
> +		goto alloc_err;
>  	}
> 
>  	if (copy_from_user(&idata->ic, user, sizeof(idata->ic))) {
> @@ -266,9 +266,9 @@ static struct mmc_blk_ioc_data
> *mmc_blk_ioctl_copy_from_user(
>  	return idata;
> 
>  copy_err:
> -	if(idata)
> -		kfree(idata->buf);
> +	kfree(idata->buf);
>  	kfree(idata);
> +alloc_err:
>  	return ERR_PTR(err);
>  }
> 
> Or it could return right after allocation fails so there needn't be
> goto. It is simplier, but maybe worse looking and to read. What is your
> opinion?

Perhaps it is also pointless to call kfree on something that is known to 
be NULL.  But I think that there is quite some code that does that, so 
others might have another opinion.

julia


> 
> Vladimir Motyka
> 
> > 
> >> Signed-off-by: Vladimir Motyka <vladimir.motyka@gmail.com>
> >>
> >> ---
> >> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> >> index 407836d..3dec493 100644
> >> --- a/drivers/mmc/card/block.c
> >> +++ b/drivers/mmc/card/block.c
> >> @@ -266,10 +266,10 @@ static struct mmc_blk_ioc_data
> >> *mmc_blk_ioctl_copy_from_user(
> >>  	return idata;
> >>
> >>  copy_err:
> >> -	kfree(idata->buf);
> >> +	if(idata)
> >> +		kfree(idata->buf);
> >>  	kfree(idata);
> >>  	return ERR_PTR(err);
> >> -
> >>  }
> >>
> >>  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
