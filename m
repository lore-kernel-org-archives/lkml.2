Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab0LHBju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:39:50 -0500
Received: from kroah.org ([198.145.64.141]:48878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab0LHBAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:52 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:32 2010
Message-Id: <20101208005732.340957276@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [110/289] oprofile: Fix the hang while taking the cpu offline
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/oprofile/timer_int.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
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


