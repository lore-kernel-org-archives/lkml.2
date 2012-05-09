Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2EIO10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:27:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46540 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2EIO1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120509080214.GJ27341@pengutronix.de>
References: <1336425407-20308-1-git-send-email-rob.lee@linaro.org>
 <1336425407-20308-3-git-send-email-rob.lee@linaro.org> <20120509080214.GJ27341@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 9 May 2012 09:27:02 -0500
Message-ID: <CAMXH7KF7eznzF7AzM_JzwJ1jOm-1J4biqd=PvKMSa=ex8YFQrA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] ARM: imx: Add imx5 cpuidle driver
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

On Wed, May 9, 2012 at 3:02 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, May 07, 2012 at 04:16:46PM -0500, Robert Lee wrote:
>> Add imx5 cpuidle driver.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>>  arch/arm/mach-imx/mm-imx5.c |   42 +++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
>> index d6b7e9f..0b3a4cc 100644
>> --- a/arch/arm/mach-imx/mm-imx5.c
>> +++ b/arch/arm/mach-imx/mm-imx5.c
>> @@ -20,26 +20,61 @@
>>
>>  #include <mach/hardware.h>
>>  #include <mach/common.h>
>> +#include <mach/cpuidle.h>
>>  #include <mach/devices-common.h>
>>  #include <mach/iomux-v3.h>
>>
>>  static struct clk *gpc_dvfs_clk;
>>
>> -static void imx5_idle(void)
>> +static int imx5_idle(void)
>>  {
>> +     int ret = 0;
>> +
>>       /* gpc clock is needed for SRPG */
>>       if (gpc_dvfs_clk == NULL) {
>>               gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
>
> This clk_get should go away here and be moved somewhere to
> initialization. Also, if getting this clock fails we can still
> do regular cpu_do_idle. Additionally, if clk_get fails, we'll
> have a ERR_PTR value in gpc_dvfs_clk in which case the
> gpc_dvfs_clk == NULL won't trigger next time you are here and
> then you'll enable a nonexisting clock below.
>

Agree.  I'd prefer to enable this clock during intialization and just
leave it running.  It is supposed to be a very low power clock and I
couldn't measuring any power difference with and without it being
enabled

>>               if (IS_ERR(gpc_dvfs_clk))
>> -                     return;
>> +                     return -ENODEV;
>>       }
>>       clk_enable(gpc_dvfs_clk);
>>       mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
>>       if (!tzic_enable_wake())
>>               cpu_do_idle();
>> +     else
>> +             ret = -EBUSY;
>>       clk_disable(gpc_dvfs_clk);
>> +
>> +     return ret;
>> +}
>> +
>> +static int imx5_cpuidle_enter(struct cpuidle_device *dev,
>> +                             struct cpuidle_driver *drv, int idx)
>> +{
>> +     int ret;
>> +
>> +     ret = imx5_idle();
>> +
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     return idx;
>>  }
>>
>> +static struct cpuidle_driver imx5_cpuidle_driver = {
>> +     .name                   = "imx5_cpuidle",
>> +     .owner                  = THIS_MODULE,
>> +     .en_core_tk_irqen       = 1,
>> +     .states[0]      = {
>> +             .enter                  = imx5_cpuidle_enter,
>> +             .exit_latency           = 20, /* max latency at 160MHz */
>> +             .target_residency       = 1,
>> +             .flags                  = CPUIDLE_FLAG_TIME_VALID,
>> +             .name                   = "IMX5 SRPG",
>> +             .desc                   = "CPU state retained,powered off",
>> +     },
>
> I wonder why you don't add the default ARM_CPUIDLE_WFI_STATE_PWR state.
> The above is something different, right? It has a greater exit latency
> than ARM_CPUIDLE_WFI_STATE_PWR, so why don't we add it here aswell?

Yes and no.  Yes this is a different state but no, it doesn't have a
significantly greater exit latency, or at least a large enough exit
latency to warrant an extra state in my opinion.  According to the
i.MX5 documentation, the extra exit time beyond basic WFI required for
the  "WAIT_UNCLOCKED_POWER_OFF" state is 500ns (this is due to a
difference in i.MX5 hardware implementation compared to all other ARM
platforms).  In reality, it did require a few more microseconds to
perform in my testing just based on the extra register writes in
mx5_cpu_lp_set().  I'd like to clean up mx5_cpu_lp_set() and add a
global variable to track the previous state and to just exit out if
the new state is the same as the old.  I could do this cleanup as part
of this patchset if you prefer that.

>
>> +     .state_count            = 1,
>> +};
>> +
>>  /*
>>   * Define the MX50 memory map.
>>   */
>> @@ -103,7 +138,7 @@ void __init imx51_init_early(void)
>>       mxc_set_cpu_type(MXC_CPU_MX51);
>>       mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
>>       mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG1_BASE_ADDR));
>> -     arm_pm_idle = imx5_idle;
>> +     arm_pm_idle = (void (*)(void))imx5_idle;
>
> Still this looks suspicious. Reading this will lead to the question why
> this prototype is casted. Please just add a imx5_pm_idle with the
> correct prototype.

Ok.

Thanks,
Rob

>
>>  }
>>
>>  void __init imx53_init_early(void)
>> @@ -238,4 +273,5 @@ void __init imx53_soc_init(void)
>>  void __init imx51_init_late(void)
>>  {
>>       mx51_neon_fixup();
>> +     imx_cpuidle_init(&imx5_cpuidle_driver);
>>  }
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
