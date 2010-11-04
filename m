Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0KDWx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:53:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:57438 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0KDWxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:53:53 -0400
Message-ID: <4CD3396D.1090308@windriver.com>
Date: Thu, 04 Nov 2010 17:53:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf,hw_breakpoint: Initialize hardware api earlier
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2010 22:53:38.0872 (UTC) FILETIME=[1EB91380:01CB7C73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Frederic,

Per our conversation, here is a possible patch to fix the early
debugging.  It might be the case that you can kill off the return code
from the init_hw_breakpoint(), or at least do something with it.  It
was not obvious to me what you might want to emit for a mess or act on
if the initialization fails.


Thanks,
Jason.


--
>From 7c425dba3a4522343faf3519f3d0e99e2e55f30c Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Thu, 4 Nov 2010 17:33:01 -0500
Subject: [PATCH] perf,hw_breakpoint: Initialize hardware api earlier

When using early debugging, the kernel does not initialize the
hw_breakpoint API early enough and causes the late initialization of
the kernel debugger to fail. The boot arguments are:

    earlyprintk=vga ekgdboc=kbd kgdbwait

Then simply type "go" at the kdb prompt and boot. The kernel will
later emit the message:

    kgdb: Could not allocate hwbreakpoints

And at that point the kernel debugger will cease to work correctly.

The solution is to initialize the hw_breakpoint at the same time that
all the other perf call backs are initialized instead of using a
core_initcall() initialization which happens well after the kernel
debugger can make use of hardware breakpoints.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hw_breakpoint.h |    4 ++++
 kernel/hw_breakpoint.c        |    3 +--
 kernel/perf_event.c           |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index a2d6ea4..d9d1799 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -33,6 +33,8 @@ enum bp_type_idx {
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+extern int __init init_hw_breakpoint(void);
+
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
 {
 	memset(attr, 0, sizeof(*attr));
@@ -108,6 +110,8 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 
 #else /* !CONFIG_HAVE_HW_BREAKPOINT */
 
+static inline extern int __init init_hw_breakpoint(void) { return 0; }
+
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 2c9120f..e532582 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -620,7 +620,7 @@ static struct pmu perf_breakpoint = {
 	.read		= hw_breakpoint_pmu_read,
 };
 
-static int __init init_hw_breakpoint(void)
+int __init init_hw_breakpoint(void)
 {
 	unsigned int **task_bp_pinned;
 	int cpu, err_cpu;
@@ -655,6 +655,5 @@ static int __init init_hw_breakpoint(void)
 
 	return -ENOMEM;
 }
-core_initcall(init_hw_breakpoint);
 
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 517d827..b1eb5c6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -31,6 +31,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/irq_regs.h>
 
@@ -6302,4 +6303,5 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
+	init_hw_breakpoint();
 }
-- 
1.6.3.3

