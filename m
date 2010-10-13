Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0JMI5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:57:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0JMI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:57:50 -0400
Date: Wed, 13 Oct 2010 10:57:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, valentin.longchamp@epfl.ch, daniel@caiaq.de,
        xiao-lizhang@freescale.com, r.schwebel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7] ARM: imx: Add iram allocator functions
Message-ID: <20101013085748.GB21498@pengutronix.de>
References: <1286900941-18123-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286900941-18123-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dinh,

On Tue, Oct 12, 2010 at 11:29:01AM -0500, Dinh.Nguyen@freescale.com wrote:
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
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

> ---
>  arch/arm/plat-mxc/Kconfig             |    4 ++
>  arch/arm/plat-mxc/Makefile            |    1 +
>  arch/arm/plat-mxc/include/mach/iram.h |   41 ++++++++++++++++++
>  arch/arm/plat-mxc/iram_alloc.c        |   73 +++++++++++++++++++++++++++++++++
>  4 files changed, 119 insertions(+), 0 deletions(-)
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
> index 0000000..022690c
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
> +void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
> +void iram_free(unsigned long dma_addr, unsigned int size);
> +
> +#else
> +
> +static inline int __init iram_init(unsigned long base, unsigned long size)
> +{
> +	return -ENOMEM;
> +}
> +
> +static inline void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
> +{
> +	return NULL;
> +}
> +
> +static inline void iram_free(unsigned long base, unsigned long size) {}
> +
> +#endif
> diff --git a/arch/arm/plat-mxc/iram_alloc.c b/arch/arm/plat-mxc/iram_alloc.c
> new file mode 100644
> index 0000000..074c386
> --- /dev/null
> +++ b/arch/arm/plat-mxc/iram_alloc.c
> @@ -0,0 +1,73 @@
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
> +	return iram_virt_base + (p - iram_phys_base);
> +}
> +
> +void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
> +{
> +	if (!iram_pool)
> +		return NULL;
> +
> +	*dma_addr = gen_pool_alloc(iram_pool, size);
> +	pr_debug("iram alloc - %dB@0x%lX\n", size, *dma_addr);
> +	if (!*dma_addr)
> +		return NULL;
> +	return iram_phys_to_virt(*dma_addr);
> +}
> +EXPORT_SYMBOL(iram_alloc);
> +
> +void iram_free(unsigned long addr, unsigned int size)
> +{
> +	if (!iram_pool)
> +		return;
> +
> +	gen_pool_free(iram_pool, addr, size);
> +}
> +EXPORT_SYMBOL(iram_free);
> +
> +int __init iram_init(unsigned long base, unsigned long size)
> +{
> +	iram_phys_base = base;
> +
> +	iram_pool = gen_pool_create(PAGE_SHIFT, -1);
> +	if (!iram_pool)
> +		return -ENOMEM;
> +
> +	gen_pool_add(iram_pool, base, size, -1);
> +	iram_virt_base = ioremap(iram_phys_base, size);
> +	if (!iram_virt_base)
> +		return -EIO;
> +
> +	pr_debug("i.MX IRAM pool: %ld KB@0x%p\n", size / 1024, iram_virt_base);
> +	return 0;
> +}
> -- 
> 1.6.0.4
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
