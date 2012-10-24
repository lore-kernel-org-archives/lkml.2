Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab2JXKHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:07:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2JXKHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:07:37 -0400
Date: Wed, 24 Oct 2012 03:04:35 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-43c032febde48aabcf6d59f47cdcb7b5debbdc63@git.kernel.org>
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
In-Reply-To: <1349873598-12583-4-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add hardware events translations for Intel cpus
Git-Commit-ID: 43c032febde48aabcf6d59f47cdcb7b5debbdc63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:04:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43c032febde48aabcf6d59f47cdcb7b5debbdc63
Gitweb:     http://git.kernel.org/tip/43c032febde48aabcf6d59f47cdcb7b5debbdc63
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:24 +0200

perf/x86: Add hardware events translations for Intel cpus

Add support for Intel processors to display 'events' sysfs
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
Link: http://lkml.kernel.org/r/1349873598-12583-4-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c       |   40 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h       |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 39737a6..8a1fa23 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1392,6 +1392,46 @@ static struct attribute_group x86_pmu_events_group = {
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
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6f75b6a..f8aa2f6 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -538,6 +538,8 @@ static inline void set_linear_ip(struct pt_regs *regs, unsigned long ip)
 	regs->ip = ip;
 }
 
+ssize_t x86_event_sysfs_show(char *page, u64 config);
+
 #ifdef CONFIG_CPU_SUP_AMD
 
 int amd_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 324bb52..6106d3b 100644
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
