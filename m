Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1DRTOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:14:46 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48314 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1DRTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:10 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 09/12] staging: xgifb: main: move functions to avoid forward declarations
Date: Mon, 18 Apr 2011 22:14:05 +0300
Message-Id: <1303154048-21989-10-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move functions so that all forward declarations of internal functions
can be deleted.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |   41 ---
 drivers/staging/xgifb/XGI_main_26.c |  599 +++++++++++++++++------------------
 2 files changed, 299 insertions(+), 341 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index c9764a7..1b20e55 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -651,24 +651,6 @@ static unsigned char filter_tb;
 
 /* ---------------------- Routine prototypes ------------------------- */
 
-/* Interface used by the world */
-#ifndef MODULE
-XGIINITSTATIC int __init XGIfb_setup(char *options);
-#endif
-
-/* Interface to the low level console driver */
-
-
-
-/* fbdev routines */
-XGIINITSTATIC int __init xgifb_init(void);
-static int      XGIfb_set_par(struct fb_info *info);
-static int      XGIfb_blank(int blank,
-                            struct fb_info *info);
-/*static int 	XGIfb_mmap(struct fb_info *info, struct file *file,
-		           struct vm_area_struct *vma);
-*/
-
 /*
 extern int	XGIfb_mode_rate_to_dclock(VB_DEVICE_INFO *XGI_Pr,
 			      struct xgi_hw_device_info *HwDeviceExtension,
@@ -683,29 +665,6 @@ extern int      XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, struct xgi_hw_d
 extern unsigned char XGI_SearchModeID(unsigned short ModeNo,
 				unsigned short *ModeIdIndex,
 				struct vb_device_info *);
-static int      XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
-			      struct fb_info *info);
-
-/* Internal general routines */
-static void     XGIfb_search_mode(const char *name);
-static int      XGIfb_validate_mode(int modeindex);
-static u8       XGIfb_search_refresh_rate(unsigned int rate);
-static int      XGIfb_setcolreg(unsigned regno, unsigned red, unsigned green,
-			unsigned blue, unsigned transp,
-			struct fb_info *fb_info);
-static int      XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
-		      	struct fb_info *info);
-static void     XGIfb_pre_setmode(void);
-static void     XGIfb_post_setmode(void);
-
-/* Chipset-dependent internal routines */
-
-
-static int      XGIfb_get_dram_size(void);
-static void     XGIfb_detect_VB(void);
-static void     XGIfb_get_VB_type(void);
-static int      XGIfb_has_VB(void);
-
 
 /* Internal routines to access PCI configuration space */
 unsigned char XGIfb_query_VGA_config_space(struct xgi_hw_device_info *pXGIhw_ext,
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 8de6829..1350681 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -50,7 +50,6 @@
 #define GPIOG_EN    (1<<6)
 #define GPIOG_WRITE (1<<6)
 #define GPIOG_READ  (1<<1)
-int XGIfb_GetXG21DefaultLVDSModeIdx(void);
 
 #define XGIFB_ROM_SIZE	65536
 
@@ -480,6 +479,33 @@ unsigned char XGIfb_query_north_bridge_space(struct xgi_hw_device_info *pXGIhw_e
 */
 /* ------------------ Internal helper routines ----------------- */
 
+int XGIfb_GetXG21DefaultLVDSModeIdx(void)
+{
+
+	int found_mode = 0;
+	int XGIfb_mode_idx = 0;
+
+	found_mode = 0;
+	while ((XGIbios_mode[XGIfb_mode_idx].mode_no != 0)
+			&& (XGIbios_mode[XGIfb_mode_idx].xres
+					<= XGI21_LCDCapList[0].LVDSHDE)) {
+		if ((XGIbios_mode[XGIfb_mode_idx].xres
+				== XGI21_LCDCapList[0].LVDSHDE)
+				&& (XGIbios_mode[XGIfb_mode_idx].yres
+						== XGI21_LCDCapList[0].LVDSVDE)
+				&& (XGIbios_mode[XGIfb_mode_idx].bpp == 8)) {
+			XGIfb_mode_no = XGIbios_mode[XGIfb_mode_idx].mode_no;
+			found_mode = 1;
+			break;
+		}
+		XGIfb_mode_idx++;
+	}
+	if (!found_mode)
+		XGIfb_mode_idx = 0;
+
+	return XGIfb_mode_idx;
+}
+
 static void XGIfb_search_mode(const char *name)
 {
 	int i = 0, j = 0, l;
@@ -603,33 +629,6 @@ static int XGIfb_GetXG21LVDSData(void)
 	return 0;
 }
 
-int XGIfb_GetXG21DefaultLVDSModeIdx(void)
-{
-
-	int found_mode = 0;
-	int XGIfb_mode_idx = 0;
-
-	found_mode = 0;
-	while ((XGIbios_mode[XGIfb_mode_idx].mode_no != 0)
-			&& (XGIbios_mode[XGIfb_mode_idx].xres
-					<= XGI21_LCDCapList[0].LVDSHDE)) {
-		if ((XGIbios_mode[XGIfb_mode_idx].xres
-				== XGI21_LCDCapList[0].LVDSHDE)
-				&& (XGIbios_mode[XGIfb_mode_idx].yres
-						== XGI21_LCDCapList[0].LVDSVDE)
-				&& (XGIbios_mode[XGIfb_mode_idx].bpp == 8)) {
-			XGIfb_mode_no = XGIbios_mode[XGIfb_mode_idx].mode_no;
-			found_mode = 1;
-			break;
-		}
-		XGIfb_mode_idx++;
-	}
-	if (!found_mode)
-		XGIfb_mode_idx = 0;
-
-	return XGIfb_mode_idx;
-}
-
 static int XGIfb_validate_mode(int myindex)
 {
 	u16 xres, yres;
@@ -978,6 +977,224 @@ static void XGIfb_bpp_to_var(struct fb_var_screeninfo *var)
 	}
 }
 
+/* --------------------- SetMode routines ------------------------- */
+
+static void XGIfb_pre_setmode(void)
+{
+	u8 cr30 = 0, cr31 = 0;
+
+	cr31 = xgifb_reg_get(XGICR, 0x31);
+	cr31 &= ~0x60;
+
+	switch (xgi_video_info.disp_state & DISPTYPE_DISP2) {
+	case DISPTYPE_CRT2:
+		cr30 = (XGI_VB_OUTPUT_CRT2 | XGI_SIMULTANEOUS_VIEW_ENABLE);
+		cr31 |= XGI_DRIVER_MODE;
+		break;
+	case DISPTYPE_LCD:
+		cr30 = (XGI_VB_OUTPUT_LCD | XGI_SIMULTANEOUS_VIEW_ENABLE);
+		cr31 |= XGI_DRIVER_MODE;
+		break;
+	case DISPTYPE_TV:
+		if (xgi_video_info.TV_type == TVMODE_HIVISION)
+			cr30 = (XGI_VB_OUTPUT_HIVISION
+					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+		else if (xgi_video_info.TV_plug == TVPLUG_SVIDEO)
+			cr30 = (XGI_VB_OUTPUT_SVIDEO
+					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+		else if (xgi_video_info.TV_plug == TVPLUG_COMPOSITE)
+			cr30 = (XGI_VB_OUTPUT_COMPOSITE
+					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+		else if (xgi_video_info.TV_plug == TVPLUG_SCART)
+			cr30 = (XGI_VB_OUTPUT_SCART
+					| XGI_SIMULTANEOUS_VIEW_ENABLE);
+		cr31 |= XGI_DRIVER_MODE;
+
+		if (XGIfb_tvmode == 1 || xgi_video_info.TV_type == TVMODE_PAL)
+			cr31 |= 0x01;
+		else
+			cr31 &= ~0x01;
+		break;
+	default: /* disable CRT2 */
+		cr30 = 0x00;
+		cr31 |= (XGI_DRIVER_MODE | XGI_VB_OUTPUT_DISABLE);
+	}
+
+	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR30, cr30);
+	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR31, cr31);
+	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR33, (XGIfb_rate_idx & 0x0F));
+}
+
+static void XGIfb_post_setmode(void)
+{
+	u8 reg;
+	unsigned char doit = 1;
+	/*
+	xgifb_reg_set(XGISR,IND_XGI_PASSWORD,XGI_PASSWORD);
+	xgifb_reg_set(XGICR, 0x13, 0x00);
+	xgifb_reg_and_or(XGISR,0x0E, 0xF0, 0x01);
+	*test*
+	*/
+	if (xgi_video_info.video_bpp == 8) {
+		/* TW: We can't switch off CRT1 on LVDS/Chrontel in 8bpp Modes */
+		if ((xgi_video_info.hasVB == HASVB_LVDS)
+				|| (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL)) {
+			doit = 0;
+		}
+		/* TW: We can't switch off CRT1 on 301B-DH in 8bpp Modes if using LCD */
+		if (xgi_video_info.disp_state & DISPTYPE_LCD)
+			doit = 0;
+	}
+
+	/* TW: We can't switch off CRT1 if bridge is in slave mode */
+	if (xgi_video_info.hasVB != HASVB_NONE) {
+		reg = xgifb_reg_get(XGIPART1, 0x00);
+
+		if ((reg & 0x50) == 0x10)
+			doit = 0;
+
+	} else {
+		XGIfb_crt1off = 0;
+	}
+
+	reg = xgifb_reg_get(XGICR, 0x17);
+	if ((XGIfb_crt1off) && (doit))
+		reg &= ~0x80;
+	else
+		reg |= 0x80;
+	xgifb_reg_set(XGICR, 0x17, reg);
+
+	xgifb_reg_and(XGISR, IND_XGI_RAMDAC_CONTROL, ~0x04);
+
+	if ((xgi_video_info.disp_state & DISPTYPE_TV) && (xgi_video_info.hasVB
+			== HASVB_301)) {
+
+		reg = xgifb_reg_get(XGIPART4, 0x01);
+
+		if (reg < 0xB0) { /* Set filter for XGI301 */
+
+			switch (xgi_video_info.video_width) {
+			case 320:
+				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 4 : 12;
+				break;
+			case 640:
+				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 5 : 13;
+				break;
+			case 720:
+				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 6 : 14;
+				break;
+			case 800:
+				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 7 : 15;
+				break;
+			default:
+				filter = -1;
+				break;
+			}
+
+			xgifb_reg_or(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
+
+			if (xgi_video_info.TV_type == TVMODE_NTSC) {
+
+				xgifb_reg_and(XGIPART2, 0x3a, 0x1f);
+
+				if (xgi_video_info.TV_plug == TVPLUG_SVIDEO) {
+
+					xgifb_reg_and(XGIPART2, 0x30, 0xdf);
+
+				} else if (xgi_video_info.TV_plug
+						== TVPLUG_COMPOSITE) {
+
+					xgifb_reg_or(XGIPART2, 0x30, 0x20);
+
+					switch (xgi_video_info.video_width) {
+					case 640:
+						xgifb_reg_set(XGIPART2, 0x35, 0xEB);
+						xgifb_reg_set(XGIPART2, 0x36, 0x04);
+						xgifb_reg_set(XGIPART2, 0x37, 0x25);
+						xgifb_reg_set(XGIPART2, 0x38, 0x18);
+						break;
+					case 720:
+						xgifb_reg_set(XGIPART2, 0x35, 0xEE);
+						xgifb_reg_set(XGIPART2, 0x36, 0x0C);
+						xgifb_reg_set(XGIPART2, 0x37, 0x22);
+						xgifb_reg_set(XGIPART2, 0x38, 0x08);
+						break;
+					case 800:
+						xgifb_reg_set(XGIPART2, 0x35, 0xEB);
+						xgifb_reg_set(XGIPART2, 0x36, 0x15);
+						xgifb_reg_set(XGIPART2, 0x37, 0x25);
+						xgifb_reg_set(XGIPART2, 0x38, 0xF6);
+						break;
+					}
+				}
+
+			} else if (xgi_video_info.TV_type == TVMODE_PAL) {
+
+				xgifb_reg_and(XGIPART2, 0x3A, 0x1F);
+
+				if (xgi_video_info.TV_plug == TVPLUG_SVIDEO) {
+
+					xgifb_reg_and(XGIPART2, 0x30, 0xDF);
+
+				} else if (xgi_video_info.TV_plug
+						== TVPLUG_COMPOSITE) {
+
+					xgifb_reg_or(XGIPART2, 0x30, 0x20);
+
+					switch (xgi_video_info.video_width) {
+					case 640:
+						xgifb_reg_set(XGIPART2, 0x35, 0xF1);
+						xgifb_reg_set(XGIPART2, 0x36, 0xF7);
+						xgifb_reg_set(XGIPART2, 0x37, 0x1F);
+						xgifb_reg_set(XGIPART2, 0x38, 0x32);
+						break;
+					case 720:
+						xgifb_reg_set(XGIPART2, 0x35, 0xF3);
+						xgifb_reg_set(XGIPART2, 0x36, 0x00);
+						xgifb_reg_set(XGIPART2, 0x37, 0x1D);
+						xgifb_reg_set(XGIPART2, 0x38, 0x20);
+						break;
+					case 800:
+						xgifb_reg_set(XGIPART2, 0x35, 0xFC);
+						xgifb_reg_set(XGIPART2, 0x36, 0xFB);
+						xgifb_reg_set(XGIPART2, 0x37, 0x14);
+						xgifb_reg_set(XGIPART2, 0x38, 0x2A);
+						break;
+					}
+				}
+			}
+
+			if ((filter >= 0) && (filter <= 7)) {
+				DPRINTK("FilterTable[%d]-%d: %02x %02x %02x %02x\n", filter_tb, filter,
+						XGI_TV_filter[filter_tb].filter[filter][0],
+						XGI_TV_filter[filter_tb].filter[filter][1],
+						XGI_TV_filter[filter_tb].filter[filter][2],
+						XGI_TV_filter[filter_tb].filter[filter][3]
+				);
+				xgifb_reg_set(
+						XGIPART2,
+						0x35,
+						(XGI_TV_filter[filter_tb].filter[filter][0]));
+				xgifb_reg_set(
+						XGIPART2,
+						0x36,
+						(XGI_TV_filter[filter_tb].filter[filter][1]));
+				xgifb_reg_set(
+						XGIPART2,
+						0x37,
+						(XGI_TV_filter[filter_tb].filter[filter][2]));
+				xgifb_reg_set(
+						XGIPART2,
+						0x38,
+						(XGI_TV_filter[filter_tb].filter[filter][3]));
+			}
+
+		}
+
+	}
+
+}
+
 static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		struct fb_info *info)
 {
@@ -1249,6 +1466,41 @@ static int XGIfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	return 0;
 }
 
+/* ----------- FBDev related routines for all series ---------- */
+
+static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
+		struct fb_info *info)
+{
+	DEBUGPRN("inside get_fix");
+	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
+
+	strcpy(fix->id, myid);
+
+	fix->smem_start = xgi_video_info.video_base;
+
+	fix->smem_len = xgi_video_info.video_size;
+
+	fix->type = video_type;
+	fix->type_aux = 0;
+	if (xgi_video_info.video_bpp == 8)
+		fix->visual = FB_VISUAL_PSEUDOCOLOR;
+	else
+		fix->visual = FB_VISUAL_DIRECTCOLOR;
+	fix->xpanstep = 0;
+#ifdef XGIFB_PAN
+	if (XGIfb_ypan)
+		fix->ypanstep = 1;
+#endif
+	fix->ywrapstep = 0;
+	fix->line_length = xgi_video_info.video_linelength;
+	fix->mmio_start = xgi_video_info.mmio_base;
+	fix->mmio_len = xgi_video_info.mmio_size;
+	fix->accel = FB_ACCEL_XGI_XABRE;
+
+	DEBUGPRN("end of get_fix");
+	return 0;
+}
+
 static int XGIfb_set_par(struct fb_info *info)
 {
 	int err;
@@ -1460,41 +1712,6 @@ static int XGIfb_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
-/* ----------- FBDev related routines for all series ---------- */
-
-static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
-		struct fb_info *info)
-{
-	DEBUGPRN("inside get_fix");
-	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
-
-	strcpy(fix->id, myid);
-
-	fix->smem_start = xgi_video_info.video_base;
-
-	fix->smem_len = xgi_video_info.video_size;
-
-	fix->type = video_type;
-	fix->type_aux = 0;
-	if (xgi_video_info.video_bpp == 8)
-		fix->visual = FB_VISUAL_PSEUDOCOLOR;
-	else
-		fix->visual = FB_VISUAL_DIRECTCOLOR;
-	fix->xpanstep = 0;
-#ifdef XGIFB_PAN
-	if (XGIfb_ypan)
-		fix->ypanstep = 1;
-#endif
-	fix->ywrapstep = 0;
-	fix->line_length = xgi_video_info.video_linelength;
-	fix->mmio_start = xgi_video_info.mmio_base;
-	fix->mmio_len = xgi_video_info.mmio_size;
-	fix->accel = FB_ACCEL_XGI_XABRE;
-
-	DEBUGPRN("end of get_fix");
-	return 0;
-}
-
 static struct fb_ops XGIfb_ops = {
 	.owner = THIS_MODULE,
 	.fb_open = XGIfb_open,
@@ -1676,25 +1893,6 @@ static void XGIfb_detect_VB(void)
 	}
 }
 
-static void XGIfb_get_VB_type(void)
-{
-	u8 reg;
-
-	if (!XGIfb_has_VB()) {
-		reg = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR37);
-		switch ((reg & XGI_EXTERNAL_CHIP_MASK) >> 1) {
-		case XGI310_EXTERNAL_CHIP_LVDS:
-			xgi_video_info.hasVB = HASVB_LVDS;
-			break;
-		case XGI310_EXTERNAL_CHIP_LVDS_CHRONTEL:
-			xgi_video_info.hasVB = HASVB_LVDS_CHRONTEL;
-			break;
-		default:
-			break;
-		}
-	}
-}
-
 static int XGIfb_has_VB(void)
 {
 	u8 vb_chipid;
@@ -1714,6 +1912,25 @@ static int XGIfb_has_VB(void)
 	return 1;
 }
 
+static void XGIfb_get_VB_type(void)
+{
+	u8 reg;
+
+	if (!XGIfb_has_VB()) {
+		reg = xgifb_reg_get(XGICR, IND_XGI_SCRATCH_REG_CR37);
+		switch ((reg & XGI_EXTERNAL_CHIP_MASK) >> 1) {
+		case XGI310_EXTERNAL_CHIP_LVDS:
+			xgi_video_info.hasVB = HASVB_LVDS;
+			break;
+		case XGI310_EXTERNAL_CHIP_LVDS_CHRONTEL:
+			xgi_video_info.hasVB = HASVB_LVDS_CHRONTEL;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 /* ------------------ Sensing routines ------------------ */
 
 /* TW: Determine and detect attached devices on XGI30x */
@@ -1836,224 +2053,6 @@ void XGI_Sense30x(void)
 	xgifb_reg_set(XGIPART4, 0x0d, backupP4_0d);
 }
 
-/* --------------------- SetMode routines ------------------------- */
-
-static void XGIfb_pre_setmode(void)
-{
-	u8 cr30 = 0, cr31 = 0;
-
-	cr31 = xgifb_reg_get(XGICR, 0x31);
-	cr31 &= ~0x60;
-
-	switch (xgi_video_info.disp_state & DISPTYPE_DISP2) {
-	case DISPTYPE_CRT2:
-		cr30 = (XGI_VB_OUTPUT_CRT2 | XGI_SIMULTANEOUS_VIEW_ENABLE);
-		cr31 |= XGI_DRIVER_MODE;
-		break;
-	case DISPTYPE_LCD:
-		cr30 = (XGI_VB_OUTPUT_LCD | XGI_SIMULTANEOUS_VIEW_ENABLE);
-		cr31 |= XGI_DRIVER_MODE;
-		break;
-	case DISPTYPE_TV:
-		if (xgi_video_info.TV_type == TVMODE_HIVISION)
-			cr30 = (XGI_VB_OUTPUT_HIVISION
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
-		else if (xgi_video_info.TV_plug == TVPLUG_SVIDEO)
-			cr30 = (XGI_VB_OUTPUT_SVIDEO
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
-		else if (xgi_video_info.TV_plug == TVPLUG_COMPOSITE)
-			cr30 = (XGI_VB_OUTPUT_COMPOSITE
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
-		else if (xgi_video_info.TV_plug == TVPLUG_SCART)
-			cr30 = (XGI_VB_OUTPUT_SCART
-					| XGI_SIMULTANEOUS_VIEW_ENABLE);
-		cr31 |= XGI_DRIVER_MODE;
-
-		if (XGIfb_tvmode == 1 || xgi_video_info.TV_type == TVMODE_PAL)
-			cr31 |= 0x01;
-		else
-			cr31 &= ~0x01;
-		break;
-	default: /* disable CRT2 */
-		cr30 = 0x00;
-		cr31 |= (XGI_DRIVER_MODE | XGI_VB_OUTPUT_DISABLE);
-	}
-
-	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR30, cr30);
-	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR31, cr31);
-	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR33, (XGIfb_rate_idx & 0x0F));
-}
-
-static void XGIfb_post_setmode(void)
-{
-	u8 reg;
-	unsigned char doit = 1;
-	/*
-	xgifb_reg_set(XGISR,IND_XGI_PASSWORD,XGI_PASSWORD);
-	xgifb_reg_set(XGICR, 0x13, 0x00);
-	xgifb_reg_and_or(XGISR,0x0E, 0xF0, 0x01);
-	*test*
-	*/
-	if (xgi_video_info.video_bpp == 8) {
-		/* TW: We can't switch off CRT1 on LVDS/Chrontel in 8bpp Modes */
-		if ((xgi_video_info.hasVB == HASVB_LVDS)
-				|| (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL)) {
-			doit = 0;
-		}
-		/* TW: We can't switch off CRT1 on 301B-DH in 8bpp Modes if using LCD */
-		if (xgi_video_info.disp_state & DISPTYPE_LCD)
-			doit = 0;
-	}
-
-	/* TW: We can't switch off CRT1 if bridge is in slave mode */
-	if (xgi_video_info.hasVB != HASVB_NONE) {
-		reg = xgifb_reg_get(XGIPART1, 0x00);
-
-		if ((reg & 0x50) == 0x10)
-			doit = 0;
-
-	} else {
-		XGIfb_crt1off = 0;
-	}
-
-	reg = xgifb_reg_get(XGICR, 0x17);
-	if ((XGIfb_crt1off) && (doit))
-		reg &= ~0x80;
-	else
-		reg |= 0x80;
-	xgifb_reg_set(XGICR, 0x17, reg);
-
-	xgifb_reg_and(XGISR, IND_XGI_RAMDAC_CONTROL, ~0x04);
-
-	if ((xgi_video_info.disp_state & DISPTYPE_TV) && (xgi_video_info.hasVB
-			== HASVB_301)) {
-
-		reg = xgifb_reg_get(XGIPART4, 0x01);
-
-		if (reg < 0xB0) { /* Set filter for XGI301 */
-
-			switch (xgi_video_info.video_width) {
-			case 320:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 4 : 12;
-				break;
-			case 640:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 5 : 13;
-				break;
-			case 720:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 6 : 14;
-				break;
-			case 800:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 7 : 15;
-				break;
-			default:
-				filter = -1;
-				break;
-			}
-
-			xgifb_reg_or(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
-
-			if (xgi_video_info.TV_type == TVMODE_NTSC) {
-
-				xgifb_reg_and(XGIPART2, 0x3a, 0x1f);
-
-				if (xgi_video_info.TV_plug == TVPLUG_SVIDEO) {
-
-					xgifb_reg_and(XGIPART2, 0x30, 0xdf);
-
-				} else if (xgi_video_info.TV_plug
-						== TVPLUG_COMPOSITE) {
-
-					xgifb_reg_or(XGIPART2, 0x30, 0x20);
-
-					switch (xgi_video_info.video_width) {
-					case 640:
-						xgifb_reg_set(XGIPART2, 0x35, 0xEB);
-						xgifb_reg_set(XGIPART2, 0x36, 0x04);
-						xgifb_reg_set(XGIPART2, 0x37, 0x25);
-						xgifb_reg_set(XGIPART2, 0x38, 0x18);
-						break;
-					case 720:
-						xgifb_reg_set(XGIPART2, 0x35, 0xEE);
-						xgifb_reg_set(XGIPART2, 0x36, 0x0C);
-						xgifb_reg_set(XGIPART2, 0x37, 0x22);
-						xgifb_reg_set(XGIPART2, 0x38, 0x08);
-						break;
-					case 800:
-						xgifb_reg_set(XGIPART2, 0x35, 0xEB);
-						xgifb_reg_set(XGIPART2, 0x36, 0x15);
-						xgifb_reg_set(XGIPART2, 0x37, 0x25);
-						xgifb_reg_set(XGIPART2, 0x38, 0xF6);
-						break;
-					}
-				}
-
-			} else if (xgi_video_info.TV_type == TVMODE_PAL) {
-
-				xgifb_reg_and(XGIPART2, 0x3A, 0x1F);
-
-				if (xgi_video_info.TV_plug == TVPLUG_SVIDEO) {
-
-					xgifb_reg_and(XGIPART2, 0x30, 0xDF);
-
-				} else if (xgi_video_info.TV_plug
-						== TVPLUG_COMPOSITE) {
-
-					xgifb_reg_or(XGIPART2, 0x30, 0x20);
-
-					switch (xgi_video_info.video_width) {
-					case 640:
-						xgifb_reg_set(XGIPART2, 0x35, 0xF1);
-						xgifb_reg_set(XGIPART2, 0x36, 0xF7);
-						xgifb_reg_set(XGIPART2, 0x37, 0x1F);
-						xgifb_reg_set(XGIPART2, 0x38, 0x32);
-						break;
-					case 720:
-						xgifb_reg_set(XGIPART2, 0x35, 0xF3);
-						xgifb_reg_set(XGIPART2, 0x36, 0x00);
-						xgifb_reg_set(XGIPART2, 0x37, 0x1D);
-						xgifb_reg_set(XGIPART2, 0x38, 0x20);
-						break;
-					case 800:
-						xgifb_reg_set(XGIPART2, 0x35, 0xFC);
-						xgifb_reg_set(XGIPART2, 0x36, 0xFB);
-						xgifb_reg_set(XGIPART2, 0x37, 0x14);
-						xgifb_reg_set(XGIPART2, 0x38, 0x2A);
-						break;
-					}
-				}
-			}
-
-			if ((filter >= 0) && (filter <= 7)) {
-				DPRINTK("FilterTable[%d]-%d: %02x %02x %02x %02x\n", filter_tb, filter,
-						XGI_TV_filter[filter_tb].filter[filter][0],
-						XGI_TV_filter[filter_tb].filter[filter][1],
-						XGI_TV_filter[filter_tb].filter[filter][2],
-						XGI_TV_filter[filter_tb].filter[filter][3]
-				);
-				xgifb_reg_set(
-						XGIPART2,
-						0x35,
-						(XGI_TV_filter[filter_tb].filter[filter][0]));
-				xgifb_reg_set(
-						XGIPART2,
-						0x36,
-						(XGI_TV_filter[filter_tb].filter[filter][1]));
-				xgifb_reg_set(
-						XGIPART2,
-						0x37,
-						(XGI_TV_filter[filter_tb].filter[filter][2]));
-				xgifb_reg_set(
-						XGIPART2,
-						0x38,
-						(XGI_TV_filter[filter_tb].filter[filter][3]));
-			}
-
-		}
-
-	}
-
-}
-
 XGIINITSTATIC int __init XGIfb_setup(char *options)
 {
 	char *this_opt;
-- 
1.5.6.5

