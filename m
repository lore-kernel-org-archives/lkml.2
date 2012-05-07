Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2EGSBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:01:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:41381 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2EGR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:49 -0400
Message-Id: <20120507175652.049316594@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/8] smp: Implement kick_all_cpus_sync()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=smp-implement-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will replace the misnomed cpu_idle_wait() function which is copied a
gazillion times all over arch/*

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/smp.h |    4 ++++
 kernel/smp.c        |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

Index: tip/include/linux/smp.h
===================================================================
--- tip.orig/include/linux/smp.h
+++ tip/include/linux/smp.h
@@ -81,6 +81,8 @@ void __smp_call_function_single(int cpui
 int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
 
+void kick_all_cpus_sync(void);
+
 /*
  * Generic and arch helpers
  */
@@ -192,6 +194,8 @@ smp_call_function_any(const struct cpuma
 	return smp_call_function_single(0, func, info, wait);
 }
 
+static inline void kick_all_cpus_sync(void) {  }
+
 #endif /* !SMP */
 
 /*
Index: tip/kernel/smp.c
===================================================================
--- tip.orig/kernel/smp.c
+++ tip/kernel/smp.c
@@ -795,3 +795,26 @@ void on_each_cpu_cond(bool (*cond_func)(
 	}
 }
 EXPORT_SYMBOL(on_each_cpu_cond);
+
+static void do_nothing(void *unused)
+{
+}
+
+/**
+ * kick_all_cpus_sync - Force all cpus out of idle
+ *
+ * Used to synchronize the update of pm_idle function pointer. It's
+ * called after the pointer is updated and returns after the dummy
+ * callback function has been executed on all cpus. The execution of
+ * the function can only happen on the remote cpus after they have
+ * left the idle function which had been called via pm_idle function
+ * pointer. So it's guaranteed that nothing uses the previous pointer
+ * anymore.
+ */
+void kick_all_cpus_sync(void)
+{
+	/* Make sure the change is visible before we kick the cpus */
+	smp_mb();
+	smp_call_function(do_nothing, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(kick_all_cpus_sync);


