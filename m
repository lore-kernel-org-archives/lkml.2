Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1EFAy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:54:26 -0400
Received: from kroah.org ([198.145.64.141]:36801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab1EFAYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.690436780@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [056/143] Input: elantech - discard the first 2 positions on some firmwares
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
[bwh: Adjust for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |   21 ++++++++++-----------
 drivers/input/mouse/elantech.h |    7 ++++---
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -182,7 +182,6 @@ static void elantech_report_absolute_v1(
 	struct elantech_data *etd = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 	int fingers;
-	static int old_fingers;
 
 	if (etd->fw_version < 0x020000) {
 		/*
@@ -200,10 +199,13 @@ static void elantech_report_absolute_v1(
 	}
 
 	if (etd->jumpy_cursor) {
-		/* Discard packets that are likely to have bogus coordinates */
-		if (fingers > old_fingers) {
+		if (fingers != 1) {
+			etd->single_finger_reports = 0;
+		} else if (etd->single_finger_reports < 2) {
+			/* Discard first 2 reports of one finger, bogus */
+			etd->single_finger_reports++;
 			elantech_debug("elantech.c: discarding packet\n");
-			goto discard_packet_v1;
+			return;
 		}
 	}
 
@@ -235,9 +237,6 @@ static void elantech_report_absolute_v1(
 	}
 
 	input_sync(dev);
-
- discard_packet_v1:
-	old_fingers = fingers;
 }
 
 /*
@@ -733,14 +732,14 @@ int elantech_init(struct psmouse *psmous
 	etd->capabilities = param[0];
 
 	/*
-	 * This firmware seems to suffer from misreporting coordinates when
+	 * This firmware suffers from misreporting coordinates when
 	 * a touch action starts causing the mouse cursor or scrolled page
 	 * to jump. Enable a workaround.
 	 */
-	if (etd->fw_version == 0x020022) {
-		pr_info("elantech.c: firmware version 2.0.34 detected, "
+	if (etd->fw_version == 0x020022 || etd->fw_version == 0x020600) {
+		pr_info("elantech.c: firmware version 2.0.34/2.6.0 detected, "
 			"enabling jumpy cursor workaround\n");
-		etd->jumpy_cursor = 1;
+		etd->jumpy_cursor = true;
 	}
 
 	if (elantech_set_absolute_mode(psmouse)) {
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
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
 


