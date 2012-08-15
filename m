Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2HOJCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:02:25 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65362 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab2HOJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:02:22 -0400
Message-ID: <502B658F.5040100@metafoo.de>
Date: Wed, 15 Aug 2012 11:02:07 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Julia Lawall <julia.lawall@lip6.fr>, Jonathan Cameron <jic23@cam.ac.uk>,
        kernel-janitors@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/iio/adc/at91_adc.c: use devm_ functions
References: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr> <5017D148.6030006@metafoo.de> <alpine.DEB.2.02.1207311509040.1894@hadrien> <502AB5F1.3050908@kernel.org>
In-Reply-To: <502AB5F1.3050908@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 10:32 PM, Jonathan Cameron wrote:
> Lars-Peter,
> 
> Are you happy with this updated version?  Can't immediately find any response
> from you to it.
> 

I think it is ok, you can add my
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>.

One minor nitpick though.

> Jonathan
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> The various devm_ functions allocate memory that is released when a driver
>> detaches.  This patch uses these functions for data that is allocated in
>> the probe function of a platform device and is only freed in the remove
>> function.
>>
>> The call to platform_get_resource(pdev, IORESOURCE_MEM, 0) is moved coser
>> to the call to devm_request_and_ioremap, which is th first use of the
>> result of platform_get_resource.
>>
>> This does not use devm_request_irq to ensure that free_irq is executed
>> before its idev argument is freed.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/iio/adc/at91_adc.c |   41 ++++++++---------------------------------
>>  1 file changed, 8 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
>> index f61780a..3506e3d 100644
>> --- a/drivers/iio/adc/at91_adc.c
>> +++ b/drivers/iio/adc/at91_adc.c
>> @@ -545,13 +545,6 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
>>  		goto error_free_device;
>>  	}
>>
>> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -	if (!res) {
>> -		dev_err(&pdev->dev, "No resource defined\n");
>> -		ret = -ENXIO;
>> -		goto error_ret;
>> -	}
>> -
>>  	platform_set_drvdata(pdev, idev);
>>
>>  	idev->dev.parent = &pdev->dev;
>> @@ -566,18 +559,13 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
>>  		goto error_free_device;
>>  	}
>>
>> -	if (!request_mem_region(res->start, resource_size(res),
>> -				"AT91 adc registers")) {
>> -		dev_err(&pdev->dev, "Resources are unavailable.\n");
>> -		ret = -EBUSY;
>> -		goto error_free_device;
>> -	}
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>
>> -	st->reg_base = ioremap(res->start, resource_size(res));
>> +	st->reg_base = devm_request_and_ioremap(&pdev->dev, res);
>>  	if (!st->reg_base) {
>>  		dev_err(&pdev->dev, "Failed to map registers.\n");

devm_request_and_ioremap will already print a error messages on it's own if
something goes wrong. So strictly speaking this one is redundant, but I don't
think it is necessary to do a resend just for this, maybe you can remove the
extra dev_err when you apply the patch.
