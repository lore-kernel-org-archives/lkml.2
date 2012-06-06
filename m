Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab2FFUOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:14:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33986 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2FFUO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:14:29 -0400
Date: Wed, 6 Jun 2012 16:06:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] x86, pvops: Remove hooks for {rd,wr}msr_safe_regs
Message-ID: <20120606200651.GA9602@phenom.dumpdata.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338562358-28182-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 04:52:35PM +0200, Borislav Petkov wrote:
> From: Andre Przywara <andre.przywara@amd.com>
> 
> There were paravirt_ops hooks for the full register set variant of
> {rd,wr}msr_safe which are actually not used by anyone anymore. Remove
> them to make the code cleaner and avoid silent breakages when the pvops
> members were uninitialized. This has been boot-tested natively and under
> Xen with PVOPS enabled and disabled on one machine.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/msr.h            |   67 ++++++++++++++-------------------
>  arch/x86/include/asm/paravirt.h       |   39 -------------------
>  arch/x86/include/asm/paravirt_types.h |    2 -
>  arch/x86/kernel/paravirt.c            |    2 -
>  arch/x86/lib/msr-reg-export.c         |    4 +-
>  arch/x86/lib/msr-reg.S                |   10 ++---
>  arch/x86/xen/enlighten.c              |    2 -
>  7 files changed, 35 insertions(+), 91 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index 084ef95274cd..81860cc012d1 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -115,8 +115,8 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
>  
>  extern unsigned long long native_read_tsc(void);
>  
> -extern int native_rdmsr_safe_regs(u32 regs[8]);
> -extern int native_wrmsr_safe_regs(u32 regs[8]);
> +extern int rdmsr_safe_regs(u32 regs[8]);
> +extern int wrmsr_safe_regs(u32 regs[8]);
>  
>  static __always_inline unsigned long long __native_read_tsc(void)
>  {
> @@ -187,43 +187,6 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
>  	return err;
>  }
>  
> -static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
> -{
> -	u32 gprs[8] = { 0 };
> -	int err;
> -
> -	gprs[1] = msr;
> -	gprs[7] = 0x9c5a203a;
> -
> -	err = native_rdmsr_safe_regs(gprs);
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
> -	return native_wrmsr_safe_regs(gprs);
> -}
> -
> -static inline int rdmsr_safe_regs(u32 regs[8])
> -{
> -	return native_rdmsr_safe_regs(regs);
> -}
> -
> -static inline int wrmsr_safe_regs(u32 regs[8])
> -{
> -	return native_wrmsr_safe_regs(regs);
> -}
> -
>  #define rdtscl(low)						\
>  	((low) = (u32)__native_read_tsc())
>  
> @@ -248,6 +211,32 @@ do {                                                            \
>  
>  #endif	/* !CONFIG_PARAVIRT */
>  
> +static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
> +{
> +	u32 gprs[8] = { 0 };
> +	int err;
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
> +	u32 gprs[8] = { 0 };
> +
> +	gprs[0] = (u32)val;
> +	gprs[1] = msr;
> +	gprs[2] = val >> 32;
> +	gprs[7] = 0x9c5a203a;
> +
> +	return wrmsr_safe_regs(gprs);
> +}
>  
>  #define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
>  					     (u32)((val) >> 32))
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 6cbbabf52707..ebb0cdb60a89 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -128,21 +128,11 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
>  	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
>  }
>  
> -static inline int paravirt_rdmsr_regs(u32 *regs)
> -{
> -	return PVOP_CALL1(int, pv_cpu_ops.rdmsr_regs, regs);
> -}
> -
>  static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
>  {
>  	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
>  }
>  
> -static inline int paravirt_wrmsr_regs(u32 *regs)
> -{
> -	return PVOP_CALL1(int, pv_cpu_ops.wrmsr_regs, regs);
> -}
> -
>  /* These should all do BUG_ON(_err), but our headers are too tangled. */
>  #define rdmsr(msr, val1, val2)			\
>  do {						\
> @@ -176,9 +166,6 @@ do {						\
>  	_err;					\
>  })
>  
> -#define rdmsr_safe_regs(regs)	paravirt_rdmsr_regs(regs)
> -#define wrmsr_safe_regs(regs)	paravirt_wrmsr_regs(regs)
> -
>  static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
>  {
>  	int err;
> @@ -186,32 +173,6 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
>  	*p = paravirt_read_msr(msr, &err);
>  	return err;
>  }
> -static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
> -{
> -	u32 gprs[8] = { 0 };
> -	int err;
> -
> -	gprs[1] = msr;
> -	gprs[7] = 0x9c5a203a;
> -
> -	err = paravirt_rdmsr_regs(gprs);
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
> -	return paravirt_wrmsr_regs(gprs);
> -}
>  
>  static inline u64 paravirt_read_tsc(void)
>  {
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 8e8b9a4987ee..8613cbb7ba41 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -153,9 +153,7 @@ struct pv_cpu_ops {
>  	/* MSR, PMC and TSR operations.
>  	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
>  	u64 (*read_msr)(unsigned int msr, int *err);
> -	int (*rdmsr_regs)(u32 *regs);
>  	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
> -	int (*wrmsr_regs)(u32 *regs);
>  
>  	u64 (*read_tsc)(void);
>  	u64 (*read_pmc)(int counter);
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 9ce885996fd7..17fff18a1031 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -352,9 +352,7 @@ struct pv_cpu_ops pv_cpu_ops = {
>  #endif
>  	.wbinvd = native_wbinvd,
>  	.read_msr = native_read_msr_safe,
> -	.rdmsr_regs = native_rdmsr_safe_regs,
>  	.write_msr = native_write_msr_safe,
> -	.wrmsr_regs = native_wrmsr_safe_regs,
>  	.read_tsc = native_read_tsc,
>  	.read_pmc = native_read_pmc,
>  	.read_tscp = native_read_tscp,
> diff --git a/arch/x86/lib/msr-reg-export.c b/arch/x86/lib/msr-reg-export.c
> index a311cc59b65d..8d6ef78b5d01 100644
> --- a/arch/x86/lib/msr-reg-export.c
> +++ b/arch/x86/lib/msr-reg-export.c
> @@ -1,5 +1,5 @@
>  #include <linux/module.h>
>  #include <asm/msr.h>
>  
> -EXPORT_SYMBOL(native_rdmsr_safe_regs);
> -EXPORT_SYMBOL(native_wrmsr_safe_regs);
> +EXPORT_SYMBOL(rdmsr_safe_regs);
> +EXPORT_SYMBOL(wrmsr_safe_regs);
> diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
> index 69fa10623f21..f6d13eefad10 100644
> --- a/arch/x86/lib/msr-reg.S
> +++ b/arch/x86/lib/msr-reg.S
> @@ -6,13 +6,13 @@
>  
>  #ifdef CONFIG_X86_64
>  /*
> - * int native_{rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
> + * int {rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
>   *
>   * reg layout: u32 gprs[eax, ecx, edx, ebx, esp, ebp, esi, edi]
>   *
>   */
>  .macro op_safe_regs op
> -ENTRY(native_\op\()_safe_regs)
> +ENTRY(\op\()_safe_regs)
>  	CFI_STARTPROC
>  	pushq_cfi %rbx
>  	pushq_cfi %rbp
> @@ -45,13 +45,13 @@ ENTRY(native_\op\()_safe_regs)
>  
>  	_ASM_EXTABLE(1b, 3b)
>  	CFI_ENDPROC
> -ENDPROC(native_\op\()_safe_regs)
> +ENDPROC(\op\()_safe_regs)
>  .endm
>  
>  #else /* X86_32 */
>  
>  .macro op_safe_regs op
> -ENTRY(native_\op\()_safe_regs)
> +ENTRY(\op\()_safe_regs)
>  	CFI_STARTPROC
>  	pushl_cfi %ebx
>  	pushl_cfi %ebp
> @@ -92,7 +92,7 @@ ENTRY(native_\op\()_safe_regs)
>  
>  	_ASM_EXTABLE(1b, 3b)
>  	CFI_ENDPROC
> -ENDPROC(native_\op\()_safe_regs)
> +ENDPROC(\op\()_safe_regs)
>  .endm
>  
>  #endif
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e74df9548a02..60f1131eb94f 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1116,9 +1116,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
>  	.wbinvd = native_wbinvd,
>  
>  	.read_msr = native_read_msr_safe,
> -	.rdmsr_regs = native_rdmsr_safe_regs,
>  	.write_msr = xen_write_msr_safe,
> -	.wrmsr_regs = native_wrmsr_safe_regs,
>  
>  	.read_tsc = native_read_tsc,
>  	.read_pmc = native_read_pmc,
> -- 
> 1.7.9.3.362.g71319
