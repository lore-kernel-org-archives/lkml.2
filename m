Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1FHDYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:24:45 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6494 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1FHDY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:24:27 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=I0jFHxriRJwyplOnjK2nOSNCO7GacXBAI5CCNqI8fuI= c=1 sm=1
 a=Bzf2nRS5QawA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=47LbCVvxAAAA:8 a=bl19pPN5vlf71qj6r6YA:9 a=SZliRxb1n2QQrkIOok0A:7
 a=MSl-tDqOz04A:10 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>, Marcin Tolysz <tolysz@gmail.com>,
        Simon Wood <simon@mungewell.org>
Subject: [PATCHv4 2/3] sony_ff_byteswap_accelerometer
Date: Sat,  4 Jun 2011 02:32:36 -0700
Message-Id: <1307179957-24458-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307179957-24458-1-git-send-email-simon@mungewell.org>
References: <1307179957-24458-1-git-send-email-simon@mungewell.org>
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

Fix extracted from previous patch submission:
https://patchwork.kernel.org/patch/95212/

Signed-off-by: Marcin Tolysz <tolysz@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
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

