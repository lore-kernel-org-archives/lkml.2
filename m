Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab0DIXCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:02:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33608
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280Ab0DIXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:01:31 -0400
Date: Fri, 09 Apr 2010 16:01:35 -0700 (PDT)
Message-Id: <20100409.160135.35854399.davem@davemloft.net>
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH 1/4] kernel: local_irq_{save,restore}_nmi()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/irqflags.h     |   51 +++++++++++++++++++++++++++++++++++++++--
 kernel/lockdep.c             |    7 +++++
 kernel/trace/trace_irqsoff.c |    8 ++++++
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 006bf45..91256d4 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
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
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..c2aae0f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2382,6 +2382,13 @@ void trace_hardirqs_off(void)
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
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..7596c6f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
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
-- 
1.7.0.4

