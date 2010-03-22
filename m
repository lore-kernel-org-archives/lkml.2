Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0CVMQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:16:30 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:50498 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0CVMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:16:19 -0400
Content-transfer-encoding: 7BIT
From: micki@n-trig.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID:HID-NTRIG update  ntrig_event function
Date: Mon, 22 Mar 2010 14:16:13 +0200
Message-id: <1269260173-2543-2-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-reply-to: <1269260173-2543-1-git-send-email-micki@n-trig.com>
References: <1269260173-2543-1-git-send-email-micki@n-trig.com>
X-OriginalArrivalTime: 22 Mar 2010 12:16:14.0061 (UTC)
 FILETIME=[7744C9D0:01CAC9B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@n-trig.com>

This patch is a part of 2 patches sumbitted by N-trig to hid-ntrig driver.
The driver send events to a user space application which will translate
the events (ignore ghost events, calcuate real X,Y coorindate, add palm).
Fake Finger events used by the user space applicaition to anaylze the information
recevied by N-trig sensor. 
User space application (for any linux distro) will be available at N-trig website.
The driver seprarate pen finger events because the user space application each device seperatly.
N-trig will maintian the driver in the kernel(Bug fix, New feautres)

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |  326 ++++++++++++++++++++++++-----------------------
 1 files changed, 167 insertions(+), 159 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index b4a573b..9f1b916 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -89,22 +89,25 @@ static int debug;
 			MODULE_NAME , ## arg); \
 	} while (0)
 
-#define NTRIG_DUPLICATE_USAGES	0x001
-
-#define nt_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
-					EV_KEY, (c))
-
+/*
+ * N-trig HID Report Structure
+ * The driver will support MTM firwmare Pen, Fingers
+ */
 struct ntrig_data {
-	/* Incoming raw values for a single contact */
-	__u16 x, y, w, h;
-	__u16 id;
-	__u8 confidence;
-
-	bool reading_mt;
-	__u8 first_contact_confidence;
-
-	__u8 mt_footer[4];
-	__u8 mt_foot_count;
+	__u8  pressure;
+	__u8  events;
+	__s32 btn_pressed;
+	__u16 x;
+	__u16 y;
+	__u16 frame_index;
+	__u8  finger_id;
+	__u16 dx;
+	__u16 dy;
+	__u8  generic_byte;
+	__u8  isPalm;
+	__u8  msc_cnt;
+	__u8  real_fingers;
+	__u8  fake_fingers;
 };
 
 /*
@@ -117,10 +120,6 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	/* No special mappings needed for the pen and single touch */
-	if (field->physical)
-		return 0;
-
 	switch (usage->hid & HID_USAGE_PAGE) {
 	case HID_UP_GENDESK:
 		switch (usage->hid) {
@@ -144,6 +143,9 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		/* we do not want to map these for now */
+		case HID_DG_INVERT: /* Not support by pen */
+		case HID_DG_ERASER: /* Not support by pen */
+
 		case HID_DG_CONTACTID: /* Not trustworthy, squelch for now */
 		case HID_DG_INPUTMODE:
 		case HID_DG_DEVICEINDEX:
@@ -158,8 +160,8 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
-			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
-					0, 1, 0, 0);
+			hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_TRACKING_ID);
 			return 1;
 		}
 		return 0;
@@ -176,13 +178,21 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	/* No special mappings needed for the pen and single touch */
-	if (field->physical)
-		return 0;
-
-	if (usage->type == EV_KEY || usage->type == EV_REL
-			|| usage->type == EV_ABS)
-		clear_bit(usage->code, *bit);
+       /*
+	* Map Keys For Pen And Touch events
+	* MSC events used to transfer information about finger status
+	* In curent Frame
+	*/
+	struct input_dev *input = hi->input;
+	set_bit(BTN_LEFT, input->keybit);
+	set_bit(BTN_RIGHT, input->keybit);
+	set_bit(EV_MSC, input->evbit);
+	set_bit(MSC_GESTURE, input->mscbit);
+	set_bit(MSC_SERIAL, input->mscbit);
+	set_bit(MSC_RAW, input->mscbit);
+
+	input_set_abs_params(hi->input, ABS_PRESSURE,
+			0/*Min*/, 255 /*Max*/, 0, 0);
 
 	return 0;
 }
@@ -199,146 +209,154 @@ static int ntrig_event(struct hid_device *hid, struct hid_field *field,
 	struct input_dev *input = field->hidinput->input;
 	struct ntrig_data *nd = hid_get_drvdata(hid);
 
-	/* No special handling needed for the pen */
-	if (field->application == HID_DG_PEN)
-		return 0;
-
 	if (hid->claimed & HID_CLAIMED_INPUT) {
+		/*
+		 * Update Common Fields For Pen and MultiTouch
+		 */
 		switch (usage->hid) {
-		case 0xff000001:
-			/* Tag indicating the start of a multitouch group */
-			nd->reading_mt = 1;
-			nd->first_contact_confidence = 0;
-			break;
-		case HID_DG_TIPSWITCH:
-			/* Prevent emission of touch until validated */
-			return 1;
-		case HID_DG_CONFIDENCE:
-			nd->confidence = value;
-			break;
 		case HID_GD_X:
 			nd->x = value;
-			/* Clear the contact footer */
-			nd->mt_foot_count = 0;
 			break;
 		case HID_GD_Y:
 			nd->y = value;
 			break;
-		case HID_DG_CONTACTID:
-			nd->id = value;
-			break;
-		case HID_DG_WIDTH:
-			nd->w = value;
-			break;
-		case HID_DG_HEIGHT:
-			nd->h = value;
-			/*
-			 * when in single touch mode, this is the last
-			 * report received in a finger event. We want
-			 * to emit a normal (X, Y) position
-			 */
-			if (!nd->reading_mt) {
-				input_report_key(input, BTN_TOOL_DOUBLETAP,
-						 (nd->confidence != 0));
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
-			break;
-		case 0xff000002:
+		}
+		if (field->application == HID_DG_PEN) {
 			/*
-			 * we receive this when the device is in multitouch
-			 * mode. The first of the three values tagged with
-			 * this usage tells if the contact point is real
-			 * or a placeholder
+			 * Pen Button state
 			 */
-
-			/* Shouldn't get more than 4 footer packets, so skip */
-			if (nd->mt_foot_count >= 4)
+			switch (usage->hid) {
+			case HID_DG_INRANGE:
+				nd->events = value;
 				break;
-
-			nd->mt_footer[nd->mt_foot_count++] = value;
-
-			/* if the footer isn't complete break */
-			if (nd->mt_foot_count != 4)
+			case HID_DG_TIPSWITCH:
+				nd->events |= (value << 1);
 				break;
-
-			/* Pen activity signal, trigger end of touch. */
-			if (nd->mt_footer[2]) {
-				nd->confidence = 0;
+			case HID_DG_BARRELSWITCH:
+				nd->events |= (value << 2);
 				break;
-			}
-
-			/* If the contact was invalid */
-			if (!(nd->confidence && nd->mt_footer[0])
-					|| nd->w <= 250
-					|| nd->h <= 190) {
-				nd->confidence = 0;
+			case HID_DG_INVERT:
+				nd->events |= (value << 3);
 				break;
+			case HID_DG_ERASER:
+				nd->events |= (value << 4);
+				break;
+			case HID_DG_TIPPRESSURE:
+				/*
+				 * Last Report Received For Pen Event
+				 */
+				nd->pressure = value;
+				input_report_abs(input, ABS_MT_TOOL_TYPE,
+					MT_TOOL_PEN);
+				input_report_abs(input, ABS_MT_POSITION_X,
+					nd->x);
+				input_report_abs(input, ABS_MT_POSITION_Y,
+					nd->y);
+				/*
+				 * Handle Button Code
+				 */
+				switch (nd->events) {
+				case EVENT_PEN_IN_RANGE:
+					if (0 != nd->btn_pressed) {
+						input_event(input, EV_KEY,
+						  nd->btn_pressed, 0x00);
+						nd->btn_pressed = 0;
+					}
+					break;
+				case EVENT_PEN_TIP:
+					if (BTN_LEFT != nd->btn_pressed) {
+						nd->btn_pressed = BTN_LEFT;
+						input_event(input, EV_KEY,
+						  nd->btn_pressed, 0x01);
+					}
+					break;
+				case EVENT_TOUCH_PEN:  /* FALLTHRU */
+				case EVENT_PEN_RIGHT:
+					if (BTN_RIGHT != nd->btn_pressed) {
+						nd->btn_pressed = BTN_RIGHT;
+						input_event(input, EV_KEY,
+						    nd->btn_pressed, 0x01);
+					}
+					break;
+				}
+				input_report_abs(input, ABS_PRESSURE,
+				  nd->pressure);
+				input_sync(input);
+				ntrig_dbg("X=%d Y=%d Button=%d Pressure=%d\n",
+				    nd->x, nd->y,
+				    nd->btn_pressed, nd->pressure);
 			}
-
-			/* emit a normal (X, Y) for the first point only */
-			if (nd->id == 0) {
-				nd->first_contact_confidence = nd->confidence;
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
-			input_event(input, EV_ABS, ABS_MT_POSITION_X, nd->x);
-			input_event(input, EV_ABS, ABS_MT_POSITION_Y, nd->y);
-			if (nd->w > nd->h) {
-				input_event(input, EV_ABS,
-						ABS_MT_ORIENTATION, 1);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MAJOR, nd->w);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MINOR, nd->h);
-			} else {
-				input_event(input, EV_ABS,
-						ABS_MT_ORIENTATION, 0);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MAJOR, nd->h);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MINOR, nd->w);
-			}
-			input_mt_sync(field->hidinput->input);
-			break;
-
-		case HID_DG_CONTACTCOUNT: /* End of a multitouch group */
-			if (!nd->reading_mt)
+		} else { /* MultiTouch Report */
+			switch (usage->hid) {
+			case HID_DG_CONTACTCOUNT:
+				nd->real_fingers = value;
+				nd->fake_fingers = MAX_FINGERS_SUPPORT - value;
 				break;
-
-			nd->reading_mt = 0;
-
-			if (nd->first_contact_confidence) {
-				switch (value) {
-				case 0:	/* for single touch devices */
-				case 1:
-					input_report_key(input,
-							BTN_TOOL_DOUBLETAP, 1);
+			case MTM_FRAME_INDEX: /* Index 1 */
+				nd->frame_index = value;
+				break;
+			case HID_DG_TIPSWITCH:	/* FALLTHRU */
+			case HID_DG_INRANGE:	/* FALLTHRU */
+			case HID_DG_CONFIDENCE: /* Not Relevant-Index 2 - 4 */
+				break;
+			case HID_DG_CONTACTID: /* Index 5 */
+				nd->finger_id = value;
+				break;
+			case HID_DG_WIDTH:/* Index 6 - 7*/
+				nd->dx = value;
+				break;
+			case HID_DG_HEIGHT:/* Index 8 - 9 */
+				nd->dy = value;
+				/* Start The Sequence of MSC bytes */
+				nd->msc_cnt = 0;
+				break;
+			case MTM_PROPROETARY:/* Index 10 - 14 */
+				nd->msc_cnt++;
+				switch (nd->msc_cnt) {
+				case REPORT_GENERIC1:
+					nd->generic_byte = value;
+					break;
+				case REPORT_MT:
 					break;
-				case 2:
-					input_report_key(input,
-							BTN_TOOL_TRIPLETAP, 1);
+				case REPORT_PALM:
+					nd->isPalm = value;
+					break;
+				case REPORT_GENERIC2:
+					if ((DUMMY_X_CORD_VAL == nd->x) && (DUMMY_Y_CORD_VAL == nd->y) &&
+					    (DUMMY_DX_CORD_VAL == nd->dx) && (DUMMY_DY_CORD_VAL == nd->dy) &&
+					    (DUMMY_GENERIC_BYTE_VAL == value)) {
+						if (MAX_FINGERS_SUPPORT == nd->fake_fingers--) {
+							input_report_abs(input, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
+							input_report_abs(input, ABS_MT_TRACKING_ID, END_OF_REPORT);
+							input_event(input, EV_MSC, MSC_RAW, nd->frame_index);
+							input_sync(input);
+							ntrig_dbg("Session Sync Frame %x\n", nd->frame_index);
+						} else
+							ntrig_dbg("Fake Finger %x\n", nd->frame_index);
+					} else {
+						input_report_abs(input, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
+						input_report_abs(input, ABS_MT_TRACKING_ID, nd->finger_id);
+						input_report_abs(input, ABS_MT_POSITION_X, nd->x);
+						input_report_abs(input, ABS_MT_POSITION_Y, nd->y);
+						input_report_abs(input, ABS_MT_TOUCH_MAJOR, nd->dx);
+						input_report_abs(input, ABS_MT_TOUCH_MINOR, nd->dy);
+						input_event(input, EV_MSC, MSC_GESTURE, nd->generic_byte);
+						input_event(input, EV_MSC, MSC_SERIAL, nd->isPalm);
+						input_mt_sync(input);
+						ntrig_dbg("Real Finger Index %x Count %d X=%d Y=%d DX=%d DY=%d FirstOccur=%d Palm=%d\n",
+							nd->frame_index, nd->real_fingers, nd->x,
+							nd->y, nd->dx, nd->dy,
+							nd->generic_byte, nd->isPalm);
+						if (0 == --nd->real_fingers) {
+							input_event(input, EV_MSC, MSC_RAW, nd->frame_index);
+							input_sync(input);
+							ntrig_dbg("Real Finger Sync Frame %x\n", nd->frame_index);
+						}
+					}
 					break;
-				case 3:
-				default:
-					input_report_key(input,
-							BTN_TOOL_QUADTAP, 1);
 				}
-				input_report_key(input, BTN_TOUCH, 1);
-			} else {
-				input_report_key(input,
-						BTN_TOOL_DOUBLETAP, 0);
-				input_report_key(input,
-						BTN_TOOL_TRIPLETAP, 0);
-				input_report_key(input,
-						BTN_TOOL_QUADTAP, 0);
-				input_report_key(input, BTN_TOUCH, 0);
+				break;
 			}
-			break;
-
-		default:
-			/* fallback to the generic hidinput handling */
-			return 0;
 		}
 	}
 
@@ -402,16 +420,12 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret;
 	struct ntrig_data *nd;
 
-	if (id->driver_data)
-		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
-
 	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
 	if (!nd) {
 		dev_err(&hdev->dev, "cannot allocate N-Trig data\n");
 		return -ENOMEM;
 	}
 
-	nd->reading_mt = 0;
 	hid_set_drvdata(hdev, nd);
 
 	ret = hid_parse(hdev);
@@ -446,16 +460,11 @@ static void ntrig_remove(struct hid_device *hdev)
 
 static const struct hid_device_id ntrig_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN),
-		.driver_data = NTRIG_DUPLICATE_USAGES },
+		.driver_data = NTRIG_USB_DEVICE_ID },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ntrig_devices);
 
-static const struct hid_usage_id ntrig_grabbed_usages[] = {
-	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
-	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1 }
-};
-
 static struct hid_driver ntrig_driver = {
 	.name = "ntrig",
 	.id_table = ntrig_devices,
@@ -463,7 +472,6 @@ static struct hid_driver ntrig_driver = {
 	.remove = ntrig_remove,
 	.input_mapping = ntrig_input_mapping,
 	.input_mapped = ntrig_input_mapped,
-	.usage_table = ntrig_grabbed_usages,
 	.event = ntrig_event,
 };
 
-- 
1.6.3.3

