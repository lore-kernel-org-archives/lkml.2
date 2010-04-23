Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0DWIAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:00:45 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:41838 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab0DWIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/14] m68k: amiga - Keyboard platform device conversion
Date: Fri, 23 Apr 2010 10:00:31 +0200
Message-Id: <1272009635-6504-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-10-git-send-email-geert@linux-m68k.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c      |    5 ++
 drivers/input/keyboard/amikbd.c |   97 +++++++++++++++++++++++----------------
 2 files changed, 63 insertions(+), 39 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 907f6f5..d427de2 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -160,6 +160,11 @@ static int __init amiga_init_devices(void)
 					 sizeof(a4000_ide_pdata));
 	}
 
+
+	/* other I/O hardware */
+	if (AMIGAHW_PRESENT(AMI_KEYBOARD))
+		platform_device_register_simple("amiga-keyboard", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 35149ec..79172af 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/keyboard.h>
+#include <linux/platform_device.h>
 
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
@@ -154,10 +155,9 @@ static const char *amikbd_messages[8] = {
 	[7] = KERN_WARNING "amikbd: keyboard interrupt\n"
 };
 
-static struct input_dev *amikbd_dev;
-
-static irqreturn_t amikbd_interrupt(int irq, void *dummy)
+static irqreturn_t amikbd_interrupt(int irq, void *data)
 {
+	struct input_dev *dev = data;
 	unsigned char scancode, down;
 
 	scancode = ~ciaa.sdr;		/* get and invert scancode (keyboard is active low) */
@@ -170,47 +170,42 @@ static irqreturn_t amikbd_interrupt(int irq, void *dummy)
 
 	if (scancode < 0x78) {		/* scancodes < 0x78 are keys */
 		if (scancode == 98) {	/* CapsLock is a toggle switch key on Amiga */
-			input_report_key(amikbd_dev, scancode, 1);
-			input_report_key(amikbd_dev, scancode, 0);
+			input_report_key(dev, scancode, 1);
+			input_report_key(dev, scancode, 0);
 		} else {
-			input_report_key(amikbd_dev, scancode, down);
+			input_report_key(dev, scancode, down);
 		}
 
-		input_sync(amikbd_dev);
+		input_sync(dev);
 	} else				/* scancodes >= 0x78 are error codes */
 		printk(amikbd_messages[scancode - 0x78]);
 
 	return IRQ_HANDLED;
 }
 
-static int __init amikbd_init(void)
+static int __init amikbd_probe(struct platform_device *pdev)
 {
+	struct input_dev *dev;
 	int i, j, err;
 
-	if (!AMIGAHW_PRESENT(AMI_KEYBOARD))
-		return -ENODEV;
-
-	if (!request_mem_region(CIAA_PHYSADDR-1+0xb00, 0x100, "amikeyb"))
-		return -EBUSY;
-
-	amikbd_dev = input_allocate_device();
-	if (!amikbd_dev) {
-		printk(KERN_ERR "amikbd: not enough memory for input device\n");
-		err = -ENOMEM;
-		goto fail1;
+	dev = input_allocate_device();
+	if (!dev) {
+		dev_err(&pdev->dev, "Not enough memory for input device\n");
+		return -ENOMEM;
 	}
 
-	amikbd_dev->name = "Amiga Keyboard";
-	amikbd_dev->phys = "amikbd/input0";
-	amikbd_dev->id.bustype = BUS_AMIGA;
-	amikbd_dev->id.vendor = 0x0001;
-	amikbd_dev->id.product = 0x0001;
-	amikbd_dev->id.version = 0x0100;
+	dev->name = pdev->name;
+	dev->phys = "amikbd/input0";
+	dev->id.bustype = BUS_AMIGA;
+	dev->id.vendor = 0x0001;
+	dev->id.product = 0x0001;
+	dev->id.version = 0x0100;
+	dev->dev.parent = &pdev->dev;
 
-	amikbd_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 
 	for (i = 0; i < 0x78; i++)
-		set_bit(i, amikbd_dev->keybit);
+		set_bit(i, dev->keybit);
 
 	for (i = 0; i < MAX_NR_KEYMAPS; i++) {
 		static u_short temp_map[NR_KEYS] __initdata;
@@ -229,30 +224,54 @@ static int __init amikbd_init(void)
 		memcpy(key_maps[i], temp_map, sizeof(temp_map));
 	}
 	ciaa.cra &= ~0x41;	 /* serial data in, turn off TA */
-	if (request_irq(IRQ_AMIGA_CIAA_SP, amikbd_interrupt, 0, "amikbd",
-			amikbd_interrupt)) {
-		err = -EBUSY;
+	err = request_irq(IRQ_AMIGA_CIAA_SP, amikbd_interrupt, 0, "amikbd",
+			  dev);
+	if (err)
 		goto fail2;
-	}
 
-	err = input_register_device(amikbd_dev);
+	err = input_register_device(dev);
 	if (err)
 		goto fail3;
 
+	platform_set_drvdata(pdev, dev);
+
 	return 0;
 
- fail3:	free_irq(IRQ_AMIGA_CIAA_SP, amikbd_interrupt);
- fail2:	input_free_device(amikbd_dev);
- fail1:	release_mem_region(CIAA_PHYSADDR - 1 + 0xb00, 0x100);
+ fail3:	free_irq(IRQ_AMIGA_CIAA_SP, dev);
+ fail2:	input_free_device(dev);
 	return err;
 }
 
-static void __exit amikbd_exit(void)
+static int __exit amikbd_remove(struct platform_device *pdev)
+{
+	struct input_dev *dev = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	free_irq(IRQ_AMIGA_CIAA_SP, dev);
+	input_unregister_device(dev);
+	return 0;
+}
+
+static struct platform_driver amikbd_driver = {
+	.remove = __exit_p(amikbd_remove),
+	.driver   = {
+		.name	= "amiga-keyboard",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amikbd_init(void)
 {
-	free_irq(IRQ_AMIGA_CIAA_SP, amikbd_interrupt);
-	input_unregister_device(amikbd_dev);
-	release_mem_region(CIAA_PHYSADDR - 1 + 0xb00, 0x100);
+	return platform_driver_probe(&amikbd_driver, amikbd_probe);
 }
 
 module_init(amikbd_init);
+
+static void __exit amikbd_exit(void)
+{
+	platform_driver_unregister(&amikbd_driver);
+}
+
 module_exit(amikbd_exit);
+
+MODULE_ALIAS("platform:amiga-keyboard");
-- 
1.6.0.4

