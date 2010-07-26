Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0GZG7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:59:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34776 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0GZG7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:59:04 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Alexander Shishkin <virtuoso@slind.org>,
        Hari Kanigeri <hari.kanigeri@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jul 2010 12:28:38 +0530
Subject: RE: [PATCH] omap3: make coresight register save across OFF modes a
 sysfs option
Thread-Topic: [PATCH] omap3: make coresight register save across OFF modes a
 sysfs option
Thread-Index: AcssPetw4X/OJgFrSJ6Cry7jXTx2qwAUavtQ
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C625569B@dbde02.ent.ti.com>
References: <AANLkTinmSJ6dtgqmyuk9CArniPEvEp7TrXauvGxLxv7x@mail.gmail.com>
 <1280091863-8891-1-git-send-email-virtuoso@slind.org>
In-Reply-To: <1280091863-8891-1-git-send-email-virtuoso@slind.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Alexander Shishkin
> Sent: Monday, July 26, 2010 2:34 AM
> To: Hari Kanigeri
> Cc: Alexander Shishkin; linux-arm-kernel@lists.infradead.org; Tony
> Lindgren; Russell King; Paul Walmsley; Kevin Hilman; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] omap3: make coresight register save across OFF modes a
> sysfs option
> 
> This adds a sysfs file at /sys/power/coresight_save which is used to
> control if the ETM and debug components' states should be saved and
> restored across OFF modes.
> 
> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-omap2/Makefile    |    1 +
>  arch/arm/mach-omap2/debug34xx.c |   66
> +++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/pm.h        |    6 +++
>  arch/arm/mach-omap2/pm34xx.c    |    3 ++
>  4 files changed, 76 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/debug34xx.c
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index f5b4ff4..3a64ce4 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -49,6 +49,7 @@ ifeq ($(CONFIG_PM),y)
>  obj-$(CONFIG_ARCH_OMAP2)		+= pm24xx.o
>  obj-$(CONFIG_ARCH_OMAP2)		+= sleep24xx.o
>  obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o cpuidle34xx.o
> +obj-$(CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG) += debug34xx.o
>  obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
> 
>  AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
> diff --git a/arch/arm/mach-omap2/debug34xx.c b/arch/arm/mach-
> omap2/debug34xx.c
> new file mode 100644
> index 0000000..698e83a
> --- /dev/null
> +++ b/arch/arm/mach-omap2/debug34xx.c

> @@ -0,0 +1,66 @@
> +/*
> + * Control saving and restoring of coresight components' state during
> + * OFF mode.
> + *
> + * Copyright (C) 2010 Nokia Corporation
> + * Alexander Shishkin
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sysfs.h>
> +#include <linux/kobject.h>
> +
> +#include "pm.h"
> +
> +/*
> + * Pointer to a place in sram where the ETM/debug state save
> + * flag is. It can be calculated after the omap_sram_idle is
> + * pushed to sram.
> + */
> +static unsigned int *_etm_save;
> +
> +/*
> + * sysfs file /sys/power/coresight_save controls whether the
> + * state of coresight components should be saved and restored
> + * across OFF modes.
> + */
> +static ssize_t coresight_save_show(struct kobject *kobj,
> +				  struct kobj_attribute *attr,
> +				  char *buf)
> +{
> +	return sprintf(buf, "%u\n", *_etm_save);
> +}
> +
> +static ssize_t coresight_save_store(struct kobject *kobj,
> +				   struct kobj_attribute *attr,
> +				   const char *buf, size_t n)
> +{
> +	unsigned int value;
> +
> +	if (sscanf(buf, "%u", &value) != 1)
> +		return -EINVAL;
> +
> +	*_etm_save = !!value;
> +
> +	return n;
> +}
> +
> +static struct kobj_attribute coresight_save_attr =
> +	__ATTR(coresight_save, 0644, coresight_save_show,
> coresight_save_store);
> +
> +int omap3_coresight_pm_init(void *sram_addr)
> +{
> +	int ret;
> +
> +	/* the last word from the top of omap_sram_idle */
> +	_etm_save = (unsigned *)((u8 *)sram_addr + omap34xx_cpu_suspend_sz -
> 4);
> +
> +	ret = sysfs_create_file(power_kobj, &coresight_save_attr.attr);
> +
> +	return ret;
> +}

Looking at content of this file, I think you can keep this under common 
pm-debug.c file. 
Any problems with that ?
> +
> diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
> index 3de6ece..0321834 100644
> --- a/arch/arm/mach-omap2/pm.h
> +++ b/arch/arm/mach-omap2/pm.h
> @@ -76,6 +76,12 @@ extern void omap34xx_cpu_suspend(u32 *addr, int
> save_state);
>  extern void save_secure_ram_context(u32 *addr);
>  extern void omap3_save_scratchpad_contents(void);
> 
> +#ifdef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
> +int omap3_coresight_pm_init(void *sram_addr);
> +#else
> +#define omap3_coresight_pm_init(x) do {} while (0)
> +#endif
> +
>  extern unsigned int omap24xx_idle_loop_suspend_sz;
>  extern unsigned int omap34xx_suspend_sz;
>  extern unsigned int save_secure_ram_context_sz;
> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> index fb4994a..c389e65 100644
> --- a/arch/arm/mach-omap2/pm34xx.c
> +++ b/arch/arm/mach-omap2/pm34xx.c
> @@ -1096,6 +1096,9 @@ static int __init omap3_pm_init(void)
>  	core_clkdm = clkdm_lookup("core_clkdm");
> 
>  	omap_push_sram_idle();
> +
> +	omap3_coresight_pm_init(_omap_sram_idle);
> +
>  #ifdef CONFIG_SUSPEND
>  	suspend_set_ops(&omap_pm_ops);
>  #endif /* CONFIG_SUSPEND */
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
