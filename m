Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0JGS7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:59:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45063 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0JGS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:59:45 -0400
Date: Thu, 7 Oct 2010 20:59:43 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        bryan.wu@canonical.com, amit.kucheria@canonical.com,
        xiao-lizhang@freescale.com
Subject: Re: [PATCHv5] ARM: imx: Add iram allocator functions
Message-ID: <20101007185943.GY29673@pengutronix.de>
References: <1286467250-22644-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286467250-22644-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 07, 2010 at 11:00:50AM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add IRAM(Internal RAM) allocation functions using GENERIC_ALLOCATOR.
> The allocation size is 4KB multiples to guarantee alignment. The
> idea for these functions is for i.MX platforms to use them
> to dynamically allocate IRAM usage.
> 
> Applies on 2.6.36-rc7
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Reviewed-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/Kconfig             |    4 ++
>  arch/arm/plat-mxc/Makefile            |    1 +
>  arch/arm/plat-mxc/include/mach/iram.h |   41 ++++++++++++++++++
>  arch/arm/plat-mxc/iram_alloc.c        |   74 +++++++++++++++++++++++++++++++++
>  4 files changed, 120 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/iram.h
>  create mode 100644 arch/arm/plat-mxc/iram_alloc.c
> 
> diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> index 6785db4..0e99bb4 100644
> --- a/arch/arm/plat-mxc/Kconfig
> +++ b/arch/arm/plat-mxc/Kconfig
> @@ -110,4 +110,8 @@ config ARCH_MXC_AUDMUX_V1
>  config ARCH_MXC_AUDMUX_V2
>  	bool
>  
> +config IRAM_ALLOC
> +	bool
> +	select GENERIC_ALLOCATOR
> +
>  endif
> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> index 78d405e..1ddfb13 100644
> --- a/arch/arm/plat-mxc/Makefile
> +++ b/arch/arm/plat-mxc/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_MXC_TZIC) += tzic.o
>  
>  obj-$(CONFIG_IMX_HAVE_IOMUX_V1) += iomux-v1.o
>  obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
> +obj-$(CONFIG_IRAM_ALLOC) += iram_alloc.o
>  obj-$(CONFIG_MXC_PWM)  += pwm.o
>  obj-$(CONFIG_USB_EHCI_MXC) += ehci.o
>  obj-$(CONFIG_MXC_ULPI) += ulpi.o
> diff --git a/arch/arm/plat-mxc/include/mach/iram.h b/arch/arm/plat-mxc/include/mach/iram.h
> new file mode 100644
> index 0000000..f7edd45
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/iram.h
> @@ -0,0 +1,41 @@
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
> +#include <linux/errno.h>
> +
> +#ifdef CONFIG_IRAM_ALLOC
> +
> +int __init iram_init(unsigned long base, unsigned long size);
> +void *iram_alloc(unsigned int size, unsigned long *dma_addr);
here an __iomem is missing

> +void iram_free(unsigned long dma_addr, unsigned int size);
> +
> +#else
> +
> +static inline int __init iram_init(unsigned long base, unsigned long size)
> +{
> +	return -ENOMEM;
> +}
> +
> +static inline void *iram_alloc(unsigned int size, unsigned long *dma_addr)
> +{
> +	return NULL;
> +}
> +
> +static inline void iram_free(unsigned long base, unsigned long size) {}
> +
> +#endif
> diff --git a/arch/arm/plat-mxc/iram_alloc.c b/arch/arm/plat-mxc/iram_alloc.c
> new file mode 100644
> index 0000000..8f75a32
> --- /dev/null
> +++ b/arch/arm/plat-mxc/iram_alloc.c
> @@ -0,0 +1,74 @@
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
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/genalloc.h>
> +#include <mach/iram.h>
> +
> +static unsigned long iram_phys_base;
> +static void __iomem *iram_virt_base;
> +static struct gen_pool *iram_pool;
> +
> +static inline void __iomem *iram_phys_to_virt(unsigned long p)
> +{
> +	p = iram_virt_base + (p - iram_phys_base);
> +	return p;
if you combine the above two lines to

	return iram_virt_base + (p - iram_phys_base);

you make sparse happy.  Currently it wails:

	arch/arm/plat-mxc/iram_alloc.c: In function 'iram_phys_to_virt':
	arch/arm/plat-mxc/iram_alloc.c:33: warning: assignment makes integer from pointer without a cast
	arch/arm/plat-mxc/iram_alloc.c:34: warning: return makes pointer from integer without a cast

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
