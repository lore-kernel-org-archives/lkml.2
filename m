Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0LCXhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:37:40 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:32792 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0LCXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:37:37 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 1/5] genirq: Pass descriptor to __free_irq
Date: Sat,  4 Dec 2010 00:37:27 +0100
Message-Id: <26d120c867374ef2b16d2432ca9a77fed11c230b.1291419444.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX18OfzZcswQxRgK22V9cZYTIMhHfhpIylS25vn92
	QYArKvCby/c0jHGIOtCcE2fKStFu/X6V4rYVfzXZxD930A4owF
	fQNG8H2UE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

One caller of __free_free already has to resolve and check the irq
descriptor. So this small cleanup consistently pushes irq_to_desc and
the NULL check to the call site to avoid redundant work.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 kernel/irq/manage.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5f92acc..6341765 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -879,17 +879,14 @@ EXPORT_SYMBOL_GPL(setup_irq);
  * Internal function to unregister an irqaction - used to free
  * regular and special interrupts that are part of the architecture.
  */
-static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
+static struct irqaction *__free_irq(struct irq_desc *desc, void *dev_id)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
+	unsigned int irq = desc->irq_data.irq;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
 
-	if (!desc)
-		return NULL;
-
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/*
@@ -977,7 +974,12 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
  */
 void remove_irq(unsigned int irq, struct irqaction *act)
 {
-	__free_irq(irq, act->dev_id);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return;
+
+	__free_irq(desc, act->dev_id);
 }
 EXPORT_SYMBOL_GPL(remove_irq);
 
@@ -1003,7 +1005,7 @@ void free_irq(unsigned int irq, void *dev_id)
 		return;
 
 	chip_bus_lock(desc);
-	kfree(__free_irq(irq, dev_id));
+	kfree(__free_irq(desc, dev_id));
 	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
-- 
1.7.1

