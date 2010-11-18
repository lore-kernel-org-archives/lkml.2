Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab0KROFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:05:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab0KROFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:05:24 -0500
Date: Thu, 18 Nov 2010 14:04:41 GMT
From: tip-bot for Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jason.wessel@windriver.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4CD3396D.1090308@windriver.com>
References: <4CD3396D.1090308@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf,hw_breakpoint: Initialize hardware api earlier
Message-ID: <tip-3c502e7a0255d82621ff25d60cc816624830497e@git.kernel.org>
Git-Commit-ID: 3c502e7a0255d82621ff25d60cc816624830497e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:04:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c502e7a0255d82621ff25d60cc816624830497e
Gitweb:     http://git.kernel.org/tip/3c502e7a0255d82621ff25d60cc816624830497e
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Thu, 4 Nov 2010 17:33:01 -0500
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 12 Nov 2010 14:51:55 +0100

perf,hw_breakpoint: Initialize hardware api earlier

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
