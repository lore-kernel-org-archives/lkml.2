Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2CWEAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:00:36 -0400
Received: from hermod.sentelic.com ([203.69.18.19]:28745 "EHLO
	hermod.sentelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2CWEAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:00:30 -0400
From: Tai-hwa Liang <avatar@sentelic.com>
To: Oskari Saarenmaa <os@ohmu.fi>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] Input: sentelic - enabling absolute coordinates output for newer hardware
Date: Fri, 23 Mar 2012 11:52:18 +0800
Message-Id: <1332474741-19426-3-git-send-email-avatar@sentelic.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
References: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Hooking multi-finger coordinates output with kernel multitouch library;
- Enabling absolute coordinates output for Cx+ hardware. The older hardware
  performs much better in relative mode; thus relative mode related code
  are preserved.

Part of the code is based on the work done by Oskari Saarenmaa <os@ohmu.fi>,
which was used to support the clickpad found on ASUS UX21/31 Ultrabook.
On the other hand, the FSP found on UX21/31 doesn't have hardware capability
register other than PnP ID, which means that we'll have to figure out an
alternative approach to identify such pad correctly; otherwise, blindly
adding INPUT_PROP_BUTTONPAD property may compatability issues amongst
existing FSPs.

Signed-off-by: Tai-hwa Liang <avatar@sentelic.com>
---
 drivers/input/mouse/sentelic.c |  114 ++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/sentelic.h |   22 +++++++-
 2 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 0ce090b..43d839a 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -2,7 +2,7 @@
  * Finger Sensing Pad PS/2 mouse driver.
  *
  * Copyright (C) 2005-2007 Asia Vital Components Co., Ltd.
- * Copyright (C) 2005-2011 Tai-hwa Liang, Sentelic Corporation.
+ * Copyright (C) 2005-2012 Tai-hwa Liang, Sentelic Corporation.
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/ctype.h>
 #include <linux/libps2.h>
 #include <linux/serio.h>
@@ -644,12 +645,24 @@ static void fsp_packet_debug(unsigned char packet[])
 }
 #endif
 
+static void fsp_set_slot(struct input_dev *dev, int slot, bool active,
+			 unsigned int x, unsigned int y)
+{
+	input_mt_slot(dev, slot);
+	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
+	if (active) {
+		input_report_abs(dev, ABS_MT_POSITION_X, x);
+		input_report_abs(dev, ABS_MT_POSITION_Y, y);
+	}
+}
+
 static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 {
 	struct input_dev *dev = psmouse->dev;
 	struct fsp_data *ad = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 	unsigned char button_status = 0, lscroll = 0, rscroll = 0;
+	unsigned short abs_x, abs_y, fgrs = 0;
 	int rel_x, rel_y;
 
 	if (psmouse->pktcnt < 4)
@@ -661,8 +674,66 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 
 	switch (psmouse->packet[0] >> FSP_PKT_TYPE_SHIFT) {
 	case FSP_PKT_TYPE_ABS:
-		dev_warn(&psmouse->ps2dev.serio->dev,
-			 "Unexpected absolute mode packet, ignored.\n");
+		abs_x = (packet[1] << 2) | ((packet[3] >> 2) & 0x03);
+		abs_y = (packet[2] << 2) | (packet[3] & 0x03);
+
+		if (packet[0] & FSP_PB0_MFMC) {
+			/*
+			 * MFMC packet: assume that there are two fingers on
+			 * pad
+			 */
+			fgrs = 2;
+
+			/* MFMC packet */
+			if (packet[0] & FSP_PB0_MFMC_FGR2) {
+				/* 2nd finger */
+				if (ad->last_mt_fgr == 2) {
+					/*
+					 * workaround for buggy firmware
+					 * which doesn't clear MFMC bit if
+					 * the 1st finger is up
+					 */
+					fgrs = 1;
+					fsp_set_slot(dev, 0, false, 0, 0);
+				}
+				ad->last_mt_fgr = 2;
+
+				fsp_set_slot(dev, 1, fgrs == 2, abs_x, abs_y);
+			} else {
+				/* 1st finger */
+				if (ad->last_mt_fgr == 1) {
+					/*
+					 * workaround for buggy firmware
+					 * which doesn't clear MFMC bit if
+					 * the 2nd finger is up
+					 */
+					fgrs = 1;
+					fsp_set_slot(dev, 1, false, 0, 0);
+				}
+				ad->last_mt_fgr = 1;
+				fsp_set_slot(dev, 0, fgrs != 0, abs_x, abs_y);
+			}
+		} else {
+			/* SFAC packet */
+
+			/* no multi-finger information */
+			ad->last_mt_fgr = 0;
+
+			if (abs_x != 0 && abs_y != 0)
+				fgrs = 1;
+
+			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
+			fsp_set_slot(dev, 1, false, 0, 0);
+		}
+		if (fgrs > 0) {
+			input_report_abs(dev, ABS_X, abs_x);
+			input_report_abs(dev, ABS_Y, abs_y);
+		}
+		input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+		input_report_key(dev, BTN_TOUCH, fgrs);
+		input_report_key(dev, BTN_TOOL_FINGER, fgrs == 1);
+		input_report_key(dev, BTN_TOOL_DOUBLETAP, fgrs == 2);
 		break;
 
 	case FSP_PKT_TYPE_NORMAL_OPC:
@@ -786,6 +857,17 @@ static int fsp_activate_protocol(struct psmouse *psmouse)
 		/* Enable on-pad vertical and horizontal scrolling */
 		fsp_onpad_vscr(psmouse, true);
 		fsp_onpad_hscr(psmouse, true);
+	} else {
+		/* Enable absolute coordinates output for Cx/Dx hardware */
+		if (fsp_reg_write(psmouse, FSP_REG_SWC1,
+				  FSP_BIT_SWC1_EN_ABS_1F |
+				  FSP_BIT_SWC1_EN_ABS_2F |
+				  FSP_BIT_SWC1_EN_FUP_OUT |
+				  FSP_BIT_SWC1_EN_ABS_CON)) {
+			dev_err(&psmouse->ps2dev.serio->dev,
+				"Unable to enable absolute coordinates output.\n");
+			return -EIO;
+		}
 	}
 
 	return 0;
@@ -802,6 +884,32 @@ static int fsp_set_input_params(struct psmouse *psmouse)
 		__set_bit(BTN_FORWARD, dev->keybit);
 		__set_bit(REL_WHEEL, dev->relbit);
 		__set_bit(REL_HWHEEL, dev->relbit);
+	} else {
+		/*
+		 * Hardware prior to Cx performs much better in relative mode;
+		 * hence, only enable absolute coordinates output as well as
+		 * multi-touch output for the newer hardware.
+		 *
+		 * Maximum coordinates can be computed as:
+		 *
+		 *	number of scanlines * 64 - 57
+		 *
+		 * where number of X/Y scanline lines are 16/12.
+		 */
+		int abs_x = 967, abs_y = 711;
+
+		__set_bit(EV_ABS, dev->evbit);
+		__clear_bit(EV_REL, dev->evbit);
+		__set_bit(BTN_TOUCH, dev->keybit);
+		__set_bit(BTN_TOOL_FINGER, dev->keybit);
+		__set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
+		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
+
+		input_set_abs_params(dev, ABS_X, 0, abs_x, 0, 0);
+		input_set_abs_params(dev, ABS_Y, 0, abs_y, 0, 0);
+		input_mt_init_slots(dev, 2);
+		input_set_abs_params(dev, ABS_MT_POSITION_X, 0, abs_x, 0, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, 0, abs_y, 0, 0);
 	}
 
 	return 0;
diff --git a/drivers/input/mouse/sentelic.h b/drivers/input/mouse/sentelic.h
index 23bd25e..334de19 100644
--- a/drivers/input/mouse/sentelic.h
+++ b/drivers/input/mouse/sentelic.h
@@ -2,7 +2,7 @@
  * Finger Sensing Pad PS/2 mouse driver.
  *
  * Copyright (C) 2005-2007 Asia Vital Components Co., Ltd.
- * Copyright (C) 2005-2011 Tai-hwa Liang, Sentelic Corporation.
+ * Copyright (C) 2005-2012 Tai-hwa Liang, Sentelic Corporation.
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License
@@ -55,6 +55,16 @@
 #define	FSP_BIT_FIX_HSCR	BIT(5)
 #define	FSP_BIT_DRAG_LOCK	BIT(6)
 
+#define	FSP_REG_SWC1		(0x90)
+#define	FSP_BIT_SWC1_EN_ABS_1F	BIT(0)
+#define	FSP_BIT_SWC1_EN_GID	BIT(1)
+#define	FSP_BIT_SWC1_EN_ABS_2F	BIT(2)
+#define	FSP_BIT_SWC1_EN_FUP_OUT	BIT(3)
+#define	FSP_BIT_SWC1_EN_ABS_CON	BIT(4)
+#define	FSP_BIT_SWC1_GST_GRP0	BIT(5)
+#define	FSP_BIT_SWC1_GST_GRP1	BIT(6)
+#define	FSP_BIT_SWC1_BX_COMPAT	BIT(7)
+
 /* Finger-sensing Pad packet formating related definitions */
 
 /* absolute packet type */
@@ -64,6 +74,15 @@
 #define	FSP_PKT_TYPE_NORMAL_OPC	(0x03)
 #define	FSP_PKT_TYPE_SHIFT	(6)
 
+/* bit definitions for the first byte of report packet */
+#define	FSP_PB0_LBTN		BIT(0)
+#define	FSP_PB0_RBTN		BIT(1)
+#define	FSP_PB0_MBTN		BIT(2)
+#define	FSP_PB0_MFMC_FGR2	FSP_PB0_MBTN
+#define	FSP_PB0_MUST_SET	BIT(3)
+#define	FSP_PB0_PHY_BTN		BIT(4)
+#define	FSP_PB0_MFMC		BIT(5)
+
 /* hardware revisions */
 #define	FSP_VER_STL3888_A4	(0xC1)
 #define	FSP_VER_STL3888_B0	(0xD0)
@@ -89,6 +108,7 @@ struct fsp_data {
 
 	unsigned char	last_reg;	/* Last register we requested read from */
 	unsigned char	last_val;
+	unsigned int	last_mt_fgr;	/* Last seen finger(multitouch) */
 };
 
 #ifdef CONFIG_MOUSE_PS2_SENTELIC
-- 
1.7.9.1

