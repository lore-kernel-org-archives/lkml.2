Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab2FTTDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:03:00 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29820 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2FTTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:02:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1340218967!7301574!10
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] staging: comedi: usbdux: refactor init code
Date: Wed, 20 Jun 2012 12:02:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201202.50221.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/usbdux.c | 488 ++++++++++++++++----------------
 1 file changed, 239 insertions(+), 249 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 586936b..848c7ec 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1,6 +1,3 @@
-#define DRIVER_VERSION "v2.4"
-#define DRIVER_AUTHOR "Bernd Porr, BerndPorr@f2s.com"
-#define DRIVER_DESC "Stirling/ITL USB-DUX -- Bernd.Porr@f2s.com"
 /*
    comedi/drivers/usbdux.c
    Copyright (C) 2003-2007 Bernd Porr, Bernd.Porr@f2s.com
@@ -101,8 +98,6 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 
 #include "../comedidev.h"
 
-#define BOARDNAME "usbdux"
-
 /* timeout for the USB-transfer in ms*/
 #define BULK_TIMEOUT 1000
 
@@ -317,8 +312,6 @@ static struct usbduxsub usbduxsub[NUMUSBDUX];
 
 static DEFINE_SEMAPHORE(start_stop_sem);
 
-static struct comedi_driver usbdux_driver;	/* see below for initializer */
-
 /*
  * Stops the data acquision
  * It should be safe to call this function from any context
@@ -2299,6 +2292,231 @@ static void tidy_up(struct usbduxsub *usbduxsub_tmp)
 	usbduxsub_tmp->pwm_cmd_running = 0;
 }
 
+/* common part of attach and attach_usb */
+static int usbdux_attach_common(struct comedi_device *dev,
+				struct usbduxsub *udev,
+				void *aux_data, int aux_len)
+{
+	int ret;
+	struct comedi_subdevice *s = NULL;
+	int n_subdevs;
+
+	down(&udev->sem);
+	/* pointer back to the corresponding comedi device */
+	udev->comedidev = dev;
+
+	/* trying to upload the firmware into the chip */
+	if (aux_data)
+		firmwareUpload(udev, aux_data, aux_len);
+
+	dev->board_name = "usbdux";
+
+	/* set number of subdevices */
+	if (udev->high_speed) {
+		/* with pwm */
+		n_subdevs = 5;
+	} else {
+		/* without pwm */
+		n_subdevs = 4;
+	}
+
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
+	if (ret) {
+		up(&udev->sem);
+		return ret;
+	}
+
+	/* private structure is also simply the usb-structure */
+	dev->private = udev;
+
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
+	/* readable and ref is to ground */
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
+	/* 8 channels */
+	s->n_chan = 8;
+	/* length of the channellist */
+	s->len_chanlist = 8;
+	/* callback functions */
+	s->insn_read = usbdux_ai_insn_read;
+	s->do_cmdtest = usbdux_ai_cmdtest;
+	s->do_cmd = usbdux_ai_cmd;
+	s->cancel = usbdux_ai_cancel;
+	/* max value from the A/D converter (12bit) */
+	s->maxdata = 0xfff;
+	/* range table to convert to physical units */
+	s->range_table = (&range_usbdux_ai_range);
+
+	/* analog out */
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
+	/* 12 bit resolution */
+	s->maxdata = 0x0fff;
+	/* bipolar range */
+	s->range_table = (&range_usbdux_ao_range);
+	/* callback */
+	s->do_cmdtest = usbdux_ao_cmdtest;
+	s->do_cmd = usbdux_ao_cmd;
+	s->cancel = usbdux_ao_cancel;
+	s->insn_read = usbdux_ao_insn_read;
+	s->insn_write = usbdux_ao_insn_write;
+
+	/* digital I/O */
+	s = dev->subdevices + SUBDEV_DIO;
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 8;
+	s->maxdata = 1;
+	s->range_table = (&range_digital);
+	s->insn_bits = usbdux_dio_insn_bits;
+	s->insn_config = usbdux_dio_insn_config;
+	/* we don't use it */
+	s->private = NULL;
+
+	/* counter */
+	s = dev->subdevices + SUBDEV_COUNTER;
+	s->type = COMEDI_SUBD_COUNTER;
+	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
+	s->n_chan = 4;
+	s->maxdata = 0xFFFF;
+	s->insn_read = usbdux_counter_read;
+	s->insn_write = usbdux_counter_write;
+	s->insn_config = usbdux_counter_config;
+
+	if (udev->high_speed) {
+		/* timer / pwm */
+		s = dev->subdevices + SUBDEV_PWM;
+		s->type = COMEDI_SUBD_PWM;
+		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
+		s->n_chan = 8;
+		/* this defines the max duty cycle resolution */
+		s->maxdata = udev->sizePwmBuf;
+		s->insn_write = usbdux_pwm_write;
+		s->insn_read = usbdux_pwm_read;
+		s->insn_config = usbdux_pwm_config;
+		usbdux_pwm_period(dev, s, PWM_DEFAULT_PERIOD);
+	}
+	/* finally decide that it's attached */
+	udev->attached = 1;
+
+	up(&udev->sem);
+
+	dev_info(&udev->interface->dev, "comedi%d: attached to usbdux.\n",
+		 dev->minor);
+
+	return 0;
+}
+
+/* is called when comedi-config is called */
+static int usbdux_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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
+
+	if (index < 0) {
+		printk(KERN_ERR
+		       "comedi%d: usbdux: error: attach failed, no usbdux devs connected to the usb bus.\n",
+		       dev->minor);
+		ret = -ENODEV;
+	} else
+		ret = usbdux_attach_common(dev, &usbduxsub[index],
+					   aux_data, aux_len);
+	up(&start_stop_sem);
+	return ret;
+}
+
+/* is called from comedi_usb_auto_config() */
+static int usbdux_attach_usb(struct comedi_device *dev,
+			     struct usb_interface *uinterf)
+{
+	int ret;
+	struct usbduxsub *this_usbduxsub;
+
+	dev->private = NULL;
+
+	down(&start_stop_sem);
+	this_usbduxsub = usb_get_intfdata(uinterf);
+	if (!this_usbduxsub || !this_usbduxsub->probed) {
+		printk(KERN_ERR
+		       "comedi%d: usbdux: error: attach_usb failed, not connected\n",
+		       dev->minor);
+		ret = -ENODEV;
+	} else if (this_usbduxsub->attached) {
+		printk(KERN_ERR
+		       "comedi%d: usbdux: error: attach_usb failed, already attached\n",
+		       dev->minor);
+		ret = -ENODEV;
+	} else
+		ret = usbdux_attach_common(dev, this_usbduxsub, NULL, 0);
+	up(&start_stop_sem);
+	return ret;
+}
+
+static void usbdux_detach(struct comedi_device *dev)
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
+static struct comedi_driver usbdux_driver = {
+	.driver_name	= "usbdux",
+	.module		= THIS_MODULE,
+	.attach		= usbdux_attach,
+	.detach		= usbdux_detach,
+	.attach_usb	= usbdux_attach_usb,
+};
+
 static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 						     void *context)
 {
@@ -2328,9 +2546,8 @@ static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 	release_firmware(fw);
 }
 
-/* allocate memory for the urbs and initialise them */
-static int usbduxsub_probe(struct usb_interface *uinterf,
-			   const struct usb_device_id *id)
+static int usbdux_usb_probe(struct usb_interface *uinterf,
+			    const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(uinterf);
 	struct device *dev = &uinterf->dev;
@@ -2591,7 +2808,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	return 0;
 }
 
-static void usbduxsub_disconnect(struct usb_interface *intf)
+static void usbdux_usb_disconnect(struct usb_interface *intf)
 {
 	struct usbduxsub *usbduxsub_tmp = usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -2614,249 +2831,22 @@ static void usbduxsub_disconnect(struct usb_interface *intf)
 	dev_dbg(&intf->dev, "comedi_: disconnected from the usb\n");
 }
 
-/* common part of attach and attach_usb */
-static int usbdux_attach_common(struct comedi_device *dev,
-				struct usbduxsub *udev,
-				void *aux_data, int aux_len)
-{
-	int ret;
-	struct comedi_subdevice *s = NULL;
-	int n_subdevs;
-
-	down(&udev->sem);
-	/* pointer back to the corresponding comedi device */
-	udev->comedidev = dev;
-
-	/* trying to upload the firmware into the chip */
-	if (aux_data)
-		firmwareUpload(udev, aux_data, aux_len);
-
-	dev->board_name = BOARDNAME;
-
-	/* set number of subdevices */
-	if (udev->high_speed) {
-		/* with pwm */
-		n_subdevs = 5;
-	} else {
-		/* without pwm */
-		n_subdevs = 4;
-	}
-
-	ret = comedi_alloc_subdevices(dev, n_subdevs);
-	if (ret) {
-		up(&udev->sem);
-		return ret;
-	}
-
-	/* private structure is also simply the usb-structure */
-	dev->private = udev;
-
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
-	/* readable and ref is to ground */
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
-	/* 8 channels */
-	s->n_chan = 8;
-	/* length of the channellist */
-	s->len_chanlist = 8;
-	/* callback functions */
-	s->insn_read = usbdux_ai_insn_read;
-	s->do_cmdtest = usbdux_ai_cmdtest;
-	s->do_cmd = usbdux_ai_cmd;
-	s->cancel = usbdux_ai_cancel;
-	/* max value from the A/D converter (12bit) */
-	s->maxdata = 0xfff;
-	/* range table to convert to physical units */
-	s->range_table = (&range_usbdux_ai_range);
-
-	/* analog out */
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
-	/* 12 bit resolution */
-	s->maxdata = 0x0fff;
-	/* bipolar range */
-	s->range_table = (&range_usbdux_ao_range);
-	/* callback */
-	s->do_cmdtest = usbdux_ao_cmdtest;
-	s->do_cmd = usbdux_ao_cmd;
-	s->cancel = usbdux_ao_cancel;
-	s->insn_read = usbdux_ao_insn_read;
-	s->insn_write = usbdux_ao_insn_write;
-
-	/* digital I/O */
-	s = dev->subdevices + SUBDEV_DIO;
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 8;
-	s->maxdata = 1;
-	s->range_table = (&range_digital);
-	s->insn_bits = usbdux_dio_insn_bits;
-	s->insn_config = usbdux_dio_insn_config;
-	/* we don't use it */
-	s->private = NULL;
-
-	/* counter */
-	s = dev->subdevices + SUBDEV_COUNTER;
-	s->type = COMEDI_SUBD_COUNTER;
-	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
-	s->n_chan = 4;
-	s->maxdata = 0xFFFF;
-	s->insn_read = usbdux_counter_read;
-	s->insn_write = usbdux_counter_write;
-	s->insn_config = usbdux_counter_config;
-
-	if (udev->high_speed) {
-		/* timer / pwm */
-		s = dev->subdevices + SUBDEV_PWM;
-		s->type = COMEDI_SUBD_PWM;
-		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
-		s->n_chan = 8;
-		/* this defines the max duty cycle resolution */
-		s->maxdata = udev->sizePwmBuf;
-		s->insn_write = usbdux_pwm_write;
-		s->insn_read = usbdux_pwm_read;
-		s->insn_config = usbdux_pwm_config;
-		usbdux_pwm_period(dev, s, PWM_DEFAULT_PERIOD);
-	}
-	/* finally decide that it's attached */
-	udev->attached = 1;
-
-	up(&udev->sem);
-
-	dev_info(&udev->interface->dev, "comedi%d: attached to usbdux.\n",
-		 dev->minor);
-
-	return 0;
-}
-
-/* is called when comedi-config is called */
-static int usbdux_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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
-
-	if (index < 0) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach failed, no usbdux devs connected to the usb bus.\n",
-		       dev->minor);
-		ret = -ENODEV;
-	} else
-		ret = usbdux_attach_common(dev, &usbduxsub[index],
-					   aux_data, aux_len);
-	up(&start_stop_sem);
-	return ret;
-}
-
-/* is called from comedi_usb_auto_config() */
-static int usbdux_attach_usb(struct comedi_device *dev,
-			     struct usb_interface *uinterf)
-{
-	int ret;
-	struct usbduxsub *this_usbduxsub;
-
-	dev->private = NULL;
-
-	down(&start_stop_sem);
-	this_usbduxsub = usb_get_intfdata(uinterf);
-	if (!this_usbduxsub || !this_usbduxsub->probed) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach_usb failed, not connected\n",
-		       dev->minor);
-		ret = -ENODEV;
-	} else if (this_usbduxsub->attached) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach_usb failed, already attached\n",
-		       dev->minor);
-		ret = -ENODEV;
-	} else
-		ret = usbdux_attach_common(dev, this_usbduxsub, NULL, 0);
-	up(&start_stop_sem);
-	return ret;
-}
-
-static void usbdux_detach(struct comedi_device *dev)
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
-static struct comedi_driver usbdux_driver = {
-	.driver_name	= "usbdux",
-	.module		= THIS_MODULE,
-	.attach		= usbdux_attach,
-	.detach		= usbdux_detach,
-	.attach_usb	= usbdux_attach_usb,
-};
-
-/* Table with the USB-devices: just now only testing IDs */
-static const struct usb_device_id usbduxsub_table[] = {
-	{USB_DEVICE(0x13d8, 0x0001)},
-	{USB_DEVICE(0x13d8, 0x0002)},
-	{}			/* Terminating entry */
+static const struct usb_device_id usbdux_usb_table[] = {
+	{ USB_DEVICE(0x13d8, 0x0001) },
+	{ USB_DEVICE(0x13d8, 0x0002) },
+	{ }
 };
 
-MODULE_DEVICE_TABLE(usb, usbduxsub_table);
+MODULE_DEVICE_TABLE(usb, usbdux_usb_table);
 
 static struct usb_driver usbdux_usb_driver = {
-	.name		= BOARDNAME,
-	.probe		= usbduxsub_probe,
-	.disconnect	= usbduxsub_disconnect,
-	.id_table	= usbduxsub_table,
+	.name		= "usbdux",
+	.probe		= usbdux_usb_probe,
+	.disconnect	= usbdux_usb_disconnect,
+	.id_table	= usbdux_usb_table,
 };
 module_comedi_usb_driver(usbdux_driver, usbdux_usb_driver);
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Bernd Porr, BerndPorr@f2s.com");
+MODULE_DESCRIPTION("Stirling/ITL USB-DUX -- Bernd.Porr@f2s.com");
 MODULE_LICENSE("GPL");
-- 
1.7.11

