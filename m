Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0DMTfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:35:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:52121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab0DMTfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:35:17 -0400
Date: Tue, 13 Apr 2010 19:34:12 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, andi@firstfloor.org, peterz@infradead.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net, torvalds@osdl.org,
       gregkh@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, peterz@infradead.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net, torvalds@osdl.org,
       gregkh@suse.de, tglx@linutronix.de
In-Reply-To: <20100326000405.991244690@linutronix.de>
References: <20100326000405.991244690@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Remove IRQF_DISABLED from core code
Message-ID: <tip-6932bf37bed45ce8ed531928b1b0f98162fe6df6@git.kernel.org>
Git-Commit-ID: 6932bf37bed45ce8ed531928b1b0f98162fe6df6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Apr 2010 19:34:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6932bf37bed45ce8ed531928b1b0f98162fe6df6
Gitweb:     http://git.kernel.org/tip/6932bf37bed45ce8ed531928b1b0f98162fe6df6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 26 Mar 2010 00:06:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 13 Apr 2010 16:36:40 +0200

genirq: Remove IRQF_DISABLED from core code

Remove all code which is related to IRQF_DISABLED from the core kernel
code. IRQF_DISABLED still exists as a flag, but becomes a NOOP and
will be removed after a grace period. That way we can easily revert to
the previous behaviour by just restoring the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>
LKML-Reference: <20100326000405.991244690@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |    7 ++++++
 include/linux/interrupt.h                  |    3 +-
 kernel/irq/manage.c                        |   30 ----------------------------
 3 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ed511af..9c31c2e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -589,3 +589,10 @@ Why:	Useful in 2003, implementation is a hack.
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
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index d7e7a76..e6d2f44 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 84f3227..444d5a8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -757,16 +757,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
-		/*
-		 * Force MSI interrupts to run with interrupts
-		 * disabled. The multi vector cards can cause stack
-		 * overflows due to nested interrupts when enough of
-		 * them are directed to a core and fire at the same
-		 * time.
-		 */
-		if (desc->msi_desc)
-			new->flags |= IRQF_DISABLED;
-
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
@@ -1027,7 +1017,6 @@ EXPORT_SYMBOL(free_irq);
  *	Flags:
  *
  *	IRQF_SHARED		Interrupt is shared
- *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
@@ -1041,25 +1030,6 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
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
