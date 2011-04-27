Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab1D0LFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:05:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63845 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab1D0LFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:05:47 -0400
Message-ID: <4DB7F885.4040402@monstr.eu>
Date: Wed, 27 Apr 2011 13:05:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@hansjkoch.de, w.sang@pengutronix.de,
        arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <20110419060816.GA5252@ponder.secretlab.ca>
In-Reply-To: <20110419060816.GA5252@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Mon, Apr 18, 2011 at 10:50:54AM +0200, Michal Simek wrote:
>> Adding OF binding to genirq.
>> Version string is setup to the "devicetree".
>>
>> Compatible string is not setup for now but you can add your
>> custom compatible string to uio_of_genirq_match structure.
>>
>> For example with "uio" compatible string:
>> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>> 	{ .compatible = "uio", },
>> 	{ /* empty for now */ },
>> };
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>
>> ---
>>
>> v3: Fix irq binding
>>     Use "devicetree" as version string
>>
>> v2: Remove additional resource binding
>>     Setup correct version string
>>     Clear compatible string
>> ---
>>  drivers/uio/uio_pdrv_genirq.c |   42 +++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 42 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
>> index 7174d51..c8d565a 100644
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
>> @@ -97,6 +101,30 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>  	int ret = -EINVAL;
>>  	int i;
>>  
>> +	if (!uioinfo) {
>> +		int irq;
>> +
>> +		/* alloc uioinfo for one device */
>> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>> +		if (!uioinfo) {
>> +			ret = -ENOMEM;
>> +			dev_err(&pdev->dev, "unable to kmalloc\n");
>> +			goto bad2;
>> +		}
>> +		uioinfo->name = pdev->dev.of_node->name;
>> +		uioinfo->version = "devicetree";
>> +
>> +		/* Multiple IRQs are not supported */
>> +		irq = platform_get_irq(pdev, 0);
>> +		if (irq < 0) {
> 
> PowerPC and x86 will return 0 for an unassigned IRQ, as will most platforms.

I have looked at it and platform_get_irq for unassigned IRQ returns -ENXIO.

It is there from 2006 (drivers/base/platform.c)
"[PATCH] driver core: platform_get_irq*(): return -ENXIO on error"
(sha1 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0)

Maybe you have this patch in your queue but it is not in the mainline 2.6.39-rc5.

Maybe should return NO_IRQ instead.
But anyway for current code I would prefer to use this condition to cover all 
architectures NO_IRQ definition.

irq = platform_get_irq(pdev, 0);
if (irq == -ENXIO || irq == NO_IRQ)
	uioinfo->irq = UIO_IRQ_NONE;
else
	uioinfo->irq = irq;

or of course to only NO_IRQ if we do s/-ENXIO/NO_IRQ in platform_get_irq.

if (irq == NO_IRQ)
	uioinfo->irq = UIO_IRQ_NONE;
else
	uioinfo->irq = irq;

What do you think?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
