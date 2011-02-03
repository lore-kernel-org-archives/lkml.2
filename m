Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1BCEWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:22:38 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53538 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1BCEWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:22:37 -0500
Date: Wed, 2 Feb 2011 20:22:34 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 17/19] mfd-core: add refcounting support to mfd_cells
Message-ID: <20110202202234.37e741f2@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This provides convenience functions for sharing of cells across
multiple mfd clients.  Mfd drivers can provide enable/disable hooks
to actually tweak the hardware, and clients can call
mfd_shared_cell_{en,dis}able without having to worry about whether
or not another client happens to have enabled or disabled the
cell/hardware.

Note that this is purely optional; drivers can continue to use
the mfd_cell's enable/disable hooks for their own purposes, if
desired.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |   51 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/mfd/core.h |   14 +++++++++++-
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d8b9e35..90e9483 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -18,6 +18,30 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
+int mfd_shared_cell_enable(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+
+	/* only call enable if the cell hasn't already been enabled */
+	if (atomic_inc_return(cell->usage_count) > 1)
+		return 0;
+
+	return cell->enable(pdev);
+}
+EXPORT_SYMBOL(mfd_shared_cell_enable);
+
+int mfd_shared_cell_disable(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+
+	/* only disable if no other clients are using it */
+	if (atomic_dec_return(cell->usage_count) != 0)
+		return 0;
+
+	return cell->disable(pdev);
+}
+EXPORT_SYMBOL(mfd_shared_cell_disable);
+
 static int mfd_add_device(struct device *parent, int id,
 			  const struct mfd_cell *cell,
 			  struct resource *mem_base,
@@ -97,14 +121,22 @@ fail_alloc:
 }
 
 int mfd_add_devices(struct device *parent, int id,
-		    const struct mfd_cell *cells, int n_devs,
+		    struct mfd_cell *cells, int n_devs,
 		    struct resource *mem_base,
 		    int irq_base)
 {
 	int i;
 	int ret = 0;
+	atomic_t *cnts;
+
+	/* initialize reference counting for all cells */
+	cnts = kcalloc(sizeof(*cnts), n_devs, GFP_KERNEL);
+	if (!cnts)
+		return -ENOMEM;
 
 	for (i = 0; i < n_devs; i++) {
+		atomic_set(&cnts[i], 0);
+		cells[i].usage_count = &cnts[i];
 		ret = mfd_add_device(parent, id, cells + i, mem_base, irq_base);
 		if (ret)
 			break;
@@ -117,15 +149,26 @@ int mfd_add_devices(struct device *parent, int id,
 }
 EXPORT_SYMBOL(mfd_add_devices);
 
-static int mfd_remove_devices_fn(struct device *dev, void *unused)
+static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	platform_device_unregister(to_platform_device(dev));
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	atomic_t **usage_count = c;
+
+	/* find the lowest address of usage_count pointers (for freeing) */
+	if (!*usage_count || (cell->usage_count < *usage_count))
+		*usage_count = cell->usage_count;
+
+	platform_device_unregister(pdev);
 	return 0;
 }
 
 void mfd_remove_devices(struct device *parent)
 {
-	device_for_each_child(parent, NULL, mfd_remove_devices_fn);
+	atomic_t *cnts = NULL;
+
+	device_for_each_child(parent, &cnts, mfd_remove_devices_fn);
+	kfree(cnts);
 }
 EXPORT_SYMBOL(mfd_remove_devices);
 
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index c74089e..d13b992 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -25,8 +25,11 @@ struct mfd_cell {
 	const char		*name;
 	int			id;
 
+	/* refcounting for multiple drivers to use a single cell */
+	atomic_t		*usage_count;
 	int			(*enable)(struct platform_device *dev);
 	int			(*disable)(struct platform_device *dev);
+
 	int			(*suspend)(struct platform_device *dev);
 	int			(*resume)(struct platform_device *dev);
 
@@ -51,6 +54,15 @@ struct mfd_cell {
 };
 
 /*
+ * Convenience functions for clients using shared cells.  Refcounting
+ * happens automatically, with the cell's enable/disable callbacks
+ * being called only when a device is first being enabled or no other
+ * clients are making use of it.
+ */
+extern int mfd_shared_cell_enable(struct platform_device *pdev);
+extern int mfd_shared_cell_disable(struct platform_device *pdev);
+
+/*
  * Given a platform device that's been created by mfd_add_devices(), fetch
  * the mfd_cell that created it.
  */
@@ -60,7 +72,7 @@ static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 }
 
 extern int mfd_add_devices(struct device *parent, int id,
-			   const struct mfd_cell *cells, int n_devs,
+			   struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,
 			   int irq_base);
 
-- 
1.7.2.3

