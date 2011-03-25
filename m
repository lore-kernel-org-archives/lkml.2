Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab1CYX7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:59:31 -0400
Received: from kroah.org ([198.145.64.141]:48947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023Ab1CYX61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:58:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:56:38 2011
Message-Id: <20110325235638.538101262@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:55:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olaf Hering <olaf@aepfle.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [20/23] Input: xen-kbdfront - advertise either absolute or relative coordinates
References: <20110325235537.660072281@clark.kroah.org>
Content-Disposition: inline; filename=input-xen-kbdfront-advertise-either-absolute-or-relative-coordinates.patch
In-Reply-To: <20110325235654.GA24416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -105,7 +105,7 @@ static irqreturn_t input_handler(int rq,
 static int __devinit xenkbd_probe(struct xenbus_device *dev,
 				  const struct xenbus_device_id *id)
 {
-	int ret, i;
+	int ret, i, abs;
 	struct xenkbd_info *info;
 	struct input_dev *kbd, *ptr;
 
@@ -123,6 +123,11 @@ static int __devinit xenkbd_probe(struct
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
@@ -132,11 +137,12 @@ static int __devinit xenkbd_probe(struct
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
@@ -155,12 +161,20 @@ static int __devinit xenkbd_probe(struct
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
@@ -267,7 +281,7 @@ static void xenkbd_backend_changed(struc
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int ret, val;
+	int val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -278,17 +292,6 @@ static void xenkbd_backend_changed(struc
 
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
 


