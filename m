Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab2EBDNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:13:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64051 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab2EBDNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:13:23 -0400
Date: Wed, 2 May 2012 11:13:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v2 1/3] ARM: imx: Add common imx cpuidle init
 functionality.
Message-ID: <20120502031311.GT2194@S2101-09.ap.freescale.net>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-2-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335924760-796-2-git-send-email-rob.lee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 09:12:38PM -0500, Robert Lee wrote:
> Add common cpuidle init functionality that can be used by various
> imx platforms.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/plat-mxc/Makefile               |    1 +
>  arch/arm/plat-mxc/cpuidle.c              |   80 ++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/cpuidle.h |   22 ++++++++
>  3 files changed, 103 insertions(+)
>  create mode 100644 arch/arm/plat-mxc/cpuidle.c
>  create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h
> 
> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> index e81290c..63b064b 100644
> --- a/arch/arm/plat-mxc/Makefile
> +++ b/arch/arm/plat-mxc/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_MXC_ULPI) += ulpi.o
>  obj-$(CONFIG_MXC_USE_EPIT) += epit.o
>  obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
> +obj-$(CONFIG_CPU_IDLE) += cpuidle.o
>  ifdef CONFIG_SND_IMX_SOC
>  obj-y += ssi-fiq.o
>  obj-y += ssi-fiq-ksym.o
> diff --git a/arch/arm/plat-mxc/cpuidle.c b/arch/arm/plat-mxc/cpuidle.c
> new file mode 100644
> index 0000000..b7a5e1c
> --- /dev/null
> +++ b/arch/arm/plat-mxc/cpuidle.c
> @@ -0,0 +1,80 @@
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

Does this function need to be exported?  I haven't seen it being
used anywhere outside this file.  Also, can it be __init?

> +
> +int __init imx_cpuidle_init(struct cpuidle_driver *drv)
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
> +	if (ret) {
> +		pr_err("%s: Failed to register cpuidle driver with error: %d\n",
> +			 __func__, ret);
> +		return ret;
> +	}
> +
> +	imx_cpuidle_devices = alloc_percpu(struct cpuidle_device);
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

Nit: print ret (error code) too?

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
> +	return ret;
> +}
> diff --git a/arch/arm/plat-mxc/include/mach/cpuidle.h b/arch/arm/plat-mxc/include/mach/cpuidle.h
> new file mode 100644
> index 0000000..8612510
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/cpuidle.h
> @@ -0,0 +1,22 @@
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
> +#ifdef CONFIG_CPU_IDLE
> +extern void imx_cpuidle_devices_uninit(void);
> +extern int imx_cpuidle_init(struct cpuidle_driver *drv);
> +#else
> +static inline void imx_cpuidle_devices_uninit(void) {}
> +static inline int imx_cpuidle_init(struct cpuidle_driver *drv)
> +{ return -ENODEV; }

Nit: if it can not be in the same line with function name, we usually
have it be:

{
	return -ENODEV;
}

> +#endif
> -- 
> 1.7.10
> 

-- 
Regards,
Shawn
