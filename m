Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2GXOrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:47:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2GXOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:47:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cyril Chemparathy <cyril@ti.com>
Subject: Re: [RFC 21/23] ARM: keystone: introducing TI Keystone platform
Date: Tue, 24 Jul 2012 14:46:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nico@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-22-git-send-email-cyril@ti.com>
In-Reply-To: <1343092165-9470-22-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241446.53401.arnd@arndb.de>
X-Provags-ID: V02:K0:vuFQwiD8YXhLxd6Q0/sGNLAwTdHTil7WKQrIvXuKH0s
 DQB29J8XvPmv7Yhbr651yWtuuLCOjNYX6rtJhhhms+jcIpvsEU
 ih/dETRyVTk/c7TXrOsuJR64Zi78+CkQ8e2FA3jPTvuyFcoz3p
 nRy1Cx3H72D92DZD9D9wEfcEJw+QNCiXKUvhmgRKS6eje+cUBl
 gFgzVDOnH5Wh9B2t1rOT3t095FJoxS83wiajgC+Sa8IIPr+OjR
 lZu/ExS5eQkHCPW2PxcWGLOH6d9Q3+BVQJsD/Y+tHIyTGOqfWm
 +KOyArg/1K4RoBmB0qBhCmuxqw7Mn5jrGx2+EjrvsJXvECzKzm
 8vBu2c0NAsw/VLhxbO0s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012, Cyril Chemparathy wrote:

> diff --git a/arch/arm/boot/dts/keystone-sim.dts b/arch/arm/boot/dts/keystone-sim.dts
> new file mode 100644
> index 0000000..118d631
> --- /dev/null
> +++ b/arch/arm/boot/dts/keystone-sim.dts
> @@ -0,0 +1,77 @@
> +/dts-v1/;
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Texas Instruments Keystone 2 SoC";
> +	compatible = "ti,keystone-evm";
> +	#address-cells = <1>;
> +	#size-cells = <1>;

I would assume that you need at least #address-cells=<2>, possibly
also #size-cells=<2>, in order to express large memory ranges.

> diff --git a/arch/arm/mach-keystone/include/mach/entry-macro.S b/arch/arm/mach-keystone/include/mach/entry-macro.S
> new file mode 100644
> index 0000000..7f486f3
> --- /dev/null
> +++ b/arch/arm/mach-keystone/include/mach/entry-macro.S
>
> +	.macro	disable_fiq
> +	.endm
> +
> +	.macro	arch_ret_to_user, tmp1, tmp2
> +	.endm

I think it would be better to enable MULTI_IRQ_HANDLER and remove
this file.

> diff --git a/arch/arm/mach-keystone/include/mach/io.h b/arch/arm/mach-keystone/include/mach/io.h
> new file mode 100644
> index 0000000..844d659
> --- /dev/null
> +++ b/arch/arm/mach-keystone/include/mach/io.h

> +#ifndef __MACH_IO_H
> +#define __MACH_IO_H
> +
> +#define __io(a)		({ (void)(a); __typesafe_io(0); })
> +#define __mem_pci(a)	(a)
> +
> +#endif

This should also be removed.

> diff --git a/arch/arm/mach-keystone/include/mach/memory.h b/arch/arm/mach-keystone/include/mach/memory.h
> new file mode 100644
> index 0000000..7c78b1e
> --- /dev/null
> +++ b/arch/arm/mach-keystone/include/mach/memory.h

> +#ifndef __ASM_MACH_MEMORY_H
> +#define __ASM_MACH_MEMORY_H
> +
> +#define MAX_PHYSMEM_BITS	36
> +#define SECTION_SIZE_BITS	34
> +
> +#endif /* __ASM_MACH_MEMORY_H */

I wonder if there is anything we can do to make these generic. What you
have here is ok for now, but we will need to do this differently once
we are building multiplatform kernels with keystone and sparse memory.

> diff --git a/arch/arm/mach-keystone/include/mach/system.h b/arch/arm/mach-keystone/include/mach/system.h
> new file mode 100644
> index 0000000..4887b4c
> --- /dev/null
> +++ b/arch/arm/mach-keystone/include/mach/system.h

> +#ifndef __MACH_SYSTEM_H
> +#define __MACH_SYSTEM_H
> +
> +static inline void arch_idle(void)
> +{
> +	cpu_do_idle();
> +}
> +
> +static inline void arch_reset(char mode, const char *cmd)
> +{
> +	while (1)
> +		;
> +}
> +
> +#endif

These are no longer used, please remove the file.


> diff --git a/arch/arm/mach-keystone/include/mach/vmalloc.h b/arch/arm/mach-keystone/include/mach/vmalloc.h
> new file mode 100644
> index 0000000..9d34c09
> --- /dev/null
> +++ b/arch/arm/mach-keystone/include/mach/vmalloc.h

> +
> +#define VMALLOC_END		0xFE800000UL
> +
> +#endif

same here.

> +DT_MACHINE_START(KEYSTONE, "Keystone")
> +	.map_io		= keystone_map_io,
> +	.init_irq	= keystone_init_irq,
> +	.timer		= &keystone_timer,
> +	.handle_irq	= gic_handle_irq,
> +	.init_machine	= keystone_init,
> +	.dt_compat	= keystone_match,
> +	.nr_irqs	= 480,
> +MACHINE_END

IIRC, you don't need to set the nr_irqs this high in advance,
they will be allocated automatically since you have enabled
sparse IRQs.

	Arnd
