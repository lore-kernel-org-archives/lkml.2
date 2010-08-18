Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0HRH4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:56:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:36167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0HRH43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:56:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,226,1280732400"; 
   d="scan'208";a="313863906"
Subject: [RFC PATCH 2/3] perf: introduce new pmu and event to show package
 energy status in perf
From: Zhang Rui <rui.zhang@intel.com>
To: peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, robert.richter@amd.com,
        acme@redhat.com, paulus@samba.org, dzickus@redhat.com,
        gorcunov@gmail.com, fweisbec@gmail.com,
        Lin Ming <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:59:32 +0800
Message-ID: <1282118372.5181.117.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce new pmu and event to show package energy status in perf.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/platform/x86/Kconfig      |    8 +
 drivers/platform/x86/Makefile     |    1 
 drivers/platform/x86/intel_rapl.c |  217 ++++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h        |    1 
 4 files changed, 227 insertions(+)

Index: linux-2.6/drivers/platform/x86/Kconfig
===================================================================
--- linux-2.6.orig/drivers/platform/x86/Kconfig
+++ linux-2.6/drivers/platform/x86/Kconfig
@@ -541,4 +541,12 @@ config INTEL_SCU_IPC
 	  some embedded Intel x86 platforms. This is not needed for PC-type
 	  machines.
 
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
@@ -26,3 +26,4 @@ obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-
 obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
 obj-$(CONFIG_TOSHIBA_BT_RFKILL)	+= toshiba_bluetooth.o
 obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
+obj-$(CONFIG_INTEL_RAPL)	+= intel_rapl.o
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -105,6 +105,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_RAPL_ENERGY		= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
Index: linux-2.6/drivers/platform/x86/intel_rapl.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/platform/x86/intel_rapl.c
@@ -0,0 +1,217 @@
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
+/* MSRs that are supported on both 062A and 062D */
+#define MSR_RAPL_POWER_UNIT		0x606
+
+#define MSR_PKG_RAPL_POWER_LIMIT	0x610
+#define MSR_PKG_ENERGY_STATUS		0x611
+#define MSR_PKG_PERF_STATUS		0x613
+#define MSR_PKG_POWER_INFO		0x614
+
+#define MSR_PP0_POWER_LIMIT		0x638
+#define MSR_PP0_ENERGY_STATUS		0x639
+#define MSR_PP0_POLICY			0x63A
+#define MSR_PP0_PERF_STATUS		0x63B
+
+/* MSRs that are supported on 062A */
+#define MSR_PP1_POWER_LIMIT		0x640
+#define MSR_PP1_ENERGY_STATUS		0x641
+#define MSR_PP1_POLICY			0x642
+
+/* MSRs that are supported on 062D */
+#define MSR_DRAM_POWER_LIMIT		0x618
+#define MSR_DRAM_ENERGY_STATUS		0x619
+#define MSR_DRAM_PERF_STATUS		0x61B
+#define MSR_DRAM_POWER_INFO		0x61C
+
+enum rapl_type {
+	RAPL_PKG,
+	RAPL_DRAM,
+	RAPL_PP0,
+	RAPL_PP1
+};
+
+enum rapl_unit {
+	POWER_UNIT_DEFAULT,	/* 0011b, 1/8 Watts */
+	ENERGY_UNIT_DEFAULT,	/* 10000b, 15.3 micro Joules */
+	TIME_UNIT_DEFAULT,	/* 1010b, 976 micro-seconds */
+	UNIT_UNKNOWN
+};
+
+enum rapl_unit power_unit_type;
+enum rapl_unit energy_unit_type;
+enum rapl_unit time_unit_type;
+
+#define POWER_UNIT_OFFSET	0x00
+#define POWER_UNIT_MASK		0x0F
+
+#define ENERGY_UNIT_OFFSET	0x08
+#define ENERGY_UNIT_MASK	0x1F00
+
+#define TIME_UNIT_OFFSET	0x16
+#define TIME_UNIT_MASK		0xF0000
+
+static int to_joules(u32 value)
+{
+	u32 low, high;
+
+	switch (energy_unit_type) {
+	case ENERGY_UNIT_DEFAULT:
+		high = value / 10000000;
+		low = value % 10000000;
+		return (high * 153 + low * 153 / 10000000);
+	default:
+		break;
+	}
+	return 0;
+}
+
+/* return the PKG consumed energy, in Joules */
+static int rapl_read(void)
+{
+	u64 output;
+
+	rdmsrl(MSR_PKG_ENERGY_STATUS, output);
+	return to_joules((u32)output);
+}
+
+static void rapl_event_update(struct perf_event *event)
+{
+	s64 prev;
+	u64 now;
+
+	now = rapl_read();
+	prev = local64_xchg(&event->hw.prev_count, now);
+	local64_add(now - prev, &event->count);
+}
+
+static void rapl_event_start(struct perf_event *event, int flags)
+{
+	local64_set(&event->hw.prev_count, rapl_read());
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
+static int rapl_pmu_event_init(struct perf_event *event)
+{
+	if (event->attr.type != PERF_TYPE_SOFTWARE)
+		return -ENOENT;
+
+	if (event->attr.config != PERF_COUNT_SW_RAPL_ENERGY)
+		return -ENOENT;
+
+	return 0;
+}
+
+static struct pmu rapl_pmu = {
+	.event_init	= rapl_pmu_event_init,
+	.add		= rapl_event_add,
+	.del		= rapl_event_del,
+	.start		= rapl_event_start,
+	.stop		= rapl_event_stop,
+	.read		= rapl_event_read,
+};
+
+static int rapl_check_unit(void)
+{
+	u64 output;
+
+	rdmsrl(MSR_RAPL_POWER_UNIT, output);
+
+	/* We only care about the energy default unit so far */
+	if (((output & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET) == 0x10)
+		energy_unit_type = ENERGY_UNIT_DEFAULT;
+	else {
+		energy_unit_type = UNIT_UNKNOWN;
+		goto unknown_type;
+	}
+
+	return 0;
+
+unknown_type:
+	printk(KERN_WARNING PREFIX "unsupported unit\n");
+	return -ENODEV;
+}
+
+static int __init intel_rapl_init(void)
+{
+	/*
+	 * RAPL features are only supported on processors have a CPUID
+	 * signature with DisplayFamily_DisplayModel of 06_2AH, 06_2DH
+	 */
+	if (boot_cpu_data.x86 != 0x06 ||
+	    (boot_cpu_data.x86_model != 0x2A &&
+	    boot_cpu_data.x86_model != 0x2D))
+		return -ENODEV;
+
+	if (rapl_check_unit())
+		return -ENODEV;
+
+	perf_pmu_register(&rapl_pmu);
+	return 0;
+}
+
+static void __exit intel_rapl_exit(void)
+{
+	perf_pmu_unregister(&rapl_pmu);
+}
+
+module_init(intel_rapl_init);
+module_exit(intel_rapl_exit);


