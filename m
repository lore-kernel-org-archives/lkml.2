Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2BICCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:02:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2BICCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:02:01 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=dgQDkWP4yZ8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=meVymXHHAAAA:8 a=yfSuk1JHSAt2nO7AwWsA:9 a=hSfk3dABn7Rd4oi26SEA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120209020159.332831878@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 08 Feb 2012 20:59:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 2/8] genirq: Handle pending irqs in irq_startup()
References: <20120209015926.851312665@goodmis.org>
Content-Disposition: inline; filename=0002-genirq-Handle-pending-irqs-in-irq_startup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Irqs might be pending when irq_startup() is called. Call the resend
function in irq_startup() otherwise the irq line might be blocked
forever.

Cc: stable-rt@vger.kernel.org
Reported-and-tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/irq/autoprobe.c |    4 ++--
 kernel/irq/chip.c      |   17 ++++++++++-------
 kernel/irq/internals.h |    2 +-
 kernel/irq/manage.c    |    2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

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
index 3322a34..ca14f5d 100644
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
@@ -596,7 +599,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
-		irq_startup(desc);
+		irq_startup(desc, true);
 	}
 out:
 	irq_put_desc_busunlock(desc, flags);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 6546431..62efdc4 100644
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
index e1bd49d..3eb233e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1020,7 +1020,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			desc->istate |= IRQS_ONESHOT;
 
 		if (irq_settings_can_autoenable(desc))
-			irq_startup(desc);
+			irq_startup(desc, true);
 		else
 			/* Undo nested disables: */
 			desc->depth = 1;
-- 
1.7.8.3


