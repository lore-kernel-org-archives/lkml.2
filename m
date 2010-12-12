Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0LLXqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0LLXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:10 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: santosh.shilimkar@ti.com, r.sricharan@ti.com, robert.richter@amd.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [70/223] oprofile: Fix the hang while taking the cpu offline
Message-Id: <20101212234608.AEEA1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>

commit 4ac3dbec800d93485a5c84e37af676278eea657c upstream.

The kernel build with CONFIG_OPROFILE and CPU_HOTPLUG enabled.
The oprofile is initialised using system timer in absence of hardware
counters supports. Oprofile isn't started from userland.

In this setup while doing a CPU offline the kernel hangs in infinite
for loop inside lock_hrtimer_base() function

This happens because as part of oprofile_cpu_notify(, it tries to
stop an hrtimer which was never started. These per-cpu hrtimers
are started when the oprfile is started.
	echo 1	> /dev/oprofile/enable

This problem also existwhen the cpu is booted with maxcpus parameter
set. When bringing the remaining cpus online the timers are started
even if oprofile is not yet enabled.

This patch fix this issue by adding a state variable so that
these hrtimer start/stop is only attempted when oprofile is
started

For stable kernels v2.6.35.y and v2.6.36.y.

Reported-by: Jan Sebastien <s-jan@ti.com>
Tested-by: sricharan <r.sricharan@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/oprofile/timer_int.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux/drivers/oprofile/timer_int.c
===================================================================
--- linux.orig/drivers/oprofile/timer_int.c
+++ linux/drivers/oprofile/timer_int.c
@@ -21,6 +21,7 @@
 #include "oprof.h"
 
 static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
+static int ctr_running;
 
 static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
 {
@@ -33,6 +34,9 @@ static void __oprofile_hrtimer_start(voi
 {
 	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
 
+	if (!ctr_running)
+		return;
+
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = oprofile_hrtimer_notify;
 
@@ -42,7 +46,10 @@ static void __oprofile_hrtimer_start(voi
 
 static int oprofile_hrtimer_start(void)
 {
+	get_online_cpus();
+	ctr_running = 1;
 	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
+	put_online_cpus();
 	return 0;
 }
 
@@ -50,6 +57,9 @@ static void __oprofile_hrtimer_stop(int
 {
 	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
 
+	if (!ctr_running)
+		return;
+
 	hrtimer_cancel(hrtimer);
 }
 
@@ -57,8 +67,11 @@ static void oprofile_hrtimer_stop(void)
 {
 	int cpu;
 
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		__oprofile_hrtimer_stop(cpu);
+	ctr_running = 0;
+	put_online_cpus();
 }
 
 static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
