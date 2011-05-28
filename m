Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1E1Sm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:42:56 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:34930 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab1E1Smz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:42:55 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 May 2011 14:42:54 EDT
From: Michael Bauer <michael@m-bauer.org>
Subject: [PATCH] hid: Fix Logitech Driving Force Pro wheel
Date: Sat, 28 May 2011 20:37:22 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-logitech; KDE/4.6.3; x86_64; ; )
MIME-Version: 1.0
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105282037.22888.michael@m-bauer.org>
X-Df-Sender: michael@m-bauer.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a patch for hid-lg.c which fixes the Logitech Driving Force Pro driver. 
It was generated against vanilla 2.6.39.

This patch contains two parts:
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

[1] https://github.com/TripleSpeeder/LTWheelConf

---

--- linux-2.6.39/drivers/hid/hid-lg.c.orig	2011-05-26 22:10:40.099883539 
+0200
+++ linux-2.6.39/drivers/hid/hid-lg.c	2011-05-28 20:15:46.368912199 +0200
@@ -41,6 +41,137 @@
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
+ * 
+ * This is the original descriptor:
+ * 
+ * 0x05, 0x01,         //  Usage Page (Desktop),                   
+ * 0x09, 0x04,         //  Usage (Joystik),                        
+ * 0xA1, 0x01,         //  Collection (Application),               
+ * 0xA1, 0x02,         //      Collection (Logical),              
+ * 0x95, 0x01,         //          Report Count (1),
+ * 0x75, 0x0E,         //          Report Size (14),
+ * 0x15, 0x00,         //          Logical Minimum (0),
+ * 0x26, 0xFF, 0x3F,   //          Logical Maximum (16383),
+ * 0x35, 0x00,         //          Physical Minimum (0),
+ * 0x46, 0xFF, 0x3F,   //          Physical Maximum (16383),
+ * 0x09, 0x30,         //          Usage (X),
+ * 0x81, 0x02,         //          Input (Variable),
+ * 0x95, 0x0E,         //          Report Count (14),
+ * 0x75, 0x01,         //          Report Size (1),
+ * 0x25, 0x01,         //          Logical Maximum (1),
+ * 0x45, 0x01,         //          Physical Maximum (1),
+ * 0x05, 0x09,         //          Usage Page (Button),
+ * 0x19, 0x01,         //          Usage Minimum (01h),
+ * 0x29, 0x0E,         //          Usage Maximum (0Eh),
+ * 0x81, 0x02,         //          Input (Variable),
+ * 0x05, 0x01,         //          Usage Page (Desktop),
+ * 0x95, 0x01,         //          Report Count (1),
+ * 0x75, 0x04,         //          Report Size (4),
+ * 0x25, 0x07,         //          Logical Maximum (7),
+ * 0x46, 0x3B, 0x01,   //          Physical Maximum (315),
+ * 0x65, 0x14,         //          Unit (Degrees),
+ * 0x09, 0x39,         //          Usage (Hat Switch),
+ * 0x81, 0x42,         //          Input (Variable, Null State),
+ * 0x65, 0x00,         //          Unit,
+ * 0x95, 0x01,         //          Report Count (1),
+ * 0x75, 0x08,         //          Report Size (8),
+ * 0x26, 0xFF, 0x00,   //          Logical Maximum (255),
+ * 0x46, 0xFF, 0x00,   //          Physical Maximum (255),
+ * 0x09, 0x31,         //          Usage (Y),
+ * 0x81, 0x02,         //          Input (Variable),
+ * 0x06, 0x00, 0xFF,   //          Usage Page (FF00h),
+ * 0x09, 0x00,         //          Usage (00h),
+ * 0x95, 0x03,         //          Report Count (3),
+ * 0x75, 0x08,         //          Report Size (8),
+ * 0x81, 0x02,         //          Input (Variable),
+ * 0xC0,               //      End Collection,
+ * 0xA1, 0x02,         //      Collection (Logical),
+ * 0x09, 0x02,         //          Usage (02h),
+ * 0x95, 0x07,         //          Report Count (7),
+ * 0x91, 0x02,         //          Output (Variable),
+ * 0xC0,               //      End Collection,
+ * 0xC0                //  End Collection
+ * 
+ */
+
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
+0x81, 0x42,         /*          Input (Variable),               */
+0x75, 0x01,         /*          Report Size (1),                */
+0x95, 0x08,         /*          Report Count (8),               */
+0x65, 0x00,         /*          Unit,                           */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),             */
+0x25, 0x01,         /*          Logical Maximum (1),            */
+0x45, 0x01,         /*          Physical Maximum (1),           */
+0x09, 0x01,         /*          Usage (01h),                    */
+0x81, 0x02,         /*          Input (Variable),               */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x14,               /*          Logical Minimum (0),            */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x34,               /*          Physical Minimum (0),           */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x09, 0x31,         /*          Usage (Y),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x14,               /*          Logical Minimum (0),            */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x34,               /*          Physical Minimum (0),           */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x09, 0x35,         /*          Usage (Rz),                     */
+0x81, 0x02,         /*          Input (Variable),               */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),             */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x09, 0x00,         /*          Usage (00h),                    */
+0x81, 0x02,         /*          Input (Variable),               */
+0xC0,               /*      End Collection,                     */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x09, 0x02,         /*          Usage (02h),                    */
+0x95, 0x07,         /*          Report Count (7),               */
+0x91, 0x02,         /*          Output (Variable),              */
+0xC0,               /*      End Collection,                     */
+0xC0                /*  End Collection                          */
+};
+
 /*
  * Certain Logitech keyboards send in report #3 keys which are far
  * above the logical maximum described in descriptor. This extends
@@ -74,6 +205,18 @@ static __u8 *lg_report_fixup(struct hid_
 		rdesc[47] = 0x95;
 		rdesc[48] = 0x0B;
 	}
+	
+	switch (hdev->product) {
+	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
+		if (*rsize == DFP_RDESC_ORIG_SIZE) {
+			hid_info(hdev,
+				"fixing up Logitech Driving Force Pro report 
descriptor\n");
+			rdesc = dfp_rdesc_fixed;
+			*rsize = sizeof(dfp_rdesc_fixed);
+		}
+		break;
+	}
+	
 	return rdesc;
 }
 
@@ -378,7 +521,7 @@ static const struct hid_device_id lg_dev
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 
USB_DEVICE_ID_LOGITECH_G25_WHEEL),
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 
USB_DEVICE_ID_LOGITECH_DFP_WHEEL),
-		.driver_data = LG_FF },
+		.driver_data = LG_NOGET | LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 
USB_DEVICE_ID_LOGITECH_WII_WHEEL),
 		.driver_data = LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 
USB_DEVICE_ID_LOGITECH_WINGMAN_FFG ),
