Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032878Ab2CST5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:57:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574Ab2CST5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:57:18 -0400
Date: Mon, 19 Mar 2012 12:56:51 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-vhdk5y2hyype9j63prymty36@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Adding sysfs group format attribute for pmu device
Git-Commit-ID: 641cc938815dfd09f8fa1ec72deb814f0938ac33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 12:56:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  641cc938815dfd09f8fa1ec72deb814f0938ac33
Gitweb:     http://git.kernel.org/tip/641cc938815dfd09f8fa1ec72deb814f0938ac33
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 15 Mar 2012 20:09:14 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 14:06:06 -0300

perf: Adding sysfs group format attribute for pmu device

Adding sysfs group 'format' attribute for pmu device that
contains a syntax description on how to construct raw events.

The event configuration is described in following
struct pefr_event_attr attributes:

  config
  config1
  config2

Each sysfs attribute within the format attribute group,
describes mapping of name and bitfield definition within
one of above attributes.

eg:
  "/sys/...<dev>/format/event" contains "config:0-7"
  "/sys/...<dev>/format/umask" contains "config:8-15"
  "/sys/...<dev>/format/usr"   contains "config:16"

the attribute value syntax is:

  line:      config ':' bits
  config:    'config' | 'config1' | 'config2"
  bits:      bits ',' bit_term | bit_term
  bit_term:  VALUE '-' VALUE | VALUE

Adding format attribute definitions for x86 cpu pmus.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-vhdk5y2hyype9j63prymty36@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../testing/sysfs-bus-event_source-devices-format  |   14 ++++++++
 arch/x86/kernel/cpu/perf_event.c                   |    7 ++++
 arch/x86/kernel/cpu/perf_event.h                   |    1 +
 arch/x86/kernel/cpu/perf_event_amd.c               |   18 ++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c             |   36 ++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c                |   19 ++++++++++
 include/linux/perf_event.h                         |   14 ++++++++
 7 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
new file mode 100644
index 0000000..079afc7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -0,0 +1,14 @@
+Where:		/sys/bus/event_source/devices/<dev>/format
+Date:		January 2012
+Kernel Version: 3.3
+Contact:	Jiri Olsa <jolsa@redhat.com>
+Description:
+		Attribute group to describe the magic bits that go into
+		perf_event_attr::config[012] for a particular pmu.
+		Each attribute of this group defines the 'hardware' bitmask
+		we want to export, so that userspace can deal with sane
+		name/value pairs.
+
+		Example: 'config1:1,6-10,44'
+		Defines contents of attribute that occupies bits 1,6-10,44 of
+		perf_event_attr::config1.
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0a18d16..453ac94 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1314,6 +1314,11 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
+static struct attribute_group x86_pmu_format_group = {
+	.name = "format",
+	.attrs = NULL,
+};
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1388,6 +1393,7 @@ static int __init init_hw_perf_events(void)
 	}
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
@@ -1668,6 +1674,7 @@ static struct attribute_group x86_pmu_attr_group = {
 
 static const struct attribute_group *x86_pmu_attr_groups[] = {
 	&x86_pmu_attr_group,
+	&x86_pmu_format_group,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8484e77..6638aaf 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -339,6 +339,7 @@ struct x86_pmu {
 	 * sysfs attrs
 	 */
 	int		attr_rdpmc;
+	struct attribute **format_attrs;
 
 	/*
 	 * CPU Hotplug hooks
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index dd002fa..95e7fe1 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -404,6 +404,21 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *amd_format_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -426,6 +441,8 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
+	.format_attrs		= amd_format_attr,
+
 	.cpu_prepare		= amd_pmu_cpu_prepare,
 	.cpu_starting		= amd_pmu_cpu_starting,
 	.cpu_dead		= amd_pmu_cpu_dead,
@@ -596,6 +613,7 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 	.cpu_dead		= amd_pmu_cpu_dead,
 #endif
 	.cpu_starting		= amd_pmu_cpu_starting,
+	.format_attrs		= amd_format_attr,
 };
 
 __init int amd_pmu_init(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6a84e7f..26b3e2f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1431,6 +1431,24 @@ static void core_pmu_enable_all(int added)
 	}
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(pc,	"config:19"	);
+PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_arch_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -1455,6 +1473,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 	.guest_get_msrs		= core_guest_get_msrs,
+	.format_attrs		= intel_arch_formats_attr,
 };
 
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1553,6 +1572,21 @@ static void intel_pmu_flush_branch_stack(void)
 		intel_pmu_lbr_reset();
 }
 
+PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
+
+static struct attribute *intel_arch3_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_any.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+
+	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	NULL,
+};
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -1576,6 +1610,8 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
 
+	.format_attrs		= intel_arch3_formats_attr,
+
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index c7181be..32bcfc7 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -87,6 +87,23 @@ static void p6_pmu_enable_event(struct perf_event *event)
 	(void)checking_wrmsrl(hwc->config_base, val);
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(pc,	"config:19"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_p6_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -115,6 +132,8 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.cntval_mask		= (1ULL << 32) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= p6_event_constraints,
+
+	.format_attrs		= intel_p6_formats_attr,
 };
 
 __init int p6_pmu_init(void)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bd9f55a..57ae485 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -550,6 +550,7 @@ struct perf_guest_info_callbacks {
 #include <linux/irq_work.h>
 #include <linux/static_key.h>
 #include <linux/atomic.h>
+#include <linux/sysfs.h>
 #include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -1291,5 +1292,18 @@ do {									\
 	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 
+
+#define PMU_FORMAT_ATTR(_name, _format)					\
+static ssize_t								\
+_name##_show(struct device *dev,					\
+			       struct device_attribute *attr,		\
+			       char *page)				\
+{									\
+	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);			\
+	return sprintf(page, _format "\n");				\
+}									\
+									\
+static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
