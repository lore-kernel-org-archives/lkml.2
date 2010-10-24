Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab0JXM7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 08:59:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51384 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932503Ab0JXM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 08:59:51 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+GFHINKDCG2DqvEdeJpImjxEpFJMF8nHSqgLlUxX
	Bl1HJzg79Gz+N2
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] viafb: add initial VX900 support
Date: Sun, 24 Oct 2010 13:11:27 +0000
Message-Id: <1287925887-3987-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support for the new VX900 IGP. Almost everything
that was implemented for other IGPs is expected to work also on VX900
after this patch. The only known issue is that on the CRT output mode
setting does not always work.
It is clear that the possibility for regressions is zero.

A big thanks to VIA Technologies for making this possible and
supporting this work.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/accel.c    |    3 +++
 drivers/video/via/chip.h     |    3 +++
 drivers/video/via/hw.c       |   23 +++++++++++++++++++++++
 drivers/video/via/hw.h       |   13 +++++++++++++
 drivers/video/via/lcd.c      |    2 ++
 drivers/video/via/via-core.c |   10 ++++++++--
 drivers/video/via/viafbdev.c |    6 ++++--
 7 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index bc49053..3c969cd 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -343,6 +343,7 @@ int viafb_setup_engine(struct fb_info *info)
 		break;
 	case UNICHROME_VX800:
 	case UNICHROME_VX855:
+	case UNICHROME_VX900:
 		viapar->shared->hw_bitblt = hw_bitblt_2;
 		break;
 	default:
@@ -402,6 +403,7 @@ void viafb_reset_engine(struct viafb_par *viapar)
 	case UNICHROME_P4M900:
 	case UNICHROME_VX800:
 	case UNICHROME_VX855:
+	case UNICHROME_VX900:
 		writel(0x00100000, engine + VIA_REG_CR_TRANSET);
 		writel(0x680A0000, engine + VIA_REG_CR_TRANSPACE);
 		writel(0x02000000, engine + VIA_REG_CR_TRANSPACE);
@@ -438,6 +440,7 @@ void viafb_reset_engine(struct viafb_par *viapar)
 	case UNICHROME_P4M900:
 	case UNICHROME_VX800:
 	case UNICHROME_VX855:
+	case UNICHROME_VX900:
 		vq_start_low |= 0x20000000;
 		vq_end_low |= 0x20000000;
 		vq_high |= 0x20000000;
diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index ef1f3de..48f1342 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -71,6 +71,9 @@
 #define     UNICHROME_VX855         12
 #define     UNICHROME_VX855_DID     0x5122
 
+#define     UNICHROME_VX900         13
+#define     UNICHROME_VX900_DID     0x7122
+
 /**************************************************/
 /* Definition TMDS Trasmitter Information         */
 /**************************************************/
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 7d7010a..36d73f9 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1429,6 +1429,15 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active)
 			    VX855_IGA1_DISPLAY_QUEUE_EXPIRE_NUM;
 		}
 
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_VX900) {
+			iga1_fifo_max_depth = VX900_IGA1_FIFO_MAX_DEPTH;
+			iga1_fifo_threshold = VX900_IGA1_FIFO_THRESHOLD;
+			iga1_fifo_high_threshold =
+			    VX900_IGA1_FIFO_HIGH_THRESHOLD;
+			iga1_display_queue_expire_num =
+			    VX900_IGA1_DISPLAY_QUEUE_EXPIRE_NUM;
+		}
+
 		/* Set Display FIFO Depath Select */
 		reg_value = IGA1_FIFO_DEPTH_SELECT_FORMULA(iga1_fifo_max_depth);
 		viafb_load_reg_num =
@@ -1569,6 +1578,15 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active)
 			    VX855_IGA2_DISPLAY_QUEUE_EXPIRE_NUM;
 		}
 
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_VX900) {
+			iga2_fifo_max_depth = VX900_IGA2_FIFO_MAX_DEPTH;
+			iga2_fifo_threshold = VX900_IGA2_FIFO_THRESHOLD;
+			iga2_fifo_high_threshold =
+			    VX900_IGA2_FIFO_HIGH_THRESHOLD;
+			iga2_display_queue_expire_num =
+			    VX900_IGA2_DISPLAY_QUEUE_EXPIRE_NUM;
+		}
+
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_K800) {
 			/* Set Display FIFO Depath Select */
 			reg_value =
@@ -1689,6 +1707,7 @@ u32 viafb_get_clk_value(int clk)
 			break;
 
 		case UNICHROME_VX855:
+		case UNICHROME_VX900:
 			value = vx855_encode_pll(pll_value[i].vx855_pll);
 			break;
 		}
@@ -1722,6 +1741,7 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
+		case UNICHROME_VX900:
 			via_write_reg(VIASR, SR44, (clk & 0x0000FF));
 			via_write_reg(VIASR, SR45, (clk & 0x00FF00) >> 8);
 			via_write_reg(VIASR, SR46, (clk & 0xFF0000) >> 16);
@@ -1748,6 +1768,7 @@ void viafb_set_vclock(u32 clk, int set_iga)
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
+		case UNICHROME_VX900:
 			via_write_reg(VIASR, SR4A, (clk & 0x0000FF));
 			via_write_reg(VIASR, SR4B, (clk & 0x00FF00) >> 8);
 			via_write_reg(VIASR, SR4C, (clk & 0xFF0000) >> 16);
@@ -2179,6 +2200,7 @@ static void __devinit init_gfx_chip_info(int chip_type)
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_VX800:
 	case UNICHROME_VX855:
+	case UNICHROME_VX900:
 		viaparinfo->chip_info->twod_engine = VIA_2D_ENG_M1;
 		break;
 	case UNICHROME_K8M890:
@@ -2403,6 +2425,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		break;
 
 	case UNICHROME_VX855:
+	case UNICHROME_VX900:
 		viafb_write_regx(VX855_ModeXregs, NUM_TOTAL_VX855_ModeXregs);
 		break;
 	}
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index b764409..668d534 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -362,6 +362,17 @@ is reserved, so it may have problem to set 1600x1200 on IGA2. */
 #define VX855_IGA2_FIFO_HIGH_THRESHOLD          160
 #define VX855_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     320
 
+/* For VT3410 */
+#define VX900_IGA1_FIFO_MAX_DEPTH               400
+#define VX900_IGA1_FIFO_THRESHOLD               320
+#define VX900_IGA1_FIFO_HIGH_THRESHOLD          320
+#define VX900_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     160
+
+#define VX900_IGA2_FIFO_MAX_DEPTH               192
+#define VX900_IGA2_FIFO_THRESHOLD               160
+#define VX900_IGA2_FIFO_HIGH_THRESHOLD          160
+#define VX900_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     320
+
 #define IGA1_FIFO_DEPTH_SELECT_REG_NUM          1
 #define IGA1_FIFO_THRESHOLD_REG_NUM             2
 #define IGA1_FIFO_HIGH_THRESHOLD_REG_NUM        2
@@ -879,6 +890,8 @@ struct iga2_crtc_timing {
 #define VX800_FUNCTION3     0x3353
 /* VT3409 chipset*/
 #define VX855_FUNCTION3     0x3409
+/* VT3410 chipset*/
+#define VX900_FUNCTION3     0x3410
 
 #define NUM_TOTAL_PLL_TABLE ARRAY_SIZE(pll_value)
 
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index de19e47..3425c39 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -442,6 +442,7 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		case UNICHROME_CN750:
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
+		case UNICHROME_VX900:
 			reg_value =
 			    K800_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
 			/* Horizontal scaling enabled */
@@ -485,6 +486,7 @@ static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		case UNICHROME_CN750:
 		case UNICHROME_VX800:
 		case UNICHROME_VX855:
+		case UNICHROME_VX900:
 			reg_value =
 			    K800_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
 			/* Vertical scaling enabled */
diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 9b487a6..31e3033 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -333,7 +333,7 @@ EXPORT_SYMBOL_GPL(viafb_dma_copy_out_sg);
 static u16 via_function3[] = {
 	CLE266_FUNCTION3, KM400_FUNCTION3, CN400_FUNCTION3, CN700_FUNCTION3,
 	CX700_FUNCTION3, KM800_FUNCTION3, KM890_FUNCTION3, P4M890_FUNCTION3,
-	P4M900_FUNCTION3, VX800_FUNCTION3, VX855_FUNCTION3,
+	P4M900_FUNCTION3, VX800_FUNCTION3, VX855_FUNCTION3, VX900_FUNCTION3,
 };
 
 /* Get the BIOS-configured framebuffer size from PCI configuration space
@@ -370,6 +370,7 @@ static int viafb_get_fb_size_from_pci(int chip_type)
 		case P4M900_FUNCTION3:
 		case VX800_FUNCTION3:
 		case VX855_FUNCTION3:
+		case VX900_FUNCTION3:
 		/*case CN750_FUNCTION3: */
 			offset = 0xA0;
 			break;
@@ -474,7 +475,10 @@ static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
 	 * Eventually we want to move away from mapping this
 	 * entire region.
 	 */
-	vdev->fbmem_start = pci_resource_start(vdev->pdev, 0);
+	if (vdev->chip_type == UNICHROME_VX900)
+		vdev->fbmem_start = pci_resource_start(vdev->pdev, 2);
+	else
+		vdev->fbmem_start = pci_resource_start(vdev->pdev, 0);
 	ret = vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
 	if (ret < 0)
 		goto out_unmap;
@@ -635,6 +639,8 @@ static struct pci_device_id via_pci_table[] __devinitdata = {
 	  .driver_data = UNICHROME_VX800 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX855_DID),
 	  .driver_data = UNICHROME_VX855 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX900_DID),
+	  .driver_data = UNICHROME_VX900 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, via_pci_table);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 6c651e4..d298cfc 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -57,7 +57,7 @@ static int viafb_pan_display(struct fb_var_screeninfo *var,
 static struct fb_ops viafb_ops;
 
 /* supported output devices on each IGP
- * only CX700, VX800, VX855 were documented
+ * only CX700, VX800, VX855, VX900 were documented
  * VIA_CRT should be everywhere
  * VIA_6C can be onle pre-CX700 (probably only on CLE266) as 6C is used for PLL
  * source selection on CX700 and later
@@ -80,6 +80,7 @@ static const u32 supported_odev_map[] = {
 	[UNICHROME_P4M900]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
 	[UNICHROME_VX800]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
 	[UNICHROME_VX855]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_VX900]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
 };
 
 static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
@@ -812,7 +813,8 @@ static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 		bg_color = cursor->image.bg_color;
 		if (chip_name == UNICHROME_CX700 ||
 			chip_name == UNICHROME_VX800 ||
-			chip_name == UNICHROME_VX855) {
+			chip_name == UNICHROME_VX855 ||
+			chip_name == UNICHROME_VX900) {
 			fg_color =
 				((info->cmap.red[fg_color] & 0xFFC0) << 14) |
 				((info->cmap.green[fg_color] & 0xFFC0) << 4) |
-- 
1.6.3.2

