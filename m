Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0LMW4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:56:40 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43569 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0LMW4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:56:38 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] Input: synaptics - add multitouch packet support
Date: Mon, 13 Dec 2010 23:55:47 +0100
Message-Id: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSHJG-00080F-9I.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PSHJG-00080F-9I 9724a6fb0728e1502e25bb1c5fdd26ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@canonical.com>

Synaptics 2.7 series of touchpads support a mode for reporting 2 sets
of X/Y/Pressure data (multi-touch).  These same devices default mode
report single finger data and do not report finger counts.

Enabling MT mode makes finger count reporting start working in same
fashion as touchpads that claim that capability. Up to three fingers
can be reported this way.

While in MT mode and two or three fingers are touching, two sets of
data are sent.  The first is a new format buffer with lower resolution
reporting of stationary finger and the second is standard data format
reporting movement.

Work to enable MT and decoding its packet is from patch from Takashi Iwai.

Additional cleanup/testing of original patch was performed by Chase Douglas.

Minor cleanup and testing performed by Chris Bagwell.

Reported-by: Tobyn Bertram
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/synaptics.c |   75 ++++++++++++++++++++++++++++++++-------
 drivers/input/mouse/synaptics.h |    4 ++
 2 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 2e300a4..de08d77 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -279,6 +279,24 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
 	synaptics_mode_cmd(psmouse, priv->mode);
 }
 
+static int synaptics_set_multitouch_mode(struct psmouse *psmouse)
+{
+	static unsigned char param = 0xc8;
+	struct synaptics_data *priv = psmouse->private;
+
+	if (!SYN_CAP_MULTITOUCH(priv->ext_cap_0c))
+		return 0;
+
+	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
+		return -1;
+	if (ps2_command(&psmouse->ps2dev, &param, PSMOUSE_CMD_SETRATE))
+		return -1;
+
+	priv->multitouch = 1;
+	printk(KERN_INFO "Synaptics: Multitouch mode enabled\n");
+	return 0;
+}
+
 /*****************************************************************************
  *	Synaptics pass-through PS/2 port support
  ****************************************************************************/
@@ -380,23 +398,38 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 
-static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *priv, struct synaptics_hw_state *hw)
+static int synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *priv, struct synaptics_hw_state *hw)
 {
 	memset(hw, 0, sizeof(struct synaptics_hw_state));
 
 	if (SYN_MODEL_NEWABS(priv->model_id)) {
-		hw->x = (((buf[3] & 0x10) << 8) |
-			 ((buf[1] & 0x0f) << 8) |
-			 buf[4]);
-		hw->y = (((buf[3] & 0x20) << 7) |
-			 ((buf[1] & 0xf0) << 4) |
-			 buf[5]);
-
-		hw->z = buf[2];
 		hw->w = (((buf[0] & 0x30) >> 2) |
 			 ((buf[0] & 0x04) >> 1) |
 			 ((buf[3] & 0x04) >> 2));
 
+		if (priv->multitouch && hw->w == 2) {
+			/* Multitouch data is half normal resolution */
+			hw->x = (((buf[4] & 0x0f) << 8) |
+				 buf[1]) << 1;
+			hw->y = (((buf[4] & 0xf0) << 4) |
+				 buf[2]) << 1;
+
+			hw->z = ((buf[3] & 0x30) |
+				 (buf[5] & 0x0f)) << 1;
+
+			/* Only look at x, y, and z for MT */
+			return 1;
+		} else {
+			hw->x = (((buf[3] & 0x10) << 8) |
+				 ((buf[1] & 0x0f) << 8) |
+				 buf[4]);
+			hw->y = (((buf[3] & 0x20) << 7) |
+				 ((buf[1] & 0xf0) << 4) |
+				 buf[5]);
+
+			hw->z = buf[2];
+		}
+
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
@@ -452,6 +485,8 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 	}
+
+	return 0;
 }
 
 /*
@@ -466,7 +501,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	int finger_width;
 	int i;
 
-	synaptics_parse_hw_state(psmouse->packet, priv, &hw);
+	if (synaptics_parse_hw_state(psmouse->packet, priv, &hw)) {
+		priv->mt = hw;
+		return;
+	}
 
 	if (hw.scroll) {
 		priv->scroll += hw.scroll;
@@ -494,7 +532,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		if (SYN_CAP_EXTENDED(priv->capabilities)) {
 			switch (hw.w) {
 			case 0 ... 1:
-				if (SYN_CAP_MULTIFINGER(priv->capabilities))
+				if (SYN_CAP_MULTIFINGER(priv->capabilities) ||
+				    priv->multitouch)
 					num_fingers = hw.w + 2;
 				break;
 			case 2:
@@ -532,7 +571,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	input_report_key(dev, BTN_LEFT, hw.left);
 	input_report_key(dev, BTN_RIGHT, hw.right);
 
-	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
+	if (SYN_CAP_MULTIFINGER(priv->capabilities) || priv->multitouch) {
 		input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
 		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
 	}
@@ -638,7 +677,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	__set_bit(BTN_LEFT, dev->keybit);
 	__set_bit(BTN_RIGHT, dev->keybit);
 
-	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
+	if (SYN_CAP_MULTIFINGER(priv->capabilities) | priv->multitouch) {
 		__set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
 		__set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
 	}
@@ -702,6 +741,11 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 	}
 
+	if (synaptics_set_multitouch_mode(psmouse)) {
+		printk(KERN_ERR "Unable to initialize Synaptics Multitouch.\n");
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -769,6 +813,11 @@ int synaptics_init(struct psmouse *psmouse)
 		goto init_fail;
 	}
 
+	if (synaptics_set_multitouch_mode(psmouse)) {
+		printk(KERN_ERR "Unable to initialize Synaptics Multitouch.\n");
+		goto init_fail;
+	}
+
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
 	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 613a365..4cb13b8 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -53,6 +53,7 @@
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
+#define SYN_CAP_MULTITOUCH(ex0c)	((ex0c) & 0x080000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -112,6 +113,9 @@ struct synaptics_data {
 	int scroll;
 
 	struct serio *pt_port;			/* Pass-through serio port */
+
+	int multitouch;				/* device provides MT data */
+	struct synaptics_hw_state mt;		/* current MT packet */
 };
 
 void synaptics_module_init(void);
-- 
1.7.1

