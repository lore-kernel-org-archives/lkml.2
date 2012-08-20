Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2HTOER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:04:17 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52195 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab2HTOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:04:12 -0400
Date: Mon, 20 Aug 2012 16:04:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Message-ID: <20120820140401.GC24149@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 01:15:22AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Define interfaces load_ucode_bsp() and load_ucode_ap() to load ucode on BSP and
> AP in early boot time. These are generic interfaces. Internally they call
> vendor specific implementations.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/microcode.h       |   23 ++++++++++
>  arch/x86/kernel/microcode_core_early.c |   74 ++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+), 0 deletions(-)

Still the same build error:

ERROR: "get_matching_microcode" [arch/x86/kernel/microcode.ko] undefined!
ERROR: "microcode_sanity_check" [arch/x86/kernel/microcode.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....


>  create mode 100644 arch/x86/kernel/microcode_core_early.c
> 
> diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
> index 4ebe157..080ea77 100644
> --- a/arch/x86/include/asm/microcode.h
> +++ b/arch/x86/include/asm/microcode.h
> @@ -63,4 +63,27 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
>  static inline void __exit exit_amd_microcode(void) {}
>  #endif
>  
> +struct mc_saved_data {
> +	unsigned int mc_saved_count;
> +	struct microcode_intel **mc_saved;
> +	struct ucode_cpu_info *ucode_cpu_info;
> +};
> +#ifdef CONFIG_MICROCODE_EARLY
> +#define MAX_UCODE_COUNT 128
> +extern struct ucode_cpu_info ucode_cpu_info_early[NR_CPUS];
> +extern struct microcode_intel __initdata *mc_saved_in_initrd[MAX_UCODE_COUNT];
> +extern struct mc_saved_data mc_saved_data;
> +extern void __init load_ucode_bsp(char *real_mode_data);
> +extern __init void load_ucode_ap(void);
> +extern void __init
> +save_microcode_in_initrd(struct mc_saved_data *mc_saved_data,
> +			 struct microcode_intel **mc_saved_in_initrd);
> +#else
> +static inline void __init load_ucode_bsp(char *real_mode_data) {}
> +static inline __init void load_ucode_ap(void) {}
> +static inline void __init
> +save_microcode_in_initrd(struct mc_saved_data *mc_saved_data,
> +			 struct microcode_intel **mc_saved_in_initrd) {}
> +#endif
> +
>  #endif /* _ASM_X86_MICROCODE_H */
> diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
> new file mode 100644
> index 0000000..5bcc6f8
> --- /dev/null
> +++ b/arch/x86/kernel/microcode_core_early.c
> @@ -0,0 +1,74 @@
> +/*
> + *	X86 CPU microcode early update for Linux
> + *
> + *	Copyright (C) 2012 Fenghua Yu <fenghua.yu@intel.com>
> + *			   H Peter Anvin" <hpa@zytor.com>
> + *
> + *	This driver allows to early upgrade microcode on Intel processors
> + *	belonging to IA-32 family - PentiumPro, Pentium II,
> + *	Pentium III, Xeon, Pentium 4, etc.

Can we drop the vendor-specific text from generic x86 code pls? This
belongs into microcode_intel_* AFAICT.

> + *
> + *	Reference: Section 9.11 of Volume 3, IA-32 Intel Architecture
> + *	Software Developer's Manual.
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <asm/microcode_intel.h>
> +#include <asm/processor.h>
> +#include <asm/cpio.h>
> +
> +struct ucode_cpu_info	ucode_cpu_info_early[NR_CPUS];
> +EXPORT_SYMBOL_GPL(ucode_cpu_info_early);
> +
> +static __init enum ucode_state
> +find_ucode_intel(unsigned long start, unsigned long end)
> +{
> +	unsigned int size = end - start + 1;
> +	struct cpio_data cd = { 0, 0 };
> +	char ucode_name[] = "kernel/x86/microcode/GenuineIntel/microcode.hex";
> +
> +	cd = find_cpio_data(ucode_name, (void *)start, size);
> +	if (cd.data)
> +		return UCODE_OK;
> +
> +	return UCODE_ERROR;
> +}

This function can be made generic by giving the ucode_name down as an
arg, for example, so that other vendors can use it too.

> +
> +void __init load_ucode_bsp(char *real_mode_data)
> +{
> +	u64 ramdisk_image, ramdisk_size, ramdisk_end;
> +	unsigned long initrd_start, initrd_end;
> +	struct boot_params *boot_params;
> +
> +	boot_params = (struct boot_params *)real_mode_data;
> +	ramdisk_image = boot_params->hdr.ramdisk_image;
> +	ramdisk_size  = boot_params->hdr.ramdisk_size;
> +
> +#ifdef CONFIG_X86_64
> +	ramdisk_end  = PAGE_ALIGN(ramdisk_image + ramdisk_size);
> +	initrd_start = ramdisk_image + PAGE_OFFSET;
> +#else
> +	ramdisk_end  = ramdisk_image + ramdisk_size;
> +	initrd_start = ramdisk_image;
> +#endif
> +	initrd_end = initrd_start + ramdisk_size;
> +
> +	/*
> +	 * It's early to get CPU vendor info at this point.
> +	 * By searching initrd to find right name for vendor's microcode,
> +	 * it's relative easier to get CPU vendor info.
> +	 */
> +	if (find_ucode_intel(initrd_start, initrd_end) == UCODE_OK)
> +		load_ucode_intel_bsp(real_mode_data);
> +}
> +
> +void __cpuinit load_ucode_ap(void)
> +{
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
> +		load_ucode_intel_ap();
> +}
> -- 
> 1.7.2
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
