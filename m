Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0IACCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:02:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61545 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0IACCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NOOHt7wbWbLN6GmeXTpBWXo5ol4fpe1Ybh9Ay7aY4HeUSIH8nSNKEQ9pO4QsjsyPrA
         WaDcsD99N+iupaiEHUiDU89NJuPa0BkilMui8+0jLVtL9weD4E5d0hdiqOlWUHAmkaar
         VVPWdXTMmbyQ87bzG8bv2NsPaUb1r1GZSfjBE=
Date: Tue, 31 Aug 2010 19:02:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: jkosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] input: Add support for Hanwang tablet
Message-ID: <20100901020243.GB23585@core.coreip.homeip.net>
References: <201008311614464536827@hanwang.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008311614464536827@hanwang.com.cn>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 04:14:46PM +0800, Xing Wei wrote:
> +
> +struct hanwang_state {
> +	unsigned int tool_style;
> +	unsigned int tool_state;

tool_state is not used anywhere.

> +	} else if (data[0] == 0x0c) {	/* roll wheel */
> +		if (data[1])
> +			input_report_abs(input_dev, ABS_WHEEL, data[1]);

Unlike REL_* events you need to send 0 ABS events since in absence of
ABS_* event in a packet it is assumed to have the same value as last
time. Thus once you move wheel it will never go back to 0.

> +		input_report_key(input_dev, BTN_0, data[2]);
> +		input_report_key(input_dev, BTN_1, data[3] & 0x01);
> +		input_report_key(input_dev, BTN_2, data[3] & 0x02);
> +		input_report_key(input_dev, BTN_3, data[3] & 0x04);
> +		input_report_key(input_dev, BTN_4, data[3] & 0x08);
> +		input_report_key(input_dev, BTN_5, data[3] & 0x10);
> +		input_report_key(input_dev, BTN_6, data[3] & 0x20);
> +		input_report_key(input_dev, BTN_7, data[3] & 0x30);

0x30 is suspicious. Can't it be

		for (i = 0; i < 8; i++)
			input_report_key(input_dev, BTN_1 + i,
					 data[3] & (1 << i));

I adjusted the patch a bit, could you please tell me if it still works
for you and I will apply it.

Thanks!

Hmm, one more thing - the device clams to have ABS_DISTANCE but I do not
see where it sends such events...

-- 
Dmitry

Input: Add support for Hanwang tablet

From: Xing Wei <weixing@hanwang.com.cn>

Add support for Art Master III tablet of BeiJing HanwangTechnology Co, Ltd.

Signed-off-by: Xing Wei <weixing@hanwang.com.cn>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/hid/hid-core.c         |    5 +
 drivers/hid/hid-ids.h          |    4 
 drivers/input/tablet/Kconfig   |   11 +
 drivers/input/tablet/Makefile  |    1 
 drivers/input/tablet/hanwang.c |  370 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 391 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/tablet/hanwang.c


diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 94ab532..7e36c02 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1770,6 +1770,11 @@ static bool hid_ignore(struct hid_device *hdev)
 		    hdev->product <= USB_DEVICE_ID_SOUNDGRAPH_IMON_LAST)
 			return true;
 		break;
+	case USB_VENDOR_ID_HANWANG:
+		if (hdev->product >= USB_DEVICE_ID_HANWANG_TABLET_FIRST &&
+		    hdev->product <= USB_DEVICE_ID_HANWANG_TABLET_LAST)
+			return true;
+		break;
 	}
 
 	if (hdev->type == HID_TYPE_USBMOUSE &&
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4dc4c18..0c19cd2 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -293,6 +293,10 @@
 #define USB_DEVICE_ID_GYRATION_REMOTE_2 0x0003
 #define USB_DEVICE_ID_GYRATION_REMOTE_3 0x0008
 
+#define USB_VENDOR_ID_HANWANG		0x0b57
+#define USB_DEVICE_ID_HANWANG_TABLET_FIRST	0x5000
+#define USB_DEVICE_ID_HANWANG_TABLET_LAST	0x8fff
+
 #define USB_VENDOR_ID_HAPP		0x078b
 #define USB_DEVICE_ID_UGCI_DRIVING	0x0010
 #define USB_DEVICE_ID_UGCI_FLYING	0x0020
diff --git a/drivers/input/tablet/Kconfig b/drivers/input/tablet/Kconfig
index effb49e..58a8775 100644
--- a/drivers/input/tablet/Kconfig
+++ b/drivers/input/tablet/Kconfig
@@ -49,6 +49,17 @@ config TABLET_USB_GTCO
           To compile this driver as a module, choose M here: the
           module will be called gtco.
 
+config TABLET_USB_HANWANG
+	tristate "Hanwang Art Master III tablet support (USB)"
+	depends on USB_ARCH_HAS_HCD
+	select USB
+	help
+	  Say Y here if you want to use the USB version of the Hanwang Art
+	  Master III tablet.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hanwang.
+
 config TABLET_USB_KBTAB
 	tristate "KB Gear JamStudio tablet support (USB)"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/input/tablet/Makefile b/drivers/input/tablet/Makefile
index ce8b9a9..3f6c252 100644
--- a/drivers/input/tablet/Makefile
+++ b/drivers/input/tablet/Makefile
@@ -8,5 +8,6 @@ wacom-objs	:= wacom_wac.o wacom_sys.o
 obj-$(CONFIG_TABLET_USB_ACECAD)	+= acecad.o
 obj-$(CONFIG_TABLET_USB_AIPTEK)	+= aiptek.o
 obj-$(CONFIG_TABLET_USB_GTCO)	+= gtco.o
+obj-$(CONFIG_TABLET_USB_HANWANG) += hanwang.o
 obj-$(CONFIG_TABLET_USB_KBTAB)	+= kbtab.o
 obj-$(CONFIG_TABLET_USB_WACOM)	+= wacom.o
diff --git a/drivers/input/tablet/hanwang.c b/drivers/input/tablet/hanwang.c
new file mode 100644
index 0000000..21cb6c2
--- /dev/null
+++ b/drivers/input/tablet/hanwang.c
@@ -0,0 +1,370 @@
+/*
+ *  USB Hanwang tablet support
+ *
+ *  Copyright (c) 2010 Xing Wei <weixing@hanwang.com.cn>
+ *
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/usb/input.h>
+
+#define DRIVER_AUTHOR   "Xing Wei <weixing@hanwang.com.cn>"
+#define DRIVER_DESC     "USB Hanwang tablet driver"
+#define DRIVER_LICENSE  "GPL"
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENSE);
+
+#define USB_VENDOR_ID_HANWANG		0x0b57
+#define HANWANG_TABLET_INT_CLASS	0x0003
+#define HANWANG_TABLET_INT_SUB_CLASS	0x0001
+#define HANWANG_TABLET_INT_PROTOCOL	0x0002
+
+#define ART_MASTERIII_PKGLEN_MAX	10
+
+/* match vendor and interface info  */
+#define HANWANG_TABLET_DEVICE(vend, cl, sc, pr) \
+	.match_flags = USB_DEVICE_ID_MATCH_VENDOR \
+		| USB_DEVICE_ID_MATCH_INT_INFO, \
+	.idVendor = (vend), \
+	.bInterfaceClass = (cl), \
+	.bInterfaceSubClass = (sc), \
+	.bInterfaceProtocol = (pr)
+
+struct hanwang {
+	unsigned char *data;
+	dma_addr_t data_dma;
+	struct input_dev *dev;
+	struct usb_device *usbdev;
+	struct urb *irq;
+	const struct hanwang_features *features;
+	unsigned int current_tool;
+	char name[64];
+	char phys[32];
+};
+
+struct hanwang_features {
+	unsigned short pid;
+	char *name;
+	int pkg_len;
+	int max_x;
+	int max_y;
+	int max_tilt_x;
+	int max_tilt_y;
+	int max_pressure;
+	int max_distance;
+};
+
+static const struct hanwang_features features_array[] = {
+	{ 0x8528, "Hanwang Art Master III 0906",
+	  ART_MASTERIII_PKGLEN_MAX, 0x5757, 0x3692, 0x3f, 0x7f, 2048, 0xff },
+	{ 0x8529, "Hanwang Art Master III 0604",
+	  ART_MASTERIII_PKGLEN_MAX, 0x3d84, 0x2672, 0x3f, 0x7f, 2048, 0xff },
+	{ 0x852a, "Hanwang Art Master III 1308",
+	  ART_MASTERIII_PKGLEN_MAX, 0x7f00, 0x4f60, 0x3f, 0x7f, 2048, 0xff },
+};
+
+static const int hw_eventtypes[] = {
+	EV_KEY, EV_ABS,
+};
+
+static const int hw_absevents[] = {
+	ABS_X, ABS_Y, ABS_TILT_X, ABS_TILT_Y, ABS_WHEEL,
+	ABS_PRESSURE, ABS_DISTANCE
+};
+
+static const int hw_btnevents[] = {
+	BTN_STYLUS, BTN_STYLUS2, BTN_TOOL_PEN, BTN_TOOL_RUBBER,
+	BTN_TOOL_MOUSE, BTN_0, BTN_1, BTN_2, BTN_3, BTN_4,
+	BTN_5, BTN_6, BTN_7, BTN_8
+};
+
+static void hanwang_parse_packet(struct hanwang *hanwang)
+{
+	unsigned char *data = hanwang->data;
+	struct input_dev *input_dev = hanwang->dev;
+	struct usb_device *dev = hanwang->usbdev;
+	int i;
+
+	switch (data[0]) {
+	case 0x02:	/* data packet */
+		switch (data[1]) {
+		case 0x80:	/* tool prox out */
+			input_report_key(input_dev, hanwang->current_tool, 0);
+			break;
+
+		case 0xc2:	/* first time tool prox in */
+			switch (data[3] & 0xf0) {
+			case 0x20:
+				hanwang->current_tool = BTN_TOOL_PEN;
+				input_report_key(input_dev, BTN_TOOL_PEN, 1);
+				break;
+			case 0xa0:
+				hanwang->current_tool = BTN_TOOL_RUBBER;
+				input_report_key(input_dev, BTN_TOOL_RUBBER, 1);
+				break;
+			default:
+				dev_dbg(&dev->dev,
+					"unknown tablet tool %02x ", data[0]);
+				break;
+			}
+			break;
+
+		default:	/* tool data packet */
+			input_report_abs(input_dev, ABS_X,
+					 (data[2] << 8) | data[3]);
+			input_report_abs(input_dev, ABS_Y,
+					 (data[4] << 8) | data[5]);
+			input_report_abs(input_dev, ABS_PRESSURE,
+					 (data[6] << 3) |
+					 ((data[7] & 0xc0) >> 5) |
+					 (data[1] & 0x01));
+			input_report_abs(input_dev, ABS_TILT_X, data[7] & 0x3f);
+			input_report_abs(input_dev, ABS_TILT_Y, data[8] & 0x7f);
+			input_report_key(input_dev, BTN_STYLUS, data[1] & 0x02);
+			input_report_key(input_dev, BTN_STYLUS2, data[1] & 0x04);
+			break;
+		}
+		break;
+
+	case 0x0c:
+		/* roll wheel */
+		input_report_abs(input_dev, ABS_WHEEL, data[1]);
+		input_report_key(input_dev, BTN_0, data[2]);
+		for (i = 0; i < 8; i++)
+			input_report_key(input_dev,
+					 BTN_1 + i, data[3] & (1 << i));
+		break;
+
+	default:
+		dev_dbg(&dev->dev, "error packet  %02x ", data[0]);
+		break;
+	}
+
+	input_sync(input_dev);
+}
+
+static void hanwang_irq(struct urb *urb)
+{
+	struct hanwang *hanwang = urb->context;
+	struct usb_device *dev = hanwang->usbdev;
+	int retval;
+
+	switch (urb->status) {
+	case 0:
+		/* success */;
+		hanwang_parse_packet(hanwang);
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dev_err(&dev->dev, "%s - urb shutting down with status: %d",
+			__func__, urb->status);
+		return;
+	default:
+		dev_err(&dev->dev, "%s - nonzero urb status received: %d",
+			__func__, urb->status);
+		break;
+	}
+
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (retval)
+		dev_err(&dev->dev, "%s - usb_submit_urb failed with result %d",
+			__func__, retval);
+}
+
+static int hanwang_open(struct input_dev *dev)
+{
+	struct hanwang *hanwang = input_get_drvdata(dev);
+
+	hanwang->irq->dev = hanwang->usbdev;
+	if (usb_submit_urb(hanwang->irq, GFP_KERNEL))
+		return -EIO;
+
+	return 0;
+}
+
+static void hanwang_close(struct input_dev *dev)
+{
+	struct hanwang *hanwang = input_get_drvdata(dev);
+
+	usb_kill_urb(hanwang->irq);
+}
+
+static bool get_features(struct usb_device *dev, struct hanwang *hanwang)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(features_array); i++) {
+		if (le16_to_cpu(dev->descriptor.idProduct) ==
+				features_array[i].pid) {
+			hanwang->features = &features_array[i];
+			return true;
+		}
+	}
+
+	return false;
+}
+
+
+static int hanwang_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *endpoint;
+	struct hanwang *hanwang;
+	struct input_dev *input_dev;
+	int error;
+	int i;
+
+	hanwang = kzalloc(sizeof(struct hanwang), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!hanwang || !input_dev) {
+		error = -ENOMEM;
+		goto fail1;
+	}
+
+	if (!get_features(dev, hanwang)) {
+		error = -ENXIO;
+		goto fail1;
+	}
+
+	hanwang->data = usb_alloc_coherent(dev, hanwang->features->pkg_len,
+					GFP_KERNEL, &hanwang->data_dma);
+	if (!hanwang->data) {
+		error = -ENOMEM;
+		goto fail1;
+	}
+
+	hanwang->irq = usb_alloc_urb(0, GFP_KERNEL);
+	if (!hanwang->irq) {
+		error = -ENOMEM;
+		goto fail2;
+	}
+
+	hanwang->usbdev = dev;
+	hanwang->dev = input_dev;
+
+	usb_make_path(dev, hanwang->phys, sizeof(hanwang->phys));
+	strlcat(hanwang->phys, "/input0", sizeof(hanwang->phys));
+
+	strlcpy(hanwang->name, hanwang->features->name, sizeof(hanwang->name));
+	input_dev->name = hanwang->name;
+	input_dev->phys = hanwang->phys;
+	usb_to_input_id(dev, &input_dev->id);
+	input_dev->dev.parent = &intf->dev;
+
+	input_set_drvdata(input_dev, hanwang);
+
+	input_dev->open = hanwang_open;
+	input_dev->close = hanwang_close;
+
+	for (i = 0; i < ARRAY_SIZE(hw_eventtypes); ++i)
+		__set_bit(hw_eventtypes[i], input_dev->evbit);
+
+	for (i = 0; i < ARRAY_SIZE(hw_absevents); ++i)
+		__set_bit(hw_absevents[i], input_dev->absbit);
+
+	for (i = 0; i < ARRAY_SIZE(hw_btnevents); ++i)
+		__set_bit(hw_btnevents[i], input_dev->keybit);
+
+	input_set_abs_params(input_dev, ABS_X,
+			     0, hanwang->features->max_x, 4, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			     0, hanwang->features->max_y, 4, 0);
+	input_set_abs_params(input_dev, ABS_TILT_X,
+			     0, hanwang->features->max_tilt_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_TILT_Y,
+			     0, hanwang->features->max_tilt_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE,
+			     0, hanwang->features->max_pressure, 0, 0);
+	input_set_abs_params(input_dev, ABS_DISTANCE,
+			     0, hanwang->features->max_distance, 0, 0);
+
+	endpoint = &intf->cur_altsetting->endpoint[0].desc;
+	usb_fill_int_urb(hanwang->irq, dev,
+			usb_rcvintpipe(dev, endpoint->bEndpointAddress),
+			hanwang->data, hanwang->features->pkg_len,
+			hanwang_irq, hanwang, endpoint->bInterval);
+	hanwang->irq->transfer_dma = hanwang->data_dma;
+	hanwang->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	error = input_register_device(hanwang->dev);
+	if (error)
+		goto fail3;
+
+	usb_set_intfdata(intf, hanwang);
+
+	return 0;
+
+ fail3:	usb_free_urb(hanwang->irq);
+ fail2:	usb_free_coherent(dev, hanwang->features->pkg_len,
+			hanwang->data, hanwang->data_dma);
+ fail1:	input_free_device(input_dev);
+	kfree(hanwang);
+	return error;
+
+}
+
+static void hanwang_disconnect(struct usb_interface *intf)
+{
+	struct hanwang *hanwang = usb_get_intfdata(intf);
+
+	input_unregister_device(hanwang->dev);
+	usb_free_urb(hanwang->irq);
+	usb_free_coherent(interface_to_usbdev(intf),
+			hanwang->features->pkg_len, hanwang->data,
+			hanwang->data_dma);
+	kfree(hanwang);
+	usb_set_intfdata(intf, NULL);
+}
+
+static const struct usb_device_id hanwang_ids[] = {
+	{ HANWANG_TABLET_DEVICE(USB_VENDOR_ID_HANWANG, HANWANG_TABLET_INT_CLASS,
+		HANWANG_TABLET_INT_SUB_CLASS, HANWANG_TABLET_INT_PROTOCOL) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, hanwang_ids);
+
+static struct usb_driver hanwang_driver = {
+	.name		= "hanwang",
+	.probe		= hanwang_probe,
+	.disconnect	= hanwang_disconnect,
+	.id_table	= hanwang_ids,
+};
+
+static int __init hanwang_init(void)
+{
+	return usb_register(&hanwang_driver);
+}
+
+static void __exit hanwang_exit(void)
+{
+	usb_deregister(&hanwang_driver);
+}
+
+module_init(hanwang_init);
+module_exit(hanwang_exit);
