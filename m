Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1D0PGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:06:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:60462 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1D0PGM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:06:12 -0400
Message-Id: <4DB84D4C020000780003E675@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:07:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: avoid pointless fields of struct cpuinfo_x86
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the flag fields of this structure are completely unused in
certain (common) configurations. Don't pointlessly reserve space for
them, and have truly flag-only fields consume a single bit only.

Make functionality detection conditional upon (partly new) config
options that are now also used to control the presence of those
fields.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig.cpu             |   16 +++++++++-
 arch/x86/include/asm/processor.h |   58 ++++++++++++++++++++++++++++-----------
 arch/x86/kernel/asm-offsets_32.c |    2 +
 arch/x86/kernel/cpu/bugs.c       |   26 ++++++++++++-----
 arch/x86/kernel/cpu/cyrix.c      |    2 -
 arch/x86/kernel/cpu/proc.c       |   47 ++++++++++++++++---------------
 arch/x86/kernel/head_32.S        |    2 +
 arch/x86/kernel/i387.c           |    2 -
 arch/x86/kernel/irqinit.c        |    4 +-
 arch/x86/kernel/process.c        |    4 +-
 arch/x86/kernel/setup.c          |   24 ++++++++++++++--
 arch/x86/lguest/boot.c           |    4 ++
 arch/x86/lib/usercopy_32.c       |    2 -
 arch/x86/mm/init_32.c            |    9 ++++--
 arch/x86/xen/enlighten.c         |    6 ++--
 arch/x86/xen/setup.c             |    4 +-
 16 files changed, 148 insertions(+), 64 deletions(-)

--- 2.6.39-rc5/arch/x86/Kconfig.cpu
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/Kconfig.cpu
@@ -302,6 +302,10 @@ config X86_INTERNODE_CACHE_SHIFT
 	default "7" if NUMA
 	default X86_L1_CACHE_SHIFT
 
+config X86_FPU
+	def_bool y
+	depends on !M386 && !M486 && !MATH_EMULATION
+
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
 
@@ -334,11 +338,19 @@ config X86_PPRO_FENCE
 
 config X86_F00F_BUG
 	def_bool y
-	depends on M586MMX || M586TSC || M586 || M486 || M386
+	depends on CPU_SUP_INTEL && (M586MMX || M586TSC || M586 || M486 || M386)
+
+config X86_FDIV_BUG
+	def_bool y
+	depends on CPU_SUP_INTEL && (M586TSC || M586 || M486 || M386)
 
 config X86_INVD_BUG
 	def_bool y
-	depends on M486 || M386
+	depends on CPU_SUP_AMD && (M486 || M386)
+
+config X86_HLT_WORKS_OK
+	def_bool y
+	depends on !M386 && !M486
 
 config X86_WP_WORKS_OK
 	def_bool y
--- 2.6.39-rc5/arch/x86/include/asm/processor.h
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/include/asm/processor.h
@@ -63,18 +63,26 @@ struct cpuinfo_x86 {
 	__u8			x86_vendor;	/* CPU vendor */
 	__u8			x86_model;
 	__u8			x86_mask;
-#ifdef CONFIG_X86_32
-	char			wp_works_ok;	/* It doesn't on 386's */
-
+#ifndef CONFIG_X86_FPU
+	bool			hard_math;
+#endif
+#ifndef CONFIG_X86_WP_WORKS_OK
+	bool			wp_works_ok:1;	/* It doesn't on 386's */
+#endif
+#ifndef CONFIG_X86_HLT_WORKS_OK
 	/* Problems on some 486Dx4's and old 386's: */
-	char			hlt_works_ok;
-	char			hard_math;
-	char			rfu;
-	char			fdiv_bug;
-	char			f00f_bug;
-	char			coma_bug;
-	char			pad0;
-#else
+	bool			hlt_works_ok:1;
+#endif
+#ifdef CONFIG_X86_FDIV_BUG
+	bool			fdiv_bug:1;
+#endif
+#ifdef CONFIG_X86_F00F_BUG
+	bool			f00f_bug:1;
+#endif
+#ifdef CONFIG_CPU_SUP_CYRIX_32
+	bool			coma_bug:1;
+#endif
+#ifdef CONFIG_X86_64
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			x86_tlbsize;
 #endif
@@ -144,12 +152,32 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct cp
 
 extern const struct seq_operations cpuinfo_op;
 
-static inline int hlt_works(int cpu)
+static inline bool hard_math(const struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_32
-	return cpu_data(cpu).hlt_works_ok;
+#ifndef CONFIG_X86_FPU
+	return c->hard_math;
+#else
+	return true;
+#endif
+}
+
+extern bool wp_works_ok; /* set to true to skip check */
+
+static inline bool wp_works(const struct cpuinfo_x86 *c)
+{
+#ifndef CONFIG_X86_WP_WORKS_OK
+	return c->wp_works_ok;
+#else
+	return true;
+#endif
+}
+
+static inline bool hlt_works(const struct cpuinfo_x86 *c)
+{
+#ifndef CONFIG_X86_HLT_WORKS_OK
+	return c->hlt_works_ok;
 #else
-	return 1;
+	return true;
 #endif
 }
 
--- 2.6.39-rc5/arch/x86/kernel/asm-offsets_32.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/asm-offsets_32.c
@@ -23,7 +23,9 @@ void foo(void)
 	OFFSET(CPUINFO_x86_vendor, cpuinfo_x86, x86_vendor);
 	OFFSET(CPUINFO_x86_model, cpuinfo_x86, x86_model);
 	OFFSET(CPUINFO_x86_mask, cpuinfo_x86, x86_mask);
+#ifndef CONFIG_X86_FPU
 	OFFSET(CPUINFO_hard_math, cpuinfo_x86, hard_math);
+#endif
 	OFFSET(CPUINFO_cpuid_level, cpuinfo_x86, cpuid_level);
 	OFFSET(CPUINFO_x86_capability, cpuinfo_x86, x86_capability);
 	OFFSET(CPUINFO_x86_vendor_id, cpuinfo_x86, x86_vendor_id);
--- 2.6.39-rc5/arch/x86/kernel/cpu/bugs.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/cpu/bugs.c
@@ -17,25 +17,24 @@
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
 
+#ifndef CONFIG_X86_HLT_WORKS_OK
 static int __init no_halt(char *s)
 {
 	boot_cpu_data.hlt_works_ok = 0;
 	return 1;
 }
-
 __setup("no-hlt", no_halt);
+#endif
 
+#ifndef CONFIG_X86_FPU
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
 	write_cr0(X86_CR0_TS | X86_CR0_EM | X86_CR0_MP | read_cr0());
 	return 1;
 }
-
 __setup("no387", no_387);
-
-static double __initdata x = 4195835.0;
-static double __initdata y = 3145727.0;
+#endif
 
 /*
  * This used to check for exceptions..
@@ -50,8 +49,10 @@ static double __initdata y = 3145727.0;
  */
 static void __init check_fpu(void)
 {
-	s32 fdiv_bug;
-
+#ifdef CONFIG_X86_FPU
+	if (!cpu_has_fpu)
+		panic("No coprocessor found.\n");
+#else
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
@@ -60,6 +61,13 @@ static void __init check_fpu(void)
 #endif
 		return;
 	}
+#endif
+
+#ifdef CONFIG_X86_FDIV_BUG
+    {
+	s32 fdiv_bug;
+	static const double __initconst x = 4195835.0;
+	static const double __initconst y = 3145727.0;
 
 	/*
 	 * trap_init() enabled FXSR and company _before_ testing for FP
@@ -82,10 +90,13 @@ static void __init check_fpu(void)
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk(KERN_WARNING "Hmm, FPU with FDIV bug.\n");
+    }
+#endif
 }
 
 static void __init check_hlt(void)
 {
+#ifndef CONFIG_X86_HLT_WORKS_OK
 	if (boot_cpu_data.x86 >= 5 || paravirt_enabled())
 		return;
 
@@ -99,6 +110,7 @@ static void __init check_hlt(void)
 	halt();
 	halt();
 	printk(KERN_CONT "OK.\n");
+#endif
 }
 
 /*
--- 2.6.39-rc5/arch/x86/kernel/cpu/cyrix.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/cpu/cyrix.c
@@ -332,7 +332,7 @@ static void __cpuinit init_cyrix(struct 
 		switch (dir0_lsn) {
 		case 0xd:  /* either a 486SLC or DLC w/o DEVID */
 			dir0_msn = 0;
-			p = Cx486_name[(c->hard_math) ? 1 : 0];
+			p = Cx486_name[hard_math(c)];
 			break;
 
 		case 0xe:  /* a 486S A step */
--- 2.6.39-rc5/arch/x86/kernel/cpu/proc.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/cpu/proc.c
@@ -23,43 +23,44 @@ static void show_cpuinfo_core(struct seq
 #endif
 }
 
-#ifdef CONFIG_X86_32
 static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 	/*
 	 * We use exception 16 if we have hardware math and we've either seen
 	 * it or the CPU claims it is internal
 	 */
-	int fpu_exception = c->hard_math && (ignore_fpu_irq || cpu_has_fpu);
+	bool fpu_exception = hard_math(c) && (ignore_fpu_irq || cpu_has_fpu);
+#else
+	bool fpu_exception = true;
+#endif
+
+#ifdef CONFIG_X86_FDIV_BUG
+	seq_printf(m, "fdiv_bug\t: %s\n", c->fdiv_bug ? "yes" : "no");
+#endif
+
+#ifndef CONFIG_X86_HLT_WORKS_OK
+	seq_printf(m, "hlt_bug\t\t: %s\n", c->hlt_works_ok ? "no" : "yes");
+#endif
+
+#ifdef CONFIG_X86_F00F_BUG
+	seq_printf(m, "f00f_bug\t: %s\n", c->f00f_bug ? "yes" : "no");
+#endif
+
+#ifdef CONFIG_CPU_SUP_CYRIX_32
+	seq_printf(m, "coma_bug\t: %s\n", c->coma_bug ? "yes" : "no");
+#endif
+
 	seq_printf(m,
-		   "fdiv_bug\t: %s\n"
-		   "hlt_bug\t\t: %s\n"
-		   "f00f_bug\t: %s\n"
-		   "coma_bug\t: %s\n"
 		   "fpu\t\t: %s\n"
 		   "fpu_exception\t: %s\n"
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
-		   c->fdiv_bug ? "yes" : "no",
-		   c->hlt_works_ok ? "no" : "yes",
-		   c->f00f_bug ? "yes" : "no",
-		   c->coma_bug ? "yes" : "no",
-		   c->hard_math ? "yes" : "no",
+		   hard_math(c) ? "yes" : "no",
 		   fpu_exception ? "yes" : "no",
 		   c->cpuid_level,
-		   c->wp_works_ok ? "yes" : "no");
-}
-#else
-static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
-{
-	seq_printf(m,
-		   "fpu\t\t: yes\n"
-		   "fpu_exception\t: yes\n"
-		   "cpuid level\t: %d\n"
-		   "wp\t\t: yes\n",
-		   c->cpuid_level);
+		   wp_works(c) ? "yes" : "no");
 }
-#endif
 
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
--- 2.6.39-rc5/arch/x86/kernel/head_32.S
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/head_32.S
@@ -480,6 +480,7 @@ is386:	movl $2,%ecx		# set MP
  * We depend on ET to be correct. This checks for 287/387.
  */
 check_x87:
+#ifndef CONFIG_X86_FPU
 	movb $0,X86_HARD_MATH
 	clts
 	fninit
@@ -493,6 +494,7 @@ check_x87:
 	ALIGN
 1:	movb $1,X86_HARD_MATH
 	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
+#endif
 	ret
 
 /*
--- 2.6.39-rc5/arch/x86/kernel/i387.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/i387.c
@@ -33,7 +33,7 @@
 #endif
 
 #ifdef CONFIG_MATH_EMULATION
-# define HAVE_HWFP		(boot_cpu_data.hard_math)
+# define HAVE_HWFP		hard_math(&boot_cpu_data)
 #else
 # define HAVE_HWFP		1
 #endif
--- 2.6.39-rc5/arch/x86/kernel/irqinit.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/irqinit.c
@@ -59,7 +59,7 @@
 static irqreturn_t math_error_irq(int cpl, void *dev_id)
 {
 	outb(0, 0xF0);
-	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
+	if (ignore_fpu_irq || !hard_math(&boot_cpu_data))
 		return IRQ_NONE;
 	math_error(get_irq_regs(), 0, 16);
 	return IRQ_HANDLED;
@@ -323,7 +323,7 @@ void __init native_init_IRQ(void)
 	 * External FPU? Set up irq13 if so, for
 	 * original braindamaged IBM FERR coupling.
 	 */
-	if (boot_cpu_data.hard_math && !cpu_has_fpu)
+	if (hard_math(&boot_cpu_data) && !cpu_has_fpu)
 		setup_irq(FPU_IRQ, &fpu_irq);
 
 	irq_ctx_init(smp_processor_id());
--- 2.6.39-rc5/arch/x86/kernel/process.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/process.c
@@ -359,7 +359,7 @@ EXPORT_SYMBOL(enable_hlt);
 
 static inline int hlt_use_halt(void)
 {
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
+	return (!hlt_counter && hlt_works(&boot_cpu_data));
 }
 #else
 static inline int hlt_use_halt(void)
@@ -411,7 +411,7 @@ void stop_this_cpu(void *dummy)
 	disable_local_APIC();
 
 	for (;;) {
-		if (hlt_works(smp_processor_id()))
+		if (hlt_works(&cpu_data(smp_processor_id())))
 			halt();
 	}
 }
--- 2.6.39-rc5/arch/x86/kernel/setup.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/kernel/setup.c
@@ -176,9 +176,29 @@ static struct resource bss_resource = {
 
 #ifdef CONFIG_X86_32
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 new_cpu_data __cpuinitdata = {
+# ifndef CONFIG_X86_WP_WORKS_OK
+	.wp_works_ok = true,
+# endif
+# ifndef CONFIG_X86_HLT_WORKS_OK
+	.hlt_works_ok = true,
+# endif
+# ifdef CONFIG_X86_FDIV_BUG
+	.fdiv_bug = true,
+# endif
+};
 /* common cpu data for all cpus */
-struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 boot_cpu_data __read_mostly = {
+# ifndef CONFIG_X86_WP_WORKS_OK
+	.wp_works_ok = true,
+# endif
+# ifndef CONFIG_X86_HLT_WORKS_OK
+	.hlt_works_ok = true,
+# endif
+# ifdef CONFIG_X86_FDIV_BUG
+	.fdiv_bug = true,
+# endif
+};
 EXPORT_SYMBOL(boot_cpu_data);
 static void set_mca_bus(int x)
 {
--- 2.6.39-rc5/arch/x86/lguest/boot.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/lguest/boot.c
@@ -1384,8 +1384,10 @@ __init void lguest_init(void)
 	/* head.S usually sets up the first capability word, so do it here. */
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
+#ifndef CONFIG_X86_FPU
 	/* Math is always hard! */
-	new_cpu_data.hard_math = 1;
+	new_cpu_data.hard_math = true;
+#endif
 
 	/* We don't have features.  We have puppies!  Puppies! */
 #ifdef CONFIG_X86_MCE
--- 2.6.39-rc5/arch/x86/lib/usercopy_32.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/lib/usercopy_32.c
@@ -718,7 +718,7 @@ unsigned long __copy_to_user_ll(void __u
 				unsigned long n)
 {
 #ifndef CONFIG_X86_WP_WORKS_OK
-	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
+	if (unlikely(!wp_works(&boot_cpu_data)) &&
 			((unsigned long)to) < TASK_SIZE) {
 		/*
 		 * When we are in an atomic section (see
--- 2.6.39-rc5/arch/x86/mm/init_32.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/mm/init_32.c
@@ -56,6 +56,7 @@
 
 unsigned long highstart_pfn, highend_pfn;
 
+bool __initdata wp_works_ok;
 static noinline int do_test_wp_bit(void);
 
 bool __read_mostly __vmalloc_start_set = false;
@@ -733,14 +734,16 @@ static void __init test_wp_bit(void)
 
 	/* Any page-aligned address will do, the test is non-destructive */
 	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
-	boot_cpu_data.wp_works_ok = do_test_wp_bit();
+	wp_works_ok = do_test_wp_bit();
 	clear_fixmap(FIX_WP_TEST);
 
-	if (!boot_cpu_data.wp_works_ok) {
+	if (!wp_works_ok) {
 		printk(KERN_CONT "No.\n");
 #ifdef CONFIG_X86_WP_WORKS_OK
 		panic(
   "This kernel doesn't support CPU's with broken WP. Recompile it for a 386!");
+#else
+		boot_cpu_data.wp_works_ok = false;
 #endif
 	} else {
 		printk(KERN_CONT "Ok.\n");
@@ -839,7 +842,7 @@ void __init mem_init(void)
 	BUG_ON(VMALLOC_START				>= VMALLOC_END);
 	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
 
-	if (boot_cpu_data.wp_works_ok < 0)
+	if (!wp_works_ok)
 		test_wp_bit();
 }
 
--- 2.6.39-rc5/arch/x86/xen/enlighten.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/xen/enlighten.c
@@ -1222,8 +1222,10 @@ asmlinkage void __init xen_start_kernel(
 #ifdef CONFIG_X86_32
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
-	new_cpu_data.hard_math = 1;
-	new_cpu_data.wp_works_ok = 1;
+# ifndef CONFIG_X86_FPU
+	new_cpu_data.hard_math = true;
+# endif
+	wp_works_ok = true;
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
 
--- 2.6.39-rc5/arch/x86/xen/setup.c
+++ 2.6.39-rc5-i386-cpuinfo-pack/arch/x86/xen/setup.c
@@ -417,8 +417,8 @@ void __init xen_arch_setup(void)
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
 	/* Set up idle, making sure it calls safe_halt() pvop */
-#ifdef CONFIG_X86_32
-	boot_cpu_data.hlt_works_ok = 1;
+#ifndef CONFIG_X86_HLT_WORKS_OK
+	boot_cpu_data.hlt_works_ok = true;
 #endif
 	pm_idle = default_idle;
 	boot_option_idle_override = IDLE_HALT;


