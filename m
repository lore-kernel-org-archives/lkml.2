Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1AGSlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:41:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:36004 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1AGSlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:41:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,290,1291622400"; 
   d="scan'208";a="590900328"
Subject: Re: [PATCH v2 1/2] apic: Fix error interrupt report at all APs
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Song, Youquan" <youquan.song@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "yong.y.wang@linux.intel.com" <yong.y.wang@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "jbaron@redhat.com" <jbaron@redhat.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "trenn@suse.de" <trenn@suse.de>, "Liu, Kent" <kent.liu@intel.com>,
        "Guo, Chaohong" <chaohong.guo@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <1294418204-15587-2-git-send-email-youquan.song@intel.com>
References: <1294418204-15587-1-git-send-email-youquan.song@intel.com>
	 <1294418204-15587-2-git-send-email-youquan.song@intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 07 Jan 2011 10:41:53 -0800
Message-Id: <1294425713.2673.18.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 08:36 -0800, Song, Youquan wrote:
> Recently, customer report that once machine boot, there are many error interrupt
> reported with exact number of all APs. 
> 
> The root cause is Local APIC will generate error interrupt when it detect
> the illegal vector (one in 0 ~ 15) in an interrupt message received or
> interrupt generate from local vector table or self IPI. SDM3A.chapter 10.
> 
> AP LAPIC thermal sensor register will be reset to 0x10000, if thermal throttling
> interrupt take over by BIOS, it need restore AP with the thermal sensor register
> value of geting from BSP, otherwise cause system issue. If BIOS does not take
> over the thermal interrupt, The restore value will be CPU rest value of 0x10000,
> which means the interrupt vector is zero. After writing 0x10000 to thermal
> sensor LVT, the processor will recieve the error interrupt report if the APIC
> error interrupt is also set.
> 
> This patch add check the BIOS whether take over the thermal interrupt by look
> at interrupt delivery mode not fixed mode(BIOS handle will be SMI mode) before
> restore AP's thermal LVT. So the agony noise of error interrupt will dismiss
> when boot on machine that BIOS does not handle thermal interrupt..  
> 
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  arch/x86/include/asm/apicdef.h           |    1 +
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 +++++++-----
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index a859ca4..f587be0 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -78,6 +78,7 @@
>  #define		APIC_DEST_LOGICAL	0x00800
>  #define		APIC_DEST_PHYSICAL	0x00000
>  #define		APIC_DM_FIXED		0x00000
> +#define		APIC_DM_FIXED_MASK	0x00700

It should be called APIC_DM_MASK. Other than that this patch looks good.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

>  #define		APIC_DM_LOWEST		0x00100
>  #define		APIC_DM_SMI		0x00200
>  #define		APIC_DM_REMRD		0x00300
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 4b68326..ecd6992 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -405,18 +405,20 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
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
> +	if (h & APIC_DM_FIXED_MASK)
> +		apic_write(APIC_LVTTHMR, lvtthmr_init);
>  
> -	h = lvtthmr_init;
>  
>  	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
>  		printk(KERN_DEBUG

