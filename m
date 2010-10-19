Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab0JSIXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:23:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38640 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108Ab0JSIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:23:17 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] genirq: handle unhandled irqs when the handler is threaded
Date: Tue, 19 Oct 2010 10:23:10 +0200
Message-Id: <1287476590-8048-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps detecting stuck irq lines for threaded irqs.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 include/linux/irq.h   |    2 ++
 kernel/irq/handle.c   |    6 ------
 kernel/irq/manage.c   |    7 ++++++-
 kernel/irq/spurious.c |   17 +++++++++++++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index c03243a..fea4dc0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -324,6 +324,8 @@ static inline void generic_handle_irq(unsigned int irq)
 }
 
 /* Handling of unhandled and spurious interrupts: */
+extern void note_threaded_interrupt(unsigned int irq, struct irq_desc *desc,
+			   irqreturn_t action_ret);
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 27e5c69..439cb78 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -378,12 +378,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		switch (ret) {
 		case IRQ_WAKE_THREAD:
 			/*
-			 * Set result to handled so the spurious check
-			 * does not trigger.
-			 */
-			ret = IRQ_HANDLED;
-
-			/*
 			 * Catch drivers which return WAKE_THREAD but
 			 * did not set up a thread function
 			 */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c3003e9..361fe54 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -598,12 +598,17 @@ static int irq_thread(void *data)
 			desc->status |= IRQ_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			irqreturn_t action_ret;
+
 			raw_spin_unlock_irq(&desc->lock);
 
-			action->thread_fn(action->irq, action->dev_id);
+			action_ret = action->thread_fn(action->irq, action->dev_id);
 
 			if (oneshot)
 				irq_finalize_oneshot(action->irq, desc);
+
+			if (!noirqdebug)
+				note_threaded_interrupt(action->irq, desc, action_ret);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index d819a3d6..079648f 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -215,8 +215,8 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	return action && (action->flags & IRQF_IRQPOLL);
 }
 
-void note_interrupt(unsigned int irq, struct irq_desc *desc,
-		    irqreturn_t action_ret)
+void note_threaded_interrupt(unsigned int irq, struct irq_desc *desc,
+		irqreturn_t action_ret)
 {
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
@@ -264,6 +264,19 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	desc->irqs_unhandled = 0;
 }
 
+void note_interrupt(unsigned int irq, struct irq_desc *desc,
+		irqreturn_t action_ret)
+{
+	if (action_ret == IRQ_WAKE_THREAD)
+		/* handle when the thread function returns */
+		return;
+
+	/* don't report IRQ_WAKE_THREAD | IRQ_HANDLED as bogus return value */
+	action_ret &= ~IRQ_WAKE_THREAD;
+
+	note_threaded_interrupt(irq, desc, action_ret);
+}
+
 int noirqdebug __read_mostly;
 
 int noirqdebug_setup(char *str)
-- 
1.7.2.3

