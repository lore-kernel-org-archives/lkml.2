Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2LNLCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:02:42 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57172 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab2LNLCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:02:39 -0500
Subject: [PATCH 02/12] driver core: add debug-objects debug for device-drivers
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 14 Dec 2012 15:02:33 +0400
Message-ID: <20121214110232.11019.91506.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_OBJECTS_DRIVERS together with CONFIG_DEBUG_OBJECTS_FREE can catch
unloading device driver modules without proper unregistering.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/base/driver.c |   34 ++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug     |    7 +++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 974e301..7eec027 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -15,8 +15,40 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/debugobjects.h>
 #include "base.h"
 
+#ifdef CONFIG_DEBUG_OBJECTS_DRIVERS
+
+static void * debug_driver_hint(void *addr)
+{
+	struct device_driver *drv = addr;
+
+	return drv->probe;
+}
+
+struct debug_obj_descr driver_debug_descr = {
+	.name = "device_driver",
+	.debug_hint = debug_driver_hint,
+};
+
+static inline void debug_driver_register(struct device_driver *drv)
+{
+	debug_object_init(drv, &driver_debug_descr);
+	debug_object_activate(drv, &driver_debug_descr);
+}
+
+static inline void debug_driver_unregister(struct device_driver *drv)
+{
+	debug_object_deactivate(drv, &driver_debug_descr);
+	debug_object_free(drv, &driver_debug_descr);
+}
+
+#else /* CONFIG_DEBUG_OBJECTS_DRIVERS */
+static inline void debug_driver_register(struct device_driver *drv) { }
+static inline void debug_driver_unregister(struct device_driver *drv) { }
+#endif /* CONFIG_DEBUG_OBJECTS_DRIVERS */
+
 static struct device *next_device(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
@@ -190,6 +222,7 @@ int driver_register(struct device_driver *drv)
 		return ret;
 	}
 	kobject_uevent(&drv->p->kobj, KOBJ_ADD);
+	debug_driver_register(drv);
 
 	return ret;
 }
@@ -209,6 +242,7 @@ void driver_unregister(struct device_driver *drv)
 	}
 	driver_remove_groups(drv, drv->groups);
 	bus_remove_driver(drv);
+	debug_driver_unregister(drv);
 }
 EXPORT_SYMBOL_GPL(driver_unregister);
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3a35309..f5aee2d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -404,6 +404,13 @@ config DEBUG_OBJECTS_PERCPU_COUNTER
 	  percpu counter routines to track the life time of percpu counter
 	  objects and validate the percpu counter operations.
 
+config DEBUG_OBJECTS_DRIVERS
+	bool "Debug device driver objects"
+	depends on DEBUG_OBJECTS
+	help
+	  Enable this to turn on debugging device drivers structures. Together
+	  with DEBUG_OBJECTS_FREE this can catch freeing registered drivers.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1

