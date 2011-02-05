Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1BEKqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 05:46:51 -0500
Received: from www.tglx.de ([62.245.132.106]:32876 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab1BEKqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 05:46:49 -0500
Message-Id: <20110205104221.336710296@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 10:46:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>
Subject: [patch 3/3] platform-drivers: x86: pmic: Use irq_chip buslock
	mechanism
References: <20110205104025.559237313@linutronix.de>
Content-Disposition: inline;
	filename=platform-drivers-x86-pmic-use-buslock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set_type function of the pmic irq chip is a horrible hack. It
schedules work because it cannot access the scu chip from the set_type
function. That breaks the assumption, that the type is set after
set_type has returned.

irq_chips provide buslock functions to avoid the above. Convert the
driver to use the proper model.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Alek Du <alek.du@intel.com>
---
 drivers/platform/x86/intel_pmic_gpio.c |   80 +++++++++++++--------------------
 1 file changed, 32 insertions(+), 48 deletions(-)

Index: linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/intel_pmic_gpio.c
+++ linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
@@ -60,23 +60,18 @@ enum pmic_gpio_register {
 #define GPOSW_DOU 0x08
 #define GPOSW_RDRV 0x30
 
+#define GPIO_UPDATE_TYPE	0x80000000
 
 #define NUM_GPIO 24
 
-struct pmic_gpio_irq {
-	spinlock_t lock;
-	u32 trigger[NUM_GPIO];
-	u32 dirty;
-	struct work_struct work;
-};
-
-
 struct pmic_gpio {
+	struct mutex		buslock;
 	struct gpio_chip	chip;
-	struct pmic_gpio_irq	irqtypes;
 	void			*gpiointr;
 	int			irq;
 	unsigned		irq_base;
+	unsigned int		update_type;
+	u32			trigger_type;
 };
 
 static void pmic_program_irqtype(int gpio, int type)
@@ -92,37 +87,6 @@ static void pmic_program_irqtype(int gpi
 		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x10);
 };
 
-static void pmic_irqtype_work(struct work_struct *work)
-{
-	struct pmic_gpio_irq *t =
-		container_of(work, struct pmic_gpio_irq, work);
-	unsigned long flags;
-	int i;
-	u16 type;
-
-	spin_lock_irqsave(&t->lock, flags);
-	/* As we drop the lock, we may need multiple scans if we race the
-	   pmic_irq_type function */
-	while (t->dirty) {
-		/*
-		 *	For each pin that has the dirty bit set send an IPC
-		 *	message to configure the hardware via the PMIC
-		 */
-		for (i = 0; i < NUM_GPIO; i++) {
-			if (!(t->dirty & (1 << i)))
-				continue;
-			t->dirty &= ~(1 << i);
-			/* We can't trust the array entry or dirty
-			   once the lock is dropped */
-			type = t->trigger[i];
-			spin_unlock_irqrestore(&t->lock, flags);
-			pmic_program_irqtype(i, type);
-			spin_lock_irqsave(&t->lock, flags);
-		}
-	}
-	spin_unlock_irqrestore(&t->lock, flags);
-}
-
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	if (offset > 8) {
@@ -190,20 +154,21 @@ static void pmic_gpio_set(struct gpio_ch
 			1 << (offset - 16));
 }
 
+/*
+ * This is called from genirq with pg->buslock locked and
+ * irq_desc->lock held. We can not access the scu bus here, so we
+ * store the change and update in the bus_sync_unlock() function below
+ */
 static int pmic_irq_type(struct irq_data *data, unsigned type)
 {
 	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
 	u32 gpio = data->irq - pg->irq_base;
-	unsigned long flags;
 
 	if (gpio >= pg->chip.ngpio)
 		return -EINVAL;
 
-	spin_lock_irqsave(&pg->irqtypes.lock, flags);
-	pg->irqtypes.trigger[gpio] = type;
-	pg->irqtypes.dirty |=  (1 << gpio);
-	spin_unlock_irqrestore(&pg->irqtypes.lock, flags);
-	schedule_work(&pg->irqtypes.work);
+	pg->trigger_type = type;
+	pg->update_type = gpio | GPIO_UPDATE_TYPE;
 	return 0;
 }
 
@@ -214,6 +179,26 @@ static int pmic_gpio_to_irq(struct gpio_
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
 
@@ -287,8 +272,7 @@ static int __devinit platform_pmic_gpio_
 	pg->chip.can_sleep = 1;
 	pg->chip.dev = dev;
 
-	INIT_WORK(&pg->irqtypes.work, pmic_irqtype_work);
-	spin_lock_init(&pg->irqtypes.lock);
+	mutex_init(&pg->buslock);
 
 	pg->chip.dev = dev;
 	retval = gpiochip_add(&pg->chip);


