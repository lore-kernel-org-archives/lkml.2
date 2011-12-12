Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1LLIwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:52:13 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:48912 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:52:12 -0500
X-SENDER-IP: [85.230.170.8]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao9CAOe/5U5V5qoIPGdsb2JhbAA8B4lOoScZAQEBATcygXIBLS8TAQ8YGGoKGgoJiAq0RhSIJ4MyBIx5KI0qjE4
X-IronPort-AV: E=Sophos;i="4.71,337,1320620400"; 
   d="scan'208";a="10172184"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: bcm5974 - Fix USB autosuspend
Date: Mon, 12 Dec 2011 10:06:04 +0100
Message-Id: <1323680764-2155-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

The bcm5974 code takes a USB autosuspend reference on device open and
releases it on device close. This means that the hardware won't sleep
when anything holds it open. This is sensible for input devices that
don't support remote wakeups on normal use (like most mice), but this
hardware trigger wakeups on touch and so can suspend transparently to
the user. Doing so allows the USB host controller to sleep when the
machine is idle, giving measurable power savings.

[rydberg@euromail.se: removal of open/close]
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   74 +++++++++++------------------------------
 1 files changed, 20 insertions(+), 54 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 5ec617e..178be2b 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -221,7 +221,7 @@ struct bcm5974 {
 	struct input_dev *input;	/* input dev */
 	struct bcm5974_config cfg;	/* device configuration */
 	struct mutex pm_mutex;		/* serialize access to open/suspend */
-	int opened;			/* 1: opened, 0: closed */
+	int started;			/* 1: started, 0: paused */
 	struct urb *bt_urb;		/* button usb request block */
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
@@ -631,6 +631,7 @@ static void bcm5974_irq_button(struct urb *urb)
 
 	switch (urb->status) {
 	case 0:
+		usb_mark_last_busy(dev->udev);
 		break;
 	case -EOVERFLOW:
 	case -ECONNRESET:
@@ -660,6 +661,7 @@ static void bcm5974_irq_trackpad(struct urb *urb)
 
 	switch (urb->status) {
 	case 0:
+		usb_mark_last_busy(dev->udev);
 		break;
 	case -EOVERFLOW:
 	case -ECONNRESET:
@@ -708,6 +710,9 @@ static int bcm5974_start_traffic(struct bcm5974 *dev)
 {
 	int error;
 
+	if (dev->started)
+		return 0;
+
 	error = bcm5974_wellspring_mode(dev, true);
 	if (error) {
 		dprintk(1, "bcm5974: mode switch failed\n");
@@ -722,6 +727,7 @@ static int bcm5974_start_traffic(struct bcm5974 *dev)
 	if (error)
 		goto err_kill_bt;
 
+	dev->started = 1;
 	return 0;
 
 err_kill_bt:
@@ -734,54 +740,12 @@ err_out:
 
 static void bcm5974_pause_traffic(struct bcm5974 *dev)
 {
+	if (!dev->started)
+		return;
 	usb_kill_urb(dev->tp_urb);
 	usb_kill_urb(dev->bt_urb);
 	bcm5974_wellspring_mode(dev, false);
-}
-
-/*
- * The code below implements open/close and manual suspend/resume.
- * All functions may be called in random order.
- *
- * Opening a suspended device fails with EACCES - permission denied.
- *
- * Failing a resume leaves the device resumed but closed.
- */
-static int bcm5974_open(struct input_dev *input)
-{
-	struct bcm5974 *dev = input_get_drvdata(input);
-	int error;
-
-	error = usb_autopm_get_interface(dev->intf);
-	if (error)
-		return error;
-
-	mutex_lock(&dev->pm_mutex);
-
-	error = bcm5974_start_traffic(dev);
-	if (!error)
-		dev->opened = 1;
-
-	mutex_unlock(&dev->pm_mutex);
-
-	if (error)
-		usb_autopm_put_interface(dev->intf);
-
-	return error;
-}
-
-static void bcm5974_close(struct input_dev *input)
-{
-	struct bcm5974 *dev = input_get_drvdata(input);
-
-	mutex_lock(&dev->pm_mutex);
-
-	bcm5974_pause_traffic(dev);
-	dev->opened = 0;
-
-	mutex_unlock(&dev->pm_mutex);
-
-	usb_autopm_put_interface(dev->intf);
+	dev->started = 0;
 }
 
 static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
@@ -790,8 +754,7 @@ static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
 
 	mutex_lock(&dev->pm_mutex);
 
-	if (dev->opened)
-		bcm5974_pause_traffic(dev);
+	bcm5974_pause_traffic(dev);
 
 	mutex_unlock(&dev->pm_mutex);
 
@@ -801,12 +764,11 @@ static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
 static int bcm5974_resume(struct usb_interface *iface)
 {
 	struct bcm5974 *dev = usb_get_intfdata(iface);
-	int error = 0;
+	int error;
 
 	mutex_lock(&dev->pm_mutex);
 
-	if (dev->opened)
-		error = bcm5974_start_traffic(dev);
+	error = bcm5974_start_traffic(dev);
 
 	mutex_unlock(&dev->pm_mutex);
 
@@ -870,6 +832,9 @@ static int bcm5974_probe(struct usb_interface *iface,
 			 dev->tp_data, dev->cfg.tp_datalen,
 			 bcm5974_irq_trackpad, dev, 1);
 
+	/* Required for autosuspend */
+	iface->needs_remote_wakeup = 1;
+
 	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));
@@ -883,9 +848,6 @@ static int bcm5974_probe(struct usb_interface *iface,
 
 	input_set_drvdata(input_dev, dev);
 
-	input_dev->open = bcm5974_open;
-	input_dev->close = bcm5974_close;
-
 	setup_events_to_report(input_dev, cfg);
 
 	error = input_register_device(dev->input);
@@ -895,6 +857,10 @@ static int bcm5974_probe(struct usb_interface *iface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
+	error = bcm5974_start_traffic(dev);
+	if (error)
+		goto err_free_buffer;
+
 	return 0;
 
 err_free_buffer:
-- 
1.7.8

