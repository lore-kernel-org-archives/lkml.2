Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0K3M3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 07:29:34 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:48270 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0K3M3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 07:29:32 -0500
X-Greylist: delayed 1278 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 07:29:32 EST
Date: Tue, 30 Nov 2010 13:08:13 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: Provide reverse compat handling for irq_chip methods.
Message-ID: <20101130120813.GR12037@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/irq/chip.c provides compat wrappers for when users of the
new-style (->irq_foo()) irq_chip methods try to call into irq_chips
that provide only old-style (->foo()) methods, but doesn't currently
provide compatibility in the other direction.

As there exist chained irq flow handlers outside kernel/irq/ that have
not been converted over to call the new methods yet, this means that
the irq_chips that they are chained off can't be converted to the new
methods yet.

This patch adds reverse compat wrappers, so that old-style flow
handlers can call into new-style irq_chips, too, and the flow handlers
and irq_chips can be converted to the new API independently.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 kernel/irq/chip.c |  142 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 138 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..9a73b0e 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -298,15 +298,106 @@ static int compat_irq_retrigger(struct irq_data *data)
 	return data->chip->retrigger(data->irq);
 }
 
-static void compat_bus_lock(struct irq_data *data)
+static void compat_irq_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
 }
 
-static void compat_bus_sync_unlock(struct irq_data *data)
+static void compat_irq_bus_sync_unlock(struct irq_data *data)
 {
 	data->chip->bus_sync_unlock(data->irq);
 }
+
+/* And the other way around */
+static void compat_mask(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_mask(data);
+}
+
+static void compat_unmask(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_unmask(data);
+}
+
+static void compat_ack(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_ack(data);
+}
+
+static void compat_mask_ack(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_mask_ack(data);
+}
+
+static void compat_eoi(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_eoi(data);
+}
+
+static void compat_enable(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_enable(data);
+}
+
+static void compat_disable(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_disable(data);
+}
+
+static void compat_shutdown(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_shutdown(data);
+}
+
+static unsigned int compat_startup(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return data->chip->irq_startup(data);
+}
+
+static int compat_set_affinity(unsigned int irq, const struct cpumask *dest)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return data->chip->irq_set_affinity(data, dest, 0);
+}
+
+static int compat_set_type(unsigned int irq, unsigned int type)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return data->chip->irq_set_type(data, type);
+}
+
+static int compat_set_wake(unsigned int irq, unsigned int on)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return data->chip->irq_set_wake(data, on);
+}
+
+static int compat_retrigger(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return data->chip->irq_retrigger(data);
+}
+
+static void compat_bus_lock(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_bus_lock(data);
+}
+
+static void compat_bus_sync_unlock(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	data->chip->irq_bus_sync_unlock(data);
+}
 #endif
 
 /*
@@ -321,12 +412,23 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 	 */
 	if (chip->enable)
 		chip->irq_enable = compat_irq_enable;
+	else if (chip->irq_enable)
+		chip->enable = compat_enable;
+
 	if (chip->disable)
 		chip->irq_disable = compat_irq_disable;
+	else if (chip->irq_disable)
+		chip->disable = compat_disable;
+
 	if (chip->shutdown)
 		chip->irq_shutdown = compat_irq_shutdown;
+	else if (chip->irq_shutdown)
+		chip->shutdown = compat_shutdown;
+
 	if (chip->startup)
 		chip->irq_startup = compat_irq_startup;
+	else if (chip->irq_startup)
+		chip->startup = compat_startup;
 #endif
 	/*
 	 * The real defaults
@@ -355,27 +457,59 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 	 * Now fix up the remaining compat handlers
 	 */
 	if (chip->bus_lock)
-		chip->irq_bus_lock = compat_bus_lock;
+		chip->irq_bus_lock = compat_irq_bus_lock;
+	else if (chip->irq_bus_lock)
+		chip->bus_lock = compat_bus_lock;
+
 	if (chip->bus_sync_unlock)
-		chip->irq_bus_sync_unlock = compat_bus_sync_unlock;
+		chip->irq_bus_sync_unlock = compat_irq_bus_sync_unlock;
+	else if (chip->irq_bus_sync_unlock)
+		chip->bus_sync_unlock = compat_bus_sync_unlock;
+
 	if (chip->mask)
 		chip->irq_mask = compat_irq_mask;
+	else if (chip->irq_mask)
+		chip->mask = compat_mask;
+
 	if (chip->unmask)
 		chip->irq_unmask = compat_irq_unmask;
+	else if (chip->irq_unmask)
+		chip->unmask = compat_unmask;
+
 	if (chip->ack)
 		chip->irq_ack = compat_irq_ack;
+	else if (chip->irq_ack)
+		chip->ack = compat_ack;
+
 	if (chip->mask_ack)
 		chip->irq_mask_ack = compat_irq_mask_ack;
+	else if (chip->irq_mask_ack)
+		chip->mask_ack = compat_mask_ack;
+
 	if (chip->eoi)
 		chip->irq_eoi = compat_irq_eoi;
+	else if (chip->irq_eoi)
+		chip->eoi = compat_eoi;
+
 	if (chip->set_affinity)
 		chip->irq_set_affinity = compat_irq_set_affinity;
+	else if (chip->irq_set_affinity)
+		chip->set_affinity = compat_set_affinity;
+
 	if (chip->set_type)
 		chip->irq_set_type = compat_irq_set_type;
+	else if (chip->irq_set_type)
+		chip->set_type = compat_set_type;
+
 	if (chip->set_wake)
 		chip->irq_set_wake = compat_irq_set_wake;
+	else if (chip->irq_set_wake)
+		chip->set_wake = compat_set_wake;
+
 	if (chip->retrigger)
 		chip->irq_retrigger = compat_irq_retrigger;
+	else if (chip->irq_retrigger)
+		chip->retrigger = compat_retrigger;
 #endif
 }
 
-- 
1.7.1
