Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0DMR1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:27:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47504 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0DMR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:27:45 -0400
Date: Tue, 13 Apr 2010 19:27:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, bryan.wu@canonical.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 3/8] mxc: Add platform specific USB
 functions for Freescale MX51 HW
Message-ID: <20100413172738.GO30801@buzzloop.caiaq.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:10:26AM -0500, Dinh.Nguyen@freescale.com wrote:
> This patch is part of enabling USB for Freescale MX51 Babbage HW. This
> patch performs some platform specific USB HW initialization, and adds
> the necessary defines.
> 
> This patch applies to 2.6.34-rc4.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/Makefile                |    2 +-
>  arch/arm/plat-mxc/include/mach/mxc_ehci.h |   48 +++++++
>  arch/arm/plat-mxc/usb_common.c            |  190 +++++++++++++++++++++++++++++
>  3 files changed, 239 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/usb_common.c

There are several general problems with this.

The functions you implement here are not at all common but purely
specific to mx51, so the name of the file and functions as well as the
location in the tree is plainly wrong.

Also, this code also completely ignores all the work that has been done
to keep things generic as much as possible. See below.

> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> index 895bc3c..fa8ed78 100644
> --- a/arch/arm/plat-mxc/Makefile
> +++ b/arch/arm/plat-mxc/Makefile
> @@ -3,7 +3,7 @@
>  #
>  
>  # Common support
> -obj-y := irq.o clock.o gpio.o time.o devices.o cpu.o system.o
> +obj-y := irq.o clock.o gpio.o time.o devices.o cpu.o system.o usb_common.o
>  
>  # MX51 uses the TZIC interrupt controller, older platforms use AVIC (irq.o)
>  obj-$(CONFIG_MXC_TZIC) += tzic.o
> diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> index 4b9b836..6edf8d7 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> @@ -1,6 +1,30 @@
>  #ifndef __INCLUDE_ASM_ARCH_MXC_EHCI_H
>  #define __INCLUDE_ASM_ARCH_MXC_EHCI_H
>  
> +#define USBOTG_OFFSET			0
> +#define USBH1_OFFSET			0x200
> +#define USBH2_OFFSET			0x400
> +#define USBH3_OFFSET			0x600
> +#define USBOTHER_REGS_OFFSET	0x800
> +
> +#define USBCMD_OFFSET			0x140
> +
> +#define ULPI_VIEWPORT_OFFSET	0x170
> +#define PORTSC_OFFSET		0x184
> +#define USBMODE_OFFSET		0x1a8
> +#define USBMODE_CM_HOST		3
> +
> +#define USBCTRL_OFFSET					0
> +#define USB_PHY_CTR_FUNC_OFFSET		0x8
> +#define USB_PHY_CTR_FUNC2_OFFSET		0xc
> +#define USB_CTRL_1_OFFSET				0x10
> +
> +
> +/* USBCMD */
> +#define UCMD_RUN_STOP           (1 << 0)        /* controller run/stop */
> +#define UCMD_RESET		(1 << 1)	/* controller reset */
> +#define UCMD_ITC_NO_THRESHOLD	 ~(0xff << 16)	/* Interrupt Threshold Control */
> +
>  /* values for portsc field */
>  #define MXC_EHCI_PHY_LOW_POWER_SUSPEND	(1 << 23)
>  #define MXC_EHCI_FORCE_FS		(1 << 24)
> @@ -26,6 +50,30 @@
>  #define MXC_EHCI_IPPUE_DOWN		(1 << 8)
>  #define MXC_EHCI_IPPUE_UP		(1 << 9)
>  
> +/* USB_CTRL */
> +#define UCTRL_OUIE		(1 << 28)	/* OTG ULPI intr enable */
> +#define UCTRL_OWIE		(1 << 27)	/* OTG wakeup intr enable */
> +#define UCTRL_OBPVAL_RXDP	(1 << 26)	/* OTG RxDp status in bypass mode */
> +#define UCTRL_OBPVAL_RXDM	(1 << 25)	/* OTG RxDm status in bypass mode */
> +#define UCTRL_OPM		(1 << 24)	/* OTG power mask */
> +#define UCTRL_H1UIE		(1 << 12)	/* Host1 ULPI interrupt enable */
> +#define UCTRL_H1WIE		(1 << 11)	/* HOST1 wakeup intr enable */
> +#define UCTRL_H1PM		(1 <<  8)		/* HOST1 power mask */
> +
> +/* USB_PHY_CTRL_FUNC */
> +#define USB_UTMI_PHYCTRL_OC_DIS	(1 << 8)	/* OTG Disable Overcurrent Event */
> +#define USB_UH1_OC_DIS	(1 << 5)		/* UH1 Disable Overcurrent Event */
> +
> +/* USB_CTRL_1 */
> +#define USB_CTRL_UH1_EXT_CLK_EN			(1 << 25)
> +#define USB_CTRL_UH2_EXT_CLK_EN			(1 << 26)
> +
> +/* USB_PHY_CTRL_FUNC2*/
> +#define USB_UTMI_PHYCTRL2_PLLDIV_MASK		0x3
> +#define USB_UTMI_PHYCTRL2_PLLDIV_SHIFT		0
> +#define USB_UTMI_PHYCTRL2_HSDEVSEL_MASK		0x3
> +#define USB_UTMI_PHYCTRL2_HSDEVSEL_SHIFT	19
> +
>  struct mxc_usbh_platform_data {
>  	int (*init)(struct platform_device *pdev);
>  	int (*exit)(struct platform_device *pdev);
> diff --git a/arch/arm/plat-mxc/usb_common.c b/arch/arm/plat-mxc/usb_common.c
> new file mode 100644
> index 0000000..b06c66e
> --- /dev/null
> +++ b/arch/arm/plat-mxc/usb_common.c
> @@ -0,0 +1,190 @@
> +/*
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> + * MA 02110-1301, USA.
> + */
> +
> +/*
> + *Include files
> + */
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/fsl_devices.h>
> +#include <mach/mxc_ehci.h>
> +#include <mach/hardware.h>
> +
> +static void usbh1_set_ulpi_xcvr(void)
> +{
> +	u32 reg_value;
> +	pr_debug("%s: \n", __func__);
> +	void __iomem *usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);

You shouldn't mix declarations and code like this. The compiler should
also have complained.

> +	u32 usbh1_base = (u32)usb_base + USBH1_OFFSET;
> +	u32 usbother_base = (u32)usb_base + USBOTHER_REGS_OFFSET;
> +
> +	/* Stop then Reset */
> +	reg_value = __raw_readl(usbh1_base + USBCMD_OFFSET);
> +	reg_value &= ~UCMD_RUN_STOP;
> +	__raw_writel(reg_value, usbh1_base + USBCMD_OFFSET);
> +	while (__raw_readl(usbh1_base + USBCMD_OFFSET) & UCMD_RUN_STOP);

This isn't good. If the above condition will never become true, the
kernel hangs in an endless loop. There should be a timeout and a call to
cpu_relax().

> +	reg_value = __raw_readl(usbh1_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbh1_base + USBCMD_OFFSET);
> +	while (__raw_readl(usbh1_base + USBCMD_OFFSET) & UCMD_RESET);

Dito.

> +	reg_value = __raw_readl(usbother_base + USB_CTRL_1_OFFSET);
> +	__raw_writel(reg_value | USB_CTRL_UH1_EXT_CLK_EN, usbother_base + USB_CTRL_1_OFFSET);
> +
> +	/* select ULPI PHY PTS=2 */
> +	reg_value = __raw_readl(usbh1_base + PORTSC_OFFSET);
> +	reg_value &= ~MXC_EHCI_MODE_SERIAL;
> +	__raw_writel(reg_value |= MXC_EHCI_MODE_ULPI, usbh1_base + PORTSC_OFFSET);
> +
> +	reg_value = __raw_readl(usbother_base + USBCTRL_OFFSET);
> +	reg_value &= ~(UCTRL_H1WIE | UCTRL_H1UIE);/* HOST1 wakeup/ULPI intr disable */
> +	reg_value |= UCTRL_H1PM; /* HOST1 power mask */
> +	__raw_writel(reg_value, usbother_base + USBCTRL_OFFSET);
> +
> +	reg_value = __raw_readl(usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +	reg_value |= USB_UH1_OC_DIS; /* OC is not used */
> +	__raw_writel(reg_value, usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +
> +	reg_value = __raw_readl(usbh1_base + USBCMD_OFFSET);
> +	/* Interrupt Threshold Control:Immediate (no threshold) */
> +	reg_value &= UCMD_ITC_NO_THRESHOLD;
> +	__raw_writel(reg_value, usbh1_base + USBCMD_OFFSET);
> +
> +	/* reset the controller */
> +	reg_value = __raw_readl(usbh1_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbh1_base + USBCMD_OFFSET);

These are all settings specific to the actual board implementation, and
these cases are exactly what the abstract layer was invented for.

In general, the code above should be made a lot more versatile and also
be put in plat-mxc/ehci.c. Look at the implementations of mx2 and mx3
and see how things are done there.

> +
> +	iounmap(usb_base);
> +
> +	/* allow controller to reset, and leave time for
> +	* the ULPI transceiver to reset too.
> +	*/
> +	msleep(100);
> +}
> +
> +int fsl_usb_host_init(struct platform_device *pdev)
> +{
> +	pr_debug("%s: pdev=0x%p\n", __func__, pdev);
> +
> +	usbh1_set_ulpi_xcvr();
> +
> +	pr_debug("%s: success\n", __func__);
> +	return 0;
> +}
> +EXPORT_SYMBOL(fsl_usb_host_init);
> +
> +int fsl_usb_host_uninit(struct fsl_usb2_platform_data *pdata)
> +{
> +	pr_debug("%s\n", __func__);
> +	return 0;
> +}
> +EXPORT_SYMBOL(fsl_usb_host_uninit);
> +
> +static void otg_set_utmi_xcvr(void)
> +{
> +	u32 reg_value;
> +	void __iomem *usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
> +	u32 usbotg_base = (u32)usb_base + USBOTG_OFFSET;
> +	u32 usbother_base = (u32)usb_base + USBOTHER_REGS_OFFSET;
> +
> +	pr_debug("otg_set_utmi_xcvr\n");
> +
> +	/* Stop then Reset */
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value &= ~UCMD_RUN_STOP;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	while (__raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RUN_STOP);
> +
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	while (__raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RESET);
> +
> +	reg_value = __raw_readl(usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +	reg_value |= USB_UTMI_PHYCTRL_OC_DIS; /* OC is not used */
> +	__raw_writel(reg_value, usbother_base + USB_PHY_CTR_FUNC_OFFSET);
> +
> +	reg_value = __raw_readl(usbother_base + USBCTRL_OFFSET);
> +	reg_value &= ~(UCTRL_OPM | UCTRL_OWIE);/* OTG wakeup/power mask disable */
> +	__raw_writel(reg_value, usbother_base + USBCTRL_OFFSET);
> +
> +	/* set UTMI xcvr */
> +	reg_value = __raw_readl(usbotg_base + PORTSC_OFFSET);
> +	reg_value &= ~MXC_EHCI_MODE_SERIAL;
> +	__raw_writel(reg_value |= MXC_EHCI_MODE_UTMI, usbotg_base + PORTSC_OFFSET);
> +
> +	/* Set the PHY clock to 19.2MHz */
> +	reg_value = __raw_readl(usbother_base + USB_PHY_CTR_FUNC2_OFFSET);
> +	reg_value &= ~USB_UTMI_PHYCTRL2_PLLDIV_MASK;
> +	reg_value |= 0x01;
> +	__raw_writel(reg_value, usbother_base + USB_PHY_CTR_FUNC2_OFFSET);
> +
> +	/* Workaround an IC issue for ehci driver:
> +	 * when turn off root hub port power, EHCI set
> +	 * PORTSC reserved bits to be 0, but PTW with 0
> +	 * means 8 bits tranceiver width, here change
> +	 * it back to be 16 bits and do PHY diable and
> +	 * then enable.
> +	 */
> +	reg_value = __raw_readl(usbotg_base + PORTSC_OFFSET);
> +	reg_value |= MXC_EHCI_UTMI_16BIT;
> +	__raw_writel(reg_value, usbotg_base + PORTSC_OFFSET);
> +
> +	/* need to reset the controller here so that the ID pin
> +	 * is correctly detected.
> +	 */
> +	/* Stop then Reset */
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value &= ~UCMD_RUN_STOP;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	while (__raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RUN_STOP);
> +
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	while (__raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RESET);
> +
> +	iounmap(usb_base);
> +	/* allow controller to reset, and leave time for
> +	 * the ULPI transceiver to reset too.
> +	 */
> +	msleep(100);
> +}
> +
> +int usbotg_init(struct platform_device *pdev)
> +{
> +	pr_debug("%s: pdev=0x%p\n", __func__, pdev);
> +
> +	otg_set_utmi_xcvr();
> +
> +	pr_debug("%s: success\n", __func__);
> +	return 0;
> +}
> +EXPORT_SYMBOL(usbotg_init);
> +
> +int usbotg_uninit(struct platform_device *pdev)
> +{
> +	pr_debug("%s\n", __func__);
> +	return 0;
> +}
> +EXPORT_SYMBOL(usbotg_uninit);

The second half of the file is just a copy of the first, and it is just
there because things are not abstracted but hard-coded.

