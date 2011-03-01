Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1CAQOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:14:01 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:37943 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1CAQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:13:59 -0500
MIME-Version: 1.0
Date: Tue, 1 Mar 2011 17:06:26 +0100
Message-ID: <AANLkTi=WRo41JprvcEH0Lgc_-j_bTX1MULgJFShV6W9g@mail.gmail.com>
Subject: [PATCH V6 2/2] tracing, perf: add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org,
        mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace the cpu state and the time spent in core and arch code

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/cpu.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 156cc55..8abb84b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -16,6 +16,9 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>

+#define CREATE_TRACE_POINTS
+#include <trace/events/cpu_hotplug.h>
+
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
@@ -197,10 +200,13 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned int cpu = (unsigned int)(param->hcpu);
 	int err;

 	/* Ensure this CPU doesn't handle any more interrupts. */
+	trace_cpu_hotplug_disable_start(cpu);
 	err = __cpu_disable();
+	trace_cpu_hotplug_disable_end(cpu);
 	if (err < 0)
 		return err;

@@ -256,7 +262,9 @@ static int __ref _cpu_down(unsigned int cpu, int
tasks_frozen)
 		cpu_relax();

 	/* This actually kills the CPU. */
+	trace_cpu_hotplug_die_start(cpu);
 	__cpu_die(cpu);
+	trace_cpu_hotplug_die_end(cpu);

 	/* CPU is completely dead: tell everyone.  Too late to complain. */
 	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
@@ -276,6 +284,8 @@ int __ref cpu_down(unsigned int cpu)

 	cpu_maps_update_begin();

+	trace_cpu_hotplug_down_start(cpu);
+
 	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
 		goto out;
@@ -284,6 +294,8 @@ int __ref cpu_down(unsigned int cpu)
 	err = _cpu_down(cpu, 0);

 out:
+	trace_cpu_hotplug_down_end(cpu);
+
 	cpu_maps_update_done();
 	return err;
 }
@@ -310,7 +322,9 @@ static int __cpuinit _cpu_up(unsigned int cpu, int
tasks_frozen)
 	}

 	/* Arch-specific enabling code. */
+	trace_cpu_hotplug_arch_up_start(cpu);
 	ret = __cpu_up(cpu);
+	trace_cpu_hotplug_arch_up_end(cpu);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
@@ -369,6 +383,8 @@ int __cpuinit cpu_up(unsigned int cpu)

 	cpu_maps_update_begin();

+	trace_cpu_hotplug_up_start(cpu);
+
 	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
 		goto out;
@@ -377,6 +393,8 @@ int __cpuinit cpu_up(unsigned int cpu)
 	err = _cpu_up(cpu, 0);

 out:
+	trace_cpu_hotplug_up_end(cpu);
+
 	cpu_maps_update_done();
 	return err;
 }
-- 
1.7.1
