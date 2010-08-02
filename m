Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0HBS2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:28:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49450 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0HBS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:28:07 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Nazarewicz?= <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] usb gadget: don't save bind callback in struct usb_configuration
Date: Mon,  2 Aug 2010 20:27:46 +0200
Message-Id: <1280773666-5405-2-git-send-email-u.kleine-koenig@pengutronix.de>
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

The bind function is only called at init time so there is no need to
save a pointer to it in the driver struct.

This fixes many section mismatches reported by modpost.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Michał Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/audio.c        |    3 +--
 drivers/usb/gadget/cdc2.c         |    3 +--
 drivers/usb/gadget/composite.c    |   14 ++++++++------
 drivers/usb/gadget/ether.c        |    7 +++----
 drivers/usb/gadget/f_loopback.c   |    3 +--
 drivers/usb/gadget/f_sourcesink.c |    3 +--
 drivers/usb/gadget/g_ffs.c        |    9 +++------
 drivers/usb/gadget/hid.c          |    3 +--
 drivers/usb/gadget/mass_storage.c |    3 +--
 drivers/usb/gadget/multi.c        |    6 ++----
 drivers/usb/gadget/nokia.c        |    8 ++++----
 drivers/usb/gadget/serial.c       |    4 ++--
 drivers/usb/gadget/webcam.c       |    4 ++--
 include/linux/usb/composite.h     |    5 +----
 14 files changed, 31 insertions(+), 44 deletions(-)

diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index a62af7b..eeff9b2 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -105,7 +105,6 @@ static int __init audio_do_config(struct usb_configuration *c)
 
 static struct usb_configuration audio_config_driver = {
 	.label			= DRIVER_DESC,
-	.bind			= audio_do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -145,7 +144,7 @@ static int __init audio_bind(struct usb_composite_dev *cdev)
 	strings_dev[STRING_PRODUCT_IDX].id = status;
 	device_desc.iProduct = status;
 
-	status = usb_add_config(cdev, &audio_config_driver);
+	status = usb_add_config(cdev, &audio_config_driver, audio_do_config);
 	if (status < 0)
 		goto fail;
 
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 928137d..c3d2c86 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -151,7 +151,6 @@ static int __init cdc_do_config(struct usb_configuration *c)
 
 static struct usb_configuration cdc_config_driver = {
 	.label			= "CDC Composite (ECM + ACM)",
-	.bind			= cdc_do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -218,7 +217,7 @@ static int __init cdc_bind(struct usb_composite_dev *cdev)
 	device_desc.iProduct = status;
 
 	/* register our configuration */
-	status = usb_add_config(cdev, &cdc_config_driver);
+	status = usb_add_config(cdev, &cdc_config_driver, cdc_do_config);
 	if (status < 0)
 		goto fail1;
 
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d07960e..b6cc043 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -470,18 +470,20 @@ done:
  * usb_add_config() - add a configuration to a device.
  * @cdev: wraps the USB gadget
  * @config: the configuration, with bConfigurationValue assigned
+ * @bind: the configuration's bind function
  * Context: single threaded during gadget setup
  *
- * One of the main tasks of a composite driver's bind() routine is to
+ * One of the main tasks of a composite @bind() routine is to
  * add each of the configurations it supports, using this routine.
  *
- * This function returns the value of the configuration's bind(), which
+ * This function returns the value of the configuration's @bind(), which
  * is zero for success else a negative errno value.  Binding configurations
  * assigns global resources including string IDs, and per-configuration
  * resources such as interface IDs and endpoints.
  */
 int usb_add_config(struct usb_composite_dev *cdev,
-		struct usb_configuration *config)
+		struct usb_configuration *config,
+		int (*bind)(struct usb_configuration *))
 {
 	int				status = -EINVAL;
 	struct usb_configuration	*c;
@@ -490,7 +492,7 @@ int usb_add_config(struct usb_composite_dev *cdev,
 			config->bConfigurationValue,
 			config->label, config);
 
-	if (!config->bConfigurationValue || !config->bind)
+	if (!config->bConfigurationValue || !bind)
 		goto done;
 
 	/* Prevent duplicate configuration identifiers */
@@ -507,7 +509,7 @@ int usb_add_config(struct usb_composite_dev *cdev,
 	INIT_LIST_HEAD(&config->functions);
 	config->next_interface_id = 0;
 
-	status = config->bind(config);
+	status = bind(config);
 	if (status < 0) {
 		list_del(&config->list);
 		config->cdev = NULL;
@@ -533,7 +535,7 @@ int usb_add_config(struct usb_composite_dev *cdev,
 		}
 	}
 
-	/* set_alt(), or next config->bind(), sets up
+	/* set_alt(), or next bind(), sets up
 	 * ep->driver_data as needed.
 	 */
 	usb_ep_autoconfig_reset(cdev->gadget);
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 400f803..cd03bea 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -251,7 +251,6 @@ static int __init rndis_do_config(struct usb_configuration *c)
 
 static struct usb_configuration rndis_config_driver = {
 	.label			= "RNDIS",
-	.bind			= rndis_do_config,
 	.bConfigurationValue	= 2,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -289,7 +288,6 @@ static int __init eth_do_config(struct usb_configuration *c)
 
 static struct usb_configuration eth_config_driver = {
 	/* .label = f(hardware) */
-	.bind			= eth_do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -373,12 +371,13 @@ static int __init eth_bind(struct usb_composite_dev *cdev)
 
 	/* register our configuration(s); RNDIS first, if it's used */
 	if (has_rndis()) {
-		status = usb_add_config(cdev, &rndis_config_driver);
+		status = usb_add_config(cdev, &rndis_config_driver,
+				rndis_do_config);
 		if (status < 0)
 			goto fail;
 	}
 
-	status = usb_add_config(cdev, &eth_config_driver);
+	status = usb_add_config(cdev, &eth_config_driver, eth_do_config);
 	if (status < 0)
 		goto fail;
 
diff --git a/drivers/usb/gadget/f_loopback.c b/drivers/usb/gadget/f_loopback.c
index e91d1b1..b37960f 100644
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -349,7 +349,6 @@ static int __init loopback_bind_config(struct usb_configuration *c)
 static struct usb_configuration loopback_driver = {
 	.label		= "loopback",
 	.strings	= loopback_strings,
-	.bind		= loopback_bind_config,
 	.bConfigurationValue = 2,
 	.bmAttributes	= USB_CONFIG_ATT_SELFPOWER,
 	/* .iConfiguration = DYNAMIC */
@@ -382,5 +381,5 @@ int __init loopback_add(struct usb_composite_dev *cdev, bool autoresume)
 		loopback_driver.bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
-	return usb_add_config(cdev, &loopback_driver);
+	return usb_add_config(cdev, &loopback_driver, loopback_bind_config);
 }
diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index 6d3cc44..e403a53 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -498,7 +498,6 @@ unknown:
 static struct usb_configuration sourcesink_driver = {
 	.label		= "source/sink",
 	.strings	= sourcesink_strings,
-	.bind		= sourcesink_bind_config,
 	.setup		= sourcesink_setup,
 	.bConfigurationValue = 3,
 	.bmAttributes	= USB_CONFIG_ATT_SELFPOWER,
@@ -532,5 +531,5 @@ int __init sourcesink_add(struct usb_composite_dev *cdev, bool autoresume)
 		sourcesink_driver.bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
-	return usb_add_config(cdev, &sourcesink_driver);
+	return usb_add_config(cdev, &sourcesink_driver, sourcesink_bind_config);
 }
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index d1af253..ddae926 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -151,13 +151,12 @@ static int gfs_do_rndis_config(struct usb_configuration *c);
 
 static struct usb_configuration gfs_rndis_config_driver = {
 	.label			= "FunctionFS + RNDIS",
-	.bind			= gfs_do_rndis_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration	= DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 #  define gfs_add_rndis_config(cdev) \
-	usb_add_config(cdev, &gfs_rndis_config_driver)
+	usb_add_config(cdev, &gfs_rndis_config_driver, gfs_do_rndis_config)
 #else
 #  define gfs_add_rndis_config(cdev) 0
 #endif
@@ -168,13 +167,12 @@ static int gfs_do_ecm_config(struct usb_configuration *c);
 
 static struct usb_configuration gfs_ecm_config_driver = {
 	.label			= "FunctionFS + ECM",
-	.bind			= gfs_do_ecm_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration	= DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 #  define gfs_add_ecm_config(cdev) \
-	usb_add_config(cdev, &gfs_ecm_config_driver)
+	usb_add_config(cdev, &gfs_ecm_config_driver, gfs_do_ecm_config)
 #else
 #  define gfs_add_ecm_config(cdev) 0
 #endif
@@ -185,13 +183,12 @@ static int gfs_do_generic_config(struct usb_configuration *c);
 
 static struct usb_configuration gfs_generic_config_driver = {
 	.label			= "FunctionFS",
-	.bind			= gfs_do_generic_config,
 	.bConfigurationValue	= 2,
 	/* .iConfiguration	= DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 };
 #  define gfs_add_generic_config(cdev) \
-	usb_add_config(cdev, &gfs_generic_config_driver)
+	usb_add_config(cdev, &gfs_generic_config_driver, gfs_do_generic_config)
 #else
 #  define gfs_add_generic_config(cdev) 0
 #endif
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 7757226..2ce69c6 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -148,7 +148,6 @@ static int __init do_config(struct usb_configuration *c)
 
 static struct usb_configuration config_driver = {
 	.label			= "HID Gadget",
-	.bind			= do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -201,7 +200,7 @@ static int __init hid_bind(struct usb_composite_dev *cdev)
 	device_desc.iProduct = status;
 
 	/* register our configuration */
-	status = usb_add_config(cdev, &config_driver);
+	status = usb_add_config(cdev, &config_driver, do_config);
 	if (status < 0)
 		return status;
 
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 705cc1f..21a65a2 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -165,7 +165,6 @@ static int __init msg_do_config(struct usb_configuration *c)
 
 static struct usb_configuration msg_config_driver = {
 	.label			= "Linux File-Backed Storage",
-	.bind			= msg_do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -208,7 +207,7 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 	msg_config_driver.iConfiguration = status;
 
 	/* register our second configuration */
-	status = usb_add_config(cdev, &msg_config_driver);
+	status = usb_add_config(cdev, &msg_config_driver, msg_do_config);
 	if (status < 0)
 		return status;
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index a930d7f..84c9ab6 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -181,7 +181,6 @@ static int __init rndis_do_config(struct usb_configuration *c)
 
 static struct usb_configuration rndis_config_driver = {
 	.label			= "Multifunction Composite (RNDIS + MS + ACM)",
-	.bind			= rndis_do_config,
 	.bConfigurationValue	= 2,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -217,7 +216,6 @@ static int __init cdc_do_config(struct usb_configuration *c)
 
 static struct usb_configuration cdc_config_driver = {
 	.label			= "Multifunction Composite (CDC + MS + ACM)",
-	.bind			= cdc_do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -295,14 +293,14 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 
 #ifdef USB_ETH_RNDIS
 	/* register our first configuration */
-	status = usb_add_config(cdev, &rndis_config_driver);
+	status = usb_add_config(cdev, &rndis_config_driver, rndis_do_config);
 	if (status < 0)
 		goto fail2;
 #endif
 
 #ifdef CONFIG_USB_G_MULTI_CDC
 	/* register our second configuration */
-	status = usb_add_config(cdev, &cdc_config_driver);
+	status = usb_add_config(cdev, &cdc_config_driver, cdc_do_config);
 	if (status < 0)
 		goto fail2;
 #endif
diff --git a/drivers/usb/gadget/nokia.c b/drivers/usb/gadget/nokia.c
index 7d6b66a..a7dda39 100644
--- a/drivers/usb/gadget/nokia.c
+++ b/drivers/usb/gadget/nokia.c
@@ -135,7 +135,6 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 
 static struct usb_configuration nokia_config_500ma_driver = {
 	.label		= "Bus Powered",
-	.bind		= nokia_bind_config,
 	.bConfigurationValue = 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes	= USB_CONFIG_ATT_ONE,
@@ -144,7 +143,6 @@ static struct usb_configuration nokia_config_500ma_driver = {
 
 static struct usb_configuration nokia_config_100ma_driver = {
 	.label		= "Self Powered",
-	.bind		= nokia_bind_config,
 	.bConfigurationValue = 2,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes	= USB_CONFIG_ATT_ONE | USB_CONFIG_ATT_SELFPOWER,
@@ -206,11 +204,13 @@ static int __init nokia_bind(struct usb_composite_dev *cdev)
 	}
 
 	/* finaly register the configuration */
-	status = usb_add_config(cdev, &nokia_config_500ma_driver);
+	status = usb_add_config(cdev, &nokia_config_500ma_driver,
+			nokia_bind_config);
 	if (status < 0)
 		goto err_usb;
 
-	status = usb_add_config(cdev, &nokia_config_100ma_driver);
+	status = usb_add_config(cdev, &nokia_config_100ma_driver,
+			nokia_bind_config);
 	if (status < 0)
 		goto err_usb;
 
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index f46a609..8838f03 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -155,7 +155,6 @@ static int __init serial_bind_config(struct usb_configuration *c)
 
 static struct usb_configuration serial_config_driver = {
 	/* .label = f(use_acm) */
-	.bind		= serial_bind_config,
 	/* .bConfigurationValue = f(use_acm) */
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes	= USB_CONFIG_ATT_SELFPOWER,
@@ -225,7 +224,8 @@ static int __init gs_bind(struct usb_composite_dev *cdev)
 	}
 
 	/* register our configuration */
-	status = usb_add_config(cdev, &serial_config_driver);
+	status = usb_add_config(cdev, &serial_config_driver,
+			serial_bind_config);
 	if (status < 0)
 		goto fail;
 
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index f5f3030..79a7230 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -317,7 +317,6 @@ webcam_config_bind(struct usb_configuration *c)
 
 static struct usb_configuration webcam_config_driver = {
 	.label			= webcam_config_label,
-	.bind			= webcam_config_bind,
 	.bConfigurationValue	= 1,
 	.iConfiguration		= 0, /* dynamic */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -354,7 +353,8 @@ webcam_bind(struct usb_composite_dev *cdev)
 	webcam_config_driver.iConfiguration = ret;
 
 	/* Register our configuration. */
-	if ((ret = usb_add_config(cdev, &webcam_config_driver)) < 0)
+	if ((ret = usb_add_config(cdev, &webcam_config_driver,
+					webcam_config_bind)) < 0)
 		goto error;
 
 	INFO(cdev, "Webcam Video Gadget\n");
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 139353e..fc750b1 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -161,8 +161,6 @@ ep_choose(struct usb_gadget *g, struct usb_endpoint_descriptor *hs,
  *	and by language IDs provided in control requests.
  * @descriptors: Table of descriptors preceding all function descriptors.
  *	Examples include OTG and vendor-specific descriptors.
- * @bind: Called from @usb_add_config() to allocate resources unique to this
- *	configuration and to call @usb_add_function() for each function used.
  * @unbind: Reverses @bind; called as a side effect of unregistering the
  *	driver which added this configuration.
  * @setup: Used to delegate control requests that aren't handled by standard
@@ -207,8 +205,7 @@ struct usb_configuration {
 	 * we can't restructure things to avoid mismatching...
 	 */
 
-	/* configuration management:  bind/unbind */
-	int			(*bind)(struct usb_configuration *);
+	/* configuration management: unbind/setup */
 	void			(*unbind)(struct usb_configuration *);
 	int			(*setup)(struct usb_configuration *,
 					const struct usb_ctrlrequest *);
-- 
1.7.1

