Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0HWPF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:05:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0HWPFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:05:52 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernen.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] driver core: platform_bus: allow runtime override of dev_pm_ops
Date: Mon, 23 Aug 2010 08:05:48 -0700
Message-Id: <1282575949-27826-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.2.1
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

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/base/platform.c         |   16 ++++++++++++++++
 include/linux/platform_device.h |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c6c933f..a7d8a00 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -976,6 +976,22 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
+const struct dev_pm_ops * __init platform_bus_get_pm_ops(void)
+{
+	struct bus_type *bus = &platform_bus_type;
+
+	return bus->pm;
+}
+
+int __init platform_bus_set_pm_ops(struct dev_pm_ops *pm)
+{
+	struct bus_type *bus = &platform_bus_type;
+
+	bus->pm = pm;
+
+	return 0;
+}
+
 int __init platform_bus_init(void)
 {
 	int error;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index d7ecad0..4bce2c9 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -138,6 +138,9 @@ extern struct platform_device *platform_create_bundle(struct platform_driver *dr
 					struct resource *res, unsigned int n_res,
 					const void *data, size_t size);
 
+extern const struct dev_pm_ops * __init platform_bus_get_pm_ops(void);
+extern int __init platform_bus_set_pm_ops(struct dev_pm_ops *pm);
+
 /* early platform driver interface */
 struct early_platform_driver {
 	const char *class_str;
-- 
1.7.2.1

