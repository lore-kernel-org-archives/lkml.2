Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1CUTXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:23:49 -0400
Received: from relay3.sgi.com ([192.48.152.1]:47834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751541Ab1CUTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:23:47 -0400
Date: Mon, 21 Mar 2011 14:23:45 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH V2] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321192345.GA31878@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <20110321165608.GA12718@sgi.com> <20110321180526.GB4849@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321180526.GB4849@elte.hu>
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
V2 - Use x86_platform_ops.

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


 arch/x86/include/asm/uv/uv_mmrs.h  |   16 ++++++
 arch/x86/include/asm/x86_init.h    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c |   90 +++++++++++++++++++++++++++----------
 arch/x86/kernel/traps.c            |    6 ++
 arch/x86/kernel/x86_init.c         |    2 
 5 files changed, 91 insertions(+), 25 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2011-03-21 14:04:49.629495972 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2011-03-21 14:04:52.485509905 -0500
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
Index: linux/arch/x86/include/asm/x86_init.h
===================================================================
--- linux.orig/arch/x86/include/asm/x86_init.h	2011-03-21 14:04:49.629495972 -0500
+++ linux/arch/x86/include/asm/x86_init.h	2011-03-21 14:04:52.489996907 -0500
@@ -7,6 +7,7 @@
 struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
+struct pt_regs;
 
 /**
  * struct x86_init_mpparse - platform specific mpparse ops
@@ -153,6 +154,7 @@ struct x86_platform_ops {
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
+	int (*nmi_handler)(struct pt_regs *regs);
 	int (*i8042_detect)(void);
 };
 
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-21 14:04:49.629495972 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-21 14:04:52.533571712 -0500
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
 
@@ -47,6 +53,13 @@ EXPORT_SYMBOL_GPL(uv_min_hub_revision_id
 unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
+static int uv_handle_nmi(struct pt_regs *regs);
+
+/* Should be part of uv_hub_info but that breas the KABI */
+static struct uv_nmi_info {
+	spinlock_t	nmi_lock;
+	unsigned long	nmi_count;
+} *uv_nmi_info;
 
 static unsigned long __init uv_early_read_mmr(unsigned long addr)
 {
@@ -115,6 +128,7 @@ static int __init uv_acpi_madt_oem_check
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
+		x86_platform.nmi_handler = uv_handle_nmi;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -635,36 +649,60 @@ void __cpuinit uv_cpu_init(void)
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
+static int uv_handle_nmi(struct pt_regs *regs)
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
@@ -717,10 +755,17 @@ void __init uv_system_init(void)
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
 
@@ -805,7 +850,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
-	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 
 	/* register Legacy VGA I/O redirection handler */
Index: linux/arch/x86/kernel/traps.c
===================================================================
--- linux.orig/arch/x86/kernel/traps.c	2011-03-21 14:04:49.629495972 -0500
+++ linux/arch/x86/kernel/traps.c	2011-03-21 14:08:44.609496310 -0500
@@ -55,6 +55,7 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 #include <asm/mce.h>
+#include <asm/x86_init.h>
 
 #include <asm/mach_traps.h>
 
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
+	handled = x86_platform.nmi_handler(regs);
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
+	    			handled)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
Index: linux/arch/x86/kernel/x86_init.c
===================================================================
--- linux.orig/arch/x86/kernel/x86_init.c	2011-03-21 14:04:49.629495972 -0500
+++ linux/arch/x86/kernel/x86_init.c	2011-03-21 14:06:52.129814554 -0500
@@ -89,6 +89,7 @@ struct x86_cpuinit_ops x86_cpuinit __cpu
 };
 
 static void default_nmi_init(void) { };
+static int default_nmi_handler(struct pt_regs *regs) { return 0; };
 static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
@@ -98,6 +99,7 @@ struct x86_platform_ops x86_platform = {
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init,
+	.nmi_handler			= default_nmi_handler,
 	.i8042_detect			= default_i8042_detect
 };
 
