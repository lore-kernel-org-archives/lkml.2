Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1FHDY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:24:28 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6494 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1FHDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:24:25 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=I0jFHxriRJwyplOnjK2nOSNCO7GacXBAI5CCNqI8fuI= c=1 sm=1
 a=c9IeMuO3SHoA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=IqbVoRcxBwMfvNZHerMA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>, Marcin Tolysz <tolysz@gmail.com>,
        Simon Wood <simon@mungewell.org>
Subject: [PATCHv4 1/3] sony_ff_hid_descriptor
Date: Sat,  4 Jun 2011 02:32:35 -0700
Message-Id: <1307179957-24458-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the HID descriptor of the Sixaxis controller
to allow the reporting of the accelerometers and gyro via
a joystick axis.

rewrite section from offset 148
--
0x75, 0x08,         /*          Report Size (8),            */
0x95, 0x27,         /*          Report Count (39),          */ /* all the other data
lumped together */
0x09, 0x01,         /*          Usage (Pointer),            */
0x81, 0x02,         /*          Input (Variable),           */
0x75, 0x08,         /*          Report Size (8),            */
0x95, 0x30,         /*          Report Count (48),          */
0x09, 0x01,         /*          Usage (Pointer),            */
0x91, 0x02,         /*          Output (Variable),          */ /* Note Output */
0x75, 0x08,         /*          Report Size (8),            */
0x95, 0x30,         /*          Report Count (48),          */
0x09, 0x01,         /*          Usage (Pointer),            */
0xB1, 0x02,         /*          Feature (Variable),         */ /* Note Feature */
--
with
--
0x95, 0x13,         /*          Report Count (19),          */ /* last 2 not used... */
0x09, 0x01,         /*          Usage (Pointer),            */
0x81, 0x02,         /*          Input (Variable),           */
0x95, 0x0C,         /*          Report Count (12),          */ /* Padding */
0x81, 0x01,         /*          Input (Constant),           */
0x75, 0x10,         /*          Report Size (16),           */
0x95, 0x04,         /*          Report Count (4),           */
0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),     */
0x46, 0xFF, 0x03,   /*          Physical Maximum (1023),    */
0x09, 0x01,         /*          Usage (Pointer),            */
0x81, 0x02,         /*          Input (Variable),           */
--

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-sony.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 936c911..5c930dc 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -28,6 +28,12 @@
 #define SIXAXIS_CONTROLLER_USB  (1 << 1)
 #define SIXAXIS_CONTROLLER_BT   (1 << 2)
 
+static const u8 sixaxis_rdesc_fixup[] = {
+	0x95, 0x13, 0x09, 0x01, 0x81, 0x02, 0x95, 0x0C,
+	0x81, 0x01, 0x75, 0x10, 0x95, 0x04, 0x26, 0xFF, 
+	0x03, 0x46, 0xFF, 0x03, 0x09, 0x01, 0x81, 0x02
+	};
+
 struct sony_sc {
 	unsigned long quirks;
 };
@@ -43,6 +49,11 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
 		rdesc[55] = 0x06;
 	}
+	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
+			*rsize == 148 && rdesc[83] == 0x75) {
+		hid_info(hdev, "Fixing up Sony Sixaxis report descriptor\n");
+		memcpy((void *)&rdesc[83], (void *) &sixaxis_rdesc_fixup, sizeof(sixaxis_rdesc_fixup));
+	}
 	return rdesc;
 }
 
-- 
1.7.4.1

