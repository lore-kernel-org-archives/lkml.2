Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0DFNjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:39:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab0DFNjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:39:15 -0400
Message-Id: <20100406133140.903644813@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 06 Apr 2010 15:28:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, David Miller <davem@davemloft.net>, acme@redhat.com,
       paulus@samba.org, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-arch@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 1/3] kernel: local_irq_{save,restore}_nmi()
References: <20100406132807.698467930@chello.nl>
Content-Disposition: inline; filename=nmi-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide local_irq_{save,restore}_nmi() which will allow us to help
architectures that implement NMIs using IRQ priorities like SPARC64
does.

Sparc uses IRQ prio 15 for NMIs and implements local_irq_disable() as
disable <= 14. However if you do that while inside an NMI you re-
enable the NMI priority again, causing all kinds of fun.

A more solid implementation would first check the disable level and
never lower it, however that is more costly and would slow down the
rest of the kernel for no particular reason.

Therefore introduce local_irq_save_nmi() which can implement this
slower but more solid scheme and dis-allow local_irq_save() from NMI
context.

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/irqflags.h     |   51 ++++++++++++++++++++++++++++++++++++++++---
 kernel/lockdep.c             |    7 +++++
 kernel/trace/trace_irqsoff.c |    8 ++++++
 3 files changed, 63 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/irqflags.h
===================================================================
--- linux-2.6.orig/include/linux/irqflags.h
+++ linux-2.6/include/linux/irqflags.h
@@ -18,6 +18,7 @@
   extern void trace_softirqs_off(unsigned long ip);
   extern void trace_hardirqs_on(void);
   extern void trace_hardirqs_off(void);
+  extern void trace_hardirqs_off_no_nmi(void);
 # define trace_hardirq_context(p)	((p)->hardirq_context)
 # define trace_softirq_context(p)	((p)->softirq_context)
 # define trace_hardirqs_enabled(p)	((p)->hardirqs_enabled)
@@ -30,6 +31,7 @@
 #else
 # define trace_hardirqs_on()		do { } while (0)
 # define trace_hardirqs_off()		do { } while (0)
+# define trace_hardirqs_off_no_nmi()	do { } while (0)
 # define trace_softirqs_on(ip)		do { } while (0)
 # define trace_softirqs_off(ip)		do { } while (0)
 # define trace_hardirq_context(p)	0
@@ -59,15 +61,15 @@
 #define local_irq_enable() \
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
-	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
+	do { raw_local_irq_disable(); trace_hardirqs_off_no_nmi(); } while (0)
+
 #define local_irq_save(flags)				\
 	do {						\
 		typecheck(unsigned long, flags);	\
 		raw_local_irq_save(flags);		\
-		trace_hardirqs_off();			\
+		trace_hardirqs_off_no_nmi();		\
 	} while (0)
 
-
 #define local_irq_restore(flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
@@ -79,6 +81,30 @@
 			raw_local_irq_restore(flags);	\
 		}					\
 	} while (0)
+
+#ifndef local_irq_save_nmi
+# define local_irq_save_nmi(flags) 			\
+	 do {						\
+		 typecheck(unsigned long, flags);	\
+		 raw_local_irq_save(flags);		\
+		 trace_hardirqs_off();			\
+	 } while (0)
+#endif
+
+#ifndef local_irq_restore_nmi
+#define local_irq_restore_nmi(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		if (raw_irqs_disabled_flags(flags)) {	\
+			raw_local_irq_restore(flags);	\
+			trace_hardirqs_off();		\
+		} else {				\
+			trace_hardirqs_on();		\
+			raw_local_irq_restore(flags);	\
+		}					\
+	} while (0)
+#endif
+
 #else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
 /*
  * The local_irq_*() APIs are equal to the raw_local_irq*()
@@ -86,16 +112,35 @@
  */
 # define raw_local_irq_disable()	local_irq_disable()
 # define raw_local_irq_enable()		local_irq_enable()
+
 # define raw_local_irq_save(flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
 		local_irq_save(flags);			\
 	} while (0)
+
 # define raw_local_irq_restore(flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
 		local_irq_restore(flags);		\
 	} while (0)
+
+#ifndef local_irq_save_nmi
+# define local_irq_save_nmi(flags)			\
+	 do {						\
+		 typecheck(unsigned long, flags);	\
+		 local_irq_save(flags);			\
+	 } while (0)
+#endif
+
+#ifndef local_irq_restore_nmi
+# define local_irq_restore_nmi(flags)			\
+	 do {						\
+		 typecheck(unsigned long, flags);	\
+		 local_irq_restore(flags);		\
+	 } while (0)
+#endif
+
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2369,6 +2369,13 @@ void trace_hardirqs_off(void)
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
+void trace_hardirqs_off_no_nmi(void)
+{
+	WARN_ON_ONCE(in_nmi());
+	trace_hardirqs_off_caller(CALLER_ADDR0);
+}
+EXPORT_SYMBOL(trace_hardirqs_off_no_nmi);
+
 /*
  * Softirqs will be enabled:
  */
Index: linux-2.6/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_irqsoff.c
+++ linux-2.6/kernel/trace/trace_irqsoff.c
@@ -316,6 +316,14 @@ void trace_hardirqs_off(void)
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
+void trace_hardirqs_off_no_nmi(void)
+{
+	WARN_ON_ONCE(in_nmi());
+	if (!preempt_trace() && irq_trace())
+		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
+}
+EXPORT_SYMBOL(trace_hardirqs_off_no_nmi);
+
 void trace_hardirqs_on_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())


