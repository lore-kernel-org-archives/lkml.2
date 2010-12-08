Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0LHT0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:26:22 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:59806 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0LHT0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:26:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HFGPCx5qGRVlHkUdV0YrnxS3RUvDGRkUcUOVHww7Jq7Ynrn/c1sQ1MKzHD+c2PWvV3
         QaXlBt0G00YybC0aHp75Owb4enyw/iIudVHjBmG8kGyY9FgSDogcsxUtUw0av589Ju8H
         WdvRzcGqQPRBlDlm7IB4zhB7N1YRRzTCGMCL8=
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, plagnioj@jcrosoft.com
In-Reply-To: <4CFE90CA.9050004@bluewatersys.com>
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com>
	 <4CFE90CA.9050004@bluewatersys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 22:26:13 +0300
Message-ID: <1291836373.15873.55.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ryan,

Couple more answers below.

> > +++ b/arch/arm/configs/stamp9g20gms_defconfig
> > @@ -0,0 +1,147 @@
> > +CONFIG_EXPERIMENTAL=y
> > +CONFIG_SYSVIPC=y
> > +CONFIG_LOG_BUF_SHIFT=14
> > +CONFIG_BLK_DEV_INITRD=y
> > +CONFIG_SLAB=y
> > +CONFIG_MODULES=y
> > +CONFIG_MODULE_UNLOAD=y
> > +CONFIG_ARCH_AT91=y
> > +CONFIG_ARCH_AT91SAM9G20=y
> > +CONFIG_MACH_STAMP9G20GMS=y
> 
> This is better and now looks (at a glance) almost identical to
> stamp9g20_defconfig. Can you just add CONFIG_MACH_STAMP9G20GMS to
> stamp9g20_defconfig and support both boards?

It is not possible to use the same defconfig for gms and other carrier
boards, because 69 different CONFIG_xxx options required for our machine
(compared with Portux G20) and our options excessive for other devices
based on the Stamp9G20.

> > diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> > index c015b68..6bc9372 100644
> > --- a/arch/arm/mach-at91/Kconfig
> > +++ b/arch/arm/mach-at91/Kconfig
> > @@ -375,6 +375,12 @@ config MACH_STAMP9G20
> >  	  evaluation board.
> >  	  <http://www.taskit.de/en/>
> >  
> > +config MACH_STAMP9G20GMS
> > +	bool "GeoSIG Stamp9G20 GMS"
> > +	help
> > +	  Select this if you are using taskit's Stamp9G20 with GeoSIG's GMS.
> > +	  <http://www.geosig.com>
> > +
> 
> Looking at this a bit more closely, the Stamp9G20 is a system on module
> (SoM) board. The MACH_STAMP9G20 option supports the Stamp9G20 on
> taskits's evaluation board and the MACH_PCONTROL_G20 option supports it
> on the PControl carrier board. There is a reasonable amount of code
> replication in each of the board files for the UARTs, NAND, MMC, etc.
> 
> Would it be better to have MACH_STAMPG20/board-stamp-9g20.c contain the
> core support for the Stamp9G20 module and then each of the carrier board
> files contain only the setup/devices found on the carrier board?
> 
> I don't know what the correct approach for SoMs. We are also interested
> in this as we develop SoMs with carrier boards. Cc'ed Russell King for
> his opinion.

You are right about the Stamp9G20 SoM.
The Stamp9G20 SoM can not be used without a carrier board from physical
point of view. It need a power supply and console interface at least.

I will send a new PATCH v3, where code for the Stamp9G20 SoM separated
into the board-stamp9g20.c, and following files will correspond to
carrier boards for Stamp9G20:
* carrier-board-gms.c - "GMS", Seismograph from GeoSIG.
* carrier-board-panelcardevb.c - "Panel Card EVB", Taskit's eval. board.
* carrier-board-portuxg20.c - "Portux G20", derivative from Stamp9G20.
* carrier-board-pcontrol_g20.c - "Pcontrol G20", PORTNER-Elektronik.

All stuff specific to carrier board will be encapsulated into functions:
* carrier_board_map_io()
* carrier_board_init()

I does not see any reasons to invent new machine for each new carrier
board. Better to have a configuration option for carrier boards.

There is only one choice for Stamp9G20 carrier board from:
* CONFIG_CARRIERBOARD_GMS
* CONFIG_CARRIERBOARD_PANELCARDEVB
* CONFIG_CARRIERBOARD_PCONTROL_G20
* CONFIG_CARRIERBOARD_PORTUXG20

> > +static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio,
> > +					unsigned ngpio, void *context)
> > +{
> > +	gpio_free(gpio + 4);
> 
> gpio_free(gpio + PCF_GPIO_ETH_DETECT)?

Corrected now. 

> > +#if	defined(CONFIG_PATA_AT91) || defined(CONFIG_PATA_AT91_MODULE)
> > +static struct at91_cf_data __initdata stamp9g20gms_cf1_data = {
> > +	.irq_pin	= AT91_PIN_PA27,
> > +	.det_pin	= AT91_PIN_PB30,
> > +	.rst_pin	= AT91_PIN_PB31,
> > +	.chipselect	= 5,
> > +	.flags		= AT91_CF_TRUE_IDE,
> > +};
> > +#endif /* CONFIG_PATA_AT91 */
> 
> I still think you can do away with some of these ifdef guards.
> Registering the device is not a problem, and you are only saving a
> handful of bytes by having this ifdef. I think the code is more
> readable/maintainable without all the ifdefs.

Corrected now.

> > +/* Power Off by RTC */
> > +static void stamp9g20gms_power_off(void)
> > +{
> > +	pr_notice("Power supply will be switched off automatically now or ");
> > +	pr_notice("after 60 seconds without ArmDAS.\n");
> 
> No. It should all be one call to pr_notice on one single line so that
> the full message can easily be grepped. Lines over 80 columns are
> allowed for printk functions and checkpatch will not warn about this.

Corrected now.

Best regards!
--
Igor Plyatov



