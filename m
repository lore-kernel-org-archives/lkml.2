Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1CUUmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:42:45 -0400
Received: from kroah.org ([198.145.64.141]:32813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1CUUma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:42:30 -0400
Date: Mon, 21 Mar 2011 13:41:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.8
Message-ID: <20110321204117.GB2702@kroah.com>
References: <20110321204104.GA2702@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110321204104.GA2702@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..eebc1f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2032,6 +2032,12 @@ W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/eeepc-laptop.c
 
+EFIFB FRAMEBUFFER DRIVER
+L:	linux-fbdev@vger.kernel.org
+M:	Peter Jones <pjones@redhat.com>
+S:	Maintained
+F:	drivers/video/efifb.c
+
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
diff --git a/Makefile b/Makefile
index d06f130..2de8294 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .7
+EXTRAVERSION = .8
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 00f46d9..eea4947 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -215,7 +215,7 @@
 	@ Slightly optimised to avoid incrementing the pointer twice
 	usraccoff \instr, \reg, \ptr, \inc, 0, \cond, \abort
 	.if	\rept == 2
-	usraccoff \instr, \reg, \ptr, \inc, 4, \cond, \abort
+	usraccoff \instr, \reg, \ptr, \inc, \inc, \cond, \abort
 	.endif
 
 	add\cond \ptr, #\rept * \inc
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index e7714f3..962236a 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -389,7 +389,9 @@ setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	unsigned long handler = (unsigned long)ka->sa.sa_handler;
 	unsigned long retcode;
 	int thumb = 0;
-	unsigned long cpsr = regs->ARM_cpsr & ~PSR_f;
+	unsigned long cpsr = regs->ARM_cpsr & ~(PSR_f | PSR_E_BIT);
+
+	cpsr |= PSR_ENDSTATE;
 
 	/*
 	 * Maybe we need to deliver a 32-bit signal to a 26-bit task.
diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
index 1e4cbd4..64f6bc1 100644
--- a/arch/arm/lib/findbit.S
+++ b/arch/arm/lib/findbit.S
@@ -174,8 +174,8 @@ ENDPROC(_find_next_bit_be)
  */
 .L_found:
 #if __LINUX_ARM_ARCH__ >= 5
-		rsb	r1, r3, #0
-		and	r3, r3, r1
+		rsb	r0, r3, #0
+		and	r3, r3, r0
 		clz	r3, r3
 		rsb	r3, r3, #31
 		add	r0, r2, r3
@@ -190,5 +190,7 @@ ENDPROC(_find_next_bit_be)
 		addeq	r2, r2, #1
 		mov	r0, r2
 #endif
+		cmp	r1, r0			@ Clamp to maxbit
+		movlo	r0, r1
 		mov	pc, lr
 
diff --git a/arch/ia64/include/asm/compat.h b/arch/ia64/include/asm/compat.h
index dfcf75b..c8662cd 100644
--- a/arch/ia64/include/asm/compat.h
+++ b/arch/ia64/include/asm/compat.h
@@ -198,7 +198,7 @@ ptr_to_compat(void __user *uptr)
 }
 
 static __inline__ void __user *
-compat_alloc_user_space (long len)
+arch_compat_alloc_user_space (long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *) (((regs->r12 & 0xffffffff) & -16) - len);
diff --git a/arch/ia64/kernel/fsys.S b/arch/ia64/kernel/fsys.S
index 3567d54..331d42b 100644
--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -420,22 +420,31 @@ EX(.fail_efault, ld8 r14=[r33])			// r14 <- *set
 	;;
 
 	RSM_PSR_I(p0, r18, r19)			// mask interrupt delivery
-	mov ar.ccv=0
 	andcm r14=r14,r17			// filter out SIGKILL & SIGSTOP
+	mov r8=EINVAL			// default to EINVAL
 
 #ifdef CONFIG_SMP
-	mov r17=1
+	// __ticket_spin_trylock(r31)
+	ld4 r17=[r31]
 	;;
-	cmpxchg4.acq r18=[r31],r17,ar.ccv	// try to acquire the lock
-	mov r8=EINVAL			// default to EINVAL
+	mov.m ar.ccv=r17
+	extr.u r9=r17,17,15
+	adds r19=1,r17
+	extr.u r18=r17,0,15
+	;;
+	cmp.eq p6,p7=r9,r18
 	;;
+(p6)	cmpxchg4.acq r9=[r31],r19,ar.ccv
+(p6)	dep.z r20=r19,1,15		// next serving ticket for unlock
+(p7)	br.cond.spnt.many .lock_contention
+	;;
+	cmp4.eq p0,p7=r9,r17
+	adds r31=2,r31
+(p7)	br.cond.spnt.many .lock_contention
 	ld8 r3=[r2]			// re-read current->blocked now that we hold the lock
-	cmp4.ne p6,p0=r18,r0
-(p6)	br.cond.spnt.many .lock_contention
 	;;
 #else
 	ld8 r3=[r2]			// re-read current->blocked now that we hold the lock
-	mov r8=EINVAL			// default to EINVAL
 #endif
 	add r18=IA64_TASK_PENDING_OFFSET+IA64_SIGPENDING_SIGNAL_OFFSET,r16
 	add r19=IA64_TASK_SIGNAL_OFFSET,r16
@@ -490,7 +499,9 @@ EX(.fail_efault, ld8 r14=[r33])			// r14 <- *set
 (p6)	br.cond.spnt.few 1b			// yes -> retry
 
 #ifdef CONFIG_SMP
-	st4.rel [r31]=r0			// release the lock
+	// __ticket_spin_unlock(r31)
+	st2.rel [r31]=r20
+	mov r20=0					// i must not leak kernel bits...
 #endif
 	SSM_PSR_I(p0, p9, r31)
 	;;
@@ -512,7 +523,8 @@ EX(.fail_efault, (p15) st8 [r34]=r3)
 
 .sig_pending:
 #ifdef CONFIG_SMP
-	st4.rel [r31]=r0			// release the lock
+	// __ticket_spin_unlock(r31)
+	st2.rel [r31]=r20			// release the lock
 #endif
 	SSM_PSR_I(p0, p9, r17)
 	;;
diff --git a/arch/mips/alchemy/mtx-1/platform.c b/arch/mips/alchemy/mtx-1/platform.c
index e30e42a..956f946 100644
--- a/arch/mips/alchemy/mtx-1/platform.c
+++ b/arch/mips/alchemy/mtx-1/platform.c
@@ -28,6 +28,8 @@
 #include <linux/mtd/physmap.h>
 #include <mtd/mtd-abi.h>
 
+#include <asm/mach-au1x00/au1xxx_eth.h>
+
 static struct gpio_keys_button mtx1_gpio_button[] = {
 	{
 		.gpio = 207,
@@ -140,10 +142,17 @@ static struct __initdata platform_device * mtx1_devs[] = {
 	&mtx1_mtd,
 };
 
+static struct au1000_eth_platform_data mtx1_au1000_eth0_pdata = {
+	.phy_search_highest_addr	= 1,
+	.phy1_search_mac0 		= 1,
+};
+
 static int __init mtx1_register_devices(void)
 {
 	int rc;
 
+	au1xxx_override_eth_cfg(0, &mtx1_au1000_eth0_pdata);
+
 	rc = gpio_request(mtx1_gpio_button[0].gpio,
 					mtx1_gpio_button[0].desc);
 	if (rc < 0) {
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index f58aed3..27505bd 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -144,7 +144,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = (struct pt_regs *)
 		((unsigned long) current_thread_info() + THREAD_SIZE - 32) - 1;
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index 7f32611..7c77fa9 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -146,7 +146,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static __inline__ void __user *compat_alloc_user_space(long len)
+static __inline__ void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = &current->thread.regs;
 	return (void __user *)regs->gr[30];
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 4774c2f..8d0fff3 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -133,7 +133,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = current->thread.regs;
 	unsigned long usp = regs->gpr[1];
diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index f027581..f0d067c 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -281,6 +281,7 @@ long plpar_hcall_raw(unsigned long opcode, unsigned long *retbuf, ...);
  */
 #define PLPAR_HCALL9_BUFSIZE 9
 long plpar_hcall9(unsigned long opcode, unsigned long *retbuf, ...);
+long plpar_hcall9_raw(unsigned long opcode, unsigned long *retbuf, ...);
 
 /* For hcall instrumentation.  One structure per-hcall, per-CPU */
 struct hcall_stats {
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index bc8dd53..6f6bd54 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -860,6 +860,7 @@
 #define PV_970		0x0039
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
+#define PV_POWER7	0x003F
 #define PV_970FX	0x003C
 #define PV_630		0x0040
 #define PV_630p	0x0041
diff --git a/arch/powerpc/kernel/cpu_setup_6xx.S b/arch/powerpc/kernel/cpu_setup_6xx.S
index 55cba4a..f8cd9fb 100644
--- a/arch/powerpc/kernel/cpu_setup_6xx.S
+++ b/arch/powerpc/kernel/cpu_setup_6xx.S
@@ -18,7 +18,7 @@
 #include <asm/mmu.h>
 
 _GLOBAL(__setup_cpu_603)
-	mflr	r4
+	mflr	r5
 BEGIN_MMU_FTR_SECTION
 	li	r10,0
 	mtspr	SPRN_SPRG_603_LRU,r10		/* init SW LRU tracking */
@@ -27,60 +27,60 @@ BEGIN_FTR_SECTION
 	bl	__init_fpu_registers
 END_FTR_SECTION_IFCLR(CPU_FTR_FPU_UNAVAILABLE)
 	bl	setup_common_caches
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_604)
-	mflr	r4
+	mflr	r5
 	bl	setup_common_caches
 	bl	setup_604_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750cx)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	bl	setup_750cx
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750fx)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	bl	setup_750fx
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_7400)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_7400_workarounds
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_7410)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_7410_workarounds
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	li	r3,0
 	mtspr	SPRN_L2CR2,r3
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_745x)
-	mflr	r4
+	mflr	r5
 	bl	setup_common_caches
 	bl	setup_745x_specifics
-	mtlr	r4
+	mtlr	r5
 	blr
 
 /* Enable caches for 603's, 604, 750 & 7400 */
@@ -194,10 +194,10 @@ setup_750cx:
 	cror	4*cr0+eq,4*cr0+eq,4*cr1+eq
 	cror	4*cr0+eq,4*cr0+eq,4*cr2+eq
 	bnelr
-	lwz	r6,CPU_SPEC_FEATURES(r5)
+	lwz	r6,CPU_SPEC_FEATURES(r4)
 	li	r7,CPU_FTR_CAN_NAP
 	andc	r6,r6,r7
-	stw	r6,CPU_SPEC_FEATURES(r5)
+	stw	r6,CPU_SPEC_FEATURES(r4)
 	blr
 
 /* 750fx specific
@@ -225,12 +225,12 @@ BEGIN_FTR_SECTION
 	andis.	r11,r11,L3CR_L3E@h
 	beq	1f
 END_FTR_SECTION_IFSET(CPU_FTR_L3CR)
-	lwz	r6,CPU_SPEC_FEATURES(r5)
+	lwz	r6,CPU_SPEC_FEATURES(r4)
 	andi.	r0,r6,CPU_FTR_L3_DISABLE_NAP
 	beq	1f
 	li	r7,CPU_FTR_CAN_NAP
 	andc	r6,r6,r7
-	stw	r6,CPU_SPEC_FEATURES(r5)
+	stw	r6,CPU_SPEC_FEATURES(r4)
 1:
 	mfspr	r11,SPRN_HID0
 
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 6f4613d..cca7c8f 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -347,10 +347,12 @@ int crash_shutdown_unregister(crash_shutdown_t handler)
 EXPORT_SYMBOL(crash_shutdown_unregister);
 
 static unsigned long crash_shutdown_buf[JMP_BUF_LEN];
+static int crash_shutdown_cpu = -1;
 
 static int handle_fault(struct pt_regs *regs)
 {
-	longjmp(crash_shutdown_buf, 1);
+	if (crash_shutdown_cpu == smp_processor_id())
+		longjmp(crash_shutdown_buf, 1);
 	return 0;
 }
 
@@ -375,11 +377,14 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	for_each_irq(i) {
 		struct irq_desc *desc = irq_to_desc(i);
 
+		if (!desc || !desc->chip || !desc->chip->eoi)
+			continue;
+
 		if (desc->status & IRQ_INPROGRESS)
 			desc->chip->eoi(i);
 
 		if (!(desc->status & IRQ_DISABLED))
-			desc->chip->disable(i);
+			desc->chip->shutdown(i);
 	}
 
 	/*
@@ -388,6 +393,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	 */
 	old_handler = __debugger_fault_handler;
 	__debugger_fault_handler = handle_fault;
+	crash_shutdown_cpu = smp_processor_id();
 	for (i = 0; crash_shutdown_handles[i]; i++) {
 		if (setjmp(crash_shutdown_buf) == 0) {
 			/*
@@ -401,6 +407,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 			asm volatile("sync; isync");
 		}
 	}
+	crash_shutdown_cpu = -1;
 	__debugger_fault_handler = old_handler;
 
 	/*
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 040bd1d..1a8de63 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/init_task.h>
 #include <linux/errno.h>
+#include <linux/cpu.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -169,10 +170,34 @@ static void kexec_smp_down(void *arg)
 	/* NOTREACHED */
 }
 
+/*
+ * We need to make sure each present CPU is online.  The next kernel will scan
+ * the device tree and assume primary threads are online and query secondary
+ * threads via RTAS to online them if required.  If we don't online primary
+ * threads, they will be stuck.  However, we also online secondary threads as we
+ * may be using 'cede offline'.  In this case RTAS doesn't see the secondary
+ * threads as offline -- and again, these CPUs will be stuck.
+ *
+ * So, we online all CPUs that should be running, including secondary threads.
+ */
+static void wake_offline_cpus(void)
+{
+	int cpu = 0;
+
+	for_each_present_cpu(cpu) {
+		if (!cpu_online(cpu)) {
+			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",
+					cpu);
+			cpu_up(cpu);
+		}
+	}
+}
+
 static void kexec_prepare_cpus(void)
 {
 	int my_cpu, i, notified=-1;
 
+	wake_offline_cpus();
 	smp_call_function(kexec_smp_down, NULL, /* wait */0);
 	my_cpu = get_cpu();
 
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index a3c0a32..8291a3c 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1220,6 +1220,28 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 	return ip;
 }
 
+static bool pmc_overflow(unsigned long val)
+{
+	if ((int)val < 0)
+		return true;
+
+	/*
+	 * Events on POWER7 can roll back if a speculative event doesn't
+	 * eventually complete. Unfortunately in some rare cases they will
+	 * raise a performance monitor exception. We need to catch this to
+	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
+	 * cycles from overflow.
+	 *
+	 * We only do this if the first pass fails to find any overflowing
+	 * PMCs because a user might set a period of less than 256 and we
+	 * don't want to mistakenly reset them.
+	 */
+	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
+		return true;
+
+	return false;
+}
+
 /*
  * Performance monitor interrupt stuff
  */
@@ -1267,7 +1289,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 			if (is_limited_pmc(i + 1))
 				continue;
 			val = read_pmc(i + 1);
-			if ((int)val < 0)
+			if (pmc_overflow(val))
 				write_pmc(i + 1, 0);
 		}
 	}
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 8eff48e..3fee685 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -169,9 +169,11 @@ static int p970_marked_instr_event(u64 event)
 	switch (unit) {
 	case PM_VPU:
 		mask = 0x4c;		/* byte 0 bits 2,3,6 */
+		break;
 	case PM_LSU0:
 		/* byte 2 bits 0,2,3,4,6; all of byte 1 */
 		mask = 0x085dff00;
+		break;
 	case PM_LSU1L:
 		mask = 0x50 << 24;	/* byte 3 bits 4,6 */
 		break;
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 6568406..21e529e 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -427,9 +427,18 @@ void __init setup_system(void)
 	DBG(" <- setup_system()\n");
 }
 
+static u64 slb0_limit(void)
+{
+	if (cpu_has_feature(CPU_FTR_1T_SEGMENT)) {
+		return 1UL << SID_SHIFT_1T;
+	}
+	return 1UL << SID_SHIFT;
+}
+
 #ifdef CONFIG_IRQSTACKS
 static void __init irqstack_early_init(void)
 {
+	u64 limit = slb0_limit();
 	unsigned int i;
 
 	/*
@@ -439,10 +448,10 @@ static void __init irqstack_early_init(void)
 	for_each_possible_cpu(i) {
 		softirq_ctx[i] = (struct thread_info *)
 			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
 		hardirq_ctx[i] = (struct thread_info *)
 			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
 	}
 }
 #else
@@ -473,7 +482,7 @@ static void __init exc_lvl_early_init(void)
  */
 static void __init emergency_stack_init(void)
 {
-	unsigned long limit;
+	u64 limit;
 	unsigned int i;
 
 	/*
@@ -485,7 +494,7 @@ static void __init emergency_stack_init(void)
 	 * bringup, we need to get at them in real mode. This means they
 	 * must also be within the RMO region.
 	 */
-	limit = min(0x10000000ULL, lmb.rmo_size);
+	limit = min(slb0_limit(), lmb.rmo_size);
 
 	for_each_possible_cpu(i) {
 		unsigned long sp;
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index 383a5d0..48d2057 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -228,3 +228,41 @@ _GLOBAL(plpar_hcall9)
 	mtcrf	0xff,r0
 
 	blr				/* return r3 = status */
+
+/* See plpar_hcall_raw to see why this is needed */
+_GLOBAL(plpar_hcall9_raw)
+	HMT_MEDIUM
+
+	mfcr	r0
+	stw	r0,8(r1)
+
+	std     r4,STK_PARM(r4)(r1)     /* Save ret buffer */
+
+	mr	r4,r5
+	mr	r5,r6
+	mr	r6,r7
+	mr	r7,r8
+	mr	r8,r9
+	mr	r9,r10
+	ld	r10,STK_PARM(r11)(r1)	 /* put arg7 in R10 */
+	ld	r11,STK_PARM(r12)(r1)	 /* put arg8 in R11 */
+	ld	r12,STK_PARM(r13)(r1)    /* put arg9 in R12 */
+
+	HVSC				/* invoke the hypervisor */
+
+	mr	r0,r12
+	ld	r12,STK_PARM(r4)(r1)
+	std	r4,  0(r12)
+	std	r5,  8(r12)
+	std	r6, 16(r12)
+	std	r7, 24(r12)
+	std	r8, 32(r12)
+	std	r9, 40(r12)
+	std	r10,48(r12)
+	std	r11,56(r12)
+	std	r0, 64(r12)
+
+	lwz	r0,8(r1)
+	mtcrf	0xff,r0
+
+	blr				/* return r3 = status */
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 0707653..568b503 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -367,21 +367,28 @@ static void pSeries_lpar_hptab_clear(void)
 {
 	unsigned long size_bytes = 1UL << ppc64_pft_size;
 	unsigned long hpte_count = size_bytes >> 4;
-	unsigned long dummy1, dummy2, dword0;
+	struct {
+		unsigned long pteh;
+		unsigned long ptel;
+	} ptes[4];
 	long lpar_rc;
-	int i;
+	int i, j;
 
-	/* TODO: Use bulk call */
-	for (i = 0; i < hpte_count; i++) {
-		/* dont remove HPTEs with VRMA mappings */
-		lpar_rc = plpar_pte_remove_raw(H_ANDCOND, i, HPTE_V_1TB_SEG,
-						&dummy1, &dummy2);
-		if (lpar_rc == H_NOT_FOUND) {
-			lpar_rc = plpar_pte_read_raw(0, i, &dword0, &dummy1);
-			if (!lpar_rc && ((dword0 & HPTE_V_VRMA_MASK)
-				!= HPTE_V_VRMA_MASK))
-				/* Can be hpte for 1TB Seg. So remove it */
-				plpar_pte_remove_raw(0, i, 0, &dummy1, &dummy2);
+	/* Read in batches of 4,
+	 * invalidate only valid entries not in the VRMA
+	 * hpte_count will be a multiple of 4
+         */
+	for (i = 0; i < hpte_count; i += 4) {
+		lpar_rc = plpar_pte_read_4_raw(0, i, (void *)ptes);
+		if (lpar_rc != H_SUCCESS)
+			continue;
+		for (j = 0; j < 4; j++){
+			if ((ptes[j].pteh & HPTE_V_VRMA_MASK) ==
+				HPTE_V_VRMA_MASK)
+				continue;
+			if (ptes[j].pteh & HPTE_V_VALID)
+				plpar_pte_remove_raw(0, i + j, 0,
+					&(ptes[j].pteh), &(ptes[j].ptel));
 		}
 	}
 }
@@ -673,6 +680,13 @@ EXPORT_SYMBOL(arch_free_page);
 /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
 extern long hcall_tracepoint_refcount;
 
+/*
+ * Since the tracing code might execute hcalls we need to guard against
+ * recursion. One example of this are spinlocks calling H_YIELD on
+ * shared processor partitions.
+ */
+static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
+
 void hcall_tracepoint_regfunc(void)
 {
 	hcall_tracepoint_refcount++;
@@ -685,12 +699,42 @@ void hcall_tracepoint_unregfunc(void)
 
 void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 {
+	unsigned long flags;
+	unsigned int *depth;
+
+	local_irq_save(flags);
+
+	depth = &__get_cpu_var(hcall_trace_depth);
+
+	if (*depth)
+		goto out;
+
+	(*depth)++;
 	trace_hcall_entry(opcode, args);
+	(*depth)--;
+
+out:
+	local_irq_restore(flags);
 }
 
 void __trace_hcall_exit(long opcode, unsigned long retval,
 			unsigned long *retbuf)
 {
+	unsigned long flags;
+	unsigned int *depth;
+
+	local_irq_save(flags);
+
+	depth = &__get_cpu_var(hcall_trace_depth);
+
+	if (*depth)
+		goto out;
+
+	(*depth)++;
 	trace_hcall_exit(opcode, retval, retbuf);
+	(*depth)--;
+
+out:
+	local_irq_restore(flags);
 }
 #endif
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index e724ef8..5e4289b 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -191,6 +191,24 @@ static inline long plpar_pte_read_raw(unsigned long flags, unsigned long ptex,
 	return rc;
 }
 
+/*
+ * plpar_pte_read_4_raw can be called in real mode.
+ * ptes must be 8*sizeof(unsigned long)
+ */
+static inline long plpar_pte_read_4_raw(unsigned long flags, unsigned long ptex,
+					unsigned long *ptes)
+
+{
+	long rc;
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+
+	rc = plpar_hcall9_raw(H_READ, retbuf, flags | H_READ_4, ptex);
+
+	memcpy(ptes, retbuf, 8*sizeof(unsigned long));
+
+	return rc;
+}
+
 static inline long plpar_pte_protect(unsigned long flags, unsigned long ptex,
 		unsigned long avpn)
 {
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 757a83f..fa79af5 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -832,7 +832,6 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
 		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 01a0802..0c940d3 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -180,7 +180,7 @@ static inline int is_compat_task(void)
 
 #endif
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	unsigned long stack;
 
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index b427154..0262c28 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -150,11 +150,6 @@ extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
  */
 extern unsigned long thread_saved_pc(struct task_struct *t);
 
-/*
- * Print register of task into buffer. Used in fs/proc/array.c.
- */
-extern void task_show_regs(struct seq_file *m, struct task_struct *task);
-
 extern void show_code(struct pt_regs *regs);
 
 unsigned long get_wchan(struct task_struct *p);
diff --git a/arch/s390/include/asm/vdso.h b/arch/s390/include/asm/vdso.h
index 7bdd7c8..4a76d94 100644
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -7,7 +7,7 @@
 #define VDSO32_LBASE	0
 #define VDSO64_LBASE	0
 
-#define VDSO_VERSION_STRING	LINUX_2.6.26
+#define VDSO_VERSION_STRING	LINUX_2.6.29
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 6e7ad63..7dd1ca6 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -243,43 +243,6 @@ void show_regs(struct pt_regs *regs)
 	show_last_breaking_event(regs);
 }
 
-/* This is called from fs/proc/array.c */
-void task_show_regs(struct seq_file *m, struct task_struct *task)
-{
-	struct pt_regs *regs;
-
-	regs = task_pt_regs(task);
-	seq_printf(m, "task: %p, ksp: %p\n",
-		       task, (void *)task->thread.ksp);
-	seq_printf(m, "User PSW : %p %p\n",
-		       (void *) regs->psw.mask, (void *)regs->psw.addr);
-
-	seq_printf(m, "User GPRS: " FOURLONG,
-			  regs->gprs[0], regs->gprs[1],
-			  regs->gprs[2], regs->gprs[3]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[4], regs->gprs[5],
-			  regs->gprs[6], regs->gprs[7]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[8], regs->gprs[9],
-			  regs->gprs[10], regs->gprs[11]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[12], regs->gprs[13],
-			  regs->gprs[14], regs->gprs[15]);
-	seq_printf(m, "User ACRS: %08x %08x %08x %08x\n",
-			  task->thread.acrs[0], task->thread.acrs[1],
-			  task->thread.acrs[2], task->thread.acrs[3]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[4], task->thread.acrs[5],
-			  task->thread.acrs[6], task->thread.acrs[7]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[8], task->thread.acrs[9],
-			  task->thread.acrs[10], task->thread.acrs[11]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[12], task->thread.acrs[13],
-			  task->thread.acrs[14], task->thread.acrs[15]);
-}
-
 static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index b59a812..3930e28 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -19,6 +19,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rcupdate.h>
 #include <linux/posix-timers.h>
+#include <linux/cpu.h>
 
 #include <asm/s390_ext.h>
 #include <asm/timer.h>
@@ -562,6 +563,23 @@ void init_cpu_vtimer(void)
 	__ctl_set_bit(0,10);
 }
 
+static int __cpuinit s390_nohz_notify(struct notifier_block *self,
+				      unsigned long action, void *hcpu)
+{
+	struct s390_idle_data *idle;
+	long cpu = (long) hcpu;
+
+	idle = &per_cpu(s390_idle, cpu);
+	switch (action) {
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		idle->nohz_delay = 0;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 void __init vtime_init(void)
 {
 	/* request the cpu timer external interrupt */
@@ -570,5 +588,6 @@ void __init vtime_init(void)
 
 	/* Enable cpu timer interrupts on the boot cpu. */
 	init_cpu_vtimer();
+	cpu_notifier(s390_nohz_notify, 0);
 }
 
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 0e70625..612bb38 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -166,7 +166,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = current_thread_info()->kregs;
 	unsigned long usp = regs->u_regs[UREG_I6];
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 5ff5546..e1bab3e 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -161,6 +161,7 @@ struct ubd {
 	struct scatterlist sg[MAX_SG];
 	struct request *request;
 	int start_sg, end_sg;
+	sector_t rq_pos;
 };
 
 #define DEFAULT_COW { \
@@ -185,6 +186,7 @@ struct ubd {
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
+	.rq_pos =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -1222,7 +1224,6 @@ static void do_ubd_request(struct request_queue *q)
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	sector_t sector;
 	int n;
 
 	while(1){
@@ -1233,12 +1234,12 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 
 			dev->request = req;
+			dev->rq_pos = blk_rq_pos(req);
 			dev->start_sg = 0;
 			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
 		}
 
 		req = dev->request;
-		sector = blk_rq_pos(req);
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
@@ -1250,10 +1251,9 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 			prepare_request(req, io_req,
-					(unsigned long long)sector << 9,
+					(unsigned long long)dev->rq_pos << 9,
 					sg->offset, sg->length, sg_page(sg));
 
-			sector += sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
@@ -1266,6 +1266,7 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 
+			dev->rq_pos += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index e7a6cca..664f942 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -22,7 +22,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_TEXT_SECTION(0)
   . = ALIGN(PAGE_SIZE);
 
   .text      :
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index dec5678..6e3359d 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -60,7 +60,7 @@ static inline long long timeval_to_ns(const struct timeval *tv)
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
-	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
+	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 53147ad..d9438ba 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -50,7 +50,12 @@
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
 	 * We don't reload %eax because syscall_trace_enter() returned
-	 * the value it wants us to use in the table lookup.
+	 * the %rax value we should see.  Instead, we just truncate that
+	 * value to 32 bits again as we did on entry from user mode.
+	 * If it's a new value set by user_regset during entry tracing,
+	 * this matches the normal truncation of the user-mode value.
+	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
+	 * an appropriately invalid value.
 	 */
 	.macro LOAD_ARGS32 offset, _r9=0
 	.if \_r9
@@ -60,6 +65,7 @@
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
 	movl \offset+64(%rsp),%edi
+	movl %eax,%eax			/* zero extension */
 	.endm
 	
 	.macro CFI_STARTPROC32 simple
@@ -153,7 +159,7 @@ ENTRY(ia32_sysenter_target)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
-	cmpl	$(IA32_NR_syscalls-1),%eax
+	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	ia32_badsys
 sysenter_do_call:
 	IA32_ARG_FIXUP
@@ -195,7 +201,7 @@ sysexit_from_sys_call:
 	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
 	call audit_syscall_entry
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 	movl %ebx,%edi			/* reload 1st syscall arg */
 	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
@@ -248,7 +254,7 @@ sysenter_tracesys:
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl	$(IA32_NR_syscalls-1),%eax
+	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
 	CFI_ENDPROC
@@ -314,7 +320,7 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-	cmpl $IA32_NR_syscalls-1,%eax
+	cmpq $IA32_NR_syscalls-1,%rax
 	ja  ia32_badsys
 cstar_do_call:
 	IA32_ARG_FIXUP 1
@@ -367,7 +373,7 @@ cstar_tracesys:
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
 END(ia32_cstar_target)
@@ -425,7 +431,7 @@ ENTRY(ia32_syscall)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 ia32_do_call:
 	IA32_ARG_FIXUP
@@ -444,7 +450,7 @@ ia32_tracesys:
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 	jmp ia32_do_call
 END(ia32_syscall)
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 56f462c..60a8959 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -89,6 +89,7 @@ extern int acpi_ht;
 extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
+extern int acpi_fix_pin2_polarity;
 
 extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index d2544f1..cb03037 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -38,4 +38,10 @@ static inline void amd_iommu_stats_init(void) { }
 
 #endif /* !CONFIG_AMD_IOMMU_STATS */
 
+static inline bool is_rd890_iommu(struct pci_dev *pdev)
+{
+	return (pdev->vendor == PCI_VENDOR_ID_ATI) &&
+	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
+}
+
 #endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ba19ad4..5a5c618 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -331,6 +331,9 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/* flags read from acpi table */
+	u8 acpi_flags;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
@@ -374,6 +377,15 @@ struct amd_iommu {
 
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
+
+	/*
+	 * This array is required to work around a potential BIOS bug.
+	 * The BIOS may miss to restore parts of the PCI configuration
+	 * space when the system resumes from S3. The result is that the
+	 * IOMMU does not execute commands anymore which leads to system
+	 * failure.
+	 */
+	u32 cache_cfg[4];
 };
 
 /*
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 9a9c7bd..c8c9a74 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -204,7 +204,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *)regs->sp - len;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 637e1ec..e8f7e86 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -150,7 +150,7 @@
 #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
 #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
 #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7373932..6a63b86 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -172,6 +172,7 @@ static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 
 extern void iounmap(volatile void __iomem *addr);
 
+extern void set_iounmap_nonlazy(void);
 
 #ifdef CONFIG_X86_32
 # include "io_32.h"
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4a2d4e0..8b5393e 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -36,8 +36,6 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		percpu_write(cpu_tlbstate.active_mm, next);
@@ -47,6 +45,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+
 		/*
 		 * load the LDT, if the LDT is different:
 		 */
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 177b016..33927d2 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -69,8 +69,6 @@ static inline void native_pmd_clear(pmd_t *pmd)
 
 static inline void pud_clear(pud_t *pudp)
 {
-	unsigned long pgd;
-
 	set_pud(pudp, __pud(0));
 
 	/*
@@ -79,13 +77,10 @@ static inline void pud_clear(pud_t *pudp)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 *
-	 * Make sure the pud entry we're updating is within the
-	 * current pgd to avoid unnecessary TLB flushes.
+	 * Currently all places where pud_clear() is called either have
+	 * flush_tlb_mm() followed or don't need TLB flush (x86_64 code or
+	 * pud_clear_bad()), so we don't need TLB flush here.
 	 */
-	pgd = read_cr3();
-	if (__pa(pudp) >= pgd && __pa(pudp) <
-	    (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
-		write_cr3(pgd);
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 01fd946..750f1bf 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -27,6 +27,7 @@ struct mm_struct;
 struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
+extern pgd_t trampoline_pg_dir[1024];
 
 static inline void pgtable_cache_init(void) { }
 static inline void check_pgt_cache(void) { }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b753ea5..6757357 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -767,29 +767,6 @@ extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 
-/*
- * on systems with caches, caches must be flashed as the absolute
- * last instruction before going into a suspended halt.  Otherwise,
- * dirty data can linger in the cache and become stale on resume,
- * leading to strange errors.
- *
- * perform a variety of operations to guarantee that the compiler
- * will not reorder instructions.  wbinvd itself is serializing
- * so the processor will not reorder.
- *
- * Systems without cache can just go into halt.
- */
-static inline void wbinvd_halt(void)
-{
-	mb();
-	/* check for clflush to determine if wbinvd is legal */
-	if (cpu_has_clflush)
-		asm volatile("cli; wbinvd; 1: hlt; jmp 1b" : : : "memory");
-	else
-		while (1)
-			halt();
-}
-
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 53235fd..daaacab 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -10,5 +10,6 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
+void pvclock_resume(void);
 
 #endif /* _ASM_X86_PVCLOCK_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4cfc908..4c2f63c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -50,7 +50,7 @@ struct smp_ops {
 	void (*smp_prepare_cpus)(unsigned max_cpus);
 	void (*smp_cpus_done)(unsigned max_cpus);
 
-	void (*smp_send_stop)(void);
+	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
 	int (*cpu_up)(unsigned cpu);
@@ -73,7 +73,12 @@ extern struct smp_ops smp_ops;
 
 static inline void smp_send_stop(void)
 {
-	smp_ops.smp_send_stop();
+	smp_ops.stop_other_cpus(0);
+}
+
+static inline void stop_other_cpus(void)
+{
+	smp_ops.stop_other_cpus(1);
 }
 
 static inline void smp_prepare_boot_cpu(void)
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 1def601..cfdc6c8 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index cb507bb..4dde797 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -13,14 +13,17 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_page_table;
 extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
 
 extern unsigned long setup_trampoline(void);
+extern void __init setup_trampoline_page_table(void);
 extern void __init reserve_trampoline_memory(void);
 #else
-static inline void reserve_trampoline_memory(void) {};
+static inline void setup_trampoline_page_table(void) {}
+static inline void reserve_trampoline_memory(void) {}
 #endif /* CONFIG_X86_TRAMPOLINE */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index d87f09b..5282277 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -11,6 +11,8 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_pvclock.o = -pg
+CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0a2b21a..b211f80 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -70,6 +70,7 @@ u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
 int acpi_use_timer_override __initdata;
+int acpi_fix_pin2_polarity __initdata;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
@@ -360,10 +361,15 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 		return 0;
 	}
 
-	if (acpi_skip_timer_override &&
-	    intsrc->source_irq == 0 && intsrc->global_irq == 2) {
-		printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
-		return 0;
+	if (intsrc->source_irq == 0 && intsrc->global_irq == 2) {
+		if (acpi_skip_timer_override) {
+			printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
+			return 0;
+		}
+		if (acpi_fix_pin2_polarity && (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
+			intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
+			printk(PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
+		}
 	}
 
 	mp_override_legacy_irq(intsrc->source_irq,
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ca15b93..b70ec99 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1885,6 +1885,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 			   size_t size,
 			   int dir)
 {
+	dma_addr_t flush_addr;
 	dma_addr_t i, start;
 	unsigned int pages;
 
@@ -1892,6 +1893,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
+	flush_addr = dma_addr;
 	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
@@ -1906,7 +1908,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
+		iommu_flush_pages(&dma_dom->domain, flush_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 86a5a11..572146b 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -628,6 +628,13 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
+
+	if (is_rd890_iommu(iommu->dev)) {
+		pci_read_config_dword(iommu->dev, 0xf0, &iommu->cache_cfg[0]);
+		pci_read_config_dword(iommu->dev, 0xf4, &iommu->cache_cfg[1]);
+		pci_read_config_dword(iommu->dev, 0xf8, &iommu->cache_cfg[2]);
+		pci_read_config_dword(iommu->dev, 0xfc, &iommu->cache_cfg[3]);
+	}
 }
 
 /*
@@ -645,29 +652,9 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	struct ivhd_entry *e;
 
 	/*
-	 * First set the recommended feature enable bits from ACPI
-	 * into the IOMMU control registers
+	 * First save the recommended feature enable bits from ACPI
 	 */
-	h->flags & IVHD_FLAG_HT_TUN_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
-		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
-
-	h->flags & IVHD_FLAG_PASSPW_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
-		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
-
-	h->flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
-		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
-
-	h->flags & IVHD_FLAG_ISOC_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
-		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
-
-	/*
-	 * make IOMMU memory accesses cache coherent
-	 */
-	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+	iommu->acpi_flags = h->flags;
 
 	/*
 	 * Done. Now parse the device entries
@@ -1109,6 +1096,40 @@ static void init_device_table(void)
 	}
 }
 
+static void iommu_init_flags(struct amd_iommu *iommu)
+{
+	iommu->acpi_flags & IVHD_FLAG_HT_TUN_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
+		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_PASSPW_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_ISOC_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
+		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
+
+	/*
+	 * make IOMMU memory accesses cache coherent
+	 */
+	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+}
+
+static void iommu_apply_quirks(struct amd_iommu *iommu)
+{
+	if (is_rd890_iommu(iommu->dev)) {
+		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
+		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
+		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
+		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
+	}
+}
+
 /*
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
@@ -1119,6 +1140,8 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
+		iommu_apply_quirks(iommu);
+		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7718bb3..fb14649 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1315,6 +1315,14 @@ void __cpuinit end_local_APIC_setup(void)
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
+
+	/*
+	 * Now that local APIC setup is completed for BP, configure the fault
+	 * handling for interrupt remapping.
+	 */
+	if (!smp_processor_id() && intr_remapping_enabled)
+		enable_drhd_fault_handling();
+
 }
 
 #ifdef CONFIG_X86_X2APIC
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b35c160a..974faf9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -316,14 +316,19 @@ void arch_init_copy_chip_data(struct irq_desc *old_desc,
 
 	old_cfg = old_desc->chip_data;
 
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+	cfg->vector = old_cfg->vector;
+	cfg->move_in_progress = old_cfg->move_in_progress;
+	cpumask_copy(cfg->domain, old_cfg->domain);
+	cpumask_copy(cfg->old_domain, old_cfg->old_domain);
 
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
-static void free_irq_cfg(struct irq_cfg *old_cfg)
+static void free_irq_cfg(struct irq_cfg *cfg)
 {
-	kfree(old_cfg);
+	free_cpumask_var(cfg->domain);
+	free_cpumask_var(cfg->old_domain);
+	kfree(cfg);
 }
 
 void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
@@ -1394,6 +1399,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3353,6 +3359,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		if (pdev)
@@ -3629,6 +3636,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 83e9be4..fac49a8 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -76,13 +76,6 @@ void __init default_setup_apic_routing(void)
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
 	}
-
-	/*
-	 * Now that apic routing model is selected, configure the
-	 * fault handling for intr remapping.
-	 */
-	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
 }
 
 /* Same for both flat and physical. */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..d11629a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -305,8 +305,7 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 	/* fixup topology information on multi-node processors */
-	if ((c->x86 == 0x10) && (c->x86_model == 9))
-		amd_fixup_dcm(c);
+	amd_fixup_dcm(c);
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..497c3b2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -537,7 +537,7 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	u32 ebx;
@@ -576,6 +576,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+	init_scattered_cpuid_features(c);
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
@@ -731,7 +732,6 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	init_scattered_cpuid_features(c);
 	detect_nopl(c);
 }
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 3624e8a..f668bb1 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -33,5 +33,6 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void get_cpu_cap(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..6d613cd 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -743,6 +743,7 @@ static int acpi_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 		per_cpu(acfreq_data, policy->cpu) = NULL;
 		acpi_processor_unregister_performance(data->acpi_data,
 						      policy->cpu);
+		kfree(data->freq_table);
 		kfree(data);
 	}
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1366c7c..e546d54 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -40,6 +40,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 			c->cpuid_level = cpuid_eax(0);
+			get_cpu_cap(c);
 		}
 	}
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 83a3d1f..8387792 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -140,6 +140,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
 					break;
+
 				address += MCG_XBLK_ADDR;
 			} else
 				++address;
@@ -147,12 +148,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (rdmsr_safe(address, &low, &high))
 				break;
 
-			if (!(high & MASK_VALID_HI)) {
-				if (block)
-					continue;
-				else
-					break;
-			}
+			if (!(high & MASK_VALID_HI))
+				continue;
 
 			if (!(high & MASK_CNTP_HI)  ||
 			     (high & MASK_LOCKED_HI))
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 09b1698..51db629 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -977,7 +977,7 @@ int __init amd_special_default_mtrr(void)
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+	if (boot_cpu_data.x86 < 0xf)
 		return 0;
 	/* In case some hypervisor doesn't pass SYSCFG through: */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..419e328 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -762,13 +762,21 @@ void set_mtrr_aps_delayed_init(void)
 }
 
 /*
- * MTRR initialization for all AP's
+ * Delayed MTRR initialization for all AP's
  */
 void mtrr_aps_init(void)
 {
 	if (!use_intel())
 		return;
 
+	/*
+	 * Check if someone has requested the delay of AP MTRR initialization,
+	 * by doing set_mtrr_aps_delayed_init(), prior to this point. If not,
+	 * then we are done.
+	 */
+	if (!mtrr_aps_delayed_init)
+		return;
+
 	set_mtrr(~0U, 0, 0, 0);
 	mtrr_aps_delayed_init = false;
 }
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 045b36c..9948288 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
@@ -46,6 +46,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
+	set_iounmap_nonlazy();
 	iounmap(vaddr);
 	return csize;
 }
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a1a7876..88e9f57 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1245,15 +1245,21 @@ static int __init parse_memopt(char *p)
 	if (!p)
 		return -EINVAL;
 
-#ifdef CONFIG_X86_32
 	if (!strcmp(p, "nopentium")) {
+#ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
-	}
+#else
+		printk(KERN_WARNING "mem=nopentium ignored! (only supported on x86_32)\n");
+		return -EINVAL;
 #endif
+	}
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index ebdb85c..f67a33c7 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -145,15 +145,10 @@ static void __init ati_bugs(int num, int slot, int func)
 
 static u32 __init ati_sbx00_rev(int num, int slot, int func)
 {
-	u32 old, d;
+	u32 d;
 
-	d = read_pci_config(num, slot, func, 0x70);
-	old = d;
-	d &= ~(1<<8);
-	write_pci_config(num, slot, func, 0x70, d);
 	d = read_pci_config(num, slot, func, 0x8);
 	d &= 0xff;
-	write_pci_config(num, slot, func, 0x70, old);
 
 	return d;
 }
@@ -162,11 +157,19 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 {
 	u32 d, rev;
 
-	if (acpi_use_timer_override)
+	rev = ati_sbx00_rev(num, slot, func);
+	if (rev >= 0x40)
+		acpi_fix_pin2_polarity = 1;
+
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
-	rev = ati_sbx00_rev(num, slot, func);
-	if (rev > 0x13)
+	if (acpi_use_timer_override)
 		return;
 
 	/* check for IRQ0 interrupt swap */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 7fd318b..e2395bf 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl $pa(swapper_pg_dir),%eax
+	movl pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
 	orl  $X86_CR0_PG,%eax
@@ -608,6 +608,8 @@ ignore_int:
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
+ENTRY(initial_page_table)
+	.long pa(swapper_pg_dir)
 
 /*
  * BSS section
@@ -623,6 +625,10 @@ ENTRY(swapper_pg_dir)
 #endif
 swapper_pg_fixmap:
 	.fill 1024,4,0
+#ifdef CONFIG_X86_TRAMPOLINE
+ENTRY(trampoline_pg_dir)
+	.fill 1024,4,0
+#endif
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 241c5b2..9ae9b0b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -498,7 +498,7 @@ static int hpet_assign_irq(struct hpet_dev *dev)
 {
 	unsigned int irq;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 1e8cead..d781730 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -457,6 +457,10 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	dr6_p = (unsigned long *)ERR_PTR(args->err);
 	dr6 = *dr6_p;
 
+	/* If it's a single step, TRAP bits are random */
+	if (dr6 & DR_STEP)
+		return NOTIFY_DONE;
+
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 9d1d263..434dfd5 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -115,6 +115,7 @@ int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
 	unsigned long flags;
 	int ret = -EIO;
 	int i;
+	int restarts = 0;
 
 	spin_lock_irqsave(&ec_lock, flags);
 
@@ -171,7 +172,9 @@ restart:
 			if (wait_on_obf(0x6c, 1)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC to provide data!\n");
-				goto restart;
+				if (restarts++ < 10)
+					goto restart;
+				goto err;
 			}
 			outbuf[i] = inb(0x68);
 			printk(KERN_DEBUG "olpc-ec:  received 0x%x\n",
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index dfdfe46..b12fe8d 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -111,6 +111,11 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
+void pvclock_resume(void)
+{
+	atomic64_set(&last_value, 0);
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 8e1aac8..ff8cc40 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -633,7 +633,7 @@ void native_machine_shutdown(void)
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	lapic_shutdown();
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4772a9f..9243586 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -981,6 +981,8 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
+	setup_trampoline_page_table();
+
 	tboot_probe();
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index ec1de97..29f0a78 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -158,10 +158,10 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
-static void native_smp_send_stop(void)
+static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
-	unsigned long wait;
+	unsigned long timeout;
 
 	if (reboot_force)
 		return;
@@ -178,9 +178,12 @@ static void native_smp_send_stop(void)
 	if (num_online_cpus() > 1) {
 		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
-		/* Don't wait longer than a second */
-		wait = USEC_PER_SEC;
-		while (num_online_cpus() > 1 && wait--)
+		/*
+		 * Don't wait longer than a second if the caller
+		 * didn't ask us to wait.
+		 */
+		timeout = USEC_PER_SEC;
+		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
@@ -226,7 +229,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.smp_send_stop		= native_smp_send_stop,
+	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b4e870c..ea1ab22 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -70,7 +70,6 @@
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
-static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -273,6 +272,18 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * fragile that we want to limit the things done here to the
 	 * most necessary things.
 	 */
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Switch away from the trampoline page-table
+	 *
+	 * Do this before cpu_init() because it needs to access per-cpu
+	 * data which may not be mapped in the trampoline page-table.
+	 */
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+#endif
+
 	vmi_bringup();
 	cpu_init();
 	preempt_disable();
@@ -291,12 +302,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 		enable_8259A_irq(0);
 	}
 
-#ifdef CONFIG_X86_32
-	while (low_mappings)
-		cpu_relax();
-	__flush_tlb_all();
-#endif
-
 	/* This must be done before setting cpu_online_mask */
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
@@ -743,6 +748,7 @@ do_rest:
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
+	initial_page_table = __pa(&trampoline_pg_dir);
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
@@ -883,20 +889,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
-#ifdef CONFIG_X86_32
-	/* init low mem mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-		min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
-	flush_tlb_all();
-	low_mappings = 1;
-
 	err = do_boot_cpu(apicid, cpu);
 
-	zap_low_mappings(false);
-	low_mappings = 0;
-#else
-	err = do_boot_cpu(apicid, cpu);
-#endif
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
@@ -1335,11 +1329,94 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+#define MWAIT_SUBSTATE_MASK		0xf
+#define MWAIT_SUBSTATE_SIZE		4
+
+#define CPUID_MWAIT_LEAF		5
+#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
+
+/*
+ * We need to flush the caches before going to sleep, lest we have
+ * dirty data in our caches when we come back up.
+ */
+static inline void mwait_play_dead(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int highest_cstate = 0;
+	unsigned int highest_subcstate = 0;
+	int i;
+	void *mwait_ptr;
+
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
+		return;
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
+		return;
+	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+		return;
+
+	eax = CPUID_MWAIT_LEAF;
+	ecx = 0;
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	/*
+	 * eax will be 0 if EDX enumeration is not valid.
+	 * Initialized below to cstate, sub_cstate value when EDX is valid.
+	 */
+	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED)) {
+		eax = 0;
+	} else {
+		edx >>= MWAIT_SUBSTATE_SIZE;
+		for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
+			if (edx & MWAIT_SUBSTATE_MASK) {
+				highest_cstate = i;
+				highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
+			}
+		}
+		eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
+			(highest_subcstate - 1);
+	}
+
+	/*
+	 * This should be a memory location in a cache line which is
+	 * unlikely to be touched by other processors.  The actual
+	 * content is immaterial as it is not actually modified in any way.
+	 */
+	mwait_ptr = &current_thread_info()->flags;
+
+	wbinvd();
+
+	while (1) {
+		/*
+		 * The CLFLUSH is a workaround for erratum AAI65 for
+		 * the Xeon 7400 series.  It's not clear it is actually
+		 * needed, but it should be harmless in either case.
+		 * The WBINVD is insufficient due to the spurious-wakeup
+		 * case where we return around the loop.
+		 */
+		clflush(mwait_ptr);
+		__monitor(mwait_ptr, 0, 0);
+		mb();
+		__mwait(eax, 0);
+	}
+}
+
+static inline void hlt_play_dead(void)
+{
+	if (current_cpu_data.x86 >= 4)
+		wbinvd();
+
+	while (1) {
+		native_halt();
+	}
+}
+
 void native_play_dead(void)
 {
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
-	wbinvd_halt();
+
+	mwait_play_dead();	/* Only returns on failure */
+	hlt_play_dead();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index c652ef6..e2a5952 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -1,6 +1,7 @@
 #include <linux/io.h>
 
 #include <asm/trampoline.h>
+#include <asm/pgtable.h>
 #include <asm/e820.h>
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
@@ -37,3 +38,19 @@ unsigned long __trampinit setup_trampoline(void)
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
 }
+
+void __init setup_trampoline_page_table(void)
+{
+#ifdef CONFIG_X86_32
+	/* Copy kernel address range */
+	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
+			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			KERNEL_PGD_PTRS);
+
+	/* Initialize low mappings */
+	clone_pgd_range(trampoline_pg_dir,
+			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS,
+			      KERNEL_PGD_BOUNDARY));
+#endif
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 07750de..8c4ca39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1615,7 +1615,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT */ | 0 /* WDT */;
 
 	/* all calls to cpuid_count() should be made on the same cpu */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f627779..a9aac79 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -829,6 +829,13 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
 	if (fault & VM_FAULT_OOM) {
+		/* Kernel mode? Handle exceptions or die: */
+		if (!(error_code & PF_USER)) {
+			up_read(&current->mm->mmap_sem);
+			no_context(regs, error_code, address);
+			return;
+		}
+
 		out_of_memory(regs, error_code, address);
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON))
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index c9ba9de..e0e6fad 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -159,8 +159,7 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
+	flush_tlb_mm(mm);
 }
 #else  /* !CONFIG_X86_PAE */
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 28c6876..802ad35 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -372,9 +372,11 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
-	for_each_node_mask(i, nodes_parsed)
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
-						nodes[i].end >> PAGE_SHIFT);
+	for (i = 0; i < num_node_memblks; i++)
+		e820_register_active_regions(memblk_nodeid[i],
+				node_memblk_range[i].start >> PAGE_SHIFT,
+				node_memblk_range[i].end >> PAGE_SHIFT);
+
 	/* for out of order entries in SRAT */
 	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6b4ffed..dd78ef6 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -25,7 +25,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
@@ -69,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b607239..4f807e6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -999,10 +999,6 @@ static void xen_reboot(int reason)
 {
 	struct sched_shutdown r = { .reason = reason };
 
-#ifdef CONFIG_SMP
-	smp_send_stop();
-#endif
-
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
 		BUG();
 }
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 563d205..ad5df67 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -397,9 +397,9 @@ static void stop_self(void *v)
 	BUG();
 }
 
-static void xen_smp_send_stop(void)
+static void xen_stop_other_cpus(int wait)
 {
-	smp_call_function(stop_self, NULL, 0);
+	smp_call_function(stop_self, NULL, wait);
 }
 
 static void xen_smp_send_reschedule(int cpu)
@@ -467,7 +467,7 @@ static const struct smp_ops xen_smp_ops __initdata = {
 	.cpu_disable = xen_cpu_disable,
 	.play_dead = xen_play_dead,
 
-	.smp_send_stop = xen_smp_send_stop,
+	.stop_other_cpus = xen_stop_other_cpus,
 	.smp_send_reschedule = xen_smp_send_reschedule,
 
 	.send_call_func_ipi = xen_smp_send_call_function_ipi,
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0d3f07c..5b6577f 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -463,6 +463,8 @@ void xen_timer_resume(void)
 {
 	int cpu;
 
+	pvclock_resume();
+
 	if (xen_clockevent != &xen_vcpuop_clockevent)
 		return;
 
diff --git a/block/blk-map.c b/block/blk-map.c
index 9083cf0..30a7e51 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -205,6 +205,8 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			unaligned = 1;
 			break;
 		}
+		if (!iov[i].iov_len)
+			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5eeb9e0..bda7d15 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -356,7 +356,7 @@ EXPORT_SYMBOL(blk_queue_logical_block_size);
  *   hardware can operate on without reverting to read-modify-write
  *   operations.
  */
-void blk_queue_physical_block_size(struct request_queue *q, unsigned short size)
+void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
 {
 	q->limits.physical_block_size = size;
 
diff --git a/block/bsg.c b/block/bsg.c
index a9fd2d8..ae14805 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -425,7 +425,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors & 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7424bf9..abc5d80 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3262,6 +3262,10 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	struct cfq_io_context *cic = cfqd->active_cic;
 
+	/* If the queue already has requests, don't wait */
+	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
+		return false;
+
 	/* If there are other queues in the group, don't wait */
 	if (cfqq->cfqg->nr_cfqq > 1)
 		return false;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a8b5a10..4f4230b 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -321,33 +321,47 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	if (hdr->iovec_count) {
 		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
 		size_t iov_data_len;
-		struct sg_iovec *iov;
+		struct sg_iovec *sg_iov;
+		struct iovec *iov;
+		int i;
 
-		iov = kmalloc(size, GFP_KERNEL);
-		if (!iov) {
+		sg_iov = kmalloc(size, GFP_KERNEL);
+		if (!sg_iov) {
 			ret = -ENOMEM;
 			goto out;
 		}
 
-		if (copy_from_user(iov, hdr->dxferp, size)) {
-			kfree(iov);
+		if (copy_from_user(sg_iov, hdr->dxferp, size)) {
+			kfree(sg_iov);
 			ret = -EFAULT;
 			goto out;
 		}
 
+		/*
+		 * Sum up the vecs, making sure they don't overflow
+		 */
+		iov = (struct iovec *) sg_iov;
+		iov_data_len = 0;
+		for (i = 0; i < hdr->iovec_count; i++) {
+			if (iov_data_len + iov[i].iov_len < iov_data_len) {
+				kfree(sg_iov);
+				ret = -EINVAL;
+				goto out;
+			}
+			iov_data_len += iov[i].iov_len;
+		}
+
 		/* SG_IO howto says that the shorter of the two wins */
-		iov_data_len = iov_length((struct iovec *)iov,
-					  hdr->iovec_count);
 		if (hdr->dxfer_len < iov_data_len) {
-			hdr->iovec_count = iov_shorten((struct iovec *)iov,
+			hdr->iovec_count = iov_shorten(iov,
 						       hdr->iovec_count,
 						       hdr->dxfer_len);
 			iov_data_len = hdr->dxfer_len;
 		}
 
-		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
+		ret = blk_rq_map_user_iov(q, rq, NULL, sg_iov, hdr->iovec_count,
 					  iov_data_len, GFP_KERNEL);
-		kfree(iov);
+		kfree(sg_iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
 				      GFP_KERNEL);
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 81e64f4..d46e256 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -846,6 +846,7 @@ struct acpi_bit_register_info {
 	ACPI_BITMASK_POWER_BUTTON_STATUS   | \
 	ACPI_BITMASK_SLEEP_BUTTON_STATUS   | \
 	ACPI_BITMASK_RT_CLOCK_STATUS       | \
+	ACPI_BITMASK_PCIEXP_WAKE_DISABLE   | \
 	ACPI_BITMASK_WAKE_STATUS)
 
 #define ACPI_BITMASK_TIMER_ENABLE               0x0001
diff --git a/drivers/acpi/acpica/dswexec.c b/drivers/acpi/acpica/dswexec.c
index f028085..eef6fde 100644
--- a/drivers/acpi/acpica/dswexec.c
+++ b/drivers/acpi/acpica/dswexec.c
@@ -300,10 +300,25 @@ acpi_ds_exec_begin_op(struct acpi_walk_state *walk_state,
 			 * we must enter this object into the namespace.  The created
 			 * object is temporary and will be deleted upon completion of
 			 * the execution of this method.
+			 *
+			 * Note 10/2010: Except for the Scope() op. This opcode does
+			 * not actually create a new object, it refers to an existing
+			 * object. However, for Scope(), we want to indeed open a
+			 * new scope.
 			 */
-			status = acpi_ds_load2_begin_op(walk_state, NULL);
+			if (op->common.aml_opcode != AML_SCOPE_OP) {
+				status =
+				    acpi_ds_load2_begin_op(walk_state, NULL);
+			} else {
+				status =
+				    acpi_ds_scope_stack_push(op->named.node,
+							     op->named.node->
+							     type, walk_state);
+				if (ACPI_FAILURE(status)) {
+					return_ACPI_STATUS(status);
+				}
+			}
 		}
-
 		break;
 
 	case AML_CLASS_EXECUTE:
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 2815df6..ab645bb 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -218,6 +218,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		},
 	},
 	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Toshiba Satellite L355",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		     DMI_MATCH(DMI_PRODUCT_VERSION, "Satellite L355"),
+		},
+	},
+	{
 	.callback = dmi_disable_osi_win7,
 	.ident = "ASUS K50IJ",
 	.matches = {
@@ -225,6 +233,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "K50IJ"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Toshiba P305D",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index fc67d11..b548e1a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -954,6 +954,9 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
 	ec_flag_msi, "MSI hardware", {
 	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-Star")}, NULL},
 	{
+	ec_flag_msi, "MSI hardware", {
+	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR")}, NULL},
+	{
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "ASUS") }, NULL},
 	{},
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9c6747c..198224b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -576,6 +576,11 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8e9b132..eae0322 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5016,9 +5016,6 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
 {
 	struct ata_device *dev = qc->dev;
 
-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;
 
@@ -5062,14 +5059,23 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;
 
-		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			/* always fill result TF for failed qc */
+		/*
+		 * Finish internal commands without any further processing
+		 * and always with the result TF filled.
+		 */
+		if (unlikely(ata_tag_internal(qc->tag))) {
 			fill_result_tf(qc);
+			__ata_qc_complete(qc);
+			return;
+		}
 
-			if (!ata_tag_internal(qc->tag))
-				ata_qc_schedule_eh(qc);
-			else
-				__ata_qc_complete(qc);
+		/*
+		 * Non-internal qc has failed.  Fill the result TF and
+		 * summon EH.
+		 */
+		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
+			fill_result_tf(qc);
+			ata_qc_schedule_eh(qc);
 			return;
 		}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d096fbc..5516624 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2547,8 +2547,11 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		 *
 		 * If door lock fails, always clear sdev->locked to
 		 * avoid this infinite loop.
+		 *
+		 * This may happen before SCSI scan is complete.  Make
+		 * sure qc->dev->sdev isn't NULL before dereferencing.
 		 */
-		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL)
+		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
 		qc->scsicmd->result = SAM_STAT_CHECK_CONDITION;
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 2bc2dbe..99d41be 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -610,7 +610,7 @@ static struct scsi_host_template mpc52xx_ata_sht = {
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	.sff_dev_select		= mpc52xx_ata_dev_select,
 	.set_piomode		= mpc52xx_ata_set_piomode,
 	.set_dmamode		= mpc52xx_ata_set_dmamode,
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 68b5957..a5d585d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2408,7 +2408,7 @@ static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 	pkt_shrink_pktlist(pd);
 }
 
-static struct pktcdvd_device *pkt_find_dev_from_minor(int dev_minor)
+static struct pktcdvd_device *pkt_find_dev_from_minor(unsigned int dev_minor)
 {
 	if (dev_minor >= MAX_WRITERS)
 		return NULL;
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index aa09193..06da1c7 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -258,9 +258,16 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 
 	BT_DBG("tty %p", tty);
 
+	/* FIXME: This btw is bogus, nothing requires the old ldisc to clear
+	   the pointer */
 	if (hu)
 		return -EEXIST;
 
+	/* Error if the tty has no write op instead of leaving an exploitable
+	   hole */
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
 	if (!(hu = kzalloc(sizeof(struct hci_uart), GFP_KERNEL))) {
 		BT_ERR("Can't allocate control structure");
 		return -ENFILE;
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e481c59..a3bcb6b 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -476,6 +476,21 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	if (irq) {
 		unsigned long irq_flags;
 
+		if (devp->hd_flags & HPET_SHARED_IRQ) {
+			/*
+			 * To prevent the interrupt handler from seeing an
+			 * unwanted interrupt status bit, program the timer
+			 * so that it will not fire in the near future ...
+			 */
+			writel(readl(&timer->hpet_config) & ~Tn_TYPE_CNF_MASK,
+			       &timer->hpet_config);
+			write_counter(read_counter(&hpet->hpet_mc),
+				      &timer->hpet_compare);
+			/* ... and clear any left-over status. */
+			isr = 1 << (devp - devp->hd_hpets->hp_dev);
+			writel(isr, &hpet->hpet_isr);
+		}
+
 		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
 		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
 						? IRQF_SHARED : IRQF_DISABLED;
@@ -967,6 +982,8 @@ static int hpet_acpi_add(struct acpi_device *device)
 		return -ENODEV;
 
 	if (!data.hd_address || !data.hd_nirqs) {
+		if (data.hd_address)
+			iounmap(data.hd_address);
 		printk("%s: no address or irqs in _CRS\n", __func__);
 		return -ENODEV;
 	}
diff --git a/drivers/char/hvc_iucv.c b/drivers/char/hvc_iucv.c
index fe62bd0..170cc4b 100644
--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -139,6 +139,8 @@ struct hvc_iucv_private *hvc_iucv_get_private(uint32_t num)
  *
  * This function allocates a new struct iucv_tty_buffer element and, optionally,
  * allocates an internal data buffer with the specified size @size.
+ * The internal data buffer is always allocated with GFP_DMA which is
+ * required for receiving and sending data with IUCV.
  * Note: The total message size arises from the internal buffer size and the
  *	 members of the iucv_tty_msg structure.
  * The function returns NULL if memory allocation has failed.
@@ -154,7 +156,7 @@ static struct iucv_tty_buffer *alloc_tty_buffer(size_t size, gfp_t flags)
 
 	if (size > 0) {
 		bufp->msg.length = MSG_SIZE(size);
-		bufp->mbuf = kmalloc(bufp->msg.length, flags);
+		bufp->mbuf = kmalloc(bufp->msg.length, flags | GFP_DMA);
 		if (!bufp->mbuf) {
 			mempool_free(bufp, hvc_iucv_mempool);
 			return NULL;
@@ -237,7 +239,7 @@ static int hvc_iucv_write(struct hvc_iucv_private *priv,
 	if (!rb->mbuf) { /* message not yet received ... */
 		/* allocate mem to store msg data; if no memory is available
 		 * then leave the buffer on the list and re-try later */
-		rb->mbuf = kmalloc(rb->msg.length, GFP_ATOMIC);
+		rb->mbuf = kmalloc(rb->msg.length, GFP_ATOMIC | GFP_DMA);
 		if (!rb->mbuf)
 			return -ENOMEM;
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 48788db..bc46ea8 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -784,10 +784,11 @@ static const struct file_operations zero_fops = {
 /*
  * capabilities for /dev/zero
  * - permits private mappings, "copies" are taken of the source of zeros
+ * - no writeback happens
  */
 static struct backing_dev_info zero_bdi = {
 	.name		= "char/mem",
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static const struct file_operations full_fops = {
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index c31a0d9..1165503 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -4144,6 +4144,8 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
+	memset(&new_line, 0, size);
+
 	switch(ifr->ifr_settings.type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index f06bb37..329b796 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -353,12 +353,14 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 		    tpm_protected_ordinal_duration[ordinal &
 						   TPM_PROTECTED_ORDINAL_MASK];
 
-	if (duration_idx != TPM_UNDEFINED)
+	if (duration_idx != TPM_UNDEFINED) {
 		duration = chip->vendor.duration[duration_idx];
-	if (duration <= 0)
+		/* if duration is 0, it's because chip->vendor.duration wasn't */
+		/* filled yet, so we set the lowest timeout just to give enough */
+		/* time for tpm_get_timeouts() to succeed */
+		return (duration <= 0 ? HZ : duration);
+	} else
 		return 2 * 60 * HZ;
-	else
-		return duration;
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index ca15c04..d872930 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -24,6 +24,7 @@
 #include <linux/pnp.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+#include <linux/acpi.h>
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
@@ -77,6 +78,26 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
+#ifdef CONFIG_ACPI
+static int is_itpm(struct pnp_dev *dev)
+{
+	struct acpi_device *acpi = pnp_acpi_device(dev);
+	struct acpi_hardware_id *id;
+
+	list_for_each_entry(id, &acpi->pnp.ids, list) {
+		if (!strcmp("INTC0102", id->id))
+			return 1;
+	}
+
+	return 0;
+}
+#else
+static int is_itpm(struct pnp_dev *dev)
+{
+	return 0;
+}
+#endif
+
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
@@ -471,6 +492,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (is_itpm(to_pnp_dev(dev)))
+		itpm = 1;
+
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 
diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index f27c4d6..9605ee5 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -412,7 +412,8 @@ static void flush_to_ldisc(struct work_struct *work)
 	spin_lock_irqsave(&tty->buf.lock, flags);
 
 	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
-		struct tty_buffer *head;
+		struct tty_buffer *head, *tail = tty->buf.tail;
+		int seen_tail = 0;
 		while ((head = tty->buf.head) != NULL) {
 			int count;
 			char *char_buf;
@@ -422,6 +423,15 @@ static void flush_to_ldisc(struct work_struct *work)
 			if (!count) {
 				if (head->next == NULL)
 					break;
+				/*
+				  There's a possibility tty might get new buffer
+				  added during the unlock window below. We could
+				  end up spinning in here forever hogging the CPU
+				  completely. To avoid this let's have a rest each
+				  time we processed the tail buffer.
+				*/
+				if (tail == head)
+					seen_tail = 1;
 				tty->buf.head = head->next;
 				tty_buffer_free(tty, head);
 				continue;
@@ -431,7 +441,7 @@ static void flush_to_ldisc(struct work_struct *work)
 			   line discipline as we want to empty the queue */
 			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
 				break;
-			if (!tty->receive_room) {
+			if (!tty->receive_room || seen_tail) {
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
 			}
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 500e740..236628f 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -47,6 +47,7 @@
 
 static DEFINE_SPINLOCK(tty_ldisc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
+static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_idle);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
@@ -83,6 +84,7 @@ static void put_ldisc(struct tty_ldisc *ld)
 		return;
 	}
 	local_irq_restore(flags);
+	wake_up(&tty_ldisc_idle);
 }
 
 /**
@@ -450,6 +452,8 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
                 /* BKL here locks verus a hangup event */
 		lock_kernel();
 		ret = ld->ops->open(tty);
+		if (ret)
+			clear_bit(TTY_LDISC_OPEN, &tty->flags);
 		unlock_kernel();
 		return ret;
 	}
@@ -530,6 +534,23 @@ static int tty_ldisc_halt(struct tty_struct *tty)
 }
 
 /**
+ *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
+ *	@tty: tty to wait for
+ *
+ *	Wait for the line discipline to become idle. The discipline must
+ *	have been halted for this to guarantee it remains idle.
+ */
+static int tty_ldisc_wait_idle(struct tty_struct *tty)
+{
+	int ret;
+	ret = wait_event_interruptible_timeout(tty_ldisc_idle,
+			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
+	if (ret < 0)
+		return ret;
+	return ret > 0 ? 0 : -EBUSY;
+}
+
+/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -632,8 +653,17 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
+	retval = tty_ldisc_wait_idle(tty);
+
 	mutex_lock(&tty->ldisc_mutex);
 	lock_kernel();
+
+	/* handle wait idle failure locked */
+	if (retval) {
+		tty_ldisc_put(new_ldisc);
+		goto enable;
+	}
+
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
@@ -667,6 +697,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_ldisc_put(o_ldisc);
 
+enable:
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */
@@ -712,9 +743,12 @@ static void tty_reset_termios(struct tty_struct *tty)
  *	state closed
  */
 
-static void tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
+static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 {
-	struct tty_ldisc *ld;
+	struct tty_ldisc *ld = tty_ldisc_get(ldisc);
+
+	if (IS_ERR(ld))
+		return -1;
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
@@ -722,10 +756,10 @@ static void tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 	/*
 	 *	Switch the line discipline back
 	 */
-	ld = tty_ldisc_get(ldisc);
-	BUG_ON(IS_ERR(ld));
 	tty_ldisc_assign(tty, ld);
 	tty_set_termios_ldisc(tty, ldisc);
+
+	return 0;
 }
 
 /**
@@ -787,13 +821,16 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	   a FIXME */
 	if (tty->ldisc) {	/* Not yet closed */
 		if (reset == 0) {
-			tty_ldisc_reinit(tty, tty->termios->c_line);
-			err = tty_ldisc_open(tty, tty->ldisc);
+
+			if (!tty_ldisc_reinit(tty, tty->termios->c_line))
+				err = tty_ldisc_open(tty, tty->ldisc);
+			else
+				err = 1;
 		}
 		/* If the re-open fails or we reset then go to N_TTY. The
 		   N_TTY open cannot fail */
 		if (reset || err) {
-			tty_ldisc_reinit(tty, N_TTY);
+			BUG_ON(tty_ldisc_reinit(tty, N_TTY));
 			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
 		}
 		tty_ldisc_enable(tty);
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..6351a26 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -503,6 +503,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	struct kbd_struct * kbd;
 	unsigned int console;
 	unsigned char ucval;
+	unsigned int uival;
 	void __user *up = (void __user *)arg;
 	int i, perm;
 	int ret = 0;
@@ -657,7 +658,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGETMODE:
-		ucval = vc->vc_mode;
+		uival = vc->vc_mode;
 		goto setint;
 
 	case KDMAPDISP:
@@ -695,7 +696,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGKBMODE:
-		ucval = ((kbd->kbdmode == VC_RAW) ? K_RAW :
+		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
 				 K_XLATE);
@@ -717,9 +718,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGKBMETA:
-		ucval = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
+		uival = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
 	setint:
-		ret = put_user(ucval, (int __user *)arg);
+		ret = put_user(uival, (int __user *)arg);
 		break;
 
 	case KDGETKEYCODE:
@@ -949,7 +950,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (! VT_IS_IN_USE(i))
 				break;
-		ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
+		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 
 
 	/*
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 8c2f370..50a886e 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -285,7 +285,7 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 	if (initial)
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 			      : "+S" (input), "+D" (output), "+a" (iv)
-			      : "d" (control_word), "b" (key), "c" (count));
+			      : "d" (control_word), "b" (key), "c" (initial));
 
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 		      : "+S" (input), "+D" (output), "+a" (iv)
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 466ab10..076d599 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -161,7 +161,7 @@ static int mv_is_err_intr(u32 intr_cause)
 
 static void mv_xor_device_clear_eoc_cause(struct mv_xor_chan *chan)
 {
-	u32 val = (1 << (1 + (chan->idx * 16)));
+	u32 val = ~(1 << (chan->idx * 16));
 	dev_dbg(chan->device->common.dev, "%s, val 0x%08x\n", __func__, val);
 	__raw_writel(val, XOR_INTR_CAUSE(chan));
 }
@@ -448,7 +448,7 @@ mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 static void mv_xor_tasklet(unsigned long data)
 {
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
-	__mv_xor_slot_cleanup(chan);
+	mv_xor_slot_cleanup(chan);
 }
 
 static struct mv_xor_desc_slot *
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 72904c8..43f96fc 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1567,7 +1567,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int dram_range,
 	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
 			hole_off, hole_valid, intlv_sel);
 
-	if (intlv_en ||
+	if (intlv_en &&
 	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
 		return -EINVAL;
 
diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 991447b..611fe92 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -75,6 +75,8 @@ static size_t config_rom_length = 1 + 4 + 1 + 1;
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
+#define CANON_OUI		0x000085
+
 static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 {
 	struct fw_descriptor *desc;
@@ -240,6 +242,7 @@ static void fw_card_bm_work(struct work_struct *work)
 	bool root_device_is_running;
 	bool root_device_is_cmc;
 	bool irm_is_1394_1995_only;
+	bool keep_this_irm;
 
 	spin_lock_irqsave(&card->lock, flags);
 
@@ -261,6 +264,10 @@ static void fw_card_bm_work(struct work_struct *work)
 	irm_is_1394_1995_only = irm_device && irm_device->config_rom &&
 			(irm_device->config_rom[2] & 0x000000f0) == 0;
 
+	/* Canon MV5i works unreliably if it is not root node. */
+	keep_this_irm = irm_device && irm_device->config_rom &&
+			irm_device->config_rom[3] >> 8 == CANON_OUI;
+
 	root_id  = root_node->node_id;
 	irm_id   = card->irm_node->node_id;
 	local_id = card->local_node->node_id;
@@ -288,7 +295,7 @@ static void fw_card_bm_work(struct work_struct *work)
 			goto pick_me;
 		}
 
-		if (irm_is_1394_1995_only) {
+		if (irm_is_1394_1995_only && !keep_this_irm) {
 			new_root_id = local_id;
 			fw_notify("%s, making local node (%02x) root.\n",
 				  "IRM is not 1394a compliant", new_root_id);
@@ -322,7 +329,7 @@ static void fw_card_bm_work(struct work_struct *work)
 
 		spin_lock_irqsave(&card->lock, flags);
 
-		if (rcode != RCODE_COMPLETE) {
+		if (rcode != RCODE_COMPLETE && !keep_this_irm) {
 			/*
 			 * The lock request failed, maybe the IRM
 			 * isn't really IRM capable after all. Let's
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 43ebf33..50db5c1 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -628,7 +628,7 @@ static void ar_context_tasklet(unsigned long data)
 	d = &ab->descriptor;
 
 	if (d->res_count == 0) {
-		size_t size, rest, offset;
+		size_t size, size2, rest, pktsize, size3, offset;
 		dma_addr_t start_bus;
 		void *start;
 
@@ -639,25 +639,61 @@ static void ar_context_tasklet(unsigned long data)
 		 */
 
 		offset = offsetof(struct ar_buffer, data);
-		start = buffer = ab;
+		start = ab;
 		start_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+		buffer = ab->data;
 
 		ab = ab->next;
 		d = &ab->descriptor;
-		size = buffer + PAGE_SIZE - ctx->pointer;
+		size = start + PAGE_SIZE - ctx->pointer;
+		/* valid buffer data in the next page */
 		rest = le16_to_cpu(d->req_count) - le16_to_cpu(d->res_count);
+		/* what actually fits in this page */
+		size2 = min(rest, (size_t)PAGE_SIZE - offset - size);
 		memmove(buffer, ctx->pointer, size);
-		memcpy(buffer + size, ab->data, rest);
-		ctx->current_buffer = ab;
-		ctx->pointer = (void *) ab->data + rest;
-		end = buffer + size + rest;
+		memcpy(buffer + size, ab->data, size2);
+
+		while (size > 0) {
+			void *next = handle_ar_packet(ctx, buffer);
+			pktsize = next - buffer;
+			if (pktsize >= size) {
+				/*
+				 * We have handled all the data that was
+				 * originally in this page, so we can now
+				 * continue in the next page.
+				 */
+				buffer = next;
+				break;
+			}
+			/* move the next packet to the start of the buffer */
+			memmove(buffer, next, size + size2 - pktsize);
+			size -= pktsize;
+			/* fill up this page again */
+			size3 = min(rest - size2,
+				    (size_t)PAGE_SIZE - offset - size - size2);
+			memcpy(buffer + size + size2,
+			       (void *) ab->data + size2, size3);
+			size2 += size3;
+		}
 
-		while (buffer < end)
-			buffer = handle_ar_packet(ctx, buffer);
+		if (rest > 0) {
+			/* handle the packets that are fully in the next page */
+			buffer = (void *) ab->data +
+					(buffer - (start + offset + size));
+			end = (void *) ab->data + rest;
+
+			while (buffer < end)
+				buffer = handle_ar_packet(ctx, buffer);
 
-		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  start, start_bus);
-		ar_context_add_page(ctx);
+			ctx->current_buffer = ab;
+			ctx->pointer = end;
+
+			dma_free_coherent(ohci->card.device, PAGE_SIZE,
+					  start, start_bus);
+			ar_context_add_page(ctx);
+		} else {
+			ctx->pointer = start + PAGE_SIZE;
+		}
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..7bb111b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -94,7 +94,10 @@ config DRM_I830
 config DRM_I915
 	tristate "i915 driver"
 	depends on AGP_INTEL
+	# we need shmfs for the swappable backing store, and in particular
+	# the shmem_readpage() which depends upon tmpfs
 	select SHMEM
+	select TMPFS
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index d91fb8c..81ba0e6 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -153,12 +153,12 @@ static struct drm_conn_prop_enum_list drm_connector_enum_list[] =
 	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
 	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
 	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
-	{ DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
-	{ DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
-	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
-	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
+	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
+	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
+	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI-A", 0 },
+	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI-B", 0 },
 	{ DRM_MODE_CONNECTOR_TV, "TV", 0 },
-	{ DRM_MODE_CONNECTOR_eDP, "Embedded DisplayPort", 0 },
+	{ DRM_MODE_CONNECTOR_eDP, "eDP", 0 },
 };
 
 static struct drm_prop_enum_list drm_encoder_enum_list[] =
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index b98384d..d07dfe1 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -543,7 +543,8 @@ int drm_modeset_ctl(struct drm_device *dev, void *data,
 		    struct drm_file *file_priv)
 {
 	struct drm_modeset_ctl *modeset = data;
-	int crtc, ret = 0;
+	int ret = 0;
+	unsigned int crtc;
 
 	/* If drm_vblank_init() hasn't been called yet, just no-op */
 	if (!dev->num_crtcs)
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 66df0c3..49c724e 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -894,6 +894,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "AOpen i915GMm-HFS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+			DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 99915a6..8aa5d93 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -187,9 +187,9 @@ static int dp_link_clock_for_mode_clock(u8 dpcd[DP_DPCD_SIZE], int mode_clock)
 int dp_mode_valid(u8 dpcd[DP_DPCD_SIZE], int mode_clock)
 {
 	int lanes = dp_lanes_for_mode_clock(dpcd, mode_clock);
-	int bw = dp_lanes_for_mode_clock(dpcd, mode_clock);
+	int dp_clock = dp_link_clock_for_mode_clock(dpcd, mode_clock);
 
-	if ((lanes == 0) || (bw == 0))
+	if ((lanes == 0) || (dp_clock == 0))
 		return MODE_CLOCK_HIGH;
 
 	return MODE_OK;
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index e249933..61a5434 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -259,6 +259,13 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 			return false;
 	}
 
+	/* mac rv630, rv730, others */
+	if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+	    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+		*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+		*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
+	}
+
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x9598) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&
@@ -1480,7 +1487,7 @@ void radeon_atom_initialize_bios_scratch_regs(struct drm_device *dev)
 	bios_2_scratch &= ~ATOM_S2_VRI_BRIGHT_ENABLE;
 
 	/* tell the bios not to handle mode switching */
-	bios_6_scratch |= (ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH | ATOM_S6_ACC_MODE);
+	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;
 
 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
@@ -1531,10 +1538,13 @@ void radeon_atom_output_lock(struct drm_encoder *encoder, bool lock)
 	else
 		bios_6_scratch = RREG32(RADEON_BIOS_6_SCRATCH);
 
-	if (lock)
+	if (lock) {
 		bios_6_scratch |= ATOM_S6_CRITICAL_STATE;
-	else
+		bios_6_scratch &= ~ATOM_S6_ACC_MODE;
+	} else {
 		bios_6_scratch &= ~ATOM_S6_CRITICAL_STATE;
+		bios_6_scratch |= ATOM_S6_ACC_MODE;
+	}
 
 	if (rdev->family >= CHIP_R600)
 		WREG32(R600_BIOS_6_SCRATCH, bios_6_scratch);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 7e17a36..b6eb1e8 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -464,7 +464,7 @@ void radeon_compute_pll(struct radeon_pll *pll,
 		max_fractional_feed_div = pll->max_frac_feedback_div;
 	}
 
-	for (post_div = min_post_div; post_div <= max_post_div; ++post_div) {
+	for (post_div = max_post_div; post_div >= min_post_div; --post_div) {
 		uint32_t ref_div;
 
 		if ((pll->flags & RADEON_PLL_NO_ODD_POST_DIV) && (post_div & 1))
@@ -578,6 +578,10 @@ void radeon_compute_pll(struct radeon_pll *pll,
 	*frac_fb_div_p = best_frac_feedback_div;
 	*ref_div_p = best_ref_div;
 	*post_div_p = best_post_div;
+	DRM_DEBUG_KMS("%d %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
+		      freq, best_freq / 1000, best_feedback_div, best_frac_feedback_div,
+		      best_ref_div, best_post_div);
+
 }
 
 void radeon_compute_pll_avivo(struct radeon_pll *pll,
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index c7320ce..acbfa27 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -443,6 +443,43 @@ out_err:
 }
 
 /**
+ * Call bo::reserved and with the lru lock held.
+ * Will release GPU memory type usage on destruction.
+ * This is the place to put in driver specific hooks.
+ * Will release the bo::reserved lock and the
+ * lru lock on exit.
+ */
+
+static void ttm_bo_cleanup_memtype_use(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_global *glob = bo->glob;
+
+	if (bo->ttm) {
+
+		/**
+		 * Release the lru_lock, since we don't want to have
+		 * an atomic requirement on ttm_tt[unbind|destroy].
+		 */
+
+		spin_unlock(&glob->lru_lock);
+		ttm_tt_unbind(bo->ttm);
+		ttm_tt_destroy(bo->ttm);
+		bo->ttm = NULL;
+		spin_lock(&glob->lru_lock);
+	}
+
+	if (bo->mem.mm_node) {
+		drm_mm_put_block(bo->mem.mm_node);
+		bo->mem.mm_node = NULL;
+	}
+
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	spin_unlock(&glob->lru_lock);
+}
+
+
+/**
  * If bo idle, remove from delayed- and lru lists, and unref.
  * If not idle, and already on delayed list, do nothing.
  * If not idle, and not on delayed list, put on delayed list,
@@ -457,6 +494,7 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
 	int ret;
 
 	spin_lock(&bo->lock);
+retry:
 	(void) ttm_bo_wait(bo, false, false, !remove_all);
 
 	if (!bo->sync_obj) {
@@ -465,32 +503,52 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
 		spin_unlock(&bo->lock);
 
 		spin_lock(&glob->lru_lock);
-		put_count = ttm_bo_del_from_lru(bo);
+		ret = ttm_bo_reserve_locked(bo, false, !remove_all, false, 0);
+
+		/**
+		 * Someone else has the object reserved. Bail and retry.
+		 */
 
-		ret = ttm_bo_reserve_locked(bo, false, false, false, 0);
-		BUG_ON(ret);
-		if (bo->ttm)
-			ttm_tt_unbind(bo->ttm);
+		if (unlikely(ret == -EBUSY)) {
+			spin_unlock(&glob->lru_lock);
+			spin_lock(&bo->lock);
+			goto requeue;
+		}
+
+		/**
+		 * We can re-check for sync object without taking
+		 * the bo::lock since setting the sync object requires
+		 * also bo::reserved. A busy object at this point may
+		 * be caused by another thread starting an accelerated
+		 * eviction.
+		 */
+
+		if (unlikely(bo->sync_obj)) {
+			atomic_set(&bo->reserved, 0);
+			wake_up_all(&bo->event_queue);
+			spin_unlock(&glob->lru_lock);
+			spin_lock(&bo->lock);
+			if (remove_all)
+				goto retry;
+			else
+				goto requeue;
+		}
+
+		put_count = ttm_bo_del_from_lru(bo);
 
 		if (!list_empty(&bo->ddestroy)) {
 			list_del_init(&bo->ddestroy);
 			++put_count;
 		}
-		if (bo->mem.mm_node) {
-			bo->mem.mm_node->private = NULL;
-			drm_mm_put_block(bo->mem.mm_node);
-			bo->mem.mm_node = NULL;
-		}
-		spin_unlock(&glob->lru_lock);
 
-		atomic_set(&bo->reserved, 0);
+		ttm_bo_cleanup_memtype_use(bo);
 
 		while (put_count--)
 			kref_put(&bo->list_kref, ttm_bo_ref_bug);
 
 		return 0;
 	}
-
+requeue:
 	spin_lock(&glob->lru_lock);
 	if (list_empty(&bo->ddestroy)) {
 		void *sync_obj = bo->sync_obj;
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 5ca37a5..cf619c4 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -326,6 +326,7 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	INIT_LIST_HEAD(&fbo->lru);
 	INIT_LIST_HEAD(&fbo->swap);
 	fbo->vm_node = NULL;
+	atomic_set(&fbo->cpu_writers, 0);
 
 	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
 	if (fbo->mem.mm_node)
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index 65335b2..9975bbf 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -916,27 +916,27 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->index;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1026_data *data = i2c_get_clientdata(client);
-	int val, orig_div, new_div, shift;
+	int val, orig_div, new_div;
 
 	val = simple_strtol(buf, NULL, 10);
 	new_div = DIV_TO_REG(val);
-	if (new_div == 0) {
-		return -EINVAL;
-	}
+
 	mutex_lock(&data->update_lock);
 	orig_div = data->fan_div[nr];
 	data->fan_div[nr] = DIV_FROM_REG(new_div);
 
 	if (nr < 4) { /* 0 <= nr < 4 */
-		shift = 2 * nr;
 		adm1026_write_value(client, ADM1026_REG_FAN_DIV_0_3,
-			((DIV_TO_REG(orig_div) & (~(0x03 << shift))) |
-			(new_div << shift)));
+				    (DIV_TO_REG(data->fan_div[0]) << 0) |
+				    (DIV_TO_REG(data->fan_div[1]) << 2) |
+				    (DIV_TO_REG(data->fan_div[2]) << 4) |
+				    (DIV_TO_REG(data->fan_div[3]) << 6));
 	} else { /* 3 < nr < 8 */
-		shift = 2 * (nr - 4);
 		adm1026_write_value(client, ADM1026_REG_FAN_DIV_4_7,
-			((DIV_TO_REG(orig_div) & (~(0x03 << (2 * shift)))) |
-			(new_div << shift)));
+				    (DIV_TO_REG(data->fan_div[4]) << 0) |
+				    (DIV_TO_REG(data->fan_div[5]) << 2) |
+				    (DIV_TO_REG(data->fan_div[6]) << 4) |
+				    (DIV_TO_REG(data->fan_div[7]) << 6));
 	}
 
 	if (data->fan_div[nr] != orig_div) {
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index a95fa42..03f08b2 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2031,7 +2031,6 @@ static int f71882fg_remove(struct platform_device *pdev)
 	int nr_fans = (data->type == f71882fg) ? 4 : 3;
 	u8 start_reg = f71882fg_read8(data, F71882FG_REG_START);
 
-	platform_set_drvdata(pdev, NULL);
 	if (data->hwmon_dev)
 		hwmon_device_unregister(data->hwmon_dev);
 
@@ -2098,6 +2097,7 @@ static int f71882fg_remove(struct platform_device *pdev)
 		}
 	}
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index b3841a6..2e8f0c9 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1259,6 +1259,7 @@ static int lm85_probe(struct i2c_client *client,
 	switch (data->type) {
 	case adm1027:
 	case adt7463:
+	case adt7468:
 	case emc6d100:
 	case emc6d102:
 		data->freq_map = adm1027_freq_map;
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index f397ce7..b2074e3 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -687,6 +687,13 @@ static int __devexit via686a_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void via686a_update_fan_div(struct via686a_data *data)
+{
+	int reg = via686a_read_value(data, VIA686A_REG_FANDIV);
+	data->fan_div[0] = (reg >> 4) & 0x03;
+	data->fan_div[1] = reg >> 6;
+}
+
 static void __devinit via686a_init_device(struct via686a_data *data)
 {
 	u8 reg;
@@ -700,6 +707,9 @@ static void __devinit via686a_init_device(struct via686a_data *data)
 	via686a_write_value(data, VIA686A_REG_TEMP_MODE,
 			    (reg & ~VIA686A_TEMP_MODE_MASK)
 			    | VIA686A_TEMP_MODE_CONTINUOUS);
+
+	/* Pre-read fan clock divisor values */
+	via686a_update_fan_div(data);
 }
 
 static struct via686a_data *via686a_update_device(struct device *dev)
@@ -751,9 +761,7 @@ static struct via686a_data *via686a_update_device(struct device *dev)
 		    (via686a_read_value(data, VIA686A_REG_TEMP_LOW23) &
 		     0xc0) >> 6;
 
-		i = via686a_read_value(data, VIA686A_REG_FANDIV);
-		data->fan_div[0] = (i >> 4) & 0x03;
-		data->fan_div[1] = i >> 6;
+		via686a_update_fan_div(data);
 		data->alarms =
 		    via686a_read_value(data,
 				       VIA686A_REG_ALARM1) |
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 855911eb..f5cd97c 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -782,6 +782,14 @@ static int i2c_do_del_adapter(struct i2c_driver *driver,
 static int __unregister_client(struct device *dev, void *dummy)
 {
 	struct i2c_client *client = i2c_verify_client(dev);
+	if (client && strcmp(client->name, "dummy"))
+		i2c_unregister_device(client);
+	return 0;
+}
+
+static int __unregister_dummy(struct device *dev, void *dummy)
+{
+	struct i2c_client *client = i2c_verify_client(dev);
 	if (client)
 		i2c_unregister_device(client);
 	return 0;
@@ -835,8 +843,12 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	}
 
 	/* Detach any active clients. This can't fail, thus we do not
-	   checking the returned value. */
+	 * check the returned value. This is a two-pass process, because
+	 * we can't remove the dummy devices during the first pass: they
+	 * could have been instantiated by real devices wishing to clean
+	 * them up properly, so we give them a chance to do that first. */
 	res = device_for_each_child(&adap->dev, NULL, __unregister_client);
+	res = device_for_each_child(&adap->dev, NULL, __unregister_dummy);
 
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_remove_link(i2c_adapter_compat_class, &adap->dev,
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5130fc5..a5dea6b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2986,6 +2986,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 		goto out; /* No match. */
 	}
 	atomic_inc(&cur_cm_id_priv->refcount);
+	atomic_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 875e34e..c84b0b1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1136,6 +1136,11 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	cm_id->context = conn_id;
 	cm_id->cm_handler = cma_ib_handler;
 
+	/*
+	 * Protect against the user destroying conn_id from another thread
+	 * until we're done accessing it.
+	 */
+	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (!ret) {
 		/*
@@ -1148,8 +1153,10 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		mutex_unlock(&lock);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		goto out;
 	}
+	cma_deref_id(conn_id);
 
 	/* Destroy the CM ID by returning a non-zero value. */
 	conn_id->cm_id.ib = NULL;
@@ -1351,17 +1358,25 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	event.param.conn.private_data_len = iw_event->private_data_len;
 	event.param.conn.initiator_depth = attr.max_qp_init_rd_atom;
 	event.param.conn.responder_resources = attr.max_qp_rd_atom;
+
+	/*
+	 * Protect against the user destroying conn_id from another thread
+	 * until we're done accessing it.
+	 */
+	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret) {
 		/* User wants to destroy the CM ID */
 		conn_id->cm_id.iw = NULL;
 		cma_exch(conn_id, CMA_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		rdma_destroy_id(&conn_id->id);
 		goto out;
 	}
 
 	mutex_unlock(&conn_id->handler_mutex);
+	cma_deref_id(conn_id);
 
 out:
 	if (dev)
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 112d397..948d6f6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -875,68 +875,81 @@ out:
 	return ret ? ret : in_len;
 }
 
+static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
+{
+	struct ib_uverbs_wc tmp;
+
+	tmp.wr_id		= wc->wr_id;
+	tmp.status		= wc->status;
+	tmp.opcode		= wc->opcode;
+	tmp.vendor_err		= wc->vendor_err;
+	tmp.byte_len		= wc->byte_len;
+	tmp.ex.imm_data		= (__u32 __force) wc->ex.imm_data;
+	tmp.qp_num		= wc->qp->qp_num;
+	tmp.src_qp		= wc->src_qp;
+	tmp.wc_flags		= wc->wc_flags;
+	tmp.pkey_index		= wc->pkey_index;
+	tmp.slid		= wc->slid;
+	tmp.sl			= wc->sl;
+	tmp.dlid_path_bits	= wc->dlid_path_bits;
+	tmp.port_num		= wc->port_num;
+	tmp.reserved		= 0;
+
+	if (copy_to_user(dest, &tmp, sizeof tmp))
+		return -EFAULT;
+
+	return 0;
+}
+
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 			  const char __user *buf, int in_len,
 			  int out_len)
 {
 	struct ib_uverbs_poll_cq       cmd;
-	struct ib_uverbs_poll_cq_resp *resp;
+	struct ib_uverbs_poll_cq_resp  resp;
+	u8 __user                     *header_ptr;
+	u8 __user                     *data_ptr;
 	struct ib_cq                  *cq;
-	struct ib_wc                  *wc;
-	int                            ret = 0;
-	int                            i;
-	int                            rsize;
+	struct ib_wc                   wc;
+	int                            ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	wc = kmalloc(cmd.ne * sizeof *wc, GFP_KERNEL);
-	if (!wc)
-		return -ENOMEM;
-
-	rsize = sizeof *resp + cmd.ne * sizeof(struct ib_uverbs_wc);
-	resp = kmalloc(rsize, GFP_KERNEL);
-	if (!resp) {
-		ret = -ENOMEM;
-		goto out_wc;
-	}
-
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
-	if (!cq) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!cq)
+		return -EINVAL;
 
-	resp->count = ib_poll_cq(cq, cmd.ne, wc);
+	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
+	header_ptr = (void __user *)(unsigned long) cmd.response;
+	data_ptr = header_ptr + sizeof resp;
 
-	put_cq_read(cq);
+	memset(&resp, 0, sizeof resp);
+	while (resp.count < cmd.ne) {
+		ret = ib_poll_cq(cq, 1, &wc);
+		if (ret < 0)
+			goto out_put;
+		if (!ret)
+			break;
+
+		ret = copy_wc_to_user(data_ptr, &wc);
+		if (ret)
+			goto out_put;
 
-	for (i = 0; i < resp->count; i++) {
-		resp->wc[i].wr_id 	   = wc[i].wr_id;
-		resp->wc[i].status 	   = wc[i].status;
-		resp->wc[i].opcode 	   = wc[i].opcode;
-		resp->wc[i].vendor_err 	   = wc[i].vendor_err;
-		resp->wc[i].byte_len 	   = wc[i].byte_len;
-		resp->wc[i].ex.imm_data    = (__u32 __force) wc[i].ex.imm_data;
-		resp->wc[i].qp_num 	   = wc[i].qp->qp_num;
-		resp->wc[i].src_qp 	   = wc[i].src_qp;
-		resp->wc[i].wc_flags 	   = wc[i].wc_flags;
-		resp->wc[i].pkey_index 	   = wc[i].pkey_index;
-		resp->wc[i].slid 	   = wc[i].slid;
-		resp->wc[i].sl 		   = wc[i].sl;
-		resp->wc[i].dlid_path_bits = wc[i].dlid_path_bits;
-		resp->wc[i].port_num 	   = wc[i].port_num;
+		data_ptr += sizeof(struct ib_uverbs_wc);
+		++resp.count;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp, rsize))
+	if (copy_to_user(header_ptr, &resp, sizeof resp)) {
 		ret = -EFAULT;
+		goto out_put;
+	}
 
-out:
-	kfree(resp);
+	ret = in_len;
 
-out_wc:
-	kfree(wc);
-	return ret ? ret : in_len;
+out_put:
+	put_cq_read(cq);
+	return ret;
 }
 
 ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 66b4135..675fc04 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -486,7 +486,8 @@ static int send_connect(struct iwch_ep *ep)
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 	skb->priority = CPL_PRIORITY_SETUP;
 	set_arp_failure_handler(skb, act_open_req_arp_failure);
 
@@ -1303,7 +1304,8 @@ static void accept_cr(struct iwch_ep *ep, __be32 peer_ip, struct sk_buff *skb)
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 
 	rpl = cplhdr(skb);
 	rpl->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index b1bd6dd..93c60e0 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -481,6 +481,9 @@ static int joydev_handle_JSIOCSAXMAP(struct joydev *joydev,
 
 	memcpy(joydev->abspam, abspam, len);
 
+	for (i = 0; i < joydev->nabs; i++)
+		joydev->absmap[joydev->abspam[i]] = i;
+
  out:
 	kfree(abspam);
 	return retval;
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 4f8fe08..2284567 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -55,6 +55,14 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
+/* MacbookAir3,2 (unibody), aka wellspring5 */
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI	0x023f
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_ISO	0x0240
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_JIS	0x0241
+/* MacbookAir3,1 (unibody), aka wellspring4 */
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI	0x0242
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO	0x0243
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS	0x0244
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -80,6 +88,14 @@ static const struct usb_device_id bcm5974_table[] = {
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
+	/* MacbookAir3,2 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_JIS),
+	/* MacbookAir3,1 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -234,6 +250,30 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		{ DIM_X, DIM_X / SN_COORD, -4460, 5166 },
 		{ DIM_Y, DIM_Y / SN_COORD, -75, 6700 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING4_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING4_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
+		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
+	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4616, 5112 },
+		{ DIM_Y, DIM_Y / SN_COORD, -142, 5234 }
+	},
 	{}
 };
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 4fab18d..16e45b7 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -800,6 +800,16 @@ static void closecard(int cardnr)
 	ll_unload(csta);
 }
 
+static irqreturn_t card_irq(int intno, void *dev_id)
+{
+	struct IsdnCardState *cs = dev_id;
+	irqreturn_t ret = cs->irq_func(intno, cs);
+
+	if (ret == IRQ_HANDLED)
+		cs->irq_cnt++;
+	return ret;
+}
+
 static int init_card(struct IsdnCardState *cs)
 {
 	int 	irq_cnt, cnt = 3, ret;
@@ -808,10 +818,10 @@ static int init_card(struct IsdnCardState *cs)
 		ret = cs->cardmsg(cs, CARD_INIT, NULL);
 		return(ret);
 	}
-	irq_cnt = kstat_irqs(cs->irq);
+	irq_cnt = cs->irq_cnt = 0;
 	printk(KERN_INFO "%s: IRQ %d count %d\n", CardType[cs->typ],
 	       cs->irq, irq_cnt);
-	if (request_irq(cs->irq, cs->irq_func, cs->irq_flags, "HiSax", cs)) {
+	if (request_irq(cs->irq, card_irq, cs->irq_flags, "HiSax", cs)) {
 		printk(KERN_WARNING "HiSax: couldn't get interrupt %d\n",
 		       cs->irq);
 		return 1;
@@ -821,8 +831,8 @@ static int init_card(struct IsdnCardState *cs)
 		/* Timeout 10ms */
 		msleep(10);
 		printk(KERN_INFO "%s: IRQ %d count %d\n",
-		       CardType[cs->typ], cs->irq, kstat_irqs(cs->irq));
-		if (kstat_irqs(cs->irq) == irq_cnt) {
+		       CardType[cs->typ], cs->irq, cs->irq_cnt);
+		if (cs->irq_cnt == irq_cnt) {
 			printk(KERN_WARNING
 			       "%s: IRQ(%d) getting no interrupts during init %d\n",
 			       CardType[cs->typ], cs->irq, 4 - cnt);
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 0685c19..85cf420 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -959,6 +959,7 @@ struct IsdnCardState {
 	u_long		event;
 	struct work_struct tqueue;
 	struct timer_list dbusytimer;
+	unsigned int	irq_cnt;
 #ifdef ERROR_STATISTIC
 	int		err_crc;
 	int		err_tx;
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 2881a66..9f65c9c 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -2635,12 +2635,6 @@ isdn_tty_modem_result(int code, modem_info * info)
 		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
 			return;
 		}
-#ifdef CONFIG_ISDN_AUDIO
-		if ( !info->vonline )
-			tty_ldisc_flush(info->tty);
-#else
-		tty_ldisc_flush(info->tty);
-#endif
 		if ((info->flags & ISDN_ASYNC_CHECK_CD) &&
 		    (!((info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
 		       (info->flags & ISDN_ASYNC_CALLOUT_NOHUP)))) {
diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 97f0498..fdb8c81 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -102,6 +102,7 @@ static struct dmi_system_id __initdata nas_led_whitelist[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
 		}
 	},
+	{}
 };
 
 /*
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e81345a..d43e186 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -33,7 +33,6 @@ struct pgpath {
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
-	struct work_struct deactivate_path;
 	struct work_struct activate_path;
 };
 
@@ -117,7 +116,6 @@ static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
-static void deactivate_path(struct work_struct *work);
 
 
 /*-----------------------------------------------
@@ -130,7 +128,6 @@ static struct pgpath *alloc_pgpath(void)
 
 	if (pgpath) {
 		pgpath->is_active = 1;
-		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
 		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
@@ -142,14 +139,6 @@ static void free_pgpath(struct pgpath *pgpath)
 	kfree(pgpath);
 }
 
-static void deactivate_path(struct work_struct *work)
-{
-	struct pgpath *pgpath =
-		container_of(work, struct pgpath, deactivate_path);
-
-	blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
-}
-
 static struct priority_group *alloc_priority_group(void)
 {
 	struct priority_group *pg;
@@ -958,7 +947,6 @@ static int fail_path(struct pgpath *pgpath)
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
-	queue_work(kmultipathd, &pgpath->deactivate_path);
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fe8889e..2e41d5e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2039,13 +2039,14 @@ static void event_callback(void *context)
 	wake_up(&md->eventq);
 }
 
+/*
+ * Protected by md->suspend_lock obtained by dm_swap_table().
+ */
 static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
 /*
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ec10d74..3512dd8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -409,6 +409,9 @@ static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
 
+	if (unit && MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1<<MdpMinorShift)-1);
+
  retry:
 	spin_lock(&all_mddevs_lock);
 
@@ -1255,7 +1258,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 
@@ -1617,7 +1620,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 static struct super_type super_types[] = {
@@ -5004,17 +5007,21 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		/* set save_raid_disk if appropriate */
+		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
-			    info->raid_disk < mddev->raid_disks)
+			    info->raid_disk < mddev->raid_disks) {
 				rdev->raid_disk = info->raid_disk;
-			else
+				set_bit(In_sync, &rdev->flags);
+			} else
 				rdev->raid_disk = -1;
 		} else
 			super_types[mddev->major_version].
 				validate_super(mddev, rdev);
-		rdev->saved_raid_disk = rdev->raid_disk;
+		if (test_bit(In_sync, &rdev->flags))
+			rdev->saved_raid_disk = rdev->raid_disk;
+		else
+			rdev->saved_raid_disk = -1;
 
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index db2de5a..5515453 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1196,6 +1196,7 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    !mddev->recovery_disabled &&
 		    mddev->degraded < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 44972d0..2b381a4 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1271,6 +1271,23 @@ static int dib7070p_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
+static int stk7700p_pid_filter(struct dvb_usb_adapter *adapter, int index,
+		u16 pid, int onoff)
+{
+	struct dib0700_state *st = adapter->dev->priv;
+	if (st->is_dib7000pc)
+		return dib7000p_pid_filter(adapter->fe, index, pid, onoff);
+	return dib7000m_pid_filter(adapter->fe, index, pid, onoff);
+}
+
+static int stk7700p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
+{
+	struct dib0700_state *st = adapter->dev->priv;
+	if (st->is_dib7000pc)
+		return dib7000p_pid_filter_ctrl(adapter->fe, onoff);
+	return dib7000m_pid_filter_ctrl(adapter->fe, onoff);
+}
+
 static int stk70x0p_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff)
 {
     return dib7000p_pid_filter(adapter->fe, index, pid, onoff);
@@ -2223,8 +2240,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
-				.pid_filter       = stk70x0p_pid_filter,
-				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
+				.pid_filter       = stk7700p_pid_filter,
+				.pid_filter_ctrl  = stk7700p_pid_filter_ctrl,
 				.frontend_attach  = stk7700p_frontend_attach,
 				.tuner_attach     = stk7700p_tuner_attach,
 
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index 0109720..7c48c5f 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1284,6 +1284,25 @@ struct i2c_adapter * dib7000m_get_i2c_master(struct dvb_frontend *demod, enum di
 }
 EXPORT_SYMBOL(dib7000m_get_i2c_master);
 
+int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
+{
+	struct dib7000m_state *state = fe->demodulator_priv;
+	u16 val = dib7000m_read_word(state, 294 + state->reg_offs) & 0xffef;
+	val |= (onoff & 0x1) << 4;
+	dprintk("PID filter enabled %d", onoff);
+	return dib7000m_write_word(state, 294 + state->reg_offs, val);
+}
+EXPORT_SYMBOL(dib7000m_pid_filter_ctrl);
+
+int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
+{
+	struct dib7000m_state *state = fe->demodulator_priv;
+	dprintk("PID filter: index %x, PID %d, OnOff %d", id, pid, onoff);
+	return dib7000m_write_word(state, 300 + state->reg_offs + id,
+			onoff ? (1 << 13) | pid : 0);
+}
+EXPORT_SYMBOL(dib7000m_pid_filter);
+
 #if 0
 /* used with some prototype boards */
 int dib7000m_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
diff --git a/drivers/media/dvb/frontends/dib7000m.h b/drivers/media/dvb/frontends/dib7000m.h
index 113819c..81fcf22 100644
--- a/drivers/media/dvb/frontends/dib7000m.h
+++ b/drivers/media/dvb/frontends/dib7000m.h
@@ -46,6 +46,8 @@ extern struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
 extern struct i2c_adapter *dib7000m_get_i2c_master(struct dvb_frontend *,
 						   enum dibx000_i2c_interface,
 						   int);
+extern int dib7000m_pid_filter(struct dvb_frontend *, u8 id, u16 pid, u8 onoff);
+extern int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff);
 #else
 static inline
 struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
@@ -63,6 +65,19 @@ struct i2c_adapter *dib7000m_get_i2c_master(struct dvb_frontend *demod,
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+static inline int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id,
+						u16 pid, u8 onoff)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
+
+static inline int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe,
+						uint8_t onoff)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
 #endif
 
 /* TODO
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index c7a65b1..c878dad 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -277,7 +277,7 @@ static int dvb_ca_ioctl(struct inode *inode, struct file *file,
 	{
 		ca_slot_info_t *info=(ca_slot_info_t *)parg;
 
-		if (info->num > 1)
+		if (info->num < 0 || info->num > 1)
 			return -EINVAL;
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 5bf4985..a91642c 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -31,7 +31,7 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
-#include <linux/delay.h>	/* udelay			*/
+#include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
@@ -71,27 +71,17 @@ static struct rtrack rtrack_card;
 
 /* local things */
 
-static void sleep_delay(long n)
-{
-	/* Sleep nicely for 'n' uS */
-	int d = n / msecs_to_jiffies(1000);
-	if (!d)
-		udelay(n);
-	else
-		msleep(jiffies_to_msecs(d));
-}
-
 static void rt_decvol(struct rtrack *rt)
 {
 	outb(0x58, rt->io);		/* volume down + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, rt->io);		/* volume steady + sigstr + on	*/
 }
 
 static void rt_incvol(struct rtrack *rt)
 {
 	outb(0x98, rt->io);		/* volume up + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, rt->io);		/* volume steady + sigstr + on	*/
 }
 
@@ -120,7 +110,7 @@ static int rt_setvol(struct rtrack *rt, int vol)
 
 	if (vol == 0) {			/* volume = 0 means mute the card */
 		outb(0x48, rt->io);	/* volume down but still "on"	*/
-		sleep_delay(2000000);	/* make sure it's totally down	*/
+		msleep(2000);	/* make sure it's totally down	*/
 		outb(0xd0, rt->io);	/* volume steady, off		*/
 		rt->curvol = 0;		/* track the volume state!	*/
 		mutex_unlock(&rt->lock);
@@ -155,7 +145,7 @@ static void send_0_byte(struct rtrack *rt)
 		outb_p(128+64+16+8+  1, rt->io);  /* on + wr-enable + data low */
 		outb_p(128+64+16+8+2+1, rt->io);  /* clock */
 	}
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static void send_1_byte(struct rtrack *rt)
@@ -169,7 +159,7 @@ static void send_1_byte(struct rtrack *rt)
 		outb_p(128+64+16+8+4+2+1, rt->io); /* clock */
 	}
 
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static int rt_setfreq(struct rtrack *rt, unsigned long freq)
@@ -427,7 +417,7 @@ static int __init rtrack_init(void)
 
 	/* this ensures that the volume is all the way down  */
 	outb(0x48, rt->io);		/* volume down but still "on"	*/
-	sleep_delay(2000000);	/* make sure it's totally down	*/
+	msleep(2000);	/* make sure it's totally down	*/
 	outb(0xc0, rt->io);		/* steady volume, mute card	*/
 
 	return 0;
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index a549082..dd2a275 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -225,14 +225,16 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 		     dev->board.name, dev->model);
 
 	/* set the direction for GPIO pins */
-	cx231xx_set_gpio_direction(dev, dev->board.tuner_gpio->bit, 1);
-	cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit, 1);
-	cx231xx_set_gpio_direction(dev, dev->board.tuner_sif_gpio, 1);
+	if (dev->board.tuner_gpio) {
+		cx231xx_set_gpio_direction(dev, dev->board.tuner_gpio->bit, 1);
+		cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit, 1);
+		cx231xx_set_gpio_direction(dev, dev->board.tuner_sif_gpio, 1);
 
-	/* request some modules if any required */
+		/* request some modules if any required */
 
-	/* reset the Tuner */
-	cx231xx_gpio_set(dev, dev->board.tuner_gpio);
+		/* reset the Tuner */
+		cx231xx_gpio_set(dev, dev->board.tuner_gpio);
+	}
 
 	/* set the mode to Analog mode initially */
 	cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 2510000..2d9c4d4 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1554,11 +1554,11 @@ struct em28xx_board em28xx_boards[] = {
 		.input           = { {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = SAA7115_COMPOSITE0,
-			.amux     = EM28XX_AMUX_VIDEO2,
+			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = SAA7115_SVIDEO3,
-			.amux     = EM28XX_AMUX_VIDEO2,
+			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
 	[EM2860_BOARD_TERRATEC_AV350] = {
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index fa6bb85..6b61bb6 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -457,6 +457,8 @@ static int ivtvfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long ar
 			struct fb_vblank vblank;
 			u32 trace;
 
+			memset(&vblank, 0, sizeof(struct fb_vblank));
+
 			vblank.flags = FB_VBLANK_HAVE_COUNT |FB_VBLANK_HAVE_VCOUNT |
 					FB_VBLANK_HAVE_VSYNC;
 			trace = read_reg(0x028c0) >> 16;
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index c4150bd..dac1387 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -193,17 +193,24 @@ static int put_video_window32(struct video_window *kp, struct video_window32 __u
 struct video_code32 {
 	char		loadwhat[16];	/* name or tag of file being passed */
 	compat_int_t	datasize;
-	unsigned char	*data;
+	compat_uptr_t	data;
 };
 
-static int get_microcode32(struct video_code *kp, struct video_code32 __user *up)
+static struct video_code __user *get_microcode32(struct video_code32 *kp)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct video_code32)) ||
-		copy_from_user(kp->loadwhat, up->loadwhat, sizeof(up->loadwhat)) ||
-		get_user(kp->datasize, &up->datasize) ||
-		copy_from_user(kp->data, up->data, up->datasize))
-			return -EFAULT;
-	return 0;
+	struct video_code __user *up;
+
+	up = compat_alloc_user_space(sizeof(*up));
+
+	/*
+	 * NOTE! We don't actually care if these fail. If the
+	 * user address is invalid, the native ioctl will do
+	 * the error handling for us
+	 */
+	(void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
+	(void) put_user(kp->datasize, &up->datasize);
+	(void) put_user(compat_ptr(kp->data), &up->data);
+	return up;
 }
 
 #define VIDIOCGTUNER32		_IOWR('v', 4, struct video_tuner32)
@@ -741,7 +748,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		struct video_tuner vt;
 		struct video_buffer vb;
 		struct video_window vw;
-		struct video_code vc;
+		struct video_code32 vc;
 		struct video_audio va;
 #endif
 		struct v4l2_format v2f;
@@ -820,8 +827,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		break;
 
 	case VIDIOCSMICROCODE:
-		err = get_microcode32(&karg.vc, up);
-		compatible_arg = 0;
+		/* Copy the 32-bit "video_code32" to kernel space */
+		if (copy_from_user(&karg.vc, up, sizeof(karg.vc)))
+			return -EFAULT;
+		/* Convert the 32-bit version to a 64-bit version in user space */
+		up = get_microcode32(&karg.vc);
 		break;
 
 	case VIDIOCSFREQ:
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 352acd0..8c85632 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -577,6 +577,13 @@ mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 }
 
 static int
+mptctl_release(struct inode *inode, struct file *filep)
+{
+	fasync_helper(-1, filep, 0, &async_queue);
+	return 0;
+}
+
+static int
 mptctl_fasync(int fd, struct file *filep, int mode)
 {
 	MPT_ADAPTER	*ioc;
@@ -2778,6 +2785,7 @@ static const struct file_operations mptctl_fops = {
 	.llseek =	no_llseek,
 	.fasync = 	mptctl_fasync,
 	.unlocked_ioctl = mptctl_ioctl,
+	.release =	mptctl_release,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_mpctl_ioctl,
 #endif
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 81279b3..fc18db9 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1835,8 +1835,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	}
 
  out:
-	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
+	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p) (sn=%ld)\n",
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), retval,
+	    SCpnt, SCpnt->serial_number);
 
 	return retval;
 }
@@ -1873,7 +1874,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		retval = SUCCESS;
+		retval = 0;
 		goto out;
 	}
 
@@ -2444,6 +2445,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
 		sdev->ordered_tags));
 
+	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
+
 	return 0;
 }
 
diff --git a/drivers/mfd/ucb1x00-ts.c b/drivers/mfd/ucb1x00-ts.c
index 000cb41..92b85e2 100644
--- a/drivers/mfd/ucb1x00-ts.c
+++ b/drivers/mfd/ucb1x00-ts.c
@@ -385,12 +385,18 @@ static int ucb1x00_ts_add(struct ucb1x00_dev *dev)
 	idev->close      = ucb1x00_ts_close;
 
 	__set_bit(EV_ABS, idev->evbit);
-	__set_bit(ABS_X, idev->absbit);
-	__set_bit(ABS_Y, idev->absbit);
-	__set_bit(ABS_PRESSURE, idev->absbit);
 
 	input_set_drvdata(idev, ts);
 
+	ucb1x00_adc_enable(ts->ucb);
+	ts->x_res = ucb1x00_ts_read_xres(ts);
+	ts->y_res = ucb1x00_ts_read_yres(ts);
+	ucb1x00_adc_disable(ts->ucb);
+
+	input_set_abs_params(idev, ABS_X, 0, ts->x_res, 0, 0);
+	input_set_abs_params(idev, ABS_Y, 0, ts->y_res, 0, 0);
+	input_set_abs_params(idev, ABS_PRESSURE, 0, 0, 0, 0);
+
 	err = input_register_device(idev);
 	if (err)
 		goto fail;
diff --git a/drivers/misc/sgi-xp/xpc_partition.c b/drivers/misc/sgi-xp/xpc_partition.c
index 9a6268c..2ac2fda 100644
--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
@@ -438,18 +438,23 @@ xpc_discovery(void)
 	 * nodes that can comprise an access protection grouping. The access
 	 * protection is in regards to memory, IOI and IPI.
 	 */
-	max_regions = 64;
 	region_size = xp_region_size;
 
-	switch (region_size) {
-	case 128:
-		max_regions *= 2;
-	case 64:
-		max_regions *= 2;
-	case 32:
-		max_regions *= 2;
-		region_size = 16;
-		DBUG_ON(!is_shub2());
+	if (is_uv())
+		max_regions = 256;
+	else {
+		max_regions = 64;
+
+		switch (region_size) {
+		case 128:
+			max_regions *= 2;
+		case 64:
+			max_regions *= 2;
+		case 32:
+			max_regions *= 2;
+			region_size = 16;
+			DBUG_ON(!is_shub2());
+		}
 	}
 
 	for (region = 0; region < max_regions; region++) {
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 8725d5e..143fa0e 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -416,6 +416,7 @@ xpc_process_activate_IRQ_rcvd_uv(void)
 static void
 xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 			      struct xpc_activate_mq_msghdr_uv *msg_hdr,
+			      int part_setup,
 			      int *wakeup_hb_checker)
 {
 	unsigned long irq_flags;
@@ -480,6 +481,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closerequest_uv,
 				   hdr);
@@ -496,6 +500,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closereply_uv,
 				   hdr);
@@ -510,6 +517,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openrequest_uv,
 				   hdr);
@@ -527,6 +537,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openreply_uv, hdr);
 		args = &part->remote_openclose_args[msg->ch_number];
@@ -544,6 +557,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV: {
 		struct xpc_activate_mq_msg_chctl_opencomplete_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				xpc_activate_mq_msg_chctl_opencomplete_uv, hdr);
 		spin_lock_irqsave(&part->chctl_lock, irq_flags);
@@ -620,6 +636,7 @@ xpc_handle_activate_IRQ_uv(int irq, void *dev_id)
 
 			part_referenced = xpc_part_ref(part);
 			xpc_handle_activate_mq_msg_uv(part, msg_hdr,
+						      part_referenced,
 						      &wakeup_hb_checker);
 			if (part_referenced)
 				xpc_part_deref(part);
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 676cd0c..14c5480 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -379,8 +379,10 @@ static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
 	sdhci_remove_host(host, 1);
 
 	for (ptr = 0; ptr < 3; ptr++) {
-		clk_disable(sc->clk_bus[ptr]);
-		clk_put(sc->clk_bus[ptr]);
+		if (sc->clk_bus[ptr]) {
+			clk_disable(sc->clk_bus[ptr]);
+			clk_put(sc->clk_bus[ptr]);
+		}
 	}
 	clk_disable(sc->clk_io);
 	clk_put(sc->clk_io);
diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 1bec5e1..35a00b7 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1923,14 +1923,14 @@ static void jedec_reset(u32 base, struct map_info *map, struct cfi_private *cfi)
 }
 
 
-static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
+static int cfi_jedec_setup(struct cfi_private *cfi, int index)
 {
 	int i,num_erase_regions;
 	uint8_t uaddr;
 
-	if (! (jedec_table[index].devtypes & p_cfi->device_type)) {
+	if (!(jedec_table[index].devtypes & cfi->device_type)) {
 		DEBUG(MTD_DEBUG_LEVEL1, "Rejecting potential %s with incompatible %d-bit device type\n",
-		      jedec_table[index].name, 4 * (1<<p_cfi->device_type));
+		      jedec_table[index].name, 4 * (1<<cfi->device_type));
 		return 0;
 	}
 
@@ -1938,27 +1938,27 @@ static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
 
 	num_erase_regions = jedec_table[index].nr_regions;
 
-	p_cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
-	if (!p_cfi->cfiq) {
+	cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
+	if (!cfi->cfiq) {
 		//xx printk(KERN_WARNING "%s: kmalloc failed for CFI ident structure\n", map->name);
 		return 0;
 	}
 
-	memset(p_cfi->cfiq,0,sizeof(struct cfi_ident));
+	memset(cfi->cfiq, 0, sizeof(struct cfi_ident));
 
-	p_cfi->cfiq->P_ID = jedec_table[index].cmd_set;
-	p_cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
-	p_cfi->cfiq->DevSize = jedec_table[index].dev_size;
-	p_cfi->cfi_mode = CFI_MODE_JEDEC;
+	cfi->cfiq->P_ID = jedec_table[index].cmd_set;
+	cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
+	cfi->cfiq->DevSize = jedec_table[index].dev_size;
+	cfi->cfi_mode = CFI_MODE_JEDEC;
 
 	for (i=0; i<num_erase_regions; i++){
-		p_cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
+		cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
 	}
-	p_cfi->cmdset_priv = NULL;
+	cfi->cmdset_priv = NULL;
 
 	/* This may be redundant for some cases, but it doesn't hurt */
-	p_cfi->mfr = jedec_table[index].mfr_id;
-	p_cfi->id = jedec_table[index].dev_id;
+	cfi->mfr = jedec_table[index].mfr_id;
+	cfi->id = jedec_table[index].dev_id;
 
 	uaddr = jedec_table[index].uaddr;
 
@@ -1966,8 +1966,8 @@ static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
 	   our brains explode when we see the datasheets talking about address
 	   lines numbered from A-1 to A18. The CFI table has unlock addresses
 	   in device-words according to the mode the device is connected in */
-	p_cfi->addr_unlock1 = unlock_addrs[uaddr].addr1 / p_cfi->device_type;
-	p_cfi->addr_unlock2 = unlock_addrs[uaddr].addr2 / p_cfi->device_type;
+	cfi->addr_unlock1 = unlock_addrs[uaddr].addr1 / cfi->device_type;
+	cfi->addr_unlock2 = unlock_addrs[uaddr].addr2 / cfi->device_type;
 
 	return 1; 	/* ok */
 }
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 1bb799f..7e12917 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1099,6 +1099,6 @@ static void __exit omap_nand_exit(void)
 module_init(omap_nand_init);
 module_exit(omap_nand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Glue layer for NAND flash on TI OMAP boards");
diff --git a/drivers/mtd/onenand/generic.c b/drivers/mtd/onenand/generic.c
index e789149..ac08750 100644
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -131,7 +131,7 @@ static struct platform_driver generic_onenand_driver = {
 	.remove		= __devexit_p(generic_onenand_remove),
 };
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 
 static int __init generic_onenand_init(void)
 {
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index 75f38b9..2797a66 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -814,7 +814,7 @@ static void __exit omap2_onenand_exit(void)
 module_init(omap2_onenand_init);
 module_exit(omap2_onenand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarkko Lavinen <jarkko.lavinen@nokia.com>");
 MODULE_DESCRIPTION("Glue layer for OneNAND flash on OMAP2 / OMAP3");
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index b6cf326..8341575 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2849,10 +2849,11 @@ static int atl1_resume(struct pci_dev *pdev)
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
 	atl1_reset_hw(&adapter->hw);
-	adapter->cmb.cmb->int_stats = 0;
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		adapter->cmb.cmb->int_stats = 0;
 		atl1_up(adapter);
+	}
 	netif_device_attach(netdev);
 
 	return 0;
diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 4869adb..137cb03 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2175,8 +2175,6 @@ static int __devinit b44_init_one(struct ssb_device *sdev,
 	dev->irq = sdev->irq;
 	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
 
-	netif_carrier_off(dev);
-
 	err = ssb_bus_powerup(sdev->bus, 0);
 	if (err) {
 		dev_err(sdev->dev,
@@ -2216,6 +2214,8 @@ static int __devinit b44_init_one(struct ssb_device *sdev,
 		goto err_out_powerdown;
 	}
 
+	netif_carrier_off(dev);
+
 	ssb_set_drvdata(sdev, dev);
 
 	/* Chip reset provides power to the b44 MAC & PCI cores, which
diff --git a/drivers/net/benet/be.h b/drivers/net/benet/be.h
index 5bc7459..8c68512 100644
--- a/drivers/net/benet/be.h
+++ b/drivers/net/benet/be.h
@@ -165,6 +165,7 @@ struct be_drvr_stats {
 	ulong be_tx_jiffies;
 	u64 be_tx_bytes;
 	u64 be_tx_bytes_prev;
+	u64 be_tx_pkts;
 	u32 be_tx_rate;
 
 	u32 cache_barrier[16];
@@ -176,6 +177,7 @@ struct be_drvr_stats {
 	ulong be_rx_jiffies;
 	u64 be_rx_bytes;
 	u64 be_rx_bytes_prev;
+	u64 be_rx_pkts;
 	u32 be_rx_rate;
 	/* number of non ether type II frames dropped where
 	 * frame len > length field of Mac Hdr */
diff --git a/drivers/net/benet/be_main.c b/drivers/net/benet/be_main.c
index 626b76c..e48bee6 100644
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -149,13 +149,10 @@ void netdev_stats_update(struct be_adapter *adapter)
 	struct net_device_stats *dev_stats = &adapter->netdev->stats;
 	struct be_erx_stats *erx_stats = &hw_stats->erx;
 
-	dev_stats->rx_packets = port_stats->rx_total_frames;
-	dev_stats->tx_packets = port_stats->tx_unicastframes +
-		port_stats->tx_multicastframes + port_stats->tx_broadcastframes;
-	dev_stats->rx_bytes = (u64) port_stats->rx_bytes_msd << 32 |
-				(u64) port_stats->rx_bytes_lsd;
-	dev_stats->tx_bytes = (u64) port_stats->tx_bytes_msd << 32 |
-				(u64) port_stats->tx_bytes_lsd;
+	dev_stats->rx_packets = drvr_stats(adapter)->be_rx_pkts;
+	dev_stats->tx_packets = drvr_stats(adapter)->be_tx_pkts;
+	dev_stats->rx_bytes = drvr_stats(adapter)->be_rx_bytes;
+	dev_stats->tx_bytes = drvr_stats(adapter)->be_tx_bytes;
 
 	/* bad pkts received */
 	dev_stats->rx_errors = port_stats->rx_crc_errors +
@@ -312,12 +309,13 @@ static void be_tx_rate_update(struct be_adapter *adapter)
 }
 
 static void be_tx_stats_update(struct be_adapter *adapter,
-			u32 wrb_cnt, u32 copied, bool stopped)
+			u32 wrb_cnt, u32 copied, u32 gso_segs, bool stopped)
 {
 	struct be_drvr_stats *stats = drvr_stats(adapter);
 	stats->be_tx_reqs++;
 	stats->be_tx_wrbs += wrb_cnt;
 	stats->be_tx_bytes += copied;
+	stats->be_tx_pkts += (gso_segs ? gso_segs : 1);
 	if (stopped)
 		stats->be_tx_stops++;
 }
@@ -462,7 +460,8 @@ static netdev_tx_t be_xmit(struct sk_buff *skb,
 
 		be_txq_notify(adapter, txq->id, wrb_cnt);
 
-		be_tx_stats_update(adapter, wrb_cnt, copied, stopped);
+		be_tx_stats_update(adapter, wrb_cnt, copied,
+				skb_shinfo(skb)->gso_segs, stopped);
 	} else {
 		txq->head = start;
 		dev_kfree_skb_any(skb);
@@ -607,6 +606,7 @@ static void be_rx_stats_update(struct be_adapter *adapter,
 	stats->be_rx_compl++;
 	stats->be_rx_frags += numfrags;
 	stats->be_rx_bytes += pktsize;
+	stats->be_rx_pkts++;
 }
 
 static inline bool do_pkt_csum(struct be_eth_rx_compl *rxcp, bool cso)
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index a555c90..972c98f 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -247,6 +247,9 @@ static const struct flash_spec flash_5709 = {
 
 MODULE_DEVICE_TABLE(pci, bnx2_pci_tbl);
 
+static void bnx2_init_napi(struct bnx2 *bp);
+static void bnx2_del_napi(struct bnx2 *bp);
+
 static inline u32 bnx2_tx_avail(struct bnx2 *bp, struct bnx2_tx_ring_info *txr)
 {
 	u32 diff;
@@ -6214,6 +6217,7 @@ bnx2_open(struct net_device *dev)
 	bnx2_disable_int(bp);
 
 	bnx2_setup_int_mode(bp, disable_msi);
+	bnx2_init_napi(bp);
 	bnx2_napi_enable(bp);
 	rc = bnx2_alloc_mem(bp);
 	if (rc)
@@ -6275,6 +6279,7 @@ open_err:
 	bnx2_free_skbs(bp);
 	bnx2_free_irq(bp);
 	bnx2_free_mem(bp);
+	bnx2_del_napi(bp);
 	return rc;
 }
 
@@ -6536,6 +6541,7 @@ bnx2_close(struct net_device *dev)
 	bnx2_free_irq(bp);
 	bnx2_free_skbs(bp);
 	bnx2_free_mem(bp);
+	bnx2_del_napi(bp);
 	bp->link_up = 0;
 	netif_carrier_off(bp->dev);
 	bnx2_set_power_state(bp, PCI_D3hot);
@@ -8200,12 +8206,21 @@ bnx2_bus_string(struct bnx2 *bp, char *str)
 	return str;
 }
 
-static void __devinit
+static void
+bnx2_del_napi(struct bnx2 *bp)
+{
+	int i;
+
+	for (i = 0; i < bp->irq_nvecs; i++)
+		netif_napi_del(&bp->bnx2_napi[i].napi);
+}
+
+static void
 bnx2_init_napi(struct bnx2 *bp)
 {
 	int i;
 
-	for (i = 0; i < BNX2_MAX_MSIX_VEC; i++) {
+	for (i = 0; i < bp->irq_nvecs; i++) {
 		struct bnx2_napi *bnapi = &bp->bnx2_napi[i];
 		int (*poll)(struct napi_struct *, int);
 
@@ -8274,7 +8289,6 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnx2_ethtool_ops;
 
 	bp = netdev_priv(dev);
-	bnx2_init_napi(bp);
 
 	pci_set_drvdata(pdev, dev);
 
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 4d353d2..7a553e90 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -5182,7 +5182,8 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		/* APME bit in EEPROM is mapped to WUC.APME */
 		eeprom_data = er32(WUC);
 		eeprom_apme_mask = E1000_WUC_APME;
-		if (eeprom_data & E1000_WUC_PHY_WAKE)
+		if ((hw->mac.type > e1000_ich10lan) &&
+		    (eeprom_data & E1000_WUC_PHY_WAKE))
 			adapter->flags2 |= FLAG2_HAS_PHY_WAKEUP;
 	} else if (adapter->flags & FLAG_APME_IN_CTRL3) {
 		if (adapter->flags & FLAG_APME_CHECK_PORT_B &&
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index c881347..01c3885 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -5010,7 +5010,7 @@ static void igb_receive_skb(struct igb_q_vector *q_vector,
 {
 	struct igb_adapter *adapter = q_vector->adapter;
 
-	if (vlan_tag)
+	if (vlan_tag && adapter->vlgrp)
 		vlan_gro_receive(&q_vector->napi, adapter->vlgrp,
 		                 vlan_tag, skb);
 	else
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 951b73c..a6c9997 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -806,6 +806,7 @@ static bool ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			break;
 		(*work_done)++;
 
+		rmb(); /* read descriptor and rx_buffer_info after status DD */
 		if (rx_ring->flags & IXGBE_RING_RX_PS_ENABLED) {
 			hdr_info = le16_to_cpu(ixgbe_get_hdr_info(rx_desc));
 			len = (hdr_info & IXGBE_RXDADV_HDRBUFLEN_MASK) >>
@@ -2147,6 +2148,10 @@ static void ixgbe_configure_rx(struct ixgbe_adapter *adapter)
 	/* Decide whether to use packet split mode or not */
 	adapter->flags |= IXGBE_FLAG_RX_PS_ENABLED;
 
+	/* Disable packet split due to 82599 erratum #45 */
+	if (hw->mac.type == ixgbe_mac_82599EB)
+		adapter->flags &= ~IXGBE_FLAG_RX_PS_ENABLED;
+
 	/* Set the RX buffer length according to the mode */
 	if (adapter->flags & IXGBE_FLAG_RX_PS_ENABLED) {
 		rx_buf_len = IXGBE_RX_HDR_SIZE;
diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index 64cff68..f1b514d 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -1398,7 +1398,6 @@ netxen_process_rcv(struct netxen_adapter *adapter,
 	if (pkt_offset)
 		skb_pull(skb, pkt_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff);
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	napi_gro_receive(&sds_ring->napi, skb);
@@ -1460,8 +1459,6 @@ netxen_process_lro(struct netxen_adapter *adapter,
 
 	skb_put(skb, lro_length + data_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff) + skb_headroom(skb);
-
 	skb_pull(skb, l2_hdr_offset);
 	skb->protocol = eth_type_trans(skb, netdev);
 
diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index f03e2e4..96a0767 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -135,7 +135,7 @@
 #define RX_DESC_SIZE	(RX_DCNT * sizeof(struct r6040_descriptor))
 #define TX_DESC_SIZE	(TX_DCNT * sizeof(struct r6040_descriptor))
 #define MBCR_DEFAULT	0x012A	/* MAC Bus Control Register */
-#define MCAST_MAX	4	/* Max number multicast addresses to filter */
+#define MCAST_MAX	3	/* Max number multicast addresses to filter */
 
 /* Descriptor status */
 #define DSC_OWNER_MAC	0x8000	/* MAC is the owner of this descriptor */
@@ -984,9 +984,6 @@ static void r6040_multicast_list(struct net_device *dev)
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (15 - (crc & 0xf));
 		}
-		/* Write the index of the hash table */
-		for (i = 0; i < 4; i++)
-			iowrite16(hash_table[i] << 14, ioaddr + MCR1);
 		/* Fill the MAC hash tables with their values */
 		iowrite16(hash_table[0], ioaddr + MAR0);
 		iowrite16(hash_table[1], ioaddr + MAR1);
@@ -994,6 +991,7 @@ static void r6040_multicast_list(struct net_device *dev)
 		iowrite16(hash_table[3], ioaddr + MAR3);
 	}
 	/* Multicast Address 1~4 case */
+	dmi = dev->mc_list;
 	for (i = 0, dmi; (i < dev->mc_count) && (i < MCAST_MAX); i++) {
 		adrp = (u16 *)dmi->dmi_addr;
 		iowrite16(adrp[0], ioaddr + MID_1L + 8*i);
@@ -1002,9 +1000,9 @@ static void r6040_multicast_list(struct net_device *dev)
 		dmi = dmi->next;
 	}
 	for (i = dev->mc_count; i < MCAST_MAX; i++) {
-		iowrite16(0xffff, ioaddr + MID_0L + 8*i);
-		iowrite16(0xffff, ioaddr + MID_0M + 8*i);
-		iowrite16(0xffff, ioaddr + MID_0H + 8*i);
+		iowrite16(0xffff, ioaddr + MID_1L + 8*i);
+		iowrite16(0xffff, ioaddr + MID_1M + 8*i);
+		iowrite16(0xffff, ioaddr + MID_1H + 8*i);
 	}
 }
 
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 69f84c8..f500649 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -23,6 +23,7 @@
 #include <linux/tcp.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci-aspm.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -3030,6 +3031,11 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mii->reg_num_mask = 0x1f;
 	mii->supports_gmii = !!(cfg->features & RTL_FEATURE_GMII);
 
+	/* disable ASPM completely as that cause random device stop working
+	 * problems as well as full system hangs for some PCIe devices users */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				     PCIE_LINK_STATE_CLKPM);
+
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pci_enable_device(pdev);
 	if (rc < 0) {
@@ -3735,7 +3741,8 @@ static void rtl_hw_start_8168(struct net_device *dev)
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
+	if (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
 		tp->intr_event |= RxFIFOOver | PCSTimeout;
 		tp->intr_event &= ~RxOverflow;
 	}
@@ -4626,7 +4633,8 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 
 		/* Work around for rx fifo overflow */
 		if (unlikely(status & RxFIFOOver) &&
-		(tp->mac_version == RTL_GIGA_MAC_VER_11)) {
+		    (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+		     tp->mac_version == RTL_GIGA_MAC_VER_22)) {
 			netif_stop_queue(dev);
 			rtl8169_tx_timeout(dev);
 			break;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6661178..896e2cd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -897,6 +897,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
+	ath9k_hw_read_revisions(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Couldn't reset chip\n");
@@ -1810,8 +1812,6 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		return false;
 	}
 
-	ath9k_hw_read_revisions(ah);
-
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 664dcd5..ead668e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1107,6 +1107,9 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
@@ -1314,6 +1317,9 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 }
 
 
@@ -2576,9 +2582,10 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 
 	flush_workqueue(priv->workqueue);
 
-	/* enable interrupts again in order to receive rfkill changes */
+	/* User space software may expect getting rfkill changes
+	 * even if interface is down */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
@@ -3451,14 +3458,14 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 8. Setup and register mac80211
 	 **********************************/
 
-	/* enable interrupts if needed: hw bug w/a */
+	/* enable rfkill interrupt: hw bug w/a */
 	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
 	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
 		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
 		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
 	}
 
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	err = iwl_setup_mac(priv);
 	if (err)
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index f8481e8..bf2a33f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -160,6 +160,12 @@ static inline void iwl_disable_interrupts(struct iwl_priv *priv)
 	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
 }
 
+static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
+	iwl_write32(priv, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 static inline void iwl_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 753a180..c41827d 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1764,6 +1764,12 @@ static int __orinoco_commit(struct orinoco_private *priv)
 	struct net_device *dev = priv->ndev;
 	int err = 0;
 
+	/* If we've called commit, we are reconfiguring or bringing the
+	 * interface up. Maintaining countermeasures across this would
+	 * be confusing, so note that we've disabled them. The port will
+	 * be enabled later in orinoco_commit or __orinoco_up. */
+	priv->tkip_cm_active = 0;
+
 	err = orinoco_hw_program_rids(priv);
 
 	/* FIXME: what about netif_tx_lock */
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 31ca241..4e9a126 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1022,10 +1022,10 @@ static int orinoco_ioctl_set_auth(struct net_device *dev,
 		 */
 		if (param->value) {
 			priv->tkip_cm_active = 1;
-			ret = hermes_enable_port(hw, 0);
+			ret = hermes_disable_port(hw, 0);
 		} else {
 			priv->tkip_cm_active = 0;
-			ret = hermes_disable_port(hw, 0);
+			ret = hermes_enable_port(hw, 0);
 		}
 		break;
 
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 8e3818f..2c31eb4 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -261,8 +261,10 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 	list->max_entries = max_channel_num;
 	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
 				 max_channel_num, GFP_KERNEL);
-	if (!list->channels)
+	if (!list->channels) {
+		ret = -ENOMEM;
 		goto free;
+	}
 
 	for (i = 0; i < max_channel_num; i++) {
 		if (i < priv->iq_autocal_len) {
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 7ff033e..f471fcb 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -198,6 +198,7 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
 	while (i != idx) {
 		u16 len;
 		struct sk_buff *skb;
+		dma_addr_t dma_addr;
 		desc = &ring[i];
 		len = le16_to_cpu(desc->len);
 		skb = rx_buf[i];
@@ -215,17 +216,20 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
 
 			len = priv->common.rx_mtu;
 		}
+		dma_addr = le32_to_cpu(desc->host_addr);
+		pci_dma_sync_single_for_cpu(priv->pdev, dma_addr,
+			priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {
-			pci_unmap_single(priv->pdev,
-					 le32_to_cpu(desc->host_addr),
-					 priv->common.rx_mtu + 32,
-					 PCI_DMA_FROMDEVICE);
+			pci_unmap_single(priv->pdev, dma_addr,
+				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 			rx_buf[i] = NULL;
-			desc->host_addr = 0;
+			desc->host_addr = cpu_to_le32(0);
 		} else {
 			skb_trim(skb, 0);
+			pci_dma_sync_single_for_device(priv->pdev, dma_addr,
+				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
 		}
 
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 805284d..0a2bf5c 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -32,8 +32,18 @@ MODULE_ALIAS("prism54usb");
 MODULE_FIRMWARE("isl3886usb");
 MODULE_FIRMWARE("isl3887usb");
 
+/*
+ * Note:
+ *
+ * Always update our wiki's device list (located at:
+ * http://wireless.kernel.org/en/users/Drivers/p54/devices ),
+ * whenever you add a new device.
+ */
+
 static struct usb_device_id p54u_table[] __devinitdata = {
 	/* Version 1 devices (pci chip + net2280) */
+	{USB_DEVICE(0x0411, 0x0050)},	/* Buffalo WLI2-USB2-G54 */
+	{USB_DEVICE(0x045e, 0x00c2)},	/* Microsoft MN-710 */
 	{USB_DEVICE(0x0506, 0x0a11)},	/* 3COM 3CRWE254G72 */
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
 	{USB_DEVICE(0x07aa, 0x001c)},	/* Corega CG-WLUSB2GT */
@@ -45,7 +55,13 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
+	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
+	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
+	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
+	{USB_DEVICE(0x15a9, 0x0002)},	/* Gemtek WUBI-100GW 802.11g */
+	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
+	{USB_DEVICE(0x182d, 0x096b)},	/* Sitecom WL-107 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
@@ -58,6 +74,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x050d, 0x7050)},	/* Belkin F5D7050 ver 1000 */
 	{USB_DEVICE(0x0572, 0x2000)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0572, 0x2002)},	/* Cohiba Proto board */
+	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
@@ -77,7 +94,10 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
+	{USB_DEVICE(0x1668, 0x1050)},	/* Actiontec 802UIG-1 */
+	{USB_DEVICE(0x1740, 0x1000)},	/* Senao NUB-350 */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
+	{USB_DEVICE(0x2001, 0x3705)},	/* D-Link DWL-G120 rev C1 */
 	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */
 	{USB_DEVICE(0x413c, 0x8104)},	/* Cohiba Proto board */
@@ -929,8 +949,8 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 #ifdef CONFIG_PM
 		/* ISL3887 needs a full reset on resume */
 		udev->reset_resume = 1;
+#endif /* CONFIG_PM */
 		err = p54u_device_reset(dev);
-#endif
 
 		priv->hw_type = P54U_3887;
 		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 9d147de..648be32 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -617,7 +617,7 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	else
 		*burst_possible = false;
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
 	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ced3b6a..d87fe3d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2401,6 +2401,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0812, 0x3101), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..9e71eee 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1423,6 +1423,11 @@ int __init enable_drhd_fault_handling(void)
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
 		}
+
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(iommu->irq, iommu);
 	}
 
 	return 0;
diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index f7b68ca..4ae494b 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -54,6 +54,9 @@ static int __init pci_stub_init(void)
 			subdevice = PCI_ANY_ID, class=0, class_mask=0;
 		int fields;
 
+		if (!strlen(id))
+			continue;
+
 		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
 				&vendor, &device, &subvendor, &subdevice,
 				&class, &class_mask);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 807224e..e189722 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -689,17 +689,21 @@ void pci_remove_legacy_files(struct pci_bus *b)
 
 #ifdef HAVE_PCI_MMAP
 
-int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma)
+int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
+		  enum pci_mmap_api mmap_api)
 {
-	unsigned long nr, start, size;
+	unsigned long nr, start, size, pci_start;
 
+	if (pci_resource_len(pdev, resno) == 0)
+		return 0;
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	if (start < size && size - start >= nr)
+	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
+			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
+	if (start >= pci_start && start < pci_start + size &&
+			start + nr <= pci_start + size)
 		return 1;
-	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
-		current->comm, start, start+nr, pci_name(pdev), resno, size);
 	return 0;
 }
 
@@ -729,8 +733,14 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
-	if (!pci_mmap_fits(pdev, i, vma))
+	if (!pci_mmap_fits(pdev, i, vma, PCI_MMAP_SYSFS)) {
+		WARN(1, "process \"%s\" tried to map 0x%08lx bytes "
+			"at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
+			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff,
+			pci_name(pdev), i,
+			pci_resource_start(pdev, i), pci_resource_len(pdev, i));
 		return -EINVAL;
+	}
 
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
@@ -979,7 +989,7 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
 		attr->write = write_vpd_attr;
 		retval = sysfs_create_bin_file(&dev->dev.kobj, attr);
 		if (retval) {
-			kfree(dev->vpd->attr);
+			kfree(attr);
 			return retval;
 		}
 		dev->vpd->attr = attr;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index fbd0e3a..45a6ba0 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -13,8 +13,13 @@ extern int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_cleanup_rom(struct pci_dev *dev);
 #ifdef HAVE_PCI_MMAP
+enum pci_mmap_api {
+	PCI_MMAP_SYSFS,	/* mmap on /sys/bus/pci/devices/<BDF>/resource<N> */
+	PCI_MMAP_PROCFS	/* mmap on /proc/bus/pci/<BDF> */
+};
 extern int pci_mmap_fits(struct pci_dev *pdev, int resno,
-			 struct vm_area_struct *vma);
+			 struct vm_area_struct *vmai,
+			 enum pci_mmap_api mmap_api);
 #endif
 int pci_probe_reset_function(struct pci_dev *dev);
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 593bb84..a03ad8c 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -259,7 +259,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 
 	/* Make sure the caller is mapping a real resource for this device */
 	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
-		if (pci_mmap_fits(dev, i, vma))
+		if (pci_mmap_fits(dev, i, vma,  PCI_MMAP_PROCFS))
 			break;
 	}
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 197e38f..3cf6ef6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -155,6 +155,26 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_2,	quirk_isa_d
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_3,	quirk_isa_dma_hangs);
 
 /*
+ * Intel NM10 "TigerPoint" LPC PM1a_STS.BM_STS must be clear
+ * for some HT machines to use C4 w/o hanging.
+ */
+static void __devinit quirk_tigerpoint_bm_sts(struct pci_dev *dev)
+{
+	u32 pmbase;
+	u16 pm1a;
+
+	pci_read_config_dword(dev, 0x40, &pmbase);
+	pmbase = pmbase & 0xff80;
+	pm1a = inw(pmbase);
+
+	if (pm1a & 0x10) {
+		dev_info(&dev->dev, FW_BUG "TigerPoint LPC.BM_STS cleared\n");
+		outw(0x10, pmbase);
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TGP_LPC, quirk_tigerpoint_bm_sts);
+
+/*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
 static void __devinit quirk_nopcipci(struct pci_dev *dev)
@@ -503,6 +523,17 @@ static void __devinit quirk_piix4_acpi(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82371AB_3,	quirk_piix4_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	quirk_piix4_acpi);
 
+#define ICH_PMBASE	0x40
+#define ICH_ACPI_CNTL	0x44
+#define  ICH4_ACPI_EN	0x10
+#define  ICH6_ACPI_EN	0x80
+#define ICH4_GPIOBASE	0x58
+#define ICH4_GPIO_CNTL	0x5c
+#define  ICH4_GPIO_EN	0x10
+#define ICH6_GPIOBASE	0x48
+#define ICH6_GPIO_CNTL	0x4c
+#define  ICH6_GPIO_EN	0x10
+
 /*
  * ICH4, ICH4-M, ICH5, ICH5-M ACPI: Three IO regions pointed to by longwords at
  *	0x40 (128 bytes of ACPI, GPIO & TCO registers)
@@ -511,12 +542,33 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	qui
 static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH4 ACPI/GPIO/TCO");
+	/*
+	 * The check for PCIBIOS_MIN_IO is to ensure we won't create a conflict
+	 * with low legacy (and fixed) ports. We don't know the decoding
+	 * priority and can't tell whether the legacy device or the one created
+	 * here is really at that address.  This happens on boards with broken
+	 * BIOSes.
+	*/
+
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH4_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+					"ICH4 ACPI/GPIO/TCO");
+	}
 
-	pci_read_config_dword(dev, 0x58, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH4 GPIO");
+	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 64,
+					PCI_BRIDGE_RESOURCES + 1, "ICH4 GPIO");
+	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -532,12 +584,25 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		qui
 static void __devinit ich6_lpc_acpi_gpio(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH6 ACPI/GPIO/TCO");
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH6_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+					"ICH6 ACPI/GPIO/TCO");
+	}
 
-	pci_read_config_dword(dev, 0x48, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH6 GPIO");
+	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 64,
+					PCI_BRIDGE_RESOURCES + 1, "ICH6 GPIO");
+	}
 }
 
 static void __devinit ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)
@@ -2492,58 +2557,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4375,
 
 #endif /* CONFIG_PCI_MSI */
 
-#ifdef CONFIG_PCI_IOV
-
-/*
- * For Intel 82576 SR-IOV NIC, if BIOS doesn't allocate resources for the
- * SR-IOV BARs, zero the Flash BAR and program the SR-IOV BARs to use the
- * old Flash Memory Space.
- */
-static void __devinit quirk_i82576_sriov(struct pci_dev *dev)
-{
-	int pos, flags;
-	u32 bar, start, size;
-
-	if (PAGE_SIZE > 0x10000)
-		return;
-
-	flags = pci_resource_flags(dev, 0);
-	if ((flags & PCI_BASE_ADDRESS_SPACE) !=
-			PCI_BASE_ADDRESS_SPACE_MEMORY ||
-	    (flags & PCI_BASE_ADDRESS_MEM_TYPE_MASK) !=
-			PCI_BASE_ADDRESS_MEM_TYPE_32)
-		return;
-
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_SRIOV);
-	if (!pos)
-		return;
-
-	pci_read_config_dword(dev, pos + PCI_SRIOV_BAR, &bar);
-	if (bar & PCI_BASE_ADDRESS_MEM_MASK)
-		return;
-
-	start = pci_resource_start(dev, 1);
-	size = pci_resource_len(dev, 1);
-	if (!start || size != 0x400000 || start & (size - 1))
-		return;
-
-	pci_resource_flags(dev, 1) = 0;
-	pci_write_config_dword(dev, PCI_BASE_ADDRESS_1, 0);
-	pci_write_config_dword(dev, pos + PCI_SRIOV_BAR, start);
-	pci_write_config_dword(dev, pos + PCI_SRIOV_BAR + 12, start + size / 2);
-
-	dev_info(&dev->dev, "use Flash Memory Space for SR-IOV BARs\n");
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10c9, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e6, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e7, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e8, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150a, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150d, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1518, quirk_i82576_sriov);
-
-#endif	/* CONFIG_PCI_IOV */
-
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
@@ -2572,6 +2585,29 @@ extern struct pci_fixup __end_pci_fixups_resume_early[];
 extern struct pci_fixup __start_pci_fixups_suspend[];
 extern struct pci_fixup __end_pci_fixups_suspend[];
 
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#define VTUNCERRMSK_REG	0x1ac
+#define VTD_MSK_SPEC_ERRORS	(1 << 31)
+/*
+ * This is a quirk for masking vt-d spec defined errors to platform error
+ * handling logic. With out this, platforms using Intel 7500, 5500 chipsets
+ * (and the derivative chipsets like X58 etc) seem to generate NMI/SMI (based
+ * on the RAS config settings of the platform) when a vt-d fault happens.
+ * The resulting SMI caused the system to hang.
+ *
+ * VT-d spec related errors are already handled by the VT-d OS code, so no
+ * need to report the same error through other channels.
+ */
+static void vtd_mask_spec_errors(struct pci_dev *dev)
+{
+	u32 word;
+
+	pci_read_config_dword(dev, VTUNCERRMSK_REG, &word);
+	pci_write_config_dword(dev, VTUNCERRMSK_REG, word | VTD_MSK_SPEC_ERRORS);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
+#endif
 
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 {
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 226b3e9..827caf4 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -90,7 +90,7 @@ struct acer_quirks {
  */
 #define AMW0_GUID1		"67C3371D-95A3-4C37-BB61-DD47B491DAAB"
 #define AMW0_GUID2		"431F16ED-0C2B-444C-B267-27DEB140CF9C"
-#define WMID_GUID1		"6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3"
+#define WMID_GUID1		"6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3"
 #define WMID_GUID2		"95764E09-FB56-4e83-B31A-37761F60994A"
 
 MODULE_ALIAS("wmi:67C3371D-95A3-4C37-BB61-DD47B491DAAB");
@@ -1062,7 +1062,7 @@ static ssize_t set_bool_threeg(struct device *dev,
 			return -EINVAL;
 	return count;
 }
-static DEVICE_ATTR(threeg, S_IWUGO | S_IRUGO | S_IWUSR, show_bool_threeg,
+static DEVICE_ATTR(threeg, S_IRUGO | S_IWUSR, show_bool_threeg,
 	set_bool_threeg);
 
 static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index c1d2aee..e6188a3 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1078,14 +1078,8 @@ static int asus_hotk_add_fs(struct acpi_device *device)
 	struct proc_dir_entry *proc;
 	mode_t mode;
 
-	/*
-	 * If parameter uid or gid is not changed, keep the default setting for
-	 * our proc entries (-rw-rw-rw-) else, it means we care about security,
-	 * and then set to -rw-rw----
-	 */
-
 	if ((asus_uid == 0) && (asus_gid == 0)) {
-		mode = S_IFREG | S_IRUGO | S_IWUGO;
+		mode = S_IFREG | S_IRUGO | S_IWUSR | S_IWGRP;
 	} else {
 		mode = S_IFREG | S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP;
 		printk(KERN_WARNING "  asus_uid and asus_gid parameters are "
diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/tc1100-wmi.c
index dd33b51..03e7e03 100644
--- a/drivers/platform/x86/tc1100-wmi.c
+++ b/drivers/platform/x86/tc1100-wmi.c
@@ -161,7 +161,7 @@ set_bool_##value(struct device *dev, struct device_attribute *attr, \
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, TC1100_INSTANCE_WIRELESS);
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index b104302..a82f18e 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -724,7 +724,7 @@ static bool guid_already_parsed(const char *guid_string)
 		wblock = list_entry(p, struct wmi_block, list);
 		gblock = &wblock->gblock;
 
-		if (strncmp(gblock->guid, guid_string, 16) == 0)
+		if (memcmp(gblock->guid, guid_string, 16) == 0)
 			return true;
 	}
 	return false;
diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 6f1dba5..ad31df1 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -211,7 +211,7 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	if (di->rem_capacity > 100)
 		di->rem_capacity = 100;
 
-	if (di->current_uA >= 100L)
+	if (di->current_uA < -100L)
 		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
 					/ (di->current_uA / 100L);
 	else
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 8fefe5a..4b38eaa 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -271,14 +271,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 9760L / 32;
+		val->intval = (s16)be16_to_cpu(ec_word) * 9760L / 32;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 15625L / 120;
+		val->intval = (s16)be16_to_cpu(ec_word) * 15625L / 120;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
@@ -299,7 +299,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
+		val->intval = (s16)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
@@ -313,7 +313,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 6250 / 15;
+		val->intval = (s16)be16_to_cpu(ec_word) * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index aa13875..af5fd61 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -851,7 +852,7 @@ static void __exit cmos_do_remove(struct device *dev)
 
 #ifdef	CONFIG_PM
 
-static int cmos_suspend(struct device *dev, pm_message_t mesg)
+static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -899,7 +900,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
  */
 static inline int cmos_poweroff(struct device *dev)
 {
-	return cmos_suspend(dev, PMSG_HIBERNATE);
+	return cmos_suspend(dev);
 }
 
 static int cmos_resume(struct device *dev)
@@ -946,9 +947,9 @@ static int cmos_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 #else
-#define	cmos_suspend	NULL
-#define	cmos_resume	NULL
 
 static inline int cmos_poweroff(struct device *dev)
 {
@@ -1084,7 +1085,7 @@ static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
 
 static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
 {
-	return cmos_suspend(&pnp->dev, mesg);
+	return cmos_suspend(&pnp->dev);
 }
 
 static int cmos_pnp_resume(struct pnp_dev *pnp)
@@ -1164,8 +1165,9 @@ static struct platform_driver cmos_platform_driver = {
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,
-		.suspend	= cmos_suspend,
-		.resume		= cmos_resume,
+#ifdef CONFIG_PM
+		.pm		= &cmos_pm_ops,
+#endif
 	}
 };
 
diff --git a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
index cee4d4e..1160fca 100644
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -462,7 +462,8 @@ kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp;
-	int ct, perm;
+	unsigned int ct;
+	int perm;
 
 	argp = (void __user *)arg;
 
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 44f2f6a..e443db1 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -91,6 +91,12 @@ enum qdio_irq_states {
 #define AC1_SC_QEBSM_AVAILABLE		0x02	/* available for subchannel */
 #define AC1_SC_QEBSM_ENABLED		0x01	/* enabled for subchannel */
 
+/* SIGA flags */
+#define QDIO_SIGA_WRITE		0x00
+#define QDIO_SIGA_READ		0x01
+#define QDIO_SIGA_SYNC		0x02
+#define QDIO_SIGA_QEBSM_FLAG	0x80
+
 #ifdef CONFIG_64BIT
 static inline int do_sqbs(u64 token, unsigned char state, int queue,
 			  int *start, int *count)
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 62b654a..91e64de 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -28,11 +28,12 @@ MODULE_AUTHOR("Utz Bacher <utz.bacher@de.ibm.com>,"\
 MODULE_DESCRIPTION("QDIO base support");
 MODULE_LICENSE("GPL");
 
-static inline int do_siga_sync(struct subchannel_id schid,
-			       unsigned int out_mask, unsigned int in_mask)
+static inline int do_siga_sync(unsigned long schid,
+			       unsigned int out_mask, unsigned int in_mask,
+			       unsigned int fc)
 {
-	register unsigned long __fc asm ("0") = 2;
-	register struct subchannel_id __schid asm ("1") = schid;
+	register unsigned long __fc asm ("0") = fc;
+	register unsigned long __schid asm ("1") = schid;
 	register unsigned long out asm ("2") = out_mask;
 	register unsigned long in asm ("3") = in_mask;
 	int cc;
@@ -46,10 +47,11 @@ static inline int do_siga_sync(struct subchannel_id schid,
 	return cc;
 }
 
-static inline int do_siga_input(struct subchannel_id schid, unsigned int mask)
+static inline int do_siga_input(unsigned long schid, unsigned int mask,
+				unsigned int fc)
 {
-	register unsigned long __fc asm ("0") = 1;
-	register struct subchannel_id __schid asm ("1") = schid;
+	register unsigned long __fc asm ("0") = fc;
+	register unsigned long __schid asm ("1") = schid;
 	register unsigned long __mask asm ("2") = mask;
 	int cc;
 
@@ -278,6 +280,8 @@ void qdio_init_buf_states(struct qdio_irq *irq_ptr)
 static inline int qdio_siga_sync(struct qdio_q *q, unsigned int output,
 			  unsigned int input)
 {
+	unsigned long schid = *((u32 *) &q->irq_ptr->schid);
+	unsigned int fc = QDIO_SIGA_SYNC;
 	int cc;
 
 	if (!need_siga_sync(q))
@@ -286,7 +290,12 @@ static inline int qdio_siga_sync(struct qdio_q *q, unsigned int output,
 	DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "siga-s:%1d", q->nr);
 	qperf_inc(q, siga_sync);
 
-	cc = do_siga_sync(q->irq_ptr->schid, output, input);
+	if (is_qebsm(q)) {
+		schid = q->irq_ptr->sch_token;
+		fc |= QDIO_SIGA_QEBSM_FLAG;
+	}
+
+	cc = do_siga_sync(schid, output, input, fc);
 	if (cc)
 		DBF_ERROR("%4x SIGA-S:%2d", SCH_NO(q), cc);
 	return cc;
@@ -312,8 +321,8 @@ static inline int qdio_siga_sync_all(struct qdio_q *q)
 
 static int qdio_siga_output(struct qdio_q *q, unsigned int *busy_bit)
 {
-	unsigned long schid;
-	unsigned int fc = 0;
+	unsigned long schid = *((u32 *) &q->irq_ptr->schid);
+	unsigned int fc = QDIO_SIGA_WRITE;
 	u64 start_time = 0;
 	int cc;
 
@@ -322,11 +331,8 @@ static int qdio_siga_output(struct qdio_q *q, unsigned int *busy_bit)
 
 	if (is_qebsm(q)) {
 		schid = q->irq_ptr->sch_token;
-		fc |= 0x80;
+		fc |= QDIO_SIGA_QEBSM_FLAG;
 	}
-	else
-		schid = *((u32 *)&q->irq_ptr->schid);
-
 again:
 	cc = do_siga_output(schid, q->mask, busy_bit, fc);
 
@@ -346,12 +352,19 @@ again:
 
 static inline int qdio_siga_input(struct qdio_q *q)
 {
+	unsigned long schid = *((u32 *) &q->irq_ptr->schid);
+	unsigned int fc = QDIO_SIGA_READ;
 	int cc;
 
 	DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "siga-r:%1d", q->nr);
 	qperf_inc(q, siga_read);
 
-	cc = do_siga_input(q->irq_ptr->schid, q->mask);
+	if (is_qebsm(q)) {
+		schid = q->irq_ptr->sch_token;
+		fc |= QDIO_SIGA_QEBSM_FLAG;
+	}
+
+	cc = do_siga_input(schid, q->mask, fc);
 	if (cc)
 		DBF_ERROR("%4x SIGA-R:%2d", SCH_NO(q), cc);
 	return cc;
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 44e2d11..1472701 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -84,11 +84,32 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->meminfo(cfg, &km_len, &dm_len);
 
+	dm_len += bfa_port_meminfo();
 
 	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_len = km_len;
 	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_len = dm_len;
 }
 
+static void
+bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi)
+{
+	struct bfa_port_s       *port = &bfa->modules.port;
+	uint32_t                dm_len;
+	uint8_t                 *dm_kva;
+	uint64_t                dm_pa;
+
+	dm_len = bfa_port_meminfo();
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa  = bfa_meminfo_dma_phys(mi);
+
+	memset(port, 0, sizeof(struct bfa_port_s));
+	bfa_port_attach(port, &bfa->ioc, bfa, bfa->trcmod, bfa->logm);
+	bfa_port_mem_claim(port, dm_kva, dm_pa);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva + dm_len;
+	bfa_meminfo_dma_phys(mi) = dm_pa + dm_len;
+}
+
 /**
  * Use this function to do attach the driver instance with the BFA
  * library. This function will not trigger any HW initialization
@@ -140,6 +161,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->attach(bfa, bfad, cfg, meminfo, pcidev);
 
+	bfa_com_port_attach(bfa, meminfo);
 }
 
 /**
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4f0d013..d991f4b 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -281,7 +281,8 @@ static void stpg_endio(struct request *req, int error)
 			    print_alua_state(h->state));
 	}
 done:
-	blk_put_request(req);
+	req->end_io_data = NULL;
+	__blk_put_request(req->q, req);
 	if (h->callback_fn) {
 		h->callback_fn(h->callback_data, err);
 		h->callback_fn = h->callback_data = NULL;
@@ -717,6 +718,8 @@ static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"IBM", "2145" },
 	{"Pillar", "Axiom" },
 	{"Intel", "Multi-Flex"},
+	{"NETAPP", "LUN"},
+	{"AIX", "NVDISK"},
 	{NULL, NULL}
 };
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 9e8fce0..bb96d74 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4174,6 +4174,14 @@ static int ioc_general(void __user *arg, char *cmnd)
     ha = gdth_find_ha(gen.ionode);
     if (!ha)
         return -EFAULT;
+
+    if (gen.data_len > INT_MAX)
+        return -EINVAL;
+    if (gen.sense_len > INT_MAX)
+        return -EINVAL;
+    if (gen.data_len + gen.sense_len > INT_MAX)
+        return -EINVAL;
+
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(ha, gen.data_len + gen.sense_len,
                                      FALSE, &paddr)))
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 816ab97..0ee989f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -346,6 +346,7 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 static struct ata_port_operations sas_sata_ops = {
 	.phy_reset		= sas_ata_phy_reset,
 	.post_internal_cmd	= sas_ata_post_internal,
+	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b672d10..f8f23b0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -648,6 +648,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	shost->host_eh_scheduled = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	SAS_DPRINTK("Enter %s\n", __func__);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 89d0240..b146702 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2024,9 +2024,9 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		/* adjust hba_queue_depth, reply_free_queue_depth,
 		 * and queue_size
 		 */
-		ioc->hba_queue_depth -= queue_diff;
-		ioc->reply_free_queue_depth -= queue_diff;
-		queue_size -= queue_diff;
+		ioc->hba_queue_depth -= (queue_diff / 2);
+		ioc->reply_free_queue_depth -= (queue_diff / 2);
+		queue_size = facts->MaxReplyDescriptorPostQueueDepth;
 	}
 	ioc->reply_post_queue_depth = queue_size;
 
@@ -3588,6 +3588,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->scsih_cmds.mutex);
 
+	/* scsih internal command bits */
+	ioc->scsih_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
+	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
+	mutex_init(&ioc->scsih_cmds.mutex);
+
 	/* task management internal command bits */
 	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
@@ -3689,6 +3694,8 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	mpt2sas_scsih_reset_handler(ioc, reset_phase);
+	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
@@ -3719,8 +3726,6 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		break;
 	}
-	mpt2sas_scsih_reset_handler(ioc, reset_phase);
-	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 }
 
 /**
@@ -3774,6 +3779,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 {
 	int r;
 	unsigned long flags;
+	u8 pe_complete = ioc->wait_for_port_enable_to_complete;
 
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
 	    __func__));
@@ -3798,6 +3804,14 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
+
+	/* If this hard reset is called while port enable is active, then
+	 * there is no reason to call make_ioc_operational
+	 */
+	if (pe_complete) {
+		r = -EFAULT;
+		goto out;
+	}
 	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index cd55176..59f6cdc 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2663,9 +2663,6 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle;
 
 	for (i = 0 ; i < event_data->NumEntries; i++) {
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
-			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
@@ -6014,6 +6011,7 @@ _scsih_remove(struct pci_dev *pdev)
 		destroy_workqueue(wq);
 
 	/* release all the volumes */
+	_scsih_ir_shutdown(ioc);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
 		if (raid_device->starget) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5697709..514ef91 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2436,7 +2436,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev)
 		sdev->sdev_state = SDEV_RUNNING;
 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
 		sdev->sdev_state = SDEV_CREATED;
-	else
+	else if (sdev->sdev_state != SDEV_CANCEL &&
+		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5a06505..02f719b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -992,10 +992,11 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
-		    sdev->sdev_state == SDEV_DEL)
+		    scsi_device_get(sdev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
 		goto restart;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bf15920..8022d3c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1108,6 +1108,12 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
 	u64 bad_lba;
 	int info_valid;
+	/*
+	 * resid is optional but mostly filled in.  When it's unused,
+	 * its value is zero, so we assume the whole buffer transferred
+	 */
+	unsigned int transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
+	unsigned int good_bytes;
 
 	if (!blk_fs_request(scmd->request))
 		return 0;
@@ -1141,7 +1147,8 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	/* This computation should always be done in terms of
 	 * the resolution of the device's medium.
 	 */
-	return (bad_lba - start_lba) * scmd->device->sector_size;
+	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
+	return min(good_bytes, transferred);
 }
 
 /**
@@ -2156,11 +2163,10 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
 
-	if (index < SD_MAX_DISKS) {
-		gd->major = sd_major((index & 0xf0) >> 4);
-		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-		gd->minors = SD_MINORS;
-	}
+	gd->major = sd_major((index & 0xf0) >> 4);
+	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+	gd->minors = SD_MINORS;
+
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
@@ -2249,6 +2255,12 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	if (index >= SD_MAX_DISKS) {
+		error = -ENODEV;
+		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
+		goto out_free_index;
+	}
+
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error)
 		goto out_free_index;
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index e9b15c3..353bd9b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -255,7 +255,8 @@ static const struct serial8250_config uart_config[] = {
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
+		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
 	[PORT_RSA] = {
 		.name		= "RSA",
diff --git a/drivers/ssb/b43_pci_bridge.c b/drivers/ssb/b43_pci_bridge.c
index ef9c6a0..744d3f6 100644
--- a/drivers/ssb/b43_pci_bridge.c
+++ b/drivers/ssb/b43_pci_bridge.c
@@ -24,6 +24,7 @@ static const struct pci_device_id b43_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4315) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BCM_GVC,  0x4318) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 8e194d5..64abd11 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -495,9 +495,9 @@ static void ssb_pmu_resources_init(struct ssb_chipcommon *cc)
 		chipco_write32(cc, SSB_CHIPCO_PMU_MAXRES_MSK, max_msk);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/SSB/PmuInit */
 void ssb_pmu_init(struct ssb_chipcommon *cc)
 {
+	struct ssb_bus *bus = cc->dev->bus;
 	u32 pmucap;
 
 	if (!(cc->capabilities & SSB_CHIPCO_CAP_PMU))
@@ -509,12 +509,15 @@ void ssb_pmu_init(struct ssb_chipcommon *cc)
 	ssb_dprintk(KERN_DEBUG PFX "Found rev %u PMU (capabilities 0x%08X)\n",
 		    cc->pmu.rev, pmucap);
 
-	if (cc->pmu.rev == 1)
-		chipco_mask32(cc, SSB_CHIPCO_PMU_CTL,
-			      ~SSB_CHIPCO_PMU_CTL_NOILPONW);
-	else
-		chipco_set32(cc, SSB_CHIPCO_PMU_CTL,
-			     SSB_CHIPCO_PMU_CTL_NOILPONW);
+	if (cc->pmu.rev >= 1) {
+		if ((bus->chip_id == 0x4325) && (bus->chip_rev < 2)) {
+			chipco_mask32(cc, SSB_CHIPCO_PMU_CTL,
+				      ~SSB_CHIPCO_PMU_CTL_NOILPONW);
+		} else {
+			chipco_set32(cc, SSB_CHIPCO_PMU_CTL,
+				     SSB_CHIPCO_PMU_CTL_NOILPONW);
+		}
+	}
 	ssb_pmu_pll_init(cc);
 	ssb_pmu_resources_init(cc);
 }
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 17a1781..321d9ef 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -22,7 +22,6 @@
 
 #include "ssb_private.h"
 
-bool ssb_is_sprom_available(struct ssb_bus *bus);
 
 /* Define the following to 1 to enable a printk on each coreswitch. */
 #define SSB_VERBOSE_PCICORESWITCH_DEBUG		0
@@ -168,7 +167,7 @@ err_pci:
 }
 
 /* Get the word-offset for a SSB_SPROM_XXX define. */
-#define SPOFF(offset)	((offset) / sizeof(u16))
+#define SPOFF(offset)	(((offset) - SSB_SPROM_BASE1) / sizeof(u16))
 /* Helper to extract some _offset, which is one of the SSB_SPROM_XXX defines. */
 #define SPEX16(_outvar, _offset, _mask, _shift)	\
 	out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
@@ -253,11 +252,6 @@ static int sprom_do_read(struct ssb_bus *bus, u16 *sprom)
 {
 	int i;
 
-	/* Check if SPROM can be read */
-	if (ioread16(bus->mmio + bus->sprom_offset) == 0xFFFF) {
-		ssb_printk(KERN_ERR PFX "Unable to read SPROM\n");
-		return -ENODEV;
-	}
 	for (i = 0; i < bus->sprom_size; i++)
 		sprom[i] = ioread16(bus->mmio + bus->sprom_offset + (i * 2));
 
@@ -652,23 +646,17 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 	if (!buf)
 		goto out;
 	bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
-	err = sprom_do_read(bus, buf);
-	if (err)
-		goto out_free;
+	sprom_do_read(bus, buf);
 	err = sprom_check_crc(buf, bus->sprom_size);
 	if (err) {
 		/* try for a 440 byte SPROM - revision 4 and higher */
 		kfree(buf);
 		buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
 			      GFP_KERNEL);
-		if (!buf) {
-			err = -ENOMEM;
+		if (!buf)
 			goto out;
-		}
 		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
-		err = sprom_do_read(bus, buf);
-		if (err)
-			goto out_free;
+		sprom_do_read(bus, buf);
 		err = sprom_check_crc(buf, bus->sprom_size);
 		if (err) {
 			/* All CRC attempts failed.
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index e72f404..46a6fb5 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -745,7 +745,7 @@ int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 
 	/* Fetch the vendor specific tuples. */
 	res = pcmcia_loop_tuple(bus->host_pcmcia, SSB_PCMCIA_CIS,
-				ssb_pcmcia_do_get_invariants, sprom);
+				ssb_pcmcia_do_get_invariants, iv);
 	if ((res == 0) || (res == -ENOSPC))
 		return 0;
 
diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 43c57b7..8a05725 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -609,13 +609,13 @@ static ssize_t class_set_picture(struct device *device,
 
 #define ASUS_OLED_DEVICE_ATTR(_file)		dev_attr_asus_oled_##_file
 
-static DEVICE_ATTR(asus_oled_enabled, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(asus_oled_enabled, S_IWUSR | S_IRUGO,
 		   get_enabled, set_enabled);
-static DEVICE_ATTR(asus_oled_picture, S_IWUGO , NULL, set_picture);
+static DEVICE_ATTR(asus_oled_picture, S_IWUSR , NULL, set_picture);
 
-static DEVICE_ATTR(enabled, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(enabled, S_IWUSR | S_IRUGO,
 		   class_get_enabled, class_set_enabled);
-static DEVICE_ATTR(picture, S_IWUGO, NULL, class_set_picture);
+static DEVICE_ATTR(picture, S_IWUSR, NULL, class_set_picture);
 
 static int asus_oled_probe(struct usb_interface *interface,
 			   const struct usb_device_id *id)
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index bd39784..1d6385a 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -52,6 +52,7 @@ Devices: [JR3] PCI force sensor board (jr3_pci)
 
 #define PCI_VENDOR_ID_JR3 0x1762
 #define PCI_DEVICE_ID_JR3_1_CHANNEL 0x3111
+#define PCI_DEVICE_ID_JR3_1_CHANNEL_NEW 0x1111
 #define PCI_DEVICE_ID_JR3_2_CHANNEL 0x3112
 #define PCI_DEVICE_ID_JR3_3_CHANNEL 0x3113
 #define PCI_DEVICE_ID_JR3_4_CHANNEL 0x3114
@@ -71,6 +72,8 @@ static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
 	{
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
+	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW,
+		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL,
@@ -807,6 +810,10 @@ static int jr3_pci_attach(struct comedi_device *dev,
 					devpriv->n_channels = 1;
 				}
 				break;
+			case PCI_DEVICE_ID_JR3_1_CHANNEL_NEW:{
+					devpriv->n_channels = 1;
+				}
+				break;
 			case PCI_DEVICE_ID_JR3_2_CHANNEL:{
 					devpriv->n_channels = 2;
 				}
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index dc3f398..4ac745a 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -528,7 +528,8 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	/* grab our IRQ */
 	if (irq) {
 		isr_flags = 0;
-		if (thisboard->bustype == pci_bustype)
+		if (thisboard->bustype == pci_bustype
+		    || thisboard->bustype == pcmcia_bustype)
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
 				driver_labpc.driver_name, dev)) {
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index ef8fcc8..f6e04f8 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -202,7 +202,7 @@ static void usb_tranzport_abort_transfers(struct usb_tranzport *dev)
     t->value = temp;							\
     return count;							\
   }									\
-  static DEVICE_ATTR(value, S_IWUGO | S_IRUGO, show_##value, set_##value);
+  static DEVICE_ATTR(value, S_IWUSR | S_IRUGO, show_##value, set_##value);
 
 show_int(enable);
 show_int(offline);
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 62b2828..871a202 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -378,6 +378,7 @@ static int blkvsc_probe(struct device *device)
 		blkdev->gd->first_minor = 0;
 	blkdev->gd->fops = &block_ops;
 	blkdev->gd->private_data = blkdev;
+	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
 	blkvsc_do_inquiry(blkdev);
diff --git a/drivers/staging/line6/control.c b/drivers/staging/line6/control.c
index 0b59852..e414571 100644
--- a/drivers/staging/line6/control.c
+++ b/drivers/staging/line6/control.c
@@ -268,210 +268,210 @@ VARIAX_PARAM_R(float, mix2);
 VARIAX_PARAM_R(float, mix1);
 VARIAX_PARAM_R(int, pickup_wiring);
 
-static DEVICE_ATTR(tweak, S_IWUGO | S_IRUGO, pod_get_tweak, pod_set_tweak);
-static DEVICE_ATTR(wah_position, S_IWUGO | S_IRUGO, pod_get_wah_position,
+static DEVICE_ATTR(tweak, S_IWUSR | S_IRUGO, pod_get_tweak, pod_set_tweak);
+static DEVICE_ATTR(wah_position, S_IWUSR | S_IRUGO, pod_get_wah_position,
 		   pod_set_wah_position);
-static DEVICE_ATTR(compression_gain, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(compression_gain, S_IWUSR | S_IRUGO,
 		   pod_get_compression_gain, pod_set_compression_gain);
-static DEVICE_ATTR(vol_pedal_position, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(vol_pedal_position, S_IWUSR | S_IRUGO,
 		   pod_get_vol_pedal_position, pod_set_vol_pedal_position);
-static DEVICE_ATTR(compression_threshold, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(compression_threshold, S_IWUSR | S_IRUGO,
 		   pod_get_compression_threshold,
 		   pod_set_compression_threshold);
-static DEVICE_ATTR(pan, S_IWUGO | S_IRUGO, pod_get_pan, pod_set_pan);
-static DEVICE_ATTR(amp_model_setup, S_IWUGO | S_IRUGO, pod_get_amp_model_setup,
+static DEVICE_ATTR(pan, S_IWUSR | S_IRUGO, pod_get_pan, pod_set_pan);
+static DEVICE_ATTR(amp_model_setup, S_IWUSR | S_IRUGO, pod_get_amp_model_setup,
 		   pod_set_amp_model_setup);
-static DEVICE_ATTR(amp_model, S_IWUGO | S_IRUGO, pod_get_amp_model,
+static DEVICE_ATTR(amp_model, S_IWUSR | S_IRUGO, pod_get_amp_model,
 		   pod_set_amp_model);
-static DEVICE_ATTR(drive, S_IWUGO | S_IRUGO, pod_get_drive, pod_set_drive);
-static DEVICE_ATTR(bass, S_IWUGO | S_IRUGO, pod_get_bass, pod_set_bass);
-static DEVICE_ATTR(mid, S_IWUGO | S_IRUGO, pod_get_mid, pod_set_mid);
-static DEVICE_ATTR(lowmid, S_IWUGO | S_IRUGO, pod_get_lowmid, pod_set_lowmid);
-static DEVICE_ATTR(treble, S_IWUGO | S_IRUGO, pod_get_treble, pod_set_treble);
-static DEVICE_ATTR(highmid, S_IWUGO | S_IRUGO, pod_get_highmid,
+static DEVICE_ATTR(drive, S_IWUSR | S_IRUGO, pod_get_drive, pod_set_drive);
+static DEVICE_ATTR(bass, S_IWUSR | S_IRUGO, pod_get_bass, pod_set_bass);
+static DEVICE_ATTR(mid, S_IWUSR | S_IRUGO, pod_get_mid, pod_set_mid);
+static DEVICE_ATTR(lowmid, S_IWUSR | S_IRUGO, pod_get_lowmid, pod_set_lowmid);
+static DEVICE_ATTR(treble, S_IWUSR | S_IRUGO, pod_get_treble, pod_set_treble);
+static DEVICE_ATTR(highmid, S_IWUSR | S_IRUGO, pod_get_highmid,
 		   pod_set_highmid);
-static DEVICE_ATTR(chan_vol, S_IWUGO | S_IRUGO, pod_get_chan_vol,
+static DEVICE_ATTR(chan_vol, S_IWUSR | S_IRUGO, pod_get_chan_vol,
 		   pod_set_chan_vol);
-static DEVICE_ATTR(reverb_mix, S_IWUGO | S_IRUGO, pod_get_reverb_mix,
+static DEVICE_ATTR(reverb_mix, S_IWUSR | S_IRUGO, pod_get_reverb_mix,
 		   pod_set_reverb_mix);
-static DEVICE_ATTR(effect_setup, S_IWUGO | S_IRUGO, pod_get_effect_setup,
+static DEVICE_ATTR(effect_setup, S_IWUSR | S_IRUGO, pod_get_effect_setup,
 		   pod_set_effect_setup);
-static DEVICE_ATTR(band_1_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(band_1_frequency, S_IWUSR | S_IRUGO,
 		   pod_get_band_1_frequency, pod_set_band_1_frequency);
-static DEVICE_ATTR(presence, S_IWUGO | S_IRUGO, pod_get_presence,
+static DEVICE_ATTR(presence, S_IWUSR | S_IRUGO, pod_get_presence,
 		   pod_set_presence);
-static DEVICE_ATTR2(treble__bass, treble, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(treble__bass, treble, S_IWUSR | S_IRUGO,
 		    pod_get_treble__bass, pod_set_treble__bass);
-static DEVICE_ATTR(noise_gate_enable, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(noise_gate_enable, S_IWUSR | S_IRUGO,
 		   pod_get_noise_gate_enable, pod_set_noise_gate_enable);
-static DEVICE_ATTR(gate_threshold, S_IWUGO | S_IRUGO, pod_get_gate_threshold,
+static DEVICE_ATTR(gate_threshold, S_IWUSR | S_IRUGO, pod_get_gate_threshold,
 		   pod_set_gate_threshold);
-static DEVICE_ATTR(gate_decay_time, S_IWUGO | S_IRUGO, pod_get_gate_decay_time,
+static DEVICE_ATTR(gate_decay_time, S_IWUSR | S_IRUGO, pod_get_gate_decay_time,
 		   pod_set_gate_decay_time);
-static DEVICE_ATTR(stomp_enable, S_IWUGO | S_IRUGO, pod_get_stomp_enable,
+static DEVICE_ATTR(stomp_enable, S_IWUSR | S_IRUGO, pod_get_stomp_enable,
 		   pod_set_stomp_enable);
-static DEVICE_ATTR(comp_enable, S_IWUGO | S_IRUGO, pod_get_comp_enable,
+static DEVICE_ATTR(comp_enable, S_IWUSR | S_IRUGO, pod_get_comp_enable,
 		   pod_set_comp_enable);
-static DEVICE_ATTR(stomp_time, S_IWUGO | S_IRUGO, pod_get_stomp_time,
+static DEVICE_ATTR(stomp_time, S_IWUSR | S_IRUGO, pod_get_stomp_time,
 		   pod_set_stomp_time);
-static DEVICE_ATTR(delay_enable, S_IWUGO | S_IRUGO, pod_get_delay_enable,
+static DEVICE_ATTR(delay_enable, S_IWUSR | S_IRUGO, pod_get_delay_enable,
 		   pod_set_delay_enable);
-static DEVICE_ATTR(mod_param_1, S_IWUGO | S_IRUGO, pod_get_mod_param_1,
+static DEVICE_ATTR(mod_param_1, S_IWUSR | S_IRUGO, pod_get_mod_param_1,
 		   pod_set_mod_param_1);
-static DEVICE_ATTR(delay_param_1, S_IWUGO | S_IRUGO, pod_get_delay_param_1,
+static DEVICE_ATTR(delay_param_1, S_IWUSR | S_IRUGO, pod_get_delay_param_1,
 		   pod_set_delay_param_1);
-static DEVICE_ATTR(delay_param_1_note_value, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(delay_param_1_note_value, S_IWUSR | S_IRUGO,
 		   pod_get_delay_param_1_note_value,
 		   pod_set_delay_param_1_note_value);
-static DEVICE_ATTR2(band_2_frequency__bass, band_2_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_2_frequency__bass, band_2_frequency, S_IWUSR | S_IRUGO,
 		    pod_get_band_2_frequency__bass,
 		    pod_set_band_2_frequency__bass);
-static DEVICE_ATTR(delay_param_2, S_IWUGO | S_IRUGO, pod_get_delay_param_2,
+static DEVICE_ATTR(delay_param_2, S_IWUSR | S_IRUGO, pod_get_delay_param_2,
 		   pod_set_delay_param_2);
-static DEVICE_ATTR(delay_volume_mix, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(delay_volume_mix, S_IWUSR | S_IRUGO,
 		   pod_get_delay_volume_mix, pod_set_delay_volume_mix);
-static DEVICE_ATTR(delay_param_3, S_IWUGO | S_IRUGO, pod_get_delay_param_3,
+static DEVICE_ATTR(delay_param_3, S_IWUSR | S_IRUGO, pod_get_delay_param_3,
 		   pod_set_delay_param_3);
-static DEVICE_ATTR(reverb_enable, S_IWUGO | S_IRUGO, pod_get_reverb_enable,
+static DEVICE_ATTR(reverb_enable, S_IWUSR | S_IRUGO, pod_get_reverb_enable,
 		   pod_set_reverb_enable);
-static DEVICE_ATTR(reverb_type, S_IWUGO | S_IRUGO, pod_get_reverb_type,
+static DEVICE_ATTR(reverb_type, S_IWUSR | S_IRUGO, pod_get_reverb_type,
 		   pod_set_reverb_type);
-static DEVICE_ATTR(reverb_decay, S_IWUGO | S_IRUGO, pod_get_reverb_decay,
+static DEVICE_ATTR(reverb_decay, S_IWUSR | S_IRUGO, pod_get_reverb_decay,
 		   pod_set_reverb_decay);
-static DEVICE_ATTR(reverb_tone, S_IWUGO | S_IRUGO, pod_get_reverb_tone,
+static DEVICE_ATTR(reverb_tone, S_IWUSR | S_IRUGO, pod_get_reverb_tone,
 		   pod_set_reverb_tone);
-static DEVICE_ATTR(reverb_pre_delay, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(reverb_pre_delay, S_IWUSR | S_IRUGO,
 		   pod_get_reverb_pre_delay, pod_set_reverb_pre_delay);
-static DEVICE_ATTR(reverb_pre_post, S_IWUGO | S_IRUGO, pod_get_reverb_pre_post,
+static DEVICE_ATTR(reverb_pre_post, S_IWUSR | S_IRUGO, pod_get_reverb_pre_post,
 		   pod_set_reverb_pre_post);
-static DEVICE_ATTR(band_2_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(band_2_frequency, S_IWUSR | S_IRUGO,
 		   pod_get_band_2_frequency, pod_set_band_2_frequency);
-static DEVICE_ATTR2(band_3_frequency__bass, band_3_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_3_frequency__bass, band_3_frequency, S_IWUSR | S_IRUGO,
 		    pod_get_band_3_frequency__bass,
 		    pod_set_band_3_frequency__bass);
-static DEVICE_ATTR(wah_enable, S_IWUGO | S_IRUGO, pod_get_wah_enable,
+static DEVICE_ATTR(wah_enable, S_IWUSR | S_IRUGO, pod_get_wah_enable,
 		   pod_set_wah_enable);
-static DEVICE_ATTR(modulation_lo_cut, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(modulation_lo_cut, S_IWUSR | S_IRUGO,
 		   pod_get_modulation_lo_cut, pod_set_modulation_lo_cut);
-static DEVICE_ATTR(delay_reverb_lo_cut, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(delay_reverb_lo_cut, S_IWUSR | S_IRUGO,
 		   pod_get_delay_reverb_lo_cut, pod_set_delay_reverb_lo_cut);
-static DEVICE_ATTR(volume_pedal_minimum, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(volume_pedal_minimum, S_IWUSR | S_IRUGO,
 		   pod_get_volume_pedal_minimum, pod_set_volume_pedal_minimum);
-static DEVICE_ATTR(eq_pre_post, S_IWUGO | S_IRUGO, pod_get_eq_pre_post,
+static DEVICE_ATTR(eq_pre_post, S_IWUSR | S_IRUGO, pod_get_eq_pre_post,
 		   pod_set_eq_pre_post);
-static DEVICE_ATTR(volume_pre_post, S_IWUGO | S_IRUGO, pod_get_volume_pre_post,
+static DEVICE_ATTR(volume_pre_post, S_IWUSR | S_IRUGO, pod_get_volume_pre_post,
 		   pod_set_volume_pre_post);
-static DEVICE_ATTR(di_model, S_IWUGO | S_IRUGO, pod_get_di_model,
+static DEVICE_ATTR(di_model, S_IWUSR | S_IRUGO, pod_get_di_model,
 		   pod_set_di_model);
-static DEVICE_ATTR(di_delay, S_IWUGO | S_IRUGO, pod_get_di_delay,
+static DEVICE_ATTR(di_delay, S_IWUSR | S_IRUGO, pod_get_di_delay,
 		   pod_set_di_delay);
-static DEVICE_ATTR(mod_enable, S_IWUGO | S_IRUGO, pod_get_mod_enable,
+static DEVICE_ATTR(mod_enable, S_IWUSR | S_IRUGO, pod_get_mod_enable,
 		   pod_set_mod_enable);
-static DEVICE_ATTR(mod_param_1_note_value, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(mod_param_1_note_value, S_IWUSR | S_IRUGO,
 		   pod_get_mod_param_1_note_value,
 		   pod_set_mod_param_1_note_value);
-static DEVICE_ATTR(mod_param_2, S_IWUGO | S_IRUGO, pod_get_mod_param_2,
+static DEVICE_ATTR(mod_param_2, S_IWUSR | S_IRUGO, pod_get_mod_param_2,
 		   pod_set_mod_param_2);
-static DEVICE_ATTR(mod_param_3, S_IWUGO | S_IRUGO, pod_get_mod_param_3,
+static DEVICE_ATTR(mod_param_3, S_IWUSR | S_IRUGO, pod_get_mod_param_3,
 		   pod_set_mod_param_3);
-static DEVICE_ATTR(mod_param_4, S_IWUGO | S_IRUGO, pod_get_mod_param_4,
+static DEVICE_ATTR(mod_param_4, S_IWUSR | S_IRUGO, pod_get_mod_param_4,
 		   pod_set_mod_param_4);
-static DEVICE_ATTR(mod_param_5, S_IWUGO | S_IRUGO, pod_get_mod_param_5,
+static DEVICE_ATTR(mod_param_5, S_IWUSR | S_IRUGO, pod_get_mod_param_5,
 		   pod_set_mod_param_5);
-static DEVICE_ATTR(mod_volume_mix, S_IWUGO | S_IRUGO, pod_get_mod_volume_mix,
+static DEVICE_ATTR(mod_volume_mix, S_IWUSR | S_IRUGO, pod_get_mod_volume_mix,
 		   pod_set_mod_volume_mix);
-static DEVICE_ATTR(mod_pre_post, S_IWUGO | S_IRUGO, pod_get_mod_pre_post,
+static DEVICE_ATTR(mod_pre_post, S_IWUSR | S_IRUGO, pod_get_mod_pre_post,
 		   pod_set_mod_pre_post);
-static DEVICE_ATTR(modulation_model, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(modulation_model, S_IWUSR | S_IRUGO,
 		   pod_get_modulation_model, pod_set_modulation_model);
-static DEVICE_ATTR(band_3_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(band_3_frequency, S_IWUSR | S_IRUGO,
 		   pod_get_band_3_frequency, pod_set_band_3_frequency);
-static DEVICE_ATTR2(band_4_frequency__bass, band_4_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_4_frequency__bass, band_4_frequency, S_IWUSR | S_IRUGO,
 		    pod_get_band_4_frequency__bass,
 		    pod_set_band_4_frequency__bass);
-static DEVICE_ATTR(mod_param_1_double_precision, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(mod_param_1_double_precision, S_IWUSR | S_IRUGO,
 		   pod_get_mod_param_1_double_precision,
 		   pod_set_mod_param_1_double_precision);
-static DEVICE_ATTR(delay_param_1_double_precision, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(delay_param_1_double_precision, S_IWUSR | S_IRUGO,
 		   pod_get_delay_param_1_double_precision,
 		   pod_set_delay_param_1_double_precision);
-static DEVICE_ATTR(eq_enable, S_IWUGO | S_IRUGO, pod_get_eq_enable,
+static DEVICE_ATTR(eq_enable, S_IWUSR | S_IRUGO, pod_get_eq_enable,
 		   pod_set_eq_enable);
-static DEVICE_ATTR(tap, S_IWUGO | S_IRUGO, pod_get_tap, pod_set_tap);
-static DEVICE_ATTR(volume_tweak_pedal_assign, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(tap, S_IWUSR | S_IRUGO, pod_get_tap, pod_set_tap);
+static DEVICE_ATTR(volume_tweak_pedal_assign, S_IWUSR | S_IRUGO,
 		   pod_get_volume_tweak_pedal_assign,
 		   pod_set_volume_tweak_pedal_assign);
-static DEVICE_ATTR(band_5_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(band_5_frequency, S_IWUSR | S_IRUGO,
 		   pod_get_band_5_frequency, pod_set_band_5_frequency);
-static DEVICE_ATTR(tuner, S_IWUGO | S_IRUGO, pod_get_tuner, pod_set_tuner);
-static DEVICE_ATTR(mic_selection, S_IWUGO | S_IRUGO, pod_get_mic_selection,
+static DEVICE_ATTR(tuner, S_IWUSR | S_IRUGO, pod_get_tuner, pod_set_tuner);
+static DEVICE_ATTR(mic_selection, S_IWUSR | S_IRUGO, pod_get_mic_selection,
 		   pod_set_mic_selection);
-static DEVICE_ATTR(cabinet_model, S_IWUGO | S_IRUGO, pod_get_cabinet_model,
+static DEVICE_ATTR(cabinet_model, S_IWUSR | S_IRUGO, pod_get_cabinet_model,
 		   pod_set_cabinet_model);
-static DEVICE_ATTR(stomp_model, S_IWUGO | S_IRUGO, pod_get_stomp_model,
+static DEVICE_ATTR(stomp_model, S_IWUSR | S_IRUGO, pod_get_stomp_model,
 		   pod_set_stomp_model);
-static DEVICE_ATTR(roomlevel, S_IWUGO | S_IRUGO, pod_get_roomlevel,
+static DEVICE_ATTR(roomlevel, S_IWUSR | S_IRUGO, pod_get_roomlevel,
 		   pod_set_roomlevel);
-static DEVICE_ATTR(band_4_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(band_4_frequency, S_IWUSR | S_IRUGO,
 		   pod_get_band_4_frequency, pod_set_band_4_frequency);
-static DEVICE_ATTR(band_6_frequency, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(band_6_frequency, S_IWUSR | S_IRUGO,
 		   pod_get_band_6_frequency, pod_set_band_6_frequency);
-static DEVICE_ATTR(stomp_param_1_note_value, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(stomp_param_1_note_value, S_IWUSR | S_IRUGO,
 		   pod_get_stomp_param_1_note_value,
 		   pod_set_stomp_param_1_note_value);
-static DEVICE_ATTR(stomp_param_2, S_IWUGO | S_IRUGO, pod_get_stomp_param_2,
+static DEVICE_ATTR(stomp_param_2, S_IWUSR | S_IRUGO, pod_get_stomp_param_2,
 		   pod_set_stomp_param_2);
-static DEVICE_ATTR(stomp_param_3, S_IWUGO | S_IRUGO, pod_get_stomp_param_3,
+static DEVICE_ATTR(stomp_param_3, S_IWUSR | S_IRUGO, pod_get_stomp_param_3,
 		   pod_set_stomp_param_3);
-static DEVICE_ATTR(stomp_param_4, S_IWUGO | S_IRUGO, pod_get_stomp_param_4,
+static DEVICE_ATTR(stomp_param_4, S_IWUSR | S_IRUGO, pod_get_stomp_param_4,
 		   pod_set_stomp_param_4);
-static DEVICE_ATTR(stomp_param_5, S_IWUGO | S_IRUGO, pod_get_stomp_param_5,
+static DEVICE_ATTR(stomp_param_5, S_IWUSR | S_IRUGO, pod_get_stomp_param_5,
 		   pod_set_stomp_param_5);
-static DEVICE_ATTR(stomp_param_6, S_IWUGO | S_IRUGO, pod_get_stomp_param_6,
+static DEVICE_ATTR(stomp_param_6, S_IWUSR | S_IRUGO, pod_get_stomp_param_6,
 		   pod_set_stomp_param_6);
-static DEVICE_ATTR(amp_switch_select, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(amp_switch_select, S_IWUSR | S_IRUGO,
 		   pod_get_amp_switch_select, pod_set_amp_switch_select);
-static DEVICE_ATTR(delay_param_4, S_IWUGO | S_IRUGO, pod_get_delay_param_4,
+static DEVICE_ATTR(delay_param_4, S_IWUSR | S_IRUGO, pod_get_delay_param_4,
 		   pod_set_delay_param_4);
-static DEVICE_ATTR(delay_param_5, S_IWUGO | S_IRUGO, pod_get_delay_param_5,
+static DEVICE_ATTR(delay_param_5, S_IWUSR | S_IRUGO, pod_get_delay_param_5,
 		   pod_set_delay_param_5);
-static DEVICE_ATTR(delay_pre_post, S_IWUGO | S_IRUGO, pod_get_delay_pre_post,
+static DEVICE_ATTR(delay_pre_post, S_IWUSR | S_IRUGO, pod_get_delay_pre_post,
 		   pod_set_delay_pre_post);
-static DEVICE_ATTR(delay_model, S_IWUGO | S_IRUGO, pod_get_delay_model,
+static DEVICE_ATTR(delay_model, S_IWUSR | S_IRUGO, pod_get_delay_model,
 		   pod_set_delay_model);
-static DEVICE_ATTR(delay_verb_model, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(delay_verb_model, S_IWUSR | S_IRUGO,
 		   pod_get_delay_verb_model, pod_set_delay_verb_model);
-static DEVICE_ATTR(tempo_msb, S_IWUGO | S_IRUGO, pod_get_tempo_msb,
+static DEVICE_ATTR(tempo_msb, S_IWUSR | S_IRUGO, pod_get_tempo_msb,
 		   pod_set_tempo_msb);
-static DEVICE_ATTR(tempo_lsb, S_IWUGO | S_IRUGO, pod_get_tempo_lsb,
+static DEVICE_ATTR(tempo_lsb, S_IWUSR | S_IRUGO, pod_get_tempo_lsb,
 		   pod_set_tempo_lsb);
-static DEVICE_ATTR(wah_model, S_IWUGO | S_IRUGO, pod_get_wah_model,
+static DEVICE_ATTR(wah_model, S_IWUSR | S_IRUGO, pod_get_wah_model,
 		   pod_set_wah_model);
-static DEVICE_ATTR(bypass_volume, S_IWUGO | S_IRUGO, pod_get_bypass_volume,
+static DEVICE_ATTR(bypass_volume, S_IWUSR | S_IRUGO, pod_get_bypass_volume,
 		   pod_set_bypass_volume);
-static DEVICE_ATTR(fx_loop_on_off, S_IWUGO | S_IRUGO, pod_get_fx_loop_on_off,
+static DEVICE_ATTR(fx_loop_on_off, S_IWUSR | S_IRUGO, pod_get_fx_loop_on_off,
 		   pod_set_fx_loop_on_off);
-static DEVICE_ATTR(tweak_param_select, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(tweak_param_select, S_IWUSR | S_IRUGO,
 		   pod_get_tweak_param_select, pod_set_tweak_param_select);
-static DEVICE_ATTR(amp1_engage, S_IWUGO | S_IRUGO, pod_get_amp1_engage,
+static DEVICE_ATTR(amp1_engage, S_IWUSR | S_IRUGO, pod_get_amp1_engage,
 		   pod_set_amp1_engage);
-static DEVICE_ATTR(band_1_gain, S_IWUGO | S_IRUGO, pod_get_band_1_gain,
+static DEVICE_ATTR(band_1_gain, S_IWUSR | S_IRUGO, pod_get_band_1_gain,
 		   pod_set_band_1_gain);
-static DEVICE_ATTR2(band_2_gain__bass, band_2_gain, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_2_gain__bass, band_2_gain, S_IWUSR | S_IRUGO,
 		    pod_get_band_2_gain__bass, pod_set_band_2_gain__bass);
-static DEVICE_ATTR(band_2_gain, S_IWUGO | S_IRUGO, pod_get_band_2_gain,
+static DEVICE_ATTR(band_2_gain, S_IWUSR | S_IRUGO, pod_get_band_2_gain,
 		   pod_set_band_2_gain);
-static DEVICE_ATTR2(band_3_gain__bass, band_3_gain, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_3_gain__bass, band_3_gain, S_IWUSR | S_IRUGO,
 		    pod_get_band_3_gain__bass, pod_set_band_3_gain__bass);
-static DEVICE_ATTR(band_3_gain, S_IWUGO | S_IRUGO, pod_get_band_3_gain,
+static DEVICE_ATTR(band_3_gain, S_IWUSR | S_IRUGO, pod_get_band_3_gain,
 		   pod_set_band_3_gain);
-static DEVICE_ATTR2(band_4_gain__bass, band_4_gain, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_4_gain__bass, band_4_gain, S_IWUSR | S_IRUGO,
 		    pod_get_band_4_gain__bass, pod_set_band_4_gain__bass);
-static DEVICE_ATTR2(band_5_gain__bass, band_5_gain, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_5_gain__bass, band_5_gain, S_IWUSR | S_IRUGO,
 		    pod_get_band_5_gain__bass, pod_set_band_5_gain__bass);
-static DEVICE_ATTR(band_4_gain, S_IWUGO | S_IRUGO, pod_get_band_4_gain,
+static DEVICE_ATTR(band_4_gain, S_IWUSR | S_IRUGO, pod_get_band_4_gain,
 		   pod_set_band_4_gain);
-static DEVICE_ATTR2(band_6_gain__bass, band_6_gain, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR2(band_6_gain__bass, band_6_gain, S_IWUSR | S_IRUGO,
 		    pod_get_band_6_gain__bass, pod_set_band_6_gain__bass);
 static DEVICE_ATTR(body, S_IRUGO, variax_get_body, line6_nop_write);
 static DEVICE_ATTR(pickup1_enable, S_IRUGO, variax_get_pickup1_enable,
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 6ef4455..b174750f 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -361,8 +361,8 @@ static ssize_t midi_set_midi_mask_receive(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(midi_mask_transmit, S_IWUGO | S_IRUGO, midi_get_midi_mask_transmit, midi_set_midi_mask_transmit);
-static DEVICE_ATTR(midi_mask_receive, S_IWUGO | S_IRUGO, midi_get_midi_mask_receive, midi_set_midi_mask_receive);
+static DEVICE_ATTR(midi_mask_transmit, S_IWUSR | S_IRUGO, midi_get_midi_mask_transmit, midi_set_midi_mask_transmit);
+static DEVICE_ATTR(midi_mask_receive, S_IWUSR | S_IRUGO, midi_get_midi_mask_receive, midi_set_midi_mask_receive);
 
 /* MIDI device destructor */
 static int snd_line6_midi_free(struct snd_device *device)
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 685c529..b9b58aa 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -950,33 +950,33 @@ POD_GET_SYSTEM_PARAM(tuner_pitch, 1, 1);
 #undef GET_SYSTEM_PARAM
 
 /* POD special files: */
-static DEVICE_ATTR(channel, S_IWUGO | S_IRUGO, pod_get_channel, pod_set_channel);
+static DEVICE_ATTR(channel, S_IWUSR | S_IRUGO, pod_get_channel, pod_set_channel);
 static DEVICE_ATTR(clip, S_IRUGO, pod_wait_for_clip, line6_nop_write);
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
 static DEVICE_ATTR(dirty, S_IRUGO, pod_get_dirty, line6_nop_write);
-static DEVICE_ATTR(dump, S_IWUGO | S_IRUGO, pod_get_dump, pod_set_dump);
-static DEVICE_ATTR(dump_buf, S_IWUGO | S_IRUGO, pod_get_dump_buf, pod_set_dump_buf);
-static DEVICE_ATTR(finish, S_IWUGO, line6_nop_read, pod_set_finish);
+static DEVICE_ATTR(dump, S_IWUSR | S_IRUGO, pod_get_dump, pod_set_dump);
+static DEVICE_ATTR(dump_buf, S_IWUSR | S_IRUGO, pod_get_dump_buf, pod_set_dump_buf);
+static DEVICE_ATTR(finish, S_IWUSR, line6_nop_read, pod_set_finish);
 static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version, line6_nop_write);
-static DEVICE_ATTR(midi_postprocess, S_IWUGO | S_IRUGO, pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(monitor_level, S_IWUGO | S_IRUGO, pod_get_monitor_level, pod_set_monitor_level);
+static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO, pod_get_midi_postprocess, pod_set_midi_postprocess);
+static DEVICE_ATTR(monitor_level, S_IWUSR | S_IRUGO, pod_get_monitor_level, pod_set_monitor_level);
 static DEVICE_ATTR(name, S_IRUGO, pod_get_name, line6_nop_write);
 static DEVICE_ATTR(name_buf, S_IRUGO, pod_get_name_buf, line6_nop_write);
-static DEVICE_ATTR(retrieve_amp_setup, S_IWUGO, line6_nop_read, pod_set_retrieve_amp_setup);
-static DEVICE_ATTR(retrieve_channel, S_IWUGO, line6_nop_read, pod_set_retrieve_channel);
-static DEVICE_ATTR(retrieve_effects_setup, S_IWUGO, line6_nop_read, pod_set_retrieve_effects_setup);
-static DEVICE_ATTR(routing, S_IWUGO | S_IRUGO, pod_get_routing, pod_set_routing);
+static DEVICE_ATTR(retrieve_amp_setup, S_IWUSR, line6_nop_read, pod_set_retrieve_amp_setup);
+static DEVICE_ATTR(retrieve_channel, S_IWUSR, line6_nop_read, pod_set_retrieve_channel);
+static DEVICE_ATTR(retrieve_effects_setup, S_IWUSR, line6_nop_read, pod_set_retrieve_effects_setup);
+static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing, pod_set_routing);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number, line6_nop_write);
-static DEVICE_ATTR(store_amp_setup, S_IWUGO, line6_nop_read, pod_set_store_amp_setup);
-static DEVICE_ATTR(store_channel, S_IWUGO, line6_nop_read, pod_set_store_channel);
-static DEVICE_ATTR(store_effects_setup, S_IWUGO, line6_nop_read, pod_set_store_effects_setup);
-static DEVICE_ATTR(tuner_freq, S_IWUGO | S_IRUGO, pod_get_tuner_freq, pod_set_tuner_freq);
-static DEVICE_ATTR(tuner_mute, S_IWUGO | S_IRUGO, pod_get_tuner_mute, pod_set_tuner_mute);
+static DEVICE_ATTR(store_amp_setup, S_IWUSR, line6_nop_read, pod_set_store_amp_setup);
+static DEVICE_ATTR(store_channel, S_IWUSR, line6_nop_read, pod_set_store_channel);
+static DEVICE_ATTR(store_effects_setup, S_IWUSR, line6_nop_read, pod_set_store_effects_setup);
+static DEVICE_ATTR(tuner_freq, S_IWUSR | S_IRUGO, pod_get_tuner_freq, pod_set_tuner_freq);
+static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute, pod_set_tuner_mute);
 static DEVICE_ATTR(tuner_note, S_IRUGO, pod_get_tuner_note, line6_nop_write);
 static DEVICE_ATTR(tuner_pitch, S_IRUGO, pod_get_tuner_pitch, line6_nop_write);
 
 #if CREATE_RAW_FILE
-static DEVICE_ATTR(raw, S_IWUGO, line6_nop_read, line6_set_raw);
+static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
 #endif
 
 /*
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index e6770ea..db42178 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -124,9 +124,9 @@ static ssize_t toneport_set_led_green(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(led_red, S_IWUGO | S_IRUGO, line6_nop_read,
+static DEVICE_ATTR(led_red, S_IWUSR | S_IRUGO, line6_nop_read,
 		   toneport_set_led_red);
-static DEVICE_ATTR(led_green, S_IWUGO | S_IRUGO, line6_nop_read,
+static DEVICE_ATTR(led_green, S_IWUSR | S_IRUGO, line6_nop_read,
 		   toneport_set_led_green);
 
 static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2)
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 48d834b..e410e60 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -387,17 +387,17 @@ static ssize_t variax_set_raw2(struct device *dev,
 #endif
 
 /* Variax workbench special files: */
-static DEVICE_ATTR(model, S_IWUGO | S_IRUGO, variax_get_model, variax_set_model);
-static DEVICE_ATTR(volume, S_IWUGO | S_IRUGO, variax_get_volume, variax_set_volume);
-static DEVICE_ATTR(tone, S_IWUGO | S_IRUGO, variax_get_tone, variax_set_tone);
+static DEVICE_ATTR(model, S_IWUSR | S_IRUGO, variax_get_model, variax_set_model);
+static DEVICE_ATTR(volume, S_IWUSR | S_IRUGO, variax_get_volume, variax_set_volume);
+static DEVICE_ATTR(tone, S_IWUSR | S_IRUGO, variax_get_tone, variax_set_tone);
 static DEVICE_ATTR(name, S_IRUGO, variax_get_name, line6_nop_write);
 static DEVICE_ATTR(bank, S_IRUGO, variax_get_bank, line6_nop_write);
 static DEVICE_ATTR(dump, S_IRUGO, variax_get_dump, line6_nop_write);
-static DEVICE_ATTR(active, S_IWUGO | S_IRUGO, variax_get_active, variax_set_active);
+static DEVICE_ATTR(active, S_IWUSR | S_IRUGO, variax_get_active, variax_set_active);
 
 #if CREATE_RAW_FILE
-static DEVICE_ATTR(raw, S_IWUGO, line6_nop_read, line6_set_raw);
-static DEVICE_ATTR(raw2, S_IWUGO, line6_nop_read, variax_set_raw2);
+static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
+static DEVICE_ATTR(raw2, S_IWUSR, line6_nop_read, variax_set_raw2);
 #endif
 
 
diff --git a/drivers/staging/rt2860/chips/rt3090.c b/drivers/staging/rt2860/chips/rt3090.c
index 5927ba4..5ff81ec 100644
--- a/drivers/staging/rt2860/chips/rt3090.c
+++ b/drivers/staging/rt2860/chips/rt3090.c
@@ -51,7 +51,8 @@ void NICInitRT3090RFRegisters(struct rt_rtmp_adapter *pAd)
 	if (IS_RT3090(pAd)) {
 		/* Init RF calibration */
 		/* Driver should toggle RF R30 bit7 before init RF registers */
-		u32 RfReg = 0, data;
+		u8 RfReg;
+		u32 data;
 
 		RT30xxReadRFRegister(pAd, RF_R30, (u8 *)& RfReg);
 		RfReg |= 0x80;
diff --git a/drivers/staging/rt2860/chips/rt30xx.c b/drivers/staging/rt2860/chips/rt30xx.c
index 6e684a3..777b333 100644
--- a/drivers/staging/rt2860/chips/rt30xx.c
+++ b/drivers/staging/rt2860/chips/rt30xx.c
@@ -53,7 +53,7 @@ struct rt_reg_pair RT30xx_RFRegTable[] = {
 	,
 	{RF_R06, 0x02}
 	,
-	{RF_R07, 0x70}
+	{RF_R07, 0x60}
 	,
 	{RF_R09, 0x0F}
 	,
@@ -444,7 +444,7 @@ void RT30xxReverseRFSleepModeSetup(struct rt_rtmp_adapter *pAd)
 
 		/* VCO_IC, RF R7 register Bit 4 & Bit 5 to 1 */
 		RT30xxReadRFRegister(pAd, RF_R07, &RFValue);
-		RFValue |= 0x30;
+		RFValue |= 0x20;
 		RT30xxWriteRFRegister(pAd, RF_R07, RFValue);
 
 		/* Idoh, RF R9 register Bit 1, Bit 2 & Bit 3 to 1 */
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index c3d9280..df559da 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -483,8 +483,6 @@ struct net_device *RtmpPhyNetDevInit(struct rt_rtmp_adapter *pAd,
 	net_dev->ml_priv = (void *)pAd;
 	pAd->net_dev = net_dev;
 
-	netif_stop_queue(net_dev);
-
 	return net_dev;
 
 }
diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index 2ebc599..9a27f1b 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -141,6 +141,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x2001, 0x3C09)},	/* D-Link */
 	{USB_DEVICE(0x2001, 0x3C0A)},	/* D-Link 3072 */
 	{USB_DEVICE(0x2019, 0xED14)},	/* Planex Communications, Inc. */
+	{USB_DEVICE(0x0411, 0x015D)},	/* Buffalo Airstation WLI-UC-GN */
 	{}			/* Terminating entry */
 };
 
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 50309f2..7146706 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -356,8 +356,12 @@ HwHSSIThreeWire(
 			}
 			udelay(10);
 		}
-		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT)
-			panic("HwThreeWire(): CmdReg: %#X RE|WE bits are not clear!!\n", u1bTmp);
+		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
+			printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
+			       " %#X RE|WE bits are not clear!!\n", u1bTmp);
+			dump_stack();
+			return 0;
+		}
 
 		// RTL8187S HSSI Read/Write Function
 		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
@@ -397,13 +401,23 @@ HwHSSIThreeWire(
 				int idx;
 				int ByteCnt = nDataBufBitCnt / 8;
                                 //printk("%d\n",nDataBufBitCnt);
-				if ((nDataBufBitCnt % 8) != 0)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should be multiple of 8!!!\n",
-				nDataBufBitCnt);
+				if ((nDataBufBitCnt % 8) != 0) {
+					printk(KERN_ERR "rtl8187se: "
+					       "HwThreeWire(): nDataBufBitCnt(%d)"
+					       " should be multiple of 8!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt += 8;
+					nDataBufBitCnt &= ~7;
+				}
 
-			       if (nDataBufBitCnt > 64)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should <= 64!!!\n",
-				nDataBufBitCnt);
+			       if (nDataBufBitCnt > 64) {
+					printk(KERN_ERR "rtl8187se: HwThreeWire():"
+					       " nDataBufBitCnt(%d) should <= 64!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt = 64;
+				}
 
 				for(idx = 0; idx < ByteCnt; idx++)
 				{
diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 4877138..218e000 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -355,7 +355,7 @@ static ssize_t set_silent_state(struct device *dev,
 	}
 	return count;
 }
-static DEVICE_ATTR(silent, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(silent, S_IWUSR | S_IRUGO,
 		   get_silent_state, set_silent_state);
 
 
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index a2566f1..af3832b 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -38,21 +38,13 @@ static int event_handler(struct usbip_device *ud)
 			ud->eh_ops.shutdown(ud);
 
 			ud->event &= ~USBIP_EH_SHUTDOWN;
-
-			break;
 		}
 
-		/* Stop the error handler. */
-		if (ud->event & USBIP_EH_BYE)
-			return -1;
-
 		/* Reset the device. */
 		if (ud->event & USBIP_EH_RESET) {
 			ud->eh_ops.reset(ud);
 
 			ud->event &= ~USBIP_EH_RESET;
-
-			break;
 		}
 
 		/* Mark the device as unusable. */
@@ -60,13 +52,11 @@ static int event_handler(struct usbip_device *ud)
 			ud->eh_ops.unusable(ud);
 
 			ud->event &= ~USBIP_EH_UNUSABLE;
-
-			break;
 		}
 
-		/* NOTREACHED */
-		printk(KERN_ERR "%s: unknown event\n", __func__);
-		return -1;
+		/* Stop the error handler. */
+		if (ud->event & USBIP_EH_BYE)
+			return -1;
 	}
 
 	return 0;
diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index 5e37517..57f7946 100644
--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -100,9 +100,6 @@ struct vhci_hcd {
 	 * But, the index of this array begins from 0.
 	 */
 	struct vhci_device vdev[VHCI_NPORTS];
-
-	/* vhci_device which has not been assiged its address yet */
-	int pending_port;
 };
 
 
@@ -119,6 +116,9 @@ void rh_port_disconnect(int rhport);
 void vhci_rx_loop(struct usbip_task *ut);
 void vhci_tx_loop(struct usbip_task *ut);
 
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+					    __u32 seqnum);
+
 #define hardware		(&the_controller->pdev.dev)
 
 static inline struct vhci_device *port_to_vdev(__u32 port)
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index ef43713..16cb6d5 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -137,8 +137,6 @@ void rh_port_connect(int rhport, enum usb_device_speed speed)
 	 * the_controller->vdev[rhport].ud.status = VDEV_CONNECT;
 	 * spin_unlock(&the_controller->vdev[rhport].ud.lock); */
 
-	the_controller->pending_port = rhport;
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
@@ -163,6 +161,8 @@ void rh_port_disconnect(int rhport)
 	 * spin_unlock(&vdev->ud.lock); */
 
 	spin_unlock_irqrestore(&the_controller->lock, flags);
+
+	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
 
@@ -556,6 +556,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct device *dev = &urb->dev->dev;
 	int ret = 0;
 	unsigned long flags;
+	struct vhci_device *vdev;
 
 	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
 		    hcd, urb, mem_flags);
@@ -571,6 +572,18 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		return urb->status;
 	}
 
+	vdev = port_to_vdev(urb->dev->portnum-1);
+
+	/* refuse enqueue for dead connection */
+	spin_lock(&vdev->ud.lock);
+	if (vdev->ud.status == VDEV_ST_NULL || vdev->ud.status == VDEV_ST_ERROR) {
+		usbip_uerr("enqueue for inactive port %d\n", vdev->rhport);
+		spin_unlock(&vdev->ud.lock);
+		spin_unlock_irqrestore(&the_controller->lock, flags);
+		return -ENODEV;
+	}
+	spin_unlock(&vdev->ud.lock);
+
 	ret = usb_hcd_link_urb_to_ep(hcd, urb);
 	if (ret)
 		goto no_need_unlink;
@@ -589,8 +602,6 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		__u8 type = usb_pipetype(urb->pipe);
 		struct usb_ctrlrequest *ctrlreq =
 				(struct usb_ctrlrequest *) urb->setup_packet;
-		struct vhci_device *vdev =
-				port_to_vdev(the_controller->pending_port);
 
 		if (type != PIPE_CONTROL || !ctrlreq) {
 			dev_err(dev, "invalid request to devnum 0\n");
@@ -604,7 +615,9 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 			dev_info(dev, "SetAddress Request (%d) to port %d\n",
 				 ctrlreq->wValue, vdev->rhport);
 
-			vdev->udev = urb->dev;
+			if (vdev->udev)
+				usb_put_dev(vdev->udev);
+			vdev->udev = usb_get_dev(urb->dev);
 
 			spin_lock(&vdev->ud.lock);
 			vdev->ud.status = VDEV_ST_USED;
@@ -624,8 +637,9 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 						"Get_Descriptor to device 0 "
 						"(get max pipe size)\n");
 
-			/* FIXME: reference count? (usb_get_dev()) */
-			vdev->udev = urb->dev;
+			if (vdev->udev)
+				usb_put_dev(vdev->udev);
+			vdev->udev = usb_get_dev(urb->dev);
 			goto out;
 
 		default:
@@ -796,27 +810,12 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
 	}
 
-
-	if (!vdev->ud.tcp_socket) {
-		/* tcp connection is closed */
-		usbip_uinfo("vhci_hcd: vhci_urb_dequeue() gives back urb %p\n",
-									urb);
-
-		usb_hcd_unlink_urb_from_ep(hcd, urb);
-
-		spin_unlock_irqrestore(&the_controller->lock, flags);
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-								urb->status);
-		spin_lock_irqsave(&the_controller->lock, flags);
-	}
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usbip_dbg_vhci_hc("leave\n");
 	return 0;
 }
 
-
 static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 {
 	struct vhci_unlink *unlink, *tmp;
@@ -824,11 +823,34 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		usbip_uinfo("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
 		list_del(&unlink->list);
 		kfree(unlink);
 	}
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_rx, list) {
+		struct urb *urb;
+
+		/* give back URB of unanswered unlink request */
+		usbip_uinfo("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			usbip_uinfo("the urb (seqnum %lu) was already given back\n",
+							unlink->unlink_seqnum);
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		spin_lock(&the_controller->lock);
+		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
+		spin_unlock(&the_controller->lock);
+
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
+
 		list_del(&unlink->list);
 		kfree(unlink);
 	}
@@ -898,6 +920,10 @@ static void vhci_device_reset(struct usbip_device *ud)
 	vdev->speed  = 0;
 	vdev->devid  = 0;
 
+	if (vdev->udev)
+		usb_put_dev(vdev->udev);
+	vdev->udev = NULL;
+
 	ud->tcp_socket = NULL;
 
 	ud->status = VDEV_ST_NULL;
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index 7636d86..2d989c4 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -21,16 +21,14 @@
 #include "vhci.h"
 
 
-/* get URB from transmitted urb queue */
-static struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+/* get URB from transmitted urb queue. caller must hold vdev->priv_lock */
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
 					    __u32 seqnum)
 {
 	struct vhci_priv *priv, *tmp;
 	struct urb *urb = NULL;
 	int status;
 
-	spin_lock(&vdev->priv_lock);
-
 	list_for_each_entry_safe(priv, tmp, &vdev->priv_rx, list) {
 		if (priv->seqnum == seqnum) {
 			urb = priv->urb;
@@ -61,8 +59,6 @@ static struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
 		}
 	}
 
-	spin_unlock(&vdev->priv_lock);
-
 	return urb;
 }
 
@@ -72,9 +68,11 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
 
+	spin_lock(&vdev->priv_lock);
 
 	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
 
+	spin_unlock(&vdev->priv_lock);
 
 	if (!urb) {
 		usbip_uerr("cannot find a urb of seqnum %u\n",
@@ -159,7 +157,12 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		return;
 	}
 
+	spin_lock(&vdev->priv_lock);
+
 	urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+
+	spin_unlock(&vdev->priv_lock);
+
 	if (!urb) {
 		/*
 		 * I get the result of a unlink request. But, it seems that I
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index c539524..a7cfe01 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2260,7 +2260,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_status, S_IWUGO | S_IRUGO, read_status, reboot);
+static DEVICE_ATTR(stat_status, S_IWUSR | S_IRUGO, read_status, reboot);
 
 static ssize_t read_human_status(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2323,7 +2323,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_human_status, S_IWUGO | S_IRUGO, read_human_status, NULL);
+static DEVICE_ATTR(stat_human_status, S_IRUGO, read_human_status, NULL);
 
 static ssize_t read_delin(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2355,7 +2355,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_delin, S_IWUGO | S_IRUGO, read_delin, NULL);
+static DEVICE_ATTR(stat_delin, S_IRUGO, read_delin, NULL);
 
 #define UEA_ATTR(name, reset) 					\
 								\
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 4fd67d6..6332fbb 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -946,10 +946,11 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
 
 static int proc_connectinfo(struct dev_state *ps, void __user *arg)
 {
-	struct usbdevfs_connectinfo ci;
+	struct usbdevfs_connectinfo ci = {
+		.devnum = ps->dev->devnum,
+		.slow = ps->dev->speed == USB_SPEED_LOW
+	};
 
-	ci.devnum = ps->dev->devnum;
-	ci.slow = ps->dev->speed == USB_SPEED_LOW;
 	if (copy_to_user(arg, &ci, sizeof(ci)))
 		return -EFAULT;
 	return 0;
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index bfc6c2e..8018f5d 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -160,9 +160,9 @@ void usb_major_cleanup(void)
 int usb_register_dev(struct usb_interface *intf,
 		     struct usb_class_driver *class_driver)
 {
-	int retval = -EINVAL;
+	int retval;
 	int minor_base = class_driver->minor_base;
-	int minor = 0;
+	int minor;
 	char name[20];
 	char *temp;
 
@@ -174,12 +174,17 @@ int usb_register_dev(struct usb_interface *intf,
 	 */
 	minor_base = 0;
 #endif
-	intf->minor = -1;
-
-	dbg ("looking for a minor, starting at %d", minor_base);
 
 	if (class_driver->fops == NULL)
-		goto exit;
+		return -EINVAL;
+	if (intf->minor >= 0)
+		return -EADDRINUSE;
+
+	retval = init_usb_class();
+	if (retval)
+		return retval;
+
+	dev_dbg(&intf->dev, "looking for a minor, starting at %d", minor_base);
 
 	down_write(&minor_rwsem);
 	for (minor = minor_base; minor < MAX_USB_MINORS; ++minor) {
@@ -187,20 +192,12 @@ int usb_register_dev(struct usb_interface *intf,
 			continue;
 
 		usb_minors[minor] = class_driver->fops;
-
-		retval = 0;
+		intf->minor = minor;
 		break;
 	}
 	up_write(&minor_rwsem);
-
-	if (retval)
-		goto exit;
-
-	retval = init_usb_class();
-	if (retval)
-		goto exit;
-
-	intf->minor = minor;
+	if (intf->minor < 0)
+		return -EXFULL;
 
 	/* create a usb class device for this usb interface */
 	snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
@@ -214,11 +211,11 @@ int usb_register_dev(struct usb_interface *intf,
 				      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
-		usb_minors[intf->minor] = NULL;
+		usb_minors[minor] = NULL;
+		intf->minor = -1;
 		up_write(&minor_rwsem);
 		retval = PTR_ERR(intf->usb_dev);
 	}
-exit:
 	return retval;
 }
 EXPORT_SYMBOL_GPL(usb_register_dev);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 9cc0aba..c33d098 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -677,6 +677,8 @@ static void hub_init_func3(struct work_struct *ws);
 static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 {
 	struct usb_device *hdev = hub->hdev;
+	struct usb_hcd *hcd;
+	int ret;
 	int port1;
 	int status;
 	bool need_debounce_delay = false;
@@ -715,6 +717,25 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			usb_autopm_get_interface_no_resume(
 					to_usb_interface(hub->intfdev));
 			return;		/* Continues at init2: below */
+		} else if (type == HUB_RESET_RESUME) {
+			/* The internal host controller state for the hub device
+			 * may be gone after a host power loss on system resume.
+			 * Update the device's info so the HW knows it's a hub.
+			 */
+			hcd = bus_to_hcd(hdev->bus);
+			if (hcd->driver->update_hub_device) {
+				ret = hcd->driver->update_hub_device(hcd, hdev,
+						&hub->tt, GFP_NOIO);
+				if (ret < 0) {
+					dev_err(hub->intfdev, "Host not "
+							"accepting hub info "
+							"update.\n");
+					dev_err(hub->intfdev, "LS/FS devices "
+							"and hubs may not work "
+							"under this hub\n.");
+				}
+			}
+			hub_power_on(hub, true);
 		} else {
 			hub_power_on(hub, true);
 		}
@@ -2734,6 +2755,11 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 		udev->ttport = hdev->ttport;
 	} else if (udev->speed != USB_SPEED_HIGH
 			&& hdev->speed == USB_SPEED_HIGH) {
+		if (!hub->tt.hub) {
+			dev_err(&udev->dev, "parent hub has no TT\n");
+			retval = -EINVAL;
+			goto fail;
+		}
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}
@@ -2872,13 +2898,16 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	else
 		i = udev->descriptor.bMaxPacketSize0;
 	if (le16_to_cpu(udev->ep0.desc.wMaxPacketSize) != i) {
-		if (udev->speed != USB_SPEED_FULL ||
+		if (udev->speed == USB_SPEED_LOW ||
 				!(i == 8 || i == 16 || i == 32 || i == 64)) {
-			dev_err(&udev->dev, "ep0 maxpacket = %d\n", i);
+			dev_err(&udev->dev, "Invalid ep0 maxpacket: %d\n", i);
 			retval = -EMSGSIZE;
 			goto fail;
 		}
-		dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);
+		if (udev->speed == USB_SPEED_FULL)
+			dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);
+		else
+			dev_warn(&udev->dev, "Using ep0 maxpacket: %d\n", i);
 		udev->ep0.desc.wMaxPacketSize = cpu_to_le16(i);
 		usb_ep0_reinit(udev);
 	}
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 1a48aac..9821c5f 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1180,13 +1180,6 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
 	int i;
 
-	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
-		skip_ep0 ? "non-ep0" : "all");
-	for (i = skip_ep0; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
-
 	/* getting rid of interfaces will disconnect
 	 * any drivers bound to them (a key side effect)
 	 */
@@ -1216,6 +1209,13 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
 		if (dev->state == USB_STATE_CONFIGURED)
 			usb_set_device_state(dev, USB_STATE_ADDRESS);
 	}
+
+	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
+		skip_ep0 ? "non-ep0" : "all");
+	for (i = skip_ep0; i < 16; ++i) {
+		usb_disable_endpoint(dev, i, true);
+		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
+	}
 }
 
 /**
@@ -1842,6 +1842,7 @@ free_interfaces:
 		intf->dev.groups = usb_interface_groups;
 		intf->dev.dma_mask = dev->dev.dma_mask;
 		INIT_WORK(&intf->reset_ws, __usb_queue_reset_device);
+		intf->minor = -1;
 		device_initialize(&intf->dev);
 		mark_quiesced(intf);
 		dev_set_name(&intf->dev, "%d-%s:%d.%d",
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index a61f160..55d3eb1 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -45,6 +45,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Samsung Android phone modem - ID conflict with SPH-I500 */
+	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
@@ -65,6 +69,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Keytouch QWERTY Panel keyboard */
+	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 4e970cf..23d4ce3 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2013,6 +2013,9 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 			} else {
 				disable_irq(gpio_to_irq(udc->vbus_pin));
 			}
+		} else {
+			/* gpio_request fail so use -EINVAL for gpio_is_valid */
+			ubc->vbus_pin = -EINVAL;
 		}
 	}
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 2d867fd..8966d5d 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -130,31 +130,31 @@ static struct printer_dev usb_printer_gadget;
  * parameters are in UTF-8 (superset of ASCII's 7 bit characters).
  */
 
-static ushort __initdata idVendor;
+static ushort idVendor;
 module_param(idVendor, ushort, S_IRUGO);
 MODULE_PARM_DESC(idVendor, "USB Vendor ID");
 
-static ushort __initdata idProduct;
+static ushort idProduct;
 module_param(idProduct, ushort, S_IRUGO);
 MODULE_PARM_DESC(idProduct, "USB Product ID");
 
-static ushort __initdata bcdDevice;
+static ushort bcdDevice;
 module_param(bcdDevice, ushort, S_IRUGO);
 MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");
 
-static char *__initdata iManufacturer;
+static char *iManufacturer;
 module_param(iManufacturer, charp, S_IRUGO);
 MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");
 
-static char *__initdata iProduct;
+static char *iProduct;
 module_param(iProduct, charp, S_IRUGO);
 MODULE_PARM_DESC(iProduct, "USB Product string");
 
-static char *__initdata iSerialNum;
+static char *iSerialNum;
 module_param(iSerialNum, charp, S_IRUGO);
 MODULE_PARM_DESC(iSerialNum, "1");
 
-static char *__initdata iPNPstring;
+static char *iPNPstring;
 module_param(iPNPstring, charp, S_IRUGO);
 MODULE_PARM_DESC(iPNPstring, "MFG:linux;MDL:g_printer;CLS:PRINTER;SN:1;");
 
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index efa0372..6396cba 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -537,6 +537,8 @@ static int ehci_init(struct usb_hcd *hcd)
 	ehci->iaa_watchdog.function = ehci_iaa_watchdog;
 	ehci->iaa_watchdog.data = (unsigned long) ehci;
 
+	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+
 	/*
 	 * hw default: 1K periodic list heads, one per frame.
 	 * periodic_size can shrink by USBCMD update if hcc_params allows.
@@ -544,11 +546,20 @@ static int ehci_init(struct usb_hcd *hcd)
 	ehci->periodic_size = DEFAULT_I_TDPS;
 	INIT_LIST_HEAD(&ehci->cached_itd_list);
 	INIT_LIST_HEAD(&ehci->cached_sitd_list);
+
+	if (HCC_PGM_FRAMELISTLEN(hcc_params)) {
+		/* periodic schedule size can be smaller than default */
+		switch (EHCI_TUNE_FLS) {
+		case 0: ehci->periodic_size = 1024; break;
+		case 1: ehci->periodic_size = 512; break;
+		case 2: ehci->periodic_size = 256; break;
+		default:	BUG();
+		}
+	}
 	if ((retval = ehci_mem_init(ehci, GFP_KERNEL)) < 0)
 		return retval;
 
 	/* controllers may cache some of the periodic schedule ... */
-	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 	if (HCC_ISOC_CACHE(hcc_params))		// full frame cache
 		ehci->i_thresh = 2 + 8;
 	else					// N microframes cached
@@ -597,12 +608,6 @@ static int ehci_init(struct usb_hcd *hcd)
 		/* periodic schedule size can be smaller than default */
 		temp &= ~(3 << 2);
 		temp |= (EHCI_TUNE_FLS << 2);
-		switch (EHCI_TUNE_FLS) {
-		case 0: ehci->periodic_size = 1024; break;
-		case 1: ehci->periodic_size = 512; break;
-		case 2: ehci->periodic_size = 256; break;
-		default:	BUG();
-		}
 	}
 	ehci->command = temp;
 
@@ -1010,10 +1015,11 @@ rescan:
 				tmp && tmp != qh;
 				tmp = tmp->qh_next.qh)
 			continue;
-		/* periodic qh self-unlinks on empty */
-		if (!tmp)
-			goto nogood;
-		unlink_async (ehci, qh);
+		/* periodic qh self-unlinks on empty, and a COMPLETING qh
+		 * may already be unlinked.
+		 */
+		if (tmp)
+			unlink_async(ehci, qh);
 		/* FALL THROUGH */
 	case QH_STATE_UNLINK:		/* wait for hw to finish? */
 	case QH_STATE_UNLINK_WAIT:
@@ -1030,7 +1036,6 @@ idle_timeout:
 		}
 		/* else FALL THROUGH */
 	default:
-nogood:
 		/* caller was supposed to have unlinked any requests;
 		 * that's not our job.  just leak this memory.
 		 */
diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 27b8f7c..11e857a 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -31,6 +31,7 @@ struct isp1760_hcd {
 	struct inter_packet_info atl_ints[32];
 	struct inter_packet_info int_ints[32];
 	struct memory_chunk memory_pool[BLOCKS];
+	u32 atl_queued;
 
 	/* periodic schedule support */
 #define	DEFAULT_I_TDPS		1024
@@ -849,6 +850,11 @@ static void enqueue_an_ATL_packet(struct usb_hcd *hcd, struct isp1760_qh *qh,
 	skip_map &= ~queue_entry;
 	isp1760_writel(skip_map, hcd->regs + HC_ATL_PTD_SKIPMAP_REG);
 
+	priv->atl_queued++;
+	if (priv->atl_queued == 2)
+		isp1760_writel(INTERRUPT_ENABLE_SOT_MASK,
+				hcd->regs + HC_INTERRUPT_ENABLE);
+
 	buffstatus = isp1760_readl(hcd->regs + HC_BUFFER_STATUS_REG);
 	buffstatus |= ATL_BUFFER;
 	isp1760_writel(buffstatus, hcd->regs + HC_BUFFER_STATUS_REG);
@@ -982,6 +988,7 @@ static void do_atl_int(struct usb_hcd *usb_hcd)
 		u32 dw3;
 
 		status = 0;
+		priv->atl_queued--;
 
 		queue_entry = __ffs(done_map);
 		done_map &= ~(1 << queue_entry);
@@ -1044,11 +1051,6 @@ static void do_atl_int(struct usb_hcd *usb_hcd)
 			 * device is not able to send data fast enough.
 			 * This happens mostly on slower hardware.
 			 */
-			printk(KERN_NOTICE "Reloading ptd %p/%p... qh %p read: "
-					"%d of %zu done: %08x cur: %08x\n", qtd,
-					urb, qh, PTD_XFERRED_LENGTH(dw3),
-					qtd->length, done_map,
-					(1 << queue_entry));
 
 			/* RL counter = ERR counter */
 			dw3 &= ~(0xf << 19);
@@ -1076,6 +1078,11 @@ static void do_atl_int(struct usb_hcd *usb_hcd)
 			priv_write_copy(priv, (u32 *)&ptd, usb_hcd->regs +
 					atl_regs, sizeof(ptd));
 
+			priv->atl_queued++;
+			if (priv->atl_queued == 2)
+				isp1760_writel(INTERRUPT_ENABLE_SOT_MASK,
+				    usb_hcd->regs + HC_INTERRUPT_ENABLE);
+
 			buffstatus = isp1760_readl(usb_hcd->regs +
 					HC_BUFFER_STATUS_REG);
 			buffstatus |= ATL_BUFFER;
@@ -1181,6 +1188,9 @@ static void do_atl_int(struct usb_hcd *usb_hcd)
 		skip_map = isp1760_readl(usb_hcd->regs +
 				HC_ATL_PTD_SKIPMAP_REG);
 	}
+	if (priv->atl_queued <= 1)
+		isp1760_writel(INTERRUPT_ENABLE_MASK,
+				usb_hcd->regs + HC_INTERRUPT_ENABLE);
 }
 
 static void do_intl_int(struct usb_hcd *usb_hcd)
@@ -1760,7 +1770,7 @@ static irqreturn_t isp1760_irq(struct usb_hcd *usb_hcd)
 		goto leave;
 
 	isp1760_writel(imask, usb_hcd->regs + HC_INTERRUPT_REG);
-	if (imask & HC_ATL_INT)
+	if (imask & (HC_ATL_INT | HC_SOT_INT))
 		do_atl_int(usb_hcd);
 
 	if (imask & HC_INTL_INT)
diff --git a/drivers/usb/host/isp1760-hcd.h b/drivers/usb/host/isp1760-hcd.h
index 6931ef5..612bce5 100644
--- a/drivers/usb/host/isp1760-hcd.h
+++ b/drivers/usb/host/isp1760-hcd.h
@@ -69,6 +69,7 @@ void deinit_kmem_cache(void);
 
 #define HC_INTERRUPT_ENABLE	0x314
 #define INTERRUPT_ENABLE_MASK	(HC_INTL_INT | HC_ATL_INT | HC_EOT_INT)
+#define INTERRUPT_ENABLE_SOT_MASK	(HC_INTL_INT | HC_SOT_INT | HC_EOT_INT)
 
 #define HC_ISO_INT		(1 << 9)
 #define HC_ATL_INT		(1 << 8)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2b26b5e..3534591 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -391,8 +391,11 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	state->new_deq_seg = find_trb_seg(cur_td->start_seg,
 			dev->eps[ep_index].stopped_trb,
 			&state->new_cycle_state);
-	if (!state->new_deq_seg)
-		BUG();
+	if (!state->new_deq_seg) {
+		WARN_ON(1);
+		return;
+	}
+
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg(xhci, "Finding endpoint context\n");
 	ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
@@ -403,8 +406,10 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
 			state->new_deq_ptr,
 			&state->new_cycle_state);
-	if (!state->new_deq_seg)
-		BUG();
+	if (!state->new_deq_seg) {
+		WARN_ON(1);
+		return;
+	}
 
 	trb = &state->new_deq_ptr->generic;
 	if ((trb->field[3] & TRB_TYPE_BITMASK) == TRB_TYPE(TRB_LINK) &&
@@ -412,6 +417,20 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 		state->new_cycle_state = ~(state->new_cycle_state) & 0x1;
 	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
 
+	/*
+	 * If there is only one segment in a ring, find_trb_seg()'s while loop
+	 * will not run, and it will return before it has a chance to see if it
+	 * needs to toggle the cycle bit.  It can't tell if the stalled transfer
+	 * ended just before the link TRB on a one-segment ring, or if the TD
+	 * wrapped around the top of the ring, because it doesn't have the TD in
+	 * question.  Look for the one-segment case where stalled TRB's address
+	 * is greater than the new dequeue pointer address.
+	 */
+	if (ep_ring->first_seg == ep_ring->first_seg->next &&
+			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
+		state->new_cycle_state ^= 0x1;
+	xhci_dbg(xhci, "Cycle state = 0x%x\n", state->new_cycle_state);
+
 	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
 			state->new_deq_seg);
@@ -1685,12 +1704,13 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
-			(sg_dma_address(sg) & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
+		running_total &= TRB_MAX_BUFF_SIZE - 1;
 		if (running_total != 0)
 			num_trbs++;
 
 		/* How many more 64KB chunks to transfer, how many more TRBs? */
-		while (running_total < sg_dma_len(sg)) {
+		while (running_total < sg_dma_len(sg) && running_total < temp) {
 			num_trbs++;
 			running_total += TRB_MAX_BUFF_SIZE;
 		}
@@ -1715,11 +1735,11 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 static void check_trb_math(struct urb *urb, int num_trbs, int running_total)
 {
 	if (num_trbs != 0)
-		dev_dbg(&urb->dev->dev, "%s - ep %#x - Miscalculated number of "
+		dev_err(&urb->dev->dev, "%s - ep %#x - Miscalculated number of "
 				"TRBs, %d left\n", __func__,
 				urb->ep->desc.bEndpointAddress, num_trbs);
 	if (running_total != urb->transfer_buffer_length)
-		dev_dbg(&urb->dev->dev, "%s - ep %#x - Miscalculated tx length, "
+		dev_err(&urb->dev->dev, "%s - ep %#x - Miscalculated tx length, "
 				"queued %#x (%d), asked for %#x (%d)\n",
 				__func__,
 				urb->ep->desc.bEndpointAddress,
@@ -1841,8 +1861,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	sg = urb->sg->sg;
 	addr = (u64) sg_dma_address(sg);
 	this_sg_len = sg_dma_len(sg);
-	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+	trb_buff_len = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
 	trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
@@ -1878,7 +1897,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 				(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
 				(unsigned int) addr + trb_buff_len);
 		if (TRB_MAX_BUFF_SIZE -
-				(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1)) < trb_buff_len) {
+				(addr & (TRB_MAX_BUFF_SIZE - 1)) < trb_buff_len) {
 			xhci_warn(xhci, "WARN: sg dma xfer crosses 64KB boundaries!\n");
 			xhci_dbg(xhci, "Next boundary at %#x, end dma = %#x\n",
 					(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
@@ -1918,7 +1937,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		}
 
 		trb_buff_len = TRB_MAX_BUFF_SIZE -
-			(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(addr & (TRB_MAX_BUFF_SIZE - 1));
 		trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 		if (running_total + trb_buff_len > urb->transfer_buffer_length)
 			trb_buff_len =
@@ -1953,7 +1972,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	num_trbs = 0;
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	running_total &= TRB_MAX_BUFF_SIZE - 1;
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
@@ -1992,8 +2012,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	/* How much data is in the first TRB? */
 	addr = (u64) urb->transfer_dma;
 	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
-	if (urb->transfer_buffer_length < trb_buff_len)
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
 
 	first_trb = true;
diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 5720bfe..49deeb6 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -195,11 +195,9 @@ static ssize_t get_port1_handler(struct device *dev,
 	return read_port(dev, attr, buf, 1, CYPRESS_READ_PORT_ID1);
 }
 
-static DEVICE_ATTR(port0, S_IWUGO | S_IRUGO,
-		   get_port0_handler, set_port0_handler);
+static DEVICE_ATTR(port0, S_IRUGO | S_IWUSR, get_port0_handler, set_port0_handler);
 
-static DEVICE_ATTR(port1, S_IWUGO | S_IRUGO,
-		   get_port1_handler, set_port1_handler);
+static DEVICE_ATTR(port1, S_IRUGO | S_IWUSR, get_port1_handler, set_port1_handler);
 
 
 static int cypress_probe(struct usb_interface *interface,
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index e75bb87..cfdcbb8 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -373,7 +373,7 @@ static ssize_t iowarrior_write(struct file *file,
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
 		/* IOW24 and IOW40 use a synchronous call */
-		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
+		buf = kmalloc(count, GFP_KERNEL);
 		if (!buf) {
 			retval = -ENOMEM;
 			goto exit;
@@ -552,6 +552,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index be41ec3..cafbd15 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3008,6 +3008,7 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #else
 			x.sisusb_conactive  = 0;
 #endif
+			memset(x.sisusb_reserved, 0, sizeof(x.sisusb_reserved));
 
 			if (copy_to_user((void __user *)arg, &x, sizeof(x)))
 				retval = -EFAULT;
diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
index 2e14102..d509dcb 100644
--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -85,7 +85,7 @@ static ssize_t set_speed(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(speed, S_IWUGO | S_IRUGO, show_speed, set_speed);
+static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR, show_speed, set_speed);
 
 static int tv_probe(struct usb_interface *interface,
 		    const struct usb_device_id *id)
diff --git a/drivers/usb/misc/usbled.c b/drivers/usb/misc/usbled.c
index 06cb719..9650de9 100644
--- a/drivers/usb/misc/usbled.c
+++ b/drivers/usb/misc/usbled.c
@@ -94,7 +94,7 @@ static ssize_t set_##value(struct device *dev, struct device_attribute *attr, co
 	change_color(led);						\
 	return count;							\
 }									\
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO, show_##value, set_##value);
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, show_##value, set_##value);
 show_set(blue);
 show_set(red);
 show_set(green);
diff --git a/drivers/usb/misc/usbsevseg.c b/drivers/usb/misc/usbsevseg.c
index 3db2555..cd8726c 100644
--- a/drivers/usb/misc/usbsevseg.c
+++ b/drivers/usb/misc/usbsevseg.c
@@ -185,7 +185,7 @@ static ssize_t set_attr_##name(struct device *dev, 		\
 								\
 	return count;						\
 }								\
-static DEVICE_ATTR(name, S_IWUGO | S_IRUGO, show_attr_##name, set_attr_##name);
+static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_attr_##name, set_attr_##name);
 
 static ssize_t show_attr_text(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -216,7 +216,7 @@ static ssize_t set_attr_text(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(text, S_IWUGO | S_IRUGO, show_attr_text, set_attr_text);
+static DEVICE_ATTR(text, S_IRUGO | S_IWUSR, show_attr_text, set_attr_text);
 
 static ssize_t show_attr_decimals(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -265,8 +265,7 @@ static ssize_t set_attr_decimals(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(decimals, S_IWUGO | S_IRUGO,
-	show_attr_decimals, set_attr_decimals);
+static DEVICE_ATTR(decimals, S_IRUGO | S_IWUSR, show_attr_decimals, set_attr_decimals);
 
 static ssize_t show_attr_textmode(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -312,8 +311,7 @@ static ssize_t set_attr_textmode(struct device *dev,
 	return -EINVAL;
 }
 
-static DEVICE_ATTR(textmode, S_IWUGO | S_IRUGO,
-	show_attr_textmode, set_attr_textmode);
+static DEVICE_ATTR(textmode, S_IRUGO | S_IWUSR, show_attr_textmode, set_attr_textmode);
 
 
 MYDEV_ATTR_SIMPLE_UNSIGNED(powered, update_display_powered);
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 9a6c27a..5a03b2e 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005
+ *	Copyright (C) 1999, 2005, 2010
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -775,6 +775,8 @@ static struct usb_device_id uss720_table [] = {
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index ad26e65..e278b07 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -298,8 +298,10 @@ int __init musb_platform_init(struct musb *musb)
 
 	usb_nop_xceiv_register();
 	musb->xceiv = otg_get_transceiver();
-	if (!musb->xceiv)
+	if (!musb->xceiv) {
+		gpio_free(musb->config->gpio_vrsel);
 		return -ENODEV;
+	}
 
 	if (ANOMALY_05000346) {
 		bfin_write_USB_APHY_CALIB(ANOMALY_05000346_value);
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 83beeac..dd8d3dc 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -309,6 +309,7 @@ static int musb_platform_resume(struct musb *musb)
 
 int musb_platform_exit(struct musb *musb)
 {
+	del_timer_sync(&musb_idle_timer);
 
 	omap_vbus_power(musb, 0 /*off*/, 1);
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 59eff72..9fab6fe 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -73,6 +73,7 @@ static int debug;
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -479,12 +480,22 @@ static void ch341_read_int_callback(struct urb *urb)
 	if (actual_length >= 4) {
 		struct ch341_private *priv = usb_get_serial_port_data(port);
 		unsigned long flags;
+		u8 prev_line_status = priv->line_status;
 
 		spin_lock_irqsave(&priv->lock, flags);
 		priv->line_status = (~(data[2])) & CH341_BITS_MODEM_STAT;
 		if ((data[1] & CH341_MULT_STAT))
 			priv->multi_status_change = 1;
 		spin_unlock_irqrestore(&priv->lock, flags);
+
+		if ((priv->line_status ^ prev_line_status) & CH341_BIT_DCD) {
+			struct tty_struct *tty = tty_port_tty_get(&port->port);
+			if (tty)
+				usb_serial_handle_dcd_change(port, tty,
+					    priv->line_status & CH341_BIT_DCD);
+			tty_kref_put(tty);
+		}
+
 		wake_up_interruptible(&priv->delta_msr_wait);
 	}
 
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index e3e087e..72c1db5 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -51,11 +51,11 @@ static void cp210x_break_ctl(struct tty_struct *, int);
 static int cp210x_startup(struct usb_serial *);
 static void cp210x_disconnect(struct usb_serial *);
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
-static int cp210x_carrier_raised(struct usb_serial_port *p);
 
 static int debug;
 
 static struct usb_device_id id_table [] = {
+	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
@@ -87,7 +87,6 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x10C4, 0x8115) }, /* Arygon NFC/Mifare Reader */
 	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
-	{ USB_DEVICE(0x10C4, 0x8149) }, /* West Mountain Radio Computerized Battery Analyzer */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
@@ -109,7 +108,9 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x8382) }, /* Cygnal Integrated Products, Inc. */
 	{ USB_DEVICE(0x10C4, 0x83A8) }, /* Amber Wireless AMB2560 */
+	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
@@ -127,6 +128,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };
@@ -157,8 +159,7 @@ static struct usb_serial_driver cp210x_device = {
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_startup,
 	.disconnect		= cp210x_disconnect,
-	.dtr_rts		= cp210x_dtr_rts,
-	.carrier_raised		= cp210x_carrier_raised
+	.dtr_rts		= cp210x_dtr_rts
 };
 
 /* Config request types */
@@ -792,15 +793,6 @@ static int cp210x_tiocmget (struct tty_struct *tty, struct file *file)
 	return result;
 }
 
-static int cp210x_carrier_raised(struct usb_serial_port *p)
-{
-	unsigned int control;
-	cp210x_get_config(p, CP210X_GET_MDMSTS, &control, 1);
-	if (control & CONTROL_DCD)
-		return 1;
-	return 0;
-}
-
 static void cp210x_break_ctl (struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 68e80be..2acfb38 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -455,7 +455,6 @@ static int digi_write_room(struct tty_struct *tty);
 static int digi_chars_in_buffer(struct tty_struct *tty);
 static int digi_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void digi_close(struct usb_serial_port *port);
-static int digi_carrier_raised(struct usb_serial_port *port);
 static void digi_dtr_rts(struct usb_serial_port *port, int on);
 static int digi_startup_device(struct usb_serial *serial);
 static int digi_startup(struct usb_serial *serial);
@@ -511,7 +510,6 @@ static struct usb_serial_driver digi_acceleport_2_device = {
 	.open =				digi_open,
 	.close =			digi_close,
 	.dtr_rts =			digi_dtr_rts,
-	.carrier_raised =		digi_carrier_raised,
 	.write =			digi_write,
 	.write_room =			digi_write_room,
 	.write_bulk_callback = 		digi_write_bulk_callback,
@@ -1338,14 +1336,6 @@ static void digi_dtr_rts(struct usb_serial_port *port, int on)
 	digi_set_modem_signals(port, on * (TIOCM_DTR|TIOCM_RTS), 1);
 }
 
-static int digi_carrier_raised(struct usb_serial_port *port)
-{
-	struct digi_port *priv = usb_get_serial_port_data(port);
-	if (priv->dp_modem_signals & TIOCM_CD)
-		return 1;
-	return 0;
-}
-
 static int digi_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
 	int ret;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bc11d0c..06af705 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -104,6 +104,7 @@ struct ftdi_sio_quirk {
 static int   ftdi_jtag_probe(struct usb_serial *serial);
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
+static int   ftdi_stmclite_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -127,6 +128,10 @@ static struct ftdi_sio_quirk ftdi_HE_TIRA1_quirk = {
 	.port_probe = ftdi_HE_TIRA1_setup,
 };
 
+static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
+	.probe	= ftdi_stmclite_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -179,6 +184,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_SNIFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
@@ -201,6 +207,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_5_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_R2000KU_TRUE_RNG) },
+	{ USB_DEVICE(FTDI_VID, FTDI_VARDAAN_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0100_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0101_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0102_PID) },
@@ -614,6 +621,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OCEANIC_PID) },
 	{ USB_DEVICE(TTI_VID, TTI_QL355P_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
+	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
@@ -675,8 +683,17 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_PCDJ_DAC2_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
-	{ USB_DEVICE(ICOM_ID1_VID, ICOM_ID1_PID) },
-	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_TMU_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_1_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_OPC_U_UC_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C1_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C2_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2D_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2VT_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2VR_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP4KVT_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP4KVR_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2KVT_PID) },
+	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2KVR_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACG_HFDUAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_YEI_SERVOCENTER31_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_THORLABS_PID) },
@@ -698,6 +715,7 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
@@ -717,8 +735,37 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
+
+	/* Papouch devices based on FTDI chip */
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AP485_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB422_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485_2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AP485_2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB422_2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485S_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485C_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_LEC_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB232_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_TMU_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_IRAMP_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_DRAK5_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO8x8_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO2x2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO10x1_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO30x3_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO60x3_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO2x16_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO3x32_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_DRAK6_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_UPSUSB_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_MU_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SIMUKEY_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AD4USB_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_GMUX_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_GMSR_PID) },
+
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },
@@ -752,6 +799,8 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
@@ -1685,6 +1734,25 @@ static int ftdi_jtag_probe(struct usb_serial *serial)
 }
 
 /*
+ * First and second port on STMCLiteadaptors is reserved for JTAG interface
+ * and the forth port for pio
+ */
+static int ftdi_stmclite_probe(struct usb_serial *serial)
+{
+	struct usb_device *udev = serial->dev;
+	struct usb_interface *interface = serial->interface;
+
+	dbg("%s", __func__);
+
+	if (interface == udev->actconfig->interface[2])
+		return 0;
+
+	dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+
+	return -ENODEV;
+}
+
+/*
  * The Matrix Orbital VK204-25-USB has an invalid IN endpoint.
  * We have to correct it if we want to read from it.
  */
@@ -2321,8 +2389,6 @@ static void ftdi_set_termios(struct tty_struct *tty,
 				"urb failed to set to rts/cts flow control\n");
 		}
 
-		/* raise DTR/RTS */
-		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	} else {
 		/*
 		 * Xon/Xoff code
@@ -2370,8 +2436,6 @@ static void ftdi_set_termios(struct tty_struct *tty,
 			}
 		}
 
-		/* lower DTR/RTS */
-		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	}
 	return;
 }
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index ffdcec7..2ed7fcf 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -56,6 +56,7 @@
 #define FTDI_OPENDCC_SNIFFER_PID	0xBFD9
 #define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
+#define FTDI_OPENDCC_GBM_PID	0xBFDC
 
 /*
  * RR-CirKits LocoBuffer USB (http://www.rr-cirkits.com)
@@ -117,6 +118,9 @@
 #define XSENS_CONVERTER_6_PID	0xD38E
 #define XSENS_CONVERTER_7_PID	0xD38F
 
+/* Vardaan Enterprises Serial Interface VEUSB422R3 */
+#define FTDI_VARDAAN_PID	0xF070
+
 /*
  * NDI (www.ndigital.com) product ids
  */
@@ -494,6 +498,12 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Acton Research Corp.
+ */
+#define ACTON_VID		0x0647	/* Vendor ID */
+#define ACTON_SPECTRAPRO_PID	0x0100
+
+/*
  * Contec products (http://www.contec.com)
  * Submitted by Daniel Sangorrin
  */
@@ -552,11 +562,23 @@
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*
- * Icom ID-1 digital transceiver
+ * Definitions for Icom Inc. devices
  */
-
-#define ICOM_ID1_VID            0x0C26
-#define ICOM_ID1_PID            0x0004
+#define ICOM_VID		0x0C26 /* Icom vendor ID */
+/* Note: ID-1 is a communications tranceiver for HAM-radio operators */
+#define ICOM_ID_1_PID		0x0004 /* ID-1 USB to RS-232 */
+/* Note: OPC is an Optional cable to connect an Icom Tranceiver */
+#define ICOM_OPC_U_UC_PID	0x0018 /* OPC-478UC, OPC-1122U cloning cable */
+/* Note: ID-RP* devices are Icom Repeater Devices for HAM-radio */
+#define ICOM_ID_RP2C1_PID	0x0009 /* ID-RP2C Asset 1 to RS-232 */
+#define ICOM_ID_RP2C2_PID	0x000A /* ID-RP2C Asset 2 to RS-232 */
+#define ICOM_ID_RP2D_PID	0x000B /* ID-RP2D configuration port*/
+#define ICOM_ID_RP2VT_PID	0x000C /* ID-RP2V Transmit config port */
+#define ICOM_ID_RP2VR_PID	0x000D /* ID-RP2V Receive config port */
+#define ICOM_ID_RP4KVT_PID	0x0010 /* ID-RP4000V Transmit config port */
+#define ICOM_ID_RP4KVR_PID	0x0011 /* ID-RP4000V Receive config port */
+#define ICOM_ID_RP2KVT_PID	0x0012 /* ID-RP2000V Transmit config port */
+#define ICOM_ID_RP2KVR_PID	0x0013 /* ID-RP2000V Receive config port */
 
 /*
  * GN Otometrics (http://www.otometrics.com)
@@ -707,6 +729,7 @@
  */
 #define RTSYSTEMS_VID			0x2100	/* Vendor ID */
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
+#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
 
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
@@ -998,14 +1021,45 @@
 #define WHT_PID			0x0004 /* Wireless Handheld Terminal */
 
 /*
+ * STMicroelectonics
+ */
+#define ST_VID			0x0483
+#define ST_STMCLT1030_PID	0x3747 /* ST Micro Connect Lite STMCLT1030 */
+
+/*
  * Papouch products (http://www.papouch.com/)
  * Submitted by Folkert van Heusden
  */
 
 #define PAPOUCH_VID			0x5050	/* Vendor ID */
+#define PAPOUCH_SB485_PID		0x0100	/* Papouch SB485 USB-485/422 Converter */
+#define PAPOUCH_AP485_PID		0x0101	/* AP485 USB-RS485 Converter */
+#define PAPOUCH_SB422_PID		0x0102	/* Papouch SB422 USB-RS422 Converter  */
+#define PAPOUCH_SB485_2_PID		0x0103	/* Papouch SB485 USB-485/422 Converter */
+#define PAPOUCH_AP485_2_PID		0x0104	/* AP485 USB-RS485 Converter */
+#define PAPOUCH_SB422_2_PID		0x0105	/* Papouch SB422 USB-RS422 Converter  */
+#define PAPOUCH_SB485S_PID		0x0106	/* Papouch SB485S USB-485/422 Converter */
+#define PAPOUCH_SB485C_PID		0x0107	/* Papouch SB485C USB-485/422 Converter */
+#define PAPOUCH_LEC_PID			0x0300	/* LEC USB Converter */
+#define PAPOUCH_SB232_PID		0x0301	/* Papouch SB232 USB-RS232 Converter */
 #define PAPOUCH_TMU_PID			0x0400	/* TMU USB Thermometer */
-#define PAPOUCH_QUIDO4x4_PID		0x0900	/* Quido 4/4 Module */
+#define PAPOUCH_IRAMP_PID		0x0500	/* Papouch IRAmp Duplex */
+#define PAPOUCH_DRAK5_PID		0x0700	/* Papouch DRAK5 */
+#define PAPOUCH_QUIDO8x8_PID		0x0800	/* Papouch Quido 8/8 Module */
+#define PAPOUCH_QUIDO4x4_PID		0x0900	/* Papouch Quido 4/4 Module */
+#define PAPOUCH_QUIDO2x2_PID		0x0a00	/* Papouch Quido 2/2 Module */
+#define PAPOUCH_QUIDO10x1_PID		0x0b00	/* Papouch Quido 10/1 Module */
+#define PAPOUCH_QUIDO30x3_PID		0x0c00	/* Papouch Quido 30/3 Module */
+#define PAPOUCH_QUIDO60x3_PID		0x0d00	/* Papouch Quido 60(100)/3 Module */
+#define PAPOUCH_QUIDO2x16_PID		0x0e00	/* Papouch Quido 2/16 Module */
+#define PAPOUCH_QUIDO3x32_PID		0x0f00	/* Papouch Quido 3/32 Module */
+#define PAPOUCH_DRAK6_PID		0x1000	/* Papouch DRAK6 */
+#define PAPOUCH_UPSUSB_PID		0x8000	/* Papouch UPS-USB adapter */
+#define PAPOUCH_MU_PID			0x8001	/* MU controller */
+#define PAPOUCH_SIMUKEY_PID		0x8002	/* Papouch SimuKey */
 #define PAPOUCH_AD4USB_PID		0x8003	/* AD4USB Measurement Module */
+#define PAPOUCH_GMUX_PID		0x8004	/* Papouch GOLIATH MUX */
+#define PAPOUCH_GMSR_PID		0x8005	/* Papouch GOLIATH MSR */
 
 /*
  * Marvell SheevaPlug
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 83443d6..94b3c83 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -578,6 +578,26 @@ int usb_serial_handle_break(struct usb_serial_port *port)
 }
 EXPORT_SYMBOL_GPL(usb_serial_handle_break);
 
+/**
+ *	usb_serial_handle_dcd_change - handle a change of carrier detect state
+ *	@port: usb_serial_port structure for the open port
+ *	@tty: tty_struct structure for the port
+ *	@status: new carrier detect status, nonzero if active
+ */
+void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
+				struct tty_struct *tty, unsigned int status)
+{
+	struct tty_port *port = &usb_port->port;
+
+	dbg("%s - port %d, status %d", __func__, usb_port->number, status);
+
+	if (status)
+		wake_up_interruptible(&port->open_wait);
+	else if (tty && !C_CLOCAL(tty))
+		tty_hangup(tty);
+}
+EXPORT_SYMBOL_GPL(usb_serial_handle_dcd_change);
+
 int usb_serial_generic_resume(struct usb_serial *serial)
 {
 	struct usb_serial_port *port;
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index b97960a..72b256c 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2935,8 +2935,8 @@ static void load_application_firmware(struct edgeport_serial *edge_serial)
 
 	dbg("%s %d.%d.%d", fw_info, rec->data[0], rec->data[1], build);
 
-	edge_serial->product_info.FirmwareMajorVersion = fw->data[0];
-	edge_serial->product_info.FirmwareMinorVersion = fw->data[1];
+	edge_serial->product_info.FirmwareMajorVersion = rec->data[0];
+	edge_serial->product_info.FirmwareMinorVersion = rec->data[1];
 	edge_serial->product_info.FirmwareBuildNumber = cpu_to_le16(build);
 
 	for (rec = ihex_next_binrec(rec); rec;
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 1296a09..0761b5a 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -663,22 +663,6 @@ static void keyspan_pda_dtr_rts(struct usb_serial_port *port, int on)
 	}
 }
 
-static int keyspan_pda_carrier_raised(struct usb_serial_port *port)
-{
-	struct usb_serial *serial = port->serial;
-	unsigned char modembits;
-
-	/* If we can read the modem status and the DCD is low then
-	   carrier is not raised yet */
-	if (keyspan_pda_get_modem_info(serial, &modembits) >= 0) {
-		if (!(modembits & (1>>6)))
-			return 0;
-	}
-	/* Carrier raised, or we failed (eg disconnected) so
-	   progress accordingly */
-	return 1;
-}
-
 
 static int keyspan_pda_open(struct tty_struct *tty,
 					struct usb_serial_port *port)
@@ -854,7 +838,6 @@ static struct usb_serial_driver keyspan_pda_device = {
 	.id_table =		id_table_std,
 	.num_ports =		1,
 	.dtr_rts =		keyspan_pda_dtr_rts,
-	.carrier_raised	=	keyspan_pda_carrier_raised,
 	.open =			keyspan_pda_open,
 	.close =		keyspan_pda_close,
 	.write =		keyspan_pda_write,
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 9d99e68..929ceb1 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -372,7 +372,7 @@ static void kobil_read_int_callback(struct urb *urb)
 	}
 
 	tty = tty_port_tty_get(&port->port);
-	if (urb->actual_length) {
+	if (tty && urb->actual_length) {
 
 		/* BEGIN DEBUG */
 		/*
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 4cdb975..656352a 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -99,8 +99,8 @@ static void opticon_bulk_callback(struct urb *urb)
 				available_room = tty_buffer_request_room(tty,
 								data_length);
 				if (available_room) {
-					tty_insert_flip_string(tty, data,
-							       available_room);
+					tty_insert_flip_string(tty, data + 2,
+							       data_length);
 					tty_flip_buffer_push(tty);
 				}
 				tty_kref_put(tty);
@@ -134,7 +134,7 @@ exit:
 						  priv->bulk_address),
 				  priv->bulk_in_buffer, priv->buffer_size,
 				  opticon_bulk_callback, priv);
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
 		if (result)
 			dev_err(&port->dev,
 			    "%s - failed resubmitting read urb, error %d\n",
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index c5def6d..b3e53ff 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -469,7 +469,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */
@@ -572,6 +572,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0011, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0012, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0013, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0014, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0016, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0017, 0xff, 0xff, 0xff) },
@@ -583,38 +584,52 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0023, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0024, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0025, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0026, 0xff, 0xff, 0xff) },
+	/* { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0026, 0xff, 0xff, 0xff) }, */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0028, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0029, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0030, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0032, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0033, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0034, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0037, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0038, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0039, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0040, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0042, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0043, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0044, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0048, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0049, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0050, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0051, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0052, 0xff, 0xff, 0xff) },
+	/* { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0053, 0xff, 0xff, 0xff) }, */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0054, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0055, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0056, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0057, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0058, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0059, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0061, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0062, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0063, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0064, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0065, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0066, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0067, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0069, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0070, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0076, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0077, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0078, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0079, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0082, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0083, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0086, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2003, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0087, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0104, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0105, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0106, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0108, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0113, 0xff, 0xff, 0xff) },
@@ -830,6 +845,8 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0141, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2003, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 9ec1a49..3ebbddd 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -59,6 +59,8 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_ALDIGA) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MMX) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
@@ -954,9 +956,11 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 {
 
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
+	struct tty_struct *tty;
 	unsigned long flags;
 	u8 status_idx = UART_STATE;
 	u8 length = UART_STATE + 1;
+	u8 prev_line_status;
 	u16 idv, idp;
 
 	idv = le16_to_cpu(port->serial->dev->descriptor.idVendor);
@@ -978,11 +982,20 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 
 	/* Save off the uart status for others to look at */
 	spin_lock_irqsave(&priv->lock, flags);
+	prev_line_status = priv->line_status;
 	priv->line_status = data[status_idx];
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
 	wake_up_interruptible(&priv->delta_msr_wait);
+
+	tty = tty_port_tty_get(&port->port);
+	if (!tty)
+		return;
+	if ((priv->line_status ^ prev_line_status) & UART_DCD)
+		usb_serial_handle_dcd_change(port, tty,
+				priv->line_status & UART_DCD);
+	tty_kref_put(tty);
 }
 
 static void pl2303_read_int_callback(struct urb *urb)
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index d640dc9..a5c94a4 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -20,6 +20,8 @@
 #define PL2303_PRODUCT_ID_ALDIGA	0x0611
 #define PL2303_PRODUCT_ID_MMX		0x0612
 #define PL2303_PRODUCT_ID_GPRS		0x0609
+#define PL2303_PRODUCT_ID_HCR331	0x331a
+#define PL2303_PRODUCT_ID_MOTOROLA	0x0307
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 6435b26..4e28b85 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -300,6 +300,9 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
        { USB_DEVICE(0x413C, 0x08133) }, /* Dell Computer Corp. Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
 
 	{ }
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 1e58220..f863d2d 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -137,7 +137,7 @@ struct spcp8x5_usb_ctrl_arg {
 
 /* how come ??? */
 #define UART_STATE			0x08
-#define UART_STATE_TRANSIENT_MASK	0x74
+#define UART_STATE_TRANSIENT_MASK	0x75
 #define UART_DCD			0x01
 #define UART_DSR			0x02
 #define UART_BREAK_ERROR		0x04
@@ -734,6 +734,10 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 			tty_insert_flip_char(tty, data[i], tty_flag);
 		tty_flip_buffer_push(tty);
 	}
+
+	if (status & UART_DCD)
+		usb_serial_handle_dcd_change(port, tty,
+			   priv->line_status & MSR_STATUS_LINE_DCD);
 	tty_kref_put(tty);
 
 	/* Schedule the next read _if_ we are still open */
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 1e9dc88..18de038 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -366,9 +366,9 @@ failed_1port:
 
 static void __exit ti_exit(void)
 {
+	usb_deregister(&ti_usb_driver);
 	usb_serial_deregister(&ti_1port_device);
 	usb_serial_deregister(&ti_2port_device);
-	usb_deregister(&ti_usb_driver);
 }
 
 
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index c140870..9af8c2f 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/cdc.h>
 #include "visor.h"
 
 /*
@@ -758,6 +759,17 @@ static int visor_probe(struct usb_serial *serial,
 
 	dbg("%s", __func__);
 
+	/*
+	 * some Samsung Android phones in modem mode have the same ID
+	 * as SPH-I500, but they are ACM devices, so dont bind to them
+	 */
+	if (id->idVendor == SAMSUNG_VENDOR_ID &&
+		id->idProduct == SAMSUNG_SPH_I500_ID &&
+		serial->dev->descriptor.bDeviceClass == USB_CLASS_COMM &&
+		serial->dev->descriptor.bDeviceSubClass ==
+			USB_CDC_SUBCLASS_ACM)
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		dev_err(&serial->dev->dev, "active config #%d != 1 ??\n",
 			serial->dev->actconfig->desc.bConfigurationValue);
diff --git a/drivers/usb/storage/sierra_ms.c b/drivers/usb/storage/sierra_ms.c
index 4395c41..38e3c3a 100644
--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -120,7 +120,7 @@ static ssize_t show_truinst(struct device *dev, struct device_attribute *attr,
 	}
 	return result;
 }
-static DEVICE_ATTR(truinst, S_IWUGO | S_IRUGO, show_truinst, NULL);
+static DEVICE_ATTR(truinst, S_IRUGO, show_truinst, NULL);
 
 int sierra_ms_init(struct us_data *us)
 {
diff --git a/drivers/usb/storage/unusual_cypress.h b/drivers/usb/storage/unusual_cypress.h
index 44be6d7..fba2824 100644
--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,4 +31,9 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x9999,
 		"Cypress ISD-300LP",
 		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
 
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+		"Super Top",
+		"USB 2.0  SATA BRIDGE",
+		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
+
 #endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index b6e0e0e..e6612dd 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -481,6 +481,13 @@ UNUSUAL_DEV(  0x04e8, 0x507c, 0x0220, 0x0220,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64),
 
+/* Reported by Vitaly Kuznetsov <vitty@altlinux.ru> */
+UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x9999,
+		"Samsung",
+		"YP-CP3",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 | US_FL_BULK_IGNORE_TAG),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Device uses standards-violating 32-byte Bulk Command Block Wrappers and
  * reports itself as "Proprietary SCSI Bulk." Cf. device entry 0x084d:0x0011.
@@ -1036,6 +1043,15 @@ UNUSUAL_DEV(  0x084d, 0x0011, 0x0110, 0x0110,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BULK32),
 
+/* Reported by <ttkspam@free.fr>
+ * The device reports a vendor-specific device class, requiring an
+ * explicit vendor/product match.
+ */
+UNUSUAL_DEV(  0x0851, 0x1542, 0x0002, 0x0002,
+		"MagicPixel",
+		"FW_Omega2",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, 0),
+
 /* Andrew Lunn <andrew@lunn.ch>
  * PanDigital Digital Picture Frame. Does not like ALLOW_MEDIUM_REMOVAL
  * on LUN 4.
@@ -1394,6 +1410,13 @@ UNUSUAL_DEV(  0x0fca, 0x0006, 0x0001, 0x0001,
 		US_FL_IGNORE_DEVICE ),
 #endif
 
+/* Submitted by Nick Holloway */
+UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0100,
+		"VTech",
+		"Kidizoom",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* Reported by Michael Stattmann <michael@stattmann.com> */
 UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x0000,
 		"Sony Ericsson",
@@ -1873,6 +1896,22 @@ UNUSUAL_DEV( 0x1908, 0x1320, 0x0000, 0x0000,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BAD_SENSE ),
 
+/* Patch by Richard Schütz <r.schtz@t-online.de>
+ * This external hard drive enclosure uses a JMicron chip which
+ * needs the US_FL_IGNORE_RESIDUE flag to work properly. */
+UNUSUAL_DEV(  0x1e68, 0x001b, 0x0000, 0x0000,
+		"TrekStor GmbH & Co. KG",
+		"DataStation maxi g.u",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
+
+/* Reported by Jasper Mackenzie <scarletpimpernal@hotmail.com> */
+UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0000,
+		"Coby Electronics",
+		"MP3 Player",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 18829cf..89025e6 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -196,12 +196,12 @@ static int backlight_suspend(struct device *dev, pm_message_t state)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state |= BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
 
 	return 0;
 }
@@ -210,12 +210,12 @@ static int backlight_resume(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state &= ~BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
 
 	return 0;
 }
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index d25df51..4e1c9ef 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 #include <linux/dmi.h>
-
+#include <linux/pci.h>
 #include <video/vga.h>
 
 static struct fb_var_screeninfo efifb_defined __initdata = {
@@ -113,7 +113,7 @@ static int set_system(const struct dmi_system_id *id)
 {
 	struct efifb_dmi_info *info = id->driver_data;
 	if (info->base == 0)
-		return -ENODEV;
+		return 0;
 
 	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at %p "
 			 "(%dx%d, stride %d)\n", id->ident,
@@ -121,18 +121,55 @@ static int set_system(const struct dmi_system_id *id)
 			 info->stride);
 
 	/* Trust the bootloader over the DMI tables */
-	if (screen_info.lfb_base == 0)
+	if (screen_info.lfb_base == 0) {
+#if defined(CONFIG_PCI)
+		struct pci_dev *dev = NULL;
+		int found_bar = 0;
+#endif
 		screen_info.lfb_base = info->base;
-	if (screen_info.lfb_linelength == 0)
-		screen_info.lfb_linelength = info->stride;
-	if (screen_info.lfb_width == 0)
-		screen_info.lfb_width = info->width;
-	if (screen_info.lfb_height == 0)
-		screen_info.lfb_height = info->height;
-	if (screen_info.orig_video_isVGA == 0)
-		screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
 
-	return 0;
+#if defined(CONFIG_PCI)
+		/* make sure that the address in the table is actually on a
+		 * VGA device's PCI BAR */
+
+		for_each_pci_dev(dev) {
+			int i;
+			if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+				continue;
+			for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+				resource_size_t start, end;
+
+				start = pci_resource_start(dev, i);
+				if (start == 0)
+					break;
+				end = pci_resource_end(dev, i);
+				if (screen_info.lfb_base >= start &&
+						screen_info.lfb_base < end) {
+					found_bar = 1;
+				}
+			}
+		}
+		if (!found_bar)
+			screen_info.lfb_base = 0;
+#endif
+	}
+	if (screen_info.lfb_base) {
+		if (screen_info.lfb_linelength == 0)
+			screen_info.lfb_linelength = info->stride;
+		if (screen_info.lfb_width == 0)
+			screen_info.lfb_width = info->width;
+		if (screen_info.lfb_height == 0)
+			screen_info.lfb_height = info->height;
+		if (screen_info.orig_video_isVGA == 0)
+			screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
+	} else {
+		screen_info.lfb_linelength = 0;
+		screen_info.lfb_width = 0;
+		screen_info.lfb_height = 0;
+		screen_info.orig_video_isVGA = 0;
+		return 0;
+	}
+	return 1;
 }
 
 static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 9d2b6bc..67ef72e 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1701,6 +1701,9 @@ static int	sisfb_ioctl(struct fb_info *info, unsigned int cmd,
 		break;
 
 	   case FBIOGET_VBLANK:
+
+		memset(&sisvbblank, 0, sizeof(struct fb_vblank));
+
 		sisvbblank.count = 0;
 		sisvbblank.flags = sisfb_setupvbblankflags(ivideo, &sisvbblank.vcount, &sisvbblank.hcount);
 
diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index d5077df..4400f91 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -277,11 +277,12 @@ static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
 		writel(tmp, engine + 0x1C);
 	}
 
-	if (op != VIA_BITBLT_COLOR)
+	if (op == VIA_BITBLT_FILL) {
+		writel(fg_color, engine + 0x58);
+	} else if (op == VIA_BITBLT_MONO) {
 		writel(fg_color, engine + 0x4C);
-
-	if (op == VIA_BITBLT_MONO)
 		writel(bg_color, engine + 0x50);
+	}
 
 	if (op == VIA_BITBLT_FILL)
 		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
diff --git a/drivers/video/via/ioctl.c b/drivers/video/via/ioctl.c
index da03c07..4d553d0 100644
--- a/drivers/video/via/ioctl.c
+++ b/drivers/video/via/ioctl.c
@@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long arg)
 {
 	struct viafb_ioctl_info viainfo;
 
+	memset(&viainfo, 0, sizeof(struct viafb_ioctl_info));
+
 	viainfo.viafb_id = VIAID;
 	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
 
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 7127bfe..77a0d5e 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -95,11 +95,6 @@ static struct pci_device_id virtio_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 
-/* A PCI device has it's own struct device and so does a virtio device so
- * we create a place for the virtio devices to show up in sysfs.  I think it
- * would make more sense for virtio to not insist on having it's own device. */
-static struct device *virtio_pci_root;
-
 /* Convert a generic virtio device to our structure */
 static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 {
@@ -628,7 +623,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	vp_dev->vdev.dev.parent = virtio_pci_root;
+	vp_dev->vdev.dev.parent = &pci_dev->dev;
 	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
@@ -649,6 +644,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		goto out_req_regions;
 
 	pci_set_drvdata(pci_dev, vp_dev);
+	pci_set_master(pci_dev);
 
 	/* we use the subsystem vendor/device id as the virtio vendor/device
 	 * id.  this allows us to use the same PCI vendor/device id for all
@@ -712,17 +708,7 @@ static struct pci_driver virtio_pci_driver = {
 
 static int __init virtio_pci_init(void)
 {
-	int err;
-
-	virtio_pci_root = root_device_register("virtio-pci");
-	if (IS_ERR(virtio_pci_root))
-		return PTR_ERR(virtio_pci_root);
-
-	err = pci_register_driver(&virtio_pci_driver);
-	if (err)
-		root_device_unregister(virtio_pci_root);
-
-	return err;
+	return pci_register_driver(&virtio_pci_driver);
 }
 
 module_init(virtio_pci_init);
@@ -730,7 +716,6 @@ module_init(virtio_pci_init);
 static void __exit virtio_pci_exit(void)
 {
 	pci_unregister_driver(&virtio_pci_driver);
-	root_device_unregister(virtio_pci_root);
 }
 
 module_exit(virtio_pci_exit);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ce602dd..b2ccb3e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -254,7 +254,7 @@ static void init_evtchn_cpu_bindings(void)
 	}
 #endif
 
-	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
+	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
 }
 
 static inline void clear_evtchn(int port)
diff --git a/fs/aio.c b/fs/aio.c
index 1cf12b3..4e58cd4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1660,6 +1660,9 @@ SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
 	if (unlikely(nr < 0))
 		return -EINVAL;
 
+	if (unlikely(nr > LONG_MAX/sizeof(*iocbpp)))
+		nr = LONG_MAX/sizeof(*iocbpp);
+
 	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
 		return -EFAULT;
 
diff --git a/fs/bio.c b/fs/bio.c
index 88094af..22f8df7 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -371,6 +371,9 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio;
 
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
 	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
 		      gfp_mask);
 	if (unlikely(!bio))
@@ -701,8 +704,12 @@ static void bio_free_map_data(struct bio_map_data *bmd)
 static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
 					       gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), gfp_mask);
+	struct bio_map_data *bmd;
 
+	if (iov_count > UIO_MAXIOV)
+		return NULL;
+
+	bmd = kmalloc(sizeof(*bmd), gfp_mask);
 	if (!bmd)
 		return NULL;
 
@@ -831,6 +838,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		end = (uaddr + iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		start = uaddr >> PAGE_SHIFT;
 
+		/*
+		 * Overflow, abort
+		 */
+		if (end < start)
+			return ERR_PTR(-EINVAL);
+
 		nr_pages += end - start;
 		len += iov[i].iov_len;
 	}
@@ -958,6 +971,12 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long start = uaddr >> PAGE_SHIFT;
 
+		/*
+		 * Overflow, abort
+		 */
+		if (end < start)
+			return ERR_PTR(-EINVAL);
+
 		nr_pages += end - start;
 		/*
 		 * buffer must be aligned to at least hardsector size for now
@@ -985,7 +1004,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 		unsigned long start = uaddr >> PAGE_SHIFT;
 		const int local_nr_pages = end - start;
 		const int page_limit = cur_page + local_nr_pages;
-		
+
 		ret = get_user_pages_fast(uaddr, local_nr_pages,
 				write_to_vm, &pages[cur_page]);
 		if (ret < local_nr_pages) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..f8b4521 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -128,7 +128,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num;
+	char *p, *num, *orig;
 	int intarg;
 	int ret = 0;
 
@@ -143,6 +143,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	if (!options)
 		return -ENOMEM;
 
+	orig = options;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -280,7 +281,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		}
 	}
 out:
-	kfree(options);
+	kfree(orig);
 	return ret;
 }
 
diff --git a/fs/char_dev.c b/fs/char_dev.c
index d6db933..be7613e 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -39,7 +39,9 @@ struct backing_dev_info directly_mappable_cdev_bdi = {
 #endif
 		/* permit direct mmap, for read, write or exec */
 		BDI_CAP_MAP_DIRECT |
-		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP),
+		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP |
+		/* no writeback happens */
+		BDI_CAP_NO_ACCT_AND_WRITEBACK),
 };
 
 static struct kobj_map *cdev_map;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 05a9b77..76d9f64 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -323,7 +323,7 @@ extern int CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 netfid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
-			const bool waitFlag);
+			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 smb_file_id, const int get_flag,
 			const __u64 len, struct file_lock *,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4e6dbab..04b755a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1641,7 +1641,8 @@ int
 CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	    const __u16 smb_file_id, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
-	    const __u32 numLock, const __u8 lockType, const bool waitFlag)
+	    const __u32 numLock, const __u8 lockType,
+	    const bool waitFlag, const __u8 oplock_level)
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
@@ -1669,6 +1670,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	pSMB->NumberOfLocks = cpu_to_le16(numLock);
 	pSMB->NumberOfUnlocks = cpu_to_le16(numUnlock);
 	pSMB->LockType = lockType;
+	pSMB->OplockLevel = oplock_level;
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = smb_file_id; /* netfid stays le */
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8639dd7..99387a4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -827,12 +827,12 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 		/* BB we could chain these into one lock request BB */
 		rc = CIFSSMBLock(xid, tcon, netfid, length, pfLock->fl_start,
-				 0, 1, lockType, 0 /* wait flag */ );
+				 0, 1, lockType, 0 /* wait flag */, 0);
 		if (rc == 0) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
 					 pfLock->fl_start, 1 /* numUnlock */ ,
 					 0 /* numLock */ , lockType,
-					 0 /* wait flag */ );
+					 0 /* wait flag */, 0);
 			pfLock->fl_type = F_UNLCK;
 			if (rc != 0)
 				cERROR(1, ("Error unlocking previously locked "
@@ -875,8 +875,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 		if (numLock) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					pfLock->fl_start,
-					0, numLock, lockType, wait_flag);
+					 pfLock->fl_start, 0, numLock, lockType,
+					 wait_flag, 0);
 
 			if (rc == 0) {
 				/* For Windows locks we must store them. */
@@ -896,9 +896,9 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 						(pfLock->fl_start + length) >=
 						(li->offset + li->length)) {
 					stored_rc = CIFSSMBLock(xid, tcon,
-							netfid,
-							li->length, li->offset,
-							1, 0, li->type, false);
+							netfid, li->length,
+							li->offset, 1, 0,
+							li->type, false, 0);
 					if (stored_rc)
 						rc = stored_rc;
 
@@ -2316,7 +2316,8 @@ cifs_oplock_break(struct slow_work *work)
 	 */
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false);
+				 LOCKING_ANDX_OPLOCK_RELEASE, false,
+				 cinode->clientCanCacheRead ? 1 : 0);
 		cFYI(1, ("Oplock release rc = %d", rc));
 	}
 }
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 23dc2af..e921aa1 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -69,15 +69,19 @@ ecryptfs_create_underlying_file(struct inode *lower_dir_inode,
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	struct dentry *dentry_save;
 	struct vfsmount *vfsmount_save;
+	unsigned int flags_save;
 	int rc;
 
 	dentry_save = nd->path.dentry;
 	vfsmount_save = nd->path.mnt;
+	flags_save = nd->flags;
 	nd->path.dentry = lower_dentry;
 	nd->path.mnt = lower_mnt;
+	nd->flags &= ~LOOKUP_OPEN;
 	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
 	nd->path.dentry = dentry_save;
 	nd->path.mnt = vfsmount_save;
+	nd->flags = flags_save;
 	return rc;
 }
 
@@ -1027,6 +1031,8 @@ int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
+		fsstack_copy_attr_all(dentry->d_inode,
+				      ecryptfs_inode_to_lower(dentry->d_inode));
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blocks = lower_stat.blocks;
 	}
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..a8dfe21 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -63,6 +63,13 @@
  * cleanup path and it is also acquired by eventpoll_release_file()
  * if a file has been pushed inside an epoll set and it is then
  * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
+ * It is also acquired when inserting an epoll fd onto another epoll
+ * fd. We do this so that we walk the epoll tree and ensure that this
+ * insertion does not create a cycle of epoll file descriptors, which
+ * could lead to deadlock. We need a global mutex to prevent two
+ * simultaneous inserts (A into B and B into A) from racing and
+ * constructing a cycle without either insert observing that it is
+ * going to.
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
@@ -227,6 +234,9 @@ static int max_user_watches __read_mostly;
  */
 static DEFINE_MUTEX(epmutex);
 
+/* Used to check for epoll file descriptor inclusion loops */
+static struct nested_calls poll_loop_ncalls;
+
 /* Used for safe wake up implementation */
 static struct nested_calls poll_safewake_ncalls;
 
@@ -1182,6 +1192,62 @@ retry:
 	return res;
 }
 
+/**
+ * ep_loop_check_proc - Callback function to be passed to the @ep_call_nested()
+ *                      API, to verify that adding an epoll file inside another
+ *                      epoll structure, does not violate the constraints, in
+ *                      terms of closed loops, or too deep chains (which can
+ *                      result in excessive stack usage).
+ *
+ * @priv: Pointer to the epoll file to be currently checked.
+ * @cookie: Original cookie for this call. This is the top-of-the-chain epoll
+ *          data structure pointer.
+ * @call_nests: Current dept of the @ep_call_nested() call stack.
+ *
+ * Returns: Returns zero if adding the epoll @file inside current epoll
+ *          structure @ep does not violate the constraints, or -1 otherwise.
+ */
+static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
+{
+	int error = 0;
+	struct file *file = priv;
+	struct eventpoll *ep = file->private_data;
+	struct rb_node *rbp;
+	struct epitem *epi;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		epi = rb_entry(rbp, struct epitem, rbn);
+		if (unlikely(is_file_epoll(epi->ffd.file))) {
+			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+					       ep_loop_check_proc, epi->ffd.file,
+					       epi->ffd.file->private_data, current);
+			if (error != 0)
+				break;
+		}
+	}
+	mutex_unlock(&ep->mtx);
+
+	return error;
+}
+
+/**
+ * ep_loop_check - Performs a check to verify that adding an epoll file (@file)
+ *                 another epoll file (represented by @ep) does not create
+ *                 closed loops or too deep chains.
+ *
+ * @ep: Pointer to the epoll private data structure.
+ * @file: Pointer to the epoll file to be checked.
+ *
+ * Returns: Returns zero if adding the epoll @file inside current epoll
+ *          structure @ep does not violate the constraints, or -1 otherwise.
+ */
+static int ep_loop_check(struct eventpoll *ep, struct file *file)
+{
+	return ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+			      ep_loop_check_proc, file, ep, current);
+}
+
 /*
  * Open an eventpoll file descriptor.
  */
@@ -1230,6 +1296,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
 	int error;
+	int did_lock_epmutex = 0;
 	struct file *file, *tfile;
 	struct eventpoll *ep;
 	struct epitem *epi;
@@ -1271,6 +1338,25 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 */
 	ep = file->private_data;
 
+	/*
+	 * When we insert an epoll file descriptor, inside another epoll file
+	 * descriptor, there is the change of creating closed loops, which are
+	 * better be handled here, than in more critical paths.
+	 *
+	 * We hold epmutex across the loop check and the insert in this case, in
+	 * order to prevent two separate inserts from racing and each doing the
+	 * insert "at the same time" such that ep_loop_check passes on both
+	 * before either one does the insert, thereby creating a cycle.
+	 */
+	if (unlikely(is_file_epoll(tfile) && op == EPOLL_CTL_ADD)) {
+		mutex_lock(&epmutex);
+		did_lock_epmutex = 1;
+		error = -ELOOP;
+		if (ep_loop_check(ep, tfile) != 0)
+			goto error_tgt_fput;
+	}
+
+
 	mutex_lock(&ep->mtx);
 
 	/*
@@ -1306,6 +1392,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
+	if (unlikely(did_lock_epmutex))
+		mutex_unlock(&epmutex);
+
 	fput(tfile);
 error_fput:
 	fput(file);
@@ -1424,6 +1513,12 @@ static int __init eventpoll_init(void)
 	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
+	/*
+	 * Initialize the structure used to perform epoll file descriptor
+	 * inclusion loops checks.
+	 */
+	ep_nested_calls_init(&poll_loop_ncalls);
+
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
 
diff --git a/fs/exec.c b/fs/exec.c
index 332f781..2fe3f18 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -246,6 +246,11 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (err)
+		goto err;
+
 	err = insert_vm_struct(mm, vma);
 	if (err)
 		goto err;
@@ -375,6 +380,9 @@ static int count(char __user * __user * argv, int max)
 			argv++;
 			if (i++ >= max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
 			cond_resched();
 		}
 	}
@@ -418,6 +426,12 @@ static int copy_strings(int argc, char __user * __user * argv,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;
@@ -593,6 +607,11 @@ int setup_arg_pages(struct linux_binprm *bprm,
 #else
 	stack_top = arch_align_stack(stack_top);
 	stack_top = PAGE_ALIGN(stack_top);
+
+	if (unlikely(stack_top < mmap_min_addr) ||
+	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr))
+		return -ENOMEM;
+
 	stack_shift = vma->vm_end - stack_top;
 
 	bprm->p -= stack_shift;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index dd7175c..e5618d4 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -327,7 +327,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 		new_de = ext2_find_entry (new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
 		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
@@ -339,12 +338,9 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 			if (new_dir->i_nlink >= EXT2_LINK_MAX)
 				goto out_dir;
 		}
-		inode_inc_link_count(old_inode);
 		err = ext2_add_link(new_dentry, old_inode);
-		if (err) {
-			inode_dec_link_count(old_inode);
+		if (err)
 			goto out_dir;
-		}
 		if (dir_de)
 			inode_inc_link_count(new_dir);
 	}
@@ -352,12 +348,11 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	/*
 	 * Like most other Unix systems, set the ctime for inodes on a
  	 * rename.
-	 * inode_dec_link_count() will mark the inode dirty.
 	 */
 	old_inode->i_ctime = CURRENT_TIME_SEC;
+	mark_inode_dirty(old_inode);
 
 	ext2_delete_entry (old_de, old_page);
-	inode_dec_link_count(old_inode);
 
 	if (dir_de) {
 		if (old_dir != new_dir)
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 7b0e44f..5589aa1 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1550,8 +1550,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
 		if (err)
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 22bc743..876c748 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -189,9 +189,6 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
  * when a file system is mounted (see ext4_fill_super).
  */
 
-
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /**
  * ext4_get_group_desc() -- load group descriptor from disk
  * @sb:			super block
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 602d5ad..3744359 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1773,6 +1773,8 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cae75c1..505a281 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1952,7 +1952,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 
 	BUG_ON(cex->ec_type != EXT4_EXT_CACHE_GAP &&
 			cex->ec_type != EXT4_EXT_CACHE_EXTENT);
-	if (block >= cex->ec_block && block < cex->ec_block + cex->ec_len) {
+	if (in_range(block, cex->ec_block, cex->ec_len)) {
 		ex->ee_block = cpu_to_le32(cex->ec_block);
 		ext4_ext_store_pblock(ex, cex->ec_start);
 		ex->ee_len = cpu_to_le16(cex->ec_len);
@@ -3258,7 +3258,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		 */
 		ee_len = ext4_ext_get_actual_len(ex);
 		/* if found extent covers block, simply return it */
-		if (iblock >= ee_block && iblock < ee_block + ee_len) {
+		if (in_range(iblock, ee_block, ee_len)) {
 			newblock = iblock - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (iblock - ee_block);
@@ -3545,6 +3545,11 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, (len + offset));
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
+	}
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 436521c..ae6de87 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -220,8 +220,6 @@ struct ext4_buddy {
 #define EXT4_MB_BITMAP(e4b)	((e4b)->bd_bitmap)
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 					struct ext4_free_extent *fex)
 {
diff --git a/fs/file_table.c b/fs/file_table.c
index 32d12b7..d4be17f 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -123,13 +123,13 @@ struct file *get_empty_filp(void)
 		goto fail;
 
 	percpu_counter_inc(&nr_files);
+	f->f_cred = get_cred(cred);
 	if (security_file_alloc(f))
 		goto fail_sec;
 
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_cred = get_cred(cred);
 	spin_lock_init(&f->f_lock);
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a9f5e13..f6104a95 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -85,18 +86,52 @@ struct fuse_file *fuse_file_get(struct fuse_file *ff)
 	return ff;
 }
 
+static void fuse_release_async(struct work_struct *work)
+{
+	struct fuse_req *req;
+	struct fuse_conn *fc;
+	struct path path;
+
+	req = container_of(work, struct fuse_req, misc.release.work);
+	path = req->misc.release.path;
+	fc = get_fuse_conn(path.dentry->d_inode);
+
+	fuse_put_request(fc, req);
+	path_put(&path);
+}
+
 static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	path_put(&req->misc.release.path);
+	if (fc->destroy_req) {
+		/*
+		 * If this is a fuseblk mount, then it's possible that
+		 * releasing the path will result in releasing the
+		 * super block and sending the DESTROY request.  If
+		 * the server is single threaded, this would hang.
+		 * For this reason do the path_put() in a separate
+		 * thread.
+		 */
+		atomic_inc(&req->count);
+		INIT_WORK(&req->misc.release.work, fuse_release_async);
+		schedule_work(&req->misc.release.work);
+	} else {
+		path_put(&req->misc.release.path);
+	}
 }
 
-static void fuse_file_put(struct fuse_file *ff)
+static void fuse_file_put(struct fuse_file *ff, bool sync)
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
 
-		req->end = fuse_release_end;
-		fuse_request_send_background(ff->fc, req);
+		if (sync) {
+			fuse_request_send(ff->fc, req);
+			path_put(&req->misc.release.path);
+			fuse_put_request(ff->fc, req);
+		} else {
+			req->end = fuse_release_end;
+			fuse_request_send_background(ff->fc, req);
+		}
 		kfree(ff);
 	}
 }
@@ -134,6 +169,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
@@ -141,6 +177,15 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		spin_lock(&fc->lock);
+		fi->attr_version = ++fc->attr_version;
+		i_size_write(inode, 0);
+		spin_unlock(&fc->lock);
+		fuse_invalidate_attr(inode);
+	}
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
@@ -208,8 +253,12 @@ void fuse_release_common(struct file *file, int opcode)
 	 * Normally this will send the RELEASE request, however if
 	 * some asynchronous READ or WRITE requests are outstanding,
 	 * the sending will be delayed.
+	 *
+	 * Make the release synchronous if this is a fuseblk mount,
+	 * synchronous RELEASE is allowed (and desirable) in this case
+	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff);
+	fuse_file_put(ff, ff->fc->destroy_req != NULL);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)
@@ -538,7 +587,7 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		unlock_page(page);
 	}
 	if (req->ff)
-		fuse_file_put(req->ff);
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_send_readpages(struct fuse_req *req, struct file *file)
@@ -1118,7 +1167,7 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
 	__free_page(req->pages[0]);
-	fuse_file_put(req->ff);
+	fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
@@ -1609,6 +1658,58 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 	return 0;
 }
 
+/* Make sure iov_length() won't overflow */
+static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
+{
+	size_t n;
+	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
+
+	for (n = 0; n < count; n++) {
+		if (iov->iov_len > (size_t) max)
+			return -ENOMEM;
+		max -= iov->iov_len;
+	}
+	return 0;
+}
+
+/*
+ * CUSE servers compiled on 32bit broke on 64bit kernels because the
+ * ABI was defined to be 'struct iovec' which is different on 32bit
+ * and 64bit.  Fortunately we can determine which structure the server
+ * used from the size of the reply.
+ */
+static int fuse_copy_ioctl_iovec(struct iovec *dst, void *src,
+				 size_t transferred, unsigned count,
+				 bool is_compat)
+{
+#ifdef CONFIG_COMPAT
+	if (count * sizeof(struct compat_iovec) == transferred) {
+		struct compat_iovec *ciov = src;
+		unsigned i;
+
+		/*
+		 * With this interface a 32bit server cannot support
+		 * non-compat (i.e. ones coming from 64bit apps) ioctl
+		 * requests
+		 */
+		if (!is_compat)
+			return -EINVAL;
+
+		for (i = 0; i < count; i++) {
+			dst[i].iov_base = compat_ptr(ciov[i].iov_base);
+			dst[i].iov_len = ciov[i].iov_len;
+		}
+		return 0;
+	}
+#endif
+
+	if (count * sizeof(struct iovec) != transferred)
+		return -EIO;
+
+	memcpy(dst, src, transferred);
+	return 0;
+}
+
 /*
  * For ioctls, there is no generic way to determine how much memory
  * needs to be read and/or written.  Furthermore, ioctls are allowed
@@ -1790,18 +1891,25 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		    in_iovs + out_iovs > FUSE_IOCTL_MAX_IOV)
 			goto out;
 
-		err = -EIO;
-		if ((in_iovs + out_iovs) * sizeof(struct iovec) != transferred)
-			goto out;
-
-		/* okay, copy in iovs and retry */
 		vaddr = kmap_atomic(pages[0], KM_USER0);
-		memcpy(page_address(iov_page), vaddr, transferred);
+		err = fuse_copy_ioctl_iovec(page_address(iov_page), vaddr,
+					    transferred, in_iovs + out_iovs,
+					    (flags & FUSE_IOCTL_COMPAT) != 0);
 		kunmap_atomic(vaddr, KM_USER0);
+		if (err)
+			goto out;
 
 		in_iov = page_address(iov_page);
 		out_iov = in_iov + in_iovs;
 
+		err = fuse_verify_ioctl_iov(in_iov, in_iovs);
+		if (err)
+			goto out;
+
+		err = fuse_verify_ioctl_iov(out_iov, out_iovs);
+		if (err)
+			goto out;
+
 		goto retry;
 	}
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 01cc462..e6d614d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -21,6 +21,7 @@
 #include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/poll.h>
+#include <linux/workqueue.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -254,7 +255,10 @@ struct fuse_req {
 	union {
 		struct fuse_forget_in forget_in;
 		struct {
-			struct fuse_release_in in;
+			union {
+				struct fuse_release_in in;
+				struct work_struct work;
+			};
 			struct path path;
 		} release;
 		struct fuse_init_in init_in;
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0d28982..e74a670 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -401,15 +401,18 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 		pos += vec->iov_len;
 	}
 
+	/*
+	 * If no bytes were started, return the error, and let the
+	 * generic layer handle the completion.
+	 */
+	if (requested_bytes == 0) {
+		nfs_direct_req_release(dreq);
+		return result < 0 ? result : -EIO;
+	}
+
 	if (put_dreq(dreq))
 		nfs_direct_complete(dreq);
-
-	if (requested_bytes != 0)
-		return 0;
-
-	if (result < 0)
-		return result;
-	return -EIO;
+	return 0;
 }
 
 static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
@@ -829,15 +832,18 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 		pos += vec->iov_len;
 	}
 
+	/*
+	 * If no bytes were started, return the error, and let the
+	 * generic layer handle the completion.
+	 */
+	if (requested_bytes == 0) {
+		nfs_direct_req_release(dreq);
+		return result < 0 ? result : -EIO;
+	}
+
 	if (put_dreq(dreq))
 		nfs_direct_write_complete(dreq, dreq->inode);
-
-	if (requested_bytes != 0)
-		return 0;
-
-	if (result < 0)
-		return result;
-	return -EIO;
+	return 0;
 }
 
 static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index bdd2142..e6794e0 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -218,7 +218,7 @@ static int nfs_do_fsync(struct nfs_open_context *ctx, struct inode *inode)
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }
@@ -670,6 +670,7 @@ static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = filp->f_mapping->host;
 	int status = 0;
+	unsigned int saved_type = fl->fl_type;
 
 	/* Try local locking first */
 	posix_test_lock(filp, fl);
@@ -677,6 +678,7 @@ static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
 		/* found a conflict */
 		goto out;
 	}
+	fl->fl_type = saved_type;
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		goto out_noconflict;
diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index 59047f8..3dde50c 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -503,13 +503,13 @@ static struct rpc_procinfo mnt3_procedures[] = {
 
 static struct rpc_version mnt_version1 = {
 	.number		= 1,
-	.nrprocs	= 2,
+	.nrprocs	= ARRAY_SIZE(mnt_procedures),
 	.procs		= mnt_procedures,
 };
 
 static struct rpc_version mnt_version3 = {
 	.number		= 3,
-	.nrprocs	= 2,
+	.nrprocs	= ARRAY_SIZE(mnt3_procedures),
 	.procs		= mnt3_procedures,
 };
 
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2a533a0..7e84a85 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -260,9 +260,11 @@ void fill_post_wcc(struct svc_fh *fhp)
 	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
 			&fhp->fh_post_attr);
 	fhp->fh_post_change = fhp->fh_dentry->d_inode->i_version;
-	if (err)
+	if (err) {
 		fhp->fh_post_saved = 0;
-	else
+		/* Grab the ctime anyway - set_change_info might use it */
+		fhp->fh_post_attr.ctime = fhp->fh_dentry->d_inode->i_ctime;
+	} else
 		fhp->fh_post_saved = 1;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 718f3fb..f226172 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -315,8 +315,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((host_err = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
-			goto out_nfserr;
+		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
+			return status;
 		iattr->ia_valid |= ATTR_UID;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
@@ -326,8 +326,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((host_err = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
-			goto out_nfserr;
+		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
+			return status;
 		iattr->ia_valid |= ATTR_GID;
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {
@@ -1106,7 +1106,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 
 	u32 dummy;
 	char *machine_name;
-	int i;
+	int i, j;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1179,7 +1179,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (i = 0; i < dummy; ++i)
+			for (j = 0; j < dummy; ++j)
 				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8715d19..c217a940 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -831,7 +831,7 @@ nfsd_get_raparms(dev_t dev, ino_t ino)
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index efa3377..c1aed78 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -479,18 +479,17 @@ static inline bool nfsd4_not_cached(struct nfsd4_compoundres *resp)
 static inline void
 set_change_info(struct nfsd4_change_info *cinfo, struct svc_fh *fhp)
 {
-	BUG_ON(!fhp->fh_pre_saved || !fhp->fh_post_saved);
-	cinfo->atomic = 1;
+	BUG_ON(!fhp->fh_pre_saved);
+	cinfo->atomic = fhp->fh_post_saved;
 	cinfo->change_supported = IS_I_VERSION(fhp->fh_dentry->d_inode);
-	if (cinfo->change_supported) {
-		cinfo->before_change = fhp->fh_pre_change;
-		cinfo->after_change = fhp->fh_post_change;
-	} else {
-		cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
-		cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
-		cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;
-		cinfo->after_ctime_nsec = fhp->fh_post_attr.ctime.tv_nsec;
-	}
+
+	cinfo->before_change = fhp->fh_pre_change;
+	cinfo->after_change = fhp->fh_post_change;
+	cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
+	cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
+	cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;
+	cinfo->after_ctime_nsec = fhp->fh_post_attr.ctime.tv_nsec;
+
 }
 
 int nfs4svc_encode_voidres(struct svc_rqst *, __be32 *, void *);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 75aa15a..3dcc044 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -100,8 +100,11 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
 {
 	__u32 mask;
 
-	/* everything should accept their own ignored and cares about children */
-	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD);
+	/*
+	 * everything should accept their own ignored, cares about children,
+	 * and should receive events when the inode is unmounted
+	 */
+	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD | FS_UNMOUNT);
 
 	/* mask off the flags used to open the fd */
 	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a8e8572..83fb185 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3214,7 +3214,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 					u32 num_clusters, unsigned int e_flags)
 {
 	int ret, delete, index, credits =  0;
-	u32 new_bit, new_len;
+	u32 new_bit, new_len, orig_num_clusters;
 	unsigned int set_len;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
@@ -3247,6 +3247,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		goto out;
 	}
 
+	orig_num_clusters = num_clusters;
+
 	while (num_clusters) {
 		ret = ocfs2_get_refcount_rec(ref_ci, context->ref_root_bh,
 					     p_cluster, num_clusters,
@@ -3334,7 +3336,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	 * in write-back mode.
 	 */
 	if (context->get_clusters == ocfs2_di_get_clusters) {
-		ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+		ret = ocfs2_cow_sync_writeback(sb, context, cpos,
+					       orig_num_clusters);
 		if (ret)
 			mlog_errno(ret);
 	}
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index da78a2a..197249e 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -191,7 +191,7 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
 			return c;
 	}
 
-	return c;
+	return NULL;
 }
 
 /*
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 32499d21..9975457 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -128,7 +128,7 @@ static void *ocfs2_fast_follow_link(struct dentry *dentry,
 	}
 
 	/* Fast symlinks can't be large */
-	len = strlen(target);
+	len = strnlen(target, ocfs2_fast_symlink_chars(inode->i_sb));
 	link = kzalloc(len + 1, GFP_NOFS);
 	if (!link) {
 		status = -ENOMEM;
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 8652fb9..2cd9e43 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -251,6 +251,11 @@ static bool ldm_parse_vmdb (const u8 *data, struct vmdb *vm)
 	}
 
 	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	if (vm->vblk_size == 0) {
+		ldm_error ("Illegal VBLK size");
+		return false;
+	}
+
 	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
 	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 
diff --git a/fs/partitions/mac.c b/fs/partitions/mac.c
index d4a0fad..5765198 100644
--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -29,10 +29,9 @@ static inline void mac_fix_string(char *stg, int len)
 
 int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-	int slot = 1;
 	Sector sect;
 	unsigned char *data;
-	int blk, blocks_in_map;
+	int slot, blocks_in_map;
 	unsigned secsize;
 #ifdef CONFIG_PPC_PMAC
 	int found_root = 0;
@@ -59,10 +58,14 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	printk(" [mac]");
 	blocks_in_map = be32_to_cpu(part->map_count);
-	for (blk = 1; blk <= blocks_in_map; ++blk) {
-		int pos = blk * secsize;
+	if (blocks_in_map < 0 || blocks_in_map >= DISK_MAX_PARTS) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	printk(" [mac]");
+	for (slot = 1; slot <= blocks_in_map; ++slot) {
+		int pos = slot * secsize;
 		put_dev_sector(sect);
 		data = read_dev_sector(bdev, pos/512, &sect);
 		if (!data)
@@ -113,13 +116,11 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 			}
 
 			if (goodness > found_root_goodness) {
-				found_root = blk;
+				found_root = slot;
 				found_root_goodness = goodness;
 			}
 		}
 #endif /* CONFIG_PPC_PMAC */
-
-		++slot;
 	}
 #ifdef CONFIG_PPC_PMAC
 	if (found_root_goodness)
diff --git a/fs/pipe.c b/fs/pipe.c
index 37ba29f..8087027 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -363,7 +363,7 @@ pipe_read(struct kiocb *iocb, const struct iovec *_iov,
 			error = ops->confirm(pipe, buf);
 			if (error) {
 				if (!ret)
-					error = ret;
+					ret = error;
 				break;
 			}
 
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 69eb4c4..e804967 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -177,7 +177,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
-	cred = get_cred((struct cred *) __task_cred(p));
+	cred = get_task_cred(p);
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -352,9 +352,6 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_cap(m, task);
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
-#if defined(CONFIG_S390)
-	task_show_regs(m, task);
-#endif
 	task_context_switch_counts(m, task);
 	return 0;
 }
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9df34a5..d41b474 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -206,6 +206,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
+	unsigned long start;
 	dev_t dev = 0;
 	int len;
 
@@ -216,8 +217,13 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
+	/* We don't show the stack guard page in /proc/maps */
+	start = vma->vm_start;
+	if (vma->vm_flags & VM_GROWSDOWN)
+		start += PAGE_SIZE;
+
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
-			vma->vm_start,
+			start,
 			vma->vm_end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index f53505d..5cbb81e 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -170,6 +170,7 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
 int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
+	int depth;
 	int index;
 	struct page *page;
 	struct address_space *mapping;
@@ -188,8 +189,8 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 	/* we need to make sure nobody is changing the file size beneath
 	 ** us
 	 */
-	mutex_lock(&inode->i_mutex);
-	reiserfs_write_lock(inode->i_sb);
+	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
+	depth = reiserfs_write_lock_once(inode->i_sb);
 
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
@@ -224,6 +225,6 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 
       out:
 	mutex_unlock(&inode->i_mutex);
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
 	return retval;
 }
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index dd20a78..933e68e 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -471,7 +471,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 		struct reiserfs_transaction_handle th;
 		size_t size = reiserfs_xattr_nblocks(inode,
 					     reiserfs_acl_size(clone->a_count));
-		reiserfs_write_lock(inode->i_sb);
+		int depth;
+
+		depth = reiserfs_write_lock_once(inode->i_sb);
 		error = journal_begin(&th, inode->i_sb, size * 2);
 		if (!error) {
 			int error2;
@@ -481,7 +483,7 @@ int reiserfs_acl_chmod(struct inode *inode)
 			if (error2)
 				error = error2;
 		}
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 	}
 	posix_acl_release(clone);
 	return error;
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index a034cf6..810ff27 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -790,6 +790,8 @@ xfs_ioc_fsgetxattr(
 {
 	struct fsxattr		fa;
 
+	memset(&fa, 0, sizeof(struct fsxattr));
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index ffac157..c6c8eb9 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1020,7 +1020,7 @@ struct drm_device {
 	struct pci_controller *hose;
 #endif
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
-	int num_crtcs;                  /**< Number of CRTCs on this device */
+	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
 	void *mm_private;
 	struct address_space *dev_mapping;
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 0cbdccc..d2674f9 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -28,7 +28,6 @@
 	{0x1002, 0x4156, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV350}, \
 	{0x1002, 0x4237, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP}, \
 	{0x1002, 0x4242, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
-	{0x1002, 0x4243, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
 	{0x1002, 0x4336, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS100|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4337, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4437, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
@@ -85,7 +84,6 @@
 	{0x1002, 0x5460, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x5462, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x5464, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
-	{0x1002, 0x5657, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5548, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R423|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5549, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R423|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x554A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R423|RADEON_NEW_MEMMAP}, \
@@ -103,6 +101,7 @@
 	{0x1002, 0x564F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5652, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5653, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x5657, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5834, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS300|RADEON_IS_IGP}, \
 	{0x1002, 0x5835, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS300|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x5954, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS480|RADEON_IS_IGP|RADEON_IS_MOBILITY|RADEON_IS_IGPGART}, \
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 81eb9f4..d30dc3c 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -224,9 +224,11 @@ struct ttm_buffer_object {
 
 	atomic_t reserved;
 
-
 	/**
 	 * Members protected by the bo::lock
+	 * In addition, setting sync_obj to anything else
+	 * than NULL requires bo::reserved to be held. This allows for
+	 * checking NULL while reserved but not holding bo::lock.
 	 */
 
 	void *sync_obj_arg;
diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 5cb86c3..fc48754 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -99,7 +99,6 @@ struct rxrpc_key_token {
  * structure of raw payloads passed to add_key() or instantiate key
  */
 struct rxrpc_key_data_v1 {
-	u32		kif_version;		/* 1 */
 	u16		security_index;
 	u16		ticket_length;
 	u32		expiry;			/* time_t */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1896e86..3b1df72 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -926,7 +926,7 @@ extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
-extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
@@ -1077,7 +1077,7 @@ static inline unsigned int queue_physical_block_size(struct request_queue *q)
 	return q->limits.physical_block_size;
 }
 
-static inline int bdev_physical_block_size(struct block_device *bdev)
+static inline unsigned int bdev_physical_block_size(struct block_device *bdev)
 {
 	return queue_physical_block_size(bdev_get_queue(bdev));
 }
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ef68119..f66c13d 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -353,5 +353,7 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+extern void __user *compat_alloc_user_space(unsigned long len);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4e3387a..ad64471 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -153,6 +153,7 @@ struct cred {
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
 extern int copy_creds(struct task_struct *, unsigned long);
+extern const struct cred *get_task_cred(struct task_struct *);
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
@@ -283,26 +284,6 @@ static inline void put_cred(const struct cred *_cred)
 	((const struct cred *)(rcu_dereference((task)->real_cred)))
 
 /**
- * get_task_cred - Get another task's objective credentials
- * @task: The task to query
- *
- * Get the objective credentials of a task, pinning them so that they can't go
- * away.  Accessing a task's credentials directly is not permitted.
- *
- * The caller must make sure task doesn't go away, either by holding a ref on
- * task or by holding tasklist_lock to prevent it from being unlinked.
- */
-#define get_task_cred(task)				\
-({							\
-	struct cred *__cred;				\
-	rcu_read_lock();				\
-	__cred = (struct cred *) __task_cred((task));	\
-	get_cred(__cred);				\
-	rcu_read_unlock();				\
-	__cred;						\
-})
-
-/**
  * get_current_cred - Get the current task's subjective credentials
  *
  * Get the subjective credentials of the current task, pinning them so that
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b4f97d..529a6d1 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -412,6 +412,7 @@ extern void unregister_ftrace_graph(void);
 
 extern void ftrace_graph_init_task(struct task_struct *t);
 extern void ftrace_graph_exit_task(struct task_struct *t);
+extern void ftrace_graph_init_idle_task(struct task_struct *t, int cpu);
 
 static inline int task_curr_ret_stack(struct task_struct *t)
 {
@@ -435,6 +436,7 @@ static inline void unpause_graph_tracing(void)
 
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
+static inline void ftrace_graph_init_idle_task(struct task_struct *t, int cpu) { }
 
 static inline int task_curr_ret_stack(struct task_struct *tsk)
 {
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 047e449..098c4f62 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -910,7 +910,7 @@ struct ieee80211_ht_info {
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
diff --git a/include/linux/klist.h b/include/linux/klist.h
index e91a4e5..a370ce5 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -22,7 +22,7 @@ struct klist {
 	struct list_head	k_list;
 	void			(*get)(struct klist_node *);
 	void			(*put)(struct klist_node *);
-} __attribute__ ((aligned (4)));
+} __attribute__ ((aligned (sizeof(void *))));
 
 #define KLIST_INIT(_name, _get, _put)					\
 	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 30fe668..b345e6d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -290,6 +290,13 @@ struct zone {
 	unsigned long watermark[NR_WMARK];
 
 	/*
+	 * When free pages are below this point, additional steps are taken
+	 * when reading the number of free pages to avoid per-cpu counter
+	 * drift allowing watermarks to be breached
+	 */
+	unsigned long percpu_drift_mark;
+
+	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
 	 * GB of ram we must reserve some of the lower zone memory (otherwise we risk
@@ -460,6 +467,12 @@ static inline int zone_is_oom_locked(const struct zone *zone)
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
+#ifdef CONFIG_SMP
+unsigned long zone_nr_free_pages(struct zone *zone);
+#else
+#define zone_nr_free_pages(zone) zone_page_state(zone, NR_FREE_PAGES)
+#endif /* CONFIG_SMP */
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 03e8d81..992c700 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2083,6 +2083,10 @@ static inline u32 dev_ethtool_get_flags(struct net_device *dev)
 		return 0;
 	return dev->ethtool_ops->get_flags(dev);
 }
+
+#define MODULE_ALIAS_NETDEV(device) \
+	MODULE_ALIAS("netdev-" device)
+
 #endif /* __KERNEL__ */
 
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f0bcfbc..2aae408 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -393,6 +393,9 @@
 #define PCI_DEVICE_ID_VLSI_82C147	0x0105
 #define PCI_DEVICE_ID_VLSI_VAS96011	0x0702
 
+/* AMD RD890 Chipset */
+#define PCI_DEVICE_ID_RD890_IOMMU	0x5a23
+
 #define PCI_VENDOR_ID_ADL		0x1005
 #define PCI_DEVICE_ID_ADL_2301		0x2301
 
@@ -2036,6 +2039,7 @@
 #define PCI_DEVICE_ID_AFAVLAB_P030	0x2182
 #define PCI_SUBDEVICE_ID_AFAVLAB_P061		0x2150
 
+#define PCI_VENDOR_ID_BCM_GVC          0x14a4
 #define PCI_VENDOR_ID_BROADCOM		0x14e4
 #define PCI_DEVICE_ID_TIGON3_5752	0x1600
 #define PCI_DEVICE_ID_TIGON3_5752M	0x1601
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 732ba9a..a2608bf 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -305,8 +305,8 @@ struct ssb_bus {
 	/* ID information about the Chip. */
 	u16 chip_id;
 	u16 chip_rev;
-	u16 sprom_size;		/* number of words in sprom */
 	u16 sprom_offset;
+	u16 sprom_size;		/* number of words in sprom */
 	u8 chip_package;
 
 	/* List of devices (cores) on the backplane. */
@@ -395,6 +395,9 @@ extern int ssb_bus_sdiobus_register(struct ssb_bus *bus,
 
 extern void ssb_bus_unregister(struct ssb_bus *bus);
 
+/* Does the device have an SPROM? */
+extern bool ssb_is_sprom_available(struct ssb_bus *bus);
+
 /* Set a fallback SPROM.
  * See kdoc at the function definition for complete documentation. */
 extern int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom);
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index 7600f38..2cdf249 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -46,7 +46,6 @@
 #define   SSB_PLLTYPE_7			0x00038000	/* 25Mhz, 4 dividers */
 #define  SSB_CHIPCO_CAP_PCTL		0x00040000	/* Power Control */
 #define  SSB_CHIPCO_CAP_OTPS		0x00380000	/* OTP size */
-#define  SSB_CHIPCO_CAP_SPROM		0x40000000	/* SPROM present */
 #define  SSB_CHIPCO_CAP_OTPS_SHIFT	19
 #define  SSB_CHIPCO_CAP_OTPS_BASE	5
 #define  SSB_CHIPCO_CAP_JTAGM		0x00400000	/* JTAG master present */
@@ -54,6 +53,7 @@
 #define  SSB_CHIPCO_CAP_64BIT		0x08000000	/* 64-bit Backplane */
 #define  SSB_CHIPCO_CAP_PMU		0x10000000	/* PMU available (rev >= 20) */
 #define  SSB_CHIPCO_CAP_ECI		0x20000000	/* ECI available (rev >= 20) */
+#define  SSB_CHIPCO_CAP_SPROM		0x40000000	/* SPROM present */
 #define SSB_CHIPCO_CORECTL		0x0008
 #define  SSB_CHIPCO_CORECTL_UARTCLK0	0x00000001	/* Drive UART with internal clock */
 #define	 SSB_CHIPCO_CORECTL_SE		0x00000002	/* sync clk out enable (corerev >= 3) */
@@ -386,6 +386,7 @@
 
 
 /** Chip specific Chip-Status register contents. */
+#define SSB_CHIPCO_CHST_4322_SPROM_EXISTS	0x00000040 /* SPROM present */
 #define SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL	0x00000003
 #define SSB_CHIPCO_CHST_4325_DEFCIS_SEL		0 /* OTP is powered up, use def. CIS, no SPROM */
 #define SSB_CHIPCO_CHST_4325_SPROM_SEL		1 /* OTP is powered up, SPROM is present */
@@ -399,6 +400,18 @@
 #define SSB_CHIPCO_CHST_4325_RCAL_VALUE_SHIFT	4
 #define SSB_CHIPCO_CHST_4325_PMUTOP_2B 		0x00000200 /* 1 for 2b, 0 for to 2a */
 
+/** Macros to determine SPROM presence based on Chip-Status register. */
+#define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
+	((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+		SSB_CHIPCO_CHST_4325_OTP_SEL)
+#define SSB_CHIPCO_CHST_4322_SPROM_PRESENT(status) \
+	(status & SSB_CHIPCO_CHST_4322_SPROM_EXISTS)
+#define SSB_CHIPCO_CHST_4325_SPROM_PRESENT(status) \
+	(((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+		SSB_CHIPCO_CHST_4325_DEFCIS_SEL) && \
+	 ((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+		SSB_CHIPCO_CHST_4325_OTP_SEL))
+
 
 
 /** Clockcontrol masks and values **/
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 1819396..87d1844 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -324,6 +324,9 @@ extern int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 					struct usb_serial_port *port,
 					unsigned int ch);
 extern int usb_serial_handle_break(struct usb_serial_port *port);
+extern void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
+					 struct tty_struct *tty,
+					 unsigned int status);
 
 
 extern int usb_serial_bus_register(struct usb_serial_driver *device);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index ee03bba..01dd4ac 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -166,6 +166,28 @@ static inline unsigned long zone_page_state(struct zone *zone,
 	return x;
 }
 
+/*
+ * More accurate version that also considers the currently pending
+ * deltas. For that we need to loop over all cpus to find the current
+ * deltas. There is no synchronization so the result cannot be
+ * exactly accurate either.
+ */
+static inline unsigned long zone_page_state_snapshot(struct zone *zone,
+					enum zone_stat_item item)
+{
+	long x = atomic_long_read(&zone->vm_stat[item]);
+
+#ifdef CONFIG_SMP
+	int cpu;
+	for_each_online_cpu(cpu)
+		x += zone_pcp(zone, cpu)->vm_stat_diff[item];
+
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 extern unsigned long global_reclaimable_pages(void);
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 851c813..61d73e3 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -279,6 +279,7 @@ int sctp_do_sm(sctp_event_t event_type, sctp_subtype_t subtype,
 /* 2nd level prototypes */
 void sctp_generate_t3_rtx_event(unsigned long peer);
 void sctp_generate_heartbeat_event(unsigned long peer);
+void sctp_generate_proto_unreach_event(unsigned long peer);
 
 void sctp_ootb_pkt_free(struct sctp_packet *);
 
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 597f8e2..219043a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1010,6 +1010,9 @@ struct sctp_transport {
 	/* Heartbeat timer is per destination. */
 	struct timer_list hb_timer;
 
+	/* Timer to handle ICMP proto unreachable envets */
+	struct timer_list proto_unreach_timer;
+
 	/* Since we're using per-destination retransmission timers
 	 * (see above), we're also using per-destination "transmitted"
 	 * queues.  This probably ought to be a private struct
diff --git a/include/net/sock.h b/include/net/sock.h
index e45305d..1cb5e07 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -681,6 +681,7 @@ struct proto {
 	/* Keeping track of sk's, looking them up, and port selection methods. */
 	void			(*hash)(struct sock *sk);
 	void			(*unhash)(struct sock *sk);
+	void			(*rehash)(struct sock *sk);
 	int			(*get_port)(struct sock *sk, unsigned short snum);
 
 	/* Keeping track of sockets in use */
diff --git a/include/net/udp.h b/include/net/udp.h
index 5348d80..4201dc8 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -151,6 +151,7 @@ static inline void udp_lib_hash(struct sock *sk)
 }
 
 extern void udp_lib_unhash(struct sock *sk);
+extern void udp_lib_rehash(struct sock *sk, u16 new_hash);
 
 static inline void udp_lib_close(struct sock *sk, long timeout)
 {
diff --git a/include/net/x25.h b/include/net/x25.h
index 9baa07d..33f67fb 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -182,6 +182,10 @@ extern int  sysctl_x25_clear_request_timeout;
 extern int  sysctl_x25_ack_holdback_timeout;
 extern int  sysctl_x25_forward;
 
+extern int x25_parse_address_block(struct sk_buff *skb,
+		struct x25_address *called_addr,
+		struct x25_address *calling_addr);
+
 extern int  x25_addr_ntoa(unsigned char *, struct x25_address *,
 			  struct x25_address *);
 extern int  x25_addr_aton(unsigned char *, struct x25_address *,
diff --git a/init/calibrate.c b/init/calibrate.c
index 6eb48e5..24fe022 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -66,7 +66,7 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + 1)) {
+		while (time_before_eq(jiffies, start_jiffies + 1)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -74,8 +74,8 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+		while (time_before_eq(jiffies, start_jiffies + 1 +
+					       DELAY_CALIBRATION_TICKS)) {
 			pre_end = end;
 			read_current_timer(&end);
 		}
diff --git a/ipc/compat.c b/ipc/compat.c
index ab76fb0..5e3e3a1 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -242,6 +242,8 @@ long compat_sys_semctl(int first, int second, int third, void __user *uptr)
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
+	memset(&s64, 0, sizeof(s64));
+
 	if (!uptr)
 		return -EINVAL;
 	if (get_user(pad, (u32 __user *) uptr))
@@ -422,6 +424,8 @@ long compat_sys_msgctl(int first, int second, void __user *uptr)
 	int version = compat_ipc_parse_version(&second);
 	void __user *p;
 
+	memset(&m64, 0, sizeof(m64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_INFO:
 	case IPC_RMID:
@@ -595,6 +599,8 @@ long compat_sys_shmctl(int first, int second, void __user *uptr)
 	int err, err2;
 	int version = compat_ipc_parse_version(&second);
 
+	memset(&s64, 0, sizeof(s64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_RMID:
 	case SHM_LOCK:
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index d8d1e9f..380ea4f 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -53,6 +53,9 @@ asmlinkage long compat_sys_mq_open(const char __user *u_name,
 	void __user *p = NULL;
 	if (u_attr && oflag & O_CREAT) {
 		struct mq_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
 		p = compat_alloc_user_space(sizeof(attr));
 		if (get_compat_mq_attr(&attr, u_attr) ||
 		    copy_to_user(p, &attr, sizeof(attr)))
@@ -127,6 +130,8 @@ asmlinkage long compat_sys_mq_getsetattr(mqd_t mqdes,
 	struct mq_attr __user *p = compat_alloc_user_space(2 * sizeof(*p));
 	long ret;
 
+	memset(&mqstat, 0, sizeof(mqstat));
+
 	if (u_mqstat) {
 		if (get_compat_mq_attr(&mqstat, u_mqstat) ||
 		    copy_to_user(p, &mqstat, sizeof(mqstat)))
diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..b4c1641 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -608,6 +608,8 @@ static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in,
 	    {
 		struct semid_ds out;
 
+		memset(&out, 0, sizeof(out));
+
 		ipc64_perm_to_ipc_perm(&in->sem_perm, &out.sem_perm);
 
 		out.sem_otime	= in->sem_otime;
diff --git a/ipc/shm.c b/ipc/shm.c
index 23256b8..3cf4f25 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -476,6 +476,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
diff --git a/kernel/compat.c b/kernel/compat.c
index 180d188..8bc5578 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -25,6 +25,7 @@
 #include <linux/posix-timers.h>
 #include <linux/times.h>
 #include <linux/ptrace.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
@@ -1136,3 +1137,24 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
 
 	return 0;
 }
+
+/*
+ * Allocate user-space memory for the duration of a single system call,
+ * in order to marshall parameters inside a compat thunk.
+ */
+void __user *compat_alloc_user_space(unsigned long len)
+{
+	void __user *ptr;
+
+	/* If len would occupy more than half of the entire compat space... */
+	if (unlikely(len > (((compat_uptr_t)~0) >> 1)))
+		return NULL;
+
+	ptr = arch_compat_alloc_user_space(len);
+
+	if (unlikely(!access_ok(VERIFY_WRITE, ptr, len)))
+		return NULL;
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(compat_alloc_user_space);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5d38bd7..6145d22 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1513,8 +1513,10 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 		return -ENODEV;
 
 	trialcs = alloc_trial_cpuset(cs);
-	if (!trialcs)
-		return -ENOMEM;
+	if (!trialcs) {
+		retval = -ENOMEM;
+		goto out;
+	}
 
 	switch (cft->private) {
 	case FILE_CPULIST:
@@ -1529,6 +1531,7 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 	}
 
 	free_trial_cpuset(trialcs);
+out:
 	cgroup_unlock();
 	return retval;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 099f5e6..ddeba36 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -209,6 +209,31 @@ void exit_creds(struct task_struct *tsk)
 	}
 }
 
+/**
+ * get_task_cred - Get another task's objective credentials
+ * @task: The task to query
+ *
+ * Get the objective credentials of a task, pinning them so that they can't go
+ * away.  Accessing a task's credentials directly is not permitted.
+ *
+ * The caller must also make sure task doesn't get deleted, either by holding a
+ * ref on task or by holding tasklist_lock to prevent it from being unlinked.
+ */
+const struct cred *get_task_cred(struct task_struct *task)
+{
+	const struct cred *cred;
+
+	rcu_read_lock();
+
+	do {
+		cred = __task_cred((task));
+		BUG_ON(!cred);
+	} while (!atomic_inc_not_zero(&((struct cred *)cred)->usage));
+
+	rcu_read_unlock();
+	return cred;
+}
+
 /*
  * Allocate blank credentials, such that the credentials can be filled in at a
  * later date without risk of ENOMEM.
@@ -231,13 +256,13 @@ struct cred *cred_alloc_blank(void)
 #endif
 
 	atomic_set(&new->usage, 1);
+#ifdef CONFIG_DEBUG_CREDENTIALS
+	new->magic = CRED_MAGIC;
+#endif
 
 	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
 		goto error;
 
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	new->magic = CRED_MAGIC;
-#endif
 	return new;
 
 error:
@@ -696,6 +721,8 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	validate_creds(old);
 
 	*new = *old;
+	atomic_set(&new->usage, 1);
+	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_group_info(new->group_info);
 
@@ -713,8 +740,6 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
 		goto error;
 
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	put_cred(old);
 	validate_creds(new);
 	return new;
@@ -787,7 +812,11 @@ bool creds_are_invalid(const struct cred *cred)
 	if (cred->magic != CRED_MAGIC)
 		return true;
 #ifdef CONFIG_SECURITY_SELINUX
-	if (selinux_is_enabled()) {
+	/*
+	 * cred->security == NULL if security_cred_alloc_blank() or
+	 * security_prepare_creds() returned an error.
+	 */
+	if (selinux_is_enabled() && cred->security) {
 		if ((unsigned long) cred->security < PAGE_SIZE)
 			return true;
 		if ((*(u32 *)cred->security & 0xffffff00) ==
diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..8856c45 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -93,6 +93,14 @@ static void __exit_signal(struct task_struct *tsk)
 		posix_cpu_timers_exit_group(tsk);
 	else {
 		/*
+		 * This can only happen if the caller is de_thread().
+		 * FIXME: this is the temporary hack, we should teach
+		 * posix-cpu-timers to handle this case correctly.
+		 */
+		if (unlikely(has_group_leader_pid(tsk)))
+			posix_cpu_timers_exit_group(tsk);
+
+		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
@@ -903,6 +911,15 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	validate_creds_for_do_exit(tsk);
@@ -1382,8 +1399,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
-	/* don't need the RCU readlock here as we're holding a spinlock */
-	uid = __task_cred(p)->uid;
+	uid = task_uid(p);
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1456,7 +1472,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
-	uid = __task_cred(p)->uid;
+	uid = task_uid(p);
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..e328f57 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1363,7 +1363,6 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
@@ -1375,7 +1374,6 @@ static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	spin_unlock(&hb->lock);
-	drop_futex_key_refs(&q->key);
 }
 
 /**
@@ -1480,8 +1478,6 @@ static void unqueue_me_pi(struct futex_q *q)
 	q->pi_state = NULL;
 
 	spin_unlock(q->lock_ptr);
-
-	drop_futex_key_refs(&q->key);
 }
 
 /*
@@ -1812,7 +1808,10 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	}
 
 retry:
-	/* Prepare to wait on uaddr. */
+	/*
+	 * Prepare to wait on uaddr. On success, holds hb lock and increments
+	 * q.key refs.
+	 */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
 		goto out;
@@ -1822,24 +1821,23 @@ retry:
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	ret = 0;
+	/* unqueue_me() drops q.key ref */
 	if (!unqueue_me(&q))
-		goto out_put_key;
+		goto out;
 	ret = -ETIMEDOUT;
 	if (to && !to->task)
-		goto out_put_key;
+		goto out;
 
 	/*
 	 * We expect signal_pending(current), but we might be the
 	 * victim of a spurious wakeup as well.
 	 */
-	if (!signal_pending(current)) {
-		put_futex_key(fshared, &q.key);
+	if (!signal_pending(current))
 		goto retry;
-	}
 
 	ret = -ERESTARTSYS;
 	if (!abs_time)
-		goto out_put_key;
+		goto out;
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = futex_wait_restart;
@@ -1856,8 +1854,6 @@ retry:
 
 	ret = -ERESTART_RESTARTBLOCK;
 
-out_put_key:
-	put_futex_key(fshared, &q.key);
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
@@ -2236,7 +2232,10 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	q.rt_waiter = &rt_waiter;
 	q.requeue_pi_key = &key2;
 
-	/* Prepare to wait on uaddr. */
+	/*
+	 * Prepare to wait on uaddr. On success, increments q.key (key1) ref
+	 * count.
+	 */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
 		goto out_key2;
@@ -2254,7 +2253,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	 * In order for us to be here, we know our q.key == key2, and since
 	 * we took the hb->lock above, we also know that futex_requeue() has
 	 * completed and we no longer have to concern ourselves with a wakeup
-	 * race with the atomic proxy lock acquition by the requeue code.
+	 * race with the atomic proxy lock acquisition by the requeue code. The
+	 * futex_requeue dropped our key1 reference and incremented our key2
+	 * reference count.
 	 */
 
 	/* Check if the requeue code acquired the second futex for us. */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..3c727aa 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -936,6 +936,7 @@ static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
+		unsigned long state;
 		int reprogram;
 
 		/*
@@ -949,8 +950,13 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
-				 reprogram);
+		/*
+		 * We must preserve the CALLBACK state flag here,
+		 * otherwise we could move the timer base in
+		 * switch_hrtimer_base.
+		 */
+		state = timer->state & HRTIMER_STATE_CALLBACK;
+		__remove_hrtimer(timer, base, state, reprogram);
 		return 1;
 	}
 	return 0;
@@ -1237,6 +1243,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 4d99512..acc9cbb 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -346,7 +346,8 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
+						triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 918c618..416269e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1097,7 +1097,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 6f50ecc..24f2757 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -160,7 +160,7 @@ static int irq_spurious_proc_show(struct seq_file *m, void *v)
 
 static int irq_spurious_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, irq_spurious_proc_show, NULL);
+	return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
 }
 
 static const struct file_operations irq_spurious_proc_fops = {
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index ca07c5c..e99e7cd 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -195,14 +195,7 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 
 	account_global_scheduler_latency(tsk, &lat);
 
-	/*
-	 * short term hack; if we're > 32 we stop; future we recycle:
-	 */
-	tsk->latency_record_count++;
-	if (tsk->latency_record_count >= LT_SAVECOUNT)
-		goto out_unlock;
-
-	for (i = 0; i < LT_SAVECOUNT; i++) {
+	for (i = 0; i < tsk->latency_record_count; i++) {
 		struct latency_record *mylat;
 		int same = 1;
 
@@ -228,8 +221,14 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 		}
 	}
 
+	/*
+	 * short term hack; if we're > 32 we stop; future we recycle:
+	 */
+	if (tsk->latency_record_count >= LT_SAVECOUNT)
+		goto out_unlock;
+
 	/* Allocated a new one: */
-	i = tsk->latency_record_count;
+	i = tsk->latency_record_count++;
 	memcpy(&tsk->latency_record[i], &lat, sizeof(struct latency_record));
 
 out_unlock:
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index fc9ed15..a8520b0 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1466,11 +1466,8 @@ static int
 swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 		unsigned int nr_pages, unsigned int nr_highmem)
 {
-	int error = 0;
-
 	if (nr_highmem > 0) {
-		error = get_highmem_buffer(PG_ANY);
-		if (error)
+		if (get_highmem_buffer(PG_ANY))
 			goto err_out;
 		if (nr_highmem > alloc_highmem) {
 			nr_highmem -= alloc_highmem;
@@ -1493,7 +1490,7 @@ swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 
  err_out:
 	swsusp_free();
-	return error;
+	return -ENOMEM;
 }
 
 asmlinkage int swsusp_save(void)
diff --git a/kernel/power/user.c b/kernel/power/user.c
index bf0014d..b135356 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -137,7 +137,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	free_all_swap_pages(data->swap);
 	if (data->frozen)
 		thaw_processes();
-	pm_notifier_call_chain(data->mode == O_WRONLY ?
+	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 1751c45..fd86add 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1016,6 +1016,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
+	if (unlikely(cpu_is_offline(cpu)))
+		printk_tick();
 	return per_cpu(printk_pending, cpu);
 }
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..05625f6 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -314,7 +314,7 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 		if (!child->exit_state)
-			wake_up_process(child);
+			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 12b9e73..bee1242 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -740,7 +740,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int i;
 
@@ -751,6 +751,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
@@ -758,9 +759,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	}
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		int len = strlen(sched_feat_names[i]);
-
-		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
+		if (strcmp(cmp, sched_feat_names[i]) == 0) {
 			if (neg)
 				sysctl_sched_features &= ~(1UL << i);
 			else
@@ -5262,9 +5261,9 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * utime);
+		temp *= utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
@@ -5295,9 +5294,9 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * cputime.utime);
+		temp *= cputime.utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
@@ -7082,7 +7081,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 * The idle tasks have their own, simple scheduling class:
 	 */
 	idle->sched_class = &idle_sched_class;
-	ftrace_graph_init_task(idle);
+	ftrace_graph_init_idle_task(idle, cpu);
 }
 
 /*
diff --git a/kernel/signal.c b/kernel/signal.c
index 6ca731b..f156b48 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -159,6 +159,10 @@ void recalc_sigpending(void)
 
 /* Given the mask, find the first available signal that should be serviced. */
 
+#define SYNCHRONOUS_MASK \
+	(sigmask(SIGSEGV) | sigmask(SIGBUS) | sigmask(SIGILL) | \
+	 sigmask(SIGTRAP) | sigmask(SIGFPE))
+
 int next_signal(struct sigpending *pending, sigset_t *mask)
 {
 	unsigned long i, *s, *m, x;
@@ -166,26 +170,39 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 
 	s = pending->signal.sig;
 	m = mask->sig;
+
+	/*
+	 * Handle the first word specially: it contains the
+	 * synchronous signals that need to be dequeued first.
+	 */
+	x = *s &~ *m;
+	if (x) {
+		if (x & SYNCHRONOUS_MASK)
+			x &= SYNCHRONOUS_MASK;
+		sig = ffz(~x) + 1;
+		return sig;
+	}
+
 	switch (_NSIG_WORDS) {
 	default:
-		for (i = 0; i < _NSIG_WORDS; ++i, ++s, ++m)
-			if ((x = *s &~ *m) != 0) {
-				sig = ffz(~x) + i*_NSIG_BPW + 1;
-				break;
-			}
+		for (i = 1; i < _NSIG_WORDS; ++i) {
+			x = *++s &~ *++m;
+			if (!x)
+				continue;
+			sig = ffz(~x) + i*_NSIG_BPW + 1;
+			break;
+		}
 		break;
 
-	case 2: if ((x = s[0] &~ m[0]) != 0)
-			sig = 1;
-		else if ((x = s[1] &~ m[1]) != 0)
-			sig = _NSIG_BPW + 1;
-		else
+	case 2:
+		x = s[1] &~ m[1];
+		if (!x)
 			break;
-		sig += ffz(~x);
+		sig = ffz(~x) + _NSIG_BPW + 1;
 		break;
 
-	case 1: if ((x = *s &~ *m) != 0)
-			sig = ffz(~x) + 1;
+	case 1:
+		/* Nothing to do */
 		break;
 	}
 
diff --git a/kernel/smp.c b/kernel/smp.c
index f104084..b1490b9 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -193,6 +193,24 @@ void generic_smp_call_function_interrupt(void)
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
+		/*
+		 * Since we walk the list without any locks, we might
+		 * see an entry that was completed, removed from the
+		 * list and is in the process of being reused.
+		 *
+		 * We must check that the cpu is in the cpumask before
+		 * checking the refs, and both must be set before
+		 * executing the callback on this cpu.
+		 */
+
+		if (!cpumask_test_cpu(cpu, data->cpumask))
+			continue;
+
+		smp_rmb();
+
+		if (atomic_read(&data->refs) == 0)
+			continue;
+
 		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
 			continue;
 
@@ -201,6 +219,8 @@ void generic_smp_call_function_interrupt(void)
 		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
 		if (!refs) {
+			WARN_ON(!cpumask_empty(data->cpumask));
+
 			raw_spin_lock(&call_function.lock);
 			list_del_rcu(&data->csd.list);
 			raw_spin_unlock(&call_function.lock);
@@ -442,11 +462,41 @@ void smp_call_function_many(const struct cpumask *mask,
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
 
+	/* This BUG_ON verifies our reuse assertions and can be removed */
+	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
+
+	/*
+	 * The global call function queue list add and delete are protected
+	 * by a lock, but the list is traversed without any lock, relying
+	 * on the rcu list add and delete to allow safe concurrent traversal.
+	 * We reuse the call function data without waiting for any grace
+	 * period after some other cpu removes it from the global queue.
+	 * This means a cpu might find our data block as it is being
+	 * filled out.
+	 *
+	 * We hold off the interrupt handler on the other cpu by
+	 * ordering our writes to the cpu mask vs our setting of the
+	 * refs counter.  We assert only the cpu owning the data block
+	 * will set a bit in cpumask, and each bit will only be cleared
+	 * by the subject cpu.  Each cpu must first find its bit is
+	 * set and then check that refs is set indicating the element is
+	 * ready to be processed, otherwise it must skip the entry.
+	 *
+	 * On the previous iteration refs was set to 0 by another cpu.
+	 * To avoid the use of transitivity, set the counter to 0 here
+	 * so the wmb will pair with the rmb in the interrupt handler.
+	 */
+	atomic_set(&data->refs, 0);	/* convert 3rd to 1st party write */
+
 	data->csd.func = func;
 	data->csd.info = info;
+
+	/* Ensure 0 refs is visible before mask.  Also orders func and info */
+	smp_wmb();
+
+	/* We rely on the "and" being processed before the store */
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
@@ -455,6 +505,12 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * will not miss any other list entries:
 	 */
 	list_add_rcu(&data->csd.list, &call_function.queue);
+	/*
+	 * We rely on the wmb() in list_add_rcu to complete our writes
+	 * to the cpumask before this write to refs, which indicates
+	 * data is on the list and is ready to be processed.
+	 */
+	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
diff --git a/kernel/sys.c b/kernel/sys.c
index 18bde97..3868b7b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -966,6 +966,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 		pgid = pid;
 	if (pgid < 0)
 		return -EINVAL;
+	rcu_read_lock();
 
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
@@ -1019,6 +1020,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	return err;
 }
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index b3bafd5..2030f62 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -600,4 +600,14 @@ int tick_broadcast_oneshot_active(void)
 	return tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT;
 }
 
+/*
+ * Check whether the broadcast device supports oneshot.
+ */
+bool tick_broadcast_oneshot_available(void)
+{
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+
+	return bc ? bc->features & CLOCK_EVT_FEAT_ONESHOT : false;
+}
+
 #endif
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b6b898d..61e296b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -51,7 +51,11 @@ int tick_is_oneshot_available(void)
 {
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 
-	return dev && (dev->features & CLOCK_EVT_FEAT_ONESHOT);
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return 0;
+	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		return 1;
+	return tick_broadcast_oneshot_available();
 }
 
 /*
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 290eefb..f65d3a7 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -36,6 +36,7 @@ extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast(int cpu);
+bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -46,6 +47,7 @@ static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -76,6 +78,7 @@ static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 	return 0;
 }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
+static inline bool tick_broadcast_oneshot_available(void) { return false; }
 #endif /* !TICK_ONESHOT */
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..a181620 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1171,6 +1171,12 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 	unsigned long expires;
 
+	/*
+	 * Pretend that there is no timer pending if the cpu is offline.
+	 * Possible pending timers will be migrated later to an active cpu.
+	 */
+	if (cpu_is_offline(smp_processor_id()))
+		return now + NEXT_TIMER_MAX_DELTA;
 	spin_lock(&base->lock);
 	if (time_before_eq(base->next_timer, base->timer_jiffies))
 		base->next_timer = __next_timer_interrupt(base);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 404c9ba..ae311ce 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3269,7 +3269,7 @@ static int start_graph_tracing(void)
 	/* The cpu_boot init_task->ret_stack will never be freed */
 	for_each_online_cpu(cpu) {
 		if (!idle_task(cpu)->ret_stack)
-			ftrace_graph_init_task(idle_task(cpu));
+			ftrace_graph_init_idle_task(idle_task(cpu), cpu);
 	}
 
 	do {
@@ -3359,6 +3359,49 @@ void unregister_ftrace_graph(void)
 	mutex_unlock(&ftrace_lock);
 }
 
+static DEFINE_PER_CPU(struct ftrace_ret_stack *, idle_ret_stack);
+
+static void
+graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
+{
+	atomic_set(&t->tracing_graph_pause, 0);
+	atomic_set(&t->trace_overrun, 0);
+	t->ftrace_timestamp = 0;
+	/* make curr_ret_stack visable before we add the ret_stack */
+	smp_wmb();
+	t->ret_stack = ret_stack;
+}
+
+/*
+ * Allocate a return stack for the idle task. May be the first
+ * time through, or it may be done by CPU hotplug online.
+ */
+void ftrace_graph_init_idle_task(struct task_struct *t, int cpu)
+{
+	t->curr_ret_stack = -1;
+	/*
+	 * The idle task has no parent, it either has its own
+	 * stack or no stack at all.
+	 */
+	if (t->ret_stack)
+		WARN_ON(t->ret_stack != per_cpu(idle_ret_stack, cpu));
+
+	if (ftrace_graph_active) {
+		struct ftrace_ret_stack *ret_stack;
+
+		ret_stack = per_cpu(idle_ret_stack, cpu);
+		if (!ret_stack) {
+			ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
+					    * sizeof(struct ftrace_ret_stack),
+					    GFP_KERNEL);
+			if (!ret_stack)
+				return;
+			per_cpu(idle_ret_stack, cpu) = ret_stack;
+		}
+		graph_init_task(t, ret_stack);
+	}
+}
+
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
@@ -3374,12 +3417,7 @@ void ftrace_graph_init_task(struct task_struct *t)
 				GFP_KERNEL);
 		if (!ret_stack)
 			return;
-		atomic_set(&t->tracing_graph_pause, 0);
-		atomic_set(&t->trace_overrun, 0);
-		t->ftrace_timestamp = 0;
-		/* make curr_ret_stack visable before we add the ret_stack */
-		smp_wmb();
-		t->ret_stack = ret_stack;
+		graph_init_task(t, ret_stack);
 	}
 }
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 54191d6..6d28666 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -389,7 +389,7 @@ static inline int test_time_stamp(u64 delta)
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
 /* Max number of timestamps that can fit on a page */
-#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_EXTEND)
 
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d12c17..8a58f51 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2321,11 +2321,19 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
 	return count;
 }
 
+static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+{
+	if (file->f_mode & FMODE_READ)
+		return seq_lseek(file, offset, origin);
+	else
+		return 0;
+}
+
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
 	.write		= tracing_write_stub,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_seek,
 	.release	= tracing_release,
 };
 
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index aeaa6d7..9d94212 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -76,6 +76,7 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
+	INIT_LIST_HEAD(&fbc->list);
 	mutex_lock(&percpu_counters_lock);
 	list_add(&fbc->list, &percpu_counters);
 	mutex_unlock(&percpu_counters_lock);
diff --git a/mm/filemap.c b/mm/filemap.c
index 96398d3..53cbace 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1009,6 +1009,9 @@ find_page:
 				goto page_not_up_to_date;
 			if (!trylock_page(page))
 				goto page_not_up_to_date;
+			/* Did it get truncated before we got the lock? */
+			if (!page->mapping)
+				goto page_not_up_to_date_locked;
 			if (!mapping->a_ops->is_partially_uptodate(page,
 								desc, offset))
 				goto page_not_up_to_date_locked;
diff --git a/mm/internal.h b/mm/internal.h
index 6a697bb..dedb0af 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,7 +62,7 @@ extern bool is_free_buddy_page(struct page *page);
  */
 static inline unsigned long page_order(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 09e4b1b..e298c6f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2645,6 +2645,26 @@ out_release:
 }
 
 /*
+ * This is like a special single-page "expand_downwards()",
+ * except we must first make sure that 'address-PAGE_SIZE'
+ * doesn't hit another vma.
+ *
+ * The "find_vma()" will do the right thing even if we wrap
+ */
+static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
+{
+	address &= PAGE_MASK;
+	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
+		address -= PAGE_SIZE;
+		if (find_vma(vma->vm_mm, address) != vma)
+			return -ENOMEM;
+
+		expand_stack(vma, address);
+	}
+	return 0;
+}
+
+/*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
@@ -2657,19 +2677,23 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pte_t entry;
 
+	pte_unmap(page_table);
+
+	/* Check if we need to add a guard page to the stack */
+	if (check_stack_guard_page(vma, address) < 0)
+		return VM_FAULT_SIGBUS;
+
+	/* Use the zero-page for reads */
 	if (!(flags & FAULT_FLAG_WRITE)) {
 		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
 						vma->vm_page_prot));
-		ptl = pte_lockptr(mm, pmd);
-		spin_lock(ptl);
+		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto unlock;
 		goto setpte;
 	}
 
 	/* Allocate our own private page. */
-	pte_unmap(page_table);
-
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 030ce8a..336b01f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -629,7 +629,7 @@ static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
  * Scanning pfn is much easier than scanning lru list.
  * Scan pfn from start to end and Find LRU page.
  */
-int scan_lru_pages(unsigned long start, unsigned long end)
+unsigned long scan_lru_pages(unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 	struct page *page;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0beac93..223aa0a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1480,7 +1480,7 @@ unsigned slab_node(struct mempolicy *policy)
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone->node;
+		return zone ? zone->node : numa_node_id();
 	}
 
 	default:
diff --git a/mm/mlock.c b/mm/mlock.c
index 2b8335a..13da2d5 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -167,6 +167,14 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	/* We don't try to access the guard page of a stack vma */
+	if (vma->vm_flags & VM_GROWSDOWN) {
+		if (start == vma->vm_start) {
+			start += PAGE_SIZE;
+			nr_pages--;
+		}
+	}
+
 	while (nr_pages > 0) {
 		int i;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index ee22989..892b7d3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2348,6 +2348,7 @@ int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
+	int ret;
 	struct vm_area_struct *vma;
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
@@ -2364,16 +2365,23 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
-	if (unlikely(insert_vm_struct(mm, vma))) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -ENOMEM;
-	}
+	ret = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (ret)
+		goto out;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret)
+		goto out;
 
 	mm->total_vm += len >> PAGE_SHIFT;
 
 	perf_event_mmap(vma);
 
 	return 0;
+
+out:
+	kmem_cache_free(vm_area_cachep, vma);
+	return ret;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
diff --git a/mm/mmzone.c b/mm/mmzone.c
index f5b7d17..e35bfb8 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -87,3 +87,24 @@ int memmap_valid_within(unsigned long pfn,
 	return 1;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
+
+#ifdef CONFIG_SMP
+/* Called when a more accurate view of NR_FREE_PAGES is needed */
+unsigned long zone_nr_free_pages(struct zone *zone)
+{
+	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
+
+	/*
+	 * While kswapd is awake, it is considered the zone is under some
+	 * memory pressure. Under pressure, there is a risk that
+	 * per-cpu-counter-drift will allow the min watermark to be breached
+	 * potentially causing a live-lock. While kswapd is awake and
+	 * free pages are low, get a better estimate for free pages
+	 */
+	if (nr_free_pages < zone->percpu_drift_mark &&
+			!waitqueue_active(&zone->zone_pgdat->kswapd_wait))
+		return zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
+	return nr_free_pages;
+}
+#endif /* CONFIG_SMP */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 8bc969d..1737c7e 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -212,6 +212,7 @@ success:
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
+	perf_event_mmap(vma);
 	return 0;
 
 fail:
@@ -300,7 +301,6 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
-		perf_event_mmap(vma);
 		nstart = tmp;
 
 		if (nstart < prev->vm_end)
diff --git a/mm/mremap.c b/mm/mremap.c
index 8451908..166b824 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -92,9 +92,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		 */
 		mapping = vma->vm_file->f_mapping;
 		spin_lock(&mapping->i_mmap_lock);
-		if (new_vma->vm_truncate_count &&
-		    new_vma->vm_truncate_count != vma->vm_truncate_count)
-			new_vma->vm_truncate_count = 0;
+		new_vma->vm_truncate_count = 0;
 	}
 
 	/*
diff --git a/mm/nommu.c b/mm/nommu.c
index 48a2ecf..f55217e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1643,6 +1643,7 @@ void exit_mmap(struct mm_struct *mm)
 		mm->mmap = vma->vm_next;
 		delete_vma_from_mm(vma);
 		delete_vma(mm, vma);
+		cond_resched();
 	}
 
 	kleave("");
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8deb9d0..d42b021 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -528,13 +528,13 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 {
 	int migratetype = 0;
 	int batch_free = 0;
+	int to_free = count;
 
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
-	while (count) {
+	while (to_free) {
 		struct page *page;
 		struct list_head *list;
 
@@ -559,8 +559,9 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, page_private(page));
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
-		} while (--count && --batch_free && !list_empty(list));
+		} while (--to_free && --batch_free && !list_empty(list));
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
@@ -571,8 +572,8 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	spin_unlock(&zone->lock);
 }
 
@@ -1362,7 +1363,7 @@ int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
-	long free_pages = zone_page_state(z, NR_FREE_PAGES) - (1 << order) + 1;
+	long free_pages = zone_nr_free_pages(z) - (1 << order) + 1;
 	int o;
 
 	if (alloc_flags & ALLOC_HIGH)
@@ -1688,6 +1689,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
 	struct task_struct *p = current;
+	bool drained = false;
 
 	cond_resched();
 
@@ -1706,14 +1708,25 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	cond_resched();
 
-	if (order != 0)
-		drain_all_pages();
+	if (unlikely(!(*did_some_progress)))
+		return NULL;
 
-	if (likely(*did_some_progress))
-		page = get_page_from_freelist(gfp_mask, nodemask, order,
+retry:
+	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
 					migratetype);
+
+	/*
+	 * If an allocation failed after direct reclaim, it could be because
+	 * pages are pinned on the per-cpu lists. Drain them and try again
+	 */
+	if (!page && !drained) {
+		drain_all_pages();
+		drained = true;
+		goto retry;
+	}
+
 	return page;
 }
 
@@ -2245,7 +2258,7 @@ void show_free_areas(void)
 			" all_unreclaimable? %s"
 			"\n",
 			zone->name,
-			K(zone_page_state(zone, NR_FREE_PAGES)),
+			K(zone_nr_free_pages(zone)),
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
diff --git a/mm/percpu.c b/mm/percpu.c
index 083e7c9..9aea73c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1724,9 +1724,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 			if (pcpu_first_unit_cpu == NR_CPUS)
 				pcpu_first_unit_cpu = cpu;
+			pcpu_last_unit_cpu = cpu;
 		}
 	}
-	pcpu_last_unit_cpu = cpu;
 	pcpu_nr_units = unit;
 
 	for_each_possible_cpu(cpu)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c0585b..e64e032 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -315,8 +315,10 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
-	/* reuse swap entry of cache-only swap if not busy. */
-	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+	/* reuse swap entry of cache-only swap if not hibernation. */
+	if (vm_swap_full()
+		&& usage == SWAP_HAS_CACHE
+		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..20a402c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -513,6 +513,15 @@ static atomic_t vmap_lazy_nr = ATOMIC_INIT(0);
 static void purge_fragmented_blocks_allcpus(void);
 
 /*
+ * called before a call to iounmap() if the caller wants vm_area_struct's
+ * immediately freed.
+ */
+void set_iounmap_nonlazy(void)
+{
+	atomic_set(&vmap_lazy_nr, lazy_max_pages()+1);
+}
+
+/*
  * Purges all lazily-freed vmap areas.
  *
  * If sync is 0 then don't purge if there is already a purge in progress.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c26986c..210c46a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1082,6 +1082,48 @@ static int too_many_isolated(struct zone *zone, int file,
 }
 
 /*
+ * Returns true if the caller should wait to clean dirty/writeback pages.
+ *
+ * If we are direct reclaiming for contiguous pages and we do not reclaim
+ * everything in the list, try again and wait for writeback IO to complete.
+ * This will stall high-order allocations noticeably. Only do that when really
+ * need to free the pages under high memory pressure.
+ */
+static inline bool should_reclaim_stall(unsigned long nr_taken,
+					unsigned long nr_freed,
+					int priority,
+					int lumpy_reclaim,
+					struct scan_control *sc)
+{
+	int lumpy_stall_priority;
+
+	/* kswapd should not stall on sync IO */
+	if (current_is_kswapd())
+		return false;
+
+	/* Only stall on lumpy reclaim */
+	if (!lumpy_reclaim)
+		return false;
+
+	/* If we have relaimed everything on the isolated list, no stall */
+	if (nr_freed == nr_taken)
+		return false;
+
+	/*
+	 * For high-order allocations, there are two stall thresholds.
+	 * High-cost allocations stall immediately where as lower
+	 * order allocations such as stacks require the scanning
+	 * priority to be much higher before stalling.
+	 */
+	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+		lumpy_stall_priority = DEF_PRIORITY;
+	else
+		lumpy_stall_priority = DEF_PRIORITY / 3;
+
+	return priority <= lumpy_stall_priority;
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
@@ -1173,14 +1215,9 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
 		nr_scanned += nr_scan;
 		nr_freed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
 
-		/*
-		 * If we are direct reclaiming for contiguous pages and we do
-		 * not reclaim everything in the list, try again and wait
-		 * for IO to complete. This will stall high-order allocations
-		 * but that should be acceptable to the caller
-		 */
-		if (nr_freed < nr_taken && !current_is_kswapd() &&
-		    lumpy_reclaim) {
+		/* Check if we should syncronously wait for writeback */
+		if (should_reclaim_stall(nr_taken, nr_freed, priority,
+					lumpy_reclaim, sc)) {
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 			/*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6051fba..71ea709 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -136,10 +136,23 @@ static void refresh_zone_stat_thresholds(void)
 	int threshold;
 
 	for_each_populated_zone(zone) {
+		unsigned long max_drift, tolerate_drift;
+
 		threshold = calculate_threshold(zone);
 
 		for_each_online_cpu(cpu)
 			zone_pcp(zone, cpu)->stat_threshold = threshold;
+
+		/*
+		 * Only set percpu_drift_mark if there is a danger that
+		 * NR_FREE_PAGES reports the low watermark is ok when in fact
+		 * the min watermark could be breached by an allocation
+		 */
+		tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
+		max_drift = num_online_cpus() * threshold;
+		if (max_drift > tolerate_drift)
+			zone->percpu_drift_mark = high_wmark_pages(zone) +
+					max_drift;
 	}
 }
 
@@ -718,7 +731,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n        scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
-		   zone_page_state(zone, NR_FREE_PAGES),
+		   zone_nr_free_pages(zone),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
diff --git a/net/can/bcm.c b/net/can/bcm.c
index e32af52..03154d9 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -117,7 +117,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [9]; /* pointer printed in ASCII with \0 */
+	char procname [20]; /* pointer printed in ASCII with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
diff --git a/net/compat.c b/net/compat.c
index a1fb1b0..7346219 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -40,10 +40,12 @@ static inline int iov_from_user_compat_to_kern(struct iovec *kiov,
 		compat_size_t len;
 
 		if (get_user(len, &uiov32->iov_len) ||
-		   get_user(buf, &uiov32->iov_base)) {
-			tot_len = -EFAULT;
-			break;
-		}
+		    get_user(buf, &uiov32->iov_base))
+			return -EFAULT;
+
+		if (len > INT_MAX - tot_len)
+			len = INT_MAX - tot_len;
+
 		tot_len += len;
 		kiov->iov_base = compat_ptr(buf);
 		kiov->iov_len = (__kernel_size_t) len;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7eb7c1d..29f936d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1103,13 +1103,21 @@ EXPORT_SYMBOL(netdev_bonding_change);
 void dev_load(struct net *net, const char *name)
 {
 	struct net_device *dev;
+	int no_module;
 
 	rcu_read_lock();
 	dev = dev_get_by_name_rcu(net, name);
 	rcu_read_unlock();
 
-	if (!dev && capable(CAP_NET_ADMIN))
-		request_module("%s", name);
+	no_module = !dev;
+	if (no_module && capable(CAP_NET_ADMIN))
+		no_module = request_module("netdev-%s", name);
+	if (no_module && capable(CAP_SYS_MODULE)) {
+		if (!request_module("%s", name))
+			pr_err("Loading kernel module for a network device "
+"with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-%s "
+"instead\n", name);
+	}
 }
 EXPORT_SYMBOL(dev_load);
 
@@ -1590,10 +1598,10 @@ EXPORT_SYMBOL(netif_device_attach);
 
 static bool can_checksum_protocol(unsigned long features, __be16 protocol)
 {
-	return ((features & NETIF_F_GEN_CSUM) ||
-		((features & NETIF_F_IP_CSUM) &&
+	return ((features & NETIF_F_NO_CSUM) ||
+		((features & NETIF_F_V4_CSUM) &&
 		 protocol == htons(ETH_P_IP)) ||
-		((features & NETIF_F_IPV6_CSUM) &&
+		((features & NETIF_F_V6_CSUM) &&
 		 protocol == htons(ETH_P_IPV6)) ||
 		((features & NETIF_F_FCOE_CRC) &&
 		 protocol == htons(ETH_P_FCOE)));
@@ -4846,6 +4854,7 @@ static void rollback_registered(struct net_device *dev)
 
 	list_add(&dev->unreg_list, &single);
 	rollback_registered_many(&single);
+	list_del(&single);
 }
 
 static void __netdev_init_queue_locks_one(struct net_device *dev,
@@ -5828,6 +5837,7 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 		}
 	}
 	unregister_netdevice_many(&dev_kill_list);
+	list_del(&dev_kill_list);
 	rtnl_unlock();
 }
 
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index ed2fb75..fe41a5f 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -258,7 +258,7 @@ static int ethtool_get_rxnfc(struct net_device *dev,
 	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
 		if (info.rule_cnt > 0) {
 			if (info.rule_cnt <= KMALLOC_MAX_SIZE / sizeof(u32))
-				rule_buf = kmalloc(info.rule_cnt * sizeof(u32),
+				rule_buf = kzalloc(info.rule_cnt * sizeof(u32),
 						   GFP_USER);
 			if (!rule_buf)
 				return -ENOMEM;
@@ -304,7 +304,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = kmalloc(reglen, GFP_USER);
+	regbuf = kzalloc(reglen, GFP_USER);
 	if (!regbuf)
 		return -ENOMEM;
 
diff --git a/net/core/iovec.c b/net/core/iovec.c
index 16ad45d..f911e66 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -38,7 +38,7 @@
 
 int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode)
 {
-	int size, err, ct;
+	int size, ct, err;
 
 	if (m->msg_namelen) {
 		if (mode == VERIFY_READ) {
@@ -60,14 +60,13 @@ int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address,
 	err = 0;
 
 	for (ct = 0; ct < m->msg_iovlen; ct++) {
-		err += iov[ct].iov_len;
-		/*
-		 * Goal is not to verify user data, but to prevent returning
-		 * negative value, which is interpreted as errno.
-		 * Overflow is still possible, but it is harmless.
-		 */
-		if (err < 0)
-			return -EMSGSIZE;
+		size_t len = iov[ct].iov_len;
+
+		if (len > INT_MAX - err) {
+			len = INT_MAX - err;
+			iov[ct].iov_len = len;
+		}
+		err += len;
 	}
 
 	return err;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 794bcb8..9c4878d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1162,6 +1162,9 @@ replay:
 			snprintf(ifname, IFNAMSIZ, "%s%%d", ops->kind);
 
 		dest_net = rtnl_link_get_net(net, tb);
+		if (IS_ERR(dest_net))
+			return PTR_ERR(dest_net);
+
 		dev = rtnl_create_link(net, dest_net, ifname, ops, tb);
 
 		if (IS_ERR(dev))
diff --git a/net/core/stream.c b/net/core/stream.c
index a37debf..e48c85f 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -140,10 +140,10 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
-		sk_wait_event(sk, &current_timeo, !sk->sk_err &&
-						  !(sk->sk_shutdown & SEND_SHUTDOWN) &&
-						  sk_stream_memory_free(sk) &&
-						  vm_wait);
+		sk_wait_event(sk, &current_timeo, sk->sk_err ||
+						  (sk->sk_shutdown & SEND_SHUTDOWN) ||
+						  (sk_stream_memory_free(sk) &&
+						  !vm_wait));
 		sk->sk_write_pending--;
 
 		if (vm_wait) {
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 071b64e..875decb 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -616,6 +616,9 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Caller (dccp_v4_do_rcv) will send Reset */
 		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
 		return 1;
+	} else if (sk->sk_state == DCCP_CLOSED) {
+		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
+		return 1;
 	}
 
 	if (sk->sk_state != DCCP_REQUESTING && sk->sk_state != DCCP_RESPOND) {
@@ -678,10 +681,6 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	}
 
 	switch (sk->sk_state) {
-	case DCCP_CLOSED:
-		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
-		return 1;
-
 	case DCCP_REQUESTING:
 		queued = dccp_rcv_request_sent_state_process(sk, skb, dh, len);
 		if (queued >= 0)
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 2b494fa..7cc13e1 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1556,6 +1556,8 @@ static int __dn_getsockopt(struct socket *sock, int level,int optname, char __us
 			if (r_len > sizeof(struct linkinfo_dn))
 				r_len = sizeof(struct linkinfo_dn);
 
+			memset(&link, 0, sizeof(link));
+
 			switch(sock->state) {
 				case SS_CONNECTING:
 					link.idn_linkstate = LL_CONNECTING;
diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 29b4931..d23ee8a 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -30,6 +30,7 @@
 #include <linux/wireless.h>
 #include <linux/skbuff.h>
 #include <linux/udp.h>
+#include <linux/vmalloc.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <linux/stat.h>
@@ -275,12 +276,12 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 #endif
 #ifdef CONFIG_ECONET_AUNUDP
 	struct msghdr udpmsg;
-	struct iovec iov[msg->msg_iovlen+1];
+	struct iovec iov[2];
 	struct aunhdr ah;
 	struct sockaddr_in udpdest;
 	__kernel_size_t size;
-	int i;
 	mm_segment_t oldfs;
+	char *userbuf;
 #endif
 
 	/*
@@ -296,23 +297,14 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 	mutex_lock(&econet_mutex);
 
-	if (saddr == NULL) {
-		struct econet_sock *eo = ec_sk(sk);
-
-		addr.station = eo->station;
-		addr.net     = eo->net;
-		port	     = eo->port;
-		cb	     = eo->cb;
-	} else {
-		if (msg->msg_namelen < sizeof(struct sockaddr_ec)) {
-			mutex_unlock(&econet_mutex);
-			return -EINVAL;
-		}
-		addr.station = saddr->addr.station;
-		addr.net = saddr->addr.net;
-		port = saddr->port;
-		cb = saddr->cb;
-	}
+        if (saddr == NULL || msg->msg_namelen < sizeof(struct sockaddr_ec)) {
+                mutex_unlock(&econet_mutex);
+                return -EINVAL;
+        }
+        addr.station = saddr->addr.station;
+        addr.net = saddr->addr.net;
+        port = saddr->port;
+        cb = saddr->cb;
 
 	/* Look for a device with the right network number. */
 	dev = net2dev_map[addr.net];
@@ -327,17 +319,17 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 		}
 	}
 
-	if (len + 15 > dev->mtu) {
-		mutex_unlock(&econet_mutex);
-		return -EMSGSIZE;
-	}
-
 	if (dev->type == ARPHRD_ECONET) {
 		/* Real hardware Econet.  We're not worthy etc. */
 #ifdef CONFIG_ECONET_NATIVE
 		unsigned short proto = 0;
 		int res;
 
+		if (len + 15 > dev->mtu) {
+			mutex_unlock(&econet_mutex);
+			return -EMSGSIZE;
+		}
+
 		dev_hold(dev);
 
 		skb = sock_alloc_send_skb(sk, len+LL_ALLOCATED_SPACE(dev),
@@ -350,7 +342,6 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 		eb = (struct ec_cb *)&skb->cb;
 
-		/* BUG: saddr may be NULL */
 		eb->cookie = saddr->cookie;
 		eb->sec = *saddr;
 		eb->sent = ec_tx_done;
@@ -414,6 +405,11 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 		return -ENETDOWN;		/* No socket - can't send */
 	}
 
+	if (len > 32768) {
+		err = -E2BIG;
+		goto error;
+	}
+
 	/* Make up a UDP datagram and hand it off to some higher intellect. */
 
 	memset(&udpdest, 0, sizeof(udpdest));
@@ -445,36 +441,26 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 	/* tack our header on the front of the iovec */
 	size = sizeof(struct aunhdr);
-	/*
-	 * XXX: that is b0rken.  We can't mix userland and kernel pointers
-	 * in iovec, since on a lot of platforms copy_from_user() will
-	 * *not* work with the kernel and userland ones at the same time,
-	 * regardless of what we do with set_fs().  And we are talking about
-	 * econet-over-ethernet here, so "it's only ARM anyway" doesn't
-	 * apply.  Any suggestions on fixing that code?		-- AV
-	 */
 	iov[0].iov_base = (void *)&ah;
 	iov[0].iov_len = size;
-	for (i = 0; i < msg->msg_iovlen; i++) {
-		void __user *base = msg->msg_iov[i].iov_base;
-		size_t iov_len = msg->msg_iov[i].iov_len;
-		/* Check it now since we switch to KERNEL_DS later. */
-		if (!access_ok(VERIFY_READ, base, iov_len)) {
-			mutex_unlock(&econet_mutex);
-			return -EFAULT;
-		}
-		iov[i+1].iov_base = base;
-		iov[i+1].iov_len = iov_len;
-		size += iov_len;
+
+	userbuf = vmalloc(len);
+	if (userbuf == NULL) {
+		err = -ENOMEM;
+		goto error;
 	}
 
+	iov[1].iov_base = userbuf;
+	iov[1].iov_len = len;
+	err = memcpy_fromiovec(userbuf, msg->msg_iov, len);
+	if (err)
+		goto error_free_buf;
+
 	/* Get a skbuff (no data, just holds our cb information) */
 	if ((skb = sock_alloc_send_skb(sk, 0,
 				       msg->msg_flags & MSG_DONTWAIT,
-				       &err)) == NULL) {
-		mutex_unlock(&econet_mutex);
-		return err;
-	}
+				       &err)) == NULL)
+		goto error_free_buf;
 
 	eb = (struct ec_cb *)&skb->cb;
 
@@ -490,7 +476,7 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 	udpmsg.msg_name = (void *)&udpdest;
 	udpmsg.msg_namelen = sizeof(udpdest);
 	udpmsg.msg_iov = &iov[0];
-	udpmsg.msg_iovlen = msg->msg_iovlen + 1;
+	udpmsg.msg_iovlen = 2;
 	udpmsg.msg_control = NULL;
 	udpmsg.msg_controllen = 0;
 	udpmsg.msg_flags=0;
@@ -498,9 +484,13 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 	oldfs = get_fs(); set_fs(KERNEL_DS);	/* More privs :-) */
 	err = sock_sendmsg(udpsock, &udpmsg, size);
 	set_fs(oldfs);
+
+error_free_buf:
+	vfree(userbuf);
 #else
 	err = -EPROTOTYPE;
 #endif
+	error:
 	mutex_unlock(&econet_mutex);
 
 	return err;
@@ -670,6 +660,9 @@ static int ec_dev_ioctl(struct socket *sock, unsigned int cmd, void __user *arg)
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
 			/* Magic up a new one. */
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index fb24658..31cafd4 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -62,8 +62,11 @@ int ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	}
 	if (!inet->inet_saddr)
 		inet->inet_saddr = rt->rt_src;	/* Update source address */
-	if (!inet->inet_rcv_saddr)
+	if (!inet->inet_rcv_saddr) {
 		inet->inet_rcv_saddr = rt->rt_src;
+		if (sk->sk_prot->rehash)
+			sk->sk_prot->rehash(sk);
+	}
 	inet->inet_daddr = rt->rt_dst;
 	inet->inet_dport = usin->sin_port;
 	sk->sk_state = TCP_ESTABLISHED;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index cc94cc2..3313809 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -504,7 +504,9 @@ restart:
 			}
 
 			rcu_read_unlock();
+			local_bh_disable();
 			inet_twsk_deschedule(tw, twdr);
+			local_bh_enable();
 			inet_twsk_put(tw);
 			goto restart_rcu;
 		}
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 68c1454..aa70db1 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1710,3 +1710,4 @@ module_exit(ipgre_fini);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_RTNL_LINK("gre");
 MODULE_ALIAS_RTNL_LINK("gretap");
+MODULE_ALIAS_NETDEV("gre0");
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3451799..b296721 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -478,9 +478,8 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 	 * we can switch to copy when see the first bad fragment.
 	 */
 	if (skb_has_frags(skb)) {
-		struct sk_buff *frag;
+		struct sk_buff *frag, *frag2;
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -493,18 +492,18 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 			if (frag->len > mtu ||
 			    ((frag->len & 7) && frag->next) ||
 			    skb_headroom(frag) < hlen)
-			    goto slow_path;
+				goto slow_path_clean;
 
 			/* Partially cloned skb? */
 			if (skb_shared(frag))
-				goto slow_path;
+				goto slow_path_clean;
 
 			BUG_ON(frag->sk);
 			if (skb->sk) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
 			}
-			truesizes += frag->truesize;
+			skb->truesize -= frag->truesize;
 		}
 
 		/* Everything is OK. Generate! */
@@ -514,7 +513,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 		frag = skb_shinfo(skb)->frag_list;
 		skb_frag_list_init(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		iph->tot_len = htons(first_len);
 		iph->frag_off = htons(IP_MF);
@@ -566,6 +564,15 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 		}
 		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
 		return err;
+
+slow_path_clean:
+		skb_walk_frags(skb, frag2) {
+			if (frag2 == frag)
+				break;
+			frag2->sk = NULL;
+			frag2->destructor = NULL;
+			skb->truesize += frag2->truesize;
+		}
 	}
 
 slow_path:
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index eda04fe..6e9168f 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -854,3 +854,4 @@ static void __exit ipip_fini(void)
 module_init(ipip_init);
 module_exit(ipip_fini);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETDEV("tunl0");
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index af86e41..a03c754 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2721,6 +2721,11 @@ slow_output:
 
 EXPORT_SYMBOL_GPL(__ip_route_output_key);
 
+static struct dst_entry *ipv4_blackhole_dst_check(struct dst_entry *dst, u32 cookie)
+{
+	return NULL;
+}
+
 static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, u32 mtu)
 {
 }
@@ -2729,7 +2734,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
 	.family			=	AF_INET,
 	.protocol		=	cpu_to_be16(ETH_P_IP),
 	.destroy		=	ipv4_dst_destroy,
-	.check			=	ipv4_dst_check,
+	.check			=	ipv4_blackhole_dst_check,
 	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
 	.entries		=	ATOMIC_INIT(0),
 };
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 03c55ac..29981da 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -387,8 +387,6 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	 */
 
 	mask = 0;
-	if (sk->sk_err)
-		mask = POLLERR;
 
 	/*
 	 * POLLHUP is certainly not done right. But poll() doesn't
@@ -457,6 +455,11 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		if (tp->urg_data & TCP_URG_VALID)
 			mask |= POLLPRI;
 	}
+	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	smp_rmb();
+	if (sk->sk_err)
+		mask |= POLLERR;
+
 	return mask;
 }
 
@@ -935,7 +938,7 @@ int tcp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 		goto out_err;
 
 	while (--iovlen >= 0) {
-		int seglen = iov->iov_len;
+		size_t seglen = iov->iov_len;
 		unsigned char __user *from = iov->iov_base;
 
 		iov++;
@@ -2229,7 +2232,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		/* Values greater than interface MTU won't take effect. However
 		 * at the point when this call is done we typically don't yet
 		 * know which interface is going to be used */
-		if (val < 8 || val > MAX_TCP_WINDOW) {
+		if (val < TCP_MIN_MSS || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b347d3c..2fc6e7b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4027,6 +4027,8 @@ static void tcp_reset(struct sock *sk)
 	default:
 		sk->sk_err = ECONNRESET;
 	}
+	/* This barrier is coupled with smp_rmb() in tcp_poll() */
+	smp_wmb();
 
 	if (!sock_flag(sk, SOCK_DEAD))
 		sk->sk_error_report(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 955f0b2..659f3b2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1256,6 +1256,49 @@ void udp_lib_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL(udp_lib_unhash);
 
+/*
+ * inet_rcv_saddr was changed, we must rehash secondary hash
+ */
+void udp_lib_rehash(struct sock *sk, u16 newhash)
+{
+	if (sk_hashed(sk)) {
+		struct udp_table *udptable = sk->sk_prot->h.udp_table;
+		struct udp_hslot *hslot, *hslot2, *nhslot2;
+
+		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
+		nhslot2 = udp_hashslot2(udptable, newhash);
+		udp_sk(sk)->udp_portaddr_hash = newhash;
+		if (hslot2 != nhslot2) {
+			hslot = udp_hashslot(udptable, sock_net(sk),
+					     udp_sk(sk)->udp_port_hash);
+			/* we must lock primary chain too */
+			spin_lock_bh(&hslot->lock);
+
+			spin_lock(&hslot2->lock);
+			hlist_nulls_del_init_rcu(&udp_sk(sk)->udp_portaddr_node);
+			hslot2->count--;
+			spin_unlock(&hslot2->lock);
+
+			spin_lock(&nhslot2->lock);
+			hlist_nulls_add_head_rcu(&udp_sk(sk)->udp_portaddr_node,
+						 &nhslot2->head);
+			nhslot2->count++;
+			spin_unlock(&nhslot2->lock);
+
+			spin_unlock_bh(&hslot->lock);
+		}
+	}
+}
+EXPORT_SYMBOL(udp_lib_rehash);
+
+static void udp_v4_rehash(struct sock *sk)
+{
+	u16 new_hash = udp4_portaddr_hash(sock_net(sk),
+					  inet_sk(sk)->inet_rcv_saddr,
+					  inet_sk(sk)->inet_num);
+	udp_lib_rehash(sk, new_hash);
+}
+
 static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	int rc = sock_queue_rcv_skb(sk, skb);
@@ -1831,6 +1874,7 @@ struct proto udp_prot = {
 	.backlog_rcv	   = __udp_queue_rcv_skb,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
+	.rehash		   = udp_v4_rehash,
 	.get_port	   = udp_v4_get_port,
 	.memory_allocated  = &udp_memory_allocated,
 	.sysctl_mem	   = sysctl_udp_mem,
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index e4a1483..71dbb43 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -70,7 +70,7 @@ __xfrm4_find_bundle(struct flowi *fl, struct xfrm_policy *policy)
 		if (xdst->u.rt.fl.oif == fl->oif &&	/*XXX*/
 		    xdst->u.rt.fl.fl4_dst == fl->fl4_dst &&
 		    xdst->u.rt.fl.fl4_src == fl->fl4_src &&
-		    xdst->u.rt.fl.fl4_tos == fl->fl4_tos &&
+                    !((xdst->u.rt.fl.fl4_tos ^ fl->fl4_tos) & IPTOS_RT_MASK) &&
 		    xfrm_bundle_ok(policy, xdst, fl, AF_INET, 0)) {
 			dst_clone(dst);
 			break;
@@ -82,7 +82,7 @@ __xfrm4_find_bundle(struct flowi *fl, struct xfrm_policy *policy)
 
 static int xfrm4_get_tos(struct flowi *fl)
 {
-	return fl->fl4_tos;
+	return IPTOS_RT_MASK & fl->fl4_tos; /* Strip ECN bits */
 }
 
 static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index e6f9cdf..385c9fe 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -103,9 +103,12 @@ ipv4_connected:
 		if (ipv6_addr_any(&np->saddr))
 			ipv6_addr_set_v4mapped(inet->inet_saddr, &np->saddr);
 
-		if (ipv6_addr_any(&np->rcv_saddr))
+		if (ipv6_addr_any(&np->rcv_saddr)) {
 			ipv6_addr_set_v4mapped(inet->inet_rcv_saddr,
 					       &np->rcv_saddr);
+			if (sk->sk_prot->rehash)
+				sk->sk_prot->rehash(sk);
+		}
 
 		goto out;
 	}
@@ -190,6 +193,8 @@ ipv4_connected:
 	if (ipv6_addr_any(&np->rcv_saddr)) {
 		ipv6_addr_copy(&np->rcv_saddr, &fl.fl6_src);
 		inet->inet_rcv_saddr = LOOPBACK4_IPV6;
+		if (sk->sk_prot->rehash)
+			sk->sk_prot->rehash(sk);
 	}
 
 	ip6_dst_store(sk, dst,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index eb6d097..b4c050a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -642,7 +642,7 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 
 	if (skb_has_frags(skb)) {
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
+		struct sk_buff *frag2;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -654,18 +654,18 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 			if (frag->len > mtu ||
 			    ((frag->len & 7) && frag->next) ||
 			    skb_headroom(frag) < hlen)
-			    goto slow_path;
+				goto slow_path_clean;
 
 			/* Partially cloned skb? */
 			if (skb_shared(frag))
-				goto slow_path;
+				goto slow_path_clean;
 
 			BUG_ON(frag->sk);
 			if (skb->sk) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
-				truesizes += frag->truesize;
 			}
+			skb->truesize -= frag->truesize;
 		}
 
 		err = 0;
@@ -696,7 +696,6 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 
 		first_len = skb_pagelen(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		ipv6_hdr(skb)->payload_len = htons(first_len -
 						   sizeof(struct ipv6hdr));
@@ -759,6 +758,15 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 			      IPSTATS_MIB_FRAGFAILS);
 		dst_release(&rt->u.dst);
 		return err;
+
+slow_path_clean:
+		skb_walk_frags(skb, frag2) {
+			if (frag2 == frag)
+				break;
+			frag2->sk = NULL;
+			frag2->destructor = NULL;
+			skb->truesize += frag2->truesize;
+		}
 	}
 
 slow_path:
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6232284..a89ff5a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1567,14 +1567,13 @@ out:
  *	i.e. Path MTU discovery
  */
 
-void rt6_pmtu_discovery(struct in6_addr *daddr, struct in6_addr *saddr,
-			struct net_device *dev, u32 pmtu)
+static void rt6_do_pmtu_disc(struct in6_addr *daddr, struct in6_addr *saddr,
+			     struct net *net, u32 pmtu, int ifindex)
 {
 	struct rt6_info *rt, *nrt;
-	struct net *net = dev_net(dev);
 	int allfrag = 0;
 
-	rt = rt6_lookup(net, daddr, saddr, dev->ifindex, 0);
+	rt = rt6_lookup(net, daddr, saddr, ifindex, 0);
 	if (rt == NULL)
 		return;
 
@@ -1642,6 +1641,27 @@ out:
 	dst_release(&rt->u.dst);
 }
 
+void rt6_pmtu_discovery(struct in6_addr *daddr, struct in6_addr *saddr,
+			struct net_device *dev, u32 pmtu)
+{
+	struct net *net = dev_net(dev);
+
+	/*
+	 * RFC 1981 states that a node "MUST reduce the size of the packets it
+	 * is sending along the path" that caused the Packet Too Big message.
+	 * Since it's not possible in the general case to determine which
+	 * interface was used to send the original packet, we update the MTU
+	 * on the interface that will be used to send future packets. We also
+	 * update the MTU on the interface that received the Packet Too Big in
+	 * case the original packet was forced out that interface with
+	 * SO_BINDTODEVICE or similar. This is the next best thing to the
+	 * correct behaviour, which would be to update the MTU on all
+	 * interfaces.
+	 */
+	rt6_do_pmtu_disc(daddr, saddr, net, pmtu, 0);
+	rt6_do_pmtu_disc(daddr, saddr, net, pmtu, dev->ifindex);
+}
+
 /*
  *	Misc support functions
  */
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 976e682..51f030d 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1243,4 +1243,4 @@ static int __init sit_init(void)
 module_init(sit_init);
 module_exit(sit_cleanup);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("sit0");
+MODULE_ALIAS_NETDEV("sit0");
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4f57cd2..e55aa9c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -110,6 +110,15 @@ int udp_v6_get_port(struct sock *sk, unsigned short snum)
 	return udp_lib_get_port(sk, snum, ipv6_rcv_saddr_equal, hash2_nulladdr);
 }
 
+static void udp_v6_rehash(struct sock *sk)
+{
+	u16 new_hash = udp6_portaddr_hash(sock_net(sk),
+					  &inet6_sk(sk)->rcv_saddr,
+					  inet_sk(sk)->inet_num);
+
+	udp_lib_rehash(sk, new_hash);
+}
+
 static inline int compute_score(struct sock *sk, struct net *net,
 				unsigned short hnum,
 				struct in6_addr *saddr, __be16 sport,
@@ -1431,6 +1440,7 @@ struct proto udpv6_prot = {
 	.backlog_rcv	   = udpv6_queue_rcv_skb,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
+	.rehash		   = udp_v6_rehash,
 	.get_port	   = udp_v6_get_port,
 	.memory_allocated  = &udp_memory_allocated,
 	.sysctl_mem	   = sysctl_udp_mem,
diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index 294e34d..f7d6150 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -501,7 +501,8 @@ static void iriap_getvaluebyclass_confirm(struct iriap_cb *self,
 		IRDA_DEBUG(4, "%s(), strlen=%d\n", __func__, value_len);
 
 		/* Make sure the string is null-terminated */
-		fp[n+value_len] = 0x00;
+		if (n + value_len < skb->len)
+			fp[n + value_len] = 0x00;
 		IRDA_DEBUG(4, "Got string %s\n", fp+n);
 
 		/* Will truncate to IAS_MAX_STRING bytes */
diff --git a/net/irda/parameters.c b/net/irda/parameters.c
index fc1a205..71cd38c 100644
--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -298,6 +298,8 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 
 	p.pi = pi;     /* In case handler needs to know */
 	p.pl = buf[1]; /* Extract length of value */
+	if (p.pl > 32)
+		p.pl = 32;
 
 	IRDA_DEBUG(2, "%s(), pi=%#x, pl=%d\n", __func__,
 		   p.pi, p.pl);
@@ -318,7 +320,7 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 		   (__u8) str[0], (__u8) str[1]);
 
 	/* Null terminate string */
-	str[p.pl+1] = '\0';
+	str[p.pl] = '\0';
 
 	p.pv.c = str; /* Handler will need to take a copy */
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 701e63a..d162599 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2123,9 +2123,6 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	struct net_device *prev_dev = NULL;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	if (status->flag & RX_FLAG_INTERNAL_CMTR)
-		goto out_free_skb;
-
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
 	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
 		goto out_free_skb;
@@ -2184,7 +2181,6 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	} else
 		goto out_free_skb;
 
-	status->flag |= RX_FLAG_INTERNAL_CMTR;
 	return;
 
  out_free_skb:
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4d79e3c..65bcd7e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1178,7 +1178,8 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced, int nulls)
 	if (!hash) {
 		*vmalloced = 1;
 		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
-		hash = __vmalloc(sz, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+		hash = __vmalloc(sz, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+				 PAGE_KERNEL);
 	}
 
 	if (hash && nulls)
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 015725a..eda826b 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL(nf_log_unregister);
 
 int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
 	if (__find_logger(pf, logger->name) == NULL) {
 		mutex_unlock(&nf_log_mutex);
@@ -96,6 +98,8 @@ EXPORT_SYMBOL(nf_log_bind_pf);
 
 void nf_log_unbind_pf(u_int8_t pf)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index b6356f3..c66c348 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -224,12 +224,13 @@ static void pipe_grant_credits(struct sock *sk)
 static int pipe_rcv_status(struct sock *sk, struct sk_buff *skb)
 {
 	struct pep_sock *pn = pep_sk(sk);
-	struct pnpipehdr *hdr = pnp_hdr(skb);
+	struct pnpipehdr *hdr;
 	int wake = 0;
 
 	if (!pskb_may_pull(skb, sizeof(*hdr) + 4))
 		return -EINVAL;
 
+	hdr = pnp_hdr(skb);
 	if (hdr->data[0] != PN_PEP_TYPE_COMMON) {
 		LIMIT_NETDEBUG(KERN_DEBUG"Phonet unknown PEP type: %u\n",
 				(unsigned)hdr->data[0]);
diff --git a/net/rds/page.c b/net/rds/page.c
index 3679012..b442a48 100644
--- a/net/rds/page.c
+++ b/net/rds/page.c
@@ -56,30 +56,17 @@ int rds_page_copy_user(struct page *page, unsigned long offset,
 	unsigned long ret;
 	void *addr;
 
-	if (to_user)
+	addr = kmap(page);
+	if (to_user) {
 		rds_stats_add(s_copy_to_user, bytes);
-	else
+		ret = copy_to_user(ptr, addr + offset, bytes);
+	} else {
 		rds_stats_add(s_copy_from_user, bytes);
-
-	addr = kmap_atomic(page, KM_USER0);
-	if (to_user)
-		ret = __copy_to_user_inatomic(ptr, addr + offset, bytes);
-	else
-		ret = __copy_from_user_inatomic(addr + offset, ptr, bytes);
-	kunmap_atomic(addr, KM_USER0);
-
-	if (ret) {
-		addr = kmap(page);
-		if (to_user)
-			ret = copy_to_user(ptr, addr + offset, bytes);
-		else
-			ret = copy_from_user(addr + offset, ptr, bytes);
-		kunmap(page);
-		if (ret)
-			return -EFAULT;
+		ret = copy_from_user(addr + offset, ptr, bytes);
 	}
+	kunmap(page);
 
-	return 0;
+	return ret ? -EFAULT : 0;
 }
 EXPORT_SYMBOL_GPL(rds_page_copy_user);
 
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 4c64daa..1fa0f4b 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -471,7 +471,7 @@ static struct rds_rdma_op *rds_rdma_prepare(struct rds_sock *rs,
 		goto out;
 	}
 
-	if (args->nr_local > (u64)UINT_MAX) {
+	if (args->nr_local > UIO_MAXIOV) {
 		ret = -EMSGSIZE;
 		goto out;
 	}
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 8feb9e5..ac2c370 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -678,7 +678,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	if ((dev = rose_dev_get(&addr->srose_addr)) == NULL) {
@@ -738,7 +738,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	/* Source + Destination digis should not exceed ROSE_MAX_DIGIS */
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 56935bb..914c419 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -542,16 +542,20 @@ struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc)
 		id = ntohs(hmacs->hmac_ids[i]);
 
 		/* Check the id is in the supported range */
-		if (id > SCTP_AUTH_HMAC_ID_MAX)
+		if (id > SCTP_AUTH_HMAC_ID_MAX) {
+			id = 0;
 			continue;
+		}
 
 		/* See is we support the id.  Supported IDs have name and
 		 * length fields set, so that we can allocated and use
 		 * them.  We can safely just check for name, for without the
 		 * name, we can't allocate the TFM.
 		 */
-		if (!sctp_hmac_list[id].hmac_name)
+		if (!sctp_hmac_list[id].hmac_name) {
+			id = 0;
 			continue;
+		}
 
 		break;
 	}
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 3d74b26..eaacf76 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -439,11 +439,25 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 {
 	SCTP_DEBUG_PRINTK("%s\n",  __func__);
 
-	sctp_do_sm(SCTP_EVENT_T_OTHER,
-		   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
-		   asoc->state, asoc->ep, asoc, t,
-		   GFP_ATOMIC);
+	if (sock_owned_by_user(sk)) {
+		if (timer_pending(&t->proto_unreach_timer))
+			return;
+		else {
+			if (!mod_timer(&t->proto_unreach_timer,
+						jiffies + (HZ/20)))
+				sctp_association_hold(asoc);
+		}
 
+	} else {
+		if (timer_pending(&t->proto_unreach_timer) &&
+		    del_timer(&t->proto_unreach_timer))
+			sctp_association_put(asoc);
+
+		sctp_do_sm(SCTP_EVENT_T_OTHER,
+			   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
+			   asoc->state, asoc->ep, asoc, t,
+			   GFP_ATOMIC);
+	}
 }
 
 /* Common lookup code for icmp/icmpv6 error handler. */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 7c55893..0ba3add 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -91,7 +91,6 @@ struct sctp_packet *sctp_packet_config(struct sctp_packet *packet,
 	SCTP_DEBUG_PRINTK("%s: packet:%p vtag:0x%x\n", __func__,
 			  packet, vtag);
 
-	sctp_packet_reset(packet);
 	packet->vtag = vtag;
 
 	if (ecn_capable && sctp_packet_empty(packet)) {
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 42bbb24..90a5367 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -396,6 +396,41 @@ out_unlock:
 	sctp_transport_put(transport);
 }
 
+/* Handle the timeout of the ICMP protocol unreachable timer.  Trigger
+ * the correct state machine transition that will close the association.
+ */
+void sctp_generate_proto_unreach_event(unsigned long data)
+{
+	struct sctp_transport *transport = (struct sctp_transport *) data;
+	struct sctp_association *asoc = transport->asoc;
+
+	sctp_bh_lock_sock(asoc->base.sk);
+	if (sock_owned_by_user(asoc->base.sk)) {
+		SCTP_DEBUG_PRINTK("%s:Sock is busy.\n", __func__);
+
+		/* Try again later.  */
+		if (!mod_timer(&transport->proto_unreach_timer,
+				jiffies + (HZ/20)))
+			sctp_association_hold(asoc);
+		goto out_unlock;
+	}
+
+	/* Is this structure just waiting around for us to actually
+	 * get destroyed?
+	 */
+	if (asoc->base.dead)
+		goto out_unlock;
+
+	sctp_do_sm(SCTP_EVENT_T_OTHER,
+		   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
+		   asoc->state, asoc->ep, asoc, transport, GFP_ATOMIC);
+
+out_unlock:
+	sctp_bh_unlock_sock(asoc->base.sk);
+	sctp_association_put(asoc);
+}
+
+
 /* Inject a SACK Timeout event into the state machine.  */
 static void sctp_generate_sack_event(unsigned long data)
 {
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index b827d21..943dbf4 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -107,6 +107,8 @@ static struct sctp_transport *sctp_transport_init(struct sctp_transport *peer,
 			(unsigned long)peer);
 	setup_timer(&peer->hb_timer, sctp_generate_heartbeat_event,
 			(unsigned long)peer);
+	setup_timer(&peer->proto_unreach_timer,
+		    sctp_generate_proto_unreach_event, (unsigned long)peer);
 
 	/* Initialize the 64-bit random nonce sent with heartbeat. */
 	get_random_bytes(&peer->hb_nonce, sizeof(peer->hb_nonce));
diff --git a/net/socket.c b/net/socket.c
index 769c386..80e0a4f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1671,6 +1671,8 @@ SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
 	struct iovec iov;
 	int fput_needed;
 
+	if (len > INT_MAX)
+		len = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1728,6 +1730,8 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
 	int err, err2;
 	int fput_needed;
 
+	if (size > INT_MAX)
+		size = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 39bddba..b7af6b2 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1233,8 +1233,10 @@ static int content_open(struct inode *inode, struct file *file,
 	if (!cd || !try_module_get(cd->owner))
 		return -EACCES;
 	han = __seq_open_private(file, &cache_content_op, sizeof(*han));
-	if (han == NULL)
+	if (han == NULL) {
+		module_put(cd->owner);
 		return -ENOMEM;
+	}
 
 	han->cd = cd;
 	return 0;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index aae6907..03a5c9e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -642,14 +642,12 @@ static void __rpc_execute(struct rpc_task *task)
 			save_callback = task->tk_callback;
 			task->tk_callback = NULL;
 			save_callback(task);
-		}
-
-		/*
-		 * Perform the next FSM step.
-		 * tk_action may be NULL when the task has been killed
-		 * by someone else.
-		 */
-		if (!RPC_IS_QUEUED(task)) {
+		} else {
+			/*
+			 * Perform the next FSM step.
+			 * tk_action may be NULL when the task has been killed
+			 * by someone else.
+			 */
 			if (task->tk_action == NULL)
 				break;
 			task->tk_action(task);
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 6bd41a9..a55d3d3 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -207,6 +207,7 @@ int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 	spin_lock(&svc_xprt_class_lock);
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		struct svc_xprt *newxprt;
+		unsigned short newport;
 
 		if (strcmp(xprt_name, xcl->xcl_name))
 			continue;
@@ -225,8 +226,9 @@ int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 		spin_lock_bh(&serv->sv_lock);
 		list_add(&newxprt->xpt_list, &serv->sv_permsocks);
 		spin_unlock_bh(&serv->sv_lock);
+		newport = svc_xprt_local_port(newxprt);
 		clear_bit(XPT_BUSY, &newxprt->xpt_flags);
-		return svc_xprt_local_port(newxprt);
+		return newport;
 	}
  err:
 	spin_unlock(&svc_xprt_class_lock);
@@ -423,8 +425,13 @@ void svc_xprt_received(struct svc_xprt *xprt)
 {
 	BUG_ON(!test_bit(XPT_BUSY, &xprt->xpt_flags));
 	xprt->xpt_pool = NULL;
+	/* As soon as we clear busy, the xprt could be closed and
+	 * 'put', so we need a reference to call svc_xprt_enqueue with:
+	 */
+	svc_xprt_get(xprt);
 	clear_bit(XPT_BUSY, &xprt->xpt_flags);
 	svc_xprt_enqueue(xprt);
+	svc_xprt_put(xprt);
 }
 EXPORT_SYMBOL_GPL(svc_xprt_received);
 
diff --git a/net/wireless/wext-priv.c b/net/wireless/wext-priv.c
index a3c2277..7438a34 100644
--- a/net/wireless/wext-priv.c
+++ b/net/wireless/wext-priv.c
@@ -151,7 +151,7 @@ static int ioctl_private_iw_point(struct iw_point *iwp, unsigned int cmd,
 	} else if (!iwp->pointer)
 		return -EFAULT;
 
-	extra = kmalloc(extra_size, GFP_KERNEL);
+	extra = kzalloc(extra_size, GFP_KERNEL);
 	if (!extra)
 		return -ENOMEM;
 
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index e3219e4..04f83ab 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -81,6 +81,41 @@ struct compat_x25_subscrip_struct {
 };
 #endif
 
+
+int x25_parse_address_block(struct sk_buff *skb,
+		struct x25_address *called_addr,
+		struct x25_address *calling_addr)
+{
+	unsigned char len;
+	int needed;
+	int rc;
+
+	if (skb->len < 1) {
+		/* packet has no address block */
+		rc = 0;
+		goto empty;
+	}
+
+	len = *skb->data;
+	needed = 1 + (len >> 4) + (len & 0x0f);
+
+	if (skb->len < needed) {
+		/* packet is too short to hold the addresses it claims
+		   to hold */
+		rc = -1;
+		goto empty;
+	}
+
+	return x25_addr_ntoa(skb->data, called_addr, calling_addr);
+
+empty:
+	*called_addr->x25_addr = 0;
+	*calling_addr->x25_addr = 0;
+
+	return rc;
+}
+
+
 int x25_addr_ntoa(unsigned char *p, struct x25_address *called_addr,
 		  struct x25_address *calling_addr)
 {
@@ -907,16 +942,26 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	/*
 	 *	Extract the X.25 addresses and convert them to ASCII strings,
 	 *	and remove them.
+	 *
+	 *	Address block is mandatory in call request packets
 	 */
-	addr_len = x25_addr_ntoa(skb->data, &source_addr, &dest_addr);
+	addr_len = x25_parse_address_block(skb, &source_addr, &dest_addr);
+	if (addr_len <= 0)
+		goto out_clear_request;
 	skb_pull(skb, addr_len);
 
 	/*
 	 *	Get the length of the facilities, skip past them for the moment
 	 *	get the call user data because this is needed to determine
 	 *	the correct listener
+	 *
+	 *	Facilities length is mandatory in call request packets
 	 */
+	if (skb->len < 1)
+		goto out_clear_request;
 	len = skb->data[0] + 1;
+	if (skb->len < len)
+		goto out_clear_request;
 	skb_pull(skb,len);
 
 	/*
diff --git a/net/x25/x25_facilities.c b/net/x25/x25_facilities.c
index a21f664..804afd3 100644
--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -35,7 +35,7 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 		struct x25_dte_facilities *dte_facs, unsigned long *vc_fac_mask)
 {
 	unsigned char *p = skb->data;
-	unsigned int len = *p++;
+	unsigned int len;
 
 	*vc_fac_mask = 0;
 
@@ -50,9 +50,19 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 	memset(dte_facs->called_ae, '\0', sizeof(dte_facs->called_ae));
 	memset(dte_facs->calling_ae, '\0', sizeof(dte_facs->calling_ae));
 
+	if (skb->len < 1)
+		return 0;
+
+	len = *p++;
+
+	if (len >= skb->len)
+		return -1;
+
 	while (len > 0) {
 		switch (*p & X25_FAC_CLASS_MASK) {
 		case X25_FAC_CLASS_A:
+			if (len < 2)
+				return 0;
 			switch (*p) {
 			case X25_FAC_REVERSE:
 				if((p[1] & 0x81) == 0x81) {
@@ -96,6 +106,8 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			len -= 2;
 			break;
 		case X25_FAC_CLASS_B:
+			if (len < 3)
+				return 0;
 			switch (*p) {
 			case X25_FAC_PACKET_SIZE:
 				facilities->pacsize_in  = p[1];
@@ -117,6 +129,8 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			len -= 3;
 			break;
 		case X25_FAC_CLASS_C:
+			if (len < 4)
+				return 0;
 			printk(KERN_DEBUG "X.25: unknown facility %02X, "
 			       "values %02X, %02X, %02X\n",
 			       p[0], p[1], p[2], p[3]);
@@ -124,26 +138,26 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			len -= 4;
 			break;
 		case X25_FAC_CLASS_D:
+			if (len < p[1] + 2)
+				return 0;
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->calling_len = p[2];
 				memcpy(dte_facs->calling_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLING_AE;
 				break;
 			case X25_FAC_CALLED_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->called_len = p[2];
 				memcpy(dte_facs->called_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLED_AE;
 				break;
 			default:
 				printk(KERN_DEBUG "X.25: unknown facility %02X,"
-					"length %d, values %02X, %02X, "
-					"%02X, %02X\n",
-					p[0], p[1], p[2], p[3], p[4], p[5]);
+					"length %d\n", p[0], p[1]);
 				break;
 			}
 			len -= p[1] + 2;
@@ -247,6 +261,8 @@ int x25_negotiate_facilities(struct sk_buff *skb, struct sock *sk,
 	memcpy(new, ours, sizeof(*new));
 
 	len = x25_parse_facilities(skb, &theirs, dte, &x25->vc_facil_mask);
+	if (len < 0)
+		return len;
 
 	/*
 	 *	They want reverse charging, we won't accept it.
diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index 96d9227..87739f2 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -89,6 +89,7 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametype)
 {
 	struct x25_address source_addr, dest_addr;
+	int len;
 
 	switch (frametype) {
 		case X25_CALL_ACCEPTED: {
@@ -106,11 +107,19 @@ static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 			 *	Parse the data in the frame.
 			 */
 			skb_pull(skb, X25_STD_MIN_LEN);
-			skb_pull(skb, x25_addr_ntoa(skb->data, &source_addr, &dest_addr));
-			skb_pull(skb,
-				 x25_parse_facilities(skb, &x25->facilities,
+
+			len = x25_parse_address_block(skb, &source_addr,
+						&dest_addr);
+			if (len > 0)
+				skb_pull(skb, len);
+
+			len = x25_parse_facilities(skb, &x25->facilities,
 						&x25->dte_facilities,
-						&x25->vc_facil_mask));
+						&x25->vc_facil_mask);
+			if (len > 0)
+				skb_pull(skb, len);
+			else
+				return -1;
 			/*
 			 *	Copy any Call User Data.
 			 */
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index e4e1b6e..3f1816a 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -391,8 +391,12 @@ void __exit x25_link_free(void)
 	write_lock_bh(&x25_neigh_list_lock);
 
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
+		struct net_device *dev;
+
 		nb = list_entry(entry, struct x25_neigh, node);
+		dev = nb->dev;
 		__x25_remove_neigh(nb);
+		dev_put(dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4759d0f..897695e 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -249,6 +249,8 @@ static int ima_lsm_rule_init(struct ima_measure_rule_entry *entry,
 	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
 					   Audit_equal, args,
 					   &entry->lsm[lsm_rule].rule);
+	if (!entry->lsm[lsm_rule].rule)
+		return -EINVAL;
 	return result;
 }
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index e9c2e7c..c25603a 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1259,6 +1259,7 @@ long keyctl_session_to_parent(void)
 	keyring_r = NULL;
 
 	me = current;
+	rcu_read_lock();
 	write_lock_irq(&tasklist_lock);
 
 	parent = me->real_parent;
@@ -1291,7 +1292,8 @@ long keyctl_session_to_parent(void)
 		goto not_permitted;
 
 	/* the keyrings must have the same UID */
-	if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
+	if ((pcred->tgcred->session_keyring &&
+	     pcred->tgcred->session_keyring->uid != mycred->euid) ||
 	    mycred->tgcred->session_keyring->uid != mycred->euid)
 		goto not_permitted;
 
@@ -1313,6 +1315,7 @@ long keyctl_session_to_parent(void)
 	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
 
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	if (oldcred)
 		put_cred(oldcred);
 	return 0;
@@ -1321,6 +1324,7 @@ already_same:
 	ret = 0;
 not_permitted:
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	put_cred(cred);
 	return ret;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a2ee84..118716c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2600,7 +2600,10 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
 
-	if (!newsid || !(sbsec->flags & SE_SBLABELSUPP)) {
+	if ((sbsec->flags & SE_SBINITIALIZED) &&
+	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT))
+		newsid = sbsec->mntpoint_sid;
+	else if (!newsid || !(sbsec->flags & SE_SBLABELSUPP)) {
 		rc = security_transition_sid(sid, dsec->sid,
 					     inode_mode_to_security_class(inode->i_mode),
 					     &newsid);
@@ -3258,7 +3261,11 @@ static void selinux_cred_free(struct cred *cred)
 {
 	struct task_security_struct *tsec = cred->security;
 
-	BUG_ON((unsigned long) cred->security < PAGE_SIZE);
+	/*
+	 * cred->security == NULL if security_cred_alloc_blank() or
+	 * security_prepare_creds() returned an error.
+	 */
+	BUG_ON(cred->security && (unsigned long) cred->security < PAGE_SIZE);
 	cred->security = (void *) 0x7UL;
 	kfree(tsec);
 }
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index dd7cc6d..24b958c 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -66,6 +66,8 @@ static struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static struct nlmsg_perm nlmsg_firewall_perms[] =
diff --git a/sound/core/control.c b/sound/core/control.c
index 268ab74..6c682fd 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -31,6 +31,7 @@
 
 /* max number of user-defined controls */
 #define MAX_USER_CONTROLS	32
+#define MAX_CONTROL_COUNT	1028
 
 struct snd_kctl_ioctl {
 	struct list_head list;		/* list of all ioctls */
@@ -191,6 +192,10 @@ static struct snd_kcontrol *snd_ctl_new(struct snd_kcontrol *control,
 	
 	if (snd_BUG_ON(!control || !control->count))
 		return NULL;
+
+	if (control->count > MAX_CONTROL_COUNT)
+		return NULL;
+
 	kctl = kzalloc(sizeof(*kctl) + sizeof(struct snd_kcontrol_volatile) * control->count, GFP_KERNEL);
 	if (kctl == NULL) {
 		snd_printk(KERN_ERR "Cannot allocate control instance\n");
diff --git a/sound/core/hrtimer.c b/sound/core/hrtimer.c
index 7f4d744..2475bda 100644
--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -44,12 +44,13 @@ static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 {
 	struct snd_hrtimer *stime = container_of(hrt, struct snd_hrtimer, hrt);
 	struct snd_timer *t = stime->timer;
+	unsigned long oruns;
 
 	if (!atomic_read(&stime->running))
 		return HRTIMER_NORESTART;
 
-	hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
-	snd_timer_interrupt(stime->timer, t->sticks);
+	oruns = hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
+	snd_timer_interrupt(stime->timer, t->sticks * oruns);
 
 	if (!atomic_read(&stime->running))
 		return HRTIMER_NORESTART;
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 0f5a194..5fac1a3 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -531,13 +531,15 @@ static int snd_rawmidi_release(struct inode *inode, struct file *file)
 {
 	struct snd_rawmidi_file *rfile;
 	struct snd_rawmidi *rmidi;
+	struct module *module;
 
 	rfile = file->private_data;
 	rmidi = rfile->rmidi;
 	rawmidi_release_priv(rfile);
 	kfree(rfile);
+	module = rmidi->card->module;
 	snd_card_file_remove(rmidi->card, file);
-	module_put(rmidi->card->module);
+	module_put(module);
 	return 0;
 }
 
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index c625309..833f0bb 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -87,7 +87,7 @@ int *load_mixer_volumes(char *name, int *levels, int present)
 	int             i, n;
 
 	for (i = 0; i < num_mixer_volumes; i++) {
-		if (strcmp(name, mixer_vols[i].name) == 0) {
+		if (strncmp(name, mixer_vols[i].name, 32) == 0) {
 			if (present)
 				mixer_vols[i].num = i;
 			return mixer_vols[i].levels;
@@ -99,7 +99,7 @@ int *load_mixer_volumes(char *name, int *levels, int present)
 	}
 	n = num_mixer_volumes++;
 
-	strcpy(mixer_vols[n].name, name);
+	strncpy(mixer_vols[n].name, name, 32);
 
 	if (present)
 		mixer_vols[n].num = n;
diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index b9d2f20..5439d66 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -42,11 +42,7 @@ static struct snd_pcm_hardware snd_vortex_playback_hw_adb = {
 	.rate_min = 5000,
 	.rate_max = 48000,
 	.channels_min = 1,
-#ifdef CHIP_AU8830
-	.channels_max = 4,
-#else
 	.channels_max = 2,
-#endif
 	.buffer_bytes_max = 0x10000,
 	.period_bytes_min = 0x1,
 	.period_bytes_max = 0x1000,
@@ -115,6 +111,17 @@ static struct snd_pcm_hardware snd_vortex_playback_hw_wt = {
 	.periods_max = 64,
 };
 #endif
+#ifdef CHIP_AU8830
+static unsigned int au8830_channels[3] = {
+	1, 2, 4,
+};
+
+static struct snd_pcm_hw_constraint_list hw_constraints_au8830_channels = {
+	.count = ARRAY_SIZE(au8830_channels),
+	.list = au8830_channels,
+	.mask = 0,
+};
+#endif
 /* open callback */
 static int snd_vortex_pcm_open(struct snd_pcm_substream *substream)
 {
@@ -156,6 +163,15 @@ static int snd_vortex_pcm_open(struct snd_pcm_substream *substream)
 		if (VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_ADB
 		    || VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_I2S)
 			runtime->hw = snd_vortex_playback_hw_adb;
+#ifdef CHIP_AU8830
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+			VORTEX_PCM_TYPE(substream->pcm) == VORTEX_PCM_ADB) {
+			runtime->hw.channels_max = 4;
+			snd_pcm_hw_constraint_list(runtime, 0,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				&hw_constraints_au8830_channels);
+		}
+#endif
 		substream->runtime->private_data = NULL;
 	}
 #ifndef CHIP_AU8810
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 459c1f6..91c05d6 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -868,7 +868,7 @@ spdif_passthru_playback_setup(struct ct_atc *atc, struct ct_atc_pcm *apcm)
 	mutex_lock(&atc->atc_mutex);
 	dao->ops->get_spos(dao, &status);
 	if (((status >> 24) & IEC958_AES3_CON_FS) != iec958_con_fs) {
-		status &= ((~IEC958_AES3_CON_FS) << 24);
+		status &= ~(IEC958_AES3_CON_FS << 24);
 		status |= (iec958_con_fs << 24);
 		dao->ops->set_spos(dao, status);
 		dao->ops->commit_write(dao);
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index af56eb9..47d9ea9 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -176,6 +176,7 @@ static int dao_set_left_input(struct dao *dao, struct rsc *input)
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_left_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscl.ops->master(&daio->rscl);
@@ -204,6 +205,7 @@ static int dao_set_right_input(struct dao *dao, struct rsc *input)
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_right_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscr.ops->master(&daio->rscr);
diff --git a/sound/pci/ctxfi/ctmixer.c b/sound/pci/ctxfi/ctmixer.c
index 15c1e72..c3519ff 100644
--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -566,19 +566,6 @@ static int ct_spdif_get_mask(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static int ct_spdif_default_get(struct snd_kcontrol *kcontrol,
-				struct snd_ctl_elem_value *ucontrol)
-{
-	unsigned int status = SNDRV_PCM_DEFAULT_CON_SPDIF;
-
-	ucontrol->value.iec958.status[0] = (status >> 0) & 0xff;
-	ucontrol->value.iec958.status[1] = (status >> 8) & 0xff;
-	ucontrol->value.iec958.status[2] = (status >> 16) & 0xff;
-	ucontrol->value.iec958.status[3] = (status >> 24) & 0xff;
-
-	return 0;
-}
-
 static int ct_spdif_get(struct snd_kcontrol *kcontrol,
 			struct snd_ctl_elem_value *ucontrol)
 {
@@ -586,6 +573,10 @@ static int ct_spdif_get(struct snd_kcontrol *kcontrol,
 	unsigned int status;
 
 	atc->spdif_out_get_status(atc, &status);
+
+	if (status == 0)
+		status = SNDRV_PCM_DEFAULT_CON_SPDIF;
+
 	ucontrol->value.iec958.status[0] = (status >> 0) & 0xff;
 	ucontrol->value.iec958.status[1] = (status >> 8) & 0xff;
 	ucontrol->value.iec958.status[2] = (status >> 16) & 0xff;
@@ -629,7 +620,7 @@ static struct snd_kcontrol_new iec958_default_ctl = {
 	.name		= SNDRV_CTL_NAME_IEC958("", PLAYBACK, DEFAULT),
 	.count		= 1,
 	.info		= ct_spdif_info,
-	.get		= ct_spdif_default_get,
+	.get		= ct_spdif_get,
 	.put		= ct_spdif_put,
 	.private_value	= MIXER_IEC958_DEFAULT
 };
diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 4228f2f..6679b68 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -378,7 +378,7 @@ static void hdmi_show_short_audio_desc(struct cea_sad *a)
 	snd_print_pcm_rates(a->rates, buf, sizeof(buf));
 
 	if (a->format == AUDIO_CODING_TYPE_LPCM)
-		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2 - 8));
+		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2) - 8);
 	else if (a->max_bitrate)
 		snprintf(buf2, sizeof(buf2),
 				", max bitrate = %d", a->max_bitrate);
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0dc3418..ec84cda 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2267,10 +2267,12 @@ static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x0470, "Dell Inspiron 1120", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x103c, 0x306d, "HP dv3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81e7, "ASUS M2V", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1043, 0x8410, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba A100-259", POS_FIX_LPIB),
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 263bf3b..82c07c0 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3536,6 +3536,7 @@ static struct snd_pci_quirk ad1984_cfg_tbl[] = {
 	/* Lenovo Thinkpad T61/X61 */
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo Thinkpad", AD1984_THINKPAD),
 	SND_PCI_QUIRK(0x1028, 0x0214, "Dell T3400", AD1984_DELL_DESKTOP),
+	SND_PCI_QUIRK(0x1028, 0x0233, "Dell Latitude E6400", AD1984_DELL_DESKTOP),
 	{}
 };
 
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index a978645..7c0d810 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -368,10 +368,16 @@ static int conexant_add_jack(struct hda_codec *codec,
 	struct conexant_spec *spec;
 	struct conexant_jack *jack;
 	const char *name;
-	int err;
+	int i, err;
 
 	spec = codec->spec;
 	snd_array_init(&spec->jacks, sizeof(*jack), 32);
+
+	jack = spec->jacks.list;
+	for (i = 0; i < spec->jacks.used; i++, jack++)
+		if (jack->nid == nid)
+			return 0 ; /* already present */
+
 	jack = snd_array_new(&spec->jacks);
 	name = (type == SND_JACK_HEADPHONE) ? "Headphone" : "Mic" ;
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dea03d9..946c2e4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4037,6 +4037,7 @@ static struct snd_pci_quirk alc880_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),
+	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_TCL_S700),
@@ -17670,6 +17671,8 @@ static inline hda_nid_t alc662_mix_to_dac(hda_nid_t nid)
 		return 0x02;
 	else if (nid >= 0x0c && nid <= 0x0e)
 		return nid - 0x0c + 0x02;
+	else if (nid == 0x26) /* ALC887-VD has this DAC too */
+		return 0x25;
 	else
 		return 0;
 }
@@ -17678,7 +17681,7 @@ static inline hda_nid_t alc662_mix_to_dac(hda_nid_t nid)
 static hda_nid_t alc662_dac_to_mix(struct hda_codec *codec, hda_nid_t pin,
 				   hda_nid_t dac)
 {
-	hda_nid_t mix[4];
+	hda_nid_t mix[5];
 	int i, num;
 
 	num = snd_hda_get_connections(codec, pin, mix, ARRAY_SIZE(mix));
@@ -18077,7 +18080,10 @@ static int patch_alc888(struct hda_codec *codec)
 {
 	if ((alc_read_coef_idx(codec, 0) & 0x00f0)==0x0030){
 		kfree(codec->chip_name);
-		codec->chip_name = kstrdup("ALC888-VD", GFP_KERNEL);
+		if (codec->vendor_id == 0x10ec0887)
+			codec->chip_name = kstrdup("ALC887-VD", GFP_KERNEL);
+		else
+			codec->chip_name = kstrdup("ALC888-VD", GFP_KERNEL);
 		if (!codec->chip_name) {
 			alc_free(codec);
 			return -ENOMEM;
@@ -18117,7 +18123,7 @@ static struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A",
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },
-	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc882 },
+	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc888 },
 	{ .id = 0x10ec0888, .rev = 0x100101, .name = "ALC1200",
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0888, .name = "ALC888", .patch = patch_alc888 },
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 256ad3a..0d3dd06 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -729,7 +729,7 @@ static int stac92xx_mux_enum_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 	struct sigmatel_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	const struct hda_input_mux *imux = spec->input_mux;
-	unsigned int idx, prev_idx;
+	unsigned int idx, prev_idx, didx;
 
 	idx = ucontrol->value.enumerated.item[0];
 	if (idx >= imux->num_items)
@@ -741,7 +741,8 @@ static int stac92xx_mux_enum_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 		snd_hda_codec_write_cache(codec, spec->mux_nids[adc_idx], 0,
 					  AC_VERB_SET_CONNECT_SEL,
 					  imux->items[idx].index);
-		if (prev_idx >= spec->num_analog_muxes) {
+		if (prev_idx >= spec->num_analog_muxes &&
+		    spec->mux_nids[adc_idx] != spec->dmux_nids[adc_idx]) {
 			imux = spec->dinput_mux;
 			/* 0 = analog */
 			snd_hda_codec_write_cache(codec,
@@ -751,9 +752,13 @@ static int stac92xx_mux_enum_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 		}
 	} else {
 		imux = spec->dinput_mux;
+		/* first dimux item is hardcoded to select analog imux,
+		 * so lets skip it
+		 */
+		didx = idx - spec->num_analog_muxes + 1;
 		snd_hda_codec_write_cache(codec, spec->dmux_nids[adc_idx], 0,
 					  AC_VERB_SET_CONNECT_SEL,
-					  imux->items[idx - 1].index);
+					  imux->items[didx].index);
 	}
 	spec->cur_mux[adc_idx] = idx;
 	return 1;
@@ -1610,6 +1615,8 @@ static struct snd_pci_quirk stac92hd73xx_cfg_tbl[] = {
 static struct snd_pci_quirk stac92hd73xx_codec_id_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02a1,
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x043a,
+		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	{} /* terminator */
 };
 
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index b990143..7fb869b 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -1860,6 +1860,12 @@ static struct ac97_quirk ac97_quirks[] __devinitdata = {
 	},
 	{
 		.subvendor = 0x1028,
+		.subdevice = 0x0182,
+		.name = "Dell Latitude D610",	/* STAC9750/51 */
+		.type = AC97_TUNE_HP_ONLY
+	},
+	{
+		.subvendor = 0x1028,
 		.subdevice = 0x0186,
 		.name = "Dell Latitude D810", /* cf. Malone #41015 */
 		.type = AC97_TUNE_HP_MUTE_LED
diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
index acbedeb..39a0a3d 100644
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -543,6 +543,10 @@ static int __devinit get_oxygen_model(struct oxygen *chip,
 		chip->model.suspend = claro_suspend;
 		chip->model.resume = claro_resume;
 		chip->model.set_adc_params = set_ak5385_params;
+		chip->model.device_config = PLAYBACK_0_TO_I2S |
+					    PLAYBACK_1_TO_SPDIF |
+					    CAPTURE_0_FROM_I2S_2 |
+					    CAPTURE_1_FROM_SPDIF;
 		break;
 	}
 	if (id->driver_data == MODEL_MERIDIAN ||
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 7bb827c..401518c 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -4610,6 +4610,7 @@ static int snd_hdsp_hwdep_ioctl(struct snd_hwdep *hw, struct file *file, unsigne
 		if (err < 0)
 			return err;
 
+		memset(&info, 0, sizeof(info));
 		spin_lock_irqsave(&hdsp->lock, flags);
 		info.pref_sync_ref = (unsigned char)hdsp_pref_sync_ref(hdsp);
 		info.wordclock_sync_check = (unsigned char)hdsp_wc_sync_check(hdsp);
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index a1b10d1..b147fce 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -4127,6 +4127,7 @@ static int snd_hdspm_hwdep_ioctl(struct snd_hwdep * hw, struct file *file,
 
 	case SNDRV_HDSPM_IOCTL_GET_CONFIG_INFO:
 
+		memset(&info, 0, sizeof(info));
 		spin_lock_irq(&hdspm->lock);
 		info.pref_sync_ref = hdspm_pref_sync_ref(hdspm);
 		info.wordclock_sync_check = hdspm_wc_sync_check(hdspm);
diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index e693229..488593f 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -260,9 +260,9 @@ static int bf5xx_ac97_suspend(struct snd_soc_dai *dai)
 	pr_debug("%s : sport %d\n", __func__, dai->id);
 	if (!dai->active)
 		return 0;
-	if (dai->capture.active)
+	if (dai->capture_active)
 		sport_rx_stop(sport);
-	if (dai->playback.active)
+	if (dai->playback_active)
 		sport_tx_stop(sport);
 	return 0;
 }
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 2f76f4d..8637fa3 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1184,7 +1184,7 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 				     WM8990_VMIDTOG);
 
 			/* Delay to allow output caps to discharge */
-			msleep(msecs_to_jiffies(300));
+			msleep(300);
 
 			/* Disable VMIDTOG */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1196,17 +1196,17 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 			/* Enable outputs */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1b00);
 
-			msleep(msecs_to_jiffies(50));
+			msleep(50);
 
 			/* Enable VMID at 2x50k */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f02);
 
-			msleep(msecs_to_jiffies(100));
+			msleep(100);
 
 			/* Enable VREF */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f03);
 
-			msleep(msecs_to_jiffies(600));
+			msleep(600);
 
 			/* Enable BUFIOEN */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1251,7 +1251,7 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 		/* Disable VMID */
 		snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f01);
 
-		msleep(msecs_to_jiffies(300));
+		msleep(300);
 
 		/* Enable all output discharge bits */
 		snd_soc_write(codec, WM8990_ANTIPOP1, WM8990_DIS_LLINE |
diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 86b2c3b..007b4bf 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -639,7 +639,7 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 	}
 
 	dev->pcm->private_data = dev;
-	strcpy(dev->pcm->name, dev->product_name);
+	strlcpy(dev->pcm->name, dev->product_name, sizeof(dev->pcm->name));
 
 	memset(dev->sub_playback, 0, sizeof(dev->sub_playback));
 	memset(dev->sub_capture, 0, sizeof(dev->sub_capture));
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index 538e8c0..bd55649 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -135,7 +135,7 @@ int snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *device)
 	if (ret < 0)
 		return ret;
 
-	strcpy(rmidi->name, device->product_name);
+	strlcpy(rmidi->name, device->product_name, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = device;
diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 91bb296..7abda8d 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -269,29 +269,26 @@ static unsigned int usb_stream_hwdep_poll(struct snd_hwdep *hw,
 					  struct file *file, poll_table *wait)
 {
 	struct us122l	*us122l = hw->private_data;
-	struct usb_stream *s = us122l->sk.s;
 	unsigned	*polled;
 	unsigned int	mask;
 
 	poll_wait(file, &us122l->sk.sleep, wait);
 
-	switch (s->state) {
-	case usb_stream_ready:
-		if (us122l->first == file)
-			polled = &s->periods_polled;
-		else
-			polled = &us122l->second_periods_polled;
-		if (*polled != s->periods_done) {
-			*polled = s->periods_done;
-			mask = POLLIN | POLLOUT | POLLWRNORM;
-			break;
+	mask = POLLIN | POLLOUT | POLLWRNORM | POLLERR;
+	if (mutex_trylock(&us122l->mutex)) {
+		struct usb_stream *s = us122l->sk.s;
+		if (s && s->state == usb_stream_ready) {
+			if (us122l->first == file)
+				polled = &s->periods_polled;
+			else
+				polled = &us122l->second_periods_polled;
+			if (*polled != s->periods_done) {
+				*polled = s->periods_done;
+				mask = POLLIN | POLLOUT | POLLWRNORM;
+			} else
+				mask = 0;
 		}
-		/* Fall through */
-		mask = 0;
-		break;
-	default:
-		mask = POLLIN | POLLOUT | POLLWRNORM | POLLERR;
-		break;
+		mutex_unlock(&us122l->mutex);
 	}
 	return mask;
 }
@@ -377,6 +374,7 @@ static int usb_stream_hwdep_ioctl(struct snd_hwdep *hw, struct file *file,
 {
 	struct usb_stream_config *cfg;
 	struct us122l *us122l = hw->private_data;
+	struct usb_stream *s;
 	unsigned min_period_frames;
 	int err = 0;
 	bool high_speed;
@@ -422,18 +420,18 @@ static int usb_stream_hwdep_ioctl(struct snd_hwdep *hw, struct file *file,
 	snd_power_wait(hw->card, SNDRV_CTL_POWER_D0);
 
 	mutex_lock(&us122l->mutex);
+	s = us122l->sk.s;
 	if (!us122l->master)
 		us122l->master = file;
 	else if (us122l->master != file) {
-		if (memcmp(cfg, &us122l->sk.s->cfg, sizeof(*cfg))) {
+		if (!s || memcmp(cfg, &s->cfg, sizeof(*cfg))) {
 			err = -EIO;
 			goto unlock;
 		}
 		us122l->slave = file;
 	}
-	if (!us122l->sk.s ||
-	    memcmp(cfg, &us122l->sk.s->cfg, sizeof(*cfg)) ||
-	    us122l->sk.s->state == usb_stream_xrun) {
+	if (!s || memcmp(cfg, &s->cfg, sizeof(*cfg)) ||
+	    s->state == usb_stream_xrun) {
 		us122l_stop(us122l);
 		if (!us122l_start(us122l, cfg->sample_rate, cfg->period_frames))
 			err = -EIO;
@@ -444,6 +442,7 @@ unlock:
 	mutex_unlock(&us122l->mutex);
 free:
 	kfree(cfg);
+	wake_up_all(&us122l->sk.sleep);
 	return err;
 }
 
