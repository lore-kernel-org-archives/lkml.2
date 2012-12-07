Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423852Ab2LGBY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:24:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423341Ab2LGBYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:24:54 -0500
Message-ID: <1354843479.20838.24.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.35
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 07 Dec 2012 01:24:39 +0000
In-Reply-To: <1354843413.20838.23.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9pn+kNL/DWNz8nlZmg8Z"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9pn+kNL/DWNz8nlZmg8Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memor=
y.txt
index cc0ebc5..fd129f6 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -440,6 +440,10 @@ Note:
 5.3 swappiness
=20
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups on=
ly.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
=20
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb=
_firmware
index e67be7a..48d25ea 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -115,7 +115,7 @@ sub tda10045 {
=20
 sub tda10046 {
 	my $sourcefile =3D "TT_PCI_2.19h_28_11_2006.zip";
-	my $url =3D "http://www.tt-download.com/download/updates/219/$sourcefile"=
;
+	my $url =3D "http://technotrend.com.ua/download/software/219/$sourcefile"=
;
 	my $hash =3D "6a7e1e2f2644b162ff0502367553c72d";
 	my $outfile =3D "dvb-fe-tda10046.fw";
 	my $tmpdir =3D tempdir(DIR =3D> "/tmp", CLEANUP =3D> 1);
diff --git a/Makefile b/Makefile
index 14ebacf..d985af0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 34
+SUBLEVEL =3D 35
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9fdc151..27bcd12 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -542,6 +542,7 @@ config ARCH_KIRKWOOD
 	bool "Marvell Kirkwood"
 	select CPU_FEROCEON
 	select PCI
+	select PCI_QUIRKS
 	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
diff --git a/arch/arm/mach-dove/include/mach/pm.h b/arch/arm/mach-dove/incl=
ude/mach/pm.h
index 3ad9f94..11799c3 100644
--- a/arch/arm/mach-dove/include/mach/pm.h
+++ b/arch/arm/mach-dove/include/mach/pm.h
@@ -45,7 +45,7 @@ static inline int pmu_to_irq(int pin)
=20
 static inline int irq_to_pmu(int irq)
 {
-	if (IRQ_DOVE_PMU_START < irq && irq < NR_IRQS)
+	if (IRQ_DOVE_PMU_START <=3D irq && irq < NR_IRQS)
 		return irq - IRQ_DOVE_PMU_START;
=20
 	return -EINVAL;
diff --git a/arch/arm/mach-dove/irq.c b/arch/arm/mach-dove/irq.c
index f07fd16..9f2fd10 100644
--- a/arch/arm/mach-dove/irq.c
+++ b/arch/arm/mach-dove/irq.c
@@ -61,8 +61,20 @@ static void pmu_irq_ack(struct irq_data *d)
 	int pin =3D irq_to_pmu(d->irq);
 	u32 u;
=20
+	/*
+	 * The PMU mask register is not RW0C: it is RW.  This means that
+	 * the bits take whatever value is written to them; if you write
+	 * a '1', you will set the interrupt.
+	 *
+	 * Unfortunately this means there is NO race free way to clear
+	 * these interrupts.
+	 *
+	 * So, let's structure the code so that the window is as small as
+	 * possible.
+	 */
 	u =3D ~(1 << (pin & 31));
-	writel(u, PMU_INTERRUPT_CAUSE);
+	u &=3D readl_relaxed(PMU_INTERRUPT_CAUSE);
+	writel_relaxed(u, PMU_INTERRUPT_CAUSE);
 }
=20
 static struct irq_chip pmu_irq_chip =3D {
diff --git a/arch/arm/mach-kirkwood/pcie.c b/arch/arm/mach-kirkwood/pcie.c
index 74b992d..a881c54 100644
--- a/arch/arm/mach-kirkwood/pcie.c
+++ b/arch/arm/mach-kirkwood/pcie.c
@@ -213,14 +213,19 @@ static int __init kirkwood_pcie_setup(int nr, struct =
pci_sys_data *sys)
 	return 1;
 }
=20
+/*
+ * The root complex has a hardwired class of PCI_CLASS_MEMORY_OTHER, when =
it
+ * is operating as a root complex this needs to be switched to
+ * PCI_CLASS_BRIDGE_HOST or Linux will errantly try to process the BAR's o=
n
+ * the device. Decoding setup is handled by the orion code.
+ */
 static void __devinit rc_pci_fixup(struct pci_dev *dev)
 {
-	/*
-	 * Prevent enumeration of root complex.
-	 */
 	if (dev->bus->parent =3D=3D NULL && dev->devfn =3D=3D 0) {
 		int i;
=20
+		dev->class &=3D 0xff;
+		dev->class |=3D PCI_CLASS_BRIDGE_HOST << 8;
 		for (i =3D 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			dev->resource[i].start =3D 0;
 			dev->resource[i].end   =3D 0;
diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.=
h
index 60e8866..93fe83e 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -156,7 +156,7 @@ typedef struct sigaltstack {
 static inline void sigaddset(sigset_t *set, int _sig)
 {
 	asm ("bfset %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -164,7 +164,7 @@ static inline void sigaddset(sigset_t *set, int _sig)
 static inline void sigdelset(sigset_t *set, int _sig)
 {
 	asm ("bfclr %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -180,7 +180,7 @@ static inline int __gen_sigismember(sigset_t *set, int =
_sig)
 	int ret;
 	asm ("bfextu %1{%2,#1},%0"
 		: "=3Dd" (ret)
-		: "od" (*set), "id" ((_sig-1) ^ 31)
+		: "o" (*set), "id" ((_sig-1) ^ 31)
 		: "cc");
 	return ret;
 }
diff --git a/arch/parisc/kernel/signal32.c b/arch/parisc/kernel/signal32.c
index e141324..d0ea054 100644
--- a/arch/parisc/kernel/signal32.c
+++ b/arch/parisc/kernel/signal32.c
@@ -67,7 +67,8 @@ put_sigset32(compat_sigset_t __user *up, sigset_t *set, s=
ize_t sz)
 {
 	compat_sigset_t s;
=20
-	if (sz !=3D sizeof *set) panic("put_sigset32()");
+	if (sz !=3D sizeof *set)
+		return -EINVAL;
 	sigset_64to32(&s, set);
=20
 	return copy_to_user(up, &s, sizeof s);
@@ -79,7 +80,8 @@ get_sigset32(compat_sigset_t __user *up, sigset_t *set, s=
ize_t sz)
 	compat_sigset_t s;
 	int r;
=20
-	if (sz !=3D sizeof *set) panic("put_sigset32()");
+	if (sz !=3D sizeof *set)
+		return -EINVAL;
=20
 	if ((r =3D copy_from_user(&s, up, sz)) =3D=3D 0) {
 		sigset_32to64(set, &s);
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_paris=
c.c
index c9b9322..7ea75d1 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -73,6 +73,8 @@ static unsigned long get_shared_area(struct address_space=
 *mapping,
 	struct vm_area_struct *vma;
 	int offset =3D mapping ? get_offset(mapping) : 0;
=20
+	offset =3D (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
+
 	addr =3D DCACHE_ALIGN(addr - offset) + offset;
=20
 	for (vma =3D find_vma(current->mm, addr); ; vma =3D vma->vm_next) {
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.=
h
index 234f1d8..2e0a15b 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -20,7 +20,7 @@
 #define PSW32_MASK_CC		0x00003000UL
 #define PSW32_MASK_PM		0x00000f00UL
=20
-#define PSW32_MASK_USER		0x00003F00UL
+#define PSW32_MASK_USER		0x0000FF00UL
=20
 #define PSW32_ADDR_AMODE	0x80000000UL
 #define PSW32_ADDR_INSN		0x7FFFFFFFUL
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.=
h
index a658463..a5b4c48 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -240,7 +240,7 @@ typedef struct
 #define PSW_MASK_EA		0x00000000UL
 #define PSW_MASK_BA		0x00000000UL
=20
-#define PSW_MASK_USER		0x00003F00UL
+#define PSW_MASK_USER		0x0000FF00UL
=20
 #define PSW_ADDR_AMODE		0x80000000UL
 #define PSW_ADDR_INSN		0x7FFFFFFFUL
@@ -269,7 +269,7 @@ typedef struct
 #define PSW_MASK_EA		0x0000000100000000UL
 #define PSW_MASK_BA		0x0000000080000000UL
=20
-#define PSW_MASK_USER		0x00003F0180000000UL
+#define PSW_MASK_USER		0x0000FF0180000000UL
=20
 #define PSW_ADDR_AMODE		0x0000000000000000UL
 #define PSW_ADDR_INSN		0xFFFFFFFFFFFFFFFFUL
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_sig=
nal.c
index 4f68c81..9fdd05d 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -312,6 +312,10 @@ static int restore_sigregs32(struct pt_regs *regs,_sig=
regs32 __user *sregs)
 	regs->psw.mask =3D (regs->psw.mask & ~PSW_MASK_USER) |
 		(__u64)(regs32.psw.mask & PSW32_MASK_USER) << 32 |
 		(__u64)(regs32.psw.addr & PSW32_ADDR_AMODE);
+	/* Check for invalid user address space control. */
+	if ((regs->psw.mask & PSW_MASK_ASC) >=3D (psw_kernel_bits & PSW_MASK_ASC)=
)
+		regs->psw.mask =3D (psw_user_bits & PSW_MASK_ASC) |
+			(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr =3D (__u64)(regs32.psw.addr & PSW32_ADDR_INSN);
 	for (i =3D 0; i < NUM_GPRS; i++)
 		regs->gprs[i] =3D (__u64) regs32.gprs[i];
@@ -493,7 +497,10 @@ static int setup_frame32(int sig, struct k_sigaction *=
ka,
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (__force __u64) frame;
-	regs->psw.mask |=3D PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask =3D PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr =3D (__force __u64) ka->sa.sa_handler;
=20
 	regs->gprs[2] =3D map_signal(sig);
@@ -557,7 +564,10 @@ static int setup_rt_frame32(int sig, struct k_sigactio=
n *ka, siginfo_t *info,
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (__force __u64) frame;
-	regs->psw.mask |=3D PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask =3D PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr =3D (__u64) ka->sa.sa_handler;
=20
 	regs->gprs[2] =3D map_signal(sig);
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 5086553..d54d475 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -147,6 +147,10 @@ static int restore_sigregs(struct pt_regs *regs, _sigr=
egs __user *sregs)
 	/* Use regs->psw.mask instead of psw_user_bits to preserve PER bit. */
 	regs->psw.mask =3D (regs->psw.mask & ~PSW_MASK_USER) |
 		(user_sregs.regs.psw.mask & PSW_MASK_USER);
+	/* Check for invalid user address space control. */
+	if ((regs->psw.mask & PSW_MASK_ASC) >=3D (psw_kernel_bits & PSW_MASK_ASC)=
)
+		regs->psw.mask =3D (psw_user_bits & PSW_MASK_ASC) |
+			(regs->psw.mask & ~PSW_MASK_ASC);
 	/* Check for invalid amode */
 	if (regs->psw.mask & PSW_MASK_EA)
 		regs->psw.mask |=3D PSW_MASK_BA;
@@ -293,7 +297,10 @@ static int setup_frame(int sig, struct k_sigaction *ka=
,
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (unsigned long) frame;
-	regs->psw.mask |=3D PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask =3D PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr =3D (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
=20
 	regs->gprs[2] =3D map_signal(sig);
@@ -362,7 +369,10 @@ static int setup_rt_frame(int sig, struct k_sigaction =
*ka, siginfo_t *info,
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (unsigned long) frame;
-	regs->psw.mask |=3D PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask =3D PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr =3D (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
=20
 	regs->gprs[2] =3D map_signal(sig);
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 65cb06e..4ccf9f5 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -183,7 +183,7 @@ int get_user_pages_fast(unsigned long start, int nr_pag=
es, int write,
 	addr =3D start;
 	len =3D (unsigned long) nr_pages << PAGE_SHIFT;
 	end =3D start + len;
-	if (end < start)
+	if ((end < start) || (end > TASK_SIZE))
 		goto slow_irqon;
=20
 	/*
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index f0836cd..d58d3ed 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -307,9 +307,7 @@ void do_rt_sigreturn(struct pt_regs *regs)
 		err |=3D restore_fpu_state(regs, fpu_save);
=20
 	err |=3D __copy_from_user(&set, &sf->mask, sizeof(sigset_t));
-	err |=3D do_sigaltstack(&sf->stack, NULL, (unsigned long)sf);
-
-	if (err)
+	if (err || do_sigaltstack(&sf->stack, NULL, (unsigned long)sf) =3D=3D -EF=
AULT)
 		goto segv;
=20
 	err |=3D __get_user(rwin_save, &sf->rwin_save);
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 3566454..3b96fd4 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -206,21 +206,14 @@ static inline bool user_64bit_mode(struct pt_regs *re=
gs)
 }
 #endif
=20
-/*
- * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
- * when it traps.  The previous stack will be directly underneath the save=
d
- * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'=
.
- *
- * This is valid only for kernel mode traps.
- */
-static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
-{
 #ifdef CONFIG_X86_32
-	return (unsigned long)(&regs->sp);
+extern unsigned long kernel_stack_pointer(struct pt_regs *regs);
 #else
+static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
+{
 	return regs->sp;
-#endif
 }
+#endif
=20
 #define GET_IP(regs) ((regs)->ip)
 #define GET_FP(regs) ((regs)->bp)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ff8557e..f07becc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -587,6 +587,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
=20
+	/*
+	 * The way access filter has a performance penalty on some workloads.
+	 * Disable it on the affected CPUs.
+	 */
+	if ((c->x86 =3D=3D 0x15) &&
+	    (c->x86_model >=3D 0x02) && (c->x86_model < 0x20)) {
+		u64 val;
+
+		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
+			val |=3D 0x1E;
+			checking_wrmsrl(0xc0011021, val);
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
=20
 	/* Multi core CPU? */
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu=
/mcheck/therm_throt.c
index 787e06c..ce04b58 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -323,17 +323,6 @@ device_initcall(thermal_throttle_init_device);
=20
 #endif /* CONFIG_SYSFS */
=20
-/*
- * Set up the most two significant bit to notify mce log that this thermal
- * event type.
- * This is a temp solution. May be changed in the future with mce log
- * infrasture.
- */
-#define CORE_THROTTLED		(0)
-#define CORE_POWER_LIMIT	((__u64)1 << 62)
-#define PACKAGE_THROTTLED	((__u64)2 << 62)
-#define PACKAGE_POWER_LIMIT	((__u64)3 << 62)
-
 static void notify_thresholds(__u64 msr_val)
 {
 	/* check whether the interrupt handler is defined;
@@ -363,27 +352,23 @@ static void intel_thermal_interrupt(void)
 	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
 				THERMAL_THROTTLING_EVENT,
 				CORE_LEVEL) !=3D 0)
-		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
+		mce_log_therm_throt_event(msr_val);
=20
 	if (this_cpu_has(X86_FEATURE_PLN))
-		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
+		therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
-					CORE_LEVEL) !=3D 0)
-			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
+					CORE_LEVEL);
=20
 	if (this_cpu_has(X86_FEATURE_PTS)) {
 		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
-		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
+		therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
 					THERMAL_THROTTLING_EVENT,
-					PACKAGE_LEVEL) !=3D 0)
-			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
+					PACKAGE_LEVEL);
 		if (this_cpu_has(X86_FEATURE_PLN))
-			if (therm_throt_process(msr_val &
+			therm_throt_process(msr_val &
 					PACKAGE_THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
-					PACKAGE_LEVEL) !=3D 0)
-				mce_log_therm_throt_event(PACKAGE_POWER_LIMIT
-							  | msr_val);
+					PACKAGE_LEVEL);
 	}
 }
=20
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_am=
d.c
index ac52c15..1ef962b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -163,6 +163,7 @@ static unsigned int verify_ucode_size(int cpu, const u8=
 *buf, unsigned int size)
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
+#define F16H_MPB_MAX_SIZE 3458
=20
 	switch (c->x86) {
 	case 0x14:
@@ -171,6 +172,9 @@ static unsigned int verify_ucode_size(int cpu, const u8=
 *buf, unsigned int size)
 	case 0x15:
 		max_size =3D F15H_MPB_MAX_SIZE;
 		break;
+	case 0x16:
+		max_size =3D F16H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size =3D F1XH_MPB_MAX_SIZE;
 		break;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8252879..2dc4121 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/module.h>
=20
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -164,6 +165,35 @@ static inline bool invalid_selector(u16 value)
=20
 #define FLAG_MASK		FLAG_MASK_32
=20
+/*
+ * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
+ * when it traps.  The previous stack will be directly underneath the save=
d
+ * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'=
.
+ *
+ * Now, if the stack is empty, '&regs->sp' is out of range. In this
+ * case we try to take the previous stack. To always return a non-null
+ * stack pointer we fall back to regs as stack if no previous stack
+ * exists.
+ *
+ * This is valid only for kernel mode traps.
+ */
+unsigned long kernel_stack_pointer(struct pt_regs *regs)
+{
+	unsigned long context =3D (unsigned long)regs & ~(THREAD_SIZE - 1);
+	unsigned long sp =3D (unsigned long)&regs->sp;
+	struct thread_info *tinfo;
+
+	if (context =3D=3D (sp & ~(THREAD_SIZE - 1)))
+		return sp;
+
+	tinfo =3D (struct thread_info *)context;
+	if (tinfo->previous_esp)
+		return tinfo->previous_esp;
+
+	return (unsigned long)regs;
+}
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
+
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long r=
egno)
 {
 	BUILD_BUG_ON(offsetof(struct pt_regs, bx) !=3D 0);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cf0ef98..0d403aa 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -937,8 +937,21 @@ void __init setup_arch(char **cmdline_p)
=20
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped =3D init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
+		int i;
+		for (i =3D 0; i < e820.nr_map; i++) {
+			struct e820entry *ei =3D &e820.map[i];
+
+			if (ei->addr + ei->size <=3D 1UL << 32)
+				continue;
+
+			if (ei->type =3D=3D E820_RESERVED)
+				continue;
+
+			max_pfn_mapped =3D init_memory_mapping(
+				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
+				ei->addr + ei->size);
+		}
+
 		/* can we preseve max_low_pfn ?*/
 		max_low_pfn =3D max_pfn;
 	}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 87488b9..34a7f40 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,36 +28,50 @@ int direct_gbpages
 #endif
 ;
=20
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+/*
+ * First calculate space needed for kernel direct mapping page tables to c=
over
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M a=
nd 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int nr_ran=
ge)
 {
-	unsigned long puds, pmds, ptes, tables, start =3D 0, good_end =3D end;
+	int i;
+	unsigned long puds =3D 0, pmds =3D 0, ptes =3D 0, tables;
+	unsigned long start =3D 0, good_end;
 	phys_addr_t base;
=20
-	puds =3D (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables =3D roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	for (i =3D 0; i < nr_range; i++) {
+		unsigned long range, extra;
=20
-	if (use_gbpages) {
-		unsigned long extra;
+		range =3D mr[i].end - mr[i].start;
+		puds +=3D (range + PUD_SIZE - 1) >> PUD_SHIFT;
=20
-		extra =3D end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds =3D (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds =3D (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables +=3D roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra =3D range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds +=3D (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds +=3D (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
=20
-	if (use_pse) {
-		unsigned long extra;
-
-		extra =3D end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra =3D range - ((range >> PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
-		extra +=3D PMD_SIZE;
+			extra +=3D PMD_SIZE;
 #endif
-		ptes =3D (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes =3D (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			ptes +=3D (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes +=3D (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}
=20
+	tables =3D roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables +=3D roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables +=3D roundup(ptes * sizeof(pte_t), PAGE_SIZE);
=20
 #ifdef CONFIG_X86_32
@@ -75,7 +89,8 @@ static void __init find_early_table_space(unsigned long e=
nd, int use_pse,
 	pgt_buf_top =3D pgt_buf_start + (tables >> PAGE_SHIFT);
=20
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
+		mr[nr_range - 1].end, pgt_buf_start << PAGE_SHIFT,
+		pgt_buf_top << PAGE_SHIFT);
 }
=20
 void __init native_pagetable_reserve(u64 start, u64 end)
@@ -83,12 +98,6 @@ void __init native_pagetable_reserve(u64 start, u64 end)
 	memblock_x86_reserve_range(start, end, "PGTABLE");
 }
=20
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -260,7 +269,7 @@ unsigned long __init_refok init_memory_mapping(unsigned=
 long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(mr, nr_range);
=20
 	for (i =3D 0; i < nr_range; i++)
 		ret =3D kernel_physical_mapping_init(mr[i].start, mr[i].end,
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 6053285..ac2c6e7 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -49,6 +49,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struc=
t gendisk *bd_disk,
 			   rq_end_io_fn *done)
 {
 	int where =3D at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	bool is_pm_resume;
=20
 	if (unlikely(blk_queue_dead(q))) {
 		rq->errors =3D -ENXIO;
@@ -59,12 +60,18 @@ void blk_execute_rq_nowait(struct request_queue *q, str=
uct gendisk *bd_disk,
=20
 	rq->rq_disk =3D bd_disk;
 	rq->end_io =3D done;
+	/*
+	 * need to check this before __blk_run_queue(), because rq can
+	 * be freed before that returns.
+	 */
+	is_pm_resume =3D rq->cmd_type =3D=3D REQ_TYPE_PM_RESUME;
+
 	WARN_ON(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type =3D=3D REQ_TYPE_PM_RESUME)
+	if (is_pm_resume)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index c364358..791df46 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -374,6 +374,8 @@ typedef struct drm_i915_private {
 	unsigned int lvds_use_ssc:1;
 	unsigned int display_clock_mode:1;
 	int lvds_ssc_freq;
+	unsigned int bios_lvds_val; /* initial [PCH_]LVDS reg val in VBIOS */
+	unsigned int lvds_val; /* used for checking LVDS channel mode */
 	struct {
 		int rate;
 		int lanes;
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel=
_bios.c
index 22efb08..87bb87b 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -174,6 +174,28 @@ get_lvds_dvo_timing(const struct bdb_lvds_lfp_data *lv=
ds_lfp_data,
 	return (struct lvds_dvo_timing *)(entry + dvo_timing_offset);
 }
=20
+/* get lvds_fp_timing entry
+ * this function may return NULL if the corresponding entry is invalid
+ */
+static const struct lvds_fp_timing *
+get_lvds_fp_timing(const struct bdb_header *bdb,
+		   const struct bdb_lvds_lfp_data *data,
+		   const struct bdb_lvds_lfp_data_ptrs *ptrs,
+		   int index)
+{
+	size_t data_ofs =3D (const u8 *)data - (const u8 *)bdb;
+	u16 data_size =3D ((const u16 *)data)[-1]; /* stored in header */
+	size_t ofs;
+
+	if (index >=3D ARRAY_SIZE(ptrs->ptr))
+		return NULL;
+	ofs =3D ptrs->ptr[index].fp_timing_offset;
+	if (ofs < data_ofs ||
+	    ofs + sizeof(struct lvds_fp_timing) > data_ofs + data_size)
+		return NULL;
+	return (const struct lvds_fp_timing *)((const u8 *)bdb + ofs);
+}
+
 /* Try to find integrated panel data */
 static void
 parse_lfp_panel_data(struct drm_i915_private *dev_priv,
@@ -183,6 +205,7 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
 	const struct bdb_lvds_lfp_data *lvds_lfp_data;
 	const struct bdb_lvds_lfp_data_ptrs *lvds_lfp_data_ptrs;
 	const struct lvds_dvo_timing *panel_dvo_timing;
+	const struct lvds_fp_timing *fp_timing;
 	struct drm_display_mode *panel_fixed_mode;
 	int i, downclock;
=20
@@ -244,6 +267,19 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv=
,
 			      "Normal Clock %dKHz, downclock %dKHz\n",
 			      panel_fixed_mode->clock, 10*downclock);
 	}
+
+	fp_timing =3D get_lvds_fp_timing(bdb, lvds_lfp_data,
+				       lvds_lfp_data_ptrs,
+				       lvds_options->panel_type);
+	if (fp_timing) {
+		/* check the resolution, just to be sure */
+		if (fp_timing->x_res =3D=3D panel_fixed_mode->hdisplay &&
+		    fp_timing->y_res =3D=3D panel_fixed_mode->vdisplay) {
+			dev_priv->bios_lvds_val =3D fp_timing->lvds_reg_val;
+			DRM_DEBUG_KMS("VBT initial LVDS value %x\n",
+				      dev_priv->bios_lvds_val);
+		}
+	}
 }
=20
 /* Try to find sdvo panel data */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index adac0dd..fdae61f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -356,6 +356,27 @@ static const intel_limit_t intel_limits_ironlake_displ=
ay_port =3D {
 	.find_pll =3D intel_find_pll_ironlake_dp,
 };
=20
+static bool is_dual_link_lvds(struct drm_i915_private *dev_priv,
+			      unsigned int reg)
+{
+	unsigned int val;
+
+	if (dev_priv->lvds_val)
+		val =3D dev_priv->lvds_val;
+	else {
+		/* BIOS should set the proper LVDS register value at boot, but
+		 * in reality, it doesn't set the value when the lid is closed;
+		 * we need to check "the value to be set" in VBT when LVDS
+		 * register is uninitialized.
+		 */
+		val =3D I915_READ(reg);
+		if (!(val & ~LVDS_DETECTED))
+			val =3D dev_priv->bios_lvds_val;
+		dev_priv->lvds_val =3D val;
+	}
+	return (val & LVDS_CLKB_POWER_MASK) =3D=3D LVDS_CLKB_POWER_UP;
+}
+
 static const intel_limit_t *intel_ironlake_limit(struct drm_crtc *crtc,
 						int refclk)
 {
@@ -364,8 +385,7 @@ static const intel_limit_t *intel_ironlake_limit(struct=
 drm_crtc *crtc,
 	const intel_limit_t *limit;
=20
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
-		if ((I915_READ(PCH_LVDS) & LVDS_CLKB_POWER_MASK) =3D=3D
-		    LVDS_CLKB_POWER_UP) {
+		if (is_dual_link_lvds(dev_priv, PCH_LVDS)) {
 			/* LVDS dual channel */
 			if (refclk =3D=3D 100000)
 				limit =3D &intel_limits_ironlake_dual_lvds_100m;
@@ -393,8 +413,7 @@ static const intel_limit_t *intel_g4x_limit(struct drm_=
crtc *crtc)
 	const intel_limit_t *limit;
=20
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
-		if ((I915_READ(LVDS) & LVDS_CLKB_POWER_MASK) =3D=3D
-		    LVDS_CLKB_POWER_UP)
+		if (is_dual_link_lvds(dev_priv, LVDS))
 			/* LVDS with dual channel */
 			limit =3D &intel_limits_g4x_dual_channel_lvds;
 		else
@@ -531,8 +550,7 @@ intel_find_best_PLL(const intel_limit_t *limit, struct =
drm_crtc *crtc,
 		 * reliably set up different single/dual channel state, if we
 		 * even can.
 		 */
-		if ((I915_READ(LVDS) & LVDS_CLKB_POWER_MASK) =3D=3D
-		    LVDS_CLKB_POWER_UP)
+		if (is_dual_link_lvds(dev_priv, LVDS))
 			clock.p2 =3D limit->p2.p2_fast;
 		else
 			clock.p2 =3D limit->p2.p2_slow;
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel=
_sdvo.c
index 3f4afba..9e24670 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2264,6 +2264,18 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdv=
o, uint16_t flags)
 	return true;
 }
=20
+static void intel_sdvo_output_cleanup(struct intel_sdvo *intel_sdvo)
+{
+	struct drm_device *dev =3D intel_sdvo->base.base.dev;
+	struct drm_connector *connector, *tmp;
+
+	list_for_each_entry_safe(connector, tmp,
+				 &dev->mode_config.connector_list, head) {
+		if (intel_attached_encoder(connector) =3D=3D &intel_sdvo->base)
+			intel_sdvo_destroy(connector);
+	}
+}
+
 static bool intel_sdvo_tv_create_property(struct intel_sdvo *intel_sdvo,
 					  struct intel_sdvo_connector *intel_sdvo_connector,
 					  int type)
@@ -2596,7 +2608,8 @@ bool intel_sdvo_init(struct drm_device *dev, int sdvo=
_reg)
 				    intel_sdvo->caps.output_flags) !=3D true) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
 			      IS_SDVOB(sdvo_reg) ? 'B' : 'C');
-		goto err;
+		/* Output_setup can leave behind connectors! */
+		goto err_output;
 	}
=20
 	/* Only enable the hotplug irq if we need it, to work around noisy
@@ -2609,12 +2622,12 @@ bool intel_sdvo_init(struct drm_device *dev, int sd=
vo_reg)
=20
 	/* Set the input timing to the screen. Assume always input 0. */
 	if (!intel_sdvo_set_target_input(intel_sdvo))
-		goto err;
+		goto err_output;
=20
 	if (!intel_sdvo_get_input_pixel_clock_range(intel_sdvo,
 						    &intel_sdvo->pixel_clock_min,
 						    &intel_sdvo->pixel_clock_max))
-		goto err;
+		goto err_output;
=20
 	DRM_DEBUG_KMS("%s device VID/DID: %02X:%02X.%02X, "
 			"clock range %dMHz - %dMHz, "
@@ -2634,6 +2647,9 @@ bool intel_sdvo_init(struct drm_device *dev, int sdvo=
_reg)
 			(SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
 	return true;
=20
+err_output:
+	intel_sdvo_output_cleanup(intel_sdvo);
+
 err:
 	drm_encoder_cleanup(&intel_encoder->base);
 	i2c_del_adapter(&intel_sdvo->ddc);
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/r=
adeon/atombios_encoders.c
index 382e141..aca4755 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1386,7 +1386,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *enco=
der, int mode)
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, =
0, 0);
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE,=
 0, 0);
 			/* some early dce3.2 boards have a bug in their transmitter control tab=
le */
-			if ((rdev->family !=3D CHIP_RV710) || (rdev->family !=3D CHIP_RV730))
+			if ((rdev->family !=3D CHIP_RV710) && (rdev->family !=3D CHIP_RV730))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE=
_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector)=
 {
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index ca94e23..b919b11 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1122,6 +1122,8 @@ void evergreen_mc_stop(struct radeon_device *rdev, st=
ruct evergreen_mc_save *sav
 					break;
 				udelay(1);
 			}
+		} else {
+			save->crtc_enabled[i] =3D false;
 		}
 	}
=20
diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/r=
adeon_agp.c
index bd2f33e..bc6b64f 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -70,9 +70,12 @@ static struct radeon_agpmode_quirk radeon_agpmode_quirk_=
list[] =3D {
 	/* Intel 82830 830 Chipset Host Bridge / Mobility M6 LY Needs AGPMode 2 (=
fdo #17360)*/
 	{ PCI_VENDOR_ID_INTEL, 0x3575, PCI_VENDOR_ID_ATI, 0x4c59,
 		PCI_VENDOR_ID_DELL, 0x00e3, 2},
-	/* Intel 82852/82855 host bridge / Mobility FireGL 9000 R250 Needs AGPMod=
e 1 (lp #296617) */
+	/* Intel 82852/82855 host bridge / Mobility FireGL 9000 RV250 Needs AGPMo=
de 1 (lp #296617) */
 	{ PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4c66,
 		PCI_VENDOR_ID_DELL, 0x0149, 1},
+	/* Intel 82855PM host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1=
 for suspend/resume */
+	{ PCI_VENDOR_ID_INTEL, 0x3340, PCI_VENDOR_ID_ATI, 0x4c66,
+		PCI_VENDOR_ID_IBM, 0x0531, 1},
 	/* Intel 82852/82855 host bridge / Mobility 9600 M10 RV350 Needs AGPMode =
1 (deb #467460) */
 	{ PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4e50,
 		0x1025, 0x0061, 1},
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm=
_page_alloc.c
index 727e93d..9e4313e 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -708,7 +708,10 @@ int ttm_get_pages(struct list_head *pages, int flags,
 	/* clear the pages coming from the pool if requested */
 	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC) {
 		list_for_each_entry(p, pages, lru) {
-			clear_page(page_address(p));
+			if (PageHighMem(p))
+				clear_highpage(p);
+			else
+				clear_page(page_address(p));
 		}
 	}
=20
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ab75a4e..652f230 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -277,6 +277,9 @@
 #define USB_VENDOR_ID_EZKEY		0x0518
 #define USB_DEVICE_ID_BTC_8193		0x0002
=20
+#define USB_VENDOR_ID_FREESCALE		0x15A2
+#define USB_DEVICE_ID_FREESCALE_MX28	0x004F
+
 #define USB_VENDOR_ID_GAMERON		0x0810
 #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirk=
s.c
index afb73af..aec3fa3 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -68,6 +68,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET =
},
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QU=
IRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_Q=
UIRK_NO_INIT_REPORTS },
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5b39216..3f28290 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -163,6 +163,38 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_=
CSTATES] =3D {
 		.enter =3D &intel_idle },
 };
=20
+static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] =3D {
+	{ /* MWAIT C0 */ },
+	{ /* MWAIT C1 */
+		.name =3D "C1-IVB",
+		.desc =3D "MWAIT 0x00",
+		.flags =3D CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency =3D 1,
+		.target_residency =3D 1,
+		.enter =3D &intel_idle },
+	{ /* MWAIT C2 */
+		.name =3D "C3-IVB",
+		.desc =3D "MWAIT 0x10",
+		.flags =3D CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency =3D 59,
+		.target_residency =3D 156,
+		.enter =3D &intel_idle },
+	{ /* MWAIT C3 */
+		.name =3D "C6-IVB",
+		.desc =3D "MWAIT 0x20",
+		.flags =3D CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency =3D 80,
+		.target_residency =3D 300,
+		.enter =3D &intel_idle },
+	{ /* MWAIT C4 */
+		.name =3D "C7-IVB",
+		.desc =3D "MWAIT 0x30",
+		.flags =3D CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency =3D 87,
+		.target_residency =3D 300,
+		.enter =3D &intel_idle },
+};
+
 static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] =3D {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
@@ -386,6 +418,11 @@ static int intel_idle_probe(void)
 		cpuidle_state_table =3D snb_cstates;
 		break;
=20
+	case 0x3A:	/* IVB */
+	case 0x3E:	/* IVB Xeon */
+		cpuidle_state_table =3D ivb_cstates;
+		break;
+
 	default:
 		pr_debug(PREFIX "does not run on family %d model %d\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ec58f48..1512bd8 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -453,6 +453,9 @@ static void setup_events_to_report(struct input_dev *in=
put_dev,
 	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
=20
+	if (cfg->caps & HAS_INTEGRATED_BUTTON)
+		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+
 	input_set_events_per_packet(input_dev, 60);
 }
=20
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d37a48e..8656441 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -991,7 +991,7 @@ static int i8042_controller_init(void)
  * Reset the controller and reset CRT to the original value set by BIOS.
  */
=20
-static void i8042_controller_reset(void)
+static void i8042_controller_reset(bool force_reset)
 {
 	i8042_flush();
=20
@@ -1016,7 +1016,7 @@ static void i8042_controller_reset(void)
  * Reset the controller if requested.
  */
=20
-	if (i8042_reset)
+	if (i8042_reset || force_reset)
 		i8042_controller_selftest();
=20
 /*
@@ -1139,9 +1139,9 @@ static int i8042_controller_resume(bool force_reset)
  * upsetting it.
  */
=20
-static int i8042_pm_reset(struct device *dev)
+static int i8042_pm_suspend(struct device *dev)
 {
-	i8042_controller_reset();
+	i8042_controller_reset(true);
=20
 	return 0;
 }
@@ -1163,13 +1163,20 @@ static int i8042_pm_thaw(struct device *dev)
 	return 0;
 }
=20
+static int i8042_pm_reset(struct device *dev)
+{
+	i8042_controller_reset(false);
+
+	return 0;
+}
+
 static int i8042_pm_restore(struct device *dev)
 {
 	return i8042_controller_resume(false);
 }
=20
 static const struct dev_pm_ops i8042_pm_ops =3D {
-	.suspend	=3D i8042_pm_reset,
+	.suspend	=3D i8042_pm_suspend,
 	.resume		=3D i8042_pm_resume,
 	.thaw		=3D i8042_pm_thaw,
 	.poweroff	=3D i8042_pm_reset,
@@ -1185,7 +1192,7 @@ static const struct dev_pm_ops i8042_pm_ops =3D {
=20
 static void i8042_shutdown(struct platform_device *dev)
 {
-	i8042_controller_reset();
+	i8042_controller_reset(false);
 }
=20
 static int __init i8042_create_kbd_port(void)
@@ -1424,7 +1431,7 @@ static int __init i8042_probe(struct platform_device =
*dev)
  out_fail:
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
-	i8042_controller_reset();
+	i8042_controller_reset(false);
 	i8042_platform_device =3D NULL;
=20
 	return error;
@@ -1434,7 +1441,7 @@ static int __devexit i8042_remove(struct platform_dev=
ice *dev)
 {
 	i8042_unregister_ports();
 	i8042_free_irqs();
-	i8042_controller_reset();
+	i8042_controller_reset(false);
 	i8042_platform_device =3D NULL;
=20
 	return 0;
diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-=
gigaset.c
index 3913f47..492aa52 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -616,7 +616,13 @@ static void int_in_work(struct work_struct *work)
 	if (rc =3D=3D 0)
 		/* success, resubmit interrupt read URB */
 		rc =3D usb_submit_urb(urb, GFP_ATOMIC);
-	if (rc !=3D 0 && rc !=3D -ENODEV) {
+
+	switch (rc) {
+	case 0:		/* success */
+	case -ENODEV:	/* device gone */
+	case -EINVAL:	/* URB already resubmitted, or terminal badness */
+		break;
+	default:	/* failure: try to recover by resetting the device */
 		dev_err(cs->dev, "clear halt failed: %s\n", get_usb_rcmsg(rc));
 		rc =3D usb_lock_device_for_reset(ucs->udev, ucs->interface);
 		if (rc =3D=3D 0) {
@@ -2437,7 +2443,9 @@ static void gigaset_disconnect(struct usb_interface *=
interface)
 }
=20
 /* gigaset_suspend
- * This function is called before the USB connection is suspended.
+ * This function is called before the USB connection is suspended
+ * or before the USB device is reset.
+ * In the latter case, message =3D=3D PMSG_ON.
  */
 static int gigaset_suspend(struct usb_interface *intf, pm_message_t messag=
e)
 {
@@ -2493,7 +2501,12 @@ static int gigaset_suspend(struct usb_interface *int=
f, pm_message_t message)
 	del_timer_sync(&ucs->timer_atrdy);
 	del_timer_sync(&ucs->timer_cmd_in);
 	del_timer_sync(&ucs->timer_int_in);
-	cancel_work_sync(&ucs->int_in_wq);
+
+	/* don't try to cancel int_in_wq from within reset as it
+	 * might be the one requesting the reset
+	 */
+	if (message.event !=3D PM_EVENT_ON)
+		cancel_work_sync(&ucs->int_in_wq);
=20
 	gig_dbg(DEBUG_SUSPEND, "suspend complete");
 	return 0;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 502dcf7..8953630 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -755,8 +755,14 @@ static void rq_completed(struct mapped_device *md, int=
 rw, int run_queue)
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
=20
+	/*
+	 * Run this off this callpath, as drivers could invoke end_io while
+	 * inside their request_fn (and holding the queue lock). Calling
+	 * back into ->request_fn() could deadlock attempting to grab the
+	 * queue lock again.
+	 */
 	if (run_queue)
-		blk_run_queue(md->queue);
+		blk_run_queue_async(md->queue);
=20
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2887f22..145e378e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1801,10 +1801,10 @@ retry:
 			memset(bbp, 0xff, PAGE_SIZE);
=20
 			for (i =3D 0 ; i < bb->count ; i++) {
-				u64 internal_bb =3D *p++;
+				u64 internal_bb =3D p[i];
 				u64 store_bb =3D ((BB_OFFSET(internal_bb) << 10)
 						| BB_LEN(internal_bb));
-				*bbp++ =3D cpu_to_le64(store_bb);
+				bbp[i] =3D cpu_to_le64(store_bb);
 			}
 			bb->changed =3D 0;
 			if (read_seqretry(&bb->lock, seq))
@@ -7650,9 +7650,9 @@ int md_is_badblock(struct badblocks *bb, sector_t s, =
int sectors,
 		   sector_t *first_bad, int *bad_sectors)
 {
 	int hi;
-	int lo =3D 0;
+	int lo;
 	u64 *p =3D bb->page;
-	int rv =3D 0;
+	int rv;
 	sector_t target =3D s + sectors;
 	unsigned seq;
=20
@@ -7667,7 +7667,8 @@ int md_is_badblock(struct badblocks *bb, sector_t s, =
int sectors,
=20
 retry:
 	seq =3D read_seqbegin(&bb->lock);
-
+	lo =3D 0;
+	rv =3D 0;
 	hi =3D bb->count;
=20
 	/* Binary search between lo and hi for 'target'
diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index e585263..f38c348 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -266,7 +266,7 @@ static int parse_cmdline(char *devname, char *szstart, =
char *szlength)
=20
 	if (*(szlength) !=3D '+') {
 		devlength =3D simple_strtoul(szlength, &buffer, 0);
-		devlength =3D handle_unit(devlength, buffer) - devstart;
+		devlength =3D handle_unit(devlength, buffer);
 		if (devlength < devstart)
 			goto err_out;
=20
diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index 64be8f0..d9127e2 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -121,7 +121,7 @@ static int parse_ofoldpart_partitions(struct mtd_info *=
master,
 	nr_parts =3D plen / sizeof(part[0]);
=20
 	*pparts =3D kzalloc(nr_parts * sizeof(*(*pparts)), GFP_KERNEL);
-	if (!pparts)
+	if (!*pparts)
 		return -ENOMEM;
=20
 	names =3D of_get_property(dp, "partition-names", &plen);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_82599.c
index 4ae26a7..7720721 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -356,6 +356,7 @@ static enum ixgbe_media_type ixgbe_get_media_type_82599=
(struct ixgbe_hw *hw)
 	case IXGBE_DEV_ID_82599_SFP_FCOE:
 	case IXGBE_DEV_ID_82599_SFP_EM:
 	case IXGBE_DEV_ID_82599_SFP_SF2:
+	case IXGBE_DEV_ID_82599_SFP_SF_QP:
 	case IXGBE_DEV_ID_82599EN_SFP:
 		media_type =3D ixgbe_media_type_fiber;
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_common.c
index f1365fe..2c14e85 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3157,6 +3157,7 @@ static s32 ixgbe_device_supports_autoneg_fc(struct ix=
gbe_hw *hw)
=20
 	switch (hw->device_id) {
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		return 0;
 	case IXGBE_DEV_ID_82599_T3_LOM:
 		return 0;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index 8ef92d1..cc96a5a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -106,6 +106,8 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci_tbl) =3D {
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF2), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_LS), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599EN_SFP), board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF_QP), board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_X540T1), board_X540 },
 	/* required last entry */
 	{0, }
 };
@@ -7611,6 +7613,7 @@ static int __devinit ixgbe_probe(struct pci_dev *pdev=
,
 		adapter->wol =3D IXGBE_WUFC_MAG;
 		break;
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		/* Check eeprom to see if it is enabled */
 		hw->eeprom.ops.read(hw, 0x2c, &adapter->eeprom_cap);
 		wol_cap =3D adapter->eeprom_cap & IXGBE_DEVICE_CAPS_WOL_MASK;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_type.h
index 6c5cca8..f00d6d5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -65,6 +65,8 @@
 #define IXGBE_SUBDEV_ID_82599_KX4_KR_MEZZ  0x000C
 #define IXGBE_DEV_ID_82599_LS            0x154F
 #define IXGBE_DEV_ID_X540T               0x1528
+#define IXGBE_DEV_ID_82599_SFP_SF_QP     0x154A
+#define IXGBE_DEV_ID_X540T1              0x1560
=20
 /* VF Device IDs */
 #define IXGBE_DEV_ID_82599_VF           0x10ED
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/=
wireless/brcm80211/brcmsmac/ampdu.c
index 0515862..858a762 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1072,9 +1072,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *=
ampdu, struct scb *scb,
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
-				wiphy_err(wiphy, "%s: BA Timeout, seq %d, in_"
-					"transit %d\n", "AMPDU status", seq,
-					ini->tx_in_transit);
+				BCMMSG(wiphy,
+				       "BA Timeout, seq %d, in_transit %d\n",
+				       seq, ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/m=
wifiex/cmdevt.c
index 6e0a3ea..5a25dd2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -816,9 +816,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context=
)
 		return;
 	}
 	cmd_node =3D adapter->curr_cmd;
-	if (cmd_node->wait_q_enabled)
-		adapter->cmd_wait_q.status =3D -ETIMEDOUT;
-
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =3D
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
@@ -863,6 +860,14 @@ mwifiex_cmd_timeout_func(unsigned long function_contex=
t)
=20
 		dev_err(adapter->dev, "ps_mode=3D%d ps_state=3D%d\n",
 				adapter->ps_mode, adapter->ps_state);
+
+		if (cmd_node->wait_q_enabled) {
+			adapter->cmd_wait_q.status =3D -ETIMEDOUT;
+			wake_up_interruptible(&adapter->cmd_wait_q.wait);
+			mwifiex_cancel_pending_ioctl(adapter);
+			/* reset cmd_sent flag to unblock new commands */
+			adapter->cmd_sent =3D false;
+		}
 	}
 	if (adapter->hw_status =3D=3D MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwi=
fiex/sdio.c
index 283171b..3579a68 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -162,7 +162,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag =3D 0;
-	int hs_actived =3D 0;
 	int i;
 	int ret =3D 0;
=20
@@ -189,12 +188,14 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	adapter =3D card->adapter;
=20
 	/* Enable the Host Sleep */
-	hs_actived =3D mwifiex_enable_hs(adapter);
-	if (hs_actived) {
-		pr_debug("cmd: suspend with MMC_PM_KEEP_POWER\n");
-		ret =3D sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (!mwifiex_enable_hs(adapter)) {
+		dev_err(adapter->dev, "cmd: failed to suspend\n");
+		return -EFAULT;
 	}
=20
+	dev_dbg(adapter->dev, "cmd: suspend with MMC_PM_KEEP_POWER\n");
+	ret =3D sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
 	/* Indicate device suspended */
 	adapter->is_suspended =3D true;
=20
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/sw.c
index 0302148..a99be2d0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -307,6 +307,7 @@ static struct usb_device_id rtl8192c_usb_ids[] =3D {
 	/*=3D=3D=3D Customer ID =3D=3D=3D*/
 	/****** 8188CU ********/
 	{RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
+	{RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - ISY*/
 	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 86b69f85..9d932f4 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -612,7 +612,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_=
size_t min_size,
 	if (children_add_size > add_size)
 		add_size =3D children_add_size;
 	size1 =3D (!realloc_head || (realloc_head && !add_size)) ? size0 :
-		calculate_iosize(size, min_size+add_size, size1,
+		calculate_iosize(size, min_size, add_size + size1,
 			resource_size(b_res), 4096);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
@@ -726,7 +726,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned =
long mask,
 	if (children_add_size > add_size)
 		add_size =3D children_add_size;
 	size1 =3D (!realloc_head || (realloc_head && !add_size)) ? size0 :
-		calculate_memsize(size, min_size+add_size, 0,
+		calculate_memsize(size, min_size, add_size,
 				resource_size(b_res), min_align);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5717509b..8b25f9c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -233,11 +233,12 @@ int pci_reassign_resource(struct pci_dev *dev, int re=
sno, resource_size_t addsiz
 		return -EINVAL;
 	}
=20
-	new_size =3D resource_size(res) + addsize + min_align;
+	/* already aligned with min_align */
+	new_size =3D resource_size(res) + addsize;
 	ret =3D _pci_assign_resource(dev, resno, new_size, min_align);
 	if (!ret) {
 		res->flags &=3D ~IORESOURCE_STARTALIGN;
-		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
+		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
 		if (resno < PCI_BRIDGE_RESOURCES)
 			pci_update_resource(dev, resno);
 	}
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wm=
i.c
index 110e4af..7d47434 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -105,6 +105,7 @@ static const struct key_entry acer_wmi_keymap[] =3D {
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
 	{KE_IGNORE, 0x43, {KEY_NEXTSONG} },
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 192cb48..f3cbecc 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1849,7 +1849,7 @@ sci_io_request_frame_handler(struct isci_request *ire=
q,
 								      frame_index,
 								      (void **)&frame_buffer);
=20
-			sci_controller_copy_sata_response(&ireq->stp.req,
+			sci_controller_copy_sata_response(&ireq->stp.rsp,
 							       frame_header,
 							       frame_buffer);
=20
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 0c6fb19..7de9993 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1934,7 +1934,6 @@ static int process_ctrl_td(struct xhci_hcd *xhci, str=
uct xhci_td *td,
 		}
 		break;
 	case COMP_SHORT_TX:
-		xhci_warn(xhci, "WARN: short transfer on control ep\n");
 		if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 			*status =3D -EREMOTEIO;
 		else
@@ -2291,7 +2290,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		xhci_dbg(xhci, "Stopped on No-op or Link TRB\n");
 		break;
 	case COMP_STALL:
-		xhci_warn(xhci, "WARN: Stalled endpoint\n");
+		xhci_dbg(xhci, "Stalled endpoint\n");
 		ep->ep_state |=3D EP_HALTED;
 		status =3D -EPIPE;
 		break;
@@ -2301,11 +2300,11 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		break;
 	case COMP_SPLIT_ERR:
 	case COMP_TX_ERR:
-		xhci_warn(xhci, "WARN: transfer error on endpoint\n");
+		xhci_dbg(xhci, "Transfer error on endpoint\n");
 		status =3D -EPROTO;
 		break;
 	case COMP_BABBLE:
-		xhci_warn(xhci, "WARN: babble error on endpoint\n");
+		xhci_dbg(xhci, "Babble error on endpoint\n");
 		status =3D -EOVERFLOW;
 		break;
 	case COMP_DB_ERR:
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5a23f4d..dab05d1 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -206,14 +206,14 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
=20
 	ret =3D pci_enable_msi(pdev);
 	if (ret) {
-		xhci_err(xhci, "failed to allocate MSI entry\n");
+		xhci_dbg(xhci, "failed to allocate MSI entry\n");
 		return ret;
 	}
=20
 	ret =3D request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
 				0, "xhci_hcd", xhci_to_hcd(xhci));
 	if (ret) {
-		xhci_err(xhci, "disable MSI interrupt\n");
+		xhci_dbg(xhci, "disable MSI interrupt\n");
 		pci_disable_msi(pdev);
 	}
=20
@@ -276,7 +276,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
=20
 	ret =3D pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
 	if (ret) {
-		xhci_err(xhci, "Failed to enable MSI-X\n");
+		xhci_dbg(xhci, "Failed to enable MSI-X\n");
 		goto free_entries;
 	}
=20
@@ -292,7 +292,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 	return ret;
=20
 disable_msix:
-	xhci_err(xhci, "disable MSI-X interrupt\n");
+	xhci_dbg(xhci, "disable MSI-X interrupt\n");
 	xhci_free_irq(xhci);
 	pci_disable_msix(pdev);
 free_entries:
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index c334670..a5f875d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -157,6 +157,7 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED	0x8001
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0x9000
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0x9001
+#define NOVATELWIRELESS_PRODUCT_E362		0x9010
 #define NOVATELWIRELESS_PRODUCT_G1		0xA001
 #define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
@@ -192,6 +193,9 @@ static void option_instat_callback(struct urb *urb);
 #define DELL_PRODUCT_5730_MINICARD_TELUS	0x8181
 #define DELL_PRODUCT_5730_MINICARD_VZW		0x8182
=20
+#define DELL_PRODUCT_5800_MINICARD_VZW		0x8195  /* Novatel E362 */
+#define DELL_PRODUCT_5800_V2_MINICARD_VZW	0x8196  /* Novatel E362 */
+
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
 #define KYOCERA_PRODUCT_KPC680			0x180a
@@ -282,6 +286,7 @@ static void option_instat_callback(struct urb *urb);
 /* ALCATEL PRODUCTS */
 #define ALCATEL_VENDOR_ID			0x1bbb
 #define ALCATEL_PRODUCT_X060S_X200		0x0000
+#define ALCATEL_PRODUCT_X220_X500D		0x0017
=20
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -705,6 +710,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
 	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELES=
S_PRODUCT_MC551, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELES=
S_PRODUCT_E362, 0xff, 0xff, 0xff) },
=20
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
@@ -727,6 +733,8 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_SPRINT) },	/* Del=
l Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_TELUS) },	/* Dell=
 Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell =
Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_MINICAR=
D_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_V2_MINI=
CARD_VZW, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100=
, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
@@ -1156,6 +1164,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S_X200),
 	  .driver_info =3D (kernel_ulong_t)&alcatel_x200_blacklist
 	},
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-seria=
l.c
index 8bea45c..e5206de 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -764,7 +764,7 @@ int usb_serial_probe(struct usb_interface *interface,
=20
 		if (retval) {
 			dbg("sub driver rejected device");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return retval;
 		}
@@ -836,7 +836,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		 */
 		if (num_bulk_in =3D=3D 0 || num_bulk_out =3D=3D 0) {
 			dev_info(&interface->dev, "PL-2303 hack: descriptors matched but endpoi=
nts did not\n");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return -ENODEV;
 		}
@@ -850,7 +850,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		if (num_ports =3D=3D 0) {
 			dev_err(&interface->dev,
 			    "Generic device with no bulk out, not allowed.\n");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return -EIO;
 		}
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 99796c5..bdf401b 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -36,6 +36,7 @@
  *	document number TBD                   : Patsburg (PBG)
  *	document number TBD                   : DH89xxCC
  *	document number TBD                   : Panther Point
+ *	document number TBD                   : Lynx Point
  */
=20
 /*
@@ -126,6 +127,7 @@ enum iTCO_chipsets {
 	TCO_PBG,	/* Patsburg */
 	TCO_DH89XXCC,	/* DH89xxCC */
 	TCO_PPT,	/* Panther Point */
+	TCO_LPT,	/* Lynx Point */
 };
=20
 static struct {
@@ -189,6 +191,7 @@ static struct {
 	{"Patsburg", 2},
 	{"DH89xxCC", 2},
 	{"Panther Point", 2},
+	{"Lynx Point", 2},
 	{NULL, 0}
 };
=20
@@ -331,6 +334,38 @@ static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) =3D {
 	{ PCI_VDEVICE(INTEL, 0x1e5d), TCO_PPT},
 	{ PCI_VDEVICE(INTEL, 0x1e5e), TCO_PPT},
 	{ PCI_VDEVICE(INTEL, 0x1e5f), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x8c40), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c41), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c42), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c43), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c44), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c45), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c46), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c47), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c48), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c49), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4a), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4b), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4c), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4d), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4e), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4f), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c50), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c51), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c52), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c53), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c54), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c55), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c56), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c57), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c58), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c59), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5a), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5b), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5c), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5d), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5e), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5f), TCO_LPT},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 0301be6..465e49a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -165,16 +165,14 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct g=
fs2_log_element *le)
 	struct gfs2_meta_header *mh;
 	struct gfs2_trans *tr;
=20
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (!list_empty(&bd->bd_list_tr))
-		goto out;
+		return;
 	tr =3D current->journal_info;
 	tr->tr_touched =3D 1;
 	tr->tr_num_buf++;
 	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 	if (!list_empty(&le->le_list))
-		goto out;
+		return;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	gfs2_meta_check(sdp, bd->bd_bh);
@@ -185,9 +183,6 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs=
2_log_element *le)
 	sdp->sd_log_num_buf++;
 	list_add(&le->le_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
=20
 static void buf_lo_before_commit(struct gfs2_sbd *sdp)
@@ -518,11 +513,9 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struc=
t gfs2_log_element *le)
 	struct address_space *mapping =3D bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip =3D GFS2_I(mapping->host);
=20
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (tr) {
 		if (!list_empty(&bd->bd_list_tr))
-			goto out;
+			return;
 		tr->tr_touched =3D 1;
 		if (gfs2_is_jdata(ip)) {
 			tr->tr_num_buf++;
@@ -530,7 +523,7 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct=
 gfs2_log_element *le)
 		}
 	}
 	if (!list_empty(&le->le_list))
-		goto out;
+		return;
=20
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
@@ -542,9 +535,6 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct=
 gfs2_log_element *le)
 	} else {
 		list_add_tail(&le->le_list, &sdp->sd_log_le_ordered);
 	}
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
=20
 static void gfs2_check_magic(struct buffer_head *bh)
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 86ac75d..6ab2a77 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -145,14 +145,22 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct =
buffer_head *bh, int meta)
 	struct gfs2_sbd *sdp =3D gl->gl_sbd;
 	struct gfs2_bufdata *bd;
=20
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
 	bd =3D bh->b_private;
 	if (bd)
 		gfs2_assert(sdp, bd->bd_gl =3D=3D gl);
 	else {
+		gfs2_log_unlock(sdp);
+		unlock_buffer(bh);
 		gfs2_attach_bufdata(gl, bh, meta);
 		bd =3D bh->b_private;
+		lock_buffer(bh);
+		gfs2_log_lock(sdp);
 	}
 	lops_add(sdp, &bd->bd_le);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
 }
=20
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index edac004..7c86b37 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1957,7 +1957,9 @@ retry:
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			spin_unlock(&journal->j_state_lock);
+			unlock_buffer(bh);
 			log_wait_commit(journal, tid);
+			lock_buffer(bh);
 			goto retry;
 		}
 		/*
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 61e6723..0095a70 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -135,33 +135,39 @@ static int jffs2_write_begin(struct file *filp, struc=
t address_space *mapping,
 	struct page *pg;
 	struct inode *inode =3D mapping->host;
 	struct jffs2_inode_info *f =3D JFFS2_INODE_INFO(inode);
+	struct jffs2_sb_info *c =3D JFFS2_SB_INFO(inode->i_sb);
+	struct jffs2_raw_inode ri;
+	uint32_t alloc_len =3D 0;
 	pgoff_t index =3D pos >> PAGE_CACHE_SHIFT;
 	uint32_t pageofs =3D index << PAGE_CACHE_SHIFT;
 	int ret =3D 0;
=20
+	D1(printk(KERN_DEBUG "%s()\n", __func__));
+
+	if (pageofs > inode->i_size) {
+		ret =3D jffs2_reserve_space(c, sizeof(ri), &alloc_len,
+					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	mutex_lock(&f->sem);
 	pg =3D grab_cache_page_write_begin(mapping, index, flags);
-	if (!pg)
+	if (!pg) {
+		if (alloc_len)
+			jffs2_complete_reservation(c);
+		mutex_unlock(&f->sem);
 		return -ENOMEM;
+	}
 	*pagep =3D pg;
=20
-	D1(printk(KERN_DEBUG "jffs2_write_begin()\n"));
-
-	if (pageofs > inode->i_size) {
+	if (alloc_len) {
 		/* Make new hole frag from old EOF to new page */
-		struct jffs2_sb_info *c =3D JFFS2_SB_INFO(inode->i_sb);
-		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
-		uint32_t alloc_len;
=20
 		D1(printk(KERN_DEBUG "Writing new hole frag 0x%x-0x%x between current EO=
F and new page\n",
 			  (unsigned int)inode->i_size, pageofs));
=20
-		ret =3D jffs2_reserve_space(c, sizeof(ri), &alloc_len,
-					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
-		if (ret)
-			goto out_page;
-
-		mutex_lock(&f->sem);
 		memset(&ri, 0, sizeof(ri));
=20
 		ri.magic =3D cpu_to_je16(JFFS2_MAGIC_BITMASK);
@@ -188,7 +194,6 @@ static int jffs2_write_begin(struct file *filp, struct =
address_space *mapping,
 		if (IS_ERR(fn)) {
 			ret =3D PTR_ERR(fn);
 			jffs2_complete_reservation(c);
-			mutex_unlock(&f->sem);
 			goto out_page;
 		}
 		ret =3D jffs2_add_full_dnode_to_inode(c, f, fn);
@@ -202,12 +207,10 @@ static int jffs2_write_begin(struct file *filp, struc=
t address_space *mapping,
 			jffs2_mark_node_obsolete(c, fn->raw);
 			jffs2_free_full_dnode(fn);
 			jffs2_complete_reservation(c);
-			mutex_unlock(&f->sem);
 			goto out_page;
 		}
 		jffs2_complete_reservation(c);
 		inode->i_size =3D pageofs;
-		mutex_unlock(&f->sem);
 	}
=20
 	/*
@@ -216,18 +219,18 @@ static int jffs2_write_begin(struct file *filp, struc=
t address_space *mapping,
 	 * case of a short-copy.
 	 */
 	if (!PageUptodate(pg)) {
-		mutex_lock(&f->sem);
 		ret =3D jffs2_do_readpage_nolock(inode, pg);
-		mutex_unlock(&f->sem);
 		if (ret)
 			goto out_page;
 	}
+	mutex_unlock(&f->sem);
 	D1(printk(KERN_DEBUG "end write_begin(). pg->flags %lx\n", pg->flags));
 	return ret;
=20
 out_page:
 	unlock_page(pg);
 	page_cache_release(pg);
+	mutex_unlock(&f->sem);
 	return ret;
 }
=20
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 5809abb..fe677c0 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1788,8 +1788,9 @@ int reiserfs_new_inode(struct reiserfs_transaction_ha=
ndle *th,
=20
 	BUG_ON(!th->t_trans_id);
=20
-	dquot_initialize(inode);
+	reiserfs_write_unlock(inode->i_sb);
 	err =3D dquot_alloc_inode(inode);
+	reiserfs_write_lock(inode->i_sb);
 	if (err)
 		goto out_end_trans;
 	if (!dir->i_nlink) {
@@ -1985,8 +1986,10 @@ int reiserfs_new_inode(struct reiserfs_transaction_h=
andle *th,
=20
       out_end_trans:
 	journal_end(th, th->t_super, th->t_blocks_allocated);
+	reiserfs_write_unlock(inode->i_sb);
 	/* Drop can be outside and it needs more credits so it's better to have i=
t outside */
 	dquot_drop(inode);
+	reiserfs_write_lock(inode->i_sb);
 	inode->i_flags |=3D S_NOQUOTA;
 	make_bad_inode(inode);
=20
@@ -3109,10 +3112,9 @@ int reiserfs_setattr(struct dentry *dentry, struct i=
attr *attr)
 	/* must be turned off for recursive notify_change calls */
 	ia_valid =3D attr->ia_valid &=3D ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
=20
-	depth =3D reiserfs_write_lock_once(inode->i_sb);
 	if (is_quota_modification(inode, attr))
 		dquot_initialize(inode);
-
+	depth =3D reiserfs_write_lock_once(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
 		 ** done for us in vmtruncate
@@ -3176,7 +3178,9 @@ int reiserfs_setattr(struct dentry *dentry, struct ia=
ttr *attr)
 		error =3D journal_begin(&th, inode->i_sb, jbegin_count);
 		if (error)
 			goto out;
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 		error =3D dquot_transfer(inode, attr);
+		depth =3D reiserfs_write_lock_once(inode->i_sb);
 		if (error) {
 			journal_end(&th, inode->i_sb, jbegin_count);
 			goto out;
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 313d39d..3ae9926 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1968,7 +1968,9 @@ int reiserfs_paste_into_item(struct reiserfs_transact=
ion_handle *th, struct tree
 		       key2type(&(key->on_disk_key)));
 #endif
=20
+	reiserfs_write_unlock(inode->i_sb);
 	retval =3D dquot_alloc_space_nodirty(inode, pasted_size);
+	reiserfs_write_lock(inode->i_sb);
 	if (retval) {
 		pathrelse(search_path);
 		return retval;
@@ -2061,9 +2063,11 @@ int reiserfs_insert_item(struct reiserfs_transaction=
_handle *th,
 			       "reiserquota insert_item(): allocating %u id=3D%u type=3D%c",
 			       quota_bytes, inode->i_uid, head2type(ih));
 #endif
+		reiserfs_write_unlock(inode->i_sb);
 		/* We can't dirty inode here. It would be immediately written but
 		 * appropriate stat item isn't inserted yet... */
 		retval =3D dquot_alloc_space_nodirty(inode, quota_bytes);
+		reiserfs_write_lock(inode->i_sb);
 		if (retval) {
 			pathrelse(path);
 			return retval;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 5e3527b..569498a 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -254,7 +254,9 @@ static int finish_unfinished(struct super_block *s)
 			retval =3D remove_save_link_only(s, &save_link_key, 0);
 			continue;
 		}
+		reiserfs_write_unlock(s);
 		dquot_initialize(inode);
+		reiserfs_write_lock(s);
=20
 		if (truncate && S_ISDIR(inode->i_mode)) {
 			/* We got a truncate request for a dir which is impossible.
@@ -1207,7 +1209,7 @@ static int reiserfs_remount(struct super_block *s, in=
t *mount_flags, char *arg)
 				kfree(qf_names[i]);
 #endif
 		err =3D -EINVAL;
-		goto out_err;
+		goto out_unlock;
 	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
@@ -1250,7 +1252,7 @@ static int reiserfs_remount(struct super_block *s, in=
t *mount_flags, char *arg)
 	if (blocks) {
 		err =3D reiserfs_resize(s, blocks);
 		if (err !=3D 0)
-			goto out_err;
+			goto out_unlock;
 	}
=20
 	if (*mount_flags & MS_RDONLY) {
@@ -1260,9 +1262,15 @@ static int reiserfs_remount(struct super_block *s, i=
nt *mount_flags, char *arg)
 			/* it is read-only already */
 			goto out_ok;
=20
+		/*
+		 * Drop write lock. Quota will retake it when needed and lock
+		 * ordering requires calling dquot_suspend() without it.
+		 */
+		reiserfs_write_unlock(s);
 		err =3D dquot_suspend(s, -1);
 		if (err < 0)
 			goto out_err;
+		reiserfs_write_lock(s);
=20
 		/* try to remount file system with read-only permissions */
 		if (sb_umount_state(rs) =3D=3D REISERFS_VALID_FS
@@ -1272,7 +1280,7 @@ static int reiserfs_remount(struct super_block *s, in=
t *mount_flags, char *arg)
=20
 		err =3D journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
=20
 		/* Mounting a rw partition read-only. */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1287,7 +1295,7 @@ static int reiserfs_remount(struct super_block *s, in=
t *mount_flags, char *arg)
=20
 		if (reiserfs_is_journal_aborted(journal)) {
 			err =3D journal->j_errno;
-			goto out_err;
+			goto out_unlock;
 		}
=20
 		handle_data_mode(s, mount_options);
@@ -1296,7 +1304,7 @@ static int reiserfs_remount(struct super_block *s, in=
t *mount_flags, char *arg)
 		s->s_flags &=3D ~MS_RDONLY;	/* now it is safe to call journal_begin */
 		err =3D journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
=20
 		/* Mount a partition which is read-only, read-write */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1313,11 +1321,17 @@ static int reiserfs_remount(struct super_block *s, =
int *mount_flags, char *arg)
 	SB_JOURNAL(s)->j_must_wait =3D 1;
 	err =3D journal_end(&th, s, 10);
 	if (err)
-		goto out_err;
+		goto out_unlock;
 	s->s_dirt =3D 0;
=20
 	if (!(*mount_flags & MS_RDONLY)) {
+		/*
+		 * Drop write lock. Quota will retake it when needed and lock
+		 * ordering requires calling dquot_resume() without it.
+		 */
+		reiserfs_write_unlock(s);
 		dquot_resume(s, -1);
+		reiserfs_write_lock(s);
 		finish_unfinished(s);
 		reiserfs_xattr_init(s, *mount_flags);
 	}
@@ -1327,9 +1341,10 @@ out_ok:
 	reiserfs_write_unlock(s);
 	return 0;
=20
+out_unlock:
+	reiserfs_write_unlock(s);
 out_err:
 	kfree(new_opts);
-	reiserfs_write_unlock(s);
 	return err;
 }
=20
@@ -1953,13 +1968,15 @@ static int reiserfs_write_dquot(struct dquot *dquot=
)
 			  REISERFS_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
 	if (ret)
 		goto out;
+	reiserfs_write_unlock(dquot->dq_sb);
 	ret =3D dquot_commit(dquot);
+	reiserfs_write_lock(dquot->dq_sb);
 	err =3D
 	    journal_end(&th, dquot->dq_sb,
 			REISERFS_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
 	if (!ret && err)
 		ret =3D err;
-      out:
+out:
 	reiserfs_write_unlock(dquot->dq_sb);
 	return ret;
 }
@@ -1975,13 +1992,15 @@ static int reiserfs_acquire_dquot(struct dquot *dqu=
ot)
 			  REISERFS_QUOTA_INIT_BLOCKS(dquot->dq_sb));
 	if (ret)
 		goto out;
+	reiserfs_write_unlock(dquot->dq_sb);
 	ret =3D dquot_acquire(dquot);
+	reiserfs_write_lock(dquot->dq_sb);
 	err =3D
 	    journal_end(&th, dquot->dq_sb,
 			REISERFS_QUOTA_INIT_BLOCKS(dquot->dq_sb));
 	if (!ret && err)
 		ret =3D err;
-      out:
+out:
 	reiserfs_write_unlock(dquot->dq_sb);
 	return ret;
 }
@@ -1995,19 +2014,21 @@ static int reiserfs_release_dquot(struct dquot *dqu=
ot)
 	ret =3D
 	    journal_begin(&th, dquot->dq_sb,
 			  REISERFS_QUOTA_DEL_BLOCKS(dquot->dq_sb));
+	reiserfs_write_unlock(dquot->dq_sb);
 	if (ret) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
 		goto out;
 	}
 	ret =3D dquot_release(dquot);
+	reiserfs_write_lock(dquot->dq_sb);
 	err =3D
 	    journal_end(&th, dquot->dq_sb,
 			REISERFS_QUOTA_DEL_BLOCKS(dquot->dq_sb));
 	if (!ret && err)
 		ret =3D err;
-      out:
 	reiserfs_write_unlock(dquot->dq_sb);
+out:
 	return ret;
 }
=20
@@ -2032,11 +2053,13 @@ static int reiserfs_write_info(struct super_block *=
sb, int type)
 	ret =3D journal_begin(&th, sb, 2);
 	if (ret)
 		goto out;
+	reiserfs_write_unlock(sb);
 	ret =3D dquot_commit_info(sb, type);
+	reiserfs_write_lock(sb);
 	err =3D journal_end(&th, sb, 2);
 	if (!ret && err)
 		ret =3D err;
-      out:
+out:
 	reiserfs_write_unlock(sb);
 	return ret;
 }
@@ -2060,8 +2083,11 @@ static int reiserfs_quota_on(struct super_block *sb,=
 int type, int format_id,
 	struct inode *inode;
 	struct reiserfs_transaction_handle th;
=20
-	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
-		return -EINVAL;
+	reiserfs_write_lock(sb);
+	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA))) {
+		err =3D -EINVAL;
+		goto out;
+	}
=20
 	/* Quotafile not on the same filesystem? */
 	if (path->mnt->mnt_sb !=3D sb) {
@@ -2103,8 +2129,10 @@ static int reiserfs_quota_on(struct super_block *sb,=
 int type, int format_id,
 		if (err)
 			goto out;
 	}
-	err =3D dquot_quota_on(sb, type, format_id, path);
+	reiserfs_write_unlock(sb);
+	return dquot_quota_on(sb, type, format_id, path);
 out:
+	reiserfs_write_unlock(sb);
 	return err;
 }
=20
@@ -2178,7 +2206,9 @@ static ssize_t reiserfs_quota_write(struct super_bloc=
k *sb, int type,
 		tocopy =3D sb->s_blocksize - offset < towrite ?
 		    sb->s_blocksize - offset : towrite;
 		tmp_bh.b_state =3D 0;
+		reiserfs_write_lock(sb);
 		err =3D reiserfs_get_block(inode, blk, &tmp_bh, GET_BLOCK_CREATE);
+		reiserfs_write_unlock(sb);
 		if (err)
 			goto out;
 		if (offset || tocopy !=3D sb->s_blocksize)
@@ -2194,10 +2224,12 @@ static ssize_t reiserfs_quota_write(struct super_bl=
ock *sb, int type,
 		flush_dcache_page(bh->b_page);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
+		reiserfs_write_lock(sb);
 		reiserfs_prepare_for_journal(sb, bh, 1);
 		journal_mark_dirty(current->journal_info, sb, bh);
 		if (!journal_quota)
 			reiserfs_add_ordered_list(inode, bh);
+		reiserfs_write_unlock(sb);
 		brelse(bh);
 		offset =3D 0;
 		towrite -=3D tocopy;
diff --git a/fs/ubifs/find.c b/fs/ubifs/find.c
index 2559d17..5dc48ca 100644
--- a/fs/ubifs/find.c
+++ b/fs/ubifs/find.c
@@ -681,8 +681,16 @@ int ubifs_find_free_leb_for_idx(struct ubifs_info *c)
 	if (!lprops) {
 		lprops =3D ubifs_fast_find_freeable(c);
 		if (!lprops) {
-			ubifs_assert(c->freeable_cnt =3D=3D 0);
-			if (c->lst.empty_lebs - c->lst.taken_empty_lebs > 0) {
+			/*
+			 * The first condition means the following: go scan the
+			 * LPT if there are uncategorized lprops, which means
+			 * there may be freeable LEBs there (UBIFS does not
+			 * store the information about freeable LEBs in the
+			 * master node).
+			 */
+			if (c->in_a_category_cnt !=3D c->main_lebs ||
+			    c->lst.empty_lebs - c->lst.taken_empty_lebs > 0) {
+				ubifs_assert(c->freeable_cnt =3D=3D 0);
 				lprops =3D scan_for_leb_for_idx(c);
 				if (IS_ERR(lprops)) {
 					err =3D PTR_ERR(lprops);
diff --git a/fs/ubifs/lprops.c b/fs/ubifs/lprops.c
index f8a181e..ea9d491 100644
--- a/fs/ubifs/lprops.c
+++ b/fs/ubifs/lprops.c
@@ -300,8 +300,11 @@ void ubifs_add_to_cat(struct ubifs_info *c, struct ubi=
fs_lprops *lprops,
 	default:
 		ubifs_assert(0);
 	}
+
 	lprops->flags &=3D ~LPROPS_CAT_MASK;
 	lprops->flags |=3D cat;
+	c->in_a_category_cnt +=3D 1;
+	ubifs_assert(c->in_a_category_cnt <=3D c->main_lebs);
 }
=20
 /**
@@ -334,6 +337,9 @@ static void ubifs_remove_from_cat(struct ubifs_info *c,
 	default:
 		ubifs_assert(0);
 	}
+
+	c->in_a_category_cnt -=3D 1;
+	ubifs_assert(c->in_a_category_cnt >=3D 0);
 }
=20
 /**
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 27f2255..8bbc99e 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1187,6 +1187,8 @@ struct ubifs_debug_info;
  * @freeable_list: list of freeable non-index LEBs (free + dirty =3D=3D @l=
eb_size)
  * @frdi_idx_list: list of freeable index LEBs (free + dirty =3D=3D @leb_s=
ize)
  * @freeable_cnt: number of freeable LEBs in @freeable_list
+ * @in_a_category_cnt: count of lprops which are in a certain category, wh=
ich
+ *                     basically meants that they were loaded from the fla=
sh
  *
  * @ltab_lnum: LEB number of LPT's own lprops table
  * @ltab_offs: offset of LPT's own lprops table
@@ -1416,6 +1418,7 @@ struct ubifs_info {
 	struct list_head freeable_list;
 	struct list_head frdi_idx_list;
 	int freeable_cnt;
+	int in_a_category_cnt;
=20
 	int ltab_lnum;
 	int ltab_offs;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cf0ac05..2f5a8f7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1167,9 +1167,14 @@ xfs_buf_bio_end_io(
 {
 	xfs_buf_t		*bp =3D (xfs_buf_t *)bio->bi_private;
=20
-	xfs_buf_ioerror(bp, -error);
+	/*
+	 * don't overwrite existing errors - otherwise we can lose errors on
+	 * buffers that require multiple bios to complete.
+	 */
+	if (!bp->b_error)
+		xfs_buf_ioerror(bp, -error);
=20
-	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
=20
 	_xfs_buf_ioend(bp, 1);
@@ -1245,6 +1250,11 @@ next_chunk:
 		if (size)
 			goto next_chunk;
 	} else {
+		/*
+		 * This is guaranteed not to be the last io reference count
+		 * because the caller (xfs_buf_iorequest) holds a count itself.
+		 */
+		atomic_dec(&bp->b_io_remaining);
 		xfs_buf_ioerror(bp, EIO);
 		bio_put(bio);
 	}
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_ker=
nel.h
index dd2e44f..9d709d1 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -50,7 +50,8 @@ struct ptp_clock_request {
  * clock operations
  *
  * @adjfreq:  Adjusts the frequency of the hardware clock.
- *            parameter delta: Desired period change in parts per billion.
+ *            parameter delta: Desired frequency offset from nominal frequ=
ency
+ *            in parts per billion
  *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.
diff --git a/kernel/futex.c b/kernel/futex.c
index 80fb1c6..77bccfc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -716,7 +716,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, stru=
ct futex_hash_bucket *hb,
 				struct futex_pi_state **ps,
 				struct task_struct *task, int set_waiters)
 {
-	int lock_taken, ret, ownerdied =3D 0;
+	int lock_taken, ret, force_take =3D 0;
 	u32 uval, newval, curval, vpid =3D task_pid_vnr(task);
=20
 retry:
@@ -755,17 +755,15 @@ retry:
 	newval =3D curval | FUTEX_WAITERS;
=20
 	/*
-	 * There are two cases, where a futex might have no owner (the
-	 * owner TID is 0): OWNER_DIED. We take over the futex in this
-	 * case. We also do an unconditional take over, when the owner
-	 * of the futex died.
-	 *
-	 * This is safe as we are protected by the hash bucket lock !
+	 * Should we force take the futex? See below.
 	 */
-	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
-		/* Keep the OWNER_DIED bit */
+	if (unlikely(force_take)) {
+		/*
+		 * Keep the OWNER_DIED and the WAITERS bit and set the
+		 * new TID value.
+		 */
 		newval =3D (curval & ~FUTEX_TID_MASK) | vpid;
-		ownerdied =3D 0;
+		force_take =3D 0;
 		lock_taken =3D 1;
 	}
=20
@@ -775,7 +773,7 @@ retry:
 		goto retry;
=20
 	/*
-	 * We took the lock due to owner died take over.
+	 * We took the lock due to forced take over.
 	 */
 	if (unlikely(lock_taken))
 		return 1;
@@ -790,20 +788,25 @@ retry:
 		switch (ret) {
 		case -ESRCH:
 			/*
-			 * No owner found for this futex. Check if the
-			 * OWNER_DIED bit is set to figure out whether
-			 * this is a robust futex or not.
+			 * We failed to find an owner for this
+			 * futex. So we have no pi_state to block
+			 * on. This can happen in two cases:
+			 *
+			 * 1) The owner died
+			 * 2) A stale FUTEX_WAITERS bit
+			 *
+			 * Re-read the futex value.
 			 */
 			if (get_futex_value_locked(&curval, uaddr))
 				return -EFAULT;
=20
 			/*
-			 * We simply start over in case of a robust
-			 * futex. The code above will take the futex
-			 * and return happy.
+			 * If the owner died or we have a stale
+			 * WAITERS bit the owner TID in the user space
+			 * futex is 0.
 			 */
-			if (curval & FUTEX_OWNER_DIED) {
-				ownerdied =3D 1;
+			if (!(curval & FUTEX_TID_MASK)) {
+				force_take =3D 1;
 				goto retry;
 			}
 		default:
@@ -840,6 +843,9 @@ static void wake_futex(struct futex_q *q)
 {
 	struct task_struct *p =3D q->task;
=20
+	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
+		return;
+
 	/*
 	 * We set q->lock_ptr =3D NULL _before_ we wake up the task. If
 	 * a non-futex wake up happens on another CPU then the task
@@ -1075,6 +1081,10 @@ retry_private:
=20
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key1)) {
+			if (this->pi_state || this->rt_waiter) {
+				ret =3D -EINVAL;
+				goto out_unlock;
+			}
 			wake_futex(this);
 			if (++ret >=3D nr_wake)
 				break;
@@ -1087,6 +1097,10 @@ retry_private:
 		op_ret =3D 0;
 		plist_for_each_entry_safe(this, next, head, list) {
 			if (match_futex (&this->key, &key2)) {
+				if (this->pi_state || this->rt_waiter) {
+					ret =3D -EINVAL;
+					goto out_unlock;
+				}
 				wake_futex(this);
 				if (++op_ret >=3D nr_wake2)
 					break;
@@ -1095,6 +1109,7 @@ retry_private:
 		ret +=3D op_ret;
 	}
=20
+out_unlock:
 	double_unlock_hb(hb1, hb2);
 out_put_keys:
 	put_futex_key(&key2);
@@ -1384,9 +1399,13 @@ retry_private:
 		/*
 		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
 		 * be paired with each other and no other futex ops.
+		 *
+		 * We should never be requeueing a futex_q with a pi_state,
+		 * which is awaiting a futex_unlock_pi().
 		 */
 		if ((requeue_pi && !this->rt_waiter) ||
-		    (!requeue_pi && this->rt_waiter)) {
+		    (!requeue_pi && this->rt_waiter) ||
+		    this->pi_state) {
 			ret =3D -EINVAL;
 			break;
 		}
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1d7bca7..a8bc4d9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -113,7 +113,7 @@ static unsigned long get_timestamp(int this_cpu)
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~=3D 10^9 */
 }
=20
-static unsigned long get_sample_period(void)
+static u64 get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -121,7 +121,7 @@ static unsigned long get_sample_period(void)
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
=20
 /* Commands for resetting the watchdog */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 43a19c5..d551d5f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2052,8 +2052,10 @@ static int rescuer_thread(void *__wq)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
=20
-	if (kthread_should_stop())
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
 		return 0;
+	}
=20
 	/*
 	 * See whether any cpu is asking for help.  Unbounded
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c8425b1..d027a24 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1457,17 +1457,26 @@ static int mem_cgroup_count_children(struct mem_cgr=
oup *memcg)
 u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 {
 	u64 limit;
-	u64 memsw;
=20
 	limit =3D res_counter_read_u64(&memcg->res, RES_LIMIT);
-	limit +=3D total_swap_pages << PAGE_SHIFT;
=20
-	memsw =3D res_counter_read_u64(&memcg->memsw, RES_LIMIT);
 	/*
-	 * If memsw is finite and limits the amount of swap space available
-	 * to this memcg, return that limit.
+	 * Do not consider swap space if we cannot swap due to swappiness
 	 */
-	return min(limit, memsw);
+	if (mem_cgroup_swappiness(memcg)) {
+		u64 memsw;
+
+		limit +=3D total_swap_pages << PAGE_SHIFT;
+		memsw =3D res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+
+		/*
+		 * If memsw is finite and limits the amount of swap space
+		 * available to this memcg, return that limit.
+		 */
+		limit =3D min(limit, memsw);
+	}
+
+	return limit;
 }
=20
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5bd5bb1..1b03878 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1475,9 +1475,17 @@ int soft_offline_page(struct page *page, int flags)
 {
 	int ret;
 	unsigned long pfn =3D page_to_pfn(page);
+	struct page *hpage =3D compound_trans_head(page);
=20
 	if (PageHuge(page))
 		return soft_offline_huge_page(page, flags);
+	if (PageTransHuge(hpage)) {
+		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
+			pr_info("soft offline: %#lx: failed to split THP\n",
+				pfn);
+			return -EBUSY;
+		}
+	}
=20
 	ret =3D get_any_page(page, pfn, flags);
 	if (ret < 0)
diff --git a/mm/shmem.c b/mm/shmem.c
index 126ca35..2d46e23 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -595,7 +595,7 @@ static void shmem_evict_inode(struct inode *inode)
 		kfree(xattr->name);
 		kfree(xattr);
 	}
-	BUG_ON(inode->i_blocks);
+	WARN_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	end_writeback(inode);
 }
diff --git a/mm/sparse.c b/mm/sparse.c
index bf7d3cc..42935b5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -622,7 +622,7 @@ static void __kfree_section_memmap(struct page *memmap,=
 unsigned long nr_pages)
 {
 	return; /* XXX: Not implemented yet */
 }
-static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 }
 #else
@@ -663,10 +663,11 @@ static void __kfree_section_memmap(struct page *memma=
p, unsigned long nr_pages)
 			   get_order(sizeof(struct page) * nr_pages));
 }
=20
-static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
 	unsigned long magic;
+	struct page *page =3D virt_to_page(memmap);
=20
 	for (i =3D 0; i < nr_pages; i++, page++) {
 		magic =3D (unsigned long) page->lru.next;
@@ -715,13 +716,10 @@ static void free_section_usemap(struct page *memmap, =
unsigned long *usemap)
 	 */
=20
 	if (memmap) {
-		struct page *memmap_page;
-		memmap_page =3D virt_to_page(memmap);
-
 		nr_pages =3D PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
 			>> PAGE_SHIFT;
=20
-		free_map_bootmem(memmap_page, nr_pages);
+		free_map_bootmem(memmap, nr_pages);
 	}
 }
=20
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 313381c..1e4ee1a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2492,6 +2492,19 @@ unsigned long try_to_free_mem_cgroup_pages(struct me=
m_cgroup *mem_cont,
 }
 #endif
=20
+static bool zone_balanced(struct zone *zone, int order,
+			  unsigned long balance_gap, int classzone_idx)
+{
+	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
+				    balance_gap, classzone_idx, 0))
+		return false;
+
+	if (COMPACTION_BUILD && order && !compaction_suitable(zone, order))
+		return false;
+
+	return true;
+}
+
 /*
  * pgdat_balanced is used when checking if a node is balanced for high-ord=
er
  * allocations. Only zones that meet watermarks and are in a zone allowed
@@ -2551,8 +2564,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, in=
t order, long remaining,
 			continue;
 		}
=20
-		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							i, 0))
+		if (!zone_balanced(zone, order, 0, i))
 			all_zones_ok =3D false;
 		else
 			balanced +=3D zone->present_pages;
@@ -2655,8 +2667,7 @@ loop_again:
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
=20
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone), 0, 0)) {
+			if (!zone_balanced(zone, order, 0, 0)) {
 				end_zone =3D i;
 				break;
 			} else {
@@ -2717,9 +2728,8 @@ loop_again:
 				(zone->present_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone) + balance_gap,
-					end_zone, 0)) {
+			if (!zone_balanced(zone, order,
+					   balance_gap, end_zone)) {
 				shrink_zone(priority, zone, &sc);
=20
 				reclaim_state->reclaimed_slab =3D 0;
@@ -2746,8 +2756,7 @@ loop_again:
 				continue;
 			}
=20
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone), end_zone, 0)) {
+			if (!zone_balanced(zone, order, 0, end_zone)) {
 				all_zones_ok =3D 0;
 				/*
 				 * We are still under min water mark.  This
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 151b773..3910c1f 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1084,6 +1084,9 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head=
, struct msghdr *msg,
 		op->sk =3D sk;
 		op->ifindex =3D ifindex;
=20
+		/* ifindex for timeout events w/o previous frame reception */
+		op->rx_ifindex =3D ifindex;
+
 		/* initialize uninitialized (kzalloc) structure */
 		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		op->timer.function =3D bcm_rx_timeout_handler;
diff --git a/net/core/dev.c b/net/core/dev.c
index 480be72..2aac4ec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2829,8 +2829,10 @@ static int get_rps_cpu(struct net_device *dev, struc=
t sk_buff *skb,
 		if (unlikely(tcpu !=3D next_cpu) &&
 		    (tcpu =3D=3D RPS_NO_CPU || !cpu_online(tcpu) ||
 		     ((int)(per_cpu(softnet_data, tcpu).input_queue_head -
-		      rflow->last_qtail)) >=3D 0))
+		      rflow->last_qtail)) >=3D 0)) {
+			tcpu =3D next_cpu;
 			rflow =3D set_rps_cpu(dev, skb, rflow, next_cpu);
+		}
=20
 		if (tcpu !=3D RPS_NO_CPU && cpu_online(tcpu)) {
 			*rflowp =3D rflow;
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 277faef..0387da0 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -308,7 +308,8 @@ int dev_addr_del(struct net_device *dev, unsigned char =
*addr,
 	 */
 	ha =3D list_first_entry(&dev->dev_addrs.list,
 			      struct netdev_hw_addr, list);
-	if (ha->addr =3D=3D dev->dev_addr && ha->refcount =3D=3D 1)
+	if (!memcmp(ha->addr, addr, dev->addr_len) &&
+	    ha->type =3D=3D addr_type && ha->refcount =3D=3D 1)
 		return -ENOENT;
=20
 	err =3D __hw_addr_del(&dev->dev_addrs, addr, dev->addr_len,
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 09ff51b..0106d25 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -468,18 +468,27 @@ static int do_ip_setsockopt(struct sock *sk, int leve=
l,
 	struct inet_sock *inet =3D inet_sk(sk);
 	int val =3D 0, err;
=20
-	if (((1<<optname) & ((1<<IP_PKTINFO) | (1<<IP_RECVTTL) |
-			     (1<<IP_RECVOPTS) | (1<<IP_RECVTOS) |
-			     (1<<IP_RETOPTS) | (1<<IP_TOS) |
-			     (1<<IP_TTL) | (1<<IP_HDRINCL) |
-			     (1<<IP_MTU_DISCOVER) | (1<<IP_RECVERR) |
-			     (1<<IP_ROUTER_ALERT) | (1<<IP_FREEBIND) |
-			     (1<<IP_PASSSEC) | (1<<IP_TRANSPARENT) |
-			     (1<<IP_MINTTL) | (1<<IP_NODEFRAG))) ||
-	    optname =3D=3D IP_MULTICAST_TTL ||
-	    optname =3D=3D IP_MULTICAST_ALL ||
-	    optname =3D=3D IP_MULTICAST_LOOP ||
-	    optname =3D=3D IP_RECVORIGDSTADDR) {
+	switch (optname) {
+	case IP_PKTINFO:
+	case IP_RECVTTL:
+	case IP_RECVOPTS:
+	case IP_RECVTOS:
+	case IP_RETOPTS:
+	case IP_TOS:
+	case IP_TTL:
+	case IP_HDRINCL:
+	case IP_MTU_DISCOVER:
+	case IP_RECVERR:
+	case IP_ROUTER_ALERT:
+	case IP_FREEBIND:
+	case IP_PASSSEC:
+	case IP_TRANSPARENT:
+	case IP_MINTTL:
+	case IP_NODEFRAG:
+	case IP_MULTICAST_TTL:
+	case IP_MULTICAST_ALL:
+	case IP_MULTICAST_LOOP:
+	case IP_RECVORIGDSTADDR:
 		if (optlen >=3D sizeof(int)) {
 			if (get_user(val, (int __user *) optval))
 				return -EFAULT;
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf=
_nat_standalone.c
index 9290048..e32b542 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -194,7 +194,8 @@ nf_nat_out(unsigned int hooknum,
=20
 		if ((ct->tuplehash[dir].tuple.src.u3.ip !=3D
 		     ct->tuplehash[!dir].tuple.dst.u3.ip) ||
-		    (ct->tuplehash[dir].tuple.src.u.all !=3D
+		    (ct->tuplehash[dir].tuple.dst.protonum !=3D IPPROTO_ICMP &&
+		     ct->tuplehash[dir].tuple.src.u.all !=3D
 		     ct->tuplehash[!dir].tuple.dst.u.all)
 		   )
 			return ip_xfrm_me_harder(skb) =3D=3D 0 ? ret : NF_DROP;
@@ -230,7 +231,8 @@ nf_nat_local_fn(unsigned int hooknum,
 				ret =3D NF_DROP;
 		}
 #ifdef CONFIG_XFRM
-		else if (ct->tuplehash[dir].tuple.dst.u.all !=3D
+		else if (ct->tuplehash[dir].tuple.dst.protonum !=3D IPPROTO_ICMP &&
+			 ct->tuplehash[dir].tuple.dst.u.all !=3D
 			 ct->tuplehash[!dir].tuple.src.u.all)
 			if (ip_xfrm_me_harder(skb))
 				ret =3D NF_DROP;
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 26cb08c..b204df8 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -798,6 +798,7 @@ pref_skip_coa:
 		if (val < 0 || val > 255)
 			goto e_inval;
 		np->min_hopcount =3D val;
+		retv =3D 0;
 		break;
 	case IPV6_DONTFRAG:
 		np->dontfrag =3D valbool;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8c7364b..9e20cb8 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -965,10 +965,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data =
*sdata)
=20
 	mutex_lock(&sdata->u.ibss.mtx);
=20
-	sdata->u.ibss.state =3D IEEE80211_IBSS_MLME_SEARCH;
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len =3D 0;
-
 	active_ibss =3D ieee80211_sta_active_ibss(sdata);
=20
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -989,6 +985,10 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data =
*sdata)
 		}
 	}
=20
+	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
+	memset(ifibss->bssid, 0, ETH_ALEN);
+	ifibss->ssid_len =3D 0;
+
 	sta_info_flush(sdata->local, sdata);
=20
 	/* remove beacon */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1fdd8ff..1c775f0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1129,6 +1129,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info =
*sta)
 	struct ieee80211_local *local =3D sdata->local;
 	struct sk_buff_head pending;
 	int filtered =3D 0, buffered =3D 0, ac;
+	unsigned long flags;
=20
 	clear_sta_flag(sta, WLAN_STA_SP);
=20
@@ -1144,12 +1145,16 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_inf=
o *sta)
 	for (ac =3D 0; ac < IEEE80211_NUM_ACS; ac++) {
 		int count =3D skb_queue_len(&pending), tmp;
=20
+		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->tx_filtered[ac], &pending);
+		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
 		tmp =3D skb_queue_len(&pending);
 		filtered +=3D tmp - count;
 		count =3D tmp;
=20
+		spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->ps_tx_buf[ac], &pending);
+		spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
 		tmp =3D skb_queue_len(&pending);
 		buffered +=3D tmp - count;
 	}
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conn=
track_proto_tcp.c
index 8235b86..57ad466 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -159,21 +159,18 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MA=
X] =3D {
  *	sCL -> sSS
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
-/*synack*/ { sIV, sIV, sIG, sIG, sIG, sIG, sIG, sIG, sIG, sSR },
+/*synack*/ { sIV, sIV, sSR, sIV, sIV, sIV, sIV, sIV, sIV, sSR },
 /*
  *	sNO -> sIV	Too late and no reason to do anything
  *	sSS -> sIV	Client can't send SYN and then SYN/ACK
  *	sS2 -> sSR	SYN/ACK sent to SYN2 in simultaneous open
- *	sSR -> sIG
- *	sES -> sIG	Error: SYNs in window outside the SYN_SENT state
- *			are errors. Receiver will reply with RST
- *			and close the connection.
- *			Or we are not in sync and hold a dead connection.
- *	sFW -> sIG
- *	sCW -> sIG
- *	sLA -> sIG
- *	sTW -> sIG
- *	sCL -> sIG
+ *	sSR -> sSR	Late retransmitted SYN/ACK in simultaneous open
+ *	sES -> sIV	Invalid SYN/ACK packets sent by the client
+ *	sFW -> sIV
+ *	sCW -> sIV
+ *	sLA -> sIV
+ *	sTW -> sIV
+ *	sCL -> sIV
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
 /*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
@@ -628,15 +625,9 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		ack =3D sack =3D receiver->td_end;
 	}
=20
-	if (seq =3D=3D end
-	    && (!tcph->rst
-		|| (seq =3D=3D 0 && state->state =3D=3D TCP_CONNTRACK_SYN_SENT)))
+	if (tcph->rst && seq =3D=3D 0 && state->state =3D=3D TCP_CONNTRACK_SYN_SE=
NT)
 		/*
-		 * Packets contains no data: we assume it is valid
-		 * and check the ack value only.
-		 * However RST segments are always validated by their
-		 * SEQ number, except when seq =3D=3D 0 (reset sent answering
-		 * SYN.
+		 * RST sent answering SYN.
 		 */
 		seq =3D end =3D sender->td_end;
=20
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fa39731..0b08905 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -125,9 +125,8 @@ static const struct ieee80211_regdomain world_regdom =
=3D {
 	.reg_rules =3D {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
-		/* IEEE 802.11b/g, channels 12..13. No HT40
-		 * channel fits here. */
-		REG_RULE(2467-10, 2472+10, 20, 6, 20,
+		/* IEEE 802.11b/g, channels 12..13. */
+		REG_RULE(2467-10, 2472+10, 40, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
 		/* IEEE 802.11 channel 14 - Only JP enables
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 4450fbe..92e24bb 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -202,8 +202,8 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
=20
 	dev_cgroup =3D cgroup_to_devcgroup(cgroup);
 	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del(&wh->list);
-		kfree(wh);
+		list_del_rcu(&wh->list);
+		kfree_rcu(wh, rcu);
 	}
 	kfree(dev_cgroup);
 }
@@ -278,7 +278,7 @@ static int may_access_whitelist(struct dev_cgroup *c,
 {
 	struct dev_whitelist_item *whitem;
=20
-	list_for_each_entry(whitem, &c->whitelist, list) {
+	list_for_each_entry_rcu(whitem, &c->whitelist, list) {
 		if (whitem->type & DEV_ALL)
 			return 1;
 		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 3bf46ab..46a5b81 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -174,7 +174,8 @@ static void sel_netnode_insert(struct sel_netnode *node=
)
 	if (sel_netnode_hash[idx].size =3D=3D SEL_NETNODE_HASH_BKT_LIMIT) {
 		struct sel_netnode *tail;
 		tail =3D list_entry(
-			rcu_dereference(sel_netnode_hash[idx].list.prev),
+			rcu_dereference_protected(sel_netnode_hash[idx].list.prev,
+						  lockdep_is_held(&sel_netnode_lock)),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
 		kfree_rcu(tail, rcu);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3ce2da2..1a09fbf 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6026,6 +6026,9 @@ static const struct hda_codec_preset snd_hda_preset_r=
ealtek[] =3D {
 	{ .id =3D 0x10ec0276, .name =3D "ALC276", .patch =3D patch_alc269 },
 	{ .id =3D 0x10ec0280, .name =3D "ALC280", .patch =3D patch_alc269 },
 	{ .id =3D 0x10ec0282, .name =3D "ALC282", .patch =3D patch_alc269 },
+	{ .id =3D 0x10ec0283, .name =3D "ALC283", .patch =3D patch_alc269 },
+	{ .id =3D 0x10ec0290, .name =3D "ALC290", .patch =3D patch_alc269 },
+	{ .id =3D 0x10ec0292, .name =3D "ALC292", .patch =3D patch_alc269 },
 	{ .id =3D 0x10ec0861, .rev =3D 0x100340, .name =3D "ALC660",
 	  .patch =3D patch_alc861 },
 	{ .id =3D 0x10ec0660, .name =3D "ALC660-VD", .patch =3D patch_alc861vd },
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 41ca4d9..f81b185 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -749,7 +749,7 @@ static int wm8978_hw_params(struct snd_pcm_substream *s=
ubstream,
 		wm8978->mclk_idx =3D -1;
 		f_sel =3D wm8978->f_mclk;
 	} else {
-		if (!wm8978->f_pllout) {
+		if (!wm8978->f_opclk) {
 			/* We only enter here, if OPCLK is not used */
 			int ret =3D wm8978_configure_pll(codec);
 			if (ret < 0)
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 0dc441c..b516488 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3009,7 +3009,7 @@ void snd_soc_dapm_shutdown(struct snd_soc_card *card)
 {
 	struct snd_soc_codec *codec;
=20
-	list_for_each_entry(codec, &card->codec_dev_list, list) {
+	list_for_each_entry(codec, &card->codec_dev_list, card_list) {
 		soc_dapm_shutdown_codec(&codec->dapm);
 		if (codec->dapm.bias_level =3D=3D SND_SOC_BIAS_STANDBY)
 			snd_soc_dapm_set_bias_level(&codec->dapm,
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index c83f614..eeefbce 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -148,6 +148,7 @@ struct snd_usb_midi_out_endpoint {
 		struct snd_usb_midi_out_endpoint* ep;
 		struct snd_rawmidi_substream *substream;
 		int active;
+		bool autopm_reference;
 		uint8_t cable;		/* cable number << 4 */
 		uint8_t state;
 #define STATE_UNKNOWN	0
@@ -1076,7 +1077,8 @@ static int snd_usbmidi_output_open(struct snd_rawmidi=
_substream *substream)
 		return -ENXIO;
 	}
 	err =3D usb_autopm_get_interface(umidi->iface);
-	if (err < 0)
+	port->autopm_reference =3D err >=3D 0;
+	if (err < 0 && err !=3D -EACCES)
 		return -EIO;
 	substream->runtime->private_data =3D port;
 	port->state =3D STATE_UNKNOWN;
@@ -1087,9 +1089,11 @@ static int snd_usbmidi_output_open(struct snd_rawmid=
i_substream *substream)
 static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substrea=
m)
 {
 	struct snd_usb_midi* umidi =3D substream->rmidi->private_data;
+	struct usbmidi_out_port *port =3D substream->runtime->private_data;
=20
 	substream_open(substream, 0);
-	usb_autopm_put_interface(umidi->iface);
+	if (port->autopm_reference)
+		usb_autopm_put_interface(umidi->iface);
 	return 0;
 }
=20



--=-9pn+kNL/DWNz8nlZmg8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMFFV+e/yOyVhhEJAQr5TQ//dXNKTRp9jcWmaGxjLaMTng6t7+jH0jIc
+YlRo3KU7Bk+CC9MhoyMStltHxu8QfQjRqZ45hIThBwBwPQhoGcbgVHjUQXVLA9N
L7eaY6a0v5CwyWlMua3ZmAT/zkrjcDqmg40Fs5t+gbpjzzEE3aLO40bezy/J3R6D
/ZtzIra0DbOzQnEJii7Wb3bzVXepFrBCQqMNURBk7FG63oaobMuUq4cmu6shSswY
3ABh3zLe6qhELTlKFKkAz5xtajj2XSq161nKZSS4qdmf62BADcch/cxljVe9xtW+
eJv7N3RlddseE1Ce3o5FVqw6FzCk2KIeK4Hf22Mv7W7r29lHZXr5p0JTfa+Vc4bX
/E2mvhgvV7Uftp1XczA5CcgOd3EKyht3Wh90FvTrkuWAxvlDohZNgMyDFDYyDxQT
15ls/w33zRGKUf6+afgWzgTE2J7xFRlDz9Vfq7hRShQ8jdwKvwQJH8HTTisUbPfO
YJIwaMPzg+HVFPbbaLQb2Eo6YlFA5k06ayUWa61xA4Af2QuF8cwsAimU1X4WiRmS
IJlZjhcrm/kq5+1m7NC2SVlUzJVrB2jNK/0Sk/xon37AiKI1tnloWBMfRFO8UJ+C
8KHhXZsF8nzh//3a4SUq/9LH1tWE+CnfvH6ptPVYcfUkzmSjQcaJ0NOWFrvj+yTz
mLYFCUkp5+k=
=jmih
-----END PGP SIGNATURE-----

--=-9pn+kNL/DWNz8nlZmg8Z--
