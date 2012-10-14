Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2JNNlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 09:41:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43778 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2JNNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 09:41:44 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use pr_ or dev_ printks in drivers/usbduxfast.c
Date: Sun, 14 Oct 2012 22:41:37 +0900
Message-Id: <1350222097-7698-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349871682-4543-1-git-send-email-yamanetoshi@gmail.com>
References: <1349871682-4543-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and added pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |  152 +++++++++++++--------------
 1 file changed, 71 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 1154a7e..060d853dc 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -37,6 +37,8 @@
  *       udev coldplug problem
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
@@ -216,8 +218,9 @@ static int send_dux_commands(struct usbduxfastsub_s *udfs, int cmd_type)
 			   usb_sndbulkpipe(udfs->usbdev, CHANNELLISTEP),
 			   udfs->dux_commands, SIZEOFDUXBUFFER, &nsent, 10000);
 	if (tmp < 0)
-		printk(KERN_ERR "comedi%d: could not transmit dux_commands to"
-		       "the usb-device, err=%d\n", udfs->comedidev->minor, tmp);
+		dev_err(&udfs->interface->dev,
+			"could not transmit dux_commands to the usb-device, err=%d\n",
+			tmp);
 	return tmp;
 }
 
@@ -252,7 +255,7 @@ static int usbduxfast_ai_stop(struct usbduxfastsub_s *udfs, int do_unlink)
 	int ret = 0;
 
 	if (!udfs) {
-		printk(KERN_ERR "comedi?: usbduxfast_ai_stop: udfs=NULL!\n");
+		pr_err("%s: udfs=NULL!\n", __func__);
 		return -EFAULT;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
@@ -284,7 +287,7 @@ static int usbduxfast_ai_cancel(struct comedi_device *dev,
 #endif
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi: usbduxfast_ai_cancel: udfs=NULL\n");
+		dev_err(dev->class_dev, "%s: udfs=NULL\n", __func__);
 		return -EFAULT;
 	}
 	down(&udfs->sem);
@@ -313,22 +316,19 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 
 	/* sanity checks - is the urb there? */
 	if (!urb) {
-		printk(KERN_ERR "comedi_: usbduxfast_: ao int-handler called "
-		       "with urb=NULL!\n");
+		pr_err("ao int-handler called with urb=NULL!\n");
 		return;
 	}
 	/* the context variable points to the subdevice */
 	this_comedidev = urb->context;
 	if (!this_comedidev) {
-		printk(KERN_ERR "comedi_: usbduxfast_: urb context is a NULL "
-		       "pointer!\n");
+		pr_err("urb context is a NULL pointer!\n");
 		return;
 	}
 	/* the private structure of the subdevice is usbduxfastsub_s */
 	udfs = this_comedidev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi_: usbduxfast_: private of comedi "
-		       "subdev is a NULL pointer!\n");
+		pr_err("private of comedi subdev is a NULL pointer!\n");
 		return;
 	}
 	/* are we running a command? */
@@ -427,8 +427,8 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 	urb->status = 0;
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: urb resubm failed: %d",
-		       udfs->comedidev->minor, err);
+		dev_err(&urb->dev->dev,
+			"urb resubm failed: %d", err);
 		s->async->events |= COMEDI_CB_EOA;
 		s->async->events |= COMEDI_CB_ERROR;
 		comedi_event(udfs->comedidev, s);
@@ -477,8 +477,8 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 			      local_transfer_buffer, 1,	/* Length */
 			      EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
-		       "(stop)\n");
+		dev_err(&udfs->interface->dev,
+			"control msg failed (stop)\n");
 		return ret;
 	}
 
@@ -512,7 +512,7 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 #endif
 
 	if (ret < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast: uppload failed\n");
+		dev_err(&udfs->interface->dev, "uppload failed\n");
 		return ret;
 	}
 
@@ -538,8 +538,8 @@ static int usbduxfastsub_submit_InURBs(struct usbduxfastsub_s *udfs)
 #endif
 	ret = usb_submit_urb(udfs->urbIn, GFP_ATOMIC);
 	if (ret) {
-		printk(KERN_ERR "comedi_: usbduxfast: ai: usb_submit_urb error"
-		       " %d\n", ret);
+		dev_err(&udfs->interface->dev,
+			"ai: usb_submit_urb error %d\n", ret);
 		return ret;
 	}
 	return 0;
@@ -682,8 +682,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 #endif
 
 	if (trignum != 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast_ai_inttrig: invalid"
-		       " trignum\n", dev->minor);
+		dev_err(dev->class_dev, "%s: invalid trignum\n", __func__);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
@@ -691,16 +690,16 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		udfs->ai_cmd_running = 1;
 		ret = usbduxfastsub_submit_InURBs(udfs);
 		if (ret < 0) {
-			printk(KERN_ERR "comedi%d: usbduxfast_ai_inttrig: "
-			       "urbSubmit: err=%d\n", dev->minor, ret);
+			dev_err(dev->class_dev,
+				"%s: urbSubmit: err=%d\n", __func__, ret);
 			udfs->ai_cmd_running = 0;
 			up(&udfs->sem);
 			return ret;
 		}
 		s->async->inttrig = NULL;
 	} else {
-		printk(KERN_ERR "comedi%d: ai_inttrig but acqu is already"
-		       " running\n", dev->minor);
+		dev_err(dev->class_dev,
+			"ai_inttrig but acqu is already running\n");
 	}
 	up(&udfs->sem);
 	return 1;
@@ -738,8 +737,8 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		printk(KERN_ERR "comedi%d: ai_cmd not possible. Another ai_cmd"
-		       " is running.\n", dev->minor);
+		dev_err(dev->class_dev,
+			"ai_cmd not possible. Another ai_cmd is running.\n");
 		up(&udfs->sem);
 		return -EBUSY;
 	}
@@ -757,31 +756,29 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		for (i = 0; i < cmd->chanlist_len; ++i) {
 			chan = CR_CHAN(cmd->chanlist[i]);
 			if (chan != i) {
-				printk(KERN_ERR "comedi%d: cmd is accepting "
-				       "only consecutive channels.\n",
-				       dev->minor);
+				dev_err(dev->class_dev,
+					"cmd is accepting only consecutive channels.\n");
 				up(&udfs->sem);
 				return -EINVAL;
 			}
 			if ((gain != CR_RANGE(cmd->chanlist[i]))
 			    && (cmd->chanlist_len > 3)) {
-				printk(KERN_ERR "comedi%d: the gain must be"
-				       " the same for all channels.\n",
-				       dev->minor);
+				dev_err(dev->class_dev,
+					"the gain must be the same for all channels.\n");
 				up(&udfs->sem);
 				return -EINVAL;
 			}
 			if (i >= NUMCHANNELS) {
-				printk(KERN_ERR "comedi%d: channel list too"
-				       " long\n", dev->minor);
+				dev_err(dev->class_dev,
+					"channel list too long\n");
 				break;
 			}
 		}
 	}
 	steps = 0;
 	if (cmd->scan_begin_src == TRIG_TIMER) {
-		printk(KERN_ERR "comedi%d: usbduxfast: "
-		       "scan_begin_src==TRIG_TIMER not valid.\n", dev->minor);
+		dev_err(dev->class_dev,
+			"scan_begin_src==TRIG_TIMER not valid.\n");
 		up(&udfs->sem);
 		return -EINVAL;
 	}
@@ -789,22 +786,21 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		steps = (cmd->convert_arg * 30) / 1000;
 
 	if ((steps < MIN_SAMPLING_PERIOD) && (cmd->chanlist_len != 1)) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: steps=%ld, "
-		       "scan_begin_arg=%d. Not properly tested by cmdtest?\n",
-		       dev->minor, steps, cmd->scan_begin_arg);
+		dev_err(dev->class_dev,
+			"ai_cmd: steps=%ld, scan_begin_arg=%d. Not properly tested by cmdtest?\n",
+			steps, cmd->scan_begin_arg);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if (steps > MAX_SAMPLING_PERIOD) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: sampling rate "
-		       "too low.\n", dev->minor);
+		dev_err(dev->class_dev, "ai_cmd: sampling rate too low.\n");
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if ((cmd->start_src == TRIG_EXT) && (cmd->chanlist_len != 1)
 	    && (cmd->chanlist_len != 16)) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: TRIG_EXT only"
-		       " with 1 or 16 channels possible.\n", dev->minor);
+		dev_err(dev->class_dev,
+			"ai_cmd: TRIG_EXT only with 1 or 16 channels possible.\n");
 		up(&udfs->sem);
 		return -EINVAL;
 	}
@@ -1121,8 +1117,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "comedi %d: unsupported combination of "
-		       "channels\n", dev->minor);
+		dev_err(dev->class_dev, "unsupported combination of channels\n");
 		up(&udfs->sem);
 		return -EFAULT;
 	}
@@ -1134,17 +1129,16 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	/* 0 means that the AD commands are sent */
 	result = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (result < 0) {
-		printk(KERN_ERR "comedi%d: adc command could not be submitted."
-		       "Aborting...\n", dev->minor);
+		dev_err(dev->class_dev,
+			"adc command could not be submitted. Aborting...\n");
 		up(&udfs->sem);
 		return result;
 	}
 	if (cmd->stop_src == TRIG_COUNT) {
 		udfs->ai_sample_count = cmd->stop_arg * cmd->scan_end_arg;
 		if (udfs->ai_sample_count < 1) {
-			printk(KERN_ERR "comedi%d: "
-			       "(cmd->stop_arg)*(cmd->scan_end_arg)<1, "
-			       "aborting.\n", dev->minor);
+			dev_err(dev->class_dev,
+				"(cmd->stop_arg)*(cmd->scan_end_arg)<1, aborting.\n");
 			up(&udfs->sem);
 			return -EFAULT;
 		}
@@ -1193,8 +1187,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi%d: ai_insn_read: no usb dev.\n",
-		       dev->minor);
+		dev_err(dev->class_dev, "%s: no usb dev.\n", __func__);
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
@@ -1207,8 +1200,8 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		printk(KERN_ERR "comedi%d: ai_insn_read not possible. Async "
-		       "Command is running.\n", dev->minor);
+		dev_err(dev->class_dev,
+			"ai_insn_read not possible. Async Command is running.\n");
 		up(&udfs->sem);
 		return -EBUSY;
 	}
@@ -1268,8 +1261,8 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 	/* 0 means that the AD commands are sent */
 	err = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (err < 0) {
-		printk(KERN_ERR "comedi%d: adc command could not be submitted."
-		       "Aborting...\n", dev->minor);
+		dev_err(dev->class_dev,
+			"adc command could not be submitted. Aborting...\n");
 		up(&udfs->sem);
 		return err;
 	}
@@ -1284,8 +1277,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 				   udfs->transfer_buffer, SIZEINBUF,
 				   &actual_length, 10000);
 		if (err < 0) {
-			printk(KERN_ERR "comedi%d: insn timeout. No data.\n",
-			       dev->minor);
+			dev_err(dev->class_dev, "insn timeout. No data.\n");
 			up(&udfs->sem);
 			return err;
 		}
@@ -1297,15 +1289,13 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 				   udfs->transfer_buffer, SIZEINBUF,
 				   &actual_length, 10000);
 		if (err < 0) {
-			printk(KERN_ERR "comedi%d: insn data error: %d\n",
-			       dev->minor, err);
+			dev_err(dev->class_dev, "insn data error: %d\n", err);
 			up(&udfs->sem);
 			return err;
 		}
 		n = actual_length / sizeof(uint16_t);
 		if ((n % 16) != 0) {
-			printk(KERN_ERR "comedi%d: insn data packet "
-			       "corrupted.\n", dev->minor);
+			dev_err(dev->class_dev, "insn data packet corrupted.\n");
 			up(&udfs->sem);
 			return -EINVAL;
 		}
@@ -1535,8 +1525,8 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	int ret;
 
 	if (udev->speed != USB_SPEED_HIGH) {
-		printk(KERN_ERR "comedi_: usbduxfast_: This driver needs"
-		       "USB 2.0 to operate. Aborting...\n");
+		dev_err(&uinterf->dev,
+			"This driver needs USB 2.0 to operate. Aborting...\n");
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
@@ -1555,7 +1545,8 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 
 	/* no more space */
 	if (index == -1) {
-		printk(KERN_ERR "Too many usbduxfast-devices connected.\n");
+		dev_err(&uinterf->dev,
+			"Too many usbduxfast-devices connected.\n");
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
@@ -1586,8 +1577,8 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	usbduxfastsub[index].dux_commands = kmalloc(SIZEOFDUXBUFFER,
 						    GFP_KERNEL);
 	if (!usbduxfastsub[index].dux_commands) {
-		printk(KERN_ERR "comedi_: usbduxfast: error alloc space for "
-		       "dac commands\n");
+		dev_err(&uinterf->dev,
+			"error alloc space for dac commands\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1595,8 +1586,8 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxfastsub[index].insnBuffer = kmalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].insnBuffer) {
-		printk(KERN_ERR "comedi_: usbduxfast: could not alloc space "
-		       "for insnBuffer\n");
+		dev_err(&uinterf->dev,
+			"could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1605,24 +1596,25 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxfastsub[index].usbdev,
 			      usbduxfastsub[index].ifnum, 1);
 	if (i < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: could not switch to "
-		       "alternate setting 1.\n", index);
+		dev_err(&uinterf->dev,
+			"usbduxfast%d: could not switch to alternate setting 1.\n",
+			index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENODEV;
 	}
 	usbduxfastsub[index].urbIn = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbduxfastsub[index].urbIn) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: Could not alloc."
-		       "urb\n", index);
+		dev_err(&uinterf->dev,
+			"usbduxfast%d: Could not alloc. urb\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
 	usbduxfastsub[index].transfer_buffer = kmalloc(SIZEINBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].transfer_buffer) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: could not alloc. "
-		       "transb.\n", index);
+		dev_err(&uinterf->dev,
+			"usbduxfast%d: could not alloc. transb.\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1640,12 +1632,12 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 				      usbduxfast_firmware_request_complete_handler);
 
 	if (ret) {
-		dev_err(&udev->dev, "could not load firmware (err=%d)\n", ret);
+		dev_err(&uinterf->dev, "could not load firmware (err=%d)\n", ret);
 		return ret;
 	}
 
-	printk(KERN_INFO "comedi_: usbduxfast%d has been successfully "
-	       "initialized.\n", index);
+	dev_info(&uinterf->dev,
+		 "usbduxfast%d has been successfully initialized.\n", index);
 	/* success */
 	return 0;
 }
@@ -1656,13 +1648,11 @@ static void usbduxfast_usb_disconnect(struct usb_interface *intf)
 	struct usb_device *udev = interface_to_usbdev(intf);
 
 	if (!udfs) {
-		printk(KERN_ERR "comedi_: usbduxfast: disconnect called with "
-		       "null pointer.\n");
+		dev_err(&intf->dev, "disconnect called with null pointer.\n");
 		return;
 	}
 	if (udfs->usbdev != udev) {
-		printk(KERN_ERR "comedi_: usbduxfast: BUG! called with wrong "
-		       "ptr!!!\n");
+		dev_err(&intf->dev, "BUG! called with wrong ptr!!!\n");
 		return;
 	}
 
-- 
1.7.9.5

