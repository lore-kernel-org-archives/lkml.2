Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2CWEBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:01:12 -0400
Received: from hermod.sentelic.com ([203.69.18.19]:32977 "EHLO
	hermod.sentelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2CWEAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:00:09 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2012 00:00:06 EDT
From: Tai-hwa Liang <avatar@sentelic.com>
To: Oskari Saarenmaa <os@ohmu.fi>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] Input: sentelic - improving packet debugging information
Date: Fri, 23 Mar 2012 11:52:21 +0800
Message-Id: <1332474741-19426-6-git-send-email-avatar@sentelic.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
References: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskari Saarenmaa <os@ohmu.fi>

Incorporating detail message submitted by Oskari Saarenmaa <os@ohmu.fi>.
Whilst here, also converting a few common absolute coordinate extraction
code into macros.

Signed-off-by: Oskari Saarenmaa <os@ohmu.fi>
Signed-off-by: Tai-hwa Liang <avatar@sentelic.com>
---
 drivers/input/mouse/sentelic.c |   43 +++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 4fe9474..6838829 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -37,6 +37,9 @@
 #define	FSP_CMD_TIMEOUT		200
 #define	FSP_CMD_TIMEOUT2	30
 
+#define	GET_ABS_X(packet)	((packet[1] << 2) | ((packet[3] >> 2) & 0x03))
+#define	GET_ABS_Y(packet)	((packet[2] << 2) | (packet[3] & 0x03))
+
 /** Driver version. */
 static const char fsp_drv_ver[] = "1.0.0-K";
 
@@ -620,18 +623,40 @@ static struct attribute_group fsp_attribute_group = {
 	.attrs = fsp_attributes,
 };
 
-#ifdef FSP_DEBUG
-static void fsp_packet_debug(unsigned char packet[])
+#ifdef	FSP_DEBUG
+static void fsp_packet_debug(struct psmouse *psmouse, unsigned char packet[])
 {
 	static unsigned int ps2_packet_cnt;
 	static unsigned int ps2_last_second;
 	unsigned int jiffies_msec;
+	const char *packet_type = "UNKNOWN";
+	unsigned short abs_x = 0, abs_y = 0;
+
+	/* Interpret & dump the packet data. */
+	switch (packet[0] >> FSP_PKT_TYPE_SHIFT) {
+	case FSP_PKT_TYPE_ABS:
+		packet_type = "Absolute";
+		abs_x = GET_ABS_X(packet);
+		abs_y = GET_ABS_Y(packet);
+		break;
+	case FSP_PKT_TYPE_NORMAL:
+		packet_type = "Normal";
+		break;
+	case FSP_PKT_TYPE_NOTIFY:
+		packet_type = "Notify";
+		break;
+	case FSP_PKT_TYPE_NORMAL_OPC:
+		packet_type = "Normal-OPC";
+		break;
+	}
 
 	ps2_packet_cnt++;
 	jiffies_msec = jiffies_to_msecs(jiffies);
 	psmouse_dbg(psmouse,
-		    "%08dms PS/2 packets: %02x, %02x, %02x, %02x\n",
-		    jiffies_msec, packet[0], packet[1], packet[2], packet[3]);
+		    "%08dms %s packets: %02x, %02x, %02x, %02x; "
+		    "abs_x: %d, abs_y: %d\n",
+		    jiffies_msec, packet_type,
+		    packet[0], packet[1], packet[2], packet[3], abs_x, abs_y);
 
 	if (jiffies_msec - ps2_last_second > 1000) {
 		psmouse_dbg(psmouse, "PS/2 packets/sec = %d\n", ps2_packet_cnt);
@@ -640,7 +665,7 @@ static void fsp_packet_debug(unsigned char packet[])
 	}
 }
 #else
-static void fsp_packet_debug(unsigned char packet[])
+static void fsp_packet_debug(struct psmouse *psmouse, unsigned char packet[])
 {
 }
 #endif
@@ -673,6 +698,8 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 	 * Full packet accumulated, process it
 	 */
 
+	fsp_packet_debug(psmouse, packet);
+
 	switch (psmouse->packet[0] >> FSP_PKT_TYPE_SHIFT) {
 	case FSP_PKT_TYPE_NOTIFY:
 		if (packet[1] != FSP_NOTIFY_MSG_GID)
@@ -702,8 +729,8 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 		break;
 
 	case FSP_PKT_TYPE_ABS:
-		abs_x = (packet[1] << 2) | ((packet[3] >> 2) & 0x03);
-		abs_y = (packet[2] << 2) | (packet[3] & 0x03);
+		abs_x = GET_ABS_X(packet);
+		abs_y = GET_ABS_Y(packet);
 
 		if (packet[0] & FSP_PB0_MFMC) {
 			/*
@@ -814,8 +841,6 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 
 	input_sync(dev);
 
-	fsp_packet_debug(packet);
-
 	return PSMOUSE_FULL_PACKET;
 }
 
-- 
1.7.9.1

