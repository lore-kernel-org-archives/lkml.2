Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1BCD4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 22:56:01 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56862 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1BCD4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 22:56:00 -0500
Date: Wed, 2 Feb 2011 19:55:56 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/19] mfd-core: unconditionally add mfd_cell to every
 platform_device
Message-ID: <20110202195556.3e947297@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously, one would set the mfd_cell's platform_data/data_size to point
to the current mfd_cell in order to pass that information along to drivers.

This causes the current mfd_cell to always be available to drivers.  It
also adds a wrapper function for fetching the mfd cell from a platform
device.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |    9 +++------
 include/linux/mfd/core.h |   12 ++++++++++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d83ad0f..d8b9e35 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -39,12 +39,9 @@ static int mfd_add_device(struct device *parent, int id,
 	pdev->dev.parent = parent;
 	platform_set_drvdata(pdev, cell->driver_data);
 
-	if (cell->data_size) {
-		ret = platform_device_add_data(pdev,
-					cell->platform_data, cell->data_size);
-		if (ret)
-			goto fail_res;
-	}
+	ret = platform_device_add_data(pdev, cell, sizeof(struct mfd_cell));
+	if (ret)
+		goto fail_res;
 
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 835996e..82b2a5c 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -33,8 +33,7 @@ struct mfd_cell {
 	/* driver-specific data for MFD-aware "cell" drivers */
 	void			*driver_data;
 
-	/* platform_data can be used to either pass data to "generic"
-	   driver or as a hook to mfd_cell for the "cell" drivers */
+	/* These two are unused */
 	void			*platform_data;
 	size_t			data_size;
 
@@ -55,6 +54,15 @@ struct mfd_cell {
 	bool			pm_runtime_no_callbacks;
 };
 
+/*
+ * Given a platform device that's been created by mfd_add_devices(), fetch
+ * the mfd_cell that created it.
+ */
+static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
+{
+	return pdev->dev.platform_data;
+}
+
 extern int mfd_add_devices(struct device *parent, int id,
 			   const struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,
-- 
1.7.2.3

