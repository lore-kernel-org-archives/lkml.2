Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab1BVFm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:42:28 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34446 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1BVFm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:42:27 -0500
Message-ID: <37B3755C4AE64BAA805DFBAEBDC3D9E4@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Samuel Ortiz" <sameo@linux.intel.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-2-git-send-email-subhasish@mistralsolutions.com> <20110221163027.GF10686@sortiz-mobl>
In-Reply-To: <20110221163027.GF10686@sortiz-mobl>
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.
Date: Tue, 22 Feb 2011 11:13:38 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments.

--------------------------------------------------
From: "Samuel Ortiz" <sameo@linux.intel.com>
Sent: Monday, February 21, 2011 10:00 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<linux-arm-kernel@lists.infradead.org>; <m-watkins@ti.com>; 
<nsekhar@ti.com>; <sachi@mistralsolutions.com>; "open list" 
<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.

> Hi Subhasish,
>
> On Fri, Feb 11, 2011 at 08:21:20PM +0530, Subhasish Ghosh wrote:
>> This patch adds the pruss MFD driver and associated include files.
> A more detailed changelog would be better. What is this device, why is it 
> an
> MFD and what are its potential subdevices ?
>

SG -- Will add a more detailed change log.

>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index fd01836..6c437df 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -81,6 +81,16 @@ config MFD_DM355EVM_MSP
>>    boards.  MSP430 firmware manages resets and power sequencing,
>>    inputs from buttons and the IR remote, LEDs, an RTC, and more.
>>
>> +config MFD_DA8XX_PRUSS
>> + tristate "Texas Instruments DA8XX PRUSS support"
>> + depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
> Why are we depending on those ?

SG -- The PRUSS core in only available within DA850 and DA830,
            DA830 support is not yet implemented.

>
>
>> + select MFD_CORE
>> + help
>> +     This driver provides support api's for the programmable
>> + realtime unit (PRU) present on TI's da8xx processors. It
>> + provides basic read, write, config, enable, disable
>> + routines to facilitate devices emulated on it.
> Please fix your identation here.

SG -- Will do.

>
>> --- /dev/null
>> +++ b/drivers/mfd/da8xx_pru.c
>> @@ -0,0 +1,446 @@
>> +/*
>> + * Copyright (C) 2010 Texas Instruments Incorporated
> s/2010/2011/ ?
>
>> + * This program is free software; you can redistribute it and/or modify 
>> it
>> + * under the terms of the GNU General Public License as  published by 
>> the
>> + * Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
>> + * whether express or implied; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <linux/module.h>
>> +#include <linux/bitops.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/errno.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/mfd/pruss/da8xx_prucore.h>
>> +#include <linux/mfd/pruss/da8xx_pru.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/io.h>
>> +#include <mach/da8xx.h>
> Is that include needed ?

SG  - Will remove if not needed.

>
>
>> +struct da8xx_pruss {
> What is the "ss" suffix for ?

SG -- We call it the PRU Sub-System.

>
>
>> +u32 pruss_disable(struct device *dev, u8 pruss_num)
>> +{
>> + struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
>> + da8xx_prusscore_regs h_pruss;
>> + u32 temp_reg;
>> +
>> + if (pruss_num == DA8XX_PRUCORE_0) {
>> + /* Disable PRU0  */
>> + h_pruss = (da8xx_prusscore_regs)
>> + ((u32) pruss->ioaddr + 0x7000);
> So it seems you're doing this in several places, and I have a few 
> comments:
>
> - You don't need the da8xx_prusscore_regs at all.
> - Define the register map through a set of #define in your header file.
> - Use a static routine that takes the core number and returns the register 
> map
> offset.
>
> Then routines like this one will look a lot more readable.

SG -- There are a huge number of PRUSS registers. A lot of them are reserved 
and are expected to change as development on the
            controller is still ongoing. If we use #defines to plot all the 
registers, then first, there are too many array type registers which will 
need to be duplicated.
            And if the offset of one of the macro changes in between, we 
will require to adjust all the rest of the macros. So I felt like a 
structure was a better option here.
            I also named the structure elements as per the register names. 
so why should it be less readable ?  But, we can definitely use macros to 
define the PRUSS0 & 1
            offsets instead of the magic numbers as above.
>
>> +s16 pruss_writeb(struct device *dev, u32 u32offset,
>> + u8 *pu8datatowrite, u16 u16bytestowrite)
> From CodingStyle: "Encoding the type of a function into the name 
> (so-called
> Hungarian notation) is brain damaged"

SG -- Will change.
>
> Also, all your exported routines severely lack any sort of locking. An IO
> mutex or spinlock is mandatory here.

SG - As per our current implementation, we do not have two devices running 
simultaneously on the PRU,
        so we do not have any way to test it. We have kept this as an 
enhancement if request comes in for
        multiple devices.

>
>> +static int pruss_mfd_add_devices(struct platform_device *pdev)
>> +{
>> + struct da8xx_pruss_devices *dev_data = pdev->dev.platform_data;
>> + struct device *dev = &pdev->dev;
>> + struct mfd_cell cell;
>> + u32 err, count;
>> +
>> + for (count = 0; (dev_data + count)->dev_name != NULL; count++) {
>> + memset(&cell, 0, sizeof(struct mfd_cell));
>> + cell.id = count;
>> + cell.name = (dev_data + count)->dev_name;
>> + cell.platform_data = (dev_data + count)->pdata;
>> + cell.data_size = (dev_data + count)->pdata_size;
>> +
>> + err = mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
>> + if (err) {
>> + dev_err(dev, "cannot add mfd cells\n");
>> + return err;
>> + }
>> + }
>> + return err;
>> +}
> So, what are the potential subdevices for this driver ? If it's a really
> dynamic setup, I'm fine with passing those as platform data but then do it 
> so
> that you pass a NULL terminated da8xx_pruss_devices array. That will avoid
> most of the ugly casts you're doing here.

SG -- I did not follow your recommendations here, could you please 
elaborate.
            I am already checking the dev_name for a NULL.
            This device is basically a microcontroller within DA850, so 
basically any device or protocol can be
            emulated on it. Currently, we have emulated 8 UARTS using the 
two PRUs and also a CAN device.
>
>> diff --git a/include/linux/mfd/pruss/da8xx_pru.h 
>> b/include/linux/mfd/pruss/da8xx_pru.h
>> new file mode 100644
>> index 0000000..68d8421
>> --- /dev/null
>> +++ b/include/linux/mfd/pruss/da8xx_pru.h
>> @@ -0,0 +1,122 @@
>> +/*
>> + * Copyright (C) 2010 Texas Instruments Incorporated
>> + * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify 
>> it
>> + * under the terms of the GNU General Public License as  published by 
>> the
>> + * Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
>> + * whether express or implied; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef _PRUSS_H_
>> +#define _PRUSS_H_
>> +
>> +#include <linux/types.h>
>> +#include <linux/platform_device.h>
>> +#include "da8xx_prucore.h"
>> +
>> +#define PRUSS_NUM0 DA8XX_PRUCORE_0
>> +#define PRUSS_NUM1 DA8XX_PRUCORE_1
> Those are unused.

SG - These are getting used by the CAN & UART drivers.

>
>> diff --git a/include/linux/mfd/pruss/da8xx_prucore.h 
>> b/include/linux/mfd/pruss/da8xx_prucore.h
>> new file mode 100644
>> index 0000000..81f2ff9
>> --- /dev/null
>> +++ b/include/linux/mfd/pruss/da8xx_prucore.h
> Please rename your mfd include directory to include/linux/mfd/da8xx/, so 
> that
> one can match it with the drivers/mfd/da8xx driver code.

SG - Will do.

>
>
>> +typedef struct {
>> + u32 CONTROL;
>> + u32 STATUS;
>> + u32 WAKEUP;
>> + u32 CYCLECNT;
>> + u32 STALLCNT;
>> + u8  RSVD0[12];
>> + u32 CONTABBLKIDX0;
>> + u32 CONTABBLKIDX1;
>> + u32 CONTABPROPTR0;
>> + u32 CONTABPROPTR1;
>> + u8  RSVD1[976];
>> + u32 INTGPR[32];
>> + u32 INTCTER[32];
>> +} *da8xx_prusscore_regs;
> Again, we don't need that structure.

SG - As mentioned above.

>
> Cheers,
> Samuel.
>
>
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/ 

