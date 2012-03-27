Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2C0MfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:35:20 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:34425 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2C0MfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:35:17 -0400
Date: Tue, 27 Mar 2012 14:34:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.4 merge window part 2
Message-ID: <20120327143444.38eaf921@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12032712-4966-0000-0000-000001DD4B15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive some minor improvements and one additional feature for the
3.4 merge window: Hendrik added perf support for the s390 CPU counters.

Ben Hutchings (1):
      [S390] Remove unncessary export of arch_pick_mmap_layout

Hendrik Brueckner (1):
      [S390] perf: add support for s390x CPU counters

Jan Glauber (2):
      [S390] qdio: log all adapter characteristics
      [S390] oprofile: Allow multiple users of the measurement alert interrupt

Martin Schwidefsky (1):
      [S390] register cpu devices for SMP=n

 arch/s390/Kconfig                  |    1 +
 arch/s390/include/asm/cpu_mf.h     |   95 +++++
 arch/s390/include/asm/irq.h        |    2 +
 arch/s390/include/asm/perf_event.h |   12 +-
 arch/s390/kernel/Makefile          |    1 +
 arch/s390/kernel/irq.c             |   23 ++
 arch/s390/kernel/perf_cpum_cf.c    |  690 ++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/perf_event.c      |  125 +++++++
 arch/s390/mm/mmap.c                |    2 -
 arch/s390/oprofile/hwsampler.c     |   52 ++--
 drivers/s390/cio/qdio_main.c       |    1 -
 drivers/s390/cio/qdio_setup.c      |    3 +-
 12 files changed, 971 insertions(+), 36 deletions(-)
 create mode 100644 arch/s390/include/asm/cpu_mf.h
 create mode 100644 arch/s390/kernel/perf_cpum_cf.c
 create mode 100644 arch/s390/kernel/perf_event.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6d99a5f..465d5be 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -64,6 +64,7 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 config S390
 	def_bool y
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select GENERIC_CPU_DEVICES if !SMP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
new file mode 100644
index 0000000..e49db5d
--- /dev/null
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -0,0 +1,95 @@
+/*
+ * CPU-measurement facilities
+ *
+ *  Copyright IBM Corp. 2012
+ *  Author(s): Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
+ *	       Jan Glauber <jang@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+#ifndef _ASM_S390_CPU_MF_H
+#define _ASM_S390_CPU_MF_H
+
+#define CPU_MF_INT_SF_IAE	(1 << 31)	/* invalid entry address */
+#define CPU_MF_INT_SF_ISE	(1 << 30)	/* incorrect SDBT entry */
+#define CPU_MF_INT_SF_PRA	(1 << 29)	/* program request alert */
+#define CPU_MF_INT_SF_SACA	(1 << 23)	/* sampler auth. change alert */
+#define CPU_MF_INT_SF_LSDA	(1 << 22)	/* loss of sample data alert */
+#define CPU_MF_INT_CF_CACA	(1 <<  7)	/* counter auth. change alert */
+#define CPU_MF_INT_CF_LCDA	(1 <<  6)	/* loss of counter data alert */
+
+#define CPU_MF_INT_CF_MASK	(CPU_MF_INT_CF_CACA|CPU_MF_INT_CF_LCDA)
+#define CPU_MF_INT_SF_MASK	(CPU_MF_INT_SF_IAE|CPU_MF_INT_SF_ISE|	\
+				 CPU_MF_INT_SF_PRA|CPU_MF_INT_SF_SACA|	\
+				 CPU_MF_INT_SF_LSDA)
+
+/* CPU measurement facility support */
+static inline int cpum_cf_avail(void)
+{
+	return MACHINE_HAS_SPP && test_facility(67);
+}
+
+static inline int cpum_sf_avail(void)
+{
+	return MACHINE_HAS_SPP && test_facility(68);
+}
+
+
+struct cpumf_ctr_info {
+	u16   cfvn;
+	u16   auth_ctl;
+	u16   enable_ctl;
+	u16   act_ctl;
+	u16   max_cpu;
+	u16   csvn;
+	u16   max_cg;
+	u16   reserved1;
+	u32   reserved2[12];
+} __packed;
+
+/* Query counter information */
+static inline int qctri(struct cpumf_ctr_info *info)
+{
+	int rc = -EINVAL;
+
+	asm volatile (
+		"0:	.insn	s,0xb28e0000,%1\n"
+		"1:	lhi	%0,0\n"
+		"2:\n"
+		EX_TABLE(1b, 2b)
+		: "+d" (rc), "=Q" (*info));
+	return rc;
+}
+
+/* Load CPU-counter-set controls */
+static inline int lcctl(u64 ctl)
+{
+	int cc;
+
+	asm volatile (
+		"	.insn	s,0xb2840000,%1\n"
+		"	ipm	%0\n"
+		"	srl	%0,28\n"
+		: "=d" (cc) : "m" (ctl) : "cc");
+	return cc;
+}
+
+/* Extract CPU counter */
+static inline int ecctr(u64 ctr, u64 *val)
+{
+	register u64 content asm("4") = 0;
+	int cc;
+
+	asm volatile (
+		"	.insn	rre,0xb2e40000,%0,%2\n"
+		"	ipm	%1\n"
+		"	srl	%1,28\n"
+		: "=d" (content), "=d" (cc) : "d" (ctr) : "cc");
+	if (!cc)
+		*val = content;
+	return cc;
+}
+
+#endif /* _ASM_S390_CPU_MF_H */
diff --git a/arch/s390/include/asm/irq.h b/arch/s390/include/asm/irq.h
index acee180..5289cac 100644
--- a/arch/s390/include/asm/irq.h
+++ b/arch/s390/include/asm/irq.h
@@ -45,5 +45,7 @@ int register_external_interrupt(u16 code, ext_int_handler_t handler);
 int unregister_external_interrupt(u16 code, ext_int_handler_t handler);
 void service_subclass_irq_register(void);
 void service_subclass_irq_unregister(void);
+void measurement_alert_subclass_register(void);
+void measurement_alert_subclass_unregister(void);
 
 #endif /* _ASM_IRQ_H */
diff --git a/arch/s390/include/asm/perf_event.h b/arch/s390/include/asm/perf_event.h
index 4eb444e..7941968 100644
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -1,8 +1,16 @@
 /*
  * Performance event support - s390 specific definitions.
  *
- * Copyright 2009 Martin Schwidefsky, IBM Corporation.
+ * Copyright IBM Corp. 2009, 2012
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *	      Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
  */
 
-/* Empty, just to avoid compiling error */
+#include <asm/cpu_mf.h>
 
+/* CPU-measurement counter facility */
+#define PERF_CPUM_CF_MAX_CTR		160
+
+/* Per-CPU flags for PMU states */
+#define PMU_F_RESERVED			0x1000
+#define PMU_F_ENABLED			0x2000
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 16b0b43..884b18a 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)  += ftrace.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
+obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o perf_cpum_cf.o
 
 # Kexec part
 S390_KEXEC_OBJS := machine_kexec.o crash.o
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 2429ecd..1c2cdd5 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -255,3 +255,26 @@ void service_subclass_irq_unregister(void)
 	spin_unlock(&sc_irq_lock);
 }
 EXPORT_SYMBOL(service_subclass_irq_unregister);
+
+static DEFINE_SPINLOCK(ma_subclass_lock);
+static int ma_subclass_refcount;
+
+void measurement_alert_subclass_register(void)
+{
+	spin_lock(&ma_subclass_lock);
+	if (!ma_subclass_refcount)
+		ctl_set_bit(0, 5);
+	ma_subclass_refcount++;
+	spin_unlock(&ma_subclass_lock);
+}
+EXPORT_SYMBOL(measurement_alert_subclass_register);
+
+void measurement_alert_subclass_unregister(void)
+{
+	spin_lock(&ma_subclass_lock);
+	ma_subclass_refcount--;
+	if (!ma_subclass_refcount)
+		ctl_clear_bit(0, 5);
+	spin_unlock(&ma_subclass_lock);
+}
+EXPORT_SYMBOL(measurement_alert_subclass_unregister);
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
new file mode 100644
index 0000000..8481ecf
--- /dev/null
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -0,0 +1,690 @@
+/*
+ * Performance event support for s390x - CPU-measurement Counter Facility
+ *
+ *  Copyright IBM Corp. 2012
+ *  Author(s): Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+#define KMSG_COMPONENT	"cpum_cf"
+#define pr_fmt(fmt)	KMSG_COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/kernel_stat.h>
+#include <linux/perf_event.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <asm/cpu_mf.h>
+
+/* CPU-measurement counter facility supports these CPU counter sets:
+ * For CPU counter sets:
+ *    Basic counter set:	     0-31
+ *    Problem-state counter set:    32-63
+ *    Crypto-activity counter set:  64-127
+ *    Extented counter set:	   128-159
+ */
+enum cpumf_ctr_set {
+	/* CPU counter sets */
+	CPUMF_CTR_SET_BASIC   = 0,
+	CPUMF_CTR_SET_USER    = 1,
+	CPUMF_CTR_SET_CRYPTO  = 2,
+	CPUMF_CTR_SET_EXT     = 3,
+
+	/* Maximum number of counter sets */
+	CPUMF_CTR_SET_MAX,
+};
+
+#define CPUMF_LCCTL_ENABLE_SHIFT    16
+#define CPUMF_LCCTL_ACTCTL_SHIFT     0
+static const u64 cpumf_state_ctl[CPUMF_CTR_SET_MAX] = {
+	[CPUMF_CTR_SET_BASIC]	= 0x02,
+	[CPUMF_CTR_SET_USER]	= 0x04,
+	[CPUMF_CTR_SET_CRYPTO]	= 0x08,
+	[CPUMF_CTR_SET_EXT]	= 0x01,
+};
+
+static void ctr_set_enable(u64 *state, int ctr_set)
+{
+	*state |= cpumf_state_ctl[ctr_set] << CPUMF_LCCTL_ENABLE_SHIFT;
+}
+static void ctr_set_disable(u64 *state, int ctr_set)
+{
+	*state &= ~(cpumf_state_ctl[ctr_set] << CPUMF_LCCTL_ENABLE_SHIFT);
+}
+static void ctr_set_start(u64 *state, int ctr_set)
+{
+	*state |= cpumf_state_ctl[ctr_set] << CPUMF_LCCTL_ACTCTL_SHIFT;
+}
+static void ctr_set_stop(u64 *state, int ctr_set)
+{
+	*state &= ~(cpumf_state_ctl[ctr_set] << CPUMF_LCCTL_ACTCTL_SHIFT);
+}
+
+/* Local CPUMF event structure */
+struct cpu_hw_events {
+	struct cpumf_ctr_info	info;
+	atomic_t		ctr_set[CPUMF_CTR_SET_MAX];
+	u64			state, tx_state;
+	unsigned int		flags;
+};
+static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
+	.ctr_set = {
+		[CPUMF_CTR_SET_BASIC]  = ATOMIC_INIT(0),
+		[CPUMF_CTR_SET_USER]   = ATOMIC_INIT(0),
+		[CPUMF_CTR_SET_CRYPTO] = ATOMIC_INIT(0),
+		[CPUMF_CTR_SET_EXT]    = ATOMIC_INIT(0),
+	},
+	.state = 0,
+	.flags = 0,
+};
+
+static int get_counter_set(u64 event)
+{
+	int set = -1;
+
+	if (event < 32)
+		set = CPUMF_CTR_SET_BASIC;
+	else if (event < 64)
+		set = CPUMF_CTR_SET_USER;
+	else if (event < 128)
+		set = CPUMF_CTR_SET_CRYPTO;
+	else if (event < 160)
+		set = CPUMF_CTR_SET_EXT;
+
+	return set;
+}
+
+static int validate_event(const struct hw_perf_event *hwc)
+{
+	switch (hwc->config_base) {
+	case CPUMF_CTR_SET_BASIC:
+	case CPUMF_CTR_SET_USER:
+	case CPUMF_CTR_SET_CRYPTO:
+	case CPUMF_CTR_SET_EXT:
+		/* check for reserved counters */
+		if ((hwc->config >=  6 && hwc->config <=  31) ||
+		    (hwc->config >= 38 && hwc->config <=  63) ||
+		    (hwc->config >= 80 && hwc->config <= 127))
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int validate_ctr_version(const struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuhw;
+	int err = 0;
+
+	cpuhw = &get_cpu_var(cpu_hw_events);
+
+	/* check required version for counter sets */
+	switch (hwc->config_base) {
+	case CPUMF_CTR_SET_BASIC:
+	case CPUMF_CTR_SET_USER:
+		if (cpuhw->info.cfvn < 1)
+			err = -EOPNOTSUPP;
+		break;
+	case CPUMF_CTR_SET_CRYPTO:
+	case CPUMF_CTR_SET_EXT:
+		if (cpuhw->info.csvn < 1)
+			err = -EOPNOTSUPP;
+		break;
+	}
+
+	put_cpu_var(cpu_hw_events);
+	return err;
+}
+
+static int validate_ctr_auth(const struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuhw;
+	u64 ctrs_state;
+	int err = 0;
+
+	cpuhw = &get_cpu_var(cpu_hw_events);
+
+	/* check authorization for cpu counter sets */
+	ctrs_state = cpumf_state_ctl[hwc->config_base];
+	if (!(ctrs_state & cpuhw->info.auth_ctl))
+		err = -EPERM;
+
+	put_cpu_var(cpu_hw_events);
+	return err;
+}
+
+/*
+ * Change the CPUMF state to active.
+ * Enable and activate the CPU-counter sets according
+ * to the per-cpu control state.
+ */
+static void cpumf_pmu_enable(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	int err;
+
+	if (cpuhw->flags & PMU_F_ENABLED)
+		return;
+
+	err = lcctl(cpuhw->state);
+	if (err) {
+		pr_err("Enabling the performance measuring unit "
+		       "failed with rc=%lx\n", err);
+		return;
+	}
+
+	cpuhw->flags |= PMU_F_ENABLED;
+}
+
+/*
+ * Change the CPUMF state to inactive.
+ * Disable and enable (inactive) the CPU-counter sets according
+ * to the per-cpu control state.
+ */
+static void cpumf_pmu_disable(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	int err;
+	u64 inactive;
+
+	if (!(cpuhw->flags & PMU_F_ENABLED))
+		return;
+
+	inactive = cpuhw->state & ~((1 << CPUMF_LCCTL_ENABLE_SHIFT) - 1);
+	err = lcctl(inactive);
+	if (err) {
+		pr_err("Disabling the performance measuring unit "
+		       "failed with rc=%lx\n", err);
+		return;
+	}
+
+	cpuhw->flags &= ~PMU_F_ENABLED;
+}
+
+
+/* Number of perf events counting hardware events */
+static atomic_t num_events = ATOMIC_INIT(0);
+/* Used to avoid races in calling reserve/release_cpumf_hardware */
+static DEFINE_MUTEX(pmc_reserve_mutex);
+
+/* CPU-measurement alerts for the counter facility */
+static void cpumf_measurement_alert(struct ext_code ext_code,
+				    unsigned int alert, unsigned long unused)
+{
+	struct cpu_hw_events *cpuhw;
+
+	if (!(alert & CPU_MF_INT_CF_MASK))
+		return;
+
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_CPM]++;
+	cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	/* Measurement alerts are shared and might happen when the PMU
+	 * is not reserved.  Ignore these alerts in this case. */
+	if (!(cpuhw->flags & PMU_F_RESERVED))
+		return;
+
+	/* counter authorization change alert */
+	if (alert & CPU_MF_INT_CF_CACA)
+		qctri(&cpuhw->info);
+
+	/* loss of counter data alert */
+	if (alert & CPU_MF_INT_CF_LCDA)
+		pr_err("CPU[%i] Counter data was lost\n", smp_processor_id());
+}
+
+#define PMC_INIT      0
+#define PMC_RELEASE   1
+static void setup_pmc_cpu(void *flags)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	switch (*((int *) flags)) {
+	case PMC_INIT:
+		memset(&cpuhw->info, 0, sizeof(cpuhw->info));
+		qctri(&cpuhw->info);
+		cpuhw->flags |= PMU_F_RESERVED;
+		break;
+
+	case PMC_RELEASE:
+		cpuhw->flags &= ~PMU_F_RESERVED;
+		break;
+	}
+
+	/* Disable CPU counter sets */
+	lcctl(0);
+}
+
+/* Initialize the CPU-measurement facility */
+static int reserve_pmc_hardware(void)
+{
+	int flags = PMC_INIT;
+
+	on_each_cpu(setup_pmc_cpu, &flags, 1);
+	measurement_alert_subclass_register();
+
+	return 0;
+}
+
+/* Release the CPU-measurement facility */
+static void release_pmc_hardware(void)
+{
+	int flags = PMC_RELEASE;
+
+	on_each_cpu(setup_pmc_cpu, &flags, 1);
+	measurement_alert_subclass_unregister();
+}
+
+/* Release the PMU if event is the last perf event */
+static void hw_perf_event_destroy(struct perf_event *event)
+{
+	if (!atomic_add_unless(&num_events, -1, 1)) {
+		mutex_lock(&pmc_reserve_mutex);
+		if (atomic_dec_return(&num_events) == 0)
+			release_pmc_hardware();
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+}
+
+/* CPUMF <-> perf event mappings for kernel+userspace (basic set) */
+static const int cpumf_generic_events_basic[] = {
+	[PERF_COUNT_HW_CPU_CYCLES]	    = 0,
+	[PERF_COUNT_HW_INSTRUCTIONS]	    = 1,
+	[PERF_COUNT_HW_CACHE_REFERENCES]    = -1,
+	[PERF_COUNT_HW_CACHE_MISSES]	    = -1,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = -1,
+	[PERF_COUNT_HW_BRANCH_MISSES]	    = -1,
+	[PERF_COUNT_HW_BUS_CYCLES]	    = -1,
+};
+/* CPUMF <-> perf event mappings for userspace (problem-state set) */
+static const int cpumf_generic_events_user[] = {
+	[PERF_COUNT_HW_CPU_CYCLES]	    = 32,
+	[PERF_COUNT_HW_INSTRUCTIONS]	    = 33,
+	[PERF_COUNT_HW_CACHE_REFERENCES]    = -1,
+	[PERF_COUNT_HW_CACHE_MISSES]	    = -1,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = -1,
+	[PERF_COUNT_HW_BRANCH_MISSES]	    = -1,
+	[PERF_COUNT_HW_BUS_CYCLES]	    = -1,
+};
+
+static int __hw_perf_event_init(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	struct hw_perf_event *hwc = &event->hw;
+	int err;
+	u64 ev;
+
+	switch (attr->type) {
+	case PERF_TYPE_RAW:
+		/* Raw events are used to access counters directly,
+		 * hence do not permit excludes */
+		if (attr->exclude_kernel || attr->exclude_user ||
+		    attr->exclude_hv)
+			return -EOPNOTSUPP;
+		ev = attr->config;
+		break;
+
+	case PERF_TYPE_HARDWARE:
+		ev = attr->config;
+		/* Count user space (problem-state) only */
+		if (!attr->exclude_user && attr->exclude_kernel) {
+			if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
+				return -EOPNOTSUPP;
+			ev = cpumf_generic_events_user[ev];
+
+		/* No support for kernel space counters only */
+		} else if (!attr->exclude_kernel && attr->exclude_user) {
+			return -EOPNOTSUPP;
+
+		/* Count user and kernel space */
+		} else {
+			if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
+				return -EOPNOTSUPP;
+			ev = cpumf_generic_events_basic[ev];
+		}
+		break;
+
+	default:
+		return -ENOENT;
+	}
+
+	if (ev == -1)
+		return -ENOENT;
+
+	if (ev >= PERF_CPUM_CF_MAX_CTR)
+		return -EINVAL;
+
+	/* The CPU measurement counter facility does not have any interrupts
+	 * to do sampling.  Sampling must be provided by external means,
+	 * for example, by timers.
+	 */
+	if (hwc->sample_period)
+		return -EINVAL;
+
+	/* Use the hardware perf event structure to store the counter number
+	 * in 'config' member and the counter set to which the counter belongs
+	 * in the 'config_base'.  The counter set (config_base) is then used
+	 * to enable/disable the counters.
+	 */
+	hwc->config = ev;
+	hwc->config_base = get_counter_set(ev);
+
+	/* Validate the counter that is assigned to this event.
+	 * Because the counter facility can use numerous counters at the
+	 * same time without constraints, it is not necessary to explicity
+	 * validate event groups (event->group_leader != event).
+	 */
+	err = validate_event(hwc);
+	if (err)
+		return err;
+
+	/* Initialize for using the CPU-measurement counter facility */
+	if (!atomic_inc_not_zero(&num_events)) {
+		mutex_lock(&pmc_reserve_mutex);
+		if (atomic_read(&num_events) == 0 && reserve_pmc_hardware())
+			err = -EBUSY;
+		else
+			atomic_inc(&num_events);
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+	event->destroy = hw_perf_event_destroy;
+
+	/* Finally, validate version and authorization of the counter set */
+	err = validate_ctr_auth(hwc);
+	if (!err)
+		err = validate_ctr_version(hwc);
+
+	return err;
+}
+
+static int cpumf_pmu_event_init(struct perf_event *event)
+{
+	int err;
+
+	switch (event->attr.type) {
+	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_RAW:
+		err = __hw_perf_event_init(event);
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	if (unlikely(err) && event->destroy)
+		event->destroy(event);
+
+	return err;
+}
+
+static int hw_perf_event_reset(struct perf_event *event)
+{
+	u64 prev, new;
+	int err;
+
+	do {
+		prev = local64_read(&event->hw.prev_count);
+		err = ecctr(event->hw.config, &new);
+		if (err) {
+			if (err != 3)
+				break;
+			/* The counter is not (yet) available. This
+			 * might happen if the counter set to which
+			 * this counter belongs is in the disabled
+			 * state.
+			 */
+			new = 0;
+		}
+	} while (local64_cmpxchg(&event->hw.prev_count, prev, new) != prev);
+
+	return err;
+}
+
+static int hw_perf_event_update(struct perf_event *event)
+{
+	u64 prev, new, delta;
+	int err;
+
+	do {
+		prev = local64_read(&event->hw.prev_count);
+		err = ecctr(event->hw.config, &new);
+		if (err)
+			goto out;
+	} while (local64_cmpxchg(&event->hw.prev_count, prev, new) != prev);
+
+	delta = (prev <= new) ? new - prev
+			      : (-1ULL - prev) + new + 1;	 /* overflow */
+	local64_add(delta, &event->count);
+out:
+	return err;
+}
+
+static void cpumf_pmu_read(struct perf_event *event)
+{
+	if (event->hw.state & PERF_HES_STOPPED)
+		return;
+
+	hw_perf_event_update(event);
+}
+
+static void cpumf_pmu_start(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
+		return;
+
+	if (WARN_ON_ONCE(hwc->config == -1))
+		return;
+
+	if (flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+
+	hwc->state = 0;
+
+	/* (Re-)enable and activate the counter set */
+	ctr_set_enable(&cpuhw->state, hwc->config_base);
+	ctr_set_start(&cpuhw->state, hwc->config_base);
+
+	/* The counter set to which this counter belongs can be already active.
+	 * Because all counters in a set are active, the event->hw.prev_count
+	 * needs to be synchronized.  At this point, the counter set can be in
+	 * the inactive or disabled state.
+	 */
+	hw_perf_event_reset(event);
+
+	/* increment refcount for this counter set */
+	atomic_inc(&cpuhw->ctr_set[hwc->config_base]);
+}
+
+static void cpumf_pmu_stop(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!(hwc->state & PERF_HES_STOPPED)) {
+		/* Decrement reference count for this counter set and if this
+		 * is the last used counter in the set, clear activation
+		 * control and set the counter set state to inactive.
+		 */
+		if (!atomic_dec_return(&cpuhw->ctr_set[hwc->config_base]))
+			ctr_set_stop(&cpuhw->state, hwc->config_base);
+		event->hw.state |= PERF_HES_STOPPED;
+	}
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		hw_perf_event_update(event);
+		event->hw.state |= PERF_HES_UPTODATE;
+	}
+}
+
+static int cpumf_pmu_add(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	/* Check authorization for the counter set to which this
+	 * counter belongs.
+	 * For group events transaction, the authorization check is
+	 * done in cpumf_pmu_commit_txn().
+	 */
+	if (!(cpuhw->flags & PERF_EVENT_TXN))
+		if (validate_ctr_auth(&event->hw))
+			return -EPERM;
+
+	ctr_set_enable(&cpuhw->state, event->hw.config_base);
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	if (flags & PERF_EF_START)
+		cpumf_pmu_start(event, PERF_EF_RELOAD);
+
+	perf_event_update_userpage(event);
+
+	return 0;
+}
+
+static void cpumf_pmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpumf_pmu_stop(event, PERF_EF_UPDATE);
+
+	/* Check if any counter in the counter set is still used.  If not used,
+	 * change the counter set to the disabled state.  This also clears the
+	 * content of all counters in the set.
+	 *
+	 * When a new perf event has been added but not yet started, this can
+	 * clear enable control and resets all counters in a set.  Therefore,
+	 * cpumf_pmu_start() always has to reenable a counter set.
+	 */
+	if (!atomic_read(&cpuhw->ctr_set[event->hw.config_base]))
+		ctr_set_disable(&cpuhw->state, event->hw.config_base);
+
+	perf_event_update_userpage(event);
+}
+
+/*
+ * Start group events scheduling transaction.
+ * Set flags to perform a single test at commit time.
+ */
+static void cpumf_pmu_start_txn(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	perf_pmu_disable(pmu);
+	cpuhw->flags |= PERF_EVENT_TXN;
+	cpuhw->tx_state = cpuhw->state;
+}
+
+/*
+ * Stop and cancel a group events scheduling tranctions.
+ * Assumes cpumf_pmu_del() is called for each successful added
+ * cpumf_pmu_add() during the transaction.
+ */
+static void cpumf_pmu_cancel_txn(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	WARN_ON(cpuhw->tx_state != cpuhw->state);
+
+	cpuhw->flags &= ~PERF_EVENT_TXN;
+	perf_pmu_enable(pmu);
+}
+
+/*
+ * Commit the group events scheduling transaction.  On success, the
+ * transaction is closed.   On error, the transaction is kept open
+ * until cpumf_pmu_cancel_txn() is called.
+ */
+static int cpumf_pmu_commit_txn(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	u64 state;
+
+	/* check if the updated state can be scheduled */
+	state = cpuhw->state & ~((1 << CPUMF_LCCTL_ENABLE_SHIFT) - 1);
+	state >>= CPUMF_LCCTL_ENABLE_SHIFT;
+	if ((state & cpuhw->info.auth_ctl) != state)
+		return -EPERM;
+
+	cpuhw->flags &= ~PERF_EVENT_TXN;
+	perf_pmu_enable(pmu);
+	return 0;
+}
+
+/* Performance monitoring unit for s390x */
+static struct pmu cpumf_pmu = {
+	.pmu_enable   = cpumf_pmu_enable,
+	.pmu_disable  = cpumf_pmu_disable,
+	.event_init   = cpumf_pmu_event_init,
+	.add	      = cpumf_pmu_add,
+	.del	      = cpumf_pmu_del,
+	.start	      = cpumf_pmu_start,
+	.stop	      = cpumf_pmu_stop,
+	.read	      = cpumf_pmu_read,
+	.start_txn    = cpumf_pmu_start_txn,
+	.commit_txn   = cpumf_pmu_commit_txn,
+	.cancel_txn   = cpumf_pmu_cancel_txn,
+};
+
+static int __cpuinit cpumf_pmu_notifier(struct notifier_block *self,
+					unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long) hcpu;
+	int flags;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+		flags = PMC_INIT;
+		smp_call_function_single(cpu, setup_pmc_cpu, &flags, 1);
+		break;
+	case CPU_DOWN_PREPARE:
+		flags = PMC_RELEASE;
+		smp_call_function_single(cpu, setup_pmc_cpu, &flags, 1);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static int __init cpumf_pmu_init(void)
+{
+	int rc;
+
+	if (!cpum_cf_avail())
+		return -ENODEV;
+
+	/* clear bit 15 of cr0 to unauthorize problem-state to
+	 * extract measurement counters */
+	ctl_clear_bit(0, 48);
+
+	/* register handler for measurement-alert interruptions */
+	rc = register_external_interrupt(0x1407, cpumf_measurement_alert);
+	if (rc) {
+		pr_err("Registering for CPU-measurement alerts "
+		       "failed with rc=%i\n", rc);
+		goto out;
+	}
+
+	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", PERF_TYPE_RAW);
+	if (rc) {
+		pr_err("Registering the cpum_cf PMU failed with rc=%i\n", rc);
+		unregister_external_interrupt(0x1407, cpumf_measurement_alert);
+		goto out;
+	}
+	perf_cpu_notifier(cpumf_pmu_notifier);
+out:
+	return rc;
+}
+early_initcall(cpumf_pmu_init);
diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
new file mode 100644
index 0000000..609f985
--- /dev/null
+++ b/arch/s390/kernel/perf_event.c
@@ -0,0 +1,125 @@
+/*
+ * Performance event support for s390x
+ *
+ *  Copyright IBM Corp. 2012
+ *  Author(s): Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+#define KMSG_COMPONENT	"perf"
+#define pr_fmt(fmt)	KMSG_COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <linux/percpu.h>
+#include <linux/export.h>
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <asm/cpu_mf.h>
+#include <asm/lowcore.h>
+#include <asm/processor.h>
+
+const char *perf_pmu_name(void)
+{
+	if (cpum_cf_avail() || cpum_sf_avail())
+		return "CPU-measurement facilities (CPUMF)";
+	return "pmu";
+}
+EXPORT_SYMBOL(perf_pmu_name);
+
+int perf_num_counters(void)
+{
+	int num = 0;
+
+	if (cpum_cf_avail())
+		num += PERF_CPUM_CF_MAX_CTR;
+
+	return num;
+}
+EXPORT_SYMBOL(perf_num_counters);
+
+void perf_event_print_debug(void)
+{
+	struct cpumf_ctr_info cf_info;
+	unsigned long flags;
+	int cpu;
+
+	if (!cpum_cf_avail())
+		return;
+
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	memset(&cf_info, 0, sizeof(cf_info));
+	if (!qctri(&cf_info)) {
+		pr_info("CPU[%i] CPUM_CF: ver=%u.%u A=%04x E=%04x C=%04x\n",
+			cpu, cf_info.cfvn, cf_info.csvn,
+			cf_info.auth_ctl, cf_info.enable_ctl, cf_info.act_ctl);
+		print_hex_dump_bytes("CPUMF Query: ", DUMP_PREFIX_OFFSET,
+				     &cf_info, sizeof(cf_info));
+	}
+
+	local_irq_restore(flags);
+}
+
+/* See also arch/s390/kernel/traps.c */
+static unsigned long __store_trace(struct perf_callchain_entry *entry,
+				   unsigned long sp,
+				   unsigned long low, unsigned long high)
+{
+	struct stack_frame *sf;
+	struct pt_regs *regs;
+
+	while (1) {
+		sp = sp & PSW_ADDR_INSN;
+		if (sp < low || sp > high - sizeof(*sf))
+			return sp;
+		sf = (struct stack_frame *) sp;
+		perf_callchain_store(entry, sf->gprs[8] & PSW_ADDR_INSN);
+		/* Follow the backchain. */
+		while (1) {
+			low = sp;
+			sp = sf->back_chain & PSW_ADDR_INSN;
+			if (!sp)
+				break;
+			if (sp <= low || sp > high - sizeof(*sf))
+				return sp;
+			sf = (struct stack_frame *) sp;
+			perf_callchain_store(entry,
+					     sf->gprs[8] & PSW_ADDR_INSN);
+		}
+		/* Zero backchain detected, check for interrupt frame. */
+		sp = (unsigned long) (sf + 1);
+		if (sp <= low || sp > high - sizeof(*regs))
+			return sp;
+		regs = (struct pt_regs *) sp;
+		perf_callchain_store(entry, sf->gprs[8] & PSW_ADDR_INSN);
+		low = sp;
+		sp = regs->gprs[15];
+	}
+}
+
+void perf_callchain_kernel(struct perf_callchain_entry *entry,
+			   struct pt_regs *regs)
+{
+	unsigned long head;
+	struct stack_frame *head_sf;
+
+	if (user_mode(regs))
+		return;
+
+	head = regs->gprs[15];
+	head_sf = (struct stack_frame *) head;
+
+	if (!head_sf || !head_sf->back_chain)
+		return;
+
+	head = head_sf->back_chain;
+	head = __store_trace(entry, head, S390_lowcore.async_stack - ASYNC_SIZE,
+			     S390_lowcore.async_stack);
+
+	__store_trace(entry, head, S390_lowcore.thread_info,
+		      S390_lowcore.thread_info + THREAD_SIZE);
+}
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index a0155c0..2857c48 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -100,7 +100,6 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
-EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
 
 #else
 
@@ -175,6 +174,5 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
-EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
 
 #endif
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 12bea05..f097d51 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -17,8 +17,7 @@
 #include <linux/semaphore.h>
 #include <linux/oom.h>
 #include <linux/oprofile.h>
-
-#include <asm/lowcore.h>
+#include <asm/cpu_mf.h>
 #include <asm/irq.h>
 
 #include "hwsampler.h"
@@ -30,12 +29,6 @@
 #define ALERT_REQ_MASK   0x4000000000000000ul
 #define BUFFER_FULL_MASK 0x8000000000000000ul
 
-#define EI_IEA      (1 << 31)	/* invalid entry address              */
-#define EI_ISE      (1 << 30)	/* incorrect SDBT entry               */
-#define EI_PRA      (1 << 29)	/* program request alert              */
-#define EI_SACA     (1 << 23)	/* sampler authorization change alert */
-#define EI_LSDA     (1 << 22)	/* loss of sample data alert          */
-
 DECLARE_PER_CPU(struct hws_cpu_buffer, sampler_cpu_buffer);
 
 struct hws_execute_parms {
@@ -232,9 +225,20 @@ static inline unsigned long *trailer_entry_ptr(unsigned long v)
 	return (unsigned long *) ret;
 }
 
-/* prototypes for external interrupt handler and worker */
 static void hws_ext_handler(struct ext_code ext_code,
-			    unsigned int param32, unsigned long param64);
+			    unsigned int param32, unsigned long param64)
+{
+	struct hws_cpu_buffer *cb = &__get_cpu_var(sampler_cpu_buffer);
+
+	if (!(param32 & CPU_MF_INT_SF_MASK))
+		return;
+
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_CPM]++;
+	atomic_xchg(&cb->ext_params, atomic_read(&cb->ext_params) | param32);
+
+	if (hws_wq)
+		queue_work(hws_wq, &cb->worker);
+}
 
 static void worker(struct work_struct *work);
 
@@ -673,18 +677,6 @@ int hwsampler_activate(unsigned int cpu)
 	return rc;
 }
 
-static void hws_ext_handler(struct ext_code ext_code,
-			    unsigned int param32, unsigned long param64)
-{
-	struct hws_cpu_buffer *cb;
-
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CPM]++;
-	cb = &__get_cpu_var(sampler_cpu_buffer);
-	atomic_xchg(&cb->ext_params, atomic_read(&cb->ext_params) | param32);
-	if (hws_wq)
-		queue_work(hws_wq, &cb->worker);
-}
-
 static int check_qsi_on_setup(void)
 {
 	int rc;
@@ -760,23 +752,23 @@ static int worker_check_error(unsigned int cpu, int ext_params)
 	if (!sdbt || !*sdbt)
 		return -EINVAL;
 
-	if (ext_params & EI_PRA)
+	if (ext_params & CPU_MF_INT_SF_PRA)
 		cb->req_alert++;
 
-	if (ext_params & EI_LSDA)
+	if (ext_params & CPU_MF_INT_SF_LSDA)
 		cb->loss_of_sample_data++;
 
-	if (ext_params & EI_IEA) {
+	if (ext_params & CPU_MF_INT_SF_IAE) {
 		cb->invalid_entry_address++;
 		rc = -EINVAL;
 	}
 
-	if (ext_params & EI_ISE) {
+	if (ext_params & CPU_MF_INT_SF_ISE) {
 		cb->incorrect_sdbt_entry++;
 		rc = -EINVAL;
 	}
 
-	if (ext_params & EI_SACA) {
+	if (ext_params & CPU_MF_INT_SF_SACA) {
 		cb->sample_auth_change_alert++;
 		rc = -EINVAL;
 	}
@@ -1009,7 +1001,7 @@ int hwsampler_deallocate(void)
 	if (hws_state != HWS_STOPPED)
 		goto deallocate_exit;
 
-	ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
+	measurement_alert_subclass_unregister();
 	deallocate_sdbt();
 
 	hws_state = HWS_DEALLOCATED;
@@ -1123,7 +1115,7 @@ int hwsampler_shutdown(void)
 		mutex_lock(&hws_sem);
 
 		if (hws_state == HWS_STOPPED) {
-			ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
+			measurement_alert_subclass_unregister();
 			deallocate_sdbt();
 		}
 		if (hws_wq) {
@@ -1198,7 +1190,7 @@ start_all_exit:
 	hws_oom = 1;
 	hws_flush_all = 0;
 	/* now let them in, 1407 CPUMF external interrupts */
-	ctl_set_bit(0, 5); /* set CR0 bit 58 */
+	measurement_alert_subclass_register();
 
 	return 0;
 }
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 2a0dfcb..35c685c 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1458,7 +1458,6 @@ int qdio_establish(struct qdio_initialize *init_data)
 	}
 
 	qdio_setup_ssqd_info(irq_ptr);
-	DBF_EVENT("qib ac:%4x", irq_ptr->qib.ac);
 
 	qdio_detect_hsicq(irq_ptr);
 
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 452989a..ecf12f0 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -311,7 +311,8 @@ void qdio_setup_ssqd_info(struct qdio_irq *irq_ptr)
 
 	check_and_setup_qebsm(irq_ptr, qdioac, irq_ptr->ssqd_desc.sch_token);
 	process_ac_flags(irq_ptr, qdioac);
-	DBF_EVENT("qdioac:%4x", qdioac);
+	DBF_EVENT("ac 1:%2x 2:%4x", qdioac, irq_ptr->ssqd_desc.qdioac2);
+	DBF_EVENT("3:%4x qib:%4x", irq_ptr->ssqd_desc.qdioac3, irq_ptr->qib.ac);
 }
 
 void qdio_release_memory(struct qdio_irq *irq_ptr)

