Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2G1BnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:43:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2G1Bm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:42:58 -0400
Date: Fri, 27 Jul 2012 18:42:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH 3/3] input: misc: New USB eBeam input driver.
Message-ID: <20120728014252.GB19817@core.coreip.homeip.net>
References: <1343433754-3887-1-git-send-email-yann.cantin@laposte.net>
 <1343433754-3887-4-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343433754-3887-4-git-send-email-yann.cantin@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,

On Sat, Jul 28, 2012 at 02:02:34AM +0200, Yann Cantin wrote:
> 
> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> ---
>  drivers/input/misc/Kconfig  |   21 +
>  drivers/input/misc/Makefile |    1 +
>  drivers/input/misc/ebeam.c  |  895 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 917 insertions(+)
>  create mode 100644 drivers/input/misc/ebeam.c
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 7faf4a7..0e798cb 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -73,6 +73,27 @@ config INPUT_BMA150
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bma150.
>  
> +config INPUT_EBEAM_USB
> +	tristate "USB eBeam driver"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB
> +	help
> +	  Say Y here if you have a USB eBeam pointing device and want to
> +	  use it without any proprietary user space tools.
> +
> +	  Have a look at <http://sourceforge.net/projects/ebeam/> for
> +	  a usage description and the required user-space tools.
> +
> +	  Currently, only the Classic Projection model is supported.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ebeam.
> +
> +config INPUT_EBEAM_USB_CLASSIC
> +	bool "eBeam Classic Projection support"
> +	depends on INPUT_EBEAM_USB
> +	default y

Will there be support for other eBean devices (are there any)? If there
will how soon? How different are they? If not the we probably do not
need this INPUT_EBEAM_USB_CLASSIC selector.

> +
>  config INPUT_PCSPKR
>  	tristate "PC Speaker support"
>  	depends on PCSPKR_PLATFORM
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index f55cdf4..4b5e4a9 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
>  obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
>  obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
>  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
> +obj-$(CONFIG_INPUT_EBEAM_USB)		+= ebeam.o
>  obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
>  obj-$(CONFIG_INPUT_GPIO_TILT_POLLED)	+= gpio_tilt_polled.o
>  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
> diff --git a/drivers/input/misc/ebeam.c b/drivers/input/misc/ebeam.c
> new file mode 100644
> index 0000000..a18615a
> --- /dev/null
> +++ b/drivers/input/misc/ebeam.c
> @@ -0,0 +1,895 @@
> +/******************************************************************************
> + *
> + * eBeam driver
> + *
> + * Copyright (C) 2012 Yann Cantin (yann.cantin@laposte.net)
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License as
> + *	published by the Free Software Foundation; either version 2 of the
> + *	License, or (at your option) any later version.
> + *
> + *  based on
> + *
> + *	usbtouchscreen.c by Daniel Ritz <daniel.ritz@gmx.ch>
> + *	aiptek.c (sysfs/settings) by Chris Atenasio <chris@crud.net>
> + *				     Bryan W. Headley <bwheadley@earthlink.net>
> + *
> + *****************************************************************************/
> +
> +#define DEBUG

I do not think leaving DEBUG on is good idea for production code.

> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/input.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/usb.h>
> +#include <linux/usb/input.h>
> +#include <linux/hid.h>
> +
> +#define DRIVER_VERSION		"v0.5"
> +#define DRIVER_AUTHOR		"Yann Cantin <yann.cantin@laposte.net>"
> +#define DRIVER_DESC		"USB eBeam Driver"
> +
> +#define USB_VENDOR_ID_EFI	   0x2650   /* Electronics For Imaging, Inc   */
> +#define USB_DEVICE_ID_EFI_CLASSIC  0x1311   /* Classic projection "La banane" */
> +
> +#define EBEAM_BTN_TIP		0x1      /* tip    */
> +#define EBEAM_BTN_LIT		0x2      /* little */
> +#define EBEAM_BTN_BIG		0x4      /* big    */
> +
> +/* until KConfig */
> +#define CONFIG_INPUT_EBEAM_USB_CLASSIC

Huh?

> +
> +/* device specifc data/functions */
> +struct ebeam_device;
> +struct ebeam_device_info {
> +	int min_X;
> +	int max_X;
> +	int min_Y;
> +	int max_Y;
> +
> +	/*
> +	 * TODO : Check if it's really necessary, waiting for other device info.
> +	 * Always service the USB devices irq not just when the input device is
> +	 * open. This is useful when devices have a watchdog which prevents us
> +	 * from periodically polling the device. Leave this unset unless your
> +	 * ebeam device requires it, as it does consume more of the USB
> +	 * bandwidth.
> +	 */
> +	bool irq_always;

Does you device need this?

> +
> +	int rept_size;
> +
> +	/* optional, generic exist */
> +	void (*process_pkt)  (struct ebeam_device *ebeam,
> +			      unsigned char *pkt,
> +			      int len);
> +
> +	/* mandatory, model-specific */
> +	int  (*read_data)    (struct ebeam_device *ebeam,
> +			      unsigned char *pkt);
> +	void (*setup_input)  (struct ebeam_device *ebeam,
> +			      struct input_dev *input_dev);
> +	void (*report_input) (struct ebeam_device *ebeam);
> +
> +	/* optional, model-specific */
> +	int  (*alloc)	(struct ebeam_device *ebeam);
> +	int  (*init)	(struct ebeam_device *ebeam);
> +	void (*exit)	(struct ebeam_device *ebeam);

Again, do you expect to see multitude of sufficiently different
devices or are they going to follow roughly the same protocol?

Thanks.

-- 
Dmitry
