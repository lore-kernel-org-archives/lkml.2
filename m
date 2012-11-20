Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2KTLas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:30:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58515 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2KTLaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:30:46 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] davinci: vpbe: pass different platform names to handle different ip's
Date: Tue, 20 Nov 2012 17:00:36 +0530
Message-Id: <1353411036-29475-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

The vpbe driver can handle different platforms DM644X, DM36X and
DM355. To differentiate between this platforms venc_type/vpbe_type
was passed as part of platform data which was incorrect. The correct
way to differentiate to handle this case is by passing different
platform names.

This patch creates platform_device_id[] array supporting different
platforms and assigns id_table to the platform driver, and finally
in the probe gets the actual device by using platform_get_device_id()
and gets the appropriate driver data for that platform.

Taking this approach will also make the DT transition easier.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 Changes for v2:
 1: Fixed review comments pointed by Sekhar.

 arch/arm/mach-davinci/board-dm644x-evm.c      |    8 ++--
 arch/arm/mach-davinci/dm644x.c                |   10 +---
 drivers/media/platform/davinci/vpbe.c         |    4 +-
 drivers/media/platform/davinci/vpbe_display.c |    2 +-
 drivers/media/platform/davinci/vpbe_osd.c     |   35 ++++++++++----
 drivers/media/platform/davinci/vpbe_venc.c    |   65 +++++++++++++++++--------
 include/media/davinci/vpbe_osd.h              |    5 +-
 include/media/davinci/vpbe_venc.h             |    5 +-
 8 files changed, 84 insertions(+), 50 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index f22572ce..b00ade4 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -689,7 +689,7 @@ static struct vpbe_output dm644xevm_vpbe_outputs[] = {
 			.std		= VENC_STD_ALL,
 			.capabilities	= V4L2_OUT_CAP_STD,
 		},
-		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
+		.subdev_name	= DM644X_VPBE_VENC_SUBDEV_NAME,
 		.default_mode	= "ntsc",
 		.num_modes	= ARRAY_SIZE(dm644xevm_enc_std_timing),
 		.modes		= dm644xevm_enc_std_timing,
@@ -701,7 +701,7 @@ static struct vpbe_output dm644xevm_vpbe_outputs[] = {
 			.type		= V4L2_OUTPUT_TYPE_ANALOG,
 			.capabilities	= V4L2_OUT_CAP_DV_TIMINGS,
 		},
-		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
+		.subdev_name	= DM644X_VPBE_VENC_SUBDEV_NAME,
 		.default_mode	= "480p59_94",
 		.num_modes	= ARRAY_SIZE(dm644xevm_enc_preset_timing),
 		.modes		= dm644xevm_enc_preset_timing,
@@ -712,10 +712,10 @@ static struct vpbe_config dm644xevm_display_cfg = {
 	.module_name	= "dm644x-vpbe-display",
 	.i2c_adapter_id	= 1,
 	.osd		= {
-		.module_name	= VPBE_OSD_SUBDEV_NAME,
+		.module_name	= DM644X_VPBE_OSD_SUBDEV_NAME,
 	},
 	.venc		= {
-		.module_name	= VPBE_VENC_SUBDEV_NAME,
+		.module_name	= DM644X_VPBE_VENC_SUBDEV_NAME,
 	},
 	.num_outputs	= ARRAY_SIZE(dm644xevm_vpbe_outputs),
 	.outputs	= dm644xevm_vpbe_outputs,
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index cd0c8b1..98d79f1 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -669,19 +669,14 @@ static struct resource dm644x_osd_resources[] = {
 	},
 };
 
-static struct osd_platform_data dm644x_osd_data = {
-	.vpbe_type     = VPBE_VERSION_1,
-};
-
 static struct platform_device dm644x_osd_dev = {
-	.name		= VPBE_OSD_SUBDEV_NAME,
+	.name		= DM644X_VPBE_OSD_SUBDEV_NAME,
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(dm644x_osd_resources),
 	.resource	= dm644x_osd_resources,
 	.dev		= {
 		.dma_mask		= &dm644x_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &dm644x_osd_data,
 	},
 };
 
@@ -752,12 +747,11 @@ static struct platform_device dm644x_vpbe_display = {
 };
 
 static struct venc_platform_data dm644x_venc_pdata = {
-	.venc_type	= VPBE_VERSION_1,
 	.setup_clock	= dm644x_venc_setup_clock,
 };
 
 static struct platform_device dm644x_venc_dev = {
-	.name		= VPBE_VENC_SUBDEV_NAME,
+	.name		= DM644X_VPBE_VENC_SUBDEV_NAME,
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(dm644x_venc_resources),
 	.resource	= dm644x_venc_resources,
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 7f5cf9b..dd670cd 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -558,9 +558,9 @@ static int platform_device_get(struct device *dev, void *data)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct vpbe_device *vpbe_dev = data;
 
-	if (strcmp("vpbe-osd", pdev->name) == 0)
+	if (strstr(pdev->name, "vpbe-osd") != NULL)
 		vpbe_dev->osd_device = platform_get_drvdata(pdev);
-	if (strcmp("vpbe-venc", pdev->name) == 0)
+	if (strstr(pdev->name, "vpbe-venc") != NULL)
 		vpbe_dev->venc_device = dev_get_platdata(&pdev->dev);
 
 	return 0;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 2bfde79..3846890 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1656,7 +1656,7 @@ static int vpbe_device_get(struct device *dev, void *data)
 	if (strcmp("vpbe_controller", pdev->name) == 0)
 		vpbe_disp->vpbe_dev = platform_get_drvdata(pdev);
 
-	if (strcmp("vpbe-osd", pdev->name) == 0)
+	if (strstr(pdev->name, "vpbe-osd") != NULL)
 		vpbe_disp->osd_device = platform_get_drvdata(pdev);
 
 	return 0;
diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 707f243..12ad17c 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -39,7 +39,22 @@
 #include <linux/io.h>
 #include "vpbe_osd_regs.h"
 
-#define MODULE_NAME	VPBE_OSD_SUBDEV_NAME
+#define MODULE_NAME	"davinci-vpbe-osd"
+
+static struct platform_device_id vpbe_osd_devtype[] = {
+	{
+		.name = DM644X_VPBE_OSD_SUBDEV_NAME,
+		.driver_data = VPBE_VERSION_1,
+	}, {
+		.name = DM365_VPBE_OSD_SUBDEV_NAME,
+		.driver_data = VPBE_VERSION_2,
+	}, {
+		.name = DM355_VPBE_OSD_SUBDEV_NAME,
+		.driver_data = VPBE_VERSION_3,
+	},
+};
+
+MODULE_DEVICE_TABLE(platform, vpbe_osd_devtype);
 
 /* register access routines */
 static inline u32 osd_read(struct osd_state *sd, u32 offset)
@@ -129,7 +144,7 @@ static int _osd_dm6446_vid0_pingpong(struct osd_state *sd,
 	struct osd_platform_data *pdata;
 
 	pdata = (struct osd_platform_data *)sd->dev->platform_data;
-	if (pdata->field_inv_wa_enable) {
+	if (pdata != NULL && pdata->field_inv_wa_enable) {
 
 		if (!field_inversion || !lconfig->interlaced) {
 			osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN0ADR);
@@ -1526,7 +1541,7 @@ static const struct vpbe_osd_ops osd_ops = {
 
 static int osd_probe(struct platform_device *pdev)
 {
-	struct osd_platform_data *pdata;
+	const struct platform_device_id *pdev_id;
 	struct osd_state *osd;
 	struct resource *res;
 	int ret = 0;
@@ -1535,16 +1550,15 @@ static int osd_probe(struct platform_device *pdev)
 	if (osd == NULL)
 		return -ENOMEM;
 
-	osd->dev = &pdev->dev;
-	pdata = (struct osd_platform_data *)pdev->dev.platform_data;
-	osd->vpbe_type = (enum vpbe_version)pdata->vpbe_type;
-	if (NULL == pdev->dev.platform_data) {
-		dev_err(osd->dev, "No platform data defined for OSD"
-			" sub device\n");
-		ret = -ENOENT;
+	pdev_id = platform_get_device_id(pdev);
+	if (!pdev_id) {
+		ret = -EINVAL;
 		goto free_mem;
 	}
 
+	osd->dev = &pdev->dev;
+	osd->vpbe_type = pdev_id->driver_data;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(osd->dev, "Unable to get OSD register address map\n");
@@ -1595,6 +1609,7 @@ static struct platform_driver osd_driver = {
 		.name	= MODULE_NAME,
 		.owner	= THIS_MODULE,
 	},
+	.id_table	= vpbe_osd_devtype
 };
 
 module_platform_driver(osd_driver);
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index aed7369..bdbebd5 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -38,7 +38,22 @@
 
 #include "vpbe_venc_regs.h"
 
-#define MODULE_NAME	VPBE_VENC_SUBDEV_NAME
+#define MODULE_NAME	"davinci-vpbe-venc"
+
+static struct platform_device_id vpbe_venc_devtype[] = {
+	{
+		.name = DM644X_VPBE_VENC_SUBDEV_NAME,
+		.driver_data = VPBE_VERSION_1,
+	}, {
+		.name = DM365_VPBE_VENC_SUBDEV_NAME,
+		.driver_data = VPBE_VERSION_2,
+	}, {
+		.name = DM355_VPBE_VENC_SUBDEV_NAME,
+		.driver_data = VPBE_VERSION_3,
+	},
+};
+
+MODULE_DEVICE_TABLE(platform, vpbe_venc_devtype);
 
 static int debug = 2;
 module_param(debug, int, 0644);
@@ -54,6 +69,7 @@ struct venc_state {
 	spinlock_t lock;
 	void __iomem *venc_base;
 	void __iomem *vdaccfg_reg;
+	enum vpbe_version venc_type;
 };
 
 static inline struct venc_state *to_state(struct v4l2_subdev *sd)
@@ -127,7 +143,7 @@ static int venc_set_dac(struct v4l2_subdev *sd, u32 out_index)
 static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
 {
 	struct venc_state *venc = to_state(sd);
-	struct venc_platform_data *pdata = venc->pdata;
+
 	v4l2_dbg(debug, 2, sd, "venc_enabledigitaloutput\n");
 
 	if (benable) {
@@ -159,7 +175,7 @@ static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
 
 		/* Disable LCD output control (accepting default polarity) */
 		venc_write(sd, VENC_LCDOUT, 0);
-		if (pdata->venc_type != VPBE_VERSION_3)
+		if (venc->venc_type != VPBE_VERSION_3)
 			venc_write(sd, VENC_CMPNT, 0x100);
 		venc_write(sd, VENC_HSPLS, 0);
 		venc_write(sd, VENC_HINT, 0);
@@ -203,11 +219,11 @@ static int venc_set_ntsc(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
-	if (pdata->venc_type == VPBE_VERSION_3) {
+	if (venc->venc_type == VPBE_VERSION_3) {
 		venc_write(sd, VENC_CLKCTL, 0x01);
 		venc_write(sd, VENC_VIDCTL, 0);
 		val = vdaccfg_write(sd, VDAC_CONFIG_SD_V3);
-	} else if (pdata->venc_type == VPBE_VERSION_2) {
+	} else if (venc->venc_type == VPBE_VERSION_2) {
 		venc_write(sd, VENC_CLKCTL, 0x01);
 		venc_write(sd, VENC_VIDCTL, 0);
 		vdaccfg_write(sd, VDAC_CONFIG_SD_V2);
@@ -238,7 +254,6 @@ static int venc_set_ntsc(struct v4l2_subdev *sd)
 static int venc_set_pal(struct v4l2_subdev *sd)
 {
 	struct venc_state *venc = to_state(sd);
-	struct venc_platform_data *pdata = venc->pdata;
 
 	v4l2_dbg(debug, 2, sd, "venc_set_pal\n");
 
@@ -249,11 +264,11 @@ static int venc_set_pal(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
-	if (pdata->venc_type == VPBE_VERSION_3) {
+	if (venc->venc_type == VPBE_VERSION_3) {
 		venc_write(sd, VENC_CLKCTL, 0x1);
 		venc_write(sd, VENC_VIDCTL, 0);
 		vdaccfg_write(sd, VDAC_CONFIG_SD_V3);
-	} else if (pdata->venc_type == VPBE_VERSION_2) {
+	} else if (venc->venc_type == VPBE_VERSION_2) {
 		venc_write(sd, VENC_CLKCTL, 0x1);
 		venc_write(sd, VENC_VIDCTL, 0);
 		vdaccfg_write(sd, VDAC_CONFIG_SD_V2);
@@ -293,8 +308,8 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
 	struct venc_platform_data *pdata = venc->pdata;
 
 	v4l2_dbg(debug, 2, sd, "venc_set_480p59_94\n");
-	if ((pdata->venc_type != VPBE_VERSION_1) &&
-	    (pdata->venc_type != VPBE_VERSION_2))
+	if (venc->venc_type != VPBE_VERSION_1 &&
+	    venc->venc_type != VPBE_VERSION_2)
 		return -EINVAL;
 
 	/* Setup clock at VPSS & VENC for SD */
@@ -303,12 +318,12 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
-	if (pdata->venc_type == VPBE_VERSION_2)
+	if (venc->venc_type == VPBE_VERSION_2)
 		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
 	venc_write(sd, VENC_OSDCLK0, 0);
 	venc_write(sd, VENC_OSDCLK1, 1);
 
-	if (pdata->venc_type == VPBE_VERSION_1) {
+	if (venc->venc_type == VPBE_VERSION_1) {
 		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
 			    VENC_VDPRO_DAFRQ);
 		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
@@ -341,8 +356,8 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
 
 	v4l2_dbg(debug, 2, sd, "venc_set_576p50\n");
 
-	if ((pdata->venc_type != VPBE_VERSION_1) &&
-	  (pdata->venc_type != VPBE_VERSION_2))
+	if (venc->venc_type != VPBE_VERSION_1 &&
+	    venc->venc_type != VPBE_VERSION_2)
 		return -EINVAL;
 	/* Setup clock at VPSS & VENC for SD */
 	if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 27000000) < 0)
@@ -350,13 +365,13 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
-	if (pdata->venc_type == VPBE_VERSION_2)
+	if (venc->venc_type == VPBE_VERSION_2)
 		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
 
 	venc_write(sd, VENC_OSDCLK0, 0);
 	venc_write(sd, VENC_OSDCLK1, 1);
 
-	if (pdata->venc_type == VPBE_VERSION_1) {
+	if (venc->venc_type == VPBE_VERSION_1) {
 		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
 			    VENC_VDPRO_DAFRQ);
 		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
@@ -460,14 +475,14 @@ static int venc_s_dv_timings(struct v4l2_subdev *sd,
 	else if (height == 480)
 		return venc_set_480p59_94(sd);
 	else if ((height == 720) &&
-			(venc->pdata->venc_type == VPBE_VERSION_2)) {
+			(venc->venc_type == VPBE_VERSION_2)) {
 		/* TBD setup internal 720p mode here */
 		ret = venc_set_720p60_internal(sd);
 		/* for DM365 VPBE, there is DAC inside */
 		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
 		return ret;
 	} else if ((height == 1080) &&
-		(venc->pdata->venc_type == VPBE_VERSION_2)) {
+		(venc->venc_type == VPBE_VERSION_2)) {
 		/* TBD setup internal 1080i mode here */
 		ret = venc_set_1080i30_internal(sd);
 		/* for DM365 VPBE, there is DAC inside */
@@ -556,7 +571,7 @@ static int venc_device_get(struct device *dev, void *data)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct venc_state **venc = data;
 
-	if (strcmp(MODULE_NAME, pdev->name) == 0)
+	if (strstr(pdev->name, "vpbe-venc") != NULL)
 		*venc = platform_get_drvdata(pdev);
 
 	return 0;
@@ -593,6 +608,7 @@ EXPORT_SYMBOL(venc_sub_dev_init);
 
 static int venc_probe(struct platform_device *pdev)
 {
+	const struct platform_device_id *pdev_id;
 	struct venc_state *venc;
 	struct resource *res;
 	int ret;
@@ -601,6 +617,12 @@ static int venc_probe(struct platform_device *pdev)
 	if (venc == NULL)
 		return -ENOMEM;
 
+	pdev_id = platform_get_device_id(pdev);
+	if (!pdev_id) {
+		ret = -EINVAL;
+		goto free_mem;
+	}
+	venc->venc_type = pdev_id->driver_data;
 	venc->pdev = &pdev->dev;
 	venc->pdata = pdev->dev.platform_data;
 	if (NULL == venc->pdata) {
@@ -630,7 +652,7 @@ static int venc_probe(struct platform_device *pdev)
 		goto release_venc_mem_region;
 	}
 
-	if (venc->pdata->venc_type != VPBE_VERSION_1) {
+	if (venc->venc_type != VPBE_VERSION_1) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		if (!res) {
 			dev_err(venc->pdev,
@@ -681,7 +703,7 @@ static int venc_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	iounmap((void *)venc->venc_base);
 	release_mem_region(res->start, resource_size(res));
-	if (venc->pdata->venc_type != VPBE_VERSION_1) {
+	if (venc->venc_type != VPBE_VERSION_1) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		iounmap((void *)venc->vdaccfg_reg);
 		release_mem_region(res->start, resource_size(res));
@@ -698,6 +720,7 @@ static struct platform_driver venc_driver = {
 		.name	= MODULE_NAME,
 		.owner	= THIS_MODULE,
 	},
+	.id_table	= vpbe_venc_devtype
 };
 
 module_platform_driver(venc_driver);
diff --git a/include/media/davinci/vpbe_osd.h b/include/media/davinci/vpbe_osd.h
index 5ab0d8d..42628fc 100644
--- a/include/media/davinci/vpbe_osd.h
+++ b/include/media/davinci/vpbe_osd.h
@@ -26,7 +26,9 @@
 
 #include <media/davinci/vpbe_types.h>
 
-#define VPBE_OSD_SUBDEV_NAME "vpbe-osd"
+#define DM644X_VPBE_OSD_SUBDEV_NAME	"dm644x,vpbe-osd"
+#define DM365_VPBE_OSD_SUBDEV_NAME	"dm365,vpbe-osd"
+#define DM355_VPBE_OSD_SUBDEV_NAME	"dm355,vpbe-osd"
 
 /**
  * enum osd_layer
@@ -387,7 +389,6 @@ struct osd_state {
 };
 
 struct osd_platform_data {
-	enum vpbe_version vpbe_type;
 	int  field_inv_wa_enable;
 };
 
diff --git a/include/media/davinci/vpbe_venc.h b/include/media/davinci/vpbe_venc.h
index cc78c2e..476fafc 100644
--- a/include/media/davinci/vpbe_venc.h
+++ b/include/media/davinci/vpbe_venc.h
@@ -20,7 +20,9 @@
 #include <media/v4l2-subdev.h>
 #include <media/davinci/vpbe_types.h>
 
-#define VPBE_VENC_SUBDEV_NAME "vpbe-venc"
+#define DM644X_VPBE_VENC_SUBDEV_NAME	"dm644x,vpbe-venc"
+#define DM365_VPBE_VENC_SUBDEV_NAME	"dm365,vpbe-venc"
+#define DM355_VPBE_VENC_SUBDEV_NAME	"dm355,vpbe-venc"
 
 /* venc events */
 #define VENC_END_OF_FRAME	BIT(0)
@@ -28,7 +30,6 @@
 #define VENC_SECOND_FIELD	BIT(2)
 
 struct venc_platform_data {
-	enum vpbe_version venc_type;
 	int (*setup_pinmux)(enum v4l2_mbus_pixelcode if_type,
 			    int field);
 	int (*setup_clock)(enum vpbe_enc_timings_type type,
-- 
1.7.4.1

