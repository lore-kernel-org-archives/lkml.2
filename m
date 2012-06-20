Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2FTTCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:02:36 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:55438 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab2FTTCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:02:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1340218951!6440142!7
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] staging: comedi: usbduxfast: refactor init code
Date: Wed, 20 Jun 2012 12:02:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201202.29280.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the usb driver probe/disconnect and comedi driver attach/
detach to follow the style of the other comedi driver types to
improve maintainability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 331 +++++++++++++---------------
 1 file changed, 157 insertions(+), 174 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 8c8e4ec9..d991158 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -49,11 +49,6 @@
 #include "comedi_fc.h"
 #include "../comedidev.h"
 
-#define DRIVER_VERSION "v1.0"
-#define DRIVER_AUTHOR "Bernd Porr, BerndPorr@f2s.com"
-#define DRIVER_DESC "USB-DUXfast, BerndPorr@f2s.com"
-#define BOARDNAME "usbduxfast"
-
 /*
  * timeout for the USB-transfer
  */
@@ -196,8 +191,6 @@ static struct usbduxfastsub_s usbduxfastsub[NUMUSBDUXFAST];
 
 static DEFINE_SEMAPHORE(start_stop_sem);
 
-static struct comedi_driver usbduxfast_driver;	/* see below for initializer */
-
 /*
  * bulk transfers to usbduxfast
  */
@@ -1436,6 +1429,149 @@ static void tidy_up(struct usbduxfastsub_s *udfs)
 	udfs->ai_cmd_running = 0;
 }
 
+/* common part of attach and attach_usb */
+static int usbduxfast_attach_common(struct comedi_device *dev,
+				    struct usbduxfastsub_s *udfs,
+				    void *aux_data, int aux_len)
+{
+	int ret;
+	struct comedi_subdevice *s;
+
+	down(&udfs->sem);
+	/* pointer back to the corresponding comedi device */
+	udfs->comedidev = dev;
+	/* trying to upload the firmware into the chip */
+	if (aux_data)
+		firmwareUpload(udfs, aux_data, aux_len);
+	dev->board_name = "usbduxfast";
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret) {
+		up(&udfs->sem);
+		return ret;
+	}
+	/* private structure is also simply the usb-structure */
+	dev->private = udfs;
+	/* the first subdevice is the A/D converter */
+	s = dev->subdevices + SUBDEV_AD;
+	/*
+	 * the URBs get the comedi subdevice which is responsible for reading
+	 * this is the subdevice which reads data
+	 */
+	dev->read_subdev = s;
+	/* the subdevice receives as private structure the usb-structure */
+	s->private = NULL;
+	/* analog input */
+	s->type = COMEDI_SUBD_AI;
+	/* readable and ref is to ground */
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
+	/* 16 channels */
+	s->n_chan = 16;
+	/* length of the channellist */
+	s->len_chanlist = 16;
+	/* callback functions */
+	s->insn_read = usbduxfast_ai_insn_read;
+	s->do_cmdtest = usbduxfast_ai_cmdtest;
+	s->do_cmd = usbduxfast_ai_cmd;
+	s->cancel = usbduxfast_ai_cancel;
+	/* max value from the A/D converter (12bit+1 bit for overflow) */
+	s->maxdata = 0x1000;
+	/* range table to convert to physical units */
+	s->range_table = &range_usbduxfast_ai_range;
+	/* finally decide that it's attached */
+	udfs->attached = 1;
+	up(&udfs->sem);
+	dev_info(dev->class_dev, "successfully attached to usbduxfast.\n");
+	return 0;
+}
+
+/* is called for COMEDI_DEVCONFIG ioctl (when comedi_config is run) */
+static int usbduxfast_attach(struct comedi_device *dev,
+			     struct comedi_devconfig *it)
+{
+	int ret;
+	int index;
+	int i;
+	void *aux_data;
+	int aux_len;
+
+	dev->private = NULL;
+
+	aux_data = comedi_aux_data(it->options, 0);
+	aux_len = it->options[COMEDI_DEVCONF_AUX_DATA_LENGTH];
+	if (aux_data == NULL)
+		aux_len = 0;
+	else if (aux_len == 0)
+		aux_data = NULL;
+	down(&start_stop_sem);
+	/*
+	 * find a valid device which has been detected by the
+	 * probe function of the usb
+	 */
+	index = -1;
+	for (i = 0; i < NUMUSBDUXFAST; i++) {
+		if (usbduxfastsub[i].probed && !usbduxfastsub[i].attached) {
+			index = i;
+			break;
+		}
+	}
+	if (index < 0) {
+		dev_err(dev->class_dev,
+			"usbduxfast: error: attach failed, no usbduxfast devs connected to the usb bus.\n");
+		ret = -ENODEV;
+	} else
+		ret = usbduxfast_attach_common(dev, &usbduxfastsub[index],
+					       aux_data, aux_len);
+	up(&start_stop_sem);
+	return ret;
+}
+
+/* is called from comedi_usb_auto_config() */
+static int usbduxfast_attach_usb(struct comedi_device *dev,
+				 struct usb_interface *uinterf)
+{
+	int ret;
+	struct usbduxfastsub_s *udfs;
+
+	dev->private = NULL;
+	down(&start_stop_sem);
+	udfs = usb_get_intfdata(uinterf);
+	if (!udfs || !udfs->probed) {
+		dev_err(dev->class_dev,
+			"usbduxfast: error: attach_usb failed, not connected\n");
+		ret = -ENODEV;
+	} else if (udfs->attached) {
+		dev_err(dev->class_dev,
+		       "usbduxfast: error: attach_usb failed, already attached\n");
+		ret = -ENODEV;
+	} else
+		ret = usbduxfast_attach_common(dev, udfs, NULL, 0);
+	up(&start_stop_sem);
+	return ret;
+}
+
+static void usbduxfast_detach(struct comedi_device *dev)
+{
+	struct usbduxfastsub_s *usb = dev->private;
+
+	if (usb) {
+		down(&usb->sem);
+		down(&start_stop_sem);
+		dev->private = NULL;
+		usb->attached = 0;
+		usb->comedidev = NULL;
+		up(&start_stop_sem);
+		up(&usb->sem);
+	}
+}
+
+static struct comedi_driver usbduxfast_driver = {
+	.driver_name	= "usbduxfast",
+	.module		= THIS_MODULE,
+	.attach		= usbduxfast_attach,
+	.detach		= usbduxfast_detach,
+	.attach_usb	= usbduxfast_attach_usb,
+};
+
 static void usbduxfast_firmware_request_complete_handler(const struct firmware
 							 *fw, void *context)
 {
@@ -1463,11 +1599,8 @@ static void usbduxfast_firmware_request_complete_handler(const struct firmware
 	release_firmware(fw);
 }
 
-/*
- * allocate memory for the urbs and initialise them
- */
-static int usbduxfastsub_probe(struct usb_interface *uinterf,
-			       const struct usb_device_id *id)
+static int usbduxfast_usb_probe(struct usb_interface *uinterf,
+				const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(uinterf);
 	int i;
@@ -1590,7 +1723,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	return 0;
 }
 
-static void usbduxfastsub_disconnect(struct usb_interface *intf)
+static void usbduxfast_usb_disconnect(struct usb_interface *intf)
 {
 	struct usbduxfastsub_s *udfs = usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -1619,175 +1752,25 @@ static void usbduxfastsub_disconnect(struct usb_interface *intf)
 #endif
 }
 
-/* common part of attach and attach_usb */
-static int usbduxfast_attach_common(struct comedi_device *dev,
-				    struct usbduxfastsub_s *udfs,
-				    void *aux_data, int aux_len)
-{
-	int ret;
-	struct comedi_subdevice *s;
-
-	down(&udfs->sem);
-	/* pointer back to the corresponding comedi device */
-	udfs->comedidev = dev;
-	/* trying to upload the firmware into the chip */
-	if (aux_data)
-		firmwareUpload(udfs, aux_data, aux_len);
-	dev->board_name = BOARDNAME;
-	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret) {
-		up(&udfs->sem);
-		return ret;
-	}
-	/* private structure is also simply the usb-structure */
-	dev->private = udfs;
-	/* the first subdevice is the A/D converter */
-	s = dev->subdevices + SUBDEV_AD;
-	/*
-	 * the URBs get the comedi subdevice which is responsible for reading
-	 * this is the subdevice which reads data
-	 */
-	dev->read_subdev = s;
-	/* the subdevice receives as private structure the usb-structure */
-	s->private = NULL;
-	/* analog input */
-	s->type = COMEDI_SUBD_AI;
-	/* readable and ref is to ground */
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
-	/* 16 channels */
-	s->n_chan = 16;
-	/* length of the channellist */
-	s->len_chanlist = 16;
-	/* callback functions */
-	s->insn_read = usbduxfast_ai_insn_read;
-	s->do_cmdtest = usbduxfast_ai_cmdtest;
-	s->do_cmd = usbduxfast_ai_cmd;
-	s->cancel = usbduxfast_ai_cancel;
-	/* max value from the A/D converter (12bit+1 bit for overflow) */
-	s->maxdata = 0x1000;
-	/* range table to convert to physical units */
-	s->range_table = &range_usbduxfast_ai_range;
-	/* finally decide that it's attached */
-	udfs->attached = 1;
-	up(&udfs->sem);
-	dev_info(dev->class_dev, "successfully attached to usbduxfast.\n");
-	return 0;
-}
-
-/* is called for COMEDI_DEVCONFIG ioctl (when comedi_config is run) */
-static int usbduxfast_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it)
-{
-	int ret;
-	int index;
-	int i;
-	void *aux_data;
-	int aux_len;
-
-	dev->private = NULL;
-
-	aux_data = comedi_aux_data(it->options, 0);
-	aux_len = it->options[COMEDI_DEVCONF_AUX_DATA_LENGTH];
-	if (aux_data == NULL)
-		aux_len = 0;
-	else if (aux_len == 0)
-		aux_data = NULL;
-	down(&start_stop_sem);
-	/*
-	 * find a valid device which has been detected by the
-	 * probe function of the usb
-	 */
-	index = -1;
-	for (i = 0; i < NUMUSBDUXFAST; i++) {
-		if (usbduxfastsub[i].probed && !usbduxfastsub[i].attached) {
-			index = i;
-			break;
-		}
-	}
-	if (index < 0) {
-		dev_err(dev->class_dev,
-			"usbduxfast: error: attach failed, no usbduxfast devs connected to the usb bus.\n");
-		ret = -ENODEV;
-	} else
-		ret = usbduxfast_attach_common(dev, &usbduxfastsub[index],
-					       aux_data, aux_len);
-	up(&start_stop_sem);
-	return ret;
-}
-
-/* is called from comedi_usb_auto_config() */
-static int usbduxfast_attach_usb(struct comedi_device *dev,
-				 struct usb_interface *uinterf)
-{
-	int ret;
-	struct usbduxfastsub_s *udfs;
-
-	dev->private = NULL;
-	down(&start_stop_sem);
-	udfs = usb_get_intfdata(uinterf);
-	if (!udfs || !udfs->probed) {
-		dev_err(dev->class_dev,
-			"usbduxfast: error: attach_usb failed, not connected\n");
-		ret = -ENODEV;
-	} else if (udfs->attached) {
-		dev_err(dev->class_dev,
-		       "usbduxfast: error: attach_usb failed, already attached\n");
-		ret = -ENODEV;
-	} else
-		ret = usbduxfast_attach_common(dev, udfs, NULL, 0);
-	up(&start_stop_sem);
-	return ret;
-}
-
-static void usbduxfast_detach(struct comedi_device *dev)
-{
-	struct usbduxfastsub_s *usb = dev->private;
-
-	if (usb) {
-		down(&usb->sem);
-		down(&start_stop_sem);
-		dev->private = NULL;
-		usb->attached = 0;
-		usb->comedidev = NULL;
-		up(&start_stop_sem);
-		up(&usb->sem);
-	}
-}
-
-/*
- * main driver struct
- */
-static struct comedi_driver usbduxfast_driver = {
-	.driver_name	= "usbduxfast",
-	.module		= THIS_MODULE,
-	.attach		= usbduxfast_attach,
-	.detach		= usbduxfast_detach,
-	.attach_usb	= usbduxfast_attach_usb,
-};
-
-/*
- * Table with the USB-devices: just now only testing IDs
- */
-static const struct usb_device_id usbduxfastsub_table[] = {
+static const struct usb_device_id usbduxfast_usb_table[] = {
 	/* { USB_DEVICE(0x4b4, 0x8613) }, testing */
-	{USB_DEVICE(0x13d8, 0x0010)},	/* real ID */
-	{USB_DEVICE(0x13d8, 0x0011)},	/* real ID */
-	{}			/* Terminating entry */
+	{ USB_DEVICE(0x13d8, 0x0010) },	/* real ID */
+	{ USB_DEVICE(0x13d8, 0x0011) },	/* real ID */
+	{ }
 };
-
-MODULE_DEVICE_TABLE(usb, usbduxfastsub_table);
+MODULE_DEVICE_TABLE(usb, usbduxfast_usb_table);
 
 static struct usb_driver usbduxfast_usb_driver = {
 #ifdef COMEDI_HAVE_USB_DRIVER_OWNER
 	.owner		= THIS_MODULE,
 #endif
-	.name		= BOARDNAME,
-	.probe		= usbduxfastsub_probe,
-	.disconnect	= usbduxfastsub_disconnect,
-	.id_table	= usbduxfastsub_table,
+	.name		= "usbduxfast",
+	.probe		= usbduxfast_usb_probe,
+	.disconnect	= usbduxfast_usb_disconnect,
+	.id_table	= usbduxfast_usb_table,
 };
 module_comedi_usb_driver(usbduxfast_driver, usbduxfast_usb_driver);
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Bernd Porr, BerndPorr@f2s.com");
+MODULE_DESCRIPTION("USB-DUXfast, BerndPorr@f2s.com");
 MODULE_LICENSE("GPL");
-- 
1.7.11

