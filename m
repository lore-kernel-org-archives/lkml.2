Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0DOGxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:53:25 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:59580 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0DOGxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:53:23 -0400
Date: Thu, 15 Apr 2010 08:53:11 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, grant.likely@secretlab.ca,
       r.herring@freescale.com, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Subject: Re: [PATCH 2.6.34-rc4 3/3] mx5: Enable USB host funcionality on
 Freescale MX51 Babbage HW
Message-ID: <20100415065311.GH30801@buzzloop.caiaq.de>
References: <1271312718-10223-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271312718-10223-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271312718-10223-3-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271312718-10223-3-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 01:25:18AM -0500, Dinh.Nguyen@freescale.com wrote:
> This patch enables USB host functionality for Host1 and OTG port on
> Freescale MX51 Babbage HW. This patch contains the board specific
> HW initialization of the USB HW. Updates mx51_defconfig to enable
> USB EHCI.
> 
> This patch applies to 2.6.34-rc4.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/configs/mx51_defconfig           |   17 ++-
>  arch/arm/mach-mx5/board-mx51_babbage.c    |  267 ++++++++++++++++++++++++++++-
>  arch/arm/plat-mxc/include/mach/mxc_ehci.h |   48 +++++
>  3 files changed, 330 insertions(+), 2 deletions(-)

That should be at least two patches again - one for the board specific
things, and one for generic stuff.

[...]

> +static int babbage_usbotg_init(struct platform_device *pdev)
> +{
> +	u32 reg_value;
> +	void __iomem *usb_base;
> +	u32 usbotg_base;
> +	u32 usbother_base;
> +	int timeout;
> +	int ret = 0;
> +
> +	usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
> +	usbotg_base = (u32)usb_base + USBOTG_OFFSET;
> +	usbother_base = (u32)usb_base + USBOTHER_REGS_OFFSET;
> +
> +	/* Stop then Reset */
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value &= ~UCMD_RUN_STOP;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	timeout = 0x100000;
> +	while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RUN_STOP)
> +		cpu_relax();
> +	if (!timeout) {
> +		printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
> +		ret = -ETIMEDOUT;
> +		goto error;
> +		}
> +
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	timeout = 0x100000;
> +	while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RESET)
> +		cpu_relax();
> +	if (!timeout) {
> +		printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
> +		ret = -ETIMEDOUT;
> +		goto error;
> +		}
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

This should already be done in drivers/usb/host/ehci-mxc.c, taking into
account the .portsc value from your pdata. Maybe add some printk() there
and see which values get passed.

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
> +	timeout = 0x100000;
> +	while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RUN_STOP)
> +		cpu_relax();
> +	if (!timeout) {
> +		printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
> +		ret = -ETIMEDOUT;
> +		goto error;
> +		}
> +
> +	reg_value = __raw_readl(usbotg_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbotg_base + USBCMD_OFFSET);
> +	timeout = 0x100000;
> +	while (--timeout && __raw_readl(usbotg_base + USBCMD_OFFSET) & UCMD_RESET)
> +		cpu_relax();
> +	if (!timeout) {
> +		printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
> +		ret = -ETIMEDOUT;
> +		goto error;
> +		}
> +
> +	/* allow controller to reset, and leave time for
> +	 * the ULPI transceiver to reset too.
> +	 */
> +	msleep(100);
> +error:
> +	iounmap(usb_base);
> +
> +	pr_debug("%s: success\n", __func__);
> +	return ret;
> +}

Hmm, no. Now all code is in your board code, so it's not reusable by
other boards.

Again, the code in this functions which writes to the registers should
not contain any hard-coded assumptions or addresses, and should also be
moved to generic places once it is generic.

Please have a look at plat-mxc/ehci.c again and see how things are done
for mx2 and mx3.


> +
> +static struct mxc_usbh_platform_data dr_utmi_config = {
> +	.init	= babbage_usbotg_init,
> +	.portsc	= MXC_EHCI_UTMI_16BIT,
> +	.flags	= MXC_EHCI_INTERNAL_PHY,
> +};
> +
> +static int babbage_usbh1_init(struct platform_device *pdev)
> +{
> +	u32 reg_value;
> +	void __iomem *usb_base;
> +	u32 usbh1_base;
> +	u32 usbother_base;
> +	int timeout;
> +	int ret = 0;
> +
> +	usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
> +	usbh1_base = (u32)usb_base + USBH1_OFFSET;
> +	usbother_base = (u32)usb_base + USBOTHER_REGS_OFFSET;
> +
> +	/* Stop then Reset */
> +	reg_value = __raw_readl(usbh1_base + USBCMD_OFFSET);
> +	reg_value &= ~UCMD_RUN_STOP;
> +	__raw_writel(reg_value, usbh1_base + USBCMD_OFFSET);
> +	timeout = 0x100000;
> +	while (--timeout && __raw_readl(usbh1_base + USBCMD_OFFSET) & UCMD_RUN_STOP)
> +		cpu_relax();
> +	if (!timeout) {
> +		printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
> +		ret = -ETIMEDOUT;
> +		goto error;
> +		}
> +
> +	reg_value = __raw_readl(usbh1_base + USBCMD_OFFSET);
> +	reg_value |= UCMD_RESET;
> +	__raw_writel(reg_value, usbh1_base + USBCMD_OFFSET);
> +	timeout = 0x100000;
> +	while (--timeout && __raw_readl(usbh1_base + USBCMD_OFFSET) & UCMD_RESET)
> +		cpu_relax();
> +	if (!timeout) {
> +		printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
> +		ret = -ETIMEDOUT;
> +		goto error;
> +		}
> +
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
> +
> +error:
> +	iounmap(usb_base);
> +
> +	/* allow controller to reset, and leave time for
> +	* the ULPI transceiver to reset too.
> +	*/
> +	msleep(100);
> +	return ret;
> +}

Again - once your code is generic, this second set of functions will not
be needed anymore.

> +static int gpio_usbh1_active(void)
> +{
> +	struct pad_desc usbh1stp_gpio = MX51_PAD_USBH1_STP__GPIO_1_27;
> +	int ret;
> +
> +	/* Set USBH1_STP to GPIO and toggle it */
> +	mxc_iomux_v3_setup_pad(&usbh1stp_gpio);
> +	ret = gpio_request(27, "usbh1_stp");
> +
> +	if (ret) {
> +		pr_debug("failed to get MX51_PAD_USBH1_STP__GPIO_1_27: %d\n", ret);
> +		return ret;
> +	}
> +	gpio_direction_output(27, 0);
> +	gpio_set_value(27, 1);
> +	msleep(100);
> +	gpio_free(27);
> +	return 0;
> +}
> +
> +static struct mxc_usbh_platform_data usbh1_config = {
> +	.init	= babbage_usbh1_init,
> +	.portsc	= MXC_EHCI_MODE_ULPI,
> +	.flags	= MXC_EHCI_POWER_PINS_ENABLED,
> +};
> +
> +static inline void babbage_usbhub_reset(void)
> +{
> +	int ret;
> +
> +	/* Bring USB hub out of reset */
> +	ret = gpio_request(GPIO_USB_HUB_RESET, "GPIO1_7");
> +	if (ret) {
> +		printk("failed to get GPIO_USB_HUB_RESET: %d\n", ret);
> +		return;
> +	}
> +	gpio_direction_output(GPIO_USB_HUB_RESET, 0);
> +
> +	/* USB HUB RESET - De-assert USB HUB RESET_N */
> +	msleep(1);
> +	gpio_set_value(GPIO_USB_HUB_RESET, 0);
> +	msleep(1);
> +	gpio_set_value(GPIO_USB_HUB_RESET, 1);
> +}
> +
>  /*
>   * Board specific initialization.
>   */
>  static void __init mxc_board_init(void)
>  {
> +	struct pad_desc usbh1stp = MX51_PAD_USBH1_STP__USBH1_STP;
> +
>  	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads,
>  					ARRAY_SIZE(mx51babbage_pads));
>  	mxc_init_imx_uart();
>  	platform_add_devices(devices, ARRAY_SIZE(devices));
> +
> +	mxc_register_device(&mxc_usbdr_host_device, &dr_utmi_config);
> +
> +	gpio_usbh1_active();
> +	mxc_register_device(&mxc_usbh1_device, &usbh1_config);
> +	/* setback USBH1_STP to be function */
> +	mxc_iomux_v3_setup_pad(&usbh1stp);
> +	babbage_usbhub_reset();
>  }
>  
>  static void __init mx51_babbage_timer_init(void)
> diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> index 4b9b836..728eb36 100644
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
> +#define UCMD_ITC_NO_THRESHOLD	 	(~(0xff << 16))	/* Interrupt Threshold Control */
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
> -- 
> 1.6.0.4
> 
