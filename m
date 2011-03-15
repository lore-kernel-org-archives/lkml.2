Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1COFAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:00:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1COFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9mzTBS9NEn36S0snUHYNzTQt5ElCq+xhB4CBmMO3++sCrae5V+kPeiZGPXWW6Qni9
         75kklv/YRmfhywxChHPBSOEtQtVMNACclhnJ4/JCOvx+ogLj8C4DH5/2da5jkFcITHFi
         KooUj7rDaw23mWwtp/SEno0p7/8Wz0qWaHpPM=
Date: Mon, 14 Mar 2011 22:00:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-input@vger.kernel.org
Subject: Re: [PATCH] input/xen-fbfront: advertise either absolute or relative
 coordinates
Message-ID: <20110315050024.GB1046@core.coreip.homeip.net>
References: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop>
 <20110313062411.GB31566@core.coreip.homeip.net>
 <20110314100144.GA4572@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314100144.GA4572@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:01:44AM +0100, Olaf Hering wrote:
> On Sat, Mar 12, Dmitry Torokhov wrote:
> 
> > Hi Stefano,
> > 
> > On Fri, Mar 11, 2011 at 11:30:10AM +0000, Stefano Stabellini wrote:
> > > From: Olaf Hering <olaf@aepfle.de>
> > > 
> > > A virtualized display device is usually viewed with the vncviewer
> > > application, either by 'xm vnc domU' or with vncviewer localhost:port.
> > > vncviewer and the RFB protocol provides absolute coordinates to the
> > > virtual display. These coordinates are either passed through to a PV
> > > guest or converted to relative coordinates for a HVM guest.
> > > 
> > > A PV guest receives these coordinates and passes them to the kernels
> > > evdev driver. There it can be picked up by applications such as the
> > > xorg-input drivers. Using absolute coordinates avoids issues such as
> > > guest mouse pointer not tracking host mouse pointer due to wrong mouse
> > > acceleration settings in the guests X display.
> > > 
> > > Advertise either absolute or relative coordinates to the input system
> > > and the evdev driver, depending on what dom0 provides. The xorg-input
> > > driver prefers relative coordinates even if a devices provides both.
> > 
> > So if I am reading this correctly the original version handled changes
> > in backend capabilities and could switch between delivering either
> > relative or absolute coordinates. The new version selects the
> > capabilities at boot time and sticks with them. Was it really the
> > intended behavior?
> 
> Yes, as mentioned in the description above, using absolute coordinates in
> the guests X11 is prefered because it avoids that the guest mouse
> pointer gets out of sync with the host/desktop mouse pointer.
> Very old Xen versions did not send absolute coordinates, but recent
> versions do.
> 

OK, as long as we have understanding that there is no concern with
migrating to a version of hypervisor that does not support absolute
coordinates reporting.

BTW, I believe the code should be rearranged a bit, like in the patch
below (this way we do not set up abs params if device works in relative
mode).

Thanks.

-- 
Dmitry

Input: xen-kbdfront - advertise either absolute or relative coordinates

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
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/xen-kbdfront.c |   44 +++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 20 deletions(-)


diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 7f85a86..53e6273 100644
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
@@ -137,11 +142,12 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
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
@@ -160,12 +166,20 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
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
@@ -272,7 +286,7 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int ret, val;
+	int val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -285,16 +299,6 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 
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
 
