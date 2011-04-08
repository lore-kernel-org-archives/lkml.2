Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1DHAkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:40:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:23849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab1DHAkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:40:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,320,1299484800"; 
   d="scan'208";a="730593924"
Date: Fri, 8 Apr 2011 02:40:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>
Subject: [RFC] [PATCH] mfd: Fetch cell pointer from
 platform_device->mfd_cell
Message-ID: <20110408004007.GC3923@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In order for MFD drivers to fetch their cell pointer but also their
platform data one, an mfd cell pointer is added to the platform_device
structure.
That allows all MFD sub devices drivers to be MFD agnostic, unless
they really need to access their MFD cell data. Most of them don't,
especially the ones for IPs used by both MFD and non MFD SoCs.

Cc: Greg KH <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/base/platform.c         |    1 +
 drivers/mfd/mfd-core.c          |   16 ++++++++++++++--
 include/linux/mfd/core.h        |    8 ++++++--
 include/linux/platform_device.h |    5 +++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f051cff..6c3a2bd 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -149,6 +149,7 @@ static void platform_device_release(struct device *dev)
 
 	of_device_node_put(&pa->pdev.dev);
 	kfree(pa->pdev.dev.platform_data);
+	kfree(pa->pdev.mfd_cell);
 	kfree(pa->pdev.resource);
 	kfree(pa);
 }
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d01574d..f4c8c84 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -55,6 +55,19 @@ int mfd_cell_disable(struct platform_device *pdev)
 }
 EXPORT_SYMBOL(mfd_cell_disable);
 
+static int mfd_platform_add_cell(struct platform_device *pdev,
+				 const struct mfd_cell *cell)
+{
+	if (!cell)
+		return 0;
+
+	pdev->mfd_cell = kmemdup(cell, sizeof(*cell), GFP_KERNEL);
+	if (!pdev->mfd_cell)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int mfd_add_device(struct device *parent, int id,
 			  const struct mfd_cell *cell,
 			  struct resource *mem_base,
@@ -75,7 +88,7 @@ static int mfd_add_device(struct device *parent, int id,
 
 	pdev->dev.parent = parent;
 
-	ret = platform_device_add_data(pdev, cell, sizeof(*cell));
+	ret = mfd_platform_add_cell(pdev, cell);
 	if (ret)
 		goto fail_res;
 
@@ -123,7 +136,6 @@ static int mfd_add_device(struct device *parent, int id,
 
 	return 0;
 
-/*	platform_device_del(pdev); */
 fail_res:
 	kfree(res);
 fail_device:
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index ad1b19a..ee4731b 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -86,16 +86,20 @@ extern int mfd_clone_cell(const char *cell, const char **clones,
  */
 static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 {
-	return pdev->dev.platform_data;
+	return pdev->mfd_cell;
 }
 
 /*
  * Given a platform device that's been created by mfd_add_devices(), fetch
  * the .mfd_data entry from the mfd_cell that created it.
+ * Otherwise just return the platform_data pointer.
  */
 static inline void *mfd_get_data(struct platform_device *pdev)
 {
-	return mfd_get_cell(pdev)->mfd_data;
+	if (pdev->mfd_cell)
+		return mfd_get_cell(pdev)->mfd_data;
+	else
+		return pdev->dev.platform_data;
 }
 
 extern int mfd_add_devices(struct device *parent, int id,
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index d96db98..744942c 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -14,6 +14,8 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 
+struct mfd_cell;
+
 struct platform_device {
 	const char	* name;
 	int		id;
@@ -23,6 +25,9 @@ struct platform_device {
 
 	const struct platform_device_id	*id_entry;
 
+	/* MFD cell pointer */
+	struct mfd_cell *mfd_cell;
+
 	/* arch specific additions */
 	struct pdev_archdata	archdata;
 };
-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
