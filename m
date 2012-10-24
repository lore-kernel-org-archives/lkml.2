Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab2JXKHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:07:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2JXKG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:06:59 -0400
Date: Wed, 24 Oct 2012 03:05:35 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0bf79d44133de42af01a70a1700b8bb4b6d3fb92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349873598-12583-5-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add hardware events translations for AMD cpus
Git-Commit-ID: 0bf79d44133de42af01a70a1700b8bb4b6d3fb92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:05:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bf79d44133de42af01a70a1700b8bb4b6d3fb92
Gitweb:     http://git.kernel.org/tip/0bf79d44133de42af01a70a1700b8bb4b6d3fb92
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:25 +0200

perf/x86: Add hardware events translations for AMD cpus

Add support for AMD processors to display 'events' sysfs
directory (/sys/devices/cpu/events/) with hw event translations:

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
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-5-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c       |    3 +--
 arch/x86/kernel/cpu/perf_event.h       |    2 +-
 arch/x86/kernel/cpu/perf_event_amd.c   |    9 +++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |   11 +++++++++--
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8a1fa23..0a55ab2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1392,9 +1392,8 @@ static struct attribute_group x86_pmu_events_group = {
 	.attrs = events_attr,
 };
 
-ssize_t x86_event_sysfs_show(char *page, u64 config)
+ssize_t x86_event_sysfs_show(char *page, u64 config, u64 event)
 {
-	u64 event  = (config & ARCH_PERFMON_EVENTSEL_EVENT);
 	u64 umask  = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	u64 cmask  = (config & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
 	bool edge  = (config & ARCH_PERFMON_EVENTSEL_EDGE);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index f8aa2f6..21419b9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -538,7 +538,7 @@ static inline void set_linear_ip(struct pt_regs *regs, unsigned long ip)
 	regs->ip = ip;
 }
 
-ssize_t x86_event_sysfs_show(char *page, u64 config);
+ssize_t x86_event_sysfs_show(char *page, u64 config, u64 event);
 
 #ifdef CONFIG_CPU_SUP_AMD
 
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
index 6106d3b..93b9e11 100644
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
