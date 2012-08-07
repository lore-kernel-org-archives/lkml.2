Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab2HGJBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:01:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23241 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2HGJBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:01:34 -0400
Message-ID: <5020D97C.2080009@oracle.com>
Date: Tue, 07 Aug 2012 17:01:48 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: zhenzhong.duan@oracle.com
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] Parallelize mtrr init between cpus
References: <5020C3D7.2070407@oracle.com>
In-Reply-To: <5020C3D7.2070407@oracle.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also post a question to xen-devel maillist.
Although this patch fix the long time issue in hvm, but I don't know
why hvm would waste such a long time at bootup.
Also I'm not sure if this patch is correct in all cases.
Maybe I miss something.
link for reference: http://www.gossamer-threads.com/lists/xen/devel/252757

thanks

2012-08-07 15:29, zhenzhong.duan wrote:
> Current code serialize mtrr init with set_atomicity_lock.
> Mtrr init is quite slow when we bootup on a hvm with large mem, vcpus
> and pci passthroughed devices(eg. 24 vcpus + 90G mem).
> It took about ~30 mins to bootup, after patch, it took ~2 min.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |   57 +++++++++++++++++-------------------
>  1 files changed, 27 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
> index e9fe907..a1468b7 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -335,8 +335,9 @@ print_fixed(unsigned base, unsigned step, const mtrr_type *types)
>  	}
>  }
>  
> -static void prepare_set(void);
> -static void post_set(void);
> +static void prepare_set(unsigned long *cr4_p, u32 *deftype_lo_p,
> +			u32 *deftype_hi_p);
> +static void post_set(unsigned long cr4, u32 deftype_lo, u32 deftype_hi);
>  
>  static void __init print_mtrr_state(void)
>  {
> @@ -385,7 +386,8 @@ static void __init print_mtrr_state(void)
>  void __init get_mtrr_state(void)
>  {
>  	struct mtrr_var_range *vrs;
> -	unsigned long flags;
> +	unsigned long flags, cr4;
> +	u32 deftype_lo, deftype_hi;
>  	unsigned lo, dummy;
>  	unsigned int i;
>  
> @@ -420,11 +422,11 @@ void __init get_mtrr_state(void)
>  
>  	/* PAT setup for BP. We need to go through sync steps here */
>  	local_irq_save(flags);
> -	prepare_set();
> +	prepare_set(&cr4, &deftype_lo, &deftype_hi);
>  
>  	pat_init();
>  
> -	post_set();
> +	post_set(cr4, deftype_lo, deftype_hi);
>  	local_irq_restore(flags);
>  }
>  
> @@ -610,15 +612,13 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
>  	return changed;
>  }
>  
> -static u32 deftype_lo, deftype_hi;
> -
>  /**
>   * set_mtrr_state - Set the MTRR state for this CPU.
>   *
>   * NOTE: The CPU must already be in a safe state for MTRR changes.
>   * RETURNS: 0 if no changes made, else a mask indicating what was changed.
>   */
> -static unsigned long set_mtrr_state(void)
> +static unsigned long set_mtrr_state(u32 *deftype_lo_p, u32 *deftype_hi_p)
>  {
>  	unsigned long change_mask = 0;
>  	unsigned int i;
> @@ -635,10 +635,10 @@ static unsigned long set_mtrr_state(void)
>  	 * Set_mtrr_restore restores the old value of MTRRdefType,
>  	 * so to set it we fiddle with the saved value:
>  	 */
> -	if ((deftype_lo & 0xff) != mtrr_state.def_type
> -	    || ((deftype_lo & 0xc00) >> 10) != mtrr_state.enabled) {
> +	if ((*deftype_lo_p & 0xff) != mtrr_state.def_type
> +	    || ((*deftype_lo_p & 0xc00) >> 10) != mtrr_state.enabled) {
>  
> -		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type |
> +		*deftype_lo_p = (*deftype_lo_p & ~0xcff) | mtrr_state.def_type |
>  			     (mtrr_state.enabled << 10);
>  		change_mask |= MTRR_CHANGE_MASK_DEFTYPE;
>  	}
> @@ -647,9 +647,6 @@ static unsigned long set_mtrr_state(void)
>  }
>  
>  
> -static unsigned long cr4;
> -static DEFINE_RAW_SPINLOCK(set_atomicity_lock);
> -
>  /*
>   * Since we are disabling the cache don't allow any interrupts,
>   * they would run extremely slow and would only increase the pain.
> @@ -657,7 +654,8 @@ static DEFINE_RAW_SPINLOCK(set_atomicity_lock);
>   * The caller must ensure that local interrupts are disabled and
>   * are reenabled after post_set() has been called.
>   */
> -static void prepare_set(void) __acquires(set_atomicity_lock)
> +static void prepare_set(unsigned long *cr4_p, u32 *deftype_lo_p,
> +			u32 *deftype_hi_p)
>  {
>  	unsigned long cr0;
>  
> @@ -668,8 +666,6 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
>  	 * changes to the way the kernel boots
>  	 */
>  
> -	raw_spin_lock(&set_atomicity_lock);
> -
>  	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
>  	cr0 = read_cr0() | X86_CR0_CD;
>  	write_cr0(cr0);
> @@ -677,22 +673,22 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
>  
>  	/* Save value of CR4 and clear Page Global Enable (bit 7) */
>  	if (cpu_has_pge) {
> -		cr4 = read_cr4();
> -		write_cr4(cr4 & ~X86_CR4_PGE);
> +		*cr4_p = read_cr4();
> +		write_cr4(*cr4_p & ~X86_CR4_PGE);
>  	}
>  
>  	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
>  	__flush_tlb();
>  
>  	/* Save MTRR state */
> -	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
> +	rdmsr(MSR_MTRRdefType, *deftype_lo_p, *deftype_hi_p);
>  
>  	/* Disable MTRRs, and set the default type to uncached */
> -	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
> +	mtrr_wrmsr(MSR_MTRRdefType, *deftype_lo_p & ~0xcff, *deftype_hi_p);
>  	wbinvd();
>  }
>  
> -static void post_set(void) __releases(set_atomicity_lock)
> +static void post_set(unsigned long cr4, u32 deftype_lo, u32 deftype_hi)
>  {
>  	/* Flush TLBs (no need to flush caches - they are disabled) */
>  	__flush_tlb();
> @@ -706,24 +702,24 @@ static void post_set(void) __releases(set_atomicity_lock)
>  	/* Restore value of CR4 */
>  	if (cpu_has_pge)
>  		write_cr4(cr4);
> -	raw_spin_unlock(&set_atomicity_lock);
>  }
>  
>  static void generic_set_all(void)
>  {
>  	unsigned long mask, count;
> -	unsigned long flags;
> +	unsigned long flags, cr4;
> +	u32 deftype_lo, deftype_hi;
>  
>  	local_irq_save(flags);
> -	prepare_set();
> +	prepare_set(&cr4, &deftype_lo, &deftype_hi);
>  
>  	/* Actually set the state */
> -	mask = set_mtrr_state();
> +	mask = set_mtrr_state(&deftype_lo, &deftype_hi);
>  
>  	/* also set PAT */
>  	pat_init();
>  
> -	post_set();
> +	post_set(cr4, deftype_lo, deftype_hi);
>  	local_irq_restore(flags);
>  
>  	/* Use the atomic bitops to update the global mask */
> @@ -748,13 +744,14 @@ static void generic_set_all(void)
>  static void generic_set_mtrr(unsigned int reg, unsigned long base,
>  			     unsigned long size, mtrr_type type)
>  {
> -	unsigned long flags;
> +	unsigned long flags, cr4;
> +	u32 deftype_lo, deftype_hi;
>  	struct mtrr_var_range *vr;
>  
>  	vr = &mtrr_state.var_ranges[reg];
>  
>  	local_irq_save(flags);
> -	prepare_set();
> +	prepare_set(&cr4, &deftype_lo, &deftype_hi);
>  
>  	if (size == 0) {
>  		/*
> @@ -773,7 +770,7 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
>  		mtrr_wrmsr(MTRRphysMask_MSR(reg), vr->mask_lo, vr->mask_hi);
>  	}
>  
> -	post_set();
> +	post_set(cr4, deftype_lo, deftype_hi);
>  	local_irq_restore(flags);
>  }
>  
