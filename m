Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2EBTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:16:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58466 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2EBTQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120502072701.GR4141@pengutronix.de>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-2-git-send-email-rob.lee@linaro.org> <20120502072701.GR4141@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 2 May 2012 14:16:36 -0500
Message-ID: <CAMXH7KGLHD8uimSnf8=0t15F7KcFiPuL=3bebY309MbaA75USA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ARM: imx: Add common imx cpuidle init functionality.
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha,

On Wed, May 2, 2012 at 2:27 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, May 01, 2012 at 09:12:38PM -0500, Robert Lee wrote:
>> Add common cpuidle init functionality that can be used by various
>> imx platforms.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>> +
>> +int __init imx_cpuidle_init(struct cpuidle_driver *drv)
>> +{
>> +     struct cpuidle_device *dev;
>> +     int cpu_id, ret;
>> +
>> +     if (!drv || drv->state_count > CPUIDLE_STATE_MAX) {
>
> Please don't check for !drv here. When someone calls this function with
> a NULL pointer he should get a nive stack trace allowing him to figure
> out what went wrong.
>

Ok, I will change this in v3.  Given your statement, my understanding
is that I should avoid adding checks to make sure a valid driver
object was given as the stack trace information is all the handling
that is needed.  If there is any further logic needed in that rule,
could you elaborate so that I don't make this mistake in the future,
or so that I don't add a check on a driver object in a case that I
should?

>> +             pr_err("%s: Invalid Input\n", __func__);
>> +             return -EINVAL;
>> +     }
>> +
>> +     ret = cpuidle_register_driver(drv);
>> +     if (ret) {
>> +             pr_err("%s: Failed to register cpuidle driver with error: %d\n",
>> +                      __func__, ret);
>> +             return ret;
>> +     }
>> +
>> +     imx_cpuidle_devices = alloc_percpu(struct cpuidle_device);
>> +     if (imx_cpuidle_devices == NULL) {
>> +             ret = -ENOMEM;
>> +             goto unregister_drv;
>> +     }
>> +
>> +     /* initialize state data for each cpuidle_device */
>> +     for_each_possible_cpu(cpu_id) {
>> +             dev = per_cpu_ptr(imx_cpuidle_devices, cpu_id);
>> +             dev->cpu = cpu_id;
>> +             dev->state_count = drv->state_count;
>> +
>> +             ret = cpuidle_register_device(dev);
>> +             if (ret) {
>> +                     pr_err("%s: Failed to register cpu %u\n",
>> +                             __func__, cpu_id);
>> +                     goto uninit;
>
> You should only unregister the cpuidle devices you successfully
> registered. Unregistering not yet registered cpuidle devices probably
> has unwanted side effects.
>

I did not add in this handling because the cpuidle_unregister_device()
call already has a "registered" check so extra handling seemed
unnecessary.  But if you still think it is needed just let me know.

cpuidle_unregister_device()
{
...
	if (dev->registered == 0)
		return;
...

Thanks,
Rob

> Sascha
>
>> +             }
>> +     }
>> +
>> +     return 0;
>> +
>> +uninit:
>> +     imx_cpuidle_devices_uninit();
>> +
>> +unregister_drv:
>> +     cpuidle_unregister_driver(drv);
>> +     return ret;
>> +}
>> diff --git a/arch/arm/plat-mxc/include/mach/cpuidle.h b/arch/arm/plat-mxc/include/mach/cpuidle.h
>> new file mode 100644
>> index 0000000..8612510
>> --- /dev/null
>> +++ b/arch/arm/plat-mxc/include/mach/cpuidle.h
>> @@ -0,0 +1,22 @@
>> +/*
>> + * Copyright 2012 Freescale Semiconductor, Inc.
>> + * Copyright 2012 Linaro Ltd.
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +#include <linux/cpuidle.h>
>> +
>> +#ifdef CONFIG_CPU_IDLE
>> +extern void imx_cpuidle_devices_uninit(void);
>> +extern int imx_cpuidle_init(struct cpuidle_driver *drv);
>> +#else
>> +static inline void imx_cpuidle_devices_uninit(void) {}
>> +static inline int imx_cpuidle_init(struct cpuidle_driver *drv)
>> +{ return -ENODEV; }
>> +#endif
>> --
>> 1.7.10
>>
>>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
