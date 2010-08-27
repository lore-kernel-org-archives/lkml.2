Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0H0CCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0H0CAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/22] Fix Alpha irqflags
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:17 +0100
Message-ID: <20100827020017.27277.51777.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
References: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 arch/alpha/include/asm/irqflags.h |   65 +++++++++++++++++++++++++++++++++++++
 arch/alpha/include/asm/system.h   |   28 ----------------
 2 files changed, 65 insertions(+), 28 deletions(-)
 create mode 100644 arch/alpha/include/asm/irqflags.h

diff --git a/arch/alpha/include/asm/irqflags.h b/arch/alpha/include/asm/irqflags.h
new file mode 100644
index 0000000..75dfe395
--- /dev/null
+++ b/arch/alpha/include/asm/irqflags.h
@@ -0,0 +1,65 @@
+#ifndef __ALPHA_IRQFLAGS_H
+#define __ALPHA_IRQFLAGS_H
+
+#define IPL_MIN		0
+#define IPL_SW0		1
+#define IPL_SW1		2
+#define IPL_DEV0	3
+#define IPL_DEV1	4
+#define IPL_TIMER	5
+#define IPL_PERF	6
+#define IPL_POWERFAIL	6
+#define IPL_MCHECK	7
+#define IPL_MAX		7
+
+#ifdef CONFIG_ALPHA_BROKEN_IRQ_MASK
+#undef IPL_MIN
+#define IPL_MIN		__min_ipl
+extern int __min_ipl;
+#endif
+
+#define getipl()		(rdps() & 7)
+#define setipl(ipl)		((void) swpipl(ipl))
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	return rdps();
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	setipl(IPL_MAX);
+	barrier();
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = swpipl(IPL_MAX);
+	barrier();
+	return flags;
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	barrier();
+	setipl(IPL_MIN);
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	barrier();
+	setipl(flags);
+	barrier();
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return flags == IPL_MAX;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(getipl());
+}
+
+#endif /* __ALPHA_IRQFLAGS_H */
diff --git a/arch/alpha/include/asm/system.h b/arch/alpha/include/asm/system.h
index 5aa40cc..9f78e69 100644
--- a/arch/alpha/include/asm/system.h
+++ b/arch/alpha/include/asm/system.h
@@ -259,34 +259,6 @@ __CALL_PAL_RW2(wrperfmon, unsigned long, unsigned long, unsigned long);
 __CALL_PAL_W1(wrusp, unsigned long);
 __CALL_PAL_W1(wrvptptr, unsigned long);
 
-#define IPL_MIN		0
-#define IPL_SW0		1
-#define IPL_SW1		2
-#define IPL_DEV0	3
-#define IPL_DEV1	4
-#define IPL_TIMER	5
-#define IPL_PERF	6
-#define IPL_POWERFAIL	6
-#define IPL_MCHECK	7
-#define IPL_MAX		7
-
-#ifdef CONFIG_ALPHA_BROKEN_IRQ_MASK
-#undef IPL_MIN
-#define IPL_MIN		__min_ipl
-extern int __min_ipl;
-#endif
-
-#define getipl()		(rdps() & 7)
-#define setipl(ipl)		((void) swpipl(ipl))
-
-#define local_irq_disable()			do { setipl(IPL_MAX); barrier(); } while(0)
-#define local_irq_enable()			do { barrier(); setipl(IPL_MIN); } while(0)
-#define local_save_flags(flags)	((flags) = rdps())
-#define local_irq_save(flags)	do { (flags) = swpipl(IPL_MAX); barrier(); } while(0)
-#define local_irq_restore(flags)	do { barrier(); setipl(flags); barrier(); } while(0)
-
-#define irqs_disabled()	(getipl() == IPL_MAX)
-
 /*
  * TB routines..
  */

