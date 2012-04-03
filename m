Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2DCXv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:51:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21268 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2DCXvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:51:55 -0400
Date: Tue, 3 Apr 2012 19:47:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20120403234702.GD6132@phenom.dumpdata.com>
References: <20120403224529.GA5593@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403224529.GA5593@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F7B8D0E.0034,ss=1,re=3.899,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 12:45:29AM +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

Hey Ingo,

I was wondering what happend to the two patches to fix the regression introduced
by Suresh's patch (the "x86, ioapic: add register checks for bogus io-apic entries")?

I am referring to:
https://lkml.org/lkml/2012/3/28/363
https://lkml.org/lkml/2012/3/28/362

Thanks!
> 
>    HEAD: dba69d1092e291e257fb5673a3ad0e4c87878ebc x86, kvm: Call restore_sched_clock_state() only after %gs is initialized
> 
> 
> out-of-topic modifications in x86-urgent-for-linus:
> ---------------------------------------------------
> drivers/block/floppy.c             # f636520: x86: Remove the ancient and depre
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Andi Kleen (1):
>       x86: Use -mno-avx when available
> 
> Len Brown (1):
>       x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
> 
> Liu, Chuansheng (1):
>       x86: Preserve lazy irq disable semantics in fixup_irqs()
> 
> Marcelo Tosatti (1):
>       x86, kvm: Call restore_sched_clock_state() only after %gs is initialized
> 
> 
>  Documentation/feature-removal-schedule.txt |    8 ------
>  arch/x86/Makefile                          |    1 +
>  arch/x86/include/asm/processor.h           |   10 -------
>  arch/x86/kernel/irq.c                      |    7 ++++-
>  arch/x86/kernel/process.c                  |   24 ------------------
>  arch/x86/power/cpu.c                       |    2 +-
>  drivers/block/floppy.c                     |   36 ----------------------------
>  7 files changed, 8 insertions(+), 80 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 0cad480..7c950d4 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -6,14 +6,6 @@ be removed from this file.
>  
>  ---------------------------
>  
> -What:	x86 floppy disable_hlt
> -When:	2012
> -Why:	ancient workaround of dubious utility clutters the
> -	code used by everybody else.
> -Who:	Len Brown <len.brown@intel.com>
> -
> ----------------------------
> -
>  What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
>  When:	2012
>  Why:	This optional sub-feature of APM is of dubious reliability,
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 968dbe2..41a7237 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -129,6 +129,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
>  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  # prevent gcc from generating any FP code by mistake
>  KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
> +KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
>  
>  KBUILD_CFLAGS += $(mflags-y)
>  KBUILD_AFLAGS += $(mflags-y)
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 7284c9a..4fa7dcc 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -974,16 +974,6 @@ extern bool cpu_has_amd_erratum(const int *);
>  #define cpu_has_amd_erratum(x)	(false)
>  #endif /* CONFIG_CPU_SUP_AMD */
>  
> -#ifdef CONFIG_X86_32
> -/*
> - * disable hlt during certain critical i/o operations
> - */
> -#define HAVE_DISABLE_HLT
> -#endif
> -
> -void disable_hlt(void);
> -void enable_hlt(void);
> -
>  void cpu_idle_wait(void);
>  
>  extern unsigned long arch_align_stack(unsigned long sp);
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 7943e0c..3dafc60 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -282,8 +282,13 @@ void fixup_irqs(void)
>  		else if (!(warned++))
>  			set_affinity = 0;
>  
> +		/*
> +		 * We unmask if the irq was not marked masked by the
> +		 * core code. That respects the lazy irq disable
> +		 * behaviour.
> +		 */
>  		if (!irqd_can_move_in_process_context(data) &&
> -		    !irqd_irq_disabled(data) && chip->irq_unmask)
> +		    !irqd_irq_masked(data) && chip->irq_unmask)
>  			chip->irq_unmask(data);
>  
>  		raw_spin_unlock(&desc->lock);
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index a33afaa..1d92a5a 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -362,34 +362,10 @@ void (*pm_idle)(void);
>  EXPORT_SYMBOL(pm_idle);
>  #endif
>  
> -#ifdef CONFIG_X86_32
> -/*
> - * This halt magic was a workaround for ancient floppy DMA
> - * wreckage. It should be safe to remove.
> - */
> -static int hlt_counter;
> -void disable_hlt(void)
> -{
> -	hlt_counter++;
> -}
> -EXPORT_SYMBOL(disable_hlt);
> -
> -void enable_hlt(void)
> -{
> -	hlt_counter--;
> -}
> -EXPORT_SYMBOL(enable_hlt);
> -
> -static inline int hlt_use_halt(void)
> -{
> -	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
> -}
> -#else
>  static inline int hlt_use_halt(void)
>  {
>  	return 1;
>  }
> -#endif
>  
>  #ifndef CONFIG_SMP
>  static inline void play_dead(void)
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index 4793683..218cdb1 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -225,13 +225,13 @@ static void __restore_processor_state(struct saved_context *ctxt)
>  	fix_processor_context();
>  
>  	do_fpu_end();
> +	x86_platform.restore_sched_clock_state();
>  	mtrr_bp_restore();
>  }
>  
>  /* Needed by apm.c */
>  void restore_processor_state(void)
>  {
> -	x86_platform.restore_sched_clock_state();
>  	__restore_processor_state(&saved_context);
>  }
>  #ifdef CONFIG_X86_32
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 76a0823..b0b00d7 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -1030,37 +1030,6 @@ static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
>  	return 0;
>  }
>  
> -static DEFINE_SPINLOCK(floppy_hlt_lock);
> -static int hlt_disabled;
> -static void floppy_disable_hlt(void)
> -{
> -	unsigned long flags;
> -
> -	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
> -	spin_lock_irqsave(&floppy_hlt_lock, flags);
> -	if (!hlt_disabled) {
> -		hlt_disabled = 1;
> -#ifdef HAVE_DISABLE_HLT
> -		disable_hlt();
> -#endif
> -	}
> -	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
> -}
> -
> -static void floppy_enable_hlt(void)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&floppy_hlt_lock, flags);
> -	if (hlt_disabled) {
> -		hlt_disabled = 0;
> -#ifdef HAVE_DISABLE_HLT
> -		enable_hlt();
> -#endif
> -	}
> -	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
> -}
> -
>  static void setup_DMA(void)
>  {
>  	unsigned long f;
> @@ -1105,7 +1074,6 @@ static void setup_DMA(void)
>  	fd_enable_dma();
>  	release_dma_lock(f);
>  #endif
> -	floppy_disable_hlt();
>  }
>  
>  static void show_floppy(void);
> @@ -1707,7 +1675,6 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
>  	fd_disable_dma();
>  	release_dma_lock(f);
>  
> -	floppy_enable_hlt();
>  	do_floppy = NULL;
>  	if (fdc >= N_FDC || FDCS->address == -1) {
>  		/* we don't even know which FDC is the culprit */
> @@ -1856,8 +1823,6 @@ static void floppy_shutdown(unsigned long data)
>  		show_floppy();
>  	cancel_activity();
>  
> -	floppy_enable_hlt();
> -
>  	flags = claim_dma_lock();
>  	fd_disable_dma();
>  	release_dma_lock(flags);
> @@ -4508,7 +4473,6 @@ static void floppy_release_irq_and_dma(void)
>  #if N_FDC > 1
>  	set_dor(1, ~8, 0);
>  #endif
> -	floppy_enable_hlt();
>  
>  	if (floppy_track_buffer && max_buffer_sectors) {
>  		tmpsize = max_buffer_sectors * 1024;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
