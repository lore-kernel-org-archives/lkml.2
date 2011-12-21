Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1LULS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:18:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45348 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1LULSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:21 -0500
Message-Id: <20111221111143.620776435@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:45 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/7] printk: Poke printk extra hard
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=printk-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 ++
 init/main.c           |    1 +
 kernel/sched/core.c   |   18 ++++++++++++++++++
 lib/Kconfig.debug     |   12 ++++++++++++
 4 files changed, 33 insertions(+)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2742,6 +2742,8 @@ static inline unsigned long rlimit_max(u
 	return task_rlimit_max(current, limit);
 }
 
+extern void printk_init(void);
+
 #endif /* __KERNEL__ */
 
 #endif
--- a/init/main.c
+++ b/init/main.c
@@ -591,6 +591,7 @@ asmlinkage void __init start_kernel(void
 		initrd_start = 0;
 	}
 #endif
+	printk_init();
 	page_cgroup_init();
 	debug_objects_mem_init();
 	kmemleak_init();
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6953,6 +6953,24 @@ void __init sched_init(void)
 	scheduler_running = 1;
 }
 
+#ifdef CONFIG_PRINTK_DEBUG
+void printk_init(void)
+{
+	struct rq *rq;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	rq = this_rq();
+	raw_spin_lock(&rq->lock);
+	printk(KERN_DEBUG "printk: echo echo echo..\n");
+	raw_spin_unlock(&rq->lock);
+	local_irq_restore(flags);
+
+}
+#else
+void printk_init(void) { };
+#endif
+
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -644,6 +644,18 @@ config DEBUG_LOCKDEP
 	  additional runtime checks to debug itself, at the price
 	  of more runtime overhead.
 
+config PRINTK_DEBUG
+	bool "Printk() wakeup debugging"
+	depends on PROVE_LOCKING
+	default n
+	help
+	 This feature registers a boot time dependency between rq->lock and
+	 printk(), this is useful to determine if your particular console
+	 setup issues wakeups while writing to the console. This is interesting
+	 to know since those that do are less reliable for debugging purposes.
+
+	 Say N if you are unsure.
+
 config TRACE_IRQFLAGS
 	bool
 	help


