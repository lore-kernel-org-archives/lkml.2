Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab2ARFZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:25:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36448 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab2ARFZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:25:20 -0500
Date: Tue, 17 Jan 2012 21:25:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jan Steinhoff <mail@jan-steinhoff.de>
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Synaptics USB device driver
Message-ID: <20120118052513.GA32285@core.coreip.homeip.net>
References: <20120103194033.779cb829@greyhound>
 <201201041020.41795.oneukum@suse.de>
 <20120104094103.GA29069@core.coreip.homeip.net>
 <201201041056.20226.oneukum@suse.de>
 <20120104100553.GA29131@core.coreip.homeip.net>
 <20120105060138.704cfb16@greyhound>
 <20120105063611.GB31895@core.coreip.homeip.net>
 <20120105142257.7adbd098@guest>
 <20120110094334.GA7036@core.coreip.homeip.net>
 <20120112000848.1c29f6a3@greyhound>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112000848.1c29f6a3@greyhound>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 12:08:48AM +0000, Jan Steinhoff wrote:
> On Tue, 10 Jan 2012 01:43:34 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > The patch below seems to work well on my combo device (Lenovo keyboard
> > with integrated touchpad/trackpoint). Could you please tell me if it
> > works with your devices as well?
> 
> Yes, it works. Thanks a lot for the cleanup and improvement!
> 
> Just a last remark: The reconnects do not appear while the cPad is
> suspended, so it is save to allow it to autosuspend. Can the autopm
> calls be removed from probe and disconnect, and needs_remote_wakeup be
> set in probe instead?

OK, how about thie patch below then (on top of the previous one)?

Thanks.

-- 
Dmitry


Input: synaptics-use - rework starting of cPad-like devices

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/synaptics_usb.c |   65 ++++++++++++-----------------------
 1 files changed, 22 insertions(+), 43 deletions(-)


diff --git a/drivers/input/mouse/synaptics_usb.c b/drivers/input/mouse/synaptics_usb.c
index 216cf2b..e559a94 100644
--- a/drivers/input/mouse/synaptics_usb.c
+++ b/drivers/input/mouse/synaptics_usb.c
@@ -245,11 +245,6 @@ static int synusb_open(struct input_dev *dev)
 	struct synusb *synusb = input_get_drvdata(dev);
 	int retval;
 
-	if (synusb->flags & SYNUSB_IO_ALWAYS) {
-		/* We already started IO in synusb_probe() */
-		return 0;
-	}
-
 	retval = usb_autopm_get_interface(synusb->intf);
 	if (retval) {
 		dev_err(&synusb->intf->dev,
@@ -277,16 +272,15 @@ out:
 static void synusb_close(struct input_dev *dev)
 {
 	struct synusb *synusb = input_get_drvdata(dev);
+	int autopm_error;
 
-	if (!(synusb->flags & SYNUSB_IO_ALWAYS)) {
-		int autopm_error = usb_autopm_get_interface(synusb->intf);
+	autopm_error = usb_autopm_get_interface(synusb->intf);
 
-		usb_kill_urb(synusb->urb);
-		synusb->intf->needs_remote_wakeup = 0;
+	usb_kill_urb(synusb->urb);
+	synusb->intf->needs_remote_wakeup = 0;
 
-		if (!autopm_error)
-			usb_autopm_put_interface(synusb->intf);
-	}
+	if (!autopm_error)
+		usb_autopm_put_interface(synusb->intf);
 }
 
 static int synusb_probe(struct usb_interface *intf,
@@ -380,8 +374,10 @@ static int synusb_probe(struct usb_interface *intf,
 	usb_to_input_id(udev, &input_dev->id);
 	input_dev->dev.parent = &synusb->intf->dev;
 
-	input_dev->open = synusb_open;
-	input_dev->close = synusb_close;
+	if (!(synusb->flags & SYNUSB_IO_ALWAYS)) {
+		input_dev->open = synusb_open;
+		input_dev->close = synusb_close;
+	}
 
 	input_set_drvdata(input_dev, synusb);
 
@@ -412,40 +408,25 @@ static int synusb_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, synusb);
 
+	if (synusb->flags & SYNUSB_IO_ALWAYS) {
+		error = synusb_open(input_dev);
+		if (error)
+			goto err_free_dma;
+	}
+
 	error = input_register_device(input_dev);
 	if (error) {
 		dev_err(&udev->dev,
 			"Failed to register input device, error %d\n",
 			error);
-		goto err_free_dma;
-	}
-
-	if (synusb->flags & SYNUSB_IO_ALWAYS) {
-		error = usb_autopm_get_interface(synusb->intf);
-		if (error) {
-			dev_err(&udev->dev,
-				"%s - usb_autopm_get_interface failed, error: %d\n",
-				__func__, error);
-			goto err_unregister_input;
-		}
-
-		error = usb_submit_urb(synusb->urb, GFP_KERNEL);
-		if (error) {
-			dev_err(&synusb->intf->dev,
-				"%s - usb_submit_urb failed, error: %d\n",
-				__func__, error);
-			error = -EIO;
-			goto err_put_intf;
-		}
+		goto err_stop_io;
 	}
 
 	return 0;
 
-err_put_intf:
-	usb_autopm_put_interface(synusb->intf);
-err_unregister_input:
-	input_unregister_device(input_dev);
-	input_dev = NULL;
+err_stop_io:
+	if (synusb->flags & SYNUSB_IO_ALWAYS)
+		synusb_close(synusb->input);
 err_free_dma:
 	usb_free_coherent(udev, SYNUSB_RECV_SIZE, synusb->data,
 			  synusb->urb->transfer_dma);
@@ -464,10 +445,8 @@ static void synusb_disconnect(struct usb_interface *intf)
 	struct synusb *synusb = usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	if (synusb->flags & SYNUSB_IO_ALWAYS) {
-		usb_kill_urb(synusb->urb);
-		usb_autopm_put_interface(synusb->intf);
-	}
+	if (synusb->flags & SYNUSB_IO_ALWAYS)
+		synusb_close(synusb->input);
 
 	input_unregister_device(synusb->input);
 
