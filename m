Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0CZAHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:07:50 -0400
Received: from www.tglx.de ([62.245.132.106]:58654 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0CZAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:07:35 -0400
Message-Id: <20100326000405.991244690@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 26 Mar 2010 00:06:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [patch 2/2] genirq: Remove IRQF_DISABLED from core code
References: <20100326000325.917127328@linutronix.de>
Content-Disposition: inline;
	filename=genirq-remove-irqf-disabled-from-core-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all code which is related to IRQF_DISABLED from the core kernel
code. IRQF_DISABLED still exists as a flag, but becomes a NOOP and
will be removed after a grace period. That way we can easily revert to
the previous behaviour by just restoring the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |    7 +++++++
 include/linux/interrupt.h                  |    3 ++-
 kernel/irq/manage.c                        |   20 --------------------
 3 files changed, 9 insertions(+), 21 deletions(-)

Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6/Documentation/feature-removal-schedule.txt
@@ -589,3 +589,10 @@ Why:	Useful in 2003, implementation is a
 	Generally invoked by accident today.
 	Seen as doing more harm than good.
 Who:	Len Brown <len.brown@intel.com>
+
+----------------------------
+
+What:	IRQF_DISABLED
+When:	2.6.36
+Why:	The flag is a NOOP as we run interrupt handlers with interrupts disabled
+Who:	Thomas Gleixner <tglx@linutronix.de>
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -39,7 +39,8 @@
  * These flags used only by the kernel as part of the
  * irq handling routines.
  *
- * IRQF_DISABLED - keep irqs disabled when calling the action handler
+ * IRQF_DISABLED - keep irqs disabled when calling the action handler.
+ *                 DEPRECATED. This flag is a NOOP and scheduled to be removed
  * IRQF_SAMPLE_RANDOM - irq is used to feed the random generator
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -995,7 +995,6 @@ EXPORT_SYMBOL(free_irq);
  *	Flags:
  *
  *	IRQF_SHARED		Interrupt is shared
- *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
@@ -1009,25 +1008,6 @@ int request_threaded_irq(unsigned int ir
 	int retval;
 
 	/*
-	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
-	 * the _first_ irqaction (sigh).  That can cause oopsing, but
-	 * the behavior is classified as "will not fix" so we need to
-	 * start nudging drivers away from using that idiom.
-	 */
-	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED)) ==
-					(IRQF_SHARED|IRQF_DISABLED)) {
-		pr_warning(
-		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
-			irq, devname);
-	}
-
-#ifdef CONFIG_LOCKDEP
-	/*
-	 * Lockdep wants atomic interrupt handlers:
-	 */
-	irqflags |= IRQF_DISABLED;
-#endif
-	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,
 	 * otherwise we'll have trouble later trying to figure out
 	 * which interrupt is which (messes up the interrupt freeing


