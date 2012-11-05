Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2KENsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:48:31 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:49583 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab2KENsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:48:30 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: linus.walleij@linaro.org
Cc: poeschel@lemonage.de, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
Subject: [PATCH v3 1/5] mfd: set device type of mfd platform devices to a mfd type
Date: Mon,  5 Nov 2012 15:48:22 +0100
Message-Id: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This sets the type of the platform devices that are added
to the mfd core to some mfd-cell type. This enables us
to add mfd cells to platform devices, that are in use by
other cores (e.g. the usb core).
Otherwise by removing the mfd cell from a platform device
that already has some "childs" would remove all childs,
not only the mfd ones.
Thanks to Lars-Peter Clausen for proposing this.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/mfd/mfd-core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f8b7771..d317b50 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -21,6 +21,10 @@
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 
+static struct device_type const mfd_device_type = {
+	.name = "mfd-cell",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -91,6 +95,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_device_type;
 
 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
@@ -204,10 +209,16 @@ EXPORT_SYMBOL(mfd_add_devices);
 
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct platform_device *pdev;
+	const struct mfd_cell *cell;
 	atomic_t **usage_count = c;
 
+	if (dev->type != &mfd_device_type)
+		return 0;
+
+	pdev = to_platform_device(dev);
+	cell = mfd_get_cell(pdev);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
-- 
1.7.10.4

