Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0FMPeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:34:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:37759 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0FMPcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:14 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] irq: cleanup irqfixup
Date: Sun, 13 Jun 2010 17:31:27 +0200
Message-Id: <1276443098-20653-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following cleanups to irqfixup.

* Define IRQFIXUP_{SPURIOUS|MISROUTED|POLL} and use them instead of
  hard coding 0, 1 and 2.

* Add an inline note_interrupt() wrapper which checks noirqdebug and
  calls __note_interrupt() instead of checking noirqdebug from each
  caller.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arm/mach-ns9xxx/irq.c              |    3 ---
 arch/powerpc/platforms/cell/interrupt.c |    5 +----
 include/linux/irq.h                     |   13 +++++++++++--
 kernel/irq/chip.c                       |   18 ++++++------------
 kernel/irq/handle.c                     |    6 ++----
 kernel/irq/internals.h                  |    2 --
 kernel/irq/spurious.c                   |   30 ++++++++++++++++++------------
 7 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index 038f24d..6be86e9 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -82,9 +82,6 @@ static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 
 	action_ret = handle_IRQ_event(irq, action);
 
-	/* XXX: There is no direct way to access noirqdebug, so check
-	 * unconditionally for spurious irqs...
-	 * Maybe this function should go to kernel/irq/chip.c? */
 	note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock(&desc->lock);
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 10eb1a4..e638fb3 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -233,8 +233,6 @@ static int iic_host_match(struct irq_host *h, struct device_node *node)
 				    "IBM,CBEA-Internal-Interrupt-Controller");
 }
 
-extern int noirqdebug;
-
 static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	raw_spin_lock(&desc->lock);
@@ -267,8 +265,7 @@ static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 		desc->status &= ~IRQ_PENDING;
 		raw_spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret);
 		raw_spin_lock(&desc->lock);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c03243a..ec93be4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -324,8 +324,17 @@ static inline void generic_handle_irq(unsigned int irq)
 }
 
 /* Handling of unhandled and spurious interrupts: */
-extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
-			   irqreturn_t action_ret);
+extern void __note_interrupt(unsigned int irq, struct irq_desc *desc,
+			     irqreturn_t action_ret);
+
+static inline void note_interrupt(unsigned int irq, struct irq_desc *desc,
+				  irqreturn_t action_ret)
+{
+	extern int noirqdebug;
+
+	if (!noirqdebug)
+		__note_interrupt(irq, desc, action_ret);
+}
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b7091d5..db26ff0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -406,8 +406,7 @@ void handle_nested_irq(unsigned int irq)
 	raw_spin_unlock_irq(&desc->lock);
 
 	action_ret = action->thread_fn(action->irq, action->dev_id);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock_irq(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -450,8 +449,7 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -495,8 +493,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -548,8 +545,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
@@ -625,8 +621,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		desc->status &= ~IRQ_PENDING;
 		raw_spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret);
 		raw_spin_lock(&desc->lock);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
@@ -654,8 +649,7 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 		desc->chip->ack(irq);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	note_interrupt(irq, desc, action_ret);
 
 	if (desc->chip->eoi)
 		desc->chip->eoi(irq);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 27e5c69..3ae50bf 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -461,8 +461,7 @@ unsigned int __do_IRQ(unsigned int irq)
 			desc->chip->ack(irq);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
-			if (!noirqdebug)
-				note_interrupt(irq, desc, action_ret);
+			note_interrupt(irq, desc, action_ret);
 		}
 		desc->chip->end(irq);
 		return 1;
@@ -515,8 +514,7 @@ unsigned int __do_IRQ(unsigned int irq)
 		raw_spin_unlock(&desc->lock);
 
 		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
+		note_interrupt(irq, desc, action_ret);
 
 		raw_spin_lock(&desc->lock);
 		if (likely(!(desc->status & IRQ_PENDING)))
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index c63f3bc..341f952 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -2,8 +2,6 @@
  * IRQ subsystem internal functions and variables:
  */
 
-extern int noirqdebug;
-
 /* Set default functions for irq_chip structures: */
 extern void irq_chip_set_defaults(struct irq_chip *chip);
 
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 89fb90a..5da60a2 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -14,7 +14,15 @@
 #include <linux/moduleparam.h>
 #include <linux/timer.h>
 
-static int irqfixup __read_mostly;
+enum {
+	/* irqfixup levels */
+	IRQFIXUP_SPURIOUS		= 0,		/* spurious storm detection */
+	IRQFIXUP_MISROUTED		= 1,		/* misrouted IRQ fixup */
+	IRQFIXUP_POLL			= 2,		/* enable polling by default */
+};
+
+int noirqdebug __read_mostly;
+static int irqfixup __read_mostly = IRQFIXUP_SPURIOUS;
 
 #define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
 static void poll_spurious_irqs(unsigned long dummy);
@@ -184,7 +192,7 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 {
 	struct irqaction *action;
 
-	if (!irqfixup)
+	if (irqfixup < IRQFIXUP_MISROUTED)
 		return 0;
 
 	/* We didn't actually handle the IRQ - see if it was misrouted? */
@@ -192,11 +200,11 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 		return 1;
 
 	/*
-	 * But for 'irqfixup == 2' we also do it for handled interrupts if
-	 * they are marked as IRQF_IRQPOLL (or for irq zero, which is the
-	 * traditional PC timer interrupt.. Legacy)
+	 * But for IRQFIXUP_POLL we also do it for handled interrupts
+	 * if they are marked as IRQF_IRQPOLL (or for irq zero, which
+	 * is the traditional PC timer interrupt.. Legacy)
 	 */
-	if (irqfixup < 2)
+	if (irqfixup < IRQFIXUP_POLL)
 		return 0;
 
 	if (!irq)
@@ -213,8 +221,8 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	return action && (action->flags & IRQF_IRQPOLL);
 }
 
-void note_interrupt(unsigned int irq, struct irq_desc *desc,
-		    irqreturn_t action_ret)
+void __note_interrupt(unsigned int irq, struct irq_desc *desc,
+		      irqreturn_t action_ret)
 {
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
@@ -262,8 +270,6 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	desc->irqs_unhandled = 0;
 }
 
-int noirqdebug __read_mostly;
-
 int noirqdebug_setup(char *str)
 {
 	noirqdebug = 1;
@@ -278,7 +284,7 @@ MODULE_PARM_DESC(noirqdebug, "Disable irq lockup detection when true");
 
 static int __init irqfixup_setup(char *str)
 {
-	irqfixup = 1;
+	irqfixup = max(irqfixup, IRQFIXUP_MISROUTED);
 	printk(KERN_WARNING "Misrouted IRQ fixup support enabled.\n");
 	printk(KERN_WARNING "This may impact system performance.\n");
 
@@ -290,7 +296,7 @@ module_param(irqfixup, int, 0644);
 
 static int __init irqpoll_setup(char *str)
 {
-	irqfixup = 2;
+	irqfixup = IRQFIXUP_POLL;
 	printk(KERN_WARNING "Misrouted IRQ fixup and polling support "
 				"enabled\n");
 	printk(KERN_WARNING "This may significantly impact system "
-- 
1.6.4.2

