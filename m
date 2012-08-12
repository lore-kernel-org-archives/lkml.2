Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2HLVkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:52 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:52511 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2HLVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:50 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OADciKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRtjoUkS8DmzaDQYlF
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="389105723"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 08/19] Input: MT - Add flags to input_mt_init_slots()
Date: Sun, 12 Aug 2012 23:42:26 +0200
Message-Id: <1344807757-2217-9-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing to move more repeated code into the mt core, and a flags
argument to the input_mt_slots_init() function.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-magicmouse.c             | 2 +-
 drivers/hid/hid-multitouch.c             | 2 +-
 drivers/input/input-mt.c                 | 4 +++-
 drivers/input/misc/uinput.c              | 2 +-
 drivers/input/mouse/alps.c               | 2 +-
 drivers/input/mouse/elantech.c           | 4 ++--
 drivers/input/mouse/sentelic.c           | 2 +-
 drivers/input/mouse/synaptics.c          | 4 ++--
 drivers/input/tablet/wacom_wac.c         | 6 +++---
 drivers/input/touchscreen/atmel_mxt_ts.c | 2 +-
 drivers/input/touchscreen/cyttsp_core.c  | 2 +-
 drivers/input/touchscreen/edt-ft5x06.c   | 2 +-
 drivers/input/touchscreen/egalax_ts.c    | 2 +-
 drivers/input/touchscreen/ili210x.c      | 2 +-
 drivers/input/touchscreen/mms114.c       | 2 +-
 drivers/input/touchscreen/penmount.c     | 2 +-
 drivers/input/touchscreen/wacom_w8001.c  | 2 +-
 include/linux/input/mt.h                 | 5 ++++-
 18 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index e425de4..eae3aaa 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -392,7 +392,7 @@ static int magicmouse_setup_input(struct input_dev *input, struct hid_device *hd
 
 	__set_bit(EV_ABS, input->evbit);
 
-	error = input_mt_init_slots(input, 16);
+	error = input_mt_init_slots(input, 16, 0);
 	if (error)
 		return error;
 	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 59c8b5c..c400d90 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -390,7 +390,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTID:
 			if (!td->maxcontacts)
 				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
-			input_mt_init_slots(hi->input, td->maxcontacts);
+			input_mt_init_slots(hi->input, td->maxcontacts, 0);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index f956b27..bbb3304 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -25,7 +25,8 @@
  * May be called repeatedly. Returns -EINVAL if attempting to
  * reinitialize with a different number of slots.
  */
-int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots)
+int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
+			unsigned int flags)
 {
 	struct input_mt *mt = dev->mt;
 	int i;
@@ -40,6 +41,7 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots)
 		return -ENOMEM;
 
 	mt->num_slots = num_slots;
+	mt->flags = flags;
 	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
 	input_set_abs_params(dev, ABS_MT_TRACKING_ID, 0, TRKID_MAX, 0, 0);
 
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 7360568..6b17975 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -405,7 +405,7 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 			goto exit;
 		if (test_bit(ABS_MT_SLOT, dev->absbit)) {
 			int nslot = input_abs_get_max(dev, ABS_MT_SLOT) + 1;
-			input_mt_init_slots(dev, nslot);
+			input_mt_init_slots(dev, nslot, 0);
 		} else if (test_bit(ABS_MT_POSITION_X, dev->absbit)) {
 			input_set_events_per_packet(dev, 60);
 		}
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 4a1347e..cf5af1f 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1620,7 +1620,7 @@ int alps_init(struct psmouse *psmouse)
 	case ALPS_PROTO_V3:
 	case ALPS_PROTO_V4:
 		set_bit(INPUT_PROP_SEMI_MT, dev1->propbit);
-		input_mt_init_slots(dev1, 2);
+		input_mt_init_slots(dev1, 2, 0);
 		input_set_abs_params(dev1, ABS_MT_POSITION_X, 0, ALPS_V3_X_MAX, 0, 0);
 		input_set_abs_params(dev1, ABS_MT_POSITION_Y, 0, ALPS_V3_Y_MAX, 0, 0);
 
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4790110..1e8e42f 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1004,7 +1004,7 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 			input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
 					     ETP_WMAX_V2, 0, 0);
 		}
-		input_mt_init_slots(dev, 2);
+		input_mt_init_slots(dev, 2, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
 		break;
@@ -1035,7 +1035,7 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 		input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
 				     ETP_WMAX_V2, 0, 0);
 		/* Multitouch capable pad, up to 5 fingers. */
-		input_mt_init_slots(dev, ETP_MAX_FINGERS);
+		input_mt_init_slots(dev, ETP_MAX_FINGERS, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
 		input_abs_set_res(dev, ABS_MT_POSITION_X, x_res);
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 3f5649f..b47155d 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -960,7 +960,7 @@ static int fsp_set_input_params(struct psmouse *psmouse)
 
 		input_set_abs_params(dev, ABS_X, 0, abs_x, 0, 0);
 		input_set_abs_params(dev, ABS_Y, 0, abs_y, 0, 0);
-		input_mt_init_slots(dev, 2);
+		input_mt_init_slots(dev, 2, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, 0, abs_x, 0, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_Y, 0, abs_y, 0, 0);
 	}
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 14eaece..37033ad 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1232,7 +1232,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
 	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
-		input_mt_init_slots(dev, 2);
+		input_mt_init_slots(dev, 2, 0);
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
 		/* Image sensors can report per-contact pressure */
@@ -1244,7 +1244,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
 		/* Non-image sensors with AGM use semi-mt */
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
-		input_mt_init_slots(dev, 2);
+		input_mt_init_slots(dev, 2, 0);
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
 	}
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 0020419..5837d07 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1530,7 +1530,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 			__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 			__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 
-			input_mt_init_slots(input_dev, features->touch_max);
+			input_mt_init_slots(input_dev, features->touch_max, 0);
 
 			input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			                     0, 255, 0, 0);
@@ -1575,7 +1575,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 	case TABLETPC2FG:
 		if (features->device_type == BTN_TOOL_FINGER) {
-			input_mt_init_slots(input_dev, features->touch_max);
+			input_mt_init_slots(input_dev, features->touch_max, 0);
 			input_set_abs_params(input_dev, ABS_MT_TOOL_TYPE,
 					0, MT_TOOL_MAX, 0, 0);
 			input_set_abs_params(input_dev, ABS_MT_POSITION_X,
@@ -1631,7 +1631,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 			__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
 			__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-			input_mt_init_slots(input_dev, features->touch_max);
+			input_mt_init_slots(input_dev, features->touch_max, 0);
 
 			if (features->pktlen == WACOM_PKGLEN_BBTOUCH3) {
 				__set_bit(BTN_TOOL_TRIPLETAP,
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 4623cc6..e92615d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1152,7 +1152,7 @@ static int __devinit mxt_probe(struct i2c_client *client,
 
 	/* For multi touch */
 	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
-	error = input_mt_init_slots(input_dev, num_mt_slots);
+	error = input_mt_init_slots(input_dev, num_mt_slots, 0);
 	if (error)
 		goto err_free_object;
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index f030d9e..8e60437 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -571,7 +571,7 @@ struct cyttsp *cyttsp_probe(const struct cyttsp_bus_ops *bus_ops,
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, CY_MAXZ, 0, 0);
 
-	input_mt_init_slots(input_dev, CY_MAX_ID);
+	input_mt_init_slots(input_dev, CY_MAX_ID, 0);
 
 	error = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
 				     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 9afc777..7b786e7 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -778,7 +778,7 @@ static int __devinit edt_ft5x06_ts_probe(struct i2c_client *client,
 			     0, tsdata->num_x * 64 - 1, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y,
 			     0, tsdata->num_y * 64 - 1, 0, 0);
-	error = input_mt_init_slots(input, MAX_SUPPORT_POINTS);
+	error = input_mt_init_slots(input, MAX_SUPPORT_POINTS, 0);
 	if (error) {
 		dev_err(&client->dev, "Unable to init MT slots.\n");
 		goto err_free_mem;
diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 70524dd..c1e3460 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -204,7 +204,7 @@ static int __devinit egalax_ts_probe(struct i2c_client *client,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_X, 0, 0);
 	input_set_abs_params(input_dev,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_Y, 0, 0);
-	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS);
+	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS, 0);
 
 	input_set_drvdata(input_dev, ts);
 
diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
index c004417..4ac6976 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -252,7 +252,7 @@ static int __devinit ili210x_i2c_probe(struct i2c_client *client,
 	input_set_abs_params(input, ABS_Y, 0, ymax, 0, 0);
 
 	/* Multi touch */
-	input_mt_init_slots(input, MAX_TOUCHES);
+	input_mt_init_slots(input, MAX_TOUCHES, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, xmax, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, ymax, 0, 0);
 
diff --git a/drivers/input/touchscreen/mms114.c b/drivers/input/touchscreen/mms114.c
index 49c44bb..560cf09 100644
--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -404,7 +404,7 @@ static int __devinit mms114_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev, ABS_Y, 0, data->pdata->y_size, 0, 0);
 
 	/* For multi touch */
-	input_mt_init_slots(input_dev, MMS114_MAX_TOUCH);
+	input_mt_init_slots(input_dev, MMS114_MAX_TOUCH, 0);
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, MMS114_MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 4ccde45..b49f0b8 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -264,7 +264,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	input_set_abs_params(pm->dev, ABS_Y, 0, max_y, 0, 0);
 
 	if (pm->maxcontacts > 1) {
-		input_mt_init_slots(pm->dev, pm->maxcontacts);
+		input_mt_init_slots(pm->dev, pm->maxcontacts, 0);
 		input_set_abs_params(pm->dev,
 				     ABS_MT_POSITION_X, 0, max_x, 0, 0);
 		input_set_abs_params(pm->dev,
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 8f9ad2f..9a83be6 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -471,7 +471,7 @@ static int w8001_setup(struct w8001 *w8001)
 		case 5:
 			w8001->pktlen = W8001_PKTLEN_TOUCH2FG;
 
-			input_mt_init_slots(dev, 2);
+			input_mt_init_slots(dev, 2, 0);
 			input_set_abs_params(dev, ABS_MT_POSITION_X,
 						0, touch.x, 0, 0);
 			input_set_abs_params(dev, ABS_MT_POSITION_Y,
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index 4ae275c..03c52ce 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -27,11 +27,13 @@ struct input_mt_slot {
  * struct input_mt - state of tracked contacts
  * @trkid: stores MT tracking ID for the next contact
  * @num_slots: number of MT slots the device uses
+ * @flags: input_mt operation flags
  * @slots: array of slots holding current values of tracked contacts
  */
 struct input_mt {
 	int trkid;
 	int num_slots;
+	unsigned int flags;
 	struct input_mt_slot slots[];
 };
 
@@ -47,7 +49,8 @@ static inline int input_mt_get_value(const struct input_mt_slot *slot,
 	return slot->abs[code - ABS_MT_FIRST];
 }
 
-int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots);
+int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
+			unsigned int flags);
 void input_mt_destroy_slots(struct input_dev *dev);
 
 static inline int input_mt_new_trkid(struct input_mt *mt)
-- 
1.7.11.4

