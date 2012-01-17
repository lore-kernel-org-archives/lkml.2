Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2AQLqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 06:46:03 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:50898 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab2AQLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 06:45:59 -0500
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ogay@logitech.com, jzanone@logitech.com, phorvath@logitech.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: [PATCH 1/1] HID: Add full MT support for Logitech Wireless Touchpad
Date: Tue, 17 Jan 2012 12:44:43 +0100
Message-Id: <1326800683-29439-1-git-send-email-nlopezcasad@logitech.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Details:

- This driver brings the full multitouch experience to the users of the
Logitech Unifying Wireless Touchpad. Users of the device will be able to
perform gestures with up to 4 fingers. Gesture recognition and actions
performed following a given gesture are completely defined by the
overlaying gesture recognition engine of the user environment.
Previously, the device would only recognize a few gestures natively and
send them to the OS as native HID usages.

- An additional module, hid-logitech-hidpp, allows Logitech devices
supporting the Logitech HID vendor specific command protocol (HIDPP) to
to send and receive commands from these devices.

Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

---
Hi everyone, 
   As mentioned on the commit message, this patch brings full multitouch
   experience to the users of the Logitech Unifying Touchpad. The patch 
   also provides basic service to other Logitech devices that need to 
   interact using the HID vendor specific commands from Logitech. 

   The wireless touchpad already benefits from those services to enable
   the raw mode of the device, which allows sending up to four finger
   data to the input layer.

   We have performed some testing succesfully, and we think that the users
   would be happy to enjoy more complex gestures with this touchpad under
   Linux. 

   Many thanks from the Logitech team and myself to Benjamin Tissoires who
   is part author of this work and has given excellent support during the
   development.

   Cheers, 
   Nestor

 drivers/hid/Kconfig              |   16 ++
 drivers/hid/Makefile             |    2 +
 drivers/hid/hid-ids.h            |    2 +
 drivers/hid/hid-logitech-dj.c    |  245 +++++++++++++++++++---
 drivers/hid/hid-logitech-dj.h    |  123 -----------
 drivers/hid/hid-logitech-hidpp.c |  353 +++++++++++++++++++++++++++++++
 drivers/hid/hid-logitech-hidpp.h |  142 +++++++++++++
 drivers/hid/hid-logitech-wtp.c   |  434 ++++++++++++++++++++++++++++++++++++++
 include/linux/input.h            |    1 +
 9 files changed, 1170 insertions(+), 148 deletions(-)
 delete mode 100644 drivers/hid/hid-logitech-dj.h
 create mode 100644 drivers/hid/hid-logitech-hidpp.c
 create mode 100644 drivers/hid/hid-logitech-hidpp.h
 create mode 100644 drivers/hid/hid-logitech-wtp.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a421abd..6fd0362 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -253,12 +253,28 @@ config HID_LOGITECH
 config HID_LOGITECH_DJ
 	tristate "Logitech Unifying receivers full support"
 	depends on HID_LOGITECH
+	select HID_LOGITECH_HIDPP
 	default m
 	---help---
 	Say Y if you want support for Logitech Unifying receivers and devices.
 	Unifying receivers are capable of pairing up to 6 Logitech compliant
 	devices to the same receiver.
 
+config HID_LOGITECH_HIDPP
+	tristate "Support for Logitech Vendor Specific HID commands"
+	---help---
+	This module allows sending vendor specific commands to Logitech
+	devices
+
+config HID_LOGITECH_WTP
+	tristate "Logitech Unifying Wireless Touchpad full multitouch support"
+	depends on HID_LOGITECH_DJ
+	select HID_LOGITECH_HIDPP
+	---help---
+	Say Y if you want full multitouch support for the Logitech Unifying Wireless
+	Touchpad. Information of up to 4 fingers is transmitted to the kernel which
+	enables complex gestures to be recognized.
+
 config LOGITECH_FF
 	bool "Logitech force feedback support"
 	depends on HID_LOGITECH
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 8aefdc9..0c9c0ae 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -53,6 +53,8 @@ obj-$(CONFIG_HID_KYE)		+= hid-kye.o
 obj-$(CONFIG_HID_LCPOWER)       += hid-lcpower.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
 obj-$(CONFIG_HID_LOGITECH_DJ)	+= hid-logitech-dj.o
+obj-$(CONFIG_HID_LOGITECH_HIDPP)	+= hid-logitech-hidpp.o
+obj-$(CONFIG_HID_LOGITECH_WTP)	+= hid-logitech-wtp.o
 obj-$(CONFIG_HID_MAGICMOUSE)    += hid-magicmouse.o
 obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
 obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b8574cd..e3b1e7f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -749,4 +749,6 @@
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 
+#define UNIFYING_DEVICE_ID_WIRELESS_TOUCHPAD	0x4011
+
 #endif
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 38b12e4..ace9c9e 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -28,7 +28,92 @@
 #include <linux/usb.h>
 #include "usbhid/usbhid.h"
 #include "hid-ids.h"
-#include "hid-logitech-dj.h"
+#include "hid-logitech-hidpp.h"
+
+#define DJ_MAX_PAIRED_DEVICES			6
+#define DJ_MAX_NUMBER_NOTIFICATIONS		8
+
+#define DJ_DEVICE_INDEX_MIN			1
+#define DJ_DEVICE_INDEX_MAX			6
+
+#define DJREPORT_SHORT_LENGTH			15
+#define DJREPORT_LONG_LENGTH			32
+
+#define REPORT_ID_DJ_SHORT			0x20
+#define REPORT_ID_DJ_LONG			0x21
+
+#define REPORT_TYPE_RFREPORT_FIRST		0x01
+#define REPORT_TYPE_RFREPORT_LAST		0x1F
+
+/* Command Switch to DJ mode */
+#define REPORT_TYPE_CMD_SWITCH			0x80
+#define CMD_SWITCH_PARAM_DEVBITFIELD		0x00
+#define CMD_SWITCH_PARAM_TIMEOUT_SECONDS	0x01
+#define TIMEOUT_NO_KEEPALIVE			0x00
+
+/* Command to Get the list of Paired devices */
+#define REPORT_TYPE_CMD_GET_PAIRED_DEVICES	0x81
+
+/* Device Paired Notification */
+#define REPORT_TYPE_NOTIF_DEVICE_PAIRED		0x41
+#define SPFUNCTION_MORE_NOTIF_EXPECTED		0x01
+#define SPFUNCTION_DEVICE_LIST_EMPTY		0x02
+#define DEVICE_PAIRED_PARAM_SPFUNCTION		0x00
+#define DEVICE_PAIRED_PARAM_EQUAD_ID_LSB	0x01
+#define DEVICE_PAIRED_PARAM_EQUAD_ID_MSB	0x02
+#define DEVICE_PAIRED_RF_REPORT_TYPE		0x03
+
+/* Device Un-Paired Notification */
+#define REPORT_TYPE_NOTIF_DEVICE_UNPAIRED	0x40
+
+/* Connection Status Notification */
+#define REPORT_TYPE_NOTIF_CONNECTION_STATUS	0x42
+#define CONNECTION_STATUS_PARAM_STATUS		0x00
+#define STATUS_LINKLOSS				0x01
+
+/* Error Notification */
+#define REPORT_TYPE_NOTIF_ERROR			0x7F
+#define NOTIF_ERROR_PARAM_ETYPE			0x00
+#define ETYPE_KEEPALIVE_TIMEOUT			0x01
+
+/* supported DJ HID && RF report types */
+#define REPORT_TYPE_KEYBOARD			0x01
+#define REPORT_TYPE_MOUSE			0x02
+#define REPORT_TYPE_CONSUMER_CONTROL		0x03
+#define REPORT_TYPE_SYSTEM_CONTROL		0x04
+#define REPORT_TYPE_MEDIA_CENTER		0x08
+#define REPORT_TYPE_LEDS			0x0E
+
+/* RF Report types bitfield */
+#define STD_KEYBOARD				0x00000002
+#define STD_MOUSE				0x00000004
+#define MULTIMEDIA				0x00000008
+#define POWER_KEYS				0x00000010
+#define MEDIA_CENTER				0x00000100
+#define KBD_LEDS				0x00004000
+
+struct dj_report {
+	u8 report_id;
+	u8 device_index;
+	u8 report_type;
+	u8 report_params[DJREPORT_SHORT_LENGTH - 3];
+};
+
+struct dj_receiver_dev {
+	struct hid_device *hdev;
+	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES +
+					    DJ_DEVICE_INDEX_MIN];
+	struct work_struct work;
+	struct kfifo notif_fifo;
+	spinlock_t lock;
+};
+
+struct dj_device {
+	struct hid_device *hdev;
+	struct dj_receiver_dev *dj_receiver_dev;
+	u32 reports_supported;
+	u8 device_index;
+};
 
 /* Keyboard descriptor (1) */
 static const char kbd_descriptor[] = {
@@ -181,6 +266,23 @@ static const u8 hid_reportid_size_map[NUMBER_OF_HID_REPORTS] = {
 
 static struct hid_ll_driver logi_dj_ll_driver;
 
+
+static void logi_dj_print_raw_event(const char *header, u8 *data, int size)
+{
+	int i;
+	unsigned char log[96];
+	unsigned char tmpstr[60];
+
+	snprintf(log, sizeof(tmpstr), "%s (size=%d)", header, size);
+
+	for (i = 0; i < size; i++) {
+		snprintf(tmpstr, sizeof(tmpstr), " %02x", data[i]);
+		strlcat(log, tmpstr, sizeof(log));
+	}
+
+	dbg_hid("hid-logitech-dj:%s\n", log);
+}
+
 static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 					size_t count,
 					unsigned char report_type);
@@ -245,13 +347,14 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 	dj_hiddev->hid_output_raw_report = logi_dj_output_hidraw_report;
 
 	dj_hiddev->dev.parent = &djrcv_hdev->dev;
-	dj_hiddev->bus = BUS_USB;
+	dj_hiddev->bus = BUS_DJ;
 	dj_hiddev->vendor = le16_to_cpu(usbdev->descriptor.idVendor);
-	dj_hiddev->product = le16_to_cpu(usbdev->descriptor.idProduct);
+	dj_hiddev->product =
+		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB] << 8
+		| dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB];
 	snprintf(dj_hiddev->name, sizeof(dj_hiddev->name),
-		"Logitech Unifying Device. Wireless PID:%02x%02x",
-		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB],
-		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB]);
+		"Logitech Unifying Device. Wireless PID:%04x",
+		dj_hiddev->product);
 
 	usb_make_path(usbdev, dj_hiddev->phys, sizeof(dj_hiddev->phys));
 	snprintf(tmpstr, sizeof(tmpstr), ":%d", dj_report->device_index);
@@ -294,9 +397,13 @@ static void delayedwork_callback(struct work_struct *work)
 	struct dj_receiver_dev *djrcv_dev =
 		container_of(work, struct dj_receiver_dev, work);
 
+	struct hidpp_device *hidpp_dev;
+	struct dj_device *djdev;
 	struct dj_report dj_report;
 	unsigned long flags;
 	int count;
+	u8 param_status;
+	bool connected;
 
 	dbg_hid("%s\n", __func__);
 
@@ -328,6 +435,23 @@ static void delayedwork_callback(struct work_struct *work)
 	case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
 		logi_dj_recv_destroy_djhid_device(djrcv_dev, &dj_report);
 		break;
+	case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
+		param_status = dj_report.report_params[
+					CONNECTION_STATUS_PARAM_STATUS];
+		connected = param_status != STATUS_LINKLOSS;
+		djdev = djrcv_dev->paired_dj_devices[dj_report.device_index];
+		if (!djdev) {
+			dev_err(&djrcv_dev->hdev->dev, "%s:"
+				"dj_dev null, unexpected device index\n", __func__);
+			return;
+		}
+		hidpp_dev = hid_get_drvdata(djdev->hdev);
+		if (!hidpp_dev)	{
+			dbg_hid("%s: hidpp_dev is NULL\n", __func__);
+			return;
+		}
+		hidpp_connect_change(hidpp_dev, connected);
+		break;
 	default:
 		dbg_hid("%s: unexpected report type\n", __func__);
 	}
@@ -383,6 +507,7 @@ static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
 {
 	/* We are called from atomic context (tasklet && djrcv->lock held) */
 	struct dj_device *dj_device;
+	int error;
 
 	dj_device = djrcv_dev->paired_dj_devices[dj_report->device_index];
 
@@ -398,13 +523,40 @@ static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
 		return;
 	}
 
-	if (hid_input_report(dj_device->hdev,
-			HID_INPUT_REPORT, &dj_report->report_type,
-			hid_reportid_size_map[dj_report->report_type], 1)) {
-		dbg_hid("hid_input_report error\n");
-	}
+	error = hid_input_report(dj_device->hdev,
+				HID_INPUT_REPORT, &dj_report->report_type,
+				hid_reportid_size_map[dj_report->report_type], 1);
+
+	if (error)
+		dbg_hid("%s:hid_input_report returned error:%d", __func__, error);
 }
 
+static void logi_dj_recv_forward_raw_report(struct dj_receiver_dev *djrcv_dev,
+			struct dj_report *dj_report,
+			struct hid_report *report, u8 *data, int size)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+
+	struct dj_device *dj_dev = NULL;
+	int error;
+
+	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
+	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX))
+		return;
+
+	dj_dev = djrcv_dev->paired_dj_devices[dj_report->device_index];
+
+	if (!dj_dev) {
+		dbg_hid("%s:warning, dropping report to device index:%d\n",
+			__func__, dj_report->device_index);
+		return;
+	}
+
+	error = hid_input_report(dj_dev->hdev, HID_INPUT_REPORT, data, size, 1);
+
+	if (error)
+		dbg_hid("%s:hid_input_report returned error:%d", __func__, error);
+}
 
 static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 				    struct dj_report *dj_report)
@@ -467,9 +619,32 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 					size_t count,
 					unsigned char report_type)
 {
+	struct dj_device *djdev = hid->driver_data;
+	struct dj_receiver_dev *djrcv_dev = djdev->dj_receiver_dev;
+	struct hid_report hid_report;
+	int i;
+
 	/* Called by hid raw to send data */
 	dbg_hid("%s\n", __func__);
 
+	switch (buf[0]) {
+	case REPORT_ID_HIDPP_SHORT:
+	case REPORT_ID_HIDPP_LONG:
+		break;
+	default:
+		return -1;
+	}
+
+	hid_report = *djrcv_dev->hdev->
+		report_enum[HID_OUTPUT_REPORT].report_id_hash[buf[0]];
+
+	hid_report.field[0]->value[0] = djdev->device_index;
+
+	for (i = 2; i < HIDPP_REPORT_LONG_LENGTH - 1; i++)
+		hid_report.field[0]->value[i-1] = buf[i];
+
+	usbhid_submit_report(djrcv_dev->hdev, &hid_report, USB_DIR_OUT);
+
 	return 0;
 }
 
@@ -477,6 +652,7 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 {
 	struct dj_device *djdev = hid->driver_data;
 	int retval;
+	struct hid_report *report;
 
 	dbg_hid("%s\n", __func__);
 
@@ -554,6 +730,13 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 			__func__, djdev->reports_supported);
 	}
 
+	report = hid_register_report(hid, HID_INPUT_REPORT,
+		REPORT_ID_HIDPP_SHORT);
+	report->size = HIDPP_REPORT_SHORT_LENGTH;
+	report = hid_register_report(hid, HID_INPUT_REPORT,
+		REPORT_ID_HIDPP_LONG);
+	report->size = HIDPP_REPORT_LONG_LENGTH;
+
 	return 0;
 }
 
@@ -632,9 +815,9 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	unsigned long flags;
 	bool report_processed = false;
 
-	dbg_hid("%s, size:%d\n", __func__, size);
+	logi_dj_print_raw_event("logi_dj_raw_event", data, size);
 
-	/* Here we receive all data coming from iface 2, there are 4 cases:
+	/* Here we receive all data coming from iface 2, there are 5 cases:
 	 *
 	 * 1) Data should continue its normal processing i.e. data does not
 	 * come from the DJ collection, in which case we do nothing and
@@ -656,6 +839,12 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 	 * a paired DJ device in which case we forward it to the correct hid
 	 * device (via hid_input_report() ) and return 1 so hid-core does not do
 	 * anything else with it.
+	 *
+	 * 5) Data is from HIDPP collection, in this case, we forward the data
+	 * to the corresponding child hid device and return 0 to hid-core so
+	 * the data also goes to the hidraw device of the receiver. This allows
+	 * a user space application to implement the full hidpp20 routing via
+	 * the receiver.
 	 */
 
 	spin_lock_irqsave(&djrcv_dev->lock, flags);
@@ -670,11 +859,19 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 			    STATUS_LINKLOSS) {
 				logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
 			}
+			logi_dj_recv_queue_notification(djrcv_dev, dj_report);
 			break;
 		default:
 			logi_dj_recv_forward_report(djrcv_dev, dj_report);
 		}
 		report_processed = true;
+	} else {
+		if (dj_report->report_id == REPORT_ID_HIDPP_SHORT ||
+		    dj_report->report_id == REPORT_ID_HIDPP_LONG) {
+			logi_dj_recv_forward_raw_report(djrcv_dev, dj_report,
+							report, data, size);
+			report_processed = false;
+		}
 	}
 	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
 
@@ -688,9 +885,6 @@ static int logi_dj_probe(struct hid_device *hdev,
 	struct dj_receiver_dev *djrcv_dev;
 	int retval;
 
-	if (is_dj_device((struct dj_device *)hdev->driver_data))
-		return -ENODEV;
-
 	dbg_hid("%s called for ifnum %d\n", __func__,
 		intf->cur_altsetting->desc.bInterfaceNumber);
 
@@ -834,14 +1028,19 @@ static void logi_dj_remove(struct hid_device *hdev)
 	hid_set_drvdata(hdev, NULL);
 }
 
+static const u16 dj_have_special_driver[] = {
+	UNIFYING_DEVICE_ID_WIRELESS_TOUCHPAD,
+};
+
 static int logi_djdevice_probe(struct hid_device *hdev,
 			 const struct hid_device_id *id)
 {
-	int ret;
-	struct dj_device *dj_dev = hdev->driver_data;
+	int ret, i;
 
-	if (!is_dj_device(dj_dev))
-		return -ENODEV;
+	for (i = 0; i < ARRAY_SIZE(dj_have_special_driver) ; i++) {
+		if (dj_have_special_driver[i] == hdev->product)
+			return -ENODEV;
+	}
 
 	ret = hid_parse(hdev);
 	if (!ret)
@@ -871,12 +1070,8 @@ static struct hid_driver logi_djreceiver_driver = {
 #endif
 };
 
-
 static const struct hid_device_id logi_dj_devices[] = {
-	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER)},
-	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
-		USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2)},
+	{HID_DEVICE(BUS_DJ, USB_VENDOR_ID_LOGITECH, HID_ANY_ID)},
 	{}
 };
 
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
deleted file mode 100644
index fd28a5e..0000000
--- a/drivers/hid/hid-logitech-dj.h
+++ /dev/null
@@ -1,123 +0,0 @@
-#ifndef __HID_LOGITECH_DJ_H
-#define __HID_LOGITECH_DJ_H
-
-/*
- *  HID driver for Logitech Unifying receivers
- *
- *  Copyright (c) 2011 Logitech
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- */
-
-#include <linux/kfifo.h>
-
-#define DJ_MAX_PAIRED_DEVICES			6
-#define DJ_MAX_NUMBER_NOTIFICATIONS		8
-#define DJ_DEVICE_INDEX_MIN 			1
-#define DJ_DEVICE_INDEX_MAX 			6
-
-#define DJREPORT_SHORT_LENGTH			15
-#define DJREPORT_LONG_LENGTH			32
-
-#define REPORT_ID_DJ_SHORT			0x20
-#define REPORT_ID_DJ_LONG			0x21
-
-#define REPORT_TYPE_RFREPORT_FIRST		0x01
-#define REPORT_TYPE_RFREPORT_LAST		0x1F
-
-/* Command Switch to DJ mode */
-#define REPORT_TYPE_CMD_SWITCH			0x80
-#define CMD_SWITCH_PARAM_DEVBITFIELD		0x00
-#define CMD_SWITCH_PARAM_TIMEOUT_SECONDS	0x01
-#define TIMEOUT_NO_KEEPALIVE			0x00
-
-/* Command to Get the list of Paired devices */
-#define REPORT_TYPE_CMD_GET_PAIRED_DEVICES	0x81
-
-/* Device Paired Notification */
-#define REPORT_TYPE_NOTIF_DEVICE_PAIRED		0x41
-#define SPFUNCTION_MORE_NOTIF_EXPECTED		0x01
-#define SPFUNCTION_DEVICE_LIST_EMPTY		0x02
-#define DEVICE_PAIRED_PARAM_SPFUNCTION		0x00
-#define DEVICE_PAIRED_PARAM_EQUAD_ID_LSB	0x01
-#define DEVICE_PAIRED_PARAM_EQUAD_ID_MSB	0x02
-#define DEVICE_PAIRED_RF_REPORT_TYPE		0x03
-
-/* Device Un-Paired Notification */
-#define REPORT_TYPE_NOTIF_DEVICE_UNPAIRED	0x40
-
-
-/* Connection Status Notification */
-#define REPORT_TYPE_NOTIF_CONNECTION_STATUS	0x42
-#define CONNECTION_STATUS_PARAM_STATUS		0x00
-#define STATUS_LINKLOSS				0x01
-
-/* Error Notification */
-#define REPORT_TYPE_NOTIF_ERROR			0x7F
-#define NOTIF_ERROR_PARAM_ETYPE			0x00
-#define ETYPE_KEEPALIVE_TIMEOUT			0x01
-
-/* supported DJ HID && RF report types */
-#define REPORT_TYPE_KEYBOARD			0x01
-#define REPORT_TYPE_MOUSE			0x02
-#define REPORT_TYPE_CONSUMER_CONTROL		0x03
-#define REPORT_TYPE_SYSTEM_CONTROL		0x04
-#define REPORT_TYPE_MEDIA_CENTER		0x08
-#define REPORT_TYPE_LEDS			0x0E
-
-/* RF Report types bitfield */
-#define STD_KEYBOARD				0x00000002
-#define STD_MOUSE				0x00000004
-#define MULTIMEDIA				0x00000008
-#define POWER_KEYS				0x00000010
-#define MEDIA_CENTER				0x00000100
-#define KBD_LEDS				0x00004000
-
-struct dj_report {
-	u8 report_id;
-	u8 device_index;
-	u8 report_type;
-	u8 report_params[DJREPORT_SHORT_LENGTH - 3];
-};
-
-struct dj_receiver_dev {
-	struct hid_device *hdev;
-	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES +
-					    DJ_DEVICE_INDEX_MIN];
-	struct work_struct work;
-	struct kfifo notif_fifo;
-	spinlock_t lock;
-};
-
-struct dj_device {
-	struct hid_device *hdev;
-	struct dj_receiver_dev *dj_receiver_dev;
-	u32 reports_supported;
-	u8 device_index;
-};
-
-/**
- * is_dj_device - know if the given dj_device is not the receiver.
- * @dj_dev: the dj device to test
- *
- * This macro tests if a struct dj_device pointer is a device created
- * by the bus enumarator.
- */
-#define is_dj_device(dj_dev) \
-	(&(dj_dev)->dj_receiver_dev->hdev->dev == (dj_dev)->hdev->dev.parent)
-
-#endif
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
new file mode 100644
index 0000000..dd7dd04
--- /dev/null
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -0,0 +1,353 @@
+/*
+ *  HIDPP protocol for Logitech Unifying receivers
+ *
+ *  Copyright (c) 2011 Logitech (c)
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so by e-mail send
+ * your message to Benjamin Tissoires <benjamin.tissoires at gmail com>
+ *
+ */
+
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include "hid-logitech-hidpp.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
+MODULE_AUTHOR("Nestor Lopez Casado <nlopezcasad@logitech.com>");
+
+#define MAX_INIT_RETRY 5
+
+enum delayed_work_type {
+	HIDPP_INIT = 0
+};
+
+static void hidpp_print_raw_event(const char *header, u8 *data, int size)
+{
+	int i;
+	unsigned char log[96];
+	unsigned char tmpstr[60];
+
+	snprintf(log, sizeof(tmpstr), "%s (size=%d)", header, size);
+
+	for (i = 0; i < size; i++) {
+		snprintf(tmpstr, sizeof(tmpstr), " %02x", data[i]);
+		strlcat(log, tmpstr, sizeof(log));
+	}
+
+	dbg_hid("%s\n", log);
+}
+
+static int __hidpp_send_report(struct hid_device *hdev,
+				struct hidpp_report *hidpp_rept)
+{
+	int sent_bytes;
+
+	if (!hdev->hid_output_raw_report) {
+		dev_err(&hdev->dev, "%s:"
+			"hid_output_raw_report is null\n", __func__);
+		return -ENODEV;
+	}
+
+	hidpp_print_raw_event("sending ", (u8 *)hidpp_rept,
+				HIDPP_REPORT_LONG_LENGTH);
+	sent_bytes = hdev->hid_output_raw_report(hdev, (u8 *) hidpp_rept,
+						 sizeof(struct hidpp_report),
+						 HID_OUTPUT_REPORT);
+
+	return (sent_bytes < 0) ? sent_bytes : 0;
+}
+
+static int hidpp_send_message_sync(struct hidpp_device *hidpp_dev,
+	struct hidpp_report *message,
+	struct hidpp_report *response)
+{
+	int ret;
+
+	mutex_lock(&hidpp_dev->send_mutex);
+
+	hidpp_dev->send_receive_buf = response;
+	hidpp_dev->answer_available = false;
+
+	/* So that we can later validate the answer when it arrives
+	 * in hidpp_raw_event */
+	*response = *message;
+
+	ret = __hidpp_send_report(hidpp_dev->hid_dev, message);
+
+	if (ret) {
+		memset(response, 0, sizeof(struct hidpp_report));
+		goto exit;
+	}
+
+	if (!wait_event_timeout(hidpp_dev->wait, hidpp_dev->answer_available, 10*HZ)) {
+		dbg_hid("%s:timeout waiting for response\n", __func__);
+		memset(response, 0, sizeof(struct hidpp_report));
+		ret = -1;
+	}
+
+	if (response->report_id == REPORT_ID_HIDPP_SHORT &&
+	    response->fap.feature_index == HIDPP_ERROR) {
+		ret = response->fap.params[0];
+		goto exit;
+	}
+
+exit:
+	mutex_unlock(&hidpp_dev->send_mutex);
+	return ret;
+
+}
+
+int hidpp_send_fap_command_sync(struct hidpp_device *hidpp_dev,
+	u8 feat_index, u8 funcindex_clientid, u8 *params, int param_count,
+	struct hidpp_report *response)
+{
+	struct hidpp_report message;
+
+	if (param_count > sizeof(message.rap.params))
+		return -EINVAL;
+
+	memset(&message, 0, sizeof(message));
+	message.report_id = REPORT_ID_HIDPP_LONG;
+	message.fap.feature_index = feat_index;
+	message.fap.funcindex_clientid = funcindex_clientid;
+	memcpy(&message.fap.params, params, param_count);
+
+	return hidpp_send_message_sync(hidpp_dev, &message, response);
+}
+EXPORT_SYMBOL_GPL(hidpp_send_fap_command_sync);
+
+int hidpp_send_rap_command_sync(struct hidpp_device *hidpp_dev,
+	u8 report_id, u8 sub_id, u8 reg_address, u8 *params,
+	int param_count,
+	struct hidpp_report *response)
+{
+	struct hidpp_report message;
+
+	if ((report_id != REPORT_ID_HIDPP_SHORT) &&
+	    (report_id != REPORT_ID_HIDPP_LONG))
+		return -EINVAL;
+
+	if (param_count > sizeof(message.rap.params))
+		return -EINVAL;
+
+	memset(&message, 0, sizeof(message));
+	message.report_id = report_id;
+	message.rap.sub_id = sub_id;
+	message.rap.reg_address = reg_address;
+	memcpy(&message.rap.params, params, param_count);
+
+	return hidpp_send_message_sync(hidpp_dev, &message, response);
+}
+EXPORT_SYMBOL_GPL(hidpp_send_rap_command_sync);
+
+
+static void schedule_delayed_hidpp_init(struct hidpp_device *hidpp_dev)
+{
+	enum delayed_work_type work_type = HIDPP_INIT;
+
+	kfifo_in(&hidpp_dev->delayed_work_fifo, &work_type,
+				sizeof(enum delayed_work_type));
+
+	if (schedule_work(&hidpp_dev->work) == 0) {
+		dbg_hid("%s: did not schedule the work item,"
+			" was already queued\n",
+			__func__);
+	}
+}
+
+static void hidpp_delayed_init(struct hidpp_device *hidpp_device)
+{
+	struct hid_device *hdev = hidpp_device->hid_dev;
+	int ret = 0;
+
+	dbg_hid("%s: hdev:%p\n", __func__, hdev);
+
+	if (hidpp_device->initialized)
+		return;
+
+	if (down_trylock(&hidpp_device->hid_dev->driver_lock)) {
+		if (hidpp_device->init_retry < MAX_INIT_RETRY) {
+			dbg_hid("%s: we need to reschedule the work item."
+				"Semaphore still held on device\n", __func__);
+			schedule_delayed_hidpp_init(hidpp_device);
+			hidpp_device->init_retry++;
+		} else {
+			dbg_hid("%s: giving up initialization now.", __func__);
+			hidpp_device->init_retry = 0;
+		}
+		return;
+	}
+	up(&hidpp_device->hid_dev->driver_lock);
+
+	if (hidpp_device->device_init)
+		ret = hidpp_device->device_init(hidpp_device);
+
+	if (!ret)
+		hidpp_device->initialized = true;
+}
+
+static void delayed_work_cb(struct work_struct *work)
+{
+	struct hidpp_device *hidpp_device =
+		container_of(work, struct hidpp_device, work);
+	unsigned long flags;
+	int count;
+	enum delayed_work_type work_type;
+
+	dbg_hid("%s\n", __func__);
+
+	spin_lock_irqsave(&hidpp_device->lock, flags);
+
+	count = kfifo_out(&hidpp_device->delayed_work_fifo, &work_type,
+				sizeof(enum delayed_work_type));
+
+	if (count != sizeof(enum delayed_work_type)) {
+		dev_err(&hidpp_device->hid_dev->dev, "%s: workitem triggered without "
+			"notifications available\n", __func__);
+		spin_unlock_irqrestore(&hidpp_device->lock, flags);
+		return;
+	}
+
+	if (!kfifo_is_empty(&hidpp_device->delayed_work_fifo)) {
+		if (schedule_work(&hidpp_device->work) == 0) {
+			dbg_hid("%s: did not schedule the work item, was "
+				"already queued\n", __func__);
+		}
+	}
+
+	spin_unlock_irqrestore(&hidpp_device->lock, flags);
+
+	switch (work_type) {
+	case HIDPP_INIT:
+		hidpp_delayed_init(hidpp_device);
+		break;
+	default:
+		dbg_hid("%s: unexpected report type\n", __func__);
+	}
+}
+
+int hidpp_init(struct hidpp_device *hidpp_dev, struct hid_device *hid_dev)
+{
+	if (hidpp_dev->initialized)
+		return 0;
+
+	hidpp_dev->init_retry = 0;
+	hidpp_dev->hid_dev = hid_dev;
+
+	INIT_WORK(&hidpp_dev->work, delayed_work_cb);
+	mutex_init(&hidpp_dev->send_mutex);
+	init_waitqueue_head(&hidpp_dev->wait);
+
+	spin_lock_init(&hidpp_dev->lock);
+	if (kfifo_alloc(&hidpp_dev->delayed_work_fifo,
+			4 * sizeof(struct hidpp_report),
+			GFP_KERNEL)) {
+		dev_err(&hidpp_dev->hid_dev->dev,
+			"%s:failed allocating delayed_work_fifo\n", __func__);
+		mutex_destroy(&hidpp_dev->send_mutex);
+		return -ENOMEM;
+	}
+
+	schedule_delayed_hidpp_init(hidpp_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hidpp_init);
+
+void hidpp_connect_change(struct hidpp_device *hidpp_dev, bool connected)
+{
+	if ((!hidpp_dev->initialized) && (connected))
+		hidpp_delayed_init(hidpp_dev);
+
+	if (hidpp_dev->connect_change)
+		hidpp_dev->connect_change(hidpp_dev, connected);
+}
+EXPORT_SYMBOL_GPL(hidpp_connect_change);
+
+void hidpp_remove(struct hidpp_device *hidpp_dev)
+{
+	dbg_hid("%s\n", __func__);
+	cancel_work_sync(&hidpp_dev->work);
+	mutex_destroy(&hidpp_dev->send_mutex);
+	kfifo_free(&hidpp_dev->delayed_work_fifo);
+	hidpp_dev->initialized = false;
+	hidpp_dev->hid_dev = NULL;
+}
+EXPORT_SYMBOL_GPL(hidpp_remove);
+
+int hidpp_raw_event(struct hid_device *hdev, struct hid_report *hid_report,
+			u8 *data, int size)
+{
+	struct hidpp_device *hidpp_dev = hid_get_drvdata(hdev);
+	struct hidpp_report *report = (struct hidpp_report *)data;
+	struct hidpp_report *question = hidpp_dev->send_receive_buf;
+	struct hidpp_report *answer = hidpp_dev->send_receive_buf;
+
+	dbg_hid("%s\n", __func__);
+
+	hidpp_print_raw_event("hidpp_raw_event", data, size);
+
+	if ((report->report_id != REPORT_ID_HIDPP_LONG) &&
+	    (report->report_id != REPORT_ID_HIDPP_SHORT)) {
+		dbg_hid("hid-logitech-hidpp.c:%s: ignore report_id:%d\n",
+			__func__, report->report_id);
+		return 0;
+	}
+
+	/* If the mutex is locked then we have a pending answer from a
+	 * previoulsly sent command
+	 */
+	if (unlikely(mutex_is_locked(&hidpp_dev->send_mutex))) {
+		/* Check for a correct hidpp20 answer */
+		bool correct_answer =
+			report->fap.feature_index == question->fap.feature_index &&
+		report->fap.funcindex_clientid == question->fap.funcindex_clientid;
+
+		/* Check for a "correct" hidpp10 error message, this means the
+		 * device is hidpp10 and does not support the command sent */
+		correct_answer = correct_answer ||
+			(report->fap.feature_index == HIDPP_ERROR &&
+		report->fap.funcindex_clientid == question->fap.feature_index &&
+		report->fap.params[0] == question->fap.funcindex_clientid);
+
+		if (correct_answer) {
+			hidpp_print_raw_event("answer", data, size);
+			*answer = *report;
+			hidpp_dev->answer_available = true;
+			wake_up(&hidpp_dev->wait);
+			/* This was an answer to a command that this driver sent
+			 * we return 1 to hid-core to avoid forwarding the command
+			 * upstream as it has been treated by the driver */
+
+			return 1;
+		}
+	}
+
+	if (hidpp_dev->raw_event != NULL)
+		return hidpp_dev->raw_event(hidpp_dev, report);
+
+	hidpp_print_raw_event("event not treated", data, size);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hidpp_raw_event);
diff --git a/drivers/hid/hid-logitech-hidpp.h b/drivers/hid/hid-logitech-hidpp.h
new file mode 100644
index 0000000..3a72e16
--- /dev/null
+++ b/drivers/hid/hid-logitech-hidpp.h
@@ -0,0 +1,142 @@
+#ifndef __HID_LOGITECH_HIDPP_H
+#define __HID_LOGITECH_HIDPP_H
+
+/*
+ *  HIDPP protocol
+ *
+ *  Copyright (c) 2011 Logitech (c)
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so by e-mail send
+ * your message to Benjamin Tissoires <benjamin.tissoires at gmail com>
+ *
+ */
+#include <linux/kfifo.h>
+
+#define REPORT_ID_HIDPP_SHORT			0x10
+#define REPORT_ID_HIDPP_LONG			0x11
+
+#define HIDPP_REPORT_SHORT_LENGTH		7
+#define HIDPP_REPORT_LONG_LENGTH		20
+
+/* There are two hidpp protocols in use, the first version hidpp10 is known
+ * as register access protocol or RAP, the second version hidpp20 is known as
+ * feature access protocol or FAP
+ *
+ * Most older devices (including the Unifying usb receiver) use the RAP protocol
+ * where as most newer devices use the FAP protocol. Both protocols are
+ * compatible with the underlying transport, which could be usb, Unifiying, or
+ * bluetooth. The message lengths are defined by the hid vendor specific report
+ * descriptor for the HIDPP_SHORT report type (total message lenth 7 bytes) and
+ * the HIDPP_LONG report type (total message length 20 bytes)
+ *
+ * The RAP protocol uses both report types, whereas the FAP only uses HIDPP_LONG
+ * messages. The Unifying receiver itself responds to RAP messages (device index is
+ * 0xFF for the receiver), and all messages (short or long) with a device index
+ * between 1 and 6 are passed untouched to the corresponding paired Unifying device.
+ *
+ * The paired device can be RAP or FAP, it will receive the message untouched from
+ * the Unifiying receiver.
+ */
+
+struct fap {
+	u8 feature_index;
+	u8 funcindex_clientid;
+	u8 params[HIDPP_REPORT_LONG_LENGTH - 4U];
+};
+
+struct rap {
+	u8 sub_id;
+	u8 reg_address;
+	u8 params[HIDPP_REPORT_LONG_LENGTH - 4U];
+};
+
+struct hidpp_report {
+	u8 report_id;
+	u8 device_index;
+	union {
+		struct fap fap;
+		struct rap rap;
+		u8 rawbytes[sizeof(struct fap)];
+	};
+} __packed;
+
+struct hidpp_device {
+	struct hid_device *hid_dev;
+	void *driver_data;
+
+	int (*raw_event)(struct hidpp_device *hidpp_dev, struct hidpp_report *report);
+	int (*device_init)(struct hidpp_device *hidpp_dev);
+	void (*connect_change)(struct hidpp_device *hidpp_dev, bool connected);
+
+	/* private */
+	struct work_struct work;
+	struct mutex send_mutex;
+	struct kfifo delayed_work_fifo;
+	spinlock_t lock;
+	void *send_receive_buf;
+	wait_queue_head_t wait;
+	bool answer_available;
+	bool initialized;
+	int init_retry;
+};
+
+extern int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
+			u8 *data, int size);
+
+extern void hidpp_connect_change(struct hidpp_device *hidpp_dev, bool connected);
+extern int hidpp_init(struct hidpp_device *hidpp_dev, struct hid_device *hid_dev);
+extern void hidpp_remove(struct hidpp_device *hidpp_dev);
+
+extern int hidpp_send_command_sync(struct hidpp_device *hidpp_dev,
+			u16 feature, u8 cmd, u8 *params, int param_count,
+			struct hidpp_report *response);
+
+
+extern int hidpp_send_fap_command_sync(struct hidpp_device *hidpp_dev,
+		u8 feat_index, u8 funcindex_clientid, u8 *params, int param_count,
+		struct hidpp_report *response);
+
+extern int hidpp_send_rap_command_sync(struct hidpp_device *hidpp_dev,
+			u8 report_id, u8 sub_id, u8 reg_address, u8 *params,
+			int param_count, struct hidpp_report *response);
+
+#define HIDPP_ERROR				0x8f
+#define HIDPP_ERROR_SUCCESS			0x00
+#define HIDPP_ERROR_INVALID_SUBID		0x01
+#define HIDPP_ERROR_INVALID_ADRESS		0x02
+#define HIDPP_ERROR_INVALID_VALUE		0x03
+#define HIDPP_ERROR_CONNECT_FAIL		0x04
+#define HIDPP_ERROR_TOO_MANY_DEVICES		0x05
+#define HIDPP_ERROR_ALREADY_EXISTS		0x06
+#define HIDPP_ERROR_BUSY			0x07
+#define HIDPP_ERROR_UNKNOWN_DEVICE		0x08
+#define HIDPP_ERROR_RESOURCE_ERROR		0x09
+#define HIDPP_ERROR_REQUEST_UNAVAILABLE		0x0a
+#define HIDPP_ERROR_INVALID_PARAM_VALUE		0x0b
+#define HIDPP_ERROR_WRONG_PIN_CODE		0x0c
+
+#define HIDPP_TYPE_KEYBOARD			0x00
+#define HIDPP_TYPE_REMOTE_CONTROL		0x01
+#define HIDPP_TYPE_NUMPAD			0x02
+#define HIDPP_TYPE_MOUSE			0x03
+#define HIDPP_TYPE_TOUCHPAD			0x04
+#define HIDPP_TYPE_TRACKBALL			0x05
+#define HIDPP_TYPE_PRESENTER			0x06
+#define HIDPP_TYPE_RECEIVER			0x07
+
+#endif
diff --git a/drivers/hid/hid-logitech-wtp.c b/drivers/hid/hid-logitech-wtp.c
new file mode 100644
index 0000000..d1bdef6
--- /dev/null
+++ b/drivers/hid/hid-logitech-wtp.c
@@ -0,0 +1,434 @@
+/*
+ *  HID driver for Logitech Wireless Touchpad device
+ *
+ *  Copyright (c) 2011 Logitech (c)
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so by e-mail send
+ * your message to Benjamin Tissoires <benjamin.tissoires at gmail com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/input/mt.h>
+
+MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
+MODULE_AUTHOR("Nestor Lopez Casado <nlopezcasad@logitech.com>");
+MODULE_DESCRIPTION("Logitech Wireless Touchpad");
+MODULE_LICENSE("GPL");
+
+#include "hid-ids.h"
+#include "hid-logitech-hidpp.h"
+
+#define X_SIZE 3700
+#define Y_SIZE 2480
+#define CMD_TOUCHPAD_GET_RAW_INFO		0x01
+#define CMD_TOUCHPAD_GET_RAW_REPORT_STATE	0x11
+#define CMD_TOUCHPAD_SET_RAW_REPORT_STATE	0x21
+#define EVENT_TOUCHPAD_RAW_XY			0x30
+#define EVENT_TOUCHPAD_RAW_XY_			0x00
+#define WTP_RAW_XY_FEAT_INDEX			0x0F
+
+struct hidpp_touchpad_raw_info {
+	u16 x_size;
+	u16 y_size;
+	u8 z_range;
+	u8 area_range;
+	u8 timestamp_unit;
+	u8 origin;
+	u8 pen_supported;
+};
+
+struct hidpp_touchpad_raw_xy_finger {
+	u8 contact_type;
+	u8 contact_status;
+	u16 x;
+	u16 y;
+	u8 z;
+	u8 area;
+	u8 finger_id;
+};
+
+struct hidpp_touchpad_raw_xy {
+	u16 timestamp;
+	struct hidpp_touchpad_raw_xy_finger fingers[2];
+	u8 spurious_flag;
+	u8 end_of_frame;
+	u8 finger_count;
+};
+
+struct wtp_mt_slot {
+	bool touch_state;	/* is the touch valid? */
+	bool seen_in_this_frame;/* has this slot been updated */
+};
+
+struct wtp_data {
+	struct input_dev *input;
+	__u16 x_size, y_size;
+	__u8 p_range, area_range;
+	__u8 finger_count;
+	__u8 mt_feature_index;
+	__u8 button_feature_index;
+	__u8 maxcontacts;
+	struct wtp_mt_slot slots[5];
+};
+
+struct touch_hidpp_report {
+	u8 x_m;
+	u8 x_l;
+	u8 y_m;
+	u8 y_l;
+	u8 z;
+	u8 area;
+	u8 id;
+};
+
+struct dual_touch_hidpp_report {
+	u8 report_id;
+	u8 device_index;
+	u8 feature_index;
+	u8 broadcast_event;
+	u16 timestamp;
+	struct touch_hidpp_report touches[2];
+};
+
+static void wtp_touch_event(struct wtp_data *fd,
+	struct hidpp_touchpad_raw_xy_finger *touch_report)
+{
+	int slot = touch_report->finger_id - 1;
+
+	fd->slots[slot].seen_in_this_frame = true;
+	fd->slots[slot].touch_state = touch_report->contact_status;
+
+	input_mt_slot(fd->input, slot);
+	input_mt_report_slot_state(fd->input, MT_TOOL_FINGER,
+					touch_report->contact_status);
+	if (touch_report->contact_status) {
+		input_event(fd->input, EV_ABS, ABS_MT_POSITION_X,
+				touch_report->x);
+		input_event(fd->input, EV_ABS, ABS_MT_POSITION_Y,
+				touch_report->y);
+		input_event(fd->input, EV_ABS, ABS_MT_PRESSURE,
+				touch_report->area);
+	}
+}
+
+static int wtp_touchpad_raw_xy_event(struct hidpp_device *hidpp_dev,
+				u8 *event_data)
+{
+	struct hidpp_touchpad_raw_xy *raw =
+		(struct hidpp_touchpad_raw_xy *)event_data;
+	struct wtp_data *fd = (struct wtp_data *)hidpp_dev->driver_data;
+
+	int finger_count = raw->finger_count;
+	bool end_of_frame = raw->end_of_frame;
+
+	int i;
+
+	if (!hidpp_dev->initialized)
+		return 0;
+
+	if (finger_count) {
+		wtp_touch_event(fd, &(raw->fingers[0]));
+		if ((end_of_frame && finger_count == 4) ||
+			(!end_of_frame && finger_count >= 2))
+			wtp_touch_event(fd, &(raw->fingers[1]));
+	}
+
+	if (end_of_frame || finger_count <= 2) {
+		for (i = 0; i < ARRAY_SIZE(fd->slots); i++) {
+			if (!fd->slots[i].seen_in_this_frame &&
+				fd->slots[i].touch_state) {
+				input_mt_slot(fd->input, i);
+				input_mt_report_slot_state(fd->input,
+					MT_TOOL_FINGER, 0);
+				fd->slots[i].touch_state = 0;
+			}
+
+			fd->slots[i].seen_in_this_frame = false;
+
+		}
+		input_mt_report_pointer_emulation(fd->input, true);
+		input_report_key(fd->input, BTN_TOOL_FINGER,
+				 finger_count == 1);
+		input_report_key(fd->input, BTN_TOOL_DOUBLETAP,
+				 finger_count == 2);
+		input_report_key(fd->input, BTN_TOOL_TRIPLETAP,
+				 finger_count == 3);
+		input_report_key(fd->input, BTN_TOOL_QUADTAP,
+				 finger_count == 4);
+		input_sync(fd->input);
+	}
+	return 1;
+}
+
+
+static void hidpp_touchpad_touch_event(struct touch_hidpp_report *touch_report,
+	struct hidpp_touchpad_raw_xy_finger *finger)
+{
+	u8 x_m = touch_report->x_m << 2;
+	u8 y_m = touch_report->y_m << 2;
+
+	finger->contact_type = touch_report->x_m >> 6;
+	finger->x = x_m << 6 | touch_report->x_l;
+
+	finger->contact_status = touch_report->y_m >> 6;
+	finger->y = y_m << 6 | touch_report->y_l;
+
+	finger->finger_id = touch_report->id >> 4;
+	finger->z = touch_report->z;
+	finger->area = touch_report->area;
+}
+
+static int hidpp_touchpad_raw_xy_event(struct hidpp_device *hidpp_device,
+		struct hidpp_report *hidpp_report)
+{
+	struct dual_touch_hidpp_report *dual_touch_report;
+	struct hidpp_touchpad_raw_xy raw_xy;
+
+	dual_touch_report = (struct dual_touch_hidpp_report *)hidpp_report;
+	raw_xy.end_of_frame = dual_touch_report->touches[0].id & 0x01;
+	raw_xy.spurious_flag = (dual_touch_report->touches[0].id >> 1) & 0x01;
+	raw_xy.finger_count = dual_touch_report->touches[1].id & 0x0f;
+
+	if (raw_xy.finger_count) {
+		hidpp_touchpad_touch_event(&dual_touch_report->touches[0],
+				&raw_xy.fingers[0]);
+		if ((raw_xy.end_of_frame && raw_xy.finger_count == 4) ||
+			(!raw_xy.end_of_frame && raw_xy.finger_count >= 2))
+			hidpp_touchpad_touch_event(
+					&dual_touch_report->touches[1],
+					&raw_xy.fingers[1]);
+	}
+	return wtp_touchpad_raw_xy_event(hidpp_device, (u8 *)&raw_xy);
+}
+
+static int hidpp_touchpad_get_raw_info(struct hidpp_device *hidpp_dev,
+	struct hidpp_touchpad_raw_info *raw_info)
+{
+	struct hidpp_report response;
+	int ret;
+	u8 *params = (u8 *)response.fap.params;
+
+	ret = hidpp_send_fap_command_sync(hidpp_dev, WTP_RAW_XY_FEAT_INDEX,
+			CMD_TOUCHPAD_GET_RAW_INFO, NULL, 0, &response);
+
+	if (ret)
+		return -ret;
+
+	*raw_info = *(struct hidpp_touchpad_raw_info *)params;
+
+	raw_info->x_size = params[0] << 8 | params[1];
+	raw_info->y_size = params[2] << 8 | params[3];
+
+	return ret;
+}
+
+static int hidpp_touchpad_set_raw_report_state(struct hidpp_device *hidpp_dev,
+				bool send_raw_reports,
+				bool force_vs_area,
+				bool sensor_enhanced_settings)
+{
+	struct hidpp_report response;
+	int ret;
+	u8 params = send_raw_reports | force_vs_area << 1 |
+				sensor_enhanced_settings << 2;
+
+	ret = hidpp_send_fap_command_sync(hidpp_dev, WTP_RAW_XY_FEAT_INDEX,
+		CMD_TOUCHPAD_SET_RAW_REPORT_STATE, &params, 1, &response);
+
+	if (ret)
+		return -ret;
+
+	return ret;
+}
+
+static int wtp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	struct hidpp_device *hidpp_dev = hid_get_drvdata(hdev);
+	struct wtp_data *fd = (struct wtp_data *)hidpp_dev->driver_data;
+	struct input_dev *input = hi->input;
+
+	dbg_hid("%s:\n", __func__);
+
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_BUTTON)
+		return -1;
+
+	fd->input = hi->input;
+
+	__set_bit(BTN_TOUCH, input->keybit);
+	__set_bit(BTN_TOOL_FINGER, input->keybit);
+	__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
+	__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
+	__set_bit(BTN_TOOL_QUADTAP, input->keybit);
+
+	__set_bit(EV_ABS, input->evbit);
+
+	input_mt_init_slots(input, fd->maxcontacts);
+
+	input_set_capability(input, EV_KEY, BTN_TOUCH);
+
+	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
+	input_set_abs_params(input, ABS_MT_POSITION_X, 0, X_SIZE, 0, 0);
+	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, Y_SIZE, 0, 0);
+	input_set_abs_params(input, ABS_X, 0, X_SIZE, 0, 0);
+	input_set_abs_params(input, ABS_Y, 0, Y_SIZE, 0, 0);
+
+	return 0;
+}
+
+static void wtp_connect_change(struct hidpp_device *hidpp_dev, bool connected)
+{
+	dbg_hid("%s: connected:%d\n", __func__, connected);
+	if ((connected) && (hidpp_dev->initialized))
+		hidpp_touchpad_set_raw_report_state(hidpp_dev, true, true, true);
+}
+
+static int wtp_device_init(struct hidpp_device *hidpp_dev)
+{
+	int ret;
+	struct hidpp_touchpad_raw_info raw_info = {};
+	struct wtp_data *fd = (struct wtp_data *)hidpp_dev->driver_data;
+
+	dbg_hid("%s\n", __func__);
+
+	ret = hidpp_touchpad_set_raw_report_state(hidpp_dev, true, true, true);
+
+	if (ret) {
+		hid_err(hidpp_dev->hid_dev, "unable to set to raw report mode. "
+			"The device may not be in range.\n");
+		return ret;
+	}
+
+	ret = hidpp_touchpad_get_raw_info(hidpp_dev, &raw_info);
+
+	if (!ret) {
+		if ((X_SIZE != raw_info.x_size) || (Y_SIZE != raw_info.y_size))
+			hid_err(hidpp_dev->hid_dev,
+				"error getting size. Should have %dx%d, "
+				"but device reported %dx%d, ignoring\n",
+				X_SIZE, Y_SIZE,
+				raw_info.x_size, raw_info.y_size);
+
+		fd->x_size = raw_info.x_size;
+		fd->y_size = raw_info.y_size;
+	}
+
+	return ret;
+}
+
+static int wtp_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	struct wtp_data *fd;
+	struct hidpp_device *hidpp_device;
+	int ret;
+
+	dbg_hid("%s\n", __func__);
+
+	hidpp_device = kzalloc(sizeof(struct hidpp_device), GFP_KERNEL);
+	if (!hidpp_device) {
+		hid_err(hdev, "cannot allocate hidpp_device\n");
+		return -ENOMEM;
+	}
+
+	fd = kzalloc(sizeof(struct wtp_data), GFP_KERNEL);
+	if (!fd) {
+		hid_err(hdev, "cannot allocate wtp Touch data\n");
+		kfree(hidpp_device);
+		return -ENOMEM;
+	}
+
+	fd->mt_feature_index = 0x0f;
+	fd->button_feature_index = 0x02;
+	fd->maxcontacts = 5;
+
+	hidpp_device->driver_data = (void *)fd;
+	hid_set_drvdata(hdev, hidpp_device);
+
+	hidpp_device->device_init = wtp_device_init;
+	hidpp_device->connect_change = wtp_connect_change;
+	hidpp_device->raw_event = hidpp_touchpad_raw_xy_event;
+
+	ret = hid_parse(hdev);
+	if (ret)
+		goto parse_failed;
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret)
+		goto failed;
+
+	ret = hidpp_init(hidpp_device, hdev);
+	if (ret)
+		goto failed;
+
+	return 0;
+
+failed:
+	hid_hw_stop(hdev);
+parse_failed:
+	kfree(hidpp_device->driver_data);
+	kfree(hidpp_device);
+	hid_set_drvdata(hdev, NULL);
+	return -ENODEV;
+}
+
+static void wtp_remove(struct hid_device *hdev)
+{
+	struct hidpp_device *hidpp_dev = hid_get_drvdata(hdev);
+	struct wtp_data *fd = hidpp_dev->driver_data;
+	dbg_hid("%s\n", __func__);
+	hid_hw_stop(hdev);
+	hidpp_remove(hidpp_dev);
+	kfree(fd);
+	kfree(hidpp_dev);
+	hid_set_drvdata(hdev, NULL);
+}
+
+static const struct hid_device_id wtp_devices[] = {
+	{HID_DEVICE(BUS_DJ, USB_VENDOR_ID_LOGITECH, UNIFYING_DEVICE_ID_WIRELESS_TOUCHPAD) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, wtp_devices);
+
+static struct hid_driver wtp_driver = {
+	.name = "wtp-touch",
+	.id_table = wtp_devices,
+	.probe = wtp_probe,
+	.remove = wtp_remove,
+	.input_mapping = wtp_input_mapping,
+	.raw_event = hidpp_raw_event,
+};
+
+static int __init wtp_init(void)
+{
+	return hid_register_driver(&wtp_driver);
+}
+
+static void __exit wtp_exit(void)
+{
+	hid_unregister_driver(&wtp_driver);
+}
+
+module_init(wtp_init);
+module_exit(wtp_exit);
diff --git a/include/linux/input.h b/include/linux/input.h
index 3862e32..7e930e6 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -897,6 +897,7 @@ struct input_keymap_entry {
 #define BUS_GSC			0x1A
 #define BUS_ATARI		0x1B
 #define BUS_SPI			0x1C
+#define BUS_DJ			0x1D
 
 /*
  * MT_TOOL types
-- 
1.7.5.3

