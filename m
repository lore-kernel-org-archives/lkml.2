Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab2FFUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:14:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42396 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2FFUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:14:56 -0400
Date: Wed, 6 Jun 2012 16:07:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/4] x86, CPU, AMD: Deprecate AMD-specific MSR variants
Message-ID: <20120606200704.GB9602@phenom.dumpdata.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-5-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338562358-28182-5-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 04:52:38PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Now that all users of {rd,wr}msr_amd_safe have been fixed, deprecate its
> use by making them private to amd.c and adding warnings when used on
> anything else beside K8.
> 

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/include/asm/msr.h |   27 ---------------------------
>  arch/x86/kernel/cpu/amd.c  |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index 81860cc012d1..cb33b5f00267 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -211,33 +211,6 @@ do {                                                            \
>  
>  #endif	/* !CONFIG_PARAVIRT */
>  
> -static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
> -{
> -	u32 gprs[8] = { 0 };
> -	int err;
> -
> -	gprs[1] = msr;
> -	gprs[7] = 0x9c5a203a;
> -
> -	err = rdmsr_safe_regs(gprs);
> -
> -	*p = gprs[0] | ((u64)gprs[2] << 32);
> -
> -	return err;
> -}
> -
> -static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
> -{
> -	u32 gprs[8] = { 0 };
> -
> -	gprs[0] = (u32)val;
> -	gprs[1] = msr;
> -	gprs[2] = val >> 32;
> -	gprs[7] = 0x9c5a203a;
> -
> -	return wrmsr_safe_regs(gprs);
> -}
> -
>  #define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
>  					     (u32)((val) >> 32))
>  
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 80ccd99542e6..c928eb26ada6 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -19,6 +19,39 @@
>  
>  #include "cpu.h"
>  
> +static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
> +{
> +	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +	u32 gprs[8] = { 0 };
> +	int err;
> +
> +	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
> +
> +	gprs[1] = msr;
> +	gprs[7] = 0x9c5a203a;
> +
> +	err = rdmsr_safe_regs(gprs);
> +
> +	*p = gprs[0] | ((u64)gprs[2] << 32);
> +
> +	return err;
> +}
> +
> +static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
> +{
> +	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +	u32 gprs[8] = { 0 };
> +
> +	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
> +
> +	gprs[0] = (u32)val;
> +	gprs[1] = msr;
> +	gprs[2] = val >> 32;
> +	gprs[7] = 0x9c5a203a;
> +
> +	return wrmsr_safe_regs(gprs);
> +}
> +
>  #ifdef CONFIG_X86_32
>  /*
>   *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
> -- 
> 1.7.9.3.362.g71319
