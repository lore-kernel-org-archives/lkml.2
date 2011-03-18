Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1CRMAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:00:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49712 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1CRL7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:59:55 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 18 Mar 2011 17:29:39 +0530
Subject: RE: [PATCH v3 1/7] mfd: add pruss mfd driver.
Thread-Topic: [PATCH v3 1/7] mfd: add pruss mfd driver.
Thread-Index: AcvdlpcsbEzELr1+QLaf4kif5wmnOQHw+vDA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C3B85A5@dbde02.ent.ti.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
 <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subhasish,

On Tue, Mar 08, 2011 at 19:27:40, Subhasish Ghosh wrote:
> This patch adds the pruss MFD driver and associated include files.
> For details regarding the PRUSS please refer the folowing link:
> http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem
> 
> The rational behind the MFD driver being the fact that multiple devices can
> be implemented on the cores independently. This is determined by the nature
> of the program which is loaded into the PRU's instruction memory.
> A device may be de-initialized and another loaded or two different devices
> can be run simultaneously on the two cores.
> It's also possible, as in our case, to implement a single device on both
> the PRU's resulting in improved load sharing.
> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  drivers/mfd/Kconfig                     |   10 +
>  drivers/mfd/Makefile                    |    1 +
>  drivers/mfd/da8xx_pru.c                 |  560 +++++++++++++++++++++++++++++++
>  include/linux/mfd/da8xx/da8xx_pru.h     |  135 ++++++++
>  include/linux/mfd/da8xx/da8xx_prucore.h |  129 +++++++
>  5 files changed, 835 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/da8xx_pru.c
>  create mode 100644 include/linux/mfd/da8xx/da8xx_pru.h
>  create mode 100644 include/linux/mfd/da8xx/da8xx_prucore.h

PRUSS as an IP is not really tied to the DA8xx SoC architecture.
So, can you please name the files ti-pruss* or even just pruss if
MFD folks are okay with it?

> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index fd01836..6c437df 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -81,6 +81,16 @@ config MFD_DM355EVM_MSP
>  	  boards.  MSP430 firmware manages resets and power sequencing,
>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
>  
> +config MFD_DA8XX_PRUSS
> +	tristate "Texas Instruments DA8XX PRUSS support"
> +	depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850

Just ARCH_DAVINCI_DA850 should be okay since ARCH_DAVINCI_DA850
Already depends on ARCH_DAVINCI

> +	select MFD_CORE
> +	help
> +	  This driver provides support api's for the programmable

"API" would be preferred. Also please remove the apostrophe.

> +	  realtime unit (PRU) present on TI's da8xx processors. It
> +	  provides basic read, write, config, enable, disable
> +	  routines to facilitate devices emulated on it.
> +
>  config HTC_EGPIO
>  	bool "HTC EGPIO support"
>  	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index a54e2c7..670d6b0 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
>  obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
>  
>  obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
> +obj-$(CONFIG_MFD_DA8XX_PRUSS)	+= da8xx_pru.o
>  obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
>  
>  obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
> diff --git a/drivers/mfd/da8xx_pru.c b/drivers/mfd/da8xx_pru.c
> new file mode 100644
> index 0000000..0fd9bb2
> --- /dev/null
> +++ b/drivers/mfd/da8xx_pru.c
> @@ -0,0 +1,560 @@
> +/*
> + * Copyright (C) 2011 Texas Instruments Incorporated
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as  published by the
> + * Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/mfd/da8xx/da8xx_prucore.h>
> +#include <linux/mfd/da8xx/da8xx_pru.h>
> +#include <linux/mfd/core.h>
> +#include <linux/io.h>
> +#include <mach/da8xx.h>

Hmm, this means the driver is tied to the platform.
This should not be the case. 

I was able to get this patch compiled even
after removing this include. Please remove it
in the next version.

> +
> +struct da8xx_pruss {

I would prefer if the variables and data structures
and includes are not pre-fixed with da8xx as well.

> +	struct device *dev;
> +	spinlock_t lock;
> +	struct resource *res;
> +	struct clk *clk;
> +	u32 clk_freq;
> +	void __iomem *ioaddr;
> +};
> +
> +u32 pruss_get_clk_freq(struct device *dev)
> +{
> +	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
> +
> +	return pruss->clk_freq;
> +}
> +EXPORT_SYMBOL(pruss_get_clk_freq);

This looks strange. Why do we need this? There
is clk_get_rate() API in the kernel would would
seem more suitable.

> +
> +s32 pruss_disable(struct device *dev, u8 pruss_num)
> +{
> +	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
> +	struct da8xx_prusscore_regs *h_pruss;
> +	struct pruss_map *pruss_mmap = (struct pruss_map *)pruss->ioaddr;
> +	u32 temp_reg;
> +	u32 delay_cnt;
> +
> +	if ((pruss_num != DA8XX_PRUCORE_0) && (pruss_num != DA8XX_PRUCORE_1))
> +		return -EINVAL;
> +
> +	spin_lock(&pruss->lock);
> +	if (pruss_num == DA8XX_PRUCORE_0) {
> +		/* pruss deinit */
> +		__raw_writel(0xFFFFFFFF, (PRUSS_INTC_STATCLRINT0 & 0xFFFF));

Why not use writel instead? Per my understanding
The __raw_ variants are unsafe to use on ARMv6
and above.

> +		/* Disable PRU0  */
> +		h_pruss = (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_0];
> +
> +		temp_reg = __raw_readl(&h_pruss->CONTROL);
> +		temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +		__raw_writel(temp_reg, &h_pruss->CONTROL);
> +
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--) {
> +
> +			temp_reg = __raw_readl(&h_pruss->CONTROL);
> +			temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +			__raw_writel(temp_reg, &h_pruss->CONTROL);
> +		}
> +
> +		/* Reset PRU0 */
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--)
> +			__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +					&h_pruss->CONTROL);
> +
> +	} else if (pruss_num == DA8XX_PRUCORE_1) {
> +		/* pruss deinit */
> +		__raw_writel(0xFFFFFFFF, (PRUSS_INTC_STATCLRINT1 & 0xFFFF));
> +		/* Disable PRU1 */
> +		h_pruss = (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_1];
> +		temp_reg = __raw_readl(&h_pruss->CONTROL);
> +		temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +		__raw_writel(temp_reg, &h_pruss->CONTROL);
> +
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--) {
> +
> +			temp_reg = __raw_readl(&h_pruss->CONTROL);
> +			temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +			__raw_writel(temp_reg, &h_pruss->CONTROL);
> +		}
> +
> +		/* Reset PRU1 */
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--)
> +			__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +							&h_pruss->CONTROL);
> +	}

There is a lot of code repeated between the if and else and
I am sure it will be possible to remove the if-else block
altogether and use the pruss_num as an index know which
core to operate on. Doing this will also help add more cores
later.

I really couldn't complete this review (got to rush now),
but I thought I will send you what I have. You can wait
for review to complete before posting another version.

Thanks,
Sekhar
