Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1GPLXC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:23:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1GPLWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:53 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=bLye3BLX62cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=q8jxh6WljTeAyj2c1qgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=lVY02w76U0392dEz:21 a=cvPRRLyqI_cx_5v3:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112251.723060362@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/20] ftrace: Do not disable interrupts for modules in mcount update
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Do-not-disable-interrupts-for-modules-in-mcou.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When I mounted an NFS directory, it caused several modules to be loaded. At the
time I was running the preemptirqsoff tracer, and it showed the following
output:

# tracer: preemptirqsoff
#
# preemptirqsoff latency trace v1.1.5 on 2.6.33.9-rt30-mrg-test
# --------------------------------------------------------------------
# latency: 1177 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: modprobe-19370 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: ftrace_module_notify
#  => ended at:   ftrace_module_notify
#
#
#                  _------=> CPU#
#                 / _-----=> irqs-off
#                | / _----=> need-resched
#                || / _---=> hardirq/softirq
#                ||| / _--=> preempt-depth
#                |||| /_--=> lock-depth
#                |||||/     delay
#  cmd     pid   |||||| time  |   caller
#     \   /      ||||||   \   |   /
modprobe-19370   3d....    0us!: ftrace_process_locs <-ftrace_module_notify
modprobe-19370   3d.... 1176us : ftrace_process_locs <-ftrace_module_notify
modprobe-19370   3d.... 1178us : trace_hardirqs_on <-ftrace_module_notify
modprobe-19370   3d.... 1178us : <stack trace>
 => ftrace_process_locs
 => ftrace_module_notify
 => notifier_call_chain
 => __blocking_notifier_call_chain
 => blocking_notifier_call_chain
 => sys_init_module
 => system_call_fastpath

That's over 1ms that interrupts are disabled on a Real-Time kernel!

Looking at the cause (being the ftrace author helped), I found that the
interrupts are disabled before the code modification of mcounts into nops. The
interrupts only need to be disabled on start up around this code, not when
modules are being loaded.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c997f73..df93392 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3318,7 +3318,7 @@ static int ftrace_process_locs(struct module *mod,
 {
 	unsigned long *p;
 	unsigned long addr;
-	unsigned long flags;
+	unsigned long flags = 0; /* Shut up gcc */
 
 	mutex_lock(&ftrace_lock);
 	p = start;
@@ -3336,12 +3336,18 @@ static int ftrace_process_locs(struct module *mod,
 	}
 
 	/*
-	 * Disable interrupts to prevent interrupts from executing
-	 * code that is being modified.
+	 * We only need to disable interrupts on start up
+	 * because we are modifying code that an interrupt
+	 * may execute, and the modification is not atomic.
+	 * But for modules, nothing runs the code we modify
+	 * until we are finished with it, and there's no
+	 * reason to cause large interrupt latencies while we do it.
 	 */
-	local_irq_save(flags);
+	if (!mod)
+		local_irq_save(flags);
 	ftrace_update_code(mod);
-	local_irq_restore(flags);
+	if (!mod)
+		local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
 	return 0;
-- 
1.7.5.4


