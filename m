Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab0HDMjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:39:54 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:34534 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab0HDMjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:39:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] RFC: AMBA bus discardable probe() function
Date: Wed, 4 Aug 2010 14:39:03 +0200
Message-ID: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fighting a compilation warning when using __init on probe():s in
the AMBA (PrimeCell) bus abstraction, the intended effect of
discarding AMBA probe():s is not achieveable without first adding
the amba_driver_probe() function akin to platform_driver_probe().

The latter does some extensive checks which I believe are
necessary to replicate, and leads to this nasty hack,
dereferencing structs from base/base.h like the platform bus does.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
I'm not sure about the proper way around this, Russell, David,
Dmitry, Greg et al, please indicate whether this is:

1) Desirable on the AMBA bus (I think so, actually all the AMBA
   devices that exist should be able to have their probe functions
   as __init() functions AFAICT, they're always embedded.)

2) Possible to do without the klist traversals, I'm not quite
   following under what circumstances this is really necessary.
   If this is just when device drivers spawn new devices then we
   might be able to do without (though in theory it'd be needed).

3) An indication that this private core stuff should somehow be
   accessible by derivative busses anyhow?

Yours,
Linus Walleij
---
 drivers/amba/bus.c       |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/spi/amba-pl022.c |    7 ++---
 include/linux/amba/bus.h |    3 ++
 3 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index d31590e..2a4c88f 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -18,6 +18,9 @@
 #include <asm/irq.h>
 #include <asm/sizes.h>
 
+/* Cross referencing the private driver core like the platform bus does */
+#include "../base/base.h"
+
 #define to_amba_device(d)	container_of(d, struct amba_device, dev)
 #define to_amba_driver(d)	container_of(d, struct amba_driver, drv)
 
@@ -223,6 +226,59 @@ void amba_driver_unregister(struct amba_driver *drv)
 	driver_unregister(&drv->drv);
 }
 
+static int amba_driver_probe_fail(struct device *_dev)
+{
+	return -ENXIO;
+}
+
+
+/**
+ * amba_driver_probe - register AMBA driver for non-hotpluggable device
+ * @drv: platform driver structure
+ * @probe: the driver probe routine, probably from an __init section
+ *
+ * Use this instead of amba_driver_register() when you know the device
+ * is not hotpluggable and has already been registered, and you want to
+ * remove its run-once probe() infrastructure from memory after the driver
+ * has bound to the device.
+ *
+ * One typical use for this would be with drivers for controllers integrated
+ * into system-on-chip processors, where the controller devices have been
+ * configured as part of board setup.
+ *
+ * Returns zero if the driver registered and bound to a device, else returns
+ * a negative error code and with the driver not registered.
+ */
+int __init_or_module amba_driver_probe(struct amba_driver *drv,
+		int (*probe)(struct amba_device *,
+		struct amba_id *))
+{
+	int retval, code;
+
+	/* make sure driver won't have bind/unbind attributes */
+	drv->drv.suppress_bind_attrs = true;
+
+	/* temporary section violation during probe() */
+	drv->probe = probe;
+	retval = code = amba_driver_register(drv);
+
+	/*
+	 * Fixup that section violation, being paranoid about code scanning
+	 * the list of drivers in order to probe new devices.  Check to see
+	 * if the probe was successful, and make sure any forced probes of
+	 * new devices fail.
+	 */
+	spin_lock(&amba_bustype.p->klist_drivers.k_lock);
+	drv->probe = NULL;
+	if (code == 0 && list_empty(&drv->drv.p->klist_devices.k_list))
+		retval = -ENODEV;
+	drv->drv.probe = amba_driver_probe_fail;
+	spin_unlock(&amba_bustype.p->klist_drivers.k_lock);
+
+	if (code != retval)
+		amba_driver_unregister(drv);
+	return retval;
+}
 
 static void amba_device_release(struct device *dev)
 {
@@ -442,6 +498,7 @@ void amba_release_regions(struct amba_device *dev)
 
 EXPORT_SYMBOL(amba_driver_register);
 EXPORT_SYMBOL(amba_driver_unregister);
+EXPORT_SYMBOL(amba_driver_probe);
 EXPORT_SYMBOL(amba_device_register);
 EXPORT_SYMBOL(amba_device_unregister);
 EXPORT_SYMBOL(amba_find_device);
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index f0a1418..28dd364 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -1969,16 +1969,15 @@ static struct amba_driver pl022_driver = {
 		.name	= "ssp-pl022",
 	},
 	.id_table	= pl022_ids,
-	.probe		= pl022_probe,
 	.remove		= __exit_p(pl022_remove),
-	.suspend        = pl022_suspend,
-	.resume         = pl022_resume,
+	.suspend	= pl022_suspend,
+	.resume		= pl022_resume,
 };
 
 
 static int __init pl022_init(void)
 {
-	return amba_driver_register(&pl022_driver);
+	return amba_driver_probe(&pl022_driver, pl022_probe);
 }
 
 module_init(pl022_init);
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index b0c1740..0d3d55f 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -58,6 +58,9 @@ enum amba_vendor {
 
 int amba_driver_register(struct amba_driver *);
 void amba_driver_unregister(struct amba_driver *);
+int amba_driver_probe(struct amba_driver *adrv,
+		      int (*probe)(struct amba_device *,
+				   struct amba_id *));
 int amba_device_register(struct amba_device *, struct resource *);
 void amba_device_unregister(struct amba_device *);
 struct amba_device *amba_find_device(const char *, struct device *, unsigned int, unsigned int);
-- 
1.6.3.3

