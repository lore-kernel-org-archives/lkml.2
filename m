Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2L1TeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:34:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55479 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299Ab2L1TTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:08 -0500
Message-Id: <20121228190345.029274542@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Peter Tyser <ptyser@xes-inc.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 071/173] mfd: Only unregister platform devices allocated by the mfd core
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit b9fbb62eb61452d728c39b2e5020739c575aac53 upstream.

mfd_remove_devices would iterate over all devices sharing a parent with
an mfd device regardless of whether they were allocated by the mfd core
or not. This especially caused problems when the device structure was
not contained within a platform_device, because to_platform_device is
used on each device pointer.

This patch defines a device_type for mfd devices and checks this is
present from mfd_remove_devices_fn before processing the device.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Tested-by: Peter Tyser <ptyser@xes-inc.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/mfd-core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -19,6 +19,10 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
+static struct device_type mfd_dev_type = {
+	.name	= "mfd_device",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -88,6 +92,7 @@ static int mfd_add_device(struct device
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_dev_type;
 
 	if (cell->pdata_size) {
 		ret = platform_device_add_data(pdev,
@@ -183,10 +188,16 @@ EXPORT_SYMBOL(mfd_add_devices);
 
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct platform_device *pdev;
+	const struct mfd_cell *cell;
 	atomic_t **usage_count = c;
 
+	if (dev->type != &mfd_dev_type)
+		return 0;
+
+	pdev = to_platform_device(dev);
+	cell = mfd_get_cell(pdev);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;


