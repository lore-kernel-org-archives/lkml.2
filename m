Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1EIPN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:13:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63448 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1EIPN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KoDTg60jow8Ox8NmIhb9ezXZdhgzjftpKIk6Rx2hqfl68LhvDUHj1wHLbtWcyOuAro
         CONALzGNFMtqe6daGR8O9yDFwxgo15u6EU1NTOJuWi1zEAnPMCwF9E7KLLZ2xxgL0cMQ
         rKjEt/8qC2Eb0sv8rU8ICH13OCLxer5tIDK2M=
MIME-Version: 1.0
In-Reply-To: <4DC802C0.9040302@gmail.com>
References: <4DC7F4AB.90607@gmail.com>
	<Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk>
	<4DC802C0.9040302@gmail.com>
Date: Mon, 9 May 2011 18:13:55 +0300
Message-ID: <BANLkTimOfmS=tKMY7Z_vRcCWEO6drgwegQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference 'idata'
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vladimir Motyka <vladimir.motyka@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, cjb@laptop.org,
        kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 6:05 PM, Vladimir Motyka
<vladimir.motyka@gmail.com> wrote:
> On 05/09/2011 04:32 PM, Julia Lawall wrote:
>> On Mon, 9 May 2011, Vladimir Motyka wrote:
>>
>>> When allocation of idata fails there was a null dereferece.
>>
>> Why not have a different label for the two cases?  That would make the
>> code easier to statically analyze, and perhaps be more understandable as
>> well.
>>
>> julia
>>
> I think You are right. So it could be better like this?
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 3dec493..a03cdc6 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -237,7 +237,7 @@ static struct mmc_blk_ioc_data
> *mmc_blk_ioctl_copy_from_user(
>        idata = kzalloc(sizeof(*idata), GFP_KERNEL);
>        if (!idata) {
>                err = -ENOMEM;
> -               goto copy_err;
> +               goto alloc_err;
>        }
>
>        if (copy_from_user(&idata->ic, user, sizeof(idata->ic))) {
> @@ -266,9 +266,9 @@ static struct mmc_blk_ioc_data
> *mmc_blk_ioctl_copy_from_user(
>        return idata;
>
>  copy_err:
> -       if(idata)
> -               kfree(idata->buf);
> +       kfree(idata->buf);
Make it one patch not series.

>        kfree(idata);
> +alloc_err:
>        return ERR_PTR(err);
>  }
>
> Or it could return right after allocation fails so there needn't be
> goto. It is simplier, but maybe worse looking and to read. What is your
> opinion?
>
> Vladimir Motyka
>
>>
>>> Signed-off-by: Vladimir Motyka <vladimir.motyka@gmail.com>
>>>
>>> ---
>>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>>> index 407836d..3dec493 100644
>>> --- a/drivers/mmc/card/block.c
>>> +++ b/drivers/mmc/card/block.c
>>> @@ -266,10 +266,10 @@ static struct mmc_blk_ioc_data
>>> *mmc_blk_ioctl_copy_from_user(
>>>      return idata;
>>>
>>>  copy_err:
>>> -    kfree(idata->buf);
>>> +    if(idata)
>>> +            kfree(idata->buf);
>>>      kfree(idata);
>>>      return ERR_PTR(err);
>>> -
>>>  }
>>>
>>>  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
With Best Regards,
Andy Shevchenko
