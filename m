Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1CKLbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:31:06 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:64407 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1CKLbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:31:03 -0500
X-IronPort-AV: E=Sophos;i="4.62,302,1297036800"; 
   d="scan'208";a="4741857"
Date: Fri, 11 Mar 2011 11:30:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: linux-kernel@vger.kernel.org
CC: dmitry.torokhov@gmail.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-input@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] input/xen-fbfront: advertise either absolute or relative
 coordinates
Message-ID: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

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

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 7f85a86..24fc38b 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -110,7 +110,7 @@ static irqreturn_t input_handler(int rq, void *dev_id)
 static int __devinit xenkbd_probe(struct xenbus_device *dev,
 				  const struct xenbus_device_id *id)
 {
-	int ret, i;
+	int ret, i, abs;
 	struct xenkbd_info *info;
 	struct input_dev *kbd, *ptr;
 
@@ -128,6 +128,11 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
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
@@ -160,10 +165,16 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 	ptr->id.bustype = BUS_PCI;
 	ptr->id.vendor = 0x5853;
 	ptr->id.product = 0xfffe;
-	ptr->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
+	ptr->evbit[0] = BIT(EV_KEY);
+	if (abs)
+		ptr->evbit[0] |= BIT(EV_ABS);
+	else {
+		ptr->evbit[0] |= BIT(EV_REL);
+		ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	}
+	input_set_capability(ptr, EV_REL, REL_WHEEL);
 	for (i = BTN_LEFT; i <= BTN_TASK; i++)
 		set_bit(i, ptr->keybit);
-	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y) | BIT(REL_WHEEL);
 	input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
 	input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
 
@@ -272,7 +283,7 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int ret, val;
+	int val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -285,16 +296,6 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 
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
-				pr_warning("can't request abs-pointer\n");
-		}
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 
