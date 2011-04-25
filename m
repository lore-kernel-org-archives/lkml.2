Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1DYUnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:43:32 -0400
Received: from 1wt.eu ([62.212.114.60]:34343 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab1DYUYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:52 -0400
Message-Id: <20110425200237.859884245@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Olaf Hering <olaf@aepfle.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 112/173] Input: xen-kbdfront - advertise either absolute or relative coordinates
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Olaf Hering <olaf@aepfle.de>

commit 8c3c283e6bf463ab498d6e7823aff6c4762314b6 upstream.

A virtualized display device is usually viewed with the vncviewer
application, either by 'xm vnc domU' or with vncviewer localhost:port.
vncviewer and the RFB protocol provides absolute coordinates to the
virtual display. These coordinates are either passed through to a PV
guest or converted to relative coordinates for a HVM guest.

A PV guest receives these coordinates and passes them to the kernels
evdev driver. There it can be picked up by applications such as the
xorg-input drivers. Using absolute coordinates avoids issues such as
guest mouse pointer not tracking host mouse pointer due to wrong mouse
acceleration settings in the guests X display.

Advertise either absolute or relative coordinates to the input system
and the evdev driver, depending on what dom0 provides. The xorg-input
driver prefers relative coordinates even if a devices provides both.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/xen-kbdfront.c |   45 ++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

Index: longterm-2.6.27/drivers/input/xen-kbdfront.c
===================================================================
--- longterm-2.6.27.orig/drivers/input/xen-kbdfront.c	2011-01-23 10:52:17.000000000 +0100
+++ longterm-2.6.27/drivers/input/xen-kbdfront.c	2011-04-25 16:32:54.339278957 +0200
@@ -105,7 +105,7 @@
 static int __devinit xenkbd_probe(struct xenbus_device *dev,
 				  const struct xenbus_device_id *id)
 {
-	int ret, i;
+	int ret, i, abs;
 	struct xenkbd_info *info;
 	struct input_dev *kbd, *ptr;
 
@@ -123,6 +123,11 @@
 	if (!info->page)
 		goto error_nomem;
 
+	if (xenbus_scanf(XBT_NIL, dev->otherend, "feature-abs-pointer", "%d", &abs) < 0)
+		abs = 0;
+	if (abs)
+		xenbus_printf(XBT_NIL, dev->nodename, "request-abs-pointer", "1");
+
 	/* keyboard */
 	kbd = input_allocate_device();
 	if (!kbd)
@@ -132,11 +137,12 @@
 	kbd->id.bustype = BUS_PCI;
 	kbd->id.vendor = 0x5853;
 	kbd->id.product = 0xffff;
-	kbd->evbit[0] = BIT(EV_KEY);
+
+	__set_bit(EV_KEY, kbd->evbit);
 	for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
-		set_bit(i, kbd->keybit);
+		__set_bit(i, kbd->keybit);
 	for (i = KEY_OK; i < KEY_MAX; i++)
-		set_bit(i, kbd->keybit);
+		__set_bit(i, kbd->keybit);
 
 	ret = input_register_device(kbd);
 	if (ret) {
@@ -155,12 +161,20 @@
 	ptr->id.bustype = BUS_PCI;
 	ptr->id.vendor = 0x5853;
 	ptr->id.product = 0xfffe;
-	ptr->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
+
+	if (abs) {
+		__set_bit(EV_ABS, ptr->evbit);
+		input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
+		input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
+	} else {
+		input_set_capability(ptr, EV_REL, REL_X);
+		input_set_capability(ptr, EV_REL, REL_Y);
+	}
+	input_set_capability(ptr, EV_REL, REL_WHEEL);
+
+	__set_bit(EV_KEY, ptr->evbit);
 	for (i = BTN_LEFT; i <= BTN_TASK; i++)
-		set_bit(i, ptr->keybit);
-	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y) | BIT(REL_WHEEL);
-	input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
-	input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
+		__set_bit(i, ptr->keybit);
 
 	ret = input_register_device(ptr);
 	if (ret) {
@@ -267,7 +281,7 @@
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev->dev.driver_data;
-	int ret, val;
+	int val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -278,17 +292,6 @@
 
 	case XenbusStateInitWait:
 InitWait:
-		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
-				   "feature-abs-pointer", "%d", &val);
-		if (ret < 0)
-			val = 0;
-		if (val) {
-			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
-					    "request-abs-pointer", "1");
-			if (ret)
-				printk(KERN_WARNING
-				       "xenkbd: can't request abs-pointer");
-		}
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 


