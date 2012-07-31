Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2GaOTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:19:36 -0400
Received: from smtp-out-178.synserver.de ([212.40.185.178]:1062 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2GaOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:19:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18226
Message-ID: <5017EA72.8030003@metafoo.de>
Date: Tue, 31 Jul 2012 16:23:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH] drivers/iio/adc/at91_adc.c: use devm_ functions
References: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr> <5017D148.6030006@metafoo.de> <alpine.DEB.2.02.1207311552440.1894@hadrien>
In-Reply-To: <alpine.DEB.2.02.1207311552440.1894@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:54 PM, Julia Lawall wrote:
> 
> 
> On Tue, 31 Jul 2012, Lars-Peter Clausen wrote:
> 
>> Hi,
>>
>> On 07/31/2012 12:09 PM, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>> @@ -720,20 +698,14 @@ error_ret:
>>>  static int __devexit at91_adc_remove(struct platform_device *pdev)
>>>  {
>>>  	struct iio_dev *idev = platform_get_drvdata(pdev);
>>> -	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>  	struct at91_adc_state *st = iio_priv(idev);
>>>
>>>  	iio_device_unregister(idev);
>>> [...]
>>> -	free_irq(st->irq, idev);
>>> [...]
>>>  	iio_device_free(idev);
>>
>> I think we have to be careful here. The interrupted is now freed after the
>> device has been freed, which means that it could trigger after the device
>> has been freed. And since we use the device in the interrupt handler we'll
>> get a use after free.
> 
> Perhaps the same would be true in the following code, from the file
> drivers/edac/highbank_l2_edac.c:
> 
>         res = devm_request_irq(&pdev->dev, drvdata->sb_irq,
>                                highbank_l2_err_handler,
>                                0, dev_name(&pdev->dev), dci);
>         if (res < 0)
>                 goto err;
> 
>         dci->mod_name = dev_name(&pdev->dev);
>         dci->dev_name = dev_name(&pdev->dev);
> 
>         if (edac_device_add_device(dci))
>                 goto err;
> 
>         devres_close_group(&pdev->dev, NULL);
>         return 0;
> err:
>     	devres_release_group(&pdev->dev, NULL);
>         edac_device_free_ctl_info(dci);

Yes looks like this has the same issue.

> 
> Is devm_request_irq perhaps not a very good idea?
> 

devm_request_irq has to be used carefully. It is ok to use it if the objects
which are accessed in the interrupt handler are also devres managed. devres
will free objects in the reverse order of which they are allocated.

E.g. if you do

obj = dev_kzalloc(...);
...
devm_request_irq(..., obj);

it is save to use, because 'obj' will be freed after the IRQ has been freed.

- Lars
