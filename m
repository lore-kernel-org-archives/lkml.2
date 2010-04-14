Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0DNPLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:11:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:55839 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab0DNPLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:11:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/2] input: Add support of Synaptics Clickpad device
Date: Wed, 14 Apr 2010 17:10:22 +0200
Message-Id: <1271257823-23566-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271257823-23566-1-git-send-email-tiwai@suse.de>
References: <1271257823-23566-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the detection of Synaptics Clickpad device.
The device can be detected a new query command 0x0c.  The clickpad
flags are in cap[0]:4 and cap[1]:0 bits.  But, the driver checks
first the product id bits in the ext capabilities to be sure, so
that it skips the new check on older devices.

When the device is detected, the driver now reports only the left
button as the supported buttons so that X11 driver can detect that
the device is Clickpad.  A Clickpad device gives the button events
only as the middle button.  The kernel driver morphs to the left
button.  The real handling of Clickpad is done rather in X driver
side.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/input/mouse/synaptics.c |   32 ++++++++++++++++++++++++++++++++
 drivers/input/mouse/synaptics.h |    4 ++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 026df60..6a51542 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -328,6 +328,24 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 
+static void synaptics_check_clickpad(struct psmouse *psmouse)
+{
+	struct synaptics_data *priv = psmouse->private;
+	unsigned char ncap[3];
+
+	/* check the new capability bits only on known working devices */
+	if (SYN_CAP_PRODUCT_ID(priv->ext_cap) != 0xe4)
+		return;
+	if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB2, ncap))
+		return;
+	printk(KERN_INFO "Synaptics: newcap: %02x:%02x:%02x\n",
+	       ncap[0], ncap[1], ncap[2]);
+	priv->clickpad = ((ncap[0] & 0x10) >> 4) | ((ncap[1] & 0x01) << 1);
+	if (priv->clickpad)
+		printk(KERN_INFO "Synaptics: Clickpad device detected: %d\n",
+		       priv->clickpad);
+}
+
 static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *priv, struct synaptics_hw_state *hw)
 {
 	memset(hw, 0, sizeof(struct synaptics_hw_state));
@@ -354,6 +372,13 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
 				hw->scroll = (signed char)(buf[1]);
 		}
 
+		if (priv->clickpad) {
+			/* clickpad reports only the middle button, report
+			 * it as the left button
+			 */
+			hw->left = ((buf[0] ^ buf[3]) & 0x01) ? 1 : 0;
+		}
+
 		if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
 			hw->up   = ((buf[0] ^ buf[3]) & 0x01) ? 1 : 0;
 			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
@@ -593,6 +618,11 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 
 	dev->absres[ABS_X] = priv->x_res;
 	dev->absres[ABS_Y] = priv->y_res;
+
+	if (priv->clickpad) {
+		__clear_bit(BTN_RIGHT, dev->keybit); /* only left-button */
+		__clear_bit(BTN_MIDDLE, dev->keybit);
+	}
 }
 
 static void synaptics_disconnect(struct psmouse *psmouse)
@@ -702,6 +732,8 @@ int synaptics_init(struct psmouse *psmouse)
 		SYN_ID_MAJOR(priv->identity), SYN_ID_MINOR(priv->identity),
 		priv->model_id, priv->capabilities, priv->ext_cap);
 
+	synaptics_check_clickpad(psmouse);
+
 	set_input_params(psmouse->dev, priv);
 
 	/*
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index f0f40a3..b824851 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -18,6 +18,7 @@
 #define SYN_QUE_SERIAL_NUMBER_SUFFIX	0x07
 #define SYN_QUE_RESOLUTION		0x08
 #define SYN_QUE_EXT_CAPAB		0x09
+#define SYN_QUE_EXT_CAPAB2		0x0c
 
 /* synatics modes */
 #define SYN_BIT_ABSOLUTE_MODE		(1 << 7)
@@ -48,6 +49,7 @@
 #define SYN_CAP_VALID(c)		((((c) & 0x00ff00) >> 8) == 0x47)
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
+#define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -103,6 +105,8 @@ struct synaptics_data {
 	unsigned char pkt_type;			/* packet type - old, new, etc */
 	unsigned char mode;			/* current mode byte */
 	int scroll;
+
+	unsigned char clickpad;
 };
 
 void synaptics_module_init(void);
-- 
1.7.0.4

