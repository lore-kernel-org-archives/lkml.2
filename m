Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1ILQrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:47:51 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62124 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1ILQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:47:49 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 04/10] hwspinlock/core/omap: fix id issues on multiple hwspinlock devices
Date: Mon, 12 Sep 2011 19:46:59 +0300
Message-Id: <1315846025-11453-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwspinlock devices provide system-wide hardware locks that are used
by remote processors that have no other way to achieve synchronization.

For that to work, each physical lock must have a system-wide unique id
number that all processors are familiar with, otherwise they can't
possibly assume they're using the same hardware lock.

Usually SoCs have a single hwspinlock device, which provides several
hwspinlocks, and in this case, they can be trivially numbered 0 to
(num-of-locks - 1).

In case boards have several hwspinlocks devices (each of which
providing numerous hardware spinlocks) a different base id should be
used for each hwspinlock device (they can't all use 0 as a starting
id!).

While this is certainly not common, it's just plain wrong to just
silently use 0 as a base id whenever the hwspinlock driver is probed.

This patch provides a hwspinlock_pdata structure, that boards can use
to set a different base id for each of the hwspinlock devices they may
have, and demonstrates how to use it with the omap hwspinlock driver
(ultimately it will be DT which will supply this base_id information).

While we're at it, make sure the hwspinlock core prints an explicit
error message in case an hwspinlock is registered with an id number
that already exists; this will help users catch such base id issues.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-omap2/hwspinlock.c     |    8 +++++++-
 drivers/hwspinlock/hwspinlock_core.c |    2 ++
 drivers/hwspinlock/omap_hwspinlock.c |    6 +++++-
 include/linux/hwspinlock.h           |   28 ++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/hwspinlock.c b/arch/arm/mach-omap2/hwspinlock.c
index 06d4a80..eb7e509 100644
--- a/arch/arm/mach-omap2/hwspinlock.c
+++ b/arch/arm/mach-omap2/hwspinlock.c
@@ -19,10 +19,15 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/hwspinlock.h>
 
 #include <plat/omap_hwmod.h>
 #include <plat/omap_device.h>
 
+static struct hwspinlock_pdata omap_hwspinlock_pdata __initdata = {
+	.base_id = 0,
+};
+
 struct omap_device_pm_latency omap_spinlock_latency[] = {
 	{
 		.deactivate_func = omap_device_idle_hwmods,
@@ -48,7 +53,8 @@ int __init hwspinlocks_init(void)
 	if (oh == NULL)
 		return -EINVAL;
 
-	od = omap_device_build(dev_name, 0, oh, NULL, 0,
+	od = omap_device_build(dev_name, 0, oh, &omap_hwspinlock_pdata,
+				sizeof(struct hwspinlock_pdata),
 				omap_spinlock_latency,
 				ARRAY_SIZE(omap_spinlock_latency), false);
 	if (IS_ERR(od)) {
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index af5175c..4eb85b4 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -282,6 +282,8 @@ int hwspin_lock_register(struct hwspinlock *hwlock)
 	spin_lock(&hwspinlock_tree_lock);
 
 	ret = radix_tree_insert(&hwspinlock_tree, hwlock->id, hwlock);
+	if (ret == -EEXIST)
+		pr_err("hwspinlock id %d already exists!\n", hwlock->id);
 	if (ret)
 		goto out;
 
diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index d058348..2044d18 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -94,12 +94,16 @@ static const struct hwspinlock_ops omap_hwspinlock_ops = {
 
 static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 {
+	struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
 	struct omap_hwspinlock *omap_lock;
 	struct omap_hwspinlock_state *state;
 	struct resource *res;
 	void __iomem *io_base;
 	int i, ret;
 
+	if (!pdata)
+		return -ENODEV;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
@@ -141,7 +145,7 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 		omap_lock = &state->lock[i];
 
 		omap_lock->lock.dev = &pdev->dev;
-		omap_lock->lock.id = i;
+		omap_lock->lock.id = pdata->base_id + i;
 		omap_lock->lock.ops = &omap_hwspinlock_ops;
 		omap_lock->addr = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index 8390efc..f85cef5 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -27,6 +27,34 @@
 
 struct hwspinlock;
 
+/**
+ * struct hwspinlock_pdata - platform data for hwspinlock drivers
+ * @base_id: base id for this hwspinlock device
+ *
+ * hwspinlock devices provide system-wide hardware locks that are used
+ * by remote processors that have no other way to achieve synchronization.
+ *
+ * To achieve that, each physical lock must have a system-wide id number
+ * that is agreed upon, otherwise remote processors can't possibly assume
+ * they're using the same hardware lock.
+ *
+ * Usually boards have a single hwspinlock device, which provides several
+ * hwspinlocks, and in this case, they can be trivially numbered 0 to
+ * (num-of-locks - 1).
+ *
+ * In case boards have several hwspinlocks devices, a different base id
+ * should be used for each hwspinlock device (they can't all use 0 as
+ * a starting id!).
+ *
+ * This platform data structure should be used to provide the base id
+ * for each device (which is trivially 0 when only a single hwspinlock
+ * device exists). It can be shared between different platforms, hence
+ * its location.
+ */
+struct hwspinlock_pdata {
+	int base_id;
+};
+
 #if defined(CONFIG_HWSPINLOCK) || defined(CONFIG_HWSPINLOCK_MODULE)
 
 int hwspin_lock_register(struct hwspinlock *lock);
-- 
1.7.4.1

