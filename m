Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1AJDah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 22:30:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:17536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab1AJDad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 22:30:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,298,1291622400"; 
   d="scan'208";a="695141118"
From: "Guo, Chaohong" <chaohong.guo@intel.com>
To: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "yong.y.wang@linux.intel.com" <yong.y.wang@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "jbaron@redhat.com" <jbaron@redhat.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "trenn@suse.de" <trenn@suse.de>, "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
Date: Mon, 10 Jan 2011 11:30:26 +0800
Subject: RE: [PATCH v3 1/2] apic: Fix error interrupt report at all APs
Thread-Topic: [PATCH v3 1/2] apic: Fix error interrupt report at all APs
Thread-Index: Acuu2rdhDhiqKEUVRd2ceLIcWIOXZwBmm21w
Message-ID: <CF2F38D4AE21BB4CB845318E4C5ECB6731A79A5E@shsmsx501.ccr.corp.intel.com>
References: <1294453211-26439-1-git-send-email-youquan.song@intel.com>
 <1294453211-26439-2-git-send-email-youquan.song@intel.com>
In-Reply-To: <1294453211-26439-2-git-send-email-youquan.song@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Song, Youquan
> Sent: Saturday, January 08, 2011 10:20 AM
> To: linux-kernel@vger.kernel.org; hpa@linux.intel.com; Siddha, Suresh B
> Cc: yong.y.wang@linux.intel.com; joe@perches.com; jbaron@redhat.com;
> arjan@linux.intel.com; trenn@suse.de; Liu, Kent; Guo, Chaohong; Youquan
> Song; Song, Youquan
> Subject: [PATCH v3 1/2] apic: Fix error interrupt report at all APs
> 
> Recently, customer report that once machine boot, there are many error
> interrupt reported with exact number of all APs.
> 
> The root cause is Local APIC will generate error interrupt when it detect the
> illegal vector (one in 0 ~ 15) in an interrupt message received or interrupt
> generate from local vector table or self IPI. SDM3A.chapter 10.
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
> at interrupt delivery mode not fixed mode(BIOS handle will be SMI mode)
> before restore AP's thermal LVT. So the agony noise of error interrupt will
> dismiss when boot on machine that BIOS does not handle thermal interrupt..
> 
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
> index a859ca4..1495098 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -85,6 +85,7 @@
>  #define		APIC_DM_INIT		0x00500
>  #define		APIC_DM_STARTUP		0x00600
>  #define		APIC_DM_EXTINT		0x00700
> +#define		APIC_DM_MASK		0x00700
>  #define		APIC_VECTOR_MASK	0x000FF
>  #define	APIC_ICR2	0x310
>  #define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 4b68326..22a3b4f 100644
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
> +	if (h & APIC_DM_MASK)

How about changing it to :

     If ( (h & APIC_DM_MASK) != APIC_DM_FIXED)

-minskey












> +		apic_write(APIC_LVTTHMR, lvtthmr_init);
> 
> -	h = lvtthmr_init;
> 
>  	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
>  		printk(KERN_DEBUG
> --
> 1.6.4.2

