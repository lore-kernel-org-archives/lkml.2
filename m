Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1BRDH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:07:59 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51789 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1BRDHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:07:54 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/29] mfd-core: unconditionally add mfd_cell to every platform_device
Date: Thu, 17 Feb 2011 19:07:09 -0800
Message-Id: <1297998456-7615-3-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, one would set the mfd_cell's platform_data/data_size to point
to the current mfd_cell in order to pass that information along to drivers.

This causes the current mfd_cell to always be available to drivers.  It
also adds a wrapper function for fetching the mfd cell from a platform
device, similar to what originally existed for mfd devices.

Drivers who previously used platform_data for other purposes can still
use it; the difference is that mfd_get_data() must be used to
access it (and the pdata structure is no longer allocated in
mfd_add_devices).

Note that mfd_get_data is intentionally vague (in name) about where
the data is stored; variable name changes can come later without having
to touch brazillions of drivers.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |    9 +++------
 include/linux/mfd/core.h |   23 +++++++++++++++++++++--
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d83ad0f..21a39dc 100644
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
+	ret = platform_device_add_data(pdev, cell, sizeof(*cell));
+	if (ret)
+		goto fail_res;
 
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 1fd7c44..aefc378 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -33,9 +33,10 @@ struct mfd_cell {
 	/* driver-specific data for MFD-aware "cell" drivers */
 	void			*driver_data;
 
-	/* platform_data can be used to either pass data to "generic"
-	   driver or as a hook to mfd_cell for the "cell" drivers */
+	/* platform_data can be used to pass data to "generic" drivers */
 	void			*platform_data;
+
+	/* unused */
 	size_t			data_size;
 
 	/*
@@ -55,6 +56,24 @@ struct mfd_cell {
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
+/*
+ * Given a platform device that's been created by mfd_add_devices(), fetch
+ * the .platform_data entry from the mfd_cell that created it.
+ */
+static inline void *mfd_get_data(struct platform_device *pdev)
+{
+	return mfd_get_cell(pdev)->platform_data;
+}
+
 extern int mfd_add_devices(struct device *parent, int id,
 			   const struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,
-- 
1.7.2.3

