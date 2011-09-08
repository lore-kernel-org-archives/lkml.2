Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab1IHNgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:36:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58951 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab1IHNgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:36:50 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>,
        <g.liakhovetski@gmx.de>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 6/8] ispccdc: Add support for BT656 interface
Date: Thu, 8 Sep 2011 19:06:29 +0530
Message-ID: <1315488989-16240-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Add support for BT656 interface in omap3isp ccdc driver.
In addition, this corrects some build errors associated
with isp_video_mbus_to_pix(). The function was declared
as static. Made it extern.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 drivers/media/video/omap3isp/ispccdc.c  |  119 +++++++++++++++++++++++++------
 drivers/media/video/omap3isp/ispvideo.c |    2 +-
 drivers/media/video/omap3isp/ispvideo.h |    4 +-
 include/media/omap3isp.h                |    7 ++
 4 files changed, 109 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index c583384..e462034 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1018,6 +1018,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (syncif->vdpol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
+	if (syncif->bt_r656_en)
+		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
+
 	if (syncif->ccdc_mastermode) {
 		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
 		isp_reg_writel(isp,
@@ -1035,9 +1038,12 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
-	if (!syncif->bt_r656_en)
+	if (syncif->bt_r656_en)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
+	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
 }
 
 /* CCDC formats descriptions */
@@ -1119,6 +1125,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	struct isp_parallel_platform_data *pdata = NULL;
 	struct v4l2_subdev *sensor;
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_pix_format pix;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
 	unsigned int depth_out;
@@ -1150,9 +1157,18 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	shift = depth_in - depth_out;
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
-	ccdc->syncif.datsz = depth_out;
-	ccdc->syncif.hdpol = pdata ? pdata->hs_pol : 0;
-	ccdc->syncif.vdpol = pdata ? pdata->vs_pol : 0;
+	if (pdata) {
+		ccdc->syncif.datsz = pdata->width;
+		ccdc->syncif.fldmode = pdata->fldmode;
+		ccdc->syncif.hdpol = pdata->hs_pol;
+		ccdc->syncif.vdpol = pdata->vs_pol;
+		ccdc->syncif.bt_r656_en = pdata->is_bt656;
+	} else {
+		ccdc->syncif.datsz = depth_out;
+		ccdc->syncif.hdpol = 0;
+		ccdc->syncif.vdpol = 0;
+	}
+
 	ccdc_config_sync_if(ccdc, &ccdc->syncif);
 
 	/* CCDC_PAD_SINK */
@@ -1178,8 +1194,14 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* Use PACK8 mode for 1byte per pixel formats. */
 	if (omap3isp_video_format_info(format->code)->bpp <= 8)
 		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
+
+	if ((format->code == V4L2_MBUS_FMT_YUYV8_2X8) ||
+		(format->code == V4L2_MBUS_FMT_UYVY8_2X8)) {
+		if (pdata->is_bt656)
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		else
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+	}
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
@@ -1210,22 +1232,42 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 			(format->code != V4L2_MBUS_FMT_UYVY8_2X8))
 		ccdc_config_imgattr(ccdc, ccdc_pattern);
 
-	/* Generate VD0 on the last line of the image and VD1 on the
-	 * 2/3 height line.
-	 */
-	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
-		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+	/* BT656: Generate VD0 on the last line of each field, and we
+	* don't use VD1.
+	* Non BT656: Generate VD0 on the last line of the image and VD1 on the
+	* 2/3 height line.
+	*/
+	if (pdata->is_bt656)
+		isp_reg_writel(isp,
+			(format->height/2 - 2) << ISPCCDC_VDINT_0_SHIFT,
+		    OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+	else
+		isp_reg_writel(isp,
+			((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
+		      ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
+		     OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 
 	/* CCDC_PAD_SOURCE_OF */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 
-	isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+	isp_video_mbus_to_pix(&ccdc->video_out, format, &pix);
+	/* For BT656 the number of bytes would be width*2 */
+	if (pdata->is_bt656)
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+			((pix.bytesperline - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	else
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
 		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
 	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
-	isp_reg_writel(isp, (format->height - 1)
+	if (pdata->is_bt656)
+		isp_reg_writel(isp, ((format->height >> 1) - 1)
+				<< ISPCCDC_VERT_LINES_NLV_SHIFT,
+				OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+	else
+		isp_reg_writel(isp, (format->height - 1)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
@@ -1238,7 +1280,16 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
 		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST3_SHIFT);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	/* In case of BT656 each alternate line must be stored into memory */
+	if (pdata->is_bt656) {
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
+	} else {
+		ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value,
+									 0, 0);
+	}
 
 	/* CCDC_PAD_SOURCE_VP */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
@@ -1276,6 +1327,11 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 unlock:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 
+	if (pdata->is_bt656)
+		ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	else
+		ccdc->update = 0;
+
 	ccdc_apply_controls(ccdc);
 }
 
@@ -1551,10 +1607,29 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 	int restart = 0;
+	struct isp_device *isp = to_isp_device(ccdc);
 
-	if (ccdc->output & CCDC_OUTPUT_MEMORY)
-		restart = ccdc_isr_buffer(ccdc);
-
+	if (ccdc->output & CCDC_OUTPUT_MEMORY) {
+		if (ccdc->syncif.bt_r656_en) {
+			u32 fid;
+			u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_SYN_MODE);
+			fid = syn_mode & ISPCCDC_SYN_MODE_FLDSTAT;
+			/* toggle the software maintained fid */
+			ccdc->syncif.fldstat ^= 1;
+			if (fid == ccdc->syncif.fldstat) {
+				if (fid == 0) {
+					restart = ccdc_isr_buffer(ccdc);
+					goto done;
+				}
+			} else if (fid == 0) {
+				ccdc->syncif.fldstat = fid;
+			}
+		} else {
+			restart = ccdc_isr_buffer(ccdc);
+		}
+	}
+done:
 	spin_lock_irqsave(&ccdc->lock, flags);
 	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD0)) {
 		spin_unlock_irqrestore(&ccdc->lock, flags);
@@ -1640,7 +1715,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
 		return 0;
 
-	if (events & IRQ0STATUS_CCDC_VD1_IRQ)
+	if (!ccdc->syncif.bt_r656_en &&
+			(events & IRQ0STATUS_CCDC_VD1_IRQ))
 		ccdc_vd1_isr(ccdc);
 
 	ccdc_lsc_isr(ccdc, events);
@@ -1648,7 +1724,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (events & IRQ0STATUS_CCDC_VD0_IRQ)
 		ccdc_vd0_isr(ccdc);
 
-	if (events & IRQ0STATUS_HS_VS_IRQ)
+	if (!ccdc->syncif.bt_r656_en &&
+			(events & IRQ0STATUS_HS_VS_IRQ))
 		ccdc_hs_vs_isr(ccdc);
 
 	return 0;
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d595d01..445143b 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -165,7 +165,7 @@ static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
  *
  * Return the number of padding bytes at end of line.
  */
-static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
 					  const struct v4l2_mbus_framefmt *mbus,
 					  struct v4l2_pix_format *pix)
 {
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index bb8feb6..01d8728 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -198,7 +198,9 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
 					      unsigned int error);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
-
+extern unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+				  const struct v4l2_mbus_framefmt *mbus,
+				  struct v4l2_pix_format *pix);
 const struct isp_format_info *
 omap3isp_video_format_info(enum v4l2_mbus_pixelcode code);
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index e917b1d..f8d08e4 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -63,17 +63,24 @@ enum {
  *		0 - Active high, 1 - Active low
  * @vs_pol: Vertical synchronization polarity
  *		0 - Active high, 1 - Active low
+ * @fldmode: Field mode
+ *             0 - progressive, 1 - Interlaced
  * @bridge: CCDC Bridge input control
  *		ISP_BRIDGE_DISABLE - Disable
  *		ISP_BRIDGE_LITTLE_ENDIAN - Little endian
  *		ISP_BRIDGE_BIG_ENDIAN - Big endian
+ * @is_bt656: Is BT656
+ *             0 - non BT656, 1 - BT656
  */
 struct isp_parallel_platform_data {
+	unsigned int width;
 	unsigned int data_lane_shift:2;
 	unsigned int clk_pol:1;
 	unsigned int hs_pol:1;
 	unsigned int vs_pol:1;
+	unsigned int fldmode:1;
 	unsigned int bridge:2;
+	unsigned int is_bt656:1;
 };
 
 enum {
-- 
1.7.0.4

