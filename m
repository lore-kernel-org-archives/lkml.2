Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0HINdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:33:19 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55951 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0HINcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:32:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Mon, 09 Aug 2010 15:33:50 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 3/3] usb gadget: don't save bind callback in struct
 usb_configuration
In-reply-to: <e465429de034460cdc6eff4e3502d2be83264f82.1281359651.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <1d9c90f2bd1979e73642f56130f46d55dbec1c3e.1281359651.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <3decda614c6d8732c018417558d74ed942e76c82.1281359651.git.m.nazarewicz@samsung.com>
 <e465429de034460cdc6eff4e3502d2be83264f82.1281359651.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

The bind function is most of the time only called at init time so there
is no need to save a pointer to it in the configuration structure.

This fixes many section mismatches reported by modpost.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[m.nazarewicz@samsung.com: updated for -next]
Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/audio.c        |    3 +--
 drivers/usb/gadget/cdc2.c         |    3 +--
 drivers/usb/gadget/composite.c    |   14 ++++++++------
 drivers/usb/gadget/ether.c        |    7 +++----
 drivers/usb/gadget/f_loopback.c   |    3 +--
 drivers/usb/gadget/f_sourcesink.c |    3 +--
 drivers/usb/gadget/g_ffs.c        |    3 +--
 drivers/usb/gadget/hid.c          |    3 +--
 drivers/usb/gadget/mass_storage.c |    3 +--
 drivers/usb/gadget/multi.c        |   10 ++++------
 drivers/usb/gadget/nokia.c        |    8 ++++----
 drivers/usb/gadget/serial.c       |    4 ++--
 drivers/usb/gadget/webcam.c       |    4 ++--
 include/linux/usb/composite.h     |    8 +++-----
 14 files changed, 33 insertions(+), 43 deletions(-)

Uwe's original patch did not apply on -next for me (g_ffs.c and multi.c
conflicted) so fixed that.

diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index 5a65fbb..93b999e 100644
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
index 1f2a9b1..2720ab0 100644
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
index 3cafda7..f794c5e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -471,18 +471,20 @@ done:
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
@@ -491,7 +493,7 @@ int usb_add_config(struct usb_composite_dev *cdev,
 			config->bConfigurationValue,
 			config->label, config);
 
-	if (!config->bConfigurationValue || !config->bind)
+	if (!config->bConfigurationValue || !bind)
 		goto done;
 
 	/* Prevent duplicate configuration identifiers */
@@ -508,7 +510,7 @@ int usb_add_config(struct usb_composite_dev *cdev,
 	INIT_LIST_HEAD(&config->functions);
 	config->next_interface_id = 0;
 
-	status = config->bind(config);
+	status = bind(config);
 	if (status < 0) {
 		list_del(&config->list);
 		config->cdev = NULL;
@@ -534,7 +536,7 @@ int usb_add_config(struct usb_composite_dev *cdev,
 		}
 	}
 
-	/* set_alt(), or next config->bind(), sets up
+	/* set_alt(), or next bind(), sets up
 	 * ep->driver_data as needed.
 	 */
 	usb_ep_autoconfig_reset(cdev->gadget);
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 33076bc..1690c9d 100644
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
index 6ab2d74..ba145ee 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -268,11 +268,10 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 		ret = GFS_STRING_FIRST_CONFIG_IDX + i;
 		c->c.label			= gfs_strings[ret].s;
 		c->c.iConfiguration		= gfs_strings[ret].id;
-		c->c.bind			= gfs_do_config;
 		c->c.bConfigurationValue	= 1 + i;
 		c->c.bmAttributes		= USB_CONFIG_ATT_SELFPOWER;
 
-		ret = usb_add_config(cdev, &c->c);
+		ret = usb_add_config(cdev, &c->c, gfs_do_config);
 		if (unlikely(ret < 0))
 			goto error_unbind;
 	}
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 77f4952..2523e54 100644
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
index a992c78..bb83d4d 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -171,7 +171,6 @@ static int __init msg_do_config(struct usb_configuration *c)
 
 static struct usb_configuration msg_config_driver = {
 	.label			= "Linux File-Backed Storage",
-	.bind			= msg_do_config,
 	.bConfigurationValue	= 1,
 	/* .iConfiguration = DYNAMIC */
 	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
@@ -214,7 +213,7 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
 	msg_config_driver.iConfiguration = status;
 
 	/* register our second configuration */
-	status = usb_add_config(cdev, &msg_config_driver);
+	status = usb_add_config(cdev, &msg_config_driver, msg_do_config);
 	if (status < 0)
 		return status;
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 384b3e1..ca54b47 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -170,7 +170,7 @@ static u8 hostaddr[ETH_ALEN];
 
 #ifdef USB_ETH_RNDIS
 
-static __ref int rndis_do_config(struct usb_configuration *c)
+static __init int rndis_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -197,7 +197,6 @@ static __ref int rndis_do_config(struct usb_configuration *c)
 static int rndis_config_register(struct usb_composite_dev *cdev)
 {
 	static struct usb_configuration config = {
-		.bind			= rndis_do_config,
 		.bConfigurationValue	= MULTI_RNDIS_CONFIG_NUM,
 		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 	};
@@ -205,7 +204,7 @@ static int rndis_config_register(struct usb_composite_dev *cdev)
 	config.label          = strings_dev[MULTI_STRING_RNDIS_CONFIG_IDX].s;
 	config.iConfiguration = strings_dev[MULTI_STRING_RNDIS_CONFIG_IDX].id;
 
-	return usb_add_config(cdev, &config);
+	return usb_add_config(cdev, &config, rndis_do_config);
 }
 
 #else
@@ -222,7 +221,7 @@ static int rndis_config_register(struct usb_composite_dev *cdev)
 
 #ifdef CONFIG_USB_G_MULTI_CDC
 
-static __ref int cdc_do_config(struct usb_configuration *c)
+static __init int cdc_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -249,7 +248,6 @@ static __ref int cdc_do_config(struct usb_configuration *c)
 static int cdc_config_register(struct usb_composite_dev *cdev)
 {
 	static struct usb_configuration config = {
-		.bind			= cdc_do_config,
 		.bConfigurationValue	= MULTI_CDC_CONFIG_NUM,
 		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
 	};
@@ -257,7 +255,7 @@ static int cdc_config_register(struct usb_composite_dev *cdev)
 	config.label          = strings_dev[MULTI_STRING_CDC_CONFIG_IDX].s;
 	config.iConfiguration = strings_dev[MULTI_STRING_CDC_CONFIG_IDX].id;
 
-	return usb_add_config(cdev, &config);
+	return usb_add_config(cdev, &config, cdc_do_config);
 }
 
 #else
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
index 0b81d7b..1ac57a9 100644
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
index de65b80..a5a0fdb 100644
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
index ff37718..9a22b33 100644
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
@@ -232,7 +229,8 @@ struct usb_configuration {
 };
 
 int usb_add_config(struct usb_composite_dev *,
-		struct usb_configuration *);
+		struct usb_configuration *,
+		int (*)(struct usb_configuration *));
 
 /**
  * struct usb_composite_driver - groups configurations into a gadget
-- 
1.7.1

