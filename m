Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1DBTXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:23:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:46711 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab1DBTXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:23:39 -0400
Date: Sat, 2 Apr 2011 21:23:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: platform-drivers: x86: pmic: Restore the dropped buslock/unlock
Message-ID: <alpine.LFD.2.00.1104022122010.5929@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I added the buslock/unlock mechanism to the pmic code in order to
get rid of the horrible work queue stuff, stupid me missed to add the
new callbacks to the irq_chip.

In consequence Andrew removed the unused functions, but I missed that.

Add them back and hook them up proper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 drivers/platform/x86/intel_pmic_gpio.c |   43 +++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/intel_pmic_gpio.c
+++ linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
@@ -74,6 +74,19 @@ struct pmic_gpio {
 	u32			trigger_type;
 };
 
+static void pmic_program_irqtype(int gpio, int type)
+{
+	if (type & IRQ_TYPE_EDGE_RISING)
+		intel_scu_ipc_update_register(GPIO0 + gpio, 0x20, 0x20);
+	else
+		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x20);
+
+	if (type & IRQ_TYPE_EDGE_FALLING)
+		intel_scu_ipc_update_register(GPIO0 + gpio, 0x10, 0x10);
+	else
+		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x10);
+};
+
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	if (offset > 8) {
@@ -166,16 +179,38 @@ static int pmic_gpio_to_irq(struct gpio_
 	return pg->irq_base + offset;
 }
 
+static void pmic_bus_lock(struct irq_data *data)
+{
+	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&pg->buslock);
+}
+
+static void pmic_bus_sync_unlock(struct irq_data *data)
+{
+	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
+
+	if (pg->update_type) {
+		unsigned int gpio = pg->update_type & ~GPIO_UPDATE_TYPE;
+
+		pmic_program_irqtype(gpio, pg->trigger_type);
+		pg->update_type = 0;
+	}
+	mutex_unlock(&pg->buslock);
+}
+
 /* the gpiointr register is read-clear, so just do nothing. */
 static void pmic_irq_unmask(struct irq_data *data) { }
 
 static void pmic_irq_mask(struct irq_data *data) { }
 
 static struct irq_chip pmic_irqchip = {
-	.name		= "PMIC-GPIO",
-	.irq_mask	= pmic_irq_mask,
-	.irq_unmask	= pmic_irq_unmask,
-	.irq_set_type	= pmic_irq_type,
+	.name			= "PMIC-GPIO",
+	.irq_mask		= pmic_irq_mask,
+	.irq_unmask		= pmic_irq_unmask,
+	.irq_set_type		= pmic_irq_type,
+	.irq_bus_lock		= pmic_irq_buslock,
+	.irq_bus_sync_unlock	= pmic_bus_sync_unlock,
 };
 
 static irqreturn_t pmic_irq_handler(int irq, void *data)
