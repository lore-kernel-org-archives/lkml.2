Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0LOXNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:13:11 -0500
Received: from www.tglx.de ([62.245.132.106]:59028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab0LOXNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:13:09 -0500
Message-Id: <20101215230531.141459653@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 23:12:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Jan Kiszka <jan.kiszka@web.de>
Subject: [RFC patch 1/4] genirq: Globally serialize request/free_irq
References: <20101215230352.411894017@linutronix.de>
Content-Disposition: inline; filename=genirq-serialize-request-free-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request/free_irq is not a hotpath, so we can afford to serialize it
with a global lock. That allows us to shorten critical sections as the
action chain of an irq descriptor becomes protected by the global
lock. It's also a prerequisite for further changes which provide
adaptive oneshot functionality for possibly shared interrupts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lyon <pugs@cisco.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jan Kiszka <jan.kiszka@web.de>
---
 kernel/irq/manage.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -14,9 +14,12 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/mutex.h>
 
 #include "internals.h"
 
+static DEFINE_MUTEX(register_lock);
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -870,8 +873,12 @@ out_thread:
 int setup_irq(unsigned int irq, struct irqaction *act)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	int ret;
 
-	return __setup_irq(irq, desc, act);
+	mutex_lock(&register_lock);
+	ret = __setup_irq(irq, desc, act);
+	mutex_unlock(&register_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
@@ -977,7 +984,9 @@ static struct irqaction *__free_irq(unsi
  */
 void remove_irq(unsigned int irq, struct irqaction *act)
 {
+	mutex_lock(&register_lock);
 	__free_irq(irq, act->dev_id);
+	mutex_unlock(&register_lock);
 }
 EXPORT_SYMBOL_GPL(remove_irq);
 
@@ -1002,9 +1011,13 @@ void free_irq(unsigned int irq, void *de
 	if (!desc)
 		return;
 
+	mutex_lock(&register_lock);
+
 	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
+
+	mutex_unlock(&register_lock);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1091,10 +1104,14 @@ int request_threaded_irq(unsigned int ir
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	mutex_lock(&register_lock);
+
 	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
 	chip_bus_sync_unlock(desc);
 
+	mutex_unlock(&register_lock);
+
 	if (retval)
 		kfree(action);
 


