Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2IDPKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:45 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:11976 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2IDPKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZiTOJTA
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821824"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 11/16] Staging: ipack: Move device ids from ipoctal.c to ipack_ids.h.
Date: Tue,  4 Sep 2012 17:01:16 +0200
Message-Id: <1346770881-4723-12-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Rename them in the process.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   26 +++++++++++---------------
 drivers/staging/ipack/ipack_ids.h       |    5 +++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index c1d0c00..ed08864 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -25,11 +25,6 @@
 #include "ipoctal.h"
 #include "scc2698.h"
 
-#define IP_OCTAL_MANUFACTURER_ID    0xF0
-#define IP_OCTAL_232_ID             0x22
-#define IP_OCTAL_422_ID             0x2A
-#define IP_OCTAL_485_ID             0x48
-
 #define IP_OCTAL_ID_SPACE_VECTOR    0x41
 #define IP_OCTAL_NB_BLOCKS          4
 
@@ -231,7 +226,7 @@ static int ipoctal_irq_handler(void *arg)
 		/* In case of RS-485, change from TX to RX when finishing TX.
 		 * Half-duplex.
 		 */
-		if ((ipoctal->board_id == IP_OCTAL_485_ID) &&
+		if ((ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) &&
 		    (sr & SR_TX_EMPTY) &&
 		    (ipoctal->nb_bytes[channel] == 0)) {
 			ipoctal_write_io_reg(ipoctal,
@@ -304,7 +299,7 @@ static int ipoctal_irq_handler(void *arg)
 			if ((ipoctal->nb_bytes[channel] == 0) &&
 			    (waitqueue_active(&ipoctal->queue[channel]))) {
 
-				if (ipoctal->board_id != IP_OCTAL_485_ID) {
+				if (ipoctal->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 					ipoctal->write = 1;
 					wake_up_interruptible(&ipoctal->queue[channel]);
 				}
@@ -322,15 +317,16 @@ static int ipoctal_check_model(struct ipack_device *dev, unsigned char *id)
 	unsigned char manufacturerID;
 	unsigned char board_id;
 
+
 	manufacturerID = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MANUFACTURER_ID);
-	if (manufacturerID != IP_OCTAL_MANUFACTURER_ID)
+	if (manufacturerID != IPACK1_VENDOR_ID_SBS)
 		return -ENODEV;
 
 	board_id = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MODEL);
 	switch (board_id) {
-	case IP_OCTAL_232_ID:
-	case IP_OCTAL_422_ID:
-	case IP_OCTAL_485_ID:
+	case IPACK1_DEVICE_ID_SBS_OCTAL_232:
+	case IPACK1_DEVICE_ID_SBS_OCTAL_422:
+	case IPACK1_DEVICE_ID_SBS_OCTAL_485:
 		*id = board_id;
 		break;
 	default:
@@ -543,7 +539,7 @@ static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel,
 	ipoctal_copy_write_buffer(ipoctal, channel, buf, count);
 
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
-	if (ipoctal->board_id == IP_OCTAL_485_ID) {
+	if (ipoctal->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 		ipoctal_write_io_reg(ipoctal,
 				     &ipoctal->chan_regs[channel].w.cr,
 				     CR_DISABLE_RX);
@@ -654,7 +650,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 
 	/* Set the flow control */
 	switch (ipoctal->board_id) {
-	case IP_OCTAL_232_ID:
+	case IPACK1_DEVICE_ID_SBS_OCTAL_232:
 		if (cflag & CRTSCTS) {
 			mr1 |= MR1_RxRTS_CONTROL_ON;
 			mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_ON;
@@ -663,11 +659,11 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 			mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_OFF;
 		}
 		break;
-	case IP_OCTAL_422_ID:
+	case IPACK1_DEVICE_ID_SBS_OCTAL_422:
 		mr1 |= MR1_RxRTS_CONTROL_OFF;
 		mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_OFF;
 		break;
-	case IP_OCTAL_485_ID:
+	case IPACK1_DEVICE_ID_SBS_OCTAL_485:
 		mr1 |= MR1_RxRTS_CONTROL_OFF;
 		mr2 |= MR2_TxRTS_CONTROL_ON | MR2_CTS_ENABLE_TX_OFF;
 		break;
diff --git a/drivers/staging/ipack/ipack_ids.h b/drivers/staging/ipack/ipack_ids.h
index ba85ec5..8153fee 100644
--- a/drivers/staging/ipack/ipack_ids.h
+++ b/drivers/staging/ipack/ipack_ids.h
@@ -25,3 +25,8 @@
 #define IPACK1_VENDOR_ID_UNREGISTRED13	0x0D
 #define IPACK1_VENDOR_ID_UNREGISTRED14	0x0E
 #define IPACK1_VENDOR_ID_UNREGISTRED15	0x0F
+
+#define IPACK1_VENDOR_ID_SBS            0xF0
+#define IPACK1_DEVICE_ID_SBS_OCTAL_232  0x22
+#define IPACK1_DEVICE_ID_SBS_OCTAL_422  0x2A
+#define IPACK1_DEVICE_ID_SBS_OCTAL_485  0x48
-- 
1.7.10.4

