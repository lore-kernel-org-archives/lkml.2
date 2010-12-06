Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0LFACH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:02:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43125 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0LFACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:02:04 -0500
Date: Mon, 6 Dec 2010 00:01:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Gary King <gking@nvidia.com>,
        Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/21] ARM: tegra: Add suspend and hotplug support
Message-ID: <20101206000141.GC22824@n2100.arm.linux.org.uk>
References: <1291590548-7341-1-git-send-email-ccross@android.com> <1291590548-7341-13-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291590548-7341-13-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 03:08:59PM -0800, Colin Cross wrote:
>  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-t2-tables.o
> -obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
> -obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
> +obj-$(CONFIG_SMP)                       += localtimer.o

This wants to be CONFIG_LOCAL_TIMERS, not CONFIG_SMP.  Local timer support
is dependent on CONFIG_LOCAL_TIMERS being set.

> +#ifdef CONFIG_VFPv3
> +	orr	r2, r3, #0xF00000
> +	mcr	p15, 0, r2, c1, c0, 2	@ enable access to FPU
> +	VFPFMRX	r2, FPEXC
> +	str	r2, [r8, #CTX_FPEXC]
> +	mov	r1, #0x40000000		@ enable access to FPU
> +	VFPFMXR	FPEXC, r1
> +	VFPFMRX	r1, FPSCR
> +	str	r1, [r8, #CTX_FPSCR]
> +	isb
> +	add	r9, r8, #CTX_VFP_REGS
> +
> +	VFPFSTMIA r9, r12	@ save out (16 or 32)*8B of FPU registers
> +	VFPFMXR	FPEXC, r2
> +	mrc	p15, 0, r3, c1, c0, 2	@ restore original FPEXC/CPACR
> +#endif

There's already functions provided for saving/restoring VFP state.  Please
use them rather than inventing a different method.

> +	cps	0x1f			@ SYS mode
> +	add	r9, r8, #CTX_SYS_SP
> +	stmia	r9, {sp,lr}
> +
> +	cps	0x17			@ Abort mode
> +	mrs	r12, spsr
> +	add	r9, r8, #CTX_ABT_SPSR
> +	stmia	r9, {r12,sp,lr}
> +
> +	cps	0x12			@ IRQ mode
> +	mrs	r12, spsr
> +	add	r9, r8, #CTX_IRQ_SPSR
> +	stmia	r9, {r12,sp,lr}
> +
> +	cps	0x1b			@ Undefined mode
> +	mrs	r12, spsr
> +	add	r9, r8, #CTX_UND_SPSR
> +	stmia	r9, {r12,sp,lr}
> +
> +	mov	r0, r8
> +	add	r1, r8, #CTX_FIQ_SPSR
> +	cps	0x11			@ FIQ mode
> +	mrs	r7, spsr
> +	stmia	r1, {r7-r12,sp,lr}

Same old mistakes...  Take a look at what we put in these registers,
and then go and look at cpu_init(), and ask whether you really need
to save all this.

> +	add	r9, r8, #CTS_CP14_BKPT_0
> +	mrc	p14, 0, r2, c0, c0, 4
> +	mrc	p14, 0, r3, c0, c0, 5
> +	stmia	r9!, {r2-r3}     	@ BRKPT_0
> +	mrc	p14, 0, r2, c0, c1, 4
> +	mrc	p14, 0, r3, c0, c1, 5
> +	stmia	r9!, {r2-r3}     	@ BRKPT_0
> +	mrc	p14, 0, r2, c0, c2, 4
> +	mrc	p14, 0, r3, c0, c2, 5
> +	stmia	r9!, {r2-r3}     	@ BRKPT_0
> +	mrc	p14, 0, r2, c0, c3, 4
> +	mrc	p14, 0, r3, c0, c3, 5
> +	stmia	r9!, {r2-r3}     	@ BRKPT_0
> +	mrc	p14, 0, r2, c0, c4, 4
> +	mrc	p14, 0, r3, c0, c4, 5
> +	stmia	r9!, {r2-r3}     	@ BRKPT_0
> +	mrc	p14, 0, r2, c0, c5, 4
> +	mrc	p14, 0, r3, c0, c5, 5
> +	stmia	r9!, {r2-r3}     	@ BRKPT_0
> +
> +	add	r9, r8, #CTS_CP14_WPT_0
> +	mrc	p14, 0, r2, c0, c0, 6
> +	mrc	p14, 0, r3, c0, c0, 7
> +	stmia	r9!, {r2-r3}     	@ WPT_0
> +	mrc	p14, 0, r2, c0, c1, 6
> +	mrc	p14, 0, r3, c0, c1, 7
> +	stmia	r9!, {r2-r3}     	@ WPT_0
> +	mrc	p14, 0, r2, c0, c2, 6
> +	mrc	p14, 0, r3, c0, c2, 7
> +	stmia	r9!, {r2-r3}     	@ WPT_0
> +	mrc	p14, 0, r2, c0, c3, 6
> +	mrc	p14, 0, r3, c0, c3, 7
> +	stmia	r9!, {r2-r3}     	@ WPT_0

Breakpoint and watchdog registers should be handled by the perf code.
If not, it needs to be added there, rather than inventing your own here.

> +#ifdef CONFIG_CACHE_L2X0
> +	cpu_id	r4
> +	cmp	r4, #0
> +	bne	__cortex_a9_save_clean_cache
> +	mov32	r4, (TEGRA_ARM_PL310_BASE-IO_CPU_PHYS+IO_CPU_VIRT)
> +	add	r9, r8, #CTX_L2_CTRL
> +	ldr	r0, [r4, #L2X0_CTRL]
> +	ldr	r1, [r4, #L2X0_AUX_CTRL]
> +	ldr	r2, [r4, #L2X0_TAG_LATENCY_CTRL]
> +	ldr	r3, [r4, #L2X0_DATA_LATENCY_CTRL]
> +	ldr	r4, [r4, #L2X0_PREFETCH_CTRL]
> +	stmia	r9, {r0-r4}
> +#endif

PM support needs to be added to the L2x0 support code.

> +#ifdef CONFIG_HOTPLUG_CPU
> +static DEFINE_PER_CPU(struct completion, cpu_killed);
> +extern void tegra_hotplug_startup(void);
> +#endif

You don't need a per-CPU cpu_killed completion.  Only one CPU can be
taken offline at a time - it's serialized by the cpu_add_remove_lock
mutex.

In any case, as a result of my cleanups, this is now in core code.

> +
> +static DECLARE_BITMAP(cpu_init_bits, CONFIG_NR_CPUS) __read_mostly;
> +const struct cpumask *const cpu_init_mask = to_cpumask(cpu_init_bits);
> +#define cpu_init_map (*(cpumask_t *)cpu_init_mask)
> +
>  #define EVP_CPU_RESET_VECTOR \
>  	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
>  #define CLK_RST_CONTROLLER_CLK_CPU_CMPLX \
>  	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x4c)
> +#define CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET \
> +	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x340)
>  #define CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR \
>  	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x344)
>  
>  void __cpuinit platform_secondary_init(unsigned int cpu)
>  {
>  	trace_hardirqs_off();

This has also been moved to core code.

> -
> -	/*
> -	 * if any interrupts are already enabled for the primary
> -	 * core (e.g. timer irq), then they will not have been enabled
> -	 * for us: do so
> -	 */
>  	gic_cpu_init(0, IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x100);
> -
>  	/*
>  	 * Synchronise with the boot thread.
>  	 */
>  	spin_lock(&boot_lock);
> +#ifdef CONFIG_HOTPLUG_CPU
> +	cpu_set(cpu, cpu_init_map);
> +	INIT_COMPLETION(per_cpu(cpu_killed, cpu));
> +#endif
>  	spin_unlock(&boot_lock);
>  }
>  
> @@ -70,27 +89,30 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
>  	 */
>  	spin_lock(&boot_lock);
>  
> -
>  	/* set the reset vector to point to the secondary_startup routine */
> +#ifdef CONFIG_HOTPLUG_CPU
> +	if (cpumask_test_cpu(cpu, cpu_init_mask))
> +		boot_vector = virt_to_phys(tegra_hotplug_startup);
> +	else
> +#endif
> +		boot_vector = virt_to_phys(tegra_secondary_startup);
> +
> +	smp_wmb();
>  
> -	boot_vector = virt_to_phys(tegra_secondary_startup);
>  	old_boot_vector = readl(EVP_CPU_RESET_VECTOR);
>  	writel(boot_vector, EVP_CPU_RESET_VECTOR);
>  
> -	/* enable cpu clock on cpu1 */
> +	/* enable cpu clock on cpu */
>  	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
> -	writel(reg & ~(1<<9), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
> +	writel(reg & ~(1<<(8+cpu)), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
>  
> -	reg = (1<<13) | (1<<9) | (1<<5) | (1<<1);
> +	reg = 0x1111<<cpu;
>  	writel(reg, CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR);
>  
> -	smp_wmb();
> -	flush_cache_all();
> -
>  	/* unhalt the cpu */
> -	writel(0, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE) + 0x14);
> +	writel(0, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE) + 0x14 + 0x8*(cpu-1));
>  
> -	timeout = jiffies + (1 * HZ);
> +	timeout = jiffies + HZ;
>  	while (time_before(jiffies, timeout)) {
>  		if (readl(EVP_CPU_RESET_VECTOR) != boot_vector)
>  			break;
> @@ -142,6 +164,12 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  	for (i = 0; i < max_cpus; i++)
>  		set_cpu_present(i, true);
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +	for_each_present_cpu(i) {
> +		init_completion(&per_cpu(cpu_killed, i));
> +	}
> +#endif
> +
>  	/*
>  	 * Initialise the SCU if there are more than one CPU and let
>  	 * them know where to start. Note that, on modern versions of
> @@ -154,3 +182,71 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  		scu_enable(scu_base);
>  	}
>  }
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +
> +extern void vfp_sync_state(struct thread_info *thread);

Looks unused, and in any case is not necessary.  With SMP, we always
save the VFP state when switching away from a task, and that includes
when we switch to the idle task.  We can only go offline from the idle
task, so we've already saved the VFP state - specific to the last running
thread which used VFP - safely away.

> +
> +void __cpuinit secondary_start_kernel(void);
> +
> +int platform_cpu_kill(unsigned int cpu)
> +{
> +	unsigned int reg;
> +	int e;
> +
> +	e = wait_for_completion_timeout(&per_cpu(cpu_killed, cpu), 100);
> +	printk(KERN_NOTICE "CPU%u: %s shutdown\n", cpu, (e) ? "clean":"forced");
> +
> +	if (e) {
> +		do {
> +			reg = readl(CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
> +			cpu_relax();
> +		} while (!(reg & (1<<cpu)));
> +	} else {
> +		writel(0x1111<<cpu, CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
> +		/* put flow controller in WAIT_EVENT mode */
> +		writel(2<<29, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE)+0x14 + 0x8*(cpu-1));
> +	}
> +	spin_lock(&boot_lock);
> +	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
> +	writel(reg | (1<<(8+cpu)), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
> +	spin_unlock(&boot_lock);
> +	return e;
> +}
> +
> +void platform_cpu_die(unsigned int cpu)
> +{
> +#ifdef DEBUG
> +	unsigned int this_cpu = hard_smp_processor_id();
> +
> +	if (cpu != this_cpu) {
> +		printk(KERN_CRIT "Eek! platform_cpu_die running on %u, should be %u\n",
> +			   this_cpu, cpu);
> +		BUG();
> +	}
> +#endif
> +
> +	gic_cpu_exit(0);
> +	barrier();
> +	complete(&per_cpu(cpu_killed, cpu));
> +	flush_cache_all();
> +	barrier();
> +	__cortex_a9_save(0);
> +
> +	/* return happens from __cortex_a9_restore */
> +	barrier();
> +	writel(smp_processor_id(), EVP_CPU_RESET_VECTOR);

Hopefully it doesn't return here - if you can take the core offline
properly, you should restore it by effectively rebooting it.

> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +
> +#include <asm/io.h>

linux/io.h (and any other places in this patch set which also have asm/io.h
includes.)

> +
> +#include <mach/gpio.h>

linux/gpio.h (and any other places which have mach/gpio.h)

> +	unsigned int flags = PMD_TYPE_SECT | PMD_SECT_AP_WRITE |
> +		PMD_SECT_WBWA | PMD_SECT_S;
> +
> +	tegra_pgd = pgd_alloc(&init_mm);
> +	if (!tegra_pgd)
> +		return -ENOMEM;
> +
> +	for (i=0; i<ARRAY_SIZE(addr_p); i++) {
> +		unsigned long v = addr_v[i];
> +		pmd = pmd_offset(tegra_pgd + pgd_index(v), v);
> +		*pmd = __pmd((addr_p[i] & PGDIR_MASK) | flags);
> +		flush_pmd_entry(pmd);
> +		outer_clean_range(__pa(pmd), __pa(pmd + 1));
> +	}
> +
> +	tegra_pgd_phys = virt_to_phys(tegra_pgd);
> +	__cpuc_flush_dcache_area(&tegra_pgd_phys,
> +		sizeof(tegra_pgd_phys));
> +	outer_clean_range(__pa(&tegra_pgd_phys),
> +		__pa(&tegra_pgd_phys+1));
> +
> +	__cpuc_flush_dcache_area(&tegra_context_area,
> +		sizeof(tegra_context_area));
> +	outer_clean_range(__pa(&tegra_context_area),
> +		__pa(&tegra_context_area+1));

Eww, no.  We should have this as a separate API.  It's also not
checkpatch-clean.

> +
> +	return 0;
> +}
> +
> +
> +
> +/*
> + * suspend_cpu_complex
> + *
> + *   disable periodic IRQs used for DVFS to prevent suspend wakeups
> + *   disable coresight debug interface
> + *
> + *
> + */
> +static noinline void restore_cpu_complex(void)

Comment doesn't match function.

> +{
> +	unsigned int reg;
> +
> +	/* restore original burst policy setting; PLLX state restored
> +	 * by CPU boot-up code - wait for PLL stabilization if PLLX
> +	 * was enabled, or if explicitly requested by caller */
> +
> +	BUG_ON(readl(clk_rst + CLK_RESET_PLLX_BASE) != tegra_sctx.pllx_base);
> +
> +	if (tegra_sctx.pllx_base & (1<<30)) {
> +		while (readl(tmrus)-tegra_sctx.pll_timeout >= 0x80000000UL)
> +			cpu_relax();
> +	}
> +	writel(tegra_sctx.cclk_divider, clk_rst + CLK_RESET_CCLK_DIVIDER);
> +	writel(tegra_sctx.cpu_burst, clk_rst + CLK_RESET_CCLK_BURST);
> +	writel(tegra_sctx.clk_csite_src, clk_rst + CLK_RESET_SOURCE_CSITE);
> +
> +	/* do not power-gate the CPU when flow controlled */
> +	reg = readl(flow_ctrl + FLOW_CTRL_CPU_CSR);
> +	reg &= ~((1<<5) | (1<<4) | 1); /* clear WFE bitmask */
> +	reg |= (1<<14); /* write-1-clear event flag */
> +	writel(reg, flow_ctrl + FLOW_CTRL_CPU_CSR);
> +	wmb();
> +
> +#ifdef CONFIG_HAVE_ARM_TWD
> +	writel(tegra_sctx.twd_ctrl, twd_base + 0x8);
> +	writel(tegra_sctx.twd_load, twd_base + 0);
> +#endif
> +
> +	gic_dist_restore(0);
> +	get_irq_chip(IRQ_LOCALTIMER)->unmask(IRQ_LOCALTIMER);
> +
> +	enable_irq(INT_SYS_STATS_MON);
> +}
> +
> +static noinline void suspend_cpu_complex(void)
> +{
> +	unsigned int reg;
> +	int i;
> +
> +	disable_irq(INT_SYS_STATS_MON);
> +
> +	/* switch coresite to clk_m, save off original source */
> +	tegra_sctx.clk_csite_src = readl(clk_rst + CLK_RESET_SOURCE_CSITE);
> +	writel(3<<30, clk_rst + CLK_RESET_SOURCE_CSITE);
> +
> +	tegra_sctx.cpu_burst = readl(clk_rst + CLK_RESET_CCLK_BURST);
> +	tegra_sctx.pllx_base = readl(clk_rst + CLK_RESET_PLLX_BASE);
> +	tegra_sctx.pllx_misc = readl(clk_rst + CLK_RESET_PLLX_MISC);
> +	tegra_sctx.pllp_base = readl(clk_rst + CLK_RESET_PLLP_BASE);
> +	tegra_sctx.pllp_outa = readl(clk_rst + CLK_RESET_PLLP_OUTA);
> +	tegra_sctx.pllp_outb = readl(clk_rst + CLK_RESET_PLLP_OUTB);
> +	tegra_sctx.pllp_misc = readl(clk_rst + CLK_RESET_PLLP_MISC);
> +	tegra_sctx.cclk_divider = readl(clk_rst + CLK_RESET_CCLK_DIVIDER);
> +
> +#ifdef CONFIG_HAVE_ARM_TWD
> +	tegra_sctx.twd_ctrl = readl(twd_base + 0x8);
> +	tegra_sctx.twd_load = readl(twd_base + 0);
> +	local_timer_stop();
> +#endif
> +
> +	reg = readl(flow_ctrl + FLOW_CTRL_CPU_CSR);
> +	/* clear any pending events, set the WFE bitmap to specify just
> +	 * CPU0, and clear any pending events for this CPU */
> +	reg &= ~(1<<5); /* clear CPU1 WFE */
> +	reg |= (1<<14) | (1<<4) | 1; /* enable CPU0 WFE */
> +	writel(reg, flow_ctrl + FLOW_CTRL_CPU_CSR);
> +	wmb();
> +
> +	for (i=1; i<num_present_cpus(); i++) {
> +		unsigned int offs = FLOW_CTRL_CPU1_CSR + (i-1)*8;
> +		reg = readl(flow_ctrl + offs);
> +		writel(reg | (1<<14), flow_ctrl + offs);
> +		wmb();
> +	}
> +
> +	gic_cpu_exit(0);
> +	gic_dist_save(0);
> +}
> +
> +unsigned int tegra_suspend_lp2(unsigned int us)
> +{
> +	unsigned int mode;
> +	unsigned long orig, reg;
> +	unsigned int remain;
> +
> +	reg = readl(pmc + PMC_CTRL);
> +	mode = (reg >> TEGRA_POWER_PMC_SHIFT) & TEGRA_POWER_PMC_MASK;
> +	mode |= TEGRA_POWER_CPU_PWRREQ_OE;
> +	if (pdata->separate_req)
> +		mode |= TEGRA_POWER_PWRREQ_OE;
> +	else
> +		mode &= ~TEGRA_POWER_PWRREQ_OE;
> +	mode &= ~TEGRA_POWER_EFFECT_LP0;
> +
> +	orig = readl(evp_reset);
> +	writel(virt_to_phys(tegra_lp2_startup), evp_reset);
> +
> +	set_power_timers(pdata->cpu_timer, pdata->cpu_off_timer,
> +			 clk_get_rate(tegra_pclk));
> +
> +	if (us)
> +		tegra_lp2_set_trigger(us);
> +
> +	suspend_cpu_complex();
> +	flush_cache_all();
> +	/* structure is written by reset code, so the L2 lines
> +	 * must be invalidated */
> +	outer_flush_range(__pa(&tegra_sctx),__pa(&tegra_sctx+1));
> +	barrier();
> +
> +	__cortex_a9_save(mode);
> +	/* return from __cortex_a9_restore */
> +	barrier();
> +	restore_cpu_complex();
> +
> +	remain = tegra_lp2_timer_remain();
> +	if (us)
> +		tegra_lp2_set_trigger(0);
> +
> +	writel(orig, evp_reset);
> +
> +	return remain;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +/* ensures that sufficient time is passed for a register write to
> + * serialize into the 32KHz domain */
> +static void pmc_32kwritel(u32 val, unsigned long offs)
> +{
> +	writel(val, pmc + offs);
> +	udelay(130);
> +}
> +
> +static u8 *iram_save = NULL;
> +static unsigned int iram_save_size = 0;
> +static void __iomem *iram_code = IO_ADDRESS(TEGRA_IRAM_CODE_AREA);
> +
> +static void tegra_suspend_dram(bool do_lp0)
> +{
> +	unsigned int mode = TEGRA_POWER_SDRAM_SELFREFRESH;
> +	unsigned long orig, reg;
> +
> +	orig = readl(evp_reset);
> +	/* copy the reset vector and SDRAM shutdown code into IRAM */
> +	memcpy(iram_save, iram_code, iram_save_size);
> +	memcpy(iram_code, (void *)__tegra_lp1_reset, iram_save_size);
> +
> +	set_power_timers(pdata->cpu_timer, pdata->cpu_off_timer, 32768);
> +
> +	reg = readl(pmc + PMC_CTRL);
> +	mode |= ((reg >> TEGRA_POWER_PMC_SHIFT) & TEGRA_POWER_PMC_MASK);
> +
> +	if (!do_lp0) {
> +		writel(TEGRA_IRAM_CODE_AREA, evp_reset);
> +
> +		mode |= TEGRA_POWER_CPU_PWRREQ_OE;
> +		if (pdata->separate_req)
> +			mode |= TEGRA_POWER_PWRREQ_OE;
> +		else
> +			mode &= ~TEGRA_POWER_PWRREQ_OE;
> +		mode &= ~TEGRA_POWER_EFFECT_LP0;
> +
> +		tegra_legacy_irq_set_lp1_wake_mask();
> +	} else {
> +		u32 boot_flag = readl(pmc + PMC_SCRATCH0);
> +		pmc_32kwritel(boot_flag | 1, PMC_SCRATCH0);
> +		pmc_32kwritel(wb0_restore, PMC_SCRATCH1);
> +		writel(0x0, pmc + PMC_SCRATCH39);
> +		mode |= TEGRA_POWER_CPU_PWRREQ_OE;
> +		mode |= TEGRA_POWER_PWRREQ_OE;
> +		mode |= TEGRA_POWER_EFFECT_LP0;
> +
> +		/* for platforms where the core & CPU power requests are
> +		 * combined as a single request to the PMU, transition to
> +		 * LP0 state by temporarily enabling both requests
> +		 */
> +		if (!pdata->separate_req) {
> +			reg |= ((mode & TEGRA_POWER_PMC_MASK) <<
> +				TEGRA_POWER_PMC_SHIFT);
> +			pmc_32kwritel(reg, PMC_CTRL);
> +			mode &= ~TEGRA_POWER_CPU_PWRREQ_OE;
> +		}
> +
> +		tegra_set_lp0_wake_pads(pdata->wake_enb, pdata->wake_high,
> +			pdata->wake_any);
> +	}
> +
> +	suspend_cpu_complex();
> +	flush_cache_all();
> +	outer_flush_all();
> +	outer_disable();
> +
> +	__cortex_a9_save(mode);
> +	restore_cpu_complex();
> +
> +	writel(orig, evp_reset);
> +	tegra_init_cache();
> +
> +	if (!do_lp0) {
> +		memcpy(iram_code, iram_save, iram_save_size);
> +		tegra_legacy_irq_restore_mask();
> +	} else {
> +		/* for platforms where the core & CPU power requests are
> +		 * combined as a single request to the PMU, transition out
> +		 * of LP0 state by temporarily enabling both requests
> +		 */
> +		if (!pdata->separate_req) {
> +			reg = readl(pmc + PMC_CTRL);
> +			reg |= (TEGRA_POWER_CPU_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
> +			pmc_32kwritel(reg, PMC_CTRL);
> +			reg &= ~(TEGRA_POWER_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
> +			writel(reg, pmc + PMC_CTRL);
> +		}
> +	}
> +
> +	wmb();
> +}
> +
> +static int tegra_suspend_prepare_late(void)
> +{
> +	disable_irq(INT_SYS_STATS_MON);
> +	return 0;
> +}
> +
> +static void tegra_suspend_wake(void)
> +{
> +	enable_irq(INT_SYS_STATS_MON);
> +}
> +
> +static u8 uart_state[5];
> +
> +static int tegra_debug_uart_suspend(void)
> +{
> +	void __iomem *uart;
> +	u32 lcr;
> +
> +	if (TEGRA_DEBUG_UART_BASE == 0)
> +		return 0;
> +
> +	uart = IO_ADDRESS(TEGRA_DEBUG_UART_BASE);
> +
> +	lcr = readb(uart + UART_LCR * 4);
> +
> +	uart_state[0] = lcr;
> +	uart_state[1] = readb(uart + UART_MCR * 4);
> +
> +	/* DLAB = 0 */
> +	writeb(lcr & ~UART_LCR_DLAB, uart + UART_LCR * 4);
> +
> +	uart_state[2] = readb(uart + UART_IER * 4);
> +
> +	/* DLAB = 1 */
> +	writeb(lcr | UART_LCR_DLAB, uart + UART_LCR * 4);
> +
> +	uart_state[3] = readb(uart + UART_DLL * 4);
> +	uart_state[4] = readb(uart + UART_DLM * 4);
> +
> +	writeb(lcr, uart + UART_LCR * 4);
> +
> +	return 0;
> +}
> +
> +static void tegra_debug_uart_resume(void)
> +{
> +	void __iomem *uart;
> +	u32 lcr;
> +
> +	if (TEGRA_DEBUG_UART_BASE == 0)
> +		return;
> +
> +	uart = IO_ADDRESS(TEGRA_DEBUG_UART_BASE);
> +
> +	lcr = uart_state[0];
> +
> +	writeb(uart_state[1], uart + UART_MCR * 4);
> +
> +	/* DLAB = 0 */
> +	writeb(lcr & ~UART_LCR_DLAB, uart + UART_LCR * 4);
> +
> +	writeb(uart_state[2], uart + UART_IER * 4);
> +
> +	/* DLAB = 1 */
> +	writeb(lcr | UART_LCR_DLAB, uart + UART_LCR * 4);
> +
> +	writeb(uart_state[3], uart + UART_DLL * 4);
> +	writeb(uart_state[4], uart + UART_DLM * 4);
> +
> +	writeb(lcr, uart + UART_LCR * 4);
> +}
> +
> +#define MC_SECURITY_START	0x6c
> +#define MC_SECURITY_SIZE	0x70
> +
> +static int tegra_suspend_enter(suspend_state_t state)
> +{
> +	struct irq_desc *desc;
> +	void __iomem *mc = IO_ADDRESS(TEGRA_MC_BASE);
> +	unsigned long flags;
> +	u32 mc_data[2];
> +	int irq;
> +	bool do_lp0 = (current_suspend_mode == TEGRA_SUSPEND_LP0);
> +	bool do_lp2 = (current_suspend_mode == TEGRA_SUSPEND_LP2);
> +	int lp_state;
> +	u64 rtc_before;
> +	u64 rtc_after;
> +	u64 secs;
> +	u32 ms;
> +
> +	if (do_lp2)
> +		lp_state = 2;
> +	else if (do_lp0)
> +		lp_state = 0;
> +	else
> +		lp_state = 1;
> +
> +	local_irq_save(flags);
> +	local_fiq_disable();
> +
> +	pr_info("Entering suspend state LP%d\n", lp_state);
> +	if (do_lp0) {
> +		tegra_irq_suspend();
> +		tegra_dma_suspend();
> +		tegra_debug_uart_suspend();
> +		tegra_pinmux_suspend();
> +		tegra_timer_suspend();
> +		tegra_gpio_suspend();
> +		tegra_clk_suspend();
> +
> +		mc_data[0] = readl(mc + MC_SECURITY_START);
> +		mc_data[1] = readl(mc + MC_SECURITY_SIZE);
> +	}
> +
> +	for_each_irq_desc(irq, desc) {
> +		if ((desc->status & IRQ_WAKEUP) &&
> +		    (desc->status & IRQ_SUSPENDED)) {
> +			get_irq_chip(irq)->unmask(irq);
> +		}
> +	}
> +
> +	rtc_before = tegra_rtc_read_ms();
> +
> +	if (do_lp2)
> +		tegra_suspend_lp2(0);
> +	else
> +		tegra_suspend_dram(do_lp0);
> +
> +	rtc_after = tegra_rtc_read_ms();
> +
> +	for_each_irq_desc(irq, desc) {
> +		if ((desc->status & IRQ_WAKEUP) &&
> +		    (desc->status & IRQ_SUSPENDED)) {
> +			get_irq_chip(irq)->mask(irq);
> +		}
> +	}
> +
> +	/* Clear DPD sample */
> +	writel(0x0, pmc + PMC_DPD_SAMPLE);
> +
> +	if (do_lp0) {
> +		writel(mc_data[0], mc + MC_SECURITY_START);
> +		writel(mc_data[1], mc + MC_SECURITY_SIZE);
> +
> +		tegra_clk_resume();
> +		tegra_gpio_resume();
> +		tegra_timer_resume();
> +		tegra_pinmux_resume();
> +		tegra_debug_uart_resume();
> +		tegra_dma_resume();
> +		tegra_irq_resume();
> +	}
> +
> +	secs = rtc_after - rtc_before;
> +	ms = do_div(secs, 1000);
> +	pr_info("Suspended for %llu.%03u seconds\n", secs, ms);
> +
> +	tegra_time_in_suspend[time_to_bin(secs)]++;
> +
> +	local_fiq_enable();
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> +
> +static struct platform_suspend_ops tegra_suspend_ops = {
> +	.valid		= suspend_valid_only_mem,
> +	.prepare_late	= tegra_suspend_prepare_late,
> +	.wake		= tegra_suspend_wake,
> +	.enter		= tegra_suspend_enter,
> +};
> +#endif
> +
> +static unsigned long lp0_vec_orig_start = 0;
> +static unsigned long lp0_vec_orig_size = 0;
> +
> +static int __init tegra_lp0_vec_arg(char *options)
> +{
> +	char *p = options;
> +
> +	lp0_vec_orig_size = memparse(p, &p);
> +	if (*p == '@')
> +		lp0_vec_orig_start = memparse(p+1, &p);
> +
> +	return 0;
> +}
> +__setup("lp0_vec=", tegra_lp0_vec_arg);
> +
> +void __init tegra_init_suspend(struct tegra_suspend_platform_data *plat)
> +{
> +	u32 reg, mode;
> +
> +	tegra_pclk = clk_get_sys(NULL, "pclk");
> +	BUG_ON(!tegra_pclk);
> +	pdata = plat;
> +	(void)reg;
> +	(void)mode;
> +
> +	if (plat->suspend_mode == TEGRA_SUSPEND_LP0 &&
> +			lp0_vec_orig_size && lp0_vec_orig_start) {
> +		unsigned char *reloc_lp0;
> +		unsigned long tmp;
> +		void __iomem *orig;
> +		reloc_lp0 = kmalloc(lp0_vec_orig_size+L1_CACHE_BYTES-1,
> +				    GFP_KERNEL);
> +		WARN_ON(!reloc_lp0);
> +		if (!reloc_lp0)
> +			goto out;
> +
> +		orig = ioremap(lp0_vec_orig_start, lp0_vec_orig_size);
> +		WARN_ON(!orig);
> +		if (!orig) {
> +			kfree(reloc_lp0);
> +			goto out;
> +		}
> +		tmp = (unsigned long) reloc_lp0;
> +		tmp = (tmp + L1_CACHE_BYTES - 1) & ~(L1_CACHE_BYTES-1);
> +		reloc_lp0 = (unsigned char *)tmp;
> +		memcpy(reloc_lp0, orig, lp0_vec_orig_size);
> +		iounmap(orig);
> +		wb0_restore = virt_to_phys(reloc_lp0);
> +	}
> +out:
> +	if (plat->suspend_mode == TEGRA_SUSPEND_LP0 && !wb0_restore) {
> +		pr_warning("Suspend mode LP0 requested, but missing lp0_vec\n");
> +		pr_warning("Disabling LP0\n");
> +		plat->suspend_mode = TEGRA_SUSPEND_LP1;
> +	}
> +
> +	tegra_context_area = kzalloc(CONTEXT_SIZE_BYTES * NR_CPUS, GFP_KERNEL);
> +
> +	if (tegra_context_area && create_suspend_pgtable()) {
> +		kfree(tegra_context_area);
> +		tegra_context_area = NULL;
> +	}
> +
> +#ifdef CONFIG_PM
> +	iram_save_size = (unsigned long)__tegra_iram_end;
> +	iram_save_size -= (unsigned long)__tegra_lp1_reset;
> +
> +	iram_save = kmalloc(iram_save_size, GFP_KERNEL);
> +	if (!iram_save) {
> +		pr_err("%s: unable to allocate memory for SDRAM self-refresh "
> +		       "LP0/LP1 unavailable\n", __func__);
> +		plat->suspend_mode = TEGRA_SUSPEND_LP2;
> +	}
> +	/* CPU reset vector for LP0 and LP1 */
> +	writel(virt_to_phys(tegra_lp2_startup), pmc + PMC_SCRATCH41);
> +
> +	/* Always enable CPU power request; just normal polarity is supported */
> +	reg = readl(pmc + PMC_CTRL);
> +	BUG_ON(reg & (TEGRA_POWER_CPU_PWRREQ_POLARITY << TEGRA_POWER_PMC_SHIFT));
> +	reg |= (TEGRA_POWER_CPU_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
> +	pmc_32kwritel(reg, PMC_CTRL);
> +
> +	/* Configure core power request and system clock control if LP0
> +	   is supported */
> +	writel(pdata->core_timer, pmc + PMC_COREPWRGOOD_TIMER);
> +	writel(pdata->core_off_timer, pmc + PMC_COREPWROFF_TIMER);
> +	reg = readl(pmc + PMC_CTRL);
> +	mode = (reg >> TEGRA_POWER_PMC_SHIFT) & TEGRA_POWER_PMC_MASK;
> +
> +	mode &= ~TEGRA_POWER_SYSCLK_POLARITY;
> +	mode &= ~TEGRA_POWER_PWRREQ_POLARITY;
> +
> +	if (!pdata->sysclkreq_high)
> +		mode |= TEGRA_POWER_SYSCLK_POLARITY;
> +	if (!pdata->corereq_high)
> +		mode |= TEGRA_POWER_PWRREQ_POLARITY;
> +
> +	/* configure output inverters while the request is tristated */
> +	reg |= (mode << TEGRA_POWER_PMC_SHIFT);
> +	pmc_32kwritel(reg, PMC_CTRL);
> +
> +	/* now enable requests */
> +	reg |= (TEGRA_POWER_SYSCLK_OE << TEGRA_POWER_PMC_SHIFT);
> +	if (pdata->separate_req)
> +		reg |= (TEGRA_POWER_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
> +	writel(reg, pmc + PMC_CTRL);
> +
> +	if (pdata->suspend_mode == TEGRA_SUSPEND_LP0)
> +		lp0_suspend_init();
> +
> +	suspend_set_ops(&tegra_suspend_ops);
> +#endif
> +
> +	current_suspend_mode = plat->suspend_mode;
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +static const char *tegra_suspend_name[TEGRA_MAX_SUSPEND_MODE] = {
> +	[TEGRA_SUSPEND_NONE]	= "none",
> +	[TEGRA_SUSPEND_LP2]	= "lp2",
> +	[TEGRA_SUSPEND_LP1]	= "lp1",
> +	[TEGRA_SUSPEND_LP0]	= "lp0",
> +};
> +
> +static int tegra_suspend_debug_show(struct seq_file *s, void *data)
> +{
> +	seq_printf(s, "%s\n", tegra_suspend_name[*(int *)s->private]);
> +	return 0;
> +}
> +
> +static int tegra_suspend_debug_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, tegra_suspend_debug_show, inode->i_private);
> +}
> +
> +static int tegra_suspend_debug_write(struct file *file,
> +	const char __user *user_buf, size_t count, loff_t *ppos)
> +{
> +	char buf[32];
> +	int buf_size;
> +	int i;
> +	struct seq_file *s = file->private_data;
> +	enum tegra_suspend_mode *val = s->private;
> +
> +	memset(buf, 0x00, sizeof(buf));
> +	buf_size = min(count, (sizeof(buf)-1));
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +
> +	for (i = 0; i < TEGRA_MAX_SUSPEND_MODE; i++) {
> +		if (!strnicmp(buf, tegra_suspend_name[i],
> +		    strlen(tegra_suspend_name[i]))) {
> +			if (i > pdata->suspend_mode)
> +				return -EINVAL;
> +			*val = i;
> +			return count;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct file_operations tegra_suspend_debug_fops = {
> +	.open		= tegra_suspend_debug_open,
> +	.write		= tegra_suspend_debug_write,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static int tegra_suspend_time_debug_show(struct seq_file *s, void *data)
> +{
> +	int bin;
> +	seq_printf(s, "time (secs)  count\n");
> +	seq_printf(s, "------------------\n");
> +	for (bin = 0; bin < 32; bin++) {
> +		if (tegra_time_in_suspend[bin] == 0)
> +			continue;
> +		seq_printf(s, "%4d - %4d %4u\n",
> +			bin ? 1 << (bin - 1) : 0, 1 << bin,
> +			tegra_time_in_suspend[bin]);
> +	}
> +	return 0;
> +}
> +
> +static int tegra_suspend_time_debug_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, tegra_suspend_time_debug_show, NULL);
> +}
> +
> +static const struct file_operations tegra_suspend_time_debug_fops = {
> +	.open		= tegra_suspend_time_debug_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static int __init tegra_suspend_debug_init(void)
> +{
> +	struct dentry *d;
> +
> +	d = debugfs_create_file("suspend_mode", 0755, NULL,
> +		(void *)&current_suspend_mode, &tegra_suspend_debug_fops);
> +	if (!d) {
> +		pr_info("Failed to create suspend_mode debug file\n");
> +		return -ENOMEM;
> +	}
> +
> +	d = debugfs_create_file("suspend_time", 0755, NULL, NULL,
> +		&tegra_suspend_time_debug_fops);
> +	if (!d) {
> +		pr_info("Failed to create suspend_time debug file\n");
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +late_initcall(tegra_suspend_debug_init);
> +#endif
> diff --git a/arch/arm/mach-tegra/tegra2_save.S b/arch/arm/mach-tegra/tegra2_save.S
> new file mode 100644
> index 0000000..91f2ba0
> --- /dev/null
> +++ b/arch/arm/mach-tegra/tegra2_save.S
> @@ -0,0 +1,413 @@
> +/*
> + * arch/arm/mach-tegra/tegra2_save.S
> + *
> + * CPU state save & restore routines for CPU hotplug
> + *
> + * Copyright (c) 2010, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +#include <asm/assembler.h>
> +#include <asm/domain.h>
> +#include <asm/ptrace.h>
> +#include <asm/cache.h>
> +#include <asm/vfpmacros.h>
> +#include <asm/memory.h>
> +#include <asm/hardware/cache-l2x0.h>
> +
> +#include <mach/iomap.h>
> +#include <mach/io.h>
> +
> +#include "power.h"
> +
> +/*	.section ".cpuinit.text", "ax"*/
> +
> +#define TTB_FLAGS 0x6A	@ IRGN_WBWA, OC_RGN_WBWA, S, NOS
> +
> +#define EMC_CFG				0xc
> +#define EMC_ADR_CFG			0x10
> +#define EMC_REFRESH			0x70
> +#define EMC_NOP				0xdc
> +#define EMC_SELF_REF			0xe0
> +#define EMC_REQ_CTRL			0x2b0
> +#define EMC_EMC_STATUS			0x2b4
> +
> +#define PMC_CTRL			0x0
> +#define PMC_CTRL_BFI_SHIFT		8
> +#define PMC_CTRL_BFI_WIDTH		9
> +#define PMC_SCRATCH38			0x134
> +#define PMC_SCRATCH41			0x140
> +
> +#define CLK_RESET_CCLK_BURST		0x20
> +#define CLK_RESET_CCLK_DIVIDER		0x24
> +#define CLK_RESET_SCLK_BURST		0x28
> +#define CLK_RESET_SCLK_DIVIDER		0x2c
> +
> +#define CLK_RESET_PLLC_BASE		0x80
> +#define CLK_RESET_PLLM_BASE		0x90
> +#define CLK_RESET_PLLP_BASE		0xa0
> +
> +#define FLOW_CTRL_HALT_CPU_EVENTS	0x0
> +
> +#include "power-macros.S"
> +
> +.macro emc_device_mask, rd, base
> +	ldr	\rd, [\base, #EMC_ADR_CFG]
> +	tst	\rd, #(0x3<<24)
> +	moveq	\rd, #(0x1<<8)		@ just 1 device
> +	movne	\rd, #(0x3<<8)		@ 2 devices
> +.endm
> +
> +/*
> + *
> + *	__tear_down_master( r8 = context_pa, sp = power state )
> + *
> + *	  Set the clock burst policy to the selected wakeup source
> + *	  Enable CPU power-request mode in the PMC
> + *	  Put the CPU in wait-for-event mode on the flow controller
> + *	  Trigger the PMC state machine to put the CPU in reset
> + */
> +ENTRY(__tear_down_master)
> +__tear_down_master:
> +#ifdef CONFIG_CACHE_L2X0
> +	/* clean out the dirtied L2 lines, since all power transitions
> +	 * cause the cache state to get invalidated (although LP1 & LP2
> +	 * preserve the data in the L2, the control words (L2X0_CTRL,
> +	 * L2X0_AUX_CTRL, etc.) need to be cleaned to L3 so that they
> +	 * will be visible on reboot.  skip this for LP0, since the L2 cache
> +	 * will be shutdown before we reach this point */
> +	tst	sp, #TEGRA_POWER_EFFECT_LP0
> +	bne	__l2_clean_done
> +	mov32	r0, (TEGRA_ARM_PL310_BASE-IO_CPU_PHYS+IO_CPU_VIRT)
> +	add	r3, r8, #(CONTEXT_SIZE_BYTES)
> +	bic	r8, r8, #0x1f
> +	add	r3, r3, #0x1f
> +11:	str	r8, [r0, #L2X0_CLEAN_LINE_PA]
> +	add	r8, r8, #32
> +	cmp	r8, r3
> +	blo	11b
> +12:	ldr	r1, [r0, #L2X0_CLEAN_LINE_PA]
> +	tst	r1, #1
> +	bne	12b
> +	mov	r1, #0
> +	str	r1, [r0, #L2X0_CACHE_SYNC]
> +13:	ldr	r1, [r0, #L2X0_CACHE_SYNC]
> +	tst	r1, #1
> +	bne	13b
> +__l2_clean_done:
> +#endif
> +
> +	tst	sp, #TEGRA_POWER_SDRAM_SELFREFRESH
> +
> +	/* preload all the address literals that are needed for the
> +	 * CPU power-gating process, to avoid loads from SDRAM (which are
> +	 * not supported once SDRAM is put into self-refresh.
> +	 * LP0 / LP1 use physical address, since the MMU needs to be
> +	 * disabled before putting SDRAM into self-refresh to avoid
> +	 * memory access due to page table walks */
> +	mov32	r0, (IO_APB_VIRT-IO_APB_PHYS)
> +	mov32	r4, TEGRA_PMC_BASE
> +	mov32	r0, (IO_PPSB_VIRT-IO_PPSB_PHYS)
> +	mov32	r5, TEGRA_CLK_RESET_BASE
> +	mov32	r6, TEGRA_FLOW_CTRL_BASE
> +	mov32	r7, TEGRA_TMRUS_BASE
> +
> +	/* change page table pointer to tegra_pgd_phys, so that IRAM
> +	 * and MMU shut-off will be mapped virtual == physical */
> +	adr	r3, __tear_down_master_data
> +	ldr	r3, [r3]		@ &tegra_pgd_phys
> +	ldr	r3, [r3]
> +	orr	r3, r3, #TTB_FLAGS
> +	mov	r2, #0
> +	mcr	p15, 0, r2, c13, c0, 1	@ reserved context
> +	isb
> +	mcr	p15, 0, r3, c2, c0, 0	@ TTB 0
> +	isb
> +
> +	/* Obtain LP1 information.
> +	 * R10 = LP1 branch target */
> +	mov32	r2, __tegra_lp1_reset
> +	mov32	r3, __tear_down_master_sdram
> +	sub	r2, r3, r2
> +	mov32	r3, (TEGRA_IRAM_CODE_AREA)
> +	add	r10, r2, r3
> +
> +	mov32	r3, __shut_off_mmu
> +
> +	/* R9 = LP2 branch target */
> +	mov32	r9, __tear_down_master_pll_cpu
> +
> +	/* Convert the branch targets
> +	 * to physical addresses */
> +	sub	r3, r3, #(PAGE_OFFSET - PHYS_OFFSET)
> +	sub	r9, r9, #(PAGE_OFFSET - PHYS_OFFSET)
> +	movne	r9, r10
> +	bx	r3
> +ENDPROC(__tear_down_master)
> +	.type	__tear_down_master_data, %object
> +__tear_down_master_data:
> +	.long	tegra_pgd_phys
> +	.size	__tear_down_master_data, . - __tear_down_master_data
> +
> +/*  START OF ROUTINES COPIED TO IRAM  */
> +/*
> + *	__tegra_lp1_reset
> + *
> + *	  reset vector for LP1 restore; copied into IRAM during suspend.
> + *	  brings the system back up to a safe starting point (SDRAM out of
> + *	  self-refresh, PLLC, PLLM and PLLP reenabled, CPU running on PLLP,
> + *	  system clock running on the same PLL that it suspended at), and
> + *	  jumps to tegra_lp2_startup to restore PLLX and virtual addressing.
> + *	  physical address of tegra_lp2_startup expected to be stored in
> + *	  PMC_SCRATCH41
> + */
> +	.align L1_CACHE_SHIFT
> +ENTRY(__tegra_lp1_reset)
> +__tegra_lp1_reset:
> +	/* the CPU and system bus are running at 32KHz and executing from
> +	 * IRAM when this code is executed; immediately switch to CLKM and
> +	 * enable PLLP. */
> +	mov32	r0, TEGRA_CLK_RESET_BASE
> +	mov	r1, #(1<<28)
> +	str	r1, [r0, #CLK_RESET_SCLK_BURST]
> +	str	r1, [r0, #CLK_RESET_CCLK_BURST]
> +	mov	r1, #0
> +	str	r1, [r0, #CLK_RESET_SCLK_DIVIDER]
> +	str	r1, [r0, #CLK_RESET_CCLK_DIVIDER]
> +
> +	ldr	r1, [r0, #CLK_RESET_PLLM_BASE]
> +	tst	r1, #(1<<30)
> +	orreq	r1, r1, #(1<<30)
> +	streq	r1, [r0, #CLK_RESET_PLLM_BASE]
> +	ldr	r1, [r0, #CLK_RESET_PLLP_BASE]
> +	tst	r1, #(1<<30)
> +	orreq	r1, r1, #(1<<30)
> +	streq	r1, [r0, #CLK_RESET_PLLP_BASE]
> +	ldr	r1, [r0, #CLK_RESET_PLLC_BASE]
> +	tst	r1, #(1<<30)
> +	orreq	r1, r1, #(1<<30)
> +	streq	r1, [r0, #CLK_RESET_PLLC_BASE]
> +	mov32	r7, TEGRA_TMRUS_BASE
> +	ldr	r1, [r7]
> +
> +	/* since the optimized settings are still in SDRAM, there is
> +	 * no need to store them back into the IRAM-local __lp1_pad_area */
> +	add	r2, pc, #__lp1_pad_area-(.+8)
> +padload:ldmia	r2!, {r3-r4}
> +	cmp	r3, #0
> +	beq	padload_done
> +	str	r4, [r3]
> +	b	padload
> +padload_done:
> +	ldr	r2, [r7]
> +	add	r2, r2, #0x4	@ 4uS delay for DRAM pad restoration
> +	wait_until r2, r7, r3
> +	add	r1, r1, #0xff	@ 255uS delay for PLL stabilization
> +	wait_until r1, r7, r3
> +
> +	str	r4, [r0, #CLK_RESET_SCLK_BURST]
> +	mov32	r4, ((1<<28) | (4))	@ burst policy is PLLP
> +	str	r4, [r0, #CLK_RESET_CCLK_BURST]
> +
> +	mov32	r0, TEGRA_EMC_BASE
> +	ldr	r1, [r0, #EMC_CFG]
> +	bic	r1, r1, #(1<<31)	@ disable DRAM_CLK_STOP
> +	str	r1, [r0, #EMC_CFG]
> +
> +	mov	r1, #0
> +	str	r1, [r0, #EMC_SELF_REF]	@ take DRAM out of self refresh
> +	mov	r1, #1
> +	str	r1, [r0, #EMC_NOP]
> +	str	r1, [r0, #EMC_NOP]
> +	str	r1, [r0, #EMC_REFRESH]
> +
> +	emc_device_mask r1, r0
> +
> +exit_selfrefresh_loop:
> +	ldr	r2, [r0, #EMC_EMC_STATUS]
> +	ands	r2, r2, r1
> +	bne	exit_selfrefresh_loop
> +
> +	mov	r1, #0
> +	str	r1, [r0, #EMC_REQ_CTRL]
> +
> +	mov32	r0, TEGRA_PMC_BASE
> +	ldr	r0, [r0, #PMC_SCRATCH41]
> +	mov	pc, r0
> +ENDPROC(__tegra_lp1_reset)
> +
> +/*
> + *	__tear_down_master_sdram
> + *
> + *	  disables MMU, data cache, and puts SDRAM into self-refresh.
> + *	  must execute from IRAM.
> + */
> +	.align L1_CACHE_SHIFT
> +__tear_down_master_sdram:
> +	mov32	r1, TEGRA_EMC_BASE
> +	mov	r2, #3
> +	str	r2, [r1, #EMC_REQ_CTRL]		@ stall incoming DRAM requests
> +
> +emcidle:ldr	r2, [r1, #EMC_EMC_STATUS]
> +	tst	r2, #4
> +	beq	emcidle
> +
> +	mov	r2, #1
> +	str	r2, [r1, #EMC_SELF_REF]
> +
> +	emc_device_mask r2, r1
> +
> +emcself:ldr	r3, [r1, #EMC_EMC_STATUS]
> +	and	r3, r3, r2
> +	cmp	r3, r2
> +	bne	emcself				@ loop until DDR in self-refresh
> +
> +	add	r2, pc, #__lp1_pad_area-(.+8)
> +
> +padsave:ldm	r2, {r0-r1}
> +	cmp	r0, #0
> +	beq	padsave_done
> +	ldr	r3, [r0]
> +	str	r1, [r0]
> +	str	r3, [r2, #4]
> +	add	r2, r2, #8
> +	b	padsave
> +padsave_done:
> +
> +	ldr	r0, [r5, #CLK_RESET_SCLK_BURST]
> +	str	r0, [r2, #4]
> +	dsb
> +	b	__tear_down_master_pll_cpu
> +ENDPROC(__tear_down_master_sdram)
> +
> +	.align	L1_CACHE_SHIFT
> +	.type	__lp1_pad_area, %object
> +__lp1_pad_area:
> +	.word	TEGRA_APB_MISC_BASE + 0x8c8 /* XM2CFGCPADCTRL */
> +	.word	0x8
> +	.word	TEGRA_APB_MISC_BASE + 0x8cc /* XM2CFGDPADCTRL */
> +	.word	0x8
> +	.word	TEGRA_APB_MISC_BASE + 0x8d0 /* XM2CLKCFGPADCTRL */
> +	.word	0x0
> +	.word	TEGRA_APB_MISC_BASE + 0x8d4 /* XM2COMPPADCTRL */
> +	.word	0x8
> +	.word	TEGRA_APB_MISC_BASE + 0x8d8 /* XM2VTTGENPADCTRL */
> +	.word	0x5500
> +	.word	TEGRA_APB_MISC_BASE + 0x8e4 /* XM2CFGCPADCTRL2 */
> +	.word	0x08080040
> +	.word	TEGRA_APB_MISC_BASE + 0x8e8 /* XM2CFGDPADCTRL2 */
> +	.word	0x0
> +	.word	0x0	/* end of list */
> +	.word	0x0	/* sclk_burst_policy */
> +	.size	__lp1_pad_area, . - __lp1_pad_area
> +
> +	.align L1_CACHE_SHIFT
> +__tear_down_master_pll_cpu:
> +	ldr	r0, [r4, #PMC_CTRL]
> +	bfi	r0, sp, #PMC_CTRL_BFI_SHIFT, #PMC_CTRL_BFI_WIDTH
> +	str	r0, [r4, #PMC_CTRL]
> +	tst	sp, #TEGRA_POWER_SDRAM_SELFREFRESH
> +
> +	/* in LP2 idle (SDRAM active), set the CPU burst policy to PLLP */
> +	moveq	r0, #(2<<28)    /* burst policy = run mode */
> +	orreq	r0, r0, #(4<<4) /* use PLLP in run mode burst */
> +	streq	r0, [r5, #CLK_RESET_CCLK_BURST]
> +	moveq	r0, #0
> +	streq	r0, [r5, #CLK_RESET_CCLK_DIVIDER]
> +	beq	__cclk_burst_set
> +
> +	/* in other modes, set system & CPU burst policies to 32KHz.
> +	 * start by jumping to CLKM to safely disable PLLs, then jump
> +	 * to CLKS */
> +	mov	r0, #(1<<28)
> +	str	r0, [r5, #CLK_RESET_SCLK_BURST]
> +	str	r0, [r5, #CLK_RESET_CCLK_BURST]
> +	mov	r0, #0
> +	str	r0, [r5, #CLK_RESET_CCLK_DIVIDER]
> +	str	r0, [r5, #CLK_RESET_SCLK_DIVIDER]
> +
> +	/* 2 us delay between changing sclk and disabling PLLs */
> +	wait_for_us r1, r7, r9
> +	add	r1, r1, #2
> +	wait_until r1, r7, r9
> +
> +	/* switch to CLKS */
> +	mov	r0, #0	/* burst policy = 32KHz */
> +	str	r0, [r5, #CLK_RESET_SCLK_BURST]
> +
> +	/* disable PLLP, PLLM, PLLC in LP0 and LP1 states */
> +	ldr	r0, [r5, #CLK_RESET_PLLM_BASE]
> +	bic	r0, r0, #(1<<30)
> +	str	r0, [r5, #CLK_RESET_PLLM_BASE]
> +	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
> +	bic	r0, r0, #(1<<30)
> +	str	r0, [r5, #CLK_RESET_PLLP_BASE]
> +	ldr	r0, [r5, #CLK_RESET_PLLC_BASE]
> +	bic	r0, r0, #(1<<30)
> +	str	r0, [r5, #CLK_RESET_PLLC_BASE]
> +
> +__cclk_burst_set:
> +	mov	r0, #(4<<29)			/* STOP_UNTIL_IRQ */
> +	orr	r0, r0, #(1<<10) | (1<<8)	/* IRQ_0, FIQ_0	*/
> +	ldr	r1, [r7]
> +	str	r1, [r4, #PMC_SCRATCH38]
> +	dsb
> +	str	r0, [r6, #FLOW_CTRL_HALT_CPU_EVENTS]
> +	dsb
> +	ldr	r0, [r6, #FLOW_CTRL_HALT_CPU_EVENTS] /* memory barrier */
> +
> +halted:	dsb
> +	wfe	/* CPU should be power gated here */
> +	isb
> +	b	halted
> +ENDPROC(__tear_down_master_pll_cpu)
> +
> +/*
> + *	__put_cpu_in_reset(cpu_nr)
> + *
> + *	 puts the specified CPU in wait-for-event mode on the flow controller
> + *	 and puts the CPU in reset
> + */
> +ENTRY(__put_cpu_in_reset)
> +__put_cpu_in_reset:
> +	cmp	r0, #0
> +	subne	r1, r0, #1
> +	movne	r1, r1, lsl #3
> +	addne	r1, r1, #0x14
> +	moveq	r1, #0			@ r1 = CPUx_HALT_EVENTS register offset
> +	mov32	r7, (TEGRA_FLOW_CTRL_BASE-IO_PPSB_PHYS+IO_PPSB_VIRT)
> +	mov	r2, #(0x2<<29)
> +	str	r2, [r7, r1]		@ put flow controller in wait event mode
> +	isb
> +	dsb
> +	movw	r1, 0x1011
> +	mov	r1, r1, lsl r0
> +	mov32	r7, (TEGRA_CLK_RESET_BASE-IO_PPSB_PHYS+IO_PPSB_VIRT)
> +	str	r1, [r7, #0x340]	@ put slave CPU in reset
> +	isb
> +	dsb
> +	b	.
> +ENDPROC(__put_cpu_in_reset)
> +
> +/* dummy symbol for end of IRAM */
> +	.align L1_CACHE_SHIFT
> +ENTRY(__tegra_iram_end)
> +__tegra_iram_end:
> +	b	.
> +ENDPROC(__tegra_iram_end)
> -- 
> 1.7.3.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
