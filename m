Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0FNImz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:42:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11091 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab0FNImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:42:52 -0400
Date: Mon, 14 Jun 2010 10:43:36 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: g_fs: code cleanup and bug fixes
In-reply-to: <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <b51342e058f33dc9d78491c1209d0e86d09ed9da.1276170819.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <f8fbee30a711b740b5875514715c3c58b4eb196c.1276170819.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit cleans the g_fs gadget hopefully making it more
readable.  This is achieved by usage of the usb_string_ids_tab()
function for bulk string IDs registration as well as
generalising provided configuration so that a single routine is
used to add each configuration and bind interfaces.  As an
effect, the code is shorter and has fewer #ifdefs.

Also, a bug has been fixed where bConfigurationValue were
not affected by what configuration user chose to compile in via
Kconfig option.  As an effect, RDNIS and ECM were always number
1 and the "pure" configuration was always number 2.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Requires "USB: gadget: composite: usb_string_ids_*() functions added"
patch to work.

 drivers/usb/gadget/Kconfig |   23 +++---
 drivers/usb/gadget/g_ffs.c |  174 ++++++++++++--------------------------------
 2 files changed, 60 insertions(+), 137 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index d5b65d3..d3d0e2d 100644
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
index da3a9e4..a9474f8 100644
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
@@ -107,15 +108,7 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 enum {
 	GFS_STRING_MANUFACTURER_IDX,
 	GFS_STRING_PRODUCT_IDX,
-#ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-	GFS_STRING_RNDIS_CONFIG_IDX,
-#endif
-#ifdef CONFIG_USB_FUNCTIONFS_ETH
-	GFS_STRING_ECM_CONFIG_IDX,
-#endif
-#ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-	GFS_STRING_GENERIC_CONFIG_IDX,
-#endif
+	GFS_STRING_FIRST_CONFIG_IDX,
 };
 
 static       char gfs_manufacturer[50];
@@ -126,13 +119,13 @@ static struct usb_string gfs_strings[] = {
 	[GFS_STRING_MANUFACTURER_IDX].s = gfs_manufacturer,
 	[GFS_STRING_PRODUCT_IDX].s = gfs_driver_desc,
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
@@ -146,59 +139,33 @@ static struct usb_gadget_strings *gfs_dev_strings[] = {
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
 	.name		= gfs_short_name,
@@ -267,7 +234,7 @@ static int functionfs_check_dev_callback(const char *dev_name)
 
 static int gfs_bind(struct usb_composite_dev *cdev)
 {
-	int ret;
+	int ret, i;
 
 	ENTER();
 
@@ -284,57 +251,32 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	snprintf(gfs_manufacturer, sizeof gfs_manufacturer, "%s %s with %s",
 		 init_utsname()->sysname, init_utsname()->release,
 		 cdev->gadget->name);
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_MANUFACTURER_IDX].id = ret;
-	gfs_dev_desc.iManufacturer = ret;
-
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_PRODUCT_IDX].id = ret;
-	gfs_dev_desc.iProduct = ret;
-
-#ifdef CONFIG_USB_FUNCTIONFS_RNDIS
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_RNDIS_CONFIG_IDX].id = ret;
-	gfs_rndis_config_driver.iConfiguration = ret;
-#endif
 
-#ifdef CONFIG_USB_FUNCTIONFS_ETH
-	ret = usb_string_id(cdev);
+	ret = usb_string_ids_tab(cdev, gfs_strings);
 	if (unlikely(ret < 0))
 		goto error;
-	gfs_strings[GFS_STRING_ECM_CONFIG_IDX].id = ret;
-	gfs_ecm_config_driver.iConfiguration = ret;
-#endif
 
-#ifdef CONFIG_USB_FUNCTIONFS_GENERIC
-	ret = usb_string_id(cdev);
-	if (unlikely(ret < 0))
-		goto error;
-	gfs_strings[GFS_STRING_GENERIC_CONFIG_IDX].id = ret;
-	gfs_generic_config_driver.iConfiguration = ret;
-#endif
+	gfs_dev_desc.iManufacturer = gfs_strings[GFS_STRING_MANUFACTURER_IDX].id;
+	gfs_dev_desc.iProduct      = gfs_strings[GFS_STRING_PRODUCT_IDX].id;
 
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
+		ret = GFS_STRING_FIRST_CONFIG_IDX + i;
+		c->c.label			= gfs_strings[ret].s;
+		c->c.iConfiguration		= gfs_strings[ret].id;
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
 
@@ -368,10 +310,10 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
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
@@ -382,8 +324,8 @@ static int __gfs_do_config(struct usb_configuration *c,
 		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
-	if (eth) {
-		ret = eth(c, ethaddr);
+	if (gc->eth) {
+		ret = gc->eth(c, gfs_hostaddr);
 		if (unlikely(ret < 0))
 			return ret;
 	}
@@ -406,32 +348,12 @@ static int __gfs_do_config(struct usb_configuration *c,
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

