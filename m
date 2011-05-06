Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab1EFA4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:56:25 -0400
Received: from kroah.org ([198.145.64.141]:36769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab1EFAYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.041111928@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Dmitry Torokhov <dtor@mail.ru>
Subject: [049/143] Input: Add support of Synaptics Clickpad device
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5f57d67da87332a9a1ba8fa7a33bf0680e1c76e7 upstream.

The new type of touchpads can be detected via a new query command
0x0c. The clickpad flags are in cap[0]:4 and cap[1]:0 bits.

When the device is detected, the driver now reports only the left
button as the supported buttons so that X11 driver can detect that
the device is Clickpad. A Clickpad device gives the button events
only as the middle button. The kernel driver morphs to the left
button. The real handling of Clickpad is done rather in X driver
side.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/synaptics.c |   35 ++++++++++++++++++++++++++++++-----
 drivers/input/mouse/synaptics.h |    4 ++++
 2 files changed, 34 insertions(+), 5 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -135,7 +135,8 @@ static int synaptics_capability(struct p
 	if (synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, cap))
 		return -1;
 	priv->capabilities = (cap[0] << 16) | (cap[1] << 8) | cap[2];
-	priv->ext_cap = 0;
+	priv->ext_cap = priv->ext_cap_0c = 0;
+
 	if (!SYN_CAP_VALID(priv->capabilities))
 		return -1;
 
@@ -148,7 +149,7 @@ static int synaptics_capability(struct p
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 1) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB, cap)) {
 			printk(KERN_ERR "Synaptics claims to have extended capabilities,"
-			       " but I'm not able to read them.");
+			       " but I'm not able to read them.\n");
 		} else {
 			priv->ext_cap = (cap[0] << 16) | (cap[1] << 8) | cap[2];
 
@@ -160,6 +161,16 @@ static int synaptics_capability(struct p
 				priv->ext_cap &= 0xff0fff;
 		}
 	}
+
+	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 4) {
+		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB_0C, cap)) {
+			printk(KERN_ERR "Synaptics claims to have extended capability 0x0c,"
+			       " but I'm not able to read it.\n");
+		} else {
+			priv->ext_cap_0c = (cap[0] << 16) | (cap[1] << 8) | cap[2];
+		}
+	}
+
 	return 0;
 }
 
@@ -346,7 +357,15 @@ static void synaptics_parse_hw_state(uns
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
-		if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
+		if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
+			/*
+			 * Clickpad's button is transmitted as middle button,
+			 * however, since it is primary button, we will report
+			 * it as BTN_LEFT.
+			 */
+			hw->left = ((buf[0] ^ buf[3]) & 0x01) ? 1 : 0;
+
+		} else if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
 			hw->middle = ((buf[0] ^ buf[3]) & 0x01) ? 1 : 0;
 			if (hw->w == 2)
 				hw->scroll = (signed char)(buf[1]);
@@ -591,6 +610,12 @@ static void set_input_params(struct inpu
 
 	dev->absres[ABS_X] = priv->x_res;
 	dev->absres[ABS_Y] = priv->y_res;
+
+	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
+		/* Clickpads report only left button */
+		__clear_bit(BTN_RIGHT, dev->keybit);
+		__clear_bit(BTN_MIDDLE, dev->keybit);
+	}
 }
 
 static void synaptics_disconnect(struct psmouse *psmouse)
@@ -689,10 +714,10 @@ int synaptics_init(struct psmouse *psmou
 
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
-	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx\n",
+	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
 		SYN_ID_MODEL(priv->identity),
 		SYN_ID_MAJOR(priv->identity), SYN_ID_MINOR(priv->identity),
-		priv->model_id, priv->capabilities, priv->ext_cap);
+		priv->model_id, priv->capabilities, priv->ext_cap, priv->ext_cap_0c);
 
 	set_input_params(psmouse->dev, priv);
 
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -18,6 +18,7 @@
 #define SYN_QUE_SERIAL_NUMBER_SUFFIX	0x07
 #define SYN_QUE_RESOLUTION		0x08
 #define SYN_QUE_EXT_CAPAB		0x09
+#define SYN_QUE_EXT_CAPAB_0C		0x0c
 
 /* synatics modes */
 #define SYN_BIT_ABSOLUTE_MODE		(1 << 7)
@@ -48,6 +49,8 @@
 #define SYN_CAP_VALID(c)		((((c) & 0x00ff00) >> 8) == 0x47)
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
+#define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
+#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -96,6 +99,7 @@ struct synaptics_data {
 	unsigned long int model_id;		/* Model-ID */
 	unsigned long int capabilities;		/* Capabilities */
 	unsigned long int ext_cap;		/* Extended Capabilities */
+	unsigned long int ext_cap_0c;		/* Ext Caps from 0x0c query */
 	unsigned long int identity;		/* Identification */
 	int x_res;				/* X resolution in units/mm */
 	int y_res;				/* Y resolution in units/mm */


