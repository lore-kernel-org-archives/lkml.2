Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab0HLPmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:42:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62137 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760282Ab0HLPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 12 Aug 2010 17:43:54 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 11/13] usb gadget: don't save bind callback in struct
 usb_composite_driver
In-reply-to: <340f780f91de1b3ca17d0c29d87963205d172f4e.1281625724.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-id: <cfb1102e8bd59822b76475d58f5e4f1ceadade50.1281625724.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
 <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
 <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
 <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
 <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com>
 <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com>
 <ad117de19af4733f113c8631e53556cc308dbf06.1281625724.git.m.nazarewicz@samsung.com>
 <340f780f91de1b3ca17d0c29d87963205d172f4e.1281625724.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bind function is most of the time only called at init time so there
is no need to save a pointer to it in the composite driver structure.

This fixes many section mismatches reported by modpost.

Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/usb/gadget/audio.c        |    3 +--
 drivers/usb/gadget/cdc2.c         |    3 +--
 drivers/usb/gadget/composite.c    |   15 +++++++++++----
 drivers/usb/gadget/ether.c        |    3 +--
 drivers/usb/gadget/g_ffs.c        |    3 +--
 drivers/usb/gadget/hid.c          |    3 +--
 drivers/usb/gadget/mass_storage.c |    3 +--
 drivers/usb/gadget/multi.c        |    3 +--
 drivers/usb/gadget/serial.c       |    3 +--
 drivers/usb/gadget/webcam.c       |    3 +--
 drivers/usb/gadget/zero.c         |    3 +--
 include/linux/usb/composite.h     |   19 +++++--------------
 12 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index a62af7b..5a65fbb 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -166,13 +166,12 @@ static struct usb_composite_driver audio_driver = {
 	.name		= "g_audio",
 	.dev		= &device_desc,
 	.strings	= audio_strings,
-	.bind		= audio_bind,
 	.unbind		= __exit_p(audio_unbind),
 };
 
 static int __init init(void)
 {
-	return usb_composite_register(&audio_driver);
+	return usb_composite_probe(&audio_driver, audio_bind);
 }
 module_init(init);
 
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 928137d..1f2a9b1 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -245,7 +245,6 @@ static struct usb_composite_driver cdc_driver = {
 	.name		= "g_cdc",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= cdc_bind,
 	.unbind		= __exit_p(cdc_unbind),
 };
 
@@ -255,7 +254,7 @@ MODULE_LICENSE("GPL");
 
 static int __init init(void)
 {
-	return usb_composite_register(&cdc_driver);
+	return usb_composite_probe(&cdc_driver, cdc_bind);
 }
 module_init(init);
 
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 0d3f4b7..6f3b5fb 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -40,6 +40,7 @@
 #define USB_BUFSIZ	1024
 
 static struct usb_composite_driver *composite;
+static int (*composite_gadget_bind)(struct usb_composite_dev *cdev);
 
 /* Some systems will need runtime overrides for the  product identifers
  * published in the device descriptor, either numbers or strings or both.
@@ -1109,7 +1110,7 @@ static int composite_bind(struct usb_gadget *gadget)
 	 * serial number), register function drivers, potentially update
 	 * power state and consumption, etc
 	 */
-	status = composite->bind(cdev);
+	status = composite_gadget_bind(cdev);
 	if (status < 0)
 		goto fail;
 
@@ -1221,8 +1222,12 @@ static struct usb_gadget_driver composite_driver = {
 };
 
 /**
- * usb_composite_register() - register a composite driver
+ * usb_composite_probe() - register a composite driver
  * @driver: the driver to register
+ * @bind: the callback used to allocate resources that are shared across the
+ *	whole device, such as string IDs, and add its configurations using
+ *	@usb_add_config().  This may fail by returning a negative errno
+ *	value; it should return zero on successful initialization.
  * Context: single threaded during gadget setup
  *
  * This function is used to register drivers using the composite driver
@@ -1235,9 +1240,10 @@ static struct usb_gadget_driver composite_driver = {
  * while it was binding.  That would usually be done in order to wait for
  * some userspace participation.
  */
-int usb_composite_register(struct usb_composite_driver *driver)
+extern int usb_composite_probe(struct usb_composite_driver *driver,
+			       int (*bind)(struct usb_composite_dev *cdev))
 {
-	if (!driver || !driver->dev || !driver->bind || composite)
+	if (!driver || !driver->dev || !bind || composite)
 		return -EINVAL;
 
 	if (!driver->iProduct)
@@ -1247,6 +1253,7 @@ int usb_composite_register(struct usb_composite_driver *driver)
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
 	composite = driver;
+	composite_gadget_bind = bind;
 
 	return usb_gadget_probe_driver(&composite_driver, composite_bind);
 }
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 400f803..33076bc 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -402,7 +402,6 @@ static struct usb_composite_driver eth_driver = {
 	.name		= "g_ether",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= eth_bind,
 	.unbind		= __exit_p(eth_unbind),
 };
 
@@ -412,7 +411,7 @@ MODULE_LICENSE("GPL");
 
 static int __init init(void)
 {
-	return usb_composite_register(&eth_driver);
+	return usb_composite_probe(&eth_driver, eth_bind);
 }
 module_init(init);
 
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 52fd3fa..9fcb158 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -147,7 +147,6 @@ static struct usb_composite_driver gfs_driver = {
 	.name		= DRIVER_NAME,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
-	.bind		= gfs_bind,
 	.unbind		= gfs_unbind,
 	.iProduct	= DRIVER_DESC,
 };
@@ -187,7 +186,7 @@ static int functionfs_ready_callback(struct ffs_data *ffs)
 		return -EBUSY;
 
 	gfs_ffs_data = ffs;
-	ret = usb_composite_register(&gfs_driver);
+	ret = usb_composite_probe(&gfs_driver, gfs_bind);
 	if (unlikely(ret < 0))
 		clear_bit(0, &gfs_registered);
 	return ret;
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 7757226..77f4952 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -256,7 +256,6 @@ static struct usb_composite_driver hidg_driver = {
 	.name		= "g_hid",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= hid_bind,
 	.unbind		= __exit_p(hid_unbind),
 };
 
@@ -282,7 +281,7 @@ static int __init hidg_init(void)
 	if (status < 0)
 		return status;
 
-	status = usb_composite_register(&hidg_driver);
+	status = usb_composite_probe(&hidg_driver, hid_bind);
 	if (status < 0)
 		platform_driver_unregister(&hidg_plat_driver);
 
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 05e9bd3..a5e4a77 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -169,7 +169,6 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
 	.dev		= &msg_device_desc,
-	.bind		= msg_bind,
 	.iProduct	= DRIVER_DESC,
 	.needs_serial	= 1,
 };
@@ -180,7 +179,7 @@ MODULE_LICENSE("GPL");
 
 static int __init msg_init(void)
 {
-	return usb_composite_register(&msg_driver);
+	return usb_composite_probe(&msg_driver, msg_bind);
 }
 module_init(msg_init);
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index ca51661..91170a0 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -353,7 +353,6 @@ static struct usb_composite_driver multi_driver = {
 	.name		= "g_multi",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= multi_bind,
 	.unbind		= __exit_p(multi_unbind),
 	.iProduct	= DRIVER_DESC,
 	.needs_serial	= 1,
@@ -362,7 +361,7 @@ static struct usb_composite_driver multi_driver = {
 
 static int __init multi_init(void)
 {
-	return usb_composite_register(&multi_driver);
+	return usb_composite_probe(&multi_driver, multi_bind);
 }
 module_init(multi_init);
 
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index f46a609..0b81d7b 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -242,7 +242,6 @@ static struct usb_composite_driver gserial_driver = {
 	.name		= "g_serial",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= gs_bind,
 };
 
 static int __init init(void)
@@ -271,7 +270,7 @@ static int __init init(void)
 	}
 	strings_dev[STRING_DESCRIPTION_IDX].s = serial_config_driver.label;
 
-	return usb_composite_register(&gserial_driver);
+	return usb_composite_probe(&gserial_driver, gs_bind);
 }
 module_init(init);
 
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index 288d211..de65b80 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -373,14 +373,13 @@ static struct usb_composite_driver webcam_driver = {
 	.name		= "g_webcam",
 	.dev		= &webcam_device_descriptor,
 	.strings	= webcam_device_strings,
-	.bind		= webcam_bind,
 	.unbind		= webcam_unbind,
 };
 
 static int __init
 webcam_init(void)
 {
-	return usb_composite_register(&webcam_driver);
+	return usb_composite_probe(&webcam_driver, webcam_bind);
 }
 
 static void __exit
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 807280d..6d16db9 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -340,7 +340,6 @@ static struct usb_composite_driver zero_driver = {
 	.name		= "zero",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= zero_bind,
 	.unbind		= zero_unbind,
 	.suspend	= zero_suspend,
 	.resume		= zero_resume,
@@ -351,7 +350,7 @@ MODULE_LICENSE("GPL");
 
 static int __init init(void)
 {
-	return usb_composite_register(&zero_driver);
+	return usb_composite_probe(&zero_driver, zero_bind);
 }
 module_init(init);
 
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index d590904..101e788 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -248,11 +248,7 @@ int usb_add_config(struct usb_composite_dev *,
  *	and language IDs provided in control requests
  * @needs_serial: set to 1 if the gadget needs userspace to provide
  * 	a serial number.  If one is not provided, warning will be printed.
- * @bind: (REQUIRED) Used to allocate resources that are shared across the
- *	whole device, such as string IDs, and add its configurations using
- *	@usb_add_config().  This may fail by returning a negative errno
- *	value; it should return zero on successful initialization.
- * @unbind: Reverses @bind(); called as a side effect of unregistering
+ * @unbind: Reverses bind; called as a side effect of unregistering
  *	this driver.
  * @suspend: Notifies when the host stops sending USB traffic,
  *	after function notifications
@@ -262,7 +258,7 @@ int usb_add_config(struct usb_composite_dev *,
  * Devices default to reporting self powered operation.  Devices which rely
  * on bus powered operation should report this in their @bind() method.
  *
- * Before returning from @bind, various fields in the template descriptor
+ * Before returning from bind, various fields in the template descriptor
  * may be overridden.  These include the idVendor/idProduct/bcdDevice values
  * normally to bind the appropriate host side driver, and the three strings
  * (iManufacturer, iProduct, iSerialNumber) normally used to provide user
@@ -278,12 +274,6 @@ struct usb_composite_driver {
 	struct usb_gadget_strings		**strings;
 	unsigned		needs_serial:1;
 
-	/* REVISIT:  bind() functions can be marked __init, which
-	 * makes trouble for section mismatch analysis.  See if
-	 * we can't restructure things to avoid mismatching...
-	 */
-
-	int			(*bind)(struct usb_composite_dev *);
 	int			(*unbind)(struct usb_composite_dev *);
 
 	void			(*disconnect)(struct usb_composite_dev *);
@@ -293,8 +283,9 @@ struct usb_composite_driver {
 	void			(*resume)(struct usb_composite_dev *);
 };
 
-extern int usb_composite_register(struct usb_composite_driver *);
-extern void usb_composite_unregister(struct usb_composite_driver *);
+extern int usb_composite_probe(struct usb_composite_driver *driver,
+			       int (*bind)(struct usb_composite_dev *cdev));
+extern void usb_composite_unregister(struct usb_composite_driver *driver);
 
 
 /**
-- 
1.7.1

