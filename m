Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2DPX4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:56:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24092 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2DPX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:56:29 -0400
Date: Tue, 17 Apr 2012 01:56:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Robert Lee <rob.lee@linaro.org>
cc: kernel@pengutronix.de, shawn.guo@linaro.org, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init
 functionality.
In-Reply-To: <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
Message-ID: <alpine.LNX.2.00.1204170152380.23403@swampdragon.chaosbits.net>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org> <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Robert Lee wrote:

> Add common cpuidle init functionality that can be used by various
> imx platforms.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/plat-mxc/Makefile               |    2 +
>  arch/arm/plat-mxc/cpuidle.c              |   89 ++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/cpuidle.h |   26 +++++++++
>  3 files changed, 117 insertions(+)
>  create mode 100644 arch/arm/plat-mxc/cpuidle.c
>  create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h
> 

A few pedantic/ignorable comments below.


> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> index e81290c..7c9e05f 100644
> --- a/arch/arm/plat-mxc/Makefile
> +++ b/arch/arm/plat-mxc/Makefile
> @@ -16,6 +16,8 @@ obj-$(CONFIG_MXC_ULPI) += ulpi.o
>  obj-$(CONFIG_MXC_USE_EPIT) += epit.o
>  obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
> +obj-$(CONFIG_CPU_IDLE)    += cpuidle.o
> +
>  ifdef CONFIG_SND_IMX_SOC
>  obj-y += ssi-fiq.o
>  obj-y += ssi-fiq-ksym.o
> diff --git a/arch/arm/plat-mxc/cpuidle.c b/arch/arm/plat-mxc/cpuidle.c
> new file mode 100644
> index 0000000..d1c9301
> --- /dev/null
> +++ b/arch/arm/plat-mxc/cpuidle.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright 2012 Freescale Semiconductor, Inc.
> + * Copyright 2012 Linaro Ltd.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/cpuidle.h>
> +#include <linux/hrtimer.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +
> +static struct cpuidle_device __percpu * imx_cpuidle_devices;
> +static struct cpuidle_driver *drv;
> +
> +void __init imx_cpuidle_set_driver(struct cpuidle_driver *p)
> +{
> +	drv = p;
> +}
> +
> +void imx_cpuidle_devices_uninit(void)
> +{
> +	int cpu_id;
> +	struct cpuidle_device *dev;
> +
> +	for_each_possible_cpu(cpu_id) {
> +		dev = per_cpu_ptr(imx_cpuidle_devices, cpu_id);
> +		cpuidle_unregister_device(dev);
> +	}
> +
> +	free_percpu(imx_cpuidle_devices);
> +}
> +
> +static int __init imx_cpuidle_init(void)
> +{
> +	struct cpuidle_device *dev;
> +	int cpu_id, ret;
> +
> +	if (!drv || drv->state_count > CPUIDLE_STATE_MAX) {
> +		pr_err("%s: Invalid Input\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	ret = cpuidle_register_driver(drv);
> +

Pointless blank line. I'd suggest removing it.

> +	if (ret) {
> +		pr_err("%s: Failed to register cpuidle driver\n", __func__);
> +		return ret;
> +	}
> +
> +	imx_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> +

Same here. Pointless blank line.

> +	if (imx_cpuidle_devices == NULL) {
> +		ret = -ENOMEM;
> +		goto unregister_drv;
> +	}
> +
> +	/* initialize state data for each cpuidle_device */
> +	for_each_possible_cpu(cpu_id) {
> +		dev = per_cpu_ptr(imx_cpuidle_devices, cpu_id);
> +		dev->cpu = cpu_id;
> +		dev->state_count = drv->state_count;
> +
> +		ret = cpuidle_register_device(dev);
> +		if (ret) {
> +			pr_err("%s: Failed to register cpu %u\n",
> +				__func__, cpu_id);
> +			goto uninit;
> +		}
> +	}
> +
> +	return 0;
> +
> +uninit:
> +	imx_cpuidle_devices_uninit();
> +
> +unregister_drv:
> +	cpuidle_unregister_driver(drv);
> +

Blank line here seems pointless.

> +	return ret;
> +}
> +late_initcall(imx_cpuidle_init);
> diff --git a/arch/arm/plat-mxc/include/mach/cpuidle.h b/arch/arm/plat-mxc/include/mach/cpuidle.h
> new file mode 100644
> index 0000000..6509f19
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/cpuidle.h
> @@ -0,0 +1,26 @@
> +/*
> + * Copyright 2012 Freescale Semiconductor, Inc.
> + * Copyright 2012 Linaro Ltd.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/cpuidle.h>
> +
> +extern int imx5_cpuidle_init(void);
> +extern int imx6q_cpuidle_init(void);
> +
> +#ifdef CONFIG_CPU_IDLE
> +extern void imx_cpuidle_devices_uninit(void);
> +extern void imx_cpuidle_set_driver(struct cpuidle_driver *p);
> +extern int imx5_cpuidle_init(void);
> +extern int imx6q_cpuidle_init(void);
> +#else
> +static inline void imx_cpuidle_devices_uninit(void) {}
> +static inline void imx_cpuidle_set_driver(struct cpuidle_driver *p) {}
> +#endif
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

