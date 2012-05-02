Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab2EBUL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:11:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab2EBUL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120502073331.GS4141@pengutronix.de>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-3-git-send-email-rob.lee@linaro.org> <20120502073331.GS4141@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 2 May 2012 15:11:35 -0500
Message-ID: <CAMXH7KE1jao1p5ZQ1aw8p7qzOQUftck22QTMKJ1oGwiPhY=FMA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: imx: Add imx5 cpuidle driver
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

On Wed, May 2, 2012 at 2:33 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, May 01, 2012 at 09:12:39PM -0500, Robert Lee wrote:
>> Add imx5 cpuidle driver.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>>  arch/arm/mach-imx/mm-imx5.c |   42 +++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
>> index d6b7e9f..cbd9bad 100644
>> --- a/arch/arm/mach-imx/mm-imx5.c
>> +++ b/arch/arm/mach-imx/mm-imx5.c
>> @@ -22,24 +22,59 @@
>>  #include <mach/common.h>
>>  #include <mach/devices-common.h>
>>  #include <mach/iomux-v3.h>
>> +#include <mach/cpuidle.h>
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
>> +     arm_pm_idle = (void *)imx5_idle;
>
> I don't like this. It will cover all warnings when the prototype of
> arm_pm_idle changes in future. Better add a static void imx5_idle
> which calls a static int imx5_do_idle, then you have an idle function
> which returns an int.
>

What about using the following:

arm_pm_idle =  (void (*)(void))imx5_idle;

This will give warnings if arm_pm_idle prototype changes.

Thanks,
Rob

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
