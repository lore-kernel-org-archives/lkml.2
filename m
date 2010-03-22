Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0CVMQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:16:20 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:50498 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab0CVMQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:16:18 -0400
Content-transfer-encoding: 7BIT
From: micki@n-trig.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: N-trig Add set feature commands to driver
Date: Mon, 22 Mar 2010 14:16:12 +0200
Message-id: <1269260173-2543-1-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 22 Mar 2010 12:16:14.0014 (UTC)
 FILETIME=[773D9DE0:01CAC9B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Add set feature commands to initialize N-trig firwmare.
Add debug option to driver, Add Macro.
Update probe function, delete name allocation caused kernel panaic

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |  169 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 128 insertions(+), 41 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index edcc0c4..b4a573b 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (c) 2008 Rafi Rubin
  *  Copyright (c) 2009 Stephane Chatty
+ *  Copyright (c) 2010 N-TRIG
  *
  */
 
@@ -16,8 +17,77 @@
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/usb.h>
 
 #include "hid-ids.h"
+#include "usbhid/usbhid.h"
+/*
+ * Pen Event Field Declaration
+ */
+#define	EVENT_PEN_TIP		0x03
+#define	EVENT_PEN_RIGHT		0x05
+#define	EVENT_TOUCH_PEN		0x07
+#define EVENT_PEN_IN_RANGE	0x01
+
+/*
+ * MTM 4 last bytes of report descriptor
+ */
+#define REPORT_GENERIC1		0x01
+#define REPORT_MT		0x02
+#define REPORT_PALM		0x03
+#define REPORT_GENERIC2		0x04
+
+#define NTRIG_USB_DEVICE_ID	0x0001
+
+/*
+ * MTM fields
+ */
+#define MAX_FINGERS_SUPPORT	0x06
+#define END_OF_REPORT		0x64
+
+/*
+ * Dummy Finger Declaration
+ */
+#define DUMMY_X_CORD_VAL	0x00
+#define DUMMY_Y_CORD_VAL	0x00
+#define DUMMY_DX_CORD_VAL	0xFA
+#define DUMMY_DY_CORD_VAL	0x96
+#define DUMMY_GENERIC_BYTE_VAL	0x0D
+
+/*
+ * MTM Parse Event
+ */
+#define MTM_FRAME_INDEX		0xff000001
+#define MTM_PROPROETARY		0xff000002
+
+/*
+ * MTM  Set Feature Commands
+ */
+#define REPORTID_DRIVER_ALIVE	0x0A
+#define REPORTID_CALIBRATION	0x0B
+#define REPORTID_GET_VERSION	0x0C
+#define REPORTID_GET_MODE	0x0D
+#define REPORTID_SET_MODE_PEN	0x0E
+#define REPORTID_SET_MODE_TOUCH	0x0F
+#define REPORTID_SET_MODE_DUAL	0x10
+#define REPORTID_CALIBRATION_RESPOND	0x11
+#define HID_CAPACITORS_CALIB	0x12
+#define HID_GET_CAPACITORS_CALIB_DONE	0x13
+
+
+static int debug;
+
+#define MODULE_NAME "hid_ntrig"
+
+
+#define info(format, arg...) \
+	printk(KERN_INFO "%s: " format , MODULE_NAME , ## arg)
+#define ntrig_dbg(format, arg...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "%s: " format, \
+			MODULE_NAME , ## arg); \
+	} while (0)
 
 #define NTRIG_DUPLICATE_USAGES	0x001
 
@@ -123,8 +193,8 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
  * decide whether we are in multi or single touch mode
  * and call input_mt_sync after each point if necessary
  */
-static int ntrig_event (struct hid_device *hid, struct hid_field *field,
-		                        struct hid_usage *usage, __s32 value)
+static int ntrig_event(struct hid_device *hid, struct hid_field *field,
+			struct hid_usage *usage, __s32 value)
 {
 	struct input_dev *input = field->hidinput->input;
 	struct ntrig_data *nd = hid_get_drvdata(hid);
@@ -133,7 +203,7 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 	if (field->application == HID_DG_PEN)
 		return 0;
 
-        if (hid->claimed & HID_CLAIMED_INPUT) {
+	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case 0xff000001:
 			/* Tag indicating the start of a multitouch group */
@@ -279,12 +349,58 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 	return 1;
 }
 
+/*
+ * This function used to configure N-trig firmware
+ * The first command we need to send to firmware is change
+ * to Multi-touch Mode we don't receive a reply
+ */
+static int ntrig_send_report(struct hid_device *hid)
+{
+	struct hid_report *report;
+	struct list_head *report_list =
+			&hid->report_enum[HID_FEATURE_REPORT].report_list;
+
+	if (list_empty(report_list)) {
+		ntrig_dbg("no feature reports found\n");
+		return -ENODEV;
+	}
+	report = list_first_entry(report_list, struct hid_report, list);
+	if (report->maxfield < 1)
+		return -ENODEV;
+
+	list_for_each_entry(report,
+			    report_list, list) {
+		if (report->maxfield < 1) {
+		      ntrig_dbg("no fields in the report\n");
+		      continue;
+		}
+		ntrig_dbg("report id %x\n", report->id);
+		switch (report->id) {
+		case REPORTID_DRIVER_ALIVE:
+		      usbhid_submit_report(hid, report, USB_DIR_OUT);
+		      break;
+		      /*
+		       * These command will implement later accroding to demand
+		       */
+		case REPORTID_GET_VERSION:	/* FALLTHRU */
+		case REPORTID_SET_MODE_DUAL:	/* FALLTHRU */
+		case REPORTID_CALIBRATION:	/* FALLTHRU */
+		case REPORTID_GET_MODE:		/* FALLTHRU */
+		case REPORTID_SET_MODE_PEN:	/* FALLTHRU */
+		case REPORTID_SET_MODE_TOUCH:	/* FALLTHRU */
+		case REPORTID_CALIBRATION_RESPOND:/* FALLTHRU */
+		case HID_CAPACITORS_CALIB:	/* FALLTHRU */
+		case HID_GET_CAPACITORS_CALIB_DONE:
+		      break;
+		}
+	}
+	return 0;
+}
+
 static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
 	struct ntrig_data *nd;
-	struct hid_input *hidinput;
-	struct input_dev *input;
 
 	if (id->driver_data)
 		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
@@ -310,42 +426,10 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_free;
 	}
 
-
-	list_for_each_entry(hidinput, &hdev->inputs, list) {
-		if (hidinput->report->maxfield < 1)
-			continue;
-
-		input = hidinput->input;
-		switch (hidinput->report->field[0]->application) {
-		case HID_DG_PEN:
-			input->name = "N-Trig Pen";
-			break;
-		case HID_DG_TOUCHSCREEN:
-			/* These keys are redundant for fingers, clear them
-			 * to prevent incorrect identification */
-			__clear_bit(BTN_TOOL_PEN, input->keybit);
-			__clear_bit(BTN_TOOL_FINGER, input->keybit);
-			__clear_bit(BTN_0, input->keybit);
-			/*
-			 * A little something special to enable
-			 * two and three finger taps.
-			 */
-			__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
-			__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
-			__set_bit(BTN_TOOL_QUADTAP, input->keybit);
-			/*
-			 * The physical touchscreen (single touch)
-			 * input has a value for physical, whereas
-			 * the multitouch only has logical input
-			 * fields.
-			 */
-			input->name =
-				(hidinput->report->field[0]
-				 ->physical) ?
-				"N-Trig Touchscreen" :
-				"N-Trig MultiTouch";
-			break;
-		}
+	ret = ntrig_send_report(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "send set feature failed\n");
+		goto err_free;
 	}
 
 	return 0;
@@ -395,4 +479,7 @@ static void __exit ntrig_exit(void)
 
 module_init(ntrig_init);
 module_exit(ntrig_exit);
+
+MODULE_PARM_DESC(debug, "Debug mode enable disable");
+module_param(debug, bool, 0644);
 MODULE_LICENSE("GPL");
-- 
1.6.3.3

