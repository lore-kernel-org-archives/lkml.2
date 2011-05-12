Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1EKQdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:57680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1EKQdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:33:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="894339"
Date: Wed, 11 May 2011 22:19:45 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, hpa@linux.intel.com,
        suresh.b.siddha@intel.com, yong.y.wang@linux.intel.com,
        joe@perches.com, jbaron@redhat.com, trenn@suse.de, kent.liu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v4 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110512021945.GB19070@linux-youquan.bj.intel.com>
References: <1303402963-17738-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303402963-17738-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Below is the updated description. If it looks good, please take it 
since the first patch "x86, apic: Print verbose error interrupt reason on
 apic=debug" in the patchset already accepted in -tip.

Thanks
-Youquan

On Fri, Apr 22, 2011 at 12:22:43AM +0800, Youquan Song wrote:
> This patch fixes a bug reported from customer, who found many unreasonable error
>  interrupts reported on all APs during the system boot stage.
> 
> According to Chapter 10 of Intel Software Developer Manual Volume 3A, Local APIC
>  may signal an illegal vector error when an LVT entry is set as an illegal
> vector value (0~15) under FIXED delivery mode (bits 8-11 is 0), regardless of
> whether the mask bit is set or an interrupt actually happen. These errors are
> seen as error interrupts.
> 
> The initial value of thermal LVT entries on all APs always reads 0x10000 because
>  APs are woken up by BSP issuing INIT-SIPI-SIPI sequence to them and LVT
> registers are reset to 0s except for the mask bits which are set to 1s when APs
> receive INIT IPI.  When BIOS take over the thermal throttling interrupt, LVT
> thermal deliver mode should be SMI and it is required to restore AP's LVT
> thermal monitor register.
> 
> This issue happens when BIOS do not take over thermal throttling interrupt,
> AP's LVT thermal monitor register will be restored to 0x10000 which means vector
>  0 and fixed deliver mode, so all APs will signal illegal vector error
> interrupt.  This patch check if interrupt delivery mode is not fixed mode before
>  restore AP's LVT thermal monitor register.
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Yong Wang <yong.y.wang@intel.com>
> ---
>  arch/x86/include/asm/apicdef.h           |    1 +
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 +++++++-----
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index d87988b..34595d5 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -78,6 +78,7 @@
>  #define		APIC_DEST_LOGICAL	0x00800
>  #define		APIC_DEST_PHYSICAL	0x00000
>  #define		APIC_DM_FIXED		0x00000
> +#define		APIC_DM_FIXED_MASK	0x00700
>  #define		APIC_DM_LOWEST		0x00100
>  #define		APIC_DM_SMI		0x00200
>  #define		APIC_DM_REMRD		0x00300
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 6f8c5e9..22c212a 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -446,18 +446,20 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
>  	 */
>  	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
>  
> +	h = lvtthmr_init;
>  	/*
>  	 * The initial value of thermal LVT entries on all APs always reads
>  	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
>  	 * sequence to them and LVT registers are reset to 0s except for
>  	 * the mask bits which are set to 1s when APs receive INIT IPI.
> -	 * Always restore the value that BIOS has programmed on AP based on
> -	 * BSP's info we saved since BIOS is always setting the same value
> -	 * for all threads/cores
> +	 * If BIOS take over the thermal interrupt and set its interrupt
> +	 * delivery mode to SMI not fixed, it restore the value that BIOS has
> +	 * programmed on AP based on BSP's info we saved since BIOS is always
> +	 * setting the same value for all threads/cores.
>  	 */
> -	apic_write(APIC_LVTTHMR, lvtthmr_init);
> +	if ((h & APIC_DM_FIXED_MASK) != APIC_DM_FIXED)
> +		apic_write(APIC_LVTTHMR, lvtthmr_init);
>  
> -	h = lvtthmr_init;
>  
>  	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
>  		printk(KERN_DEBUG
> -- 
> 1.6.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
