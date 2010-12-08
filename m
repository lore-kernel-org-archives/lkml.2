Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0LHUm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:42:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:34674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0LHUmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:42:54 -0500
Date: Wed, 8 Dec 2010 20:42:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        vgoyal@redhat.com, ebiederm@xmission.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        vgoyal@redhat.com, ebiederm@xmission.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Stop all counters on reboot
Message-ID: <tip-c277443cfc29b1623b4923219ff0bdb48b91b589@git.kernel.org>
Git-Commit-ID: c277443cfc29b1623b4923219ff0bdb48b91b589
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:42:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c277443cfc29b1623b4923219ff0bdb48b91b589
Gitweb:     http://git.kernel.org/tip/c277443cfc29b1623b4923219ff0bdb48b91b589
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Dec 2010 15:29:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:16:31 +0100

perf: Stop all counters on reboot

Use the reboot notifier to detach all running counters on reboot, this
solves a problem with kexec where the new kernel doesn't expect
running counters (rightly so).

It will however decrease the coverage of the NMI watchdog. Making a
kexec specific reboot notifier callback would be best, however that
would require touching all notifier callback handlers as they are not
properly structured to deal with new state.

As a compromise, place the perf reboot notifier at the very last
position in the list.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Don Zickus <dzickus@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 77ad22c..f9d2645 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -21,6 +21,7 @@
 #include <linux/dcache.h>
 #include <linux/percpu.h>
 #include <linux/ptrace.h>
+#include <linux/reboot.h>
 #include <linux/vmstat.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
@@ -6429,7 +6430,7 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	mutex_unlock(&swhash->hlist_mutex);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
+#if defined CONFIG_HOTPLUG_CPU || defined CONFIG_KEXEC
 static void perf_pmu_rotate_stop(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
@@ -6483,6 +6484,26 @@ static void perf_event_exit_cpu(int cpu)
 static inline void perf_event_exit_cpu(int cpu) { }
 #endif
 
+static int
+perf_reboot(struct notifier_block *notifier, unsigned long val, void *v)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		perf_event_exit_cpu(cpu);
+
+	return NOTIFY_OK;
+}
+
+/*
+ * Run the perf reboot notifier at the very last possible moment so that
+ * the generic watchdog code runs as long as possible.
+ */
+static struct notifier_block perf_reboot_notifier = {
+	.notifier_call = perf_reboot,
+	.priority = INT_MIN,
+};
+
 static int __cpuinit
 perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
@@ -6518,6 +6539,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
+	register_reboot_notifier(&perf_reboot_notifier);
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
