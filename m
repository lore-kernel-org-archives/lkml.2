Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0DWIDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:03:14 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38576 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab0DWIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 11/14] m68k: amiga - Mouse platform device conversion
Date: Fri, 23 Apr 2010 10:00:32 +0200
Message-Id: <1272009635-6504-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-11-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-9-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-10-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-11-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c     |    3 +
 drivers/input/mouse/amimouse.c |   98 +++++++++++++++++++++++++--------------
 2 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index d427de2..269bafc 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -165,6 +165,9 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_KEYBOARD))
 		platform_device_register_simple("amiga-keyboard", -1, NULL, 0);
 
+	if (AMIGAHW_PRESENT(AMI_MOUSE))
+		platform_device_register_simple("amiga-mouse", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index a185ac7..ff5f61a 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
 #include <asm/irq.h>
 #include <asm/setup.h>
@@ -34,10 +35,10 @@ MODULE_DESCRIPTION("Amiga mouse driver");
 MODULE_LICENSE("GPL");
 
 static int amimouse_lastx, amimouse_lasty;
-static struct input_dev *amimouse_dev;
 
-static irqreturn_t amimouse_interrupt(int irq, void *dummy)
+static irqreturn_t amimouse_interrupt(int irq, void *data)
 {
+	struct input_dev *dev = data;
 	unsigned short joy0dat, potgor;
 	int nx, ny, dx, dy;
 
@@ -59,14 +60,14 @@ static irqreturn_t amimouse_interrupt(int irq, void *dummy)
 
 	potgor = amiga_custom.potgor;
 
-	input_report_rel(amimouse_dev, REL_X, dx);
-	input_report_rel(amimouse_dev, REL_Y, dy);
+	input_report_rel(dev, REL_X, dx);
+	input_report_rel(dev, REL_Y, dy);
 
-	input_report_key(amimouse_dev, BTN_LEFT,   ciaa.pra & 0x40);
-	input_report_key(amimouse_dev, BTN_MIDDLE, potgor & 0x0100);
-	input_report_key(amimouse_dev, BTN_RIGHT,  potgor & 0x0400);
+	input_report_key(dev, BTN_LEFT,   ciaa.pra & 0x40);
+	input_report_key(dev, BTN_MIDDLE, potgor & 0x0100);
+	input_report_key(dev, BTN_RIGHT,  potgor & 0x0400);
 
-	input_sync(amimouse_dev);
+	input_sync(dev);
 
 	return IRQ_HANDLED;
 }
@@ -74,63 +75,90 @@ static irqreturn_t amimouse_interrupt(int irq, void *dummy)
 static int amimouse_open(struct input_dev *dev)
 {
 	unsigned short joy0dat;
+	int error;
 
 	joy0dat = amiga_custom.joy0dat;
 
 	amimouse_lastx = joy0dat & 0xff;
 	amimouse_lasty = joy0dat >> 8;
 
-	if (request_irq(IRQ_AMIGA_VERTB, amimouse_interrupt, 0, "amimouse", amimouse_interrupt)) {
-                printk(KERN_ERR "amimouse.c: Can't allocate irq %d\n", IRQ_AMIGA_VERTB);
-                return -EBUSY;
-        }
+	error = request_irq(IRQ_AMIGA_VERTB, amimouse_interrupt, 0, "amimouse",
+			    dev);
+	if (error)
+		dev_err(&dev->dev, "Can't allocate irq %d\n", IRQ_AMIGA_VERTB);
 
-        return 0;
+	return error;
 }
 
 static void amimouse_close(struct input_dev *dev)
 {
-	free_irq(IRQ_AMIGA_VERTB, amimouse_interrupt);
+	free_irq(IRQ_AMIGA_VERTB, dev);
 }
 
-static int __init amimouse_init(void)
+static int __init amimouse_probe(struct platform_device *pdev)
 {
 	int err;
+	struct input_dev *dev;
 
-	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(AMI_MOUSE))
-		return -ENODEV;
-
-	amimouse_dev = input_allocate_device();
-	if (!amimouse_dev)
+	dev = input_allocate_device();
+	if (!dev)
 		return -ENOMEM;
 
-	amimouse_dev->name = "Amiga mouse";
-	amimouse_dev->phys = "amimouse/input0";
-	amimouse_dev->id.bustype = BUS_AMIGA;
-	amimouse_dev->id.vendor = 0x0001;
-	amimouse_dev->id.product = 0x0002;
-	amimouse_dev->id.version = 0x0100;
+	dev->name = pdev->name;
+	dev->phys = "amimouse/input0";
+	dev->id.bustype = BUS_AMIGA;
+	dev->id.vendor = 0x0001;
+	dev->id.product = 0x0002;
+	dev->id.version = 0x0100;
 
-	amimouse_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
-	amimouse_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
-	amimouse_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+	dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
 		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
-	amimouse_dev->open = amimouse_open;
-	amimouse_dev->close = amimouse_close;
+	dev->open = amimouse_open;
+	dev->close = amimouse_close;
+	dev->dev.parent = &pdev->dev;
 
-	err = input_register_device(amimouse_dev);
+	err = input_register_device(dev);
 	if (err) {
-		input_free_device(amimouse_dev);
+		input_free_device(dev);
 		return err;
 	}
 
+	platform_set_drvdata(pdev, dev);
+
 	return 0;
 }
 
-static void __exit amimouse_exit(void)
+static int __exit amimouse_remove(struct platform_device *pdev)
 {
-        input_unregister_device(amimouse_dev);
+	struct input_dev *dev = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	input_unregister_device(dev);
+	return 0;
+}
+
+static struct platform_driver amimouse_driver = {
+	.remove = __exit_p(amimouse_remove),
+	.driver   = {
+		.name	= "amiga-mouse",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amimouse_init(void)
+{
+	return platform_driver_probe(&amimouse_driver, amimouse_probe);
 }
 
 module_init(amimouse_init);
+
+static void __exit amimouse_exit(void)
+{
+	platform_driver_unregister(&amimouse_driver);
+}
+
 module_exit(amimouse_exit);
+
+MODULE_ALIAS("platform:amiga-mouse");
-- 
1.6.0.4

