Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0DSIc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:32:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62237 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0DSIc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pYY+rgY+lmiwNORHyo+/RzmfqrGoCY+W9l+IW6R3fxXyAB5DFAKrm8OgKwKakvOrNn
         61XOQbb9unhxHRP7cVVEAXlZg9+m6gwH31k3AyqxXwS8HHpuMCz3esRLPeCR3tDEx3Mi
         xFwyXRMu2YpMyKe48BNSG0NWJaUs40koQ03NU=
Date: Mon, 19 Apr 2010 01:32:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] input: Add support of Synaptics Clickpad device
Message-ID: <20100419083221.GB26102@core.coreip.homeip.net>
References: <1271257823-23566-1-git-send-email-tiwai@suse.de>
 <1271257823-23566-2-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271257823-23566-2-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Wed, Apr 14, 2010 at 05:10:22PM +0200, Takashi Iwai wrote:
> Add the detection of Synaptics Clickpad device.
> The device can be detected a new query command 0x0c.  The clickpad
> flags are in cap[0]:4 and cap[1]:0 bits.  But, the driver checks
> first the product id bits in the ext capabilities to be sure, so
> that it skips the new check on older devices.
> 

Instead of looking at the product id, can we check the number of
supported extended capabilities queries and act accordingly, like the
patch below?

Thanks.

-- 
Dmitry


Input: Add support of Synaptics Clickpad device

From: Takashi Iwai <tiwai@suse.de>

The new type of touchpads can be detected via a new query command 0x0c.
The clickpad flags are in cap[0]:4 and cap[1]:0 bits.

When the device is detected, the driver now reports only the left
button as the supported buttons so that X11 driver can detect that
the device is Clickpad.  A Clickpad device gives the button events
only as the middle button.  The kernel driver morphs to the left
button.  The real handling of Clickpad is done rather in X driver
side.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/synaptics.c |   33 +++++++++++++++++++++++++++++----
 drivers/input/mouse/synaptics.h |    4 ++++
 2 files changed, 33 insertions(+), 4 deletions(-)


diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 026df60..c7b5285 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -137,7 +137,8 @@ static int synaptics_capability(struct psmouse *psmouse)
 	if (synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, cap))
 		return -1;
 	priv->capabilities = (cap[0] << 16) | (cap[1] << 8) | cap[2];
-	priv->ext_cap = 0;
+	priv->ext_cap = priv->ext_cap_0c = 0;
+
 	if (!SYN_CAP_VALID(priv->capabilities))
 		return -1;
 
@@ -162,6 +163,16 @@ static int synaptics_capability(struct psmouse *psmouse)
 				priv->ext_cap &= 0xff0fff;
 		}
 	}
+
+	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 4) {
+		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB_0C, cap)) {
+			printk(KERN_ERR "Synaptics claims to have extended capability 0x0c,"
+			       " but I'm not able to read it.");
+		} else {
+			priv->ext_cap_0c = (cap[0] << 16) | (cap[1] << 8) | cap[2];
+		}
+	}
+
 	return 0;
 }
 
@@ -348,7 +359,15 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
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
@@ -593,6 +612,12 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 
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
@@ -697,10 +722,10 @@ int synaptics_init(struct psmouse *psmouse)
 
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
-	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx\n",
+	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
 		SYN_ID_MODEL(priv->identity),
 		SYN_ID_MAJOR(priv->identity), SYN_ID_MINOR(priv->identity),
-		priv->model_id, priv->capabilities, priv->ext_cap);
+		priv->model_id, priv->capabilities, priv->ext_cap, priv->ext_cap_0c);
 
 	set_input_params(psmouse->dev, priv);
 
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index f0f40a3..ae37c5d 100644
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
