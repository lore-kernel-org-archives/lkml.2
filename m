Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1BKBya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:54:30 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57290 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab1BKBy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:54:28 -0500
Date: Thu, 10 Feb 2011 17:54:24 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 07/10] olpc_dcon: move more variables into dcon_priv
Message-ID: <20110210175424.49084782@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This moves dcon_source and dcon_pending into the dcon_priv struct.

Because these variables are used by the IRQ handler (which is
registered in the model-specific callbacks), we end up needing
to move dcon_priv into olpc_dcon.h.  This also changes the IRQ
registration to use the dcon_priv pointer as dev_id, instead of
dcon_driver.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c        |   51 +++++++-------------------
 drivers/staging/olpc_dcon/olpc_dcon.h        |   32 ++++++++++++++--
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c   |   10 +++---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |    9 ++---
 4 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 96b6fd2..cdd8718 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/backlight.h>
 #include <linux/device.h>
-#include <linux/notifier.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
 #include <linux/reboot.h>
@@ -46,24 +45,6 @@ module_param(useaa, int, 0444);
 
 static struct dcon_platform_data *pdata;
 
-struct dcon_priv {
-	struct i2c_client *client;
-	struct fb_info *fbinfo;
-
-	struct work_struct switch_source;
-	struct notifier_block reboot_nb;
-	struct notifier_block fbevent_nb;
-
-	/* Shadow register for the DCON_REG_MODE register */
-	u8 disp_mode;
-
-	/* Current output type; true == mono, false == color */
-	bool mono;
-	bool asleep;
-	/* This get set while controlling fb blank state from the driver */
-	bool ignore_fb_events;
-};
-
 /* I2C structures */
 
 /* Platform devices */
@@ -72,12 +53,6 @@ static struct platform_device *dcon_device;
 /* Backlight device */
 static struct backlight_device *dcon_bl_dev;
 
-/* Current source, initialized at probe time */
-int dcon_source;
-
-/* Desired source */
-int dcon_pending;
-
 /* Variables used during switches */
 static int dcon_switched;
 static struct timespec dcon_irq_time;
@@ -119,7 +94,7 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 	if (is_init) {
 		printk(KERN_INFO "olpc-dcon:  Discovered DCON version %x\n",
 				ver & 0xFF);
-		rc = pdata->init();
+		rc = pdata->init(dcon);
 		if (rc != 0) {
 			printk(KERN_ERR "olpc-dcon:  Unable to init.\n");
 			goto err;
@@ -366,9 +341,9 @@ static void dcon_source_switch(struct work_struct *work)
 	struct dcon_priv *dcon = container_of(work, struct dcon_priv,
 			switch_source);
 	DECLARE_WAITQUEUE(wait, current);
-	int source = dcon_pending;
+	int source = dcon->pending_src;
 
-	if (dcon_source == source)
+	if (dcon->curr_src == source)
 		return;
 
 	dcon_load_holdoff();
@@ -406,7 +381,7 @@ static void dcon_source_switch(struct work_struct *work)
 		 */
 		if (!dcon_blank_fb(dcon, false)) {
 			printk(KERN_ERR "olpc-dcon:  Failed to enter CPU mode\n");
-			dcon_pending = DCON_SOURCE_DCON;
+			dcon->pending_src = DCON_SOURCE_DCON;
 			return;
 		}
 
@@ -468,17 +443,17 @@ static void dcon_source_switch(struct work_struct *work)
 		BUG();
 	}
 
-	dcon_source = source;
+	dcon->curr_src = source;
 }
 
 static void dcon_set_source(struct dcon_priv *dcon, int arg)
 {
-	if (dcon_pending == arg)
+	if (dcon->pending_src == arg)
 		return;
 
-	dcon_pending = arg;
+	dcon->pending_src = arg;
 
-	if ((dcon_source != arg) && !work_pending(&dcon->switch_source))
+	if ((dcon->curr_src != arg) && !work_pending(&dcon->switch_source))
 		schedule_work(&dcon->switch_source);
 }
 
@@ -524,7 +499,8 @@ static ssize_t dcon_sleep_show(struct device *dev,
 static ssize_t dcon_freeze_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dcon_source == DCON_SOURCE_DCON ? 1 : 0);
+	struct dcon_priv *dcon = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", dcon->curr_src == DCON_SOURCE_DCON ? 1 : 0);
 }
 
 static ssize_t dcon_mono_show(struct device *dev,
@@ -765,7 +741,7 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	platform_device_unregister(dcon_device);
 	dcon_device = NULL;
  eirq:
-	free_irq(DCON_IRQ, &dcon_driver);
+	free_irq(DCON_IRQ, dcon);
  einit:
 	i2c_set_clientdata(client, NULL);
 	kfree(dcon);
@@ -782,7 +758,7 @@ static int dcon_remove(struct i2c_client *client)
 	unregister_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
 
-	free_irq(DCON_IRQ, &dcon_driver);
+	free_irq(DCON_IRQ, dcon);
 
 	if (dcon_bl_dev != NULL)
 		backlight_device_unregister(dcon_bl_dev);
@@ -826,6 +802,7 @@ static int dcon_resume(struct i2c_client *client)
 
 irqreturn_t dcon_interrupt(int irq, void *id)
 {
+	struct dcon_priv *dcon = id;
 	int status = pdata->read_status();
 
 	if (status == -1)
@@ -851,7 +828,7 @@ irqreturn_t dcon_interrupt(int irq, void *id)
 		 * of the DCON happened long before this point.
 		 * see http://dev.laptop.org/ticket/9869
 		 */
-		if (dcon_source != dcon_pending && !dcon_switched) {
+		if (dcon->curr_src != dcon->pending_src && !dcon_switched) {
 			dcon_switched = 1;
 			getnstimeofday(&dcon_irq_time);
 			wake_up(&dcon_wait_queue);
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index 03ac42c..2c06e19 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -1,6 +1,9 @@
 #ifndef OLPC_DCON_H_
 #define OLPC_DCON_H_
 
+#include <linux/notifier.h>
+#include <linux/workqueue.h>
+
 /* DCON registers */
 
 #define DCON_REG_ID		 0
@@ -44,8 +47,32 @@
 /* Interrupt */
 #define DCON_IRQ                6
 
+struct dcon_priv {
+	struct i2c_client *client;
+	struct fb_info *fbinfo;
+
+	struct work_struct switch_source;
+	struct notifier_block reboot_nb;
+	struct notifier_block fbevent_nb;
+
+	/* Shadow register for the DCON_REG_MODE register */
+	u8 disp_mode;
+
+	/* Current source, initialized at probe time */
+	int curr_src;
+
+	/* Desired source */
+	int pending_src;
+
+	/* Current output type; true == mono, false == color */
+	bool mono;
+	bool asleep;
+	/* This get set while controlling fb blank state from the driver */
+	bool ignore_fb_events;
+};
+
 struct dcon_platform_data {
-	int (*init)(void);
+	int (*init)(struct dcon_priv *);
 	void (*bus_stabilize_wiggle)(void);
 	void (*set_dconload)(int);
 	u8 (*read_status)(void);
@@ -53,10 +80,7 @@ struct dcon_platform_data {
 
 #include <linux/interrupt.h>
 
-extern int dcon_source;
-extern int dcon_pending;
 extern irqreturn_t dcon_interrupt(int irq, void *id);
-extern struct i2c_driver dcon_driver;
 
 #ifdef CONFIG_FB_OLPC_DCON_1
 extern struct dcon_platform_data dcon_pdata_xo_1;
diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index be52b6c..b154be7 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -16,7 +16,7 @@
 
 #include "olpc_dcon.h"
 
-static int dcon_init_xo_1(void)
+static int dcon_init_xo_1(struct dcon_priv *dcon)
 {
 	unsigned char lob;
 
@@ -54,10 +54,10 @@ static int dcon_init_xo_1(void)
 	 * then a value is set.  So, future readings of the pin can use
 	 * READ_BACK, but the first one cannot.  Awesome, huh?
 	 */
-	dcon_source = cs5535_gpio_isset(OLPC_GPIO_DCON_LOAD, GPIO_OUTPUT_VAL)
+	dcon->curr_src = cs5535_gpio_isset(OLPC_GPIO_DCON_LOAD, GPIO_OUTPUT_VAL)
 		? DCON_SOURCE_CPU
 		: DCON_SOURCE_DCON;
-	dcon_pending = dcon_source;
+	dcon->pending_src = dcon->curr_src;
 
 	/* Set the directions for the GPIO pins */
 	gpio_direction_input(OLPC_GPIO_DCON_STAT0);
@@ -65,7 +65,7 @@ static int dcon_init_xo_1(void)
 	gpio_direction_input(OLPC_GPIO_DCON_IRQ);
 	gpio_direction_input(OLPC_GPIO_DCON_BLANK);
 	gpio_direction_output(OLPC_GPIO_DCON_LOAD,
-			dcon_source == DCON_SOURCE_CPU);
+			dcon->curr_src == DCON_SOURCE_CPU);
 
 	/* Set up the interrupt mappings */
 
@@ -81,7 +81,7 @@ static int dcon_init_xo_1(void)
 	outb(lob, 0x4d0);
 
 	/* Register the interupt handler */
-	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", &dcon_driver)) {
+	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", dcon)) {
 		printk(KERN_ERR "olpc-dcon: failed to request DCON's irq\n");
 		goto err_req_irq;
 	}
diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
index d4c2d74..e213b63 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
@@ -57,7 +57,7 @@ static int dcon_was_irq(void)
 	return 0;
 }
 
-static int dcon_init_xo_1_5(void)
+static int dcon_init_xo_1_5(struct dcon_priv *dcon)
 {
 	unsigned int irq;
 	u_int8_t tmp;
@@ -96,20 +96,19 @@ static int dcon_init_xo_1_5(void)
 
 	/* Determine the current state of DCONLOAD, likely set by firmware */
 	/* GPIO1 */
-	dcon_source = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x1000) ?
+	dcon->curr_src = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x1000) ?
 			DCON_SOURCE_CPU : DCON_SOURCE_DCON;
-	dcon_pending = dcon_source;
+	dcon->pending_src = dcon->curr_src;
 
 	pci_dev_put(pdev);
 
 	/* we're sharing the IRQ with ACPI */
 	irq = acpi_gbl_FADT.sci_interrupt;
-	if (request_irq(irq, &dcon_interrupt, IRQF_SHARED, "DCON", &dcon_driver)) {
+	if (request_irq(irq, &dcon_interrupt, IRQF_SHARED, "DCON", dcon)) {
 		printk(KERN_ERR PREFIX "DCON (IRQ%d) allocation failed\n", irq);
 		return 1;
 	}
 
-
 	return 0;
 }
 
-- 
1.7.2.3

