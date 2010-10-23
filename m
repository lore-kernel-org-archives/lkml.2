Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0JWMMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 08:12:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46271 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0JWMMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 08:12:21 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: oprofile-list@lists.sf.net
Cc: linux-kernel@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        sricharan <r.sricharan@ti.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile: Fix the hang while offline the cpu
Date: Sat, 23 Oct 2010 17:42:06 +0530
Message-Id: <1287835926-1957-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel build with CONFIG_OPROFILE and CPU_HOTPLUG enabled.
The oprofile is initialised using system timer in absence of hardware
counters supports. Oprofile isn't started from userland.

In this setup while doing a CPU offline the kernel hangs in infinite
for loop inside lock_hrtimer_base() function

This happens because as part of oprofile_cpu_notify(, it tries to
stop an hrtimer which was never started. These per-cpu hrtimers
are started when the oprfile is started.
	echo 1	> /dev/oprofile/enable

This patch fix this issue by adding a state variable so that
these hrtimer start/stop is only attempted when oprofile is
started

Reported-by: Jan Sebastien <s-jan@ti.com>
Signed-off-by: sricharan <r.sricharan@ti.com>
Tested-by: sricharan <r.sricharan@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Cc: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/timer_int.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index dc0ae4d..de487ba 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -21,6 +21,7 @@
 #include "oprof.h"
 
 static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
+static int oprofile_hrtimer_started;
 
 static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
 {
@@ -33,6 +34,9 @@ static void __oprofile_hrtimer_start(void *unused)
 {
 	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
 
+	if (!oprofile_hrtimer_started)
+		return;
+
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = oprofile_hrtimer_notify;
 
@@ -42,6 +46,7 @@ static void __oprofile_hrtimer_start(void *unused)
 
 static int oprofile_hrtimer_start(void)
 {
+	oprofile_hrtimer_started = 1;
 	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
 	return 0;
 }
@@ -50,6 +55,9 @@ static void __oprofile_hrtimer_stop(int cpu)
 {
 	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
 
+	if (!oprofile_hrtimer_started)
+		return;
+
 	hrtimer_cancel(hrtimer);
 }
 
@@ -59,6 +67,7 @@ static void oprofile_hrtimer_stop(void)
 
 	for_each_online_cpu(cpu)
 		__oprofile_hrtimer_stop(cpu);
+	oprofile_hrtimer_started = 0;
 }
 
 static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
-- 
1.6.0.4

