Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2BASjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:39:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47747 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2BASjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:39:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Frederic Lambert <frdrc66@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@sirena.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] drivercore: Output common devicetree information in uevent
Date: Wed,  1 Feb 2012 11:39:04 -0700
Message-Id: <1328121545-21955-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When userspace needs to find a specific device, it currently isn't easy to
resolve a /sys/devices/ path from a specific device tree node.  Nor is it
easy to obtain the compatible list for devices.

This patch generalizes the code that inserts OF_* values into the uevent
device attribute so that any device that is attached to an OF node will
have that information exported to userspace.  Without this patch only
platform devices and some powerpc-specific busses have access to this
data.

The original function also creates a MODALIAS property for the compatible
list, but that code has not been generalized into the common case because
it has the potential to break module loading on a lot of bus types.  Bus
types are still responsible for their own MODALIAS properties.

Boot tested on ARM and compile tested on PowerPC and SPARC.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Tobias Klauser <tklauser@distanz.ch>
Cc: Frederic Lambert <frdrc66@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Brown <broonie@sirena.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Resend: actually including the mailing lists this time and using an up-to-date
email address for Greg.

g.

 arch/powerpc/kernel/ibmebus.c  |    2 +-
 drivers/base/core.c            |    5 +++++
 drivers/base/platform.c        |    2 +-
 drivers/macintosh/macio_asic.c |    2 +-
 drivers/of/device.c            |   30 ++++++++++++++++--------------
 include/linux/of_device.h      |    8 ++++++--
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index d39ae60..79bb282 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -713,7 +713,7 @@ static struct dev_pm_ops ibmebus_bus_dev_pm_ops = {
 
 struct bus_type ibmebus_bus_type = {
 	.name      = "ibmebus",
-	.uevent    = of_device_uevent,
+	.uevent    = of_device_uevent_modalias,
 	.bus_attrs = ibmebus_bus_attrs,
 	.match     = ibmebus_bus_bus_match,
 	.probe     = ibmebus_bus_device_probe,
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4a67cc0..28d8c21 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -18,6 +18,8 @@
 #include <linux/string.h>
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
@@ -267,6 +269,9 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (dev->driver)
 		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
 
+	/* Add common DT information about the device */
+	of_device_uevent(dev, env);
+
 	/* have the bus specific function add its stuff */
 	if (dev->bus && dev->bus->uevent) {
 		retval = dev->bus->uevent(dev, env);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f0c605e..a1a7225 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -621,7 +621,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 	int rc;
 
 	/* Some devices have extra OF data and an OF-style MODALIAS */
-	rc = of_device_uevent(dev,env);
+	rc = of_device_uevent_modalias(dev,env);
 	if (rc != -ENODEV)
 		return rc;
 
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 4daf9e5..20e5c2c 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -137,7 +137,7 @@ extern struct device_attribute macio_dev_attrs[];
 struct bus_type macio_bus_type = {
        .name	= "macio",
        .match	= macio_bus_match,
-       .uevent = of_device_uevent,
+       .uevent = of_device_uevent_modalias,
        .probe	= macio_device_probe,
        .remove	= macio_device_remove,
        .shutdown = macio_device_shutdown,
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 62b4b32..4c74e4f 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -128,39 +128,41 @@ ssize_t of_device_get_modalias(struct device *dev, char *str, ssize_t len)
 /**
  * of_device_uevent - Display OF related uevent information
  */
-int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
+void of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	const char *compat;
 	int seen = 0, cplen, sl;
 
 	if ((!dev) || (!dev->of_node))
-		return -ENODEV;
-
-	if (add_uevent_var(env, "OF_NAME=%s", dev->of_node->name))
-		return -ENOMEM;
+		return;
 
-	if (add_uevent_var(env, "OF_TYPE=%s", dev->of_node->type))
-		return -ENOMEM;
+	add_uevent_var(env, "OF_NAME=%s", dev->of_node->name);
+	add_uevent_var(env, "OF_FULLNAME=%s", dev->of_node->full_name);
+	if (dev->of_node->type && strcmp("<NULL>", dev->of_node->type) != 0)
+		add_uevent_var(env, "OF_TYPE=%s", dev->of_node->type);
 
 	/* Since the compatible field can contain pretty much anything
 	 * it's not really legal to split it out with commas. We split it
 	 * up using a number of environment variables instead. */
-
 	compat = of_get_property(dev->of_node, "compatible", &cplen);
 	while (compat && *compat && cplen > 0) {
-		if (add_uevent_var(env, "OF_COMPATIBLE_%d=%s", seen, compat))
-			return -ENOMEM;
-
+		add_uevent_var(env, "OF_COMPATIBLE_%d=%s", seen, compat);
 		sl = strlen(compat) + 1;
 		compat += sl;
 		cplen -= sl;
 		seen++;
 	}
+	add_uevent_var(env, "OF_COMPATIBLE_N=%d", seen);
+}
 
-	if (add_uevent_var(env, "OF_COMPATIBLE_N=%d", seen))
-		return -ENOMEM;
+int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
+{
+	int sl;
+
+	if ((!dev) || (!dev->of_node))
+		return -ENODEV;
 
-	/* modalias is trickier, we add it in 2 steps */
+	/* Devicetree modalias is tricky, we add it in 2 steps */
 	if (add_uevent_var(env, "MODALIAS="))
 		return -ENOMEM;
 
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index ae56384..cbc4214 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -34,7 +34,8 @@ extern void of_device_unregister(struct platform_device *ofdev);
 extern ssize_t of_device_get_modalias(struct device *dev,
 					char *str, ssize_t len);
 
-extern int of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
+extern void of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
+extern int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env);
 
 static inline void of_device_node_put(struct device *dev)
 {
@@ -49,7 +50,10 @@ static inline int of_driver_match_device(struct device *dev,
 	return 0;
 }
 
-static inline int of_device_uevent(struct device *dev,
+static inline void of_device_uevent(struct device *dev,
+			struct kobj_uevent_env *env) { }
+
+static inline int of_device_uevent_modalias(struct device *dev,
 				   struct kobj_uevent_env *env)
 {
 	return -ENODEV;
-- 
1.7.5.4

