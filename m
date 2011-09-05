Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1IECPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:15:17 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:3203 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1IECOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:14:41 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?UTF-8?q?=C3=89ric=20Piel?= <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH v5 5/8] Input: elantech - packet checking for v2 hardware
Date: Mon,  5 Sep 2011 10:16:44 +0800
Message-Id: <1315189007-2179-6-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
References: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v2 hardware, there is no real parity check, but we can still check
some constant bits for data integrity.

Also rename elantech_check_parity_v1 to elantech_packet_check_v1 to make
these packet checking function names consistent.

Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
Acked-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/input/mouse/elantech.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 282b8b6..008e8c2 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -350,7 +350,7 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 	input_sync(dev);
 }
 
-static int elantech_check_parity_v1(struct psmouse *psmouse)
+static int elantech_packet_check_v1(struct psmouse *psmouse)
 {
 	struct elantech_data *etd = psmouse->private;
 	unsigned char *packet = psmouse->packet;
@@ -374,6 +374,34 @@ static int elantech_check_parity_v1(struct psmouse *psmouse)
 	       etd->parity[packet[3]] == p3;
 }
 
+static int elantech_packet_check_v2(struct psmouse *psmouse)
+{
+	struct elantech_data *etd = psmouse->private;
+	unsigned char *packet = psmouse->packet;
+
+	/*
+	 * V2 hardware has two flavors. Older ones that do not report pressure,
+	 * and newer ones that reports pressure and width. With newer ones, all
+	 * packets (1, 2, 3 finger touch) have the same constant bits. With
+	 * older ones, 1/3 finger touch packets and 2 finger touch packets
+	 * have different constant bits.
+	 * With all three cases, if the constant bits are not exactly what I
+	 * expected, I consider them invalid.
+	 */
+	if (etd->reports_pressure)
+		return (packet[0] & 0x0c) == 0x04 &&
+		       (packet[3] & 0x0f) == 0x02;
+
+	if ((packet[0] & 0xc0) == 0x80)
+		return (packet[0] & 0x0c) == 0x0c &&
+		       (packet[3] & 0x0e) == 0x08;
+
+	return (packet[0] & 0x3c) == 0x3c &&
+	       (packet[1] & 0xf0) == 0x00 &&
+	       (packet[3] & 0x3e) == 0x38 &&
+	       (packet[4] & 0xf0) == 0x00;
+}
+
 /*
  * Process byte stream from mouse and handle complete packets
  */
@@ -389,14 +417,16 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
 
 	switch (etd->hw_version) {
 	case 1:
-		if (etd->paritycheck && !elantech_check_parity_v1(psmouse))
+		if (etd->paritycheck && !elantech_packet_check_v1(psmouse))
 			return PSMOUSE_BAD_DATA;
 
 		elantech_report_absolute_v1(psmouse);
 		break;
 
 	case 2:
-		/* We don't know how to check parity in protocol v2 */
+		if (etd->paritycheck && !elantech_packet_check_v2(psmouse))
+			return PSMOUSE_BAD_DATA;
+
 		elantech_report_absolute_v2(psmouse);
 		break;
 	}
@@ -795,8 +825,7 @@ int elantech_init(struct psmouse *psmouse)
 		etd->hw_version = 2;
 		/* For now show extra debug information */
 		etd->debug = 1;
-		/* Don't know how to do parity checking for version 2 */
-		etd->paritycheck = 0;
+		etd->paritycheck = 1;
 
 		if (etd->fw_version >= 0x020800)
 			etd->reports_pressure = true;
-- 
1.7.4.1

