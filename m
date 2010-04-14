Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0DNPLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:11:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:55840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab0DNPLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:11:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 2/2] input: Add LED support to Synaptics device
Date: Wed, 14 Apr 2010 17:10:23 +0200
Message-Id: <1271257823-23566-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271257823-23566-1-git-send-email-tiwai@suse.de>
References: <1271257823-23566-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Synaptics devices have an LED on the top-left corner.
This is controlled via the command 0x0a with parameters 0x88 or 0x10.

The detection of the LED isn't clear yet.  It should have been the new
capability bits that indicate the presence, but on real machines, it
doesn't fit.  So, for the time being, the driver checks the product id
in the ext capability bits and assumes that LED exists on the known
devices.

The support of LED is controlled via a normal input event with EV_LED
bit mask.  It supports LED_MUTE bit.  X driver can detect the LED
support by checking these bits.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/input/mouse/synaptics.c |   54 +++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/synaptics.h |    4 +++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 6a51542..ea874bd 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -28,6 +28,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
+#include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "psmouse.h"
 #include "synaptics.h"
@@ -328,6 +329,37 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 
+static void synaptics_set_led(struct psmouse *psmouse, int on)
+{
+	unsigned char param[1];
+
+	if (psmouse_sliced_command(psmouse, on ? 0x88 : 0x10))
+		return;
+	param[0] = 0x0a;
+	ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_SETRATE);
+}
+
+static void synaptics_led_work(struct work_struct *work)
+{
+	struct synaptics_data *priv = container_of(work, struct synaptics_data, led_work);
+	synaptics_set_led(priv->psmouse, priv->led_status);
+}
+
+/* input event handler: changed by x11 synaptics driver */
+static int synaptics_led_event(struct input_dev *dev, unsigned int type,
+			       unsigned int code, int value)
+{
+	struct synaptics_data *priv = dev->dev.platform_data;
+
+	if (!priv)
+		return 0;
+	if (type == EV_LED && code == LED_MUTE) {
+		priv->led_status = !!value;
+		schedule_work(&priv->led_work);
+	}
+	return 0;
+}
+
 static void synaptics_check_clickpad(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
@@ -344,6 +376,12 @@ static void synaptics_check_clickpad(struct psmouse *psmouse)
 	if (priv->clickpad)
 		printk(KERN_INFO "Synaptics: Clickpad device detected: %d\n",
 		       priv->clickpad);
+	/* FIXME: this should be ncap[1] 0x20, but it's not really... */
+	priv->has_led = 1;
+	if (priv->has_led) {
+		printk(KERN_INFO "Synaptics: support LED control\n");
+		INIT_WORK(&priv->led_work, synaptics_led_work);
+	}
 }
 
 static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *priv, struct synaptics_hw_state *hw)
@@ -623,10 +661,22 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 		__clear_bit(BTN_RIGHT, dev->keybit); /* only left-button */
 		__clear_bit(BTN_MIDDLE, dev->keybit);
 	}
+	if (priv->has_led) {
+		__set_bit(EV_LED, dev->evbit);
+		__set_bit(LED_MUTE, dev->ledbit);
+		dev->event = synaptics_led_event;
+		dev->dev.platform_data = priv;
+	}
 }
 
 static void synaptics_disconnect(struct psmouse *psmouse)
 {
+	struct synaptics_data *priv = psmouse->private;
+
+	if (priv->has_led) {
+		cancel_work_sync(&priv->led_work);
+		synaptics_set_led(psmouse, 0);
+	}
 	synaptics_reset(psmouse);
 	kfree(psmouse->private);
 	psmouse->private = NULL;
@@ -658,6 +708,9 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 	}
 
+	if (priv->has_led)
+		synaptics_set_led(psmouse, priv->led_status);
+
 	return 0;
 }
 
@@ -713,6 +766,7 @@ int synaptics_init(struct psmouse *psmouse)
 	if (!priv)
 		return -1;
 
+	priv->psmouse = psmouse;
 	psmouse_reset(psmouse);
 
 	if (synaptics_query_hardware(psmouse)) {
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index b824851..aeca6d2 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -107,6 +107,10 @@ struct synaptics_data {
 	int scroll;
 
 	unsigned char clickpad;
+	unsigned char has_led;
+	unsigned char led_status;
+	struct psmouse *psmouse;
+	struct work_struct led_work;
 };
 
 void synaptics_module_init(void);
-- 
1.7.0.4

