Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1HKPYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:24:15 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:43310 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752837Ab1HKPYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:24:09 -0400
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <Benjamin_Tissoires@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtitmuss@logitech.com, ogay@logitech.com
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: [PATCH v2] HID: Add full support for Logitech Unifying receivers
Date: Thu, 11 Aug 2011 17:22:17 +0200
Message-Id: <1313076137-22590-1-git-send-email-nlopezcasad@logitech.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this driver, all the devices paired to a single Unifying
receiver are exposed to user processes in separated /input/dev
nodes.

Keyboards with different layouts can be treated differently,
Multiplayer games on single PC (like home theater PC) can
differentiate input coming from different kbds paired to the
same receiver.

Up to now, when Logitech Unifying receivers are connected to a
Linux based system, a single keyboard and a single mouse are
presented to the HID Layer, even if the Unifying receiver can
pair up to six compatible devices. The Unifying receiver by default
multiplexes all incoming events (from multiple keyboards/mice)
into these two.

Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
---

Hi everyone, 

 I took a second look at your comments with the help of Benjamin
 Tissoires, who is by the way working with us for a few weeks here
 at Logitech. 

 We finally agreed to remove BUS_DJ, as you suggested, and we are now
 using BUS_VIRTUAL. We can not use BUS_USB because that would assign 
 the hid-logitech-dj created "virtual" devices back to the hid-logitech-dj 
 module while they should be treated by hid-core.

 Concerning the conditional compilation on_id hid_have_special_driver[], 
 we also agreed to remove them. This implies that if the driver is not included
 by a certain distribution, then the receiver and all of the paired devices
 will not work at all. Note that today, even if there is no driver installed
 this devices work in a basic mode. For this reason we added a 'default m' in
 the Kconfig

 Overall, the totality of your suggestions have been addressed.

 Cheers, 
 Nestor 

 drivers/hid/Kconfig           |    9 +
 drivers/hid/Makefile          |    1 +
 drivers/hid/hid-core.c        |    2 +
 drivers/hid/hid-ids.h         |    3 +
 drivers/hid/hid-logitech-dj.c |  945 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-logitech-dj.h |  116 +++++
 6 files changed, 1076 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-logitech-dj.c
 create mode 100644 drivers/hid/hid-logitech-dj.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 306b15f..e0f1360 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -245,6 +245,15 @@ config HID_LOGITECH
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
 
+config HID_LOGITECH_DJ
+	tristate "Logitech Unifying receivers full support"
+	depends on HID_LOGITECH
+	default m
+	---help---
+	Say Y if you want support for Logitech Unifying receivers and devices.
+	Unifying receivers are capable of pairing up to 6 Logitech compliant
+	devices to the same receiver.
+
 config LOGITECH_FF
 	bool "Logitech force feedback support"
 	depends on HID_LOGITECH
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0a0a38e..ff36e489 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_HID_KEYTOUCH)	+= hid-keytouch.o
 obj-$(CONFIG_HID_KYE)		+= hid-kye.o
 obj-$(CONFIG_HID_LCPOWER)       += hid-lcpower.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
+obj-$(CONFIG_HID_LOGITECH_DJ)	+= hid-logitech-dj.o
 obj-$(CONFIG_HID_MAGICMOUSE)    += hid-magicmouse.o
 obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
 obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1a5cf0c..ab4ae12 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1419,6 +1419,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G27_WHEEL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index db63ccf..2081d1a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -443,6 +443,8 @@
 #define USB_DEVICE_ID_S510_RECEIVER_2	0xc517
 #define USB_DEVICE_ID_LOGITECH_CORDLESS_DESKTOP_LX500	0xc512
 #define USB_DEVICE_ID_MX3000_RECEIVER	0xc513
+#define USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER	0xc52b
+#define USB_DEVICE_ID_LOGITECH_UNIFYING_RECEIVER_2	0xc532
 #define USB_DEVICE_ID_SPACETRAVELLER	0xc623
 #define USB_DEVICE_ID_SPACENAVIGATOR	0xc626
 #define USB_DEVICE_ID_DINOVO_DESKTOP	0xc704
@@ -450,6 +452,7 @@
 #define USB_DEVICE_ID_DINOVO_MINI	0xc71f
 #define USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2	0xca03
 
+
 #define USB_VENDOR_ID_LUMIO		0x202e
 #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
 #define USB_DEVICE_ID_CRYSTALTOUCH_DUAL	0x0007
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
new file mode 100644
index 0000000..82091ca
--- /dev/null
+++ b/drivers/hid/hid-logitech-dj.c
@@ -0,0 +1,945 @@
+/*
+ *  HID driver for Logitech Unifying receivers
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
+ * your message to Nestor Lopez Casado <xnlopez at gmail com>
+ *
+ */
+
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include "usbhid/usbhid.h"
+#include "hid-ids.h"
+#include "hid-logitech-dj.h"
+
+/* Keyboard descriptor (1) */
+static const char kbd_descriptor[] = {
+	0x05, 0x01,		/* USAGE_PAGE (generic Desktop)     */
+	0x09, 0x06,		/* USAGE (Keyboard)         */
+	0xA1, 0x01,		/* COLLECTION (Application)     */
+	0x85, 0x01,		/* REPORT_ID (1)            */
+	0x95, 0x08,		/*   REPORT_COUNT (8)           */
+	0x75, 0x01,		/*   REPORT_SIZE (1)            */
+	0x15, 0x00,		/*   LOGICAL_MINIMUM (0)        */
+	0x25, 0x01,		/*   LOGICAL_MAXIMUM (1)        */
+	0x05, 0x07,		/*   USAGE_PAGE (Keyboard)      */
+	0x19, 0xE0,		/*   USAGE_MINIMUM (Left Control)   */
+	0x29, 0xE7,		/*   USAGE_MAXIMUM (Right GUI)      */
+	0x81, 0x02,		/*   INPUT (Data,Var,Abs)       */
+	0x95, 0x05,		/*   REPORT COUNT (5)           */
+	0x05, 0x08,		/*   USAGE PAGE (LED page)      */
+	0x19, 0x01,		/*   USAGE MINIMUM (1)          */
+	0x29, 0x05,		/*   USAGE MAXIMUM (5)          */
+	0x91, 0x02,		/*   OUTPUT (Data, Variable, Absolute)  */
+	0x95, 0x01,		/*   REPORT COUNT (1)           */
+	0x75, 0x03,		/*   REPORT SIZE (3)            */
+	0x91, 0x01,		/*   OUTPUT (Constant)          */
+	0x95, 0x06,		/*   REPORT_COUNT (6)           */
+	0x75, 0x08,		/*   REPORT_SIZE (8)            */
+	0x15, 0x00,		/*   LOGICAL_MINIMUM (0)        */
+	0x26, 0xFF, 0x00,	/*   LOGICAL_MAXIMUM (255)      */
+	0x05, 0x07,		/*   USAGE_PAGE (Keyboard)      */
+	0x19, 0x00,		/*   USAGE_MINIMUM (no event)       */
+	0x2A, 0xFF, 0x00,	/*   USAGE_MAXIMUM (reserved)       */
+	0x81, 0x00,		/*   INPUT (Data,Ary,Abs)       */
+	0xC0
+};
+
+/* Mouse descriptor (2)     */
+static const char mse_descriptor[] = {
+	0x05, 0x01,		/*  USAGE_PAGE (Generic Desktop)        */
+	0x09, 0x02,		/*  USAGE (Mouse)                       */
+	0xA1, 0x01,		/*  COLLECTION (Application)            */
+	0x85, 0x02,		/*    REPORT_ID = 2                     */
+	0x09, 0x01,		/*    USAGE (pointer)                   */
+	0xA1, 0x00,		/*    COLLECTION (physical)             */
+	0x05, 0x09,		/*      USAGE_PAGE (buttons)            */
+	0x19, 0x01,		/*      USAGE_MIN (1)                   */
+	0x29, 0x10,		/*      USAGE_MAX (16)                  */
+	0x15, 0x00,		/*      LOGICAL_MIN (0)                 */
+	0x25, 0x01,		/*      LOGICAL_MAX (1)                 */
+	0x95, 0x10,		/*      REPORT_COUNT (16)               */
+	0x75, 0x01,		/*      REPORT_SIZE (1)                 */
+	0x81, 0x02,		/*      INPUT (data var abs)            */
+	0x05, 0x01,		/*      USAGE_PAGE (generic desktop)    */
+	0x16, 0x01, 0xF8,	/*      LOGICAL_MIN (-2047)             */
+	0x26, 0xFF, 0x07,	/*      LOGICAL_MAX (2047)              */
+	0x75, 0x0C,		/*      REPORT_SIZE (12)                */
+	0x95, 0x02,		/*      REPORT_COUNT (2)                */
+	0x09, 0x30,		/*      USAGE (X)                       */
+	0x09, 0x31,		/*      USAGE (Y)                       */
+	0x81, 0x06,		/*      INPUT                           */
+	0x15, 0x81,		/*      LOGICAL_MIN (-127)              */
+	0x25, 0x7F,		/*      LOGICAL_MAX (127)               */
+	0x75, 0x08,		/*      REPORT_SIZE (8)                 */
+	0x95, 0x01,		/*      REPORT_COUNT (1)                */
+	0x09, 0x38,		/*      USAGE (wheel)                   */
+	0x81, 0x06,		/*      INPUT                           */
+	0x05, 0x0C,		/*      USAGE_PAGE(consumer)            */
+	0x0A, 0x38, 0x02,	/*      USAGE(AC Pan)                   */
+	0x95, 0x01,		/*      REPORT_COUNT (1)                */
+	0x81, 0x06,		/*      INPUT                           */
+	0xC0,			/*    END_COLLECTION                    */
+	0xC0,			/*  END_COLLECTION                      */
+};
+
+/* Consumer Control descriptor (3) */
+static const char consumer_descriptor[] = {
+	0x05, 0x0C,		/* USAGE_PAGE (Consumer Devices)       */
+	0x09, 0x01,		/* USAGE (Consumer Control)            */
+	0xA1, 0x01,		/* COLLECTION (Application)            */
+	0x85, 0x03,		/* REPORT_ID = 3                       */
+	0x75, 0x10,		/* REPORT_SIZE (16)                    */
+	0x95, 0x02,		/* REPORT_COUNT (2)                    */
+	0x15, 0x01,		/* LOGICAL_MIN (1)                     */
+	0x26, 0x8C, 0x02,	/* LOGICAL_MAX (652)                   */
+	0x19, 0x01,		/* USAGE_MIN (1)                       */
+	0x2A, 0x8C, 0x02,	/* USAGE_MAX (652)                     */
+	0x81, 0x00,		/* INPUT (Data Ary Abs)                */
+	0xC0,			/* END_COLLECTION                      */
+};				/*                                     */
+
+/* System control descriptor (4) */
+static const char syscontrol_descriptor[] = {
+	0x05, 0x01,		/*   USAGE_PAGE (Generic Desktop)      */
+	0x09, 0x80,		/*   USAGE (System Control)            */
+	0xA1, 0x01,		/*   COLLECTION (Application)          */
+	0x85, 0x04,		/*   REPORT_ID = 4                     */
+	0x75, 0x02,		/*   REPORT_SIZE (2)                   */
+	0x95, 0x01,		/*   REPORT_COUNT (1)                  */
+	0x15, 0x01,		/*   LOGICAL_MIN (1)                   */
+	0x25, 0x03,		/*   LOGICAL_MAX (3)                   */
+	0x09, 0x82,		/*   USAGE (System Sleep)              */
+	0x09, 0x81,		/*   USAGE (System Power Down)         */
+	0x09, 0x83,		/*   USAGE (System Wake Up)            */
+	0x81, 0x60,		/*   INPUT (Data Ary Abs NPrf Null)    */
+	0x75, 0x06,		/*   REPORT_SIZE (6)                   */
+	0x81, 0x03,		/*   INPUT (Cnst Var Abs)              */
+	0xC0,			/*   END_COLLECTION                    */
+};
+
+/* Media descriptor (8) */
+static const char media_descriptor[] = {
+	0x06, 0xbc, 0xff,	/* Usage Page 0xffbc                   */
+	0x09, 0x88,		/* Usage 0x0088                        */
+	0xa1, 0x01,		/* BeginCollection                     */
+	0x85, 0x08,		/*   Report ID 8                       */
+	0x19, 0x01,		/*   Usage Min 0x0001                  */
+	0x29, 0xff,		/*   Usage Max 0x00ff                  */
+	0x15, 0x01,		/*   Logical Min 1                     */
+	0x26, 0xff, 0x00,	/*   Logical Max 255                   */
+	0x75, 0x08,		/*   Report Size 8                     */
+	0x95, 0x01,		/*   Report Count 1                    */
+	0x81, 0x00,		/*   Input                             */
+	0xc0,			/* EndCollection                       */
+};				/*                                     */
+
+/* Maximum size of all defined hid reports in bytes (including report id) */
+#define MAX_REPORT_SIZE 8
+
+/* Number of possible hid report types that can be created by this driver.
+ *
+ * Right now, RF report types have the same report types (or report id's)
+ * than the hid report created from those RF reports. In the future
+ * this doesnt have to be true.
+ *
+ * For instance, RF report type 0x01 which has a size of 8 bytes, corresponds
+ * to hid report id 0x01, this is standard keyboard. Same thing applies to mice
+ * reports and consumer control, etc. If a new RF report is created, it doesn't
+ * has to have the same report id as its corresponding hid report, so an
+ * translation may have to take place for future report types.
+ */
+#define NUMBER_OF_HID_REPORTS 32
+static const u8 hid_reportid_size_map[NUMBER_OF_HID_REPORTS] = {
+	0,			/* Not used */
+	8,			/* Standard keyboard */
+	8,			/* Standard mouse */
+	5,			/* Consumer control */
+	2,			/* System control */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	2,			/* Media Center */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0,			/* Not used */
+	0			/* Not used */
+};
+
+
+#define LOGITECH_DJ_INTERFACE_NUMBER 0x02
+
+static struct hid_ll_driver logi_dj_ll_driver;
+
+static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
+					size_t count,
+					unsigned char report_type);
+
+static void logi_dj_recv_destroy_djhid_device(struct dj_receiver_dev *djrcv_dev,
+						struct dj_report *dj_report)
+{
+	/* Called in delayed work context */
+	struct dj_device *dj_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&djrcv_dev->lock, flags);
+	dj_dev = djrcv_dev->paired_dj_devices[dj_report->device_index];
+	djrcv_dev->paired_dj_devices[dj_report->device_index] = NULL;
+	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
+
+	if (dj_dev != NULL) {
+		hid_destroy_device(dj_dev->hdev);
+		kfree(dj_dev);
+	} else {
+		dev_err(&djrcv_dev->hdev->dev, "logi_dj_recv_destroy_djhid_device:"
+					"can't destroy a NULL device\n");
+	}
+}
+
+
+static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev
+					  *djrcv_dev,
+					  struct dj_report *dj_report)
+{
+	/* Called in delayed work context */
+	struct usb_interface *intf = to_usb_interface(djrcv_dev->hdev->dev.parent);
+	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct hid_device *dj_hiddev;
+	struct dj_device *dj_dev;
+	unsigned long flags;
+	unsigned char tmpstr[20];
+
+	if (dj_report->report_params[NOTIF_DEVICE_PAIRED_PARAM_SPFUNCTION] &
+	    SPFUNCTION_DEVICE_LIST_EMPTY) {
+		dbg_hid("logi_dj_recv_add_djhid_device: device list is empty\n");
+		return;
+	}
+
+	dj_hiddev = hid_allocate_device();
+	if (IS_ERR(dj_hiddev)) {
+		dev_err(&djrcv_dev->hdev->dev, "logi_dj_recv_add_djhid_device:"
+						"hid_allocate_device failed\n");
+		return;
+	}
+
+	dj_hiddev->ll_driver = &logi_dj_ll_driver;
+	dj_hiddev->hid_output_raw_report = logi_dj_output_hidraw_report;
+
+	dj_hiddev->dev.parent = &djrcv_dev->hdev->dev;
+	dj_hiddev->bus = BUS_VIRTUAL;
+	dj_hiddev->vendor = le16_to_cpu(usbdev->descriptor.idVendor);
+	dj_hiddev->product = le16_to_cpu(usbdev->descriptor.idProduct);
+	dj_hiddev->name[0] = 0;
+	strlcpy(dj_hiddev->name, "Logitech Unifying Device. ", sizeof(dj_hiddev->name));
+	snprintf(tmpstr, sizeof(tmpstr), "Wireless PID:%02x%02x",
+		dj_report->report_params[NOTIF_DEVICE_PAIRED_PARAM_EQUAD_ID_MSB],
+		dj_report->report_params[NOTIF_DEVICE_PAIRED_PARAM_EQUAD_ID_LSB]);
+	strlcat(dj_hiddev->name, tmpstr, sizeof(dj_hiddev->name));
+
+	usb_make_path(usbdev, dj_hiddev->phys, sizeof(dj_hiddev->phys));
+	snprintf(tmpstr, sizeof(tmpstr), ":%d", dj_report->device_index);
+	strlcat(dj_hiddev->phys, tmpstr, sizeof(dj_hiddev->phys));
+
+	dj_dev = kzalloc(sizeof(struct dj_device), GFP_KERNEL);
+
+	if (IS_ERR(dj_dev)) {
+		dev_err(&djrcv_dev->hdev->dev,
+			"logi_dj_recv_add_djhid_device:failed allocating dj_device\n");
+		goto dj_device_allocate_fail;
+	}
+
+	dj_dev->reports_supported = le32_to_cpu(
+			dj_report->
+			report_params[NOTIF_DEVICE_PAIRED_RF_REPORT_TYPE_LSB]);
+	dj_dev->hdev = dj_hiddev;
+	dj_dev->device_index = dj_report->device_index;
+	dj_hiddev->driver_data = dj_dev;
+
+	if (hid_add_device(dj_hiddev)) {
+		dev_err(&djrcv_dev->hdev->dev,
+			"logi_dj_recv_add_djhid_device:failed adding dj_device\n");
+		goto hid_add_device_fail;
+	}
+
+	spin_lock_irqsave(&djrcv_dev->lock, flags);
+	djrcv_dev->paired_dj_devices[dj_report->device_index] = dj_dev;
+	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
+
+	return;
+
+hid_add_device_fail:
+	kfree(dj_dev);
+dj_device_allocate_fail:
+	hid_destroy_device(dj_hiddev);
+}
+
+
+static int notif_fifo_push(struct dj_receiver_dev *djrcv_dev,
+			   struct dj_report *dj_report)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+
+	if (!djrcv_dev->notif_fifo_full) {
+		memcpy(&djrcv_dev->notif_fifo[djrcv_dev->notif_fifo_end &
+			(DJ_MAX_NUMBER_NOTIFICATIONS - 1)],
+			dj_report,
+			sizeof(struct dj_report));
+		djrcv_dev->notif_fifo_end++;
+
+		if (((djrcv_dev->notif_fifo_end ^ djrcv_dev->notif_fifo_start) &
+			(DJ_MAX_NUMBER_NOTIFICATIONS - 1)) == 0)
+				djrcv_dev->notif_fifo_full = 1;
+		return 0;
+	}
+	return -1;
+}
+
+static int notif_fifo_pop(struct dj_receiver_dev *djrcv_dev,
+			  struct dj_report *dj_report)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+
+	if ((djrcv_dev->notif_fifo_start != djrcv_dev->notif_fifo_end) ||
+	    (djrcv_dev->notif_fifo_full == 1)) {
+		memcpy(dj_report,
+		       &djrcv_dev->notif_fifo[djrcv_dev->notif_fifo_start &
+			   (DJ_MAX_NUMBER_NOTIFICATIONS - 1)],
+		       sizeof(struct dj_report));
+		djrcv_dev->notif_fifo_start++;
+		djrcv_dev->notif_fifo_full = 0;
+		return (djrcv_dev->notif_fifo_start !=
+			djrcv_dev->notif_fifo_end) ? 1 : 0;
+	}
+	return -1;
+}
+
+static void delayedwork_callback(struct work_struct *work)
+{
+	struct dj_receiver_dev *djrcv_dev =
+	    container_of(work, struct dj_receiver_dev, delayed_work);
+
+	struct dj_report dj_report;
+	unsigned long flags;
+	int process_more;
+
+	dbg_hid("delayedwork_callback\n");
+
+	spin_lock_irqsave(&djrcv_dev->lock, flags);
+	process_more = notif_fifo_pop(djrcv_dev, &dj_report);
+	if (process_more < 0) {
+		dev_err(&djrcv_dev->hdev->dev, "delayedwork_callback:"
+			"workitem triggered without notifications available\n");
+	} else if (process_more > 0) {
+		if (schedule_work(&djrcv_dev->delayed_work) == 0) {
+			dbg_hid("delayedwork_callback:"
+				" did not schedule the work item, was already queued\n");
+		}
+	}
+	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
+
+	if (dj_report.report_type == REPORT_TYPE_NOTIF_DEVICE_PAIRED)
+		logi_dj_recv_add_djhid_device(djrcv_dev, &dj_report);
+	else if (dj_report.report_type == REPORT_TYPE_NOTIF_DEVICE_UNPAIRED)
+		logi_dj_recv_destroy_djhid_device(djrcv_dev, &dj_report);
+	else
+		dbg_hid("delayedwork_callback: unexpected report type\n");
+}
+
+static int logi_dj_recv_queue_notification(struct dj_receiver_dev *djrcv_dev,
+					   struct dj_report *dj_report)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+
+	if (notif_fifo_push(djrcv_dev, dj_report)) {
+		dev_err(&djrcv_dev->hdev->dev,
+			"logi_dj_recv_queue_notification:"
+			"unexpected number of notifications arrived\n");
+		return 0;
+	}
+
+	if (schedule_work(&djrcv_dev->delayed_work) == 0) {
+		dbg_hid("logi_dj_recv_queue_notification:"
+			" did not schedule the work item, was already queued\n");
+	}
+	return 0;
+}
+
+static void logi_dj_recv_forward_null_report(struct dj_receiver_dev *djrcv_dev,
+					     struct dj_report *dj_report)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+	unsigned int i;
+	u8 reportbuffer[MAX_REPORT_SIZE];
+	struct dj_device *djdev;
+
+	memset(reportbuffer, 0, sizeof(reportbuffer));
+
+	if (djrcv_dev->paired_dj_devices[dj_report->device_index] == NULL) {
+		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
+			" is NULL, index %d\n", dj_report->device_index);
+		return;
+	}
+
+	djdev = djrcv_dev->paired_dj_devices[dj_report->device_index];
+
+	for (i = 0; i < NUMBER_OF_HID_REPORTS; i++) {
+		if (djdev->reports_supported & (1 << i)) {
+			reportbuffer[0] = i;
+			if (hid_input_report(djdev->hdev,
+					     HID_INPUT_REPORT,
+					     reportbuffer,
+					     hid_reportid_size_map[i], 1)) {
+				dbg_hid("hid_input_report error sending null report\n");
+			}
+		}
+	}
+}
+
+static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
+					struct dj_report *dj_report)
+{
+	/* We are called from atomic context (tasklet && djrcv->lock held) */
+
+	if (djrcv_dev->paired_dj_devices[dj_report->device_index] == NULL) {
+		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
+			" is NULL, index %d\n", dj_report->device_index);
+		return;
+	}
+
+	if ((dj_report->report_type > (ARRAY_SIZE(hid_reportid_size_map) - 1)) ||
+	    (hid_reportid_size_map[dj_report->report_type] == 0)) {
+		dbg_hid("invalid report type:%x\n", dj_report->report_type);
+		return;
+	}
+
+	if (hid_input_report(djrcv_dev->paired_dj_devices[dj_report->device_index]->hdev,
+			     HID_INPUT_REPORT, &dj_report->report_type,
+			     hid_reportid_size_map[dj_report->report_type], 1)) {
+		dbg_hid("hid_input_report error\n");
+	}
+
+	return;
+
+}
+
+
+static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
+				    struct dj_report *dj_report)
+{
+	struct hid_device *hdev = djrcv_dev->hdev;
+	int sent_bytes;
+
+	if (!hdev->hid_output_raw_report) {
+		dev_err(&hdev->dev, "logi_dj_recv_send_report:"
+			"hid_output_raw_report is null\n");
+		return -ENODEV;
+	}
+
+	sent_bytes = hdev->hid_output_raw_report(hdev, (u8 *) dj_report,
+						 sizeof(struct dj_report),
+						 HID_OUTPUT_REPORT);
+
+	return (sent_bytes < 0) ? sent_bytes : 0;
+}
+
+static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev
+					     *djrcv_dev)
+{
+	struct dj_report dj_report;
+
+	memset(&dj_report, 0, sizeof(dj_report));
+	dj_report.report_id = REPORT_ID_DJ_SHORT;
+	dj_report.device_index = 0xFF;
+	dj_report.report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
+	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+}
+
+static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev
+					  *djrcv_dev, unsigned timeout)
+{
+	struct dj_report dj_report;
+
+	memset(&dj_report, 0, sizeof(dj_report));
+	dj_report.report_id = REPORT_ID_DJ_SHORT;
+	dj_report.device_index = 0xFF;
+	dj_report.report_type = REPORT_TYPE_CMD_SWITCH;
+	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x1F;
+	dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8) timeout;
+	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+}
+
+
+static int logi_dj_ll_open(struct hid_device *hid)
+{
+	dbg_hid("logi_dj_ll_open:%s\n", hid->phys);
+	return 0;
+
+}
+
+static void logi_dj_ll_close(struct hid_device *hid)
+{
+	dbg_hid("logi_dj_ll_close:%s\n", hid->phys);
+}
+
+
+
+static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
+					size_t count,
+					unsigned char report_type)
+{
+	/* Called by hid raw to send data */
+	dbg_hid("logi_dj_output_hidraw_report\n");
+
+	return 0;
+}
+
+static int logi_dj_ll_parse(struct hid_device *hid)
+{
+	struct dj_device *djdev = hid->driver_data;
+	int retval = 0;
+
+	dbg_hid("logi_dj_ll_parse\n");
+
+	djdev->hdev->version = le16_to_cpu(0x0111);
+	djdev->hdev->country = 0x00;
+
+	if (djdev->reports_supported & STD_KEYBOARD) {
+		dbg_hid("logi_dj_ll_parse: "
+			"sending a kbd descriptor, reports_supported: %x\n",
+			djdev->reports_supported);
+		retval = hid_parse_report(hid,
+					  (u8 *) kbd_descriptor,
+					  sizeof(kbd_descriptor));
+		if (retval) {
+			dbg_hid("logi_dj_ll_parse:"
+				" sending a kbd descriptor, hid_parse failed error: %d\n",
+				retval);
+			return retval;
+		}
+	}
+
+	if (djdev->reports_supported & STD_MOUSE) {
+		dbg_hid("logi_dj_ll_parse:"
+			"sending a mouse descriptor, reports_supported: %x\n",
+			djdev->reports_supported);
+		retval = hid_parse_report(hid,
+					  (u8 *) mse_descriptor,
+					  sizeof(mse_descriptor));
+		if (retval) {
+			dbg_hid("logi_dj_ll_parse:"
+				" sending a mouse descriptor, hid_parse failed error: %d\n",
+				retval);
+			return retval;
+		}
+	}
+
+	if (djdev->reports_supported & MULTIMEDIA) {
+		dbg_hid("logi_dj_ll_parse:"
+			" sending a multimedia report descriptor: %x\n",
+			djdev->reports_supported);
+		retval = hid_parse_report(hid,
+					  (u8 *) consumer_descriptor,
+					  sizeof(consumer_descriptor));
+		if (retval) {
+			dbg_hid("logi_dj_ll_parse:"
+				" sending a consumer_descriptor, hid_parse failed error: %d\n",
+				retval);
+			return retval;
+		}
+	}
+
+	if (djdev->reports_supported & POWER_KEYS) {
+		dbg_hid("logi_dj_ll_parse:"
+			" sending a power keys report descriptor: %x\n",
+			djdev->reports_supported);
+		retval = hid_parse_report(hid,
+					  (u8 *) syscontrol_descriptor,
+					  sizeof(syscontrol_descriptor));
+		if (retval) {
+			dbg_hid("logi_dj_ll_parse:"
+				" sending a syscontrol_descriptor, hid_parse failed error: %d\n",
+				retval);
+			return retval;
+		}
+	}
+
+	if (djdev->reports_supported & MEDIA_CENTER) {
+		dbg_hid("logi_dj_ll_parse:"
+			" sending a media center report descriptor: %x\n",
+			djdev->reports_supported);
+		retval = hid_parse_report(hid,
+					  (u8 *) media_descriptor,
+					  sizeof(media_descriptor));
+		if (retval) {
+			dbg_hid("logi_dj_ll_parse:"
+				" sending a media_descriptor, hid_parse failed error: %d\n",
+				retval);
+			return retval;
+		}
+	}
+
+	if (djdev->reports_supported & KBD_LEDS) {
+		dbg_hid("logi_dj_ll_parse:"
+			" need to send kbd leds report descriptor: %x\n",
+			djdev->reports_supported);
+	}
+	return 0;
+
+}
+
+static int logi_dj_ll_input_event(struct input_dev *dev, unsigned int type,
+				  unsigned int code, int value)
+{
+	/* Sent by the input layer to handle leds and Force Feedback */
+	struct hid_device *dj_hiddev = input_get_drvdata(dev);
+	struct dj_device *dj_dev = dj_hiddev->driver_data;
+
+	struct dj_receiver_dev *djrcv_dev =
+	    dev_get_drvdata(dj_hiddev->dev.parent);
+	struct hid_device *dj_rcv_hiddev = djrcv_dev->hdev;
+
+	struct hid_field *field;
+	struct hid_report *report;
+	unsigned char data[8];
+	int offset;
+
+	dbg_hid("logi_dj_ll_input_event: %s, type:%d | code:%d | value:%d\n",
+		dev->phys, type, code, value);
+
+	if (type != EV_LED)
+		return -1;
+
+	offset = hidinput_find_field(dj_hiddev, type, code, &field);
+
+	if (offset == -1) {
+		dev_warn(&dev->dev, "event field not found\n");
+		return -1;
+	}
+	hid_set_field(field, offset, value);
+	hid_output_report(field->report, &data[0]);
+
+	report = dj_rcv_hiddev->
+		report_enum[HID_OUTPUT_REPORT].report_id_hash[REPORT_ID_DJ_SHORT];
+	hid_set_field(report->field[0], 0, dj_dev->device_index);
+	hid_set_field(report->field[0], 1, REPORT_TYPE_LEDS);
+	hid_set_field(report->field[0], 2, data[1]);
+
+	usbhid_submit_report(dj_rcv_hiddev, report, USB_DIR_OUT);
+
+	return 0;
+
+}
+
+static int logi_dj_ll_start(struct hid_device *hid)
+{
+	dbg_hid("logi_dj_ll_start\n");
+	return 0;
+}
+
+static void logi_dj_ll_stop(struct hid_device *hid)
+{
+	dbg_hid("logi_dj_ll_stop\n");
+}
+
+static int logi_dj_ll_power(struct hid_device *hid, int lvl)
+{
+
+	dbg_hid("logi_dj_ll_power\n");
+	return 0;
+}
+
+
+static struct hid_ll_driver logi_dj_ll_driver = {
+	.parse = logi_dj_ll_parse,
+	.start = logi_dj_ll_start,
+	.stop = logi_dj_ll_stop,
+	.open = logi_dj_ll_open,
+	.close = logi_dj_ll_close,
+	.power = logi_dj_ll_power,
+	.hidinput_input_event = logi_dj_ll_input_event,
+};
+
+
+static int logi_dj_raw_event(struct hid_device *hdev,
+			     struct hid_report *report, u8 * data,
+			     int size)
+{
+	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
+	struct dj_report *dj_report = (struct dj_report *) data;
+	unsigned long flags;
+	int report_processed = 0;
+
+	dbg_hid("logi_dj_raw_event, size:%d\n", size);
+
+	/* Here we receive all data coming from iface 2, there are 4 cases:
+	 *
+	 * 1) Data should continue its normal processing i.e. data does not
+	 * come from the DJ collection, in which case we do nothing and
+	 * return 0, so hid-core can continue normal processing (will forward
+	 * to associated hidraw device)
+	 *
+	 * 2) Data is from DJ collection, and is intended for this driver i. e.
+	 * data contains arrival, departure, etc notifications, in which case
+	 * we queue them for delayed processing by the work queue. We return 1
+	 * to hid-core as no further processing is required from it.
+	 *
+	 * 3) Data is from DJ collection, and informs a connection change,
+	 * if the change means rf link loss, then we must send a null report
+	 * to the upper layer to discard potentially pressed keys that may be
+	 * repeated forever by the input layer. Return 1 to hid-core as no further
+	 * processing is required.
+	 *
+	 * 4) Data is from DJ collection and is an actual input event from
+	 * a paired DJ device in which case we forward it to the correct hid
+	 * device (via hid_input_report() ) and return 1 so hid-core does not do
+	 * anything else with it.
+	 */
+
+	spin_lock_irqsave(&djrcv_dev->lock, flags);
+	if (dj_report->report_id == REPORT_ID_DJ_SHORT) {
+		if ((dj_report->report_type == REPORT_TYPE_NOTIF_DEVICE_PAIRED) ||
+		    (dj_report->report_type == REPORT_TYPE_NOTIF_DEVICE_UNPAIRED)) {
+			logi_dj_recv_queue_notification(djrcv_dev, dj_report);
+		} else if (dj_report->report_type == REPORT_TYPE_NOTIF_CONNECTION_STATUS) {
+			if (dj_report->report_params[NOTIF_CONNECTION_STATUS_PARAM_STATUS] ==
+			    STATUS_LINKLOSS) {
+				logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
+			}
+		} else {
+			logi_dj_recv_forward_report(djrcv_dev, dj_report);
+		}
+		report_processed = 1;
+	}
+	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
+
+
+	return report_processed;
+}
+
+static int logi_dj_probe(struct hid_device *hdev,
+			 const struct hid_device_id *id)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct dj_receiver_dev *djrcv_dev;
+	int retval = 0;
+
+	dbg_hid("logi_dj_probe called for ifnum %d\n",
+		intf->cur_altsetting->desc.bInterfaceNumber);
+
+	/* Ignore interfaces 0 and 1, they will not carry any data, dont create
+	 * any hid_device for them */
+	if (intf->cur_altsetting->desc.bInterfaceNumber !=
+	    LOGITECH_DJ_INTERFACE_NUMBER) {
+		dbg_hid("logi_dj_probe: ignoring ifnum %d\n",
+			intf->cur_altsetting->desc.bInterfaceNumber);
+		return -ENODEV;
+	}
+
+	/* Treat interface 2 */
+
+	djrcv_dev = kzalloc(sizeof(struct dj_receiver_dev), GFP_KERNEL);
+	if (IS_ERR(djrcv_dev)) {
+		dev_err(&hdev->dev,
+			"logi_dj_probe:failed allocating dj_receiver_dev\n");
+		return -ENOMEM;
+	}
+	djrcv_dev->hdev = hdev;
+	INIT_WORK(&djrcv_dev->delayed_work, delayedwork_callback);
+	spin_lock_init(&djrcv_dev->lock);
+	hid_set_drvdata(hdev, djrcv_dev);
+
+	/* Call  to usbhid to fetch the HID descriptors of interface 2 and subsequently
+	 * call to the hid/hid-core to parse the fetched descriptors, this will in turn
+	 * create the hidraw and hiddev nodes for interface 2 of the receiver */
+	retval = hid_parse(hdev);
+	if (retval) {
+		dev_err(&hdev->dev,
+			"logi_dj_probe:parse of interface 2 failed\n");
+		goto hid_parse_fail;
+	}
+
+	/* Starts the usb device and connects to upper interfaces hiddev and hidraw */
+	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (retval) {
+		dev_err(&hdev->dev,
+			"logi_dj_probe:hid_hw_start returned error\n");
+		goto hid_hw_start_fail;
+	}
+
+	retval = logi_dj_recv_switch_to_dj_mode(djrcv_dev, 0);
+	if (retval < 0) {
+		dev_err(&hdev->dev,
+			"logi_dj_probe:logi_dj_recv_switch_to_dj_mode returned error:%d\n",
+			retval);
+		goto switch_to_dj_mode_fail;
+	}
+
+	/* This is enabling the polling urb on the IN endpoint */
+	retval = hdev->ll_driver->open(hdev);
+	if (retval < 0) {
+		dev_err(&hdev->dev,
+			"logi_dj_probe:hdev->ll_driver->open returned error:%d\n",
+			retval);
+		goto llopen_failed;
+	}
+
+	retval = logi_dj_recv_query_paired_devices(djrcv_dev);
+	if (retval < 0) {
+		dev_err(&hdev->dev,
+			"logi_dj_probe:logi_dj_recv_query_paired_devices error:%d\n",
+			retval);
+		goto logi_dj_recv_query_paired_devices_failed;
+	}
+
+	return retval;
+
+logi_dj_recv_query_paired_devices_failed:
+	hdev->ll_driver->close(hdev);
+
+llopen_failed:
+switch_to_dj_mode_fail:
+	hid_hw_stop(hdev);
+
+hid_hw_start_fail:
+hid_parse_fail:
+	kfree(djrcv_dev);
+	hid_set_drvdata(hdev, NULL);
+	return retval;
+
+}
+
+static void logi_dj_remove(struct hid_device *hdev)
+{
+	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
+	struct dj_device *dj_dev;
+	int i;
+
+	dbg_hid("logi_dj_remove\n");
+
+	cancel_work_sync(&djrcv_dev->delayed_work);
+
+	/* I suppose that at this point the only context that can access
+	 * the djrecv_data is this thread as the work item is guaranteed to
+	 * have finished and no more raw_event callbacks should arrive after
+	 * the remove callback was triggered so no locks are put around the
+	 * code below */
+	for (i = 0; i < DJ_MAX_PAIRED_DEVICES; i++) {
+		dj_dev = djrcv_dev->paired_dj_devices[i];
+		if (dj_dev != NULL) {
+			hid_destroy_device(dj_dev->hdev);
+			kfree(dj_dev);
+			djrcv_dev->paired_dj_devices[i] = NULL;
+		}
+	}
+
+	hdev->ll_driver->close(hdev);
+	hid_hw_stop(hdev);
+	/* Free the dj_recv_dev struct */
+	kfree(hid_get_drvdata(hdev));
+	hid_set_drvdata(hdev, NULL);
+}
+
+static const struct hid_device_id logi_dj_receivers[] = {
+	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xc52b)},
+	{HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xc532)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(hid, logi_dj_receivers);
+
+static struct hid_driver logi_djreceiver_driver = {
+	.name = "logitech-djreceiver",
+	.id_table = logi_dj_receivers,
+	.probe = logi_dj_probe,
+	.remove = logi_dj_remove,
+	.raw_event = logi_dj_raw_event
+};
+
+#define HID_DEVICE(b, ven, prod) \
+	.bus = (b), \
+	.vendor = (ven), .product = (prod)
+
+
+static const struct hid_device_id logi_dj_devices[] = {
+	{HID_DEVICE(BUS_VIRTUAL, HID_ANY_ID, HID_ANY_ID)},
+	{}
+};
+
+static struct hid_driver logi_djdevice_driver = {
+	.name = "generic-dj",
+	.id_table = logi_dj_devices,
+};
+
+
+static int __init logi_dj_init(void)
+{
+	int retval = 0;
+
+	dbg_hid("Logitech-DJ:logi_dj_init\n");
+
+	retval = hid_register_driver(&logi_djreceiver_driver);
+	if (retval)
+		return retval;
+
+	retval = hid_register_driver(&logi_djdevice_driver);
+	if (retval)
+		hid_unregister_driver(&logi_djreceiver_driver);
+
+	return retval;
+
+}
+
+static void __exit logi_dj_exit(void)
+{
+	dbg_hid("Logitech-DJ:logi_dj_exit\n");
+
+	hid_unregister_driver(&logi_djdevice_driver);
+	hid_unregister_driver(&logi_djreceiver_driver);
+
+}
+
+module_init(logi_dj_init);
+module_exit(logi_dj_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Logitech");
+MODULE_AUTHOR("Nestor Lopez Casado");
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
new file mode 100644
index 0000000..459e1f0
--- /dev/null
+++ b/drivers/hid/hid-logitech-dj.h
@@ -0,0 +1,116 @@
+#ifndef __HID_LOGITECH_DJ_H
+#define __HID_LOGITECH_DJ_H
+
+/*
+ *  HID driver for Logitech Unifying receivers
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
+ * your message to Nestor Lopez Casado <xnlopez at gmail com>
+ *
+ */
+
+#define DJ_MAX_PAIRED_DEVICES   6
+#define DJ_MAX_NUMBER_NOTIFICATIONS   8
+
+#define DJREPORT_SHORT_LENGTH  15
+#define DJREPORT_LONG_LENGTH   32
+
+#define REPORT_ID_HIDPP_SHORT  0x10
+#define REPORT_ID_HIDPP_LONG   0x11
+#define REPORT_ID_DJ_SHORT     0x20
+#define REPORT_ID_DJ_LONG      0x21
+
+#define REPORT_TYPE_RFREPORT_FIRST            0x01
+#define REPORT_TYPE_RFREPORT_LAST             0x1F
+
+/* Command Switch to DJ mode */
+#define REPORT_TYPE_CMD_SWITCH              0x80
+#define CMD_SWITCH_PARAM_DEVBITFIELD        0x00
+#define CMD_SWITCH_PARAM_TIMEOUT_SECONDS    0x01
+#define TIMEOUT_NO_KEEPALIVE                0x00
+
+/* Command to Get the list of Paired devices */
+#define REPORT_TYPE_CMD_GET_PAIRED_DEVICES  0x81
+
+/* Device Paired Notification */
+#define REPORT_TYPE_NOTIF_DEVICE_PAIRED             0x41
+#define NOTIF_DEVICE_PAIRED_PARAM_SPFUNCTION        0x00
+#define SPFUNCTION_MORE_NOTIF_EXPECTED              0x01
+#define SPFUNCTION_DEVICE_LIST_EMPTY                0x02
+#define NOTIF_DEVICE_PAIRED_PARAM_EQUAD_ID_LSB      0x01
+#define NOTIF_DEVICE_PAIRED_PARAM_EQUAD_ID_MSB      0x02
+#define NOTIF_DEVICE_PAIRED_RF_REPORT_TYPE_LSB      0x03
+#define NOTIF_DEVICE_PAIRED_RF_REPORT_TYPE_MSB      0x06
+
+/* Device Un-Paired Notification */
+#define REPORT_TYPE_NOTIF_DEVICE_UNPAIRED           0x40
+
+
+/* Connection Status Notification */
+#define REPORT_TYPE_NOTIF_CONNECTION_STATUS         0x42
+#define NOTIF_CONNECTION_STATUS_PARAM_STATUS        0x00
+#define STATUS_LINKLOSS                             0x01
+
+/* Error Notification */
+#define REPORT_TYPE_NOTIF_ERROR     0x7F
+#define NOTIF_ERROR_PARAM_ETYPE     0x00
+#define ETYPE_KEEPALIVE_TIMEOUT     0x01
+
+/* supported DJ HID && RF report types */
+#define REPORT_TYPE_KEYBOARD            0x01
+#define REPORT_TYPE_MOUSE               0x02
+#define REPORT_TYPE_CONSUMER_CONTROL    0x03
+#define REPORT_TYPE_SYSTEM_CONTROL      0x04
+#define REPORT_TYPE_MEDIA_CENTER        0x08
+#define REPORT_TYPE_LEDS                0x0E
+
+/* RF Report types bitfield */
+#define STD_KEYBOARD    0x00000002
+#define STD_MOUSE       0x00000004
+#define MULTIMEDIA      0x00000008
+#define POWER_KEYS      0x00000010
+#define MEDIA_CENTER    0x00000100
+#define KBD_LEDS        0x00004000
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
+	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES];
+	struct work_struct delayed_work;
+	struct dj_report notif_fifo[DJ_MAX_NUMBER_NOTIFICATIONS];
+	u32 notif_fifo_start;
+	u32 notif_fifo_end;
+	u32 notif_fifo_full;
+	spinlock_t lock;
+};
+
+struct dj_device {
+	struct hid_device *hdev;
+	u32 reports_supported;
+	u32 device_index;
+};
+
+#endif
-- 
1.7.5.3

