Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0LHOdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:33:45 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54983 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0LHOdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:33:44 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <20101208140103.GM21786@redhat.com>
References: <1291232292.32004.1969.camel@laptop>
	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>
	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	 <1291764620.2032.1293.camel@laptop>  <20101208140103.GM21786@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 15:33:31 +0100
Message-ID: <1291818811.28378.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 09:01 -0500, Don Zickus wrote:
> Privately, I used the above wrapped with for_each_online_cpu(cpu) and it
> worked fine for me. 


Something like so then?

---
Subject: perf: Stop all counters on reboot
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Dec 08 15:29:02 CET 2010

Use the reboot notifier to detach all running counters on reboot, this
solves a problem with kexec where the new kernel doesn't expect
running counters (rightly so).

It will however decrease the coverage of the NMI watchdog. Making a
kexec specific reboot notifier callback would be best, however that
would require touching all notifier callback handlers as they are not
properly structured to deal with new state.

As a compromise, place the perf reboot notifier at the very last
position in the list.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -21,6 +21,7 @@
 #include <linux/dcache.h>
 #include <linux/percpu.h>
 #include <linux/ptrace.h>
+#include <linux/reboot.h>
 #include <linux/vmstat.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
@@ -6329,7 +6330,7 @@ static void __cpuinit perf_event_init_cp
 	mutex_unlock(&swhash->hlist_mutex);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
+#if defined CONFIG_HOTPLUG_CPU || defined CONFIG_KEXEC
 static void perf_pmu_rotate_stop(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
@@ -6383,6 +6384,26 @@ static void perf_event_exit_cpu(int cpu)
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
@@ -6418,6 +6439,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
+	register_reboot_notifier(&perf_reboot_notifier);
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);

