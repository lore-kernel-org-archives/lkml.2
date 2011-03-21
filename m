Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1CUQBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:01:39 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59980 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753539Ab1CUQBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:01:37 -0400
Date: Mon, 21 Mar 2011 11:01:35 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321160135.GA31562@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a problem seen on UV systems handling NMIs from the node controller.
The original code used the DIE notifier as the hook to get to the UV NMI
handler. This does not work if performance counters are active - the hw_perf
code consumes the NMI and the UV handler is not called.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
(This patch was needed to debug system hangs that occur only when running
performance tools (perf or oprofile) on large systems. Without the
patch the system hard hangs. Attempts to NMI the system or get into
a debugger fail. This patch allowed the problem to be debugger. The
hang will be fixed later)

I tried reordering notifier priorities so that the UV code was called first.
This can be made to work BUT requires knowledge in the UV nmi handler whether
any other NMI source is active. The UV NMI handler cannot return NOTIFY_STOP
if other NMI sources are active - if NOTIFY_STOP is returned, the other handlers
will not be called. I tried this reordering & hw_perf collection would ocassionally
hang due to a missed NMI. If the UV haandler returns NOTIFY_OK or NOTIFY_DONE
and hw_perf is NOT active, we get the "dazed & confused" messages.

I considered adding a NMI handling callout to x86_platform_ops. This
might be a cleaner approach. This would replace the UV-specific change
in traps.c. Thoughts???




 arch/x86/include/asm/uv/uv.h       |    2 
 arch/x86/include/asm/uv/uv_mmrs.h  |   16 ++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |   88 +++++++++++++++++++++++++++----------
 arch/x86/kernel/traps.c            |    6 ++
 4 files changed, 87 insertions(+), 25 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h	2011-03-21 09:05:43.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv.h	2011-03-21 09:06:20.313497084 -0500
@@ -13,6 +13,7 @@ extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
 extern void uv_system_init(void);
+extern int uv_handle_nmi(struct pt_regs *regs, unsigned char reason);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long va,
@@ -24,6 +25,7 @@ static inline enum uv_system_type get_uv
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
+static inline int uv_handle_nmi(struct pt_regs *regs, unsigned char reason)	{ return 0; }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long va, unsigned int cpu)
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2011-03-21 09:05:56.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2011-03-21 09:09:01.101557321 -0500
@@ -5,7 +5,7 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2011 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
@@ -1099,5 +1099,19 @@ union uvh_rtc1_int_config_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                               UVH_SCRATCH5                                */
+/* ========================================================================= */
+#define UVH_SCRATCH5 0x2d0200UL
+#define UVH_SCRATCH5_32 0x00778
+
+#define UVH_SCRATCH5_SCRATCH5_SHFT 0
+#define UVH_SCRATCH5_SCRATCH5_MASK 0xffffffffffffffffUL
+union uvh_scratch5_u {
+    unsigned long	v;
+    struct uvh_scratch5_s {
+	unsigned long	scratch5 : 64;  /* RW, W1CS */
+    } s;
+};
 
 #endif /* __ASM_UV_MMRS_X86_H__ */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-21 09:05:56.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-21 09:18:10.581558983 -0500
@@ -34,6 +34,12 @@
 #include <asm/ipi.h>
 #include <asm/smp.h>
 #include <asm/x86_init.h>
+#include <asm/perf_event.h>
+
+/* BMC sets this MMR non-zero before sending an NMI */
+#define UVH_NMI_MMR				UVH_SCRATCH5
+#define UVH_NMI_MMR_CLEAR			(UVH_NMI_MMR + 8)
+#define UV_NMI_PENDING_MASK			(1UL << 63)
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
@@ -48,6 +54,12 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+/* Should be part of uv_hub_info but that breas the KABI */
+static struct uv_nmi_info {
+	spinlock_t	nmi_lock;
+	unsigned long	nmi_count;
+} *uv_nmi_info;
+
 static unsigned long __init uv_early_read_mmr(unsigned long addr)
 {
 	unsigned long val, *mmr;
@@ -635,36 +647,60 @@ void __cpuinit uv_cpu_init(void)
 }
 
 /*
- * When NMI is received, print a stack trace.
+ * When an NMI from the BMC is received:
+ * 	- print a stack trace
  */
-int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
+DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
+static unsigned long last_nmi_jiffies;
+
+int uv_handle_nmi(struct pt_regs *regs, unsigned char reason)
 {
-	if (reason != DIE_NMIUNKNOWN)
-		return NOTIFY_OK;
+	unsigned long real_uv_nmi;
+	int blade;
 
 	if (in_crash_kexec)
 		/* do nothing if entering the crash kernel */
-		return NOTIFY_OK;
+		return 0;
+
 	/*
-	 * Use a lock so only one cpu prints at a time
-	 * to prevent intermixed output.
+	 * Each blade has an MMR that indicates when an NMI has been sent
+	 * to cpus on the blade. If an NMI is detected, atomically
+	 * clear the MMR and update a per-blade NMI count used to
+	 * cause each cpu on the blade to notice a new NMI.
+	 */
+	blade = uv_numa_blade_id();
+	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
+	if (unlikely(real_uv_nmi)) {
+		spin_lock(&uv_nmi_info[blade].nmi_lock);
+		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
+		if (real_uv_nmi) {
+			uv_nmi_info[blade].nmi_count++;
+			mb();
+			uv_write_local_mmr(UVH_NMI_MMR_CLEAR, UV_NMI_PENDING_MASK);
+		}
+		spin_unlock(&uv_nmi_info[blade].nmi_lock);
+	}
+
+	/*
+	 * Return "NMI handled" if an NMI has been seen within the preceeding
+	 * few seconds. This eliminates the "dazed.." message that can occur
+	 * if a hw_perf and BMC NMI are received at about the same time
+	 * and both events are processed with the first NMI.
+	 */
+	if (__get_cpu_var(cpu_last_nmi_count) == uv_nmi_info[blade].nmi_count)
+		return jiffies - last_nmi_jiffies < 10 * HZ;
+	__get_cpu_var(cpu_last_nmi_count) = uv_nmi_info[blade].nmi_count;
+
+	/*
+	 * Use a lock so only one cpu prints at a time.
+	 * This prevents intermixed output.
 	 */
 	spin_lock(&uv_nmi_lock);
-	pr_info("NMI stack dump cpu %u:\n", smp_processor_id());
+	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
 	dump_stack();
 	spin_unlock(&uv_nmi_lock);
-
-	return NOTIFY_STOP;
-}
-
-static struct notifier_block uv_dump_stack_nmi_nb = {
-	.notifier_call	= uv_handle_nmi
-};
-
-void uv_register_nmi_notifier(void)
-{
-	if (register_die_notifier(&uv_dump_stack_nmi_nb))
-		printk(KERN_WARNING "UV NMI handler failed to register\n");
+	last_nmi_jiffies = jiffies;
+	return 1;
 }
 
 void uv_nmi_init(void)
@@ -717,10 +753,17 @@ void __init uv_system_init(void)
 	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
-	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
+	uv_blade_info = kzalloc(bytes, GFP_KERNEL);
 	BUG_ON(!uv_blade_info);
-	for (blade = 0; blade < uv_num_possible_blades(); blade++)
+
+	bytes = sizeof(uv_nmi_info[0]) * num_possible_cpus();
+	uv_nmi_info = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_nmi_info);
+
+	for (blade = 0; blade < uv_num_possible_blades(); blade++) {
 		uv_blade_info[blade].memory_nid = -1;
+		spin_lock_init(&uv_nmi_info[blade].nmi_lock);
+	}
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
@@ -805,7 +848,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
-	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 
 	/* register Legacy VGA I/O redirection handler */
Index: linux/arch/x86/kernel/traps.c
===================================================================
--- linux.orig/arch/x86/kernel/traps.c	2011-03-21 09:05:43.000000000 -0500
+++ linux/arch/x86/kernel/traps.c	2011-03-21 09:13:01.306555675 -0500
@@ -57,6 +57,7 @@
 #include <asm/mce.h>
 
 #include <asm/mach_traps.h>
+#include <asm/uv/uv.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -397,13 +398,16 @@ unknown_nmi_error(unsigned char reason,
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
+	int handled;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
 	 * NMI, otherwise we may lose it, because the CPU-specific
 	 * NMI can not be detected/processed on other CPUs.
 	 */
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+	handled = uv_handle_nmi(regs, reason);
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
+	    		handled)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
