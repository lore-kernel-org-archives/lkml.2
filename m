Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0LGXai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 18:30:38 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50375 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0LGXah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 18:30:37 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <20101202161502.GL18100@redhat.com>
References: <1291219906.32004.1671.camel@laptop>
	 <20101201162335.GB2511@redhat.com> <1291232292.32004.1969.camel@laptop>
	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>
	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins>  <20101202161502.GL18100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 00:30:20 +0100
Message-ID: <1291764620.2032.1293.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 11:15 -0500, Don Zickus wrote:

> Vivek suggested to me this morning that I should just blantantly disable the
> perf counter during init when running my test. 

Nah, we should actively scan for that during the bring-up and kill
hw-perf when we find an enable bit set, some BIOSes actively use the
PMU, this is something that should be discouraged.

---
 arch/x86/kernel/cpu/perf_event.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 817d2b1..7f92833 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -375,15 +375,40 @@ static void release_pmc_hardware(void) {}
 static bool check_hw_exists(void)
 {
 	u64 val, val_new = 0;
-	int ret = 0;
+	int i, reg, ret = 0;
 
 	val = 0xabcdUL;
 	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
 	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
-	if (ret || val != val_new)
+	if (ret || val != val_new) {
+		printk(KERN_CONT "Broken PMU hardware detected, software events only.\n");
 		return false;
+	}
+
+	/*
+	 * Check to see if the BIOS enabled any of the counters, if so
+	 * complain and bail.
+	 */
+	for (i = 0; i < x86_pmu.num_counters; i++) {
+		reg = x86_pmu.eventsel + i;
+		rdmsrl(reg, val);
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
+			goto bios_fail;
+	}
+
+	for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
+		reg = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+		rdmsrl(reg, val);
+		if (val & (0x03 << i*4))
+			goto bios_fail;
+	}
 
 	return true;
+
+bios_fail:
+	printk(KERN_CONT "Broken BIOS detected, software events only.\n");
+	printk(KERN_ERR FW_BUG "invalid MSR %x=%Lx\n", reg, val);
+	return false;
 }
 
 static void reserve_ds_buffers(void);
@@ -1379,7 +1404,6 @@ int __init init_hw_perf_events(void)
 
 	/* sanity check that the hardware exists or is emulated */
 	if (!check_hw_exists()) {
-		pr_cont("Broken PMU hardware detected, software events only.\n");
 		return 0;
 	}
 



>  Looking through the code I
> don't think I can do this using disable_all because some routines look for
> the active bit to be set and some arches have different disable registers
> than others.  Thoughts?

Something like the below, preferably I'd key that off of SYS_KEXEC, but
looking through the existing notifiers adding a state requires touching
all of them :/

---
 kernel/perf_event.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 195393c..7abcd8d 100644
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
@@ -6383,6 +6384,25 @@ static void perf_event_exit_cpu(int cpu)
 static inline void perf_event_exit_cpu(int cpu) { }
 #endif
 
+static int 
+perf_reboot(struct notifier_block *notifier, unsigned long val, void *v)
+{
+	/*
+	 * XXX this relies on hotplug, does kexec do too?
+	 */
+	perf_event_exit_cpu(0);
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
@@ -6418,6 +6438,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
+	register_reboot_notifier(&perf_reboot_notifier);
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);

