Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0DMTeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:34:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:52046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab0DMTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:34:09 -0400
Date: Tue, 13 Apr 2010 19:33:36 GMT
From: tip-bot for Marc Zyngier <maz@misterjones.org>
Cc: linux-kernel@vger.kernel.org, maz@misterjones.org, hpa@zytor.com,
       mingo@redhat.com, joachim.eastwood@jotron.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, maz@misterjones.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       joachim.eastwood@jotron.com
In-Reply-To: <927ea285bd0c68934ddae1a47e44a9ba@localhost>
References: <927ea285bd0c68934ddae1a47e44a9ba@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Introduce request_any_context_irq()
Message-ID: <tip-ae731f8d0785ccd3380f511bae888933b6562e45@git.kernel.org>
Git-Commit-ID: ae731f8d0785ccd3380f511bae888933b6562e45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Apr 2010 19:33:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae731f8d0785ccd3380f511bae888933b6562e45
Gitweb:     http://git.kernel.org/tip/ae731f8d0785ccd3380f511bae888933b6562e45
Author:     Marc Zyngier <maz@misterjones.org>
AuthorDate: Mon, 15 Mar 2010 22:56:33 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 13 Apr 2010 16:36:39 +0200

genirq: Introduce request_any_context_irq()

Now that we enjoy threaded interrupts, we're starting to see irq_chip
implementations (wm831x, pca953x) that make use of threaded interrupts
for the controller, and nested interrupts for the client interrupt. It
all works very well, with one drawback:

Drivers requesting an IRQ must now know whether the handler will
run in a thread context or not, and call request_threaded_irq() or
request_irq() accordingly.

The problem is that the requesting driver sometimes doesn't know
about the nature of the interrupt, specially when the interrupt
controller is a discrete chip (typically a GPIO expander connected
over I2C) that can be connected to a wide variety of otherwise perfectly
supported hardware.

This patch introduces the request_any_context_irq() function that mostly
mimics the usual request_irq(), except that it checks whether the irq
level is configured as nested or not, and calls the right backend.
On success, it also returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

[ tglx: Made return value an enum, simplified code and made the export
  	of request_any_context_irq GPL ]

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Cc: <joachim.eastwood@jotron.com>
LKML-Reference: <927ea285bd0c68934ddae1a47e44a9ba@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   23 +++++++++++++++++++++++
 kernel/irq/manage.c       |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 75f3f00..d7e7a76 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -77,6 +77,18 @@ enum {
 	IRQTF_AFFINITY,
 };
 
+/**
+ * These values can be returned by request_any_context_irq() and
+ * describe the context the interrupt will be run in.
+ *
+ * IRQC_IS_HARDIRQ - interrupt runs in hardirq context
+ * IRQC_IS_NESTED - interrupt runs in a nested threaded context
+ */
+enum {
+	IRQC_IS_HARDIRQ	= 0,
+	IRQC_IS_NESTED,
+};
+
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 /**
@@ -120,6 +132,10 @@ request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
 	return request_threaded_irq(irq, handler, NULL, flags, name, dev);
 }
 
+extern int __must_check
+request_any_context_irq(unsigned int irq, irq_handler_t handler,
+			unsigned long flags, const char *name, void *dev_id);
+
 extern void exit_irq_thread(void);
 #else
 
@@ -141,6 +157,13 @@ request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	return request_irq(irq, handler, flags, name, dev);
 }
 
+static inline int __must_check
+request_any_context_irq(unsigned int irq, irq_handler_t handler,
+			unsigned long flags, const char *name, void *dev_id)
+{
+	return request_irq(irq, handler, flags, name, dev_id);
+}
+
 static inline void exit_irq_thread(void) { }
 #endif
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 704e488..84f3227 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1120,3 +1120,40 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	return retval;
 }
 EXPORT_SYMBOL(request_threaded_irq);
+
+/**
+ *	request_any_context_irq - allocate an interrupt line
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs.
+ *		  Threaded handler for threaded interrupts.
+ *	@flags: Interrupt type flags
+ *	@name: An ascii name for the claiming device
+ *	@dev_id: A cookie passed back to the handler function
+ *
+ *	This call allocates interrupt resources and enables the
+ *	interrupt line and IRQ handling. It selects either a
+ *	hardirq or threaded handling method depending on the
+ *	context.
+ *
+ *	On failure, it returns a negative value. On success,
+ *	it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
+ */
+int request_any_context_irq(unsigned int irq, irq_handler_t handler,
+			    unsigned long flags, const char *name, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int ret;
+
+	if (!desc)
+		return -EINVAL;
+
+	if (desc->status & IRQ_NESTED_THREAD) {
+		ret = request_threaded_irq(irq, NULL, handler,
+					   flags, name, dev_id);
+		return !ret ? IRQC_IS_NESTED : ret;
+	}
+
+	ret = request_irq(irq, handler, flags, name, dev_id);
+	return !ret ? IRQC_IS_HARDIRQ : ret;
+}
+EXPORT_SYMBOL_GPL(request_any_context_irq);
