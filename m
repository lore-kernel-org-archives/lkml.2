Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1GOQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:42:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35817 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1GOQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:42:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/15] gma500: Make crtc count a property of the device
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:33:43 +0100
Message-ID: <20110715163336.28759.2163.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Octavian Purdila posted a patch that sets num_crtc to 1 for Moorestown, but
Oaktrail has 2 so we need to split Oaktrail/Moorestown more sensibly, and
also cope with some other differences later on.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/framebuffer.c  |    2 +-
 drivers/staging/gma500/mdfld_device.c |    1 +
 drivers/staging/gma500/mrst_device.c  |   41 +++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_device.c   |    1 +
 drivers/staging/gma500/psb_drv.h      |    1 +
 5 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index d890a50..ebfde13 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -578,7 +578,7 @@ int psb_fbdev_init(struct drm_device *dev)
 	dev_priv->fbdev = fbdev;
 	fbdev->psb_fb_helper.funcs = &psb_fb_helper_funcs;
 
-	drm_fb_helper_init(dev, &fbdev->psb_fb_helper, 2,
+	drm_fb_helper_init(dev, &fbdev->psb_fb_helper, dev_priv->ops->crtcs,
 							INTELFB_CONN_LIMIT);
 
 	drm_fb_helper_single_add_all_connectors(&fbdev->psb_fb_helper);
diff --git a/drivers/staging/gma500/mdfld_device.c b/drivers/staging/gma500/mdfld_device.c
index f258b06..f47aeb7 100644
--- a/drivers/staging/gma500/mdfld_device.c
+++ b/drivers/staging/gma500/mdfld_device.c
@@ -691,6 +691,7 @@ const struct psb_ops mdfld_chip_ops = {
 	.name = "Medfield",
 	.accel_2d = 0,
 	.pipes = 3,
+	.crtcs = 2,
 	.sgx_offset = MRST_SGX_OFFSET,
 
 	.chip_setup = mid_chip_setup,
diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 436580d..3d525a0 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -24,9 +24,12 @@
 #include "psb_drv.h"
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
+#include <asm/mrst.h>
 #include <asm/intel_scu_ipc.h>
 #include "mid_bios.h"
 
+static const struct psb_ops oaktrail_chip_ops;
+
 /* IPC message and command defines used to enable/disable mipi panel voltages */
 #define IPC_MSG_PANEL_ON_OFF    0xE9
 #define IPC_CMD_PANEL_ON        1
@@ -352,10 +355,48 @@ static int mrst_power_up(struct drm_device *dev)
 	return 0;
 }
 
+static int mrst_chip_setup(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+#if defined(CONFIG_X86_MRST)
+	if (mrst_identify_cpu())
+		return mid_chip_setup(dev);
+#endif
+	dev_priv->ops = &oaktrail_chip_ops;
+	/* Check - may be better to go via BIOS paths ? */
+	return mid_chip_setup(dev);
+}
+	
 const struct psb_ops mrst_chip_ops = {
 	.name = "Moorestown",
 	.accel_2d = 1,
 	.pipes = 1,
+	.crtcs = 1,
+	.sgx_offset = MRST_SGX_OFFSET,
+
+	.chip_setup = mrst_chip_setup,
+	.crtc_helper = &mrst_helper_funcs,
+	.crtc_funcs = &psb_intel_crtc_funcs,
+
+	.output_init = mrst_output_init,
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	.backlight_init = mrst_backlight_init,
+#endif
+
+	.init_pm = mrst_init_pm,
+	.save_regs = mrst_save_display_registers,
+	.restore_regs = mrst_restore_display_registers,
+	.power_down = mrst_power_down,
+	.power_up = mrst_power_up,
+};
+
+static const struct psb_ops oaktrail_chip_ops = {
+	.name = "Oaktrail",
+	.accel_2d = 1,
+	.pipes = 2,
+	.crtcs = 2,
 	.sgx_offset = MRST_SGX_OFFSET,
 
 	.chip_setup = mid_chip_setup,
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 1e117f0..4659132 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -331,6 +331,7 @@ const struct psb_ops psb_chip_ops = {
 	.name = "Poulsbo",
 	.accel_2d = 1,
 	.pipes = 2,
+	.crtcs = 2,
 	.sgx_offset = PSB_SGX_OFFSET,
 	.chip_setup = psb_chip_setup,
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index daf3ca5..8184c23 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -622,6 +622,7 @@ struct psb_ops {
 	const char *name;
 	unsigned int accel_2d:1;
 	int pipes;		/* Number of output pipes */
+	int crtcs;		/* Number of CRTCs */
 	int sgx_offset;		/* Base offset of SGX device */
 
 	/* Sub functions */

