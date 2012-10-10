Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2JJMz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab2JJMyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:54:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf x86: Adding hardware events translations for intel cpus
Date: Wed, 10 Oct 2012 14:53:13 +0200
Message-Id: <1349873598-12583-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for intel processors to display 'events' sysfs
directory (/sys/devices/cpu/events/) with hw event translations.

  # ls  /sys/devices/cpu/events/
  branch-instructions
  branch-misses
  bus-cycles
  cache-misses
  cache-references
  cpu-cycles
  instructions
  ref-cycles
  stalled-cycles-backend
  stalled-cycles-frontend

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       | 40 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |  2 ++
 include/linux/perf_event.h             |  2 ++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9b6f83c..1fbf319 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1384,6 +1384,46 @@ static struct attribute_group x86_pmu_events_group = {
 	.attrs = events_attr,
 };
 
+ssize_t x86_event_sysfs_show(char *page, u64 config)
+{
+	u64 event  = (config & ARCH_PERFMON_EVENTSEL_EVENT);
+	u64 umask  = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
+	u64 cmask  = (config & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
+	bool edge  = (config & ARCH_PERFMON_EVENTSEL_EDGE);
+	bool pc    = (config & ARCH_PERFMON_EVENTSEL_PIN_CONTROL);
+	bool any   = (config & ARCH_PERFMON_EVENTSEL_ANY);
+	bool inv   = (config & ARCH_PERFMON_EVENTSEL_INV);
+	ssize_t ret;
+
+	/*
+	* We have whole page size to spend and just little data
+	* to write, so we can safely use sprintf.
+	*/
+	ret = sprintf(page, "event=0x%02llx", event);
+
+	if (umask)
+		ret += sprintf(page + ret, ",umask=0x%02llx", umask);
+
+	if (edge)
+		ret += sprintf(page + ret, ",edge");
+
+	if (pc)
+		ret += sprintf(page + ret, ",pc");
+
+	if (any)
+		ret += sprintf(page + ret, ",any");
+
+	if (inv)
+		ret += sprintf(page + ret, ",inv");
+
+	if (cmask)
+		ret += sprintf(page + ret, ",cmask=0x%02llx", cmask);
+
+	ret += sprintf(page + ret, "\n");
+
+	return ret;
+}
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7f2739e..f711ca2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1628,6 +1628,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 	.guest_get_msrs		= core_guest_get_msrs,
 	.format_attrs		= intel_arch_formats_attr,
+	.events_sysfs_show	= x86_event_sysfs_show,
 };
 
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1766,6 +1767,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.pebs_aliases		= intel_pebs_aliases_core2,
 
 	.format_attrs		= intel_arch3_formats_attr,
+	.events_sysfs_show	= x86_event_sysfs_show,
 
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 28f9cee..ee9c9d0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1418,5 +1418,7 @@ _name##_show(struct device *dev,					\
 									\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
+ssize_t x86_event_sysfs_show(char *page, u64 config);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
-- 
1.7.11.4

