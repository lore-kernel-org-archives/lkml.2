Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392Ab2KABct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 21:32:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50968 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab2KABcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 21:32:47 -0400
Message-ID: <5091D13B.6060106@gmail.com>
Date: Wed, 31 Oct 2012 20:32:43 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Yangfei (Felix)" <felix.yang@huawei.com>
CC: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Fix the "WFI" instruction opcode definition.
References: <DA41BE1DDCA941489001C7FBD7A8820E3CB5512E@szxeml549-mbx.china.huawei.com>
In-Reply-To: <DA41BE1DDCA941489001C7FBD7A8820E3CB5512E@szxeml549-mbx.china.huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:24 PM, Yangfei (Felix) wrote:
> The current "WFI" opcode definiton causes CPU hot-plug feature fails to work
> if the kernel is built with CONFIG_THUMB2_KERNEL/CONFIG_CPU_ENDIAN_BE8 being
> defined. An invalid instruction exception will be generated.
> 
> Signed-off-by: yangfei.kernel@gmail.com
> ---
>  arch/arm/mach-exynos/hotplug.c   |    8 +++++++-
>  arch/arm/mach-realview/hotplug.c |    8 +++++++-
>  arch/arm/mach-shmobile/hotplug.c |    8 +++++++-
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index f4d7dd2..823a0e4 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -18,11 +18,17 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cp15.h>
>  #include <asm/smp_plat.h>
> +#include <asm/opcodes.h>
>  
>  #include <mach/regs-pmu.h>
>  
>  #include "common.h"
>  
> +/*
> + * Define opcode of the WFI instruction.
> + */
> +#define __WFI __inst_arm_thumb16(0xe320f003, 0xbf30)
> +
>  static inline void cpu_enter_lowpower(void)
>  {
>  	unsigned int v;
> @@ -72,7 +78,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  		/*
>  		 * here's the WFI
>  		 */
> -		asm(".word	0xe320f003\n"
> +		asm(__WFI

Wouldn't using the actual wfi instruction fix this. There is a wfi() macro.

Or just call cpu_do_idle() which will do any other things needed before
wfi like a dsb instruction.

Rob
>  		    :
>  		    :
>  		    : "memory", "cc");
> diff --git a/arch/arm/mach-realview/hotplug.c b/arch/arm/mach-realview/hotplug.c
> index 53818e5..5271a1a 100644
> --- a/arch/arm/mach-realview/hotplug.c
> +++ b/arch/arm/mach-realview/hotplug.c
> @@ -15,6 +15,12 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cp15.h>
>  #include <asm/smp_plat.h>
> +#include <asm/opcodes.h>
> +
> +/*
> + * Define opcode of the WFI instruction.
> + */
> +#define __WFI __inst_arm_thumb16(0xe320f003, 0xbf30)
>  
>  static inline void cpu_enter_lowpower(void)
>  {
> @@ -64,7 +70,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  		/*
>  		 * here's the WFI
>  		 */
> -		asm(".word	0xe320f003\n"
> +		asm(__WFI
>  		    :
>  		    :
>  		    : "memory", "cc");
> diff --git a/arch/arm/mach-shmobile/hotplug.c b/arch/arm/mach-shmobile/hotplug.c
> index b09a0bd..0d7b7d1 100644
> --- a/arch/arm/mach-shmobile/hotplug.c
> +++ b/arch/arm/mach-shmobile/hotplug.c
> @@ -20,6 +20,12 @@
>  #include <mach/emev2.h>
>  #include <asm/cacheflush.h>
>  #include <asm/mach-types.h>
> +#include <asm/opcodes.h>
> +
> +/*
> + * Define opcode of the WFI instruction.
> + */
> ++#define __WFI __inst_arm_thumb16(0xe320f003, 0xbf30)
>  
>  static cpumask_t dead_cpus;
>  
> @@ -39,7 +45,7 @@ void shmobile_cpu_die(unsigned int cpu)
>  		/*
>  		 * here's the WFI
>  		 */
> -		asm(".word	0xe320f003\n"
> +		asm(__WFI
>  		    :
>  		    :
>  		    : "memory", "cc");
> --
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

