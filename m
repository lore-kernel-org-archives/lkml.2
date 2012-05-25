Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2EYIFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:05:49 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:43364 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab2EYIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:05:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAIo8v09bdWOb/2dsb2JhbABEtRCBB4JDUoE+E4gRu0iQRwOVGI9wgmI
X-IronPort-AV: E=Sophos;i="4.75,655,1330902000"; 
   d="scan'208";a="995215616"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Staging: ipack: use idr interface for numbering buses
Date: Fri, 25 May 2012 10:03:01 +0200
Message-Id: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use idr interface to give the bus number. That way, we remove the
limitation of 64 buses.

The mutex is removed because the ida interface uses spinlocks inside, so it is
not needed an extra lock.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index e6dc21a..e97be99 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -12,22 +12,14 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 #include "ipack.h"
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
 #define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)
 
-/* used when allocating bus numbers */
-#define IPACK_MAXBUS              64
-
-static DEFINE_MUTEX(ipack_mutex);
-
-struct ipack_busmap {
-	unsigned long busmap[IPACK_MAXBUS / (8*sizeof(unsigned long))];
-};
-static struct ipack_busmap busmap;
+static DEFINE_IDA(ipack_ida);
 
 static void ipack_device_release(struct device *dev)
 {
@@ -79,26 +71,6 @@ static struct bus_type ipack_bus_type = {
 	.remove = ipack_bus_remove,
 };
 
-static int ipack_assign_bus_number(void)
-{
-	int busnum;
-
-	mutex_lock(&ipack_mutex);
-	busnum = find_next_zero_bit(busmap.busmap, IPACK_MAXBUS, 1);
-
-	if (busnum >= IPACK_MAXBUS) {
-		pr_err("too many buses\n");
-		busnum = -1;
-		goto error_find_busnum;
-	}
-
-	set_bit(busnum, busmap.busmap);
-
-error_find_busnum:
-	mutex_unlock(&ipack_mutex);
-	return busnum;
-}
-
 struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
 					    struct ipack_bus_ops *ops)
 {
@@ -109,7 +81,7 @@ struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
 	if (!bus)
 		return NULL;
 
-	bus_nr = ipack_assign_bus_number();
+	bus_nr = ida_simple_get(&ipack_ida, 0, 0, GFP_KERNEL);
 	if (bus_nr < 0) {
 		kfree(bus);
 		return NULL;
@@ -125,9 +97,7 @@ EXPORT_SYMBOL_GPL(ipack_bus_register);
 
 int ipack_bus_unregister(struct ipack_bus_device *bus)
 {
-	mutex_lock(&ipack_mutex);
-	clear_bit(bus->bus_nr, busmap.busmap);
-	mutex_unlock(&ipack_mutex);
+	ida_simple_remove(&ipack_ida, bus->bus_nr);
 	kfree(bus);
 	return 0;
 }
@@ -189,12 +159,14 @@ EXPORT_SYMBOL_GPL(ipack_device_unregister);
 
 static int __init ipack_init(void)
 {
+	ida_init(&ipack_ida);
 	return bus_register(&ipack_bus_type);
 }
 
 static void __exit ipack_exit(void)
 {
 	bus_unregister(&ipack_bus_type);
+	ida_destroy(&ipack_ida);
 }
 
 module_init(ipack_init);
-- 
1.7.10

