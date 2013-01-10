Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3AJKYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:24:11 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:47393 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3AJKYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:24:05 -0500
Date: Thu, 10 Jan 2013 11:23:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.8-rc4
Message-ID: <20130110112356.48aab1ac@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13011010-0342-0000-0000-000003E2D493
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Add the finit_module system call, fix the irq statistics in /proc/stat,
fix a s390dbf lockdep problem, a patch revert for a problem that is
not 100% understood yet, and a few patches to fix warnings.

Heiko Carstens (11):
      s390/smp: fix section mismatch for smp_add_present_cpu()
      s390/pci: remove dead code
      s390/syscalls: wire up finit_module syscall
      s390/irq: enable irq sum accounting for /proc/stat again
      s390/irq: remove split irq fields from /proc/stat
      s390/irq: count cpu restart events
      s390/3215: partially revert tty close handling fix
      s390/pci: define isa_dma_bridge_buggy
      s390/pm: export pm_power_off
      s390/topology: export cpu_topology
      s390/pci: define read*_relaxed functions

Michael Holzheu (1):
      s390/debug: Fix s390dbf lockdep problem in debug_(un)register_view()

 arch/s390/include/asm/dma.h         |    6 ++
 arch/s390/include/asm/io.h          |    5 ++
 arch/s390/include/asm/irq.h         |   78 +++++++++++++---------
 arch/s390/include/uapi/asm/unistd.h |    3 +-
 arch/s390/kernel/compat_wrapper.S   |    6 ++
 arch/s390/kernel/debug.c            |   11 ++--
 arch/s390/kernel/irq.c              |  124 +++++++++++++++++++++--------------
 arch/s390/kernel/nmi.c              |    2 +-
 arch/s390/kernel/perf_cpum_cf.c     |    2 +-
 arch/s390/kernel/runtime_instr.c    |    2 +-
 arch/s390/kernel/setup.c            |    3 +-
 arch/s390/kernel/smp.c              |   12 ++--
 arch/s390/kernel/syscalls.S         |    1 +
 arch/s390/kernel/time.c             |    4 +-
 arch/s390/kernel/topology.c         |    2 +
 arch/s390/mm/fault.c                |    2 +-
 arch/s390/oprofile/hwsampler.c      |    2 +-
 arch/s390/pci/pci.c                 |   33 +---------
 arch/s390/pci/pci_dma.c             |    2 -
 drivers/s390/block/dasd_diag.c      |    2 +-
 drivers/s390/block/dasd_eckd.c      |    2 +-
 drivers/s390/block/dasd_fba.c       |    2 +-
 drivers/s390/char/con3215.c         |    8 ++-
 drivers/s390/char/raw3270.c         |    2 +-
 drivers/s390/char/sclp.c            |    4 +-
 drivers/s390/char/tape_34xx.c       |    2 +-
 drivers/s390/char/tape_3590.c       |    2 +-
 drivers/s390/char/vmur.c            |    2 +-
 drivers/s390/cio/chsc_sch.c         |    2 +-
 drivers/s390/cio/cio.c              |   10 +--
 drivers/s390/cio/device.c           |   12 ++--
 drivers/s390/cio/device.h           |    5 +-
 drivers/s390/cio/eadm_sch.c         |    2 +-
 drivers/s390/cio/qdio_thinint.c     |    2 +-
 drivers/s390/crypto/ap_bus.c        |    2 +-
 drivers/s390/kvm/kvm_virtio.c       |    2 +-
 drivers/s390/net/claw.c             |    2 +-
 drivers/s390/net/ctcm_main.c        |    2 +-
 drivers/s390/net/lcs.c              |    2 +-
 net/iucv/iucv.c                     |    2 +-
 40 files changed, 207 insertions(+), 164 deletions(-)

diff --git a/arch/s390/include/asm/dma.h b/arch/s390/include/asm/dma.h
index de015d8..bb9bdcd 100644
--- a/arch/s390/include/asm/dma.h
+++ b/arch/s390/include/asm/dma.h
@@ -10,4 +10,10 @@
  */
 #define MAX_DMA_ADDRESS         0x80000000
 
+#ifdef CONFIG_PCI
+extern int isa_dma_bridge_buggy;
+#else
+#define isa_dma_bridge_buggy	(0)
+#endif
+
 #endif /* _ASM_S390_DMA_H */
diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index 16c3eb1..27cb321 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -85,6 +85,11 @@ static inline void iounmap(volatile void __iomem *addr)
 #define __raw_writel	zpci_write_u32
 #define __raw_writeq	zpci_write_u64
 
+#define readb_relaxed	readb
+#define readw_relaxed	readw
+#define readl_relaxed	readl
+#define readq_relaxed	readq
+
 #endif /* CONFIG_PCI */
 
 #include <asm-generic/io.h>
diff --git a/arch/s390/include/asm/irq.h b/arch/s390/include/asm/irq.h
index e6972f8..7def773 100644
--- a/arch/s390/include/asm/irq.h
+++ b/arch/s390/include/asm/irq.h
@@ -2,43 +2,61 @@
 #define _ASM_IRQ_H
 
 #include <linux/hardirq.h>
+#include <linux/percpu.h>
+#include <linux/cache.h>
 #include <linux/types.h>
 
-enum interruption_class {
+enum interruption_main_class {
 	EXTERNAL_INTERRUPT,
 	IO_INTERRUPT,
-	EXTINT_CLK,
-	EXTINT_EXC,
-	EXTINT_EMS,
-	EXTINT_TMR,
-	EXTINT_TLA,
-	EXTINT_PFL,
-	EXTINT_DSD,
-	EXTINT_VRT,
-	EXTINT_SCP,
-	EXTINT_IUC,
-	EXTINT_CMS,
-	EXTINT_CMC,
-	EXTINT_CMR,
-	IOINT_CIO,
-	IOINT_QAI,
-	IOINT_DAS,
-	IOINT_C15,
-	IOINT_C70,
-	IOINT_TAP,
-	IOINT_VMR,
-	IOINT_LCS,
-	IOINT_CLW,
-	IOINT_CTC,
-	IOINT_APB,
-	IOINT_ADM,
-	IOINT_CSC,
-	IOINT_PCI,
-	IOINT_MSI,
+	NR_IRQS
+};
+
+enum interruption_class {
+	IRQEXT_CLK,
+	IRQEXT_EXC,
+	IRQEXT_EMS,
+	IRQEXT_TMR,
+	IRQEXT_TLA,
+	IRQEXT_PFL,
+	IRQEXT_DSD,
+	IRQEXT_VRT,
+	IRQEXT_SCP,
+	IRQEXT_IUC,
+	IRQEXT_CMS,
+	IRQEXT_CMC,
+	IRQEXT_CMR,
+	IRQIO_CIO,
+	IRQIO_QAI,
+	IRQIO_DAS,
+	IRQIO_C15,
+	IRQIO_C70,
+	IRQIO_TAP,
+	IRQIO_VMR,
+	IRQIO_LCS,
+	IRQIO_CLW,
+	IRQIO_CTC,
+	IRQIO_APB,
+	IRQIO_ADM,
+	IRQIO_CSC,
+	IRQIO_PCI,
+	IRQIO_MSI,
 	NMI_NMI,
-	NR_IRQS,
+	CPU_RST,
+	NR_ARCH_IRQS
 };
 
+struct irq_stat {
+	unsigned int irqs[NR_ARCH_IRQS];
+};
+
+DECLARE_PER_CPU_SHARED_ALIGNED(struct irq_stat, irq_stat);
+
+static __always_inline void inc_irq_stat(enum interruption_class irq)
+{
+	__get_cpu_var(irq_stat).irqs[irq]++;
+}
+
 struct ext_code {
 	unsigned short subcode;
 	unsigned short code;
diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 63e6078..864f693 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -279,7 +279,8 @@
 #define __NR_process_vm_writev	341
 #define __NR_s390_runtime_instr 342
 #define __NR_kcmp		343
-#define NR_syscalls 344
+#define __NR_finit_module	344
+#define NR_syscalls 345
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 827e094..9b9a805 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1659,3 +1659,9 @@ ENTRY(sys_kcmp_wrapper)
 	llgfr	%r5,%r5			# unsigned long
 	llgfr	%r6,%r6			# unsigned long
 	jg	sys_kcmp
+
+ENTRY(sys_finit_module_wrapper)
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# const char __user *
+	lgfr	%r4,%r4			# int
+	jg	sys_finit_module
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index ba500d8..4e8215e 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1127,13 +1127,14 @@ debug_register_view(debug_info_t * id, struct debug_view *view)
 	if (i == DEBUG_MAX_VIEWS) {
 		pr_err("Registering view %s/%s would exceed the maximum "
 		       "number of views %i\n", id->name, view->name, i);
-		debugfs_remove(pde);
 		rc = -1;
 	} else {
 		id->views[i] = view;
 		id->debugfs_entries[i] = pde;
 	}
 	spin_unlock_irqrestore(&id->lock, flags);
+	if (rc)
+		debugfs_remove(pde);
 out:
 	return rc;
 }
@@ -1146,9 +1147,9 @@ EXPORT_SYMBOL(debug_register_view);
 int
 debug_unregister_view(debug_info_t * id, struct debug_view *view)
 {
-	int rc = 0;
-	int i;
+	struct dentry *dentry = NULL;
 	unsigned long flags;
+	int i, rc = 0;
 
 	if (!id)
 		goto out;
@@ -1160,10 +1161,12 @@ debug_unregister_view(debug_info_t * id, struct debug_view *view)
 	if (i == DEBUG_MAX_VIEWS)
 		rc = -1;
 	else {
-		debugfs_remove(id->debugfs_entries[i]);
+		dentry = id->debugfs_entries[i];
 		id->views[i] = NULL;
+		id->debugfs_entries[i] = NULL;
 	}
 	spin_unlock_irqrestore(&id->lock, flags);
+	debugfs_remove(dentry);
 out:
 	return rc;
 }
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index bf24293..9df824e 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -24,43 +24,65 @@
 #include <asm/irq.h>
 #include "entry.h"
 
+DEFINE_PER_CPU_SHARED_ALIGNED(struct irq_stat, irq_stat);
+EXPORT_PER_CPU_SYMBOL_GPL(irq_stat);
+
 struct irq_class {
 	char *name;
 	char *desc;
 };
 
-static const struct irq_class intrclass_names[] = {
+/*
+ * The list of "main" irq classes on s390. This is the list of interrrupts
+ * that appear both in /proc/stat ("intr" line) and /proc/interrupts.
+ * Historically only external and I/O interrupts have been part of /proc/stat.
+ * We can't add the split external and I/O sub classes since the first field
+ * in the "intr" line in /proc/stat is supposed to be the sum of all other
+ * fields.
+ * Since the external and I/O interrupt fields are already sums we would end
+ * up with having a sum which accounts each interrupt twice.
+ */
+static const struct irq_class irqclass_main_desc[NR_IRQS] = {
 	[EXTERNAL_INTERRUPT] = {.name = "EXT"},
-	[IO_INTERRUPT]	     = {.name = "I/O"},
-	[EXTINT_CLK] = {.name = "CLK", .desc = "[EXT] Clock Comparator"},
-	[EXTINT_EXC] = {.name = "EXC", .desc = "[EXT] External Call"},
-	[EXTINT_EMS] = {.name = "EMS", .desc = "[EXT] Emergency Signal"},
-	[EXTINT_TMR] = {.name = "TMR", .desc = "[EXT] CPU Timer"},
-	[EXTINT_TLA] = {.name = "TAL", .desc = "[EXT] Timing Alert"},
-	[EXTINT_PFL] = {.name = "PFL", .desc = "[EXT] Pseudo Page Fault"},
-	[EXTINT_DSD] = {.name = "DSD", .desc = "[EXT] DASD Diag"},
-	[EXTINT_VRT] = {.name = "VRT", .desc = "[EXT] Virtio"},
-	[EXTINT_SCP] = {.name = "SCP", .desc = "[EXT] Service Call"},
-	[EXTINT_IUC] = {.name = "IUC", .desc = "[EXT] IUCV"},
-	[EXTINT_CMS] = {.name = "CMS", .desc = "[EXT] CPU-Measurement: Sampling"},
-	[EXTINT_CMC] = {.name = "CMC", .desc = "[EXT] CPU-Measurement: Counter"},
-	[EXTINT_CMR] = {.name = "CMR", .desc = "[EXT] CPU-Measurement: RI"},
-	[IOINT_CIO]  = {.name = "CIO", .desc = "[I/O] Common I/O Layer Interrupt"},
-	[IOINT_QAI]  = {.name = "QAI", .desc = "[I/O] QDIO Adapter Interrupt"},
-	[IOINT_DAS]  = {.name = "DAS", .desc = "[I/O] DASD"},
-	[IOINT_C15]  = {.name = "C15", .desc = "[I/O] 3215"},
-	[IOINT_C70]  = {.name = "C70", .desc = "[I/O] 3270"},
-	[IOINT_TAP]  = {.name = "TAP", .desc = "[I/O] Tape"},
-	[IOINT_VMR]  = {.name = "VMR", .desc = "[I/O] Unit Record Devices"},
-	[IOINT_LCS]  = {.name = "LCS", .desc = "[I/O] LCS"},
-	[IOINT_CLW]  = {.name = "CLW", .desc = "[I/O] CLAW"},
-	[IOINT_CTC]  = {.name = "CTC", .desc = "[I/O] CTC"},
-	[IOINT_APB]  = {.name = "APB", .desc = "[I/O] AP Bus"},
-	[IOINT_ADM]  = {.name = "ADM", .desc = "[I/O] EADM Subchannel"},
-	[IOINT_CSC]  = {.name = "CSC", .desc = "[I/O] CHSC Subchannel"},
-	[IOINT_PCI]  = {.name = "PCI", .desc = "[I/O] PCI Interrupt" },
-	[IOINT_MSI] =  {.name = "MSI", .desc = "[I/O] MSI Interrupt" },
+	[IO_INTERRUPT]	     = {.name = "I/O"}
+};
+
+/*
+ * The list of split external and I/O interrupts that appear only in
+ * /proc/interrupts.
+ * In addition this list contains non external / I/O events like NMIs.
+ */
+static const struct irq_class irqclass_sub_desc[NR_ARCH_IRQS] = {
+	[IRQEXT_CLK] = {.name = "CLK", .desc = "[EXT] Clock Comparator"},
+	[IRQEXT_EXC] = {.name = "EXC", .desc = "[EXT] External Call"},
+	[IRQEXT_EMS] = {.name = "EMS", .desc = "[EXT] Emergency Signal"},
+	[IRQEXT_TMR] = {.name = "TMR", .desc = "[EXT] CPU Timer"},
+	[IRQEXT_TLA] = {.name = "TAL", .desc = "[EXT] Timing Alert"},
+	[IRQEXT_PFL] = {.name = "PFL", .desc = "[EXT] Pseudo Page Fault"},
+	[IRQEXT_DSD] = {.name = "DSD", .desc = "[EXT] DASD Diag"},
+	[IRQEXT_VRT] = {.name = "VRT", .desc = "[EXT] Virtio"},
+	[IRQEXT_SCP] = {.name = "SCP", .desc = "[EXT] Service Call"},
+	[IRQEXT_IUC] = {.name = "IUC", .desc = "[EXT] IUCV"},
+	[IRQEXT_CMS] = {.name = "CMS", .desc = "[EXT] CPU-Measurement: Sampling"},
+	[IRQEXT_CMC] = {.name = "CMC", .desc = "[EXT] CPU-Measurement: Counter"},
+	[IRQEXT_CMR] = {.name = "CMR", .desc = "[EXT] CPU-Measurement: RI"},
+	[IRQIO_CIO]  = {.name = "CIO", .desc = "[I/O] Common I/O Layer Interrupt"},
+	[IRQIO_QAI]  = {.name = "QAI", .desc = "[I/O] QDIO Adapter Interrupt"},
+	[IRQIO_DAS]  = {.name = "DAS", .desc = "[I/O] DASD"},
+	[IRQIO_C15]  = {.name = "C15", .desc = "[I/O] 3215"},
+	[IRQIO_C70]  = {.name = "C70", .desc = "[I/O] 3270"},
+	[IRQIO_TAP]  = {.name = "TAP", .desc = "[I/O] Tape"},
+	[IRQIO_VMR]  = {.name = "VMR", .desc = "[I/O] Unit Record Devices"},
+	[IRQIO_LCS]  = {.name = "LCS", .desc = "[I/O] LCS"},
+	[IRQIO_CLW]  = {.name = "CLW", .desc = "[I/O] CLAW"},
+	[IRQIO_CTC]  = {.name = "CTC", .desc = "[I/O] CTC"},
+	[IRQIO_APB]  = {.name = "APB", .desc = "[I/O] AP Bus"},
+	[IRQIO_ADM]  = {.name = "ADM", .desc = "[I/O] EADM Subchannel"},
+	[IRQIO_CSC]  = {.name = "CSC", .desc = "[I/O] CHSC Subchannel"},
+	[IRQIO_PCI]  = {.name = "PCI", .desc = "[I/O] PCI Interrupt" },
+	[IRQIO_MSI]  = {.name = "MSI", .desc = "[I/O] MSI Interrupt" },
 	[NMI_NMI]    = {.name = "NMI", .desc = "[NMI] Machine Check"},
+	[CPU_RST]    = {.name = "RST", .desc = "[CPU] CPU Restart"},
 };
 
 /*
@@ -68,30 +90,34 @@ static const struct irq_class intrclass_names[] = {
  */
 int show_interrupts(struct seq_file *p, void *v)
 {
-	int i = *(loff_t *) v, j;
+	int irq = *(loff_t *) v;
+	int cpu;
 
 	get_online_cpus();
-	if (i == 0) {
+	if (irq == 0) {
 		seq_puts(p, "           ");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%d       ",j);
+		for_each_online_cpu(cpu)
+			seq_printf(p, "CPU%d       ", cpu);
 		seq_putc(p, '\n');
 	}
-
-	if (i < NR_IRQS) {
-		seq_printf(p, "%s: ", intrclass_names[i].name);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
-#endif
-		if (intrclass_names[i].desc)
-			seq_printf(p, "  %s", intrclass_names[i].desc);
-                seq_putc(p, '\n');
-        }
+	if (irq < NR_IRQS) {
+		seq_printf(p, "%s: ", irqclass_main_desc[irq].name);
+		for_each_online_cpu(cpu)
+			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[irq]);
+		seq_putc(p, '\n');
+		goto skip_arch_irqs;
+	}
+	for (irq = 0; irq < NR_ARCH_IRQS; irq++) {
+		seq_printf(p, "%s: ", irqclass_sub_desc[irq].name);
+		for_each_online_cpu(cpu)
+			seq_printf(p, "%10u ", per_cpu(irq_stat, cpu).irqs[irq]);
+		if (irqclass_sub_desc[irq].desc)
+			seq_printf(p, "  %s", irqclass_sub_desc[irq].desc);
+		seq_putc(p, '\n');
+	}
+skip_arch_irqs:
 	put_online_cpus();
-        return 0;
+	return 0;
 }
 
 /*
@@ -222,7 +248,7 @@ void __irq_entry do_extint(struct pt_regs *regs, struct ext_code ext_code,
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
 	}
-	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
+	kstat_incr_irqs_this_cpu(EXTERNAL_INTERRUPT, NULL);
 	if (ext_code.code != 0x1004)
 		__get_cpu_var(s390_idle).nohz_delay = 1;
 
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index a6daa5c..7918fbe 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -254,7 +254,7 @@ void notrace s390_do_machine_check(struct pt_regs *regs)
 	int umode;
 
 	nmi_enter();
-	kstat_cpu(smp_processor_id()).irqs[NMI_NMI]++;
+	inc_irq_stat(NMI_NMI);
 	mci = (struct mci *) &S390_lowcore.mcck_interruption_code;
 	mcck = &__get_cpu_var(cpu_mcck);
 	umode = user_mode(regs);
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index c4e7269..86ec744 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -229,7 +229,7 @@ static void cpumf_measurement_alert(struct ext_code ext_code,
 	if (!(alert & CPU_MF_INT_CF_MASK))
 		return;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CMC]++;
+	inc_irq_stat(IRQEXT_CMC);
 	cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	/* Measurement alerts are shared and might happen when the PMU
diff --git a/arch/s390/kernel/runtime_instr.c b/arch/s390/kernel/runtime_instr.c
index 61066f6..077a993 100644
--- a/arch/s390/kernel/runtime_instr.c
+++ b/arch/s390/kernel/runtime_instr.c
@@ -71,7 +71,7 @@ static void runtime_instr_int_handler(struct ext_code ext_code,
 	if (!(param32 & CPU_MF_INT_RI_MASK))
 		return;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CMR]++;
+	inc_irq_stat(IRQEXT_CMR);
 
 	if (!current->thread.ri_cb)
 		return;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 2568590..a5360de 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -16,7 +16,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/errno.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/memblock.h>
@@ -289,6 +289,7 @@ void machine_power_off(void)
  * Dummy power off function.
  */
 void (*pm_power_off)(void) = machine_power_off;
+EXPORT_SYMBOL_GPL(pm_power_off);
 
 static int __init early_parse_mem(char *p)
 {
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 0b45baa..7433a2f 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -433,9 +433,9 @@ static void do_ext_call_interrupt(struct ext_code ext_code,
 
 	cpu = smp_processor_id();
 	if (ext_code.code == 0x1202)
-		kstat_cpu(cpu).irqs[EXTINT_EXC]++;
+		inc_irq_stat(IRQEXT_EXC);
 	else
-		kstat_cpu(cpu).irqs[EXTINT_EMS]++;
+		inc_irq_stat(IRQEXT_EMS);
 	/*
 	 * handle bit signal external calls
 	 */
@@ -623,9 +623,10 @@ static struct sclp_cpu_info *smp_get_cpu_info(void)
 	return info;
 }
 
-static int smp_add_present_cpu(int cpu);
+static int __cpuinit smp_add_present_cpu(int cpu);
 
-static int __smp_rescan_cpus(struct sclp_cpu_info *info, int sysfs_add)
+static int __cpuinit __smp_rescan_cpus(struct sclp_cpu_info *info,
+				       int sysfs_add)
 {
 	struct pcpu *pcpu;
 	cpumask_t avail;
@@ -708,6 +709,7 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
 	pfault_init();
 	notify_cpu_starting(smp_processor_id());
 	set_cpu_online(smp_processor_id(), true);
+	inc_irq_stat(CPU_RST);
 	local_irq_enable();
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
@@ -985,7 +987,7 @@ static int __cpuinit smp_cpu_notify(struct notifier_block *self,
 	return notifier_from_errno(err);
 }
 
-static int smp_add_present_cpu(int cpu)
+static int __cpuinit smp_add_present_cpu(int cpu)
 {
 	struct cpu *c = &pcpu_devices[cpu].cpu;
 	struct device *s = &c->dev;
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 4817485..6a6c61f 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -352,3 +352,4 @@ SYSCALL(sys_process_vm_readv,sys_process_vm_readv,compat_sys_process_vm_readv_wr
 SYSCALL(sys_process_vm_writev,sys_process_vm_writev,compat_sys_process_vm_writev_wrapper)
 SYSCALL(sys_ni_syscall,sys_s390_runtime_instr,sys_s390_runtime_instr_wrapper)
 SYSCALL(sys_kcmp,sys_kcmp,sys_kcmp_wrapper)
+SYSCALL(sys_finit_module,sys_finit_module,sys_finit_module_wrapper)
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 7fcd690..aff0e35 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -168,7 +168,7 @@ static void clock_comparator_interrupt(struct ext_code ext_code,
 				       unsigned int param32,
 				       unsigned long param64)
 {
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CLK]++;
+	inc_irq_stat(IRQEXT_CLK);
 	if (S390_lowcore.clock_comparator == -1ULL)
 		set_clock_comparator(S390_lowcore.clock_comparator);
 }
@@ -179,7 +179,7 @@ static void stp_timing_alert(struct stp_irq_parm *);
 static void timing_alert_interrupt(struct ext_code ext_code,
 				   unsigned int param32, unsigned long param64)
 {
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_TLA]++;
+	inc_irq_stat(IRQEXT_TLA);
 	if (param32 & 0x00c40000)
 		etr_timing_alert((struct etr_irq_parm *) &param32);
 	if (param32 & 0x00038000)
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index f1aba87..4b2e3e3 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -10,6 +10,7 @@
 #include <linux/bootmem.h>
 #include <linux/cpuset.h>
 #include <linux/device.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/init.h>
@@ -42,6 +43,7 @@ static struct mask_info socket_info;
 static struct mask_info book_info;
 
 struct cpu_topology_s390 cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 static cpumask_t cpu_group_map(struct mask_info *info, unsigned int cpu)
 {
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 42601d6..2fb9e63 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -569,7 +569,7 @@ static void pfault_interrupt(struct ext_code ext_code,
 	subcode = ext_code.subcode;
 	if ((subcode & 0xff00) != __SUBCODE_MASK)
 		return;
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_PFL]++;
+	inc_irq_stat(IRQEXT_PFL);
 	/* Get the token (= pid of the affected task). */
 	pid = sizeof(void *) == 4 ? param32 : param64;
 	rcu_read_lock();
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 0cb385d..b5b2916 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -233,7 +233,7 @@ static void hws_ext_handler(struct ext_code ext_code,
 	if (!(param32 & CPU_MF_INT_SF_MASK))
 		return;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CMS]++;
+	inc_irq_stat(IRQEXT_CMS);
 	atomic_xchg(&cb->ext_params, atomic_read(&cb->ext_params) | param32);
 
 	if (hws_wq)
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index ff49427..60e0372 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -160,35 +160,6 @@ int pci_proc_domain(struct pci_bus *bus)
 }
 EXPORT_SYMBOL_GPL(pci_proc_domain);
 
-/* Store PCI function information block */
-static int zpci_store_fib(struct zpci_dev *zdev, u8 *fc)
-{
-	struct zpci_fib *fib;
-	u8 status, cc;
-
-	fib = (void *) get_zeroed_page(GFP_KERNEL);
-	if (!fib)
-		return -ENOMEM;
-
-	do {
-		cc = __stpcifc(zdev->fh, 0, fib, &status);
-		if (cc == 2) {
-			msleep(ZPCI_INSN_BUSY_DELAY);
-			memset(fib, 0, PAGE_SIZE);
-		}
-	} while (cc == 2);
-
-	if (cc)
-		pr_err_once("%s: cc: %u  status: %u\n",
-			    __func__, cc, status);
-
-	/* Return PCI function controls */
-	*fc = fib->fc;
-
-	free_page((unsigned long) fib);
-	return (cc) ? -EIO : 0;
-}
-
 /* Modify PCI: Register adapter interruptions */
 static int zpci_register_airq(struct zpci_dev *zdev, unsigned int aisb,
 			      u64 aibv)
@@ -469,7 +440,7 @@ static void zpci_irq_handler(void *dont, void *need)
 	int rescan = 0, max = aisb_max;
 	struct zdev_irq_map *imap;
 
-	kstat_cpu(smp_processor_id()).irqs[IOINT_PCI]++;
+	inc_irq_stat(IRQIO_PCI);
 	sbit = start;
 
 scan:
@@ -481,7 +452,7 @@ scan:
 		/* find vector bit */
 		imap = bucket->imap[sbit];
 		for_each_set_bit_left(mbit, &imap->aibv, imap->msi_vecs) {
-			kstat_cpu(smp_processor_id()).irqs[IOINT_MSI]++;
+			inc_irq_stat(IRQIO_MSI);
 			clear_bit(63 - mbit, &imap->aibv);
 
 			spin_lock(&imap->lock);
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 6138468..a547419 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -13,8 +13,6 @@
 #include <linux/pci.h>
 #include <asm/pci_dma.h>
 
-static enum zpci_ioat_dtype zpci_ioat_dt = ZPCI_IOTA_RTTO;
-
 static struct kmem_cache *dma_region_table_cache;
 static struct kmem_cache *dma_page_table_cache;
 
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 9bd5da3..704488d 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -248,7 +248,7 @@ static void dasd_ext_handler(struct ext_code ext_code,
 	default:
 		return;
 	}
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_DSD]++;
+	inc_irq_stat(IRQEXT_DSD);
 	if (!ip) {		/* no intparm: unsolicited interrupt */
 		DBF_EVENT(DBF_NOTICE, "%s", "caught unsolicited "
 			      "interrupt");
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 806fe91..e37bc16 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -4274,7 +4274,7 @@ static struct ccw_driver dasd_eckd_driver = {
 	.thaw	     = dasd_generic_restore_device,
 	.restore     = dasd_generic_restore_device,
 	.uc_handler  = dasd_generic_uc_handler,
-	.int_class   = IOINT_DAS,
+	.int_class   = IRQIO_DAS,
 };
 
 /*
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index eb74850..4146985 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -78,7 +78,7 @@ static struct ccw_driver dasd_fba_driver = {
 	.freeze      = dasd_generic_pm_freeze,
 	.thaw	     = dasd_generic_restore_device,
 	.restore     = dasd_generic_restore_device,
-	.int_class   = IOINT_DAS,
+	.int_class   = IRQIO_DAS,
 };
 
 static void
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 4008450..33b7141 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -44,6 +44,7 @@
 #define RAW3215_NR_CCWS	    3
 #define RAW3215_TIMEOUT	    HZ/10     /* time for delayed output */
 
+#define RAW3215_FIXED	    1	      /* 3215 console device is not be freed */
 #define RAW3215_WORKING	    4	      /* set if a request is being worked on */
 #define RAW3215_THROTTLED   8	      /* set if reading is disabled */
 #define RAW3215_STOPPED	    16	      /* set if writing is disabled */
@@ -630,7 +631,8 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long flags;
 
-	if (!(raw->port.flags & ASYNC_INITIALIZED))
+	if (!(raw->port.flags & ASYNC_INITIALIZED) ||
+	    (raw->flags & RAW3215_FIXED))
 		return;
 	/* Wait for outstanding requests, then free irq */
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
@@ -805,7 +807,7 @@ static struct ccw_driver raw3215_ccw_driver = {
 	.freeze		= &raw3215_pm_stop,
 	.thaw		= &raw3215_pm_start,
 	.restore	= &raw3215_pm_start,
-	.int_class	= IOINT_C15,
+	.int_class	= IRQIO_C15,
 };
 
 #ifdef CONFIG_TN3215_CONSOLE
@@ -927,6 +929,8 @@ static int __init con3215_init(void)
 	dev_set_drvdata(&cdev->dev, raw);
 	cdev->handler = raw3215_irq;
 
+	raw->flags |= RAW3215_FIXED;
+
 	/* Request the console irq */
 	if (raw3215_startup(raw) != 0) {
 		raw3215_free_info(raw);
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index f3b8bb8..9a6c140 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -1396,7 +1396,7 @@ static struct ccw_driver raw3270_ccw_driver = {
 	.freeze		= &raw3270_pm_stop,
 	.thaw		= &raw3270_pm_start,
 	.restore	= &raw3270_pm_start,
-	.int_class	= IOINT_C70,
+	.int_class	= IRQIO_C70,
 };
 
 static int
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 4fa21f7..12c16a6 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -400,7 +400,7 @@ static void sclp_interrupt_handler(struct ext_code ext_code,
 	u32 finished_sccb;
 	u32 evbuf_pending;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_SCP]++;
+	inc_irq_stat(IRQEXT_SCP);
 	spin_lock(&sclp_lock);
 	finished_sccb = param32 & 0xfffffff8;
 	evbuf_pending = param32 & 0x3;
@@ -813,7 +813,7 @@ static void sclp_check_handler(struct ext_code ext_code,
 {
 	u32 finished_sccb;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_SCP]++;
+	inc_irq_stat(IRQEXT_SCP);
 	finished_sccb = param32 & 0xfffffff8;
 	/* Is this the interrupt we are waiting for? */
 	if (finished_sccb == 0)
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index 6ae929c..9aa7970 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -1193,7 +1193,7 @@ static struct ccw_driver tape_34xx_driver = {
 	.set_online = tape_34xx_online,
 	.set_offline = tape_generic_offline,
 	.freeze = tape_generic_pm_suspend,
-	.int_class = IOINT_TAP,
+	.int_class = IRQIO_TAP,
 };
 
 static int
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 1b0eb49..327cb19 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -1656,7 +1656,7 @@ static struct ccw_driver tape_3590_driver = {
 	.set_offline = tape_generic_offline,
 	.set_online = tape_3590_online,
 	.freeze = tape_generic_pm_suspend,
-	.int_class = IOINT_TAP,
+	.int_class = IRQIO_TAP,
 };
 
 /*
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 73bef0b..483f72b 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -74,7 +74,7 @@ static struct ccw_driver ur_driver = {
 	.set_online	= ur_set_online,
 	.set_offline	= ur_set_offline,
 	.freeze		= ur_pm_suspend,
-	.int_class	= IOINT_VMR,
+	.int_class	= IRQIO_VMR,
 };
 
 static DEFINE_MUTEX(vmur_mutex);
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 8f9a1a3..facdf80 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -58,7 +58,7 @@ static void chsc_subchannel_irq(struct subchannel *sch)
 
 	CHSC_LOG(4, "irb");
 	CHSC_LOG_HEX(4, irb, sizeof(*irb));
-	kstat_cpu(smp_processor_id()).irqs[IOINT_CSC]++;
+	inc_irq_stat(IRQIO_CSC);
 
 	/* Copy irb to provided request and set done. */
 	if (!request) {
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 8e927b9..c8faf62 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -611,7 +611,7 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	tpi_info = (struct tpi_info *)&S390_lowcore.subchannel_id;
 	irb = (struct irb *)&S390_lowcore.irb;
 	do {
-		kstat_cpu(smp_processor_id()).irqs[IO_INTERRUPT]++;
+		kstat_incr_irqs_this_cpu(IO_INTERRUPT, NULL);
 		if (tpi_info->adapter_IO) {
 			do_adapter_IO(tpi_info->isc);
 			continue;
@@ -619,7 +619,7 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 		sch = (struct subchannel *)(unsigned long)tpi_info->intparm;
 		if (!sch) {
 			/* Clear pending interrupt condition. */
-			kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
+			inc_irq_stat(IRQIO_CIO);
 			tsch(tpi_info->schid, irb);
 			continue;
 		}
@@ -633,9 +633,9 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 			if (sch->driver && sch->driver->irq)
 				sch->driver->irq(sch);
 			else
-				kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
+				inc_irq_stat(IRQIO_CIO);
 		} else
-			kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
+			inc_irq_stat(IRQIO_CIO);
 		spin_unlock(sch->lock);
 		/*
 		 * Are more interrupts pending?
@@ -678,7 +678,7 @@ static void cio_tsch(struct subchannel *sch)
 	if (sch->driver && sch->driver->irq)
 		sch->driver->irq(sch);
 	else
-		kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
+		inc_irq_stat(IRQIO_CIO);
 	if (!irq_context) {
 		irq_exit();
 		_local_bh_enable();
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 6995cff..7cd5c68 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -758,7 +758,7 @@ static int io_subchannel_initialize_dev(struct subchannel *sch,
 					struct ccw_device *cdev)
 {
 	cdev->private->cdev = cdev;
-	cdev->private->int_class = IOINT_CIO;
+	cdev->private->int_class = IRQIO_CIO;
 	atomic_set(&cdev->private->onoff, 0);
 	cdev->dev.parent = &sch->dev;
 	cdev->dev.release = ccw_device_release;
@@ -1023,7 +1023,7 @@ static void io_subchannel_irq(struct subchannel *sch)
 	if (cdev)
 		dev_fsm_event(cdev, DEV_EVENT_INTERRUPT);
 	else
-		kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
+		inc_irq_stat(IRQIO_CIO);
 }
 
 void io_subchannel_init_config(struct subchannel *sch)
@@ -1634,7 +1634,7 @@ ccw_device_probe_console(void)
 	memset(&console_private, 0, sizeof(struct ccw_device_private));
 	console_cdev.private = &console_private;
 	console_private.cdev = &console_cdev;
-	console_private.int_class = IOINT_CIO;
+	console_private.int_class = IRQIO_CIO;
 	ret = ccw_device_console_enable(&console_cdev, sch);
 	if (ret) {
 		cio_release_console();
@@ -1715,13 +1715,13 @@ ccw_device_probe (struct device *dev)
 	if (cdrv->int_class != 0)
 		cdev->private->int_class = cdrv->int_class;
 	else
-		cdev->private->int_class = IOINT_CIO;
+		cdev->private->int_class = IRQIO_CIO;
 
 	ret = cdrv->probe ? cdrv->probe(cdev) : -ENODEV;
 
 	if (ret) {
 		cdev->drv = NULL;
-		cdev->private->int_class = IOINT_CIO;
+		cdev->private->int_class = IRQIO_CIO;
 		return ret;
 	}
 
@@ -1755,7 +1755,7 @@ ccw_device_remove (struct device *dev)
 	}
 	ccw_device_set_timeout(cdev, 0);
 	cdev->drv = NULL;
-	cdev->private->int_class = IOINT_CIO;
+	cdev->private->int_class = IRQIO_CIO;
 	return 0;
 }
 
diff --git a/drivers/s390/cio/device.h b/drivers/s390/cio/device.h
index 2e575cf..7d4ecb6 100644
--- a/drivers/s390/cio/device.h
+++ b/drivers/s390/cio/device.h
@@ -61,11 +61,10 @@ dev_fsm_event(struct ccw_device *cdev, enum dev_event dev_event)
 
 	if (dev_event == DEV_EVENT_INTERRUPT) {
 		if (state == DEV_STATE_ONLINE)
-			kstat_cpu(smp_processor_id()).
-				irqs[cdev->private->int_class]++;
+			inc_irq_stat(cdev->private->int_class);
 		else if (state != DEV_STATE_CMFCHANGE &&
 			 state != DEV_STATE_CMFUPDATE)
-			kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
+			inc_irq_stat(IRQIO_CIO);
 	}
 	dev_jumptable[state][dev_event](cdev, dev_event);
 }
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index 6c96734..d9eddcb 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -139,7 +139,7 @@ static void eadm_subchannel_irq(struct subchannel *sch)
 	EADM_LOG(6, "irq");
 	EADM_LOG_HEX(6, irb, sizeof(*irb));
 
-	kstat_cpu(smp_processor_id()).irqs[IOINT_ADM]++;
+	inc_irq_stat(IRQIO_ADM);
 
 	if ((scsw->stctl & (SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND))
 	    && scsw->eswf == 1 && irb->esw.eadm.erw.r)
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index bdb394b..bde5255 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -182,7 +182,7 @@ static void tiqdio_thinint_handler(void *alsi, void *data)
 	struct qdio_q *q;
 
 	last_ai_time = S390_lowcore.int_clock;
-	kstat_cpu(smp_processor_id()).irqs[IOINT_QAI]++;
+	inc_irq_stat(IRQIO_QAI);
 
 	/* protect tiq_list entries, only changed in activate or shutdown */
 	rcu_read_lock();
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 7b865a7..b8b340a 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1272,7 +1272,7 @@ out:
 
 static void ap_interrupt_handler(void *unused1, void *unused2)
 {
-	kstat_cpu(smp_processor_id()).irqs[IOINT_APB]++;
+	inc_irq_stat(IRQIO_APB);
 	tasklet_schedule(&ap_tasklet);
 }
 
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 7dabef6..8491111 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -392,7 +392,7 @@ static void kvm_extint_handler(struct ext_code ext_code,
 
 	if ((ext_code.subcode & 0xff00) != VIRTIO_SUBCODE_64)
 		return;
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_VRT]++;
+	inc_irq_stat(IRQEXT_VRT);
 
 	/* The LSB might be overloaded, we have to mask it */
 	vq = (struct virtqueue *)(param64 & ~1UL);
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index 5c70a65..83bc9c5 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -282,7 +282,7 @@ static struct ccw_driver claw_ccw_driver = {
 	.ids	= claw_ids,
 	.probe	= ccwgroup_probe_ccwdev,
 	.remove	= ccwgroup_remove_ccwdev,
-	.int_class = IOINT_CLW,
+	.int_class = IRQIO_CLW,
 };
 
 static ssize_t claw_driver_group_store(struct device_driver *ddrv,
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 817b689..676f120 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1755,7 +1755,7 @@ static struct ccw_driver ctcm_ccw_driver = {
 	.ids	= ctcm_ids,
 	.probe	= ccwgroup_probe_ccwdev,
 	.remove	= ccwgroup_remove_ccwdev,
-	.int_class = IOINT_CTC,
+	.int_class = IRQIO_CTC,
 };
 
 static struct ccwgroup_driver ctcm_group_driver = {
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 2ca0f1d..c645dc9 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -2384,7 +2384,7 @@ static struct ccw_driver lcs_ccw_driver = {
 	.ids	= lcs_ids,
 	.probe	= ccwgroup_probe_ccwdev,
 	.remove	= ccwgroup_remove_ccwdev,
-	.int_class = IOINT_LCS,
+	.int_class = IRQIO_LCS,
 };
 
 /**
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 3ad1f9d..df08250 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1806,7 +1806,7 @@ static void iucv_external_interrupt(struct ext_code ext_code,
 	struct iucv_irq_data *p;
 	struct iucv_irq_list *work;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_IUC]++;
+	inc_irq_stat(IRQEXT_IUC);
 	p = iucv_irq_data[smp_processor_id()];
 	if (p->ippathid >= iucv_max_pathid) {
 		WARN_ON(p->ippathid >= iucv_max_pathid);

