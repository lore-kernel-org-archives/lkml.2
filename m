Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2JJMyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2JJMyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:54:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf x86: Adding hardware events translations for amd cpus
Date: Wed, 10 Oct 2012 14:53:14 +0200
Message-Id: <1349873598-12583-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for amd processors to display 'events' sysfs
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
 arch/x86/kernel/cpu/perf_event.c       |  3 +--
 arch/x86/kernel/cpu/perf_event_amd.c   |  9 +++++++++
 arch/x86/kernel/cpu/perf_event_intel.c | 11 +++++++++--
 include/linux/perf_event.h             |  2 +-
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1fbf319..476dab0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1384,9 +1384,8 @@ static struct attribute_group x86_pmu_events_group = {
 	.attrs = events_attr,
 };
 
-ssize_t x86_event_sysfs_show(char *page, u64 config)
+ssize_t x86_event_sysfs_show(char *page, u64 config, u64 event)
 {
-	u64 event  = (config & ARCH_PERFMON_EVENTSEL_EVENT);
 	u64 umask  = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	u64 cmask  = (config & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
 	bool edge  = (config & ARCH_PERFMON_EVENTSEL_EDGE);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4528ae7..c93bc4e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -568,6 +568,14 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 	}
 }
 
+static ssize_t amd_event_sysfs_show(char *page, u64 config)
+{
+	u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
+		    (config & AMD64_EVENTSEL_EVENT) >> 24;
+
+	return x86_event_sysfs_show(page, config, event);
+}
+
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -591,6 +599,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.put_event_constraints	= amd_put_event_constraints,
 
 	.format_attrs		= amd_format_attr,
+	.events_sysfs_show	= amd_event_sysfs_show,
 
 	.cpu_prepare		= amd_pmu_cpu_prepare,
 	.cpu_starting		= amd_pmu_cpu_starting,
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f711ca2..fe50274 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1603,6 +1603,13 @@ static struct attribute *intel_arch_formats_attr[] = {
 	NULL,
 };
 
+ssize_t intel_event_sysfs_show(char *page, u64 config)
+{
+	u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT);
+
+	return x86_event_sysfs_show(page, config, event);
+}
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -1628,7 +1635,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 	.guest_get_msrs		= core_guest_get_msrs,
 	.format_attrs		= intel_arch_formats_attr,
-	.events_sysfs_show	= x86_event_sysfs_show,
+	.events_sysfs_show	= intel_event_sysfs_show,
 };
 
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1767,7 +1774,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.pebs_aliases		= intel_pebs_aliases_core2,
 
 	.format_attrs		= intel_arch3_formats_attr,
-	.events_sysfs_show	= x86_event_sysfs_show,
+	.events_sysfs_show	= intel_event_sysfs_show,
 
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee9c9d0..827c374 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1418,7 +1418,7 @@ _name##_show(struct device *dev,					\
 									\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
-ssize_t x86_event_sysfs_show(char *page, u64 config);
+ssize_t x86_event_sysfs_show(char *page, u64 config, u64 event);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
-- 
1.7.11.4

