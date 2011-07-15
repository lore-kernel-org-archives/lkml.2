Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1GOQmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:42:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35814 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1GOQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:42:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/15] gma500: remove the legacy PM method
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:33:26 +0100
Message-ID: <20110715163319.28759.14659.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <octavian.purdila@intel.com>

PCI core only prefer one of legacy PM and new PM. And since runtime pm
is implemented, which requires the new PM method, we should remove the
legacy PM method.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/power.c   |    9 +++++----
 drivers/staging/gma500/power.h   |    4 ++--
 drivers/staging/gma500/psb_drv.c |    6 ++----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 5cd5023..972bea7 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -185,8 +185,9 @@ static bool gma_resume_pci(struct pci_dev *pdev)
  *	perform the necessary shut down steps and save enough state that
  *	we can undo this when resume is called.
  */
-int gma_power_suspend(struct pci_dev *pdev, pm_message_t state)
+int gma_power_suspend(struct device *_dev)
 {
+	struct pci_dev *pdev = container_of(_dev, struct pci_dev, dev);
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
@@ -210,8 +211,9 @@ int gma_power_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  *	Resume the PCI side of the graphics and then the displays
  */
-int gma_power_resume(struct pci_dev *pdev)
+int gma_power_resume(struct device *_dev)
 {
+	struct pci_dev *pdev = container_of(_dev, struct pci_dev, dev);
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
 	mutex_lock(&power_mutex);
@@ -295,8 +297,7 @@ void gma_power_end(struct drm_device *dev)
 
 int psb_runtime_suspend(struct device *dev)
 {
-	static pm_message_t dummy;
-	return gma_power_suspend(to_pci_dev(dev), dummy);
+	return gma_power_suspend(dev);
 }
 
 int psb_runtime_resume(struct device *dev)
diff --git a/drivers/staging/gma500/power.h b/drivers/staging/gma500/power.h
index 333b28d..1969d2e 100644
--- a/drivers/staging/gma500/power.h
+++ b/drivers/staging/gma500/power.h
@@ -39,8 +39,8 @@ void gma_power_uninit(struct drm_device *dev);
 /*
  * The kernel bus power management  will call these functions
  */
-int gma_power_suspend(struct pci_dev *pdev, pm_message_t state);
-int gma_power_resume(struct pci_dev *pdev);
+int gma_power_suspend(struct device *dev);
+int gma_power_resume(struct device *dev);
 
 /*
  * These are the functions the driver should use to wrap all hw access
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b8b9864..f96a619 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1144,6 +1144,8 @@ static void psb_remove(struct pci_dev *pdev)
 }
 
 static const struct dev_pm_ops psb_pm_ops = {
+	.resume = gma_power_resume,
+	.suspend = gma_power_suspend,
 	.runtime_suspend = psb_runtime_suspend,
 	.runtime_resume = psb_runtime_resume,
 	.runtime_idle = psb_runtime_idle,
@@ -1205,13 +1207,9 @@ static struct drm_driver driver = {
 static struct pci_driver psb_pci_driver = {
 	.name = DRIVER_NAME,
 	.id_table = pciidlist,
-	.resume = gma_power_resume,
-	.suspend = gma_power_suspend,
 	.probe = psb_probe,
 	.remove = psb_remove,
-#ifdef CONFIG_PM
 	.driver.pm = &psb_pm_ops,
-#endif
 };
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)

