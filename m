Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031210Ab2CUO20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:28:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63641 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030924Ab2CUO2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <1332274969-15782-5-git-send-email-rob.lee@linaro.org>
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
	<1332274969-15782-5-git-send-email-rob.lee@linaro.org>
Date: Wed, 21 Mar 2012 09:28:18 -0500
Message-ID: <CAMXH7KH5kS=wPFdC8QrtnhE6_sZqmsJ8h=6Gs3kfHOTbeHjacA@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] ARM: davinci: Consolidate time keeping and irq enable
From: Rob Lee <rob.lee@linaro.org>
To: len.brown@intel.com, "Nori, Sekhar" <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>
Cc: akpm@linux-foundation.org, rjw@sisk.pl, robherring2@gmail.com,
        Baohua.Song@csr.com, amit.kucheria@linaro.org, nicolas.ferre@atmel.com,
        linux@maxim.org.za, kgene.kim@samsung.com, amit.kachhap@linaro.org,
        magnus.damm@gmail.com, daniel.lezcano@linaro.org,
        mturquette@linaro.org, vincent.guittot@linaro.org,
        arnd.bergmann@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, deepthi@linux.vnet.ibm.com,
        broonie@opensource.wolfsonmicro.com, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, jean.pihet@newoldbits.com, venki@google.com,
        ccross@google.com, g.trinabh@gmail.com, kernel@wantstofly.org,
        lethal@linux-sh.org, jon-hunter@ti.com, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar tested this patch on Davinci last night and found a problem.  I
looked at the code again and found a mindless omission on my part (see
below).  Fix is trivial.  I've check all other platforms and confirmed
this problem does not exist for those.  Will resend a v9 of the
patchset shortly.

On Tue, Mar 20, 2012 at 3:22 PM, Robert Lee <rob.lee@linaro.org> wrote:
> Enable core cpuidle timekeeping and irq enabling and remove that
> handling from this code.
>
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Jean Pihet<j-pihet@ti.com>
> ---
>  arch/arm/mach-davinci/cpuidle.c |   82 ++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 49 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
> index a30c7c5..93ae096 100644
> --- a/arch/arm/mach-davinci/cpuidle.c
> +++ b/arch/arm/mach-davinci/cpuidle.c
> @@ -18,6 +18,7 @@
>  #include <linux/io.h>
>  #include <linux/export.h>
>  #include <asm/proc-fns.h>
> +#include <asm/cpuidle.h>
>
>  #include <mach/cpuidle.h>
>  #include <mach/ddr2.h>
> @@ -30,12 +31,42 @@ struct davinci_ops {
>        u32 flags;
>  };
>
> +/* Actual code that puts the SoC in different idle states */
> +static int davinci_enter_idle(struct cpuidle_device *dev,
> +                               struct cpuidle_driver *drv,
> +                                               int index)
> +{
> +       struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
> +       struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
> +
> +       if (ops && ops->enter)
> +               ops->enter(ops->flags);
> +
> +       index = cpuidle_wrap_enter(dev, drv, index,
> +                               arm_cpuidle_simple_enter);
> +
> +       if (ops && ops->exit)
> +               ops->exit(ops->flags);
> +
> +       return index;
> +}
> +
>  /* fields in davinci_ops.flags */
>  #define DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN        BIT(0)
>
>  static struct cpuidle_driver davinci_idle_driver = {
> -       .name   = "cpuidle-davinci",
> -       .owner  = THIS_MODULE,
> +       .name           = "cpuidle-davinci",
> +       .owner          = THIS_MODULE,

Argh! I am missing the ".en_core_tk_irqen = 1" here.


> +       .states[0]      = ARM_CPUIDLE_WFI_STATE,
> +       .states[1]      = {
> +               .enter                  = davinci_enter_idle,
> +               .exit_latency           = 10,
> +               .target_residency       = 100000,
> +               .flags                  = CPUIDLE_FLAG_TIME_VALID,
> +               .name                   = "DDR SR",
> +               .desc                   = "WFI and DDR Self Refresh",
> +       },
> +       .state_count = DAVINCI_CPUIDLE_MAX_STATES,
>  };
>
>  static DEFINE_PER_CPU(struct cpuidle_device, davinci_cpuidle_device);
> @@ -77,41 +108,10 @@ static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
>        },
>  };
>
> -/* Actual code that puts the SoC in different idle states */
> -static int davinci_enter_idle(struct cpuidle_device *dev,
> -                               struct cpuidle_driver *drv,
> -                                               int index)
> -{
> -       struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
> -       struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
> -       struct timeval before, after;
> -       int idle_time;
> -
> -       local_irq_disable();
> -       do_gettimeofday(&before);
> -
> -       if (ops && ops->enter)
> -               ops->enter(ops->flags);
> -       /* Wait for interrupt state */
> -       cpu_do_idle();
> -       if (ops && ops->exit)
> -               ops->exit(ops->flags);
> -
> -       do_gettimeofday(&after);
> -       local_irq_enable();
> -       idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
> -                       (after.tv_usec - before.tv_usec);
> -
> -       dev->last_residency = idle_time;
> -
> -       return index;
> -}
> -
>  static int __init davinci_cpuidle_probe(struct platform_device *pdev)
>  {
>        int ret;
>        struct cpuidle_device *device;
> -       struct cpuidle_driver *driver = &davinci_idle_driver;
>        struct davinci_cpuidle_config *pdata = pdev->dev.platform_data;
>
>        device = &per_cpu(davinci_cpuidle_device, smp_processor_id());
> @@ -123,27 +123,11 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
>
>        ddr2_reg_base = pdata->ddr2_ctlr_base;
>
> -       /* Wait for interrupt state */
> -       driver->states[0].enter = davinci_enter_idle;
> -       driver->states[0].exit_latency = 1;
> -       driver->states[0].target_residency = 10000;
> -       driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
> -       strcpy(driver->states[0].name, "WFI");
> -       strcpy(driver->states[0].desc, "Wait for interrupt");
> -
> -       /* Wait for interrupt and DDR self refresh state */
> -       driver->states[1].enter = davinci_enter_idle;
> -       driver->states[1].exit_latency = 10;
> -       driver->states[1].target_residency = 10000;
> -       driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
> -       strcpy(driver->states[1].name, "DDR SR");
> -       strcpy(driver->states[1].desc, "WFI and DDR Self Refresh");
>        if (pdata->ddr2_pdown)
>                davinci_states[1].flags |= DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN;
>        cpuidle_set_statedata(&device->states_usage[1], &davinci_states[1]);
>
>        device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
> -       driver->state_count = DAVINCI_CPUIDLE_MAX_STATES;
>
>        ret = cpuidle_register_driver(&davinci_idle_driver);
>        if (ret) {
> --
> 1.7.9.4
>
