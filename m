Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab2FAJak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:30:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59295 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab2FAJaj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 1 Jun 2012 05:30:39 -0400
Message-Id: <4FC8A7DC0200007800087BBC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 01 Jun 2012 10:30:36 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andre Przywara" <andre.przywara@amd.com>, <konrad.wilk@oracle.com>,
        <hpa@zytor.com>
Cc: <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] pvops/x86: remove hooks for {rd,
 wr}msr_safe_regs
References: <1338542796-40586-1-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1338542796-40586-1-git-send-email-andre.przywara@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.06.12 at 11:26, Andre Przywara <andre.przywara@amd.com> wrote:
> There were paravirt_ops hooks for the full register set variant of
> {rd,wr}msr_safe which are actually not used by anyone anymore.
> Remove them to make the code cleaner and avoid silent breakages
> when the pvops members were uninitialized.
> This has been boot-tested natively and under Xen with PVOPS enabled
> and disabled on one machine.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

> ---
>  arch/x86/include/asm/msr.h            |   67 ++++++++++++++-------------------
>  arch/x86/include/asm/paravirt.h       |   39 -------------------
>  arch/x86/include/asm/paravirt_types.h |    2 -
>  arch/x86/kernel/paravirt.c            |    2 -
>  arch/x86/lib/msr-reg-export.c         |    4 +-
>  arch/x86/lib/msr-reg.S                |   10 ++--
>  arch/x86/xen/enlighten.c              |    2 -
>  7 files changed, 35 insertions(+), 91 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index 084ef95..81860cc 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -115,8 +115,8 @@ notrace static inline int native_write_msr_safe(unsigned 
> int msr,
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
> @@ -187,43 +187,6 @@ static inline int rdmsrl_safe(unsigned msr, unsigned 
> long long *p)
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
> @@ -248,6 +211,32 @@ do {                                                     
>        \
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
> index 6cbbabf..ebb0cdb 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -128,21 +128,11 @@ static inline u64 paravirt_read_msr(unsigned msr, int 
> *err)
>  	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
>  }
>  
> -static inline int paravirt_rdmsr_regs(u32 *regs)
> -{
> -	return PVOP_CALL1(int, pv_cpu_ops.rdmsr_regs, regs);
> -}
> -
>  static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned 
> high)
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
> @@ -186,32 +173,6 @@ static inline int rdmsrl_safe(unsigned msr, unsigned 
> long long *p)
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
> diff --git a/arch/x86/include/asm/paravirt_types.h 
> b/arch/x86/include/asm/paravirt_types.h
> index 8e8b9a4..8613cbb 100644
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
> index 9ce8859..17fff18 100644
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
> index a311cc5..8d6ef78 100644
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
> index 69fa106..f6d13ee 100644
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
> index e74df95..60f1131 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1116,9 +1116,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst 
> = {
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
> 1.7.4.4
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 


