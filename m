Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2K1AH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:07:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47753 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2K1AH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121127230747.GB2605@local>
References: <201211271929.32315.vitas@nppfactor.kiev.ua>
	<20121127230747.GB2605@local>
Date: Wed, 28 Nov 2012 01:07:26 +0100
Message-ID: <CAP9qxA-ZmhZLVujmdM0YLqXony-s8oZggKZxTU6oYmtcuO5erQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/uio/uio_pdrv_genirq.c: Fix memory leak &
 confusing labels
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Vitalii Demianets <vitas@nppfactor.kiev.ua>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:07 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> On Tue, Nov 27, 2012 at 07:29:32PM +0200, Vitalii Demianets wrote:
>> Memory leak was caused by jumping to the wrong exit label. So, it is good time
>> to improve misleading label names too.
>
> I agree that bad0, bad1, and bad2 are not the best choice for label names...
> I don't have any objections to your renaming.
>
> But there's a more serious bug, maybe you can fix that as well while you're
> at it? (See below)
>
> Thanks,
> Hans
>
>>
>> Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
>> ---
>>  drivers/uio/uio_pdrv_genirq.c |   21 +++++++++++----------
>>  1 files changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
>> index 42202cd..b88cf7b 100644
>> --- a/drivers/uio/uio_pdrv_genirq.c
>> +++ b/drivers/uio/uio_pdrv_genirq.c
>> @@ -110,7 +110,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>               if (!uioinfo) {
>>                       ret = -ENOMEM;
>>                       dev_err(&pdev->dev, "unable to kmalloc\n");
>> -                     goto bad2;
>> +                     goto out;
>>               }
>>               uioinfo->name = pdev->dev.of_node->name;
>>               uioinfo->version = "devicetree";
>> @@ -125,20 +125,20 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>
>>       if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>>               dev_err(&pdev->dev, "missing platform_data\n");
>> -             goto bad0;
>> +             goto out_uioinfo;
>>       }
>>
>>       if (uioinfo->handler || uioinfo->irqcontrol ||
>>           uioinfo->irq_flags & IRQF_SHARED) {
>>               dev_err(&pdev->dev, "interrupt configuration error\n");
>> -             goto bad0;
>> +             goto out_uioinfo;
>>       }
>>
>>       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>>       if (!priv) {
>>               ret = -ENOMEM;
>>               dev_err(&pdev->dev, "unable to kmalloc\n");
>> -             goto bad0;
>> +             goto out_uioinfo;
>>       }
>>
>>       priv->uioinfo = uioinfo;
>> @@ -150,7 +150,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>               ret = platform_get_irq(pdev, 0);
>>               if (ret < 0) {
>>                       dev_err(&pdev->dev, "failed to get IRQ\n");
>> -                     goto bad0;
>> +                     goto out_priv;
>>               }
>>               uioinfo->irq = ret;
>>       }
>> @@ -205,19 +205,20 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>       ret = uio_register_device(&pdev->dev, priv->uioinfo);
>>       if (ret) {
>>               dev_err(&pdev->dev, "unable to register uio device\n");
>> -             goto bad1;
>> +             goto out_pm;
>>       }
>>
>>       platform_set_drvdata(pdev, priv);
>>       return 0;
>> - bad1:
>> -     kfree(priv);
>> +out_pm:
>>       pm_runtime_disable(&pdev->dev);
>> - bad0:
>> +out_priv:
>> +     kfree(priv);
>> +out_uioinfo:
>>       /* kfree uioinfo for OF */
>>       if (pdev->dev.of_node)
>>               kfree(uioinfo);
>
> The free() depends on pdev->dev.of_node, while the allocation doesn't!!!!
> That's another source of memory leaks.
I don't agree. In line 99, it is
struct uio_info *uioinfo = pdev->dev.platform_data;
if uioinfo doesn't equal to NULL, it will run to line 126,
if (!uioinfo || !uioinfo->name || !uioinfo->version) {
and then if uioinfo->name equals to NULL, it runs to line 127 and 128,
and then goto bad0. If in this flow, we have to check
pdev->dev.of_node before free(uioinfo), right?

btw, I think in line 126 it is not necessary to check (!uioinfo),
because if uioinfo equals to NULL, it will go to line 109, and if the
alloc fails, it will go to bad2. uioinfo has no chance to be NULL when
runs to line 126. So I'd like to suggest a patch to avoid unnecessary
check like this

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
 index 42202cd..3eb4fa2 100644
 --- a/drivers/uio/uio_pdrv_genirq.c
 +++ b/drivers/uio/uio_pdrv_genirq.c
 @@ -123,7 +123,7 @@ static int uio_pdrv_genirq_probe(struct
platform_device *pdev)
             uioinfo->irq = irq;
     }

 -   if (!uioinfo || !uioinfo->name || !uioinfo->version) {
 +   if (!uioinfo->name || !uioinfo->version) {
         dev_err(&pdev->dev, "missing platform_data\n");
         goto bad0;
     }


>
>> - bad2:
>> +out:
>>       return ret;
>>  }
>>
>> --
>> 1.7.8.6
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
