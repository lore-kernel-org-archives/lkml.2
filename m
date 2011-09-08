Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1IHNgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:36:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34018 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab1IHNgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:36:02 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>,
        <g.liakhovetski@gmx.de>, "Vaibhav Hiremath" <hvaibhav@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 5/8] ispccdc: Configure CCDC registers
Date: Thu, 8 Sep 2011 19:05:44 +0530
Message-ID: <1315488944-16190-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Configure the CCDC registers for YUV and non YUV
data. Also some code clean-up for making it compact.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 drivers/media/video/omap3isp/ispccdc.c  |   65 +++++++++++++++++++++----------
 drivers/media/video/omap3isp/ispreg.h   |    1 +
 drivers/media/video/omap3isp/ispvideo.c |    3 +
 3 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index d58fe45..c583384 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -58,6 +58,7 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SBGGR12_1X12,
 	V4L2_MBUS_FMT_SGBRG12_1X12,
 	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_YUYV8_2X8,
 };
 
 /*
@@ -788,11 +789,16 @@ static void ccdc_apply_controls(struct isp_ccdc_device *ccdc)
 void omap3isp_ccdc_restore_context(struct isp_device *isp)
 {
 	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct v4l2_mbus_framefmt *format;
 
 	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, ISPCCDC_CFG_VDLC);
 
-	ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
-		     | OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+	if ((format->code != V4L2_MBUS_FMT_UYVY8_2X8) &&
+			(format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
+				| OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
 	ccdc_apply_controls(ccdc);
 	ccdc_configure_fpc(ccdc);
 }
@@ -966,14 +972,22 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
 				     ISPCCDC_SYN_MODE);
 
+	syn_mode &= ~(ISPCCDC_SYN_MODE_VDHDOUT |
+			ISPCCDC_SYN_MODE_FLDOUT |
+			ISPCCDC_SYN_MODE_VDPOL |
+			ISPCCDC_SYN_MODE_HDPOL |
+			ISPCCDC_SYN_MODE_FLDPOL |
+			ISPCCDC_SYN_MODE_FLDMODE |
+			ISPCCDC_SYN_MODE_DATAPOL |
+			ISPCCDC_SYN_MODE_DATSIZ_MASK |
+			ISPCCDC_SYN_MODE_PACK8 |
+			ISPCCDC_SYN_MODE_INPMOD_MASK);
+
 	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
 
 	if (syncif->fldstat)
 		syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
 
-	syn_mode &= ~ISPCCDC_SYN_MODE_DATSIZ_MASK;
 	switch (syncif->datsz) {
 	case 8:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
@@ -991,28 +1005,18 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	if (syncif->fldmode)
 		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
 
 	if (syncif->datapol)
 		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
 
 	if (syncif->fldpol)
 		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
 
 	if (syncif->hdpol)
 		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
 
 	if (syncif->vdpol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
 
 	if (syncif->ccdc_mastermode) {
 		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
@@ -1027,9 +1031,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 			     | syncif->hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
 			       OMAP3_ISP_IOMEM_CCDC,
 			       ISPCCDC_PIX_LINES);
-	} else
-		syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
-			      ISPCCDC_SYN_MODE_VDHDOUT);
+	}
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
@@ -1181,6 +1183,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
+	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
 	/* Mosaic filter */
 	switch (format->code) {
 	case V4L2_MBUS_FMT_SRGGB10_1X10:
@@ -1200,7 +1205,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		ccdc_pattern = ccdc_sgrbg_pattern;
 		break;
 	}
-	ccdc_config_imgattr(ccdc, ccdc_pattern);
+
+	if ((format->code != V4L2_MBUS_FMT_YUYV8_2X8) &&
+			(format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc_config_imgattr(ccdc, ccdc_pattern);
 
 	/* Generate VD0 on the last line of the image and VD1 on the
 	 * 2/3 height line.
@@ -1221,6 +1229,15 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST0_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST1_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST2_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST3_SHIFT);
+
 	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
 
 	/* CCDC_PAD_SOURCE_VP */
@@ -1270,6 +1287,7 @@ static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
 }
 
+static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event);
 static int ccdc_disable(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
@@ -1280,6 +1298,11 @@ static int ccdc_disable(struct isp_ccdc_device *ccdc)
 		ccdc->stopping = CCDC_STOP_REQUEST;
 	spin_unlock_irqrestore(&ccdc->lock, flags);
 
+	__ccdc_lsc_enable(ccdc, 0);
+	__ccdc_enable(ccdc, 0);
+	ccdc->stopping = CCDC_STOP_EXECUTED;
+	__ccdc_handle_stopping(ccdc, CCDC_STOP_FINISHED);
+
 	ret = wait_event_timeout(ccdc->wait,
 				 ccdc->stopping == CCDC_STOP_FINISHED,
 				 msecs_to_jiffies(2000));
@@ -1735,7 +1758,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 		 * links are inactive.
 		 */
 		ccdc_config_vp(ccdc);
-		ccdc_enable_vp(ccdc, 1);
+		ccdc_enable_vp(ccdc, 0);
 		ccdc->error = 0;
 		ccdc_print_status(ccdc);
 	}
@@ -2265,7 +2288,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 
 	ccdc->vpcfg.pixelclk = 0;
 
-	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	ccdc->update = 0;
 	ccdc_apply_controls(ccdc);
 
 	return ccdc_init_entities(ccdc);
diff --git a/drivers/media/video/omap3isp/ispreg.h b/drivers/media/video/omap3isp/ispreg.h
index 69f6af6..ada39c6 100644
--- a/drivers/media/video/omap3isp/ispreg.h
+++ b/drivers/media/video/omap3isp/ispreg.h
@@ -827,6 +827,7 @@
 #define ISPCCDC_SDOFST_LOFST2_SHIFT		3
 #define ISPCCDC_SDOFST_LOFST1_SHIFT		6
 #define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define ISPCCDC_SDOFST_LOFST_MASK              0x7
 #define EVENEVEN				1
 #define ODDEVEN					2
 #define EVENODD					3
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index ff0ffed..d595d01 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -104,6 +104,9 @@ static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
 	  V4L2_MBUS_FMT_UYVY8_2X8, 0,
 	  V4L2_PIX_FMT_UYVY, 16, },
+	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_YUYV8_2X8,
+	  V4L2_MBUS_FMT_YUYV8_2X8, 0,
+	  V4L2_PIX_FMT_YUYV, 16, },
 };
 
 const struct isp_format_info *
-- 
1.7.0.4

