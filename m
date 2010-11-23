Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0KWPiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:38:04 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43173 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0KWPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:38:01 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>, Simon Que <sque@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH v2 4/4] omap: add hwspinlock device
Date: Tue, 23 Nov 2010 17:39:00 +0200
Message-Id: <1290526740-27624-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290526740-27624-1-git-send-email-ohad@wizery.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Que <sque@ti.com>

Build and register an hwspinlock platform device.

Although only OMAP4 supports the hardware spinlock module (for now),
it is still safe to run this initcall on all omaps, because hwmod lookup
will simply fail on hwspinlock-less platforms.

Signed-off-by: Simon Que <sque@ti.com>
Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/Makefile     |    1 +
 arch/arm/mach-omap2/hwspinlock.c |   63 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/hwspinlock.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index ce7b1f0..5162665 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -197,3 +197,4 @@ obj-y					+= $(smc91x-m) $(smc91x-y)
 
 smsc911x-$(CONFIG_SMSC911X)		:= gpmc-smsc911x.o
 obj-y					+= $(smsc911x-m) $(smsc911x-y)
+obj-$(CONFIG_ARCH_OMAP4)		+= hwspinlock.o
diff --git a/arch/arm/mach-omap2/hwspinlock.c b/arch/arm/mach-omap2/hwspinlock.c
new file mode 100644
index 0000000..06d4a80
--- /dev/null
+++ b/arch/arm/mach-omap2/hwspinlock.c
@@ -0,0 +1,63 @@
+/*
+ * OMAP hardware spinlock device initialization
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Contact: Simon Que <sque@ti.com>
+ *          Hari Kanigeri <h-kanigeri2@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+
+#include <plat/omap_hwmod.h>
+#include <plat/omap_device.h>
+
+struct omap_device_pm_latency omap_spinlock_latency[] = {
+	{
+		.deactivate_func = omap_device_idle_hwmods,
+		.activate_func   = omap_device_enable_hwmods,
+		.flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
+	}
+};
+
+int __init hwspinlocks_init(void)
+{
+	int retval = 0;
+	struct omap_hwmod *oh;
+	struct omap_device *od;
+	const char *oh_name = "spinlock";
+	const char *dev_name = "omap_hwspinlock";
+
+	/*
+	 * Hwmod lookup will fail in case our platform doesn't support the
+	 * hardware spinlock module, so it is safe to run this initcall
+	 * on all omaps
+	 */
+	oh = omap_hwmod_lookup(oh_name);
+	if (oh == NULL)
+		return -EINVAL;
+
+	od = omap_device_build(dev_name, 0, oh, NULL, 0,
+				omap_spinlock_latency,
+				ARRAY_SIZE(omap_spinlock_latency), false);
+	if (IS_ERR(od)) {
+		pr_err("Can't build omap_device for %s:%s\n", dev_name,
+								oh_name);
+		retval = PTR_ERR(od);
+	}
+
+	return retval;
+}
+/* early board code might need to reserve specific hwspinlock instances */
+postcore_initcall(hwspinlocks_init);
-- 
1.7.0.4

