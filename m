Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0GVMP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:15:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58574 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0GVMPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:15:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 22 Jul 2010 14:16:36 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 4/5] USB: gadget: g_fs: code cleanup
In-reply-to: <1dece38844f330c5850cb021705c41a3be92c40d.1279794290.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <d58a19b7f466f052fe4d7048bcb28ef883bb71c1.1279794290.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
 <c50b89e66cc80f2f89e5c7d4948969e167eb9185.1279794289.git.m.nazarewicz@samsung.com>
 <1dece38844f330c5850cb021705c41a3be92c40d.1279794290.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit cleans the g_fs gadget hopefully making it more
readable.  This is achieved by usage of the usb_string_ids_tab()
function for batch string IDs registration as well as
generalising configuration so that a single routine is
used to add each configuration and bind interfaces.  As an
effect, the code is shorter and has fewer #ifdefs.

Moreover, in some circumstances previous code #defined
CONFIG_USB_FUNCTIONFS_GENERIC macro to prevent a situation
where gadget with no configurations is built.  This code removes
the #define form source code and achieves the same effect using
select in Kconfig.

This patch also changes wording and names of the Kconfig options.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/Kconfig |   23 +++---
 drivers/usb/gadget/g_ffs.c |  163 ++++++++++++--------------------------------
 2 files changed, 56 insertions(+), 130 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 41a8a3e..fc55eff 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -750,6 +750,7 @@ config USB_GADGETFS
 config USB_FUNCTIONFS
 	tristate "Function Filesystem (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select USB_FUNCTIONFS_GENERIC if !(USB_FUNCTIONFS_ETH || USB_FUNCTIONFS_RNDIS)
 	help
 	  The Function Filesystem (FunctioFS) lets one create USB
 	  composite functions in user space in the same way as GadgetFS
@@ -758,31 +759,31 @@ config USB_FUNCTIONFS
 	  implemented in kernel space (for instance Ethernet, serial or
 	  mass storage) and other are implemented in user space.
 
+	  If you say "y" or "m" here you will be able what kind of
+	  configurations the gadget will provide.
+
 	  Say "y" to link the driver statically, or "m" to build
 	  a dynamically linked module called "g_ffs".
 
 config USB_FUNCTIONFS_ETH
-	bool "Include CDC ECM (Ethernet) function"
+	bool "Include configuration with CDC ECM (Ethernet)"
 	depends on USB_FUNCTIONFS && NET
 	help
-	  Include an CDC ECM (Ethernet) funcion in the CDC ECM (Funcion)
-	  Filesystem.  If you also say "y" to the RNDIS query below the
-	  gadget will have two configurations.
+	  Include a configuration with CDC ECM funcion (Ethernet) and the
+	  Funcion Filesystem.
 
 config USB_FUNCTIONFS_RNDIS
-	bool "Include RNDIS (Ethernet) function"
+	bool "Include configuration with RNDIS (Ethernet)"
 	depends on USB_FUNCTIONFS && NET
 	help
-	  Include an RNDIS (Ethernet) funcion in the Funcion Filesystem.
-	  If you also say "y" to the CDC ECM query above the gadget will
-	  have two configurations.
+	  Include a configuration with RNDIS funcion (Ethernet) and the Filesystem.
 
 config USB_FUNCTIONFS_GENERIC
 	bool "Include 'pure' configuration"
-	depends on USB_FUNCTIONFS && (USB_FUNCTIONFS_ETH || USB_FUNCTIONFS_RNDIS)
+	depends on USB_FUNCTIONFS
 	help
-	  Include a configuration with FunctionFS and no Ethernet
-	  configuration.
+	  Include a configuration with the Function Filesystem alone with
+	  no Ethernet interface.
 
 config USB_FILE_STORAGE
 	tristate "File-backed Storage Gadget"
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 503712d..a2feb7c 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -32,12 +32,13 @@
 #  include "u_ether.c"
 
 static u8 gfs_hostaddr[ETH_ALEN];
-#else
-#  if !defined CONFIG_USB_FUNCTIONFS_GENERIC
-#    define CONFIG_USB_FUNCTIONFS_GENERIC
+#  ifdef CONFIG_USB_FUNCTIONFS_ETH
+static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN]);
 #  endif
+#else
 #  define gether_cleanup() do { } while (0)
 #  define gether_setup(gadget, hostaddr)   ((int)0)
+#  define gfs_hostaddr NULL
 #endif
 
 #include "f_fs.c"
@@ -104,27 +105,15 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 
 /* string IDs are assigned dynamically */
 
-enum {
-#ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-	GFS_STRING_RNDIS_CONFIG_IDX,
-#endif
-#ifdef CONFIG_USB_FUNCTIONFS_ETH
-	GFS_STRING_ECM_CONFIG_IDX,
-#endif
-#ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-	GFS_STRING_GENERIC_CONFIG_IDX,
-#endif
-};
-
 static struct usb_string gfs_strings[] = {
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-	[GFS_STRING_RNDIS_CONFIG_IDX].s = "FunctionFS + RNDIS",
+	{ .s = "FunctionFS + RNDIS" },
 #endif
 #ifdef CONFIG_USB_FUNCTIONFS_ETH
-	[GFS_STRING_ECM_CONFIG_IDX].s = "FunctionFS + ECM",
+	{ .s = "FunctionFS + ECM" },
 #endif
 #ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-	[GFS_STRING_GENERIC_CONFIG_IDX].s = "FunctionFS",
+	{ .s = "FunctionFS" },
 #endif
 	{  } /* end of list */
 };
@@ -138,59 +127,33 @@ static struct usb_gadget_strings *gfs_dev_strings[] = {
 };
 
 
+
+struct gfs_configuration {
+	struct usb_configuration c;
+	int (*eth)(struct usb_configuration *c, u8 *ethaddr);
+} gfs_configurations[] = {
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-static int gfs_do_rndis_config(struct usb_configuration *c);
-
-static struct usb_configuration gfs_rndis_config_driver = {
-	.label			= "FunctionFS + RNDIS",
-	.bind			= gfs_do_rndis_config,
-	.bConfigurationValue	= 1,
-	/* .iConfiguration	= DYNAMIC */
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
-#  define gfs_add_rndis_config(cdev) \
-	usb_add_config(cdev, &gfs_rndis_config_driver)
-#else
-#  define gfs_add_rndis_config(cdev) 0
+	{
+		.eth		= rndis_bind_config,
+	},
 #endif
 
-
 #ifdef CONFIG_USB_FUNCTIONFS_ETH
-static int gfs_do_ecm_config(struct usb_configuration *c);
-
-static struct usb_configuration gfs_ecm_config_driver = {
-	.label			= "FunctionFS + ECM",
-	.bind			= gfs_do_ecm_config,
-	.bConfigurationValue	= 1,
-	/* .iConfiguration	= DYNAMIC */
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
-#  define gfs_add_ecm_config(cdev) \
-	usb_add_config(cdev, &gfs_ecm_config_driver)
-#else
-#  define gfs_add_ecm_config(cdev) 0
+	{
+		.eth		= eth_bind_config,
+	},
 #endif
 
-
 #ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-static int gfs_do_generic_config(struct usb_configuration *c);
-
-static struct usb_configuration gfs_generic_config_driver = {
-	.label			= "FunctionFS",
-	.bind			= gfs_do_generic_config,
-	.bConfigurationValue	= 2,
-	/* .iConfiguration	= DYNAMIC */
-	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-};
-#  define gfs_add_generic_config(cdev) \
-	usb_add_config(cdev, &gfs_generic_config_driver)
-#else
-#  define gfs_add_generic_config(cdev) 0
+	{
+	},
 #endif
+};
 
 
 static int gfs_bind(struct usb_composite_dev *cdev);
 static int gfs_unbind(struct usb_composite_dev *cdev);
+static int gfs_do_config(struct usb_configuration *c);
 
 static struct usb_composite_driver gfs_driver = {
 	.name		= DRIVER_NAME,
@@ -260,7 +223,7 @@ static int functionfs_check_dev_callback(const char *dev_name)
 
 static int gfs_bind(struct usb_composite_dev *cdev)
 {
-	int ret;
+	int ret, i;
 
 	ENTER();
 
@@ -279,45 +242,27 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	gfs_dev_desc.iProduct      = 0;
 	gfs_dev_desc.iSerialNumber = 0;
 
-#ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_RNDIS_CONFIG_IDX].id = ret;
-	gfs_rndis_config_driver.iConfiguration = ret;
-#endif
-
-#ifdef CONFIG_USB_FUNCTIONFS_ETH
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_ECM_CONFIG_IDX].id = ret;
-	gfs_ecm_config_driver.iConfiguration = ret;
-#endif
-
-#ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-	ret = usb_string_id(cdev);
+	ret = usb_string_ids_tab(cdev, gfs_strings);
 	if (unlikely(ret < 0))
 		goto error;
-	gfs_strings[GFS_STRING_GENERIC_CONFIG_IDX].id = ret;
-	gfs_generic_config_driver.iConfiguration = ret;
-#endif
 
 	ret = functionfs_bind(gfs_ffs_data, cdev);
 	if (unlikely(ret < 0))
 		goto error;
 
-	ret = gfs_add_rndis_config(cdev);
-	if (unlikely(ret < 0))
-		goto error_unbind;
+	for (i = 0; i < ARRAY_SIZE(gfs_configurations); ++i) {
+		struct gfs_configuration *c = gfs_configurations + i;
 
-	ret = gfs_add_ecm_config(cdev);
-	if (unlikely(ret < 0))
-		goto error_unbind;
+		c->c.label			= gfs_strings[i].s;
+		c->c.iConfiguration		= gfs_strings[i].id;
+		c->c.bind			= gfs_do_config;
+		c->c.bConfigurationValue	= 1 + i;
+		c->c.bmAttributes		= USB_CONFIG_ATT_SELFPOWER;
 
-	ret = gfs_add_generic_config(cdev);
-	if (unlikely(ret < 0))
-		goto error_unbind;
+		ret = usb_add_config(cdev, &c->c);
+		if (unlikely(ret < 0))
+			goto error_unbind;
+	}
 
 	return 0;
 
@@ -351,10 +296,10 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
 }
 
 
-static int __gfs_do_config(struct usb_configuration *c,
-			   int (*eth)(struct usb_configuration *c, u8 *ethaddr),
-			   u8 *ethaddr)
+static int gfs_do_config(struct usb_configuration *c)
 {
+	struct gfs_configuration *gc =
+		container_of(c, struct gfs_configuration, c);
 	int ret;
 
 	if (WARN_ON(!gfs_ffs_data))
@@ -365,8 +310,8 @@ static int __gfs_do_config(struct usb_configuration *c,
 		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
-	if (eth) {
-		ret = eth(c, ethaddr);
+	if (gc->eth) {
+		ret = gc->eth(c, gfs_hostaddr);
 		if (unlikely(ret < 0))
 			return ret;
 	}
@@ -389,32 +334,12 @@ static int __gfs_do_config(struct usb_configuration *c,
 	return 0;
 }
 
-#ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-static int gfs_do_rndis_config(struct usb_configuration *c)
-{
-	ENTER();
-
-	return __gfs_do_config(c, rndis_bind_config, gfs_hostaddr);
-}
-#endif
 
 #ifdef CONFIG_USB_FUNCTIONFS_ETH
-static int gfs_do_ecm_config(struct usb_configuration *c)
-{
-	ENTER();
-
-	return __gfs_do_config(c,
-			       can_support_ecm(c->cdev->gadget)
-			     ? ecm_bind_config : geth_bind_config,
-			       gfs_hostaddr);
-}
-#endif
-
-#ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-static int gfs_do_generic_config(struct usb_configuration *c)
+static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
-	ENTER();
-
-	return __gfs_do_config(c, NULL, NULL);
+	return can_support_ecm(c->cdev->gadget)
+		? ecm_bind_config(c, ethaddr)
+		: geth_bind_config(c, ethaddr);
 }
 #endif
-- 
1.7.1

