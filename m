Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab1CaN2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:28:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55423 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab1CaN2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:28:45 -0400
Message-ID: <4D948189.9070606@monstr.eu>
Date: Thu, 31 Mar 2011 15:28:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu> <1301574600-4861-2-git-send-email-monstr@monstr.eu> <20110331124925.GA2202@pengutronix.de>
In-Reply-To: <20110331124925.GA2202@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
>> Support OF support. "generic-uio" compatible property is used.
> 
> And exactly this was the issue last time (when I tried). This is a
> generic property, which is linux-specific and not describing HW. The
> agreement back then was to we probably need to add compatible-entries at
> runtime (something like new_id for USB). So the uio-of-driver could be
> matched against any device. Otherwise, we would collect a lot of
> potential entries like "vendor,special-card1". Although I wonder
> meanwhile if it is really going to be that bad; we don't have so much
> UIO-driver in tree as well. Maybe worth a try?

I will read reactions to get better picture to be able to argue. :-)

> 
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  drivers/uio/uio_pdrv_genirq.c |   60 ++++++++++++++++++++++++++++++++++++++--
>>  1 files changed, 57 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
>> index 7174d51..9e89806 100644
>> --- a/drivers/uio/uio_pdrv_genirq.c
>> +++ b/drivers/uio/uio_pdrv_genirq.c
>> @@ -23,6 +23,10 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/slab.h>
>>  
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_address.h>
>> +
>>  #define DRIVER_NAME "uio_pdrv_genirq"
>>  
>>  struct uio_pdrv_genirq_platdata {
>> @@ -92,11 +96,44 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
>>  static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>  {
>>  	struct uio_info *uioinfo = pdev->dev.platform_data;
>> -	struct uio_pdrv_genirq_platdata *priv;
>> +	struct uio_pdrv_genirq_platdata *priv = NULL;
> 
> unrelated?

you are right here. I changed order and this is not necessary.


> 
>>  	struct uio_mem *uiomem;
>>  	int ret = -EINVAL;
>>  	int i;
>>  
>> +	if (!uioinfo) {
>> +		struct resource r_irq; /* Interrupt resources */
>> +		int rc = 0;
>> +
>> +		rc = of_address_to_resource(pdev->dev.of_node, 0,
>> +							&pdev->resource[0]);
>> +		if (rc) {
>> +			dev_err(&pdev->dev, "invalid address\n");
>> +			goto bad2;
>> +		}
>> +		pdev->num_resources = 1;
>> +
>> +		/* alloc uioinfo for one device */
>> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>> +		if (!uioinfo) {
>> +			ret = -ENOMEM;
>> +			dev_err(&pdev->dev, "unable to kmalloc\n");
>> +			goto bad2;
>> +		}
>> +		uioinfo->name = pdev->dev.of_node->name;
>> +		/* Use version for storing full IP name for identification */
>> +		uioinfo->version = pdev->dev.of_node->full_name;
> 
> I don't think this is apropriate, but will leave that to Hans.

I was thinking what to add and I choose full_name because I can read this value 
and identify which UIO is this device.
I know that there should be version but there is no version string in DTS.

> 
>> +		/* Get IRQ for the device */
>> +		rc = of_irq_to_resource(pdev->dev.of_node, 0, &r_irq);
>> +		if (rc == NO_IRQ)
>> +			dev_err(&pdev->dev, "no IRQ found\n");
> 
> No error, I think. Sometimes just mmaping the registers is enough.

OK. Let's changed it to dev_info if you like.


> 
>> +		else {
>> +			uioinfo->irq = r_irq.start;
>> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
>> +		}
>> +	}
>> +
>>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>>  		dev_err(&pdev->dev, "missing platform_data\n");
>>  		goto bad0;
>> @@ -176,10 +213,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>  
>>  	platform_set_drvdata(pdev, priv);
>>  	return 0;
>> - bad1:
>> +
>> +bad1:
> 
> The spaces before labels are intentional, better keep them.

I found both cases. checkpatch doesn't show any problem for both cases that's 
why if you like space before label, I am fine with this.

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
