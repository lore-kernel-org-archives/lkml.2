Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2INMt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:49:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57053 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab2INMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:49:46 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 07/14] davinci: vpfe: v4l2 capture driver with media interface
Date: Fri, 14 Sep 2012 18:16:37 +0530
Message-Id: <1347626804-5703-8-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add the vpfe capture driver which implements media controller
interface. The driver suports all the setup functionality for
all all units nnamely- ccdc, previewer, resizer, h3a, aew.
The driver supports both dm365 and Dm355. The driver does isr
registration, v4l2 device registration, media registration and
platform driver registrations. It calls the appropriate subdevs
from here to cerate the appropriate subdevices and media entities.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpfe_mc_capture.c |  764 ++++++++++++++++++++++
 drivers/media/platform/davinci/vpfe_mc_capture.h |  104 +++
 include/media/davinci/vpfe.h                     |   84 +++
 3 files changed, 952 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.c
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.h
 create mode 100644 include/media/davinci/vpfe.h

diff --git a/drivers/media/platform/davinci/vpfe_mc_capture.c b/drivers/media/platform/davinci/vpfe_mc_capture.c
new file mode 100644
index 0000000..306d45f
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_mc_capture.c
@@ -0,0 +1,764 @@
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
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#include <media/v4l2-common.h>
+#include <media/media-entity.h>
+#include <media/media-device.h>
+#include <media/davinci/vpfe_types.h>
+
+#include "vpfe_mc_capture.h"
+
+static bool debug;
+static bool interface;
+static u32 cont_bufoffset;
+static u32 cont_bufsize;
+static u32 en_serializer;
+
+module_param(interface, bool, S_IRUGO);
+module_param(debug, bool, 0644);
+module_param(cont_bufoffset, uint, S_IRUGO);
+module_param(cont_bufsize, uint, S_IRUGO);
+module_param(en_serializer, uint, S_IRUGO);
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
+MODULE_PARM_DESC(cont_bufoffset, "Capture buffer offset (default 0)");
+MODULE_PARM_DESC(cont_bufsize, "Capture buffer size (default 0)");
+MODULE_PARM_DESC(en_serializer, "enable IPIPE serializer (default:0)");
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
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+		pix->bytesperline = pix->width * 2;
+		break;
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		pix->pixelformat = V4L2_PIX_FMT_UYVY;
+		pix->bytesperline = pix->width * 2;
+		break;
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		pix->pixelformat = V4L2_PIX_FMT_SBGGR16;
+		pix->bytesperline = pix->width * 2;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8;
+		pix->bytesperline = pix->width;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8;
+		pix->bytesperline = pix->width;
+		break;
+	case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
+		pix->pixelformat = V4L2_PIX_FMT_NV12;
+		pix->bytesperline = pix->width;
+		break;
+	case V4L2_MBUS_FMT_Y8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_GREY;
+		pix->bytesperline = pix->width;
+		break;
+	case V4L2_MBUS_FMT_UV8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_UV8;
+		pix->bytesperline = pix->width;
+		break;
+	default:
+		pr_err("Invalid mbus code set\n");
+	}
+
+	/* pitch should be 32 bytes aligned */
+	pix->bytesperline = ALIGN(pix->bytesperline, 32);
+
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
+	ccdc_buffer_isr(&vpfe_dev->vpfe_ccdc);
+	prv_buffer_isr(&vpfe_dev->vpfe_previewer);
+	rsz_buffer_isr(&vpfe_dev->vpfe_resizer);
+
+	return IRQ_HANDLED;
+}
+
+/* vpfe_vdint1_isr() - isr handler for VINT1 interrupt */
+static irqreturn_t vpfe_vdint1_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_vdint1_isr\n");
+	ccdc_vidint1_isr(&vpfe_dev->vpfe_ccdc);
+
+	return IRQ_HANDLED;
+}
+
+/* vpfe_imp_dma_isr() - ISR for ipipe dma completion */
+static irqreturn_t vpfe_imp_dma_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_imp_dma_isr\n");
+	prv_dma_isr(&vpfe_dev->vpfe_previewer);
+	rsz_dma_isr(&vpfe_dev->vpfe_resizer);
+
+	return IRQ_HANDLED;
+}
+
+/* set user setting of serializer in ipipe */
+static void vpfe_initialize(struct vpfe_device *vpfe_dev)
+{
+	/* inform user choice on serializer to ipipe */
+	enable_serializer(vpfe_dev->ipipe, en_serializer);
+}
+
+/**
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
+		clk_disable(vpfe_dev->clks[i]);
+		clk_put(vpfe_dev->clks[i]);
+	}
+
+	kzfree(vpfe_dev->clks);
+	v4l2_info(vpfe_dev->pdev->driver, "vpfe capture clocks disabled\n");
+}
+
+/**
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
+
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
+		vpfe_dev->clks[i] = clk_get(vpfe_dev->pdev,
+					      vpfe_cfg->clocks[i]);
+		if (vpfe_dev->clks[i] == NULL) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"Failed to get clock %s\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		if (clk_enable(vpfe_dev->clks[i])) {
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
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (vpfe_dev->clks[i])
+			clk_put(vpfe_dev->clks[i]);
+	}
+
+	v4l2_err(vpfe_dev->pdev->driver, "Failed to enable clocks\n");
+
+	kzfree(vpfe_dev->clks);
+	return ret;
+}
+
+/**
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
+/**
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
+			"vpfe_capture0", vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"Error: requesting VINT0 interrupt\n");
+		return ret;
+	}
+
+	ret = request_irq(vpfe_dev->ccdc_irq1, vpfe_vdint1_isr, IRQF_DISABLED,
+					"vpfe_capture1", vpfe_dev);
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
+/**
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
+
+	i2c_adap = i2c_get_adapter(1);
+	num_subdevs = vpfe_cfg->num_subdevs;
+
+	vpfe_dev->sd = kzalloc(sizeof(struct v4l2_subdev *)*num_subdevs,
+			       GFP_KERNEL);
+
+	if (vpfe_dev->sd == NULL) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"unable to allocate memory for subdevice\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0, k = 0; i < num_subdevs; i++) {
+		sdinfo = &vpfe_cfg->sub_devs[i];
+		/**
+		 * register subdevices based on interface setting. Currently
+		 * tvp5146 and mt9p031 cannot co-exists due to i2c address
+		 * conflicts. So only one of them is registered. Re-visit this
+		 * once we have support for i2c switch handling in i2c driver
+		 * framework
+		 */
+
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
+
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
+/**
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
+	ret = vpfe_ccdc_register_entities(&vpfe_dev->vpfe_ccdc,
+					  &vpfe_dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	ret = vpfe_previewer_register_entities(&vpfe_dev->vpfe_previewer,
+					       &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_ccdc_register;
+
+	ret = vpfe_resizer_register_entities(&vpfe_dev->vpfe_resizer,
+					     &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_previewer_register;
+	/* create links now, starting with external(i2c) entities */
+	for (i = 0; i < vpfe_dev->num_ext_subdevs; i++) {
+		/* if entity has no pads (ex: amplifier),
+		   cant establish link */
+		if (vpfe_dev->sd[i]->entity.num_pads) {
+			ret = media_entity_create_link(&vpfe_dev->sd[i]->entity,
+				0, &vpfe_dev->vpfe_ccdc.subdev.entity,
+				0, flags);
+			if (ret < 0)
+				goto out_resizer_register;
+		}
+	}
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ccdc.subdev.entity, 1,
+				       &vpfe_dev->vpfe_previewer.subdev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_previewer.subdev.entity,
+				       1, &vpfe_dev->vpfe_resizer.subdev.entity,
+				       0, flags);
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
+out_previewer_register:
+	vpfe_previewer_unregister_entities(&vpfe_dev->vpfe_previewer);
+out_ccdc_register:
+	vpfe_ccdc_unregister_entities(&vpfe_dev->vpfe_ccdc);
+	return ret;
+}
+
+/**
+ * vpfe_unregister_entities() - unregister all v4l2 subdevs and media entities
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * unregister all v4l2 subdevs and media entities
+ */
+static void vpfe_unregister_entities(struct vpfe_device *vpfe_dev)
+{
+	vpfe_ccdc_unregister_entities(&vpfe_dev->vpfe_ccdc);
+	vpfe_previewer_unregister_entities(&vpfe_dev->vpfe_previewer);
+	vpfe_resizer_unregister_entities(&vpfe_dev->vpfe_resizer);
+}
+
+/**
+ * vpfe_cleanup_modules() - cleanup all non-i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ * @pdev - pointer to platform device
+ *
+ * cleanup all v4l2 subdevs
+ */
+static void vpfe_cleanup_modules(struct vpfe_device *vpfe_dev,
+				 struct platform_device *pdev)
+{
+	vpfe_ccdc_cleanup(pdev);
+	vpfe_previewer_cleanup(pdev, vpfe_dev->ipipe);
+}
+
+/**
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
+	ret = vpfe_ccdc_init(&vpfe_dev->vpfe_ccdc, pdev);
+	if (ret)
+		return ret;
+
+	ret = vpfe_previewer_init(&vpfe_dev->vpfe_previewer, pdev);
+	if (ret)
+		goto out_ccdc_init;
+
+	ret = vpfe_resizer_init(&vpfe_dev->vpfe_resizer, pdev);
+	if (ret)
+		goto out_previewer_init;
+
+	return 0;
+
+out_previewer_init:
+	vpfe_previewer_cleanup(pdev, vpfe_dev->ipipe);
+out_ccdc_init:
+	vpfe_ccdc_cleanup(pdev);
+
+	return ret;
+}
+
+/**
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
+	unsigned long phys_end_kernel;
+	int ret = -ENOMEM;
+	int err;
+	size_t size;
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
+
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
+	res1 = platform_get_resource(pdev,
+				IORESOURCE_IRQ, 1);
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
+	vpfe_initialize(vpfe_dev);
+
+	vpfe_dev->media_dev.dev = vpfe_dev->pdev;
+	strcpy((char *)&vpfe_dev->media_dev.model, "davinci-media");
+	ret = media_device_register(&vpfe_dev->media_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver,
+			"Unable to register media device.\n");
+		goto probe_out_entities_cleanup;
+	}
+
+	vpfe_dev->v4l2_dev.mdev = &vpfe_dev->media_dev;
+
+	ret = v4l2_device_register(&pdev->dev, &vpfe_dev->v4l2_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver, "Unable to register v4l2 device.\n");
+		goto probe_out_media_unregister;
+	}
+	v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 device registered\n");
+
+	/* set the driver data in platform device */
+	platform_set_drvdata(pdev, vpfe_dev);
+
+	/* register subdevs/entities */
+	if (vpfe_register_entities(vpfe_dev))
+		goto probe_out_v4l2_unregister;
+
+	ret = vpfe_attach_irq(vpfe_dev);
+	if (ret)
+		goto probe_out_entities_unregister;
+
+	if (cont_bufsize) {
+		/* attempt to determine the end of Linux kernel memory */
+		phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
+			(num_physpages << PAGE_SHIFT);
+		size = cont_bufsize;
+		phys_end_kernel += cont_bufoffset;
+		err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
+				phys_end_kernel, size,
+				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+		if (!err) {
+			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+			ret = -ENOENT;
+			goto probe_detach_irq;
+		}
+		vpfe_dev->video_limit = size;
+	}
+
+	return 0;
+
+probe_detach_irq:
+	vpfe_detach_irq(vpfe_dev);
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
index 0000000..aba0a00
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_mc_capture.h
@@ -0,0 +1,104 @@
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
+#ifndef _VPFE_MC_CAPTURE_H
+#define _VPFE_MC_CAPTURE_H
+
+/* Header files */
+#include <linux/i2c.h>
+#include <linux/v4l2-subdev.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf-dma-contig.h>
+
+#include "vpfe_video.h"
+#include "vpfe_af.h"
+#include "vpfe_aew.h"
+#include "vpfe_ccdc.h"
+#include "imp_hw_if.h"
+#include "vpfe_resizer.h"
+#include "vpfe_previewer.h"
+#include "vpfe_imp_common.h"
+
+/* Macros */
+#define VPFE_MAJOR_RELEASE		0
+#define VPFE_MINOR_RELEASE		0
+#define VPFE_BUILD			1
+#define VPFE_CAPTURE_VERSION_CODE       ((VPFE_MAJOR_RELEASE << 16) | \
+					(VPFE_MINOR_RELEASE << 8)  | \
+					VPFE_BUILD)
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
+	struct vpfe_ccdc_device		vpfe_ccdc;
+	/* resizer subdevice */
+	struct vpfe_resizer_device	vpfe_resizer;
+	/* previewer subdevice */
+	struct vpfe_previewer_device	vpfe_previewer;
+	/* aew subdevice */
+	struct vpfe_aew_device		vpfe_aew;
+	/* af subdevice */
+	struct vpfe_af_device		vpfe_af;
+	void				*ipipe;
+};
+
+/* File handle structure */
+struct vpfe_fh {
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
+#endif	/* _VPFE_MC_CAPTURE_H */
diff --git a/include/media/davinci/vpfe.h b/include/media/davinci/vpfe.h
new file mode 100644
index 0000000..15bca28
--- /dev/null
+++ b/include/media/davinci/vpfe.h
@@ -0,0 +1,84 @@
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
-- 
1.7.4.1

