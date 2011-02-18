Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1BRDKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:10:22 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51916 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534Ab1BRDIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:18 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/29] mfd-core: add refcounting support to mfd_cells (v2)
Date: Thu, 17 Feb 2011 19:07:34 -0800
Message-Id: <1297998456-7615-28-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
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

v2: modify mfd_shared_cell_enable/disable to only modify refcount
if the hook call succeeds.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |   64 +++++++++++++++++++++++++++++++++++++++++++---
 include/linux/mfd/core.h |   14 +++++++++-
 2 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 01115f6..ca789f8 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -18,6 +18,43 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
+int mfd_shared_cell_enable(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	int err = 0;
+
+	/* only call enable hook if the cell wasn't previously enabled */
+	if (atomic_inc_return(cell->usage_count) == 1)
+		err = cell->enable(pdev);
+
+	/* if the enable hook failed, decrement counter to allow retries */
+	if (err)
+		atomic_dec(cell->usage_count);
+
+	return err;
+}
+EXPORT_SYMBOL(mfd_shared_cell_enable);
+
+int mfd_shared_cell_disable(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	int err = 0;
+
+	/* only disable if no other clients are using it */
+	if (atomic_dec_return(cell->usage_count) == 0)
+		err = cell->disable(pdev);
+
+	/* if the disable hook failed, increment to allow retries */
+	if (err)
+		atomic_inc(cell->usage_count);
+
+	/* sanity check; did someone call disable too many times? */
+	WARN_ON(atomic_read(cell->usage_count) < 0);
+
+	return err;
+}
+EXPORT_SYMBOL(mfd_shared_cell_disable);
+
 static int mfd_add_device(struct device *parent, int id,
 			  const struct mfd_cell *cell,
 			  struct resource *mem_base,
@@ -96,14 +133,22 @@ fail_alloc:
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
@@ -116,15 +161,26 @@ int mfd_add_devices(struct device *parent, int id,
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
+	/* find the base address of usage_count pointers (for freeing) */
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
index 71cd1f9..22a2f5e 100644
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
@@ -69,7 +81,7 @@ static inline void *mfd_get_data(struct platform_device *pdev)
 }
 
 extern int mfd_add_devices(struct device *parent, int id,
-			   const struct mfd_cell *cells, int n_devs,
+			   struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,
 			   int irq_base);
 
-- 
1.7.2.3

