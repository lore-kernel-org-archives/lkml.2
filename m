Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab0HEHaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:30:01 -0400
Received: from mail.perches.com ([173.55.12.10]:2269 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759842Ab0HEH3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:54 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/9] drivers/input/joystick: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:43 -0700
Message-Id: <77ea3ee3d9995d1659fb4d4ecfedda10a8f8c755.1280992118.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert some bare printks to pr_cont
Add argument checking to non-debug #define dbg

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/joystick/a3d.c                   |    9 +++-
 drivers/input/joystick/adi.c                   |   12 +++--
 drivers/input/joystick/amijoy.c                |    4 +-
 drivers/input/joystick/analog.c                |   15 ++++---
 drivers/input/joystick/cobra.c                 |    7 ++-
 drivers/input/joystick/db9.c                   |   16 ++++---
 drivers/input/joystick/gf2k.c                  |    7 ++-
 drivers/input/joystick/grip_mp.c               |   15 ++++---
 drivers/input/joystick/guillemot.c             |   11 +++-
 drivers/input/joystick/iforce/iforce-packets.c |    8 ++-
 drivers/input/joystick/interact.c              |    7 ++-
 drivers/input/joystick/joydump.c               |   40 +++++++++-------
 drivers/input/joystick/sidewinder.c            |   58 +++++++++++++-----------
 drivers/input/joystick/spaceball.c             |    6 ++-
 drivers/input/joystick/spaceorb.c              |   15 ++++--
 drivers/input/joystick/turbografx.c            |   16 ++++---
 drivers/input/joystick/walkera0701.c           |    6 ++-
 drivers/input/joystick/xpad.c                  |    4 +-
 18 files changed, 156 insertions(+), 100 deletions(-)

diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index d259b41..73d897b 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -295,8 +297,9 @@ static int a3d_connect(struct gameport *gameport, struct gameport_driver *drv)
 	a3d->mode = data[0];
 
 	if (!a3d->mode || a3d->mode > 5) {
-		printk(KERN_WARNING "a3d.c: Unknown A3D device detected "
-			"(%s, id=%d), contact <vojtech@ucw.cz>\n", gameport->phys, a3d->mode);
+		pr_warning("Unknown A3D device detected "
+			   "(%s, id=%d), contact <vojtech@ucw.cz>\n",
+			   gameport->phys, a3d->mode);
 		err = -ENODEV;
 		goto fail2;
 	}
@@ -360,7 +363,7 @@ static int a3d_connect(struct gameport *gameport, struct gameport_driver *drv)
 		a3d_read(a3d, data);
 
 		if (!(a3d->adc = adc = gameport_allocate_port()))
-			printk(KERN_ERR "a3d: Not enough memory for ADC port\n");
+			pr_err("Not enough memory for ADC port\n");
 		else {
 			adc->port_data = a3d;
 			adc->open = a3d_adc_open;
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index b992fbf..84e257e 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -336,7 +338,8 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 		return;
 
 	if (adi->ret < (t = adi_get_bits(adi, 10))) {
-		printk(KERN_WARNING "adi: Short ID packet: reported: %d != read: %d\n", t, adi->ret);
+		pr_warning("Short ID packet: reported: %d != read: %d\n",
+			   t, adi->ret);
 		return;
 	}
 
@@ -347,7 +350,7 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 	adi->length = adi_get_bits(adi, 10);
 
 	if (adi->length >= ADI_MAX_LENGTH || adi->length < ADI_MIN_LENGTH) {
-		printk(KERN_WARNING "adi: Bad data packet length (%d).\n", adi->length);
+		pr_warning("Bad data packet length (%d)\n", adi->length);
 		adi->length = 0;
 		return;
 	}
@@ -356,7 +359,7 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 	adi->buttons = adi_get_bits(adi, 6);
 
 	if (adi_get_bits(adi, 6) != 8 && adi->hats) {
-		printk(KERN_WARNING "adi: Other than 8-dir POVs not supported yet.\n");
+		pr_warning("Other than 8-dir POVs not supported yet\n");
 		adi->length = 0;
 		return;
 	}
@@ -379,7 +382,8 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 
 	t = 8 + adi->buttons + adi->axes10 * 10 + adi->axes8 * 8 + adi->hats * 4;
 	if (adi->length != t && adi->length != t + (t & 1)) {
-		printk(KERN_WARNING "adi: Expected length %d != data length %d\n", t, adi->length);
+		pr_warning("Expected length %d != data length %d\n",
+			   t, adi->length);
 		adi->length = 0;
 		return;
 	}
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index e90694f..fcf943a 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -84,7 +86,7 @@ static int amijoy_open(struct input_dev *dev)
 		return err;
 
 	if (!amijoy_used && request_irq(IRQ_AMIGA_VERTB, amijoy_interrupt, 0, "amijoy", amijoy_interrupt)) {
-		printk(KERN_ERR "amijoy.c: Can't allocate irq %d\n", IRQ_AMIGA_VERTB);
+		pr_err("Can't allocate irq %d\n", IRQ_AMIGA_VERTB);
 		err = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 4afe0a3..12e9abc 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -531,9 +533,9 @@ static int analog_init_masks(struct analog_port *port)
 		return -1;
 
 	if ((port->mask & 3) != 3 && port->mask != 0xc) {
-		printk(KERN_WARNING "analog.c: Unknown joystick device found  "
-			"(data=%#x, %s), probably not analog joystick.\n",
-			port->mask, port->gameport->phys);
+		pr_warning("Unknown joystick device found  "
+			   "(data=%#x, %s), probably not analog joystick\n",
+			   port->mask, port->gameport->phys);
 		return -1;
 	}
 
@@ -693,8 +695,9 @@ static void analog_disconnect(struct gameport *gameport)
 			input_unregister_device(port->analog[i].dev);
 	gameport_close(gameport);
 	gameport_set_drvdata(gameport, NULL);
-	printk(KERN_INFO "analog.c: %d out of %d reads (%d%%) on %s failed\n",
-		port->bads, port->reads, port->reads ? (port->bads * 100 / port->reads) : 0,
+	pr_info("%d out of %d reads (%d%%) on %s failed\n",
+		port->bads, port->reads,
+		port->reads ? (port->bads * 100 / port->reads) : 0,
 		port->gameport->phys);
 	kfree(port);
 }
@@ -738,7 +741,7 @@ static void analog_parse_options(void)
 		analog_options[i] = 0xff;
 		if (!strlen(js[i])) continue;
 
-		printk(KERN_WARNING "analog.c: Bad config for port %d - \"%s\"\n", i, js[i]);
+		pr_warning("Bad config for port %d - \"%s\"\n", i, js[i]);
 	}
 
 	for (; i < ANALOG_PORTS; i++)
diff --git a/drivers/input/joystick/cobra.c b/drivers/input/joystick/cobra.c
index 3497b87..010a130 100644
--- a/drivers/input/joystick/cobra.c
+++ b/drivers/input/joystick/cobra.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -177,8 +179,9 @@ static int cobra_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 	for (i = 0; i < 2; i++)
 		if ((cobra->exists >> i) & data[i] & 1) {
-			printk(KERN_WARNING "cobra.c: Device %d on %s has the Ext bit set. ID is: %d"
-				" Contact vojtech@ucw.cz\n", i, gameport->phys, (data[i] >> 2) & 7);
+			pr_warning("Device %d on %s has the Ext bit set. ID is: %d"
+				   " Contact vojtech@ucw.cz\n",
+				   i, gameport->phys, (data[i] >> 2) & 7);
 			cobra->exists &= ~(1 << i);
 		}
 
diff --git a/drivers/input/joystick/db9.c b/drivers/input/joystick/db9.c
index 8e7de5c..4ee17ee 100644
--- a/drivers/input/joystick/db9.c
+++ b/drivers/input/joystick/db9.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -564,7 +566,7 @@ static struct db9 __init *db9_probe(int parport, int mode)
 	int err;
 
 	if (mode < 1 || mode >= DB9_MAX_PAD || !db9_modes[mode].n_buttons) {
-		printk(KERN_ERR "db9.c: Bad device type %d\n", mode);
+		pr_err("Bad device type %d\n", mode);
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -573,27 +575,27 @@ static struct db9 __init *db9_probe(int parport, int mode)
 
 	pp = parport_find_number(parport);
 	if (!pp) {
-		printk(KERN_ERR "db9.c: no such parport\n");
+		pr_err("no such parport\n");
 		err = -ENODEV;
 		goto err_out;
 	}
 
 	if (db9_mode->bidirectional && !(pp->modes & PARPORT_MODE_TRISTATE)) {
-		printk(KERN_ERR "db9.c: specified parport is not bidirectional\n");
+		pr_err("specified parport is not bidirectional\n");
 		err = -EINVAL;
 		goto err_put_pp;
 	}
 
 	pd = parport_register_device(pp, "db9", NULL, NULL, NULL, PARPORT_DEV_EXCL, NULL);
 	if (!pd) {
-		printk(KERN_ERR "db9.c: parport busy already - lp.o loaded?\n");
+		pr_err("parport busy already - lp.o loaded?\n");
 		err = -EBUSY;
 		goto err_put_pp;
 	}
 
 	db9 = kzalloc(sizeof(struct db9), GFP_KERNEL);
 	if (!db9) {
-		printk(KERN_ERR "db9.c: Not enough memory\n");
+		pr_err("Not enough memory\n");
 		err = -ENOMEM;
 		goto err_unreg_pardev;
 	}
@@ -609,7 +611,7 @@ static struct db9 __init *db9_probe(int parport, int mode)
 
 		db9->dev[i] = input_dev = input_allocate_device();
 		if (!input_dev) {
-			printk(KERN_ERR "db9.c: Not enough memory for input device\n");
+			pr_err("Not enough memory for input device\n");
 			err = -ENOMEM;
 			goto err_unreg_devs;
 		}
@@ -682,7 +684,7 @@ static int __init db9_init(void)
 			continue;
 
 		if (db9_cfg[i].nargs < 2) {
-			printk(KERN_ERR "db9.c: Device type must be specified.\n");
+			pr_err("Device type must be specified\n");
 			err = -EINVAL;
 			break;
 		}
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 0536b1b..4ed7706 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -287,8 +289,9 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 #endif
 
 	if (gf2k->id > GF2K_ID_MAX || !gf2k_axes[gf2k->id]) {
-		printk(KERN_WARNING "gf2k.c: Not yet supported joystick on %s. [id: %d type:%s]\n",
-			gameport->phys, gf2k->id, gf2k->id > GF2K_ID_MAX ? "Unknown" : gf2k_names[gf2k->id]);
+		pr_warning("Not yet supported joystick on %s. [id: %d type:%s]\n",
+			   gameport->phys, gf2k->id,
+			   gf2k->id > GF2K_ID_MAX ? "Unknown" : gf2k_names[gf2k->id]);
 		err = -ENODEV;
 		goto fail2;
 	}
diff --git a/drivers/input/joystick/grip_mp.c b/drivers/input/joystick/grip_mp.c
index 2d47baf..4e1d31c 100644
--- a/drivers/input/joystick/grip_mp.c
+++ b/drivers/input/joystick/grip_mp.c
@@ -9,6 +9,8 @@
  *  Copyright (c) 1998-2000 Vojtech Pavlik
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -26,9 +28,9 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 #ifdef GRIP_DEBUG
-#define dbg(format, arg...) printk(KERN_ERR __FILE__ ": " format "\n" , ## arg)
+#define dbg(format, arg...) pr_err(format "\n", ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...) do { if (0) pr_err(format "\n", ##arg); } while (0)
 #endif
 
 #define GRIP_MAX_PORTS	4
@@ -393,8 +395,8 @@ static int get_and_decode_packet(struct grip_mp *grip, int flags)
 	if (!joytype) {
 
 		if (port->registered) {
-			printk(KERN_INFO "grip_mp: removing %s, slot %d\n",
-			       grip_name[port->mode], slot);
+			pr_info("removing %s, slot %d\n",
+				grip_name[port->mode], slot);
 			input_unregister_device(port->dev);
 			port->registered = 0;
 		}
@@ -434,8 +436,9 @@ static int get_and_decode_packet(struct grip_mp *grip, int flags)
 	{
 		static int strange_code = 0;
 		if (strange_code != joytype) {
-			printk(KERN_INFO "Possible non-grip pad/joystick detected.\n");
-			printk(KERN_INFO "Got joy type 0x%x and packet 0x%x.\n", joytype, packet);
+			pr_info("Possible non-grip pad/joystick detected\n");
+			pr_info("Got joy type 0x%x and packet 0x%x\n",
+				joytype, packet);
 			strange_code = joytype;
 		}
 	}
diff --git a/drivers/input/joystick/guillemot.c b/drivers/input/joystick/guillemot.c
index 4058d4b..2056c9a 100644
--- a/drivers/input/joystick/guillemot.c
+++ b/drivers/input/joystick/guillemot.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -211,8 +213,10 @@ static int guillemot_connect(struct gameport *gameport, struct gameport_driver *
 			break;
 
 	if (!guillemot_type[i].name) {
-		printk(KERN_WARNING "guillemot.c: Unknown joystick on %s. [ %02x%02x:%04x, ver %d.%02d ]\n",
-			gameport->phys, data[12], data[13], data[11], data[14], data[15]);
+		pr_warning("Unknown joystick on %s. "
+			   "[ %02x%02x:%04x, ver %d.%02d ]\n",
+			   gameport->phys,
+			   data[12], data[13], data[11], data[14], data[15]);
 		err = -ENODEV;
 		goto fail2;
 	}
@@ -266,7 +270,8 @@ static void guillemot_disconnect(struct gameport *gameport)
 {
 	struct guillemot *guillemot = gameport_get_drvdata(gameport);
 
-	printk(KERN_INFO "guillemot.c: Failed %d reads out of %d on %s\n", guillemot->reads, guillemot->bads, guillemot->phys);
+	pr_info("Failed %d reads out of %d on %s\n",
+		guillemot->reads, guillemot->bads, guillemot->phys);
 	input_unregister_device(guillemot->dev);
 	gameport_close(gameport);
 	kfree(guillemot);
diff --git a/drivers/input/joystick/iforce/iforce-packets.c b/drivers/input/joystick/iforce/iforce-packets.c
index a17b500..08db6ad 100644
--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -25,6 +25,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "iforce.h"
 
 static struct {
@@ -37,10 +39,10 @@ void iforce_dump_packet(char *msg, u16 cmd, unsigned char *data)
 {
 	int i;
 
-	printk(KERN_DEBUG __FILE__ ": %s cmd = %04x, data = ", msg, cmd);
+	printk(KERN_DEBUG pr_fmt("%s cmd = %04x, data ="), msg, cmd);
 	for (i = 0; i < LO(cmd); i++)
-		printk("%02x ", data[i]);
-	printk("\n");
+		pr_cont(" %02x", data[i]);
+	pr_cont("\n");
 }
 
 /*
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 16fb19d..6efcd02 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -240,8 +242,9 @@ static int interact_connect(struct gameport *gameport, struct gameport_driver *d
 			break;
 
 	if (!interact_type[i].length) {
-		printk(KERN_WARNING "interact.c: Unknown joystick on %s. [len %d d0 %08x d1 %08x i2 %08x]\n",
-			gameport->phys, i, data[0], data[1], data[2]);
+		pr_warning("Unknown joystick on %s. "
+			   "[len %d d0 %08x d1 %08x i2 %08x]\n",
+			   gameport->phys, i, data[0], data[1], data[2]);
 		err = -ENODEV;
 		goto fail2;
 	}
diff --git a/drivers/input/joystick/joydump.c b/drivers/input/joystick/joydump.c
index cd894a0..5f0d269 100644
--- a/drivers/input/joystick/joydump.c
+++ b/drivers/input/joystick/joydump.c
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/gameport.h>
 #include <linux/kernel.h>
@@ -56,34 +58,36 @@ static int joydump_connect(struct gameport *gameport, struct gameport_driver *dr
 	unsigned long flags;
 	unsigned char u;
 
-	printk(KERN_INFO "joydump: ,------------------ START ----------------.\n");
-	printk(KERN_INFO "joydump: | Dumping: %30s |\n", gameport->phys);
-	printk(KERN_INFO "joydump: | Speed: %28d kHz |\n", gameport->speed);
+	pr_info(",------------------ START ----------------.\n");
+	pr_info("| Dumping: %30s |\n", gameport->phys);
+	pr_info("| Speed: %28d kHz |\n", gameport->speed);
 
 	if (gameport_open(gameport, drv, GAMEPORT_MODE_RAW)) {
 
-		printk(KERN_INFO "joydump: | Raw mode not available - trying cooked.    |\n");
+		pr_info("| Raw mode not available - trying cooked.    |\n");
 
 		if (gameport_open(gameport, drv, GAMEPORT_MODE_COOKED)) {
 
-			printk(KERN_INFO "joydump: | Cooked not available either. Failing.   |\n");
-			printk(KERN_INFO "joydump: `------------------- END -----------------'\n");
+			pr_info("| Cooked not available either. Failing.   |\n");
+			pr_info("`------------------- END -----------------'\n");
 			return -ENODEV;
 		}
 
 		gameport_cooked_read(gameport, axes, &buttons);
 
 		for (i = 0; i < 4; i++)
-			printk(KERN_INFO "joydump: | Axis %d: %4d.                           |\n", i, axes[i]);
-		printk(KERN_INFO "joydump: | Buttons %02x.                             |\n", buttons);
-		printk(KERN_INFO "joydump: `------------------- END -----------------'\n");
+			pr_info("| Axis %d: %4d.                           |\n",
+				i, axes[i]);
+		pr_info("| Buttons %02x.                             |\n",
+			buttons);
+		pr_info("`------------------- END -----------------'\n");
 	}
 
 	timeout = gameport_time(gameport, 10000); /* 10 ms */
 
 	buf = kmalloc(BUF_SIZE * sizeof(struct joydump), GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_INFO "joydump: no memory for testing\n");
+		pr_info("no memory for testing\n");
 		goto jd_end;
 	}
 	dump = buf;
@@ -123,24 +127,24 @@ static int joydump_connect(struct gameport *gameport, struct gameport_driver *dr
 	dump = buf;
 	prev = dump;
 
-	printk(KERN_INFO "joydump: >------------------ DATA -----------------<\n");
-	printk(KERN_INFO "joydump: | index: %3d delta: %3d us data: ", 0, 0);
+	pr_info(">------------------ DATA -----------------<\n");
+	pr_info("| index: %3d delta: %3d us data: ", 0, 0);
 	for (j = 7; j >= 0; j--)
-		printk("%d", (dump->data >> j) & 1);
-	printk(" |\n");
+		pr_cont("%d", (dump->data >> j) & 1);
+	pr_cont(" |\n");
 	dump++;
 
 	for (i = 1; i < t; i++, dump++, prev++) {
-		printk(KERN_INFO "joydump: | index: %3d delta: %3d us data: ",
+		pr_info("| index: %3d delta: %3d us data: ",
 			i, dump->time - prev->time);
 		for (j = 7; j >= 0; j--)
-			printk("%d", (dump->data >> j) & 1);
-		printk(" |\n");
+			pr_cont("%d", (dump->data >> j) & 1);
+		pr_cont(" |\n");
 	}
 	kfree(buf);
 
 jd_end:
-	printk(KERN_INFO "joydump: `------------------- END -----------------'\n");
+	pr_info("`------------------- END -----------------'\n");
 
 	return 0;
 }
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index b8d8611..46811d3 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -60,9 +62,10 @@ MODULE_LICENSE("GPL");
 #define SW_LENGTH	512	/* Max number of bits in a packet */
 
 #ifdef SW_DEBUG
-#define dbg(format, arg...) printk(KERN_DEBUG __FILE__ ": " format "\n" , ## arg)
+#define dbg(format, arg...) printk(KERN_DEBUG pr_fmt(format), ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...) \
+	do { if (0) printk(KERN_DEBUG pr_fmt(format), ##arg); } while (0)
 #endif
 
 /*
@@ -197,9 +200,10 @@ static int sw_read_packet(struct gameport *gameport, unsigned char *buf, int len
 #ifdef SW_DEBUG_DATA
 	{
 		int j;
-		printk(KERN_DEBUG "sidewinder.c: Read %d triplets. [", i);
-		for (j = 0; j < i; j++) printk("%d", buf[j]);
-		printk("]\n");
+		printk(KERN_DEBUG pr_fmt("Read %d triplets. ["), i);
+		for (j = 0; j < i; j++)
+			pr_cont(" %d", buf[j]);
+		pr_cont(" ]\n");
 	}
 #endif
 
@@ -433,8 +437,9 @@ static int sw_read(struct sw *sw)
 	if (sw->type == SW_ID_3DP && sw->length == 66 && i != 66) {		/* Broken packet, try to fix */
 
 		if (i == 64 && !sw_check(sw_get_bits(buf,0,64,1))) {		/* Last init failed, 1 bit mode */
-			printk(KERN_WARNING "sidewinder.c: Joystick in wrong mode on %s"
-				" - going to reinitialize.\n", sw->gameport->phys);
+			pr_warning("Joystick in wrong mode on %s"
+				   " - going to reinitialize\n",
+				   sw->gameport->phys);
 			sw->fail = SW_FAIL;					/* Reinitialize */
 			i = 128;						/* Bogus value */
 		}
@@ -459,8 +464,9 @@ static int sw_read(struct sw *sw)
 		if (sw->type == SW_ID_3DP && sw->length == 66			/* Many packets OK */
 			&& sw->ok > SW_OK) {
 
-			printk(KERN_INFO "sidewinder.c: No more trouble on %s"
-				" - enabling optimization again.\n", sw->gameport->phys);
+			pr_info("No more trouble on %s"
+				" - enabling optimization again\n",
+				sw->gameport->phys);
 			sw->length = 22;
 		}
 
@@ -472,16 +478,16 @@ static int sw_read(struct sw *sw)
 
 	if (sw->type == SW_ID_3DP && sw->length == 22 && sw->fail > SW_BAD) {	/* Consecutive bad packets */
 
-		printk(KERN_INFO "sidewinder.c: Many bit errors on %s"
-			" - disabling optimization.\n", sw->gameport->phys);
+		pr_info("Many bit errors on %s - disabling optimization\n",
+			sw->gameport->phys);
 		sw->length = 66;
 	}
 
 	if (sw->fail < SW_FAIL)
 		return -1;							/* Not enough, don't reinitialize yet */
 
-	printk(KERN_WARNING "sidewinder.c: Too many bit errors on %s"
-		" - reinitializing joystick.\n", sw->gameport->phys);
+	pr_warning("Too many bit errors on %s - reinitializing joystick\n",
+		   sw->gameport->phys);
 
 	if (!i && sw->type == SW_ID_3DP) {					/* 3D Pro can be in analog mode */
 		mdelay(3 * SW_TIMEOUT);
@@ -530,10 +536,10 @@ static void sw_print_packet(char *name, int length, unsigned char *buf, char bit
 {
 	int i;
 
-	printk(KERN_INFO "sidewinder.c: %s packet, %d bits. [", name, length);
+	pr_info("%s packet, %d bits. [", name, length);
 	for (i = (((length + 3) >> 2) - 1); i >= 0; i--)
-		printk("%x", (int)sw_get_bits(buf, i << 2, 4, bits));
-	printk("]\n");
+		pr_cont("%x", (int)sw_get_bits(buf, i << 2, 4, bits));
+	pr_cont("]\n");
 }
 
 /*
@@ -613,19 +619,19 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 	if (err)
 		goto fail1;
 
-	dbg("Init 0: Opened %s, io %#x, speed %d",
+	dbg("Init 0: Opened %s, io %#x, speed %d\n",
 		gameport->phys, gameport->io, gameport->speed);
 
 	i = sw_read_packet(gameport, buf, SW_LENGTH, 0);		/* Read normal packet */
 	msleep(SW_TIMEOUT);
-	dbg("Init 1: Mode %d. Length %d.", m , i);
+	dbg("Init 1: Mode %d. Length %d\n", m , i);
 
 	if (!i) {							/* No data. 3d Pro analog mode? */
 		sw_init_digital(gameport);				/* Switch to digital */
 		msleep(SW_TIMEOUT);
 		i = sw_read_packet(gameport, buf, SW_LENGTH, 0);	/* Retry reading packet */
 		msleep(SW_TIMEOUT);
-		dbg("Init 1b: Length %d.", i);
+		dbg("Init 1b: Length %d\n", i);
 		if (!i) {						/* No data -> FAIL */
 			err = -ENODEV;
 			goto fail2;
@@ -634,20 +640,20 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 	j = sw_read_packet(gameport, idbuf, SW_LENGTH, i);		/* Read ID. This initializes the stick */
 	m |= sw_guess_mode(idbuf, j);					/* ID packet should carry mode info [3DP] */
-	dbg("Init 2: Mode %d. ID Length %d.", m, j);
+	dbg("Init 2: Mode %d. ID Length %d\n", m, j);
 
 	if (j <= 0) {							/* Read ID failed. Happens in 1-bit mode on PP */
 		msleep(SW_TIMEOUT);
 		i = sw_read_packet(gameport, buf, SW_LENGTH, 0);	/* Retry reading packet */
 		m |= sw_guess_mode(buf, i);
-		dbg("Init 2b: Mode %d. Length %d.", m, i);
+		dbg("Init 2b: Mode %d. Length %d\n", m, i);
 		if (!i) {
 			err = -ENODEV;
 			goto fail2;
 		}
 		msleep(SW_TIMEOUT);
 		j = sw_read_packet(gameport, idbuf, SW_LENGTH, i);	/* Retry reading ID */
-		dbg("Init 2c: ID Length %d.", j);
+		dbg("Init 2c: ID Length %d\n", j);
 	}
 
 	sw->type = -1;
@@ -658,7 +664,7 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 		k--;
 		msleep(SW_TIMEOUT);
 		i = sw_read_packet(gameport, buf, SW_LENGTH, 0);	/* Read data packet */
-		dbg("Init 3: Mode %d. Length %d. Last %d. Tries %d.", m, i, l, k);
+		dbg("Init 3: Mode %d. Length %d. Last %d. Tries %d\n", m, i, l, k);
 
 		if (i > l) {						/* Longer? As we can only lose bits, it makes */
 									/* no sense to try detection for a packet shorter */
@@ -669,7 +675,7 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 			sw->length = i;
 			sw->bits = m;
 
-			dbg("Init 3a: Case %d.\n", i * m);
+			dbg("Init 3a: Case %d\n", i * m);
 
 			switch (i * m) {
 				case 60:
@@ -712,8 +718,8 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 	} while (k && sw->type == -1);
 
 	if (sw->type == -1) {
-		printk(KERN_WARNING "sidewinder.c: unknown joystick device detected "
-			"on %s, contact <vojtech@ucw.cz>\n", gameport->phys);
+		pr_warning("unknown joystick device detected on %s, "
+			   "contact <vojtech@ucw.cz>\n", gameport->phys);
 		sw_print_packet("ID", j * 3, idbuf, 3);
 		sw_print_packet("Data", i * m, buf, m);
 		err = -ENODEV;
diff --git a/drivers/input/joystick/spaceball.c b/drivers/input/joystick/spaceball.c
index 0cd9b29..2690e2b 100644
--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -30,6 +30,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -128,12 +130,12 @@ static void spaceball_process_packet(struct spaceball* spaceball)
 
 		case 'E':					/* Device error */
 			spaceball->data[spaceball->idx - 1] = 0;
-			printk(KERN_ERR "spaceball: Device error. [%s]\n", spaceball->data + 1);
+			pr_err("Device error. [%s]\n", spaceball->data + 1);
 			break;
 
 		case '?':					/* Bad command packet */
 			spaceball->data[spaceball->idx - 1] = 0;
-			printk(KERN_ERR "spaceball: Bad command. [%s]\n", spaceball->data + 1);
+			pr_err("Bad command. [%s]\n", spaceball->data + 1);
 			break;
 	}
 
diff --git a/drivers/input/joystick/spaceorb.c b/drivers/input/joystick/spaceorb.c
index a694bf8..55253ac 100644
--- a/drivers/input/joystick/spaceorb.c
+++ b/drivers/input/joystick/spaceorb.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -89,8 +91,8 @@ static void spaceorb_process_packet(struct spaceorb *spaceorb)
 		case 'R':				/* Reset packet */
 			spaceorb->data[spaceorb->idx - 1] = 0;
 			for (i = 1; i < spaceorb->idx && spaceorb->data[i] == ' '; i++);
-			printk(KERN_INFO "input: %s [%s] is %s\n",
-				 dev->name, spaceorb->data + i, spaceorb->phys);
+			pr_info("%s [%s] is %s\n",
+				dev->name, spaceorb->data + i, spaceorb->phys);
 			break;
 
 		case 'D':				/* Ball + button data */
@@ -117,9 +119,12 @@ static void spaceorb_process_packet(struct spaceorb *spaceorb)
 
 		case 'E':				/* Error packet */
 			if (spaceorb->idx != 4) return;
-			printk(KERN_ERR "spaceorb: Device error. [ ");
-			for (i = 0; i < 7; i++) if (data[1] & (1 << i)) printk("%s ", spaceorb_errors[i]);
-			printk("]\n");
+			pr_err("Device error. [");
+			for (i = 0; i < 7; i++) {
+				if (data[1] & (1 << i))
+					pr_cont(" %s", spaceorb_errors[i]);
+			}
+			pr_cont(" ]\n");
 			break;
 	}
 
diff --git a/drivers/input/joystick/turbografx.c b/drivers/input/joystick/turbografx.c
index d53b9e9..a592eaa 100644
--- a/drivers/input/joystick/turbografx.c
+++ b/drivers/input/joystick/turbografx.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/parport.h>
 #include <linux/input.h>
@@ -167,21 +169,21 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 
 	pp = parport_find_number(parport);
 	if (!pp) {
-		printk(KERN_ERR "turbografx.c: no such parport\n");
+		pr_err("no such parport\n");
 		err = -EINVAL;
 		goto err_out;
 	}
 
 	pd = parport_register_device(pp, "turbografx", NULL, NULL, NULL, PARPORT_DEV_EXCL, NULL);
 	if (!pd) {
-		printk(KERN_ERR "turbografx.c: parport busy already - lp.o loaded?\n");
+		pr_err("parport busy already - lp.o loaded?\n");
 		err = -EBUSY;
 		goto err_put_pp;
 	}
 
 	tgfx = kzalloc(sizeof(struct tgfx), GFP_KERNEL);
 	if (!tgfx) {
-		printk(KERN_ERR "turbografx.c: Not enough memory\n");
+		pr_err("Not enough memory\n");
 		err = -ENOMEM;
 		goto err_unreg_pardev;
 	}
@@ -197,14 +199,14 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 			continue;
 
 		if (n_buttons[i] > 6) {
-			printk(KERN_ERR "turbografx.c: Invalid number of buttons %d\n", n_buttons[i]);
+			pr_err("Invalid number of buttons %d\n", n_buttons[i]);
 			err = -EINVAL;
 			goto err_unreg_devs;
 		}
 
 		tgfx->dev[i] = input_dev = input_allocate_device();
 		if (!input_dev) {
-			printk(KERN_ERR "turbografx.c: Not enough memory for input device\n");
+			pr_err("Not enough memory for input device\n");
 			err = -ENOMEM;
 			goto err_unreg_devs;
 		}
@@ -240,7 +242,7 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 	}
 
         if (!tgfx->sticks) {
-		printk(KERN_ERR "turbografx.c: No valid devices specified\n");
+		pr_err("No valid devices specified\n");
 		err = -EINVAL;
 		goto err_free_tgfx;
         }
@@ -285,7 +287,7 @@ static int __init tgfx_init(void)
 			continue;
 
 		if (tgfx_cfg[i].nargs < 2) {
-			printk(KERN_ERR "turbografx.c: at least one joystick must be specified\n");
+			pr_err("at least one joystick must be specified\n");
 			err = -EINVAL;
 			break;
 		}
diff --git a/drivers/input/joystick/walkera0701.c b/drivers/input/joystick/walkera0701.c
index 4dfa1ee..9e69249 100644
--- a/drivers/input/joystick/walkera0701.c
+++ b/drivers/input/joystick/walkera0701.c
@@ -12,6 +12,8 @@
  * the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* #define WK0701_DEBUG */
 
 #define RESERVE 20000
@@ -108,7 +110,7 @@ static inline void walkera0701_parse_frame(struct walkera_dev *w)
 		magic = (w->buf[21] << 4) | w->buf[22];
 		magic_bit = (w->buf[24] & 8) >> 3;
 		printk(KERN_DEBUG
-		       "walkera0701: %4d %4d %4d %4d  %4d %4d %4d %4d (magic %2x %d)\n",
+		       pr_fmt("%4d %4d %4d %4d  %4d %4d %4d %4d (magic %2x %d)\n"),
 		       val1, val2, val3, val4, val5, val6, val7, val8, magic,
 		       magic_bit);
 	}
@@ -207,7 +209,7 @@ static int walkera0701_connect(struct walkera_dev *w, int parport)
 		return -ENODEV;
 
 	if (w->parport->irq == -1) {
-		printk(KERN_ERR "walkera0701: parport without interrupt\n");
+		pr_err("parport without interrupt\n");
 		goto init_err;
 	}
 
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 269a846..17a0314 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -73,6 +73,8 @@
  * Later changes can be tracked in SCM.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1001,7 +1003,7 @@ static int __init usb_xpad_init(void)
 {
 	int result = usb_register(&xpad_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+		pr_info(DRIVER_DESC "\n");
 	return result;
 }
 
-- 
1.7.2.19.g9a302

