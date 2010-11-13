Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab0KMViT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 16:38:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45477 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0KMViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 16:38:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=JN6bkW8TJ7bChBJMx6sCB5BgfWUUwSSy7zGl5Q6VFIuYgPEdv2+yKlKwImp/RY5yyU
         0JVH5vyWqV+p2p8jEfH0fa1cMnDSk4BTJH1zF+GJ/3WTu4LthFH5YwiqwXb0lTI3do7h
         QEe2HW8OZk1G4vFXWxHq9uCwOpo7SHj07xY/0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] perf,hw_breakpoint: Initialize hardware api earlier
Date: Sat, 13 Nov 2010 22:37:53 +0100
Message-Id: <1289684273-26770-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

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
LKML-Reference: <4CD3396D.1090308@windriver.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/hw_breakpoint.h |    4 ++++
 kernel/hw_breakpoint.c        |    3 +--
 kernel/perf_event.c           |    6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index a2d6ea4..d1e55fe 100644
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
 
+static inline int __init init_hw_breakpoint(void) { return 0; }
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
index 517d827..05b7d8c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -31,6 +31,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/irq_regs.h>
 
@@ -6295,6 +6296,8 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 
 void __init perf_event_init(void)
 {
+	int ret;
+
 	perf_event_init_all_cpus();
 	init_srcu_struct(&pmus_srcu);
 	perf_pmu_register(&perf_swevent);
@@ -6302,4 +6305,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
+
+	ret = init_hw_breakpoint();
+	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 }
-- 
1.6.2.3

