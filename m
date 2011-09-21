Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1IUK4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:56:49 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22184 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1IUK4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:56:45 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRVD2F-02-09Q-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [V3][PATCH 2/7] perf, x86: Implement IBS initialization
Date: Wed, 21 Sep 2011 11:30:18 +0200
Message-ID: <1316597423-25723-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements IBS feature detection and initialzation. The
code is shared between perf and oprofile. If ibs is available on the
system for perf, a pmu is setup.

V2:
* Remove printks in pmu function stubs.
* Modify perf_event_ibs_init() to use ibs_caps directly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h        |    2 +
 arch/x86/kernel/cpu/Makefile             |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  292 ++++++++++++++++++++++++++++++
 arch/x86/oprofile/nmi_int.c              |    2 -
 arch/x86/oprofile/op_model_amd.c         |  197 --------------------
 arch/x86/oprofile/op_x86_model.h         |    1 -
 6 files changed, 295 insertions(+), 201 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_ibs.c

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index bc801ac..e7d2f15 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -156,6 +156,8 @@ union cpuid10_edx {
 #define IBS_OP_MAX_CNT		0x0000FFFFULL
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 
+extern u32 get_ibs_caps(void);
+
 #ifdef CONFIG_PERF_EVENTS
 extern void perf_events_lapic_init(void);
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..ab70cd1 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
-obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
new file mode 100644
index 0000000..1ae5154
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -0,0 +1,292 @@
+/*
+ * Performance events - AMD IBS
+ *
+ *  Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+static u32 ibs_caps;
+
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
+
+static struct pmu perf_ibs;
+
+static int perf_ibs_init(struct perf_event *event)
+{
+	if (perf_ibs.type != event->attr.type)
+		return -ENOENT;
+	return 0;
+}
+
+static int perf_ibs_add(struct perf_event *event, int flags)
+{
+	return 0;
+}
+
+static void perf_ibs_del(struct perf_event *event, int flags)
+{
+}
+
+static struct pmu perf_ibs = {
+	.event_init= perf_ibs_init,
+	.add= perf_ibs_add,
+	.del= perf_ibs_del,
+};
+
+static __init int perf_event_ibs_init(void)
+{
+	if (!ibs_caps)
+		return -ENODEV;	/* ibs not supported by the cpu */
+
+	perf_pmu_register(&perf_ibs, "ibs", -1);
+	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
+
+	return 0;
+}
+
+#else /* defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD) */
+
+static __init int perf_event_ibs_init(void) { return 0; }
+
+#endif
+
+/* IBS - apic initialization, for perf and oprofile */
+
+static __init u32 __get_ibs_caps(void)
+{
+	u32 caps;
+	unsigned int max_level;
+
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return 0;
+
+	/* check IBS cpuid feature flags */
+	max_level = cpuid_eax(0x80000000);
+	if (max_level < IBS_CPUID_FEATURES)
+		return IBS_CAPS_DEFAULT;
+
+	caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (!(caps & IBS_CAPS_AVAIL))
+		/* cpuid flags not valid */
+		return IBS_CAPS_DEFAULT;
+
+	return caps;
+}
+
+u32 get_ibs_caps(void)
+{
+	return ibs_caps;
+}
+
+EXPORT_SYMBOL(get_ibs_caps);
+
+static inline int get_eilvt(int offset)
+{
+	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
+}
+
+static inline int put_eilvt(int offset)
+{
+	return !setup_APIC_eilvt(offset, 0, 0, 1);
+}
+
+/*
+ * Check and reserve APIC extended interrupt LVT offset for IBS if available.
+ */
+static inline int ibs_eilvt_valid(void)
+{
+	int offset;
+	u64 val;
+	int valid = 0;
+
+	preempt_disable();
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	offset = val & IBSCTL_LVT_OFFSET_MASK;
+
+	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
+		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
+		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		goto out;
+	}
+
+	if (!get_eilvt(offset)) {
+		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
+		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		goto out;
+	}
+
+	valid = 1;
+out:
+	preempt_enable();
+
+	return valid;
+}
+
+static int setup_ibs_ctl(int ibs_eilvt_off)
+{
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+
+	nodes = 0;
+	cpu_cfg = NULL;
+	do {
+		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
+					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
+					 cpu_cfg);
+		if (!cpu_cfg)
+			break;
+		++nodes;
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVT_OFFSET_VALID);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
+		if (value != (ibs_eilvt_off | IBSCTL_LVT_OFFSET_VALID)) {
+			pci_dev_put(cpu_cfg);
+			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
+			       "IBSCTL = 0x%08x\n", value);
+			return -EINVAL;
+		}
+	} while (1);
+
+	if (!nodes) {
+		printk(KERN_DEBUG "No CPU node configured for IBS\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * This runs only on the current cpu. We try to find an LVT offset and
+ * setup the local APIC. For this we must disable preemption. On
+ * success we initialize all nodes with this offset. This updates then
+ * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
+ * the IBS interrupt vector is handled by perf_ibs_cpu_notifier that
+ * is using the new offset.
+ */
+static int force_ibs_eilvt_setup(void)
+{
+	int offset;
+	int ret;
+
+	preempt_disable();
+	/* find the next free available EILVT entry, skip offset 0 */
+	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
+		if (get_eilvt(offset))
+			break;
+	}
+	preempt_enable();
+
+	if (offset == APIC_EILVT_NR_MAX) {
+		printk(KERN_DEBUG "No EILVT entry available\n");
+		return -EBUSY;
+	}
+
+	ret = setup_ibs_ctl(offset);
+	if (ret)
+		goto out;
+
+	if (!ibs_eilvt_valid()) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
+	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
+
+	return 0;
+out:
+	preempt_disable();
+	put_eilvt(offset);
+	preempt_enable();
+	return ret;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void *dummy)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("perf: IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void *dummy)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int __cpuinit
+perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		setup_APIC_ibs(NULL);
+		break;
+	case CPU_DYING:
+		clear_APIC_ibs(NULL);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static __init int amd_ibs_init(void)
+{
+	u32 caps;
+	int ret;
+
+	caps = __get_ibs_caps();
+	if (!caps)
+		return -ENODEV;	/* ibs not supported by the cpu */
+
+	if (!ibs_eilvt_valid()) {
+		ret = force_ibs_eilvt_setup();
+		if (ret) {
+			pr_err("Failed to setup IBS, %d\n", ret);
+			return ret;
+		}
+	}
+
+	get_online_cpus();
+	ibs_caps = caps;
+	/* make ibs_caps visible to other cpus: */
+	smp_mb();
+	perf_cpu_notifier(perf_ibs_cpu_notifier);
+	smp_call_function(setup_APIC_ibs, NULL, 1);
+	put_online_cpus();
+
+	return perf_event_ibs_init();
+}
+
+/* Since we need the pci subsystem to init ibs we can't do this earlier: */
+device_initcall(amd_ibs_init);
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index adf8fb3..c04dc14 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -385,8 +385,6 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
-	if (model->cpu_down)
-		model->cpu_down();
 }
 
 static void nmi_cpu_up(void *dummy)
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index e947e5c..303f086 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -74,27 +74,6 @@ static struct ibs_state ibs_state;
 #define IBS_RANDOM_MASK			((1ULL << IBS_RANDOM_BITS) - 1)
 #define IBS_RANDOM_MAXCNT_OFFSET	(1ULL << (IBS_RANDOM_BITS - 5))
 
-static u32 get_ibs_caps(void)
-{
-	u32 ibs_caps;
-	unsigned int max_level;
-
-	if (!boot_cpu_has(X86_FEATURE_IBS))
-		return 0;
-
-	/* check IBS cpuid feature flags */
-	max_level = cpuid_eax(0x80000000);
-	if (max_level < IBS_CPUID_FEATURES)
-		return IBS_CAPS_DEFAULT;
-
-	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
-	if (!(ibs_caps & IBS_CAPS_AVAIL))
-		/* cpuid flags not valid */
-		return IBS_CAPS_DEFAULT;
-
-	return ibs_caps;
-}
-
 /*
  * 16-bit Linear Feedback Shift Register (LFSR)
  *
@@ -285,81 +264,6 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
-static inline int get_eilvt(int offset)
-{
-	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
-}
-
-static inline int put_eilvt(int offset)
-{
-	return !setup_APIC_eilvt(offset, 0, 0, 1);
-}
-
-static inline int ibs_eilvt_valid(void)
-{
-	int offset;
-	u64 val;
-	int valid = 0;
-
-	preempt_disable();
-
-	rdmsrl(MSR_AMD64_IBSCTL, val);
-	offset = val & IBSCTL_LVT_OFFSET_MASK;
-
-	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
-		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
-		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		goto out;
-	}
-
-	if (!get_eilvt(offset)) {
-		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
-		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		goto out;
-	}
-
-	valid = 1;
-out:
-	preempt_enable();
-
-	return valid;
-}
-
-static inline int get_ibs_offset(void)
-{
-	u64 val;
-
-	rdmsrl(MSR_AMD64_IBSCTL, val);
-	if (!(val & IBSCTL_LVT_OFFSET_VALID))
-		return -EINVAL;
-
-	return val & IBSCTL_LVT_OFFSET_MASK;
-}
-
-static void setup_APIC_ibs(void)
-{
-	int offset;
-
-	offset = get_ibs_offset();
-	if (offset < 0)
-		goto failed;
-
-	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
-		return;
-failed:
-	pr_warn("oprofile: IBS APIC setup failed on cpu #%d\n",
-		smp_processor_id());
-}
-
-static void clear_APIC_ibs(void)
-{
-	int offset;
-
-	offset = get_ibs_offset();
-	if (offset >= 0)
-		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
-}
-
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
@@ -473,15 +377,6 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 		val |= op_x86_get_ctrl(model, &counter_config[virt]);
 		wrmsrl(msrs->controls[i].addr, val);
 	}
-
-	if (ibs_caps)
-		setup_APIC_ibs();
-}
-
-static void op_amd_cpu_shutdown(void)
-{
-	if (ibs_caps)
-		clear_APIC_ibs();
 }
 
 static int op_amd_check_ctrs(struct pt_regs * const regs,
@@ -544,86 +439,6 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	op_amd_stop_ibs();
 }
 
-static int setup_ibs_ctl(int ibs_eilvt_off)
-{
-	struct pci_dev *cpu_cfg;
-	int nodes;
-	u32 value = 0;
-
-	nodes = 0;
-	cpu_cfg = NULL;
-	do {
-		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
-					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
-					 cpu_cfg);
-		if (!cpu_cfg)
-			break;
-		++nodes;
-		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
-				       | IBSCTL_LVT_OFFSET_VALID);
-		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
-		if (value != (ibs_eilvt_off | IBSCTL_LVT_OFFSET_VALID)) {
-			pci_dev_put(cpu_cfg);
-			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
-			       "IBSCTL = 0x%08x\n", value);
-			return -EINVAL;
-		}
-	} while (1);
-
-	if (!nodes) {
-		printk(KERN_DEBUG "No CPU node configured for IBS\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-/*
- * This runs only on the current cpu. We try to find an LVT offset and
- * setup the local APIC. For this we must disable preemption. On
- * success we initialize all nodes with this offset. This updates then
- * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
- * the IBS interrupt vector is called from op_amd_setup_ctrs()/op_-
- * amd_cpu_shutdown() using the new offset.
- */
-static int force_ibs_eilvt_setup(void)
-{
-	int offset;
-	int ret;
-
-	preempt_disable();
-	/* find the next free available EILVT entry, skip offset 0 */
-	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
-		if (get_eilvt(offset))
-			break;
-	}
-	preempt_enable();
-
-	if (offset == APIC_EILVT_NR_MAX) {
-		printk(KERN_DEBUG "No EILVT entry available\n");
-		return -EBUSY;
-	}
-
-	ret = setup_ibs_ctl(offset);
-	if (ret)
-		goto out;
-
-	if (!ibs_eilvt_valid()) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
-	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
-
-	return 0;
-out:
-	preempt_disable();
-	put_eilvt(offset);
-	preempt_enable();
-	return ret;
-}
-
 /*
  * check and reserve APIC extended interrupt LVT offset for IBS if
  * available
@@ -636,17 +451,6 @@ static void init_ibs(void)
 	if (!ibs_caps)
 		return;
 
-	if (ibs_eilvt_valid())
-		goto out;
-
-	if (!force_ibs_eilvt_setup())
-		goto out;
-
-	/* Failed to setup ibs */
-	ibs_caps = 0;
-	return;
-
-out:
 	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
 }
 
@@ -729,7 +533,6 @@ struct op_x86_model_spec op_amd_spec = {
 	.init			= op_amd_init,
 	.fill_in_addresses	= &op_amd_fill_in_addresses,
 	.setup_ctrs		= &op_amd_setup_ctrs,
-	.cpu_down		= &op_amd_cpu_shutdown,
 	.check_ctrs		= &op_amd_check_ctrs,
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 89017fa..71e8a67 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -43,7 +43,6 @@ struct op_x86_model_spec {
 	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);
-	void		(*cpu_down)(void);
 	int		(*check_ctrs)(struct pt_regs * const regs,
 				      struct op_msrs const * const msrs);
 	void		(*start)(struct op_msrs const * const msrs);
-- 
1.7.6.1


