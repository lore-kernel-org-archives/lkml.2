Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2CWEAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:00:23 -0400
Received: from hermod.sentelic.com ([203.69.18.19]:5644 "EHLO
	hermod.sentelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2CWEAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:00:15 -0400
From: Tai-hwa Liang <avatar@sentelic.com>
To: Oskari Saarenmaa <os@ohmu.fi>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] Input: sentelic - enabling hardware supported gesture ID output
Date: Fri, 23 Mar 2012 11:52:19 +0800
Message-Id: <1332474741-19426-4-git-send-email-avatar@sentelic.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
References: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling on-chip gesture processing mode and send the result to the user
land through MSC_GESTURE event.  This event could be useful for 3rd party
applications.

Signed-off-by: Tai-hwa Liang <avatar@sentelic.com>
---
 drivers/input/mouse/sentelic.c |   38 +++++++++++++++++++-
 drivers/input/mouse/sentelic.h |   73 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 43d839a..0b57fe4 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -661,8 +661,9 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 	struct input_dev *dev = psmouse->dev;
 	struct fsp_data *ad = psmouse->private;
 	unsigned char *packet = psmouse->packet;
-	unsigned char button_status = 0, lscroll = 0, rscroll = 0;
+	unsigned char button_status = 0;
 	unsigned short abs_x, abs_y, fgrs = 0;
+	unsigned short vscroll = 0, hscroll = 0, lscroll = 0, rscroll = 0;
 	int rel_x, rel_y;
 
 	if (psmouse->pktcnt < 4)
@@ -673,6 +674,33 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 	 */
 
 	switch (psmouse->packet[0] >> FSP_PKT_TYPE_SHIFT) {
+	case FSP_PKT_TYPE_NOTIFY:
+		if (packet[1] != FSP_NOTIFY_MSG_GID)
+			break;	/* unsupported message types */
+
+		switch (packet[2]) {
+		case FSP_GID_SP_UP:
+			vscroll =  1;
+			break;
+		case FSP_GID_SP_DOWN:
+			vscroll = -1;
+			break;
+		case FSP_GID_SP_LEFT:
+			hscroll =  1;
+			break;
+		case FSP_GID_SP_RIGHT:
+			hscroll = -1;
+			break;
+		default:
+			dev_dbg(&psmouse->ps2dev.serio->dev,
+				"GID 0x%x\n", packet[2]);
+			break;
+		}
+		input_report_rel(dev, REL_WHEEL, vscroll);
+		input_report_rel(dev, REL_HWHEEL, hscroll);
+		input_event(dev, EV_MSC, MSC_GESTURE, packet[2]);
+		break;
+
 	case FSP_PKT_TYPE_ABS:
 		abs_x = (packet[1] << 2) | ((packet[3] >> 2) & 0x03);
 		abs_y = (packet[2] << 2) | (packet[3] & 0x03);
@@ -861,9 +889,12 @@ static int fsp_activate_protocol(struct psmouse *psmouse)
 		/* Enable absolute coordinates output for Cx/Dx hardware */
 		if (fsp_reg_write(psmouse, FSP_REG_SWC1,
 				  FSP_BIT_SWC1_EN_ABS_1F |
+				  FSP_BIT_SWC1_EN_GID |
 				  FSP_BIT_SWC1_EN_ABS_2F |
 				  FSP_BIT_SWC1_EN_FUP_OUT |
-				  FSP_BIT_SWC1_EN_ABS_CON)) {
+				  FSP_BIT_SWC1_EN_ABS_CON |
+				  FSP_BIT_SWC1_GST_GRP0 |
+				  FSP_BIT_SWC1_GST_GRP1)) {
 			dev_err(&psmouse->ps2dev.serio->dev,
 				"Unable to enable absolute coordinates output.\n");
 			return -EIO;
@@ -910,6 +941,9 @@ static int fsp_set_input_params(struct psmouse *psmouse)
 		input_mt_init_slots(dev, 2);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, 0, abs_x, 0, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_Y, 0, abs_y, 0, 0);
+
+		/* device generated gesture ID events */
+		input_set_capability(dev, EV_MSC, MSC_GESTURE);
 	}
 
 	return 0;
diff --git a/drivers/input/mouse/sentelic.h b/drivers/input/mouse/sentelic.h
index 334de19..0cd0efb 100644
--- a/drivers/input/mouse/sentelic.h
+++ b/drivers/input/mouse/sentelic.h
@@ -83,6 +83,79 @@
 #define	FSP_PB0_PHY_BTN		BIT(4)
 #define	FSP_PB0_MFMC		BIT(5)
 
+/* notification message types */
+#define	FSP_NOTIFY_MSG_GID	(0xba)
+#define	FSP_NOTIFY_MSG_HX_GST	(0xc0)
+
+/* gesture IDs */
+/** GID for 2F Straight Up             */
+#define	FSP_GID_SP1		(0x86)
+#define	FSP_GID_SP_UP		FSP_GID_SP1
+
+/** GID for 2F Straight Down           */
+#define	FSP_GID_SP5		(0x82)
+#define	FSP_GID_SP_DOWN		FSP_GID_SP5
+
+/** GID for 2F Straight Right          */
+#define	FSP_GID_SP2		(0x80)
+#define	FSP_GID_SP_RIGHT	FSP_GID_SP2
+
+/** GID for 2F Straight Left           */
+#define	FSP_GID_SP6		(0x84)
+#define	FSP_GID_SP_LEFT		FSP_GID_SP6
+
+/** GID for 2F Zoom In                 */
+#define	FSP_GID_SC6		(0x8F)
+#define	FSP_GID_SC_ZOOM_IN	FSP_GID_SC6
+
+/** GID for 2F Zoom Out                */
+#define	FSP_GID_SC3		(0x8B)
+#define	FSP_GID_SC_ZOOM_OUT	FSP_GID_SC3
+
+/** GID for 2F Curve CW                */
+#define	FSP_GID_DC1		(0xC4)
+#define	FSP_GID_DC_ROT_CW	FSP_GID_DC1
+
+/** GID for 2F Curve CCW               */
+#define	FSP_GID_DC2		(0xC0)
+#define	FSP_GID_DC_ROT_CCW	FSP_GID_DC2
+
+/** GID for 3F Straight Up             */
+#define	FSP_GID_TS4		(0x2E)
+#define	FSP_GID_TS_UP		FSP_GID_TS4
+
+/** GID for 3F Straight Down           */
+#define	FSP_GID_TS2		(0x2A)
+#define	FSP_GID_TS_DOWN		FSP_GID_TS2
+
+/** GID for 3F Straight Right          */
+#define	FSP_GID_TS1		(0x28)
+#define	FSP_GID_TS_RIGHT	FSP_GID_TS1
+
+/** GID for 3F Straight Left           */
+#define	FSP_GID_TS3		(0x2C)
+#define	FSP_GID_TS_LEFT		FSP_GID_TS3
+
+/** GID for 2F Click                   */
+#define	FSP_GID_DF1		(0x11)
+#define	FSP_GID_DF_CLICK	FSP_GID_DF1
+
+/** GID for 2F Double Click            */
+#define	FSP_GID_DF2		(0x12)
+#define	FSP_GID_DF_DBLCLICK	FSP_GID_DF2
+
+/** GID for 3F Click                   */
+#define	FSP_GID_TF1		(0x19)
+#define	FSP_GID_TF_CLICK	FSP_GID_TF1
+
+/** GID for 3F Double Click            */
+#define	FSP_GID_TF2		(0x1A)
+#define	FSP_GID_TF_DBLCLICK	FSP_GID_TF2
+
+/** GID for Palm                       */
+#define	FSP_GID_PM1		(0x38)
+#define	FSP_GID_PALM		FSP_GID_PM1
+
 /* hardware revisions */
 #define	FSP_VER_STL3888_A4	(0xC1)
 #define	FSP_VER_STL3888_B0	(0xD0)
-- 
1.7.9.1

