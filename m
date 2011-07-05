Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1GEOuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:50:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59142 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1GEOuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:50:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 28/49] gma500: move configuration bits into the psb_ops
 structure
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:40:16 +0100
Message-ID: <20110705144014.23872.52397.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We can stuff things like the number of pipes and the SGX offset away in
here as well and clean up more conditional code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_device.c |    6 +++
 drivers/staging/gma500/mrst_bios.c    |   14 ++++++-
 drivers/staging/gma500/mrst_bios.h    |    5 +--
 drivers/staging/gma500/mrst_device.c  |    5 +++
 drivers/staging/gma500/psb_device.c   |   54 ++++++++++++++++++++++++++-
 drivers/staging/gma500/psb_drv.c      |   65 +++------------------------------
 drivers/staging/gma500/psb_drv.h      |    5 +++
 7 files changed, 86 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_device.c b/drivers/staging/gma500/mdfld_device.c
index e66d04a..daa9487 100644
--- a/drivers/staging/gma500/mdfld_device.c
+++ b/drivers/staging/gma500/mdfld_device.c
@@ -26,6 +26,7 @@
 #include "psb_drv.h"
 #include "mdfld_output.h"
 #include "mdfld_dsi_output.h"
+#include "mrst_bios.h"
 
 /*
  *	Provide the Medfield specific backlight management
@@ -689,6 +690,11 @@ static int mdfld_power_up(struct drm_device *dev)
 const struct psb_ops mdfld_chip_ops = {
 	.name = "Medfield",
 	.accel_2d = 0,
+	.pipes = 3,
+	.sgx_offset = MRST_SGX_OFFSET,
+
+	.chip_setup = mid_chip_setup,
+
 	.crtc_helper = &mdfld_helper_funcs,
 	.crtc_funcs = &mdfld_intel_crtc_funcs,
 
diff --git a/drivers/staging/gma500/mrst_bios.c b/drivers/staging/gma500/mrst_bios.c
index c3707f4..cf015df 100644
--- a/drivers/staging/gma500/mrst_bios.c
+++ b/drivers/staging/gma500/mrst_bios.c
@@ -35,7 +35,7 @@ module_param_named(panel_id, panel_id, int, 0600);
 MODULE_PARM_DESC(panel_id, "Panel Identifier");
 
 
-void mrst_get_fuse_settings(struct drm_device *dev)
+static void mid_get_fuse_settings(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
@@ -102,7 +102,7 @@ void mrst_get_fuse_settings(struct drm_device *dev)
 /*
  *	Get the revison ID, B0:D2:F0;0x08
  */
-void mid_get_pci_revID(struct drm_psb_private *dev_priv)
+static void mid_get_pci_revID(struct drm_psb_private *dev_priv)
 {
 	uint32_t platform_rev_id = 0;
 	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
@@ -114,7 +114,7 @@ void mid_get_pci_revID(struct drm_psb_private *dev_priv)
 					dev_priv->platform_rev_id);
 }
 
-void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
+static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
 {
 	struct drm_device *dev = dev_priv->dev;
 	struct mrst_vbt *vbt = &dev_priv->vbt_data;
@@ -261,3 +261,11 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 	}
 }
 
+int mid_chip_setup(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	mid_get_fuse_settings(dev);
+	mid_get_vbt_data(dev_priv);
+	mid_get_pci_revID(dev_priv);
+	return 0;
+}
\ No newline at end of file
diff --git a/drivers/staging/gma500/mrst_bios.h b/drivers/staging/gma500/mrst_bios.h
index a257306..00e7d56 100644
--- a/drivers/staging/gma500/mrst_bios.h
+++ b/drivers/staging/gma500/mrst_bios.h
@@ -17,6 +17,5 @@
  *
  **************************************************************************/
 
-extern void mrst_get_fuse_settings(struct drm_device *dev);
-extern void mid_get_pci_revID(struct drm_psb_private *dev_priv);
-extern void mrst_get_vbt_data(struct drm_psb_private *dev_priv);
+extern int mid_chip_setup(struct drm_device *dev);
+
diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 79cd784..d71e8d3 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -25,6 +25,7 @@
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include <asm/intel_scu_ipc.h>
+#include "mrst_bios.h"
 
 /* IPC message and command defines used to enable/disable mipi panel voltages */
 #define IPC_MSG_PANEL_ON_OFF    0xE9
@@ -354,6 +355,10 @@ static int mrst_power_up(struct drm_device *dev)
 const struct psb_ops mrst_chip_ops = {
 	.name = "Moorestown",
 	.accel_2d = 1,
+	.pipes = 1,
+	.sgx_offset = MRST_SGX_OFFSET,
+
+	.chip_setup = mid_chip_setup,
 	.crtc_helper = &mrst_helper_funcs,
 	.crtc_funcs = &psb_intel_crtc_funcs,
 
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 0402171..1be6434 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -271,19 +271,69 @@ static int psb_restore_display_registers(struct drm_device *dev)
 	return 0;
 }
 
-int psb_power_down(struct drm_device *dev)
+static int psb_power_down(struct drm_device *dev)
 {
 	return 0;
 }
 
-int psb_power_up(struct drm_device *dev)
+static int psb_power_up(struct drm_device *dev)
 {
 	return 0;
 }
 
+static void psb_get_core_freq(struct drm_device *dev)
+{
+	uint32_t clock;
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/*pci_write_config_dword(pci_root, 0xD4, 0x00C32004);*/
+	/*pci_write_config_dword(pci_root, 0xD0, 0xE0033000);*/
+
+	pci_write_config_dword(pci_root, 0xD0, 0xD0050300);
+	pci_read_config_dword(pci_root, 0xD4, &clock);
+	pci_dev_put(pci_root);
+
+	switch (clock & 0x07) {
+	case 0:
+		dev_priv->core_freq = 100;
+		break;
+	case 1:
+		dev_priv->core_freq = 133;
+		break;
+	case 2:
+		dev_priv->core_freq = 150;
+		break;
+	case 3:
+		dev_priv->core_freq = 178;
+		break;
+	case 4:
+		dev_priv->core_freq = 200;
+		break;
+	case 5:
+	case 6:
+	case 7:
+		dev_priv->core_freq = 266;
+	default:
+		dev_priv->core_freq = 0;
+	}
+}
+
+static int psb_chip_setup(struct drm_device *dev)
+{
+	psb_get_core_freq(dev);
+	psb_intel_opregion_init(dev);
+	psb_intel_init_bios(dev);
+	return 0;
+}
+
 const struct psb_ops psb_chip_ops = {
 	.name = "Poulsbo",
 	.accel_2d = 1,
+	.pipes = 2,
+	.sgx_offset = PSB_SGX_OFFSET,
+	.chip_setup = psb_chip_setup,
+
 	.crtc_helper = &psb_intel_helper_funcs,
 	.crtc_funcs = &psb_intel_crtc_funcs,
 
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index dfb3f3a..b95d0a6 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -158,44 +158,6 @@ static void psb_do_takedown(struct drm_device *dev)
 	/* FIXME: do we need to clean up the gtt here ? */
 }
 
-static void psb_get_core_freq(struct drm_device *dev)
-{
-	uint32_t clock;
-	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	/*pci_write_config_dword(pci_root, 0xD4, 0x00C32004);*/
-	/*pci_write_config_dword(pci_root, 0xD0, 0xE0033000);*/
-
-	pci_write_config_dword(pci_root, 0xD0, 0xD0050300);
-	pci_read_config_dword(pci_root, 0xD4, &clock);
-	pci_dev_put(pci_root);
-
-	switch (clock & 0x07) {
-	case 0:
-		dev_priv->core_freq = 100;
-		break;
-	case 1:
-		dev_priv->core_freq = 133;
-		break;
-	case 2:
-		dev_priv->core_freq = 150;
-		break;
-	case 3:
-		dev_priv->core_freq = 178;
-		break;
-	case 4:
-		dev_priv->core_freq = 200;
-		break;
-	case 5:
-	case 6:
-	case 7:
-		dev_priv->core_freq = 266;
-	default:
-		dev_priv->core_freq = 0;
-	}
-}
-
 static int psb_do_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv =
@@ -336,13 +298,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev_priv->dev = dev;
 	dev->dev_private = (void *) dev_priv;
 
-	if (IS_MRST(dev))
-		dev_priv->num_pipe = 1;
-	else if (IS_MFLD(dev))
-		dev_priv->num_pipe = 3;
-	else
-		dev_priv->num_pipe = 2;
-
+	dev_priv->num_pipe = dev_priv->ops->pipes;
 
 	resource_start = pci_resource_start(dev->pdev, PSB_MMIO_RESOURCE);
 
@@ -351,25 +307,14 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (!dev_priv->vdc_reg)
 		goto out_err;
 
-	if (IS_MRST(dev) || IS_MFLD(dev))
-		dev_priv->sgx_reg = ioremap(resource_start + MRST_SGX_OFFSET,
+	dev_priv->sgx_reg = ioremap(resource_start + dev_priv->ops->sgx_offset,
 							PSB_SGX_SIZE);
-	else
-		dev_priv->sgx_reg = ioremap(resource_start + PSB_SGX_OFFSET,
-							PSB_SGX_SIZE);
-
 	if (!dev_priv->sgx_reg)
 		goto out_err;
 
-	if (IS_MRST(dev) || IS_MFLD(dev)) {
-		mrst_get_fuse_settings(dev);
-		mrst_get_vbt_data(dev_priv);
-		mid_get_pci_revID(dev_priv);
-	} else {
-		psb_get_core_freq(dev);
-		psb_intel_opregion_init(dev);
-		psb_intel_init_bios(dev);
-	}
+	ret = dev_priv->ops->chip_setup(dev);
+	if (ret)
+		goto out_err;
 
 	/* Init OSPM support */
 	gma_power_init(dev);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 4bc5e8d..7e6f178 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -619,11 +619,16 @@ struct drm_psb_private {
 struct psb_ops {
 	const char *name;
 	unsigned int accel_2d:1;
+	int pipes;		/* Number of output pipes */
+	int sgx_offset;		/* Base offset of SGX device */
 
 	/* Sub functions */
 	struct drm_crtc_helper_funcs const *crtc_helper;
 	struct drm_crtc_funcs const *crtc_funcs;
 
+	/* Setup hooks */
+	int (*chip_setup)(struct drm_device *dev);
+
 	/* Display management hooks */
 	int (*output_init)(struct drm_device *dev);
 	/* Power management hooks */

