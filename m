Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1FCPPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:15:10 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30739 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1FCPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:15:08 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=dyVpuHYQJROgCHwBBw1H+I+7e1rgZIKdHwrI0HSbuo4= c=1 sm=1
 a=BBx-CtPOl7IA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=n3DLBDIp2lSvWb96zoUu4Q==:17 a=s3h_cnINAAAA:8 a=47LbCVvxAAAA:8
 a=NEAV23lmAAAA:8 a=Rh_zQq1JyuMdTgv7l1QA:9 a=BJaimqmIks7t_PAunugA:7
 a=ReXhBHqOodcA:10 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>, Simon Wood <simon@mungewell.org>
Subject: [PATCHv3] hid: Fix Logitech Driving Force Pro wheel
Date: Thu,  2 Jun 2011 15:40:14 -0700
Message-Id: <1307054414-19239-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110603112510.18482vx63j4ygmm8@webmail.df.eu>
References: <20110603112510.18482vx63j4ygmm8@webmail.df.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from initial patch:
- shorten comment (removed original descriptor)
- optimized new descriptor (simpler and shorter)
- resent by Simon to fix patch for 3.0rc1

This is a patch for hid-lg.c which fixes the Logitech Driving Force Pro driver.
It was generated against vanilla 2.6.39.
It contains two parts:
- Add the quirk "NOGET" to make the wheel work at all in native mode.
- Replace the somehow broken report descriptor with a custom one to have
separate throttle and brake axes.

As there are significant differences in the descriptor (original descriptor
"hides" the separate axes in a  24 bit FF00 usagepage, new descripter replaces
that with two individual 8 bit desktop.y and desktop.rz usages) I provided a
complete replacement descriptor instead trying to patch the original one.
Patching the descriptor seems not feasible as the new one is much larger.

Note: To actually test this you have to use the tool "ltwheelconf" to put the
DFP into it's native mode - See below for more info.

Background:
Most Logitech wheels are initially reporting themselves with a "fallback"
deviceID (USB_DEVICE_ID_LOGITECH_WHEEL - 0xc294), in order to make sure they
are working even without having the proper driver installed.

If the Logitech driver is installed it sends a special command to the wheel
which sets the wheel to "native mode", enabling enhance features like:
- Clutch pedal
- extended wheel rotation range (up to 900 degrees)
- H-gate shifter
- separate axis for throttle / brake
- all buttons

When the wheel is set to native mode it basically disconnects and reconnects
with a different deviceID (USB_DEVICE_ID_LOGITECH_DFP_WHEEL - 0xc298 in this
case).

I am working on a userspace tool [1] which does the switching from fallback to
native mode. During development I found out that the Driving Force Pro wheel
is not supported in native mode - quierk NOGET is missing and the throttle and
brake axes are reported in a combined way only.

Signed-off-by: Michael Bauer <michael@m-bauer.org>
Signed-off-by: Simon Wood <simon@mungewell.org>

[1] https://github.com/TripleSpeeder/LTWheelConf
---
 drivers/hid/hid-lg.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 21f205f..a7f916e 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -41,6 +41,66 @@
 #define LG_FF3			0x1000
 #define LG_FF4			0x2000
 
+/* Size of the original descriptor of the Driving Force Pro wheel */
+#define DFP_RDESC_ORIG_SIZE	97
+
+/* Fixed report descriptor for Logitech Driving Force Pro wheel controller
+ *
+ * The original descriptor hides the separate throttle and brake axes in
+ * a custom vendor usage page, providing only a combined value as
+ * GenericDesktop.Y.
+ * This descriptor removes the combined Y axis and instead reports
+ * separate throttle (Y) and brake (RZ).
+ */
+static __u8 dfp_rdesc_fixed[] = {
+0x05, 0x01,         /*  Usage Page (Desktop),                   */
+0x09, 0x04,         /*  Usage (Joystik),                        */
+0xA1, 0x01,         /*  Collection (Application),               */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x0E,         /*          Report Size (14),               */
+0x14,               /*          Logical Minimum (0),            */
+0x26, 0xFF, 0x3F,   /*          Logical Maximum (16383),        */
+0x34,               /*          Physical Minimum (0),           */
+0x46, 0xFF, 0x3F,   /*          Physical Maximum (16383),       */
+0x09, 0x30,         /*          Usage (X),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x0E,         /*          Report Count (14),              */
+0x75, 0x01,         /*          Report Size (1),                */
+0x25, 0x01,         /*          Logical Maximum (1),            */
+0x45, 0x01,         /*          Physical Maximum (1),           */
+0x05, 0x09,         /*          Usage Page (Button),            */
+0x19, 0x01,         /*          Usage Minimum (01h),            */
+0x29, 0x0E,         /*          Usage Maximum (0Eh),            */
+0x81, 0x02,         /*          Input (Variable),               */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x04,         /*          Report Size (4),                */
+0x25, 0x07,         /*          Logical Maximum (7),            */
+0x46, 0x3B, 0x01,   /*          Physical Maximum (315),         */
+0x65, 0x14,         /*          Unit (Degrees),                 */
+0x09, 0x39,         /*          Usage (Hat Switch),             */
+0x81, 0x42,         /*          Input (Variable, Nullstate),    */
+0x65, 0x00,         /*          Unit,                           */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x75, 0x08,         /*          Report Size (8),                */
+0x81, 0x01,         /*          Input (Constant),               */
+0x09, 0x31,         /*          Usage (Y),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x09, 0x35,         /*          Usage (Rz),                     */
+0x81, 0x02,         /*          Input (Variable),               */
+0x81, 0x01,         /*          Input (Constant),               */
+0xC0,               /*      End Collection,                     */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x09, 0x02,         /*          Usage (02h),                    */
+0x95, 0x07,         /*          Report Count (7),               */
+0x91, 0x02,         /*          Output (Variable),              */
+0xC0,               /*      End Collection,                     */
+0xC0                /*  End Collection                          */
+};
+
+
 /*
  * Certain Logitech keyboards send in report #3 keys which are far
  * above the logical maximum described in descriptor. This extends
@@ -74,6 +134,18 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc[47] = 0x95;
 		rdesc[48] = 0x0B;
 	}
+
+	switch (hdev->product) {
+	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
+		if (*rsize == DFP_RDESC_ORIG_SIZE) {
+			hid_info(hdev,
+				"fixing up Logitech Driving Force Pro report descriptor\n");
+			rdesc = dfp_rdesc_fixed;
+			*rsize = sizeof(dfp_rdesc_fixed);
+		}
+		break;
+	}
+
 	return rdesc;
 }
 
@@ -380,7 +452,7 @@ static const struct hid_device_id lg_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G27_WHEEL),
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL),
-		.driver_data = LG_FF },
+		.driver_data = LG_NOGET | LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL),
 		.driver_data = LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WINGMAN_FFG ),
-- 
1.7.4.1

