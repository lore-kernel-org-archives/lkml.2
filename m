Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1BVRwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:52:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54536 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1BVRwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:52:18 -0500
Message-ID: <4D63F7CD.5070307@monstr.eu>
Date: Tue, 22 Feb 2011 18:52:13 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        John.Linn@xilinx.com
Subject: Re: [PATCH v2 1/2] i2c: xiic: Add OF support for Xilinx i2c bus interface
References: <1298384530-14994-1-git-send-email-monstr@monstr.eu> <AANLkTi=FvafUgqMCF29cX7egviDwrfB=sViudLr+4Fsx@mail.gmail.com>
In-Reply-To: <AANLkTi=FvafUgqMCF29cX7egviDwrfB=sViudLr+4Fsx@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Tue, Feb 22, 2011 at 7:22 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Add OF support to Xilinx i2c bus interface.
>> It is used on Microblaze systems.
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> Hi Michal, comments below...
> 
>> ---
>>  drivers/i2c/busses/i2c-xiic.c |   46 ++++++++++++++++++++++++++++++++++------
>>  1 files changed, 39 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
>> index a9c419e..4166570 100644
>> --- a/drivers/i2c/busses/i2c-xiic.c
>> +++ b/drivers/i2c/busses/i2c-xiic.c
>> @@ -2,6 +2,8 @@
>>  * i2c-xiic.c
>>  * Copyright (c) 2002-2007 Xilinx Inc.
>>  * Copyright (c) 2009-2010 Intel Corporation
>> + * Copyright (c) 2010-2011 Michal Simek <monstr@monstr.eu>
>> + * Copyright (c) 2010-2011 PetaLogix
> 
> This change is going to end up being pretty trivial.  It would be a
> little odd to claim copyright on such a tiny change; particularly when
> it just follows the pattern already established by other drivers.

agree - I forget to remove it - it was in my origin patch.

> 
>>  *
>>  * This program is free software; you can redistribute it and/or modify
>>  * it under the terms of the GNU General Public License version 2 as
>> @@ -41,6 +43,13 @@
>>  #include <linux/io.h>
>>  #include <linux/slab.h>
>>
>> +#ifdef CONFIG_OF
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_i2c.h>
>> +#include <linux/of_address.h>
>> +#endif
> 
> As previously mentioned; drop the #ifdef protection around these
> includes. It should be safe to include them unconditionally, and if it
> isn't then it is a bug in the headers which should be fixed.  These
> includes should be part of the regular block of includes.

remove done

> 
>> +
>>  #define DRIVER_NAME "xiic-i2c"
>>
>>  enum xilinx_i2c_state {
>> @@ -426,7 +435,7 @@ static void xiic_process(struct xiic_i2c *i2c)
>>                        xiic_wakeup(i2c, STATE_ERROR);
>>
>>        } else if (pend & (XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK)) {
>> -               /* Transmit register/FIFO is empty or ½ empty */
>> +               /* Transmit register/FIFO is empty or 1/2 empty */
>>
>>                clr = pend &
>>                        (XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK);
>> @@ -691,10 +700,12 @@ static struct i2c_adapter xiic_adapter = {
>>  static int __devinit xiic_i2c_probe(struct platform_device *pdev)
>>  {
>>        struct xiic_i2c *i2c;
>> +#ifndef CONFIG_OF
>>        struct xiic_i2c_platform_data *pdata;
>> +       u8 i;
>> +#endif
>>        struct resource *res;
>>        int ret, irq;
>> -       u8 i;
> 
> You can drop this hunk (see below).

done

> 
>>        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>        if (!res)
>> @@ -704,10 +715,6 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
>>        if (irq < 0)
>>                goto resource_missing;
>>
>> -       pdata = (struct xiic_i2c_platform_data *) pdev->dev.platform_data;
>> -       if (!pdata)
>> -               return -EINVAL;
>> -
>>        i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
>>        if (!i2c)
>>                return -ENOMEM;
>> @@ -730,7 +737,9 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
>>        i2c->adap = xiic_adapter;
>>        i2c_set_adapdata(&i2c->adap, i2c);
>>        i2c->adap.dev.parent = &pdev->dev;
>> -
>> +#ifdef CONFIG_OF
>> +       i2c->adap.dev.of_node = of_node_get(pdev->dev.of_node);
>> +#endif
> 
> Drop the #ifdef here.  In devicetree/next of_node is no longer
> protected by a #ifdef.

ok, done

> 
>>        xiic_reinit(i2c);
>>
>>        spin_lock_init(&i2c->lock);
>> @@ -748,9 +757,20 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
>>                goto add_adapter_failed;
>>        }
>>
>> +       dev_info(&pdev->dev, "mapped to 0x%08X, irq=%d\n",
>> +                                       (unsigned int)i2c->base, irq);
>> +
>> +#ifndef CONFIG_OF
>> +       pdata = (struct xiic_i2c_platform_data *) pdev->dev.platform_data;
>> +       if (!pdata)
>> +               return -EINVAL;
>> +
>>        /* add in known devices to the bus */
>>        for (i = 0; i < pdata->num_devices; i++)
>>                i2c_new_device(&i2c->adap, pdata->devices + i);
>> +#else
>> +       of_i2c_register_devices(&i2c->adap);
>> +#endif
> 
> Do it this way instead:
> 
> 	pdata = (struct xiic_i2c_platform_data *) pdev->dev.platform_data;
> 	if (pdata) {
> 		/* add in known devices to the bus */
> 		for (i = 0; i < pdata->num_devices; i++)
> 		       i2c_new_device(&i2c->adap, pdata->devices + i);
> 	}
> 
> 	of_i2c_register_devices(&i2c->adap);
> 
> of_i2c_register_devices() is safe to call regardless of if CONFIG_OF
> is selected or not.  This driver should be written to handle both
> device tree and platform_data use cases at run time.

ok, done. I hope that it doesn't non OF version. I can't easily test it.

> 
>>        return 0;
>>
>> @@ -799,12 +819,24 @@ static int __devexit xiic_i2c_remove(struct platform_device* pdev)
>>  /* work with hotplug and coldplug */
>>  MODULE_ALIAS("platform:"DRIVER_NAME);
>>
>> +#ifdef CONFIG_OF
>> +/* Match table for of_platform binding */
>> +static struct of_device_id __devinitdata xilinx_iic_of_match[] = {
>> +       { .compatible = "xlnx,xps-iic-2.00.a", },
>> +       {},
>> +};
>> +MODULE_DEVICE_TABLE(of, xilinx_iic_of_match);
> 
> If you add the following, then you can drop the #ifdef around
> .of_match_table below...
> 
> #else
> #define xilinx_iic_of_match NULL
> 
>> +#endif
>> +
>>  static struct platform_driver xiic_i2c_driver = {
>>        .probe   = xiic_i2c_probe,
>>        .remove  = __devexit_p(xiic_i2c_remove),
>>        .driver  = {
>>                .owner = THIS_MODULE,
>>                .name = DRIVER_NAME,
>> +#ifdef CONFIG_OF
>> +               .of_match_table = xilinx_iic_of_match,
>> +#endif
> 
> Drop the #ifdef and base this patch on devicetree/next

specifically this I was checking in the Linus tree to know if there is any ifdef.
devicetree/next branch is fine.

I have sent v3 based on your devicetree/next branch.

Thanks for your comments,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
