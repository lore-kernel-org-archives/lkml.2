Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab2HVPhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:37:03 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:53147 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab2HVPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:37:00 -0400
MIME-Version: 1.0
In-Reply-To: <1345648390-4234-3-git-send-email-arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de> <1345648390-4234-3-git-send-email-arnd@arndb.de>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 22 Aug 2012 21:06:38 +0530
Message-ID: <CAMQu2gw0x6saWrK-M3teu49tJDGvS8RhGrVSh6JTs5DEy+22pA@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: omap: allow building omap44xx without SMP
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 8:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The new omap4 cpuidle implementation currently requires
> ARCH_NEEDS_CPU_IDLE_COUPLED, which only works on SMP.
>
> This patch makes it possible to build a non-SMP kernel
> for that platform. This is not normally desired for
> end-users but can be useful for testing.
>
> Without this patch, building rand-0y2jSKT results in:
>
> drivers/cpuidle/coupled.c: In function 'cpuidle_coupled_poke':
> drivers/cpuidle/coupled.c:317:3: error: implicit declaration of function '__smp_call_function_single' [-Werror=implicit-function-declaration]
>
> It's not clear if this patch is the best solution for
> the problem at hand. I have made sure that we can now
> build the kernel in all configurations, but that does
> not mean it will actually work on an OMAP44xx.
>
Am not sure either about the subject patch.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/Kconfig       |    2 +-
>  arch/arm/mach-omap2/cpuidle44xx.c |    3 ++-
>  include/linux/cpuidle.h           |    4 ++++
>  3 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index dd2db02..66a8be3 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -62,7 +62,7 @@ config ARCH_OMAP4
>         select PM_OPP if PM
>         select USB_ARCH_HAS_EHCI if USB_SUPPORT
>         select ARM_CPU_SUSPEND if PM
> -       select ARCH_NEEDS_CPU_IDLE_COUPLED
> +       select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
>
>  config SOC_OMAP5
>         bool "TI OMAP5"
> diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
> index ee05e19..288bee6 100644
> --- a/arch/arm/mach-omap2/cpuidle44xx.c
> +++ b/arch/arm/mach-omap2/cpuidle44xx.c
> @@ -238,8 +238,9 @@ int __init omap4_idle_init(void)
>         for_each_cpu(cpu_id, cpu_online_mask) {
>                 dev = &per_cpu(omap4_idle_dev, cpu_id);
>                 dev->cpu = cpu_id;
> +#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
>                 dev->coupled_cpus = *cpu_online_mask;
> -
> +#endif

Was just thinking whether we should just take care of it at
core cpuidle level itself. Will below be enough to kill the build
error what you mentioned in the change log ?

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 2c9bf26..df34534 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -314,7 +314,9 @@ static void cpuidle_coupled_poke(int cpu)
        struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);

        if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
+#ifdef CONFIG_SMP
                __smp_call_function_single(cpu, csd, 0);
+#endif
 }

 /**

Regards
Santosh
