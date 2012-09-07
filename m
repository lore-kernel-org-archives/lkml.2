Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2IGPWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:22:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab2IGPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:22:31 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 6/7] drm/pci: Add drm_put_pci_dev()
Date: Fri,  7 Sep 2012 10:22:09 -0500
Message-Id: <1347031330-19657-7-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
References: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When deferred initialization support for pci devices is added some
additional cleanup will be needed. Add a pci-specific put function to
serve this purpose, and convert the pci drivers over to using it. For
now it just calls drm_put_dev(), so this commit has no functional
change.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/ast/ast_drv.c         |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c   |    2 +-
 drivers/gpu/drm/drm_pci.c             |    8 +++++++-
 drivers/gpu/drm/gma500/psb_drv.c      |    2 +-
 drivers/gpu/drm/i915/i915_drv.c       |    2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c   |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    2 +-
 include/drm/drmP.h                    |    1 +
 10 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index d0c4574..001298d 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -72,7 +72,7 @@ ast_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 
diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 7053140..c7ca02b 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -64,7 +64,7 @@ static void cirrus_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 static const struct file_operations cirrus_driver_fops = {
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 5320364..55eb824 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -388,6 +388,12 @@ err_g1:
 }
 EXPORT_SYMBOL(drm_get_pci_dev);
 
+void drm_put_pci_dev(struct drm_device *dev)
+{
+	drm_put_dev(dev);
+}
+EXPORT_SYMBOL(drm_put_pci_dev);
+
 /**
  * PCI device initialization. Called direct from modules at load time.
  *
@@ -460,7 +466,7 @@ void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
 		pci_unregister_driver(pdriver);
 	} else {
 		list_for_each_entry_safe(dev, tmp, &driver->device_list, driver_item)
-			drm_put_dev(dev);
+			drm_put_pci_dev(dev);
 	}
 	DRM_INFO("Module unloaded\n");
 }
diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 0c47374..d7c3c9c 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -585,7 +585,7 @@ static void psb_driver_preclose(struct drm_device *dev, struct drm_file *priv)
 static void psb_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 static const struct dev_pm_ops psb_pm_ops = {
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index a24ffbe..86ae5a2 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -856,7 +856,7 @@ i915_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 static int i915_pm_suspend(struct device *dev)
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.c b/drivers/gpu/drm/mgag200/mgag200_drv.c
index ea1024d..a3b0a4a 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -73,7 +73,7 @@ static void mga_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 static const struct file_operations mgag200_driver_fops = {
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 9a36f5f..b74b02a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -168,7 +168,7 @@ nouveau_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 int
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 8c593ea..05d2ebc 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -310,7 +310,7 @@ radeon_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 static int
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 4d9edea..cf901cc 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -982,7 +982,7 @@ static void vmw_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	drm_put_dev(dev);
+	drm_put_pci_dev(dev);
 }
 
 static int vmwgfx_pm_notifier(struct notifier_block *nb, unsigned long val,
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index d6b67bb..eb99e96 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1748,6 +1748,7 @@ extern void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver);
 extern int drm_get_pci_dev(struct pci_dev *pdev,
 			   const struct pci_device_id *ent,
 			   struct drm_driver *driver);
+extern void drm_put_pci_dev(struct drm_device *dev);
 
 #define DRM_PCIE_SPEED_25 1
 #define DRM_PCIE_SPEED_50 2
-- 
1.7.9.5

