Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1EFAyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:54:46 -0400
Received: from kroah.org ([198.145.64.141]:36791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab1EFAYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.506130982@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [054/143] Input: elantech - use all 3 bytes when checking version
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 504e8beed161bd11a2c6cbb8aaf352c14d39b5bb upstream.

Apparently all 3 bytes returned by ETP_FW_VERSION_QUERY are significant
and should be taken into account when matching hardware version/features.

Tested-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |   24 ++++++++++++------------
 drivers/input/mouse/elantech.h |    5 ++---
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -184,7 +184,7 @@ static void elantech_report_absolute_v1(
 	int fingers;
 	static int old_fingers;
 
-	if (etd->fw_version_maj == 0x01) {
+	if (etd->fw_version < 0x020000) {
 		/*
 		 * byte 0:  D   U  p1  p2   1  p3   R   L
 		 * byte 1:  f   0  th  tw  x9  x8  y9  y8
@@ -226,7 +226,7 @@ static void elantech_report_absolute_v1(
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
 	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 
-	if ((etd->fw_version_maj == 0x01) &&
+	if (etd->fw_version < 0x020000 &&
 	    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
 		/* rocker up */
 		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40);
@@ -320,7 +320,7 @@ static int elantech_check_parity_v1(stru
 	unsigned char p1, p2, p3;
 
 	/* Parity bits are placed differently */
-	if (etd->fw_version_maj == 0x01) {
+	if (etd->fw_version < 0x020000) {
 		/* byte 0:  D   U  p1  p2   1  p3   R   L */
 		p1 = (packet[0] & 0x20) >> 5;
 		p2 = (packet[0] & 0x10) >> 4;
@@ -456,7 +456,7 @@ static void elantech_set_input_params(st
 	switch (etd->hw_version) {
 	case 1:
 		/* Rocker button */
-		if ((etd->fw_version_maj == 0x01) &&
+		if (etd->fw_version < 0x020000 &&
 		    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
 			__set_bit(BTN_FORWARD, dev->keybit);
 			__set_bit(BTN_BACK, dev->keybit);
@@ -685,15 +685,14 @@ int elantech_init(struct psmouse *psmous
 		pr_err("elantech.c: failed to query firmware version.\n");
 		goto init_fail;
 	}
-	etd->fw_version_maj = param[0];
-	etd->fw_version_min = param[2];
+
+	etd->fw_version = (param[0] << 16) | (param[1] << 8) | param[2];
 
 	/*
 	 * Assume every version greater than this is new EeePC style
 	 * hardware with 6 byte packets
 	 */
-	if ((etd->fw_version_maj == 0x02 && etd->fw_version_min >= 0x30) ||
-	    etd->fw_version_maj > 0x02) {
+	if (etd->fw_version >= 0x020030) {
 		etd->hw_version = 2;
 		/* For now show extra debug information */
 		etd->debug = 1;
@@ -703,8 +702,9 @@ int elantech_init(struct psmouse *psmous
 		etd->hw_version = 1;
 		etd->paritycheck = 1;
 	}
-	pr_info("elantech.c: assuming hardware version %d, firmware version %d.%d\n",
-		etd->hw_version, etd->fw_version_maj, etd->fw_version_min);
+
+	pr_info("elantech.c: assuming hardware version %d, firmware version %d.%d.%d\n",
+		etd->hw_version, param[0], param[1], param[2]);
 
 	if (synaptics_send_cmd(psmouse, ETP_CAPABILITIES_QUERY, param)) {
 		pr_err("elantech.c: failed to query capabilities.\n");
@@ -719,8 +719,8 @@ int elantech_init(struct psmouse *psmous
 	 * a touch action starts causing the mouse cursor or scrolled page
 	 * to jump. Enable a workaround.
 	 */
-	if (etd->fw_version_maj == 0x02 && etd->fw_version_min == 0x22) {
-		pr_info("elantech.c: firmware version 2.34 detected, "
+	if (etd->fw_version == 0x020022) {
+		pr_info("elantech.c: firmware version 2.0.34 detected, "
 			"enabling jumpy cursor workaround\n");
 		etd->jumpy_cursor = 1;
 	}
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -100,11 +100,10 @@ struct elantech_data {
 	unsigned char reg_26;
 	unsigned char debug;
 	unsigned char capabilities;
-	unsigned char fw_version_maj;
-	unsigned char fw_version_min;
-	unsigned char hw_version;
 	unsigned char paritycheck;
 	unsigned char jumpy_cursor;
+	unsigned char hw_version;
+	unsigned int  fw_version;
 	unsigned char parity[256];
 };
 


