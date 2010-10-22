Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0JVSbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:31:46 -0400
Received: from kroah.org ([198.145.64.141]:37766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795Ab0JVSZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@ti.com>, Magnus Damm <magnus.damm@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/31] driver core: platform_bus: allow runtime override of dev_pm_ops
Date: Fri, 22 Oct 2010 11:24:51 -0700
Message-Id: <1287771916-15016-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@ti.com>

Currently, the platform_bus allows customization of several of the
busses dev_pm_ops methods by using weak symbols so that platform code
can override them.  The weak-symbol approach is not scalable when
wanting to support multiple platforms in a single kernel binary.

Instead, provide __init methods for platform code to customize the
dev_pm_ops methods at runtime.

NOTE: after these dynamic methods are merged, the weak symbols should
      be removed from drivers/base/platform.c.  AFAIK, this will only
      affect SH and sh-mobile which should be converted to use this
      runtime approach instead of the weak symbols.  After SH &
      sh-mobile are converted, the weak symobols could be removed.

Tested on OMAP3.

Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/platform_device.h |    3 +++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 579906f..a01abf9 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -976,6 +976,41 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
+/**
+ * platform_bus_get_pm_ops() - return pointer to busses dev_pm_ops
+ *
+ * This function can be used by platform code to get the current
+ * set of dev_pm_ops functions used by the platform_bus_type.
+ */
+const struct dev_pm_ops * __init platform_bus_get_pm_ops(void)
+{
+	return platform_bus_type.pm;
+}
+
+/**
+ * platform_bus_set_pm_ops() - update dev_pm_ops for the platform_bus_type
+ *
+ * @pm: pointer to new dev_pm_ops struct to be used for platform_bus_type
+ *
+ * Platform code can override the dev_pm_ops methods of
+ * platform_bus_type by using this function.  It is expected that
+ * platform code will first do a platform_bus_get_pm_ops(), then
+ * kmemdup it, then customize selected methods and pass a pointer to
+ * the new struct dev_pm_ops to this function.
+ *
+ * Since platform-specific code is customizing methods for *all*
+ * devices (not just platform-specific devices) it is expected that
+ * any custom overrides of these functions will keep existing behavior
+ * and simply extend it.  For example, any customization of the
+ * runtime PM methods should continue to call the pm_generic_*
+ * functions as the default ones do in addition to the
+ * platform-specific behavior.
+ */
+void __init platform_bus_set_pm_ops(const struct dev_pm_ops *pm)
+{
+	platform_bus_type.pm = pm;
+}
+
 int __init platform_bus_init(void)
 {
 	int error;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index d7ecad0..2e700ec 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -138,6 +138,9 @@ extern struct platform_device *platform_create_bundle(struct platform_driver *dr
 					struct resource *res, unsigned int n_res,
 					const void *data, size_t size);
 
+extern const struct dev_pm_ops * platform_bus_get_pm_ops(void);
+extern void platform_bus_set_pm_ops(const struct dev_pm_ops *pm);
+
 /* early platform driver interface */
 struct early_platform_driver {
 	const char *class_str;
-- 
1.7.2

