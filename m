Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1LAN7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:59:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43918 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1LAN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:59:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@keymile.com>,
        Daniel Mack <daniel@caiaq.de>, Eric Benard <eric@eukrea.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] video i.MX IPU: Fix display connections
Date: Thu,  1 Dec 2011 14:58:52 +0100
Message-Id: <1322747932-24943-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322747932-24943-1-git-send-email-s.hauer@pengutronix.de>
References: <1322747932-24943-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPU internally works on 32bit colors. It can arbitrarily map
between pixel formats and internal representation and also between
internal representation and the physical connection to the display.
The driver used to change the mapping between internal representation
and display connection depending on the user selected bpp which is
wrong. Instead, the mapping is specified by the hardware, so an
additional field in platform data is added to describe the connection
between i.MX and the display. The default for this field is RGB666
which seems to be the only configuration which works without this
patch, so I assumed that all in Kernel boards are connected this
way.
This patch has been tested on a RGB666 connected display and a
RGB888 connected display in both 16bpp and 32bpp modes.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/mx3fb.h |   15 ++++++++
 drivers/video/mx3fb.c                  |   61 +++++++++++--------------------
 2 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/mx3fb.h b/arch/arm/plat-mxc/include/mach/mx3fb.h
index ac24c5c..fdbe600 100644
--- a/arch/arm/plat-mxc/include/mach/mx3fb.h
+++ b/arch/arm/plat-mxc/include/mach/mx3fb.h
@@ -22,6 +22,20 @@
 #define FB_SYNC_SWAP_RGB	0x04000000
 #define FB_SYNC_CLK_SEL_EN	0x02000000
 
+/*
+ * Specify the way your display is connected. The IPU can arbitrarily
+ * map the internal colors to the external data lines. We only support
+ * the following mappings at the moment.
+ */
+enum disp_data_mapping {
+	/* blue -> d[0..5], green -> d[6..11], red -> d[12..17] */
+	IPU_DISP_DATA_MAPPING_RGB666,
+	/* blue -> d[0..4], green -> d[5..10], red -> d[11..15] */
+	IPU_DISP_DATA_MAPPING_RGB565,
+	/* blue -> d[0..7], green -> d[8..15], red -> d[16..23] */
+	IPU_DISP_DATA_MAPPING_RGB888,
+};
+
 /**
  * struct mx3fb_platform_data - mx3fb platform data
  *
@@ -33,6 +47,7 @@ struct mx3fb_platform_data {
 	const char			*name;
 	const struct fb_videomode	*mode;
 	int				num_modes;
+	enum disp_data_mapping		disp_data_fmt;
 };
 
 #endif
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index e3406ab..f1383c8 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -245,6 +245,7 @@ struct mx3fb_data {
 
 	uint32_t		h_start_width;
 	uint32_t		v_start_width;
+	enum disp_data_mapping	disp_data_fmt;
 };
 
 struct dma_chan_request {
@@ -287,11 +288,14 @@ static void mx3fb_write_reg(struct mx3fb_data *mx3fb, u32 value, unsigned long r
 	__raw_writel(value, mx3fb->reg_base + reg);
 }
 
-static const uint32_t di_mappings[] = {
-	0x1600AAAA, 0x00E05555, 0x00070000, 3,	/* RGB888 */
-	0x0005000F, 0x000B000F, 0x0011000F, 1,	/* RGB666 */
-	0x0011000F, 0x000B000F, 0x0005000F, 1,	/* BGR666 */
-	0x0004003F, 0x000A000F, 0x000F003F, 1	/* RGB565 */
+struct di_mapping {
+	uint32_t b0, b1, b2;
+};
+
+static const struct di_mapping di_mappings[] = {
+	[IPU_DISP_DATA_MAPPING_RGB666] = { 0x0005000f, 0x000b000f, 0x0011000f },
+	[IPU_DISP_DATA_MAPPING_RGB565] = { 0x0004003f, 0x000a000f, 0x000f003f },
+	[IPU_DISP_DATA_MAPPING_RGB888] = { 0x00070000, 0x000f0000, 0x00170000 },
 };
 
 static void sdc_fb_init(struct mx3fb_info *fbi)
@@ -425,7 +429,6 @@ static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel
  * @pixel_clk:		desired pixel clock frequency in Hz.
  * @width:		width of panel in pixels.
  * @height:		height of panel in pixels.
- * @pixel_fmt:		pixel format of buffer as FOURCC ASCII code.
  * @h_start_width:	number of pixel clocks between the HSYNC signal pulse
  *			and the start of valid data.
  * @h_sync_width:	width of the HSYNC signal in units of pixel clocks.
@@ -442,7 +445,6 @@ static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel
 static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 			  uint32_t pixel_clk,
 			  uint16_t width, uint16_t height,
-			  enum pixel_fmt pixel_fmt,
 			  uint16_t h_start_width, uint16_t h_sync_width,
 			  uint16_t h_end_width, uint16_t v_start_width,
 			  uint16_t v_sync_width, uint16_t v_end_width,
@@ -453,6 +455,7 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 	uint32_t old_conf;
 	uint32_t div;
 	struct clk *ipu_clk;
+	const struct di_mapping *map;
 
 	dev_dbg(mx3fb->dev, "panel size = %d x %d", width, height);
 
@@ -540,36 +543,10 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 		sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
 	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_SIG_POL);
 
-	switch (pixel_fmt) {
-	case IPU_PIX_FMT_RGB24:
-		mx3fb_write_reg(mx3fb, di_mappings[0], DI_DISP3_B0_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[1], DI_DISP3_B1_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[2], DI_DISP3_B2_MAP);
-		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-			     ((di_mappings[3] - 1) << 12), DI_DISP_ACC_CC);
-		break;
-	case IPU_PIX_FMT_RGB666:
-		mx3fb_write_reg(mx3fb, di_mappings[4], DI_DISP3_B0_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[5], DI_DISP3_B1_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[6], DI_DISP3_B2_MAP);
-		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-			     ((di_mappings[7] - 1) << 12), DI_DISP_ACC_CC);
-		break;
-	case IPU_PIX_FMT_BGR666:
-		mx3fb_write_reg(mx3fb, di_mappings[8], DI_DISP3_B0_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[9], DI_DISP3_B1_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[10], DI_DISP3_B2_MAP);
-		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-			     ((di_mappings[11] - 1) << 12), DI_DISP_ACC_CC);
-		break;
-	default:
-		mx3fb_write_reg(mx3fb, di_mappings[12], DI_DISP3_B0_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[13], DI_DISP3_B1_MAP);
-		mx3fb_write_reg(mx3fb, di_mappings[14], DI_DISP3_B2_MAP);
-		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-			     ((di_mappings[15] - 1) << 12), DI_DISP_ACC_CC);
-		break;
-	}
+	map = &di_mappings[mx3fb->disp_data_fmt];
+	mx3fb_write_reg(mx3fb, map->b0, DI_DISP3_B0_MAP);
+	mx3fb_write_reg(mx3fb, map->b1, DI_DISP3_B1_MAP);
+	mx3fb_write_reg(mx3fb, map->b2, DI_DISP3_B2_MAP);
 
 	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
 
@@ -780,8 +757,6 @@ static int __set_par(struct fb_info *fbi, bool lock)
 		if (sdc_init_panel(mx3fb, mode,
 				   (PICOS2KHZ(fbi->var.pixclock)) * 1000UL,
 				   fbi->var.xres, fbi->var.yres,
-				   (fbi->var.sync & FB_SYNC_SWAP_RGB) ?
-				   IPU_PIX_FMT_BGR666 : IPU_PIX_FMT_RGB666,
 				   fbi->var.left_margin,
 				   fbi->var.hsync_len,
 				   fbi->var.right_margin +
@@ -1349,6 +1324,12 @@ static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
 	const struct fb_videomode *mode;
 	int ret, num_modes;
 
+	if (mx3fb_pdata->disp_data_fmt >= ARRAY_SIZE(di_mappings)) {
+		dev_err(dev, "Illegal display data format %d\n",
+				mx3fb_pdata->disp_data_fmt);
+		return -EINVAL;
+	}
+
 	ichan->client = mx3fb;
 	irq = ichan->eof_irq;
 
@@ -1402,6 +1383,8 @@ static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
 	mx3fbi->mx3fb		= mx3fb;
 	mx3fbi->blank		= FB_BLANK_NORMAL;
 
+	mx3fb->disp_data_fmt	= mx3fb_pdata->disp_data_fmt;
+
 	init_completion(&mx3fbi->flip_cmpl);
 	disable_irq(ichan->eof_irq);
 	dev_dbg(mx3fb->dev, "disabling irq %d\n", ichan->eof_irq);
-- 
1.7.7.1

