Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2CHVL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:11:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53107 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2CHVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:11:26 -0500
Date: Thu, 8 Mar 2012 13:11:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH RESEND v3] USB: Support for LPC32xx SoC
Message-ID: <20120308211120.GB21058@kroah.com>
References: <1331068913-9321-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331068913-9321-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 10:21:53PM +0100, Roland Stigge wrote:
> This patch adds OHCI support to the LPC32xx ARM platform
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
>  drivers/usb/host/ohci-hcd.c     |    5 +++
>  drivers/usb/host/ohci-pnx4008.c |   66 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 67 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.orig/drivers/usb/host/ohci-hcd.c
> +++ linux-2.6/drivers/usb/host/ohci-hcd.c
> @@ -1055,6 +1055,11 @@ MODULE_LICENSE ("GPL");
>  #define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
>  #endif
>  
> +#ifdef CONFIG_ARCH_LPC32XX
> +#include "ohci-pnx4008.c"
> +#define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
> +#endif
> +
>  #ifdef CONFIG_ARCH_DAVINCI_DA8XX
>  #include "ohci-da8xx.c"
>  #define PLATFORM_DRIVER		ohci_hcd_da8xx_driver
> --- linux-2.6.orig/drivers/usb/host/ohci-pnx4008.c
> +++ linux-2.6/drivers/usb/host/ohci-pnx4008.c
> @@ -22,6 +22,7 @@
>  #include <linux/i2c.h>
>  
>  #include <mach/hardware.h>
> +#include <asm/mach-types.h>
>  #include <asm/io.h>
>  
>  #include <mach/platform.h>
> @@ -143,7 +144,17 @@ static void i2c_write(u8 buf, u8 subaddr
>  	i2c_master_send(isp1301_i2c_client, &tmpbuf[0], 2);
>  }
>  
> -static void isp1301_configure(void)
> +static u16 i2c_read16(u8 subaddr)
> +{
> +	u16 data;
> +
> +	i2c_master_send(isp1301_i2c_client, &subaddr, 1);
> +	i2c_master_recv(isp1301_i2c_client, (u8 *) &data, 2);
> +
> +	return data;
> +}
> +
> +static void isp1301_configure_pnx4008(void)
>  {
>  	/* PNX4008 only supports DAT_SE0 USB mode */
>  	/* PNX4008 R2A requires setting the MAX603 to output 3.6V */
> @@ -166,7 +177,51 @@ static void isp1301_configure(void)
>  		  ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR);
>  	i2c_write(0xFF,
>  		  ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR);
> +}
>  
> +static void isp1301_configure_lpc32xx(void)
> +{
> +	/* LPC32XX only supports DAT_SE0 USB mode */
> +	/* This sequence is important */
> +
> +	/* Disable transparent UART mode first */
> +	i2c_write(MC1_UART_EN, (ISP1301_I2C_MODE_CONTROL_1 |
> +		ISP1301_I2C_REG_CLEAR_ADDR));
> +
> +	i2c_write(~MC1_SPEED_REG, (ISP1301_I2C_MODE_CONTROL_1 |
> +		ISP1301_I2C_REG_CLEAR_ADDR));
> +	i2c_write(MC1_SPEED_REG, ISP1301_I2C_MODE_CONTROL_1);
> +	i2c_write(~0,
> +		(ISP1301_I2C_MODE_CONTROL_2 | ISP1301_I2C_REG_CLEAR_ADDR));
> +	i2c_write((MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL),
> +		ISP1301_I2C_MODE_CONTROL_2);
> +	i2c_write(~0, (ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR));
> +	i2c_write(MC1_DAT_SE0, ISP1301_I2C_MODE_CONTROL_1);
> +	i2c_write((OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN),
> +		ISP1301_I2C_OTG_CONTROL_1);
> +	i2c_write((OTG1_DM_PULLUP | OTG1_DP_PULLUP),
> +		(ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR));
> +	i2c_write(~0,
> +		 ISP1301_I2C_INTERRUPT_LATCH | ISP1301_I2C_REG_CLEAR_ADDR);
> +	i2c_write(~0,
> +		ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR);
> +	i2c_write(~0,
> +		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR);
> +
> +	/* Enable usb_need_clk clock after transceiver is initialized */
> +	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
> +
> +	printk(KERN_INFO "ISP1301 Vendor ID  : 0x%04x\n", i2c_read16(0x00));
> +	printk(KERN_INFO "ISP1301 Product ID : 0x%04x\n", i2c_read16(0x02));
> +	printk(KERN_INFO "ISP1301 Version ID : 0x%04x\n", i2c_read16(0x14));
> +}
> +
> +static void isp1301_configure(void)
> +{
> +	if (machine_is_pnx4008())
> +		isp1301_configure_pnx4008();
> +	else
> +		isp1301_configure_lpc32xx();
>  }
>  
>  static inline void isp1301_vbus_on(void)
> @@ -375,7 +430,8 @@ static int __devinit usb_hcd_pnx4008_pro
>  	}
>  
>  	/* Set all USB bits in the Start Enable register */
> -	pnx4008_set_usb_bits();
> +	if (machine_is_pnx4008())
> +		pnx4008_set_usb_bits();
>  
>  	hcd->rsrc_start = pdev->resource[0].start;
>  	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
> @@ -404,7 +460,8 @@ static int __devinit usb_hcd_pnx4008_pro
>  
>  	pnx4008_stop_hc();
>  out4:
> -	pnx4008_unset_usb_bits();
> +	if (machine_is_pnx4008())
> +		pnx4008_unset_usb_bits();

How come some of these pnx4008_* functions you have wrapped in
machine_is_pnx4008(), but not all of them?

Actually, why don't those functions do that kind of checking themselves,
without having to do this before you call them each time?

Consistancy is key.

thanks,

greg k-h
