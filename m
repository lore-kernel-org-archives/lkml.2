Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2DDLVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:21:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50408 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab2DDLVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
	<1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
Date: Wed, 4 Apr 2012 07:21:32 -0400
Message-ID: <CAMiH66EC7=x0sRYhE3hpEyBemDGSRS19xguQUqKj2kuPw5Tifw@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
From: Huang Shijie <shijie8@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Wolfram:

Could you provide an API such as gpmi_reset_block()?
It will much helpful to me.

BR
Huang Shijie

On Wed, Mar 21, 2012 at 6:21 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> MX23/28 use IP cores which follow a register layout I have first seen on
> STMP3xxx SoCs. In this layout, every register actually has four u32:
>
>  1.) to store a value directly
>  2.) a SET register where every 1-bit sets the corresponding bit,
>     others are unaffected
>  3.) same with a CLR register
>  4.) same with a TOG (toggle) register
>
> Also, the 2 MSBs in register 0 are always the same and can be used to reset
> the IP core.
>
> All this is strictly speaking not mach-specific (but IP core specific) and,
> thus, doesn't need to be in mach-mxs/include. At least, mx6 and mx50 also
> utilize IP cores following this stmp-style. So:
>
> Introduce a stmp-style device, put the code and defines for that in a public
> place (lib/), and let drivers for stmp-style devices select that code.
> To avoid regressions and ease reviewing, the actual code is simply copied from
> mach-mxs. It definately wants updates, but those need a seperate patch series.
>
> Voila, mach dependency gone, reusable code introduced. Note that I didn't
> remove the duplicated code from mach-mxs yet, first the drivers have to be
> converted.
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  include/linux/stmp_device.h |   20 +++++++++++
>  lib/Kconfig                 |    3 ++
>  lib/Makefile                |    2 +
>  lib/stmp_device.c           |   80 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 105 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/stmp_device.h
>  create mode 100644 lib/stmp_device.c
>
> diff --git a/include/linux/stmp_device.h b/include/linux/stmp_device.h
> new file mode 100644
> index 0000000..6cf7ec9
> --- /dev/null
> +++ b/include/linux/stmp_device.h
> @@ -0,0 +1,20 @@
> +/*
> + * basic functions for devices following the "stmp" style register layout
> + *
> + * Copyright (C) 2011 Wolfram Sang, Pengutronix e.K.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __STMP_DEVICE_H__
> +#define __STMP_DEVICE_H__
> +
> +#define STMP_OFFSET_REG_SET    0x4
> +#define STMP_OFFSET_REG_CLR    0x8
> +#define STMP_OFFSET_REG_TOG    0xc
> +
> +extern int stmp_reset_block(void __iomem *);
> +#endif /* __STMP_DEVICE_H__ */
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 028aba9..d4af46f 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -29,6 +29,9 @@ config GENERIC_IOMAP
>        bool
>        select GENERIC_PCI_IOMAP
>
> +config STMP_DEVICE
> +       bool
> +
>  config CRC_CCITT
>        tristate "CRC-CCITT functions"
>        help
> diff --git a/lib/Makefile b/lib/Makefile
> index 18515f0..f78dbcd 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -123,6 +123,8 @@ obj-$(CONFIG_SIGNATURE) += digsig.o
>
>  obj-$(CONFIG_CLZ_TAB) += clz_tab.o
>
> +obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
> +
>  hostprogs-y    := gen_crc32table
>  clean-files    := crc32table.h
>
> diff --git a/lib/stmp_device.c b/lib/stmp_device.c
> new file mode 100644
> index 0000000..8ac9bcc
> --- /dev/null
> +++ b/lib/stmp_device.c
> @@ -0,0 +1,80 @@
> +/*
> + * Copyright (C) 1999 ARM Limited
> + * Copyright (C) 2000 Deep Blue Solutions Ltd
> + * Copyright 2006-2007,2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
> + * Copyright 2009 Ilya Yanok, Emcraft Systems Ltd, yanok@emcraft.com
> + * Copyright (C) 2011 Wolfram Sang, Pengutronix e.K.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/errno.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/stmp_device.h>
> +
> +#define STMP_MODULE_CLKGATE    (1 << 30)
> +#define STMP_MODULE_SFTRST     (1 << 31)
> +
> +/*
> + * Clear the bit and poll it cleared.  This is usually called with
> + * a reset address and mask being either SFTRST(bit 31) or CLKGATE
> + * (bit 30).
> + */
> +static int stmp_clear_poll_bit(void __iomem *addr, u32 mask)
> +{
> +       int timeout = 0x400;
> +
> +       writel(mask, addr + STMP_OFFSET_REG_CLR);
> +       udelay(1);
> +       while ((readl(addr) & mask) && --timeout)
> +               /* nothing */;
> +
> +       return !timeout;
> +}
> +
> +int stmp_reset_block(void __iomem *reset_addr)
> +{
> +       int ret;
> +       int timeout = 0x400;
> +
> +       /* clear and poll SFTRST */
> +       ret = stmp_clear_poll_bit(reset_addr, STMP_MODULE_SFTRST);
> +       if (unlikely(ret))
> +               goto error;
> +
> +       /* clear CLKGATE */
> +       writel(STMP_MODULE_CLKGATE, reset_addr + STMP_OFFSET_REG_CLR);
> +
> +       /* set SFTRST to reset the block */
> +       writel(STMP_MODULE_SFTRST, reset_addr + STMP_OFFSET_REG_SET);
> +       udelay(1);
> +
> +       /* poll CLKGATE becoming set */
> +       while ((!(readl(reset_addr) & STMP_MODULE_CLKGATE)) && --timeout)
> +               /* nothing */;
> +       if (unlikely(!timeout))
> +               goto error;
> +
> +       /* clear and poll SFTRST */
> +       ret = stmp_clear_poll_bit(reset_addr, STMP_MODULE_SFTRST);
> +       if (unlikely(ret))
> +               goto error;
> +
> +       /* clear and poll CLKGATE */
> +       ret = stmp_clear_poll_bit(reset_addr, STMP_MODULE_CLKGATE);
> +       if (unlikely(ret))
> +               goto error;
> +
> +       return 0;
> +
> +error:
> +       pr_err("%s(%p): module reset timeout\n", __func__, reset_addr);
> +       return -ETIMEDOUT;
> +}
> +EXPORT_SYMBOL(stmp_reset_block);
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
