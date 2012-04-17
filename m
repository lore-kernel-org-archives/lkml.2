Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2DQHnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:43:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35946 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2DQHnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:43:05 -0400
Date: Tue, 17 Apr 2012 09:43:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120417074301.GM20478@pengutronix.de>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
 <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:32:28 up 156 days, 15:19, 43 users,  load average: 0.06, 0.10,
 0.33
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 06:50:12PM -0500, Robert Lee wrote:
> Add common cpuidle init functionality that can be used by various
> imx platforms.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
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

You like it complicated, eh? Why do you introduce a function which sets
a variable...

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

... instead of passing it directly to the function which uses it?

> +{
> +	struct cpuidle_device *dev;
> +	int cpu_id, ret;
> +
> +	if (!drv || drv->state_count > CPUIDLE_STATE_MAX) {
> +		pr_err("%s: Invalid Input\n", __func__);

You introduce a pointless error message on SoCs not setting a cpuidle
driver. When will people learn that initcalls do not only run on
machines they have on their desk?

> +		return -EINVAL;
> +	}
> +
> +	ret = cpuidle_register_driver(drv);
> +
> +	if (ret) {
> +		pr_err("%s: Failed to register cpuidle driver\n", __func__);

It's always nice to add the return value to the error message to get a
clue *what* went wrong. The function name though is rather
uninteresting.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
