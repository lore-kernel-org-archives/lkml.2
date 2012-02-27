Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2B0K0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:26:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab2B0K03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:26:29 -0500
Date: Mon, 27 Feb 2012 11:26:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20120227102623.GA2432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   HEAD: b4bc724e82e80478cba5fe9825b62e71ddf78757 genirq: Handle pending irqs in irq_startup()

 Thanks,

	Ingo

------------------>
Thomas Gleixner (2):
      genirq: Unmask oneshot irqs when thread was not woken
      genirq: Handle pending irqs in irq_startup()


 kernel/irq/autoprobe.c |    4 ++--
 kernel/irq/chip.c      |   42 +++++++++++++++++++++++++++++++++---------
 kernel/irq/internals.h |    2 +-
 kernel/irq/manage.c    |    2 +-
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 342d8f4..0119b9d 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -53,7 +53,7 @@ unsigned long probe_irq_on(void)
 			if (desc->irq_data.chip->irq_set_type)
 				desc->irq_data.chip->irq_set_type(&desc->irq_data,
 							 IRQ_TYPE_PROBE);
-			irq_startup(desc);
+			irq_startup(desc, false);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -70,7 +70,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && irq_settings_can_probe(desc)) {
 			desc->istate |= IRQS_AUTODETECT | IRQS_WAITING;
-			if (irq_startup(desc))
+			if (irq_startup(desc, false))
 				desc->istate |= IRQS_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f7c543a..fb7db75 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -157,19 +157,22 @@ static void irq_state_set_masked(struct irq_desc *desc)
 	irqd_set(&desc->irq_data, IRQD_IRQ_MASKED);
 }
 
-int irq_startup(struct irq_desc *desc)
+int irq_startup(struct irq_desc *desc, bool resend)
 {
+	int ret = 0;
+
 	irq_state_clr_disabled(desc);
 	desc->depth = 0;
 
 	if (desc->irq_data.chip->irq_startup) {
-		int ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
+		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
 		irq_state_clr_masked(desc);
-		return ret;
+	} else {
+		irq_enable(desc);
 	}
-
-	irq_enable(desc);
-	return 0;
+	if (resend)
+		check_irq_resend(desc, desc->irq_data.irq);
+	return ret;
 }
 
 void irq_shutdown(struct irq_desc *desc)
@@ -330,6 +333,24 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_simple_irq);
 
+/*
+ * Called unconditionally from handle_level_irq() and only for oneshot
+ * interrupts from handle_fasteoi_irq()
+ */
+static void cond_unmask_irq(struct irq_desc *desc)
+{
+	/*
+	 * We need to unmask in the following cases:
+	 * - Standard level irq (IRQF_ONESHOT is not set)
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot)
+		unmask_irq(desc);
+}
+
 /**
  *	handle_level_irq - Level type irq handler
  *	@irq:	the interrupt number
@@ -362,8 +383,8 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	handle_irq_event(desc);
 
-	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
-		unmask_irq(desc);
+	cond_unmask_irq(desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -417,6 +438,9 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	preflow_handler(desc);
 	handle_irq_event(desc);
 
+	if (desc->istate & IRQS_ONESHOT)
+		cond_unmask_irq(desc);
+
 out_eoi:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 out_unlock:
@@ -625,7 +649,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
-		irq_startup(desc);
+		irq_startup(desc, true);
 	}
 out:
 	irq_put_desc_busunlock(desc, flags);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index b795231..40378ff 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -67,7 +67,7 @@ extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
-extern int irq_startup(struct irq_desc *desc);
+extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a9a9dbe..32313c0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1027,7 +1027,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			desc->istate |= IRQS_ONESHOT;
 
 		if (irq_settings_can_autoenable(desc))
-			irq_startup(desc);
+			irq_startup(desc, true);
 		else
 			/* Undo nested disables: */
 			desc->depth = 1;
