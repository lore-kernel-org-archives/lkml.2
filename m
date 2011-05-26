Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1EZIgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:36:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:22040 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1EZIgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,272,1304319600"; 
   d="scan'208";a="7971568"
Subject: [PATCH 2/3] introduce intel_rapl driver
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, "Brown, Len" <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 16:34:17 +0800
Message-ID: <1306398857.2207.157.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce Intel RAPL driver.

RAPL (running average power limit) is a new feature which provides mechanisms
to enforce power consumption limit, on some new processors.

RAPL provides MSRs reporting the total amount of energy consumed
by the package/core/uncore/dram.
Further more, by using RAPL, OS can set a power bugdet in a certain time window,
and let Hardware to throttle the processor P/T-state to meet this enery limitation.

Currently, we don't have the plan to support the RAPL power control,
but we do want to export the package/core/uncore/dram power consumption
information via perf tool first.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/platform/x86/Kconfig      |    8 
 drivers/platform/x86/Makefile     |    1 
 drivers/platform/x86/intel_rapl.c |  368 ++++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h        |    4 
 4 files changed, 381 insertions(+)

Index: linux-2.6/drivers/platform/x86/Kconfig
===================================================================
--- linux-2.6.orig/drivers/platform/x86/Kconfig
+++ linux-2.6/drivers/platform/x86/Kconfig
@@ -753,4 +753,12 @@ config SAMSUNG_LAPTOP
 	  To compile this driver as a module, choose M here: the module
 	  will be called samsung-laptop.
 
+config INTEL_RAPL
+	tristate "Intel RAPL Support"
+	depends on X86
+	default y
+	---help---
+	  RAPL, AKA, Running Average Power Limit provides mechanisms to enforce
+	  power consumption limit.
+
 endif # X86_PLATFORM_DEVICES
Index: linux-2.6/drivers/platform/x86/Makefile
===================================================================
--- linux-2.6.orig/drivers/platform/x86/Makefile
+++ linux-2.6/drivers/platform/x86/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_XO15_EBOOK)	+= xo15-ebook.o
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_SAMSUNG_LAPTOP)	+= samsung-laptop.o
 obj-$(CONFIG_INTEL_MFLD_THERMAL)	+= intel_mid_thermal.o
+obj-$(CONFIG_INTEL_RAPL)	+= intel_rapl.o
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -107,6 +107,10 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_PKG_ENERGY		= 9,
+	PERF_COUNT_SW_CORE_ENERGY		= 10,
+	PERF_COUNT_SW_UNCORE_ENERGY		= 11,
+	PERF_COUNT_SW_DRAM_ENERGY		= 12,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
Index: linux-2.6/drivers/platform/x86/intel_rapl.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/platform/x86/intel_rapl.c
@@ -0,0 +1,368 @@
+/*
+ *  Intel RAPL interface driver
+ *
+ *  Copyright (C) 2010-2011 Zhang Rui <rui.zhang@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <asm/processor.h>
+#include <linux/perf_event.h>
+
+MODULE_AUTHOR("Zhang Rui");
+MODULE_DESCRIPTION("Intel RAPL interface Driver");
+MODULE_LICENSE("GPL");
+
+#define PREFIX "Intel: RAPL: "
+
+#define MSR_RAPL_POWER_UNIT		0x606
+
+/*
+ * Platform specific RAPL Domains.
+ * Note that PP1 RAPL Domain is supported on 062A only
+ * And DRAM RAPL Domain is supported on 062D only
+ */
+/* Package RAPL Domain */
+#define MSR_PKG_RAPL_POWER_LIMIT	0x610
+#define MSR_PKG_ENERGY_STATUS		0x611
+#define MSR_PKG_PERF_STATUS		0x613
+#define MSR_PKG_POWER_INFO		0x614
+
+/* PP0 RAPL Domain */
+#define MSR_PP0_POWER_LIMIT		0x638
+#define MSR_PP0_ENERGY_STATUS		0x639
+#define MSR_PP0_POLICY			0x63A
+#define MSR_PP0_PERF_STATUS		0x63B
+
+/* PP1 RAPL Domain, may reflect to uncore devices */
+#define MSR_PP1_POWER_LIMIT		0x640
+#define MSR_PP1_ENERGY_STATUS		0x641
+#define MSR_PP1_POLICY			0x642
+
+/* DRAM RAPL Domain */
+#define MSR_DRAM_POWER_LIMIT		0x618
+#define MSR_DRAM_ENERGY_STATUS		0x619
+#define MSR_DRAM_PERF_STATUS		0x61B
+#define MSR_DRAM_POWER_INFO		0x61C
+
+/* RAPL UNIT BITMASK */
+#define POWER_UNIT_OFFSET	0
+#define POWER_UNIT_MASK		0x0F
+
+#define ENERGY_UNIT_OFFSET	0x08
+#define ENERGY_UNIT_MASK	0x1F00
+
+#define TIME_UNIT_OFFSET	0x10
+#define TIME_UNIT_MASK		0xF000
+
+static int rapl_pmu_pkg_event_init(struct perf_event *event);
+static int rapl_pmu_core_event_init(struct perf_event *event);
+static int rapl_pmu_uncore_event_init(struct perf_event *event);
+static int rapl_pmu_dram_event_init(struct perf_event *event);
+static void rapl_event_start(struct perf_event *event, int flags);
+static void rapl_event_stop(struct perf_event *event, int flags);
+static int rapl_event_add(struct perf_event *event, int flags);
+static void rapl_event_del(struct perf_event *event, int flags);
+static void rapl_event_read(struct perf_event *event);
+
+enum rapl_domain_id {
+	RAPL_DOMAIN_PKG,
+	RAPL_DOMAIN_PP0,
+	RAPL_DOMAIN_PP1,
+	RAPL_DOMAIN_DRAM,
+	RAPL_DOMAIN_MAX
+};
+
+struct rapl_domain_msr {
+	int	limit;
+	int	status;
+};
+
+struct rapl_domain {
+	enum rapl_domain_id domain_id;
+	struct rapl_domain_msr msrs;
+	struct pmu pmu;
+	enum perf_sw_ids event_id;
+	int valid;
+};
+
+#define to_rapl_domain(p) container_of(p, struct rapl_domain, pmu);
+
+static struct rapl_domain rapl_domains[] = {
+	[RAPL_DOMAIN_PKG] = {
+		.domain_id = RAPL_DOMAIN_PKG,
+		.msrs	= {
+			.limit	= MSR_PKG_RAPL_POWER_LIMIT,
+			.status	= MSR_PKG_ENERGY_STATUS,
+		},
+		.pmu	= {
+			.name		= "rapl_pkg_energy_meter",
+			.event_init	= rapl_pmu_pkg_event_init,
+			.add		= rapl_event_add,
+			.del		= rapl_event_del,
+			.start		= rapl_event_start,
+			.stop		= rapl_event_stop,
+			.read		= rapl_event_read,
+		},
+		.event_id = PERF_COUNT_SW_PKG_ENERGY,
+		.valid	= 1,
+	},
+	[RAPL_DOMAIN_PP0] = {
+		.domain_id = RAPL_DOMAIN_PP0,
+		.msrs	= {
+			.limit	= MSR_PP0_POWER_LIMIT,
+			.status	= MSR_PP0_ENERGY_STATUS,
+		},
+		.pmu	= {
+			.name		= "rapl_core_energy_meter",
+			.event_init	= rapl_pmu_core_event_init,
+			.add		= rapl_event_add,
+			.del		= rapl_event_del,
+			.start		= rapl_event_start,
+			.stop		= rapl_event_stop,
+			.read		= rapl_event_read,
+		},
+		.event_id = PERF_COUNT_SW_CORE_ENERGY,
+		.valid	= 1,
+	},
+	[RAPL_DOMAIN_PP1] = {
+		.domain_id = RAPL_DOMAIN_PP1,
+		.msrs	= {
+			.limit	= MSR_PP1_POWER_LIMIT,
+			.status	= MSR_PP1_ENERGY_STATUS,
+		},
+		.pmu	= {
+			.name		= "rapl_uncore_energy_meter",
+			.event_init	= rapl_pmu_uncore_event_init,
+			.add		= rapl_event_add,
+			.del		= rapl_event_del,
+			.start		= rapl_event_start,
+			.stop		= rapl_event_stop,
+			.read		= rapl_event_read,
+		},
+		.event_id = PERF_COUNT_SW_UNCORE_ENERGY,
+	},
+	[RAPL_DOMAIN_DRAM] = {
+		.domain_id = RAPL_DOMAIN_DRAM,
+		.msrs	= {
+			.limit	= MSR_DRAM_POWER_LIMIT,
+			.status	= MSR_DRAM_ENERGY_STATUS,
+		},
+		.pmu	= {
+			.name		= "rapl_dram_energy_meter",
+			.event_init	= rapl_pmu_dram_event_init,
+			.add		= rapl_event_add,
+			.del		= rapl_event_del,
+			.start		= rapl_event_start,
+			.stop		= rapl_event_stop,
+			.read		= rapl_event_read,
+		},
+		.event_id = PERF_COUNT_SW_DRAM_ENERGY,
+	},
+};
+
+static unsigned int power_unit_divisor;
+static unsigned int energy_unit_divisor;
+static unsigned int time_unit_divisor;
+
+enum unit_type {
+	POWER_UNIT,
+	ENERGY_UNIT,
+	TIME_UNIT
+};
+static u64 rapl_unit_xlate(enum unit_type type, u64 value, int action)
+{
+	u64 divisor;
+
+	switch (type) {
+	case POWER_UNIT:
+		divisor = power_unit_divisor;
+		break;
+	case ENERGY_UNIT:
+		divisor = energy_unit_divisor;
+		break;
+	case TIME_UNIT:
+		divisor = time_unit_divisor;
+		break;
+	default:
+		return 0;
+	};
+
+	if (action)
+		return value * divisor; /* value is from users */
+	else
+		return div64_u64(value, divisor); /* value is from MSR */
+}
+
+/* show the energy status, in Jelous */
+static int rapl_read_energy(struct rapl_domain *domain)
+{
+	u64 value;
+	u32 msr = domain->msrs.status;
+
+	rdmsrl(msr, value);
+	return rapl_unit_xlate(ENERGY_UNIT, value, 0);
+}
+
+static void rapl_event_update(struct perf_event *event)
+{
+	s64 prev;
+	u64 now;
+	struct rapl_domain *domain = to_rapl_domain(event->pmu);
+
+	now = rapl_read_energy(domain);
+	prev = local64_xchg(&event->hw.prev_count, now);
+	local64_add(now - prev, &event->count);
+}
+
+static void rapl_event_start(struct perf_event *event, int flags)
+{
+	struct rapl_domain *domain = to_rapl_domain(event->pmu);
+
+	local64_set(&event->hw.prev_count, rapl_read_energy(domain));
+	perf_swevent_start_hrtimer(event);
+}
+
+static void rapl_event_stop(struct perf_event *event, int flags)
+{
+	perf_swevent_cancel_hrtimer(event);
+	rapl_event_update(event);
+}
+
+static int rapl_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		rapl_event_start(event, flags);
+	return 0;
+}
+static void rapl_event_del(struct perf_event *event, int flags)
+{
+	rapl_event_stop(event, flags);
+}
+
+static void rapl_event_read(struct perf_event *event)
+{
+	rapl_event_update(event);
+}
+
+static int rapl_pmu_event_init(struct perf_event *event,
+			       enum rapl_domain_id id)
+{
+	struct rapl_domain *domain = &(rapl_domains[id]);
+
+	if (event->attr.type != PERF_TYPE_SOFTWARE)
+		return -ENOENT;
+
+	if (event->attr.config != domain->event_id)
+		return -ENOENT;
+
+	/* Do periodecal update every second */
+	event->attr.freq = 1;
+	event->attr.sample_period = 1;
+
+	perf_swevent_init_hrtimer(event);
+
+	return 0;
+}
+
+static int rapl_pmu_pkg_event_init(struct perf_event *event)
+{
+	return rapl_pmu_event_init(event, RAPL_DOMAIN_PKG);
+}
+
+static int rapl_pmu_core_event_init(struct perf_event *event)
+{
+	return rapl_pmu_event_init(event, RAPL_DOMAIN_PP0);
+}
+
+static int rapl_pmu_uncore_event_init(struct perf_event *event)
+{
+	return rapl_pmu_event_init(event, RAPL_DOMAIN_PP1);
+}
+
+static int rapl_pmu_dram_event_init(struct perf_event *event)
+{
+	return rapl_pmu_event_init(event, RAPL_DOMAIN_DRAM);
+}
+
+static int rapl_check_unit(void)
+{
+	u64 output;
+	u32 value;
+
+	rdmsrl(MSR_RAPL_POWER_UNIT, output);
+
+	/* energy unit: 1/enery_unit_divisor Joules */
+	value = (output & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
+	energy_unit_divisor = 1 << value;
+
+	/* power unit: 1/power_unit_divisor Watts */
+	value = (output & POWER_UNIT_MASK) >> POWER_UNIT_OFFSET;
+	power_unit_divisor = 1 << value;
+
+	/* time unit: 1/time_unit_divisor Seconds */
+	value =(output & TIME_UNIT_MASK) >> TIME_UNIT_OFFSET;
+	time_unit_divisor = 1 << value;
+
+	return 0;
+}
+
+static int __init intel_rapl_init(void)
+{
+	enum rapl_domain_id id;
+
+	/*
+	 * RAPL features are only supported on processors have a CPUID
+	 * signature with DisplayFamily_DisplayModel of 06_2AH, 06_2DH
+	 */
+	if (boot_cpu_data.x86 != 0x06)
+		return -ENODEV;
+
+	if (boot_cpu_data.x86_model == 0x2A)
+		rapl_domains[RAPL_DOMAIN_PP1].valid = 1;
+	else if (boot_cpu_data.x86_model == 0x2D)
+		rapl_domains[RAPL_DOMAIN_DRAM].valid = 1;
+	else
+		return -ENODEV;
+
+	if (rapl_check_unit())
+		return -ENODEV;
+
+	for(id = 0; id < RAPL_DOMAIN_MAX; id++)
+		if (rapl_domains[id].valid)
+			perf_pmu_register(&(rapl_domains[id].pmu), rapl_domains[id].pmu.name, PERF_TYPE_SOFTWARE);
+	return 0;
+}
+
+static void __exit intel_rapl_exit(void)
+{
+	enum rapl_domain_id id;
+
+	for(id = 0; id < RAPL_DOMAIN_MAX; id++)
+		if (rapl_domains[id].valid)
+			perf_pmu_unregister(&(rapl_domains[id].pmu));
+}
+
+module_init(intel_rapl_init);
+module_exit(intel_rapl_exit);


