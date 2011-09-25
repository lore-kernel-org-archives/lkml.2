Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1IYLBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:01:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1IYLBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:01:36 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Cousson Benoit <b-cousson@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 2/5] ARM: OMAP: omap_device: add a method to set iommu private archdata
Date: Sun, 25 Sep 2011 13:58:54 +0300
Message-Id: <1316948337-7924-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316948337-7924-1-git-send-email-ohad@wizery.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to set an iommu private archdata before a newly-created
omap device is registered.

Binding iommu client devices with their respective iommu data this way
is needed so the generic IOMMU API can later be used without employing
any omap-specific IOMMU plumbing.

This patch just crudely adds an omap_device_build_ss_ext() method which
accepts an iommu private data, but we may actually want to do something
more generic here: e.g., split the omap_device_build API to alloc+add
methods, so users can just manipulate the device as needed before it is
registered (very much like we can do with plain devices).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
---
This is obviously not yet based on Benoit's recent changes; I'll do so after
we'll settle on the approach we want to take here.

 arch/arm/plat-omap/include/plat/omap_device.h |    6 ++++
 arch/arm/plat-omap/omap_device.c              |   39 +++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap_device.h b/arch/arm/plat-omap/include/plat/omap_device.h
index ee405b36..a3f672c 100644
--- a/arch/arm/plat-omap/include/plat/omap_device.h
+++ b/arch/arm/plat-omap/include/plat/omap_device.h
@@ -102,6 +102,12 @@ struct omap_device *omap_device_build_ss(const char *pdev_name, int pdev_id,
 					 void *pdata, int pdata_len,
 					 struct omap_device_pm_latency *pm_lats,
 					 int pm_lats_cnt, int is_early_device);
+struct omap_device *omap_device_build_ss_ext(const char *pdev_name, int pdev_id,
+					 struct omap_hwmod **ohs, int oh_cnt,
+					 void *pdata, int pdata_len,
+					 struct omap_device_pm_latency *pm_lats,
+					 int pm_lats_cnt, int is_early_device,
+					 void *iommu);
 
 int omap_device_register(struct omap_device *od);
 int omap_early_device_register(struct omap_device *od);
diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index 02609ee..38bc753 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -422,7 +422,8 @@ struct omap_device *omap_device_build(const char *pdev_name, int pdev_id,
 }
 
 /**
- * omap_device_build_ss - build and register an omap_device with multiple hwmods
+ * omap_device_build_ss_ext - build and register an omap_device with multiple
+ *				hwmods and an optional private iommu data
  * @pdev_name: name of the platform_device driver to use
  * @pdev_id: this platform_device's connection ID
  * @oh: ptr to the single omap_hwmod that backs this omap_device
@@ -431,6 +432,7 @@ struct omap_device *omap_device_build(const char *pdev_name, int pdev_id,
  * @pm_lats: pointer to a omap_device_pm_latency array for this device
  * @pm_lats_cnt: ARRAY_SIZE() of @pm_lats
  * @is_early_device: should the device be registered as an early device or not
+ * @iommu: private iommu data to be placed in dev_archdata
  *
  * Convenience function for building and registering an omap_device
  * subsystem record.  Subsystem records consist of multiple
@@ -438,11 +440,12 @@ struct omap_device *omap_device_build(const char *pdev_name, int pdev_id,
  * platform_device record.  Returns an ERR_PTR() on error, or passes
  * along the return value of omap_device_register().
  */
-struct omap_device *omap_device_build_ss(const char *pdev_name, int pdev_id,
+struct omap_device *omap_device_build_ss_ext(const char *pdev_name, int pdev_id,
 					 struct omap_hwmod **ohs, int oh_cnt,
 					 void *pdata, int pdata_len,
 					 struct omap_device_pm_latency *pm_lats,
-					 int pm_lats_cnt, int is_early_device)
+					 int pm_lats_cnt, int is_early_device,
+					 void *iommu)
 {
 	int ret = -ENOMEM;
 	struct omap_device *od;
@@ -500,6 +503,8 @@ struct omap_device *omap_device_build_ss(const char *pdev_name, int pdev_id,
 	od->pm_lats = pm_lats;
 	od->pm_lats_cnt = pm_lats_cnt;
 
+	od->pdev.dev.archdata.iommu = iommu;
+
 	if (is_early_device)
 		ret = omap_early_device_register(od);
 	else
@@ -530,6 +535,34 @@ odbs_exit1:
 }
 
 /**
+ * omap_device_build_ss - build and register an omap_device with multiple hwmods
+ * @pdev_name: name of the platform_device driver to use
+ * @pdev_id: this platform_device's connection ID
+ * @oh: ptr to the single omap_hwmod that backs this omap_device
+ * @pdata: platform_data ptr to associate with the platform_device
+ * @pdata_len: amount of memory pointed to by @pdata
+ * @pm_lats: pointer to a omap_device_pm_latency array for this device
+ * @pm_lats_cnt: ARRAY_SIZE() of @pm_lats
+ * @is_early_device: should the device be registered as an early device or not
+ *
+ * Convenience function for building and registering an omap_device
+ * subsystem record.  Subsystem records consist of multiple
+ * omap_hwmods.  This function in turn builds and registers a
+ * platform_device record.  Returns an ERR_PTR() on error, or passes
+ * along the return value of omap_device_register().
+ */
+struct omap_device *omap_device_build_ss(const char *pdev_name, int pdev_id,
+					 struct omap_hwmod **ohs, int oh_cnt,
+					 void *pdata, int pdata_len,
+					 struct omap_device_pm_latency *pm_lats,
+					 int pm_lats_cnt, int is_early_device)
+{
+	return omap_device_build_ss_ext(pdev_name, pdev_id, ohs, oh_cnt,
+			pdata, pdata_len, pm_lats, pm_lats_cnt,
+			is_early_device, NULL);
+}
+
+/**
  * omap_early_device_register - register an omap_device as an early platform
  * device.
  * @od: struct omap_device * to register
-- 
1.7.4.1

