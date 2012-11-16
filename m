Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2KPOqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:46:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:32926 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2KPOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:46:19 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 01/12] davinci: vpfe: add v4l2 capture driver with media interface
Date: Fri, 16 Nov 2012 20:15:03 +0530
Message-Id: <1353077114-19296-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add the vpfe capture driver which implements media controller
interface. The driver supports the DM365 sub ip units for capture
namely - ISIF, IPIPE, IPIPEIF, Resizer. This file represents the main
driver which does isr registration, v4l2 device registration,
media registration and platform driver registrations.
It calls the appropriate subdevs from here to create subdevices
and media entities.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpfe_mc_capture.c |  741 +++++++++++++
 drivers/media/platform/davinci/vpfe_mc_capture.h |   97 ++
 include/media/davinci/vpfe.h                     |   86 ++
 include/uapi/linux/Kbuild                        |    1 +
 include/uapi/linux/davinci_vpfe.h                | 1285 ++++++++++++++++++++++
 5 files changed, 2210 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.c
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.h
 create mode 100644 include/media/davinci/vpfe.h
 create mode 100644 include/uapi/linux/davinci_vpfe.h

diff --git a/drivers/media/platform/davinci/vpfe_mc_capture.c b/drivers/media/platform/davinci/vpfe_mc_capture.c
new file mode 100644
index 0000000..807ed33
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_mc_capture.c
@@ -0,0 +1,741 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ *
+ *
+ * Driver name : VPFE Capture driver
+ *    VPFE Capture driver allows applications to capture and stream video
+ *    frames on DaVinci SoCs (DM6446, DM355 etc) from a YUV source such as
+ *    TVP5146 or  Raw Bayer RGB image data from an image sensor
+ *    such as Microns' MT9T001, MT9T031 etc.
+ *
+ *    These SoCs have, in common, a Video Processing Subsystem (VPSS) that
+ *    consists of a Video Processing Front End (VPFE) for capturing
+ *    video/raw image data and Video Processing Back End (VPBE) for displaying
+ *    YUV data through an in-built analog encoder or Digital LCD port. This
+ *    driver is for capture through VPFE. A typical EVM using these SoCs have
+ *    following high level configuration.
+ *
+ *    decoder(TVP5146/		YUV/
+ *	MT9T001)   -->  Raw Bayer RGB ---> MUX -> VPFE (CCDC/ISIF)
+ *			data input              |      |
+ *							V      |
+ *						      SDRAM    |
+ *							       V
+ *							   Image Processor
+ *							       |
+ *							       V
+ *							     SDRAM
+ *    The data flow happens from a decoder connected to the VPFE over a
+ *    YUV embedded (BT.656/BT.1120) or separate sync or raw bayer rgb interface
+ *    and to the input of VPFE through an optional MUX (if more inputs are
+ *    to be interfaced on the EVM). The input data is first passed through
+ *    CCDC (CCD Controller, a.k.a Image Sensor Interface, ISIF). The CCDC
+ *    does very little or no processing on YUV data and does pre-process Raw
+ *    Bayer RGB data through modules such as Defect Pixel Correction (DFC)
+ *    Color Space Conversion (CSC), data gain/offset etc. After this, data
+ *    can be written to SDRAM or can be connected to the image processing
+ *    block such as IPIPE (on DM355/DM365 only).
+ *
+ *    Features supported
+ *		- MMAP IO
+ *		- USERPTR IO
+ *		- Capture using TVP5146 over BT.656
+ *		- Support for interfacing decoders using sub device model
+ *		- Work with DM365 or DM355 or DM6446 CCDC to do Raw Bayer
+ *		  RGB/YUV data capture to SDRAM.
+ *		- Chaining of Image Processor
+ *		- SINGLE-SHOT mode
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <media/davinci/vpfe.h>
+
+#include "vpfe_mc_capture.h"
+
+static bool debug;
+static bool interface;
+
+module_param(interface, bool, S_IRUGO);
+module_param(debug, bool, 0644);
+
+/**
+ * VPFE capture can be used for capturing video such as from TVP5146 or TVP7002
+ * and for capture raw bayer data from camera sensors such as mt9p031. At this
+ * point there is problem in co-existence of mt9p031 and tvp5146 due to i2c
+ * address collision. So set the variable below from bootargs to do either video
+ * capture or camera capture.
+ * interface = 0 - video capture (from TVP514x or such),
+ * interface = 1 - Camera capture (from mt9p031 or such)
+ * Re-visit this when we fix the co-existence issue
+ */
+MODULE_PARM_DESC(interface, "interface 0-1 (default:0)");
+MODULE_PARM_DESC(debug, "Debug level 0-1");
+
+MODULE_DESCRIPTION("VPFE Video for Linux Capture Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Texas Instruments");
+
+/* map mbus_fmt to pixelformat */
+void mbus_to_pix(const struct v4l2_mbus_framefmt *mbus,
+			   struct v4l2_pix_format *pix)
+{
+	switch (mbus->code) {
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		pix->pixelformat = V4L2_PIX_FMT_UYVY;
+		pix->bytesperline = pix->width * 2;
+		break;
+
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+		pix->bytesperline = pix->width * 2;
+		break;
+
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		pix->pixelformat = V4L2_PIX_FMT_UYVY;
+		pix->bytesperline = pix->width * 2;
+		break;
+
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		pix->pixelformat = V4L2_PIX_FMT_SBGGR16;
+		pix->bytesperline = pix->width * 2;
+		break;
+
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8;
+		pix->bytesperline = pix->width;
+		break;
+
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8;
+		pix->bytesperline = pix->width;
+		break;
+
+	case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
+		pix->pixelformat = V4L2_PIX_FMT_NV12;
+		pix->bytesperline = pix->width;
+		break;
+
+	case V4L2_MBUS_FMT_Y8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_GREY;
+		pix->bytesperline = pix->width;
+		break;
+
+	case V4L2_MBUS_FMT_UV8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_UV8;
+		pix->bytesperline = pix->width;
+		break;
+
+	default:
+		pr_err("Invalid mbus code set\n");
+	}
+	/* pitch should be 32 bytes aligned */
+	pix->bytesperline = ALIGN(pix->bytesperline, 32);
+	if (pix->pixelformat == V4L2_PIX_FMT_NV12)
+		pix->sizeimage = pix->bytesperline * pix->height +
+				((pix->bytesperline * pix->height) >> 1);
+	else
+		pix->sizeimage = pix->bytesperline * pix->height;
+}
+
+/* ISR for VINT0*/
+static irqreturn_t vpfe_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_isr\n");
+	vpfe_isif_buffer_isr(&vpfe_dev->vpfe_isif);
+	vpfe_resizer_buffer_isr(&vpfe_dev->vpfe_resizer);
+	return IRQ_HANDLED;
+}
+
+/* vpfe_vdint1_isr() - isr handler for VINT1 interrupt */
+static irqreturn_t vpfe_vdint1_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_vdint1_isr\n");
+	vpfe_isif_vidint1_isr(&vpfe_dev->vpfe_isif);
+	return IRQ_HANDLED;
+}
+
+/* vpfe_imp_dma_isr() - ISR for ipipe dma completion */
+static irqreturn_t vpfe_imp_dma_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_imp_dma_isr\n");
+	vpfe_ipipeif_ss_buffer_isr(&vpfe_dev->vpfe_ipipeif);
+	vpfe_resizer_dma_isr(&vpfe_dev->vpfe_resizer);
+	return IRQ_HANDLED;
+}
+
+/*
+ * vpfe_disable_clock() - Disable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Disables clocks defined in vpfe configuration. The function
+ * assumes that at least one clock is to be defined which is
+ * true as of now.
+ */
+static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
+	int i;
+
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		clk_disable_unprepare(vpfe_dev->clks[i]);
+		clk_put(vpfe_dev->clks[i]);
+	}
+	kzfree(vpfe_dev->clks);
+	v4l2_info(vpfe_dev->pdev->driver, "vpfe capture clocks disabled\n");
+}
+
+/*
+ * vpfe_enable_clock() - Enable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Enables clocks defined in vpfe configuration. The function
+ * assumes that at least one clock is to be defined which is
+ * true as of now.
+ */
+static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
+	int ret = -EFAULT;
+	int i;
+
+	if (!vpfe_cfg->num_clocks)
+		return 0;
+
+	vpfe_dev->clks = kzalloc(vpfe_cfg->num_clocks *
+				   sizeof(struct clock *), GFP_KERNEL);
+	if (vpfe_dev->clks == NULL) {
+		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (vpfe_cfg->clocks[i] == NULL) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"clock %s is not defined in vpfe config\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		vpfe_dev->clks[i] =
+				clk_get(vpfe_dev->pdev, vpfe_cfg->clocks[i]);
+		if (vpfe_dev->clks[i] == NULL) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"Failed to get clock %s\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		if (clk_prepare_enable(vpfe_dev->clks[i])) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"vpfe clock %s not enabled\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		v4l2_info(vpfe_dev->pdev->driver, "vpss clock %s enabled",
+			  vpfe_cfg->clocks[i]);
+	}
+
+	return 0;
+out:
+	for (i = 0; i < vpfe_cfg->num_clocks; i++)
+		if (vpfe_dev->clks[i]) {
+			clk_disable_unprepare(vpfe_dev->clks[i]);
+			clk_put(vpfe_dev->clks[i]);
+		}
+
+	v4l2_err(vpfe_dev->pdev->driver, "Failed to enable clocks\n");
+	kzfree(vpfe_dev->clks);
+
+	return ret;
+}
+
+/*
+ * vpfe_detach_irq() - Detach IRQs for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Detach all IRQs defined in vpfe configuration.
+ */
+static void vpfe_detach_irq(struct vpfe_device *vpfe_dev)
+{
+	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+	free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
+	free_irq(vpfe_dev->imp_dma_irq, vpfe_dev);
+}
+
+/*
+ * vpfe_attach_irq() - Attach IRQs for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Attach all IRQs defined in vpfe configuration.
+ */
+static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
+{
+	int ret = 0;
+
+	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
+			  "vpfe_capture0", vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"Error: requesting VINT0 interrupt\n");
+		return ret;
+	}
+
+	ret = request_irq(vpfe_dev->ccdc_irq1, vpfe_vdint1_isr, IRQF_DISABLED,
+			  "vpfe_capture1", vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"Error: requesting VINT1 interrupt\n");
+		free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+		return ret;
+	}
+
+	ret = request_irq(vpfe_dev->imp_dma_irq, vpfe_imp_dma_isr,
+			  IRQF_DISABLED, "Imp_Sdram_Irq", vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			 "Error: requesting IMP IRQ interrupt\n");
+		free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
+		free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * register_i2c_devices() - register all i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * register all i2c v4l2 subdevs
+ */
+static int register_i2c_devices(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_ext_subdev_info *sdinfo;
+	struct vpfe_config *vpfe_cfg;
+	struct i2c_adapter *i2c_adap;
+	unsigned int num_subdevs;
+	int ret;
+	int i;
+	int k;
+
+	vpfe_cfg = vpfe_dev->cfg;
+	i2c_adap = i2c_get_adapter(1);
+	num_subdevs = vpfe_cfg->num_subdevs;
+	vpfe_dev->sd =
+		  kzalloc(sizeof(struct v4l2_subdev *)*num_subdevs, GFP_KERNEL);
+	if (vpfe_dev->sd == NULL) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"unable to allocate memory for subdevice\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0, k = 0; i < num_subdevs; i++) {
+		sdinfo = &vpfe_cfg->sub_devs[i];
+		/*
+		 * register subdevices based on interface setting. Currently
+		 * tvp5146 and mt9p031 cannot co-exists due to i2c address
+		 * conflicts. So only one of them is registered. Re-visit this
+		 * once we have support for i2c switch handling in i2c driver
+		 * framework
+		 */
+		if (interface == sdinfo->is_camera) {
+			/* setup input path */
+			if (vpfe_cfg->setup_input &&
+				vpfe_cfg->setup_input(sdinfo->grp_id) < 0) {
+				ret = -EFAULT;
+				v4l2_info(&vpfe_dev->v4l2_dev,
+					  "could not setup input for %s\n",
+						sdinfo->module_name);
+				goto probe_sd_out;
+			}
+			/* Load up the subdevice */
+			vpfe_dev->sd[k] =
+				v4l2_i2c_new_subdev_board(&vpfe_dev->v4l2_dev,
+						  i2c_adap, &sdinfo->board_info,
+						  NULL);
+			if (vpfe_dev->sd[k]) {
+				v4l2_info(&vpfe_dev->v4l2_dev,
+						"v4l2 sub device %s registered\n",
+						sdinfo->module_name);
+
+				vpfe_dev->sd[k]->grp_id = sdinfo->grp_id;
+				k++;
+
+				sdinfo->registered = 1;
+			}
+		} else {
+			v4l2_info(&vpfe_dev->v4l2_dev,
+				  "v4l2 sub device %s is not registered\n",
+				  sdinfo->module_name);
+		}
+	}
+	vpfe_dev->num_ext_subdevs = k;
+
+	return 0;
+
+probe_sd_out:
+	kzfree(vpfe_dev->sd);
+
+	return ret;
+}
+
+/*
+ * vpfe_register_entities() - register all v4l2 subdevs and media entities
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * register all v4l2 subdevs, media entities, and creates links
+ * between entities
+ */
+static int vpfe_register_entities(struct vpfe_device *vpfe_dev)
+{
+	unsigned int flags = 0;
+	int ret;
+	int i;
+
+	/* register i2c devices first */
+	ret = register_i2c_devices(vpfe_dev);
+	if (ret)
+		return ret;
+
+	/* register rest of the sub-devs */
+	ret = vpfe_isif_register_entities(&vpfe_dev->vpfe_isif,
+					  &vpfe_dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	ret = vpfe_ipipeif_register_entities(&vpfe_dev->vpfe_ipipeif,
+					     &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_isif_register;
+
+	ret = vpfe_ipipe_register_entities(&vpfe_dev->vpfe_ipipe,
+					   &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_ipipeif_register;
+
+	ret = vpfe_resizer_register_entities(&vpfe_dev->vpfe_resizer,
+					     &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_ipipe_register;
+
+	/* create links now, starting with external(i2c) entities */
+	for (i = 0; i < vpfe_dev->num_ext_subdevs; i++)
+		/* if entity has no pads (ex: amplifier),
+		   cant establish link */
+		if (vpfe_dev->sd[i]->entity.num_pads) {
+			ret = media_entity_create_link(&vpfe_dev->sd[i]->entity,
+				0, &vpfe_dev->vpfe_isif.subdev.entity,
+				0, flags);
+			if (ret < 0)
+				goto out_resizer_register;
+		}
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_isif.subdev.entity, 1,
+				       &vpfe_dev->vpfe_ipipeif.subdev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
+				       &vpfe_dev->vpfe_ipipe.subdev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ipipe.subdev.entity,
+			1, &vpfe_dev->vpfe_resizer.crop_resizer.subdev.entity,
+			0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
+			&vpfe_dev->vpfe_resizer.crop_resizer.subdev.entity,
+			0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = v4l2_device_register_subdev_nodes(&vpfe_dev->v4l2_dev);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	return 0;
+
+out_resizer_register:
+	vpfe_resizer_unregister_entities(&vpfe_dev->vpfe_resizer);
+out_ipipe_register:
+	vpfe_ipipe_unregister_entities(&vpfe_dev->vpfe_ipipe);
+out_ipipeif_register:
+	vpfe_ipipeif_unregister_entities(&vpfe_dev->vpfe_ipipeif);
+out_isif_register:
+	vpfe_isif_unregister_entities(&vpfe_dev->vpfe_isif);
+
+	return ret;
+}
+
+/*
+ * vpfe_unregister_entities() - unregister all v4l2 subdevs and media entities
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * unregister all v4l2 subdevs and media entities
+ */
+static void vpfe_unregister_entities(struct vpfe_device *vpfe_dev)
+{
+	vpfe_isif_unregister_entities(&vpfe_dev->vpfe_isif);
+	vpfe_ipipeif_unregister_entities(&vpfe_dev->vpfe_ipipeif);
+	vpfe_ipipe_unregister_entities(&vpfe_dev->vpfe_ipipe);
+	vpfe_resizer_unregister_entities(&vpfe_dev->vpfe_resizer);
+}
+
+/*
+ * vpfe_cleanup_modules() - cleanup all non-i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ * @pdev - pointer to platform device
+ *
+ * cleanup all v4l2 subdevs
+ */
+static void vpfe_cleanup_modules(struct vpfe_device *vpfe_dev,
+				 struct platform_device *pdev)
+{
+	vpfe_isif_cleanup(&vpfe_dev->vpfe_isif, pdev);
+	vpfe_ipipeif_cleanup(&vpfe_dev->vpfe_ipipeif, pdev);
+	vpfe_ipipe_cleanup(&vpfe_dev->vpfe_ipipe, pdev);
+	vpfe_resizer_cleanup(&vpfe_dev->vpfe_resizer, pdev);
+}
+
+/*
+ * vpfe_initialize_modules() - initialize all non-i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ * @pdev - pointer to platform device
+ *
+ * intialize all v4l2 subdevs and media entities
+ */
+static int vpfe_initialize_modules(struct vpfe_device *vpfe_dev,
+				   struct platform_device *pdev)
+{
+	int ret;
+
+	ret = vpfe_isif_init(&vpfe_dev->vpfe_isif, pdev);
+	if (ret)
+		return ret;
+
+	ret = vpfe_ipipeif_init(&vpfe_dev->vpfe_ipipeif, pdev);
+	if (ret)
+		goto out_isif_init;
+
+	ret = vpfe_ipipe_init(&vpfe_dev->vpfe_ipipe, pdev);
+	if (ret)
+		goto out_ipipeif_init;
+
+	ret = vpfe_resizer_init(&vpfe_dev->vpfe_resizer, pdev);
+	if (ret)
+		goto out_ipipe_init;
+
+	return 0;
+
+out_ipipe_init:
+	vpfe_ipipe_cleanup(&vpfe_dev->vpfe_ipipe, pdev);
+out_ipipeif_init:
+	vpfe_ipipeif_cleanup(&vpfe_dev->vpfe_ipipeif, pdev);
+out_isif_init:
+	vpfe_isif_cleanup(&vpfe_dev->vpfe_isif, pdev);
+
+	return ret;
+}
+
+/*
+ * vpfe_probe() : vpfe probe function
+ * @pdev: platform device pointer
+ *
+ * This function creates device entries by register itself to the V4L2 driver
+ * and initializes fields of each device objects
+ */
+static __devinit int vpfe_probe(struct platform_device *pdev)
+{
+	struct vpfe_device *vpfe_dev;
+	struct resource *res1;
+	int ret = -ENOMEM;
+
+	vpfe_dev = kzalloc(sizeof(*vpfe_dev), GFP_KERNEL);
+	if (!vpfe_dev) {
+		v4l2_err(pdev->dev.driver,
+			"Failed to allocate memory for vpfe_dev\n");
+		return ret;
+	}
+
+	if (pdev->dev.platform_data == NULL) {
+		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+
+	vpfe_dev->cfg = pdev->dev.platform_data;
+	if (vpfe_dev->cfg->card_name == NULL ||
+			vpfe_dev->cfg->sub_devs == NULL) {
+		v4l2_err(pdev->dev.driver, "null ptr in vpfe_cfg\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+
+	/* Get VINT0 irq resource */
+	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res1) {
+		v4l2_err(pdev->dev.driver,
+			 "Unable to get interrupt for VINT0\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+	vpfe_dev->ccdc_irq0 = res1->start;
+
+	/* Get VINT1 irq resource */
+	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	if (!res1) {
+		v4l2_err(pdev->dev.driver,
+			 "Unable to get interrupt for VINT1\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+	vpfe_dev->ccdc_irq1 = res1->start;
+
+	/* Get DMA irq resource */
+	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 2);
+	if (!res1) {
+		v4l2_err(pdev->dev.driver,
+			 "Unable to get interrupt for DMA\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+	vpfe_dev->imp_dma_irq = res1->start;
+
+	vpfe_dev->pdev = &pdev->dev;
+
+	/* enable vpss clocks */
+	ret = vpfe_enable_clock(vpfe_dev);
+	if (ret)
+		goto probe_free_dev_mem;
+
+	if (vpfe_initialize_modules(vpfe_dev, pdev))
+		goto probe_disable_clock;
+
+	vpfe_dev->media_dev.dev = vpfe_dev->pdev;
+	strcpy((char *)&vpfe_dev->media_dev.model, "davinci-media");
+
+	ret = media_device_register(&vpfe_dev->media_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver,
+			"Unable to register media device.\n");
+		goto probe_out_entities_cleanup;
+	}
+
+	vpfe_dev->v4l2_dev.mdev = &vpfe_dev->media_dev;
+	ret = v4l2_device_register(&pdev->dev, &vpfe_dev->v4l2_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver, "Unable to register v4l2 device.\n");
+		goto probe_out_media_unregister;
+	}
+
+	v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 device registered\n");
+	/* set the driver data in platform device */
+	platform_set_drvdata(pdev, vpfe_dev);
+	/* register subdevs/entities */
+	if (vpfe_register_entities(vpfe_dev))
+		goto probe_out_v4l2_unregister;
+
+	ret = vpfe_attach_irq(vpfe_dev);
+	if (ret)
+		goto probe_out_entities_unregister;
+
+	return 0;
+
+probe_out_entities_unregister:
+	vpfe_unregister_entities(vpfe_dev);
+	kzfree(vpfe_dev->sd);
+probe_out_v4l2_unregister:
+	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
+probe_out_media_unregister:
+	media_device_unregister(&vpfe_dev->media_dev);
+probe_out_entities_cleanup:
+	vpfe_cleanup_modules(vpfe_dev, pdev);
+probe_disable_clock:
+	vpfe_disable_clock(vpfe_dev);
+probe_free_dev_mem:
+	kzfree(vpfe_dev);
+
+	return ret;
+}
+
+/*
+ * vpfe_remove : This function un-registers device from V4L2 driver
+ */
+static int vpfe_remove(struct platform_device *pdev)
+{
+	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
+
+	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
+
+	kzfree(vpfe_dev->sd);
+	vpfe_detach_irq(vpfe_dev);
+	vpfe_unregister_entities(vpfe_dev);
+	vpfe_cleanup_modules(vpfe_dev, pdev);
+	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
+	media_device_unregister(&vpfe_dev->media_dev);
+	vpfe_disable_clock(vpfe_dev);
+	kzfree(vpfe_dev);
+
+	return 0;
+}
+
+static struct platform_driver vpfe_driver = {
+	.driver = {
+		.name = CAPTURE_DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = vpfe_probe,
+	.remove = __devexit_p(vpfe_remove),
+};
+
+/**
+ * vpfe_init : This function registers device driver
+ */
+static __init int vpfe_init(void)
+{
+	/* Register driver to the kernel */
+	return platform_driver_register(&vpfe_driver);
+}
+
+/**
+ * vpfe_cleanup : This function un-registers device driver
+ */
+static void vpfe_cleanup(void)
+{
+	platform_driver_unregister(&vpfe_driver);
+}
+
+module_init(vpfe_init);
+module_exit(vpfe_cleanup);
diff --git a/drivers/media/platform/davinci/vpfe_mc_capture.h b/drivers/media/platform/davinci/vpfe_mc_capture.h
new file mode 100644
index 0000000..68f6fe4
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_mc_capture.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_MC_CAPTURE_H
+#define _DAVINCI_VPFE_MC_CAPTURE_H
+
+#include "dm365_ipipe.h"
+#include "dm365_ipipeif.h"
+#include "dm365_isif.h"
+#include "dm365_resizer.h"
+#include "vpfe_video.h"
+
+#define VPFE_MAJOR_RELEASE		0
+#define VPFE_MINOR_RELEASE		0
+#define VPFE_BUILD			1
+#define VPFE_CAPTURE_VERSION_CODE       ((VPFE_MAJOR_RELEASE << 16) | \
+					(VPFE_MINOR_RELEASE << 8)  | \
+					VPFE_BUILD)
+
+/* IPIPE hardware limits */
+#define IPIPE_MAX_OUTPUT_WIDTH_A	2176
+#define IPIPE_MAX_OUTPUT_WIDTH_B	640
+
+/* Based on max resolution supported. QXGA */
+#define IPIPE_MAX_OUTPUT_HEIGHT_A	1536
+/* Based on max resolution supported. VGA */
+#define IPIPE_MAX_OUTPUT_HEIGHT_B	480
+
+#define to_vpfe_device(ptr_module)				\
+	container_of(ptr_module, struct vpfe_device, vpfe_##ptr_module)
+#define to_device(ptr_module)						\
+	(to_vpfe_device(ptr_module)->dev)
+
+struct vpfe_device {
+	/* external registered sub devices */
+	struct v4l2_subdev		**sd;
+	/* number of registered external subdevs */
+	unsigned int			num_ext_subdevs;
+	/* vpfe cfg */
+	struct vpfe_config		*cfg;
+	/* clock ptrs for vpfe capture */
+	struct clk			**clks;
+	/* V4l2 device */
+	struct v4l2_device		v4l2_dev;
+	/* parent device */
+	struct device			*pdev;
+	/* IRQ number for DMA transfer completion at the image processor */
+	unsigned int			imp_dma_irq;
+	/* CCDC IRQs used when CCDC/ISIF output to SDRAM */
+	unsigned int			ccdc_irq0;
+	unsigned int			ccdc_irq1;
+	/* maximum video memory that is available*/
+	unsigned int			video_limit;
+	/* media device */
+	struct media_device		media_dev;
+	/* ccdc subdevice */
+	struct vpfe_isif_device		vpfe_isif;
+	/* ipipeif subdevice */
+	struct vpfe_ipipeif_device	vpfe_ipipeif;
+	/* ipipe subdevice */
+	struct vpfe_ipipe_device	vpfe_ipipe;
+	/* resizer subdevice */
+	struct vpfe_resizer_device	vpfe_resizer;
+};
+
+/* File handle structure */
+struct vpfe_fh {
+	struct v4l2_fh vfh;
+	struct vpfe_video_device *video;
+	/* Indicates whether this file handle is doing IO */
+	u8 io_allowed;
+	/* Used to keep track priority of this instance */
+	enum v4l2_priority prio;
+};
+
+void mbus_to_pix(const struct v4l2_mbus_framefmt *mbus,
+			   struct v4l2_pix_format *pix);
+
+#endif		/* _DAVINCI_VPFE_MC_CAPTURE_H */
diff --git a/include/media/davinci/vpfe.h b/include/media/davinci/vpfe.h
new file mode 100644
index 0000000..0587bc5
--- /dev/null
+++ b/include/media/davinci/vpfe.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _VPFE_H
+#define _VPFE_H
+
+#ifdef __KERNEL__
+#include <linux/v4l2-subdev.h>
+#include <linux/clk.h>
+#include <linux/i2c.h>
+
+#include <media/davinci/vpfe_types.h>
+
+#define CAPTURE_DRV_NAME	"vpfe-capture"
+
+struct vpfe_route {
+	__u32 input;
+	__u32 output;
+};
+
+enum vpfe_subdev_id {
+	VPFE_SUBDEV_TVP5146 = 1,
+	VPFE_SUBDEV_MT9T031 = 2,
+	VPFE_SUBDEV_TVP7002 = 3,
+	VPFE_SUBDEV_MT9P031 = 4,
+};
+
+struct vpfe_ext_subdev_info {
+	/* v4l2 subdev */
+	struct v4l2_subdev *subdev;
+	/* Sub device module name */
+	char module_name[32];
+	/* Sub device group id */
+	int grp_id;
+	/* Number of inputs supported */
+	int num_inputs;
+	/* inputs available at the sub device */
+	struct v4l2_input *inputs;
+	/* Sub dev routing information for each input */
+	struct vpfe_route *routes;
+	/* ccdc bus/interface configuration */
+	struct vpfe_hw_if_param ccdc_if_params;
+	/* i2c subdevice board info */
+	struct i2c_board_info board_info;
+	/* Is this a camera sub device ? */
+	unsigned is_camera:1;
+	/* check if sub dev supports routing */
+	unsigned can_route:1;
+	/* registered ? */
+	unsigned registered:1;
+};
+
+struct vpfe_config {
+	/* Number of sub devices connected to vpfe */
+	int num_subdevs;
+	/* information about each subdev */
+	struct vpfe_ext_subdev_info *sub_devs;
+	/* evm card info */
+	char *card_name;
+	/* setup function for the input path */
+	int (*setup_input)(enum vpfe_subdev_id id);
+	/* number of clocks */
+	int num_clocks;
+	/* clocks used for vpfe capture */
+	char *clocks[];
+};
+#endif
+#endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e194387..777d82e 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -87,6 +87,7 @@ header-y += cramfs_fs.h
 header-y += cuda.h
 header-y += cyclades.h
 header-y += cycx_cfm.h
+header-y += davinci_vpfe.h
 header-y += dcbnl.h
 header-y += dccp.h
 header-y += dlm.h
diff --git a/include/uapi/linux/davinci_vpfe.h b/include/uapi/linux/davinci_vpfe.h
new file mode 100644
index 0000000..e1b29ac
--- /dev/null
+++ b/include/uapi/linux/davinci_vpfe.h
@@ -0,0 +1,1285 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_USER_H
+#define _DAVINCI_VPFE_USER_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+/*
+ * Private IOCTL
+ *
+ * VIDIOC_VPFE_ISIF_S_RAW_PARAMS: Set raw params in isif
+ * VIDIOC_VPFE_ISIF_G_RAW_PARAMS: Get raw params from isif
+ * VIDIOC_VPFE_PRV_S_CONFIG: Set ipipe engine configuration
+ * VIDIOC_VPFE_PRV_G_CONFIG: Get ipipe engine configuration
+ * VIDIOC_VPFE_RSZ_S_CONFIG: Set resizer engine configuration
+ * VIDIOC_VPFE_RSZ_G_CONFIG: Get resizer engine configuration
+ */
+
+#define VIDIOC_VPFE_ISIF_S_RAW_PARAMS \
+	_IOW('V', BASE_VIDIOC_PRIVATE + 1,  struct vpfe_isif_raw_config)
+#define VIDIOC_VPFE_ISIF_G_RAW_PARAMS \
+	_IOR('V', BASE_VIDIOC_PRIVATE + 2, struct vpfe_isif_raw_config)
+#define VIDIOC_VPFE_IPIPE_S_CONFIG \
+	_IOWR('P', BASE_VIDIOC_PRIVATE + 3, struct vpfe_ipipe_config)
+#define VIDIOC_VPFE_IPIPE_G_CONFIG \
+	_IOWR('P', BASE_VIDIOC_PRIVATE + 4, struct vpfe_ipipe_config)
+#define VIDIOC_VPFE_RSZ_S_CONFIG \
+	_IOWR('R', BASE_VIDIOC_PRIVATE + 5, struct vpfe_rsz_config)
+#define VIDIOC_VPFE_RSZ_G_CONFIG \
+	_IOWR('R', BASE_VIDIOC_PRIVATE + 6, struct vpfe_rsz_config)
+
+/*
+ * Private Control's for ISIF
+ */
+#define VPFE_ISIF_CID_CRGAIN           (V4L2_CID_USER_BASE | 0xa001)
+#define VPFE_ISIF_CID_CGRGAIN          (V4L2_CID_USER_BASE | 0xa002)
+#define VPFE_ISIF_CID_CGBGAIN          (V4L2_CID_USER_BASE | 0xa003)
+#define VPFE_ISIF_CID_CBGAIN           (V4L2_CID_USER_BASE | 0xa004)
+#define VPFE_ISIF_CID_GAIN_OFFSET      (V4L2_CID_USER_BASE | 0xa005)
+
+/************************************************************************
+ *   Vertical Defect Correction parameters
+ ***********************************************************************/
+
+/**
+ * vertical defect correction methods
+ */
+enum vpfe_isif_vdfc_corr_mode {
+	/* Defect level subtraction. Just fed through if saturating */
+	VPFE_ISIF_VDFC_NORMAL,
+	/**
+	 * Defect level subtraction. Horizontal interpolation ((i-2)+(i+2))/2
+	 * if data saturating
+	 */
+	VPFE_ISIF_VDFC_HORZ_INTERPOL_IF_SAT,
+	/* Horizontal interpolation (((i-2)+(i+2))/2) */
+	VPFE_ISIF_VDFC_HORZ_INTERPOL
+};
+
+/**
+ * Max Size of the Vertical Defect Correction table
+ */
+#define VPFE_ISIF_VDFC_TABLE_SIZE	8
+
+/**
+ * Values used for shifting up the vdfc defect level
+ */
+enum vpfe_isif_vdfc_shift {
+	/* No Shift */
+	VPFE_ISIF_VDFC_NO_SHIFT,
+	/* Shift by 1 bit */
+	VPFE_ISIF_VDFC_SHIFT_1,
+	/* Shift by 2 bit */
+	VPFE_ISIF_VDFC_SHIFT_2,
+	/* Shift by 3 bit */
+	VPFE_ISIF_VDFC_SHIFT_3,
+	/* Shift by 4 bit */
+	VPFE_ISIF_VDFC_SHIFT_4
+};
+
+/**
+ * Defect Correction (DFC) table entry
+ */
+struct vpfe_isif_vdfc_entry {
+	/* vertical position of defect */
+	unsigned short pos_vert;
+	/* horizontal position of defect */
+	unsigned short pos_horz;
+	/**
+	 * Defect level of Vertical line defect position. This is subtracted
+	 * from the data at the defect position
+	 */
+	unsigned char level_at_pos;
+	/**
+	 * Defect level of the pixels upper than the vertical line defect.
+	 * This is subtracted from the data
+	 */
+	unsigned char level_up_pixels;
+	/**
+	 * Defect level of the pixels lower than the vertical line defect.
+	 * This is subtracted from the data
+	 */
+	unsigned char level_low_pixels;
+};
+
+/**
+ * Structure for Defect Correction (DFC) parameter
+ */
+struct vpfe_isif_dfc {
+	/* enable vertical defect correction */
+	unsigned char en;
+	/* Correction methods */
+	enum vpfe_isif_vdfc_corr_mode corr_mode;
+	/**
+	 * 0 - whole line corrected, 1 - not
+	 * pixels upper than the defect
+	 */
+	unsigned char corr_whole_line;
+	/**
+	 * defect level shift value. level_at_pos, level_upper_pos,
+	 * and level_lower_pos can be shifted up by this value
+	 */
+	enum vpfe_isif_vdfc_shift def_level_shift;
+	/* defect saturation level */
+	unsigned short def_sat_level;
+	/* number of vertical defects. Max is VPFE_ISIF_VDFC_TABLE_SIZE */
+	short num_vdefects;
+	/* VDFC table ptr */
+	struct vpfe_isif_vdfc_entry table[VPFE_ISIF_VDFC_TABLE_SIZE];
+};
+
+/************************************************************************
+*   Digital/Black clamp or DC Subtract parameters
+************************************************************************/
+/**
+ * Horizontal Black Clamp modes
+ */
+enum vpfe_isif_horz_bc_mode {
+	/**
+	 * Horizontal clamp disabled. Only vertical clamp
+	 * value is subtracted
+	 */
+	VPFE_ISIF_HORZ_BC_DISABLE,
+	/**
+	 * Horizontal clamp value is calculated and subtracted
+	 * from image data along with vertical clamp value
+	 */
+	VPFE_ISIF_HORZ_BC_CLAMP_CALC_ENABLED,
+	/**
+	 * Horizontal clamp value calculated from previous image
+	 * is subtracted from image data along with vertical clamp
+	 * value. How the horizontal clamp value for the first image
+	 * is calculated in this case ???
+	 */
+	VPFE_ISIF_HORZ_BC_CLAMP_NOT_UPDATED
+};
+
+/**
+ * Base window selection for Horizontal Black Clamp calculations
+ */
+enum vpfe_isif_horz_bc_base_win_sel {
+	/* Select Most left window for bc calculation */
+	VPFE_ISIF_SEL_MOST_LEFT_WIN,
+
+	/* Select Most right window for bc calculation */
+	VPFE_ISIF_SEL_MOST_RIGHT_WIN,
+};
+
+/* Size of window in horizontal direction for horizontal bc */
+enum vpfe_isif_horz_bc_sz_h {
+	VPFE_ISIF_HORZ_BC_SZ_H_2PIXELS,
+	VPFE_ISIF_HORZ_BC_SZ_H_4PIXELS,
+	VPFE_ISIF_HORZ_BC_SZ_H_8PIXELS,
+	VPFE_ISIF_HORZ_BC_SZ_H_16PIXELS
+};
+
+/* Size of window in vertcal direction for vertical bc */
+enum vpfe_isif_horz_bc_sz_v {
+	VPFE_ISIF_HORZ_BC_SZ_H_32PIXELS,
+	VPFE_ISIF_HORZ_BC_SZ_H_64PIXELS,
+	VPFE_ISIF_HORZ_BC_SZ_H_128PIXELS,
+	VPFE_ISIF_HORZ_BC_SZ_H_256PIXELS
+};
+
+/**
+ * Structure for Horizontal Black Clamp config params
+ */
+struct vpfe_isif_horz_bclamp {
+	/* horizontal clamp mode */
+	enum vpfe_isif_horz_bc_mode mode;
+	/**
+	 * pixel value limit enable.
+	 *  0 - limit disabled
+	 *  1 - pixel value limited to 1023
+	 */
+	unsigned char clamp_pix_limit;
+	/**
+	 * Select most left or right window for clamp val
+	 * calculation
+	 */
+	enum vpfe_isif_horz_bc_base_win_sel base_win_sel_calc;
+	/* Window count per color for calculation. range 1-32 */
+	unsigned char win_count_calc;
+	/* Window start position - horizontal for calculation. 0 - 8191 */
+	unsigned short win_start_h_calc;
+	/* Window start position - vertical for calculation 0 - 8191 */
+	unsigned short win_start_v_calc;
+	/* Width of the sample window in pixels for calculation */
+	enum vpfe_isif_horz_bc_sz_h win_h_sz_calc;
+	/* Height of the sample window in pixels for calculation */
+	enum vpfe_isif_horz_bc_sz_v win_v_sz_calc;
+};
+
+/**
+ * Black Clamp vertical reset values
+ */
+enum vpfe_isif_vert_bc_reset_val_sel {
+	/* Reset value used is the clamp value calculated */
+	VPFE_ISIF_VERT_BC_USE_HORZ_CLAMP_VAL,
+	/* Reset value used is reset_clamp_val configured */
+	VPFE_ISIF_VERT_BC_USE_CONFIG_CLAMP_VAL,
+	/* No update, previous image value is used */
+	VPFE_ISIF_VERT_BC_NO_UPDATE
+};
+
+enum vpfe_isif_vert_bc_sz_h {
+	VPFE_ISIF_VERT_BC_SZ_H_2PIXELS,
+	VPFE_ISIF_VERT_BC_SZ_H_4PIXELS,
+	VPFE_ISIF_VERT_BC_SZ_H_8PIXELS,
+	VPFE_ISIF_VERT_BC_SZ_H_16PIXELS,
+	VPFE_ISIF_VERT_BC_SZ_H_32PIXELS,
+	VPFE_ISIF_VERT_BC_SZ_H_64PIXELS
+};
+
+/**
+ * Structure for Vertical Black Clamp configuration params
+ */
+struct vpfe_isif_vert_bclamp {
+	/* Reset value selection for vertical clamp calculation */
+	enum vpfe_isif_vert_bc_reset_val_sel reset_val_sel;
+	/* U12 value if reset_sel = ISIF_BC_VERT_USE_CONFIG_CLAMP_VAL */
+	unsigned short reset_clamp_val;
+	/**
+	 * U8Q8. Line average coefficient used in vertical clamp
+	 * calculation
+	 */
+	unsigned char line_ave_coef;
+	/* Width in pixels of the optical black region used for calculation. */
+	enum vpfe_isif_vert_bc_sz_h ob_h_sz_calc;
+	/* Height of the optical black region for calculation */
+	unsigned short ob_v_sz_calc;
+	/* Optical black region start position - horizontal. 0 - 8191 */
+	unsigned short ob_start_h;
+	/* Optical black region start position - vertical 0 - 8191 */
+	unsigned short ob_start_v;
+};
+
+/**
+ * Structure for Black Clamp configuration params
+ */
+struct vpfe_isif_black_clamp {
+	/**
+	 * this offset value is added irrespective of the clamp
+	 * enable status. S13
+	 */
+	unsigned short dc_offset;
+	/**
+	 * Enable black/digital clamp value to be subtracted
+	 * from the image data
+	 */
+	unsigned char en;
+	/**
+	 * black clamp mode. same/separate clamp for 4 colors
+	 * 0 - disable - same clamp value for all colors
+	 * 1 - clamp value calculated separately for all colors
+	 */
+	unsigned char bc_mode_color;
+	/* Vertical start position for bc subtraction */
+	unsigned short vert_start_sub;
+	/* Black clamp for horizontal direction */
+	struct vpfe_isif_horz_bclamp horz;
+	/* Black clamp for vertical direction */
+	struct vpfe_isif_vert_bclamp vert;
+};
+
+/*************************************************************************
+** Color Space Conversion (CSC)
+*************************************************************************/
+/**
+ * Number of Coefficient values used for CSC
+ */
+#define VPFE_ISIF_CSC_NUM_COEFF 16
+
+struct float_8_bit {
+	/* 8 bit integer part */
+	__u8 integer;
+	/* 8 bit decimal part */
+	__u8 decimal;
+};
+
+struct float_16_bit {
+	/* 16 bit integer part */
+	__u16 integer;
+	/* 16 bit decimal part */
+	__u16 decimal;
+};
+
+/*************************************************************************
+**  Color Space Conversion parameters
+*************************************************************************/
+/**
+ * Structure used for CSC config params
+ */
+struct vpfe_isif_color_space_conv {
+	/* Enable color space conversion */
+	unsigned char en;
+	/**
+	 * csc coefficient table. S8Q5, M00 at index 0, M01 at index 1, and
+	 * so forth
+	 */
+	struct float_8_bit coeff[VPFE_ISIF_CSC_NUM_COEFF];
+};
+
+enum vpfe_isif_datasft {
+	/* No Shift */
+	VPFE_ISIF_NO_SHIFT,
+	/* 1 bit Shift */
+	VPFE_ISIF_1BIT_SHIFT,
+	/* 2 bit Shift */
+	VPFE_ISIF_2BIT_SHIFT,
+	/* 3 bit Shift */
+	VPFE_ISIF_3BIT_SHIFT,
+	/* 4 bit Shift */
+	VPFE_ISIF_4BIT_SHIFT,
+	/* 5 bit Shift */
+	VPFE_ISIF_5BIT_SHIFT,
+	/* 6 bit Shift */
+	VPFE_ISIF_6BIT_SHIFT
+};
+
+#define VPFE_ISIF_LINEAR_TAB_SIZE		192
+/*************************************************************************
+**  Linearization parameters
+*************************************************************************/
+/**
+ * Structure for Sensor data linearization
+ */
+struct vpfe_isif_linearize {
+	/* Enable or Disable linearization of data */
+	unsigned char en;
+	/* Shift value applied */
+	enum vpfe_isif_datasft corr_shft;
+	/* scale factor applied U11Q10 */
+	struct float_16_bit scale_fact;
+	/* Size of the linear table */
+	unsigned short table[VPFE_ISIF_LINEAR_TAB_SIZE];
+};
+
+/*************************************************************************
+**  ISIF Raw configuration parameters
+*************************************************************************/
+enum vpfe_isif_fmt_mode {
+	VPFE_ISIF_SPLIT,
+	VPFE_ISIF_COMBINE
+};
+
+enum vpfe_isif_lnum {
+	VPFE_ISIF_1LINE,
+	VPFE_ISIF_2LINES,
+	VPFE_ISIF_3LINES,
+	VPFE_ISIF_4LINES
+};
+
+enum vpfe_isif_line {
+	VPFE_ISIF_1STLINE,
+	VPFE_ISIF_2NDLINE,
+	VPFE_ISIF_3RDLINE,
+	VPFE_ISIF_4THLINE
+};
+
+struct vpfe_isif_fmtplen {
+	/**
+	 * number of program entries for SET0, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	unsigned short plen0;
+	/**
+	 * number of program entries for SET1, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	unsigned short plen1;
+	/**
+	 * number of program entries for SET2, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	unsigned short plen2;
+	/**
+	 * number of program entries for SET3, range 1 - 16
+	 * when fmtmode is ISIF_SPLIT, 1 - 8 when fmtmode is
+	 * ISIF_COMBINE
+	 */
+	unsigned short plen3;
+};
+
+struct vpfe_isif_fmt_cfg {
+	/* Split or combine or line alternate */
+	enum vpfe_isif_fmt_mode fmtmode;
+	/* enable or disable line alternating mode */
+	unsigned char ln_alter_en;
+	/* Split/combine line number */
+	enum vpfe_isif_lnum lnum;
+	/* Address increment Range 1 - 16 */
+	unsigned int addrinc;
+};
+
+struct vpfe_isif_fmt_addr_ptr {
+	/* Initial address */
+	unsigned int init_addr;
+	/* output line number */
+	enum vpfe_isif_line out_line;
+};
+
+struct vpfe_isif_fmtpgm_ap {
+	/* program address pointer */
+	unsigned char pgm_aptr;
+	/* program address increment or decrement */
+	unsigned char pgmupdt;
+};
+
+struct vpfe_isif_data_formatter {
+	/* Enable/Disable data formatter */
+	unsigned char en;
+	/* data formatter configuration */
+	struct vpfe_isif_fmt_cfg cfg;
+	/* Formatter program entries length */
+	struct vpfe_isif_fmtplen plen;
+	/* first pixel in a line fed to formatter */
+	unsigned short fmtrlen;
+	/* HD interval for output line. Only valid when split line */
+	unsigned short fmthcnt;
+	/* formatter address pointers */
+	struct vpfe_isif_fmt_addr_ptr fmtaddr_ptr[16];
+	/* program enable/disable */
+	unsigned char pgm_en[32];
+	/* program address pointers */
+	struct vpfe_isif_fmtpgm_ap fmtpgm_ap[32];
+};
+
+struct vpfe_isif_df_csc {
+	/* Color Space Conversion configuration, 0 - csc, 1 - df */
+	unsigned int df_or_csc;
+	/* csc configuration valid if df_or_csc is 0 */
+	struct vpfe_isif_color_space_conv csc;
+	/* data formatter configuration valid if df_or_csc is 1 */
+	struct vpfe_isif_data_formatter df;
+	/* start pixel in a line at the input */
+	unsigned int start_pix;
+	/* number of pixels in input line */
+	unsigned int num_pixels;
+	/* start line at the input */
+	unsigned int start_line;
+	/* number of lines at the input */
+	unsigned int num_lines;
+};
+
+struct vpfe_isif_gain_offsets_adj {
+	/* Enable or Disable Gain adjustment for SDRAM data */
+	unsigned char gain_sdram_en;
+	/* Enable or Disable Gain adjustment for IPIPE data */
+	unsigned char gain_ipipe_en;
+	/* Enable or Disable Gain adjustment for H3A data */
+	unsigned char gain_h3a_en;
+	/* Enable or Disable Gain adjustment for SDRAM data */
+	unsigned char offset_sdram_en;
+	/* Enable or Disable Gain adjustment for IPIPE data */
+	unsigned char offset_ipipe_en;
+	/* Enable or Disable Gain adjustment for H3A data */
+	unsigned char offset_h3a_en;
+};
+
+struct vpfe_isif_cul {
+	/* Horizontal Cull pattern for odd lines */
+	unsigned char hcpat_odd;
+	/* Horizontal Cull pattern for even lines */
+	unsigned char hcpat_even;
+	/* Vertical Cull pattern */
+	unsigned char vcpat;
+	/* Enable or disable lpf. Apply when cull is enabled */
+	unsigned char en_lpf;
+};
+
+/* all the stuff in this struct will be provided by userland */
+struct vpfe_isif_raw_config {
+	/* Linearization parameters for image sensor data input */
+	struct vpfe_isif_linearize linearize;
+	/* Data formatter or CSC */
+	struct vpfe_isif_df_csc df_csc;
+	/* Defect Pixel Correction (DFC) confguration */
+	struct vpfe_isif_dfc dfc;
+	/* Black/Digital Clamp configuration */
+	struct vpfe_isif_black_clamp bclamp;
+	/* Gain, offset adjustments */
+	struct vpfe_isif_gain_offsets_adj gain_offset;
+	/* Culling */
+	struct vpfe_isif_cul culling;
+	/* horizontal offset for Gain/LSC/DFC */
+	unsigned short horz_offset;
+	/* vertical offset for Gain/LSC/DFC */
+	unsigned short vert_offset;
+};
+
+/**********************************************************************
+      IPIPE API Structures
+**********************************************************************/
+
+/* IPIPE module configurations */
+
+/* IPIPE input configuration */
+#define VPFE_IPIPE_INPUT_CONFIG		(1 << 0)
+/* LUT based Defect Pixel Correction */
+#define VPFE_IPIPE_LUTDPC		(1 << 1)
+/* On the fly (OTF) Defect Pixel Correction */
+#define VPFE_IPIPE_OTFDPC		(1 << 2)
+/* Noise Filter - 1 */
+#define VPFE_IPIPE_NF1			(1 << 3)
+/* Noise Filter - 2 */
+#define VPFE_IPIPE_NF2			(1 << 4)
+/* White Balance.  Also a control ID */
+#define VPFE_IPIPE_WB			(1 << 5)
+/* 1st RGB to RBG Blend module */
+#define VPFE_IPIPE_RGB2RGB_1		(1 << 6)
+/* 2nd RGB to RBG Blend module */
+#define VPFE_IPIPE_RGB2RGB_2		(1 << 7)
+/* Gamma Correction */
+#define VPFE_IPIPE_GAMMA		(1 << 8)
+/* 3D LUT color conversion */
+#define VPFE_IPIPE_3D_LUT		(1 << 9)
+/* RGB to YCbCr module */
+#define VPFE_IPIPE_RGB2YUV		(1 << 10)
+/* YUV 422 conversion module */
+#define VPFE_IPIPE_YUV422_CONV		(1 << 11)
+/* Edge Enhancement */
+#define VPFE_IPIPE_YEE			(1 << 12)
+/* Green Imbalance Correction */
+#define VPFE_IPIPE_GIC			(1 << 13)
+/* CFA Interpolation */
+#define VPFE_IPIPE_CFA			(1 << 14)
+/* Chroma Artifact Reduction */
+#define VPFE_IPIPE_CAR			(1 << 15)
+/* Chroma Gain Suppression */
+#define VPFE_IPIPE_CGS			(1 << 16)
+/* Global brightness and contrast control */
+#define VPFE_IPIPE_GBCE			(1 << 17)
+
+#define VPFE_IPIPE_MAX_MODULES		18
+
+struct ipipe_float_u16 {
+	unsigned short integer;
+	unsigned short decimal;
+};
+
+struct ipipe_float_s16 {
+	short integer;
+	unsigned short decimal;
+};
+
+struct ipipe_float_u8 {
+	unsigned char integer;
+	unsigned char decimal;
+};
+
+/* Copy method selection for vertical correction
+ *  Used when ipipe_dfc_corr_meth is IPIPE_DPC_CTORB_AFTER_HINT
+ */
+enum vpfe_ipipe_dpc_corr_meth {
+	/* replace by black or white dot specified by repl_white */
+	VPFE_IPIPE_DPC_REPL_BY_DOT = 0,
+	/* Copy from left */
+	VPFE_IPIPE_DPC_CL = 1,
+	/* Copy from right */
+	VPFE_IPIPE_DPC_CR = 2,
+	/* Horizontal interpolation */
+	VPFE_IPIPE_DPC_H_INTP = 3,
+	/* Vertical interpolation */
+	VPFE_IPIPE_DPC_V_INTP = 4,
+	/* Copy from top  */
+	VPFE_IPIPE_DPC_CT = 5,
+	/* Copy from bottom */
+	VPFE_IPIPE_DPC_CB = 6,
+	/* 2D interpolation */
+	VPFE_IPIPE_DPC_2D_INTP = 7,
+};
+
+struct vpfe_ipipe_lutdpc_entry {
+	/* Horizontal position */
+	unsigned short horz_pos;
+	/* vertical position */
+	unsigned short vert_pos;
+	enum vpfe_ipipe_dpc_corr_meth method;
+};
+
+#define VPFE_IPIPE_MAX_SIZE_DPC 256
+
+/* Structure for configuring DPC module */
+struct vpfe_ipipe_lutdpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* 0 - replace with black dot, 1 - white dot when correction
+	 * method is  IPIPE_DFC_REPL_BY_DOT=0,
+	 */
+	unsigned char repl_white;
+	/* number of entries in the correction table. Currently only
+	 * support up-to 256 entries. infinite mode is not supported
+	 */
+	unsigned short dpc_size;
+	struct vpfe_ipipe_lutdpc_entry table[VPFE_IPIPE_MAX_SIZE_DPC];
+};
+
+enum vpfe_ipipe_otfdpc_det_meth {
+	VPFE_IPIPE_DPC_OTF_MIN_MAX,
+	VPFE_IPIPE_DPC_OTF_MIN_MAX2
+};
+
+struct vpfe_ipipe_otfdpc_thr {
+	unsigned short r;
+	unsigned short gr;
+	unsigned short gb;
+	unsigned short b;
+};
+
+enum vpfe_ipipe_otfdpc_alg {
+	VPFE_IPIPE_OTFDPC_2_0,
+	VPFE_IPIPE_OTFDPC_3_0
+};
+
+struct vpfe_ipipe_otfdpc_2_0_cfg {
+	/* defect detection threshold for MIN_MAX2 method  (DPC 2.0 alg) */
+	struct vpfe_ipipe_otfdpc_thr det_thr;
+	/* defect correction threshold for MIN_MAX2 method (DPC 2.0 alg) or
+	 * maximum value for MIN_MAX method
+	 */
+	struct vpfe_ipipe_otfdpc_thr corr_thr;
+};
+
+struct vpfe_ipipe_otfdpc_3_0_cfg {
+	/* DPC3.0 activity adj shf. activity = (max2-min2) >> (6 -shf)
+	 */
+	unsigned char act_adj_shf;
+	/* DPC3.0 detection threshold, THR */
+	unsigned short det_thr;
+	/* DPC3.0 detection threshold slope, SLP */
+	unsigned short det_slp;
+	/* DPC3.0 detection threshold min, MIN */
+	unsigned short det_thr_min;
+	/* DPC3.0 detection threshold max, MAX */
+	unsigned short det_thr_max;
+	/* DPC3.0 correction threshold, THR */
+	unsigned short corr_thr;
+	/* DPC3.0 correction threshold slope, SLP */
+	unsigned short corr_slp;
+	/* DPC3.0 correction threshold min, MIN */
+	unsigned short corr_thr_min;
+	/* DPC3.0 correction threshold max, MAX */
+	unsigned short corr_thr_max;
+};
+
+struct vpfe_ipipe_otfdpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum vpfe_ipipe_otfdpc_det_meth det_method;
+	/* Algorithm used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum vpfe_ipipe_otfdpc_alg alg;
+	union {
+		/* if alg is IPIPE_OTFDPC_2_0 */
+		struct vpfe_ipipe_otfdpc_2_0_cfg dpc_2_0;
+		/* if alg is IPIPE_OTFDPC_3_0 */
+		struct vpfe_ipipe_otfdpc_3_0_cfg dpc_3_0;
+	} alg_cfg;
+};
+
+/* Threshold values table size */
+#define VPFE_IPIPE_NF_THR_TABLE_SIZE		8
+/* Intensity values table size */
+#define VPFE_IPIPE_NF_STR_TABLE_SIZE		8
+
+/* NF, sampling method for green pixels */
+enum vpfe_ipipe_nf_sampl_meth {
+	/* Same as R or B */
+	VPFE_IPIPE_NF_BOX,
+	/* Diamond mode */
+	VPFE_IPIPE_NF_DIAMOND
+};
+
+/* Structure for configuring NF module */
+struct vpfe_ipipe_nf {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* Sampling method for green pixels */
+	enum vpfe_ipipe_nf_sampl_meth gr_sample_meth;
+	/* Down shift value in LUT reference address
+	 */
+	unsigned char shft_val;
+	/* Spread value in NF algorithm
+	 */
+	unsigned char spread_val;
+	/* Apply LSC gain to threshold. Enable this only if
+	 * LSC is enabled in ISIF
+	 */
+	unsigned char apply_lsc_gain;
+	/* Threshold values table */
+	unsigned short thr[VPFE_IPIPE_NF_THR_TABLE_SIZE];
+	/* intensity values table */
+	unsigned char str[VPFE_IPIPE_NF_STR_TABLE_SIZE];
+	/* Edge detection minimum threshold */
+	unsigned short edge_det_min_thr;
+	/* Edge detection maximum threshold */
+	unsigned short edge_det_max_thr;
+};
+
+enum vpfe_ipipe_gic_alg {
+	VPFE_IPIPE_GIC_ALG_CONST_GAIN,
+	VPFE_IPIPE_GIC_ALG_ADAPT_GAIN
+};
+
+enum vpfe_ipipe_gic_thr_sel {
+	VPFE_IPIPE_GIC_THR_REG,
+	VPFE_IPIPE_GIC_THR_NF
+};
+
+enum vpfe_ipipe_gic_wt_fn_type {
+	/* Use difference as index */
+	VPFE_IPIPE_GIC_WT_FN_TYP_DIF,
+	/* Use weight function as index */
+	VPFE_IPIPE_GIC_WT_FN_TYP_HP_VAL
+};
+
+/* structure for Green Imbalance Correction */
+struct vpfe_ipipe_gic {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* 0 - Constant gain , 1 - Adaptive gain algorithm */
+	enum vpfe_ipipe_gic_alg gic_alg;
+	/* GIC gain or weight. Used for Constant gain and Adaptive algorithms
+	 */
+	unsigned short gain;
+	/* Threshold selection. GIC register values or NF2 thr table */
+	enum vpfe_ipipe_gic_thr_sel thr_sel;
+	/* thr1. Used when thr_sel is  IPIPE_GIC_THR_REG */
+	unsigned short thr;
+	/* this value is used for thr2-thr1, thr3-thr2 or
+	 * thr4-thr3 when wt_fn_type is index. Otherwise it
+	 * is the
+	 */
+	unsigned short slope;
+	/* Apply LSC gain to threshold. Enable this only if
+	 * LSC is enabled in ISIF & thr_sel is IPIPE_GIC_THR_REG
+	 */
+	unsigned char apply_lsc_gain;
+	/* Multiply Nf2 threshold by this gain. Use this when thr_sel
+	 * is IPIPE_GIC_THR_NF
+	 */
+	struct ipipe_float_u8 nf2_thr_gain;
+	/* Weight function uses difference as index or high pass value.
+	 * Used for adaptive gain algorithm
+	 */
+	enum vpfe_ipipe_gic_wt_fn_type wt_fn_type;
+};
+
+/* Structure for configuring WB module */
+struct vpfe_ipipe_wb {
+	/* Offset (S12) for R */
+	short ofst_r;
+	/* Offset (S12) for Gr */
+	short ofst_gr;
+	/* Offset (S12) for Gb */
+	short ofst_gb;
+	/* Offset (S12) for B */
+	short ofst_b;
+	/* Gain (U13Q9) for Red */
+	struct ipipe_float_u16 gain_r;
+	/* Gain (U13Q9) for Gr */
+	struct ipipe_float_u16 gain_gr;
+	/* Gain (U13Q9) for Gb */
+	struct ipipe_float_u16 gain_gb;
+	/* Gain (U13Q9) for Blue */
+	struct ipipe_float_u16 gain_b;
+};
+
+enum vpfe_ipipe_cfa_alg {
+	/* Algorithm is 2DirAC */
+	VPFE_IPIPE_CFA_ALG_2DIRAC,
+	/* Algorithm is 2DirAC + Digital Antialiasing (DAA) */
+	VPFE_IPIPE_CFA_ALG_2DIRAC_DAA,
+	/* Algorithm is DAA */
+	VPFE_IPIPE_CFA_ALG_DAA
+};
+
+/* Structure for CFA Interpolation */
+struct vpfe_ipipe_cfa {
+	/* 2DirAC or 2DirAC + DAA */
+	enum vpfe_ipipe_cfa_alg alg;
+	/* 2Dir CFA HP value Low Threshold */
+	unsigned short hpf_thr_2dir;
+	/* 2Dir CFA HP value slope */
+	unsigned short hpf_slp_2dir;
+	/* 2Dir CFA HP mix threshold */
+	unsigned short hp_mix_thr_2dir;
+	/* 2Dir CFA HP mix slope */
+	unsigned short hp_mix_slope_2dir;
+	/* 2Dir Direction threshold */
+	unsigned short dir_thr_2dir;
+	/* 2Dir Direction slope */
+	unsigned short dir_slope_2dir;
+	/* 2Dir Non Directional Weight */
+	unsigned short nd_wt_2dir;
+	/* DAA Mono Hue Fraction */
+	unsigned short hue_fract_daa;
+	/* DAA Mono Edge threshold */
+	unsigned short edge_thr_daa;
+	/* DAA Mono threshold minimum */
+	unsigned short thr_min_daa;
+	/* DAA Mono threshold slope */
+	unsigned short thr_slope_daa;
+	/* DAA Mono slope minimum */
+	unsigned short slope_min_daa;
+	/* DAA Mono slope slope */
+	unsigned short slope_slope_daa;
+	/* DAA Mono LP wight */
+	unsigned short lp_wt_daa;
+};
+
+/* Struct for configuring RGB2RGB blending module */
+struct vpfe_ipipe_rgb2rgb {
+	/* Matrix coefficient for RR S12Q8 for ID = 1 and S11Q8 for ID = 2 */
+	struct ipipe_float_s16 coef_rr;
+	/* Matrix coefficient for GR S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gr;
+	/* Matrix coefficient for BR S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_br;
+	/* Matrix coefficient for RG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_rg;
+	/* Matrix coefficient for GG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gg;
+	/* Matrix coefficient for BG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_bg;
+	/* Matrix coefficient for RB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_rb;
+	/* Matrix coefficient for GB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gb;
+	/* Matrix coefficient for BB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_bb;
+	/* Output offset for R S13/S11 */
+	int out_ofst_r;
+	/* Output offset for G S13/S11 */
+	int out_ofst_g;
+	/* Output offset for B S13/S11 */
+	int out_ofst_b;
+};
+
+#define VPFE_IPIPE_MAX_SIZE_GAMMA		512
+
+enum vpfe_ipipe_gamma_tbl_size {
+	VPFE_IPIPE_GAMMA_TBL_SZ_64 = 64,
+	VPFE_IPIPE_GAMMA_TBL_SZ_128 = 128,
+	VPFE_IPIPE_GAMMA_TBL_SZ_256 = 256,
+	VPFE_IPIPE_GAMMA_TBL_SZ_512 = 512,
+};
+
+enum vpfe_ipipe_gamma_tbl_sel {
+	VPFE_IPIPE_GAMMA_TBL_RAM = 0,
+	VPFE_IPIPE_GAMMA_TBL_ROM = 1,
+};
+
+struct vpfe_ipipe_gamma_entry {
+	/* 10 bit slope */
+	short slope;
+	/* 10 bit offset */
+	unsigned short offset;
+};
+
+/* Structure for configuring Gamma correction module */
+struct vpfe_ipipe_gamma {
+	/* 0 - Enable Gamma correction for Red
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_r;
+	/* 0 - Enable Gamma correction for Blue
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_b;
+	/* 0 - Enable Gamma correction for Green
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_g;
+	/* IPIPE_GAMMA_TBL_RAM or IPIPE_GAMMA_TBL_ROM */
+	enum vpfe_ipipe_gamma_tbl_sel tbl_sel;
+	/* Table size for RAM gamma table.
+	 */
+	enum vpfe_ipipe_gamma_tbl_size tbl_size;
+	/* R table */
+	struct vpfe_ipipe_gamma_entry table_r[VPFE_IPIPE_MAX_SIZE_GAMMA];
+	/* Blue table */
+	struct vpfe_ipipe_gamma_entry table_b[VPFE_IPIPE_MAX_SIZE_GAMMA];
+	/* Green table */
+	struct vpfe_ipipe_gamma_entry table_g[VPFE_IPIPE_MAX_SIZE_GAMMA];
+};
+
+#define VPFE_IPIPE_MAX_SIZE_3D_LUT		729
+
+struct vpfe_ipipe_3d_lut_entry {
+	/* 10 bit entry for red */
+	unsigned short r;
+	/* 10 bit entry for green */
+	unsigned short g;
+	/* 10 bit entry for blue */
+	unsigned short b;
+};
+
+/* structure for 3D-LUT */
+struct vpfe_ipipe_3d_lut {
+	/* enable/disable 3D lut */
+	unsigned char en;
+	/* 3D - LUT table entry */
+	struct vpfe_ipipe_3d_lut_entry table[VPFE_IPIPE_MAX_SIZE_3D_LUT];
+};
+
+/* Struct for configuring rgb2ycbcr module */
+struct vpfe_ipipe_rgb2yuv {
+	/* Matrix coefficient for RY S12Q8 */
+	struct ipipe_float_s16 coef_ry;
+	/* Matrix coefficient for GY S12Q8 */
+	struct ipipe_float_s16 coef_gy;
+	/* Matrix coefficient for BY S12Q8 */
+	struct ipipe_float_s16 coef_by;
+	/* Matrix coefficient for RCb S12Q8 */
+	struct ipipe_float_s16 coef_rcb;
+	/* Matrix coefficient for GCb S12Q8 */
+	struct ipipe_float_s16 coef_gcb;
+	/* Matrix coefficient for BCb S12Q8 */
+	struct ipipe_float_s16 coef_bcb;
+	/* Matrix coefficient for RCr S12Q8 */
+	struct ipipe_float_s16 coef_rcr;
+	/* Matrix coefficient for GCr S12Q8 */
+	struct ipipe_float_s16 coef_gcr;
+	/* Matrix coefficient for BCr S12Q8 */
+	struct ipipe_float_s16 coef_bcr;
+	/* Output offset for R S11 */
+	int out_ofst_y;
+	/* Output offset for Cb S11 */
+	int out_ofst_cb;
+	/* Output offset for Cr S11 */
+	int out_ofst_cr;
+};
+
+enum vpfe_ipipe_gbce_type {
+	VPFE_IPIPE_GBCE_Y_VAL_TBL = 0,
+	VPFE_IPIPE_GBCE_GAIN_TBL = 1,
+};
+
+#define VPFE_IPIPE_MAX_SIZE_GBCE_LUT		1024
+
+/* structure for Global brightness and Contrast */
+struct vpfe_ipipe_gbce {
+	/* enable/disable GBCE */
+	unsigned char en;
+	/* Y - value table or Gain table */
+	enum vpfe_ipipe_gbce_type type;
+	/* ptr to LUT for GBCE with 1024 entries */
+	unsigned short table[VPFE_IPIPE_MAX_SIZE_GBCE_LUT];
+};
+
+/* Chrominance position. Applicable only for YCbCr input
+ * Applied after edge enhancement
+ */
+enum vpfe_chr_pos {
+	/* Co-siting, same position with luminance */
+	VPFE_IPIPE_YUV422_CHR_POS_COSITE = 0,
+	/* Centering, In the middle of luminance */
+	VPFE_IPIPE_YUV422_CHR_POS_CENTRE = 1,
+};
+
+/* Structure for configuring yuv422 conversion module */
+struct vpfe_ipipe_yuv422_conv {
+	/* Max Chrominance value */
+	unsigned char en_chrom_lpf;
+	/* 1 - enable LPF for chrminance, 0 - disable */
+	enum vpfe_chr_pos chrom_pos;
+};
+
+#define VPFE_IPIPE_MAX_SIZE_YEE_LUT		1024
+
+enum vpfe_ipipe_yee_merge_meth {
+	VPFE_IPIPE_YEE_ABS_MAX = 0,
+	VPFE_IPIPE_YEE_EE_ES = 1,
+};
+
+/* Structure for configuring YUV Edge Enhancement module */
+struct vpfe_ipipe_yee {
+	/* 1 - enable enhancement, 0 - disable */
+	unsigned char en;
+	/* enable/disable halo reduction in edge sharpner */
+	unsigned char en_halo_red;
+	/* Merge method between Edge Enhancer and Edge sharpner */
+	enum vpfe_ipipe_yee_merge_meth merge_meth;
+	/* HPF Shift length */
+	unsigned char hpf_shft;
+	/* HPF Coefficient 00, S10 */
+	short hpf_coef_00;
+	/* HPF Coefficient 01, S10 */
+	short hpf_coef_01;
+	/* HPF Coefficient 02, S10 */
+	short hpf_coef_02;
+	/* HPF Coefficient 10, S10 */
+	short hpf_coef_10;
+	/* HPF Coefficient 11, S10 */
+	short hpf_coef_11;
+	/* HPF Coefficient 12, S10 */
+	short hpf_coef_12;
+	/* HPF Coefficient 20, S10 */
+	short hpf_coef_20;
+	/* HPF Coefficient 21, S10 */
+	short hpf_coef_21;
+	/* HPF Coefficient 22, S10 */
+	short hpf_coef_22;
+	/* Lower threshold before referring to LUT */
+	unsigned short yee_thr;
+	/* Edge sharpener Gain */
+	unsigned short es_gain;
+	/* Edge sharpener lower threshold */
+	unsigned short es_thr1;
+	/* Edge sharpener upper threshold */
+	unsigned short es_thr2;
+	/* Edge sharpener gain on gradient */
+	unsigned short es_gain_grad;
+	/* Edge sharpener offset on gradient */
+	unsigned short es_ofst_grad;
+	/* Ptr to EE table. Must have 1024 entries */
+	short table[VPFE_IPIPE_MAX_SIZE_YEE_LUT];
+};
+
+enum vpfe_ipipe_car_meth {
+	/* Chromatic Gain Control */
+	VPFE_IPIPE_CAR_CHR_GAIN_CTRL = 0,
+	/* Dynamic switching between CHR_GAIN_CTRL
+	 * and MED_FLTR
+	 */
+	VPFE_IPIPE_CAR_DYN_SWITCH = 1,
+	/* Median Filter */
+	VPFE_IPIPE_CAR_MED_FLTR = 2,
+};
+
+enum vpfe_ipipe_car_hpf_type {
+	VPFE_IPIPE_CAR_HPF_Y = 0,
+	VPFE_IPIPE_CAR_HPF_H = 1,
+	VPFE_IPIPE_CAR_HPF_V = 2,
+	VPFE_IPIPE_CAR_HPF_2D = 3,
+	/* 2D HPF from YUV Edge Enhancement */
+	VPFE_IPIPE_CAR_HPF_2D_YEE = 4,
+};
+
+struct vpfe_ipipe_car_gain {
+	/* csup_gain */
+	unsigned char gain;
+	/* csup_shf. */
+	unsigned char shft;
+	/* gain minimum */
+	unsigned short gain_min;
+};
+
+/* Structure for Chromatic Artifact Reduction */
+struct vpfe_ipipe_car {
+	/* enable/disable */
+	unsigned char en;
+	/* Gain control or Dynamic switching */
+	enum vpfe_ipipe_car_meth meth;
+	/* Gain1 function configuration for Gain control */
+	struct vpfe_ipipe_car_gain gain1;
+	/* Gain2 function configuration for Gain control */
+	struct vpfe_ipipe_car_gain gain2;
+	/* HPF type used for CAR */
+	enum vpfe_ipipe_car_hpf_type hpf;
+	/* csup_thr: HPF threshold for Gain control */
+	unsigned char hpf_thr;
+	/* Down shift value for hpf. 2 bits */
+	unsigned char hpf_shft;
+	/* switch limit for median filter */
+	unsigned char sw0;
+	/* switch coefficient for Gain control */
+	unsigned char sw1;
+};
+
+/* structure for Chromatic Gain Suppression */
+struct vpfe_ipipe_cgs {
+	/* enable/disable */
+	unsigned char en;
+	/* gain1 bright side threshold */
+	unsigned char h_thr;
+	/* gain1 bright side slope */
+	unsigned char h_slope;
+	/* gain1 down shift value for bright side */
+	unsigned char h_shft;
+	/* gain1 bright side minimum gain */
+	unsigned char h_min;
+};
+
+/* Max pixels allowed in the input. If above this either decimation
+ * or frame division mode to be enabled
+ */
+#define VPFE_IPIPE_MAX_INPUT_WIDTH	2600
+
+struct vpfe_ipipe_input_config {
+	unsigned int vst;
+	unsigned int hst;
+};
+
+/**
+ * struct vpfe_ipipe_config - IPIPE engine configuration (user)
+ * @input_config: Pointer to structure for ipipe configuration.
+ * @flag: Specifies which ISP IPIPE functions should be enabled.
+ * @lutdpc: Pointer to luma enhancement structure.
+ * @otfdpc: Pointer to structure for defect correction.
+ * @nf1: Pointer to structure for Noise Filter.
+ * @nf2: Pointer to structure for Noise Filter.
+ * @gic: Pointer to structure for Green Imbalance.
+ * @wbal: Pointer to structure for White Balance.
+ * @cfa: Pointer to structure containing the CFA interpolation.
+ * @rgb2rgb1: Pointer to structure for RGB to RGB Blending.
+ * @rgb2rgb2: Pointer to structure for RGB to RGB Blending.
+ * @gamma: Pointer to gamma structure.
+ * @lut: Pointer to structure for 3D LUT.
+ * @rgb2yuv: Pointer to structure for RGB-YCbCr conversion.
+ * @gbce: Pointer to structure for Global Brightness,Contrast Control.
+ * @yuv422_conv: Pointer to structure for YUV 422 conversion.
+ * @yee: Pointer to structure for Edge Enhancer.
+ * @car: Pointer to structure for Chromatic Artifact Reduction.
+ * @cgs: Pointer to structure for Chromatic Gain Suppression.
+ */
+struct vpfe_ipipe_config {
+	__u32 flag;
+	struct vpfe_ipipe_input_config __user *input_config;
+	struct vpfe_ipipe_lutdpc __user *lutdpc;
+	struct vpfe_ipipe_otfdpc __user *otfdpc;
+	struct vpfe_ipipe_nf __user *nf1;
+	struct vpfe_ipipe_nf __user *nf2;
+	struct vpfe_ipipe_gic __user *gic;
+	struct vpfe_ipipe_wb __user *wbal;
+	struct vpfe_ipipe_cfa __user *cfa;
+	struct vpfe_ipipe_rgb2rgb __user *rgb2rgb1;
+	struct vpfe_ipipe_rgb2rgb __user *rgb2rgb2;
+	struct vpfe_ipipe_gamma __user *gamma;
+	struct vpfe_ipipe_3d_lut __user *lut;
+	struct vpfe_ipipe_rgb2yuv __user *rgb2yuv;
+	struct vpfe_ipipe_gbce __user *gbce;
+	struct vpfe_ipipe_yuv422_conv __user *yuv422_conv;
+	struct vpfe_ipipe_yee __user *yee;
+	struct vpfe_ipipe_car __user *car;
+	struct vpfe_ipipe_cgs __user *cgs;
+};
+
+/*******************************************************************
+**  Resizer API structures
+*******************************************************************/
+/* Interpolation types used for horizontal rescale */
+enum vpfe_rsz_intp_t {
+	VPFE_RSZ_INTP_CUBIC,
+	VPFE_RSZ_INTP_LINEAR
+};
+
+/* Horizontal LPF intensity selection */
+enum vpfe_rsz_h_lpf_lse_t {
+	VPFE_RSZ_H_LPF_LSE_INTERN,
+	VPFE_RSZ_H_LPF_LSE_USER_VAL
+};
+
+enum vpfe_rsz_down_scale_ave_sz {
+	VPFE_IPIPE_DWN_SCALE_1_OVER_2,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_4,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_8,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_16,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_32,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_64,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_128,
+	VPFE_IPIPE_DWN_SCALE_1_OVER_256
+};
+
+struct vpfe_rsz_output_spec {
+	/* enable horizontal flip */
+	unsigned char h_flip;
+	/* enable vertical flip */
+	unsigned char v_flip;
+	/* line start offset for y. */
+	unsigned int vst_y;
+	/* line start offset for c. Only for 420 */
+	unsigned int vst_c;
+	/* vertical rescale interpolation type, YCbCr or Luminance */
+	enum vpfe_rsz_intp_t v_typ_y;
+	/* vertical rescale interpolation type for Chrominance */
+	enum vpfe_rsz_intp_t v_typ_c;
+	/* vertical lpf intensity - Luminance */
+	unsigned char v_lpf_int_y;
+	/* vertical lpf intensity - Chrominance */
+	unsigned char v_lpf_int_c;
+	/* horizontal rescale interpolation types, YCbCr or Luminance  */
+	enum vpfe_rsz_intp_t h_typ_y;
+	/* horizontal rescale interpolation types, Chrominance */
+	enum vpfe_rsz_intp_t h_typ_c;
+	/* horizontal lpf intensity - Luminance */
+	unsigned char h_lpf_int_y;
+	/* horizontal lpf intensity - Chrominance */
+	unsigned char h_lpf_int_c;
+	/* Use down scale mode for scale down */
+	unsigned char en_down_scale;
+	/* if downscale, set the downscale more average size for horizontal
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum vpfe_rsz_down_scale_ave_sz h_dscale_ave_sz;
+	/* if downscale, set the downscale more average size for vertical
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum vpfe_rsz_down_scale_ave_sz v_dscale_ave_sz;
+	/* Y offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_y_ofst;
+	/* C offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_c_ofst;
+};
+
+struct vpfe_rsz_config_params {
+	unsigned int vst;
+	/* horizontal start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int hst;
+	/* output spec of the image data coming out of resizer - 0(UYVY).
+	 */
+	struct vpfe_rsz_output_spec output1;
+	/* output spec of the image data coming out of resizer - 1(UYVY).
+	 */
+	struct vpfe_rsz_output_spec output2;
+	/* 0 , chroma sample at odd pixel, 1 - even pixel */
+	unsigned char chroma_sample_even;
+	unsigned char frame_div_mode_en;
+	unsigned char yuv_y_min;
+	unsigned char yuv_y_max;
+	unsigned char yuv_c_min;
+	unsigned char yuv_c_max;
+	enum vpfe_chr_pos out_chr_pos;
+	unsigned char bypass;
+};
+
+/* Structure for VIDIOC_VPFE_RSZ_[S/G]_CONFIG IOCTLs */
+struct vpfe_rsz_config {
+	struct vpfe_rsz_config_params *config;
+};
+
+#endif		/* _DAVINCI_VPFE_USER_H */
-- 
1.7.4.1

