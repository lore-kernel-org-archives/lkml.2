Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab0HEHcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:32:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2270 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759846Ab0HEH3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:54 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] drivers/input/keyboard: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:44 -0700
Message-Id: <2bfbe5c3c84aade9813c0a894ca4575122a27c81.1280992118.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move error messages from array to direct uses.
Convert bare printks to pr_cont

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/keyboard/amikbd.c         |   42 ++++++++++++++++-------
 drivers/input/keyboard/atakbd.c         |    4 ++-
 drivers/input/keyboard/hil_kbd.c        |   21 +++++-------
 drivers/input/keyboard/hilkbd.c         |   26 ++++++++-------
 drivers/input/keyboard/jornada680_kbd.c |    5 ++-
 drivers/input/keyboard/jornada720_kbd.c |   10 +++--
 drivers/input/keyboard/lkkbd.c          |   54 +++++++++++++++----------------
 drivers/input/keyboard/locomokbd.c      |    6 ++-
 drivers/input/keyboard/newtonkbd.c      |    4 ++-
 drivers/input/keyboard/omap-keypad.c    |   25 +++++++-------
 drivers/input/keyboard/sunkbd.c         |    9 +++--
 drivers/input/keyboard/xtkbd.c          |    7 +++-
 12 files changed, 119 insertions(+), 94 deletions(-)

diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 79172af..61f92a5 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -144,17 +146,6 @@ static unsigned char amikbd_keycode[0x78] __initdata = {
 	[103]	 = KEY_RIGHTMETA
 };
 
-static const char *amikbd_messages[8] = {
-	[0] = KERN_ALERT "amikbd: Ctrl-Amiga-Amiga reset warning!!\n",
-	[1] = KERN_WARNING "amikbd: keyboard lost sync\n",
-	[2] = KERN_WARNING "amikbd: keyboard buffer overflow\n",
-	[3] = KERN_WARNING "amikbd: keyboard controller failure\n",
-	[4] = KERN_ERR "amikbd: keyboard selftest failure\n",
-	[5] = KERN_INFO "amikbd: initiate power-up key stream\n",
-	[6] = KERN_INFO "amikbd: terminate power-up key stream\n",
-	[7] = KERN_WARNING "amikbd: keyboard interrupt\n"
-};
-
 static irqreturn_t amikbd_interrupt(int irq, void *data)
 {
 	struct input_dev *dev = data;
@@ -177,8 +168,33 @@ static irqreturn_t amikbd_interrupt(int irq, void *data)
 		}
 
 		input_sync(dev);
-	} else				/* scancodes >= 0x78 are error codes */
-		printk(amikbd_messages[scancode - 0x78]);
+	} else {			/* scancodes >= 0x78 are error codes */
+		switch (scancode) {
+		case 0x78:
+			pr_alert("Ctrl-Amiga-Amiga reset warning!!\n");
+			break;
+		case 0x79:
+			pr_warning("keyboard lost sync\n");
+			break;
+		case 0x7a:
+			pr_warning("keyboard buffer overflow\n");
+			break;
+		case 0x7b:
+			pr_warning("keyboard controller failure\n");
+			break;
+		case 0x7c:
+			pr_err("keyboard selftest failure\n");
+			break;
+		case 0x7d:
+			pr_info("initiate power-up key stream\n");
+			break;
+		case 0x7e:
+			pr_info("terminate power-up key stream\n");
+			break;
+		case 0x7f:
+			pr_warning("keyboard interrupt\n");
+			break;
+		}
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/keyboard/atakbd.c b/drivers/input/keyboard/atakbd.c
index 1839194..5975052 100644
--- a/drivers/input/keyboard/atakbd.c
+++ b/drivers/input/keyboard/atakbd.c
@@ -40,6 +40,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -210,7 +212,7 @@ static void atakbd_interrupt(unsigned char scancode, char down)
 			input_sync(atakbd_dev);
 		}
 	} else				/* scancodes >= 0xf2 are mouse data, most likely */
-		printk(KERN_INFO "atakbd: unhandled scancode %x\n", scancode);
+		pr_info("unhandled scancode %x\n", scancode);
 
 	return;
 }
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index ddd5afd..cf6448a 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hil.h>
 #include <linux/input.h>
 #include <linux/serio.h>
@@ -131,7 +133,7 @@ static void hil_dev_handle_command_response(struct hil_dev *dev)
 		/* These occur when device isn't present */
 		if (p != (HIL_ERR_INT | HIL_PKT_CMD)) {
 			/* Anything else we'd like to know about. */
-			printk(KERN_WARNING PREFIX "Device sent unknown record %x\n", p);
+			pr_warning("Device sent unknown record %x\n", p);
 		}
 		goto out;
 	}
@@ -212,8 +214,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 	bool absdev, ax16;
 
 	if ((p & HIL_CMDCT_POL) != idx - 1) {
-		printk(KERN_WARNING PREFIX
-			"Malformed poll packet %x (idx = %i)\n", p, idx);
+		pr_warning("Malformed poll packet %x (idx = %i)\n", p, idx);
 		return;
 	}
 
@@ -267,7 +268,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 
 static void hil_dev_process_err(struct hil_dev *dev)
 {
-	printk(KERN_WARNING PREFIX "errored HIL packet\n");
+	pr_warning("errored HIL packet\n");
 	dev->idx4 = 0;
 	complete(&dev->cmd_done); /* just in case somebody is waiting */
 }
@@ -347,7 +348,7 @@ static void hil_dev_keyboard_setup(struct hil_dev *kbd)
 	input_dev->name	= strlen(kbd->rnm) ? kbd->rnm : "HIL keyboard";
 	input_dev->phys	= "hpkbd/input0";
 
-	printk(KERN_INFO PREFIX "HIL keyboard found (did = 0x%02x, lang = %s)\n",
+	pr_info("HIL keyboard found (did = 0x%02x, lang = %s)\n",
 		did, hil_language[did & HIL_IDD_DID_TYPE_KB_LANG_MASK]);
 }
 
@@ -433,11 +434,8 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 
 	input_dev->name = strlen(ptr->rnm) ? ptr->rnm : "HIL pointer device";
 
-	printk(KERN_INFO PREFIX
-		"HIL pointer device found (did: 0x%02x, axis: %s)\n",
-		did, txt);
-	printk(KERN_INFO PREFIX
-		"HIL pointer has %i buttons and %i sets of %i axes\n",
+	pr_info("HIL pointer device found (did: 0x%02x, axis: %s)\n", did, txt);
+	pr_info("HIL pointer has %i buttons and %i sets of %i axes\n",
 		ptr->nbtn, naxsets, ptr->naxes);
 }
 
@@ -511,8 +509,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 	case HIL_IDD_DID_TYPE_CHAR:
 		if (HIL_IDD_NUM_BUTTONS(idd) ||
 		    HIL_IDD_NUM_AXES_PER_SET(*idd)) {
-			printk(KERN_INFO PREFIX
-				"combo devices are not supported.\n");
+			pr_info("combo devices are not supported\n");
 			goto bail1;
 		}
 
diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index 5f72440..447f49a 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -15,6 +15,8 @@
  * archive for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci_ids.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
@@ -219,7 +221,7 @@ static int __devinit hil_keyb_init(void)
 
 	err = request_irq(HIL_IRQ, hil_interrupt, 0, "hil", hil_dev.dev_id);
 	if (err) {
-		printk(KERN_ERR "HIL: Can't get IRQ\n");
+		pr_err("Can't get IRQ\n");
 		goto err1;
 	}
 
@@ -232,16 +234,16 @@ static int __devinit hil_keyb_init(void)
 
 	wait_event_interruptible_timeout(hil_wait, hil_dev.valid, 3 * HZ);
 	if (!hil_dev.valid)
-		printk(KERN_WARNING "HIL: timed out, assuming no keyboard present\n");
+		pr_warning("timed out, assuming no keyboard present\n");
 
 	c = hil_dev.c;
 	hil_dev.valid = 0;
 	if (c == 0) {
 		kbid = -1;
-		printk(KERN_WARNING "HIL: no keyboard present\n");
+		pr_warning("no keyboard present\n");
 	} else {
 		kbid = ffz(~c);
-		printk(KERN_INFO "HIL: keyboard found at id %d\n", kbid);
+		pr_info("keyboard found at id %d\n", kbid);
 	}
 
 	/* set it to raw mode */
@@ -268,12 +270,12 @@ static int __devinit hil_keyb_init(void)
 
 	err = input_register_device(hil_dev.dev);
 	if (err) {
-		printk(KERN_ERR "HIL: Can't register device\n");
+		pr_err("Can't register device\n");
 		goto err2;
 	}
 
-	printk(KERN_INFO "input: %s, ID %d at 0x%08lx (irq %d) found and attached\n",
-	       hil_dev.dev->name, kbid, HILBASE, HIL_IRQ);
+	pr_info("%s, ID %d at 0x%08lx (irq %d) found and attached\n",
+		hil_dev.dev->name, kbid, HILBASE, HIL_IRQ);
 
 	return 0;
 
@@ -306,8 +308,8 @@ static int __devinit hil_probe_chip(struct parisc_device *dev)
 		return -ENODEV;
 
 	if (!dev->irq) {
-		printk(KERN_WARNING "HIL: IRQ not found for HIL bus at 0x%p\n",
-			(void *)dev->hpa.start);
+		pr_warning("IRQ not found for HIL bus at 0x%p\n",
+			   (void *)dev->hpa.start);
 		return -ENODEV;
 	}
 
@@ -315,7 +317,7 @@ static int __devinit hil_probe_chip(struct parisc_device *dev)
 	hil_irq  = dev->irq;
 	hil_dev.dev_id = dev;
 
-	printk(KERN_INFO "Found HIL bus at 0x%08lx, IRQ %d\n", hil_base, hil_irq);
+	pr_info("Found HIL bus at 0x%08lx, IRQ %d\n", hil_base, hil_irq);
 
 	return hil_keyb_init();
 }
@@ -368,12 +370,12 @@ static int __init hil_init(void)
 		return -ENODEV;
 
 	if (!hwreg_present((void *)(HILBASE + HIL_DATA))) {
-		printk(KERN_ERR "HIL: hardware register was not found\n");
+		pr_err("hardware register was not found\n");
 		return -ENODEV;
 	}
 
 	if (!request_region(HILBASE + HIL_DATA, 2, "hil")) {
-		printk(KERN_ERR "HIL: IOPORT region already used\n");
+		pr_err("IOPORT region already used\n");
 		return -EIO;
 	}
 
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index 5fc976d..e2c7112 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -16,6 +16,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input-polldev.h>
@@ -231,8 +233,7 @@ static int __devinit jornada680kbd_probe(struct platform_device *pdev)
 	return 0;
 
  failed:
-	printk(KERN_ERR "Jornadakbd: failed to register driver, error: %d\n",
-		error);
+	pr_err("failed to register driver, error: %d\n", error);
 	platform_set_drvdata(pdev, NULL);
 	input_free_polled_device(poll_dev);
 	kfree(jornadakbd);
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index 2cd3e1d..f1995d8 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -15,6 +15,9 @@
  * published by the Free Software Foundation.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -67,9 +70,8 @@ static irqreturn_t jornada720_kbd_interrupt(int irq, void *dev_id)
 
 	if (jornada_ssp_inout(GETSCANKEYCODE) != TXDUMMY) {
 		printk(KERN_DEBUG
-			"jornada720_kbd: "
-			"GetKeycode command failed with ETIMEDOUT, "
-			"flushed bus\n");
+		       pr_fmt("GetKeycode command failed with ETIMEDOUT, "
+			      "flushed bus\n"));
 	} else {
 		/* How many keycodes are waiting for us? */
 		count = jornada_ssp_byte(TXDUMMY);
@@ -132,7 +134,7 @@ static int __devinit jornada720_kbd_probe(struct platform_device *pdev)
 			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
 			  "jornadakbd", pdev);
 	if (err) {
-		printk(KERN_INFO "jornadakbd720_kbd: Unable to grab IRQ\n");
+		pr_info("Unable to grab IRQ\n");
 		goto fail1;
 	}
 
diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index fa9bb6d..41d3770 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -61,6 +61,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -105,9 +107,9 @@ MODULE_PARM_DESC(lk201_compose_is_alt,
 
 #undef LKKBD_DEBUG
 #ifdef LKKBD_DEBUG
-#define DBG(x...) printk(x)
+#define DBG(format, arg...) pr_info(format, ##arg)
 #else
-#define DBG(x...) do {} while (0)
+#define DBG(format, arg...) do { if (0) pr_info(format, ##arg); } while (0)
 #endif
 
 /* LED control */
@@ -384,18 +386,16 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 
 	default:
 		strlcpy(lk->name, "Unknown DEC keyboard", sizeof(lk->name));
-		printk(KERN_ERR
-			"lkkbd: keyboard on %s is unknown, please report to "
+		pr_err("keyboard on %s is unknown, please report to "
 			"Jan-Benedict Glaw <jbglaw@lug-owl.de>\n", lk->phys);
-		printk(KERN_ERR "lkkbd: keyboard ID'ed as:");
+		pr_err("keyboard ID'ed as:");
 		for (i = 0; i < LK_NUM_IGNORE_BYTES; i++)
-			printk(" 0x%02x", lk->id[i]);
-		printk("\n");
+			pr_cont(" 0x%02x", lk->id[i]);
+		pr_cont("\n");
 		break;
 	}
 
-	printk(KERN_INFO "lkkbd: keyboard on %s identified as: %s\n",
-		lk->phys, lk->name);
+	pr_info("keyboard on %s identified as: %s\n", lk->phys, lk->name);
 
 	/*
 	 * Report errors during keyboard boot-up.
@@ -406,20 +406,18 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 		break;
 
 	case LK_STUCK_KEY:
-		printk(KERN_ERR "lkkbd: Stuck key on keyboard at %s\n",
+		pr_err("Stuck key on keyboard at %s\n",
 			lk->phys);
 		break;
 
 	case LK_SELFTEST_FAILED:
-		printk(KERN_ERR
-			"lkkbd: Selftest failed on keyboard at %s, "
-			"keyboard may not work properly\n", lk->phys);
+		pr_err("Selftest failed on keyboard at %s, "
+		       "keyboard may not work properly\n", lk->phys);
 		break;
 
 	default:
-		printk(KERN_ERR
-			"lkkbd: Unknown error %02x on keyboard at %s\n",
-			lk->id[2], lk->phys);
+		pr_err("Unknown error %02x on keyboard at %s\n",
+		       lk->id[2], lk->phys);
 		break;
 	}
 
@@ -427,9 +425,8 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 	 * Try to hint user if there's a stuck key.
 	 */
 	if (lk->id[2] == LK_STUCK_KEY && lk->id[3] != 0)
-		printk(KERN_ERR
-			"Scancode of stuck key is 0x%02x, keycode is 0x%04x\n",
-			lk->id[3], lk->keycode[lk->id[3]]);
+		pr_err("Scancode of stuck key is 0x%02x, keycode is 0x%04x\n",
+		       lk->id[3], lk->keycode[lk->id[3]]);
 }
 
 /*
@@ -444,10 +441,10 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 	unsigned int keycode;
 	int i;
 
-	DBG(KERN_INFO "Got byte 0x%02x\n", data);
+	DBG("Got byte 0x%02x\n", data);
 
 	if (lk->ignore_bytes > 0) {
-		DBG(KERN_INFO "Ignoring a byte on %s\n", lk->name);
+		DBG("Ignoring a byte on %s\n", lk->name);
 		lk->id[LK_NUM_IGNORE_BYTES - lk->ignore_bytes--] = data;
 
 		if (lk->ignore_bytes == 0)
@@ -464,7 +461,7 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 		break;
 
 	case 0x01:
-		DBG(KERN_INFO "Got 0x01, scheduling re-initialization\n");
+		DBG("Got 0x01, scheduling re-initialization\n");
 		lk->ignore_bytes = LK_NUM_IGNORE_BYTES;
 		lk->id[LK_NUM_IGNORE_BYTES - lk->ignore_bytes--] = data;
 		schedule_work(&lk->tq);
@@ -478,8 +475,10 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 	case LK_PREFIX_KEY_DOWN:
 	case LK_MODE_CHANGE_ACK:
 	case LK_RESPONSE_RESERVED:
-		DBG(KERN_INFO "Got %s and don't know how to handle...\n",
-			response_name(data));
+#ifdef LKKBD_DEBUG
+		DBG("Got %s and don't know how to handle...\n",
+		    response_name(data));
+#endif
 		break;
 
 	default:
@@ -489,9 +488,8 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 					 !test_bit(keycode, input_dev->key));
 			input_sync(input_dev);
 		} else {
-			printk(KERN_WARNING
-				"%s: Unknown key with scancode 0x%02x on %s.\n",
-				__FILE__, data, lk->name);
+			pr_warning("Unknown key with scancode 0x%02x on %s\n",
+				   data, lk->name);
 		}
 	}
 
@@ -565,7 +563,7 @@ static int lkkbd_event(struct input_dev *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "%s(): Got unknown type %d, code %d, value %d\n",
+		pr_err("%s(): Got unknown type %d, code %d, value %d\n",
 			__func__, type, code, value);
 	}
 
diff --git a/drivers/input/keyboard/locomokbd.c b/drivers/input/keyboard/locomokbd.c
index b1ab298..01e60bd 100644
--- a/drivers/input/keyboard/locomokbd.c
+++ b/drivers/input/keyboard/locomokbd.c
@@ -23,6 +23,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -254,7 +256,7 @@ static int __devinit locomokbd_probe(struct locomo_dev *dev)
 				dev->length,
 				LOCOMO_DRIVER_NAME(dev))) {
 		err = -EBUSY;
-		printk(KERN_ERR "locomokbd: Can't acquire access to io memory for keyboard\n");
+		pr_err("Can't acquire access to io memory for keyboard\n");
 		goto err_free_mem;
 	}
 
@@ -299,7 +301,7 @@ static int __devinit locomokbd_probe(struct locomo_dev *dev)
 	/* attempt to get the interrupt */
 	err = request_irq(dev->irq[0], locomokbd_interrupt, 0, "locomokbd", locomokbd);
 	if (err) {
-		printk(KERN_ERR "locomokbd: Can't get irq for keyboard\n");
+		pr_err("Can't get irq for keyboard\n");
 		goto err_release_region;
 	}
 
diff --git a/drivers/input/keyboard/newtonkbd.c b/drivers/input/keyboard/newtonkbd.c
index 48d1cab..2b60858 100644
--- a/drivers/input/keyboard/newtonkbd.c
+++ b/drivers/input/keyboard/newtonkbd.c
@@ -26,6 +26,8 @@
  * Justin Cormack, 68 Dartmouth Park Road, London NW5 1SN, UK.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -76,7 +78,7 @@ static irqreturn_t nkbd_interrupt(struct serio *serio,
 	}
 
 	else if (data == 0xe7) /* end of init sequence */
-		printk(KERN_INFO "input: %s on %s\n", nkbd->dev->name, serio->phys);
+		pr_info("%s on %s\n", nkbd->dev->name, serio->phys);
 	return IRQ_HANDLED;
 
 }
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index a72e61d..2b85872 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -195,15 +197,14 @@ static void omap_kp_tasklet(unsigned long data)
 			if (!(changed & (1 << row)))
 				continue;
 #ifdef NEW_BOARD_LEARNING_MODE
-			printk(KERN_INFO "omap-keypad: key %d-%d %s\n", col,
-			       row, (new_state[col] & (1 << row)) ?
-			       "pressed" : "released");
+			pr_info("key %d-%d %s\n",
+				col, row, (new_state[col] & (1 << row)) ?
+				"pressed" : "released");
 #else
 			key = omap_kp_find_key(col, row);
 			if (key < 0) {
-				printk(KERN_WARNING
-				      "omap-keypad: Spurious key event %d-%d\n",
-				       col, row);
+				pr_warning("Spurious key event %d-%d\n",
+					   col, row);
 				/* We scan again after a couple of seconds */
 				spurious = 1;
 				continue;
@@ -300,7 +301,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 	int i, col_idx, row_idx, irq_idx, ret;
 
 	if (!pdata->rows || !pdata->cols || !pdata->keymap) {
-		printk(KERN_ERR "No rows, cols or keymap from pdata\n");
+		pr_err("No rows, cols or keymap from pdata\n");
 		return -EINVAL;
 	}
 
@@ -340,8 +341,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 		/* Cols: outputs */
 		for (col_idx = 0; col_idx < omap_kp->cols; col_idx++) {
 			if (gpio_request(col_gpios[col_idx], "omap_kp_col") < 0) {
-				printk(KERN_ERR "Failed to request"
-				       "GPIO%d for keypad\n",
+				pr_err("Failed to request GPIO%d for keypad\n",
 				       col_gpios[col_idx]);
 				goto err1;
 			}
@@ -350,8 +350,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 		/* Rows: inputs */
 		for (row_idx = 0; row_idx < omap_kp->rows; row_idx++) {
 			if (gpio_request(row_gpios[row_idx], "omap_kp_row") < 0) {
-				printk(KERN_ERR "Failed to request"
-				       "GPIO%d for keypad\n",
+				pr_err("Failed to request GPIO%d for keypad\n",
 				       row_gpios[row_idx]);
 				goto err2;
 			}
@@ -387,7 +386,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 
 	ret = input_register_device(omap_kp->input);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to register omap-keypad input device\n");
+		pr_err("Unable to register omap-keypad input device\n");
 		goto err3;
 	}
 
@@ -478,7 +477,7 @@ static struct platform_driver omap_kp_driver = {
 
 static int __init omap_kp_init(void)
 {
-	printk(KERN_INFO "OMAP Keypad Driver\n");
+	pr_info("OMAP Keypad Driver\n");
 	return platform_driver_register(&omap_kp_driver);
 }
 
diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index a99a04b..41216ca 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -137,10 +139,9 @@ static irqreturn_t sunkbd_interrupt(struct serio *serio,
 					 !(data & SUNKBD_RELEASE));
 			input_sync(sunkbd->dev);
 		} else {
-			printk(KERN_WARNING
-				"sunkbd.c: Unknown key (scancode %#x) %s.\n",
-				data & SUNKBD_KEY,
-				data & SUNKBD_RELEASE ? "released" : "pressed");
+			pr_warning("Unknown key (scancode %#x) %s.\n",
+				   data & SUNKBD_KEY,
+				   data & SUNKBD_RELEASE ? "released" : "pressed");
 		}
 	}
 out:
diff --git a/drivers/input/keyboard/xtkbd.c b/drivers/input/keyboard/xtkbd.c
index 37b01d7..292110b 100644
--- a/drivers/input/keyboard/xtkbd.c
+++ b/drivers/input/keyboard/xtkbd.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -76,8 +78,9 @@ static irqreturn_t xtkbd_interrupt(struct serio *serio,
 				input_report_key(xtkbd->dev, xtkbd->keycode[data & XTKBD_KEY], !(data & XTKBD_RELEASE));
 				input_sync(xtkbd->dev);
 			} else {
-				printk(KERN_WARNING "xtkbd.c: Unknown key (scancode %#x) %s.\n",
-					data & XTKBD_KEY, data & XTKBD_RELEASE ? "released" : "pressed");
+				pr_warning("Unknown key (scancode %#x) %s\n",
+					   data & XTKBD_KEY,
+					   data & XTKBD_RELEASE ? "released" : "pressed");
 			}
 	}
 	return IRQ_HANDLED;
-- 
1.7.2.19.g9a302

