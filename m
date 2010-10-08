Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab0JHO6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:58:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60412 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab0JHO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:58:07 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-input@vger.kernel.org, xorg-devel@lists.x.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: [PATCH 1/3] Input: synaptics - add multitouch support
Date: Fri,  8 Oct 2010 10:57:58 -0400
Message-Id: <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Synaptics devices support multitouch. It appears there is no touch
tracking, so the non-slotted protocol is used.

Multitouch mode is disabled by default because it makes click-and-drag
on touchpads with integrated buttons even more difficult than it already
is. Maybe if/when the X synaptics input module works around this issue
we can enable it by default.

Credit goes to Tobyn Bertram for reverse engineering the protocol.

Reported-by: Tobyn Bertram
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   78 +++++++++++++++++++++++++++++++++++----
 drivers/input/mouse/synaptics.h |    3 +
 2 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 96b70a4..990598f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -44,6 +44,10 @@
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+static bool synaptics_multitouch;
+module_param(synaptics_multitouch, bool, 0644);
+MODULE_PARM_DESC(synaptics_multitouch,
+		 "Enable multitouch mode on Synaptics devices");
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -279,6 +283,22 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
 	synaptics_mode_cmd(psmouse, priv->mode);
 }
 
+static void synaptics_set_multitouch_mode(struct psmouse *psmouse)
+{
+	static unsigned char param = 0xc8;
+	struct synaptics_data *priv = psmouse->private;
+
+	if (!SYN_CAP_MULTITOUCH(priv->ext_cap_0c) || !synaptics_multitouch)
+		return;
+	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
+		return;
+	if (ps2_command(&psmouse->ps2dev, &param, PSMOUSE_CMD_SETRATE))
+		return;
+
+	priv->multitouch = 1;
+	printk(KERN_INFO "Synaptics: Multitouch mode enabled\n");
+}
+
 /*****************************************************************************
  *	Synaptics pass-through PS/2 port support
  ****************************************************************************/
@@ -362,18 +382,30 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
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
 
+		if (SYN_MULTITOUCH(priv, hw)) {
+			/* Multitouch data is half normal resolution */
+			hw->x = (((buf[4] & 0x0f) << 8) |
+				 buf[1]) << 1;
+			hw->y = (((buf[4] & 0xf0) << 4) |
+				 buf[2]) << 1;
+
+			hw->z = ((buf[3] & 0x30) |
+				 (buf[5] & 0x0f)) << 1;
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
 
@@ -445,6 +477,18 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 
 	synaptics_parse_hw_state(psmouse->packet, priv, &hw);
 
+	if (SYN_MULTITOUCH(priv, &hw)) {
+		if (hw.z > 0) {
+			input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
+			input_report_abs(dev, ABS_MT_POSITION_Y,
+					 YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
+			input_report_abs(dev, ABS_MT_PRESSURE, hw.z);
+		}
+
+		input_mt_sync(dev);
+		return;
+	}
+
 	if (hw.scroll) {
 		priv->scroll += hw.scroll;
 
@@ -499,6 +543,12 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	if (hw.z > 0) {
 		input_report_abs(dev, ABS_X, hw.x);
 		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
+		if (priv->multitouch) {
+			input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
+			input_report_abs(dev, ABS_MT_POSITION_Y,
+					 YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
+			input_report_abs(dev, ABS_MT_PRESSURE, hw.z);
+		}
 	}
 	input_report_abs(dev, ABS_PRESSURE, hw.z);
 
@@ -525,6 +575,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	for (i = 0; i < SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
 		input_report_key(dev, BTN_0 + i, hw.ext_buttons & (1 << i));
 
+	if (priv->multitouch)
+		input_mt_sync(dev);
 	input_sync(dev);
 }
 
@@ -605,6 +657,14 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 			     YMIN_NOMINAL, priv->y_max ?: YMAX_NOMINAL, 0, 0);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
+	if (priv->multitouch) {
+		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
+				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
+				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+	}
+
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
 		input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
 
@@ -745,6 +805,8 @@ int synaptics_init(struct psmouse *psmouse)
 		goto init_fail;
 	}
 
+	synaptics_set_multitouch_mode(psmouse);
+
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
 	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index b6aa7d2..5126c9c 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -53,6 +53,7 @@
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
+#define SYN_CAP_MULTITOUCH(ex0c)	((ex0c) & 0x080000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -78,6 +79,7 @@
 #define SYN_NEWABS_STRICT		1
 #define SYN_NEWABS_RELAXED		2
 #define SYN_OLDABS			3
+#define SYN_MULTITOUCH(priv, hw)	((priv)->multitouch && (hw)->w == 2)
 
 /*
  * A structure to describe the state of the touchpad hardware (buttons and pad)
@@ -110,6 +112,7 @@ struct synaptics_data {
 	unsigned char pkt_type;			/* packet type - old, new, etc */
 	unsigned char mode;			/* current mode byte */
 	int scroll;
+	int multitouch;				/* Whether device provides MT */
 };
 
 void synaptics_module_init(void);
-- 
1.7.1

