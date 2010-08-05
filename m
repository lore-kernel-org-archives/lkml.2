Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab0HEHbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:31:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2274 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759882Ab0HEH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:56 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/9] drivers/input/mouse: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:46 -0700
Message-Id: <1ad2e62949b4bf172b04f7f9da74d4a8faf79eff.1280992119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ps2 related drivers use #define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
all others use #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Add argument checking to dbg macro
Convert bare printks to pr_cont

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/mouse/alps.c         |   12 ++++---
 drivers/input/mouse/appletouch.c   |   64 +++++++++++++++++------------------
 drivers/input/mouse/bcm5974.c      |   48 +++++++++++++--------------
 drivers/input/mouse/elantech.c     |    4 +-
 drivers/input/mouse/inport.c       |    8 +++--
 drivers/input/mouse/lifebook.c     |    5 ++-
 drivers/input/mouse/logibm.c       |   10 +++--
 drivers/input/mouse/logips2pp.c    |   13 ++++---
 drivers/input/mouse/pc110pad.c     |   10 +++--
 drivers/input/mouse/psmouse-base.c |   52 +++++++++++++++--------------
 drivers/input/mouse/rpcmouse.c     |    4 ++-
 drivers/input/mouse/sentelic.c     |   13 ++++---
 drivers/input/mouse/sermouse.c     |    6 ++-
 drivers/input/mouse/synaptics.c    |   30 +++++++++--------
 drivers/input/mouse/trackpoint.c   |   10 +++---
 drivers/input/mouse/vsxxxaa.c      |   44 ++++++++++++-------------
 16 files changed, 174 insertions(+), 159 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 99d5876..bc2bde3 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -15,6 +15,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
@@ -25,9 +27,9 @@
 
 #undef DEBUG
 #ifdef DEBUG
-#define dbg(format, arg...) printk(KERN_INFO "alps.c: " format "\n", ## arg)
+#define dbg(format, arg...) pr_info(format "\n", ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...) do { if (0) pr_info(format "\n", ##arg); } while (0)
 #endif
 
 #define ALPS_OLDPROTO		0x01	/* old style input */
@@ -605,12 +607,12 @@ static int alps_hw_init(struct psmouse *psmouse)
 	}
 
 	if (alps_tap_mode(psmouse, true)) {
-		printk(KERN_WARNING "alps.c: Failed to enable hardware tapping\n");
+		pr_warning("Failed to enable hardware tapping\n");
 		return -1;
 	}
 
 	if (alps_absolute_mode(psmouse)) {
-		printk(KERN_ERR "alps.c: Failed to enable absolute mode\n");
+		pr_err("Failed to enable absolute mode\n");
 		return -1;
 	}
 
@@ -621,7 +623,7 @@ static int alps_hw_init(struct psmouse *psmouse)
 
 	/* ALPS needs stream mode, otherwise it won't report any data */
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM)) {
-		printk(KERN_ERR "alps.c: Failed to enable stream mode\n");
+		pr_err("Failed to enable stream mode\n");
 		return -1;
 	}
 
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index 05edd75..740cb8c 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -28,6 +28,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -212,20 +214,22 @@ struct atp {
 	struct work_struct	work;
 };
 
-#define dbg_dump(msg, tab) \
+#define dbg_dump(msg, tab)						\
+do {									\
 	if (debug > 1) {						\
 		int __i;						\
-		printk(KERN_DEBUG "appletouch: %s", msg);		\
+		printk(KERN_DEBUG pr_fmt("%s"), msg);			\
 		for (__i = 0; __i < ATP_XSENSORS + ATP_YSENSORS; __i++)	\
-			printk(" %02x", tab[__i]);			\
-		printk("\n");						\
-	}
+			pr_cont(" %02x", tab[__i]);			\
+		pr_cont("\n");						\
+	}								\
+} while (0)
 
-#define dprintk(format, a...)						\
-	do {								\
-		if (debug)						\
-			printk(KERN_DEBUG format, ##a);			\
-	} while (0)
+#define dprintk(level, format, a...)					\
+do {									\
+	if (debug > level)						\
+		printk(KERN_DEBUG pr_fmt(format), ##a);			\
+} while (0)
 
 MODULE_AUTHOR("Johannes Berg");
 MODULE_AUTHOR("Stelian Pop");
@@ -273,11 +277,11 @@ static int atp_geyser_init(struct usb_device *udev)
 			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		dprintk("atp_geyser_init: read error\n");
+		dprintk(0, "%s(): read error\n", __func__);
 		for (i = 0; i < 8; i++)
-			dprintk("appletouch[%d]: %d\n", i, data[i]);
+			dprintk(0, "[%d]: %d\n", i, data[i]);
 
-		err("Failed to read mode from device.");
+		err("Failed to read mode from device");
 		ret = -EIO;
 		goto out_free;
 	}
@@ -292,9 +296,9 @@ static int atp_geyser_init(struct usb_device *udev)
 			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		dprintk("atp_geyser_init: write error\n");
+		dprintk(0, "%s(): write error\n", __func__);
 		for (i = 0; i < 8; i++)
-			dprintk("appletouch[%d]: %d\n", i, data[i]);
+			dprintk(0, "[%d]: %d\n", i, data[i]);
 
 		err("Failed to request geyser raw mode");
 		ret = -EIO;
@@ -316,7 +320,7 @@ static void atp_reinit(struct work_struct *work)
 	struct usb_device *udev = dev->udev;
 	int retval;
 
-	dprintk("appletouch: putting appletouch to sleep (reinit)\n");
+	dprintk(0, "putting appletouch to sleep (reinit)\n");
 	atp_geyser_init(udev);
 
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
@@ -407,9 +411,8 @@ static int atp_status_check(struct urb *urb)
 		break;
 	case -EOVERFLOW:
 		if (!dev->overflow_warned) {
-			printk(KERN_WARNING "appletouch: OVERFLOW with data "
-				"length %d, actual length is %d\n",
-				dev->info->datalen, dev->urb->actual_length);
+			pr_warning("OVERFLOW with data length %d, actual length is %d\n",
+				   dev->info->datalen, dev->urb->actual_length);
 			dev->overflow_warned = true;
 		}
 	case -ECONNRESET:
@@ -428,8 +431,7 @@ static int atp_status_check(struct urb *urb)
 
 	/* drop incomplete datasets */
 	if (dev->urb->actual_length != dev->info->datalen) {
-		dprintk("appletouch: incomplete data package"
-			" (first byte: %d, length: %d).\n",
+		dprintk(0, "incomplete data package (first byte: %d, length: %d)\n",
 			dev->data[0], dev->urb->actual_length);
 		return ATP_URB_STATUS_ERROR;
 	}
@@ -445,7 +447,7 @@ static void atp_detect_size(struct atp *dev)
 	for (i = dev->info->xsensors; i < ATP_XSENSORS; i++) {
 		if (dev->xy_cur[i]) {
 
-			printk(KERN_INFO "appletouch: 17\" model detected.\n");
+			pr_info("17\" model detected.\n");
 
 			input_set_abs_params(dev->input, ABS_X, 0,
 					     (dev->info->xsensors_17 - 1) *
@@ -556,10 +558,8 @@ static void atp_complete_geyser_1_2(struct urb *urb)
 			dev->x_old = x;
 			dev->y_old = y;
 
-			if (debug > 1)
-				printk(KERN_DEBUG "appletouch: "
-					"X: %3d Y: %3d Xz: %3d Yz: %3d\n",
-					x, y, x_z, y_z);
+			dprintk(1, "X: %3d Y: %3d Xz: %3d Yz: %3d\n",
+				x, y, x_z, y_z);
 
 			input_report_key(dev->input, BTN_TOUCH, 1);
 			input_report_abs(dev->input, ABS_X, x);
@@ -630,7 +630,7 @@ static void atp_complete_geyser_3_4(struct urb *urb)
 	/* Just update the base values (i.e. touchpad in untouched state) */
 	if (dev->data[dev->info->datalen - 1] & ATP_STATUS_BASE_UPDATE) {
 
-		dprintk(KERN_DEBUG "appletouch: updated base values\n");
+		dprintk(0, "updated base values\n");
 
 		memcpy(dev->xy_old, dev->xy_cur, sizeof(dev->xy_old));
 		goto exit;
@@ -667,10 +667,8 @@ static void atp_complete_geyser_3_4(struct urb *urb)
 			dev->x_old = x;
 			dev->y_old = y;
 
-			if (debug > 1)
-				printk(KERN_DEBUG "appletouch: X: %3d Y: %3d "
-				       "Xz: %3d Yz: %3d\n",
-				       x, y, x_z, y_z);
+			dprintk(1, "X: %3d Y: %3d Xz: %3d Yz: %3d\n",
+				x, y, x_z, y_z);
 
 			input_report_key(dev->input, BTN_TOUCH, 1);
 			input_report_abs(dev->input, ABS_X, x);
@@ -755,7 +753,7 @@ static int atp_handle_geyser(struct atp *dev)
 		if (atp_geyser_init(udev))
 			return -EIO;
 
-		printk(KERN_INFO "appletouch: Geyser mode initialized.\n");
+		pr_info("Geyser mode initialized\n");
 	}
 
 	return 0;
@@ -886,7 +884,7 @@ static void atp_disconnect(struct usb_interface *iface)
 		usb_free_urb(dev->urb);
 		kfree(dev);
 	}
-	printk(KERN_INFO "input: appletouch disconnected\n");
+	pr_info("appletouch disconnected\n");
 }
 
 static int atp_recover(struct atp *dev)
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ea67c49..8b201dc 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -32,6 +32,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -89,8 +91,8 @@ MODULE_AUTHOR("Henrik Rydberg");
 MODULE_DESCRIPTION("Apple USB BCM5974 multitouch driver");
 MODULE_LICENSE("GPL");
 
-#define dprintk(level, format, a...)\
-	{ if (debug >= level) printk(KERN_DEBUG format, ##a); }
+#define dprintk(level, format, a...)				\
+do { if (debug >= level) printk(KERN_DEBUG pr_fmt(format), ##a); } while (0)
 
 static int debug = 1;
 module_param(debug, int, 0644);
@@ -322,8 +324,7 @@ static int report_bt_state(struct bcm5974 *dev, int size)
 	if (size != sizeof(struct bt_data))
 		return -EIO;
 
-	dprintk(7,
-		"bcm5974: button data: %x %x %x %x\n",
+	dprintk(7, "button data: %x %x %x %x\n",
 		dev->bt_data->unknown1, dev->bt_data->button,
 		dev->bt_data->rel_x, dev->bt_data->rel_y);
 
@@ -378,9 +379,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		raw_x = raw2int(f->abs_x);
 		raw_y = raw2int(f->abs_y);
 
-		dprintk(9,
-			"bcm5974: "
-			"raw: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
+		dprintk(9, "raw: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
 			raw_p, raw_w, raw_x, raw_y, raw_n);
 
 		ptest = int2bound(&c->p, raw_p);
@@ -426,9 +425,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		input_report_abs(input, ABS_X, abs_x);
 		input_report_abs(input, ABS_Y, abs_y);
 
-		dprintk(8,
-			"bcm5974: abs: p: %+05d w: %+05d x: %+05d y: %+05d "
-			"nmin: %d nmax: %d n: %d ibt: %d\n", abs_p, abs_w,
+		dprintk(8, "abs: p: %+05d w: %+05d x: %+05d y: %+05d "
+			"nmin: %d nmax: %d n: %d ibt: %d\n",
+			abs_p, abs_w,
 			abs_x, abs_y, nmin, nmax, dev->fingers, ibt);
 
 	}
@@ -456,7 +455,7 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 	int retval = 0, size;
 
 	if (!data) {
-		err("bcm5974: out of memory");
+		pr_err("out of memory\n");
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -469,7 +468,7 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 			BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		err("bcm5974: could not read from device");
+		pr_err("could not read from device\n");
 		retval = -EIO;
 		goto out;
 	}
@@ -487,13 +486,12 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 			BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		err("bcm5974: could not write to device");
+		pr_err("could not write to device\n");
 		retval = -EIO;
 		goto out;
 	}
 
-	dprintk(2, "bcm5974: switched to %s mode.\n",
-		on ? "wellspring" : "normal");
+	dprintk(2, "switched to %s mode\n", on ? "wellspring" : "normal");
 
  out:
 	kfree(data);
@@ -512,21 +510,21 @@ static void bcm5974_irq_button(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		dbg("bcm5974: button urb shutting down: %d", urb->status);
+		pr_debug("button urb shutting down: %d\n", urb->status);
 		return;
 	default:
-		dbg("bcm5974: button urb status: %d", urb->status);
+		pr_debug("button urb status: %d\n", urb->status);
 		goto exit;
 	}
 
 	if (report_bt_state(dev, dev->bt_urb->actual_length))
-		dprintk(1, "bcm5974: bad button package, length: %d\n",
+		dprintk(1, "bad button package, length: %d\n",
 			dev->bt_urb->actual_length);
 
 exit:
 	error = usb_submit_urb(dev->bt_urb, GFP_ATOMIC);
 	if (error)
-		err("bcm5974: button urb failed: %d", error);
+		pr_err("button urb failed: %d\n", error);
 }
 
 static void bcm5974_irq_trackpad(struct urb *urb)
@@ -541,10 +539,10 @@ static void bcm5974_irq_trackpad(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		dbg("bcm5974: trackpad urb shutting down: %d", urb->status);
+		pr_debug("trackpad urb shutting down: %d\n", urb->status);
 		return;
 	default:
-		dbg("bcm5974: trackpad urb status: %d", urb->status);
+		pr_debug("trackpad urb status: %d\n", urb->status);
 		goto exit;
 	}
 
@@ -553,13 +551,13 @@ static void bcm5974_irq_trackpad(struct urb *urb)
 		goto exit;
 
 	if (report_tp_state(dev, dev->tp_urb->actual_length))
-		dprintk(1, "bcm5974: bad trackpad package, length: %d\n",
+		dprintk(1, "bad trackpad package, length: %d\n",
 			dev->tp_urb->actual_length);
 
 exit:
 	error = usb_submit_urb(dev->tp_urb, GFP_ATOMIC);
 	if (error)
-		err("bcm5974: trackpad urb failed: %d", error);
+		pr_err("trackpad urb failed: %d\n", error);
 }
 
 /*
@@ -586,7 +584,7 @@ static int bcm5974_start_traffic(struct bcm5974 *dev)
 
 	error = bcm5974_wellspring_mode(dev, true);
 	if (error) {
-		dprintk(1, "bcm5974: mode switch failed\n");
+		dprintk(1, "mode switch failed\n");
 		goto err_out;
 	}
 
@@ -705,7 +703,7 @@ static int bcm5974_probe(struct usb_interface *iface,
 	dev = kzalloc(sizeof(struct bcm5974), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!dev || !input_dev) {
-		err("bcm5974: out of memory");
+		pr_err("out of memory\n");
 		goto err_free_devs;
 	}
 
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index b18862b..a6c41e0 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -171,8 +171,8 @@ static void elantech_packet_dump(unsigned char *packet, int size)
 
 	printk(KERN_DEBUG pr_fmt("PS/2 packet ["));
 	for (i = 0; i < size; i++)
-		printk("%s0x%02x ", (i) ? ", " : " ", packet[i]);
-	printk("]\n");
+		pr_cont(" 0x%02x", packet[i]);
+	pr_cont(" ]\n");
 }
 
 /*
diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 3827a22..9a522c1 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -32,6 +32,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
@@ -133,7 +135,7 @@ static int __init inport_init(void)
 	int err;
 
 	if (!request_region(INPORT_BASE, INPORT_EXTENT, "inport")) {
-		printk(KERN_ERR "inport.c: Can't allocate ports at %#x\n", INPORT_BASE);
+		pr_err("Can't allocate ports at %#x\n", INPORT_BASE);
 		return -EBUSY;
 	}
 
@@ -141,14 +143,14 @@ static int __init inport_init(void)
 	b = inb(INPORT_SIGNATURE_PORT);
 	c = inb(INPORT_SIGNATURE_PORT);
 	if (a == b || a != c) {
-		printk(KERN_INFO "inport.c: Didn't find InPort mouse at %#x\n", INPORT_BASE);
+		pr_info("Didn't find InPort mouse at %#x\n", INPORT_BASE);
 		err = -ENODEV;
 		goto err_release_region;
 	}
 
 	inport_dev = input_allocate_device();
 	if (!inport_dev) {
-		printk(KERN_ERR "inport.c: Not enough memory for input device\n");
+		pr_err("Not enough memory for input device\n");
 		err = -ENOMEM;
 		goto err_release_region;
 	}
diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index c31ad11..20145dd 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -12,6 +12,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
@@ -169,8 +171,7 @@ static psmouse_ret_t lifebook_process_byte(struct psmouse *psmouse)
 
 	if (relative_packet) {
 		if (!dev2)
-			printk(KERN_WARNING "lifebook.c: got relative packet "
-				"but no relative device set up\n");
+			pr_warning("got relative packet but no relative device set up\n");
 	} else {
 		if (lifebook_use_6byte_proto) {
 			input_report_abs(dev1, ABS_X,
diff --git a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
index e241311..988667f 100644
--- a/drivers/input/mouse/logibm.c
+++ b/drivers/input/mouse/logibm.c
@@ -33,6 +33,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
@@ -104,7 +106,7 @@ static irqreturn_t logibm_interrupt(int irq, void *dev_id)
 static int logibm_open(struct input_dev *dev)
 {
 	if (request_irq(logibm_irq, logibm_interrupt, 0, "logibm", NULL)) {
-		printk(KERN_ERR "logibm.c: Can't allocate irq %d\n", logibm_irq);
+		pr_err("Can't allocate irq %d\n", logibm_irq);
 		return -EBUSY;
 	}
 	outb(LOGIBM_ENABLE_IRQ, LOGIBM_CONTROL_PORT);
@@ -122,7 +124,7 @@ static int __init logibm_init(void)
 	int err;
 
 	if (!request_region(LOGIBM_BASE, LOGIBM_EXTENT, "logibm")) {
-		printk(KERN_ERR "logibm.c: Can't allocate ports at %#x\n", LOGIBM_BASE);
+		pr_err("Can't allocate ports at %#x\n", LOGIBM_BASE);
 		return -EBUSY;
 	}
 
@@ -131,7 +133,7 @@ static int __init logibm_init(void)
 	udelay(100);
 
 	if (inb(LOGIBM_SIGNATURE_PORT) != LOGIBM_SIGNATURE_BYTE) {
-		printk(KERN_INFO "logibm.c: Didn't find Logitech busmouse at %#x\n", LOGIBM_BASE);
+		pr_info("Didn't find Logitech busmouse at %#x\n", LOGIBM_BASE);
 		err = -ENODEV;
 		goto err_release_region;
 	}
@@ -141,7 +143,7 @@ static int __init logibm_init(void)
 
 	logibm_dev = input_allocate_device();
 	if (!logibm_dev) {
-		printk(KERN_ERR "logibm.c: Not enough memory for input device\n");
+		pr_err("Not enough memory for input device\n");
 		err = -ENOMEM;
 		goto err_release_region;
 	}
diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index c9983ae..c8c5bbd 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -9,6 +9,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
@@ -84,8 +86,8 @@ static psmouse_ret_t ps2pp_process_byte(struct psmouse *psmouse)
 
 #ifdef DEBUG
 		default:
-			printk(KERN_WARNING "psmouse.c: Received PS2++ packet #%x, but don't know how to handle.\n",
-				(packet[1] >> 4) | (packet[0] & 0x30));
+			pr_warning("Received PS2++ packet #%x, but don't know how to handle\n",
+				   (packet[1] >> 4) | (packet[0] & 0x30));
 #endif
 		}
 	} else {
@@ -382,7 +384,7 @@ int ps2pp_init(struct psmouse *psmouse, bool set_properties)
 		}
 
 	} else {
-		printk(KERN_WARNING "logips2pp: Detected unknown logitech mouse model %d\n", model);
+		pr_warning("Detected unknown logitech mouse model %d\n", model);
 	}
 
 	if (set_properties) {
@@ -400,9 +402,8 @@ int ps2pp_init(struct psmouse *psmouse, bool set_properties)
 				error = device_create_file(&psmouse->ps2dev.serio->dev,
 							   &psmouse_attr_smartscroll.dattr);
 				if (error) {
-					printk(KERN_ERR
-						"logips2pp.c: failed to create smartscroll "
-						"sysfs attribute, error: %d\n", error);
+					pr_err("failed to create smartscroll sysfs attribute, error: %d\n",
+					       error);
 					return -1;
 				}
 			}
diff --git a/drivers/input/mouse/pc110pad.c b/drivers/input/mouse/pc110pad.c
index 7b02b65..37c1854 100644
--- a/drivers/input/mouse/pc110pad.c
+++ b/drivers/input/mouse/pc110pad.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -114,22 +116,22 @@ static int __init pc110pad_init(void)
 		return -ENODEV;
 
 	if (!request_region(pc110pad_io, 4, "pc110pad")) {
-		printk(KERN_ERR "pc110pad: I/O area %#x-%#x in use.\n",
-				pc110pad_io, pc110pad_io + 4);
+		pr_err("I/O area %#x-%#x in use\n",
+		       pc110pad_io, pc110pad_io + 4);
 		return -EBUSY;
 	}
 
 	outb(PC110PAD_OFF, pc110pad_io + 2);
 
 	if (request_irq(pc110pad_irq, pc110pad_interrupt, 0, "pc110pad", NULL)) {
-		printk(KERN_ERR "pc110pad: Unable to get irq %d.\n", pc110pad_irq);
+		pr_err("Unable to get irq %d\n", pc110pad_irq);
 		err = -EBUSY;
 		goto err_release_region;
 	}
 
 	pc110pad_dev = input_allocate_device();
 	if (!pc110pad_dev) {
-		printk(KERN_ERR "pc110pad: Not enough memory.\n");
+		pr_err("Not enough memory\n");
 		err = -ENOMEM;
 		goto err_free_irq;
 	}
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 73a7af2..ed15ab2 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -11,6 +11,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -251,11 +253,12 @@ static int psmouse_handle_byte(struct psmouse *psmouse)
 	switch (rc) {
 	case PSMOUSE_BAD_DATA:
 		if (psmouse->state == PSMOUSE_ACTIVATED) {
-			printk(KERN_WARNING "psmouse.c: %s at %s lost sync at byte %d\n",
-				psmouse->name, psmouse->phys, psmouse->pktcnt);
+			pr_warning("%s at %s lost sync at byte %d\n",
+				   psmouse->name, psmouse->phys,
+				   psmouse->pktcnt);
 			if (++psmouse->out_of_sync_cnt == psmouse->resetafter) {
 				__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
-				printk(KERN_NOTICE "psmouse.c: issuing reconnect request\n");
+				pr_notice("issuing reconnect request\n");
 				serio_reconnect(psmouse->ps2dev.serio);
 				return -1;
 			}
@@ -267,8 +270,8 @@ static int psmouse_handle_byte(struct psmouse *psmouse)
 		psmouse->pktcnt = 0;
 		if (psmouse->out_of_sync_cnt) {
 			psmouse->out_of_sync_cnt = 0;
-			printk(KERN_NOTICE "psmouse.c: %s at %s - driver resynched.\n",
-				psmouse->name, psmouse->phys);
+			pr_notice("%s at %s - driver resynched\n",
+				  psmouse->name, psmouse->phys);
 		}
 		break;
 
@@ -295,9 +298,9 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 		     ((flags & SERIO_PARITY) && !psmouse->ignore_parity))) {
 
 		if (psmouse->state == PSMOUSE_ACTIVATED)
-			printk(KERN_WARNING "psmouse.c: bad data from KBC -%s%s\n",
-				flags & SERIO_TIMEOUT ? " timeout" : "",
-				flags & SERIO_PARITY ? " bad parity" : "");
+			pr_warning("bad data from KBC -%s%s\n",
+				   flags & SERIO_TIMEOUT ? " timeout" : "",
+				   flags & SERIO_PARITY ? " bad parity" : "");
 		ps2_cmd_aborted(&psmouse->ps2dev);
 		goto out;
 	}
@@ -315,8 +318,8 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 
 	if (psmouse->state == PSMOUSE_ACTIVATED &&
 	    psmouse->pktcnt && time_after(jiffies, psmouse->last + HZ/2)) {
-		printk(KERN_INFO "psmouse.c: %s at %s lost synchronization, throwing %d bytes away.\n",
-		       psmouse->name, psmouse->phys, psmouse->pktcnt);
+		pr_info("%s at %s lost synchronization, throwing %d bytes away\n",
+			psmouse->name, psmouse->phys, psmouse->pktcnt);
 		psmouse->badbyte = psmouse->packet[0];
 		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
 		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
@@ -943,7 +946,8 @@ static int psmouse_probe(struct psmouse *psmouse)
  */
 
 	if (ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_DIS))
-		printk(KERN_WARNING "psmouse.c: Failed to reset mouse on %s\n", ps2dev->serio->phys);
+		pr_warning("failed to reset mouse on %s\n",
+			   ps2dev->serio->phys);
 
 	return 0;
 }
@@ -1005,8 +1009,8 @@ static void psmouse_initialize(struct psmouse *psmouse)
 static void psmouse_activate(struct psmouse *psmouse)
 {
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE))
-		printk(KERN_WARNING "psmouse.c: Failed to enable mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to enable mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 
 	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
 }
@@ -1020,8 +1024,8 @@ static void psmouse_activate(struct psmouse *psmouse)
 static void psmouse_deactivate(struct psmouse *psmouse)
 {
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE))
-		printk(KERN_WARNING "psmouse.c: Failed to deactivate mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to deactivate mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 
 	psmouse_set_state(psmouse, PSMOUSE_CMD_MODE);
 }
@@ -1115,14 +1119,14 @@ static void psmouse_resync(struct work_struct *work)
 	}
 
 	if (!enabled) {
-		printk(KERN_WARNING "psmouse.c: failed to re-enable mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to re-enable mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 		failed = true;
 	}
 
 	if (failed) {
 		psmouse_set_state(psmouse, PSMOUSE_IGNORE);
-		printk(KERN_INFO "psmouse.c: resync failed, issuing reconnect request\n");
+		pr_info("resync failed, issuing reconnect request\n");
 		serio_reconnect(serio);
 	} else
 		psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
@@ -1155,8 +1159,8 @@ static void psmouse_cleanup(struct serio *serio)
 	 * Disable stream mode so cleanup routine can proceed undisturbed.
 	 */
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE))
-		printk(KERN_WARNING "psmouse.c: Failed to disable mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to disable mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 
 	if (psmouse->cleanup)
 		psmouse->cleanup(psmouse);
@@ -1400,7 +1404,7 @@ static int psmouse_reconnect(struct serio *serio)
 	int rc = -1;
 
 	if (!drv || !psmouse) {
-		printk(KERN_DEBUG "psmouse: reconnect request, but serio is disconnected, ignoring...\n");
+		printk(KERN_DEBUG pr_fmt("reconnect request, but serio is disconnected, ignoring...\n"));
 		return -1;
 	}
 
@@ -1586,9 +1590,7 @@ static ssize_t psmouse_attr_set_protocol(struct psmouse *psmouse, void *data, co
 
 	while (serio->child) {
 		if (++retry > 3) {
-			printk(KERN_WARNING
-				"psmouse: failed to destroy child port, "
-				"protocol change aborted.\n");
+			pr_warning("failed to destroy child port, protocol change aborted\n");
 			input_free_device(new_dev);
 			return -EIO;
 		}
@@ -1714,7 +1716,7 @@ static int __init psmouse_init(void)
 
 	kpsmoused_wq = create_singlethread_workqueue("kpsmoused");
 	if (!kpsmoused_wq) {
-		printk(KERN_ERR "psmouse: failed to create kpsmoused workqueue\n");
+		pr_err("failed to create kpsmoused workqueue\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/input/mouse/rpcmouse.c b/drivers/input/mouse/rpcmouse.c
index 272dedd..12586ba 100644
--- a/drivers/input/mouse/rpcmouse.c
+++ b/drivers/input/mouse/rpcmouse.c
@@ -17,6 +17,8 @@
  * the complete state and then work out if something has changed.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
@@ -87,7 +89,7 @@ static int __init rpcmouse_init(void)
 	rpcmouse_lasty = (short) iomd_readl(IOMD_MOUSEY);
 
 	if (request_irq(IRQ_VSYNCPULSE, rpcmouse_irq, IRQF_SHARED, "rpcmouse", rpcmouse_dev)) {
-		printk(KERN_ERR "rpcmouse: unable to allocate VSYNC interrupt\n");
+		pr_err("unable to allocate VSYNC interrupt\n");
 		err = -EBUSY;
 		goto err_free_dev;
 	}
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 1242775..1a4218c 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -19,6 +19,8 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/input.h>
@@ -608,11 +610,13 @@ static void fsp_packet_debug(unsigned char packet[])
 
 	ps2_packet_cnt++;
 	jiffies_msec = jiffies_to_msecs(jiffies);
-	printk(KERN_DEBUG "%08dms PS/2 packets: %02x, %02x, %02x, %02x\n",
-		jiffies_msec, packet[0], packet[1], packet[2], packet[3]);
+	printk(KERN_DEBUG
+	       pr_fmt("%08dms PS/2 packets: %02x, %02x, %02x, %02x\n"),
+	       jiffies_msec, packet[0], packet[1], packet[2], packet[3]);
 
 	if (jiffies_msec - ps2_last_second > 1000) {
-		printk(KERN_DEBUG "PS/2 packets/sec = %d\n", ps2_packet_cnt);
+		printk(KERN_DEBUG pr_fmt("PS/2 packets/sec = %d\n"),
+		       ps2_packet_cnt);
 		ps2_packet_cnt = 0;
 		ps2_last_second = jiffies_msec;
 	}
@@ -821,8 +825,7 @@ int fsp_init(struct psmouse *psmouse)
 		return -ENODEV;
 	}
 
-	printk(KERN_INFO
-		"Finger Sensing Pad, hw: %d.%d.%d, sw: %s, buttons: %d\n",
+	pr_info("Finger Sensing Pad, hw: %d.%d.%d, sw: %s, buttons: %d\n",
 		ver >> 4, ver & 0x0F, rev, fsp_drv_ver, buttons & 7);
 
 	psmouse->private = priv = kzalloc(sizeof(struct fsp_data), GFP_KERNEL);
diff --git a/drivers/input/mouse/sermouse.c b/drivers/input/mouse/sermouse.c
index 17ff137b..d809a94 100644
--- a/drivers/input/mouse/sermouse.c
+++ b/drivers/input/mouse/sermouse.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -186,8 +188,8 @@ static void sermouse_process_ms(struct sermouse *sermouse, signed char data)
 
 				default: /* We don't decode anything else yet. */
 
-					printk(KERN_WARNING
-						"sermouse.c: Received MZ++ packet %x, don't know how to handle.\n", buf[1]);
+					pr_warning("Received MZ++ packet %x, don't know how to handle\n",
+						   buf[1]);
 					break;
 			}
 
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 96b70a4..fe78899 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -23,6 +23,8 @@
  * Trademarks are the property of their respective owners.
  */
 
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/input.h>
@@ -157,7 +159,7 @@ static int synaptics_capability(struct psmouse *psmouse)
 
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 1) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB, cap)) {
-			printk(KERN_ERR "Synaptics claims to have extended capabilities,"
+			pr_err("Synaptics claims to have extended capabilities,"
 			       " but I'm not able to read them.\n");
 		} else {
 			priv->ext_cap = (cap[0] << 16) | (cap[1] << 8) | cap[2];
@@ -173,7 +175,7 @@ static int synaptics_capability(struct psmouse *psmouse)
 
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 4) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB_0C, cap)) {
-			printk(KERN_ERR "Synaptics claims to have extended capability 0x0c,"
+			pr_err("Synaptics claims to have extended capability 0x0c,"
 			       " but I'm not able to read it.\n");
 		} else {
 			priv->ext_cap_0c = (cap[0] << 16) | (cap[1] << 8) | cap[2];
@@ -223,7 +225,7 @@ static int synaptics_resolution(struct psmouse *psmouse)
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 5 &&
 	    SYN_CAP_MAX_DIMENSIONS(priv->ext_cap_0c)) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_DIMENSIONS, max)) {
-			printk(KERN_ERR "Synaptics claims to have dimensions query,"
+			pr_err("Synaptics claims to have dimensions query,"
 			       " but I'm not able to read it.\n");
 		} else {
 			priv->x_max = (max[0] << 5) | ((max[1] & 0x0f) << 1);
@@ -327,7 +329,7 @@ static void synaptics_pt_activate(struct psmouse *psmouse)
 			priv->mode &= ~SYN_BIT_FOUR_BYTE_CLIENT;
 
 		if (synaptics_mode_cmd(psmouse, priv->mode))
-			printk(KERN_INFO "synaptics: failed to switch guest protocol\n");
+			pr_info("failed to switch guest protocol\n");
 	}
 }
 
@@ -337,7 +339,7 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 
 	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
 	if (!serio) {
-		printk(KERN_ERR "synaptics: not enough memory to allocate pass-through port\n");
+		pr_err("not enough memory to allocate pass-through port\n");
 		return;
 	}
 
@@ -349,7 +351,7 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 
 	psmouse->pt_activate = synaptics_pt_activate;
 
-	printk(KERN_INFO "serio: %s port at %s\n", serio->name, psmouse->phys);
+	pr_info("%s port at %s\n", serio->name, psmouse->phys);
 	serio_register_port(serio);
 }
 
@@ -552,7 +554,7 @@ static int synaptics_validate_byte(unsigned char packet[], int idx, unsigned cha
 		return (packet[idx] & oldabs_mask[idx]) == oldabs_rslt[idx];
 
 	default:
-		printk(KERN_ERR "synaptics: unknown packet type %d\n", pkt_type);
+		pr_err("unknown packet type %d\n", pkt_type);
 		return 0;
 	}
 }
@@ -563,7 +565,7 @@ static unsigned char synaptics_detect_pkt_type(struct psmouse *psmouse)
 
 	for (i = 0; i < 5; i++)
 		if (!synaptics_validate_byte(psmouse->packet, i, SYN_NEWABS_STRICT)) {
-			printk(KERN_INFO "synaptics: using relaxed packet validation\n");
+			pr_info("using relaxed packet validation\n");
 			return SYN_NEWABS_RELAXED;
 		}
 
@@ -663,7 +665,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 
 	if (synaptics_query_hardware(psmouse)) {
-		printk(KERN_ERR "Unable to query Synaptics hardware.\n");
+		pr_err("Unable to query Synaptics hardware\n");
 		return -1;
 	}
 
@@ -674,7 +676,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 
 	if (synaptics_set_absolute_mode(psmouse)) {
-		printk(KERN_ERR "Unable to initialize Synaptics hardware.\n");
+		pr_err("Unable to initialize Synaptics hardware\n");
 		return -1;
 	}
 
@@ -736,18 +738,18 @@ int synaptics_init(struct psmouse *psmouse)
 	psmouse_reset(psmouse);
 
 	if (synaptics_query_hardware(psmouse)) {
-		printk(KERN_ERR "Unable to query Synaptics hardware.\n");
+		pr_err("Unable to query Synaptics hardware\n");
 		goto init_fail;
 	}
 
 	if (synaptics_set_absolute_mode(psmouse)) {
-		printk(KERN_ERR "Unable to initialize Synaptics hardware.\n");
+		pr_err("Unable to initialize Synaptics hardware\n");
 		goto init_fail;
 	}
 
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
-	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
+	pr_info("Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
 		SYN_ID_MODEL(priv->identity),
 		SYN_ID_MAJOR(priv->identity), SYN_ID_MINOR(priv->identity),
 		priv->model_id, priv->capabilities, priv->ext_cap, priv->ext_cap_0c);
@@ -782,7 +784,7 @@ int synaptics_init(struct psmouse *psmouse)
 	 * thye same as rate of standard PS/2 mouse.
 	 */
 	if (psmouse->rate >= 80 && impaired_toshiba_kbc) {
-		printk(KERN_INFO "synaptics: Toshiba %s detected, limiting rate to 40pps.\n",
+		pr_info("Toshiba %s detected, limiting rate to 40pps\n",
 			dmi_get_system_info(DMI_PRODUCT_NAME));
 		psmouse->rate = 40;
 	}
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 0643e49..3a7d24f 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -8,6 +8,8 @@
  * Trademarks are the property of their respective owners.
  */
 
+#define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/serio.h>
@@ -297,7 +299,7 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 		return 0;
 
 	if (trackpoint_read(&psmouse->ps2dev, TP_EXT_BTN, &button_info)) {
-		printk(KERN_WARNING "trackpoint.c: failed to get extended button data\n");
+		pr_warning("failed to get extended button data\n");
 		button_info = 0;
 	}
 
@@ -319,15 +321,13 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 
 	error = sysfs_create_group(&ps2dev->serio->dev.kobj, &trackpoint_attr_group);
 	if (error) {
-		printk(KERN_ERR
-			"trackpoint.c: failed to create sysfs attributes, error: %d\n",
-			error);
+		pr_err("failed to create sysfs attributes, error: %d\n", error);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 		return -1;
 	}
 
-	printk(KERN_INFO "IBM TrackPoint firmware: 0x%02x, buttons: %d/%d\n",
+	pr_info("IBM TrackPoint firmware: 0x%02x, buttons: %d/%d\n",
 		firmware_id, (button_info & 0xf0) >> 4, button_info & 0x0f);
 
 	return 0;
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index bf2c0c8..7af4bc6 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -76,6 +76,8 @@
  * http://www.vt100.net/manx/details?pn=EK-104AA-TM-001;id=21;cp=1
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -92,9 +94,9 @@ MODULE_LICENSE("GPL");
 
 #undef VSXXXAA_DEBUG
 #ifdef VSXXXAA_DEBUG
-#define DBG(x...) printk(x)
+#define DBG(format, arg...) pr_info(format, ##arg)
 #else
-#define DBG(x...) do {} while (0)
+#define DBG(format, arg...) do { if (0) pr_info(format, ##arg); } while (0)
 #endif
 
 #define VSXXXAA_INTRO_MASK	0x80
@@ -137,12 +139,12 @@ static void vsxxxaa_drop_bytes(struct vsxxxaa *mouse, int num)
 static void vsxxxaa_queue_byte(struct vsxxxaa *mouse, unsigned char byte)
 {
 	if (mouse->count == BUFLEN) {
-		printk(KERN_ERR "%s on %s: Dropping a byte of full buffer.\n",
-			mouse->name, mouse->phys);
+		pr_err("%s on %s: Dropping a byte of full buffer\n",
+		       mouse->name, mouse->phys);
 		vsxxxaa_drop_bytes(mouse, 1);
 	}
 
-	DBG(KERN_INFO "Queueing byte 0x%02x\n", byte);
+	DBG("Queueing byte 0x%02x\n", byte);
 
 	mouse->buf[mouse->count++] = byte;
 }
@@ -167,8 +169,7 @@ static void vsxxxaa_detection_done(struct vsxxxaa *mouse)
 		break;
 	}
 
-	printk(KERN_INFO
-		"Found %s version 0x%02x from country 0x%02x on port %s\n",
+	pr_info("Found %s version 0x%02x from country 0x%02x on port %s\n",
 		mouse->name, mouse->version, mouse->country, mouse->phys);
 }
 
@@ -188,10 +189,9 @@ static int vsxxxaa_check_packet(struct vsxxxaa *mouse, int packet_len)
 	/* Check all following bytes */
 	for (i = 1; i < packet_len; i++) {
 		if (IS_HDR_BYTE(mouse->buf[i])) {
-			printk(KERN_ERR
-				"Need to drop %d bytes of a broken packet.\n",
-				i - 1);
-			DBG(KERN_INFO "check: len=%d, b[%d]=0x%02x\n",
+			pr_err("Need to drop %d bytes of a broken packet\n",
+			       i - 1);
+			DBG("check: len=%d, b[%d]=0x%02x\n",
 			    packet_len, i, mouse->buf[i]);
 			return i - 1;
 		}
@@ -246,7 +246,7 @@ static void vsxxxaa_handle_REL_packet(struct vsxxxaa *mouse)
 
 	vsxxxaa_drop_bytes(mouse, 3);
 
-	DBG(KERN_INFO "%s on %s: dx=%d, dy=%d, buttons=%s%s%s\n",
+	DBG("%s on %s: dx=%d, dy=%d, buttons=%s%s%s\n",
 	    mouse->name, mouse->phys, dx, dy,
 	    left ? "L" : "l", middle ? "M" : "m", right ? "R" : "r");
 
@@ -297,7 +297,7 @@ static void vsxxxaa_handle_ABS_packet(struct vsxxxaa *mouse)
 
 	vsxxxaa_drop_bytes(mouse, 5);
 
-	DBG(KERN_INFO "%s on %s: x=%d, y=%d, buttons=%s%s%s%s\n",
+	DBG("%s on %s: x=%d, y=%d, buttons=%s%s%s%s\n",
 	    mouse->name, mouse->phys, x, y,
 	    left ? "L" : "l", middle ? "M" : "m",
 	    right ? "R" : "r", touch ? "T" : "t");
@@ -365,7 +365,7 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
 		input_sync(dev);
 
 		if (error != 0)
-			printk(KERN_INFO "Your %s on %s reports error=0x%02x\n",
+			pr_info("Your %s on %s reports error=0x%02x\n",
 				mouse->name, mouse->phys, error);
 
 	}
@@ -374,10 +374,9 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
 	 * If the mouse was hot-plugged, we need to force differential mode
 	 * now... However, give it a second to recover from it's reset.
 	 */
-	printk(KERN_NOTICE
-		"%s on %s: Forcing standard packet format, "
-		"incremental streaming mode and 72 samples/sec\n",
-		mouse->name, mouse->phys);
+	pr_notice("%s on %s: Forcing standard packet format, "
+		  "incremental streaming mode and 72 samples/sec\n",
+		  mouse->name, mouse->phys);
 	serio_write(mouse->serio, 'S');	/* Standard format */
 	mdelay(50);
 	serio_write(mouse->serio, 'R');	/* Incremental */
@@ -402,9 +401,9 @@ static void vsxxxaa_parse_buffer(struct vsxxxaa *mouse)
 		 * activity on the mouse.
 		 */
 		while (mouse->count > 0 && !IS_HDR_BYTE(buf[0])) {
-			printk(KERN_ERR "%s on %s: Dropping a byte to regain "
-				"sync with mouse data stream...\n",
-				mouse->name, mouse->phys);
+			pr_err("%s on %s: Dropping a byte to regain "
+			       "sync with mouse data stream...\n",
+			       mouse->name, mouse->phys);
 			vsxxxaa_drop_bytes(mouse, 1);
 		}
 
@@ -437,8 +436,7 @@ static void vsxxxaa_parse_buffer(struct vsxxxaa *mouse)
 		}
 
 		if (stray_bytes > 0) {
-			printk(KERN_ERR "Dropping %d bytes now...\n",
-				stray_bytes);
+			pr_err("Dropping %d bytes now...\n", stray_bytes);
 			vsxxxaa_drop_bytes(mouse, stray_bytes);
 		}
 
-- 
1.7.2.19.g9a302

