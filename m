Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab2CMAq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:46:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:48272 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961Ab2CMAXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?=C3=89ric=20Piel?= <E.A.B.Piel@tudelft.nl>,
        =?UTF-8?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
        Dmitry Torokhov <dtor@mail.ru>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 116/196] Input: elantech - discard the first 2 positions on some firmwares
Date: Mon, 12 Mar 2012 20:20:29 -0400
Message-Id: <1331598109-31424-71-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Éric Piel <E.A.B.Piel@tudelft.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7f29f17b57255b6395046805a98bc663ded63fb8 upstream.

According to the Dell/Ubuntu driver, what was previously observed as
"jumpy cursor" corresponds to the hardware sending incorrect data for
the first two reports of a one touch finger. So let's use the same
workaround as in the other driver. Also, detect another firmware
version with the same behaviour, as in the other driver.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/input/mouse/elantech.c |   21 ++++++++++-----------
 drivers/input/mouse/elantech.h |    7 ++++---
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4400369..a0c19c2 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -183,7 +183,6 @@ static void elantech_report_absolute_v1(struct psmouse *psmouse)
 	struct elantech_data *etd = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 	int fingers;
-	static int old_fingers;
 
 	if (etd->fw_version < 0x020000) {
 		/*
@@ -201,10 +200,13 @@ static void elantech_report_absolute_v1(struct psmouse *psmouse)
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
 
@@ -236,9 +238,6 @@ static void elantech_report_absolute_v1(struct psmouse *psmouse)
 	}
 
 	input_sync(dev);
-
- discard_packet_v1:
-	old_fingers = fingers;
 }
 
 /*
@@ -734,14 +733,14 @@ int elantech_init(struct psmouse *psmouse)
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
diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
index ac57bde..aa4aac5 100644
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
 
-- 
1.7.9.3

