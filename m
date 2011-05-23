Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab1FATmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:42:50 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:18625 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab1FATmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:42:47 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=n2W5COKzyCYKBlY96L0A3my6r0xTlngINTUh0kppeyk= c=1 sm=1
 a=D9lEqAhTD9gA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=n3DLBDIp2lSvWb96zoUu4Q==:17 a=bl19pPN5vlf71qj6r6YA:9
 a=_NqjlWUz0_mv78HesXgA:7 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antonio Ospite <ospite@studenti.unina.it>,
        Marcin Tolysz <tolysz@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [PATCH 2/2] sony_ff_byteswap_accelerometer
Date: Mon, 23 May 2011 03:19:59 -0700
Message-Id: <1306145999-15643-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306145999-15643-1-git-send-email-simon@mungewell.org>
References: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com>
 <1306145999-15643-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The accelerometers/gyro on the sixaxis are reported in the wrong
endianness (ie. not compatible with HID), so this patch intercepts
the report and swaps the appropriate bytes over.

Accelerometers are scaled with a nominal value of +/-4000 = 1G,
maximum value would be around +/-32768 = 8G.

Gyro on my device always reports -32768, might need some calibration
set within the controller.
---
 drivers/hid/hid-sony.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 5c930dc..f219746 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -57,6 +57,24 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	return rdesc;
 }
 
+/* Sixaxis HID report has acclerometers/gyro with MSByte first, this has
+ * to be BYTE_SWAPPED before passing up to joystick interface
+ */
+static int sony_raw_event(struct hid_device *hdev, struct hid_report *report, __u8 *rd, int size)
+{
+	struct sony_sc *sc = hid_get_drvdata(hdev);
+
+	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
+			rd[0] == 0x01 && size == 49) {
+		swap(rd[41], rd[42]);
+		swap(rd[43], rd[44]);
+		swap(rd[45], rd[46]);
+		swap(rd[47], rd[48]);
+	}
+
+	return 0;
+}
+
 /*
  * The Sony Sixaxis does not handle HID Output Reports on the Interrupt EP
  * like it should according to usbhid/hid-core.c::usbhid_output_raw_report()
@@ -205,6 +223,7 @@ static struct hid_driver sony_driver = {
 	.probe = sony_probe,
 	.remove = sony_remove,
 	.report_fixup = sony_report_fixup,
+	.raw_event = sony_raw_event
 };
 
 static int __init sony_init(void)
-- 
1.7.4.1

