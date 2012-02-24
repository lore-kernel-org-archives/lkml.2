Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2BXWHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:07:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55759 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2BXWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:07:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.213.136 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benoit Cousson <b-cousson@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] devicetree: Add empty of_platform_populate() for !CONFIG_OF_ADDRESS (sparc)
Date: Fri, 24 Feb 2012 15:06:58 -0700
Message-Id: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparc has its own helpers for translating address ranges when the device
tree is parsed at boot time, and it isn't able to use of_platform_populate().
However, there are some device drivers that want to use that function on
other DT enabled platforms (ie. TWL4030).  This patch adds an empty
of_platform_populate() implementation that returns an error when
CONFIG_OF_ADDRESS is not selected.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/twl-core.c      |    5 ++---
 drivers/of/platform.c       |    4 ++--
 include/linux/of_platform.h |   12 ++++++++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 66f9bff..4970d43 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1305,11 +1305,10 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		twl_i2c_write_u8(TWL4030_MODULE_INTBR, temp, REG_GPPUPDCTR1);
 	}
 
-#ifdef CONFIG_OF_DEVICE
+	status = -ENODEV;
 	if (node)
 		status = of_platform_populate(node, NULL, NULL, &client->dev);
-	else
-#endif
+	if (status)
 		status = add_children(pdata, id->driver_data);
 
 fail:
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 63b3ec4..20fbebd 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -55,7 +55,7 @@ EXPORT_SYMBOL(of_find_device_by_node);
 #include <asm/dcr.h>
 #endif
 
-#if !defined(CONFIG_SPARC)
+#ifdef CONFIG_OF_ADDRESS
 /*
  * The following routines scan a subtree and registers a device for
  * each applicable node.
@@ -462,4 +462,4 @@ int of_platform_populate(struct device_node *root,
 	of_node_put(root);
 	return rc;
 }
-#endif /* !CONFIG_SPARC */
+#endif /* CONFIG_OF_ADDRESS */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 040ce2f..242fa35 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -81,7 +81,7 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
 					 struct device *parent);
 extern struct platform_device *of_find_device_by_node(struct device_node *np);
 
-#if !defined(CONFIG_SPARC) /* SPARC has its own device registration method */
+#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
 /* Platform devices and busses creation */
 extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
@@ -94,7 +94,15 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
-#endif /* !CONFIG_SPARC */
+#else
+static inline int of_platform_populate(struct device_node *root,
+					const struct of_device_id *matches,
+					const struct of_dev_auxdata *lookup,
+					struct device *parent)
+{
+	return -ENODEV;
+}
+#endif /* !CONFIG_OF_ADDRESS */
 
 #endif /* CONFIG_OF_DEVICE */
 
-- 
1.7.9

