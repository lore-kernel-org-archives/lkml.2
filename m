Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2CWEBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:01:08 -0400
Received: from hermod.sentelic.com ([203.69.18.19]:26607 "EHLO
	hermod.sentelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2CWEAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:00:09 -0400
From: Tai-hwa Liang <avatar@sentelic.com>
To: Oskari Saarenmaa <os@ohmu.fi>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] Input: sentelic - code refactorying for upcoming new hardware support
Date: Fri, 23 Mar 2012 11:52:17 +0800
Message-Id: <1332474741-19426-2-git-send-email-avatar@sentelic.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
References: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Moving event bits setup code to a separated function,
  fsp_set_input_params(), such that we can perform hardware specific settings
  in the future;
- Taking hardware version information into account when activating
  protocol;
- Removing button information from boot message as it's somewhat confusing
  and is only for internal processing.  Whilst here, also moving button
  retrieving code to be a part of protocol activation process.

Signed-off-by: Tai-hwa Liang <avatar@sentelic.com>
---
 drivers/input/mouse/sentelic.c |  106 +++++++++++++++++++++++----------------
 drivers/input/mouse/sentelic.h |   13 +++++-
 2 files changed, 74 insertions(+), 45 deletions(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index e36847d..0ce090b 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -745,37 +745,64 @@ static int fsp_activate_protocol(struct psmouse *psmouse)
 		return -EIO;
 	}
 
-	if (fsp_reg_read(psmouse, FSP_REG_SYSCTL5, &val)) {
-		dev_err(&psmouse->ps2dev.serio->dev,
-			"Unable to read SYSCTL5 register.\n");
-		return -EIO;
-	}
+	if (pad->ver < FSP_VER_STL3888_C0) {
+		/* Preparing relative coordinates output for older hardware */
+		if (fsp_reg_read(psmouse, FSP_REG_SYSCTL5, &val)) {
+			dev_err(&psmouse->ps2dev.serio->dev,
+				"Unable to read SYSCTL5 register.\n");
+			return -EIO;
+		}
 
-	val &= ~(FSP_BIT_EN_MSID7 | FSP_BIT_EN_MSID8 | FSP_BIT_EN_AUTO_MSID8);
-	/* Ensure we are not in absolute mode */
-	val &= ~FSP_BIT_EN_PKT_G0;
-	if (pad->buttons == 0x06) {
-		/* Left/Middle/Right & Scroll Up/Down/Right/Left */
-		val |= FSP_BIT_EN_MSID6;
-	}
+		if (fsp_get_buttons(psmouse, &pad->buttons)) {
+			dev_err(&psmouse->ps2dev.serio->dev,
+				"Unable to retrieve number of buttons.\n");
+			return -EIO;
+		}
 
-	if (fsp_reg_write(psmouse, FSP_REG_SYSCTL5, val)) {
-		dev_err(&psmouse->ps2dev.serio->dev,
-			"Unable to set up required mode bits.\n");
-		return -EIO;
+		val &= ~(FSP_BIT_EN_MSID7 | FSP_BIT_EN_MSID8 | FSP_BIT_EN_AUTO_MSID8);
+		/* Ensure we are not in absolute mode */
+		val &= ~FSP_BIT_EN_PKT_G0;
+		if (pad->buttons == 0x06) {
+			/* Left/Middle/Right & Scroll Up/Down/Right/Left */
+			val |= FSP_BIT_EN_MSID6;
+		}
+
+		if (fsp_reg_write(psmouse, FSP_REG_SYSCTL5, val)) {
+			dev_err(&psmouse->ps2dev.serio->dev,
+				"Unable to set up required mode bits.\n");
+			return -EIO;
+		}
+
+		/*
+		 * Enable OPC tags such that driver can tell the difference
+		 * between on-pad and real button click
+		 */
+		if (fsp_opc_tag_enable(psmouse, true))
+			dev_warn(&psmouse->ps2dev.serio->dev,
+				 "Failed to enable OPC tag mode.\n");
+		/* enable on-pad click by default */
+		pad->flags |= FSPDRV_FLAG_EN_OPC;
+
+		/* Enable on-pad vertical and horizontal scrolling */
+		fsp_onpad_vscr(psmouse, true);
+		fsp_onpad_hscr(psmouse, true);
 	}
 
-	/*
-	 * Enable OPC tags such that driver can tell the difference between
-	 * on-pad and real button click
-	 */
-	if (fsp_opc_tag_enable(psmouse, true))
-		dev_warn(&psmouse->ps2dev.serio->dev,
-			 "Failed to enable OPC tag mode.\n");
+	return 0;
+}
+
+static int fsp_set_input_params(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct fsp_data *pad = psmouse->private;
 
-	/* Enable on-pad vertical and horizontal scrolling */
-	fsp_onpad_vscr(psmouse, true);
-	fsp_onpad_hscr(psmouse, true);
+	if (pad->ver < FSP_VER_STL3888_C0) {
+		__set_bit(BTN_MIDDLE, dev->keybit);
+		__set_bit(BTN_BACK, dev->keybit);
+		__set_bit(BTN_FORWARD, dev->keybit);
+		__set_bit(REL_WHEEL, dev->relbit);
+		__set_bit(REL_HWHEEL, dev->relbit);
+	}
 
 	return 0;
 }
@@ -833,18 +860,16 @@ static int fsp_reconnect(struct psmouse *psmouse)
 int fsp_init(struct psmouse *psmouse)
 {
 	struct fsp_data *priv;
-	int ver, rev, buttons;
+	int ver, rev;
 	int error;
 
 	if (fsp_get_version(psmouse, &ver) ||
-	    fsp_get_revision(psmouse, &rev) ||
-	    fsp_get_buttons(psmouse, &buttons)) {
+	    fsp_get_revision(psmouse, &rev)) {
 		return -ENODEV;
 	}
 
-	psmouse_info(psmouse,
-		     "Finger Sensing Pad, hw: %d.%d.%d, sw: %s, buttons: %d\n",
-		     ver >> 4, ver & 0x0F, rev, fsp_drv_ver, buttons & 7);
+	psmouse_info(psmouse, "Finger Sensing Pad, hw: %d.%d.%d, sw: %s\n",
+		     ver >> 4, ver & 0x0F, rev, fsp_drv_ver);
 
 	psmouse->private = priv = kzalloc(sizeof(struct fsp_data), GFP_KERNEL);
 	if (!priv)
@@ -852,17 +877,6 @@ int fsp_init(struct psmouse *psmouse)
 
 	priv->ver = ver;
 	priv->rev = rev;
-	priv->buttons = buttons;
-
-	/* enable on-pad click by default */
-	priv->flags |= FSPDRV_FLAG_EN_OPC;
-
-	/* Set up various supported input event bits */
-	__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
-	__set_bit(BTN_BACK, psmouse->dev->keybit);
-	__set_bit(BTN_FORWARD, psmouse->dev->keybit);
-	__set_bit(REL_WHEEL, psmouse->dev->relbit);
-	__set_bit(REL_HWHEEL, psmouse->dev->relbit);
 
 	psmouse->protocol_handler = fsp_process_byte;
 	psmouse->disconnect = fsp_disconnect;
@@ -870,11 +884,15 @@ int fsp_init(struct psmouse *psmouse)
 	psmouse->cleanup = fsp_reset;
 	psmouse->pktsize = 4;
 
-	/* set default packet output based on number of buttons we found */
 	error = fsp_activate_protocol(psmouse);
 	if (error)
 		goto err_out;
 
+	/* Set up various supported input event bits */
+	error = fsp_set_input_params(psmouse);
+	if (error)
+		goto err_out;
+
 	error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
 				   &fsp_attribute_group);
 	if (error) {
diff --git a/drivers/input/mouse/sentelic.h b/drivers/input/mouse/sentelic.h
index 2e4af24..23bd25e 100644
--- a/drivers/input/mouse/sentelic.h
+++ b/drivers/input/mouse/sentelic.h
@@ -64,12 +64,23 @@
 #define	FSP_PKT_TYPE_NORMAL_OPC	(0x03)
 #define	FSP_PKT_TYPE_SHIFT	(6)
 
+/* hardware revisions */
+#define	FSP_VER_STL3888_A4	(0xC1)
+#define	FSP_VER_STL3888_B0	(0xD0)
+#define	FSP_VER_STL3888_B1	(0xD1)
+#define	FSP_VER_STL3888_B2	(0xD2)
+#define	FSP_VER_STL3888_C0	(0xE0)
+#define	FSP_VER_STL3888_C1	(0xE1)
+#define	FSP_VER_STL3888_D0	(0xE2)
+#define	FSP_VER_STL3888_D1	(0xE3)
+#define	FSP_VER_STL3888_E0	(0xE4)
+
 #ifdef __KERNEL__
 
 struct fsp_data {
 	unsigned char	ver;		/* hardware version */
 	unsigned char	rev;		/* hardware revison */
-	unsigned char	buttons;	/* Number of buttons */
+	unsigned int	buttons;	/* Number of buttons */
 	unsigned int	flags;
 #define	FSPDRV_FLAG_EN_OPC	(0x001)	/* enable on-pad clicking */
 
-- 
1.7.9.1

