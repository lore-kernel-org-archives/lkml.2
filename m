Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab1FAMgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:36:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40681 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897Ab1FAMgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:36:05 -0400
Date: Wed, 1 Jun 2011 18:05:54 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf_events: Enable idle state tracing for pseries (ppc64)
Message-ID: <20110601123554.GA12492@deepthi.in.ibm.com>
Reply-To: deepthi@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find below a patch, which has perf_events added for pseries (ppc64)
platform in order to emit the trace required for perf timechart. 
It essentially enables perf timechart for pseries platfrom to analyse
power savings events like cpuidle states.

Steps to enable and disable the trace;
1) Mount  debugfs;
   mount -t debugfs none /sys/kernel/debug
2) Then, enable the event using;
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_idle/enable
3) The output of the trace can be seen in /sys/kernel/debug/tracing/trace
4) To disable the trace use;
    echo 0 > sys/kernel/debug/tracing/events/power/cpu_idle/enable

Trace .svg o/p can be viewed for pseries (ppc64) systems showing various 
cpu-idle states as a part of perf timechart tool. 
References: http://blog.fenrus.org/?p=5

Issue command 'perf timechart record' to enable tracing. 
This generates the trace and records in  perf.data file by default.
One can generate output.svg file by issuing 'perf timechart'. 

Sample o/p from the trace file: 
===============================

State 1 -> Snooze
State 2 -> Cede

# tracer: nop
#
TASK-PID    CPU#    TIMESTAMP  FUNCTION
  | |       |          |         |
<idle>-0     [000]   292.482314: cpu_idle: state=1 cpu_id=0 
						^^ Enter Snooze
<idle>-0     [001]   292.482363: cpu_idle: state=1 cpu_id=1
<idle>-0     [000]   292.492315: cpu_idle: state=4294967295 cpu_id=0
						^^ Exit Snooze 	
<idle>-0     [000]   292.492316: cpu_idle: state=2 cpu_id=0 
						^^ Enter  Cede 
<idle>-0     [001]   292.492364: cpu_idle: state=4294967295 cpu_id=1
<idle>-0     [001]   292.492364: cpu_idle: state=2 cpu_id=1	
<idle>-0     [000]   292.504198: cpu_idle: state=4294967295 cpu_id=0 
						^^Exit Cede 
<idle>-0     [000]   292.504204: cpu_idle: state=1 cpu_id=0
<idle>-0     [001]   292.504921: cpu_idle: state=4294967295 cpu_id=1
<idle>-0     [001]   292.504936: cpu_idle: state=1 cpu_id=1
<idle>-0     [000]   292.514205: cpu_idle: state=4294967295 cpu_id=0    

This patch applies on 2.6.39 and tested on a IBM POWER7 machine.  

-Deepthi

Adding perf events to trace various cpu idle states on ppc64 (pseries) platform.
Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

pseries.h |    4 ++++
setup.c   |   14 ++++++++++++++
2 files changed, 18 insertions(+)

Index: linux-2.6.39/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- linux-2.6.39.orig/arch/powerpc/platforms/pseries/setup.c	2011-05-19 00:06:34.000000000 -0400
+++ linux-2.6.39/arch/powerpc/platforms/pseries/setup.c	2011-06-01 07:46:00.000000000 -0400
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
+#include <trace/events/power.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
@@ -582,6 +583,10 @@
 	 * while, do so.
 	 */
 	if (snooze) {
+
+		trace_power_start(POWER_CSTATE, CPU_IDLE_SNOOZE, cpu);
+		trace_cpu_idle(CPU_IDLE_SNOOZE, cpu);
+
 		start_snooze = get_tb() + snooze * tb_ticks_per_usec;
 		local_irq_enable();
 		set_thread_flag(TIF_POLLING_NRFLAG);
@@ -602,9 +607,19 @@
 			goto out;
 	}
 
+	trace_power_end(cpu);
+	trace_cpu_idle(PWR_EVENT_EXIT, cpu);
+
+	trace_power_start(POWER_CSTATE, CPU_IDLE_CEDE, cpu);
+	trace_cpu_idle(CPU_IDLE_CEDE, cpu);
+
 	cede_processor();
 
 out:
+
+	trace_power_end(cpu);
+	trace_cpu_idle(PWR_EVENT_EXIT, cpu);
+
 	HMT_medium();
 	out_purr = mfspr(SPRN_PURR);
 	get_lppaca()->wait_state_cycles += out_purr - in_purr;
Index: linux-2.6.39/arch/powerpc/platforms/pseries/pseries.h
===================================================================
--- linux-2.6.39.orig/arch/powerpc/platforms/pseries/pseries.h	2011-05-19 00:06:34.000000000 -0400
+++ linux-2.6.39/arch/powerpc/platforms/pseries/pseries.h	2011-06-01 07:53:24.000000000 -0400
@@ -12,6 +12,9 @@
 
 #include <linux/interrupt.h>
 
+#define CPU_IDLE_SNOOZE 1
+#define CPU_IDLE_CEDE	 2
+
 struct device_node;
 
 extern void request_event_sources_irqs(struct device_node *np,
@@ -56,4 +59,5 @@
 extern int dlpar_attach_node(struct device_node *);
 extern int dlpar_detach_node(struct device_node *);
 
+
 #endif /* _PSERIES_PSERIES_H */
