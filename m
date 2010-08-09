Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0HINc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:32:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56373 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0HINcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:32:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Mon, 09 Aug 2010 15:33:49 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/3] usb gadget: don't save bind callback in struct
 usb_composite_driver
In-reply-to: <3decda614c6d8732c018417558d74ed942e76c82.1281359651.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <e465429de034460cdc6eff4e3502d2be83264f82.1281359651.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <3decda614c6d8732c018417558d74ed942e76c82.1281359651.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bind function is most of the time only called at init time so there
is no need to save a pointer to it in the composite driver structure.

This fixes many section mismatches reported by modpost.

Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/audio.c        |    3 +--
 drivers/usb/gadget/cdc2.c         |    3 +--
 drivers/usb/gadget/composite.c    |   19 +++++++++++++------
 drivers/usb/gadget/ether.c        |    3 +--
 drivers/usb/gadget/g_ffs.c        |    3 +--
 drivers/usb/gadget/hid.c          |    3 +--
 drivers/usb/gadget/mass_storage.c |    3 +--
 drivers/usb/gadget/multi.c        |    3 +--
 drivers/usb/gadget/serial.c       |    3 +--
 drivers/usb/gadget/webcam.c       |    3 +--
 drivers/usb/gadget/zero.c         |    3 +--
 include/linux/usb/composite.h     |   15 +++------------
 12 files changed, 26 insertions(+), 38 deletions(-)

This replaces Uwe's patch which used __refdata for instances of struct
usb_composite_driver.  This patch replaces usb_composite_register() with
usb_composite_probe() in similar fashion to other two Uwe's patches.

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
index 4590c6a..3cafda7 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -39,6 +39,7 @@
 #define USB_BUFSIZ	1024
 
 static struct usb_composite_driver *composite;
+static int (*composite_gadget_bind)(struct usb_composite_dev *cdev);
 
 /* Some systems will need runtime overrides for the  product identifers
  * published in the device descriptor, either numbers or strings or both.
@@ -1094,15 +1095,15 @@ static int composite_bind(struct usb_gadget *gadget)
 	 * serial number), register function drivers, potentially update
 	 * power state and consumption, etc
 	 */
-	status = composite->bind(cdev);
+	status = composite_gadget_bind(cdev);
 	if (status < 0)
 		goto fail;
 
 	cdev->desc = *composite->dev;
 	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
 
-	/* strings can't be assigned before bind() allocates the
-	 * releavnt identifiers
+	/* strings can't be assigned before composite_gadget_bind()
+	 * allocates the releavnt identifiers
 	 */
 	if (cdev->desc.iManufacturer && iManufacturer)
 		string_override(composite->strings,
@@ -1191,8 +1192,12 @@ static struct usb_gadget_driver composite_driver = {
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
@@ -1205,9 +1210,10 @@ static struct usb_gadget_driver composite_driver = {
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
 
 	if (!driver->name)
@@ -1215,6 +1221,7 @@ int usb_composite_register(struct usb_composite_driver *driver)
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
index a9474f8..6ab2d74 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -171,7 +171,6 @@ static struct usb_composite_driver gfs_driver = {
 	.name		= gfs_short_name,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
-	.bind		= gfs_bind,
 	.unbind		= gfs_unbind,
 };
 
@@ -210,7 +209,7 @@ static int functionfs_ready_callback(struct ffs_data *ffs)
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
index 306098f..a992c78 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -231,7 +231,6 @@ static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
 	.dev		= &msg_device_desc,
 	.strings	= dev_strings,
-	.bind		= msg_bind,
 };
 
 MODULE_DESCRIPTION(DRIVER_DESC);
@@ -240,7 +239,7 @@ MODULE_LICENSE("GPL");
 
 static int __init msg_init(void)
 {
-	return usb_composite_register(&msg_driver);
+	return usb_composite_probe(&msg_driver, msg_bind);
 }
 module_init(msg_init);
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 795d762..384b3e1 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -368,14 +368,13 @@ static struct usb_composite_driver multi_driver = {
 	.name		= "g_multi",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.bind		= multi_bind,
 	.unbind		= __exit_p(multi_unbind),
 };
 
 
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
index 890bc14..ff37718 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -241,10 +241,6 @@ int usb_add_config(struct usb_composite_dev *,
  *	identifiers.
  * @strings: tables of strings, keyed by identifiers assigned during bind()
  *	and language IDs provided in control requests
- * @bind: (REQUIRED) Used to allocate resources that are shared across the
- *	whole device, such as string IDs, and add its configurations using
- *	@usb_add_config().  This may fail by returning a negative errno
- *	value; it should return zero on successful initialization.
  * @unbind: Reverses @bind(); called as a side effect of unregistering
  *	this driver.
  * @suspend: Notifies when the host stops sending USB traffic,
@@ -268,12 +264,6 @@ struct usb_composite_driver {
 	const struct usb_device_descriptor	*dev;
 	struct usb_gadget_strings		**strings;
 
-	/* REVISIT:  bind() functions can be marked __init, which
-	 * makes trouble for section mismatch analysis.  See if
-	 * we can't restructure things to avoid mismatching...
-	 */
-
-	int			(*bind)(struct usb_composite_dev *);
 	int			(*unbind)(struct usb_composite_dev *);
 
 	void			(*disconnect)(struct usb_composite_dev *);
@@ -283,8 +273,9 @@ struct usb_composite_driver {
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

