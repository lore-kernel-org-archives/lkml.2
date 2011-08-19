Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1HSTlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:41:08 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:55643 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab1HSTke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:34 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] staging: xgifb: probe: delete checks for mode "none"
Date: Fri, 19 Aug 2011 22:40:26 +0300
Message-Id: <1313782830-31461-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver does not allow selecting the mode "none", so no need to check
for that in probe.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |  499 +++++++++++++++++------------------
 1 files changed, 246 insertions(+), 253 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index cc4127f..1674a4b 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2143,15 +2143,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error;
 	}
 
-	if ((xgifb_mode_idx < 0) ||
-	    ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
-		/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
-		xgifb_reg_or(XGISR,
-			     IND_XGI_PCI_ADDRESS_SET,
-			     (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
-		/* Enable 2D accelerator engine */
-		xgifb_reg_or(XGISR, IND_XGI_MODULE_ENABLE, XGI_ENABLE_2D);
-	}
+	/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
+	xgifb_reg_or(XGISR,
+		     IND_XGI_PCI_ADDRESS_SET,
+		     (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
+	/* Enable 2D accelerator engine */
+	xgifb_reg_or(XGISR, IND_XGI_MODULE_ENABLE, XGI_ENABLE_2D);
 
 	XGIhw_ext.ulVideoMemorySize = xgi_video_info.video_size;
 
@@ -2195,298 +2192,294 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	xgi_video_info.mtrr = (unsigned int) 0;
 
-	if ((xgifb_mode_idx < 0) ||
-	    ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
+	xgi_video_info.hasVB = HASVB_NONE;
+	if ((xgi_video_info.chip == XG20) ||
+	    (xgi_video_info.chip == XG27)) {
 		xgi_video_info.hasVB = HASVB_NONE;
-		if ((xgi_video_info.chip == XG20) ||
-		    (xgi_video_info.chip == XG27)) {
-			xgi_video_info.hasVB = HASVB_NONE;
-		} else if (xgi_video_info.chip == XG21) {
-			CR38 = xgifb_reg_get(XGICR, 0x38);
-			if ((CR38&0xE0) == 0xC0) {
-				xgi_video_info.disp_state = DISPTYPE_LCD;
-				if (!XGIfb_GetXG21LVDSData()) {
-					int m;
-					for (m = 0; m < sizeof(XGI21_LCDCapList)/sizeof(struct XGI21_LVDSCapStruct); m++) {
-						if ((XGI21_LCDCapList[m].LVDSHDE == XGIbios_mode[xgifb_mode_idx].xres) &&
-						    (XGI21_LCDCapList[m].LVDSVDE == XGIbios_mode[xgifb_mode_idx].yres)) {
-							xgifb_reg_set(XGI_Pr.P3d4, 0x36, m);
-						}
+	} else if (xgi_video_info.chip == XG21) {
+		CR38 = xgifb_reg_get(XGICR, 0x38);
+		if ((CR38&0xE0) == 0xC0) {
+			xgi_video_info.disp_state = DISPTYPE_LCD;
+			if (!XGIfb_GetXG21LVDSData()) {
+				int m;
+				for (m = 0; m < sizeof(XGI21_LCDCapList)/sizeof(struct XGI21_LVDSCapStruct); m++) {
+					if ((XGI21_LCDCapList[m].LVDSHDE == XGIbios_mode[xgifb_mode_idx].xres) &&
+					    (XGI21_LCDCapList[m].LVDSVDE == XGIbios_mode[xgifb_mode_idx].yres)) {
+						xgifb_reg_set(XGI_Pr.P3d4, 0x36, m);
 					}
 				}
-			} else if ((CR38&0xE0) == 0x60) {
-				xgi_video_info.hasVB = HASVB_CHRONTEL;
-			} else {
-				xgi_video_info.hasVB = HASVB_NONE;
 			}
+		} else if ((CR38&0xE0) == 0x60) {
+			xgi_video_info.hasVB = HASVB_CHRONTEL;
 		} else {
-			XGIfb_get_VB_type();
+			xgi_video_info.hasVB = HASVB_NONE;
 		}
+	} else {
+		XGIfb_get_VB_type();
+	}
 
-		XGIhw_ext.ujVBChipID = VB_CHIP_UNKNOWN;
-
-		XGIhw_ext.ulExternalChip = 0;
+	XGIhw_ext.ujVBChipID = VB_CHIP_UNKNOWN;
 
-		switch (xgi_video_info.hasVB) {
-		case HASVB_301:
-			reg = xgifb_reg_get(XGIPART4, 0x01);
-			if (reg >= 0xE0) {
-				XGIhw_ext.ujVBChipID = VB_CHIP_302LV;
-				printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
-			} else if (reg >= 0xD0) {
-				XGIhw_ext.ujVBChipID = VB_CHIP_301LV;
-				printk(KERN_INFO "XGIfb: XGI301LV bridge detected (revision 0x%02x)\n", reg);
-			}
-			/* else if (reg >= 0xB0) {
-				XGIhw_ext.ujVBChipID = VB_CHIP_301B;
-				reg1 = xgifb_reg_get(XGIPART4, 0x23);
-				printk("XGIfb: XGI301B bridge detected\n");
-			} */
-			else {
-				XGIhw_ext.ujVBChipID = VB_CHIP_301;
-				printk("XGIfb: XGI301 bridge detected\n");
-			}
-			break;
-		case HASVB_302:
-			reg = xgifb_reg_get(XGIPART4, 0x01);
-			if (reg >= 0xE0) {
-				XGIhw_ext.ujVBChipID = VB_CHIP_302LV;
-				printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
-			} else if (reg >= 0xD0) {
-				XGIhw_ext.ujVBChipID = VB_CHIP_301LV;
-				printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
-			} else if (reg >= 0xB0) {
-				reg1 = xgifb_reg_get(XGIPART4, 0x23);
-
-				XGIhw_ext.ujVBChipID = VB_CHIP_302B;
+	XGIhw_ext.ulExternalChip = 0;
 
-			} else {
-				XGIhw_ext.ujVBChipID = VB_CHIP_302;
-				printk(KERN_INFO "XGIfb: XGI302 bridge detected\n");
-			}
-			break;
-		case HASVB_LVDS:
-			XGIhw_ext.ulExternalChip = 0x1;
-			printk(KERN_INFO "XGIfb: LVDS transmitter detected\n");
-			break;
-		case HASVB_TRUMPION:
-			XGIhw_ext.ulExternalChip = 0x2;
-			printk(KERN_INFO "XGIfb: Trumpion Zurac LVDS scaler detected\n");
-			break;
-		case HASVB_CHRONTEL:
-			XGIhw_ext.ulExternalChip = 0x4;
-			printk(KERN_INFO "XGIfb: Chrontel TV encoder detected\n");
-			break;
-		case HASVB_LVDS_CHRONTEL:
-			XGIhw_ext.ulExternalChip = 0x5;
-			printk(KERN_INFO "XGIfb: LVDS transmitter and Chrontel TV encoder detected\n");
-			break;
-		default:
-			printk(KERN_INFO "XGIfb: No or unknown bridge type detected\n");
-			break;
+	switch (xgi_video_info.hasVB) {
+	case HASVB_301:
+		reg = xgifb_reg_get(XGIPART4, 0x01);
+		if (reg >= 0xE0) {
+			XGIhw_ext.ujVBChipID = VB_CHIP_302LV;
+			printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
+		} else if (reg >= 0xD0) {
+			XGIhw_ext.ujVBChipID = VB_CHIP_301LV;
+			printk(KERN_INFO "XGIfb: XGI301LV bridge detected (revision 0x%02x)\n", reg);
 		}
+		/* else if (reg >= 0xB0) {
+			XGIhw_ext.ujVBChipID = VB_CHIP_301B;
+			reg1 = xgifb_reg_get(XGIPART4, 0x23);
+			printk("XGIfb: XGI301B bridge detected\n");
+		} */
+		else {
+			XGIhw_ext.ujVBChipID = VB_CHIP_301;
+			printk("XGIfb: XGI301 bridge detected\n");
+		}
+		break;
+	case HASVB_302:
+		reg = xgifb_reg_get(XGIPART4, 0x01);
+		if (reg >= 0xE0) {
+			XGIhw_ext.ujVBChipID = VB_CHIP_302LV;
+			printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
+		} else if (reg >= 0xD0) {
+			XGIhw_ext.ujVBChipID = VB_CHIP_301LV;
+			printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
+		} else if (reg >= 0xB0) {
+			reg1 = xgifb_reg_get(XGIPART4, 0x23);
 
-		if (xgi_video_info.hasVB != HASVB_NONE)
-			XGIfb_detect_VB();
+			XGIhw_ext.ujVBChipID = VB_CHIP_302B;
 
-		if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
-			if (XGIfb_crt1off)
-				xgi_video_info.disp_state |= DISPMODE_SINGLE;
-			else
-				xgi_video_info.disp_state |= (DISPMODE_MIRROR |
-							      DISPTYPE_CRT1);
 		} else {
-			xgi_video_info.disp_state = DISPMODE_SINGLE |
-						    DISPTYPE_CRT1;
+			XGIhw_ext.ujVBChipID = VB_CHIP_302;
+			printk(KERN_INFO "XGIfb: XGI302 bridge detected\n");
 		}
+		break;
+	case HASVB_LVDS:
+		XGIhw_ext.ulExternalChip = 0x1;
+		printk(KERN_INFO "XGIfb: LVDS transmitter detected\n");
+		break;
+	case HASVB_TRUMPION:
+		XGIhw_ext.ulExternalChip = 0x2;
+		printk(KERN_INFO "XGIfb: Trumpion Zurac LVDS scaler detected\n");
+		break;
+	case HASVB_CHRONTEL:
+		XGIhw_ext.ulExternalChip = 0x4;
+		printk(KERN_INFO "XGIfb: Chrontel TV encoder detected\n");
+		break;
+	case HASVB_LVDS_CHRONTEL:
+		XGIhw_ext.ulExternalChip = 0x5;
+		printk(KERN_INFO "XGIfb: LVDS transmitter and Chrontel TV encoder detected\n");
+		break;
+	default:
+		printk(KERN_INFO "XGIfb: No or unknown bridge type detected\n");
+		break;
+	}
 
-		if (xgi_video_info.disp_state & DISPTYPE_LCD) {
-			if (!enable_dstn) {
-				reg = xgifb_reg_get(XGICR, IND_XGI_LCD_PANEL);
-				reg &= 0x0f;
-				XGIhw_ext.ulCRT2LCDType = XGI310paneltype[reg];
+	if (xgi_video_info.hasVB != HASVB_NONE)
+		XGIfb_detect_VB();
 
-			} else {
-				/* TW: FSTN/DSTN */
-				XGIhw_ext.ulCRT2LCDType = LCD_320x480;
-			}
+	if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
+		if (XGIfb_crt1off)
+			xgi_video_info.disp_state |= DISPMODE_SINGLE;
+		else
+			xgi_video_info.disp_state |= (DISPMODE_MIRROR |
+						      DISPTYPE_CRT1);
+	} else {
+		xgi_video_info.disp_state = DISPMODE_SINGLE |
+					    DISPTYPE_CRT1;
+	}
+
+	if (xgi_video_info.disp_state & DISPTYPE_LCD) {
+		if (!enable_dstn) {
+			reg = xgifb_reg_get(XGICR, IND_XGI_LCD_PANEL);
+			reg &= 0x0f;
+			XGIhw_ext.ulCRT2LCDType = XGI310paneltype[reg];
+
+		} else {
+			/* TW: FSTN/DSTN */
+			XGIhw_ext.ulCRT2LCDType = LCD_320x480;
 		}
+	}
 
-		XGIfb_detectedpdc = 0;
+	XGIfb_detectedpdc = 0;
 
-		XGIfb_detectedlcda = 0xff;
+	XGIfb_detectedlcda = 0xff;
 
-		/* TW: Try to find about LCDA */
+	/* TW: Try to find about LCDA */
 
-		if ((XGIhw_ext.ujVBChipID == VB_CHIP_302B) ||
-				(XGIhw_ext.ujVBChipID == VB_CHIP_301LV) ||
-				(XGIhw_ext.ujVBChipID == VB_CHIP_302LV)) {
-			int tmp;
-			tmp = xgifb_reg_get(XGICR, 0x34);
-			if (tmp <= 0x13) {
+	if ((XGIhw_ext.ujVBChipID == VB_CHIP_302B) ||
+			(XGIhw_ext.ujVBChipID == VB_CHIP_301LV) ||
+			(XGIhw_ext.ujVBChipID == VB_CHIP_302LV)) {
+		int tmp;
+		tmp = xgifb_reg_get(XGICR, 0x34);
+		if (tmp <= 0x13) {
+			/* Currently on LCDA?
+			 *(Some BIOSes leave CR38) */
+			tmp = xgifb_reg_get(XGICR, 0x38);
+			if ((tmp & 0x03) == 0x03) {
+				/* XGI_Pr.XGI_UseLCDA = 1; */
+			} else {
 				/* Currently on LCDA?
-				 *(Some BIOSes leave CR38) */
-				tmp = xgifb_reg_get(XGICR, 0x38);
-				if ((tmp & 0x03) == 0x03) {
+				 *(Some newer BIOSes set D0 in CR35) */
+				tmp = xgifb_reg_get(XGICR, 0x35);
+				if (tmp & 0x01) {
 					/* XGI_Pr.XGI_UseLCDA = 1; */
 				} else {
-					/* Currently on LCDA?
-					 *(Some newer BIOSes set D0 in CR35) */
-					tmp = xgifb_reg_get(XGICR, 0x35);
-					if (tmp & 0x01) {
-						/* XGI_Pr.XGI_UseLCDA = 1; */
-					} else {
-						tmp = xgifb_reg_get(XGICR,
-								    0x30);
-						if (tmp & 0x20) {
-							tmp = xgifb_reg_get(
-								XGIPART1, 0x13);
-							if (tmp & 0x04) {
-								/* XGI_Pr.XGI_UseLCDA = 1; */
-							}
+					tmp = xgifb_reg_get(XGICR,
+							    0x30);
+					if (tmp & 0x20) {
+						tmp = xgifb_reg_get(
+							XGIPART1, 0x13);
+						if (tmp & 0x04) {
+							/* XGI_Pr.XGI_UseLCDA = 1; */
 						}
 					}
 				}
 			}
-
 		}
 
-		if (xgifb_mode_idx >= 0)
-			xgifb_mode_idx = XGIfb_validate_mode(xgifb_mode_idx);
-
-		if (xgifb_mode_idx < 0) {
-			switch (xgi_video_info.disp_state & DISPTYPE_DISP2) {
-			case DISPTYPE_LCD:
-				xgifb_mode_idx = DEFAULT_LCDMODE;
-				if (xgi_video_info.chip == XG21)
-					xgifb_mode_idx =
-					    XGIfb_GetXG21DefaultLVDSModeIdx();
-				break;
-			case DISPTYPE_TV:
-				xgifb_mode_idx = DEFAULT_TVMODE;
-				break;
-			default:
-				xgifb_mode_idx = DEFAULT_MODE;
-				break;
-			}
-		}
-
-		XGIfb_mode_no = XGIbios_mode[xgifb_mode_idx].mode_no;
+	}
 
-		/* yilin set default refresh rate */
-		if (xgi_video_info.refresh_rate == 0)
-			xgi_video_info.refresh_rate = 60;
-		if (XGIfb_search_refresh_rate(
-				xgi_video_info.refresh_rate) == 0) {
-			XGIfb_rate_idx = XGIbios_mode[xgifb_mode_idx].rate_idx;
-			xgi_video_info.refresh_rate = 60;
-		}
+	if (xgifb_mode_idx >= 0)
+		xgifb_mode_idx = XGIfb_validate_mode(xgifb_mode_idx);
 
-		xgi_video_info.video_bpp = XGIbios_mode[xgifb_mode_idx].bpp;
-		xgi_video_info.video_vwidth =
-			xgi_video_info.video_width =
-				XGIbios_mode[xgifb_mode_idx].xres;
-		xgi_video_info.video_vheight =
-			xgi_video_info.video_height =
-				XGIbios_mode[xgifb_mode_idx].yres;
-		xgi_video_info.org_x = xgi_video_info.org_y = 0;
-		xgi_video_info.video_linelength =
-			xgi_video_info.video_width *
-			(xgi_video_info.video_bpp >> 3);
-		switch (xgi_video_info.video_bpp) {
-		case 8:
-			xgi_video_info.DstColor = 0x0000;
-			xgi_video_info.XGI310_AccelDepth = 0x00000000;
-			xgi_video_info.video_cmap_len = 256;
-			break;
-		case 16:
-			xgi_video_info.DstColor = 0x8000;
-			xgi_video_info.XGI310_AccelDepth = 0x00010000;
-			xgi_video_info.video_cmap_len = 16;
+	if (xgifb_mode_idx < 0) {
+		switch (xgi_video_info.disp_state & DISPTYPE_DISP2) {
+		case DISPTYPE_LCD:
+			xgifb_mode_idx = DEFAULT_LCDMODE;
+			if (xgi_video_info.chip == XG21)
+				xgifb_mode_idx =
+				    XGIfb_GetXG21DefaultLVDSModeIdx();
 			break;
-		case 32:
-			xgi_video_info.DstColor = 0xC000;
-			xgi_video_info.XGI310_AccelDepth = 0x00020000;
-			xgi_video_info.video_cmap_len = 16;
+		case DISPTYPE_TV:
+			xgifb_mode_idx = DEFAULT_TVMODE;
 			break;
 		default:
-			xgi_video_info.video_cmap_len = 16;
-			printk(KERN_INFO "XGIfb: Unsupported depth %d",
-			       xgi_video_info.video_bpp);
+			xgifb_mode_idx = DEFAULT_MODE;
 			break;
 		}
+	}
 
-		printk(KERN_INFO "XGIfb: Default mode is %dx%dx%d (%dHz)\n",
-		       xgi_video_info.video_width,
-		       xgi_video_info.video_height,
-		       xgi_video_info.video_bpp,
-		       xgi_video_info.refresh_rate);
-
-		default_var.xres =
-			default_var.xres_virtual =
-				xgi_video_info.video_width;
-		default_var.yres =
-			default_var.yres_virtual =
-				xgi_video_info.video_height;
-		default_var.bits_per_pixel = xgi_video_info.video_bpp;
-
-		XGIfb_bpp_to_var(&default_var);
-
-		default_var.pixclock = (u32) (1000000000 /
-				XGIfb_mode_rate_to_dclock(&XGI_Pr, &XGIhw_ext,
-						XGIfb_mode_no, XGIfb_rate_idx));
-
-		if (XGIfb_mode_rate_to_ddata(&XGI_Pr, &XGIhw_ext,
-			XGIfb_mode_no, XGIfb_rate_idx,
-			&default_var.left_margin, &default_var.right_margin,
-			&default_var.upper_margin, &default_var.lower_margin,
-			&default_var.hsync_len, &default_var.vsync_len,
-			&default_var.sync, &default_var.vmode)) {
-
-			if ((default_var.vmode & FB_VMODE_MASK) ==
-			    FB_VMODE_INTERLACED) {
-				default_var.yres <<= 1;
-				default_var.yres_virtual <<= 1;
-			} else if ((default_var.vmode & FB_VMODE_MASK) ==
-				   FB_VMODE_DOUBLE) {
-				default_var.pixclock >>= 1;
-				default_var.yres >>= 1;
-				default_var.yres_virtual >>= 1;
-			}
+	XGIfb_mode_no = XGIbios_mode[xgifb_mode_idx].mode_no;
 
+	/* yilin set default refresh rate */
+	if (xgi_video_info.refresh_rate == 0)
+		xgi_video_info.refresh_rate = 60;
+	if (XGIfb_search_refresh_rate(
+			xgi_video_info.refresh_rate) == 0) {
+		XGIfb_rate_idx = XGIbios_mode[xgifb_mode_idx].rate_idx;
+		xgi_video_info.refresh_rate = 60;
+	}
+
+	xgi_video_info.video_bpp = XGIbios_mode[xgifb_mode_idx].bpp;
+	xgi_video_info.video_vwidth =
+		xgi_video_info.video_width =
+			XGIbios_mode[xgifb_mode_idx].xres;
+	xgi_video_info.video_vheight =
+		xgi_video_info.video_height =
+			XGIbios_mode[xgifb_mode_idx].yres;
+	xgi_video_info.org_x = xgi_video_info.org_y = 0;
+	xgi_video_info.video_linelength =
+		xgi_video_info.video_width *
+		(xgi_video_info.video_bpp >> 3);
+	switch (xgi_video_info.video_bpp) {
+	case 8:
+		xgi_video_info.DstColor = 0x0000;
+		xgi_video_info.XGI310_AccelDepth = 0x00000000;
+		xgi_video_info.video_cmap_len = 256;
+		break;
+	case 16:
+		xgi_video_info.DstColor = 0x8000;
+		xgi_video_info.XGI310_AccelDepth = 0x00010000;
+		xgi_video_info.video_cmap_len = 16;
+		break;
+	case 32:
+		xgi_video_info.DstColor = 0xC000;
+		xgi_video_info.XGI310_AccelDepth = 0x00020000;
+		xgi_video_info.video_cmap_len = 16;
+		break;
+	default:
+		xgi_video_info.video_cmap_len = 16;
+		printk(KERN_INFO "XGIfb: Unsupported depth %d",
+		       xgi_video_info.video_bpp);
+		break;
+	}
+
+	printk(KERN_INFO "XGIfb: Default mode is %dx%dx%d (%dHz)\n",
+	       xgi_video_info.video_width,
+	       xgi_video_info.video_height,
+	       xgi_video_info.video_bpp,
+	       xgi_video_info.refresh_rate);
+
+	default_var.xres =
+		default_var.xres_virtual =
+			xgi_video_info.video_width;
+	default_var.yres =
+		default_var.yres_virtual =
+			xgi_video_info.video_height;
+	default_var.bits_per_pixel = xgi_video_info.video_bpp;
+
+	XGIfb_bpp_to_var(&default_var);
+
+	default_var.pixclock = (u32) (1000000000 /
+			XGIfb_mode_rate_to_dclock(&XGI_Pr, &XGIhw_ext,
+					XGIfb_mode_no, XGIfb_rate_idx));
+
+	if (XGIfb_mode_rate_to_ddata(&XGI_Pr, &XGIhw_ext,
+		XGIfb_mode_no, XGIfb_rate_idx,
+		&default_var.left_margin, &default_var.right_margin,
+		&default_var.upper_margin, &default_var.lower_margin,
+		&default_var.hsync_len, &default_var.vsync_len,
+		&default_var.sync, &default_var.vmode)) {
+
+		if ((default_var.vmode & FB_VMODE_MASK) ==
+		    FB_VMODE_INTERLACED) {
+			default_var.yres <<= 1;
+			default_var.yres_virtual <<= 1;
+		} else if ((default_var.vmode & FB_VMODE_MASK) ==
+			   FB_VMODE_DOUBLE) {
+			default_var.pixclock >>= 1;
+			default_var.yres >>= 1;
+			default_var.yres_virtual >>= 1;
 		}
 
-		fb_info->flags = FBINFO_FLAG_DEFAULT;
-		fb_info->var = default_var;
-		fb_info->fix = XGIfb_fix;
-		fb_info->par = &xgi_video_info;
-		fb_info->screen_base = xgi_video_info.video_vbase;
-		fb_info->fbops = &XGIfb_ops;
-		XGIfb_get_fix(&fb_info->fix, -1, fb_info);
-		fb_info->pseudo_palette = pseudo_palette;
+	}
+
+	fb_info->flags = FBINFO_FLAG_DEFAULT;
+	fb_info->var = default_var;
+	fb_info->fix = XGIfb_fix;
+	fb_info->par = &xgi_video_info;
+	fb_info->screen_base = xgi_video_info.video_vbase;
+	fb_info->fbops = &XGIfb_ops;
+	XGIfb_get_fix(&fb_info->fix, -1, fb_info);
+	fb_info->pseudo_palette = pseudo_palette;
 
-		fb_alloc_cmap(&fb_info->cmap, 256 , 0);
+	fb_alloc_cmap(&fb_info->cmap, 256 , 0);
 
 #ifdef CONFIG_MTRR
-		xgi_video_info.mtrr = mtrr_add(
-			(unsigned int) xgi_video_info.video_base,
-			(unsigned int) xgi_video_info.video_size,
-			MTRR_TYPE_WRCOMB, 1);
-		if (xgi_video_info.mtrr)
-			printk(KERN_INFO "XGIfb: Added MTRRs\n");
+	xgi_video_info.mtrr = mtrr_add(
+		(unsigned int) xgi_video_info.video_base,
+		(unsigned int) xgi_video_info.video_size,
+		MTRR_TYPE_WRCOMB, 1);
+	if (xgi_video_info.mtrr)
+		printk(KERN_INFO "XGIfb: Added MTRRs\n");
 #endif
 
-		if (register_framebuffer(fb_info) < 0) {
-			ret = -EINVAL;
-			goto error_1;
-		}
-
-		XGIfb_registered = 1;
+	if (register_framebuffer(fb_info) < 0) {
+		ret = -EINVAL;
+		goto error_1;
+	}
 
-		printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
-		       fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
+	XGIfb_registered = 1;
 
-	}
+	printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
+	       fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
 
 	dumpVGAReg();
 
-- 
1.7.2.5

