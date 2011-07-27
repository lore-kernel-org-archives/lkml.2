Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1G0Aha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:37:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:60783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1G0AfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32659421"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: E.A.B.Piel@tudelft.nl, eric.piel@tremplin-utc.net, dtor@mail.ru,
        ak@linux.intel.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [31/98] Input: elantech - discard the first 2 positions on some firmwares
Message-Id: <20110727003523.82D4B2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Éric Piel <eric.piel@tremplin-utc.net>

commit 7f29f17b57255b6395046805a98bc663ded63fb8 upstream.

According to the Dell/Ubuntu driver, what was previously observed as
"jumpy cursor" corresponds to the hardware sending incorrect data for
the first two reports of a one touch finger. So let's use the same
workaround as in the other driver. Also, detect another firmware
version with the same behaviour, as in the other driver.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[bwh: Adjust for 2.6.32]
[ak: adjust for 2.6.35]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |   21 ++++++++++-----------
 drivers/input/mouse/elantech.h |    7 ++++---
 2 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6.35.y/drivers/input/mouse/elantech.c
===================================================================
--- linux-2.6.35.y.orig/drivers/input/mouse/elantech.c
+++ linux-2.6.35.y/drivers/input/mouse/elantech.c
@@ -185,7 +185,6 @@ static void elantech_report_absolute_v1(
 	struct elantech_data *etd = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 	int fingers;
-	static int old_fingers;
 
 	if (etd->fw_version < 0x020000) {
 		/*
@@ -203,11 +202,14 @@ static void elantech_report_absolute_v1(
 	}
 
 	if (etd->jumpy_cursor) {
-		/* Discard packets that are likely to have bogus coordinates */
-		if (fingers > old_fingers) {
-			elantech_debug("discarding packet\n");
-			goto discard_packet_v1;
-		}
+		if (fingers != 1) {
+			etd->single_finger_reports = 0;
+		} else if (etd->single_finger_reports < 2) {
+			/* Discard first 2 reports of one finger, bogus */
+			etd->single_finger_reports++;
+ 			elantech_debug("elantech.c: discarding packet\n");
+			return;
+ 		}
 	}
 
 	input_report_key(dev, BTN_TOUCH, fingers != 0);
@@ -238,9 +240,6 @@ static void elantech_report_absolute_v1(
 	}
 
 	input_sync(dev);
-
- discard_packet_v1:
-	old_fingers = fingers;
 }
 
 /*
@@ -733,13 +732,14 @@ int elantech_init(struct psmouse *psmous
 	etd->capabilities = param[0];
 
 	/*
-	 * This firmware seems to suffer from misreporting coordinates when
+	 * This firmware suffers from misreporting coordinates when
 	 * a touch action starts causing the mouse cursor or scrolled page
 	 * to jump. Enable a workaround.
 	 */
-	if (etd->fw_version == 0x020022) {
-		pr_info("firmware version 2.0.34 detected, enabling jumpy cursor workaround\n");
-		etd->jumpy_cursor = 1;
+	if (etd->fw_version == 0x020022 || etd->fw_version == 0x020600) {
+		pr_info("elantech.c: firmware version 2.0.34/2.6.0 detected, "
+			"enabling jumpy cursor workaround\n");
+		etd->jumpy_cursor = true;
 	}
 
 	if (elantech_set_absolute_mode(psmouse)) {
Index: linux-2.6.35.y/drivers/input/mouse/elantech.h
===================================================================
--- linux-2.6.35.y.orig/drivers/input/mouse/elantech.h
+++ linux-2.6.35.y/drivers/input/mouse/elantech.h
@@ -100,10 +100,11 @@ struct elantech_data {
 	unsigned char reg_26;
 	unsigned char debug;
 	unsigned char capabilities;
-	unsigned char paritycheck;
-	unsigned char jumpy_cursor;
+	bool paritycheck;
+	bool jumpy_cursor;
 	unsigned char hw_version;
-	unsigned int  fw_version;
+	unsigned int fw_version;
+	unsigned int single_finger_reports;
 	unsigned char parity[256];
 };
 
