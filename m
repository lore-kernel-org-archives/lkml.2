Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1KSR1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:27:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50456 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1KSR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:27:08 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <balbi@ti.com>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Anatolij Gustschin <agust@denx.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ben Dooks <ben@simtec.co.uk>, Heiko Stubner <heiko@sntech.de>,
        Thomas Abraham <thomas.ab@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 1/3] usb: udc: Fix gadget driver's speed check in various UDC drivers
Date: Sat, 19 Nov 2011 18:26:25 +0100
Message-Id: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <Pine.LNX.4.44L0.1111161624570.3443-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1111161624570.3443-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Several UDC drivers had a gadget driver's speed sanity check of the
form of:

	driver->speed != USB_SPEED_HIGH

or:

	driver->speed != USB_SPEED_HIGH && driver->speed != USB_SPEED_FULL

As more and more gadget drivers support USB SuperSpeed, driver->speed
may be set to USB_SPEED_SUPER and UDC driver should handle such gadget
correctly.  The above checks however fail to recognise USB_SPEED_SUPER
as a valid speed.

This commit changes the two checks to:

	driver->speed < USB_SPEED_HIGH

or:

	driver->speed < USB_SPEED_FULL

respectively.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
---

I had no way of testing those changes but it appears that those UDC
drivers check gadget driver's speed only on the entry point and then
nothing is really dependent on it.

The only thing that makes me wonder a little is that
USB_SPEED_WIRELESS will be allowed by the above checks and I'm not
entirely sure if that's desired (even though that's probably not an
issue right now).

Nonetheless, this patch needs to get merged to 3.2 as without it
file_storage won't work on UDC drivers this patch updates.

The next two patches that follow this one are replacements for
[291a72f8: usb: gadget: replace usb_gadget::is_dualspeed with
max_speed] and [d93bb846: usb: gadget: rename usb_gadget_driver::speed
to max_speed] from Felipe's gadget tree, which did not apply correctly
on top of this patch.

The whole series is based on Greg's for-linus tree.

 drivers/usb/gadget/amd5536udc.c   |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c   |    3 +--
 drivers/usb/gadget/fsl_udc_core.c |    3 +--
 drivers/usb/gadget/m66592-udc.c   |    2 +-
 drivers/usb/gadget/net2280.c      |    2 +-
 drivers/usb/gadget/r8a66597-udc.c |    2 +-
 drivers/usb/gadget/s3c-hsotg.c    |    4 +---
 drivers/usb/gadget/s3c-hsudc.c    |    3 +--
 drivers/usb/musb/musb_gadget.c    |    2 +-
 9 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 4730016..45f422a 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1959,7 +1959,7 @@ static int amd5536_start(struct usb_gadget_driver *driver,
 	u32 tmp;
 
 	if (!driver || !bind || !driver->setup
-			|| driver->speed != USB_SPEED_HIGH)
+			|| driver->speed < USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 2a03e4d..e00cf92 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2336,8 +2336,7 @@ static int fsl_qe_start(struct usb_gadget_driver *driver,
 	if (!udc_controller)
 		return -ENODEV;
 
-	if (!driver || (driver->speed != USB_SPEED_FULL
-			&& driver->speed != USB_SPEED_HIGH)
+	if (!driver || driver->speed < USB_SPEED_FULL
 			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index b3b3d83..1482b12 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1938,8 +1938,7 @@ static int fsl_start(struct usb_gadget_driver *driver,
 	if (!udc_controller)
 		return -ENODEV;
 
-	if (!driver || (driver->speed != USB_SPEED_FULL
-				&& driver->speed != USB_SPEED_HIGH)
+	if (!driver || driver->speed < USB_SPEED_FULL
 			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 91d0af2..9aa1cbb 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1472,7 +1472,7 @@ static int m66592_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->speed < USB_SPEED_HIGH
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 7f1bc9a..da2b9d0 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1881,7 +1881,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 * (dev->usb->xcvrdiag & FORCE_FULL_SPEED_MODE)
 	 * "must not be used in normal operation"
 	 */
-	if (!driver || driver->speed != USB_SPEED_HIGH
+	if (!driver || driver->speed < USB_SPEED_HIGH
 			|| !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 24f84b2..fc719a3 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1746,7 +1746,7 @@ static int r8a66597_start(struct usb_gadget *gadget,
 	struct r8a66597 *r8a66597 = gadget_to_r8a66597(gadget);
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->speed < USB_SPEED_HIGH
 			|| !driver->setup)
 		return -EINVAL;
 	if (!r8a66597)
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index a552453..b314482 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2586,10 +2586,8 @@ static int s3c_hsotg_start(struct usb_gadget_driver *driver,
 		return -EINVAL;
 	}
 
-	if (driver->speed != USB_SPEED_HIGH &&
-	    driver->speed != USB_SPEED_FULL) {
+	if (driver->speed < USB_SPEED_FULL)
 		dev_err(hsotg->dev, "%s: bad speed\n", __func__);
-	}
 
 	if (!bind || !driver->setup) {
 		dev_err(hsotg->dev, "%s: missing entry points\n", __func__);
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 8d54f89..20a553b 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1142,8 +1142,7 @@ static int s3c_hsudc_start(struct usb_gadget_driver *driver,
 	int ret;
 
 	if (!driver
-		|| (driver->speed != USB_SPEED_FULL &&
-			driver->speed != USB_SPEED_HIGH)
+		|| driver->speed < USB_SPEED_FULL
 		|| !bind
 		|| !driver->unbind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index d51043a..922148f 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1903,7 +1903,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	unsigned long		flags;
 	int			retval = -EINVAL;
 
-	if (driver->speed != USB_SPEED_HIGH)
+	if (driver->speed < USB_SPEED_HIGH)
 		goto err0;
 
 	pm_runtime_get_sync(musb->controller);
-- 
1.7.3.1

