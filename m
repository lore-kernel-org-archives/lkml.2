Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2ITBat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:30:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34915 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648Ab2ITBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:30:40 -0400
Message-ID: <1348104614.4836.66.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.30
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Thu, 20 Sep 2012 02:30:14 +0100
In-Reply-To: <1348104546.4836.65.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iH3FQUanuVeOTBxRWJXU"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iH3FQUanuVeOTBxRWJXU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt b/Docu=
mentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
index ab22fe6..e39a0c0 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
@@ -10,8 +10,8 @@ Required properties:
=20
 Optional properties:
 - fsl,card-wired : Indicate the card is wired to host permanently
-- fsl,cd-internal : Indicate to use controller internal card detection
-- fsl,wp-internal : Indicate to use controller internal write protection
+- fsl,cd-controller : Indicate to use controller internal card detection
+- fsl,wp-controller : Indicate to use controller internal write protection
 - cd-gpios : Specify GPIOs for card detection
 - wp-gpios : Specify GPIOs for write protection
=20
@@ -21,8 +21,8 @@ esdhc@70004000 {
 	compatible =3D "fsl,imx51-esdhc";
 	reg =3D <0x70004000 0x4000>;
 	interrupts =3D <1>;
-	fsl,cd-internal;
-	fsl,wp-internal;
+	fsl,cd-controller;
+	fsl,wp-controller;
 };
=20
 esdhc@70008000 {
diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i=
2c-i801
index 2871fd5..99d4e44 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -20,6 +20,8 @@ Supported adapters:
   * Intel Patsburg (PCH)
   * Intel DH89xxCC (PCH)
   * Intel Panther Point (PCH)
+  * Intel Lynx Point (PCH)
+  * Intel Lynx Point-LP (PCH)
    Datasheets: Publicly available at the Intel website
=20
 On Intel Patsburg and later chipsets, both the normal host SMBus controlle=
r
diff --git a/Makefile b/Makefile
index d96fc2a..9fd7e60 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 29
+SUBLEVEL =3D 30
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 987c72d..9fdc151 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2065,6 +2065,7 @@ source "drivers/cpufreq/Kconfig"
 config CPU_FREQ_IMX
 	tristate "CPUfreq driver for i.MX CPUs"
 	depends on ARCH_MXC && CPU_FREQ
+	select CPU_FREQ_TABLE
 	help
 	  This enables the CPUfreq driver for i.MX CPUs.
=20
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index dfcf3b0..362c7ca 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -284,10 +284,10 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=3D$(boot) MACHINE=3D$(MACHINE) $@
=20
-%.dtb:
+%.dtb: scripts
 	$(Q)$(MAKE) $(build)=3D$(boot) MACHINE=3D$(MACHINE) $(boot)/$@
=20
-dtbs:
+dtbs: scripts
 	$(Q)$(MAKE) $(build)=3D$(boot) MACHINE=3D$(MACHINE) $(boot)/$@
=20
 # We use MRPROPER_FILES and CLEAN_FILES now
diff --git a/arch/arm/boot/dts/imx51-babbage.dts b/arch/arm/boot/dts/imx51-=
babbage.dts
index f8766af..4790df2 100644
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@ -29,8 +29,8 @@
 		aips@70000000 { /* aips-1 */
 			spba@70000000 {
 				esdhc@70004000 { /* ESDHC1 */
-					fsl,cd-internal;
-					fsl,wp-internal;
+					fsl,cd-controller;
+					fsl,wp-controller;
 					status =3D "okay";
 				};
=20
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.=
h
index 8512475..9b419ab 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -232,6 +232,18 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
=20
+#define pte_none(pte)		(!pte_val(pte))
+#define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
+#define pte_write(pte)		(!(pte_val(pte) & L_PTE_RDONLY))
+#define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
+#define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
+#define pte_exec(pte)		(!(pte_val(pte) & L_PTE_XN))
+#define pte_special(pte)	(0)
+
+#define pte_present_user(pte) \
+	((pte_val(pte) & (L_PTE_PRESENT | L_PTE_USER)) =3D=3D \
+	 (L_PTE_PRESENT | L_PTE_USER))
+
 #if __LINUX_ARM_ARCH__ < 6
 static inline void __sync_icache_dcache(pte_t pteval)
 {
@@ -243,25 +255,15 @@ extern void __sync_icache_dcache(pte_t pteval);
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
-	if (addr >=3D TASK_SIZE)
-		set_pte_ext(ptep, pteval, 0);
-	else {
+	unsigned long ext =3D 0;
+
+	if (addr < TASK_SIZE && pte_present_user(pteval)) {
 		__sync_icache_dcache(pteval);
-		set_pte_ext(ptep, pteval, PTE_EXT_NG);
+		ext |=3D PTE_EXT_NG;
 	}
-}
=20
-#define pte_none(pte)		(!pte_val(pte))
-#define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
-#define pte_write(pte)		(!(pte_val(pte) & L_PTE_RDONLY))
-#define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
-#define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
-#define pte_exec(pte)		(!(pte_val(pte) & L_PTE_XN))
-#define pte_special(pte)	(0)
-
-#define pte_present_user(pte) \
-	((pte_val(pte) & (L_PTE_PRESENT | L_PTE_USER)) =3D=3D \
-	 (L_PTE_PRESENT | L_PTE_USER))
+	set_pte_ext(ptep, pteval, ext);
+}
=20
 #define PTE_BIT_FUNC(fn,op) \
 static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoin=
t.c
index 814a52a9..2bc1a8e 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -160,6 +160,12 @@ static int debug_arch_supported(void)
 		arch >=3D ARM_DEBUG_ARCH_V7_1;
 }
=20
+/* Can we determine the watchpoint access type from the fsr? */
+static int debug_exception_updates_fsr(void)
+{
+	return 0;
+}
+
 /* Determine number of WRP registers available. */
 static int get_num_wrp_resources(void)
 {
@@ -620,18 +626,35 @@ int arch_validate_hwbkpt_settings(struct perf_event *=
bp)
 	info->address &=3D ~alignment_mask;
 	info->ctrl.len <<=3D offset;
=20
-	/*
-	 * Currently we rely on an overflow handler to take
-	 * care of single-stepping the breakpoint when it fires.
-	 * In the case of userspace breakpoints on a core with V7 debug,
-	 * we can use the mismatch feature as a poor-man's hardware
-	 * single-step, but this only works for per-task breakpoints.
-	 */
-	if (!bp->overflow_handler && (arch_check_bp_in_kernelspace(bp) ||
-	    !core_has_mismatch_brps() || !bp->hw.bp_target)) {
-		pr_warning("overflow handler required but none found\n");
-		ret =3D -EINVAL;
+	if (!bp->overflow_handler) {
+		/*
+		 * Mismatch breakpoints are required for single-stepping
+		 * breakpoints.
+		 */
+		if (!core_has_mismatch_brps())
+			return -EINVAL;
+
+		/* We don't allow mismatch breakpoints in kernel space. */
+		if (arch_check_bp_in_kernelspace(bp))
+			return -EPERM;
+
+		/*
+		 * Per-cpu breakpoints are not supported by our stepping
+		 * mechanism.
+		 */
+		if (!bp->hw.bp_target)
+			return -EINVAL;
+
+		/*
+		 * We only support specific access types if the fsr
+		 * reports them.
+		 */
+		if (!debug_exception_updates_fsr() &&
+		    (info->ctrl.type =3D=3D ARM_BREAKPOINT_LOAD ||
+		     info->ctrl.type =3D=3D ARM_BREAKPOINT_STORE))
+			return -EINVAL;
 	}
+
 out:
 	return ret;
 }
@@ -707,10 +730,12 @@ static void watchpoint_handler(unsigned long addr, un=
signed int fsr,
 				goto unlock;
=20
 			/* Check that the access type matches. */
-			access =3D (fsr & ARM_FSR_ACCESS_MASK) ? HW_BREAKPOINT_W :
-				 HW_BREAKPOINT_R;
-			if (!(access & hw_breakpoint_type(wp)))
-				goto unlock;
+			if (debug_exception_updates_fsr()) {
+				access =3D (fsr & ARM_FSR_ACCESS_MASK) ?
+					  HW_BREAKPOINT_W : HW_BREAKPOINT_R;
+				if (!(access & hw_breakpoint_type(wp)))
+					goto unlock;
+			}
=20
 			/* We have a winner. */
 			info->trigger =3D addr;
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 8380bd1..7ac5dfd 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -380,20 +380,23 @@ asmlinkage void __exception do_undefinstr(struct pt_r=
egs *regs)
 #endif
 			instr =3D *(u32 *) pc;
 	} else if (thumb_mode(regs)) {
-		get_user(instr, (u16 __user *)pc);
+		if (get_user(instr, (u16 __user *)pc))
+			goto die_sig;
 		if (is_wide_instruction(instr)) {
 			unsigned int instr2;
-			get_user(instr2, (u16 __user *)pc+1);
+			if (get_user(instr2, (u16 __user *)pc+1))
+				goto die_sig;
 			instr <<=3D 16;
 			instr |=3D instr2;
 		}
-	} else {
-		get_user(instr, (u32 __user *)pc);
+	} else if (get_user(instr, (u32 __user *)pc)) {
+		goto die_sig;
 	}
=20
 	if (call_undef_hook(regs, instr) =3D=3D 0)
 		return;
=20
+die_sig:
 #ifdef CONFIG_DEBUG_USER
 	if (user_debug & UDBG_UNDEFINED) {
 		printk(KERN_INFO "%s (%d): undefined instruction: pc=3D%p\n",
diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 1620b15..cb105bf8 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -92,7 +92,7 @@ void __init dove_ge00_init(struct mv643xx_eth_platform_da=
ta *eth_data)
 {
 	orion_ge00_init(eth_data, &dove_mbus_dram_info,
 			DOVE_GE00_PHYS_BASE, IRQ_DOVE_GE00_SUM,
-			0, get_tclk());
+			0, get_tclk(), 1600);
 }
=20
 /*************************************************************************=
****
diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
index 20ed2d5..f8f7437 100644
--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -42,22 +42,6 @@ static inline void cpu_enter_lowpower(void)
 	  : "cc");
 }
=20
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-		"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=3D&r" (v)
-	  : "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
-
 /*
  * platform-specific code to shutdown a CPU
  *
@@ -67,11 +51,10 @@ void platform_cpu_die(unsigned int cpu)
 {
 	cpu_enter_lowpower();
 	imx_enable_cpu(cpu, false);
-	cpu_do_idle();
-	cpu_leave_lowpower();
=20
-	/* We should never return from idle */
-	panic("cpu %d unexpectedly exit from shutdown\n", cpu);
+	/* spin here until hardware takes it down */
+	while (1)
+		;
 }
=20
 int platform_cpu_disable(unsigned int cpu)
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/commo=
n.c
index c5dbbb3..06faa97 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -88,7 +88,7 @@ void __init kirkwood_ge00_init(struct mv643xx_eth_platfor=
m_data *eth_data)
=20
 	orion_ge00_init(eth_data, &kirkwood_mbus_dram_info,
 			GE00_PHYS_BASE, IRQ_KIRKWOOD_GE00_SUM,
-			IRQ_KIRKWOOD_GE00_ERR, kirkwood_tclk);
+			IRQ_KIRKWOOD_GE00_ERR, kirkwood_tclk, 1600);
 }
=20

@@ -102,7 +102,7 @@ void __init kirkwood_ge01_init(struct mv643xx_eth_platf=
orm_data *eth_data)
=20
 	orion_ge01_init(eth_data, &kirkwood_mbus_dram_info,
 			GE01_PHYS_BASE, IRQ_KIRKWOOD_GE01_SUM,
-			IRQ_KIRKWOOD_GE01_ERR, kirkwood_tclk);
+			IRQ_KIRKWOOD_GE01_ERR, kirkwood_tclk, 1600);
 }
=20

diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.=
c
index d90e244..570ee4d 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -202,7 +202,8 @@ void __init mv78xx0_ge00_init(struct mv643xx_eth_platfo=
rm_data *eth_data)
 {
 	orion_ge00_init(eth_data, &mv78xx0_mbus_dram_info,
 			GE00_PHYS_BASE, IRQ_MV78XX0_GE00_SUM,
-			IRQ_MV78XX0_GE_ERR, get_tclk());
+			IRQ_MV78XX0_GE_ERR, get_tclk(),
+			MV643XX_TX_CSUM_DEFAULT_LIMIT);
 }
=20

@@ -213,7 +214,8 @@ void __init mv78xx0_ge01_init(struct mv643xx_eth_platfo=
rm_data *eth_data)
 {
 	orion_ge01_init(eth_data, &mv78xx0_mbus_dram_info,
 			GE01_PHYS_BASE, IRQ_MV78XX0_GE01_SUM,
-			NO_IRQ, get_tclk());
+			NO_IRQ, get_tclk(),
+			MV643XX_TX_CSUM_DEFAULT_LIMIT);
 }
=20

diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.=
c
index 53b68b8..20260db 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -95,7 +95,8 @@ void __init orion5x_eth_init(struct mv643xx_eth_platform_=
data *eth_data)
 {
 	orion_ge00_init(eth_data, &orion5x_mbus_dram_info,
 			ORION5X_ETH_PHYS_BASE, IRQ_ORION5X_ETH_SUM,
-			IRQ_ORION5X_ETH_ERR, orion5x_tclk);
+			IRQ_ORION5X_ETH_ERR, orion5x_tclk,
+			MV643XX_TX_CSUM_DEFAULT_LIMIT);
 }
=20

diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 1a8d4aa..8fda9f7 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -236,8 +236,6 @@ void __sync_icache_dcache(pte_t pteval)
 	struct page *page;
 	struct address_space *mapping;
=20
-	if (!pte_present_user(pteval))
-		return;
 	if (cache_is_vipt_nonaliasing() && !pte_exec(pteval))
 		/* only flush non-aliasing VIPT caches for exec mappings */
 		return;
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index af3b92b..f9adbbb 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_enable);
=20
 void omap_dm_timer_disable(struct omap_dm_timer *timer)
 {
-	pm_runtime_put(&timer->pdev->dev);
+	pm_runtime_put_sync(&timer->pdev->dev);
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_disable);
=20
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 11dce87..8a6886a 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -263,10 +263,12 @@ void __init orion_ge00_init(struct mv643xx_eth_platfo=
rm_data *eth_data,
 			    unsigned long mapbase,
 			    unsigned long irq,
 			    unsigned long irq_err,
-			    int tclk)
+			    int tclk,
+			    unsigned int tx_csum_limit)
 {
 	fill_resources(&orion_ge00_shared, orion_ge00_shared_resources,
 		       mapbase + 0x2000, SZ_16K - 1, irq_err);
+	orion_ge00_shared_data.tx_csum_limit =3D tx_csum_limit;
 	ge_complete(&orion_ge00_shared_data, mbus_dram_info, tclk,
 		    orion_ge00_resources, irq, &orion_ge00_shared,
 		    eth_data, &orion_ge00);
@@ -317,10 +319,12 @@ void __init orion_ge01_init(struct mv643xx_eth_platfo=
rm_data *eth_data,
 			    unsigned long mapbase,
 			    unsigned long irq,
 			    unsigned long irq_err,
-			    int tclk)
+			    int tclk,
+			    unsigned int tx_csum_limit)
 {
 	fill_resources(&orion_ge01_shared, orion_ge01_shared_resources,
 		       mapbase + 0x2000, SZ_16K - 1, irq_err);
+	orion_ge01_shared_data.tx_csum_limit =3D tx_csum_limit;
 	ge_complete(&orion_ge01_shared_data, mbus_dram_info, tclk,
 		    orion_ge01_resources, irq, &orion_ge01_shared,
 		    eth_data, &orion_ge01);
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orio=
n/include/plat/common.h
index a2c0e31..b637dae 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -41,14 +41,16 @@ void __init orion_ge00_init(struct mv643xx_eth_platform=
_data *eth_data,
 			    unsigned long mapbase,
 			    unsigned long irq,
 			    unsigned long irq_err,
-			    int tclk);
+			    int tclk,
+			    unsigned int tx_csum_limit);
=20
 void __init orion_ge01_init(struct mv643xx_eth_platform_data *eth_data,
 			    struct mbus_dram_target_info *mbus_dram_info,
 			    unsigned long mapbase,
 			    unsigned long irq,
 			    unsigned long irq_err,
-			    int tclk);
+			    int tclk,
+			    unsigned int tx_csum_limit);
=20
 void __init orion_ge10_init(struct mv643xx_eth_platform_data *eth_data,
 			    struct mbus_dram_target_info *mbus_dram_info,
diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 8a90b6a..1eedf8d 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -431,7 +431,7 @@ s3c2410_dma_canload(struct s3c2410_dma_chan *chan)
  * when necessary.
 */
=20
-int s3c2410_dma_enqueue(unsigned int channel, void *id,
+int s3c2410_dma_enqueue(enum dma_ch channel, void *id,
 			dma_addr_t data, int size)
 {
 	struct s3c2410_dma_chan *chan =3D s3c_dma_lookup_channel(channel);
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/ato=
mic.h
index 4054b31..c4b779b 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -247,7 +247,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, =
int a, int u)
=20
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i),(v)) =3D=3D 0)
=20
-#define ATOMIC_INIT(i)	((atomic_t) { (i) })
+#define ATOMIC_INIT(i)	{ (i) }
=20
 #define smp_mb__before_atomic_dec()	smp_mb()
 #define smp_mb__after_atomic_dec()	smp_mb()
@@ -256,7 +256,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, =
int a, int u)
=20
 #ifdef CONFIG_64BIT
=20
-#define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
+#define ATOMIC64_INIT(i) { (i) }
=20
 static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-of=
fsets.c
index 7c5324f..cc20b0a 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -79,6 +79,7 @@ int main(void)
 	DEFINE(SIGSEGV, SIGSEGV);
 	DEFINE(NMI_MASK, NMI_MASK);
 	DEFINE(THREAD_DSCR, offsetof(struct thread_struct, dscr));
+	DEFINE(THREAD_DSCR_INHERIT, offsetof(struct thread_struct, dscr_inherit))=
;
 #else
 	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 #endif /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kernel/dbell.c b/arch/powerpc/kernel/dbell.c
index 2cc451a..6856062 100644
--- a/arch/powerpc/kernel/dbell.c
+++ b/arch/powerpc/kernel/dbell.c
@@ -28,6 +28,8 @@ void doorbell_setup_this_cpu(void)
=20
 void doorbell_cause_ipi(int cpu, unsigned long data)
 {
+	/* Order previous accesses vs. msgsnd, which is treated as a store */
+	mb();
 	ppc_msgsnd(PPC_DBELL, 0, data);
 }
=20
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.=
S
index d834425..654fc53 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -380,6 +380,12 @@ _GLOBAL(ret_from_fork)
 	li	r3,0
 	b	syscall_exit
=20
+	.section	".toc","aw"
+DSCR_DEFAULT:
+	.tc dscr_default[TC],dscr_default
+
+	.section	".text"
+
 /*
  * This routine switches between two different tasks.  The process
  * state of one is saved on its kernel stack.  Then the state
@@ -519,9 +525,6 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEGMENT)
 	mr	r1,r8		/* start using new stack pointer */
 	std	r7,PACAKSAVE(r13)
=20
-	ld	r6,_CCR(r1)
-	mtcrf	0xFF,r6
-
 #ifdef CONFIG_ALTIVEC
 BEGIN_FTR_SECTION
 	ld	r0,THREAD_VRSAVE(r4)
@@ -530,14 +533,22 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 #endif /* CONFIG_ALTIVEC */
 #ifdef CONFIG_PPC64
 BEGIN_FTR_SECTION
+	lwz	r6,THREAD_DSCR_INHERIT(r4)
+	ld	r7,DSCR_DEFAULT@toc(2)
 	ld	r0,THREAD_DSCR(r4)
-	cmpd	r0,r25
-	beq	1f
+	cmpwi	r6,0
+	bne	1f
+	ld	r0,0(r7)
+1:	cmpd	r0,r25
+	beq	2f
 	mtspr	SPRN_DSCR,r0
-1:=09
+2:
 END_FTR_SECTION_IFSET(CPU_FTR_DSCR)
 #endif
=20
+	ld	r6,_CCR(r1)
+	mtcrf	0xFF,r6
+
 	/* r3-r13 are destroyed -- Cort */
 	REST_8GPRS(14, r1)
 	REST_10GPRS(22, r1)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 6457574..d687e3f 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -778,16 +778,8 @@ int copy_thread(unsigned long clone_flags, unsigned lo=
ng usp,
 #endif /* CONFIG_PPC_STD_MMU_64 */
 #ifdef CONFIG_PPC64=20
 	if (cpu_has_feature(CPU_FTR_DSCR)) {
-		if (current->thread.dscr_inherit) {
-			p->thread.dscr_inherit =3D 1;
-			p->thread.dscr =3D current->thread.dscr;
-		} else if (0 !=3D dscr_default) {
-			p->thread.dscr_inherit =3D 1;
-			p->thread.dscr =3D dscr_default;
-		} else {
-			p->thread.dscr_inherit =3D 0;
-			p->thread.dscr =3D 0;
-		}
+		p->thread.dscr_inherit =3D current->thread.dscr_inherit;
+		p->thread.dscr =3D current->thread.dscr;
 	}
 #endif
=20
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 6df7090..fe04b4a 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -214,8 +214,15 @@ void smp_muxed_ipi_message_pass(int cpu, int msg)
 	struct cpu_messages *info =3D &per_cpu(ipi_message, cpu);
 	char *message =3D (char *)&info->messages;
=20
+	/*
+	 * Order previous accesses before accesses in the IPI handler.
+	 */
+	smp_mb();
 	message[msg] =3D 1;
-	mb();
+	/*
+	 * cause_ipi functions are required to include a full barrier
+	 * before doing whatever causes the IPI.
+	 */
 	smp_ops->cause_ipi(cpu, info->data);
 }
=20
@@ -227,7 +234,7 @@ irqreturn_t smp_ipi_demux(void)
 	mb();	/* order any irq clear */
=20
 	do {
-		all =3D xchg_local(&info->messages, 0);
+		all =3D xchg(&info->messages, 0);
=20
 #ifdef __BIG_ENDIAN
 		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNCTION)))
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index ce035c1..55be64d 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -192,6 +192,14 @@ static ssize_t show_dscr_default(struct sysdev_class *=
class,
 	return sprintf(buf, "%lx\n", dscr_default);
 }
=20
+static void update_dscr(void *dummy)
+{
+	if (!current->thread.dscr_inherit) {
+		current->thread.dscr =3D dscr_default;
+		mtspr(SPRN_DSCR, dscr_default);
+	}
+}
+
 static ssize_t __used store_dscr_default(struct sysdev_class *class,
 		struct sysdev_class_attribute *attr, const char *buf,
 		size_t count)
@@ -204,6 +212,8 @@ static ssize_t __used store_dscr_default(struct sysdev_=
class *class,
 		return -EINVAL;
 	dscr_default =3D val;
=20
+	on_each_cpu(update_dscr, NULL, 1);
+
 	return count;
 }
=20
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 5459d14..82dcd4d 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -942,8 +942,9 @@ static int emulate_instruction(struct pt_regs *regs)
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mtdscr, regs);
 		rd =3D (instword >> 21) & 0x1f;
-		mtspr(SPRN_DSCR, regs->gpr[rd]);
+		current->thread.dscr =3D regs->gpr[rd];
 		current->thread.dscr_inherit =3D 1;
+		mtspr(SPRN_DSCR, current->thread.dscr);
 		return 0;
 	}
 #endif
diff --git a/arch/powerpc/sysdev/xics/icp-hv.c b/arch/powerpc/sysdev/xics/i=
cp-hv.c
index 9518d36..5c76bf7 100644
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -27,33 +27,53 @@ static inline unsigned int icp_hv_get_xirr(unsigned cha=
r cppr)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 	long rc;
+	unsigned int ret =3D XICS_IRQ_SPURIOUS;
=20
 	rc =3D plpar_hcall(H_XIRR, retbuf, cppr);
-	if (rc !=3D H_SUCCESS)
-		panic(" bad return code xirr - rc =3D %lx\n", rc);
-	return (unsigned int)retbuf[0];
+	if (rc =3D=3D H_SUCCESS) {
+		ret =3D (unsigned int)retbuf[0];
+	} else {
+		pr_err("%s: bad return code xirr cppr=3D0x%x returned %ld\n",
+			__func__, cppr, rc);
+		WARN_ON_ONCE(1);
+	}
+
+	return ret;
 }
=20
 static inline void icp_hv_set_xirr(unsigned int value)
 {
 	long rc =3D plpar_hcall_norets(H_EOI, value);
-	if (rc !=3D H_SUCCESS)
-		panic("bad return code EOI - rc =3D %ld, value=3D%x\n", rc, value);
+	if (rc !=3D H_SUCCESS) {
+		pr_err("%s: bad return code eoi xirr=3D0x%x returned %ld\n",
+			__func__, value, rc);
+		WARN_ON_ONCE(1);
+	}
 }
=20
 static inline void icp_hv_set_cppr(u8 value)
 {
 	long rc =3D plpar_hcall_norets(H_CPPR, value);
-	if (rc !=3D H_SUCCESS)
-		panic("bad return code cppr - rc =3D %lx\n", rc);
+	if (rc !=3D H_SUCCESS) {
+		pr_err("%s: bad return code cppr cppr=3D0x%x returned %ld\n",
+			__func__, value, rc);
+		WARN_ON_ONCE(1);
+	}
 }
=20
 static inline void icp_hv_set_qirr(int n_cpu , u8 value)
 {
-	long rc =3D plpar_hcall_norets(H_IPI, get_hard_smp_processor_id(n_cpu),
-				     value);
-	if (rc !=3D H_SUCCESS)
-		panic("bad return code qirr - rc =3D %lx\n", rc);
+	int hw_cpu =3D get_hard_smp_processor_id(n_cpu);
+	long rc;
+
+	/* Make sure all previous accesses are ordered before IPI sending */
+	mb();
+	rc =3D plpar_hcall_norets(H_IPI, hw_cpu, value);
+	if (rc !=3D H_SUCCESS) {
+		pr_err("%s: bad return code qirr cpu=3D%d hw_cpu=3D%d mfrr=3D0x%x "
+			"returned %ld\n", __func__, n_cpu, hw_cpu, value, rc);
+		WARN_ON_ONCE(1);
+	}
 }
=20
 static void icp_hv_eoi(struct irq_data *d)
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b2c7179..bb104b4 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -78,9 +78,16 @@ static void __init xen_add_extra_mem(u64 start, u64 size=
)
 	memblock_x86_reserve_range(start, start + size, "XEN EXTRA");
=20
 	xen_max_p2m_pfn =3D PFN_DOWN(start + size);
+	for (pfn =3D PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
+		unsigned long mfn =3D pfn_to_mfn(pfn);
+
+		if (WARN(mfn =3D=3D pfn, "Trying to over-write 1-1 mapping (pfn: %lx)\n"=
, pfn))
+			continue;
+		WARN(mfn !=3D INVALID_P2M_ENTRY, "Trying to remove %lx which has %lx mfn=
!\n",
+			pfn, mfn);
=20
-	for (pfn =3D PFN_DOWN(start); pfn <=3D xen_max_p2m_pfn; pfn++)
 		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+	}
 }
=20
 static unsigned long __init xen_release_chunk(unsigned long start,
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fb65915..608257a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -386,6 +386,8 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(0x1b4b, 0x9192),
+	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte *=
/
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data =3D board_ahci_yes_fbs },
=20
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 8323fc3..3f1799b 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1625,10 +1625,8 @@ int drm_mode_cursor_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
=20
-	if (!req->flags) {
-		DRM_ERROR("no operation set\n");
+	if (!req->flags || (~DRM_MODE_CURSOR_FLAGS & req->flags))
 		return -EINVAL;
-	}
=20
 	mutex_lock(&dev->mode_config.mutex);
 	obj =3D drm_mode_object_find(dev, req->crtc_id, DRM_MODE_OBJECT_CRTC);
@@ -1641,7 +1639,6 @@ int drm_mode_cursor_ioctl(struct drm_device *dev,
=20
 	if (req->flags & DRM_MODE_CURSOR_BO) {
 		if (!crtc->funcs->cursor_set) {
-			DRM_ERROR("crtc does not support cursor\n");
 			ret =3D -ENXIO;
 			goto out;
 		}
@@ -1654,7 +1651,6 @@ int drm_mode_cursor_ioctl(struct drm_device *dev,
 		if (crtc->funcs->cursor_move) {
 			ret =3D crtc->funcs->cursor_move(crtc, req->x, req->y);
 		} else {
-			DRM_ERROR("crtc does not support cursor\n");
 			ret =3D -EFAULT;
 			goto out;
 		}
@@ -1692,14 +1688,11 @@ int drm_mode_addfb(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
=20
-	if ((config->min_width > r->width) || (r->width > config->max_width)) {
-		DRM_ERROR("mode new framebuffer width not within limits\n");
+	if ((config->min_width > r->width) || (r->width > config->max_width))
 		return -EINVAL;
-	}
-	if ((config->min_height > r->height) || (r->height > config->max_height))=
 {
-		DRM_ERROR("mode new framebuffer height not within limits\n");
+
+	if ((config->min_height > r->height) || (r->height > config->max_height))
 		return -EINVAL;
-	}
=20
 	mutex_lock(&dev->mode_config.mutex);
=20
@@ -1756,7 +1749,6 @@ int drm_mode_rmfb(struct drm_device *dev,
 	obj =3D drm_mode_object_find(dev, *id, DRM_MODE_OBJECT_FB);
 	/* TODO check that we really get a framebuffer back. */
 	if (!obj) {
-		DRM_ERROR("mode invalid framebuffer id\n");
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -1767,7 +1759,6 @@ int drm_mode_rmfb(struct drm_device *dev,
 			found =3D 1;
=20
 	if (!found) {
-		DRM_ERROR("tried to remove a fb that we didn't own\n");
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -1814,7 +1805,6 @@ int drm_mode_getfb(struct drm_device *dev,
 	mutex_lock(&dev->mode_config.mutex);
 	obj =3D drm_mode_object_find(dev, r->fb_id, DRM_MODE_OBJECT_FB);
 	if (!obj) {
-		DRM_ERROR("invalid framebuffer id\n");
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -1850,7 +1840,6 @@ int drm_mode_dirtyfb_ioctl(struct drm_device *dev,
 	mutex_lock(&dev->mode_config.mutex);
 	obj =3D drm_mode_object_find(dev, r->fb_id, DRM_MODE_OBJECT_FB);
 	if (!obj) {
-		DRM_ERROR("invalid framebuffer id\n");
 		ret =3D -EINVAL;
 		goto out_err1;
 	}
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index a1ee634..0c1a99b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -66,6 +66,8 @@
 #define EDID_QUIRK_FIRST_DETAILED_PREFERRED	(1 << 5)
 /* use +hsync +vsync for detailed mode */
 #define EDID_QUIRK_DETAILED_SYNC_PP		(1 << 6)
+/* Force reduced-blanking timings for detailed modes */
+#define EDID_QUIRK_FORCE_REDUCED_BLANKING	(1 << 7)
=20
 struct detailed_mode_closure {
 	struct drm_connector *connector;
@@ -85,6 +87,9 @@ static struct edid_quirk {
 	int product_id;
 	u32 quirks;
 } edid_quirk_list[] =3D {
+	/* ASUS VW222S */
+	{ "ACI", 0x22a2, EDID_QUIRK_FORCE_REDUCED_BLANKING },
+
 	/* Acer AL1706 */
 	{ "ACR", 44358, EDID_QUIRK_PREFER_LARGE_60 },
 	/* Acer F51 */
@@ -120,6 +125,9 @@ static struct edid_quirk {
 	/* Samsung SyncMaster 22[5-6]BW */
 	{ "SAM", 596, EDID_QUIRK_PREFER_LARGE_60 },
 	{ "SAM", 638, EDID_QUIRK_PREFER_LARGE_60 },
+
+	/* ViewSonic VA2026w */
+	{ "VSC", 5020, EDID_QUIRK_FORCE_REDUCED_BLANKING },
 };
=20
 /*** DDC fetch and block validation ***/
@@ -863,12 +871,19 @@ static struct drm_display_mode *drm_mode_detailed(str=
uct drm_device *dev,
 				"Wrong Hsync/Vsync pulse width\n");
 		return NULL;
 	}
+
+	if (quirks & EDID_QUIRK_FORCE_REDUCED_BLANKING) {
+		mode =3D drm_cvt_mode(dev, hactive, vactive, 60, true, false, false);
+		if (!mode)
+			return NULL;
+
+		goto set_size;
+	}
+
 	mode =3D drm_mode_create(dev);
 	if (!mode)
 		return NULL;
=20
-	mode->type =3D DRM_MODE_TYPE_DRIVER;
-
 	if (quirks & EDID_QUIRK_135_CLOCK_TOO_HIGH)
 		timing->pixel_clock =3D cpu_to_le16(1088);
=20
@@ -892,8 +907,6 @@ static struct drm_display_mode *drm_mode_detailed(struc=
t drm_device *dev,
=20
 	drm_mode_do_interlace_quirk(mode, pt);
=20
-	drm_mode_set_name(mode);
-
 	if (quirks & EDID_QUIRK_DETAILED_SYNC_PP) {
 		pt->misc |=3D DRM_EDID_PT_HSYNC_POSITIVE | DRM_EDID_PT_VSYNC_POSITIVE;
 	}
@@ -903,6 +916,7 @@ static struct drm_display_mode *drm_mode_detailed(struc=
t drm_device *dev,
 	mode->flags |=3D (pt->misc & DRM_EDID_PT_VSYNC_POSITIVE) ?
 		DRM_MODE_FLAG_PVSYNC : DRM_MODE_FLAG_NVSYNC;
=20
+set_size:
 	mode->width_mm =3D pt->width_mm_lo | (pt->width_height_mm_hi & 0xf0) << 4=
;
 	mode->height_mm =3D pt->height_mm_lo | (pt->width_height_mm_hi & 0xf) << =
8;
=20
@@ -916,6 +930,9 @@ static struct drm_display_mode *drm_mode_detailed(struc=
t drm_device *dev,
 		mode->height_mm =3D edid->height_cm * 10;
 	}
=20
+	mode->type =3D DRM_MODE_TYPE_DRIVER;
+	drm_mode_set_name(mode);
+
 	return mode;
 }
=20
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index 578ddfc..c8b5bc1 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2006,10 +2006,22 @@ static int i915_driver_irq_postinstall(struct drm_d=
evice *dev)
 			hotplug_en |=3D HDMIC_HOTPLUG_INT_EN;
 		if (dev_priv->hotplug_supported_mask & HDMID_HOTPLUG_INT_STATUS)
 			hotplug_en |=3D HDMID_HOTPLUG_INT_EN;
-		if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS)
-			hotplug_en |=3D SDVOC_HOTPLUG_INT_EN;
-		if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS)
-			hotplug_en |=3D SDVOB_HOTPLUG_INT_EN;
+		if (IS_G4X(dev)) {
+			if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS_G4X)
+				hotplug_en |=3D SDVOC_HOTPLUG_INT_EN;
+			if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS_G4X)
+				hotplug_en |=3D SDVOB_HOTPLUG_INT_EN;
+		} else if (IS_GEN4(dev)) {
+			if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS_I965)
+				hotplug_en |=3D SDVOC_HOTPLUG_INT_EN;
+			if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS_I965)
+				hotplug_en |=3D SDVOB_HOTPLUG_INT_EN;
+		} else {
+			if (dev_priv->hotplug_supported_mask & SDVOC_HOTPLUG_INT_STATUS_I915)
+				hotplug_en |=3D SDVOC_HOTPLUG_INT_EN;
+			if (dev_priv->hotplug_supported_mask & SDVOB_HOTPLUG_INT_STATUS_I915)
+				hotplug_en |=3D SDVOB_HOTPLUG_INT_EN;
+		}
 		if (dev_priv->hotplug_supported_mask & CRT_HOTPLUG_INT_STATUS) {
 			hotplug_en |=3D CRT_HOTPLUG_INT_EN;
=20
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index fd53122..4a5e662 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1419,14 +1419,20 @@
 #define   DPC_HOTPLUG_INT_STATUS		(1 << 28)
 #define   HDMID_HOTPLUG_INT_STATUS		(1 << 27)
 #define   DPD_HOTPLUG_INT_STATUS		(1 << 27)
+/* CRT/TV common between gen3+ */
 #define   CRT_HOTPLUG_INT_STATUS		(1 << 11)
 #define   TV_HOTPLUG_INT_STATUS			(1 << 10)
 #define   CRT_HOTPLUG_MONITOR_MASK		(3 << 8)
 #define   CRT_HOTPLUG_MONITOR_COLOR		(3 << 8)
 #define   CRT_HOTPLUG_MONITOR_MONO		(2 << 8)
 #define   CRT_HOTPLUG_MONITOR_NONE		(0 << 8)
-#define   SDVOC_HOTPLUG_INT_STATUS		(1 << 7)
-#define   SDVOB_HOTPLUG_INT_STATUS		(1 << 6)
+/* SDVO is different across gen3/4 */
+#define   SDVOC_HOTPLUG_INT_STATUS_G4X		(1 << 3)
+#define   SDVOB_HOTPLUG_INT_STATUS_G4X		(1 << 2)
+#define   SDVOC_HOTPLUG_INT_STATUS_I965		(3 << 4)
+#define   SDVOB_HOTPLUG_INT_STATUS_I965		(3 << 2)
+#define   SDVOC_HOTPLUG_INT_STATUS_I915		(1 << 7)
+#define   SDVOB_HOTPLUG_INT_STATUS_I915		(1 << 6)
=20
 /* SDVO port control */
 #define SDVOB			0x61140
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 3eed270..6c3fb44 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1072,8 +1072,8 @@ static void assert_pch_hdmi_disabled(struct drm_i915_=
private *dev_priv,
 				     enum pipe pipe, int reg)
 {
 	u32 val =3D I915_READ(reg);
-	WARN(hdmi_pipe_enabled(dev_priv, val, pipe),
-	     "PCH DP (0x%08x) enabled on transcoder %c, should be disabled\n",
+	WARN(hdmi_pipe_enabled(dev_priv, pipe, val),
+	     "PCH HDMI (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
=20
@@ -1089,13 +1089,13 @@ static void assert_pch_ports_disabled(struct drm_i9=
15_private *dev_priv,
=20
 	reg =3D PCH_ADPA;
 	val =3D I915_READ(reg);
-	WARN(adpa_pipe_enabled(dev_priv, val, pipe),
+	WARN(adpa_pipe_enabled(dev_priv, pipe, val),
 	     "PCH VGA enabled on transcoder %c, should be disabled\n",
 	     pipe_name(pipe));
=20
 	reg =3D PCH_LVDS;
 	val =3D I915_READ(reg);
-	WARN(lvds_pipe_enabled(dev_priv, val, pipe),
+	WARN(lvds_pipe_enabled(dev_priv, pipe, val),
 	     "PCH LVDS enabled on transcoder %c, should be disabled\n",
 	     pipe_name(pipe));
=20
@@ -1437,7 +1437,7 @@ static void disable_pch_hdmi(struct drm_i915_private =
*dev_priv,
 			     enum pipe pipe, int reg)
 {
 	u32 val =3D I915_READ(reg);
-	if (hdmi_pipe_enabled(dev_priv, val, pipe)) {
+	if (hdmi_pipe_enabled(dev_priv, pipe, val)) {
 		DRM_DEBUG_KMS("Disabling pch HDMI %x on pipe %d\n",
 			      reg, pipe);
 		I915_WRITE(reg, val & ~PORT_ENABLE);
@@ -1459,12 +1459,12 @@ static void intel_disable_pch_ports(struct drm_i915=
_private *dev_priv,
=20
 	reg =3D PCH_ADPA;
 	val =3D I915_READ(reg);
-	if (adpa_pipe_enabled(dev_priv, val, pipe))
+	if (adpa_pipe_enabled(dev_priv, pipe, val))
 		I915_WRITE(reg, val & ~ADPA_DAC_ENABLE);
=20
 	reg =3D PCH_LVDS;
 	val =3D I915_READ(reg);
-	if (lvds_pipe_enabled(dev_priv, val, pipe)) {
+	if (lvds_pipe_enabled(dev_priv, pipe, val)) {
 		DRM_DEBUG_KMS("disable lvds on pipe %d val 0x%08x\n", pipe, val);
 		I915_WRITE(reg, val & ~LVDS_PORT_EN);
 		POSTING_READ(reg);
@@ -2852,16 +2852,14 @@ static void intel_clear_scanline_wait(struct drm_de=
vice *dev)
=20
 static void intel_crtc_wait_for_pending_flips(struct drm_crtc *crtc)
 {
-	struct drm_i915_gem_object *obj;
-	struct drm_i915_private *dev_priv;
+	struct drm_device *dev =3D crtc->dev;
=20
 	if (crtc->fb =3D=3D NULL)
 		return;
=20
-	obj =3D to_intel_framebuffer(crtc->fb)->obj;
-	dev_priv =3D crtc->dev->dev_private;
-	wait_event(dev_priv->pending_flip_queue,
-		   atomic_read(&obj->pending_flip) =3D=3D 0);
+	mutex_lock(&dev->struct_mutex);
+	intel_finish_fb(crtc->fb);
+	mutex_unlock(&dev->struct_mutex);
 }
=20
 static bool intel_crtc_driving_pch(struct drm_crtc *crtc)
@@ -3322,23 +3320,6 @@ static void intel_crtc_disable(struct drm_crtc *crtc=
)
 	struct drm_crtc_helper_funcs *crtc_funcs =3D crtc->helper_private;
 	struct drm_device *dev =3D crtc->dev;
=20
-	/* Flush any pending WAITs before we disable the pipe. Note that
-	 * we need to drop the struct_mutex in order to acquire it again
-	 * during the lowlevel dpms routines around a couple of the
-	 * operations. It does not look trivial nor desirable to move
-	 * that locking higher. So instead we leave a window for the
-	 * submission of further commands on the fb before we can actually
-	 * disable it. This race with userspace exists anyway, and we can
-	 * only rely on the pipe being disabled by userspace after it
-	 * receives the hotplug notification and has flushed any pending
-	 * batches.
-	 */
-	if (crtc->fb) {
-		mutex_lock(&dev->struct_mutex);
-		intel_finish_fb(crtc->fb);
-		mutex_unlock(&dev->struct_mutex);
-	}
-
 	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
=20
 	if (crtc->fb) {
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index ceec71b..f07bde2 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -752,7 +752,7 @@ static const struct dmi_system_id intel_no_lvds[] =3D {
 		.ident =3D "Hewlett-Packard t5745",
 		.matches =3D {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "hp t5745"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "hp t5745"),
 		},
 	},
 	{
@@ -760,7 +760,7 @@ static const struct dmi_system_id intel_no_lvds[] =3D {
 		.ident =3D "Hewlett-Packard st5747",
 		.matches =3D {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "hp st5747"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "hp st5747"),
 		},
 	},
 	{
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel=
_sdvo.c
index a8d8ee5..bbf247c 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2514,6 +2514,7 @@ bool intel_sdvo_init(struct drm_device *dev, int sdvo=
_reg)
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	struct intel_encoder *intel_encoder;
 	struct intel_sdvo *intel_sdvo;
+	u32 hotplug_mask;
 	int i;
=20
 	intel_sdvo =3D kzalloc(sizeof(struct intel_sdvo), GFP_KERNEL);
@@ -2544,10 +2545,17 @@ bool intel_sdvo_init(struct drm_device *dev, int sd=
vo_reg)
 		}
 	}
=20
-	if (IS_SDVOB(sdvo_reg))
-		dev_priv->hotplug_supported_mask |=3D SDVOB_HOTPLUG_INT_STATUS;
-	else
-		dev_priv->hotplug_supported_mask |=3D SDVOC_HOTPLUG_INT_STATUS;
+	hotplug_mask =3D 0;
+	if (IS_G4X(dev)) {
+		hotplug_mask =3D IS_SDVOB(sdvo_reg) ?
+			SDVOB_HOTPLUG_INT_STATUS_G4X : SDVOC_HOTPLUG_INT_STATUS_G4X;
+	} else if (IS_GEN4(dev)) {
+		hotplug_mask =3D IS_SDVOB(sdvo_reg) ?
+			SDVOB_HOTPLUG_INT_STATUS_I965 : SDVOC_HOTPLUG_INT_STATUS_I965;
+	} else {
+		hotplug_mask =3D IS_SDVOB(sdvo_reg) ?
+			SDVOB_HOTPLUG_INT_STATUS_I915 : SDVOC_HOTPLUG_INT_STATUS_I915;
+	}
=20
 	drm_encoder_helper_add(&intel_encoder->base, &intel_sdvo_helper_funcs);
=20
@@ -2555,14 +2563,6 @@ bool intel_sdvo_init(struct drm_device *dev, int sdv=
o_reg)
 	if (!intel_sdvo_get_capabilities(intel_sdvo, &intel_sdvo->caps))
 		goto err;
=20
-	/* Set up hotplug command - note paranoia about contents of reply.
-	 * We assume that the hardware is in a sane state, and only touch
-	 * the bits we think we understand.
-	 */
-	intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_ACTIVE_HOT_PLUG,
-			     &intel_sdvo->hotplug_active, 2);
-	intel_sdvo->hotplug_active[0] &=3D ~0x3;
-
 	if (intel_sdvo_output_setup(intel_sdvo,
 				    intel_sdvo->caps.output_flags) !=3D true) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
@@ -2570,6 +2570,12 @@ bool intel_sdvo_init(struct drm_device *dev, int sdv=
o_reg)
 		goto err;
 	}
=20
+	/* Only enable the hotplug irq if we need it, to work around noisy
+	 * hotplug lines.
+	 */
+	if (intel_sdvo->hotplug_active[0])
+		dev_priv->hotplug_supported_mask |=3D hotplug_mask;
+
 	intel_sdvo_select_ddc_bus(dev_priv, intel_sdvo, sdvo_reg);
=20
 	/* Set the input timing to the screen. Assume always input 0. */
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/no=
uveau/nouveau_display.c
index b12fd2c..6adef06 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -381,7 +381,7 @@ nouveau_display_dumb_create(struct drm_file *file_priv,=
 struct drm_device *dev,
 	args->size =3D args->pitch * args->height;
 	args->size =3D roundup(args->size, PAGE_SIZE);
=20
-	ret =3D nouveau_gem_new(dev, args->size, 0, TTM_PL_FLAG_VRAM, 0, 0, &bo);
+	ret =3D nouveau_gem_new(dev, args->size, 0, NOUVEAU_GEM_DOMAIN_VRAM, 0, 0=
, &bo);
 	if (ret)
 		return ret;
=20
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeo=
n/atombios_crtc.c
index 757c549..ceffd20 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1446,14 +1446,98 @@ static void radeon_legacy_atom_fixup(struct drm_crt=
c *crtc)
 	}
 }
=20
+/**
+ * radeon_get_pll_use_mask - look up a mask of which pplls are in use
+ *
+ * @crtc: drm crtc
+ *
+ * Returns the mask of which PPLLs (Pixel PLLs) are in use.
+ */
+static u32 radeon_get_pll_use_mask(struct drm_crtc *crtc)
+{
+	struct drm_device *dev =3D crtc->dev;
+	struct drm_crtc *test_crtc;
+	struct radeon_crtc *radeon_test_crtc;
+	u32 pll_in_use =3D 0;
+
+	list_for_each_entry(test_crtc, &dev->mode_config.crtc_list, head) {
+		if (crtc =3D=3D test_crtc)
+			continue;
+
+		radeon_test_crtc =3D to_radeon_crtc(test_crtc);
+		if (radeon_test_crtc->pll_id !=3D ATOM_PPLL_INVALID)
+			pll_in_use |=3D (1 << radeon_test_crtc->pll_id);
+	}
+	return pll_in_use;
+}
+
+/**
+ * radeon_get_shared_dp_ppll - return the PPLL used by another crtc for DP
+ *
+ * @crtc: drm crtc
+ *
+ * Returns the PPLL (Pixel PLL) used by another crtc/encoder which is
+ * also in DP mode.  For DP, a single PPLL can be used for all DP
+ * crtcs/encoders.
+ */
+static int radeon_get_shared_dp_ppll(struct drm_crtc *crtc)
+{
+	struct drm_device *dev =3D crtc->dev;
+	struct drm_encoder *test_encoder;
+	struct radeon_crtc *radeon_test_crtc;
+
+	list_for_each_entry(test_encoder, &dev->mode_config.encoder_list, head) {
+		if (test_encoder->crtc && (test_encoder->crtc !=3D crtc)) {
+			if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
+				/* for DP use the same PLL for all */
+				radeon_test_crtc =3D to_radeon_crtc(test_encoder->crtc);
+				if (radeon_test_crtc->pll_id !=3D ATOM_PPLL_INVALID)
+					return radeon_test_crtc->pll_id;
+			}
+		}
+	}
+	return ATOM_PPLL_INVALID;
+}
+
+/**
+ * radeon_atom_pick_pll - Allocate a PPLL for use by the crtc.
+ *
+ * @crtc: drm crtc
+ *
+ * Returns the PPLL (Pixel PLL) to be used by the crtc.  For DP monitors
+ * a single PPLL can be used for all DP crtcs/encoders.  For non-DP
+ * monitors a dedicated PPLL must be used.  If a particular board has
+ * an external DP PLL, return ATOM_PPLL_INVALID to skip PLL programming
+ * as there is no need to program the PLL itself.  If we are not able to
+ * allocate a PLL, return ATOM_PPLL_INVALID to skip PLL programming to
+ * avoid messing up an existing monitor.
+ *
+ * Asic specific PLL information
+ *
+ * DCE 6.1
+ * - PPLL2 is only available to UNIPHYA (both DP and non-DP)
+ * - PPLL0, PPLL1 are available for UNIPHYB/C/D/E/F (both DP and non-DP)
+ *
+ * DCE 6.0
+ * - PPLL0 is available to all UNIPHY (DP only)
+ * - PPLL1, PPLL2 are available for all UNIPHY (both DP and non-DP) and DA=
C
+ *
+ * DCE 5.0
+ * - DCPLL is available to all UNIPHY (DP only)
+ * - PPLL1, PPLL2 are available for all UNIPHY (both DP and non-DP) and DA=
C
+ *
+ * DCE 3.0/4.0/4.1
+ * - PPLL1, PPLL2 are available for all UNIPHY (both DP and non-DP) and DA=
C
+ *
+ */
 static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 {
 	struct radeon_crtc *radeon_crtc =3D to_radeon_crtc(crtc);
 	struct drm_device *dev =3D crtc->dev;
 	struct radeon_device *rdev =3D dev->dev_private;
 	struct drm_encoder *test_encoder;
-	struct drm_crtc *test_crtc;
-	uint32_t pll_in_use =3D 0;
+	u32 pll_in_use;
+	int pll;
=20
 	if (ASIC_IS_DCE4(rdev)) {
 		list_for_each_entry(test_encoder, &dev->mode_config.encoder_list, head) =
{
@@ -1461,35 +1545,39 @@ static int radeon_atom_pick_pll(struct drm_crtc *cr=
tc)
 				/* in DP mode, the DP ref clock can come from PPLL, DCPLL, or ext cloc=
k,
 				 * depending on the asic:
 				 * DCE4: PPLL or ext clock
-				 * DCE5: DCPLL or ext clock
+				 * DCE5: PPLL, DCPLL, or ext clock
 				 *
 				 * Setting ATOM_PPLL_INVALID will cause SetPixelClock to skip
 				 * PPLL/DCPLL programming and only program the DP DTO for the
 				 * crtc virtual pixel clock.
 				 */
 				if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
-					if (ASIC_IS_DCE5(rdev) || rdev->clock.dp_extclk)
+					if (rdev->clock.dp_extclk)
+						/* skip PPLL programming if using ext clock */
 						return ATOM_PPLL_INVALID;
+					else if (ASIC_IS_DCE5(rdev))
+						/* use DCPLL for all DP */
+						return ATOM_DCPLL;
+					else {
+						/* use the same PPLL for all DP monitors */
+						pll =3D radeon_get_shared_dp_ppll(crtc);
+						if (pll !=3D ATOM_PPLL_INVALID)
+							return pll;
+					}
 				}
+				break;
 			}
 		}
-
-		/* otherwise, pick one of the plls */
-		list_for_each_entry(test_crtc, &dev->mode_config.crtc_list, head) {
-			struct radeon_crtc *radeon_test_crtc;
-
-			if (crtc =3D=3D test_crtc)
-				continue;
-
-			radeon_test_crtc =3D to_radeon_crtc(test_crtc);
-			if ((radeon_test_crtc->pll_id >=3D ATOM_PPLL1) &&
-			    (radeon_test_crtc->pll_id <=3D ATOM_PPLL2))
-				pll_in_use |=3D (1 << radeon_test_crtc->pll_id);
-		}
-		if (!(pll_in_use & 1))
+		/* all other cases */
+		pll_in_use =3D radeon_get_pll_use_mask(crtc);
+		if (!(pll_in_use & (1 << ATOM_PPLL2)))
+			return ATOM_PPLL2;
+		if (!(pll_in_use & (1 << ATOM_PPLL1)))
 			return ATOM_PPLL1;
-		return ATOM_PPLL2;
+		DRM_ERROR("unable to allocate a PPLL\n");
+		return ATOM_PPLL_INVALID;
 	} else
+		/* use PPLL1 or PPLL2 */
 		return radeon_crtc->crtc_id;
=20
 }
@@ -1578,10 +1666,25 @@ static void atombios_crtc_commit(struct drm_crtc *c=
rtc)
 static void atombios_crtc_disable(struct drm_crtc *crtc)
 {
 	struct radeon_crtc *radeon_crtc =3D to_radeon_crtc(crtc);
+	struct drm_device *dev =3D crtc->dev;
+	struct radeon_device *rdev =3D dev->dev_private;
 	struct radeon_atom_ss ss;
+	int i;
=20
 	atombios_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
=20
+	for (i =3D 0; i < rdev->num_crtc; i++) {
+		if (rdev->mode_info.crtcs[i] &&
+		    rdev->mode_info.crtcs[i]->enabled &&
+		    i !=3D radeon_crtc->crtc_id &&
+		    radeon_crtc->pll_id =3D=3D rdev->mode_info.crtcs[i]->pll_id) {
+			/* one other crtc is using this pll don't turn
+			 * off the pll
+			 */
+			goto done;
+		}
+	}
+
 	switch (radeon_crtc->pll_id) {
 	case ATOM_PPLL1:
 	case ATOM_PPLL2:
@@ -1592,7 +1695,8 @@ static void atombios_crtc_disable(struct drm_crtc *cr=
tc)
 	default:
 		break;
 	}
-	radeon_crtc->pll_id =3D -1;
+done:
+	radeon_crtc->pll_id =3D ATOM_PPLL_INVALID;
 }
=20
 static const struct drm_crtc_helper_funcs atombios_helper_funcs =3D {
@@ -1641,6 +1745,6 @@ void radeon_atombios_init_crtc(struct drm_device *dev=
,
 		else
 			radeon_crtc->crtc_offset =3D 0;
 	}
-	radeon_crtc->pll_id =3D -1;
+	radeon_crtc->pll_id =3D ATOM_PPLL_INVALID;
 	drm_crtc_helper_add(&radeon_crtc->base, &atombios_helper_funcs);
 }
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/r=
adeon/atombios_encoders.c
index 5351ee1..382e141 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1344,6 +1344,8 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *enco=
der, int mode)
 	struct drm_device *dev =3D encoder->dev;
 	struct radeon_device *rdev =3D dev->dev_private;
 	struct radeon_encoder *radeon_encoder =3D to_radeon_encoder(encoder);
+	struct drm_encoder *ext_encoder =3D radeon_get_external_encoder(encoder);
+	struct radeon_encoder_atom_dig *dig =3D radeon_encoder->enc_priv;
 	struct drm_connector *connector =3D radeon_get_connector_for_encoder(enco=
der);
 	struct radeon_connector *radeon_connector =3D NULL;
 	struct radeon_connector_atom_dig *radeon_dig_connector =3D NULL;
@@ -1355,12 +1357,38 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *en=
coder, int mode)
=20
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
-		/* some early dce3.2 boards have a bug in their transmitter control tabl=
e */
-		if ((rdev->family =3D=3D CHIP_RV710) || (rdev->family =3D=3D CHIP_RV730)=
 ||
-		    ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
+		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+			if (!connector)
+				dig->panel_mode =3D DP_PANEL_MODE_EXTERNAL_DP_MODE;
+			else
+				dig->panel_mode =3D radeon_dp_get_panel_mode(encoder, connector);
+
+			/* setup and enable the encoder */
+			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
+			atombios_dig_encoder_setup(encoder,
+						   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
+						   dig->panel_mode);
+			if (ext_encoder) {
+				if (ASIC_IS_DCE41(rdev))
+					atombios_external_encoder_setup(encoder, ext_encoder,
+									EXTERNAL_ENCODER_ACTION_V3_ENCODER_SETUP);
+			}
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE,=
 0, 0);
+		} else if (ASIC_IS_DCE4(rdev)) {
+			/* setup and enable the encoder */
+			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
+			/* enable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE,=
 0, 0);
-		else
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_=
OUTPUT, 0, 0);
+		} else {
+			/* setup and enable the encoder and transmitter */
+			atombios_dig_encoder_setup(encoder, ATOM_ENABLE, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, =
0, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE,=
 0, 0);
+			/* some early dce3.2 boards have a bug in their transmitter control tab=
le */
+			if ((rdev->family !=3D CHIP_RV710) || (rdev->family !=3D CHIP_RV730))
+				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE=
_OUTPUT, 0, 0);
+		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector)=
 {
 			if (connector->connector_type =3D=3D DRM_MODE_CONNECTOR_eDP) {
 				atombios_set_edp_panel_power(connector,
@@ -1377,10 +1405,19 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *en=
coder, int mode)
 	case DRM_MODE_DPMS_STANDBY:
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
-		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
+		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+			/* disable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
-		else
+		} else if (ASIC_IS_DCE4(rdev)) {
+			/* disable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
_OUTPUT, 0, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
+		} else {
+			/* disable the encoder and transmitter */
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
_OUTPUT, 0, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
+			atombios_dig_encoder_setup(encoder, ATOM_DISABLE, 0);
+		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector)=
 {
 			if (ASIC_IS_DCE4(rdev))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_OFF, 0);
@@ -1805,10 +1842,12 @@ radeon_atom_encoder_mode_set(struct drm_encoder *en=
coder,
 	struct drm_device *dev =3D encoder->dev;
 	struct radeon_device *rdev =3D dev->dev_private;
 	struct radeon_encoder *radeon_encoder =3D to_radeon_encoder(encoder);
-	struct drm_encoder *ext_encoder =3D radeon_get_external_encoder(encoder);
=20
 	radeon_encoder->pixel_clock =3D adjusted_mode->clock;
=20
+	/* need to call this here rather than in prepare() since we need some crt=
c info */
+	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+
 	if (ASIC_IS_AVIVO(rdev) && !ASIC_IS_DCE4(rdev)) {
 		if (radeon_encoder->active_device & (ATOM_DEVICE_CV_SUPPORT | ATOM_DEVIC=
E_TV_SUPPORT))
 			atombios_yuv_setup(encoder, true);
@@ -1827,38 +1866,7 @@ radeon_atom_encoder_mode_set(struct drm_encoder *enc=
oder,
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
-		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
-			struct drm_connector *connector =3D radeon_get_connector_for_encoder(en=
coder);
-			struct radeon_encoder_atom_dig *dig =3D radeon_encoder->enc_priv;
-
-			if (!connector)
-				dig->panel_mode =3D DP_PANEL_MODE_EXTERNAL_DP_MODE;
-			else
-				dig->panel_mode =3D radeon_dp_get_panel_mode(encoder, connector);
-
-			/* setup and enable the encoder */
-			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
-			atombios_dig_encoder_setup(encoder,
-						   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
-						   dig->panel_mode);
-		} else if (ASIC_IS_DCE4(rdev)) {
-			/* disable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
-			/* setup and enable the encoder */
-			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
-
-			/* enable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE,=
 0, 0);
-		} else {
-			/* disable the encoder and transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
-			atombios_dig_encoder_setup(encoder, ATOM_DISABLE, 0);
-
-			/* setup and enable the encoder and transmitter */
-			atombios_dig_encoder_setup(encoder, ATOM_ENABLE, 0);
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, =
0, 0);
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE,=
 0, 0);
-		}
+		/* handled in dpms */
 		break;
 	case ENCODER_OBJECT_ID_INTERNAL_DDI:
 	case ENCODER_OBJECT_ID_INTERNAL_DVO1:
@@ -1879,14 +1887,6 @@ radeon_atom_encoder_mode_set(struct drm_encoder *enc=
oder,
 		break;
 	}
=20
-	if (ext_encoder) {
-		if (ASIC_IS_DCE41(rdev))
-			atombios_external_encoder_setup(encoder, ext_encoder,
-							EXTERNAL_ENCODER_ACTION_V3_ENCODER_SETUP);
-		else
-			atombios_external_encoder_setup(encoder, ext_encoder, ATOM_ENABLE);
-	}
-
 	atombios_apply_encoder_quirks(encoder, adjusted_mode);
=20
 	if (atombios_get_encoder_mode(encoder) =3D=3D ATOM_ENCODER_MODE_HDMI) {
@@ -2059,7 +2059,6 @@ static void radeon_atom_encoder_prepare(struct drm_en=
coder *encoder)
 	}
=20
 	radeon_atom_output_lock(encoder, true);
-	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
=20
 	if (connector) {
 		struct radeon_connector *radeon_connector =3D to_radeon_connector(connec=
tor);
@@ -2080,6 +2079,7 @@ static void radeon_atom_encoder_prepare(struct drm_en=
coder *encoder)
=20
 static void radeon_atom_encoder_commit(struct drm_encoder *encoder)
 {
+	/* need to call this here as we need the crtc set up */
 	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_ON);
 	radeon_atom_output_lock(encoder, false);
 }
@@ -2120,14 +2120,7 @@ static void radeon_atom_encoder_disable(struct drm_e=
ncoder *encoder)
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
-		if (ASIC_IS_DCE4(rdev))
-			/* disable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
-		else {
-			/* disable the encoder and transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE=
, 0, 0);
-			atombios_dig_encoder_setup(encoder, ATOM_DISABLE, 0);
-		}
+		/* handled in dpms */
 		break;
 	case ENCODER_OBJECT_ID_INTERNAL_DDI:
 	case ENCODER_OBJECT_ID_INTERNAL_DVO1:
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeo=
n/radeon_device.c
index 9231564..c5762e3 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -761,7 +761,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	if (rdev->flags & RADEON_IS_AGP)
 		rdev->need_dma32 =3D true;
 	if ((rdev->flags & RADEON_IS_PCI) &&
-	    (rdev->family < CHIP_RS400))
+	    (rdev->family <=3D CHIP_RS740))
 		rdev->need_dma32 =3D true;
=20
 	dma_bits =3D rdev->need_dma32 ? 32 : 40;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_drv.c
index dff8fc7..033fc96 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -178,6 +178,7 @@ static struct pci_device_id vmw_pci_id_list[] =3D {
 	{0x15ad, 0x0405, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VMWGFX_CHIP_SVGAII},
 	{0, 0, 0}
 };
+MODULE_DEVICE_TABLE(pci, vmw_pci_id_list);
=20
 static int enable_fbdev;
=20
@@ -1088,6 +1089,11 @@ static struct drm_driver driver =3D {
 	.master_drop =3D vmw_master_drop,
 	.open =3D vmw_driver_open,
 	.postclose =3D vmw_postclose,
+
+	.dumb_create =3D vmw_dumb_create,
+	.dumb_map_offset =3D vmw_dumb_map_offset,
+	.dumb_destroy =3D vmw_dumb_destroy,
+
 	.fops =3D {
 		 .owner =3D THIS_MODULE,
 		 .open =3D drm_open,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/v=
mwgfx_drv.h
index dc27970..0e3fa7d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -641,6 +641,16 @@ int vmw_kms_readback(struct vmw_private *dev_priv,
 int vmw_kms_update_layout_ioctl(struct drm_device *dev, void *data,
 				struct drm_file *file_priv);
=20
+int vmw_dumb_create(struct drm_file *file_priv,
+		    struct drm_device *dev,
+		    struct drm_mode_create_dumb *args);
+
+int vmw_dumb_map_offset(struct drm_file *file_priv,
+			struct drm_device *dev, uint32_t handle,
+			uint64_t *offset);
+int vmw_dumb_destroy(struct drm_file *file_priv,
+		     struct drm_device *dev,
+		     uint32_t handle);
 /**
  * Overlay control - vmwgfx_overlay.c
  */
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmw=
gfx/vmwgfx_resource.c
index 1c7f09e..0795d17 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1950,3 +1950,76 @@ err_ref:
 	vmw_resource_unreference(&res);
 	return ret;
 }
+
+
+int vmw_dumb_create(struct drm_file *file_priv,
+		    struct drm_device *dev,
+		    struct drm_mode_create_dumb *args)
+{
+	struct vmw_private *dev_priv =3D vmw_priv(dev);
+	struct vmw_master *vmaster =3D vmw_master(file_priv->master);
+	struct vmw_user_dma_buffer *vmw_user_bo;
+	struct ttm_buffer_object *tmp;
+	int ret;
+
+	args->pitch =3D args->width * ((args->bpp + 7) / 8);
+	args->size =3D args->pitch * args->height;
+
+	vmw_user_bo =3D kzalloc(sizeof(*vmw_user_bo), GFP_KERNEL);
+	if (vmw_user_bo =3D=3D NULL)
+		return -ENOMEM;
+
+	ret =3D ttm_read_lock(&vmaster->lock, true);
+	if (ret !=3D 0) {
+		kfree(vmw_user_bo);
+		return ret;
+	}
+
+	ret =3D vmw_dmabuf_init(dev_priv, &vmw_user_bo->dma, args->size,
+			      &vmw_vram_sys_placement, true,
+			      &vmw_user_dmabuf_destroy);
+	if (ret !=3D 0)
+		goto out_no_dmabuf;
+
+	tmp =3D ttm_bo_reference(&vmw_user_bo->dma.base);
+	ret =3D ttm_base_object_init(vmw_fpriv(file_priv)->tfile,
+				   &vmw_user_bo->base,
+				   false,
+				   ttm_buffer_type,
+				   &vmw_user_dmabuf_release, NULL);
+	if (unlikely(ret !=3D 0))
+		goto out_no_base_object;
+
+	args->handle =3D vmw_user_bo->base.hash.key;
+
+out_no_base_object:
+	ttm_bo_unref(&tmp);
+out_no_dmabuf:
+	ttm_read_unlock(&vmaster->lock);
+	return ret;
+}
+
+int vmw_dumb_map_offset(struct drm_file *file_priv,
+			struct drm_device *dev, uint32_t handle,
+			uint64_t *offset)
+{
+	struct ttm_object_file *tfile =3D vmw_fpriv(file_priv)->tfile;
+	struct vmw_dma_buffer *out_buf;
+	int ret;
+
+	ret =3D vmw_user_dmabuf_lookup(tfile, handle, &out_buf);
+	if (ret !=3D 0)
+		return -EINVAL;
+
+	*offset =3D out_buf->base.addr_space_offset;
+	vmw_dmabuf_unreference(&out_buf);
+	return 0;
+}
+
+int vmw_dumb_destroy(struct drm_file *file_priv,
+		     struct drm_device *dev,
+		     uint32_t handle)
+{
+	return ttm_ref_object_base_unref(vmw_fpriv(file_priv)->tfile,
+					 handle, TTM_REF_USAGE);
+}
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index d21f6d0..b5cc078 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -350,6 +350,7 @@ config HID_MULTITOUCH
 	  - Lumio CrystalTouch panels
 	  - MosArt dual-touch panels
 	  - PenMount dual touch panels
+	  - PixArt optical touch screen
 	  - Pixcir dual touch panels
 	  - eGalax dual-touch panels, including the Joojoo and Wetab tablets
 	  - Stantum multitouch panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5cc029f..0c8bea9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1507,6 +1507,9 @@ static const struct hid_device_id hid_have_special_dr=
iver[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_RE=
MOTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH=
_SCREEN) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH=
_SCREEN1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH=
_SCREEN2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH=
) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_O=
PTICAL_TOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e4317a2..ab75a4e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -593,6 +593,11 @@
 #define USB_VENDOR_ID_PI_ENGINEERING	0x05f3
 #define USB_DEVICE_ID_PI_ENGINEERING_VEC_USB_FOOTPEDAL	0xff
=20
+#define USB_VENDOR_ID_PIXART				0x093a
+#define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN	0x8001
+#define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1	0x8002
+#define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2	0x8003
+
 #define USB_VENDOR_ID_PLAYDOTCOM	0x0b43
 #define USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII	0x0003
=20
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 995fc4c..13af0f1 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -93,6 +93,7 @@ struct mt_class {
 #define MT_CLS_DUAL_INRANGE_CONTACTID		0x0005
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0006
 #define MT_CLS_DUAL_NSMU_CONTACTID		0x0007
+#define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
=20
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -155,6 +156,9 @@ struct mt_class mt_classes[] =3D {
 		.quirks =3D MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_SLOT_IS_CONTACTID,
 		.maxcontacts =3D 2 },
+	{ .name =3D MT_CLS_INRANGE_CONTACTNUMBER,
+		.quirks =3D MT_QUIRK_VALID_IS_INRANGE |
+			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
=20
 	/*
 	 * vendor specific classes
@@ -744,6 +748,17 @@ static const struct hid_device_id mt_devices[] =3D {
 		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
 			USB_DEVICE_ID_PENMOUNT_PCI) },
=20
+	/* PixArt optical touch screen */
+	{ .driver_data =3D MT_CLS_INRANGE_CONTACTNUMBER,
+		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN) },
+	{ .driver_data =3D MT_CLS_INRANGE_CONTACTNUMBER,
+		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1) },
+	{ .driver_data =3D MT_CLS_INRANGE_CONTACTNUMBER,
+		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2) },
+
 	/* PixCir-based panels */
 	{ .driver_data =3D MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirk=
s.c
index 1fe6b80..afb73af 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -68,6 +68,10 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QU=
IRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_Q=
UIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_Q=
UIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET =
},
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SC=
REEN, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 00e9851..83d2fbd6 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -34,6 +34,12 @@ static const struct dmi_system_id __initconst atk_force_=
new_if[] =3D {
 		.matches =3D {
 			DMI_MATCH(DMI_BOARD_NAME, "SABERTOOTH X58")
 		}
+	}, {
+		/* Old interface reads the same sensor for fan0 and fan1 */
+		.ident =3D "Asus M5A78L",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_NAME, "M5A78L")
+		}
 	},
 	{ }
 };
diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-mad=
c-hwmon.c
index 0018c7d..1a174f0 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -44,12 +44,13 @@ static ssize_t madc_read(struct device *dev,
 			 struct device_attribute *devattr, char *buf)
 {
 	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
-	struct twl4030_madc_request req;
+	struct twl4030_madc_request req =3D {
+		.channels =3D 1 << attr->index,
+		.method =3D TWL4030_MADC_SW2,
+		.type =3D TWL4030_MADC_WAIT,
+	};
 	long val;
=20
-	req.channels =3D (1 << attr->index);
-	req.method =3D TWL4030_MADC_SW2;
-	req.func_cb =3D NULL;
 	val =3D twl4030_madc_conversion(&req);
 	if (val < 0)
 		return val;
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index a3afac4..60f593c 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -103,6 +103,8 @@ config I2C_I801
 	    Patsburg (PCH)
 	    DH89xxCC (PCH)
 	    Panther Point (PCH)
+	    Lynx Point (PCH)
+	    Lynx Point-LP (PCH)
=20
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
@@ -349,9 +351,13 @@ config I2C_DAVINCI
 	  devices such as DaVinci NIC.
 	  For details please see http://www.ti.com/davinci
=20
+config I2C_DESIGNWARE_CORE
+	tristate
+
 config I2C_DESIGNWARE_PLATFORM
 	tristate "Synopsys DesignWare Platfrom"
 	depends on HAVE_CLK
+	select I2C_DESIGNWARE_CORE
 	help
 	  If you say yes to this option, support will be included for the
 	  Synopsys DesignWare I2C adapter. Only master mode is supported.
@@ -362,6 +368,7 @@ config I2C_DESIGNWARE_PLATFORM
 config I2C_DESIGNWARE_PCI
 	tristate "Synopsys DesignWare PCI"
 	depends on PCI
+	select I2C_DESIGNWARE_CORE
 	help
 	  If you say yes to this option, support will be included for the
 	  Synopsys DesignWare I2C adapter. Only master mode is supported.
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index fba6da6..d6b8779 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -33,10 +33,11 @@ obj-$(CONFIG_I2C_AU1550)	+=3D i2c-au1550.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+=3D i2c-bfin-twi.o
 obj-$(CONFIG_I2C_CPM)		+=3D i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+=3D i2c-davinci.o
+obj-$(CONFIG_I2C_DESIGNWARE_CORE)	+=3D i2c-designware-core.o
 obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+=3D i2c-designware-platform.o
-i2c-designware-platform-objs :=3D i2c-designware-platdrv.o i2c-designware-=
core.o
+i2c-designware-platform-objs :=3D i2c-designware-platdrv.o
 obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+=3D i2c-designware-pci.o
-i2c-designware-pci-objs :=3D i2c-designware-pcidrv.o i2c-designware-core.o
+i2c-designware-pci-objs :=3D i2c-designware-pcidrv.o
 obj-$(CONFIG_I2C_GPIO)		+=3D i2c-gpio.o
 obj-$(CONFIG_I2C_HIGHLANDER)	+=3D i2c-highlander.o
 obj-$(CONFIG_I2C_IBM_IIC)	+=3D i2c-ibm_iic.o
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/=
i2c-designware-core.c
index df87992..6193349 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -25,6 +25,7 @@
  * -----------------------------------------------------------------------=
-----
  *
  */
+#include <linux/export.h>
 #include <linux/clk.h>
 #include <linux/errno.h>
 #include <linux/err.h>
@@ -305,6 +306,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	dw_writel(dev, dev->master_cfg , DW_IC_CON);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(i2c_dw_init);
=20
 /*
  * Waiting for bus not busy
@@ -557,12 +559,14 @@ done:
=20
 	return ret;
 }
+EXPORT_SYMBOL_GPL(i2c_dw_xfer);
=20
 u32 i2c_dw_func(struct i2c_adapter *adap)
 {
 	struct dw_i2c_dev *dev =3D i2c_get_adapdata(adap);
 	return dev->functionality;
 }
+EXPORT_SYMBOL_GPL(i2c_dw_func);
=20
 static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
 {
@@ -667,17 +671,20 @@ tx_aborted:
=20
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(i2c_dw_isr);
=20
 void i2c_dw_enable(struct dw_i2c_dev *dev)
 {
        /* Enable the adapter */
 	dw_writel(dev, 1, DW_IC_ENABLE);
 }
+EXPORT_SYMBOL_GPL(i2c_dw_enable);
=20
 u32 i2c_dw_is_enabled(struct dw_i2c_dev *dev)
 {
 	return dw_readl(dev, DW_IC_ENABLE);
 }
+EXPORT_SYMBOL_GPL(i2c_dw_is_enabled);
=20
 void i2c_dw_disable(struct dw_i2c_dev *dev)
 {
@@ -688,18 +695,22 @@ void i2c_dw_disable(struct dw_i2c_dev *dev)
 	dw_writel(dev, 0, DW_IC_INTR_MASK);
 	dw_readl(dev, DW_IC_CLR_INTR);
 }
+EXPORT_SYMBOL_GPL(i2c_dw_disable);
=20
 void i2c_dw_clear_int(struct dw_i2c_dev *dev)
 {
 	dw_readl(dev, DW_IC_CLR_INTR);
 }
+EXPORT_SYMBOL_GPL(i2c_dw_clear_int);
=20
 void i2c_dw_disable_int(struct dw_i2c_dev *dev)
 {
 	dw_writel(dev, 0, DW_IC_INTR_MASK);
 }
+EXPORT_SYMBOL_GPL(i2c_dw_disable_int);
=20
 u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev)
 {
 	return dw_readl(dev, DW_IC_COMP_PARAM_1);
 }
+EXPORT_SYMBOL_GPL(i2c_dw_read_comp_param);
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ab26840d..817d025 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -51,6 +51,8 @@
   Patsburg (PCH) IDF    0x1d72     32     hard     yes     yes     yes
   DH89xxCC (PCH)        0x2330     32     hard     yes     yes     yes
   Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
+  Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
+  Lynx Point-LP (PCH)   0x9c22     32     hard     yes     yes     yes
=20
   Features supported by this driver:
   Software PEC                     no
@@ -145,6 +147,8 @@
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
=20
 struct i801_priv {
 	struct i2c_adapter adapter;
@@ -633,6 +637,8 @@ static const struct pci_device_id i801_ids[] =3D {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2=
) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS)=
 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS)=
 },
 	{ 0, }
 };
=20
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8=
042-x86ia64io.h
index b4cfc6c..d4ec371 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -177,6 +177,20 @@ static const struct dmi_system_id __initconst i8042_dm=
i_noloop_table[] =3D {
 		},
 	},
 	{
+		/* Gigabyte T1005 - defines wrong chassis type ("Other") */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T1005"),
+		},
+	},
+	{
+		/* Gigabyte T1005M/P - defines wrong chassis type ("Other") */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T1005M/P"),
+		},
+	},
+	{
 		.matches =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnl=
oop.c
index d497db0..509135f 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
=20
-static char *revision =3D "$Revision: 1.11.6.7 $";
 static char *isdnloop_id =3D "loop0";
=20
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card"=
);
@@ -1494,17 +1493,6 @@ isdnloop_addcard(char *id1)
 static int __init
 isdnloop_init(void)
 {
-	char *p;
-	char rev[10];
-
-	if ((p =3D strchr(revision, ':'))) {
-		strcpy(rev, p + 1);
-		p =3D strchr(rev, '$');
-		*p =3D 0;
-	} else
-		strcpy(rev, " ??? ");
-	printk(KERN_NOTICE "isdnloop-ISDN-driver Rev%s\n", rev);
-
 	if (isdnloop_id)
 		return (isdnloop_addcard(isdnloop_id));
=20
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 34416d4..74793af 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1339,7 +1339,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, str=
uct request *req)
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
-		if (req->cmd_flags & REQ_SECURE)
+		if (req->cmd_flags & REQ_SECURE &&
+			!(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
 			ret =3D mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret =3D mmc_blk_issue_discard_rq(mq, req);
@@ -1614,6 +1615,8 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	return ret;
 }
=20
+#define CID_MANFID_SAMSUNG	0x15
+
 static const struct mmc_fixup blk_fixups[] =3D
 {
 	MMC_FIXUP("SEM02G", 0x2, 0x100, add_quirk, MMC_QUIRK_INAND_CMD38),
@@ -1644,6 +1647,28 @@ static const struct mmc_fixup blk_fixups[] =3D
 	MMC_FIXUP(CID_NAME_ANY, 0x13, 0x200, add_quirk_mmc,
 		  MMC_QUIRK_LONG_READ_TIME),
=20
+	/*
+	 * On these Samsung MoviNAND parts, performing secure erase or
+	 * secure trim can result in unrecoverable corruption due to a
+	 * firmware bug.
+	 */
+	MMC_FIXUP("M8G2FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("MAG4FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("MBG8FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("MCGAFA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("VAL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("VYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("KYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("VZL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+
 	END_FIXUP
 };
=20
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 99b449d..f201bed 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -279,11 +279,11 @@ static irqreturn_t mxs_mmc_irq_handler(int irq, void =
*dev_id)
 	writel(stat & MXS_MMC_IRQ_BITS,
 	       host->base + HW_SSP_CTRL1 + MXS_CLR_ADDR);
=20
+	spin_unlock(&host->lock);
+
 	if ((stat & BM_SSP_CTRL1_SDIO_IRQ) && (stat & BM_SSP_CTRL1_SDIO_IRQ_EN))
 		mmc_signal_sdio_irq(host->mmc);
=20
-	spin_unlock(&host->lock);
-
 	if (stat & BM_SSP_CTRL1_RESP_TIMEOUT_IRQ)
 		cmd->error =3D -ETIMEDOUT;
 	else if (stat & BM_SSP_CTRL1_RESP_ERR_IRQ)
@@ -628,10 +628,6 @@ static void mxs_mmc_enable_sdio_irq(struct mmc_host *m=
mc, int enable)
 		       host->base + HW_SSP_CTRL0 + MXS_SET_ADDR);
 		writel(BM_SSP_CTRL1_SDIO_IRQ_EN,
 		       host->base + HW_SSP_CTRL1 + MXS_SET_ADDR);
-
-		if (readl(host->base + HW_SSP_STATUS) & BM_SSP_STATUS_SDIO_IRQ)
-			mmc_signal_sdio_irq(host->mmc);
-
 	} else {
 		writel(BM_SSP_CTRL0_SDIO_IRQ_CHECK,
 		       host->base + HW_SSP_CTRL0 + MXS_CLR_ADDR);
@@ -640,6 +636,10 @@ static void mxs_mmc_enable_sdio_irq(struct mmc_host *m=
mc, int enable)
 	}
=20
 	spin_unlock_irqrestore(&host->lock, flags);
+
+	if (enable && readl(host->base + HW_SSP_STATUS) & BM_SSP_STATUS_SDIO_IRQ)
+		mmc_signal_sdio_irq(host->mmc);
+
 }
=20
 static const struct mmc_host_ops mxs_mmc_ops =3D {
diff --git a/drivers/mmc/host/sdhci-esdhc.h b/drivers/mmc/host/sdhci-esdhc.=
h
index c3b08f1..62ca03a 100644
--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -48,14 +48,14 @@ static inline void esdhc_set_clock(struct sdhci_host *h=
ost, unsigned int clock)
 	int div =3D 1;
 	u32 temp;
=20
+	if (clock =3D=3D 0)
+		goto out;
+
 	temp =3D sdhci_readl(host, ESDHC_SYSTEM_CONTROL);
 	temp &=3D ~(ESDHC_CLOCK_IPGEN | ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN
 		| ESDHC_CLOCK_MASK);
 	sdhci_writel(host, temp, ESDHC_SYSTEM_CONTROL);
=20
-	if (clock =3D=3D 0)
-		goto out;
-
 	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
 		pre_div *=3D 2;
=20
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 890754c..95b29f5 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -346,7 +346,7 @@ retry:
 	 */
 	err =3D ubi_scan_add_used(ubi, si, new_seb->pnum, new_seb->ec,
 				vid_hdr, 0);
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
=20
@@ -359,7 +359,7 @@ write_error:
 		list_add(&new_seb->u.list, &si->erase);
 		goto retry;
 	}
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 330140e..9bcc39a 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -83,6 +83,11 @@
 #define INSTRUCTION_LOAD_TXB(n)	(0x40 + 2 * (n))
 #define INSTRUCTION_READ_RXB(n)	(((n) =3D=3D 0) ? 0x90 : 0x94)
 #define INSTRUCTION_RESET	0xC0
+#define RTS_TXB0		0x01
+#define RTS_TXB1		0x02
+#define RTS_TXB2		0x04
+#define INSTRUCTION_RTS(n)	(0x80 | ((n) & 0x07))
+
=20
 /* MPC251x registers */
 #define CANSTAT	      0x0e
@@ -397,6 +402,7 @@ static void mcp251x_hw_tx_frame(struct spi_device *spi,=
 u8 *buf,
 static void mcp251x_hw_tx(struct spi_device *spi, struct can_frame *frame,
 			  int tx_buf_idx)
 {
+	struct mcp251x_priv *priv =3D dev_get_drvdata(&spi->dev);
 	u32 sid, eid, exide, rtr;
 	u8 buf[SPI_TRANSFER_BUF_LEN];
=20
@@ -418,7 +424,10 @@ static void mcp251x_hw_tx(struct spi_device *spi, stru=
ct can_frame *frame,
 	buf[TXBDLC_OFF] =3D (rtr << DLC_RTR_SHIFT) | frame->can_dlc;
 	memcpy(buf + TXBDAT_OFF, frame->data, frame->can_dlc);
 	mcp251x_hw_tx_frame(spi, buf, frame->can_dlc, tx_buf_idx);
-	mcp251x_write_reg(spi, TXBCTRL(tx_buf_idx), TXBCTRL_TXREQ);
+
+	/* use INSTRUCTION_RTS, to avoid "repeated frame problem" */
+	priv->spi_tx_buf[0] =3D INSTRUCTION_RTS(1 << tx_buf_idx);
+	mcp251x_spi_trans(priv->spi, 1);
 }
=20
 static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/etherne=
t/freescale/gianfar.c
index 83199fd..d0722a7 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1041,7 +1041,7 @@ static int gfar_probe(struct platform_device *ofdev)
=20
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
 		dev->hw_features |=3D NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
-		dev->features |=3D NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
+		dev->features |=3D NETIF_F_HW_VLAN_RX;
 	}
=20
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_EXTENDED_HASH) {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/=
ibmveth.c
index b1cd41b..021463b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -472,14 +472,9 @@ static void ibmveth_cleanup(struct ibmveth_adapter *ad=
apter)
 	}
=20
 	if (adapter->rx_queue.queue_addr !=3D NULL) {
-		if (!dma_mapping_error(dev, adapter->rx_queue.queue_dma)) {
-			dma_unmap_single(dev,
-					adapter->rx_queue.queue_dma,
-					adapter->rx_queue.queue_len,
-					DMA_BIDIRECTIONAL);
-			adapter->rx_queue.queue_dma =3D DMA_ERROR_CODE;
-		}
-		kfree(adapter->rx_queue.queue_addr);
+		dma_free_coherent(dev, adapter->rx_queue.queue_len,
+				  adapter->rx_queue.queue_addr,
+				  adapter->rx_queue.queue_dma);
 		adapter->rx_queue.queue_addr =3D NULL;
 	}
=20
@@ -556,10 +551,13 @@ static int ibmveth_open(struct net_device *netdev)
 		goto err_out;
 	}
=20
+	dev =3D &adapter->vdev->dev;
+
 	adapter->rx_queue.queue_len =3D sizeof(struct ibmveth_rx_q_entry) *
 						rxq_entries;
-	adapter->rx_queue.queue_addr =3D kmalloc(adapter->rx_queue.queue_len,
-						GFP_KERNEL);
+	adapter->rx_queue.queue_addr =3D
+	    dma_alloc_coherent(dev, adapter->rx_queue.queue_len,
+			       &adapter->rx_queue.queue_dma, GFP_KERNEL);
=20
 	if (!adapter->rx_queue.queue_addr) {
 		netdev_err(netdev, "unable to allocate rx queue pages\n");
@@ -567,19 +565,13 @@ static int ibmveth_open(struct net_device *netdev)
 		goto err_out;
 	}
=20
-	dev =3D &adapter->vdev->dev;
-
 	adapter->buffer_list_dma =3D dma_map_single(dev,
 			adapter->buffer_list_addr, 4096, DMA_BIDIRECTIONAL);
 	adapter->filter_list_dma =3D dma_map_single(dev,
 			adapter->filter_list_addr, 4096, DMA_BIDIRECTIONAL);
-	adapter->rx_queue.queue_dma =3D dma_map_single(dev,
-			adapter->rx_queue.queue_addr,
-			adapter->rx_queue.queue_len, DMA_BIDIRECTIONAL);
=20
 	if ((dma_mapping_error(dev, adapter->buffer_list_dma)) ||
-	    (dma_mapping_error(dev, adapter->filter_list_dma)) ||
-	    (dma_mapping_error(dev, adapter->rx_queue.queue_dma))) {
+	    (dma_mapping_error(dev, adapter->filter_list_dma))) {
 		netdev_err(netdev, "unable to map filter or buffer list "
 			   "pages\n");
 		rc =3D -ENOMEM;
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethern=
et/intel/e1000e/e1000.h
index f478a22..8e362bb 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -302,6 +302,7 @@ struct e1000_adapter {
 	 */
 	struct e1000_ring *tx_ring /* One per active queue */
 						____cacheline_aligned_in_smp;
+	u32 tx_fifo_limit;
=20
 	struct napi_struct napi;
=20
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ether=
net/intel/e1000e/netdev.c
index 64d3f98..0182649 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3386,6 +3386,15 @@ void e1000e_reset(struct e1000_adapter *adapter)
 	}
=20
 	/*
+	 * Alignment of Tx data is on an arbitrary byte boundary with the
+	 * maximum size per Tx descriptor limited only to the transmit
+	 * allocation of the packet buffer minus 96 bytes with an upper
+	 * limit of 24KB due to receive synchronization limitations.
+	 */
+	adapter->tx_fifo_limit =3D min_t(u32, ((er32(PBA) >> 16) << 10) - 96,
+				       24 << 10);
+
+	/*
 	 * Disable Adaptive Interrupt Moderation if 2 full packets cannot
 	 * fit in receive buffer and early-receive not supported.
 	 */
@@ -4647,13 +4656,9 @@ static bool e1000_tx_csum(struct e1000_adapter *adap=
ter, struct sk_buff *skb)
 	return 1;
 }
=20
-#define E1000_MAX_PER_TXD	8192
-#define E1000_MAX_TXD_PWR	12
-
 static int e1000_tx_map(struct e1000_adapter *adapter,
 			struct sk_buff *skb, unsigned int first,
-			unsigned int max_per_txd, unsigned int nr_frags,
-			unsigned int mss)
+			unsigned int max_per_txd, unsigned int nr_frags)
 {
 	struct e1000_ring *tx_ring =3D adapter->tx_ring;
 	struct pci_dev *pdev =3D adapter->pdev;
@@ -4882,20 +4887,19 @@ static int e1000_maybe_stop_tx(struct net_device *n=
etdev, int size)
 {
 	struct e1000_adapter *adapter =3D netdev_priv(netdev);
=20
+	BUG_ON(size > adapter->tx_ring->count);
+
 	if (e1000_desc_unused(adapter->tx_ring) >=3D size)
 		return 0;
 	return __e1000_maybe_stop_tx(netdev, size);
 }
=20
-#define TXD_USE_COUNT(S, X) (((S) >> (X)) + 1 )
 static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
 	struct e1000_adapter *adapter =3D netdev_priv(netdev);
 	struct e1000_ring *tx_ring =3D adapter->tx_ring;
 	unsigned int first;
-	unsigned int max_per_txd =3D E1000_MAX_PER_TXD;
-	unsigned int max_txd_pwr =3D E1000_MAX_TXD_PWR;
 	unsigned int tx_flags =3D 0;
 	unsigned int len =3D skb_headlen(skb);
 	unsigned int nr_frags;
@@ -4915,18 +4919,8 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *=
skb,
 	}
=20
 	mss =3D skb_shinfo(skb)->gso_size;
-	/*
-	 * The controller does a simple calculation to
-	 * make sure there is enough room in the FIFO before
-	 * initiating the DMA for each buffer.  The calc is:
-	 * 4 =3D ceil(buffer len/mss).  To make sure we don't
-	 * overrun the FIFO, adjust the max buffer len if mss
-	 * drops.
-	 */
 	if (mss) {
 		u8 hdr_len;
-		max_per_txd =3D min(mss << 2, max_per_txd);
-		max_txd_pwr =3D fls(max_per_txd) - 1;
=20
 		/*
 		 * TSO Workaround for 82571/2/3 Controllers -- if skb->data
@@ -4956,12 +4950,12 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff =
*skb,
 		count++;
 	count++;
=20
-	count +=3D TXD_USE_COUNT(len, max_txd_pwr);
+	count +=3D DIV_ROUND_UP(len, adapter->tx_fifo_limit);
=20
 	nr_frags =3D skb_shinfo(skb)->nr_frags;
 	for (f =3D 0; f < nr_frags; f++)
-		count +=3D TXD_USE_COUNT(skb_frag_size(&skb_shinfo(skb)->frags[f]),
-				       max_txd_pwr);
+		count +=3D DIV_ROUND_UP(skb_frag_size(&skb_shinfo(skb)->frags[f]),
+				      adapter->tx_fifo_limit);
=20
 	if (adapter->hw.mac.tx_pkt_filtering)
 		e1000_transfer_dhcp_info(adapter, skb);
@@ -5000,12 +4994,15 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff =
*skb,
 		tx_flags |=3D E1000_TX_FLAGS_IPV4;
=20
 	/* if count is 0 then mapping error has occurred */
-	count =3D e1000_tx_map(adapter, skb, first, max_per_txd, nr_frags, mss);
+	count =3D e1000_tx_map(adapter, skb, first, adapter->tx_fifo_limit,
+			     nr_frags);
 	if (count) {
 		e1000_tx_queue(adapter, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
-		e1000_maybe_stop_tx(netdev, MAX_SKB_FRAGS + 2);
-
+		e1000_maybe_stop_tx(netdev,
+				    (MAX_SKB_FRAGS *
+				     DIV_ROUND_UP(PAGE_SIZE,
+						  adapter->tx_fifo_limit) + 2));
 	} else {
 		dev_kfree_skb_any(skb);
 		tx_ring->buffer_info[first].time_stamp =3D 0;
@@ -6150,8 +6147,8 @@ static int __devinit e1000_probe(struct pci_dev *pdev=
,
 	adapter->hw.phy.autoneg_advertised =3D 0x2f;
=20
 	/* ring size defaults */
-	adapter->rx_ring->count =3D 256;
-	adapter->tx_ring->count =3D 256;
+	adapter->rx_ring->count =3D E1000_DEFAULT_RXD;
+	adapter->tx_ring->count =3D E1000_DEFAULT_TXD;
=20
 	/*
 	 * Initial Wake on LAN setting - If APM wake is enabled in
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.=
c
index d5731f1..a6611f1 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1383,6 +1383,11 @@ static int efx_probe_all(struct efx_nic *efx)
 		goto fail2;
 	}
=20
+	BUILD_BUG_ON(EFX_DEFAULT_DMAQ_SIZE < EFX_RXQ_MIN_ENT);
+	if (WARN_ON(EFX_DEFAULT_DMAQ_SIZE < EFX_TXQ_MIN_ENT(efx))) {
+		rc =3D -EINVAL;
+		goto fail3;
+	}
 	efx->rxq_entries =3D efx->txq_entries =3D EFX_DEFAULT_DMAQ_SIZE;
 	rc =3D efx_probe_channels(efx);
 	if (rc)
@@ -1973,6 +1978,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 	net_dev->irq =3D efx->pci_dev->irq;
 	net_dev->netdev_ops =3D &efx_netdev_ops;
 	SET_ETHTOOL_OPS(net_dev, &efx_ethtool_ops);
+	net_dev->gso_max_segs =3D EFX_TSO_MAX_SEGS;
=20
 	/* Clear MAC statistics */
 	efx->mac_op->update_stats(efx);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.=
h
index 4764793..1355245 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -34,6 +34,7 @@ extern netdev_tx_t
 efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 extern void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int inde=
x);
 extern int efx_setup_tc(struct net_device *net_dev, u8 num_tc);
+extern unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
=20
 /* RX */
 extern int efx_probe_rx_queue(struct efx_rx_queue *rx_queue);
@@ -56,10 +57,15 @@ extern void efx_schedule_slow_fill(struct efx_rx_queue =
*rx_queue);
 #define EFX_MAX_EVQ_SIZE 16384UL
 #define EFX_MIN_EVQ_SIZE 512UL
=20
-/* The smallest [rt]xq_entries that the driver supports. Callers of
- * efx_wake_queue() assume that they can subsequently send at least one
- * skb. Falcon/A1 may require up to three descriptors per skb_frag. */
-#define EFX_MIN_RING_SIZE (roundup_pow_of_two(2 * 3 * MAX_SKB_FRAGS))
+/* Maximum number of TCP segments we support for soft-TSO */
+#define EFX_TSO_MAX_SEGS	100
+
+/* The smallest [rt]xq_entries that the driver supports.  RX minimum
+ * is a bit arbitrary.  For TX, we must have space for at least 2
+ * TSO skbs.
+ */
+#define EFX_RXQ_MIN_ENT		128U
+#define EFX_TXQ_MIN_ENT(efx)	(2 * efx_tx_max_skb_descs(efx))
=20
 /* Filters */
 extern int efx_probe_filters(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/=
ethtool.c
index f3cd96d..90158c9 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -690,21 +690,27 @@ static int efx_ethtool_set_ringparam(struct net_devic=
e *net_dev,
 				     struct ethtool_ringparam *ring)
 {
 	struct efx_nic *efx =3D netdev_priv(net_dev);
+	u32 txq_entries;
=20
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
 	    ring->rx_pending > EFX_MAX_DMAQ_SIZE ||
 	    ring->tx_pending > EFX_MAX_DMAQ_SIZE)
 		return -EINVAL;
=20
-	if (ring->rx_pending < EFX_MIN_RING_SIZE ||
-	    ring->tx_pending < EFX_MIN_RING_SIZE) {
+	if (ring->rx_pending < EFX_RXQ_MIN_ENT) {
 		netif_err(efx, drv, efx->net_dev,
-			  "TX and RX queues cannot be smaller than %ld\n",
-			  EFX_MIN_RING_SIZE);
+			  "RX queues cannot be smaller than %u\n",
+			  EFX_RXQ_MIN_ENT);
 		return -EINVAL;
 	}
=20
-	return efx_realloc_channels(efx, ring->rx_pending, ring->tx_pending);
+	txq_entries =3D max(ring->tx_pending, EFX_TXQ_MIN_ENT(efx));
+	if (txq_entries !=3D ring->tx_pending)
+		netif_warn(efx, drv, efx->net_dev,
+			   "increasing TX queue size to minimum of %u\n",
+			   txq_entries);
+
+	return efx_realloc_channels(efx, ring->rx_pending, txq_entries);
 }
=20
 static int efx_ethtool_set_pauseparam(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.=
h
index 5fb24d3..66ece48 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -65,6 +65,9 @@ enum {
 #define FALCON_GMAC_LOOPBACKS			\
 	(1 << LOOPBACK_GMAC)
=20
+/* Alignment of PCIe DMA boundaries (4KB) */
+#define EFX_PAGE_SIZE	4096
+
 /**
  * struct falcon_board_type - board operations and type information
  * @id: Board type id, as found in NVRAM
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index df88c543..807d515 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -115,6 +115,25 @@ efx_max_tx_len(struct efx_nic *efx, dma_addr_t dma_add=
r)
 	return len;
 }
=20
+unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
+{
+	/* Header and payload descriptor for each output segment, plus
+	 * one for every input fragment boundary within a segment
+	 */
+	unsigned int max_descs =3D EFX_TSO_MAX_SEGS * 2 + MAX_SKB_FRAGS;
+
+	/* Possibly one more per segment for the alignment workaround */
+	if (EFX_WORKAROUND_5391(efx))
+		max_descs +=3D EFX_TSO_MAX_SEGS;
+
+	/* Possibly more for PCIe page boundaries within input fragments */
+	if (PAGE_SIZE > EFX_PAGE_SIZE)
+		max_descs +=3D max_t(unsigned int, MAX_SKB_FRAGS,
+				   DIV_ROUND_UP(GSO_MAX_SIZE, EFX_PAGE_SIZE));
+
+	return max_descs;
+}
+
 /*
  * Add a socket buffer to a TX queue
  *
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index f8a6853..ad6a9d9 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -189,7 +189,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct s=
k_buff *skb)
 	if (sk_pppox(po)->sk_state & PPPOX_DEAD)
 		goto tx_error;
=20
-	rt =3D ip_route_output_ports(&init_net, &fl4, NULL,
+	rt =3D ip_route_output_ports(sock_net(sk), &fl4, NULL,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0, IPPROTO_GRE,
@@ -468,7 +468,7 @@ static int pptp_connect(struct socket *sock, struct soc=
kaddr *uservaddr,
 	po->chan.private =3D sk;
 	po->chan.ops =3D &pptp_chan_ops;
=20
-	rt =3D ip_route_output_ports(&init_net, &fl4, sk,
+	rt =3D ip_route_output_ports(sock_net(sk), &fl4, sk,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wirel=
ess/iwlwifi/iwl-debugfs.c
index a1670e3..93e6179 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -232,6 +232,9 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	struct iwl_priv *priv =3D file->private_data;
 	size_t bufsz;
=20
+	if (!iwl_is_ready_rf(priv->shrd))
+		return -EAGAIN;
+
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset =3D 0x800000;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/ne=
t/wireless/iwlwifi/iwl-trans-pcie-int.h
index 5c29281..8533ba2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -303,7 +303,7 @@ int iwl_queue_space(const struct iwl_queue *q);
 ******************************************************/
 int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 			    char **buf, bool display);
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
+int iwl_dump_fh(struct iwl_trans *trans, char **buf);
 void iwl_dump_csr(struct iwl_trans *trans);
=20
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net=
/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 1daf01e..17fb25d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -678,7 +678,7 @@ static void iwl_irq_handle_error(struct iwl_trans *tran=
s)
=20
 	iwl_dump_nic_error_log(trans);
 	iwl_dump_csr(trans);
-	iwl_dump_fh(trans, NULL, false);
+	iwl_dump_fh(trans, NULL);
 	iwl_dump_nic_event_log(trans, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wi=
reless/iwlwifi/iwl-trans-pcie.c
index 4661a64..75da4bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1541,13 +1541,9 @@ static const char *get_fh_string(int cmd)
 	}
 }
=20
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
+int iwl_dump_fh(struct iwl_trans *trans, char **buf)
 {
 	int i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	int pos =3D 0;
-	size_t bufsz =3D 0;
-#endif
 	static const u32 fh_tbl[] =3D {
 		FH_RSCSR_CHNL0_STTS_WPTR_REG,
 		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
@@ -1559,29 +1555,35 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf=
, bool display)
 		FH_TSSR_TX_STATUS_REG,
 		FH_TSSR_TX_ERROR_REG
 	};
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		bufsz =3D ARRAY_SIZE(fh_tbl) * 48 + 40;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (buf) {
+		int pos =3D 0;
+		size_t bufsz =3D ARRAY_SIZE(fh_tbl) * 48 + 40;
+
 		*buf =3D kmalloc(bufsz, GFP_KERNEL);
 		if (!*buf)
 			return -ENOMEM;
+
 		pos +=3D scnprintf(*buf + pos, bufsz - pos,
 				"FH register values:\n");
-		for (i =3D 0; i < ARRAY_SIZE(fh_tbl); i++) {
+
+		for (i =3D 0; i < ARRAY_SIZE(fh_tbl); i++)
 			pos +=3D scnprintf(*buf + pos, bufsz - pos,
 				"  %34s: 0X%08x\n",
 				get_fh_string(fh_tbl[i]),
 				iwl_read_direct32(bus(trans), fh_tbl[i]));
-		}
+
 		return pos;
 	}
 #endif
+
 	IWL_ERR(trans, "FH register values:\n");
-	for (i =3D 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+	for (i =3D 0; i <  ARRAY_SIZE(fh_tbl); i++)
 		IWL_ERR(trans, "  %34s: 0X%08x\n",
 			get_fh_string(fh_tbl[i]),
 			iwl_read_direct32(bus(trans), fh_tbl[i]));
-	}
+
 	return 0;
 }
=20
@@ -1929,11 +1931,11 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *f=
ile,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans =3D file->private_data;
-	char *buf;
+	char *buf =3D NULL;
 	int pos =3D 0;
 	ssize_t ret =3D -EFAULT;
=20
-	ret =3D pos =3D iwl_dump_fh(trans, &buf, true);
+	ret =3D pos =3D iwl_dump_fh(trans, &buf);
 	if (buf) {
 		ret =3D simple_read_from_buffer(user_buf,
 					      count, ppos, buf, pos);
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless=
/rt2x00/rt2400pci.c
index 3a6b402..0ea85f4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1611,6 +1611,7 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev =
*rt2x00dev)
 static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
=20
 	/*
 	 * Allocate eeprom data.
@@ -1624,6 +1625,14 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2=
x00dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00_set_field32(&reg, GPIOCSR_BIT8, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt2400pci_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless=
/rt2x00/rt2400pci.h
index d3a4a68..7564ae9 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -670,6 +670,7 @@
 #define GPIOCSR_BIT5			FIELD32(0x00000020)
 #define GPIOCSR_BIT6			FIELD32(0x00000040)
 #define GPIOCSR_BIT7			FIELD32(0x00000080)
+#define GPIOCSR_BIT8			FIELD32(0x00000100)
=20
 /*
  * BBPPCSR: BBP Pin control register.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless=
/rt2x00/rt2500pci.c
index dcc0e1f..aa10c48 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1929,6 +1929,7 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev =
*rt2x00dev)
 static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
=20
 	/*
 	 * Allocate eeprom data.
@@ -1942,6 +1943,14 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2=
x00dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00_set_field32(&reg, GPIOCSR_DIR0, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt2500pci_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless=
/rt2x00/rt2500usb.c
index 53c5f87..22ed6df 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -283,7 +283,7 @@ static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2=
x00dev)
 	u16 reg;
=20
 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
-	return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
+	return rt2x00_get_field16(reg, MAC_CSR19_BIT7);
 }
=20
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -1768,6 +1768,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev =
*rt2x00dev)
 static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u16 reg;
=20
 	/*
 	 * Allocate eeprom data.
@@ -1781,6 +1782,14 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2=
x00dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR19_BIT8, 0);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR19, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt2500usb_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless=
/rt2x00/rt2500usb.h
index b493306..196bd51 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -189,14 +189,15 @@
  * MAC_CSR19: GPIO control register.
  */
 #define MAC_CSR19			0x0426
-#define MAC_CSR19_BIT0			FIELD32(0x0001)
-#define MAC_CSR19_BIT1			FIELD32(0x0002)
-#define MAC_CSR19_BIT2			FIELD32(0x0004)
-#define MAC_CSR19_BIT3			FIELD32(0x0008)
-#define MAC_CSR19_BIT4			FIELD32(0x0010)
-#define MAC_CSR19_BIT5			FIELD32(0x0020)
-#define MAC_CSR19_BIT6			FIELD32(0x0040)
-#define MAC_CSR19_BIT7			FIELD32(0x0080)
+#define MAC_CSR19_BIT0			FIELD16(0x0001)
+#define MAC_CSR19_BIT1			FIELD16(0x0002)
+#define MAC_CSR19_BIT2			FIELD16(0x0004)
+#define MAC_CSR19_BIT3			FIELD16(0x0008)
+#define MAC_CSR19_BIT4			FIELD16(0x0010)
+#define MAC_CSR19_BIT5			FIELD16(0x0020)
+#define MAC_CSR19_BIT6			FIELD16(0x0040)
+#define MAC_CSR19_BIT7			FIELD16(0x0080)
+#define MAC_CSR19_BIT8			FIELD16(0x0100)
=20
 /*
  * MAC_CSR20: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless=
/rt2x00/rt2800pci.c
index 837b460..518157d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -935,6 +935,7 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev =
*rt2x00dev)
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
=20
 	/*
 	 * Allocate eeprom data.
@@ -948,6 +949,14 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x0=
0dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt2800_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless=
/rt2x00/rt2800usb.c
index ae7528b..b66a61b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -621,8 +621,16 @@ static void rt2800usb_fill_rxdone(struct queue_entry *=
entry,
 	skb_pull(entry->skb, RXINFO_DESC_SIZE);
=20
 	/*
-	 * FIXME: we need to check for rx_pkt_len validity
+	 * Check for rx_pkt_len validity. Return if invalid, leaving
+	 * rxdesc->size zeroed out by the upper level.
 	 */
+	if (unlikely(rx_pkt_len =3D=3D 0 ||
+			rx_pkt_len > entry->queue->data_size)) {
+		ERROR(entry->queue->rt2x00dev,
+			"Bad frame size %d, forcing to 0\n", rx_pkt_len);
+		return;
+	}
+
 	rxd =3D (__le32 *)(entry->skb->data + rx_pkt_len);
=20
 	/*
@@ -690,6 +698,7 @@ static int rt2800usb_validate_eeprom(struct rt2x00_dev =
*rt2x00dev)
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
=20
 	/*
 	 * Allocate eeprom data.
@@ -703,6 +712,14 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x0=
0dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
+	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt2800_probe_hw_mode(rt2x00dev);
@@ -1111,6 +1128,8 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x1690, 0x0744) },
 	{ USB_DEVICE(0x1690, 0x0761) },
 	{ USB_DEVICE(0x1690, 0x0764) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
 	/* EnGenius */
@@ -1163,7 +1182,6 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x0b05, 0x1760) },
 	{ USB_DEVICE(0x0b05, 0x1761) },
 	{ USB_DEVICE(0x0b05, 0x1790) },
-	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262) },
 	{ USB_DEVICE(0x13d3, 0x3284) },
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless=
/rt2x00/rt2x00dev.c
index 21b529b..f099b30 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -624,7 +624,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	 */
 	if (unlikely(rxdesc.size =3D=3D 0 ||
 		     rxdesc.size > entry->queue->data_size)) {
-		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
+		ERROR(rt2x00dev, "Wrong frame size %d max %d.\n",
 			rxdesc.size, entry->queue->data_size);
 		dev_kfree_skb(entry->skb);
 		goto renew_skb;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/r=
t2x00/rt61pci.c
index d69f88c..3e058e5 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2832,6 +2832,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *r=
t2x00dev)
 static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
=20
 	/*
 	 * Disable power saving.
@@ -2850,6 +2851,14 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x0=
0dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT13, 1);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt61pci_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/r=
t2x00/rt61pci.h
index e3cd6db..8f3da5a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -372,6 +372,7 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
 #define MAC_CSR13_BIT11			FIELD32(0x00000800)
 #define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_BIT13			FIELD32(0x00002000)
=20
 /*
  * MAC_CSR14: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/r=
t2x00/rt73usb.c
index cfb19db..2ad468d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2177,6 +2177,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *r=
t2x00dev)
 static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
=20
 	/*
 	 * Allocate eeprom data.
@@ -2190,6 +2191,14 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x0=
0dev)
 		return retval;
=20
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT15, 0);
+	rt2x00usb_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval =3D rt73usb_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/r=
t2x00/rt73usb.h
index 9f6b470..df1cc11 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -282,6 +282,9 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
 #define MAC_CSR13_BIT11			FIELD32(0x00000800)
 #define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_BIT13			FIELD32(0x00002000)
+#define MAC_CSR13_BIT14			FIELD32(0x00004000)
+#define MAC_CSR13_BIT15			FIELD32(0x00008000)
=20
 /*
  * MAC_CSR14: LED control register.
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index 29a994f..7c471eb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4125,7 +4125,6 @@ megasas_probe_one(struct pci_dev *pdev, const struct =
pci_device_id *id)
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
-	spin_lock_init(&poll_aen_lock);
=20
 	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
@@ -5520,6 +5519,8 @@ static int __init megasas_init(void)
 	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
 	       MEGASAS_EXT_VERSION);
=20
+	spin_lock_init(&poll_aen_lock);
+
 	support_poll_for_event =3D 2;
 	support_device_change =3D 1;
=20
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index e903077..98cb5e6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2353,10 +2353,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER =
*ioc,  int sleep_flag)
 	}
=20
 	/* command line tunables  for max controller queue depth */
-	if (max_queue_depth !=3D -1)
-		max_request_credit =3D (max_queue_depth < facts->RequestCredit)
-		    ? max_queue_depth : facts->RequestCredit;
-	else
+	if (max_queue_depth !=3D -1 && max_queue_depth !=3D 0) {
+		max_request_credit =3D min_t(u16, max_queue_depth +
+			ioc->hi_priority_depth + ioc->internal_depth,
+			facts->RequestCredit);
+		if (max_request_credit > MAX_HBA_QUEUE_DEPTH)
+			max_request_credit =3D  MAX_HBA_QUEUE_DEPTH;
+	} else
 		max_request_credit =3D min_t(u16, facts->RequestCredit,
 		    MAX_HBA_QUEUE_DEPTH);
=20
@@ -2431,7 +2434,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *i=
oc,  int sleep_flag)
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue =3D ioc->scsiio_depth - (2);
+	ioc->shost->can_queue =3D ioc->scsiio_depth;
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
 	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
=20
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 456b131..c83571e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -41,6 +41,8 @@
=20
 #include <trace/events/scsi.h>
=20
+static void scsi_eh_done(struct scsi_cmnd *scmd);
+
 #define SENSE_TIMEOUT		(10*HZ)
=20
 /*
@@ -240,6 +242,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
=20
+	if (scmd->cmnd[0] =3D=3D TEST_UNIT_READY && scmd->scsi_done !=3D scsi_eh_=
done)
+		/*
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
=20
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a48b59c..c6c80c9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -776,6 +776,16 @@ static int scsi_add_lun(struct scsi_device *sdev, unsi=
gned char *inq_result,
 	sdev->model =3D (char *) (sdev->inquiry + 16);
 	sdev->rev =3D (char *) (sdev->inquiry + 32);
=20
+	if (strncmp(sdev->vendor, "ATA     ", 8) =3D=3D 0) {
+		/*
+		 * sata emulation layer device.  This is a hack to work around
+		 * the SATL power management specifications which state that
+		 * when the SATL detects the device has gone into standby
+		 * mode, it shall respond with NOT READY.
+		 */
+		sdev->allow_restart =3D 1;
+	}
+
 	if (*bflags & BLIST_ISROM) {
 		sdev->type =3D TYPE_ROM;
 		sdev->removable =3D 1;
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comed=
i/drivers/das08.c
index 3141dc8..a48fe88 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -385,7 +385,7 @@ static const struct das08_board_struct das08_boards[] =
=3D {
 	 .ai =3D das08_ai_rinsn,
 	 .ai_nbits =3D 16,
 	 .ai_pg =3D das08_pg_none,
-	 .ai_encoding =3D das08_encode12,
+	 .ai_encoding =3D das08_encode16,
 	 .ao =3D das08jr_ao_winsn,
 	 .ao_nbits =3D 16,
 	 .di =3D das08jr_di_rbits,
@@ -655,7 +655,7 @@ static int das08jr_ao_winsn(struct comedi_device *dev,
 	int chan;
=20
 	lsb =3D data[0] & 0xff;
-	msb =3D (data[0] >> 8) & 0xf;
+	msb =3D (data[0] >> 8) & 0xff;
=20
 	chan =3D CR_CHAN(insn->chanspec);
=20
diff --git a/drivers/staging/rtl8712/recv_linux.c b/drivers/staging/rtl8712=
/recv_linux.c
index 0e26d5f..495ee12 100644
--- a/drivers/staging/rtl8712/recv_linux.c
+++ b/drivers/staging/rtl8712/recv_linux.c
@@ -117,13 +117,8 @@ void r8712_recv_indicatepkt(struct _adapter *padapter,
 	if (skb =3D=3D NULL)
 		goto _recv_indicatepkt_drop;
 	skb->data =3D precv_frame->u.hdr.rx_data;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->tail =3D (sk_buff_data_t)(precv_frame->u.hdr.rx_tail -
-		     precv_frame->u.hdr.rx_head);
-#else
-	skb->tail =3D (sk_buff_data_t)precv_frame->u.hdr.rx_tail;
-#endif
 	skb->len =3D precv_frame->u.hdr.len;
+	skb_set_tail_pointer(skb, skb->len);
 	if ((pattrib->tcpchk_valid =3D=3D 1) && (pattrib->tcp_chkrpt =3D=3D 1))
 		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 	else
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index c0edf97..08021f4 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -200,7 +200,7 @@ s_vProcessRxMACHeader (
     } else if (!compare_ether_addr(pbyRxBuffer, &pDevice->abySNAP_RFC1042[=
0])) {
         cbHeaderSize +=3D 6;
         pwType =3D (PWORD) (pbyRxBufferAddr + cbHeaderSize);
-	if ((*pwType =3D=3D cpu_to_le16(ETH_P_IPX)) ||
+	if ((*pwType =3D=3D cpu_to_be16(ETH_P_IPX)) ||
 	    (*pwType =3D=3D cpu_to_le16(0xF380))) {
 		cbHeaderSize -=3D 8;
             pwType =3D (PWORD) (pbyRxBufferAddr + cbHeaderSize);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9b64b10..fe21868 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1701,7 +1701,7 @@ s_bPacketToWirelessUsb(
     // 802.1H
     if (ntohs(psEthHeader->wType) > ETH_DATA_LEN) {
 	if (pDevice->dwDiagRefCount =3D=3D 0) {
-		if ((psEthHeader->wType =3D=3D cpu_to_le16(ETH_P_IPX)) ||
+		if ((psEthHeader->wType =3D=3D cpu_to_be16(ETH_P_IPX)) ||
 		    (psEthHeader->wType =3D=3D cpu_to_le16(0xF380))) {
 			memcpy((PBYTE) (pbyPayloadHead),
 			       abySNAP_Bridgetunnel, 6);
@@ -2840,10 +2840,10 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int =
uDMAIdx, struct sk_buff *skb)
     Packet_Type =3D skb->data[ETH_HLEN+1];
     Descriptor_type =3D skb->data[ETH_HLEN+1+1+2];
     Key_info =3D (skb->data[ETH_HLEN+1+1+2+1] << 8)|(skb->data[ETH_HLEN+1+=
1+2+2]);
-    if (pDevice->sTxEthHeader.wType =3D=3D cpu_to_le16(ETH_P_PAE)) {
-	/* 802.1x OR eapol-key challenge frame transfer */
-	if (((Protocol_Version =3D=3D 1) || (Protocol_Version =3D=3D 2)) &&
-		(Packet_Type =3D=3D 3)) {
+	if (pDevice->sTxEthHeader.wType =3D=3D cpu_to_be16(ETH_P_PAE)) {
+		/* 802.1x OR eapol-key challenge frame transfer */
+		if (((Protocol_Version =3D=3D 1) || (Protocol_Version =3D=3D 2)) &&
+			(Packet_Type =3D=3D 3)) {
                         bTxeapol_key =3D TRUE;
                        if(!(Key_info & BIT3) &&  //WPA or RSN group-key ch=
allenge
 			   (Key_info & BIT8) && (Key_info & BIT9)) {    //send 2/2 key
@@ -2989,19 +2989,19 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int =
uDMAIdx, struct sk_buff *skb)
         }
     }
=20
-    if (pDevice->sTxEthHeader.wType =3D=3D cpu_to_le16(ETH_P_PAE)) {
-        if (pDevice->byBBType !=3D BB_TYPE_11A) {
-            pDevice->wCurrentRate =3D RATE_1M;
-            pDevice->byACKRate =3D RATE_1M;
-            pDevice->byTopCCKBasicRate =3D RATE_1M;
-            pDevice->byTopOFDMBasicRate =3D RATE_6M;
-        } else {
-            pDevice->wCurrentRate =3D RATE_6M;
-            pDevice->byACKRate =3D RATE_6M;
-            pDevice->byTopCCKBasicRate =3D RATE_1M;
-            pDevice->byTopOFDMBasicRate =3D RATE_6M;
-        }
-    }
+	if (pDevice->sTxEthHeader.wType =3D=3D cpu_to_be16(ETH_P_PAE)) {
+		if (pDevice->byBBType !=3D BB_TYPE_11A) {
+			pDevice->wCurrentRate =3D RATE_1M;
+			pDevice->byACKRate =3D RATE_1M;
+			pDevice->byTopCCKBasicRate =3D RATE_1M;
+			pDevice->byTopOFDMBasicRate =3D RATE_6M;
+		} else {
+			pDevice->wCurrentRate =3D RATE_6M;
+			pDevice->byACKRate =3D RATE_6M;
+			pDevice->byTopCCKBasicRate =3D RATE_1M;
+			pDevice->byTopOFDMBasicRate =3D RATE_6M;
+		}
+	}
=20
     DBG_PRT(MSG_LEVEL_DEBUG,
 	    KERN_INFO "dma_tx: pDevice->wCurrentRate =3D %d\n",
@@ -3017,7 +3017,7 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uD=
MAIdx, struct sk_buff *skb)
=20
     if (bNeedEncryption =3D=3D TRUE) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ntohs Pkt Type=3D%04x\n", ntohs=
(pDevice->sTxEthHeader.wType));
-	if ((pDevice->sTxEthHeader.wType) =3D=3D cpu_to_le16(ETH_P_PAE)) {
+	if ((pDevice->sTxEthHeader.wType) =3D=3D cpu_to_be16(ETH_P_PAE)) {
 		bNeedEncryption =3D FALSE;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Pkt Type=3D%04x\n", (pDevic=
e->sTxEthHeader.wType));
             if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_STA) && (pMgmt->eCu=
rrState =3D=3D WMAC_STATE_ASSOC)) {
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/=
zcache-main.c
index 16ad9fe..4306475 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1223,13 +1223,12 @@ static int zcache_pampd_get_data_and_free(char *dat=
a, size_t *bufsize, bool raw,
 					void *pampd, struct tmem_pool *pool,
 					struct tmem_oid *oid, uint32_t index)
 {
-	int ret =3D 0;
-
 	BUG_ON(!is_ephemeral(pool));
-	zbud_decompress((struct page *)(data), pampd);
+	if (zbud_decompress((struct page *)(data), pampd) < 0)
+		return -EINVAL;
 	zbud_free_and_delist((struct zbud_hdr *)pampd);
 	atomic_dec(&zcache_curr_eph_pampd_count);
-	return ret;
+	return 0;
 }
=20
 /*
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 163fc90..8e68f79 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -130,6 +130,7 @@
 #define  UCR4_OREN  	 (1<<1)  /* Receiver overrun interrupt enable */
 #define  UCR4_DREN  	 (1<<0)  /* Recv data ready interrupt enable */
 #define  UFCR_RXTL_SHF   0       /* Receiver trigger level shift */
+#define  UFCR_DCEDTE	 (1<<6)  /* DCE/DTE mode select */
 #define  UFCR_RFDIV      (7<<7)  /* Reference freq divider mask */
 #define  UFCR_RFDIV_REG(x)	(((x) < 7 ? 6 - (x) : 6) << 7)
 #define  UFCR_TXTL_SHF   10      /* Transmitter trigger level shift */
@@ -635,22 +636,11 @@ static void imx_break_ctl(struct uart_port *port, int=
 break_state)
 static int imx_setup_ufcr(struct imx_port *sport, unsigned int mode)
 {
 	unsigned int val;
-	unsigned int ufcr_rfdiv;
-
-	/* set receiver / transmitter trigger level.
-	 * RFDIV is set such way to satisfy requested uartclk value
-	 */
-	val =3D TXTL << 10 | RXTL;
-	ufcr_rfdiv =3D (clk_get_rate(sport->clk) + sport->port.uartclk / 2)
-			/ sport->port.uartclk;
-
-	if(!ufcr_rfdiv)
-		ufcr_rfdiv =3D 1;
-
-	val |=3D UFCR_RFDIV_REG(ufcr_rfdiv);
=20
+	/* set receiver / transmitter trigger level */
+	val =3D readl(sport->port.membase + UFCR) & (UFCR_RFDIV | UFCR_DCEDTE);
+	val |=3D TXTL << UFCR_TXTL_SHF | RXTL;
 	writel(val, sport->port.membase + UFCR);
-
 	return 0;
 }
=20
@@ -725,6 +715,7 @@ static int imx_startup(struct uart_port *port)
 		}
 	}
=20
+	spin_lock_irqsave(&sport->port.lock, flags);
 	/*
 	 * Finally, clear and enable interrupts
 	 */
@@ -778,7 +769,6 @@ static int imx_startup(struct uart_port *port)
 	/*
 	 * Enable modem status interrupts
 	 */
-	spin_lock_irqsave(&sport->port.lock,flags);
 	imx_enable_ms(&sport->port);
 	spin_unlock_irqrestore(&sport->port.lock,flags);
=20
@@ -808,10 +798,13 @@ static void imx_shutdown(struct uart_port *port)
 {
 	struct imx_port *sport =3D (struct imx_port *)port;
 	unsigned long temp;
+	unsigned long flags;
=20
+	spin_lock_irqsave(&sport->port.lock, flags);
 	temp =3D readl(sport->port.membase + UCR2);
 	temp &=3D ~(UCR2_TXEN);
 	writel(temp, sport->port.membase + UCR2);
+	spin_unlock_irqrestore(&sport->port.lock, flags);
=20
 	if (USE_IRDA(sport)) {
 		struct imxuart_platform_data *pdata;
@@ -840,12 +833,14 @@ static void imx_shutdown(struct uart_port *port)
 	 * Disable all interrupts, port and break condition.
 	 */
=20
+	spin_lock_irqsave(&sport->port.lock, flags);
 	temp =3D readl(sport->port.membase + UCR1);
 	temp &=3D ~(UCR1_TXMPTYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN);
 	if (USE_IRDA(sport))
 		temp &=3D ~(UCR1_IREN);
=20
 	writel(temp, sport->port.membase + UCR1);
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
=20
 static void
@@ -1119,6 +1114,9 @@ imx_console_write(struct console *co, const char *s, =
unsigned int count)
 {
 	struct imx_port *sport =3D imx_ports[co->index];
 	unsigned int old_ucr1, old_ucr2, ucr1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sport->port.lock, flags);
=20
 	/*
 	 *	First, save UCR1/2 and then disable interrupts
@@ -1145,6 +1143,8 @@ imx_console_write(struct console *co, const char *s, =
unsigned int count)
=20
 	writel(old_ucr1, sport->port.membase + UCR1);
 	writel(old_ucr2, sport->port.membase + UCR2);
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
=20
 /*
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 32d3adc..8b2a9d8 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -96,6 +96,10 @@ static const struct usb_device_id usb_quirk_list[] =3D {
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =3D
 			USB_QUIRK_CONFIG_INTF_STRINGS },
=20
+	/* Microchip Joss Optical infrared touchboard device */
+	{ USB_DEVICE(0x04d8, 0x000c), .driver_info =3D
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =3D
 			USB_QUIRK_CONFIG_INTF_STRINGS },
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index fef1db3..2023733 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -128,9 +128,17 @@ qh_refresh (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	else {
 		qtd =3D list_entry (qh->qtd_list.next,
 				struct ehci_qtd, qtd_list);
-		/* first qtd may already be partially processed */
-		if (cpu_to_hc32(ehci, qtd->qtd_dma) =3D=3D qh->hw->hw_current)
+		/*
+		 * first qtd may already be partially processed.
+		 * If we come here during unlink, the QH overlay region
+		 * might have reference to the just unlinked qtd. The
+		 * qtd is updated in qh_completions(). Update the QH
+		 * overlay here.
+		 */
+		if (cpu_to_hc32(ehci, qtd->qtd_dma) =3D=3D qh->hw->hw_current) {
+			qh->hw->hw_qtd_next =3D qtd->hw_next;
 			qtd =3D NULL;
+		}
 	}
=20
 	if (qtd)
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 833b3c6..d0ec2f0 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -75,7 +75,9 @@
 #define	NB_PIF0_PWRDOWN_1	0x01100013
=20
 #define USB_INTEL_XUSB2PR      0xD0
+#define USB_INTEL_USB2PRM      0xD4
 #define USB_INTEL_USB3_PSSEN   0xD8
+#define USB_INTEL_USB3PRM      0xDC
=20
 static struct amd_chipset_info {
 	struct pci_dev	*nb_dev;
@@ -772,10 +774,18 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 		return;
 	}
=20
-	ports_available =3D 0xffffffff;
+	/* Read USB3PRM, the USB 3.0 Port Routing Mask Register
+	 * Indicate the ports that can be changed from OS.
+	 */
+	pci_read_config_dword(xhci_pdev, USB_INTEL_USB3PRM,
+			&ports_available);
+
+	dev_dbg(&xhci_pdev->dev, "Configurable ports to enable SuperSpeed: 0x%x\n=
",
+			ports_available);
+
 	/* Write USB3_PSSEN, the USB 3.0 Port SuperSpeed Enable
-	 * Register, to turn on SuperSpeed terminations for all
-	 * available ports.
+	 * Register, to turn on SuperSpeed terminations for the
+	 * switchable ports.
 	 */
 	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN,
 			cpu_to_le32(ports_available));
@@ -785,7 +795,16 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 	dev_dbg(&xhci_pdev->dev, "USB 3.0 ports that are now enabled "
 			"under xHCI: 0x%x\n", ports_available);
=20
-	ports_available =3D 0xffffffff;
+	/* Read XUSB2PRM, xHCI USB 2.0 Port Routing Mask Register
+	 * Indicate the USB 2.0 ports to be controlled by the xHCI host.
+	 */
+
+	pci_read_config_dword(xhci_pdev, USB_INTEL_USB2PRM,
+			&ports_available);
+
+	dev_dbg(&xhci_pdev->dev, "Configurable USB 2.0 ports to hand over to xCHI=
: 0x%x\n",
+			ports_available);
+
 	/* Write XUSB2PR, the xHC USB 2.0 Port Routing Register, to
 	 * switch the USB 2.0 power and data lines over to the xHCI
 	 * host.
@@ -800,6 +819,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 }
 EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);
=20
+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
+{
+	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN, 0x0);
+	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR, 0x0);
+}
+EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
+
 /**
  * PCI Quirks for xHCI.
  *
@@ -815,12 +841,12 @@ static void __devinit quirk_usb_handoff_xhci(struct p=
ci_dev *pdev)
 	void __iomem *op_reg_base;
 	u32 val;
 	int timeout;
+	int len =3D pci_resource_len(pdev, 0);
=20
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
=20
-	base =3D ioremap_nocache(pci_resource_start(pdev, 0),
-				pci_resource_len(pdev, 0));
+	base =3D ioremap_nocache(pci_resource_start(pdev, 0), len);
 	if (base =3D=3D NULL)
 		return;
=20
@@ -830,9 +856,17 @@ static void __devinit quirk_usb_handoff_xhci(struct pc=
i_dev *pdev)
 	 */
 	ext_cap_offset =3D xhci_find_next_cap_offset(base, XHCI_HCC_PARAMS_OFFSET=
);
 	do {
+		if ((ext_cap_offset + sizeof(val)) > len) {
+			/* We're reading garbage from the controller */
+			dev_warn(&pdev->dev,
+				 "xHCI controller failing to respond");
+			return;
+		}
+
 		if (!ext_cap_offset)
 			/* We've reached the end of the extended capabilities */
 			goto hc_init;
+
 		val =3D readl(base + ext_cap_offset);
 		if (XHCI_EXT_CAPS_ID(val) =3D=3D XHCI_EXT_CAPS_LEGACY)
 			break;
@@ -863,9 +897,10 @@ static void __devinit quirk_usb_handoff_xhci(struct pc=
i_dev *pdev)
 	/* Disable any BIOS SMIs and clear all SMI events*/
 	writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
=20
+hc_init:
 	if (usb_is_intel_switchable_xhci(pdev))
 		usb_enable_xhci_ports(pdev);
-hc_init:
+
 	op_reg_base =3D base + XHCI_HC_LENGTH(readl(base));
=20
 	/* Wait for the host controller to be ready before writing any
diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index b1002a8..7f69a39 100644
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -10,10 +10,12 @@ void usb_amd_quirk_pll_disable(void);
 void usb_amd_quirk_pll_enable(void);
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev);
 void usb_enable_xhci_ports(struct pci_dev *xhci_pdev);
+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
 #else
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
 static inline void usb_amd_dev_put(void) {}
+static inline void usb_disable_xhci_ports(struct pci_dev *xhci_pdev) {}
 #endif  /* CONFIG_PCI */
=20
 #endif  /*  __LINUX_USB_PCI_QUIRKS_H  */
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index fd8a2c2..978860b 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -469,11 +469,48 @@ static void xhci_hub_report_link_state(u32 *status, u=
32 status_reg)
 		 * when this bit is set.
 		 */
 		pls |=3D USB_PORT_STAT_CONNECTION;
+	} else {
+		/*
+		 * If CAS bit isn't set but the Port is already at
+		 * Compliance Mode, fake a connection so the USB core
+		 * notices the Compliance state and resets the port.
+		 * This resolves an issue generated by the SN65LVPE502CP
+		 * in which sometimes the port enters compliance mode
+		 * caused by a delay on the host-device negotiation.
+		 */
+		if (pls =3D=3D USB_SS_PORT_LS_COMP_MOD)
+			pls |=3D USB_PORT_STAT_CONNECTION;
 	}
+
 	/* update status field */
 	*status |=3D pls;
 }
=20
+/*
+ * Function for Compliance Mode Quirk.
+ *
+ * This Function verifies if all xhc USB3 ports have entered U0, if so,
+ * the compliance mode timer is deleted. A port won't enter
+ * compliance mode if it has previously entered U0.
+ */
+void xhci_del_comp_mod_timer(struct xhci_hcd *xhci, u32 status, u16 wIndex=
)
+{
+	u32 all_ports_seen_u0 =3D ((1 << xhci->num_usb3_ports)-1);
+	bool port_in_u0 =3D ((status & PORT_PLS_MASK) =3D=3D XDEV_U0);
+
+	if (!(xhci->quirks & XHCI_COMP_MODE_QUIRK))
+		return;
+
+	if ((xhci->port_status_u0 !=3D all_ports_seen_u0) && port_in_u0) {
+		xhci->port_status_u0 |=3D 1 << wIndex;
+		if (xhci->port_status_u0 =3D=3D all_ports_seen_u0) {
+			del_timer_sync(&xhci->comp_mode_recovery_timer);
+			xhci_dbg(xhci, "All USB3 ports have entered U0 already!\n");
+			xhci_dbg(xhci, "Compliance Mode Recovery Timer Deleted.\n");
+		}
+	}
+}
+
 int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		u16 wIndex, char *buf, u16 wLength)
 {
@@ -618,6 +655,11 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq,=
 u16 wValue,
 		/* Update Port Link State for super speed ports*/
 		if (hcd->speed =3D=3D HCD_USB3) {
 			xhci_hub_report_link_state(&status, temp);
+			/*
+			 * Verify if all USB3 Ports Have entered U0 already.
+			 * Delete Compliance Mode Timer if so.
+			 */
+			xhci_del_comp_mod_timer(xhci, temp, wIndex);
 		}
 		if (bus_state->port_c_suspend & (1 << wIndex))
 			status |=3D 1 << USB_PORT_FEAT_C_SUSPEND;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 07c72a4..bddcbfc 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -90,6 +90,15 @@ static void xhci_pci_quirks(struct device *dev, struct x=
hci_hcd *xhci)
 		xhci->quirks |=3D XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps =3D 64;
 		xhci->quirks |=3D XHCI_SW_BW_CHECKING;
+		/*
+		 * PPT desktop boards DH77EB and DH77DF will power back on after
+		 * a few seconds of being shutdown.  The fix for this is to
+		 * switch the ports from xHCI to EHCI on shutdown.  We can't use
+		 * DMI information to find those particular boards (since each
+		 * vendor will change the board name), so we have to key off all
+		 * PPT chipsets.
+		 */
+		xhci->quirks |=3D XHCI_SPURIOUS_REBOOT;
 	}
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_ETRON &&
 			pdev->device =3D=3D PCI_DEVICE_ID_ASROCK_P67) {
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index fb0981e..c7c530c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -145,25 +145,34 @@ static void next_trb(struct xhci_hcd *xhci,
  */
 static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool co=
nsumer)
 {
-	union xhci_trb *next =3D ++(ring->dequeue);
 	unsigned long long addr;
=20
 	ring->deq_updates++;
-	/* Update the dequeue pointer further if that was a link TRB or we're at
-	 * the end of an event ring segment (which doesn't have link TRBS)
-	 */
-	while (last_trb(xhci, ring, ring->deq_seg, next)) {
-		if (consumer && last_trb_on_last_seg(xhci, ring, ring->deq_seg, next)) {
-			ring->cycle_state =3D (ring->cycle_state ? 0 : 1);
-			if (!in_interrupt())
-				xhci_dbg(xhci, "Toggle cycle state for ring %p =3D %i\n",
-						ring,
-						(unsigned int) ring->cycle_state);
+
+	do {
+		/*
+		 * Update the dequeue pointer further if that was a link TRB or
+		 * we're at the end of an event ring segment (which doesn't have
+		 * link TRBS)
+		 */
+		if (last_trb(xhci, ring, ring->deq_seg, ring->dequeue)) {
+			if (consumer && last_trb_on_last_seg(xhci, ring,
+						ring->deq_seg, ring->dequeue)) {
+				if (!in_interrupt())
+					xhci_dbg(xhci, "Toggle cycle state "
+							"for ring %p =3D %i\n",
+							ring,
+							(unsigned int)
+							ring->cycle_state);
+				ring->cycle_state =3D (ring->cycle_state ? 0 : 1);
+			}
+			ring->deq_seg =3D ring->deq_seg->next;
+			ring->dequeue =3D ring->deq_seg->trbs;
+		} else {
+			ring->dequeue++;
 		}
-		ring->deq_seg =3D ring->deq_seg->next;
-		ring->dequeue =3D ring->deq_seg->trbs;
-		next =3D ring->dequeue;
-	}
+	} while (last_trb(xhci, ring, ring->deq_seg, ring->dequeue));
+
 	addr =3D (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg, ring->d=
equeue);
 }
=20
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f7c0a2a..09872ee 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/dmi.h>
=20
 #include "xhci.h"
=20
@@ -387,6 +388,95 @@ static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
=20
 #endif
=20
+static void compliance_mode_recovery(unsigned long arg)
+{
+	struct xhci_hcd *xhci;
+	struct usb_hcd *hcd;
+	u32 temp;
+	int i;
+
+	xhci =3D (struct xhci_hcd *)arg;
+
+	for (i =3D 0; i < xhci->num_usb3_ports; i++) {
+		temp =3D xhci_readl(xhci, xhci->usb3_ports[i]);
+		if ((temp & PORT_PLS_MASK) =3D=3D USB_SS_PORT_LS_COMP_MOD) {
+			/*
+			 * Compliance Mode Detected. Letting USB Core
+			 * handle the Warm Reset
+			 */
+			xhci_dbg(xhci, "Compliance Mode Detected->Port %d!\n",
+					i + 1);
+			xhci_dbg(xhci, "Attempting Recovery routine!\n");
+			hcd =3D xhci->shared_hcd;
+
+			if (hcd->state =3D=3D HC_STATE_SUSPENDED)
+				usb_hcd_resume_root_hub(hcd);
+
+			usb_hcd_poll_rh_status(hcd);
+		}
+	}
+
+	if (xhci->port_status_u0 !=3D ((1 << xhci->num_usb3_ports)-1))
+		mod_timer(&xhci->comp_mode_recovery_timer,
+			jiffies + msecs_to_jiffies(COMP_MODE_RCVRY_MSECS));
+}
+
+/*
+ * Quirk to work around issue generated by the SN65LVPE502CP USB3.0 re-dri=
ver
+ * that causes ports behind that hardware to enter compliance mode sometim=
es.
+ * The quirk creates a timer that polls every 2 seconds the link state of
+ * each host controller's port and recovers it by issuing a Warm reset
+ * if Compliance mode is detected, otherwise the port will become "dead" (=
no
+ * device connections or disconnections will be detected anymore). Becasue=
 no
+ * status event is generated when entering compliance mode (per xhci spec)=
,
+ * this quirk is needed on systems that have the failing hardware installe=
d.
+ */
+static void compliance_mode_recovery_timer_init(struct xhci_hcd *xhci)
+{
+	xhci->port_status_u0 =3D 0;
+	init_timer(&xhci->comp_mode_recovery_timer);
+
+	xhci->comp_mode_recovery_timer.data =3D (unsigned long) xhci;
+	xhci->comp_mode_recovery_timer.function =3D compliance_mode_recovery;
+	xhci->comp_mode_recovery_timer.expires =3D jiffies +
+			msecs_to_jiffies(COMP_MODE_RCVRY_MSECS);
+
+	set_timer_slack(&xhci->comp_mode_recovery_timer,
+			msecs_to_jiffies(COMP_MODE_RCVRY_MSECS));
+	add_timer(&xhci->comp_mode_recovery_timer);
+	xhci_dbg(xhci, "Compliance Mode Recovery Timer Initialized.\n");
+}
+
+/*
+ * This function identifies the systems that have installed the SN65LVPE50=
2CP
+ * USB3.0 re-driver and that need the Compliance Mode Quirk.
+ * Systems:
+ * Vendor: Hewlett-Packard -> System Models: Z420, Z620 and Z820
+ */
+static bool compliance_mode_recovery_timer_quirk_check(void)
+{
+	const char *dmi_product_name, *dmi_sys_vendor;
+
+	dmi_product_name =3D dmi_get_system_info(DMI_PRODUCT_NAME);
+	dmi_sys_vendor =3D dmi_get_system_info(DMI_SYS_VENDOR);
+
+	if (!(strstr(dmi_sys_vendor, "Hewlett-Packard")))
+		return false;
+
+	if (strstr(dmi_product_name, "Z420") ||
+			strstr(dmi_product_name, "Z620") ||
+			strstr(dmi_product_name, "Z820"))
+		return true;
+
+	return false;
+}
+
+static int xhci_all_ports_seen_u0(struct xhci_hcd *xhci)
+{
+	return (xhci->port_status_u0 =3D=3D ((1 << xhci->num_usb3_ports)-1));
+}
+
+
 /*
  * Initialize memory for HCD and xHC (one-time init).
  *
@@ -410,6 +500,12 @@ int xhci_init(struct usb_hcd *hcd)
 	retval =3D xhci_mem_init(xhci, GFP_KERNEL);
 	xhci_dbg(xhci, "Finished xhci_init\n");
=20
+	/* Initializing Compliance Mode Recovery Data If Needed */
+	if (compliance_mode_recovery_timer_quirk_check()) {
+		xhci->quirks |=3D XHCI_COMP_MODE_QUIRK;
+		compliance_mode_recovery_timer_init(xhci);
+	}
+
 	return retval;
 }
=20
@@ -618,6 +714,11 @@ void xhci_stop(struct usb_hcd *hcd)
 	del_timer_sync(&xhci->event_ring_timer);
 #endif
=20
+	/* Deleting Compliance Mode Recovery Timer */
+	if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+			(!(xhci_all_ports_seen_u0(xhci))))
+		del_timer_sync(&xhci->comp_mode_recovery_timer);
+
 	if (xhci->quirks & XHCI_AMD_PLL_FIX)
 		usb_amd_dev_put();
=20
@@ -648,6 +749,9 @@ void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci =3D hcd_to_xhci(hcd);
=20
+	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
+		usb_disable_xhci_ports(to_pci_dev(hcd->self.controller));
+
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	spin_unlock_irq(&xhci->lock);
@@ -791,6 +895,16 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irq(&xhci->lock);
=20
+	/*
+	 * Deleting Compliance Mode Recovery Timer because the xHCI Host
+	 * is about to be suspended.
+	 */
+	if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+			(!(xhci_all_ports_seen_u0(xhci)))) {
+		del_timer_sync(&xhci->comp_mode_recovery_timer);
+		xhci_dbg(xhci, "Compliance Mode Recovery Timer Deleted!\n");
+	}
+
 	/* step 5: remove core well power */
 	/* synchronize irq when using MSI-X */
 	xhci_msix_sync_irqs(xhci);
@@ -923,6 +1037,16 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernate=
d)
 		usb_hcd_resume_root_hub(hcd);
 		usb_hcd_resume_root_hub(xhci->shared_hcd);
 	}
+
+	/*
+	 * If system is subject to the Quirk, Compliance Mode Timer needs to
+	 * be re-initialized Always after a system resume. Ports are subject
+	 * to suffer the Compliance Mode issue again. It doesn't matter if
+	 * ports have entered previously to U0 before system's suspension.
+	 */
+	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+		compliance_mode_recovery_timer_init(xhci);
+
 	return retval;
 }
 #endif	/* CONFIG_PM */
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7a56805..44d518a 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1471,6 +1471,8 @@ struct xhci_hcd {
 #define	XHCI_SW_BW_CHECKING	(1 << 8)
 #define XHCI_AMD_0x96_HOST	(1 << 9)
 #define XHCI_TRUST_TX_LENGTH	(1 << 10)
+#define XHCI_SPURIOUS_REBOOT	(1 << 13)
+#define XHCI_COMP_MODE_QUIRK	(1 << 14)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
@@ -1487,6 +1489,11 @@ struct xhci_hcd {
 	unsigned		sw_lpm_support:1;
 	/* support xHCI 1.0 spec USB2 hardware LPM */
 	unsigned		hw_lpm_support:1;
+	/* Compliance Mode Recovery Data */
+	struct timer_list	comp_mode_recovery_timer;
+	u32    			port_status_u0;
+/* Compliance Mode Timer Triggered every 2 seconds */
+#define COMP_MODE_RCVRY_MSECS 2000
 };
=20
 /* convert between an HCD pointer and the corresponding EHCI_HCD */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b3182bb..7324bea 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -704,6 +704,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, FTDI_PCDJ_DAC2_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NZR_SEM_USB_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_1_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_OPC_U_UC_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C1_PID) },
@@ -804,13 +805,32 @@ static struct usb_device_id id_table_combined [] =3D =
{
 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(MICROCHIP_VID, MICROCHIP_USB_BOARD_PID) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MICROCHIP_VID, MICROCHIP_USB_BOARD_PID,
+					USB_CLASS_VENDOR_SPEC,
+					USB_SUBCLASS_VENDOR_SPEC, 0x00) },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
+	{ USB_DEVICE(FTDI_VID, PI_C865_PID) },
+	{ USB_DEVICE(FTDI_VID, PI_C857_PID) },
+	{ USB_DEVICE(PI_VID, PI_C866_PID) },
+	{ USB_DEVICE(PI_VID, PI_C663_PID) },
+	{ USB_DEVICE(PI_VID, PI_C725_PID) },
+	{ USB_DEVICE(PI_VID, PI_E517_PID) },
+	{ USB_DEVICE(PI_VID, PI_C863_PID) },
 	{ USB_DEVICE(PI_VID, PI_E861_PID) },
+	{ USB_DEVICE(PI_VID, PI_C867_PID) },
+	{ USB_DEVICE(PI_VID, PI_E609_PID) },
+	{ USB_DEVICE(PI_VID, PI_E709_PID) },
+	{ USB_DEVICE(PI_VID, PI_100F_PID) },
+	{ USB_DEVICE(PI_VID, PI_1011_PID) },
+	{ USB_DEVICE(PI_VID, PI_1012_PID) },
+	{ USB_DEVICE(PI_VID, PI_1013_PID) },
+	{ USB_DEVICE(PI_VID, PI_1014_PID) },
+	{ USB_DEVICE(PI_VID, PI_1015_PID) },
+	{ USB_DEVICE(PI_VID, PI_1016_PID) },
 	{ USB_DEVICE(KONDO_VID, KONDO_USB_SERIAL_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 54b4258..06f6fd2 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -75,6 +75,9 @@
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
=20
+/* NZR SEM 16+ USB (http://www.nzr.de) */
+#define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */
+
 /*
  * RR-CirKits LocoBuffer USB (http://www.rr-cirkits.com)
  */
@@ -539,7 +542,10 @@
 /*
  * Microchip Technology, Inc.
  *
- * MICROCHIP_VID (0x04D8) and MICROCHIP_USB_BOARD_PID (0x000A) are also us=
ed by:
+ * MICROCHIP_VID (0x04D8) and MICROCHIP_USB_BOARD_PID (0x000A) are
+ * used by single function CDC ACM class based firmware demo
+ * applications.  The VID/PID has also been used in firmware
+ * emulating FTDI serial chips by:
  * Hornby Elite - Digital Command Control Console
  * http://www.hornby.com/hornby-dcc/controllers/
  */
@@ -791,8 +797,27 @@
  * Physik Instrumente
  * http://www.physikinstrumente.com/en/products/
  */
+/* These two devices use the VID of FTDI */
+#define PI_C865_PID	0xe0a0  /* PI C-865 Piezomotor Controller */
+#define PI_C857_PID	0xe0a1  /* PI Encoder Trigger Box */
+
 #define PI_VID              0x1a72  /* Vendor ID */
-#define PI_E861_PID         0x1008  /* E-861 piezo controller USB connecti=
on */
+#define PI_C866_PID	0x1000  /* PI C-866 Piezomotor Controller */
+#define PI_C663_PID	0x1001  /* PI C-663 Mercury-Step */
+#define PI_C725_PID	0x1002  /* PI C-725 Piezomotor Controller */
+#define PI_E517_PID	0x1005  /* PI E-517 Digital Piezo Controller Operation=
 Module */
+#define PI_C863_PID	0x1007  /* PI C-863 */
+#define PI_E861_PID	0x1008  /* PI E-861 Piezomotor Controller */
+#define PI_C867_PID	0x1009  /* PI C-867 Piezomotor Controller */
+#define PI_E609_PID	0x100D  /* PI E-609 Digital Piezo Controller */
+#define PI_E709_PID	0x100E  /* PI E-709 Digital Piezo Controller */
+#define PI_100F_PID	0x100F  /* PI Digital Piezo Controller */
+#define PI_1011_PID	0x1011  /* PI Digital Piezo Controller */
+#define PI_1012_PID	0x1012  /* PI Motion Controller */
+#define PI_1013_PID	0x1013  /* PI Motion Controller */
+#define PI_1014_PID	0x1014  /* PI Device */
+#define PI_1015_PID	0x1015  /* PI Device */
+#define PI_1016_PID	0x1016  /* PI Digital Servo Module */
=20
 /*
  * Kondo Kagaku Co.Ltd.
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 113560d..c068b4d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1090,6 +1090,10 @@ static const struct usb_device_id option_ids[] =3D {
 	 .driver_info =3D (kernel_ulong_t)&zte_ad3812_z_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2716, 0xff, =
0xff, 0xff),
 	 .driver_info =3D (kernel_ulong_t)&zte_mc2716_z_blacklist },
+	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x86, 0x10) },
+
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_=
VENDOR_ID */
diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2=
/omapfb/omapfb-main.c
index 70aa47d..f7c1753 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1183,7 +1183,7 @@ static int _setcolreg(struct fb_info *fbi, u_int regn=
o, u_int red, u_int green,
 			break;
=20
 		if (regno < 16) {
-			u16 pal;
+			u32 pal;
 			pal =3D ((red >> (16 - var->red.length)) <<
 					var->red.offset) |
 				((green >> (16 - var->green.length)) <<
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 284798a..89588e7 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -231,7 +231,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t=
 size,
 		return ret;
=20
 	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask =3D hwdev->coherent_dma_mask;
+		dma_mask =3D dma_alloc_coherent_mask(hwdev, flags);
=20
 	phys =3D virt_to_phys(ret);
 	dev_addr =3D xen_phys_to_bus(phys);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0bb785f..51574d4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -882,7 +882,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	if (!buf) {
 		mutex_unlock(&cinode->lock_mutex);
 		FreeXid(xid);
-		return rc;
+		return -ENOMEM;
 	}
=20
 	for (i =3D 0; i < 2; i++) {
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index af11098..7c7556b 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -640,6 +640,7 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *o=
ld_dentry,
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *trap =3D NULL;
+	struct inode *target_inode;
=20
 	lower_old_dentry =3D ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry =3D ecryptfs_dentry_to_lower(new_dentry);
@@ -647,6 +648,7 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *o=
ld_dentry,
 	dget(lower_new_dentry);
 	lower_old_dir_dentry =3D dget_parent(lower_old_dentry);
 	lower_new_dir_dentry =3D dget_parent(lower_new_dentry);
+	target_inode =3D new_dentry->d_inode;
 	trap =3D lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	/* source should not be ancestor of target */
 	if (trap =3D=3D lower_old_dentry) {
@@ -662,6 +664,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *o=
ld_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
+	if (target_inode)
+		fsstack_copy_attr_all(target_inode,
+				      ecryptfs_inode_to_lower(target_inode));
 	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
 	if (new_dir !=3D old_dir)
 		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5b3f907..71b263f 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3072,6 +3072,8 @@ static int ext3_do_update_inode(handle_t *handle,
 	struct ext3_inode_info *ei =3D EXT3_I(inode);
 	struct buffer_head *bh =3D iloc->bh;
 	int err =3D 0, rc, block;
+	int need_datasync =3D 0;
+	__le32 disksize;
=20
 again:
 	/* we can't allow multiple procs in here at once, its a bit racey */
@@ -3109,7 +3111,11 @@ again:
 		raw_inode->i_gid_high =3D 0;
 	}
 	raw_inode->i_links_count =3D cpu_to_le16(inode->i_nlink);
-	raw_inode->i_size =3D cpu_to_le32(ei->i_disksize);
+	disksize =3D cpu_to_le32(ei->i_disksize);
+	if (disksize !=3D raw_inode->i_size) {
+		need_datasync =3D 1;
+		raw_inode->i_size =3D disksize;
+	}
 	raw_inode->i_atime =3D cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime =3D cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime =3D cpu_to_le32(inode->i_mtime.tv_sec);
@@ -3125,8 +3131,11 @@ again:
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl =3D cpu_to_le32(ei->i_dir_acl);
 	} else {
-		raw_inode->i_size_high =3D
-			cpu_to_le32(ei->i_disksize >> 32);
+		disksize =3D cpu_to_le32(ei->i_disksize >> 32);
+		if (disksize !=3D raw_inode->i_size_high) {
+			raw_inode->i_size_high =3D disksize;
+			need_datasync =3D 1;
+		}
 		if (ei->i_disksize > 0x7fffffffULL) {
 			struct super_block *sb =3D inode->i_sb;
 			if (!EXT3_HAS_RO_COMPAT_FEATURE(sb,
@@ -3179,6 +3188,8 @@ again:
 	ext3_clear_inode_state(inode, EXT3_STATE_NEW);
=20
 	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
+	if (need_datasync)
+		atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
 out_brelse:
 	brelse (bh);
 	ext3_std_error(inode->i_sb, err);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 2aaf3ea..5c029fb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1524,6 +1524,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct=
 inode *inode,
 		req->pages[req->num_pages] =3D page;
 		req->num_pages++;
=20
+		offset =3D 0;
 		num -=3D this_num;
 		total_len +=3D this_num;
 		index++;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 50a15fa..b78b5b6 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -150,7 +150,7 @@ static void nfs_zap_caches_locked(struct inode *inode)
 	nfsi->attrtimeo =3D NFS_MINATTRTIMEO(inode);
 	nfsi->attrtimeo_timestamp =3D jiffies;
=20
-	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
+	memset(NFS_I(inode)->cookieverf, 0, sizeof(NFS_I(inode)->cookieverf));
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
 		nfsi->cache_validity |=3D NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_=
INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
 	else
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 5195fd6..dba87e6 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -633,7 +633,7 @@ nfs3_proc_readdir(struct dentry *dentry, struct rpc_cre=
d *cred,
 		  u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct inode		*dir =3D dentry->d_inode;
-	__be32			*verf =3D NFS_COOKIEVERF(dir);
+	__be32			*verf =3D NFS_I(dir)->cookieverf;
 	struct nfs3_readdirargs	arg =3D {
 		.fh		=3D NFS_FH(dir),
 		.cookie		=3D cookie,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index d20221d..61796a40 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3025,11 +3025,11 @@ static int _nfs4_proc_readdir(struct dentry *dentry=
, struct rpc_cred *cred,
 			dentry->d_parent->d_name.name,
 			dentry->d_name.name,
 			(unsigned long long)cookie);
-	nfs4_setup_readdir(cookie, NFS_COOKIEVERF(dir), dentry, &args);
+	nfs4_setup_readdir(cookie, NFS_I(dir)->cookieverf, dentry, &args);
 	res.pgbase =3D args.pgbase;
 	status =3D nfs4_call_sync(NFS_SERVER(dir)->client, NFS_SERVER(dir), &msg,=
 &args.seq_args, &res.seq_res, 0);
 	if (status >=3D 0) {
-		memcpy(NFS_COOKIEVERF(dir), res.verifier.data, NFS4_VERIFIER_SIZE);
+		memcpy(NFS_I(dir)->cookieverf, res.verifier.data, NFS4_VERIFIER_SIZE);
 		status +=3D args.pgbase;
 	}
=20
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index bdd5bdc..00818c8 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -6113,7 +6113,8 @@ static int nfs4_xdr_dec_open(struct rpc_rqst *rqstp, =
struct xdr_stream *xdr,
 	status =3D decode_open(xdr, res);
 	if (status)
 		goto out;
-	if (decode_getfh(xdr, &res->fh) !=3D 0)
+	status =3D decode_getfh(xdr, &res->fh);
+	if (status)
 		goto out;
 	if (decode_getfattr(xdr, res->f_attr, res->server,
 				!RPC_IS_ASYNC(rqstp->rq_task)) !=3D 0)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6e85ec6..e42d6f6 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1820,6 +1820,7 @@ static int nfs_validate_mount_data(void *options,
=20
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen =3D sizeof(data->addr);
+		args->nfs_server.port =3D ntohs(data->addr.sin_port);
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
=20
@@ -2538,6 +2539,7 @@ static int nfs4_validate_mount_data(void *options,
 			return -EFAULT;
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
+		args->nfs_server.port =3D ntohs(((struct sockaddr_in *)sap)->sin_port);
=20
 		if (data->auth_flavourlen) {
 			if (data->auth_flavourlen > 1)
diff --git a/fs/stat.c b/fs/stat.c
index 8806b89..7b21801 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -57,12 +57,13 @@ EXPORT_SYMBOL(vfs_getattr);
=20
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
-	struct file *f =3D fget(fd);
+	int fput_needed;
+	struct file *f =3D fget_raw_light(fd, &fput_needed);
 	int error =3D -EBADF;
=20
 	if (f) {
 		error =3D vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
-		fput(f);
+		fput_light(f, fput_needed);
 	}
 	return error;
 }
diff --git a/fs/udf/file.c b/fs/udf/file.c
index d567b84..874c9e3 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -39,20 +39,24 @@
 #include "udf_i.h"
 #include "udf_sb.h"
=20
-static int udf_adinicb_readpage(struct file *file, struct page *page)
+static void __udf_adinicb_readpage(struct page *page)
 {
 	struct inode *inode =3D page->mapping->host;
 	char *kaddr;
 	struct udf_inode_info *iinfo =3D UDF_I(inode);
=20
-	BUG_ON(!PageLocked(page));
-
 	kaddr =3D kmap(page);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
 	memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr, inode->i_size);
+	memset(kaddr + inode->i_size, 0, PAGE_CACHE_SIZE - inode->i_size);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	kunmap(page);
+}
+
+static int udf_adinicb_readpage(struct file *file, struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	__udf_adinicb_readpage(page);
 	unlock_page(page);
=20
 	return 0;
@@ -77,6 +81,25 @@ static int udf_adinicb_writepage(struct page *page,
 	return 0;
 }
=20
+static int udf_adinicb_write_begin(struct file *file,
+			struct address_space *mapping, loff_t pos,
+			unsigned len, unsigned flags, struct page **pagep,
+			void **fsdata)
+{
+	struct page *page;
+
+	if (WARN_ON_ONCE(pos >=3D PAGE_CACHE_SIZE))
+		return -EIO;
+	page =3D grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page)
+		return -ENOMEM;
+	*pagep =3D page;
+
+	if (!PageUptodate(page) && len !=3D PAGE_CACHE_SIZE)
+		__udf_adinicb_readpage(page);
+	return 0;
+}
+
 static int udf_adinicb_write_end(struct file *file,
 			struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
@@ -98,8 +121,8 @@ static int udf_adinicb_write_end(struct file *file,
 const struct address_space_operations udf_adinicb_aops =3D {
 	.readpage	=3D udf_adinicb_readpage,
 	.writepage	=3D udf_adinicb_writepage,
-	.write_begin =3D simple_write_begin,
-	.write_end =3D udf_adinicb_write_end,
+	.write_begin	=3D udf_adinicb_write_begin,
+	.write_end	=3D udf_adinicb_write_end,
 };
=20
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *=
iov,
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index ddd46db..7639f18 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -277,8 +277,9 @@ struct drm_mode_mode_cmd {
 	struct drm_mode_modeinfo mode;
 };
=20
-#define DRM_MODE_CURSOR_BO	(1<<0)
-#define DRM_MODE_CURSOR_MOVE	(1<<1)
+#define DRM_MODE_CURSOR_BO	0x01
+#define DRM_MODE_CURSOR_MOVE	0x02
+#define DRM_MODE_CURSOR_FLAGS	0x03
=20
 /*
  * depending on the value in flags different members are used.
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ad81e1c..445f978 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -226,7 +226,7 @@ static inline int kobject_uevent_env(struct kobject *ko=
bj,
=20
 static inline __printf(2, 3)
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
-{ return 0; }
+{ return -ENOMEM; }
=20
 static inline int kobject_action_type(const char *buf, size_t count,
 				      enum kobject_action *type)
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 603bec2..06177ba10 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -58,13 +58,6 @@ union ktime {
=20
 typedef union ktime ktime_t;		/* Kill this */
=20
-#define KTIME_MAX			((s64)~((u64)1 << 63))
-#if (BITS_PER_LONG =3D=3D 64)
-# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#else
-# define KTIME_SEC_MAX			LONG_MAX
-#endif
-
 /*
  * ktime_t definitions when using the 64-bit scalar representation:
  */
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index c8ef9bc..87967ee 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -219,6 +219,7 @@ struct mmc_card {
 #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular multiblo=
ck */
 #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512 bytes i=
n */
 #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
+#define MMC_QUIRK_SEC_ERASE_TRIM_BROKEN (1<<10)	/* Skip secure for erase/t=
rim */
 						/* byte mode */
 	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
 #define MMC_NO_POWER_NOTIFICATION	0
diff --git a/include/linux/mv643xx_eth.h b/include/linux/mv643xx_eth.h
index 30b0c4e..43e038a 100644
--- a/include/linux/mv643xx_eth.h
+++ b/include/linux/mv643xx_eth.h
@@ -15,6 +15,8 @@
 #define MV643XX_ETH_SIZE_REG_4		0x2224
 #define MV643XX_ETH_BASE_ADDR_ENABLE_REG	0x2290
=20
+#define MV643XX_TX_CSUM_DEFAULT_LIMIT	0
+
 struct mv643xx_eth_shared_platform_data {
 	struct mbus_dram_target_info	*dram;
 	struct platform_device	*shared_smi;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cb52340..00ca32b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1299,6 +1299,8 @@ struct net_device {
 	/* for setting kernel sock attribute on TCP connection setup */
 #define GSO_MAX_SIZE		65536
 	unsigned int		gso_max_size;
+#define GSO_MAX_SEGS		65535
+	u16			gso_max_segs;
=20
 #ifdef CONFIG_DCB
 	/* Data Center Bridging netlink ops */
@@ -1511,6 +1513,8 @@ struct packet_type {
 	struct sk_buff		**(*gro_receive)(struct sk_buff **head,
 					       struct sk_buff *skb);
 	int			(*gro_complete)(struct sk_buff *skb);
+	bool			(*id_match)(struct packet_type *ptype,
+					    struct sock *sk);
 	void			*af_packet_priv;
 	struct list_head	list;
 };
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 92ecf55..33c52a2 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -261,11 +261,6 @@ static inline const struct nfs_rpc_ops *NFS_PROTO(cons=
t struct inode *inode)
 	return NFS_SERVER(inode)->nfs_client->rpc_ops;
 }
=20
-static inline __be32 *NFS_COOKIEVERF(const struct inode *inode)
-{
-	return NFS_I(inode)->cookieverf;
-}
-
 static inline unsigned NFS_MINATTRTIMEO(const struct inode *inode)
 {
 	struct nfs_server *nfss =3D NFS_SERVER(inode);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2aaee0c..67cc215 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2124,7 +2124,7 @@
 #define PCI_DEVICE_ID_TIGON3_5704S	0x16a8
 #define PCI_DEVICE_ID_NX2_57800_VF	0x16a9
 #define PCI_DEVICE_ID_NX2_5706S		0x16aa
-#define PCI_DEVICE_ID_NX2_57840_MF	0x16ab
+#define PCI_DEVICE_ID_NX2_57840_MF	0x16a4
 #define PCI_DEVICE_ID_NX2_5708S		0x16ac
 #define PCI_DEVICE_ID_NX2_57840_VF	0x16ad
 #define PCI_DEVICE_ID_NX2_57810_MF	0x16ae
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b1f8912..b669be6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -794,7 +794,7 @@ struct perf_event {
 	struct hw_perf_event		hw;
=20
 	struct perf_event_context	*ctx;
-	struct file			*filp;
+	atomic_long_t			refcount;
=20
 	/*
 	 * These accumulate total time (in nanoseconds) that children
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 15518a1..0a4cd10 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -114,6 +114,7 @@ struct rpc_xprt_ops {
 	void		(*set_buffer_size)(struct rpc_xprt *xprt, size_t sndsize, size_t rc=
vsize);
 	int		(*reserve_xprt)(struct rpc_xprt *xprt, struct rpc_task *task);
 	void		(*release_xprt)(struct rpc_xprt *xprt, struct rpc_task *task);
+	void		(*alloc_slot)(struct rpc_xprt *xprt, struct rpc_task *task);
 	void		(*rpcbind)(struct rpc_task *task);
 	void		(*set_port)(struct rpc_xprt *xprt, unsigned short port);
 	void		(*connect)(struct rpc_task *task);
@@ -274,6 +275,8 @@ void			xprt_connect(struct rpc_task *task);
 void			xprt_reserve(struct rpc_task *task);
 int			xprt_reserve_xprt(struct rpc_xprt *xprt, struct rpc_task *task);
 int			xprt_reserve_xprt_cong(struct rpc_xprt *xprt, struct rpc_task *task)=
;
+void			xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task);
+void			xprt_lock_and_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *ta=
sk);
 int			xprt_prepare_transmit(struct rpc_task *task);
 void			xprt_transmit(struct rpc_task *task);
 void			xprt_end_transmit(struct rpc_task *task);
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..8c0216e 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -107,11 +107,36 @@ static inline struct timespec timespec_sub(struct tim=
espec lhs,
 	return ts_delta;
 }
=20
+#define KTIME_MAX			((s64)~((u64)1 << 63))
+#if (BITS_PER_LONG =3D=3D 64)
+# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#else
+# define KTIME_SEC_MAX			LONG_MAX
+#endif
+
 /*
  * Returns true if the timespec is norm, false if denorm:
  */
-#define timespec_valid(ts) \
-	(((ts)->tv_sec >=3D 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC=
))
+static inline bool timespec_valid(const struct timespec *ts)
+{
+	/* Dates before 1970 are bogus */
+	if (ts->tv_sec < 0)
+		return false;
+	/* Can't have more nanoseconds then a second */
+	if ((unsigned long)ts->tv_nsec >=3D NSEC_PER_SEC)
+		return false;
+	return true;
+}
+
+static inline bool timespec_valid_strict(const struct timespec *ts)
+{
+	if (!timespec_valid(ts))
+		return false;
+	/* Disallow values that could overflow ktime_t */
+	if ((unsigned long long)ts->tv_sec >=3D KTIME_SEC_MAX)
+		return false;
+	return true;
+}
=20
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/include/net/scm.h b/include/net/scm.h
index d456f4c..0c0017c 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -71,9 +71,11 @@ static __inline__ void scm_destroy(struct scm_cookie *sc=
m)
 }
=20
 static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
-			       struct scm_cookie *scm)
+			       struct scm_cookie *scm, bool forcecreds)
 {
 	memset(scm, 0, sizeof(*scm));
+	if (forcecreds)
+		scm_set_cred(scm, task_tgid(current), current_cred());
 	unix_get_peersec_dgram(sock, scm);
 	if (msg->msg_controllen <=3D 0)
 		return 0;
diff --git a/include/net/sock.h b/include/net/sock.h
index 32e3937..ddf523c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -194,6 +194,7 @@ struct sock_common {
   *	@sk_route_nocaps: forbidden route capabilities (e.g NETIF_F_GSO_MASK)
   *	@sk_gso_type: GSO type (e.g. %SKB_GSO_TCPV4)
   *	@sk_gso_max_size: Maximum GSO segment size to build
+  *	@sk_gso_max_segs: Maximum number of GSO segments
   *	@sk_lingertime: %SO_LINGER l_linger setting
   *	@sk_backlog: always used with the per-socket spinlock held
   *	@sk_callback_lock: used with the callbacks in the end of this struct
@@ -310,6 +311,7 @@ struct sock {
 	int			sk_route_nocaps;
 	int			sk_gso_type;
 	unsigned int		sk_gso_max_size;
+	u16			sk_gso_max_segs;
 	int			sk_rcvlowat;
 	unsigned long	        sk_lingertime;
 	struct sk_buff_head	sk_error_queue;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 58690af..7d1f05e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3011,12 +3011,12 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 /*
  * Called when the last reference to the file is gone.
  */
-static int perf_release(struct inode *inode, struct file *file)
+static void put_event(struct perf_event *event)
 {
-	struct perf_event *event =3D file->private_data;
 	struct task_struct *owner;
=20
-	file->private_data =3D NULL;
+	if (!atomic_long_dec_and_test(&event->refcount))
+		return;
=20
 	rcu_read_lock();
 	owner =3D ACCESS_ONCE(event->owner);
@@ -3051,7 +3051,13 @@ static int perf_release(struct inode *inode, struct =
file *file)
 		put_task_struct(owner);
 	}
=20
-	return perf_event_release_kernel(event);
+	perf_event_release_kernel(event);
+}
+
+static int perf_release(struct inode *inode, struct file *file)
+{
+	put_event(file->private_data);
+	return 0;
 }
=20
 u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *run=
ning)
@@ -3304,7 +3310,7 @@ unlock:
=20
 static const struct file_operations perf_fops;
=20
-static struct perf_event *perf_fget_light(int fd, int *fput_needed)
+static struct file *perf_fget_light(int fd, int *fput_needed)
 {
 	struct file *file;
=20
@@ -3318,7 +3324,7 @@ static struct perf_event *perf_fget_light(int fd, int=
 *fput_needed)
 		return ERR_PTR(-EBADF);
 	}
=20
-	return file->private_data;
+	return file;
 }
=20
 static int perf_event_set_output(struct perf_event *event,
@@ -3350,19 +3356,21 @@ static long perf_ioctl(struct file *file, unsigned =
int cmd, unsigned long arg)
=20
 	case PERF_EVENT_IOC_SET_OUTPUT:
 	{
+		struct file *output_file =3D NULL;
 		struct perf_event *output_event =3D NULL;
 		int fput_needed =3D 0;
 		int ret;
=20
 		if (arg !=3D -1) {
-			output_event =3D perf_fget_light(arg, &fput_needed);
-			if (IS_ERR(output_event))
-				return PTR_ERR(output_event);
+			output_file =3D perf_fget_light(arg, &fput_needed);
+			if (IS_ERR(output_file))
+				return PTR_ERR(output_file);
+			output_event =3D output_file->private_data;
 		}
=20
 		ret =3D perf_event_set_output(event, output_event);
 		if (output_event)
-			fput_light(output_event->filp, fput_needed);
+			fput_light(output_file, fput_needed);
=20
 		return ret;
 	}
@@ -5912,6 +5920,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cp=
u,
=20
 	mutex_init(&event->mmap_mutex);
=20
+	atomic_long_set(&event->refcount, 1);
 	event->cpu		=3D cpu;
 	event->attr		=3D *attr;
 	event->group_leader	=3D group_leader;
@@ -6182,12 +6191,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		return event_fd;
=20
 	if (group_fd !=3D -1) {
-		group_leader =3D perf_fget_light(group_fd, &fput_needed);
-		if (IS_ERR(group_leader)) {
-			err =3D PTR_ERR(group_leader);
+		group_file =3D perf_fget_light(group_fd, &fput_needed);
+		if (IS_ERR(group_file)) {
+			err =3D PTR_ERR(group_file);
 			goto err_fd;
 		}
-		group_file =3D group_leader->filp;
+		group_leader =3D group_file->private_data;
 		if (flags & PERF_FLAG_FD_OUTPUT)
 			output_event =3D group_leader;
 		if (flags & PERF_FLAG_FD_NO_GROUP)
@@ -6322,7 +6331,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		put_ctx(gctx);
 	}
=20
-	event->filp =3D event_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
=20
@@ -6412,7 +6420,6 @@ perf_event_create_kernel_counter(struct perf_event_at=
tr *attr, int cpu,
 		goto err_free;
 	}
=20
-	event->filp =3D NULL;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
@@ -6461,7 +6468,7 @@ static void sync_child_event(struct perf_event *child=
_event,
 	 * Release the parent event, if this was the last
 	 * reference to it.
 	 */
-	fput(parent_event->filp);
+	put_event(parent_event);
 }
=20
 static void
@@ -6537,9 +6544,8 @@ static void perf_event_exit_task_context(struct task_=
struct *child, int ctxn)
 	 *
 	 *   __perf_event_exit_task()
 	 *     sync_child_event()
-	 *       fput(parent_event->filp)
-	 *         perf_release()
-	 *           mutex_lock(&ctx->mutex)
+	 *       put_event()
+	 *         mutex_lock(&ctx->mutex)
 	 *
 	 * But since its the parent context it won't be the same instance.
 	 */
@@ -6607,7 +6613,7 @@ static void perf_free_event(struct perf_event *event,
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
=20
-	fput(parent->filp);
+	put_event(parent);
=20
 	perf_group_detach(event);
 	list_del_event(event, ctx);
@@ -6687,6 +6693,12 @@ inherit_event(struct perf_event *parent_event,
 				           NULL, NULL);
 	if (IS_ERR(child_event))
 		return child_event;
+
+	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
+		free_event(child_event);
+		return NULL;
+	}
+
 	get_ctx(child_ctx);
=20
 	/*
@@ -6728,14 +6740,6 @@ inherit_event(struct perf_event *parent_event,
 	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
=20
 	/*
-	 * Get a reference to the parent filp - we will fput it
-	 * when the child event exits. This is safe to do because
-	 * we are in the parent and we know that the filp still
-	 * exists and has a nonzero count:
-	 */
-	atomic_long_inc(&parent_event->filp->f_count);
-
-	/*
 	 * Link this into the parent event's child list
 	 */
 	WARN_ON_ONCE(parent_event->ctx->parent_ctx);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 03e67d4..5ee1ac0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -382,7 +382,7 @@ int do_settimeofday(const struct timespec *tv)
 	struct timespec ts_delta;
 	unsigned long flags;
=20
-	if ((unsigned long)tv->tv_nsec >=3D NSEC_PER_SEC)
+	if (!timespec_valid_strict(tv))
 		return -EINVAL;
=20
 	write_seqlock_irqsave(&xtime_lock, flags);
@@ -417,6 +417,8 @@ EXPORT_SYMBOL(do_settimeofday);
 int timekeeping_inject_offset(struct timespec *ts)
 {
 	unsigned long flags;
+	struct timespec tmp;
+	int ret =3D 0;
=20
 	if ((unsigned long)ts->tv_nsec >=3D NSEC_PER_SEC)
 		return -EINVAL;
@@ -425,9 +427,16 @@ int timekeeping_inject_offset(struct timespec *ts)
=20
 	timekeeping_forward_now();
=20
+	tmp =3D timespec_add(xtime,  *ts);
+	if (!timespec_valid_strict(&tmp)) {
+		ret =3D -EINVAL;
+		goto error;
+	}
+
 	xtime =3D timespec_add(xtime, *ts);
 	wall_to_monotonic =3D timespec_sub(wall_to_monotonic, *ts);
=20
+error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(true);
=20
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -435,7 +444,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	/* signal hrtimers about time change */
 	clock_was_set();
=20
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(timekeeping_inject_offset);
=20
@@ -582,7 +591,20 @@ void __init timekeeping_init(void)
 	struct timespec now, boot;
=20
 	read_persistent_clock(&now);
+	if (!timespec_valid_strict(&now)) {
+		pr_warn("WARNING: Persistent clock returned invalid value!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		now.tv_sec =3D 0;
+		now.tv_nsec =3D 0;
+	}
+
 	read_boot_clock(&boot);
+	if (!timespec_valid_strict(&boot)) {
+		pr_warn("WARNING: Boot clock returned invalid value!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		boot.tv_sec =3D 0;
+		boot.tv_nsec =3D 0;
+	}
=20
 	write_seqlock_irqsave(&xtime_lock, flags);
=20
@@ -627,7 +649,7 @@ static void update_sleep_time(struct timespec t)
  */
 static void __timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	if (!timespec_valid(delta)) {
+	if (!timespec_valid_strict(delta)) {
 		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
 					"sleep delta value!\n");
 		return;
@@ -1011,6 +1033,10 @@ static void update_wall_time(void)
 #else
 	offset =3D (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
+	/* Check if there's really nothing to do */
+	if (offset < timekeeper.cycle_interval)
+		return;
+
 	timekeeper.xtime_nsec =3D (s64)xtime.tv_nsec << timekeeper.shift;
=20
 	/*
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a650bee..979d4de 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3437,14 +3437,17 @@ static int __cpuinit trustee_thread(void *__gcwq)
=20
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work =3D &worker->rebind_work;
+		unsigned long worker_flags =3D worker->flags;
=20
 		/*
 		 * Rebind_work may race with future cpu hotplug
 		 * operations.  Use a separate flag to mark that
-		 * rebinding is scheduled.
+		 * rebinding is scheduled.  The morphing should
+		 * be atomic.
 		 */
-		worker->flags |=3D WORKER_REBIND;
-		worker->flags &=3D ~WORKER_ROGUE;
+		worker_flags |=3D WORKER_REBIND;
+		worker_flags &=3D ~WORKER_ROGUE;
+		ACCESS_ONCE(worker->flags) =3D worker_flags;
=20
 		/* queue rebind_work, wq doesn't matter, use the default one */
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c0007f9..11b8d47 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2533,7 +2533,7 @@ int mpol_to_str(char *buffer, int maxlen, struct memp=
olicy *pol, int no_context)
 		break;
=20
 	default:
-		BUG();
+		return -EINVAL;
 	}
=20
 	l =3D strlen(policy_modes[mode]);
diff --git a/net/atm/common.c b/net/atm/common.c
index 14ff9fe..0ca06e8 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -784,6 +784,7 @@ int vcc_getsockopt(struct socket *sock, int level, int =
optname,
=20
 		if (!vcc->dev || !test_bit(ATM_VF_ADDR, &vcc->flags))
 			return -ENOTCONN;
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family =3D AF_ATMPVC;
 		pvc.sap_addr.itf =3D vcc->dev->number;
 		pvc.sap_addr.vpi =3D vcc->vpi;
diff --git a/net/atm/pvc.c b/net/atm/pvc.c
index 3a73491..ae03240 100644
--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -95,6 +95,7 @@ static int pvc_getname(struct socket *sock, struct sockad=
dr *sockaddr,
 		return -ENOTCONN;
 	*sockaddr_len =3D sizeof(struct sockaddr_atmpvc);
 	addr =3D (struct sockaddr_atmpvc *)sockaddr;
+	memset(addr, 0, sizeof(*addr));
 	addr->sap_family =3D AF_ATMPVC;
 	addr->sap_addr.itf =3D vcc->dev->number;
 	addr->sap_addr.vpi =3D vcc->vpi;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index f6afe3d..8361ee4 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -388,6 +388,7 @@ static int hci_sock_getname(struct socket *sock, struct=
 sockaddr *addr, int *add
 	*addr_len =3D sizeof(*haddr);
 	haddr->hci_family =3D AF_BLUETOOTH;
 	haddr->hci_dev    =3D hdev->id;
+	haddr->hci_channel=3D 0;
=20
 	release_sock(sk);
 	return 0;
@@ -671,6 +672,7 @@ static int hci_sock_getsockopt(struct socket *sock, int=
 level, int optname, char
 		{
 			struct hci_filter *f =3D &hci_pi(sk)->filter;
=20
+			memset(&uf, 0, sizeof(uf));
 			uf.type_mask =3D f->type_mask;
 			uf.opcode    =3D f->opcode;
 			uf.event_mask[0] =3D *((u32 *) f->event_mask + 0);
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 5c406d3..6dedd6f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -293,6 +293,7 @@ static int l2cap_sock_getname(struct socket *sock, stru=
ct sockaddr *addr, int *l
=20
 	BT_DBG("sock %p, sk %p", sock, sk);
=20
+	memset(la, 0, sizeof(struct sockaddr_l2));
 	addr->sa_family =3D AF_BLUETOOTH;
 	*len =3D sizeof(struct sockaddr_l2);
=20
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 5417f61..7ee4ead 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -547,6 +547,7 @@ static int rfcomm_sock_getname(struct socket *sock, str=
uct sockaddr *addr, int *
=20
 	BT_DBG("sock %p, sk %p", sock, sk);
=20
+	memset(sa, 0, sizeof(*sa));
 	sa->rc_family  =3D AF_BLUETOOTH;
 	sa->rc_channel =3D rfcomm_pi(sk)->channel;
 	if (peer)
@@ -835,6 +836,7 @@ static int rfcomm_sock_getsockopt(struct socket *sock, =
int level, int optname, c
 		}
=20
 		sec.level =3D rfcomm_pi(sk)->sec_level;
+		sec.key_size =3D 0;
=20
 		len =3D min_t(unsigned int, len, sizeof(sec));
 		if (copy_to_user(optval, (char *) &sec, len))
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index c258796..bc1eb56 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -471,7 +471,7 @@ static int rfcomm_get_dev_list(void __user *arg)
=20
 	size =3D sizeof(*dl) + dev_num * sizeof(*di);
=20
-	dl =3D kmalloc(size, GFP_KERNEL);
+	dl =3D kzalloc(size, GFP_KERNEL);
 	if (!dl)
 		return -ENOMEM;
=20
diff --git a/net/core/dev.c b/net/core/dev.c
index 4b18703..832ba6d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1059,6 +1059,8 @@ rollback:
  */
 int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 {
+	char *new_ifalias;
+
 	ASSERT_RTNL();
=20
 	if (len >=3D IFALIASZ)
@@ -1072,9 +1074,10 @@ int dev_set_alias(struct net_device *dev, const char=
 *alias, size_t len)
 		return 0;
 	}
=20
-	dev->ifalias =3D krealloc(dev->ifalias, len + 1, GFP_KERNEL);
-	if (!dev->ifalias)
+	new_ifalias =3D krealloc(dev->ifalias, len + 1, GFP_KERNEL);
+	if (!new_ifalias)
 		return -ENOMEM;
+	dev->ifalias =3D new_ifalias;
=20
 	strlcpy(dev->ifalias, alias, len+1);
 	return len;
@@ -1628,6 +1631,19 @@ static inline int deliver_skb(struct sk_buff *skb,
 	return pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 }
=20
+static inline bool skb_loop_sk(struct packet_type *ptype, struct sk_buff *=
skb)
+{
+	if (ptype->af_packet_priv =3D=3D NULL)
+		return false;
+
+	if (ptype->id_match)
+		return ptype->id_match(ptype, skb->sk);
+	else if ((struct sock *)ptype->af_packet_priv =3D=3D skb->sk)
+		return true;
+
+	return false;
+}
+
 /*
  *	Support routine. Sends outgoing frames to any network
  *	taps currently in use.
@@ -1645,8 +1661,7 @@ static void dev_queue_xmit_nit(struct sk_buff *skb, s=
truct net_device *dev)
 		 * they originated from - MvS (miquels@drinkel.ow.org)
 		 */
 		if ((ptype->dev =3D=3D dev || !ptype->dev) &&
-		    (ptype->af_packet_priv =3D=3D NULL ||
-		     (struct sock *)ptype->af_packet_priv !=3D skb->sk)) {
+		    (!skb_loop_sk(ptype, skb))) {
 			if (pt_prev) {
 				deliver_skb(skb2, pt_prev, skb->dev);
 				pt_prev =3D ptype;
@@ -2108,6 +2123,9 @@ u32 netif_skb_features(struct sk_buff *skb)
 	__be16 protocol =3D skb->protocol;
 	u32 features =3D skb->dev->features;
=20
+	if (skb_shinfo(skb)->gso_segs > skb->dev->gso_max_segs)
+		features &=3D ~NETIF_F_GSO_MASK;
+
 	if (protocol =3D=3D htons(ETH_P_8021Q)) {
 		struct vlan_ethhdr *veh =3D (struct vlan_ethhdr *)skb->data;
 		protocol =3D veh->h_vlan_encapsulated_proto;
@@ -5990,6 +6008,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, =
const char *name,
 	dev_net_set(dev, &init_net);
=20
 	dev->gso_max_size =3D GSO_MAX_SIZE;
+	dev->gso_max_segs =3D GSO_MAX_SEGS;
=20
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
diff --git a/net/core/sock.c b/net/core/sock.c
index 8d095b9..018fd41 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1308,6 +1308,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry =
*dst)
 		} else {
 			sk->sk_route_caps |=3D NETIF_F_SG | NETIF_F_HW_CSUM;
 			sk->sk_gso_max_size =3D dst->dev->gso_max_size;
+			sk->sk_gso_max_segs =3D dst->dev->gso_max_segs;
 		}
 	}
 }
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index 3d604e1..4caf63f 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -532,6 +532,7 @@ static int ccid3_hc_tx_getsockopt(struct sock *sk, cons=
t int optname, int len,
 	case DCCP_SOCKOPT_CCID_TX_INFO:
 		if (len < sizeof(tfrc))
 			return -EINVAL;
+		memset(&tfrc, 0, sizeof(tfrc));
 		tfrc.tfrctx_x	   =3D hc->tx_x;
 		tfrc.tfrctx_x_recv =3D hc->tx_x_recv;
 		tfrc.tfrctx_x_calc =3D hc->tx_x_calc;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index d2aae27..0064394 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -125,6 +125,8 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
 static struct kmem_cache *mrt_cachep __read_mostly;
=20
 static struct mr_table *ipmr_new_table(struct net *net, u32 id);
+static void ipmr_free_table(struct mr_table *mrt);
+
 static int ip_mr_forward(struct net *net, struct mr_table *mrt,
 			 struct sk_buff *skb, struct mfc_cache *cache,
 			 int local);
@@ -132,6 +134,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert);
 static int __ipmr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 			      struct mfc_cache *c, struct rtmsg *rtm);
+static void mroute_clean_tables(struct mr_table *mrt);
 static void ipmr_expire_process(unsigned long arg);
=20
 #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
@@ -272,7 +275,7 @@ static void __net_exit ipmr_rules_exit(struct net *net)
=20
 	list_for_each_entry_safe(mrt, next, &net->ipv4.mr_tables, list) {
 		list_del(&mrt->list);
-		kfree(mrt);
+		ipmr_free_table(mrt);
 	}
 	fib_rules_unregister(net->ipv4.mr_rules_ops);
 }
@@ -300,7 +303,7 @@ static int __net_init ipmr_rules_init(struct net *net)
=20
 static void __net_exit ipmr_rules_exit(struct net *net)
 {
-	kfree(net->ipv4.mrt);
+	ipmr_free_table(net->ipv4.mrt);
 }
 #endif
=20
@@ -337,6 +340,13 @@ static struct mr_table *ipmr_new_table(struct net *net=
, u32 id)
 	return mrt;
 }
=20
+static void ipmr_free_table(struct mr_table *mrt)
+{
+	del_timer_sync(&mrt->ipmr_expire_timer);
+	mroute_clean_tables(mrt);
+	kfree(mrt);
+}
+
 /* Service routines creating virtual interfaces: DVMRP tunnels and PIMREG =
*/
=20
 static void ipmr_del_tunnel(struct net_device *dev, struct vifctl *v)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ad466a7..043d49b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -740,7 +740,9 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk,=
 u32 mss_now,
 			   old_size_goal + mss_now > xmit_size_goal)) {
 			xmit_size_goal =3D old_size_goal;
 		} else {
-			tp->xmit_size_goal_segs =3D xmit_size_goal / mss_now;
+			tp->xmit_size_goal_segs =3D
+				min_t(u16, xmit_size_goal / mss_now,
+				      sk->sk_gso_max_segs);
 			xmit_size_goal =3D tp->xmit_size_goal_segs * mss_now;
 		}
 	}
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 850c737..6cebfd2 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -290,7 +290,8 @@ int tcp_is_cwnd_limited(const struct sock *sk, u32 in_f=
light)
 	left =3D tp->snd_cwnd - in_flight;
 	if (sk_can_gso(sk) &&
 	    left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd &&
-	    left * tp->mss_cache < sk->sk_gso_max_size)
+	    left * tp->mss_cache < sk->sk_gso_max_size &&
+	    left < sk->sk_gso_max_segs)
 		return 1;
 	return left <=3D tcp_max_burst(tp);
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c51dd5b..921cbac 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1318,21 +1318,21 @@ static void tcp_cwnd_validate(struct sock *sk)
  * when we would be allowed to send the split-due-to-Nagle skb fully.
  */
 static unsigned int tcp_mss_split_point(const struct sock *sk, const struc=
t sk_buff *skb,
-					unsigned int mss_now, unsigned int cwnd)
+					unsigned int mss_now, unsigned int max_segs)
 {
 	const struct tcp_sock *tp =3D tcp_sk(sk);
-	u32 needed, window, cwnd_len;
+	u32 needed, window, max_len;
=20
 	window =3D tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
-	cwnd_len =3D mss_now * cwnd;
+	max_len =3D mss_now * max_segs;
=20
-	if (likely(cwnd_len <=3D window && skb !=3D tcp_write_queue_tail(sk)))
-		return cwnd_len;
+	if (likely(max_len <=3D window && skb !=3D tcp_write_queue_tail(sk)))
+		return max_len;
=20
 	needed =3D min(skb->len, window);
=20
-	if (cwnd_len <=3D needed)
-		return cwnd_len;
+	if (max_len <=3D needed)
+		return max_len;
=20
 	return needed - needed % mss_now;
 }
@@ -1560,7 +1560,8 @@ static int tcp_tso_should_defer(struct sock *sk, stru=
ct sk_buff *skb)
 	limit =3D min(send_win, cong_win);
=20
 	/* If a full-sized TSO skb can be sent, do it. */
-	if (limit >=3D sk->sk_gso_max_size)
+	if (limit >=3D min_t(unsigned int, sk->sk_gso_max_size,
+			   sk->sk_gso_max_segs * tp->mss_cache))
 		goto send_now;
=20
 	/* Middle in queue won't get any more data, full sendable already? */
@@ -1786,7 +1787,9 @@ static int tcp_write_xmit(struct sock *sk, unsigned i=
nt mss_now, int nonagle,
 		limit =3D mss_now;
 		if (tso_segs > 1 && !tcp_urg_mode(tp))
 			limit =3D tcp_mss_split_point(sk, skb, mss_now,
-						    cwnd_quota);
+						    min_t(unsigned int,
+							  cwnd_quota,
+							  sk->sk_gso_max_segs));
=20
 		if (skb->len > limit &&
 		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp)))
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a5521c5..aef80d7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -493,8 +493,7 @@ static void addrconf_forward_change(struct net *net, __=
s32 newf)
 	struct net_device *dev;
 	struct inet6_dev *idev;
=20
-	rcu_read_lock();
-	for_each_netdev_rcu(net, dev) {
+	for_each_netdev(net, dev) {
 		idev =3D __in6_dev_get(dev);
 		if (idev) {
 			int changed =3D (!idev->cnf.forwarding) ^ (!newf);
@@ -503,7 +502,6 @@ static void addrconf_forward_change(struct net *net, __=
s32 newf)
 				dev_forward_change(idev);
 		}
 	}
-	rcu_read_unlock();
 }
=20
 static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int =
old)
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 89ff8c6..7501b22 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1253,11 +1253,10 @@ static void l2tp_tunnel_free(struct l2tp_tunnel *tu=
nnel)
 	/* Remove from tunnel list */
 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
 	list_del_rcu(&tunnel->list);
+	kfree_rcu(tunnel, rcu);
 	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-	synchronize_rcu();
=20
 	atomic_dec(&l2tp_tunnel_count);
-	kfree(tunnel);
 }
=20
 /* Create a socket for the tunnel, if one isn't set up by
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index a16a48e..4393794 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -157,6 +157,7 @@ struct l2tp_tunnel_cfg {
=20
 struct l2tp_tunnel {
 	int			magic;		/* Should be L2TP_TUNNEL_MAGIC */
+	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
 						/* hashed list of sessions,
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index a18e6c3..99a60d5 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -966,14 +966,13 @@ static int llc_ui_getname(struct socket *sock, struct=
 sockaddr *uaddr,
 	struct sockaddr_llc sllc;
 	struct sock *sk =3D sock->sk;
 	struct llc_sock *llc =3D llc_sk(sk);
-	int rc =3D 0;
+	int rc =3D -EBADF;
=20
 	memset(&sllc, 0, sizeof(sllc));
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 	*uaddrlen =3D sizeof(sllc);
-	memset(uaddr, 0, *uaddrlen);
 	if (peer) {
 		rc =3D -ENOTCONN;
 		if (sk->sk_state !=3D TCP_ESTABLISHED)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.=
c
index e1a66cf..72f4253 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2713,6 +2713,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __use=
r *user, int *len)
 	{
 		struct ip_vs_timeout_user t;
=20
+		memset(&t, 0, sizeof(t));
 		__ip_vs_get_timeouts(net, &t);
 		if (copy_to_user(user, &t, sizeof(t)) !=3D 0)
 			ret =3D -EFAULT;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a99fb41..38b78b9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1333,7 +1333,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struc=
t socket *sock,
 	if (NULL =3D=3D siocb->scm)
 		siocb->scm =3D &scm;
=20
-	err =3D scm_send(sock, msg, siocb->scm);
+	err =3D scm_send(sock, msg, siocb->scm, true);
 	if (err < 0)
 		return err;
=20
@@ -1344,7 +1344,8 @@ static int netlink_sendmsg(struct kiocb *kiocb, struc=
t socket *sock,
 		dst_pid =3D addr->nl_pid;
 		dst_group =3D ffs(addr->nl_groups);
 		err =3D  -EPERM;
-		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND))
+		if ((dst_group || dst_pid) &&
+		    !netlink_capable(sock, NL_NONROOT_SEND))
 			goto out;
 	} else {
 		dst_pid =3D nlk->dst_pid;
@@ -2103,6 +2104,7 @@ static void __init netlink_add_usersock_entry(void)
 	rcu_assign_pointer(nl_table[NETLINK_USERSOCK].listeners, listeners);
 	nl_table[NETLINK_USERSOCK].module =3D THIS_MODULE;
 	nl_table[NETLINK_USERSOCK].registered =3D 1;
+	nl_table[NETLINK_USERSOCK].nl_nonroot =3D NL_NONROOT_SEND;
=20
 	netlink_table_ungrab();
 }
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d9d4970..85afc13 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1281,6 +1281,14 @@ static void __fanout_unlink(struct sock *sk, struct =
packet_sock *po)
 	spin_unlock(&f->lock);
 }
=20
+bool match_fanout_group(struct packet_type *ptype, struct sock * sk)
+{
+	if (ptype->af_packet_priv =3D=3D (void*)((struct packet_sock *)sk)->fanou=
t)
+		return true;
+
+	return false;
+}
+
 static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 {
 	struct packet_sock *po =3D pkt_sk(sk);
@@ -1333,6 +1341,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 ty=
pe_flags)
 		match->prot_hook.dev =3D po->prot_hook.dev;
 		match->prot_hook.func =3D packet_rcv_fanout;
 		match->prot_hook.af_packet_priv =3D match;
+		match->prot_hook.id_match =3D match_fanout_group;
 		dev_add_pack(&match->prot_hook);
 		list_add(&match->list, &fanout_list);
 	}
@@ -1931,7 +1940,6 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
=20
 	if (likely(po->tx_ring.pg_vec)) {
 		ph =3D skb_shinfo(skb)->destructor_arg;
-		BUG_ON(__packet_get_status(po, ph) !=3D TP_STATUS_SENDING);
 		BUG_ON(atomic_read(&po->tx_ring.pending) =3D=3D 0);
 		atomic_dec(&po->tx_ring.pending);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE);
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index b77f5a0..bdacd8d 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -67,6 +67,9 @@ static int tcf_gact_init(struct nlattr *nla, struct nlatt=
r *est,
 	struct tcf_common *pc;
 	int ret =3D 0;
 	int err;
+#ifdef CONFIG_GACT_PROB
+	struct tc_gact_p *p_parm =3D NULL;
+#endif
=20
 	if (nla =3D=3D NULL)
 		return -EINVAL;
@@ -82,6 +85,12 @@ static int tcf_gact_init(struct nlattr *nla, struct nlat=
tr *est,
 #ifndef CONFIG_GACT_PROB
 	if (tb[TCA_GACT_PROB] !=3D NULL)
 		return -EOPNOTSUPP;
+#else
+	if (tb[TCA_GACT_PROB]) {
+		p_parm =3D nla_data(tb[TCA_GACT_PROB]);
+		if (p_parm->ptype >=3D MAX_RAND)
+			return -EINVAL;
+	}
 #endif
=20
 	pc =3D tcf_hash_check(parm->index, a, bind, &gact_hash_info);
@@ -103,8 +112,7 @@ static int tcf_gact_init(struct nlattr *nla, struct nla=
ttr *est,
 	spin_lock_bh(&gact->tcf_lock);
 	gact->tcf_action =3D parm->action;
 #ifdef CONFIG_GACT_PROB
-	if (tb[TCA_GACT_PROB] !=3D NULL) {
-		struct tc_gact_p *p_parm =3D nla_data(tb[TCA_GACT_PROB]);
+	if (p_parm) {
 		gact->tcfg_paction =3D p_parm->paction;
 		gact->tcfg_pval    =3D p_parm->pval;
 		gact->tcfg_ptype   =3D p_parm->ptype;
@@ -133,7 +141,7 @@ static int tcf_gact(struct sk_buff *skb, const struct t=
c_action *a,
=20
 	spin_lock(&gact->tcf_lock);
 #ifdef CONFIG_GACT_PROB
-	if (gact->tcfg_ptype && gact_rand[gact->tcfg_ptype] !=3D NULL)
+	if (gact->tcfg_ptype)
 		action =3D gact_rand[gact->tcfg_ptype](gact);
 	else
 		action =3D gact->tcf_action;
diff --git a/net/socket.c b/net/socket.c
index 273cbce..68879db 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2645,6 +2645,7 @@ static int dev_ifconf(struct net *net, struct compat_=
ifconf __user *uifc32)
 	if (copy_from_user(&ifc32, uifc32, sizeof(struct compat_ifconf)))
 		return -EFAULT;
=20
+	memset(&ifc, 0, sizeof(ifc));
 	if (ifc32.ifcbuf =3D=3D 0) {
 		ifc32.ifc_len =3D 0;
 		ifc.ifc_len =3D 0;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 3ac9789..ffba207 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -962,11 +962,11 @@ static bool xprt_dynamic_free_slot(struct rpc_xprt *x=
prt, struct rpc_rqst *req)
 	return false;
 }
=20
-static void xprt_alloc_slot(struct rpc_task *task)
+void xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 {
-	struct rpc_xprt	*xprt =3D task->tk_xprt;
 	struct rpc_rqst *req;
=20
+	spin_lock(&xprt->reserve_lock);
 	if (!list_empty(&xprt->free)) {
 		req =3D list_entry(xprt->free.next, struct rpc_rqst, rq_list);
 		list_del(&req->rq_list);
@@ -987,12 +987,29 @@ static void xprt_alloc_slot(struct rpc_task *task)
 	default:
 		task->tk_status =3D -EAGAIN;
 	}
+	spin_unlock(&xprt->reserve_lock);
 	return;
 out_init_req:
 	task->tk_status =3D 0;
 	task->tk_rqstp =3D req;
 	xprt_request_init(task, xprt);
+	spin_unlock(&xprt->reserve_lock);
+}
+EXPORT_SYMBOL_GPL(xprt_alloc_slot);
+
+void xprt_lock_and_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task=
)
+{
+	/* Note: grabbing the xprt_lock_write() ensures that we throttle
+	 * new slot allocation if the transport is congested (i.e. when
+	 * reconnecting a stream transport or when out of socket write
+	 * buffer space).
+	 */
+	if (xprt_lock_write(xprt, task)) {
+		xprt_alloc_slot(xprt, task);
+		xprt_release_write(xprt, task);
+	}
 }
+EXPORT_SYMBOL_GPL(xprt_lock_and_alloc_slot);
=20
 static void xprt_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
 {
@@ -1076,20 +1093,9 @@ void xprt_reserve(struct rpc_task *task)
 	if (task->tk_rqstp !=3D NULL)
 		return;
=20
-	/* Note: grabbing the xprt_lock_write() here is not strictly needed,
-	 * but ensures that we throttle new slot allocation if the transport
-	 * is congested (e.g. if reconnecting or if we're out of socket
-	 * write buffer space).
-	 */
 	task->tk_timeout =3D 0;
 	task->tk_status =3D -EAGAIN;
-	if (!xprt_lock_write(xprt, task))
-		return;
-
-	spin_lock(&xprt->reserve_lock);
-	xprt_alloc_slot(task);
-	spin_unlock(&xprt->reserve_lock);
-	xprt_release_write(xprt, task);
+	xprt->ops->alloc_slot(xprt, task);
 }
=20
 static inline __be32 xprt_alloc_xid(struct rpc_xprt *xprt)
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transpor=
t.c
index 06cdbff..5d9202d 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -713,6 +713,7 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt=
, struct seq_file *seq)
 static struct rpc_xprt_ops xprt_rdma_procs =3D {
 	.reserve_xprt		=3D xprt_rdma_reserve_xprt,
 	.release_xprt		=3D xprt_release_xprt_cong, /* sunrpc/xprt.c */
+	.alloc_slot		=3D xprt_alloc_slot,
 	.release_request	=3D xprt_release_rqst_cong,       /* ditto */
 	.set_retrans_timeout	=3D xprt_set_retrans_timeout_def, /* ditto */
 	.rpcbind		=3D rpcb_getport_async,	/* sunrpc/rpcb_clnt.c */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 1a6edc7..c5391af 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2422,6 +2422,7 @@ static void bc_destroy(struct rpc_xprt *xprt)
 static struct rpc_xprt_ops xs_local_ops =3D {
 	.reserve_xprt		=3D xprt_reserve_xprt,
 	.release_xprt		=3D xs_tcp_release_xprt,
+	.alloc_slot		=3D xprt_alloc_slot,
 	.rpcbind		=3D xs_local_rpcbind,
 	.set_port		=3D xs_local_set_port,
 	.connect		=3D xs_connect,
@@ -2438,6 +2439,7 @@ static struct rpc_xprt_ops xs_udp_ops =3D {
 	.set_buffer_size	=3D xs_udp_set_buffer_size,
 	.reserve_xprt		=3D xprt_reserve_xprt_cong,
 	.release_xprt		=3D xprt_release_xprt_cong,
+	.alloc_slot		=3D xprt_alloc_slot,
 	.rpcbind		=3D rpcb_getport_async,
 	.set_port		=3D xs_set_port,
 	.connect		=3D xs_connect,
@@ -2455,6 +2457,7 @@ static struct rpc_xprt_ops xs_udp_ops =3D {
 static struct rpc_xprt_ops xs_tcp_ops =3D {
 	.reserve_xprt		=3D xprt_reserve_xprt,
 	.release_xprt		=3D xs_tcp_release_xprt,
+	.alloc_slot		=3D xprt_lock_and_alloc_slot,
 	.rpcbind		=3D rpcb_getport_async,
 	.set_port		=3D xs_set_port,
 	.connect		=3D xs_connect,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d99678a..317bfe3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1435,7 +1435,7 @@ static int unix_dgram_sendmsg(struct kiocb *kiocb, st=
ruct socket *sock,
 	if (NULL =3D=3D siocb->scm)
 		siocb->scm =3D &tmp_scm;
 	wait_for_unix_gc();
-	err =3D scm_send(sock, msg, siocb->scm);
+	err =3D scm_send(sock, msg, siocb->scm, false);
 	if (err < 0)
 		return err;
=20
@@ -1596,7 +1596,7 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, s=
truct socket *sock,
 	if (NULL =3D=3D siocb->scm)
 		siocb->scm =3D &tmp_scm;
 	wait_for_unix_gc();
-	err =3D scm_send(sock, msg, siocb->scm);
+	err =3D scm_send(sock, msg, siocb->scm, false);
 	if (err < 0)
 		return err;
=20
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f3be54e..b0187e7 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2312,6 +2312,7 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 	}
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
+	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	codec->proc_widget_hook =3D NULL;
 	codec->spec =3D NULL;
 	free_hda_cache(&codec->amp_cache);
@@ -2324,7 +2325,6 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 	codec->num_pcms =3D 0;
 	codec->pcm_info =3D NULL;
 	codec->preset =3D NULL;
-	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	codec->slave_dig_outs =3D NULL;
 	codec->spdif_status_reset =3D 0;
 	module_put(codec->owner);
diff --git a/sound/pci/ice1712/prodigy_hifi.c b/sound/pci/ice1712/prodigy_h=
ifi.c
index 764cc93..075d5aa 100644
--- a/sound/pci/ice1712/prodigy_hifi.c
+++ b/sound/pci/ice1712/prodigy_hifi.c
@@ -297,6 +297,7 @@ static int ak4396_dac_vol_put(struct snd_kcontrol *kcon=
trol, struct snd_ctl_elem
 }
=20
 static const DECLARE_TLV_DB_SCALE(db_scale_wm_dac, -12700, 100, 1);
+static const DECLARE_TLV_DB_LINEAR(ak4396_db_scale, TLV_DB_GAIN_MUTE, 0);
=20
 static struct snd_kcontrol_new prodigy_hd2_controls[] __devinitdata =3D {
     {
@@ -307,7 +308,7 @@ static struct snd_kcontrol_new prodigy_hd2_controls[] _=
_devinitdata =3D {
 	.info =3D ak4396_dac_vol_info,
 	.get =3D ak4396_dac_vol_get,
 	.put =3D ak4396_dac_vol_put,
-	.tlv =3D { .p =3D db_scale_wm_dac },
+	.tlv =3D { .p =3D ak4396_db_scale },
     },
 };
=20



--=-iH3FQUanuVeOTBxRWJXU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFpxpue/yOyVhhEJAQoptg//ftGHY/lyOeKdwNh1QbcoD7wAHBn/6PzS
qA+yz21suL/nCZzIZr6mYbph0v4aYGoz/0ZBRomyCFaaBZ2kHXZAK2U+4qgTkTKz
L0DR+Vi9NuftPMvAdRb0HqKfonUjUmX1dIu3EZr3gW6EwQ1+mL0L5nw0FHcDlUdZ
/omZeotQi485iLkjmIlPRXWHkys+RFUXDDzaVx6nLMmGYKtvoJeokDCGuoZblPVn
6LVeGGMqWPxN01T8AL3omfLgPkZSMk/zL/HfbojNTkhya6W/Yum09eev+jfg60iu
BUYJRPVySFUhrkMTaTDc0d6SFhtLDSt+kaW9EbDLAzHBM1e1D4b2V1Ovlgg+IDmW
dQgs5vIQhNpj8/OjJQfi/4o3w6FBc6N+PqRQHQDBgk+M1x2VCeMGGbwDarAyOXEn
UKp2ANV6uHsg2jF/eSrXz/Ggpmk6Sfuu+y4IlCDk4sHxEuseUZ/kzIu61KgLx4o4
KjLjF+6ADCl4RTT2w3d1kqglJogesRh6OyS/l+3pqRWaZUa5dXMwXBb9ExB9B6Hc
p4WgRJ7FIWcIc54+Ib7Fr8tAZNQ77J0MP0oEzQJ7WEykrBHLZOIrb9rMHAfHC1MR
EBqLAjkrYnYnAX7PAULSfS4DF0zJqY3LQ/J7F7MLIodU3Q5aeNYvnjC8tu2qXuBo
qe2nGGraFqM=
=o2lE
-----END PGP SIGNATURE-----

--=-iH3FQUanuVeOTBxRWJXU--
