Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0HAIof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:44:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57390 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0HAIod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:44:33 -0400
Date: Sun, 1 Aug 2010 09:44:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] cyber2000fb: add I2C support
Message-ID: <20100801084415.GA10608@n2100.arm.linux.org.uk>
References: <201007312255.51139.linux@rainbow-software.org> <20100731214242.GB3633@n2100.arm.linux.org.uk> <201008010013.39287.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008010013.39287.linux@rainbow-software.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 12:13:37AM +0200, Ondrej Zary wrote:
> Add I2C support for the DDC bus to cyber2000fb driver. This is only bus
> support, driver does not use EDID.
> Tested on two different CyberPro 2000 cards with i2cdetect and decode-edid.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
> This is v2 with added locking and ddc things properly named.
> 
> diff -urp linux-2.6.35-rc3-/drivers/video/cyber2000fb.c linux-2.6.35-rc3/drivers/video/cyber2000fb.c
> --- linux-2.6.35-rc3-/drivers/video/cyber2000fb.c	2010-07-31 21:58:35.000000000 +0200
> +++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-08-01 00:02:59.000000000 +0200
> @@ -48,6 +48,10 @@
>  #include <linux/init.h>
>  #include <linux/io.h>
>  
> +#include <linux/i2c.h>
> +#include <linux/i2c-id.h>
> +#include <linux/i2c-algo-bit.h>
> +
>  #include <asm/pgtable.h>
>  #include <asm/system.h>
>  
> @@ -88,6 +92,12 @@ struct cfb_info {
>  	u_char			ramdac_powerdown;
>  
>  	u32			pseudo_palette[16];
> +#ifdef CONFIG_FB_CYBER2000_I2C

CONFIG_FB_CYBER2000_DDC please.

> +	bool			ddc_registered;
> +	struct i2c_adapter	ddc_adapter;
> +	struct i2c_algo_bit_data	ddc_algo;
> +	struct mutex		reg_b0_lock;

Does the weight of a mutex really matter here, or would a spinlock be
lighter weight?
> +static void cyber2000fb_enable_ddc(struct cfb_info *cfb)
> +{
> +	mutex_lock(&cfb->reg_b0_lock);
> +	cyber2000fb_writew(0x1bf, 0x3ce, cfb);
> +}
> +
> +static void cyber2000fb_disable_ddc(struct cfb_info *cfb)
> +{
> +	cyber2000fb_writew(0x0bf, 0x3ce, cfb);
> +	mutex_unlock(&cfb->reg_b0_lock);
> +}
> +
> +
> +static void cyber2000fb_setscl(void *data, int val)

cyber2000fb_ddc_setscl

> +{
> +	struct cfb_info *cfb = data;
> +	unsigned char reg;
> +
> +	cyber2000fb_enable_ddc(cfb);
> +	reg = cyber2000_grphr(DDC_REG, cfb);
> +	if (!val)	/* bit is inverted */
> +		reg |= DDC_SCL_OUT;
> +	else
> +		reg &= ~DDC_SCL_OUT;
> +	cyber2000_grphw(DDC_REG, reg, cfb);
> +	cyber2000fb_disable_ddc(cfb);
> +}
> +
> +static void cyber2000fb_setsda(void *data, int val)

cyber2000fb_ddc_setsda

> +{
> +	struct cfb_info *cfb = data;
> +	unsigned char reg;
> +
> +	cyber2000fb_enable_ddc(cfb);
> +	reg = cyber2000_grphr(DDC_REG, cfb);
> +	if (!val)	/* bit is inverted */
> +		reg |= DDC_SDA_OUT;
> +	else
> +		reg &= ~DDC_SDA_OUT;
> +	cyber2000_grphw(DDC_REG, reg, cfb);
> +	cyber2000fb_disable_ddc(cfb);
> +}
> +
> +static int cyber2000fb_getscl(void *data)

cyber2000fb_ddc_getscl

> +{
> +	struct cfb_info *cfb = data;
> +	int retval;
> +
> +	cyber2000fb_enable_ddc(cfb);
> +	retval = !!(cyber2000_grphr(DDC_REG, cfb) & DDC_SCL_IN);
> +	cyber2000fb_disable_ddc(cfb);
> +
> +	return retval;
> +}
> +
> +static int cyber2000fb_getsda(void *data)

cyber2000fb_ddc_getsda
