Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0EPWmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:42:10 -0400
Received: from www.tglx.de ([62.245.132.106]:55103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0EPWmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:42:08 -0400
Date: Mon, 17 May 2010 00:40:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/8] x86/mrst: add cpu type detection for Medfield
In-Reply-To: <1273873281-17489-3-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170032240.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-3-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Fri, 14 May 2010, Jacob Pan wrote:

> Medfield is the follow-up of Moorestown, it is treated under the same
> HW sub-architecture. However, we do need to know the CPU type such that
> some drivers can act accordingly.
> 
> We also have different optimal clock configuration for each CPU type.
> For Moorestown the CPU type is Lincroft and for Medfield the CPU type is
> Penwell.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/include/asm/mrst.h |   13 +++++++++++++
>  arch/x86/kernel/mrst.c      |   21 +++++++++++++++++++++
>  2 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
> index 451d30e..ddf0ad8 100644
> --- a/arch/x86/include/asm/mrst.h
> +++ b/arch/x86/include/asm/mrst.h
> @@ -11,8 +11,21 @@
>  #ifndef _ASM_X86_MRST_H
>  #define _ASM_X86_MRST_H
>  extern int pci_mrst_init(void);
> +extern int mrst_identify_cpu(void);
>  int __init sfi_parse_mrtc(struct sfi_table_header *table);
>  
> +/**
> + * Medfield is the follow-up of Moorestown, it combines two chip solution into
> + * one. Other than that it also added always-on and constant tsc and lapic
> + * timers. Medfield is the platform name, and the chip name is called Penwell
> + * we treat Medfield/Penwell as a variant of Moorestown. Penwell can be
> + * identified via MSRs.
> + */
> +enum mrst_cpu_type {
> +	MRST_CPU_CHIP_LINCROFT = 1,
> +	MRST_CPU_CHIP_PENWELL,
> +};
> +
>  #define SFI_MTMR_MAX_NUM 8
>  #define SFI_MRTC_MAX	8
>  
> diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
> index 0aad867..a3e85be 100644
> --- a/arch/x86/kernel/mrst.c
> +++ b/arch/x86/kernel/mrst.c
> @@ -27,6 +27,7 @@
>  
>  static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
>  static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
> +static u32 mrst_cpu_chip;
>  int sfi_mtimer_num;
>  
>  struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
> @@ -216,6 +217,26 @@ static void __init mrst_setup_boot_clock(void)
>  		setup_boot_APIC_clock();
>  };
>  
> +int mrst_identify_cpu(void)
> +{
> +	if (boot_cpu_data.x86 == 6 &&
> +		boot_cpu_data.x86_model == 0x27 &&
> +		boot_cpu_data.x86_mask == 1)
> +		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
> +	else if (boot_cpu_data.x86 == 6 &&
> +		boot_cpu_data.x86_model == 0x26)
> +		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
> +	else {
> +		pr_err("Unknown Moorestown CPU type, default to Lincroft\n");
> +		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
> +	}
> +	pr_debug("Moorestown CPU %s identified\n",
> +		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
> +		"Lincroft" : "Penwell");
> +
> +	return mrst_cpu_chip;
> +}

Why are you having mrst_cpu_chip as a caching variable if you expose
the identify function ? Either you evaluate boot_cpu_data everytime or
you do it once and expose a function which lets you access the cached
data. IIRC Alan mentioned that drivers need this info, so the access
function will need an EXPORT_SYMBOL_GPL to work.

Thanks,

	tglx
