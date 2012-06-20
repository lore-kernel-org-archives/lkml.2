Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2FTTC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:02:26 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:11857 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2FTTCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:02:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1340218937!12001603!11
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] staging: comedi: usbduxsigma: refactor init code
Date: Wed, 20 Jun 2012 12:02:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201202.15579.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/usbduxsigma.c | 450 +++++++++++++--------------
 1 file changed, 219 insertions(+), 231 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index e430882..8da8c1c 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1,6 +1,3 @@
-#define DRIVER_VERSION "v0.6"
-#define DRIVER_AUTHOR "Bernd Porr, BerndPorr@f2s.com"
-#define DRIVER_DESC "Stirling/ITL USB-DUX SIGMA -- Bernd.Porr@f2s.com"
 /*
    comedi/drivers/usbdux.c
    Copyright (C) 2011 Bernd Porr, Bernd.Porr@f2s.com
@@ -62,8 +59,6 @@ Status: testing
 #include "comedi_fc.h"
 #include "../comedidev.h"
 
-#define BOARDNAME "usbduxsigma"
-
 /* timeout for the USB-transfer in ms*/
 #define BULK_TIMEOUT 1000
 
@@ -267,8 +262,6 @@ static struct usbduxsub usbduxsub[NUMUSBDUX];
 
 static DEFINE_SEMAPHORE(start_stop_sem);
 
-static struct comedi_driver usbduxsigma_driver;	/* see below for initializer */
-
 /*
  * Stops the data acquision
  * It should be safe to call this function from any context
@@ -2307,6 +2300,210 @@ static void tidy_up(struct usbduxsub *usbduxsub_tmp)
 	usbduxsub_tmp->pwm_cmd_running = 0;
 }
 
+/* common part of attach and attach_usb */
+static int usbduxsigma_attach_common(struct comedi_device *dev,
+				     struct usbduxsub *uds,
+				     void *aux_data, int aux_len)
+{
+	int ret;
+	struct comedi_subdevice *s;
+	int n_subdevs;
+	int offset;
+
+	down(&uds->sem);
+	/* pointer back to the corresponding comedi device */
+	uds->comedidev = dev;
+	/* trying to upload the firmware into the FX2 */
+	if (aux_data)
+		firmwareUpload(uds, aux_data, aux_len);
+	dev->board_name = "usbduxsigma";
+	/* set number of subdevices */
+	if (uds->high_speed)
+		n_subdevs = 4;	/* with pwm */
+	else
+		n_subdevs = 3;	/* without pwm */
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
+	if (ret) {
+		up(&uds->sem);
+		return ret;
+	}
+	/* private structure is also simply the usb-structure */
+	dev->private = uds;
+	/* the first subdevice is the A/D converter */
+	s = dev->subdevices + SUBDEV_AD;
+	/* the URBs get the comedi subdevice */
+	/* which is responsible for reading */
+	/* this is the subdevice which reads data */
+	dev->read_subdev = s;
+	/* the subdevice receives as private structure the */
+	/* usb-structure */
+	s->private = NULL;
+	/* analog input */
+	s->type = COMEDI_SUBD_AI;
+	/* readable and ref is to ground, 32 bit wide data! */
+	s->subdev_flags = SDF_READABLE | SDF_GROUND |
+		SDF_CMD_READ | SDF_LSAMPL;
+	/* 16 A/D channels */
+	s->n_chan = NUMCHANNELS;
+	/* length of the channellist */
+	s->len_chanlist = NUMCHANNELS;
+	/* callback functions */
+	s->insn_read = usbdux_ai_insn_read;
+	s->do_cmdtest = usbdux_ai_cmdtest;
+	s->do_cmd = usbdux_ai_cmd;
+	s->cancel = usbdux_ai_cancel;
+	/* max value from the A/D converter (24bit) */
+	s->maxdata = 0x00FFFFFF;
+	/* range table to convert to physical units */
+	s->range_table = (&range_usbdux_ai_range);
+	/* analog output subdevice */
+	s = dev->subdevices + SUBDEV_DA;
+	/* analog out */
+	s->type = COMEDI_SUBD_AO;
+	/* backward pointer */
+	dev->write_subdev = s;
+	/* the subdevice receives as private structure the */
+	/* usb-structure */
+	s->private = NULL;
+	/* are writable */
+	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_CMD_WRITE;
+	/* 4 channels */
+	s->n_chan = 4;
+	/* length of the channellist */
+	s->len_chanlist = 4;
+	/* 8 bit resolution */
+	s->maxdata = 0x00ff;
+	/* unipolar range */
+	s->range_table = (&range_usbdux_ao_range);
+	/* callback */
+	s->do_cmdtest = usbdux_ao_cmdtest;
+	s->do_cmd = usbdux_ao_cmd;
+	s->cancel = usbdux_ao_cancel;
+	s->insn_read = usbdux_ao_insn_read;
+	s->insn_write = usbdux_ao_insn_write;
+	/* digital I/O subdevice */
+	s = dev->subdevices + SUBDEV_DIO;
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	/* 8 external and 16 internal channels */
+	s->n_chan = 24;
+	s->maxdata = 1;
+	s->range_table = (&range_digital);
+	s->insn_bits = usbdux_dio_insn_bits;
+	s->insn_config = usbdux_dio_insn_config;
+	/* we don't use it */
+	s->private = NULL;
+	if (uds->high_speed) {
+		/* timer / pwm subdevice */
+		s = dev->subdevices + SUBDEV_PWM;
+		s->type = COMEDI_SUBD_PWM;
+		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
+		s->n_chan = 8;
+		/* this defines the max duty cycle resolution */
+		s->maxdata = uds->sizePwmBuf;
+		s->insn_write = usbdux_pwm_write;
+		s->insn_read = usbdux_pwm_read;
+		s->insn_config = usbdux_pwm_config;
+		usbdux_pwm_period(dev, s, PWM_DEFAULT_PERIOD);
+	}
+	/* finally decide that it's attached */
+	uds->attached = 1;
+	up(&uds->sem);
+	offset = usbdux_getstatusinfo(dev, 0);
+	if (offset < 0)
+		dev_err(&uds->interface->dev,
+			"Communication to USBDUXSIGMA failed! Check firmware and cabling.");
+	dev_info(&uds->interface->dev,
+		 "comedi%d: attached, ADC_zero = %x\n", dev->minor, offset);
+	return 0;
+}
+
+/* is called for COMEDI_DEVCONFIG ioctl (when comedi_config is run) */
+static int usbduxsigma_attach(struct comedi_device *dev,
+			      struct comedi_devconfig *it)
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
+
+	down(&start_stop_sem);
+	/* find a valid device which has been detected by the probe function of
+	 * the usb */
+	index = -1;
+	for (i = 0; i < NUMUSBDUX; i++) {
+		if ((usbduxsub[i].probed) && (!usbduxsub[i].attached)) {
+			index = i;
+			break;
+		}
+	}
+	if (index < 0) {
+		dev_err(dev->class_dev,
+			"usbduxsigma: error: attach failed, dev not connected to the usb bus.\n");
+		up(&start_stop_sem);
+		ret = -ENODEV;
+	} else
+		ret = usbduxsigma_attach_common(dev, &usbduxsub[index],
+						aux_data, aux_len);
+	up(&start_stop_sem);
+	return ret;
+}
+
+/* is called from comedi_usb_auto_config() */
+static int usbduxsigma_attach_usb(struct comedi_device *dev,
+				  struct usb_interface *uinterf)
+{
+	int ret;
+	struct usbduxsub *uds;
+
+	dev->private = NULL;
+	down(&start_stop_sem);
+	uds = usb_get_intfdata(uinterf);
+	if (!uds || !uds->probed) {
+		dev_err(dev->class_dev,
+			"usbduxsigma: error: attach_usb failed, not connected\n");
+		ret = -ENODEV;
+	} else if (uds->attached) {
+		dev_err(dev->class_dev,
+		       "usbduxsigma: error: attach_usb failed, already attached\n");
+		ret = -ENODEV;
+	} else
+		ret = usbduxsigma_attach_common(dev, uds, NULL, 0);
+	up(&start_stop_sem);
+	return ret;
+}
+
+static void usbduxsigma_detach(struct comedi_device *dev)
+{
+	struct usbduxsub *usb = dev->private;
+
+	if (usb) {
+		down(&usb->sem);
+		dev->private = NULL;
+		usb->attached = 0;
+		usb->comedidev = NULL;
+		up(&usb->sem);
+	}
+}
+
+static struct comedi_driver usbduxsigma_driver = {
+	.driver_name	= "usbduxsigma",
+	.module		= THIS_MODULE,
+	.attach		= usbduxsigma_attach,
+	.detach		= usbduxsigma_detach,
+	.attach_usb	= usbduxsigma_attach_usb,
+};
+
 static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 						     void *context)
 {
@@ -2336,9 +2533,8 @@ out:
 	release_firmware(fw);
 }
 
-/* allocate memory for the urbs and initialise them */
-static int usbduxsigma_probe(struct usb_interface *uinterf,
-			   const struct usb_device_id *id)
+static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
+				 const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(uinterf);
 	struct device *dev = &uinterf->dev;
@@ -2602,7 +2798,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	return 0;
 }
 
-static void usbduxsigma_disconnect(struct usb_interface *intf)
+static void usbduxsigma_usb_disconnect(struct usb_interface *intf)
 {
 	struct usbduxsub *usbduxsub_tmp = usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -2631,230 +2827,22 @@ static void usbduxsigma_disconnect(struct usb_interface *intf)
 	dev_info(&intf->dev, "comedi_: disconnected from the usb\n");
 }
 
-/* common part of attach and attach_usb */
-static int usbduxsigma_attach_common(struct comedi_device *dev,
-				     struct usbduxsub *uds,
-				     void *aux_data, int aux_len)
-{
-	int ret;
-	struct comedi_subdevice *s;
-	int n_subdevs;
-	int offset;
-
-	down(&uds->sem);
-	/* pointer back to the corresponding comedi device */
-	uds->comedidev = dev;
-	/* trying to upload the firmware into the FX2 */
-	if (aux_data)
-		firmwareUpload(uds, aux_data, aux_len);
-	dev->board_name = BOARDNAME;
-	/* set number of subdevices */
-	if (uds->high_speed)
-		n_subdevs = 4;	/* with pwm */
-	else
-		n_subdevs = 3;	/* without pwm */
-	ret = comedi_alloc_subdevices(dev, n_subdevs);
-	if (ret) {
-		up(&uds->sem);
-		return ret;
-	}
-	/* private structure is also simply the usb-structure */
-	dev->private = uds;
-	/* the first subdevice is the A/D converter */
-	s = dev->subdevices + SUBDEV_AD;
-	/* the URBs get the comedi subdevice */
-	/* which is responsible for reading */
-	/* this is the subdevice which reads data */
-	dev->read_subdev = s;
-	/* the subdevice receives as private structure the */
-	/* usb-structure */
-	s->private = NULL;
-	/* analog input */
-	s->type = COMEDI_SUBD_AI;
-	/* readable and ref is to ground, 32 bit wide data! */
-	s->subdev_flags = SDF_READABLE | SDF_GROUND |
-		SDF_CMD_READ | SDF_LSAMPL;
-	/* 16 A/D channels */
-	s->n_chan = NUMCHANNELS;
-	/* length of the channellist */
-	s->len_chanlist = NUMCHANNELS;
-	/* callback functions */
-	s->insn_read = usbdux_ai_insn_read;
-	s->do_cmdtest = usbdux_ai_cmdtest;
-	s->do_cmd = usbdux_ai_cmd;
-	s->cancel = usbdux_ai_cancel;
-	/* max value from the A/D converter (24bit) */
-	s->maxdata = 0x00FFFFFF;
-	/* range table to convert to physical units */
-	s->range_table = (&range_usbdux_ai_range);
-	/* analog output subdevice */
-	s = dev->subdevices + SUBDEV_DA;
-	/* analog out */
-	s->type = COMEDI_SUBD_AO;
-	/* backward pointer */
-	dev->write_subdev = s;
-	/* the subdevice receives as private structure the */
-	/* usb-structure */
-	s->private = NULL;
-	/* are writable */
-	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_CMD_WRITE;
-	/* 4 channels */
-	s->n_chan = 4;
-	/* length of the channellist */
-	s->len_chanlist = 4;
-	/* 8 bit resolution */
-	s->maxdata = 0x00ff;
-	/* unipolar range */
-	s->range_table = (&range_usbdux_ao_range);
-	/* callback */
-	s->do_cmdtest = usbdux_ao_cmdtest;
-	s->do_cmd = usbdux_ao_cmd;
-	s->cancel = usbdux_ao_cancel;
-	s->insn_read = usbdux_ao_insn_read;
-	s->insn_write = usbdux_ao_insn_write;
-	/* digital I/O subdevice */
-	s = dev->subdevices + SUBDEV_DIO;
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	/* 8 external and 16 internal channels */
-	s->n_chan = 24;
-	s->maxdata = 1;
-	s->range_table = (&range_digital);
-	s->insn_bits = usbdux_dio_insn_bits;
-	s->insn_config = usbdux_dio_insn_config;
-	/* we don't use it */
-	s->private = NULL;
-	if (uds->high_speed) {
-		/* timer / pwm subdevice */
-		s = dev->subdevices + SUBDEV_PWM;
-		s->type = COMEDI_SUBD_PWM;
-		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
-		s->n_chan = 8;
-		/* this defines the max duty cycle resolution */
-		s->maxdata = uds->sizePwmBuf;
-		s->insn_write = usbdux_pwm_write;
-		s->insn_read = usbdux_pwm_read;
-		s->insn_config = usbdux_pwm_config;
-		usbdux_pwm_period(dev, s, PWM_DEFAULT_PERIOD);
-	}
-	/* finally decide that it's attached */
-	uds->attached = 1;
-	up(&uds->sem);
-	offset = usbdux_getstatusinfo(dev, 0);
-	if (offset < 0)
-		dev_err(&uds->interface->dev,
-			"Communication to USBDUXSIGMA failed! Check firmware and cabling.");
-	dev_info(&uds->interface->dev,
-		 "comedi%d: attached, ADC_zero = %x\n", dev->minor, offset);
-	return 0;
-}
-
-/* is called for COMEDI_DEVCONFIG ioctl (when comedi_config is run) */
-static int usbduxsigma_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it)
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
-
-	down(&start_stop_sem);
-	/* find a valid device which has been detected by the probe function of
-	 * the usb */
-	index = -1;
-	for (i = 0; i < NUMUSBDUX; i++) {
-		if ((usbduxsub[i].probed) && (!usbduxsub[i].attached)) {
-			index = i;
-			break;
-		}
-	}
-	if (index < 0) {
-		dev_err(dev->class_dev,
-			"usbduxsigma: error: attach failed, dev not connected to the usb bus.\n");
-		up(&start_stop_sem);
-		ret = -ENODEV;
-	} else
-		ret = usbduxsigma_attach_common(dev, &usbduxsub[index],
-						aux_data, aux_len);
-	up(&start_stop_sem);
-	return ret;
-}
-
-/* is called from comedi_usb_auto_config() */
-static int usbduxsigma_attach_usb(struct comedi_device *dev,
-				  struct usb_interface *uinterf)
-{
-	int ret;
-	struct usbduxsub *uds;
-
-	dev->private = NULL;
-	down(&start_stop_sem);
-	uds = usb_get_intfdata(uinterf);
-	if (!uds || !uds->probed) {
-		dev_err(dev->class_dev,
-			"usbduxsigma: error: attach_usb failed, not connected\n");
-		ret = -ENODEV;
-	} else if (uds->attached) {
-		dev_err(dev->class_dev,
-		       "usbduxsigma: error: attach_usb failed, already attached\n");
-		ret = -ENODEV;
-	} else
-		ret = usbduxsigma_attach_common(dev, uds, NULL, 0);
-	up(&start_stop_sem);
-	return ret;
-}
-
-static void usbduxsigma_detach(struct comedi_device *dev)
-{
-	struct usbduxsub *usb = dev->private;
-
-	if (usb) {
-		down(&usb->sem);
-		dev->private = NULL;
-		usb->attached = 0;
-		usb->comedidev = NULL;
-		up(&usb->sem);
-	}
-}
-
-/* main driver struct */
-static struct comedi_driver usbduxsigma_driver = {
-	.driver_name	= "usbduxsigma",
-	.module		= THIS_MODULE,
-	.attach		= usbduxsigma_attach,
-	.detach		= usbduxsigma_detach,
-	.attach_usb	= usbduxsigma_attach_usb,
+static const struct usb_device_id usbduxsigma_usb_table[] = {
+	{ USB_DEVICE(0x13d8, 0x0020) },
+	{ USB_DEVICE(0x13d8, 0x0021) },
+	{ USB_DEVICE(0x13d8, 0x0022) },
+	{ }
 };
+MODULE_DEVICE_TABLE(usb, usbduxsigma_usb_table);
 
-/* Table with the USB-devices */
-static const struct usb_device_id usbduxsigma_table[] = {
-	{USB_DEVICE(0x13d8, 0x0020)},
-	{USB_DEVICE(0x13d8, 0x0021)},
-	{USB_DEVICE(0x13d8, 0x0022)},
-	{}			/* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE(usb, usbduxsigma_table);
-
-/* The usbduxsub-driver */
 static struct usb_driver usbduxsigma_usb_driver = {
-	.name		= BOARDNAME,
-	.probe		= usbduxsigma_probe,
-	.disconnect	= usbduxsigma_disconnect,
-	.id_table	= usbduxsigma_table,
+	.name		= "usbduxsigma",
+	.probe		= usbduxsigma_usb_probe,
+	.disconnect	= usbduxsigma_usb_disconnect,
+	.id_table	= usbduxsigma_usb_table,
 };
 module_comedi_usb_driver(usbduxsigma_driver, usbduxsigma_usb_driver);
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Bernd Porr, BerndPorr@f2s.com");
+MODULE_DESCRIPTION("Stirling/ITL USB-DUX SIGMA -- Bernd.Porr@f2s.com");
 MODULE_LICENSE("GPL");
-- 
1.7.11

