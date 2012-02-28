Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2B1Bb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:31:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2B1BHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.223.199 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010214.412074510@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:03:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
Subject: [ 61/73] genirq: Handle pending irqs in irq_startup()
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit b4bc724e82e80478cba5fe9825b62e71ddf78757 upstream.

An interrupt might be pending when irq_startup() is called, but the
startup code does not invoke the resend logic. In some cases this
prevents the device from issuing another interrupt which renders the
device non functional.

Call the resend function in irq_startup() to keep things going.

Reported-and-tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/autoprobe.c |    4 ++--
 kernel/irq/chip.c      |   17 ++++++++++-------
 kernel/irq/internals.h |    2 +-
 kernel/irq/manage.c    |    2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

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
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -157,19 +157,22 @@ static void irq_state_set_masked(struct
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
@@ -596,7 +599,7 @@ __irq_set_handler(unsigned int irq, irq_
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
-		irq_startup(desc);
+		irq_startup(desc, true);
 	}
 out:
 	irq_put_desc_busunlock(desc, flags);
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -67,7 +67,7 @@ extern int __irq_set_trigger(struct irq_
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
-extern int irq_startup(struct irq_desc *desc);
+extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1018,7 +1018,7 @@ __setup_irq(unsigned int irq, struct irq
 			desc->istate |= IRQS_ONESHOT;
 
 		if (irq_settings_can_autoenable(desc))
-			irq_startup(desc);
+			irq_startup(desc, true);
 		else
 			/* Undo nested disables: */
 			desc->depth = 1;


