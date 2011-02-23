Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1BWMYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:24:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1BWMY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:24:29 -0500
Message-ID: <24ADBD8C15AA48568F25C781C14387B2@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Samuel Ortiz" <sameo@linux.intel.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-2-git-send-email-subhasish@mistralsolutions.com> <20110221163027.GF10686@sortiz-mobl> <37B3755C4AE64BAA805DFBAEBDC3D9E4@subhasishg> <20110222103127.GC30279@sortiz-mobl>
In-Reply-To: <20110222103127.GC30279@sortiz-mobl>
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.
Date: Wed, 23 Feb 2011 17:55:44 +0530
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

--------------------------------------------------
From: "Samuel Ortiz" <sameo@linux.intel.com>
Sent: Tuesday, February 22, 2011 4:01 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<linux-arm-kernel@lists.infradead.org>; <m-watkins@ti.com>; 
<nsekhar@ti.com>; <sachi@mistralsolutions.com>; "open list" 
<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.

> Hi Subhasish,
>
> On Tue, Feb 22, 2011 at 11:13:38AM +0530, Subhasish Ghosh wrote:
>> Thank you for your comments.
> No problem.
>
>> >>diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> >>index fd01836..6c437df 100644
>> >>--- a/drivers/mfd/Kconfig
>> >>+++ b/drivers/mfd/Kconfig
>> >>@@ -81,6 +81,16 @@ config MFD_DM355EVM_MSP
>> >>   boards.  MSP430 firmware manages resets and power sequencing,
>> >>   inputs from buttons and the IR remote, LEDs, an RTC, and more.
>> >>
>> >>+config MFD_DA8XX_PRUSS
>> >>+ tristate "Texas Instruments DA8XX PRUSS support"
>> >>+ depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
>> >Why are we depending on those ?
>>
>> SG -- The PRUSS core in only available within DA850 and DA830,
>>            DA830 support is not yet implemented.
> Sure, but if there are no actual code dependencies, I'd like to get rid of
> those depends.


SG -- The PRU Clock and Power is the dependency here.
            This is available in arch/arm/mach-davinci/da850.c
            The source is specific to the SOC clock tree.

>
>> >>+u32 pruss_disable(struct device *dev, u8 pruss_num)
>> >>+{
>> >>+ struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
>> >>+ da8xx_prusscore_regs h_pruss;
>> >>+ u32 temp_reg;
>> >>+
>> >>+ if (pruss_num == DA8XX_PRUCORE_0) {
>> >>+ /* Disable PRU0  */
>> >>+ h_pruss = (da8xx_prusscore_regs)
>> >>+ ((u32) pruss->ioaddr + 0x7000);
>> >So it seems you're doing this in several places, and I have a few
>> >comments:
>> >
>> >- You don't need the da8xx_prusscore_regs at all.
>> >- Define the register map through a set of #define in your header file.
>> >- Use a static routine that takes the core number and returns the
>> >register map
>> >offset.
>> >
>> >Then routines like this one will look a lot more readable.
>>
>> SG -- There are a huge number of PRUSS registers. A lot of them are
>> reserved and are expected to change as development on the
>>            controller is still ongoing.
> First of all, from what I read in your patch you're only using the CONTROL
> offset.
>
>> If we use #defines to plot
>> all the registers, then first, there are too many array type
>> registers which will need to be duplicated.
> What I'm expecting is a small set of defines for the register offsets. You
> have 13 fields in your da8xx_prusscore_regs, you only need to define 13
> register offsets.
>
> So, if you have a:
>
> static u32 reg_offset(struct device *dev, u8 pru_num)
> {
> struct da8xx_pruss *pru = dev_get_drvdata(dev->parent);
>
> switch (pru_num) {
> case DA8XX_PRUCORE_0:
> return (u32) pru->ioaddr + 0x7000;
> case DA8XX_PRUCORE_1:
> return (u32) pru->ioaddr + 0x7800;
> default:
> return 0;
> }
>
>
> then routines like pruss_enable (which should return an int, btw) would 
> look
> like:
>
> int pruss_enable(struct device *dev, u8 pruss_num)
> {
> u32 offset = reg_offset(dev, pruss_num);
>
> if (offset == 0)
> return -EINVAL;
>
> __raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> offset + PRU_CORE_CONTROL);
>
> return 0;
> }
>
>> >Also, all your exported routines severely lack any sort of locking. An 
>> >IO
>> >mutex or spinlock is mandatory here.
>>
>> SG - As per our current implementation, we do not have two devices
>> running simultaneously on the PRU,
>>        so we do not have any way to test it. We have kept this as an
>> enhancement if request comes in for
>>        multiple devices.
> It's not about having multiple devices at the same time, it's about having
> multiple callers writing and reading to the same registers. Since you're
> exporting all your I/O routines you have no way to prevent 2 drivers from
> writing to the same register at the "same" time. You need locking here,
> regardless of the number of devices that you can have on a system.
>

SG - Ok, will do

>
>> >>+static int pruss_mfd_add_devices(struct platform_device *pdev)
>> >>+{
>> >>+ struct da8xx_pruss_devices *dev_data = pdev->dev.platform_data;
>> >>+ struct device *dev = &pdev->dev;
>> >>+ struct mfd_cell cell;
>> >>+ u32 err, count;
>> >>+
>> >>+ for (count = 0; (dev_data + count)->dev_name != NULL; count++) {
>> >>+ memset(&cell, 0, sizeof(struct mfd_cell));
>> >>+ cell.id = count;
>> >>+ cell.name = (dev_data + count)->dev_name;
>> >>+ cell.platform_data = (dev_data + count)->pdata;
>> >>+ cell.data_size = (dev_data + count)->pdata_size;
>> >>+
>> >>+ err = mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
>> >>+ if (err) {
>> >>+ dev_err(dev, "cannot add mfd cells\n");
>> >>+ return err;
>> >>+ }
>> >>+ }
>> >>+ return err;
>> >>+}
>> >So, what are the potential subdevices for this driver ? If it's a really
>> >dynamic setup, I'm fine with passing those as platform data but
>> >then do it so
>> >that you pass a NULL terminated da8xx_pruss_devices array. That will 
>> >avoid
>> >most of the ugly casts you're doing here.
>>
>> SG -- I did not follow your recommendations here, could you please
>> elaborate.
>>            I am already checking the dev_name for a NULL.
>>            This device is basically a microcontroller within DA850,
>> so basically any device or protocol can be
>>            emulated on it. Currently, we have emulated 8 UARTS using
>> the two PRUs and also a CAN device.
> Ok, I wasnt sure you can emulate anything on that thing. So I'm fine with 
> you
> passing all your devices through platform_data. But I'd prefer this 
> routine to
> look like:
>
> [...]
> for (count = 0; dev_data[count] != NULL; count++) {
> memset(&cell, 0, sizeof(struct mfd_cell));
> cell.id = count;
> cell.name = dev_data[count]->dev_name;
> cell.platform_data = dev_data[count]->pdata;
> cell.data_size = dev_data[count]->pdata_size;
>
> Looks nicer to me.

SG - I have a problem here, dev_data was initialized as a structure array.

static struct da8xx_pruss_devices pruss_devices[] = {
        {
                .dev_name       = "da8xx_pruss_can",
                .pdata          = &can_data,
                .pdata_size     = sizeof(can_data),
                .setup          = da850_evm_setup_pruss_can,
                .num_resources  = 0,
                .resources      = NULL,
        },
        {
                .dev_name       = "da8xx_pruss_uart",
                .pdata          = &suart_data,
                .pdata_size     = sizeof(suart_data),
                .setup          = da850_evm_setup_pruss_suart,
                .num_resources  = ARRAY_SIZE(da850_evm_suart_resource),
                .resources      = da850_evm_suart_resource,
        },
        {
                .dev_name       = NULL,
        },
};

How can I initialize the last array element to NULL!
I think, I must have some type of delimiter.

>
> Cheers,
> Samuel.
>
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/ 

