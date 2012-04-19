Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2DSFOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:14:11 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:11640 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab2DSFOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:14:10 -0400
X-IronPort-AV: E=Sophos;i="4.75,445,1330902000"; 
   d="scan'208";a="154658664"
Date: Thu, 19 Apr 2012 07:14:05 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Jingoo Han <jg1.han@samsung.com>
cc: "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        joe@perches.com
Subject: RE: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling
 code
In-Reply-To: <000401cd1dd2$5f8ee3b0$1eacab10$%han@samsung.com>
Message-ID: <alpine.DEB.2.02.1204190713200.1954@localhost6.localdomain6>
References: <1334777828-3557-1-git-send-email-Julia.Lawall@lip6.fr> <4F8F5938.2000207@gmail.com> <000401cd1dd2$5f8ee3b0$1eacab10$%han@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know thw impact of the ./.  I use the options

--nokeywords --nogit-fallback --subsystem --norolestats -f

julia

On Thu, 19 Apr 2012, Jingoo Han wrote:

>> -----Original Message-----
>> From: Ryan Mallon
>> Sent: Thursday, April 19, 2012 9:16 AM
>> To: Julia Lawall
>> Cc: Florian Tobias Schandinat; kernel-janitors@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling code
>>
>> On 19/04/12 05:37, Julia Lawall wrote:
>>
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> There were two problems in this code: failure of the setup function should
>>> free locally allocated resources like other nearby failures, and the test
>>> if (&info->cmap) can never be false.  To generally clean things up, this
>>> patch reorders the error handling code at the failed label and adds labels
>>> so that the conditionals are not necessary.
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Reviewed-by: Ryan Mallon <rmallon@gmail.com>
>>
>> Oddly, scripts/get_maintainer.pl on this file doesn't return me, even
>> though, according to git blame, I am the author of 90% of the commits.
>> Should I have an entry in the MAINTAINERS file, or is
>> scripts/get_maintainer.pl not working properly?
>
> There are optional differences in using scripts/get_maintainer.pl.
> If you use './' ahead of file path, you will see your name.
>
> Without './' ahead of 'drivers/video/ep93xx-fb.c':
> ./scripts/get_maintainer.pl --file drivers/video/ep93xx-fb.c
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> (maintainer:FRAMEBUFFER LAYER)
> linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
> linux-kernel@vger.kernel.org (open list)
>
> With './' ahead of 'drivers/video/ep93xx-fb.c':
> ./scripts/get_maintainer.pl --file ./drivers/video/ep93xx-fb.c
> Ryan Mallon <rmallon@gmail.com> (commit_signer:2/3=67%)
> Paul Gortmaker <paul.gortmaker@windriver.com> (commit_signer:1/3=33%)
> H Hartley Sweeten <hsweeten@visionengravers.com> (commit_signer:1/3=33%)
> Jesper Juhl <jj@chaosbits.net> (commit_signer:1/3=33%)
> Jiri Kosina <jkosina@suse.cz> (commit_signer:1/3=33%)
> linux-kernel@vger.kernel.org (open list)
>
>
> Best regards,
> Jingoo Han
>
>>
>> ~Ryan
>>
>>> ---
>>> Not tested.
>>>
>>>  drivers/video/ep93xx-fb.c |   32 +++++++++++++++++---------------
>>>  1 file changed, 17 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
>>> index f8babbe..345d962 100644
>>> --- a/drivers/video/ep93xx-fb.c
>>> +++ b/drivers/video/ep93xx-fb.c
>>> @@ -507,16 +507,16 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>>>
>>>  	err = fb_alloc_cmap(&info->cmap, 256, 0);
>>>  	if (err)
>>> -		goto failed;
>>> +		goto failed_cmap;
>>>
>>>  	err = ep93xxfb_alloc_videomem(info);
>>>  	if (err)
>>> -		goto failed;
>>> +		goto failed_videomem;
>>>
>>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>  	if (!res) {
>>>  		err = -ENXIO;
>>> -		goto failed;
>>> +		goto failed_resource;
>>>  	}
>>>
>>>  	/*
>>> @@ -532,7 +532,7 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>>>  	fbi->mmio_base = ioremap(res->start, resource_size(res));
>>>  	if (!fbi->mmio_base) {
>>>  		err = -ENXIO;
>>> -		goto failed;
>>> +		goto failed_resource;
>>>  	}
>>>
>>>  	strcpy(info->fix.id, pdev->name);
>>> @@ -553,24 +553,24 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>>>  	if (err == 0) {
>>>  		dev_err(info->dev, "No suitable video mode found\n");
>>>  		err = -EINVAL;
>>> -		goto failed;
>>> +		goto failed_mode;
>>>  	}
>>>
>>>  	if (mach_info->setup) {
>>>  		err = mach_info->setup(pdev);
>>>  		if (err)
>>> -			return err;
>>> +			goto failed_mode;
>>>  	}
>>>
>>>  	err = ep93xxfb_check_var(&info->var, info);
>>>  	if (err)
>>> -		goto failed;
>>> +		goto failed_check;
>>>
>>>  	fbi->clk = clk_get(info->dev, NULL);
>>>  	if (IS_ERR(fbi->clk)) {
>>>  		err = PTR_ERR(fbi->clk);
>>>  		fbi->clk = NULL;
>>> -		goto failed;
>>> +		goto failed_check;
>>>  	}
>>>
>>>  	ep93xxfb_set_par(info);
>>> @@ -585,15 +585,17 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>>>  	return 0;
>>>
>>>  failed:
>>> -	if (fbi->clk)
>>> -		clk_put(fbi->clk);
>>> -	if (fbi->mmio_base)
>>> -		iounmap(fbi->mmio_base);
>>> -	ep93xxfb_dealloc_videomem(info);
>>> -	if (&info->cmap)
>>> -		fb_dealloc_cmap(&info->cmap);
>>> +	clk_put(fbi->clk);
>>> +failed_check:
>>>  	if (fbi->mach_info->teardown)
>>>  		fbi->mach_info->teardown(pdev);
>>> +failed_mode:
>>> +	iounmap(fbi->mmio_base);
>>> +failed_resource:
>>> +	ep93xxfb_dealloc_videomem(info);
>>> +failed_videomem:
>>> +	fb_dealloc_cmap(&info->cmap);
>>> +failed_cmap:
>>>  	kfree(info);
>>>  	platform_set_drvdata(pdev, NULL);
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
