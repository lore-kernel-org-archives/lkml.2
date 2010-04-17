Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0DQRHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 13:07:32 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40381 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0DQRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 13:07:13 -0400
Date: Sat, 17 Apr 2010 19:07:07 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       r.herring@freescale.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Subject: Re: [PATCHv4 2.6.34-rc4 5/7] mxc: Add generic USB HW
 initialization for MX51
Message-ID: <20100417170706.GY30801@buzzloop.caiaq.de>
References: <1271445371-18501-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-4-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-5-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271445371-18501-5-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 02:16:09PM -0500, Dinh.Nguyen@freescale.com wrote:
> This patch adds USB HW initializiation code to /plat-mxc/ehci.c.
> 	-Stops and resets USB HW
> 	-Sets some specific PHY settings
> 	-Stop and restart the USB HW.
> Renames mxc_set_usbcontrol to mxc_initialize_usb_hw.
> 
> This patch applies to 2.6.34-rc4.

Yes, the whole series looks _much_ better now, thanks!
Some minor things below.


> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/ehci.c                  |  128 ++++++++++++++++++++++++++++-
>  arch/arm/plat-mxc/include/mach/mxc_ehci.h |    2 +-
>  2 files changed, 127 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/ehci.c b/arch/arm/plat-mxc/ehci.c
> index cb0b638..35ff1c1 100644
> --- a/arch/arm/plat-mxc/ehci.c
> +++ b/arch/arm/plat-mxc/ehci.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
> + * Copyright (C) 2010 Freescale Semiconductor, Inc.
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the
> @@ -18,6 +19,7 @@
>  
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/delay.h>
>  
>  #include <mach/hardware.h>
>  #include <mach/mxc_ehci.h>
> @@ -50,9 +52,14 @@
>  #define MX35_H1_TLL_BIT		(1 << 5)
>  #define MX35_H1_USBTE_BIT	(1 << 4)
>  
> -int mxc_set_usbcontrol(int port, unsigned int flags)
> +int mxc_intialize_usb_hw(int port, unsigned int flags)

This patch and the next one should be merged into one. The reason is
that you rename a function here and the next patch follows that change.
Especially when bisecting, this can lead to uncompilable checkouts of
the tree when stopping in the middle.

>  {
>  	unsigned int v;
> +	void __iomem *usb_base;
> +	u32 usbotg_base;
> +	u32 usbother_base;
> +	int timeout;
> +	int ret = 0;

As you only use these variable in the MX51 case, ...

>  #ifdef CONFIG_ARCH_MX3
>  	if (cpu_is_mx31()) {
>  		v = readl(MX31_IO_ADDRESS(MX31_OTG_BASE_ADDR +
> @@ -186,9 +193,126 @@ int mxc_set_usbcontrol(int port, unsigned int flags)
>  		return 0;
>  	}
>  #endif /* CONFIG_MACH_MX27 */
> +#ifdef CONFIG_ARCH_MX51
> +	if (cpu_is_mx51()) {

... they can be local -> here.

> +		usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
> +
> +		switch (port) {
> +		case 0:	/* OTG port */
> +			usbotg_base = (u32)usb_base + USBOTG_OFFSET;
> +			break;
> +		case 1:	/* Host 1 port */
> +			usbotg_base = (u32)usb_base + USBH1_OFFSET;
> +			break;
> +		default:
> +			printk(KERN_ERR"%s no such port %d\n", __func__, port);
> +			ret = -ENOENT;
> +			goto error;
> +		}
> +		usbother_base = (u32)usb_base + USBOTHER_REGS_OFFSET;

That cast shouldn't be needed.

> +		/* Stop then Reset */
> +		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +		v &= ~UCMD_RUN_STOP;
> +		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> +		timeout = 0x100000;
> +		while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RUN_STOP)
> +			cpu_relax();

I'm thinking whether this __raw_readl/timeout procedure could be
factored out to some static inline function?

Also, the timeout seem _huge_.

> +		if (!timeout) {
> +			printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
> +			ret = -ETIMEDOUT;
> +			goto error;
> +		}
> +
> +		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +		v |= UCMD_RESET;
> +		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> +		timeout = 0x100000;
> +		while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RESET)
> +			cpu_relax();
> +		if (!timeout) {
> +			printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
> +			ret = -ETIMEDOUT;
> +			goto error;
> +		}
> +
> +		switch (port) {
> +		case 0:	/*OTG port */
> +			v = __raw_readl(usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +			v |= USB_UTMI_PHYCTRL_OC_DIS; /* OC is not used */
> +			__raw_writel(v, usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +
> +			v = __raw_readl(usbother_base + USBCTRL_OFFSET);
> +			v &= ~(UCTRL_OPM | UCTRL_OWIE);/* OTG wakeup/power mask disable */
> +			__raw_writel(v, usbother_base + USBCTRL_OFFSET);
> +
> +			/* Set the PHY clock to 19.2MHz */
> +			v = __raw_readl(usbother_base + USB_PHY_CTR_FUNC2_OFFSET);
> +			v &= ~USB_UTMI_PHYCTRL2_PLLDIV_MASK;
> +			v |= 0x01;
> +			__raw_writel(v, usbother_base + USB_PHY_CTR_FUNC2_OFFSET);
> +			break;
> +		case 1:	/* Host 1 */
> +			/*Host ULPI */
> +			v = __raw_readl(usbother_base + USB_CTRL_1_OFFSET);
> +			__raw_writel(v | USB_CTRL_UH1_EXT_CLK_EN, usbother_base + USB_CTRL_1_OFFSET);
> +
> +			v = __raw_readl(usbother_base + USBCTRL_OFFSET);
> +			v &= ~(UCTRL_H1WIE | UCTRL_H1UIE);/* HOST1 wakeup/ULPI intr disable */
> +			v |= UCTRL_H1PM; /* HOST1 power mask */
> +			__raw_writel(v, usbother_base + USBCTRL_OFFSET);
> +
> +			v = __raw_readl(usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +			v |= USB_UH1_OC_DIS; /* OC is not used */
> +			__raw_writel(v, usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +
> +			v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +			/* Interrupt Threshold Control:Immediate (no threshold) */
> +			v &= UCMD_ITC_NO_THRESHOLD;
> +			__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> +			break;
> +		}
> +
> +		/* need to reset the controller here so that the ID pin
> +		 * is correctly detected.
> +		 */
> +		/* Stop then Reset */
> +		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +		v &= ~UCMD_RUN_STOP;
> +		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> +		timeout = 0x100000;
> +		while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RUN_STOP)
> +			cpu_relax();
> +		if (!timeout) {
> +			printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
> +			ret = -ETIMEDOUT;
> +			goto error;
> +		}
> +
> +		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +		v |= UCMD_RESET;
> +		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
> +		timeout = 0x100000;
> +		while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RESET)
> +			cpu_relax();
> +		if (!timeout) {
> +			printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
> +			ret = -ETIMEDOUT;
> +			goto error;
> +		}
> +
> +		/* allow controller to reset, and leave time for
> +		 * the ULPI transceiver to reset too.
> +		 */
> +		msleep(100);
> +error:
> +		iounmap(usb_base);
> +		return ret;
> +	}

And especially because of the jump label, I think that function could be
split now into individual chunks for the different platforms now.
But that can be done later. I'll send in a patch once things are merged.

Thanks,
Daniel


> +#endif
>  	printk(KERN_WARNING
>  		"%s() unable to setup USBCONTROL for this CPU\n", __func__);
>  	return -EINVAL;
>  }
> -EXPORT_SYMBOL(mxc_set_usbcontrol);
> +EXPORT_SYMBOL(mxc_intialize_usb_hw);
>  
> diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> index c5b1e7b..e61feac 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> @@ -83,7 +83,7 @@ struct mxc_usbh_platform_data {
>  	struct otg_transceiver	*otg;
>  };
>  
> -int mxc_set_usbcontrol(int port, unsigned int flags);
> +int mxc_intialize_usb_hw(int port, unsigned int flags);
>  
>  #endif /* __INCLUDE_ASM_ARCH_MXC_EHCI_H */
>  
> -- 
> 1.6.0.4
> 
