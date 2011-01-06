Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1AFJzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:55:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:42927 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1AFJzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:55:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,282,1291622400"; 
   d="scan'208";a="644010619"
Date: Thu, 6 Jan 2011 17:27:53 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, trenn@suse.de,
        kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110106092753.GA32343@ywang-moblin2.bj.intel.com>
References: <1294284532-24285-1-git-send-email-youquan.song@intel.com> <1294284532-24285-2-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294284532-24285-2-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 11:28:51AM +0800, Youquan Song wrote:
> Recently, customer report that once machine boot, there are many error interrupt
> reported with exact number of all APs. 
> 
> The root cause is Local APIC will generate error interrupt when it detect
> the illegal vector (one in 0 ~ 15) in an interrupt message received or
> interrupt generate from local vector table or self IPI. SDM3A.chapter 10.
> 
> The thermal sensor register will be reset to 0x10000, current thermal throttling
> driver will first restore AP with the thermal sensor register value of geting
> from BSP,but BSP thermal sensor register is also set 0x10000.  value 0x10000
> means the interrupt vector is zero. After writing 0x10000 to thermal sensor LVT,
> the processor will recieve the error interrupt report if the APIC error
> interrupt is also set.
> 

If the thermal interrupt vector of all CPUs is 0 and you are seeing
LAPIC error interrupts, the correct way to fix it is to disable digital
thermal sensors from generating interrupts.

> Restore thermal sensor value of BSP is useless because it will soon be set to
> correct value included legal vector information.  This patch remove the restore
> process. So the agony noise of error interrupt will be dismiss when machine boot   
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 4b68326..1658483 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -405,17 +405,6 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
>  	 */
>  	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
>  
> -	/*
> -	 * The initial value of thermal LVT entries on all APs always reads
> -	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
> -	 * sequence to them and LVT registers are reset to 0s except for
> -	 * the mask bits which are set to 1s when APs receive INIT IPI.
> -	 * Always restore the value that BIOS has programmed on AP based on
> -	 * BSP's info we saved since BIOS is always setting the same value
> -	 * for all threads/cores
> -	 */
> -	apic_write(APIC_LVTTHMR, lvtthmr_init);
> -

NACK. Please take a look at the commit msg adding the above code you are
trying to delete. If the code is deleted, the bug that
a2202aa29289db64ca7988b12343158b67b27f10 solved will pop up again.

Btw, please try your best to find and copy the person whose code you
wanna delete in your patch.

-Yong

