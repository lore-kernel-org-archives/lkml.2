Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1HVQFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:05:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6162 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1HVQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:04:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vM2Jay8uNJUQMcscBRjkWrqT+a0fBGuvESzsQMXnigCdLNMoiYMIFXPblg6hcZGDc
	3JPaTBqRnB+h8VzhDRYqQ==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv4 3/4] usb: gadget: rename usb_gadget_driver::speed to max_speed
Date: Mon, 22 Aug 2011 18:04:21 +0200
Message-Id: <8289497114d3da8366ea7ed8397b4d3f16afb946.1314028707.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1314028707.git.mina86@mina86.com>
References: <cover.1314028707.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit renames the “speed” field of the usb_gadget_driver
structure to “max_speed”.  This is so that to make it more
apparent that the field represents the maximum speed gadget
driver can support.

This also make the field look more like fields with the same
name in usb_gadget and usb_composite_driver structures.  All
of those represent the *maximal* speed given entity supports.

After this commit, there are the following fields in various
structures:
* usb_gadget::speed - the current connection speed,
* usb_gadget::max_speed - maximal speed UDC supports,
* usb_gadget_driver::max_speed - maximal speed gadget driver
  supports, and
* usb_composite_driver::max_speed - maximal speed composite
  gadget supports.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/amd5536udc.c   |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c  |    2 +-
 drivers/usb/gadget/composite.c    |    8 ++++----
 drivers/usb/gadget/dbgp.c         |    2 +-
 drivers/usb/gadget/dummy_hcd.c    |   13 ++++++-------
 drivers/usb/gadget/file_storage.c |    4 ++--
 drivers/usb/gadget/gmidi.c        |    2 +-
 drivers/usb/gadget/goku_udc.c     |    2 +-
 drivers/usb/gadget/inode.c        |    6 +++---
 drivers/usb/gadget/m66592-udc.c   |    2 +-
 drivers/usb/gadget/net2272.c      |    2 +-
 drivers/usb/gadget/net2280.c      |    2 +-
 drivers/usb/gadget/pch_udc.c      |    2 +-
 drivers/usb/gadget/printer.c      |    2 +-
 drivers/usb/gadget/r8a66597-udc.c |    2 +-
 include/linux/usb/gadget.h        |    4 ++--
 16 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 8b684b0..cd520f9 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1968,7 +1968,7 @@ static int amd5536_start(struct usb_gadget_driver *driver,
 	u32 tmp;
 
 	if (!driver || !bind || !driver->setup
-			|| driver->speed != USB_SPEED_HIGH)
+			|| driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index b877464..6c13174 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -798,7 +798,7 @@ static ssize_t show_driver(struct device *dev, struct device_attribute *attr,
 	n += scnprintf(buf + n, PAGE_SIZE - n, "function  = %s\n",
 		       (driver->function ? driver->function : ""));
 	n += scnprintf(buf + n, PAGE_SIZE - n, "max speed = %d\n",
-		       driver->speed);
+		       driver->max_speed);
 
 	return n;
 }
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 0d03936..36f326a 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1544,9 +1544,9 @@ composite_resume(struct usb_gadget *gadget)
 
 static struct usb_gadget_driver composite_driver = {
 #ifdef CONFIG_USB_GADGET_SUPERSPEED
-	.speed		= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER,
 #else
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #endif
 
 	.unbind		= composite_unbind,
@@ -1593,8 +1593,8 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
-	composite_driver.speed = min((u8)composite_driver.speed,
-				     (u8)driver->max_speed);
+	composite_driver.max_speed = min((u8)composite_driver.max_speed,
+					 (u8)driver->max_speed);
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/dbgp.c b/drivers/usb/gadget/dbgp.c
index e8737b5..4e6f8a2 100644
--- a/drivers/usb/gadget/dbgp.c
+++ b/drivers/usb/gadget/dbgp.c
@@ -405,7 +405,7 @@ fail:
 
 static struct usb_gadget_driver dbgp_driver = {
 	.function = "dbgp",
-	.speed = USB_SPEED_HIGH,
+	.max_speed = USB_SPEED_HIGH,
 	.unbind = dbgp_unbind,
 	.setup = dbgp_setup,
 	.disconnect = dbgp_disconnect,
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 03f074f..c0fefc5 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -832,19 +832,18 @@ static int dummy_pullup (struct usb_gadget *_gadget, int value)
 
 	if (value && dum->driver) {
 		if (mod_data.is_super_speed)
-			dum->gadget.speed = dum->driver->speed;
+			dum->gadget.speed = dum->driver->max_speed;
 		else if (mod_data.is_high_speed)
 			dum->gadget.speed = min_t(u8, USB_SPEED_HIGH,
-					dum->driver->speed);
+					dum->driver->max_speed);
 		else
 			dum->gadget.speed = USB_SPEED_FULL;
 		dummy_udc_udpate_ep0(dum);
 
-		if (dum->gadget.speed < dum->driver->speed)
+		if (dum->gadget.speed < dum->driver->max_speed)
 			dev_dbg(udc_dev(dum), "This device can perform faster"
-					" if you connect it to a %s port...\n",
-					(dum->driver->speed == USB_SPEED_SUPER ?
-					 "SuperSpeed" : "HighSpeed"));
+				" if you connect it to a %s port...\n",
+				usb_speed_string(dum->driver->max_speed));
 	}
 	dum_hcd = gadget_to_dummy_hcd(_gadget);
 
@@ -907,7 +906,7 @@ static int dummy_udc_start(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	if (driver->speed == USB_SPEED_UNKNOWN)
+	if (driver->max_speed == USB_SPEED_UNKNOWN)
 		return -EINVAL;
 
 	/*
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index fede982..7526d4a 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3556,9 +3556,9 @@ static void fsg_resume(struct usb_gadget *gadget)
 
 static struct usb_gadget_driver		fsg_driver = {
 #ifdef CONFIG_USB_GADGET_DUALSPEED
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #else
-	.speed		= USB_SPEED_FULL,
+	.max_speed	= USB_SPEED_FULL,
 #endif
 	.function	= (char *) fsg_string_product,
 	.unbind		= fsg_unbind,
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 6c3d213..0ea862c 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -1283,7 +1283,7 @@ static void gmidi_resume(struct usb_gadget *gadget)
 
 
 static struct usb_gadget_driver gmidi_driver = {
-	.speed		= USB_SPEED_FULL,
+	.max_speed	= USB_SPEED_FULL,
 	.function	= (char *)longname,
 	.unbind		= gmidi_unbind,
 
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index ab9c924..5af70fcc 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1357,7 +1357,7 @@ static int goku_start(struct usb_gadget_driver *driver,
 	int			retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 1b24099..4bd48ea 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1774,9 +1774,9 @@ gadgetfs_suspend (struct usb_gadget *gadget)
 
 static struct usb_gadget_driver gadgetfs_driver = {
 #ifdef	CONFIG_USB_GADGET_DUALSPEED
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #else
-	.speed		= USB_SPEED_FULL,
+	.max_speed	= USB_SPEED_FULL,
 #endif
 	.function	= (char *) driver_desc,
 	.unbind		= gadgetfs_unbind,
@@ -1800,7 +1800,7 @@ static int gadgetfs_probe (struct usb_gadget *gadget)
 }
 
 static struct usb_gadget_driver probe_driver = {
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= gadgetfs_nop,
 	.setup		= (void *)gadgetfs_nop,
 	.disconnect	= gadgetfs_nop,
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index fbdfca8..72dc3f1 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1482,7 +1482,7 @@ static int m66592_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 8747432..1767230 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -1461,7 +1461,7 @@ static int net2272_start(struct usb_gadget_driver *driver,
 	unsigned i;
 
 	if (!driver || !bind || !driver->unbind || !driver->setup ||
-	    driver->speed != USB_SPEED_HIGH)
+	    driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 40b86a7..11b9959 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1892,7 +1892,7 @@ static int net2280_start(struct usb_gadget_driver *driver,
 	 * "must not be used in normal operation"
 	 */
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !bind || !driver->setup)
 		return -EINVAL;
 	if (!dev)
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index d781540..1db6d0e 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2701,7 +2701,7 @@ static int pch_udc_start(struct usb_gadget_driver *driver,
 	struct pch_udc_dev	*dev = pch_udc;
 	int			retval;
 
-	if (!driver || (driver->speed == USB_SPEED_UNKNOWN) || !bind ||
+	if (!driver || (driver->max_speed == USB_SPEED_UNKNOWN) || !bind ||
 	    !driver->setup || !driver->unbind || !driver->disconnect) {
 		dev_err(&dev->pdev->dev,
 			"%s: invalid driver parameter\n", __func__);
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index c39dd8c..2b9965b 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1544,7 +1544,7 @@ fail:
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver printer_driver = {
-	.speed		= DEVSPEED,
+	.max_speed	= DEVSPEED,
 
 	.function	= (char *) driver_desc,
 	.unbind		= printer_unbind,
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index a8f7a05..df99690 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1442,7 +1442,7 @@ static int r8a66597_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 7eb2ec3..c8ea048 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -760,7 +760,7 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
 /**
  * struct usb_gadget_driver - driver for usb 'slave' devices
  * @function: String describing the gadget's function
- * @speed: Highest speed the driver handles.
+ * @max_speed: Highest speed the driver handles.
  * @setup: Invoked for ep0 control requests that aren't handled by
  *	the hardware level driver. Most calls must be handled by
  *	the gadget driver, including descriptor and configuration
@@ -824,7 +824,7 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
  */
 struct usb_gadget_driver {
 	char			*function;
-	enum usb_device_speed	speed;
+	enum usb_device_speed	max_speed;
 	void			(*unbind)(struct usb_gadget *);
 	int			(*setup)(struct usb_gadget *,
 					const struct usb_ctrlrequest *);
-- 
1.7.3.1

