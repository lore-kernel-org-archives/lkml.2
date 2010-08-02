Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0HBS2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:28:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49448 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0HBS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:28:07 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Nazarewicz?= <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] usb gadget: don't save bind callback in struct usb_gadget_driver
Date: Mon,  2 Aug 2010 20:27:45 +0200
Message-Id: <1280773666-5405-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100802182521.GA4151@pengutronix.de>
References: <20100802182521.GA4151@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To accomplish this the function to register a gadget driver takes the bind
function as a second argument.  To make things clearer rename the function
to resemble platform_driver_probe.

This fixes many section mismatches like

	WARNING: drivers/usb/gadget/g_printer.o(.data+0xc): Section mismatch in
	reference from the variable printer_driver to the function
	.init.text:printer_bind()
	The variable printer_driver references
	the function __init printer_bind()

All callers are fixed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Michał Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/amd5536udc.c     |    9 +++++----
 drivers/usb/gadget/at91_udc.c       |   11 ++++++-----
 drivers/usb/gadget/atmel_usba_udc.c |    7 ++++---
 drivers/usb/gadget/ci13xxx_udc.c    |   18 ++++++++++--------
 drivers/usb/gadget/composite.c      |    3 +--
 drivers/usb/gadget/dummy_hcd.c      |   10 +++++-----
 drivers/usb/gadget/file_storage.c   |    3 +--
 drivers/usb/gadget/fsl_qe_udc.c     |   12 ++++++------
 drivers/usb/gadget/fsl_udc_core.c   |   10 +++++-----
 drivers/usb/gadget/gmidi.c          |    3 +--
 drivers/usb/gadget/goku_udc.c       |    9 +++++----
 drivers/usb/gadget/imx_udc.c        |    9 +++++----
 drivers/usb/gadget/inode.c          |    6 ++----
 drivers/usb/gadget/langwell_udc.c   |    9 +++++----
 drivers/usb/gadget/lh7a40x_udc.c    |   10 +++++-----
 drivers/usb/gadget/m66592-udc.c     |    9 +++++----
 drivers/usb/gadget/net2280.c        |   10 +++++-----
 drivers/usb/gadget/omap_udc.c       |   10 +++++-----
 drivers/usb/gadget/printer.c        |    5 ++---
 drivers/usb/gadget/pxa25x_udc.c     |    9 +++++----
 drivers/usb/gadget/pxa27x_udc.c     |   12 +++++++-----
 drivers/usb/gadget/r8a66597-udc.c   |    9 +++++----
 drivers/usb/gadget/s3c-hsotg.c      |    9 +++++----
 drivers/usb/gadget/s3c2410_udc.c    |   17 ++++++++---------
 drivers/usb/musb/musb_gadget.c      |    9 +++++----
 include/linux/usb/gadget.h          |   20 ++++++++------------
 26 files changed, 126 insertions(+), 122 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 731150d..fadebfd 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1954,13 +1954,14 @@ static int setup_ep0(struct udc *dev)
 }
 
 /* Called by gadget driver to register itself */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct udc		*dev = udc;
 	int			retval;
 	u32 tmp;
 
-	if (!driver || !driver->bind || !driver->setup
+	if (!driver || !bind || !driver->setup
 			|| driver->speed != USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
@@ -1972,7 +1973,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	dev->driver = driver;
 	dev->gadget.dev.driver = &driver->driver;
 
-	retval = driver->bind(&dev->gadget);
+	retval = bind(&dev->gadget);
 
 	/* Some gadget drivers use both ep0 directions.
 	 * NOTE: to gadget driver, ep0 is just one endpoint...
@@ -2000,7 +2001,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	return 0;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 /* shutdown requests and disconnect from gadget */
 static void
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index eaa79c8..e0f2911 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1570,14 +1570,15 @@ static irqreturn_t at91_vbus_irq(int irq, void *_udc)
 	return IRQ_HANDLED;
 }
 
-int usb_gadget_register_driver (struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct at91_udc	*udc = &controller;
 	int		retval;
 
 	if (!driver
 			|| driver->speed < USB_SPEED_FULL
-			|| !driver->bind
+			|| !bind
 			|| !driver->setup) {
 		DBG("bad parameter.\n");
 		return -EINVAL;
@@ -1594,9 +1595,9 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	udc->enabled = 1;
 	udc->selfpowered = 1;
 
-	retval = driver->bind(&udc->gadget);
+	retval = bind(&udc->gadget);
 	if (retval) {
-		DBG("driver->bind() returned %d\n", retval);
+		DBG("bind() returned %d\n", retval);
 		udc->driver = NULL;
 		udc->gadget.dev.driver = NULL;
 		dev_set_drvdata(&udc->gadget.dev, NULL);
@@ -1612,7 +1613,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	DBG("bound to %s\n", driver->driver.name);
 	return 0;
 }
-EXPORT_SYMBOL (usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index d623c7b..e4810c6 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1789,7 +1789,8 @@ out:
 	return IRQ_HANDLED;
 }
 
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct usba_udc *udc = &the_udc;
 	unsigned long flags;
@@ -1812,7 +1813,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	clk_enable(udc->pclk);
 	clk_enable(udc->hclk);
 
-	ret = driver->bind(&udc->gadget);
+	ret = bind(&udc->gadget);
 	if (ret) {
 		DBG(DBG_ERR, "Could not bind to driver %s: error %d\n",
 			driver->driver.name, ret);
@@ -1841,7 +1842,7 @@ err_driver_bind:
 	udc->gadget.dev.driver = NULL;
 	return ret;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 6996951..98b36fc 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -2340,12 +2340,15 @@ static const struct usb_ep_ops usb_ep_ops = {
 static const struct usb_gadget_ops usb_gadget_ops;
 
 /**
- * usb_gadget_register_driver: register a gadget driver
+ * usb_gadget_probe_driver: register a gadget driver
+ * @driver: the driver being registered
+ * @bind: the driver's bind callback
  *
- * Check usb_gadget_register_driver() at "usb_gadget.h" for details
- * Interrupts are enabled here
+ * Check usb_gadget_probe_driver() at <linux/usb/gadget.h> for details.
+ * Interrupts are enabled here.
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct ci13xxx *udc = _udc;
 	unsigned long i, k, flags;
@@ -2354,7 +2357,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	trace("%p", driver);
 
 	if (driver             == NULL ||
-	    driver->bind       == NULL ||
+	    bind               == NULL ||
 	    driver->unbind     == NULL ||
 	    driver->setup      == NULL ||
 	    driver->disconnect == NULL ||
@@ -2430,7 +2433,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	udc->gadget.dev.driver = &driver->driver;
 
 	spin_unlock_irqrestore(udc->lock, flags);
-	retval = driver->bind(&udc->gadget);                /* MAY SLEEP */
+	retval = bind(&udc->gadget);                /* MAY SLEEP */
 	spin_lock_irqsave(udc->lock, flags);
 
 	if (retval) {
@@ -2447,7 +2450,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		usb_gadget_unregister_driver(driver);
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 /**
  * usb_gadget_unregister_driver: unregister a gadget driver
@@ -2462,7 +2465,6 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 	trace("%p", driver);
 
 	if (driver             == NULL ||
-	    driver->bind       == NULL ||
 	    driver->unbind     == NULL ||
 	    driver->setup      == NULL ||
 	    driver->disconnect == NULL ||
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 391d169..d07960e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1112,7 +1112,6 @@ composite_resume(struct usb_gadget *gadget)
 static struct usb_gadget_driver composite_driver = {
 	.speed		= USB_SPEED_HIGH,
 
-	.bind		= composite_bind,
 	.unbind		= composite_unbind,
 
 	.setup		= composite_setup,
@@ -1152,7 +1151,7 @@ int usb_composite_register(struct usb_composite_driver *driver)
 	composite_driver.driver.name = driver->name;
 	composite = driver;
 
-	return usb_gadget_register_driver(&composite_driver);
+	return usb_gadget_probe_driver(&composite_driver, composite_bind);
 }
 
 /**
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 4f9e578..5860222 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -748,7 +748,8 @@ static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
  */
 
 int
-usb_gadget_register_driver (struct usb_gadget_driver *driver)
+usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct dummy	*dum = the_controller;
 	int		retval, i;
@@ -757,8 +758,7 @@ usb_gadget_register_driver (struct usb_gadget_driver *driver)
 		return -EINVAL;
 	if (dum->driver)
 		return -EBUSY;
-	if (!driver->bind || !driver->setup
-			|| driver->speed == USB_SPEED_UNKNOWN)
+	if (!bind || !driver->setup || driver->speed == USB_SPEED_UNKNOWN)
 		return -EINVAL;
 
 	/*
@@ -796,7 +796,7 @@ usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	dum->gadget.dev.driver = &driver->driver;
 	dev_dbg (udc_dev(dum), "binding gadget driver '%s'\n",
 			driver->driver.name);
-	retval = driver->bind(&dum->gadget);
+	retval = bind(&dum->gadget);
 	if (retval) {
 		dum->driver = NULL;
 		dum->gadget.dev.driver = NULL;
@@ -812,7 +812,7 @@ usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	usb_hcd_poll_rh_status (dummy_to_hcd (dum));
 	return 0;
 }
-EXPORT_SYMBOL (usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int
 usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b49d86e..7c858ca 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3541,7 +3541,6 @@ static struct usb_gadget_driver		fsg_driver = {
 	.speed		= USB_SPEED_FULL,
 #endif
 	.function	= (char *) fsg_string_product,
-	.bind		= fsg_bind,
 	.unbind		= fsg_unbind,
 	.disconnect	= fsg_disconnect,
 	.setup		= fsg_setup,
@@ -3583,7 +3582,7 @@ static int __init fsg_init(void)
 	if ((rc = fsg_alloc()) != 0)
 		return rc;
 	fsg = the_fsg;
-	if ((rc = usb_gadget_register_driver(&fsg_driver)) != 0)
+	if ((rc = usb_gadget_probe_driver(&fsg_driver, fsg_bind)) != 0)
 		kref_put(&fsg->ref, fsg_release);
 	return rc;
 }
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 82506ca..9b4f4b5 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2301,9 +2301,10 @@ static irqreturn_t qe_udc_irq(int irq, void *_udc)
 }
 
 /*-------------------------------------------------------------------------
-	Gadget driver register and unregister.
+	Gadget driver probe and unregister.
  --------------------------------------------------------------------------*/
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	int retval;
 	unsigned long flags = 0;
@@ -2314,8 +2315,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	if (!driver || (driver->speed != USB_SPEED_FULL
 			&& driver->speed != USB_SPEED_HIGH)
-			|| !driver->bind || !driver->disconnect
-			|| !driver->setup)
+			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
 	if (udc_controller->driver)
@@ -2331,7 +2331,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	udc_controller->gadget.speed = (enum usb_device_speed)(driver->speed);
 	spin_unlock_irqrestore(&udc_controller->lock, flags);
 
-	retval = driver->bind(&udc_controller->gadget);
+	retval = bind(&udc_controller->gadget);
 	if (retval) {
 		dev_err(udc_controller->dev, "bind to %s --> %d",
 				driver->driver.name, retval);
@@ -2352,7 +2352,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		udc_controller->gadget.name, driver->driver.name);
 	return 0;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 08a9a62..c16b402 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1765,7 +1765,8 @@ static irqreturn_t fsl_udc_irq(int irq, void *_udc)
  * Hook to gadget drivers
  * Called by initialization code of gadget drivers
 *----------------------------------------------------------------*/
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	int retval = -ENODEV;
 	unsigned long flags = 0;
@@ -1775,8 +1776,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	if (!driver || (driver->speed != USB_SPEED_FULL
 				&& driver->speed != USB_SPEED_HIGH)
-			|| !driver->bind || !driver->disconnect
-			|| !driver->setup)
+			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
 	if (udc_controller->driver)
@@ -1792,7 +1792,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	spin_unlock_irqrestore(&udc_controller->lock, flags);
 
 	/* bind udc driver to gadget driver */
-	retval = driver->bind(&udc_controller->gadget);
+	retval = bind(&udc_controller->gadget);
 	if (retval) {
 		VDBG("bind to %s --> %d", driver->driver.name, retval);
 		udc_controller->gadget.dev.driver = NULL;
@@ -1814,7 +1814,7 @@ out:
 		       retval);
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 /* Disconnect from gadget driver */
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 2b56ce6..b33ee5d 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -1292,7 +1292,6 @@ static void gmidi_resume(struct usb_gadget *gadget)
 static struct usb_gadget_driver gmidi_driver = {
 	.speed		= USB_SPEED_FULL,
 	.function	= (char *)longname,
-	.bind		= gmidi_bind,
 	.unbind		= gmidi_unbind,
 
 	.setup		= gmidi_setup,
@@ -1309,7 +1308,7 @@ static struct usb_gadget_driver gmidi_driver = {
 
 static int __init gmidi_init(void)
 {
-	return usb_gadget_register_driver(&gmidi_driver);
+	return usb_gadget_probe_driver(&gmidi_driver, gmidi_bind);
 }
 module_init(gmidi_init);
 
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 1088d08..49fbd4d 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1343,14 +1343,15 @@ static struct goku_udc	*the_controller;
  * disconnect is reported.  then a host may connect again, or
  * the driver might get unbound.
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct goku_udc	*dev = the_controller;
 	int			retval;
 
 	if (!driver
 			|| driver->speed < USB_SPEED_FULL
-			|| !driver->bind
+			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
 		return -EINVAL;
@@ -1363,7 +1364,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	driver->driver.bus = NULL;
 	dev->driver = driver;
 	dev->gadget.dev.driver = &driver->driver;
-	retval = driver->bind(&dev->gadget);
+	retval = bind(&dev->gadget);
 	if (retval) {
 		DBG(dev, "bind to driver %s --> error %d\n",
 				driver->driver.name, retval);
@@ -1380,7 +1381,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	DBG(dev, "registered gadget driver '%s'\n", driver->driver.name);
 	return 0;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 static void
 stop_activity(struct goku_udc *dev, struct usb_gadget_driver *driver)
diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index e743122..ed02664 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -1319,14 +1319,15 @@ static struct imx_udc_struct controller = {
  * USB gadged driver functions
  *******************************************************************************
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct imx_udc_struct *imx_usb = &controller;
 	int retval;
 
 	if (!driver
 		|| driver->speed < USB_SPEED_FULL
-		|| !driver->bind
+		|| !bind
 		|| !driver->disconnect
 		|| !driver->setup)
 			return -EINVAL;
@@ -1342,7 +1343,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	retval = device_add(&imx_usb->gadget.dev);
 	if (retval)
 		goto fail;
-	retval = driver->bind(&imx_usb->gadget);
+	retval = bind(&imx_usb->gadget);
 	if (retval) {
 		D_ERR(imx_usb->dev, "<%s> bind to driver %s --> error %d\n",
 			__func__, driver->driver.name, retval);
@@ -1362,7 +1363,7 @@ fail:
 	imx_usb->gadget.dev.driver = NULL;
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index de8a838..1da5583 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1777,7 +1777,6 @@ static struct usb_gadget_driver gadgetfs_driver = {
 	.speed		= USB_SPEED_FULL,
 #endif
 	.function	= (char *) driver_desc,
-	.bind		= gadgetfs_bind,
 	.unbind		= gadgetfs_unbind,
 	.setup		= gadgetfs_setup,
 	.disconnect	= gadgetfs_disconnect,
@@ -1800,7 +1799,6 @@ static int gadgetfs_probe (struct usb_gadget *gadget)
 
 static struct usb_gadget_driver probe_driver = {
 	.speed		= USB_SPEED_HIGH,
-	.bind		= gadgetfs_probe,
 	.unbind		= gadgetfs_nop,
 	.setup		= (void *)gadgetfs_nop,
 	.disconnect	= gadgetfs_nop,
@@ -1914,7 +1912,7 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	/* triggers gadgetfs_bind(); then we can enumerate. */
 	spin_unlock_irq (&dev->lock);
-	value = usb_gadget_register_driver (&gadgetfs_driver);
+	value = usb_gadget_probe_driver(&gadgetfs_driver, gadgetfs_bind);
 	if (value != 0) {
 		kfree (dev->buf);
 		dev->buf = NULL;
@@ -2053,7 +2051,7 @@ gadgetfs_fill_super (struct super_block *sb, void *opts, int silent)
 		return -ESRCH;
 
 	/* fake probe to determine $CHIP */
-	(void) usb_gadget_register_driver (&probe_driver);
+	(void) usb_gadget_probe_driver(&probe_driver, gadgetfs_probe);
 	if (!CHIP)
 		return -ENODEV;
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a391351..e7222de 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -1807,7 +1807,8 @@ static DEVICE_ATTR(langwell_udc, S_IRUGO, show_langwell_udc, NULL);
  * the driver might get unbound.
  */
 
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct langwell_udc	*dev = the_controller;
 	unsigned long		flags;
@@ -1830,7 +1831,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	retval = driver->bind(&dev->gadget);
+	retval = bind(&dev->gadget);
 	if (retval) {
 		DBG(dev, "bind to driver %s --> %d\n",
 				driver->driver.name, retval);
@@ -1868,7 +1869,7 @@ err_unbind:
 	DBG(dev, "<--- %s()\n", __func__);
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 
 /* unregister gadget driver */
@@ -1882,7 +1883,7 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 
 	DBG(dev, "---> %s()\n", __func__);
 
-	if (unlikely(!driver || !driver->bind || !driver->unbind))
+	if (unlikely(!driver || !driver->unbind))
 		return -EINVAL;
 
 	/* unbind OTG transceiver */
diff --git a/drivers/usb/gadget/lh7a40x_udc.c b/drivers/usb/gadget/lh7a40x_udc.c
index fded3fc..6b58bd8 100644
--- a/drivers/usb/gadget/lh7a40x_udc.c
+++ b/drivers/usb/gadget/lh7a40x_udc.c
@@ -408,7 +408,8 @@ static void udc_enable(struct lh7a40x_udc *dev)
 /*
   Register entry point for the peripheral controller driver.
 */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct lh7a40x_udc *dev = the_controller;
 	int retval;
@@ -417,7 +418,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	if (!driver
 			|| driver->speed != USB_SPEED_FULL
-			|| !driver->bind
+			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
 		return -EINVAL;
@@ -431,7 +432,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	dev->gadget.dev.driver = &driver->driver;
 
 	device_add(&dev->gadget.dev);
-	retval = driver->bind(&dev->gadget);
+	retval = bind(&dev->gadget);
 	if (retval) {
 		printk(KERN_WARNING "%s: bind to driver %s --> error %d\n",
 		       dev->gadget.name, driver->driver.name, retval);
@@ -453,8 +454,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	return 0;
 }
-
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 /*
   Unregister entry point for the peripheral controller driver.
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 166bf71..2ce1f49 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1454,14 +1454,15 @@ static struct usb_ep_ops m66592_ep_ops = {
 /*-------------------------------------------------------------------------*/
 static struct m66592 *the_controller;
 
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct m66592 *m66592 = the_controller;
 	int retval;
 
 	if (!driver
 			|| driver->speed != USB_SPEED_HIGH
-			|| !driver->bind
+			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
 	if (!m66592)
@@ -1480,7 +1481,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		goto error;
 	}
 
-	retval = driver->bind (&m66592->gadget);
+	retval = bind(&m66592->gadget);
 	if (retval) {
 		pr_err("bind to driver error (%d)\n", retval);
 		device_del(&m66592->gadget.dev);
@@ -1505,7 +1506,7 @@ error:
 
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 9498be8..d09155b 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1929,7 +1929,8 @@ static void ep0_start (struct net2280 *dev)
  * disconnect is reported.  then a host may connect again, or
  * the driver might get unbound.
  */
-int usb_gadget_register_driver (struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct net2280		*dev = the_controller;
 	int			retval;
@@ -1941,8 +1942,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	 */
 	if (!driver
 			|| driver->speed != USB_SPEED_HIGH
-			|| !driver->bind
-			|| !driver->setup)
+			|| !bind || !driver->setup)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
@@ -1957,7 +1957,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	driver->driver.bus = NULL;
 	dev->driver = driver;
 	dev->gadget.dev.driver = &driver->driver;
-	retval = driver->bind (&dev->gadget);
+	retval = bind(&dev->gadget);
 	if (retval) {
 		DEBUG (dev, "bind to driver %s --> %d\n",
 				driver->driver.name, retval);
@@ -1993,7 +1993,7 @@ err_unbind:
 	dev->driver = NULL;
 	return retval;
 }
-EXPORT_SYMBOL (usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 static void
 stop_activity (struct net2280 *dev, struct usb_gadget_driver *driver)
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index f81e4f0..61d3ca6 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2102,7 +2102,8 @@ static inline int machine_without_vbus_sense(void)
 		);
 }
 
-int usb_gadget_register_driver (struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	int		status = -ENODEV;
 	struct omap_ep	*ep;
@@ -2114,8 +2115,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	if (!driver
 			// FIXME if otg, check:  driver->is_otg
 			|| driver->speed < USB_SPEED_FULL
-			|| !driver->bind
-			|| !driver->setup)
+			|| !bind || !driver->setup)
 		return -EINVAL;
 
 	spin_lock_irqsave(&udc->lock, flags);
@@ -2145,7 +2145,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 	if (udc->dc_clk != NULL)
 		omap_udc_enable_clock(1);
 
-	status = driver->bind (&udc->gadget);
+	status = bind(&udc->gadget);
 	if (status) {
 		DBG("bind to %s --> %d\n", driver->driver.name, status);
 		udc->gadget.dev.driver = NULL;
@@ -2186,7 +2186,7 @@ done:
 		omap_udc_enable_clock(0);
 	return status;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 4c3ac5c..317f113 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1542,7 +1542,6 @@ static struct usb_gadget_driver printer_driver = {
 	.speed		= DEVSPEED,
 
 	.function	= (char *) driver_desc,
-	.bind		= printer_bind,
 	.unbind		= printer_unbind,
 
 	.setup		= printer_setup,
@@ -1578,11 +1577,11 @@ init(void)
 		return status;
 	}
 
-	status = usb_gadget_register_driver(&printer_driver);
+	status = usb_gadget_probe_driver(&printer_driver, printer_bind);
 	if (status) {
 		class_destroy(usb_gadget_class);
 		unregister_chrdev_region(g_printer_devno, 1);
-		DBG(dev, "usb_gadget_register_driver %x\n", status);
+		DBG(dev, "usb_gadget_probe_driver %x\n", status);
 	}
 
 	return status;
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index be5fb34..b37f92c 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1280,14 +1280,15 @@ static void udc_enable (struct pxa25x_udc *dev)
  * disconnect is reported.  then a host may connect again, or
  * the driver might get unbound.
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct pxa25x_udc	*dev = the_controller;
 	int			retval;
 
 	if (!driver
 			|| driver->speed < USB_SPEED_FULL
-			|| !driver->bind
+			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
 		return -EINVAL;
@@ -1308,7 +1309,7 @@ fail:
 		dev->gadget.dev.driver = NULL;
 		return retval;
 	}
-	retval = driver->bind(&dev->gadget);
+	retval = bind(&dev->gadget);
 	if (retval) {
 		DMSG("bind to driver %s --> error %d\n",
 				driver->driver.name, retval);
@@ -1338,7 +1339,7 @@ fail:
 bind_fail:
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 static void
 stop_activity(struct pxa25x_udc *dev, struct usb_gadget_driver *driver)
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 85b0d89..798d280 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1792,8 +1792,9 @@ static void udc_enable(struct pxa_udc *udc)
 }
 
 /**
- * usb_gadget_register_driver - Register gadget driver
+ * usb_gadget_probe_driver - Register gadget driver
  * @driver: gadget driver
+ * @bind: bind function
  *
  * When a driver is successfully registered, it will receive control requests
  * including set_configuration(), which enables non-control requests.  Then
@@ -1805,12 +1806,13 @@ static void udc_enable(struct pxa_udc *udc)
  *
  * Returns 0 if no error, -EINVAL, -ENODEV, -EBUSY otherwise
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct pxa_udc *udc = the_controller;
 	int retval;
 
-	if (!driver || driver->speed < USB_SPEED_FULL || !driver->bind
+	if (!driver || driver->speed < USB_SPEED_FULL || !bind
 			|| !driver->disconnect || !driver->setup)
 		return -EINVAL;
 	if (!udc)
@@ -1828,7 +1830,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		dev_err(udc->dev, "device_add error %d\n", retval);
 		goto add_fail;
 	}
-	retval = driver->bind(&udc->gadget);
+	retval = bind(&udc->gadget);
 	if (retval) {
 		dev_err(udc->dev, "bind to driver %s --> error %d\n",
 			driver->driver.name, retval);
@@ -1859,7 +1861,7 @@ add_fail:
 	udc->gadget.dev.driver = NULL;
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 
 /**
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 70a8178..5545d41 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1405,14 +1405,15 @@ static struct usb_ep_ops r8a66597_ep_ops = {
 /*-------------------------------------------------------------------------*/
 static struct r8a66597 *the_controller;
 
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct r8a66597 *r8a66597 = the_controller;
 	int retval;
 
 	if (!driver
 			|| driver->speed != USB_SPEED_HIGH
-			|| !driver->bind
+			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
 	if (!r8a66597)
@@ -1431,7 +1432,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		goto error;
 	}
 
-	retval = driver->bind(&r8a66597->gadget);
+	retval = bind(&r8a66597->gadget);
 	if (retval) {
 		printk(KERN_ERR "bind to driver error (%d)\n", retval);
 		device_del(&r8a66597->gadget.dev);
@@ -1456,7 +1457,7 @@ error:
 
 	return retval;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 26193ec..89f04bc 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2478,7 +2478,8 @@ static int s3c_hsotg_corereset(struct s3c_hsotg *hsotg)
 	return 0;
 }
 
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct s3c_hsotg *hsotg = our_hsotg;
 	int ret;
@@ -2498,7 +2499,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		dev_err(hsotg->dev, "%s: bad speed\n", __func__);
 	}
 
-	if (!driver->bind || !driver->setup) {
+	if (!bind || !driver->setup) {
 		dev_err(hsotg->dev, "%s: missing entry points\n", __func__);
 		return -EINVAL;
 	}
@@ -2517,7 +2518,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		goto err;
 	}
 
-	ret = driver->bind(&hsotg->gadget);
+	ret = bind(&hsotg->gadget);
 	if (ret) {
 		dev_err(hsotg->dev, "failed bind %s\n", driver->driver.name);
 
@@ -2641,7 +2642,7 @@ err:
 	hsotg->gadget.dev.driver = NULL;
 	return ret;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index e724a05..8ddaf02 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1628,15 +1628,15 @@ static void s3c2410_udc_enable(struct s3c2410_udc *dev)
 }
 
 /*
- *	usb_gadget_register_driver
+ *	usb_gadget_probe_driver
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	struct s3c2410_udc *udc = the_controller;
 	int		retval;
 
-	dprintk(DEBUG_NORMAL, "usb_gadget_register_driver() '%s'\n",
-		driver->driver.name);
+	dprintk(DEBUG_NORMAL, "%s() '%s'\n", __func__, driver->driver.name);
 
 	/* Sanity checks */
 	if (!udc)
@@ -1645,10 +1645,9 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	if (udc->driver)
 		return -EBUSY;
 
-	if (!driver->bind || !driver->setup
-			|| driver->speed < USB_SPEED_FULL) {
+	if (!bind || !driver->setup || driver->speed < USB_SPEED_FULL) {
 		printk(KERN_ERR "Invalid driver: bind %p setup %p speed %d\n",
-			driver->bind, driver->setup, driver->speed);
+			bind, driver->setup, driver->speed);
 		return -EINVAL;
 	}
 #if defined(MODULE)
@@ -1671,7 +1670,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	dprintk(DEBUG_NORMAL, "binding gadget driver '%s'\n",
 		driver->driver.name);
 
-	if ((retval = driver->bind (&udc->gadget)) != 0) {
+	if ((retval = bind(&udc->gadget)) != 0) {
 		device_del(&udc->gadget.dev);
 		goto register_error;
 	}
@@ -1686,6 +1685,7 @@ register_error:
 	udc->gadget.dev.driver = NULL;
 	return retval;
 }
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 /*
  *	usb_gadget_unregister_driver
@@ -2045,7 +2045,6 @@ static void __exit udc_exit(void)
 }
 
 EXPORT_SYMBOL(usb_gadget_unregister_driver);
-EXPORT_SYMBOL(usb_gadget_register_driver);
 
 module_init(udc_init);
 module_exit(udc_exit);
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 6fca870..d940e80 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1696,9 +1696,11 @@ void musb_gadget_cleanup(struct musb *musb)
  * -ENOMEM no memeory to perform the operation
  *
  * @param driver the gadget driver
+ * @param bind the driver's bind function
  * @return <0 if error, 0 if everything is fine
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	int retval;
 	unsigned long flags;
@@ -1706,8 +1708,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 
 	if (!driver
 			|| driver->speed != USB_SPEED_HIGH
-			|| !driver->bind
-			|| !driver->setup)
+			|| !bind || !driver->setup)
 		return -EINVAL;
 
 	/* driver must be initialized to support peripheral mode */
@@ -1735,7 +1736,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	spin_unlock_irqrestore(&musb->lock, flags);
 
 	if (retval == 0) {
-		retval = driver->bind(&musb->g);
+		retval = bind(&musb->g);
 		if (retval != 0) {
 			DBG(3, "bind to driver %s failed --> %d\n",
 					driver->driver.name, retval);
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index d3ef42d..006412c 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -705,11 +705,6 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
  * struct usb_gadget_driver - driver for usb 'slave' devices
  * @function: String describing the gadget's function
  * @speed: Highest speed the driver handles.
- * @bind: Invoked when the driver is bound to a gadget, usually
- *	after registering the driver.
- *	At that point, ep0 is fully initialized, and ep_list holds
- *	the currently-available endpoints.
- *	Called in a context that permits sleeping.
  * @setup: Invoked for ep0 control requests that aren't handled by
  *	the hardware level driver. Most calls must be handled by
  *	the gadget driver, including descriptor and configuration
@@ -774,7 +769,6 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
 struct usb_gadget_driver {
 	char			*function;
 	enum usb_device_speed	speed;
-	int			(*bind)(struct usb_gadget *);
 	void			(*unbind)(struct usb_gadget *);
 	int			(*setup)(struct usb_gadget *,
 					const struct usb_ctrlrequest *);
@@ -798,17 +792,19 @@ struct usb_gadget_driver {
  */
 
 /**
- * usb_gadget_register_driver - register a gadget driver
- * @driver:the driver being registered
+ * usb_gadget_probe_driver - probe a gadget driver
+ * @driver: the driver being registered
+ * @bind: the driver's bind callback
  * Context: can sleep
  *
  * Call this in your gadget driver's module initialization function,
  * to tell the underlying usb controller driver about your driver.
- * The driver's bind() function will be called to bind it to a
- * gadget before this registration call returns.  It's expected that
- * the bind() functions will be in init sections.
+ * The @bind() function will be called to bind it to a gadget before this
+ * registration call returns.  It's expected that the @bind() function will
+ * be in init sections.
  */
-int usb_gadget_register_driver(struct usb_gadget_driver *driver);
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *));
 
 /**
  * usb_gadget_unregister_driver - unregister a gadget driver
-- 
1.7.1

