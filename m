Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1KUUyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:54:49 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:33908 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1KUUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/8] fbdev/amifb: Reorder functions to remove forward declarations
Date: Mon, 21 Nov 2011 21:53:54 +0100
Message-Id: <1321908839-11419-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
References: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c | 2767 ++++++++++++++++++++++++-------------------------
 1 files changed, 1356 insertions(+), 1411 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 39d211a..d7961bd 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -1118,82 +1118,1213 @@ static u_short sprfetchmode[3] = {
 };
 
 
+/* --------------------------- Hardware routines --------------------------- */
+
 	/*
-	 * Interface used by the world
+	 * Get the video params out of `var'. If a value doesn't fit, round
+	 * it up, if it's too big, return -EINVAL.
 	 */
 
-int amifb_setup(char*);
+static int ami_decode_var(struct fb_var_screeninfo *var,
+			  struct amifb_par *par)
+{
+	u_short clk_shift, line_shift;
+	u_long maxfetchstop, fstrt, fsize, fconst, xres_n, yres_n;
+	u_int htotal, vtotal;
 
-static int amifb_check_var(struct fb_var_screeninfo *var,
-			   struct fb_info *info);
-static int amifb_set_par(struct fb_info *info);
-static int amifb_setcolreg(unsigned regno, unsigned red, unsigned green,
-			   unsigned blue, unsigned transp,
-			   struct fb_info *info);
-static int amifb_blank(int blank, struct fb_info *info);
-static int amifb_pan_display(struct fb_var_screeninfo *var,
-			     struct fb_info *info);
-static void amifb_fillrect(struct fb_info *info,
-			   const struct fb_fillrect *rect);
-static void amifb_copyarea(struct fb_info *info,
-			   const struct fb_copyarea *region);
-static void amifb_imageblit(struct fb_info *info,
-			    const struct fb_image *image);
-static int amifb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg);
+	/*
+	 * Find a matching Pixel Clock
+	 */
 
+	for (clk_shift = TAG_SHRES; clk_shift <= TAG_LORES; clk_shift++)
+		if (var->pixclock <= pixclock[clk_shift])
+			break;
+	if (clk_shift > TAG_LORES) {
+		DPRINTK("pixclock too high\n");
+		return -EINVAL;
+	}
+	par->clk_shift = clk_shift;
 
 	/*
-	 * Interface to the low level console driver
+	 * Check the Geometry Values
 	 */
 
-static void amifb_deinit(struct platform_device *pdev);
+	if ((par->xres = var->xres) < 64)
+		par->xres = 64;
+	if ((par->yres = var->yres) < 64)
+		par->yres = 64;
+	if ((par->vxres = var->xres_virtual) < par->xres)
+		par->vxres = par->xres;
+	if ((par->vyres = var->yres_virtual) < par->yres)
+		par->vyres = par->yres;
+
+	par->bpp = var->bits_per_pixel;
+	if (!var->nonstd) {
+		if (par->bpp < 1)
+			par->bpp = 1;
+		if (par->bpp > maxdepth[clk_shift]) {
+			if (round_down_bpp && maxdepth[clk_shift])
+				par->bpp = maxdepth[clk_shift];
+			else {
+				DPRINTK("invalid bpp\n");
+				return -EINVAL;
+			}
+		}
+	} else if (var->nonstd == FB_NONSTD_HAM) {
+		if (par->bpp < 6)
+			par->bpp = 6;
+		if (par->bpp != 6) {
+			if (par->bpp < 8)
+				par->bpp = 8;
+			if (par->bpp != 8 || !IS_AGA) {
+				DPRINTK("invalid bpp for ham mode\n");
+				return -EINVAL;
+			}
+		}
+	} else {
+		DPRINTK("unknown nonstd mode\n");
+		return -EINVAL;
+	}
 
 	/*
-	 * Internal routines
+	 * FB_VMODE_SMOOTH_XPAN will be cleared, if one of the folloing
+	 * checks failed and smooth scrolling is not possible
 	 */
 
-static int flash_cursor(void);
-static irqreturn_t amifb_interrupt(int irq, void *dev_id);
-static u_long chipalloc(u_long size);
-static void chipfree(void);
+	par->vmode = var->vmode | FB_VMODE_SMOOTH_XPAN;
+	switch (par->vmode & FB_VMODE_MASK) {
+	case FB_VMODE_INTERLACED:
+		line_shift = 0;
+		break;
+	case FB_VMODE_NONINTERLACED:
+		line_shift = 1;
+		break;
+	case FB_VMODE_DOUBLE:
+		if (!IS_AGA) {
+			DPRINTK("double mode only possible with aga\n");
+			return -EINVAL;
+		}
+		line_shift = 2;
+		break;
+	default:
+		DPRINTK("unknown video mode\n");
+		return -EINVAL;
+		break;
+	}
+	par->line_shift = line_shift;
 
 	/*
-	 * Hardware routines
+	 * Vertical and Horizontal Timings
+	 */
+
+	xres_n = par->xres << clk_shift;
+	yres_n = par->yres << line_shift;
+	par->htotal = down8((var->left_margin + par->xres + var->right_margin +
+			     var->hsync_len) << clk_shift);
+	par->vtotal =
+		down2(((var->upper_margin + par->yres + var->lower_margin +
+			var->vsync_len) << line_shift) + 1);
+
+	if (IS_AGA)
+		par->bplcon3 = sprpixmode[clk_shift];
+	else
+		par->bplcon3 = 0;
+	if (var->sync & FB_SYNC_BROADCAST) {
+		par->diwstop_h = par->htotal -
+			((var->right_margin - var->hsync_len) << clk_shift);
+		if (IS_AGA)
+			par->diwstop_h += mod4(var->hsync_len);
+		else
+			par->diwstop_h = down4(par->diwstop_h);
+
+		par->diwstrt_h = par->diwstop_h - xres_n;
+		par->diwstop_v = par->vtotal -
+			((var->lower_margin - var->vsync_len) << line_shift);
+		par->diwstrt_v = par->diwstop_v - yres_n;
+		if (par->diwstop_h >= par->htotal + 8) {
+			DPRINTK("invalid diwstop_h\n");
+			return -EINVAL;
+		}
+		if (par->diwstop_v > par->vtotal) {
+			DPRINTK("invalid diwstop_v\n");
+			return -EINVAL;
+		}
+
+		if (!IS_OCS) {
+			/* Initialize sync with some reasonable values for pwrsave */
+			par->hsstrt = 160;
+			par->hsstop = 320;
+			par->vsstrt = 30;
+			par->vsstop = 34;
+		} else {
+			par->hsstrt = 0;
+			par->hsstop = 0;
+			par->vsstrt = 0;
+			par->vsstop = 0;
+		}
+		if (par->vtotal > (PAL_VTOTAL + NTSC_VTOTAL) / 2) {
+			/* PAL video mode */
+			if (par->htotal != PAL_HTOTAL) {
+				DPRINTK("htotal invalid for pal\n");
+				return -EINVAL;
+			}
+			if (par->diwstrt_h < PAL_DIWSTRT_H) {
+				DPRINTK("diwstrt_h too low for pal\n");
+				return -EINVAL;
+			}
+			if (par->diwstrt_v < PAL_DIWSTRT_V) {
+				DPRINTK("diwstrt_v too low for pal\n");
+				return -EINVAL;
+			}
+			htotal = PAL_HTOTAL>>clk_shift;
+			vtotal = PAL_VTOTAL>>1;
+			if (!IS_OCS) {
+				par->beamcon0 = BMC0_PAL;
+				par->bplcon3 |= BPC3_BRDRBLNK;
+			} else if (AMIGAHW_PRESENT(AGNUS_HR_PAL) ||
+				   AMIGAHW_PRESENT(AGNUS_HR_NTSC)) {
+				par->beamcon0 = BMC0_PAL;
+				par->hsstop = 1;
+			} else if (amiga_vblank != 50) {
+				DPRINTK("pal not supported by this chipset\n");
+				return -EINVAL;
+			}
+		} else {
+			/* NTSC video mode
+			 * In the AGA chipset seems to be hardware bug with BPC3_BRDRBLNK
+			 * and NTSC activated, so than better let diwstop_h <= 1812
+			 */
+			if (par->htotal != NTSC_HTOTAL) {
+				DPRINTK("htotal invalid for ntsc\n");
+				return -EINVAL;
+			}
+			if (par->diwstrt_h < NTSC_DIWSTRT_H) {
+				DPRINTK("diwstrt_h too low for ntsc\n");
+				return -EINVAL;
+			}
+			if (par->diwstrt_v < NTSC_DIWSTRT_V) {
+				DPRINTK("diwstrt_v too low for ntsc\n");
+				return -EINVAL;
+			}
+			htotal = NTSC_HTOTAL>>clk_shift;
+			vtotal = NTSC_VTOTAL>>1;
+			if (!IS_OCS) {
+				par->beamcon0 = 0;
+				par->bplcon3 |= BPC3_BRDRBLNK;
+			} else if (AMIGAHW_PRESENT(AGNUS_HR_PAL) ||
+				   AMIGAHW_PRESENT(AGNUS_HR_NTSC)) {
+				par->beamcon0 = 0;
+				par->hsstop = 1;
+			} else if (amiga_vblank != 60) {
+				DPRINTK("ntsc not supported by this chipset\n");
+				return -EINVAL;
+			}
+		}
+		if (IS_OCS) {
+			if (par->diwstrt_h >= 1024 || par->diwstop_h < 1024 ||
+			    par->diwstrt_v >=  512 || par->diwstop_v <  256) {
+				DPRINTK("invalid position for display on ocs\n");
+				return -EINVAL;
+			}
+		}
+	} else if (!IS_OCS) {
+		/* Programmable video mode */
+		par->hsstrt = var->right_margin << clk_shift;
+		par->hsstop = (var->right_margin + var->hsync_len) << clk_shift;
+		par->diwstop_h = par->htotal - mod8(par->hsstrt) + 8 - (1 << clk_shift);
+		if (!IS_AGA)
+			par->diwstop_h = down4(par->diwstop_h) - 16;
+		par->diwstrt_h = par->diwstop_h - xres_n;
+		par->hbstop = par->diwstrt_h + 4;
+		par->hbstrt = par->diwstop_h + 4;
+		if (par->hbstrt >= par->htotal + 8)
+			par->hbstrt -= par->htotal;
+		par->hcenter = par->hsstrt + (par->htotal >> 1);
+		par->vsstrt = var->lower_margin << line_shift;
+		par->vsstop = (var->lower_margin + var->vsync_len) << line_shift;
+		par->diwstop_v = par->vtotal;
+		if ((par->vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED)
+			par->diwstop_v -= 2;
+		par->diwstrt_v = par->diwstop_v - yres_n;
+		par->vbstop = par->diwstrt_v - 2;
+		par->vbstrt = par->diwstop_v - 2;
+		if (par->vtotal > 2048) {
+			DPRINTK("vtotal too high\n");
+			return -EINVAL;
+		}
+		if (par->htotal > 2048) {
+			DPRINTK("htotal too high\n");
+			return -EINVAL;
+		}
+		par->bplcon3 |= BPC3_EXTBLKEN;
+		par->beamcon0 = BMC0_HARDDIS | BMC0_VARVBEN | BMC0_LOLDIS |
+				BMC0_VARVSYEN | BMC0_VARHSYEN | BMC0_VARBEAMEN |
+				BMC0_PAL | BMC0_VARCSYEN;
+		if (var->sync & FB_SYNC_HOR_HIGH_ACT)
+			par->beamcon0 |= BMC0_HSYTRUE;
+		if (var->sync & FB_SYNC_VERT_HIGH_ACT)
+			par->beamcon0 |= BMC0_VSYTRUE;
+		if (var->sync & FB_SYNC_COMP_HIGH_ACT)
+			par->beamcon0 |= BMC0_CSYTRUE;
+		htotal = par->htotal>>clk_shift;
+		vtotal = par->vtotal>>1;
+	} else {
+		DPRINTK("only broadcast modes possible for ocs\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Checking the DMA timing
+	 */
+
+	fconst = 16 << maxfmode << clk_shift;
+
+	/*
+	 * smallest window start value without turn off other dma cycles
+	 * than sprite1-7, unless you change min_fstrt
+	 */
+
+
+	fsize = ((maxfmode + clk_shift <= 1) ? fconst : 64);
+	fstrt = downx(fconst, par->diwstrt_h - 4) - fsize;
+	if (fstrt < min_fstrt) {
+		DPRINTK("fetch start too low\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * smallest window start value where smooth scrolling is possible
+	 */
+
+	fstrt = downx(fconst, par->diwstrt_h - fconst + (1 << clk_shift) - 4) -
+		fsize;
+	if (fstrt < min_fstrt)
+		par->vmode &= ~FB_VMODE_SMOOTH_XPAN;
+
+	maxfetchstop = down16(par->htotal - 80);
+
+	fstrt = downx(fconst, par->diwstrt_h - 4) - 64 - fconst;
+	fsize = upx(fconst, xres_n +
+		    modx(fconst, downx(1 << clk_shift, par->diwstrt_h - 4)));
+	if (fstrt + fsize > maxfetchstop)
+		par->vmode &= ~FB_VMODE_SMOOTH_XPAN;
+
+	fsize = upx(fconst, xres_n);
+	if (fstrt + fsize > maxfetchstop) {
+		DPRINTK("fetch stop too high\n");
+		return -EINVAL;
+	}
+
+	if (maxfmode + clk_shift <= 1) {
+		fsize = up64(xres_n + fconst - 1);
+		if (min_fstrt + fsize - 64 > maxfetchstop)
+			par->vmode &= ~FB_VMODE_SMOOTH_XPAN;
+
+		fsize = up64(xres_n);
+		if (min_fstrt + fsize - 64 > maxfetchstop) {
+			DPRINTK("fetch size too high\n");
+			return -EINVAL;
+		}
+
+		fsize -= 64;
+	} else
+		fsize -= fconst;
+
+	/*
+	 * Check if there is enough time to update the bitplane pointers for ywrap
+	 */
+
+	if (par->htotal - fsize - 64 < par->bpp * 64)
+		par->vmode &= ~FB_VMODE_YWRAP;
+
+	/*
+	 * Bitplane calculations and check the Memory Requirements
+	 */
+
+	if (amifb_ilbm) {
+		par->next_plane = div8(upx(16 << maxfmode, par->vxres));
+		par->next_line = par->bpp * par->next_plane;
+		if (par->next_line * par->vyres > fb_info.fix.smem_len) {
+			DPRINTK("too few video mem\n");
+			return -EINVAL;
+		}
+	} else {
+		par->next_line = div8(upx(16 << maxfmode, par->vxres));
+		par->next_plane = par->vyres * par->next_line;
+		if (par->next_plane * par->bpp > fb_info.fix.smem_len) {
+			DPRINTK("too few video mem\n");
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Hardware Register Values
+	 */
+
+	par->bplcon0 = BPC0_COLOR | bplpixmode[clk_shift];
+	if (!IS_OCS)
+		par->bplcon0 |= BPC0_ECSENA;
+	if (par->bpp == 8)
+		par->bplcon0 |= BPC0_BPU3;
+	else
+		par->bplcon0 |= par->bpp << 12;
+	if (var->nonstd == FB_NONSTD_HAM)
+		par->bplcon0 |= BPC0_HAM;
+	if (var->sync & FB_SYNC_EXT)
+		par->bplcon0 |= BPC0_ERSY;
+
+	if (IS_AGA)
+		par->fmode = bplfetchmode[maxfmode];
+
+	switch (par->vmode & FB_VMODE_MASK) {
+	case FB_VMODE_INTERLACED:
+		par->bplcon0 |= BPC0_LACE;
+		break;
+	case FB_VMODE_DOUBLE:
+		if (IS_AGA)
+			par->fmode |= FMODE_SSCAN2 | FMODE_BSCAN2;
+		break;
+	}
+
+	if (!((par->vmode ^ var->vmode) & FB_VMODE_YWRAP)) {
+		par->xoffset = var->xoffset;
+		par->yoffset = var->yoffset;
+		if (par->vmode & FB_VMODE_YWRAP) {
+			if (par->xoffset || par->yoffset < 0 ||
+			    par->yoffset >= par->vyres)
+				par->xoffset = par->yoffset = 0;
+		} else {
+			if (par->xoffset < 0 ||
+			    par->xoffset > upx(16 << maxfmode, par->vxres - par->xres) ||
+			    par->yoffset < 0 || par->yoffset > par->vyres - par->yres)
+				par->xoffset = par->yoffset = 0;
+		}
+	} else
+		par->xoffset = par->yoffset = 0;
+
+	par->crsr.crsr_x = par->crsr.crsr_y = 0;
+	par->crsr.spot_x = par->crsr.spot_y = 0;
+	par->crsr.height = par->crsr.width = 0;
+
+	return 0;
+}
+
+	/*
+	 * Fill the `var' structure based on the values in `par' and maybe
+	 * other values read out of the hardware.
 	 */
 
-static int ami_decode_var(struct fb_var_screeninfo *var,
-			  struct amifb_par *par);
 static int ami_encode_var(struct fb_var_screeninfo *var,
-			  struct amifb_par *par);
-static void ami_pan_var(struct fb_var_screeninfo *var);
-static int ami_update_par(void);
-static void ami_update_display(void);
-static void ami_init_display(void);
-static void ami_do_blank(void);
-static int ami_get_fix_cursorinfo(struct fb_fix_cursorinfo *fix);
-static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data);
-static int ami_set_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data);
-static int ami_get_cursorstate(struct fb_cursorstate *state);
-static int ami_set_cursorstate(struct fb_cursorstate *state);
-static void ami_set_sprite(void);
-static void ami_init_copper(void);
-static void ami_reinit_copper(void);
-static void ami_build_copper(void);
-static void ami_rebuild_copper(void);
+			  struct amifb_par *par)
+{
+	u_short clk_shift, line_shift;
 
+	memset(var, 0, sizeof(struct fb_var_screeninfo));
+
+	clk_shift = par->clk_shift;
+	line_shift = par->line_shift;
+
+	var->xres = par->xres;
+	var->yres = par->yres;
+	var->xres_virtual = par->vxres;
+	var->yres_virtual = par->vyres;
+	var->xoffset = par->xoffset;
+	var->yoffset = par->yoffset;
+
+	var->bits_per_pixel = par->bpp;
+	var->grayscale = 0;
+
+	var->red.offset = 0;
+	var->red.msb_right = 0;
+	var->red.length = par->bpp;
+	if (par->bplcon0 & BPC0_HAM)
+		var->red.length -= 2;
+	var->blue = var->green = var->red;
+	var->transp.offset = 0;
+	var->transp.length = 0;
+	var->transp.msb_right = 0;
+
+	if (par->bplcon0 & BPC0_HAM)
+		var->nonstd = FB_NONSTD_HAM;
+	else
+		var->nonstd = 0;
+	var->activate = 0;
+
+	var->height = -1;
+	var->width = -1;
+
+	var->pixclock = pixclock[clk_shift];
+
+	if (IS_AGA && par->fmode & FMODE_BSCAN2)
+		var->vmode = FB_VMODE_DOUBLE;
+	else if (par->bplcon0 & BPC0_LACE)
+		var->vmode = FB_VMODE_INTERLACED;
+	else
+		var->vmode = FB_VMODE_NONINTERLACED;
+
+	if (!IS_OCS && par->beamcon0 & BMC0_VARBEAMEN) {
+		var->hsync_len = (par->hsstop - par->hsstrt)>>clk_shift;
+		var->right_margin = par->hsstrt>>clk_shift;
+		var->left_margin = (par->htotal>>clk_shift) - var->xres - var->right_margin - var->hsync_len;
+		var->vsync_len = (par->vsstop - par->vsstrt)>>line_shift;
+		var->lower_margin = par->vsstrt>>line_shift;
+		var->upper_margin = (par->vtotal>>line_shift) - var->yres - var->lower_margin - var->vsync_len;
+		var->sync = 0;
+		if (par->beamcon0 & BMC0_HSYTRUE)
+			var->sync |= FB_SYNC_HOR_HIGH_ACT;
+		if (par->beamcon0 & BMC0_VSYTRUE)
+			var->sync |= FB_SYNC_VERT_HIGH_ACT;
+		if (par->beamcon0 & BMC0_CSYTRUE)
+			var->sync |= FB_SYNC_COMP_HIGH_ACT;
+	} else {
+		var->sync = FB_SYNC_BROADCAST;
+		var->hsync_len = (152>>clk_shift) + mod4(par->diwstop_h);
+		var->right_margin = ((par->htotal - down4(par->diwstop_h))>>clk_shift) + var->hsync_len;
+		var->left_margin = (par->htotal>>clk_shift) - var->xres - var->right_margin - var->hsync_len;
+		var->vsync_len = 4>>line_shift;
+		var->lower_margin = ((par->vtotal - par->diwstop_v)>>line_shift) + var->vsync_len;
+		var->upper_margin = (((par->vtotal - 2)>>line_shift) + 1) - var->yres -
+				    var->lower_margin - var->vsync_len;
+	}
+
+	if (par->bplcon0 & BPC0_ERSY)
+		var->sync |= FB_SYNC_EXT;
+	if (par->vmode & FB_VMODE_YWRAP)
+		var->vmode |= FB_VMODE_YWRAP;
+
+	return 0;
+}
+
+
+	/*
+	 * Update hardware
+	 */
+
+static int ami_update_par(void)
+{
+	struct amifb_par *par = &currentpar;
+	short clk_shift, vshift, fstrt, fsize, fstop, fconst,  shift, move, mod;
+
+	clk_shift = par->clk_shift;
+
+	if (!(par->vmode & FB_VMODE_SMOOTH_XPAN))
+		par->xoffset = upx(16 << maxfmode, par->xoffset);
+
+	fconst = 16 << maxfmode << clk_shift;
+	vshift = modx(16 << maxfmode, par->xoffset);
+	fstrt = par->diwstrt_h - (vshift << clk_shift) - 4;
+	fsize = (par->xres + vshift) << clk_shift;
+	shift = modx(fconst, fstrt);
+	move = downx(2 << maxfmode, div8(par->xoffset));
+	if (maxfmode + clk_shift > 1) {
+		fstrt = downx(fconst, fstrt) - 64;
+		fsize = upx(fconst, fsize);
+		fstop = fstrt + fsize - fconst;
+	} else {
+		mod = fstrt = downx(fconst, fstrt) - fconst;
+		fstop = fstrt + upx(fconst, fsize) - 64;
+		fsize = up64(fsize);
+		fstrt = fstop - fsize + 64;
+		if (fstrt < min_fstrt) {
+			fstop += min_fstrt - fstrt;
+			fstrt = min_fstrt;
+		}
+		move = move - div8((mod - fstrt)>>clk_shift);
+	}
+	mod = par->next_line - div8(fsize>>clk_shift);
+	par->ddfstrt = fstrt;
+	par->ddfstop = fstop;
+	par->bplcon1 = hscroll2hw(shift);
+	par->bpl2mod = mod;
+	if (par->bplcon0 & BPC0_LACE)
+		par->bpl2mod += par->next_line;
+	if (IS_AGA && (par->fmode & FMODE_BSCAN2))
+		par->bpl1mod = -div8(fsize>>clk_shift);
+	else
+		par->bpl1mod = par->bpl2mod;
+
+	if (par->yoffset) {
+		par->bplpt0 = fb_info.fix.smem_start +
+			      par->next_line * par->yoffset + move;
+		if (par->vmode & FB_VMODE_YWRAP) {
+			if (par->yoffset > par->vyres - par->yres) {
+				par->bplpt0wrap = fb_info.fix.smem_start + move;
+				if (par->bplcon0 & BPC0_LACE &&
+				    mod2(par->diwstrt_v + par->vyres -
+					 par->yoffset))
+					par->bplpt0wrap += par->next_line;
+			}
+		}
+	} else
+		par->bplpt0 = fb_info.fix.smem_start + move;
+
+	if (par->bplcon0 & BPC0_LACE && mod2(par->diwstrt_v))
+		par->bplpt0 += par->next_line;
+
+	return 0;
+}
+
+
+	/*
+	 * Pan or Wrap the Display
+	 *
+	 * This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
+	 * in `var'.
+	 */
+
+static void ami_pan_var(struct fb_var_screeninfo *var)
+{
+	struct amifb_par *par = &currentpar;
+
+	par->xoffset = var->xoffset;
+	par->yoffset = var->yoffset;
+	if (var->vmode & FB_VMODE_YWRAP)
+		par->vmode |= FB_VMODE_YWRAP;
+	else
+		par->vmode &= ~FB_VMODE_YWRAP;
+
+	do_vmode_pan = 0;
+	ami_update_par();
+	do_vmode_pan = 1;
+}
+
+
+static void ami_update_display(void)
+{
+	struct amifb_par *par = &currentpar;
+
+	custom.bplcon1 = par->bplcon1;
+	custom.bpl1mod = par->bpl1mod;
+	custom.bpl2mod = par->bpl2mod;
+	custom.ddfstrt = ddfstrt2hw(par->ddfstrt);
+	custom.ddfstop = ddfstop2hw(par->ddfstop);
+}
+
+	/*
+	 * Change the video mode (called by VBlank interrupt)
+	 */
+
+static void ami_init_display(void)
+{
+	struct amifb_par *par = &currentpar;
+	int i;
+
+	custom.bplcon0 = par->bplcon0 & ~BPC0_LACE;
+	custom.bplcon2 = (IS_OCS ? 0 : BPC2_KILLEHB) | BPC2_PF2P2 | BPC2_PF1P2;
+	if (!IS_OCS) {
+		custom.bplcon3 = par->bplcon3;
+		if (IS_AGA)
+			custom.bplcon4 = BPC4_ESPRM4 | BPC4_OSPRM4;
+		if (par->beamcon0 & BMC0_VARBEAMEN) {
+			custom.htotal = htotal2hw(par->htotal);
+			custom.hbstrt = hbstrt2hw(par->hbstrt);
+			custom.hbstop = hbstop2hw(par->hbstop);
+			custom.hsstrt = hsstrt2hw(par->hsstrt);
+			custom.hsstop = hsstop2hw(par->hsstop);
+			custom.hcenter = hcenter2hw(par->hcenter);
+			custom.vtotal = vtotal2hw(par->vtotal);
+			custom.vbstrt = vbstrt2hw(par->vbstrt);
+			custom.vbstop = vbstop2hw(par->vbstop);
+			custom.vsstrt = vsstrt2hw(par->vsstrt);
+			custom.vsstop = vsstop2hw(par->vsstop);
+		}
+	}
+	if (!IS_OCS || par->hsstop)
+		custom.beamcon0 = par->beamcon0;
+	if (IS_AGA)
+		custom.fmode = par->fmode;
+
+	/*
+	 * The minimum period for audio depends on htotal
+	 */
+
+	amiga_audio_min_period = div16(par->htotal);
+
+	is_lace = par->bplcon0 & BPC0_LACE ? 1 : 0;
+#if 1
+	if (is_lace) {
+		i = custom.vposr >> 15;
+	} else {
+		custom.vposw = custom.vposr | 0x8000;
+		i = 1;
+	}
+#else
+	i = 1;
+	custom.vposw = custom.vposr | 0x8000;
+#endif
+	custom.cop2lc = (u_short *)ZTWO_PADDR(copdisplay.list[currentcop][i]);
+}
+
+	/*
+	 * (Un)Blank the screen (called by VBlank interrupt)
+	 */
+
+static void ami_do_blank(void)
+{
+	struct amifb_par *par = &currentpar;
+#if defined(CONFIG_FB_AMIGA_AGA)
+	u_short bplcon3 = par->bplcon3;
+#endif
+	u_char red, green, blue;
+
+	if (do_blank > 0) {
+		custom.dmacon = DMAF_RASTER | DMAF_SPRITE;
+		red = green = blue = 0;
+		if (!IS_OCS && do_blank > 1) {
+			switch (do_blank) {
+			case FB_BLANK_VSYNC_SUSPEND:
+				custom.hsstrt = hsstrt2hw(par->hsstrt);
+				custom.hsstop = hsstop2hw(par->hsstop);
+				custom.vsstrt = vsstrt2hw(par->vtotal + 4);
+				custom.vsstop = vsstop2hw(par->vtotal + 4);
+				break;
+			case FB_BLANK_HSYNC_SUSPEND:
+				custom.hsstrt = hsstrt2hw(par->htotal + 16);
+				custom.hsstop = hsstop2hw(par->htotal + 16);
+				custom.vsstrt = vsstrt2hw(par->vsstrt);
+				custom.vsstop = vsstrt2hw(par->vsstop);
+				break;
+			case FB_BLANK_POWERDOWN:
+				custom.hsstrt = hsstrt2hw(par->htotal + 16);
+				custom.hsstop = hsstop2hw(par->htotal + 16);
+				custom.vsstrt = vsstrt2hw(par->vtotal + 4);
+				custom.vsstop = vsstop2hw(par->vtotal + 4);
+				break;
+			}
+			if (!(par->beamcon0 & BMC0_VARBEAMEN)) {
+				custom.htotal = htotal2hw(par->htotal);
+				custom.vtotal = vtotal2hw(par->vtotal);
+				custom.beamcon0 = BMC0_HARDDIS | BMC0_VARBEAMEN |
+						  BMC0_VARVSYEN | BMC0_VARHSYEN | BMC0_VARCSYEN;
+			}
+		}
+	} else {
+		custom.dmacon = DMAF_SETCLR | DMAF_RASTER | DMAF_SPRITE;
+		red = red0;
+		green = green0;
+		blue = blue0;
+		if (!IS_OCS) {
+			custom.hsstrt = hsstrt2hw(par->hsstrt);
+			custom.hsstop = hsstop2hw(par->hsstop);
+			custom.vsstrt = vsstrt2hw(par->vsstrt);
+			custom.vsstop = vsstop2hw(par->vsstop);
+			custom.beamcon0 = par->beamcon0;
+		}
+	}
+#if defined(CONFIG_FB_AMIGA_AGA)
+	if (IS_AGA) {
+		custom.bplcon3 = bplcon3;
+		custom.color[0] = rgb2hw8_high(red, green, blue);
+		custom.bplcon3 = bplcon3 | BPC3_LOCT;
+		custom.color[0] = rgb2hw8_low(red, green, blue);
+		custom.bplcon3 = bplcon3;
+	} else
+#endif
+#if defined(CONFIG_FB_AMIGA_ECS)
+	if (par->bplcon0 & BPC0_SHRES) {
+		u_short color, mask;
+		int i;
+
+		mask = 0x3333;
+		color = rgb2hw2(red, green, blue);
+		for (i = 12; i >= 0; i -= 4)
+			custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
+		mask <<= 2; color >>= 2;
+		for (i = 3; i >= 0; i--)
+			custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
+	} else
+#endif
+		custom.color[0] = rgb2hw4(red, green, blue);
+	is_blanked = do_blank > 0 ? do_blank : 0;
+}
+
+static int ami_get_fix_cursorinfo(struct fb_fix_cursorinfo *fix)
+{
+	struct amifb_par *par = &currentpar;
+
+	fix->crsr_width = fix->crsr_xsize = par->crsr.width;
+	fix->crsr_height = fix->crsr_ysize = par->crsr.height;
+	fix->crsr_color1 = 17;
+	fix->crsr_color2 = 18;
+	return 0;
+}
+
+static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data)
+{
+	struct amifb_par *par = &currentpar;
+	register u_short *lspr, *sspr;
+#ifdef __mc68000__
+	register u_long datawords asm ("d2");
+#else
+	register u_long datawords;
+#endif
+	register short delta;
+	register u_char color;
+	short height, width, bits, words;
+	int size, alloc;
+
+	size = par->crsr.height * par->crsr.width;
+	alloc = var->height * var->width;
+	var->height = par->crsr.height;
+	var->width = par->crsr.width;
+	var->xspot = par->crsr.spot_x;
+	var->yspot = par->crsr.spot_y;
+	if (size > var->height * var->width)
+		return -ENAMETOOLONG;
+	if (!access_ok(VERIFY_WRITE, data, size))
+		return -EFAULT;
+	delta = 1 << par->crsr.fmode;
+	lspr = lofsprite + (delta << 1);
+	if (par->bplcon0 & BPC0_LACE)
+		sspr = shfsprite + (delta << 1);
+	else
+		sspr = NULL;
+	for (height = (short)var->height - 1; height >= 0; height--) {
+		bits = 0; words = delta; datawords = 0;
+		for (width = (short)var->width - 1; width >= 0; width--) {
+			if (bits == 0) {
+				bits = 16; --words;
+#ifdef __mc68000__
+				asm volatile ("movew %1@(%3:w:2),%0 ; swap %0 ; movew %1@+,%0"
+					: "=d" (datawords), "=a" (lspr) : "1" (lspr), "d" (delta));
+#else
+				datawords = (*(lspr + delta) << 16) | (*lspr++);
+#endif
+			}
+			--bits;
+#ifdef __mc68000__
+			asm volatile (
+				"clrb %0 ; swap %1 ; lslw #1,%1 ; roxlb #1,%0 ; "
+				"swap %1 ; lslw #1,%1 ; roxlb #1,%0"
+				: "=d" (color), "=d" (datawords) : "1" (datawords));
+#else
+			color = (((datawords >> 30) & 2)
+				 | ((datawords >> 15) & 1));
+			datawords <<= 1;
+#endif
+			put_user(color, data++);
+		}
+		if (bits > 0) {
+			--words; ++lspr;
+		}
+		while (--words >= 0)
+			++lspr;
+#ifdef __mc68000__
+		asm volatile ("lea %0@(%4:w:2),%0 ; tstl %1 ; jeq 1f ; exg %0,%1\n1:"
+			: "=a" (lspr), "=a" (sspr) : "0" (lspr), "1" (sspr), "d" (delta));
+#else
+		lspr += delta;
+		if (sspr) {
+			u_short *tmp = lspr;
+			lspr = sspr;
+			sspr = tmp;
+		}
+#endif
+	}
+	return 0;
+}
+
+static int ami_set_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data)
+{
+	struct amifb_par *par = &currentpar;
+	register u_short *lspr, *sspr;
+#ifdef __mc68000__
+	register u_long datawords asm ("d2");
+#else
+	register u_long datawords;
+#endif
+	register short delta;
+	u_short fmode;
+	short height, width, bits, words;
+
+	if (!var->width)
+		return -EINVAL;
+	else if (var->width <= 16)
+		fmode = TAG_FMODE_1;
+	else if (var->width <= 32)
+		fmode = TAG_FMODE_2;
+	else if (var->width <= 64)
+		fmode = TAG_FMODE_4;
+	else
+		return -EINVAL;
+	if (fmode > maxfmode)
+		return -EINVAL;
+	if (!var->height)
+		return -EINVAL;
+	if (!access_ok(VERIFY_READ, data, var->width * var->height))
+		return -EFAULT;
+	delta = 1 << fmode;
+	lofsprite = shfsprite = (u_short *)spritememory;
+	lspr = lofsprite + (delta << 1);
+	if (par->bplcon0 & BPC0_LACE) {
+		if (((var->height + 4) << fmode << 2) > SPRITEMEMSIZE)
+			return -EINVAL;
+		memset(lspr, 0, (var->height + 4) << fmode << 2);
+		shfsprite += ((var->height + 5)&-2) << fmode;
+		sspr = shfsprite + (delta << 1);
+	} else {
+		if (((var->height + 2) << fmode << 2) > SPRITEMEMSIZE)
+			return -EINVAL;
+		memset(lspr, 0, (var->height + 2) << fmode << 2);
+		sspr = NULL;
+	}
+	for (height = (short)var->height - 1; height >= 0; height--) {
+		bits = 16; words = delta; datawords = 0;
+		for (width = (short)var->width - 1; width >= 0; width--) {
+			unsigned long tdata = 0;
+			get_user(tdata, data);
+			data++;
+#ifdef __mc68000__
+			asm volatile (
+				"lsrb #1,%2 ; roxlw #1,%0 ; swap %0 ; "
+				"lsrb #1,%2 ; roxlw #1,%0 ; swap %0"
+				: "=d" (datawords)
+				: "0" (datawords), "d" (tdata));
+#else
+			datawords = ((datawords << 1) & 0xfffefffe);
+			datawords |= tdata & 1;
+			datawords |= (tdata & 2) << (16 - 1);
+#endif
+			if (--bits == 0) {
+				bits = 16; --words;
+#ifdef __mc68000__
+				asm volatile ("swap %2 ; movew %2,%0@(%3:w:2) ; swap %2 ; movew %2,%0@+"
+					: "=a" (lspr) : "0" (lspr), "d" (datawords), "d" (delta));
+#else
+				*(lspr + delta) = (u_short) (datawords >> 16);
+				*lspr++ = (u_short) (datawords & 0xffff);
+#endif
+			}
+		}
+		if (bits < 16) {
+			--words;
+#ifdef __mc68000__
+			asm volatile (
+				"swap %2 ; lslw %4,%2 ; movew %2,%0@(%3:w:2) ; "
+				"swap %2 ; lslw %4,%2 ; movew %2,%0@+"
+				: "=a" (lspr) : "0" (lspr), "d" (datawords), "d" (delta), "d" (bits));
+#else
+			*(lspr + delta) = (u_short) (datawords >> (16 + bits));
+			*lspr++ = (u_short) ((datawords & 0x0000ffff) >> bits);
+#endif
+		}
+		while (--words >= 0) {
+#ifdef __mc68000__
+			asm volatile ("moveql #0,%%d0 ; movew %%d0,%0@(%2:w:2) ; movew %%d0,%0@+"
+				: "=a" (lspr) : "0" (lspr), "d" (delta) : "d0");
+#else
+			*(lspr + delta) = 0;
+			*lspr++ = 0;
+#endif
+		}
+#ifdef __mc68000__
+		asm volatile ("lea %0@(%4:w:2),%0 ; tstl %1 ; jeq 1f ; exg %0,%1\n1:"
+			: "=a" (lspr), "=a" (sspr) : "0" (lspr), "1" (sspr), "d" (delta));
+#else
+		lspr += delta;
+		if (sspr) {
+			u_short *tmp = lspr;
+			lspr = sspr;
+			sspr = tmp;
+		}
+#endif
+	}
+	par->crsr.height = var->height;
+	par->crsr.width = var->width;
+	par->crsr.spot_x = var->xspot;
+	par->crsr.spot_y = var->yspot;
+	par->crsr.fmode = fmode;
+	if (IS_AGA) {
+		par->fmode &= ~(FMODE_SPAGEM | FMODE_SPR32);
+		par->fmode |= sprfetchmode[fmode];
+		custom.fmode = par->fmode;
+	}
+	return 0;
+}
+
+static int ami_get_cursorstate(struct fb_cursorstate *state)
+{
+	struct amifb_par *par = &currentpar;
+
+	state->xoffset = par->crsr.crsr_x;
+	state->yoffset = par->crsr.crsr_y;
+	state->mode = cursormode;
+	return 0;
+}
+
+static int ami_set_cursorstate(struct fb_cursorstate *state)
+{
+	struct amifb_par *par = &currentpar;
+
+	par->crsr.crsr_x = state->xoffset;
+	par->crsr.crsr_y = state->yoffset;
+	if ((cursormode = state->mode) == FB_CURSOR_OFF)
+		cursorstate = -1;
+	do_cursor = 1;
+	return 0;
+}
+
+static void ami_set_sprite(void)
+{
+	struct amifb_par *par = &currentpar;
+	copins *copl, *cops;
+	u_short hs, vs, ve;
+	u_long pl, ps, pt;
+	short mx, my;
+
+	cops = copdisplay.list[currentcop][0];
+	copl = copdisplay.list[currentcop][1];
+	ps = pl = ZTWO_PADDR(dummysprite);
+	mx = par->crsr.crsr_x - par->crsr.spot_x;
+	my = par->crsr.crsr_y - par->crsr.spot_y;
+	if (!(par->vmode & FB_VMODE_YWRAP)) {
+		mx -= par->xoffset;
+		my -= par->yoffset;
+	}
+	if (!is_blanked && cursorstate > 0 && par->crsr.height > 0 &&
+	    mx > -(short)par->crsr.width && mx < par->xres &&
+	    my > -(short)par->crsr.height && my < par->yres) {
+		pl = ZTWO_PADDR(lofsprite);
+		hs = par->diwstrt_h + (mx << par->clk_shift) - 4;
+		vs = par->diwstrt_v + (my << par->line_shift);
+		ve = vs + (par->crsr.height << par->line_shift);
+		if (par->bplcon0 & BPC0_LACE) {
+			ps = ZTWO_PADDR(shfsprite);
+			lofsprite[0] = spr2hw_pos(vs, hs);
+			shfsprite[0] = spr2hw_pos(vs + 1, hs);
+			if (mod2(vs)) {
+				lofsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs, hs, ve);
+				shfsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs + 1, hs, ve + 1);
+				pt = pl; pl = ps; ps = pt;
+			} else {
+				lofsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs, hs, ve + 1);
+				shfsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs + 1, hs, ve);
+			}
+		} else {
+			lofsprite[0] = spr2hw_pos(vs, hs) | (IS_AGA && (par->fmode & FMODE_BSCAN2) ? 0x80 : 0);
+			lofsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs, hs, ve);
+		}
+	}
+	copl[cop_spr0ptrh].w[1] = highw(pl);
+	copl[cop_spr0ptrl].w[1] = loww(pl);
+	if (par->bplcon0 & BPC0_LACE) {
+		cops[cop_spr0ptrh].w[1] = highw(ps);
+		cops[cop_spr0ptrl].w[1] = loww(ps);
+	}
+}
+
+
+	/*
+	 * Initialise the Copper Initialisation List
+	 */
+
+static void __init ami_init_copper(void)
+{
+	copins *cop = copdisplay.init;
+	u_long p;
+	int i;
+
+	if (!IS_OCS) {
+		(cop++)->l = CMOVE(BPC0_COLOR | BPC0_SHRES | BPC0_ECSENA, bplcon0);
+		(cop++)->l = CMOVE(0x0181, diwstrt);
+		(cop++)->l = CMOVE(0x0281, diwstop);
+		(cop++)->l = CMOVE(0x0000, diwhigh);
+	} else
+		(cop++)->l = CMOVE(BPC0_COLOR, bplcon0);
+	p = ZTWO_PADDR(dummysprite);
+	for (i = 0; i < 8; i++) {
+		(cop++)->l = CMOVE(0, spr[i].pos);
+		(cop++)->l = CMOVE(highw(p), sprpt[i]);
+		(cop++)->l = CMOVE2(loww(p), sprpt[i]);
+	}
+
+	(cop++)->l = CMOVE(IF_SETCLR | IF_COPER, intreq);
+	copdisplay.wait = cop;
+	(cop++)->l = CEND;
+	(cop++)->l = CMOVE(0, copjmp2);
+	cop->l = CEND;
+
+	custom.cop1lc = (u_short *)ZTWO_PADDR(copdisplay.init);
+	custom.copjmp1 = 0;
+}
+
+static void ami_reinit_copper(void)
+{
+	struct amifb_par *par = &currentpar;
+
+	copdisplay.init[cip_bplcon0].w[1] = ~(BPC0_BPU3 | BPC0_BPU2 | BPC0_BPU1 | BPC0_BPU0) & par->bplcon0;
+	copdisplay.wait->l = CWAIT(32, par->diwstrt_v - 4);
+}
+
+
+	/*
+	 * Rebuild the Copper List
+	 *
+	 * We only change the things that are not static
+	 */
+
+static void ami_rebuild_copper(void)
+{
+	struct amifb_par *par = &currentpar;
+	copins *copl, *cops;
+	u_short line, h_end1, h_end2;
+	short i;
+	u_long p;
+
+	if (IS_AGA && maxfmode + par->clk_shift == 0)
+		h_end1 = par->diwstrt_h - 64;
+	else
+		h_end1 = par->htotal - 32;
+	h_end2 = par->ddfstop + 64;
+
+	ami_set_sprite();
+
+	copl = copdisplay.rebuild[1];
+	p = par->bplpt0;
+	if (par->vmode & FB_VMODE_YWRAP) {
+		if ((par->vyres - par->yoffset) != 1 || !mod2(par->diwstrt_v)) {
+			if (par->yoffset > par->vyres - par->yres) {
+				for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
+					(copl++)->l = CMOVE(highw(p), bplpt[i]);
+					(copl++)->l = CMOVE2(loww(p), bplpt[i]);
+				}
+				line = par->diwstrt_v + ((par->vyres - par->yoffset) << par->line_shift) - 1;
+				while (line >= 512) {
+					(copl++)->l = CWAIT(h_end1, 510);
+					line -= 512;
+				}
+				if (line >= 510 && IS_AGA && maxfmode + par->clk_shift == 0)
+					(copl++)->l = CWAIT(h_end1, line);
+				else
+					(copl++)->l = CWAIT(h_end2, line);
+				p = par->bplpt0wrap;
+			}
+		} else
+			p = par->bplpt0wrap;
+	}
+	for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
+		(copl++)->l = CMOVE(highw(p), bplpt[i]);
+		(copl++)->l = CMOVE2(loww(p), bplpt[i]);
+	}
+	copl->l = CEND;
+
+	if (par->bplcon0 & BPC0_LACE) {
+		cops = copdisplay.rebuild[0];
+		p = par->bplpt0;
+		if (mod2(par->diwstrt_v))
+			p -= par->next_line;
+		else
+			p += par->next_line;
+		if (par->vmode & FB_VMODE_YWRAP) {
+			if ((par->vyres - par->yoffset) != 1 || mod2(par->diwstrt_v)) {
+				if (par->yoffset > par->vyres - par->yres + 1) {
+					for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
+						(cops++)->l = CMOVE(highw(p), bplpt[i]);
+						(cops++)->l = CMOVE2(loww(p), bplpt[i]);
+					}
+					line = par->diwstrt_v + ((par->vyres - par->yoffset) << par->line_shift) - 2;
+					while (line >= 512) {
+						(cops++)->l = CWAIT(h_end1, 510);
+						line -= 512;
+					}
+					if (line > 510 && IS_AGA && maxfmode + par->clk_shift == 0)
+						(cops++)->l = CWAIT(h_end1, line);
+					else
+						(cops++)->l = CWAIT(h_end2, line);
+					p = par->bplpt0wrap;
+					if (mod2(par->diwstrt_v + par->vyres -
+					    par->yoffset))
+						p -= par->next_line;
+					else
+						p += par->next_line;
+				}
+			} else
+				p = par->bplpt0wrap - par->next_line;
+		}
+		for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
+			(cops++)->l = CMOVE(highw(p), bplpt[i]);
+			(cops++)->l = CMOVE2(loww(p), bplpt[i]);
+		}
+		cops->l = CEND;
+	}
+}
+
+
+	/*
+	 * Build the Copper List
+	 */
+
+static void ami_build_copper(void)
+{
+	struct amifb_par *par = &currentpar;
+	copins *copl, *cops;
+	u_long p;
+
+	currentcop = 1 - currentcop;
+
+	copl = copdisplay.list[currentcop][1];
+
+	(copl++)->l = CWAIT(0, 10);
+	(copl++)->l = CMOVE(par->bplcon0, bplcon0);
+	(copl++)->l = CMOVE(0, sprpt[0]);
+	(copl++)->l = CMOVE2(0, sprpt[0]);
+
+	if (par->bplcon0 & BPC0_LACE) {
+		cops = copdisplay.list[currentcop][0];
+
+		(cops++)->l = CWAIT(0, 10);
+		(cops++)->l = CMOVE(par->bplcon0, bplcon0);
+		(cops++)->l = CMOVE(0, sprpt[0]);
+		(cops++)->l = CMOVE2(0, sprpt[0]);
+
+		(copl++)->l = CMOVE(diwstrt2hw(par->diwstrt_h, par->diwstrt_v + 1), diwstrt);
+		(copl++)->l = CMOVE(diwstop2hw(par->diwstop_h, par->diwstop_v + 1), diwstop);
+		(cops++)->l = CMOVE(diwstrt2hw(par->diwstrt_h, par->diwstrt_v), diwstrt);
+		(cops++)->l = CMOVE(diwstop2hw(par->diwstop_h, par->diwstop_v), diwstop);
+		if (!IS_OCS) {
+			(copl++)->l = CMOVE(diwhigh2hw(par->diwstrt_h, par->diwstrt_v + 1,
+					    par->diwstop_h, par->diwstop_v + 1), diwhigh);
+			(cops++)->l = CMOVE(diwhigh2hw(par->diwstrt_h, par->diwstrt_v,
+					    par->diwstop_h, par->diwstop_v), diwhigh);
+#if 0
+			if (par->beamcon0 & BMC0_VARBEAMEN) {
+				(copl++)->l = CMOVE(vtotal2hw(par->vtotal), vtotal);
+				(copl++)->l = CMOVE(vbstrt2hw(par->vbstrt + 1), vbstrt);
+				(copl++)->l = CMOVE(vbstop2hw(par->vbstop + 1), vbstop);
+				(cops++)->l = CMOVE(vtotal2hw(par->vtotal), vtotal);
+				(cops++)->l = CMOVE(vbstrt2hw(par->vbstrt), vbstrt);
+				(cops++)->l = CMOVE(vbstop2hw(par->vbstop), vbstop);
+			}
+#endif
+		}
+		p = ZTWO_PADDR(copdisplay.list[currentcop][0]);
+		(copl++)->l = CMOVE(highw(p), cop2lc);
+		(copl++)->l = CMOVE2(loww(p), cop2lc);
+		p = ZTWO_PADDR(copdisplay.list[currentcop][1]);
+		(cops++)->l = CMOVE(highw(p), cop2lc);
+		(cops++)->l = CMOVE2(loww(p), cop2lc);
+		copdisplay.rebuild[0] = cops;
+	} else {
+		(copl++)->l = CMOVE(diwstrt2hw(par->diwstrt_h, par->diwstrt_v), diwstrt);
+		(copl++)->l = CMOVE(diwstop2hw(par->diwstop_h, par->diwstop_v), diwstop);
+		if (!IS_OCS) {
+			(copl++)->l = CMOVE(diwhigh2hw(par->diwstrt_h, par->diwstrt_v,
+					    par->diwstop_h, par->diwstop_v), diwhigh);
+#if 0
+			if (par->beamcon0 & BMC0_VARBEAMEN) {
+				(copl++)->l = CMOVE(vtotal2hw(par->vtotal), vtotal);
+				(copl++)->l = CMOVE(vbstrt2hw(par->vbstrt), vbstrt);
+				(copl++)->l = CMOVE(vbstop2hw(par->vbstop), vbstop);
+			}
+#endif
+		}
+	}
+	copdisplay.rebuild[1] = copl;
+
+	ami_update_par();
+	ami_rebuild_copper();
+}
 
-static struct fb_ops amifb_ops = {
-	.owner		= THIS_MODULE,
-	.fb_check_var	= amifb_check_var,
-	.fb_set_par	= amifb_set_par,
-	.fb_setcolreg	= amifb_setcolreg,
-	.fb_blank	= amifb_blank,
-	.fb_pan_display	= amifb_pan_display,
-	.fb_fillrect	= amifb_fillrect,
-	.fb_copyarea	= amifb_copyarea,
-	.fb_imageblit	= amifb_imageblit,
-	.fb_ioctl	= amifb_ioctl,
-};
 
 static void __init amifb_setup_mcap(char *spec)
 {
@@ -1327,6 +2458,93 @@ static int amifb_set_par(struct fb_info *info)
 
 
 	/*
+	 * Set a single color register. The values supplied are already
+	 * rounded down to the hardware's capabilities (according to the
+	 * entries in the var structure). Return != 0 for invalid regno.
+	 */
+
+static int amifb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
+			   u_int transp, struct fb_info *info)
+{
+	if (IS_AGA) {
+		if (regno > 255)
+			return 1;
+	} else if (currentpar.bplcon0 & BPC0_SHRES) {
+		if (regno > 3)
+			return 1;
+	} else {
+		if (regno > 31)
+			return 1;
+	}
+	red >>= 8;
+	green >>= 8;
+	blue >>= 8;
+	if (!regno) {
+		red0 = red;
+		green0 = green;
+		blue0 = blue;
+	}
+
+	/*
+	 * Update the corresponding Hardware Color Register, unless it's Color
+	 * Register 0 and the screen is blanked.
+	 *
+	 * VBlank is switched off to protect bplcon3 or ecs_palette[] from
+	 * being changed by ami_do_blank() during the VBlank.
+	 */
+
+	if (regno || !is_blanked) {
+#if defined(CONFIG_FB_AMIGA_AGA)
+		if (IS_AGA) {
+			u_short bplcon3 = currentpar.bplcon3;
+			VBlankOff();
+			custom.bplcon3 = bplcon3 | (regno << 8 & 0xe000);
+			custom.color[regno & 31] = rgb2hw8_high(red, green,
+								blue);
+			custom.bplcon3 = bplcon3 | (regno << 8 & 0xe000) |
+					 BPC3_LOCT;
+			custom.color[regno & 31] = rgb2hw8_low(red, green,
+							       blue);
+			custom.bplcon3 = bplcon3;
+			VBlankOn();
+		} else
+#endif
+#if defined(CONFIG_FB_AMIGA_ECS)
+		if (currentpar.bplcon0 & BPC0_SHRES) {
+			u_short color, mask;
+			int i;
+
+			mask = 0x3333;
+			color = rgb2hw2(red, green, blue);
+			VBlankOff();
+			for (i = regno + 12; i >= (int)regno; i -= 4)
+				custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
+			mask <<= 2; color >>= 2;
+			regno = down16(regno) + mul4(mod4(regno));
+			for (i = regno + 3; i >= (int)regno; i--)
+				custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
+			VBlankOn();
+		} else
+#endif
+			custom.color[regno] = rgb2hw4(red, green, blue);
+	}
+	return 0;
+}
+
+
+	/*
+	 * Blank the display.
+	 */
+
+static int amifb_blank(int blank, struct fb_info *info)
+{
+	do_blank = blank ? blank : -1;
+
+	return 0;
+}
+
+
+	/*
 	 * Pan or Wrap the Display
 	 *
 	 * This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
@@ -2232,6 +3450,77 @@ static int amifb_ioctl(struct fb_info *info,
 
 
 	/*
+	 * Flash the cursor (called by VBlank interrupt)
+	 */
+
+static int flash_cursor(void)
+{
+	static int cursorcount = 1;
+
+	if (cursormode == FB_CURSOR_FLASH) {
+		if (!--cursorcount) {
+			cursorstate = -cursorstate;
+			cursorcount = cursorrate;
+			if (!is_blanked)
+				return 1;
+		}
+	}
+	return 0;
+}
+
+	/*
+	 * VBlank Display Interrupt
+	 */
+
+static irqreturn_t amifb_interrupt(int irq, void *dev_id)
+{
+	if (do_vmode_pan || do_vmode_full)
+		ami_update_display();
+
+	if (do_vmode_full)
+		ami_init_display();
+
+	if (do_vmode_pan) {
+		flash_cursor();
+		ami_rebuild_copper();
+		do_cursor = do_vmode_pan = 0;
+	} else if (do_cursor) {
+		flash_cursor();
+		ami_set_sprite();
+		do_cursor = 0;
+	} else {
+		if (flash_cursor())
+			ami_set_sprite();
+	}
+
+	if (do_blank) {
+		ami_do_blank();
+		do_blank = 0;
+	}
+
+	if (do_vmode_full) {
+		ami_reinit_copper();
+		do_vmode_full = 0;
+	}
+	return IRQ_HANDLED;
+}
+
+
+static struct fb_ops amifb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_check_var	= amifb_check_var,
+	.fb_set_par	= amifb_set_par,
+	.fb_setcolreg	= amifb_setcolreg,
+	.fb_blank	= amifb_blank,
+	.fb_pan_display	= amifb_pan_display,
+	.fb_fillrect	= amifb_fillrect,
+	.fb_copyarea	= amifb_copyarea,
+	.fb_imageblit	= amifb_imageblit,
+	.fb_ioctl	= amifb_ioctl,
+};
+
+
+	/*
 	 * Allocate, Clear and Align a Block of Chip Memory
 	 */
 
@@ -2255,6 +3544,17 @@ static inline void chipfree(void)
 }
 
 
+static void amifb_deinit(struct platform_device *pdev)
+{
+	if (fb_info.cmap.len)
+		fb_dealloc_cmap(&fb_info.cmap);
+	chipfree();
+	if (videomemory)
+		iounmap((void *)videomemory);
+	custom.dmacon = DMAF_ALL | DMAF_MASTER;
+}
+
+
 	/*
 	 * Initialisation
 	 */
@@ -2460,1361 +3760,6 @@ amifb_error:
 	return err;
 }
 
-static void amifb_deinit(struct platform_device *pdev)
-{
-	if (fb_info.cmap.len)
-		fb_dealloc_cmap(&fb_info.cmap);
-	chipfree();
-	if (videomemory)
-		iounmap((void *)videomemory);
-	custom.dmacon = DMAF_ALL | DMAF_MASTER;
-}
-
-
-	/*
-	 * Blank the display.
-	 */
-
-static int amifb_blank(int blank, struct fb_info *info)
-{
-	do_blank = blank ? blank : -1;
-
-	return 0;
-}
-
-	/*
-	 * Flash the cursor (called by VBlank interrupt)
-	 */
-
-static int flash_cursor(void)
-{
-	static int cursorcount = 1;
-
-	if (cursormode == FB_CURSOR_FLASH) {
-		if (!--cursorcount) {
-			cursorstate = -cursorstate;
-			cursorcount = cursorrate;
-			if (!is_blanked)
-				return 1;
-		}
-	}
-	return 0;
-}
-
-	/*
-	 * VBlank Display Interrupt
-	 */
-
-static irqreturn_t amifb_interrupt(int irq, void *dev_id)
-{
-	if (do_vmode_pan || do_vmode_full)
-		ami_update_display();
-
-	if (do_vmode_full)
-		ami_init_display();
-
-	if (do_vmode_pan) {
-		flash_cursor();
-		ami_rebuild_copper();
-		do_cursor = do_vmode_pan = 0;
-	} else if (do_cursor) {
-		flash_cursor();
-		ami_set_sprite();
-		do_cursor = 0;
-	} else {
-		if (flash_cursor())
-			ami_set_sprite();
-	}
-
-	if (do_blank) {
-		ami_do_blank();
-		do_blank = 0;
-	}
-
-	if (do_vmode_full) {
-		ami_reinit_copper();
-		do_vmode_full = 0;
-	}
-	return IRQ_HANDLED;
-}
-
-/* --------------------------- Hardware routines --------------------------- */
-
-	/*
-	 * Get the video params out of `var'. If a value doesn't fit, round
-	 * it up, if it's too big, return -EINVAL.
-	 */
-
-static int ami_decode_var(struct fb_var_screeninfo *var,
-			  struct amifb_par *par)
-{
-	u_short clk_shift, line_shift;
-	u_long maxfetchstop, fstrt, fsize, fconst, xres_n, yres_n;
-	u_int htotal, vtotal;
-
-	/*
-	 * Find a matching Pixel Clock
-	 */
-
-	for (clk_shift = TAG_SHRES; clk_shift <= TAG_LORES; clk_shift++)
-		if (var->pixclock <= pixclock[clk_shift])
-			break;
-	if (clk_shift > TAG_LORES) {
-		DPRINTK("pixclock too high\n");
-		return -EINVAL;
-	}
-	par->clk_shift = clk_shift;
-
-	/*
-	 * Check the Geometry Values
-	 */
-
-	if ((par->xres = var->xres) < 64)
-		par->xres = 64;
-	if ((par->yres = var->yres) < 64)
-		par->yres = 64;
-	if ((par->vxres = var->xres_virtual) < par->xres)
-		par->vxres = par->xres;
-	if ((par->vyres = var->yres_virtual) < par->yres)
-		par->vyres = par->yres;
-
-	par->bpp = var->bits_per_pixel;
-	if (!var->nonstd) {
-		if (par->bpp < 1)
-			par->bpp = 1;
-		if (par->bpp > maxdepth[clk_shift]) {
-			if (round_down_bpp && maxdepth[clk_shift])
-				par->bpp = maxdepth[clk_shift];
-			else {
-				DPRINTK("invalid bpp\n");
-				return -EINVAL;
-			}
-		}
-	} else if (var->nonstd == FB_NONSTD_HAM) {
-		if (par->bpp < 6)
-			par->bpp = 6;
-		if (par->bpp != 6) {
-			if (par->bpp < 8)
-				par->bpp = 8;
-			if (par->bpp != 8 || !IS_AGA) {
-				DPRINTK("invalid bpp for ham mode\n");
-				return -EINVAL;
-			}
-		}
-	} else {
-		DPRINTK("unknown nonstd mode\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * FB_VMODE_SMOOTH_XPAN will be cleared, if one of the folloing
-	 * checks failed and smooth scrolling is not possible
-	 */
-
-	par->vmode = var->vmode | FB_VMODE_SMOOTH_XPAN;
-	switch (par->vmode & FB_VMODE_MASK) {
-	case FB_VMODE_INTERLACED:
-		line_shift = 0;
-		break;
-	case FB_VMODE_NONINTERLACED:
-		line_shift = 1;
-		break;
-	case FB_VMODE_DOUBLE:
-		if (!IS_AGA) {
-			DPRINTK("double mode only possible with aga\n");
-			return -EINVAL;
-		}
-		line_shift = 2;
-		break;
-	default:
-		DPRINTK("unknown video mode\n");
-		return -EINVAL;
-		break;
-	}
-	par->line_shift = line_shift;
-
-	/*
-	 * Vertical and Horizontal Timings
-	 */
-
-	xres_n = par->xres << clk_shift;
-	yres_n = par->yres << line_shift;
-	par->htotal = down8((var->left_margin + par->xres + var->right_margin +
-			     var->hsync_len) << clk_shift);
-	par->vtotal =
-		down2(((var->upper_margin + par->yres + var->lower_margin +
-			var->vsync_len) << line_shift) + 1);
-
-	if (IS_AGA)
-		par->bplcon3 = sprpixmode[clk_shift];
-	else
-		par->bplcon3 = 0;
-	if (var->sync & FB_SYNC_BROADCAST) {
-		par->diwstop_h = par->htotal -
-			((var->right_margin - var->hsync_len) << clk_shift);
-		if (IS_AGA)
-			par->diwstop_h += mod4(var->hsync_len);
-		else
-			par->diwstop_h = down4(par->diwstop_h);
-
-		par->diwstrt_h = par->diwstop_h - xres_n;
-		par->diwstop_v = par->vtotal -
-			((var->lower_margin - var->vsync_len) << line_shift);
-		par->diwstrt_v = par->diwstop_v - yres_n;
-		if (par->diwstop_h >= par->htotal + 8) {
-			DPRINTK("invalid diwstop_h\n");
-			return -EINVAL;
-		}
-		if (par->diwstop_v > par->vtotal) {
-			DPRINTK("invalid diwstop_v\n");
-			return -EINVAL;
-		}
-
-		if (!IS_OCS) {
-			/* Initialize sync with some reasonable values for pwrsave */
-			par->hsstrt = 160;
-			par->hsstop = 320;
-			par->vsstrt = 30;
-			par->vsstop = 34;
-		} else {
-			par->hsstrt = 0;
-			par->hsstop = 0;
-			par->vsstrt = 0;
-			par->vsstop = 0;
-		}
-		if (par->vtotal > (PAL_VTOTAL + NTSC_VTOTAL) / 2) {
-			/* PAL video mode */
-			if (par->htotal != PAL_HTOTAL) {
-				DPRINTK("htotal invalid for pal\n");
-				return -EINVAL;
-			}
-			if (par->diwstrt_h < PAL_DIWSTRT_H) {
-				DPRINTK("diwstrt_h too low for pal\n");
-				return -EINVAL;
-			}
-			if (par->diwstrt_v < PAL_DIWSTRT_V) {
-				DPRINTK("diwstrt_v too low for pal\n");
-				return -EINVAL;
-			}
-			htotal = PAL_HTOTAL>>clk_shift;
-			vtotal = PAL_VTOTAL>>1;
-			if (!IS_OCS) {
-				par->beamcon0 = BMC0_PAL;
-				par->bplcon3 |= BPC3_BRDRBLNK;
-			} else if (AMIGAHW_PRESENT(AGNUS_HR_PAL) ||
-				   AMIGAHW_PRESENT(AGNUS_HR_NTSC)) {
-				par->beamcon0 = BMC0_PAL;
-				par->hsstop = 1;
-			} else if (amiga_vblank != 50) {
-				DPRINTK("pal not supported by this chipset\n");
-				return -EINVAL;
-			}
-		} else {
-			/* NTSC video mode
-			 * In the AGA chipset seems to be hardware bug with BPC3_BRDRBLNK
-			 * and NTSC activated, so than better let diwstop_h <= 1812
-			 */
-			if (par->htotal != NTSC_HTOTAL) {
-				DPRINTK("htotal invalid for ntsc\n");
-				return -EINVAL;
-			}
-			if (par->diwstrt_h < NTSC_DIWSTRT_H) {
-				DPRINTK("diwstrt_h too low for ntsc\n");
-				return -EINVAL;
-			}
-			if (par->diwstrt_v < NTSC_DIWSTRT_V) {
-				DPRINTK("diwstrt_v too low for ntsc\n");
-				return -EINVAL;
-			}
-			htotal = NTSC_HTOTAL>>clk_shift;
-			vtotal = NTSC_VTOTAL>>1;
-			if (!IS_OCS) {
-				par->beamcon0 = 0;
-				par->bplcon3 |= BPC3_BRDRBLNK;
-			} else if (AMIGAHW_PRESENT(AGNUS_HR_PAL) ||
-				   AMIGAHW_PRESENT(AGNUS_HR_NTSC)) {
-				par->beamcon0 = 0;
-				par->hsstop = 1;
-			} else if (amiga_vblank != 60) {
-				DPRINTK("ntsc not supported by this chipset\n");
-				return -EINVAL;
-			}
-		}
-		if (IS_OCS) {
-			if (par->diwstrt_h >= 1024 || par->diwstop_h < 1024 ||
-			    par->diwstrt_v >=  512 || par->diwstop_v <  256) {
-				DPRINTK("invalid position for display on ocs\n");
-				return -EINVAL;
-			}
-		}
-	} else if (!IS_OCS) {
-		/* Programmable video mode */
-		par->hsstrt = var->right_margin << clk_shift;
-		par->hsstop = (var->right_margin + var->hsync_len) << clk_shift;
-		par->diwstop_h = par->htotal - mod8(par->hsstrt) + 8 - (1 << clk_shift);
-		if (!IS_AGA)
-			par->diwstop_h = down4(par->diwstop_h) - 16;
-		par->diwstrt_h = par->diwstop_h - xres_n;
-		par->hbstop = par->diwstrt_h + 4;
-		par->hbstrt = par->diwstop_h + 4;
-		if (par->hbstrt >= par->htotal + 8)
-			par->hbstrt -= par->htotal;
-		par->hcenter = par->hsstrt + (par->htotal >> 1);
-		par->vsstrt = var->lower_margin << line_shift;
-		par->vsstop = (var->lower_margin + var->vsync_len) << line_shift;
-		par->diwstop_v = par->vtotal;
-		if ((par->vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED)
-			par->diwstop_v -= 2;
-		par->diwstrt_v = par->diwstop_v - yres_n;
-		par->vbstop = par->diwstrt_v - 2;
-		par->vbstrt = par->diwstop_v - 2;
-		if (par->vtotal > 2048) {
-			DPRINTK("vtotal too high\n");
-			return -EINVAL;
-		}
-		if (par->htotal > 2048) {
-			DPRINTK("htotal too high\n");
-			return -EINVAL;
-		}
-		par->bplcon3 |= BPC3_EXTBLKEN;
-		par->beamcon0 = BMC0_HARDDIS | BMC0_VARVBEN | BMC0_LOLDIS |
-				BMC0_VARVSYEN | BMC0_VARHSYEN | BMC0_VARBEAMEN |
-				BMC0_PAL | BMC0_VARCSYEN;
-		if (var->sync & FB_SYNC_HOR_HIGH_ACT)
-			par->beamcon0 |= BMC0_HSYTRUE;
-		if (var->sync & FB_SYNC_VERT_HIGH_ACT)
-			par->beamcon0 |= BMC0_VSYTRUE;
-		if (var->sync & FB_SYNC_COMP_HIGH_ACT)
-			par->beamcon0 |= BMC0_CSYTRUE;
-		htotal = par->htotal>>clk_shift;
-		vtotal = par->vtotal>>1;
-	} else {
-		DPRINTK("only broadcast modes possible for ocs\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * Checking the DMA timing
-	 */
-
-	fconst = 16 << maxfmode << clk_shift;
-
-	/*
-	 * smallest window start value without turn off other dma cycles
-	 * than sprite1-7, unless you change min_fstrt
-	 */
-
-
-	fsize = ((maxfmode + clk_shift <= 1) ? fconst : 64);
-	fstrt = downx(fconst, par->diwstrt_h - 4) - fsize;
-	if (fstrt < min_fstrt) {
-		DPRINTK("fetch start too low\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * smallest window start value where smooth scrolling is possible
-	 */
-
-	fstrt = downx(fconst, par->diwstrt_h - fconst + (1 << clk_shift) - 4) -
-		fsize;
-	if (fstrt < min_fstrt)
-		par->vmode &= ~FB_VMODE_SMOOTH_XPAN;
-
-	maxfetchstop = down16(par->htotal - 80);
-
-	fstrt = downx(fconst, par->diwstrt_h - 4) - 64 - fconst;
-	fsize = upx(fconst, xres_n +
-		    modx(fconst, downx(1 << clk_shift, par->diwstrt_h - 4)));
-	if (fstrt + fsize > maxfetchstop)
-		par->vmode &= ~FB_VMODE_SMOOTH_XPAN;
-
-	fsize = upx(fconst, xres_n);
-	if (fstrt + fsize > maxfetchstop) {
-		DPRINTK("fetch stop too high\n");
-		return -EINVAL;
-	}
-
-	if (maxfmode + clk_shift <= 1) {
-		fsize = up64(xres_n + fconst - 1);
-		if (min_fstrt + fsize - 64 > maxfetchstop)
-			par->vmode &= ~FB_VMODE_SMOOTH_XPAN;
-
-		fsize = up64(xres_n);
-		if (min_fstrt + fsize - 64 > maxfetchstop) {
-			DPRINTK("fetch size too high\n");
-			return -EINVAL;
-		}
-
-		fsize -= 64;
-	} else
-		fsize -= fconst;
-
-	/*
-	 * Check if there is enough time to update the bitplane pointers for ywrap
-	 */
-
-	if (par->htotal - fsize - 64 < par->bpp * 64)
-		par->vmode &= ~FB_VMODE_YWRAP;
-
-	/*
-	 * Bitplane calculations and check the Memory Requirements
-	 */
-
-	if (amifb_ilbm) {
-		par->next_plane = div8(upx(16 << maxfmode, par->vxres));
-		par->next_line = par->bpp * par->next_plane;
-		if (par->next_line * par->vyres > fb_info.fix.smem_len) {
-			DPRINTK("too few video mem\n");
-			return -EINVAL;
-		}
-	} else {
-		par->next_line = div8(upx(16 << maxfmode, par->vxres));
-		par->next_plane = par->vyres * par->next_line;
-		if (par->next_plane * par->bpp > fb_info.fix.smem_len) {
-			DPRINTK("too few video mem\n");
-			return -EINVAL;
-		}
-	}
-
-	/*
-	 * Hardware Register Values
-	 */
-
-	par->bplcon0 = BPC0_COLOR | bplpixmode[clk_shift];
-	if (!IS_OCS)
-		par->bplcon0 |= BPC0_ECSENA;
-	if (par->bpp == 8)
-		par->bplcon0 |= BPC0_BPU3;
-	else
-		par->bplcon0 |= par->bpp << 12;
-	if (var->nonstd == FB_NONSTD_HAM)
-		par->bplcon0 |= BPC0_HAM;
-	if (var->sync & FB_SYNC_EXT)
-		par->bplcon0 |= BPC0_ERSY;
-
-	if (IS_AGA)
-		par->fmode = bplfetchmode[maxfmode];
-
-	switch (par->vmode & FB_VMODE_MASK) {
-	case FB_VMODE_INTERLACED:
-		par->bplcon0 |= BPC0_LACE;
-		break;
-	case FB_VMODE_DOUBLE:
-		if (IS_AGA)
-			par->fmode |= FMODE_SSCAN2 | FMODE_BSCAN2;
-		break;
-	}
-
-	if (!((par->vmode ^ var->vmode) & FB_VMODE_YWRAP)) {
-		par->xoffset = var->xoffset;
-		par->yoffset = var->yoffset;
-		if (par->vmode & FB_VMODE_YWRAP) {
-			if (par->xoffset || par->yoffset < 0 ||
-			    par->yoffset >= par->vyres)
-				par->xoffset = par->yoffset = 0;
-		} else {
-			if (par->xoffset < 0 ||
-			    par->xoffset > upx(16 << maxfmode, par->vxres - par->xres) ||
-			    par->yoffset < 0 || par->yoffset > par->vyres - par->yres)
-				par->xoffset = par->yoffset = 0;
-		}
-	} else
-		par->xoffset = par->yoffset = 0;
-
-	par->crsr.crsr_x = par->crsr.crsr_y = 0;
-	par->crsr.spot_x = par->crsr.spot_y = 0;
-	par->crsr.height = par->crsr.width = 0;
-
-	return 0;
-}
-
-	/*
-	 * Fill the `var' structure based on the values in `par' and maybe
-	 * other values read out of the hardware.
-	 */
-
-static int ami_encode_var(struct fb_var_screeninfo *var,
-			  struct amifb_par *par)
-{
-	u_short clk_shift, line_shift;
-
-	memset(var, 0, sizeof(struct fb_var_screeninfo));
-
-	clk_shift = par->clk_shift;
-	line_shift = par->line_shift;
-
-	var->xres = par->xres;
-	var->yres = par->yres;
-	var->xres_virtual = par->vxres;
-	var->yres_virtual = par->vyres;
-	var->xoffset = par->xoffset;
-	var->yoffset = par->yoffset;
-
-	var->bits_per_pixel = par->bpp;
-	var->grayscale = 0;
-
-	var->red.offset = 0;
-	var->red.msb_right = 0;
-	var->red.length = par->bpp;
-	if (par->bplcon0 & BPC0_HAM)
-		var->red.length -= 2;
-	var->blue = var->green = var->red;
-	var->transp.offset = 0;
-	var->transp.length = 0;
-	var->transp.msb_right = 0;
-
-	if (par->bplcon0 & BPC0_HAM)
-		var->nonstd = FB_NONSTD_HAM;
-	else
-		var->nonstd = 0;
-	var->activate = 0;
-
-	var->height = -1;
-	var->width = -1;
-
-	var->pixclock = pixclock[clk_shift];
-
-	if (IS_AGA && par->fmode & FMODE_BSCAN2)
-		var->vmode = FB_VMODE_DOUBLE;
-	else if (par->bplcon0 & BPC0_LACE)
-		var->vmode = FB_VMODE_INTERLACED;
-	else
-		var->vmode = FB_VMODE_NONINTERLACED;
-
-	if (!IS_OCS && par->beamcon0 & BMC0_VARBEAMEN) {
-		var->hsync_len = (par->hsstop - par->hsstrt)>>clk_shift;
-		var->right_margin = par->hsstrt>>clk_shift;
-		var->left_margin = (par->htotal>>clk_shift) - var->xres - var->right_margin - var->hsync_len;
-		var->vsync_len = (par->vsstop - par->vsstrt)>>line_shift;
-		var->lower_margin = par->vsstrt>>line_shift;
-		var->upper_margin = (par->vtotal>>line_shift) - var->yres - var->lower_margin - var->vsync_len;
-		var->sync = 0;
-		if (par->beamcon0 & BMC0_HSYTRUE)
-			var->sync |= FB_SYNC_HOR_HIGH_ACT;
-		if (par->beamcon0 & BMC0_VSYTRUE)
-			var->sync |= FB_SYNC_VERT_HIGH_ACT;
-		if (par->beamcon0 & BMC0_CSYTRUE)
-			var->sync |= FB_SYNC_COMP_HIGH_ACT;
-	} else {
-		var->sync = FB_SYNC_BROADCAST;
-		var->hsync_len = (152>>clk_shift) + mod4(par->diwstop_h);
-		var->right_margin = ((par->htotal - down4(par->diwstop_h))>>clk_shift) + var->hsync_len;
-		var->left_margin = (par->htotal>>clk_shift) - var->xres - var->right_margin - var->hsync_len;
-		var->vsync_len = 4>>line_shift;
-		var->lower_margin = ((par->vtotal - par->diwstop_v)>>line_shift) + var->vsync_len;
-		var->upper_margin = (((par->vtotal - 2)>>line_shift) + 1) - var->yres -
-				    var->lower_margin - var->vsync_len;
-	}
-
-	if (par->bplcon0 & BPC0_ERSY)
-		var->sync |= FB_SYNC_EXT;
-	if (par->vmode & FB_VMODE_YWRAP)
-		var->vmode |= FB_VMODE_YWRAP;
-
-	return 0;
-}
-
-
-	/*
-	 * Pan or Wrap the Display
-	 *
-	 * This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
-	 * in `var'.
-	 */
-
-static void ami_pan_var(struct fb_var_screeninfo *var)
-{
-	struct amifb_par *par = &currentpar;
-
-	par->xoffset = var->xoffset;
-	par->yoffset = var->yoffset;
-	if (var->vmode & FB_VMODE_YWRAP)
-		par->vmode |= FB_VMODE_YWRAP;
-	else
-		par->vmode &= ~FB_VMODE_YWRAP;
-
-	do_vmode_pan = 0;
-	ami_update_par();
-	do_vmode_pan = 1;
-}
-
-	/*
-	 * Update hardware
-	 */
-
-static int ami_update_par(void)
-{
-	struct amifb_par *par = &currentpar;
-	short clk_shift, vshift, fstrt, fsize, fstop, fconst,  shift, move, mod;
-
-	clk_shift = par->clk_shift;
-
-	if (!(par->vmode & FB_VMODE_SMOOTH_XPAN))
-		par->xoffset = upx(16 << maxfmode, par->xoffset);
-
-	fconst = 16 << maxfmode << clk_shift;
-	vshift = modx(16 << maxfmode, par->xoffset);
-	fstrt = par->diwstrt_h - (vshift << clk_shift) - 4;
-	fsize = (par->xres + vshift) << clk_shift;
-	shift = modx(fconst, fstrt);
-	move = downx(2 << maxfmode, div8(par->xoffset));
-	if (maxfmode + clk_shift > 1) {
-		fstrt = downx(fconst, fstrt) - 64;
-		fsize = upx(fconst, fsize);
-		fstop = fstrt + fsize - fconst;
-	} else {
-		mod = fstrt = downx(fconst, fstrt) - fconst;
-		fstop = fstrt + upx(fconst, fsize) - 64;
-		fsize = up64(fsize);
-		fstrt = fstop - fsize + 64;
-		if (fstrt < min_fstrt) {
-			fstop += min_fstrt - fstrt;
-			fstrt = min_fstrt;
-		}
-		move = move - div8((mod - fstrt)>>clk_shift);
-	}
-	mod = par->next_line - div8(fsize>>clk_shift);
-	par->ddfstrt = fstrt;
-	par->ddfstop = fstop;
-	par->bplcon1 = hscroll2hw(shift);
-	par->bpl2mod = mod;
-	if (par->bplcon0 & BPC0_LACE)
-		par->bpl2mod += par->next_line;
-	if (IS_AGA && (par->fmode & FMODE_BSCAN2))
-		par->bpl1mod = -div8(fsize>>clk_shift);
-	else
-		par->bpl1mod = par->bpl2mod;
-
-	if (par->yoffset) {
-		par->bplpt0 = fb_info.fix.smem_start +
-			      par->next_line * par->yoffset + move;
-		if (par->vmode & FB_VMODE_YWRAP) {
-			if (par->yoffset > par->vyres - par->yres) {
-				par->bplpt0wrap = fb_info.fix.smem_start + move;
-				if (par->bplcon0 & BPC0_LACE &&
-				    mod2(par->diwstrt_v + par->vyres -
-					 par->yoffset))
-					par->bplpt0wrap += par->next_line;
-			}
-		}
-	} else
-		par->bplpt0 = fb_info.fix.smem_start + move;
-
-	if (par->bplcon0 & BPC0_LACE && mod2(par->diwstrt_v))
-		par->bplpt0 += par->next_line;
-
-	return 0;
-}
-
-
-	/*
-	 * Set a single color register. The values supplied are already
-	 * rounded down to the hardware's capabilities (according to the
-	 * entries in the var structure). Return != 0 for invalid regno.
-	 */
-
-static int amifb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
-			   u_int transp, struct fb_info *info)
-{
-	if (IS_AGA) {
-		if (regno > 255)
-			return 1;
-	} else if (currentpar.bplcon0 & BPC0_SHRES) {
-		if (regno > 3)
-			return 1;
-	} else {
-		if (regno > 31)
-			return 1;
-	}
-	red >>= 8;
-	green >>= 8;
-	blue >>= 8;
-	if (!regno) {
-		red0 = red;
-		green0 = green;
-		blue0 = blue;
-	}
-
-	/*
-	 * Update the corresponding Hardware Color Register, unless it's Color
-	 * Register 0 and the screen is blanked.
-	 *
-	 * VBlank is switched off to protect bplcon3 or ecs_palette[] from
-	 * being changed by ami_do_blank() during the VBlank.
-	 */
-
-	if (regno || !is_blanked) {
-#if defined(CONFIG_FB_AMIGA_AGA)
-		if (IS_AGA) {
-			u_short bplcon3 = currentpar.bplcon3;
-			VBlankOff();
-			custom.bplcon3 = bplcon3 | (regno << 8 & 0xe000);
-			custom.color[regno & 31] = rgb2hw8_high(red, green,
-								blue);
-			custom.bplcon3 = bplcon3 | (regno << 8 & 0xe000) |
-					 BPC3_LOCT;
-			custom.color[regno & 31] = rgb2hw8_low(red, green,
-							       blue);
-			custom.bplcon3 = bplcon3;
-			VBlankOn();
-		} else
-#endif
-#if defined(CONFIG_FB_AMIGA_ECS)
-		if (currentpar.bplcon0 & BPC0_SHRES) {
-			u_short color, mask;
-			int i;
-
-			mask = 0x3333;
-			color = rgb2hw2(red, green, blue);
-			VBlankOff();
-			for (i = regno + 12; i >= (int)regno; i -= 4)
-				custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
-			mask <<= 2; color >>= 2;
-			regno = down16(regno) + mul4(mod4(regno));
-			for (i = regno + 3; i >= (int)regno; i--)
-				custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
-			VBlankOn();
-		} else
-#endif
-			custom.color[regno] = rgb2hw4(red, green, blue);
-	}
-	return 0;
-}
-
-static void ami_update_display(void)
-{
-	struct amifb_par *par = &currentpar;
-
-	custom.bplcon1 = par->bplcon1;
-	custom.bpl1mod = par->bpl1mod;
-	custom.bpl2mod = par->bpl2mod;
-	custom.ddfstrt = ddfstrt2hw(par->ddfstrt);
-	custom.ddfstop = ddfstop2hw(par->ddfstop);
-}
-
-	/*
-	 * Change the video mode (called by VBlank interrupt)
-	 */
-
-static void ami_init_display(void)
-{
-	struct amifb_par *par = &currentpar;
-	int i;
-
-	custom.bplcon0 = par->bplcon0 & ~BPC0_LACE;
-	custom.bplcon2 = (IS_OCS ? 0 : BPC2_KILLEHB) | BPC2_PF2P2 | BPC2_PF1P2;
-	if (!IS_OCS) {
-		custom.bplcon3 = par->bplcon3;
-		if (IS_AGA)
-			custom.bplcon4 = BPC4_ESPRM4 | BPC4_OSPRM4;
-		if (par->beamcon0 & BMC0_VARBEAMEN) {
-			custom.htotal = htotal2hw(par->htotal);
-			custom.hbstrt = hbstrt2hw(par->hbstrt);
-			custom.hbstop = hbstop2hw(par->hbstop);
-			custom.hsstrt = hsstrt2hw(par->hsstrt);
-			custom.hsstop = hsstop2hw(par->hsstop);
-			custom.hcenter = hcenter2hw(par->hcenter);
-			custom.vtotal = vtotal2hw(par->vtotal);
-			custom.vbstrt = vbstrt2hw(par->vbstrt);
-			custom.vbstop = vbstop2hw(par->vbstop);
-			custom.vsstrt = vsstrt2hw(par->vsstrt);
-			custom.vsstop = vsstop2hw(par->vsstop);
-		}
-	}
-	if (!IS_OCS || par->hsstop)
-		custom.beamcon0 = par->beamcon0;
-	if (IS_AGA)
-		custom.fmode = par->fmode;
-
-	/*
-	 * The minimum period for audio depends on htotal
-	 */
-
-	amiga_audio_min_period = div16(par->htotal);
-
-	is_lace = par->bplcon0 & BPC0_LACE ? 1 : 0;
-#if 1
-	if (is_lace) {
-		i = custom.vposr >> 15;
-	} else {
-		custom.vposw = custom.vposr | 0x8000;
-		i = 1;
-	}
-#else
-	i = 1;
-	custom.vposw = custom.vposr | 0x8000;
-#endif
-	custom.cop2lc = (u_short *)ZTWO_PADDR(copdisplay.list[currentcop][i]);
-}
-
-	/*
-	 * (Un)Blank the screen (called by VBlank interrupt)
-	 */
-
-static void ami_do_blank(void)
-{
-	struct amifb_par *par = &currentpar;
-#if defined(CONFIG_FB_AMIGA_AGA)
-	u_short bplcon3 = par->bplcon3;
-#endif
-	u_char red, green, blue;
-
-	if (do_blank > 0) {
-		custom.dmacon = DMAF_RASTER | DMAF_SPRITE;
-		red = green = blue = 0;
-		if (!IS_OCS && do_blank > 1) {
-			switch (do_blank) {
-			case FB_BLANK_VSYNC_SUSPEND:
-				custom.hsstrt = hsstrt2hw(par->hsstrt);
-				custom.hsstop = hsstop2hw(par->hsstop);
-				custom.vsstrt = vsstrt2hw(par->vtotal + 4);
-				custom.vsstop = vsstop2hw(par->vtotal + 4);
-				break;
-			case FB_BLANK_HSYNC_SUSPEND:
-				custom.hsstrt = hsstrt2hw(par->htotal + 16);
-				custom.hsstop = hsstop2hw(par->htotal + 16);
-				custom.vsstrt = vsstrt2hw(par->vsstrt);
-				custom.vsstop = vsstrt2hw(par->vsstop);
-				break;
-			case FB_BLANK_POWERDOWN:
-				custom.hsstrt = hsstrt2hw(par->htotal + 16);
-				custom.hsstop = hsstop2hw(par->htotal + 16);
-				custom.vsstrt = vsstrt2hw(par->vtotal + 4);
-				custom.vsstop = vsstop2hw(par->vtotal + 4);
-				break;
-			}
-			if (!(par->beamcon0 & BMC0_VARBEAMEN)) {
-				custom.htotal = htotal2hw(par->htotal);
-				custom.vtotal = vtotal2hw(par->vtotal);
-				custom.beamcon0 = BMC0_HARDDIS | BMC0_VARBEAMEN |
-						  BMC0_VARVSYEN | BMC0_VARHSYEN | BMC0_VARCSYEN;
-			}
-		}
-	} else {
-		custom.dmacon = DMAF_SETCLR | DMAF_RASTER | DMAF_SPRITE;
-		red = red0;
-		green = green0;
-		blue = blue0;
-		if (!IS_OCS) {
-			custom.hsstrt = hsstrt2hw(par->hsstrt);
-			custom.hsstop = hsstop2hw(par->hsstop);
-			custom.vsstrt = vsstrt2hw(par->vsstrt);
-			custom.vsstop = vsstop2hw(par->vsstop);
-			custom.beamcon0 = par->beamcon0;
-		}
-	}
-#if defined(CONFIG_FB_AMIGA_AGA)
-	if (IS_AGA) {
-		custom.bplcon3 = bplcon3;
-		custom.color[0] = rgb2hw8_high(red, green, blue);
-		custom.bplcon3 = bplcon3 | BPC3_LOCT;
-		custom.color[0] = rgb2hw8_low(red, green, blue);
-		custom.bplcon3 = bplcon3;
-	} else
-#endif
-#if defined(CONFIG_FB_AMIGA_ECS)
-	if (par->bplcon0 & BPC0_SHRES) {
-		u_short color, mask;
-		int i;
-
-		mask = 0x3333;
-		color = rgb2hw2(red, green, blue);
-		for (i = 12; i >= 0; i -= 4)
-			custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
-		mask <<= 2; color >>= 2;
-		for (i = 3; i >= 0; i--)
-			custom.color[i] = ecs_palette[i] = (ecs_palette[i] & mask) | color;
-	} else
-#endif
-		custom.color[0] = rgb2hw4(red, green, blue);
-	is_blanked = do_blank > 0 ? do_blank : 0;
-}
-
-static int ami_get_fix_cursorinfo(struct fb_fix_cursorinfo *fix)
-{
-	struct amifb_par *par = &currentpar;
-
-	fix->crsr_width = fix->crsr_xsize = par->crsr.width;
-	fix->crsr_height = fix->crsr_ysize = par->crsr.height;
-	fix->crsr_color1 = 17;
-	fix->crsr_color2 = 18;
-	return 0;
-}
-
-static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data)
-{
-	struct amifb_par *par = &currentpar;
-	register u_short *lspr, *sspr;
-#ifdef __mc68000__
-	register u_long datawords asm ("d2");
-#else
-	register u_long datawords;
-#endif
-	register short delta;
-	register u_char color;
-	short height, width, bits, words;
-	int size, alloc;
-
-	size = par->crsr.height * par->crsr.width;
-	alloc = var->height * var->width;
-	var->height = par->crsr.height;
-	var->width = par->crsr.width;
-	var->xspot = par->crsr.spot_x;
-	var->yspot = par->crsr.spot_y;
-	if (size > var->height * var->width)
-		return -ENAMETOOLONG;
-	if (!access_ok(VERIFY_WRITE, data, size))
-		return -EFAULT;
-	delta = 1 << par->crsr.fmode;
-	lspr = lofsprite + (delta << 1);
-	if (par->bplcon0 & BPC0_LACE)
-		sspr = shfsprite + (delta << 1);
-	else
-		sspr = NULL;
-	for (height = (short)var->height - 1; height >= 0; height--) {
-		bits = 0; words = delta; datawords = 0;
-		for (width = (short)var->width - 1; width >= 0; width--) {
-			if (bits == 0) {
-				bits = 16; --words;
-#ifdef __mc68000__
-				asm volatile ("movew %1@(%3:w:2),%0 ; swap %0 ; movew %1@+,%0"
-					: "=d" (datawords), "=a" (lspr) : "1" (lspr), "d" (delta));
-#else
-				datawords = (*(lspr + delta) << 16) | (*lspr++);
-#endif
-			}
-			--bits;
-#ifdef __mc68000__
-			asm volatile (
-				"clrb %0 ; swap %1 ; lslw #1,%1 ; roxlb #1,%0 ; "
-				"swap %1 ; lslw #1,%1 ; roxlb #1,%0"
-				: "=d" (color), "=d" (datawords) : "1" (datawords));
-#else
-			color = (((datawords >> 30) & 2)
-				 | ((datawords >> 15) & 1));
-			datawords <<= 1;
-#endif
-			put_user(color, data++);
-		}
-		if (bits > 0) {
-			--words; ++lspr;
-		}
-		while (--words >= 0)
-			++lspr;
-#ifdef __mc68000__
-		asm volatile ("lea %0@(%4:w:2),%0 ; tstl %1 ; jeq 1f ; exg %0,%1\n1:"
-			: "=a" (lspr), "=a" (sspr) : "0" (lspr), "1" (sspr), "d" (delta));
-#else
-		lspr += delta;
-		if (sspr) {
-			u_short *tmp = lspr;
-			lspr = sspr;
-			sspr = tmp;
-		}
-#endif
-	}
-	return 0;
-}
-
-static int ami_set_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data)
-{
-	struct amifb_par *par = &currentpar;
-	register u_short *lspr, *sspr;
-#ifdef __mc68000__
-	register u_long datawords asm ("d2");
-#else
-	register u_long datawords;
-#endif
-	register short delta;
-	u_short fmode;
-	short height, width, bits, words;
-
-	if (!var->width)
-		return -EINVAL;
-	else if (var->width <= 16)
-		fmode = TAG_FMODE_1;
-	else if (var->width <= 32)
-		fmode = TAG_FMODE_2;
-	else if (var->width <= 64)
-		fmode = TAG_FMODE_4;
-	else
-		return -EINVAL;
-	if (fmode > maxfmode)
-		return -EINVAL;
-	if (!var->height)
-		return -EINVAL;
-	if (!access_ok(VERIFY_READ, data, var->width * var->height))
-		return -EFAULT;
-	delta = 1 << fmode;
-	lofsprite = shfsprite = (u_short *)spritememory;
-	lspr = lofsprite + (delta << 1);
-	if (par->bplcon0 & BPC0_LACE) {
-		if (((var->height + 4) << fmode << 2) > SPRITEMEMSIZE)
-			return -EINVAL;
-		memset(lspr, 0, (var->height + 4) << fmode << 2);
-		shfsprite += ((var->height + 5)&-2) << fmode;
-		sspr = shfsprite + (delta << 1);
-	} else {
-		if (((var->height + 2) << fmode << 2) > SPRITEMEMSIZE)
-			return -EINVAL;
-		memset(lspr, 0, (var->height + 2) << fmode << 2);
-		sspr = NULL;
-	}
-	for (height = (short)var->height - 1; height >= 0; height--) {
-		bits = 16; words = delta; datawords = 0;
-		for (width = (short)var->width - 1; width >= 0; width--) {
-			unsigned long tdata = 0;
-			get_user(tdata, data);
-			data++;
-#ifdef __mc68000__
-			asm volatile (
-				"lsrb #1,%2 ; roxlw #1,%0 ; swap %0 ; "
-				"lsrb #1,%2 ; roxlw #1,%0 ; swap %0"
-				: "=d" (datawords)
-				: "0" (datawords), "d" (tdata));
-#else
-			datawords = ((datawords << 1) & 0xfffefffe);
-			datawords |= tdata & 1;
-			datawords |= (tdata & 2) << (16 - 1);
-#endif
-			if (--bits == 0) {
-				bits = 16; --words;
-#ifdef __mc68000__
-				asm volatile ("swap %2 ; movew %2,%0@(%3:w:2) ; swap %2 ; movew %2,%0@+"
-					: "=a" (lspr) : "0" (lspr), "d" (datawords), "d" (delta));
-#else
-				*(lspr + delta) = (u_short) (datawords >> 16);
-				*lspr++ = (u_short) (datawords & 0xffff);
-#endif
-			}
-		}
-		if (bits < 16) {
-			--words;
-#ifdef __mc68000__
-			asm volatile (
-				"swap %2 ; lslw %4,%2 ; movew %2,%0@(%3:w:2) ; "
-				"swap %2 ; lslw %4,%2 ; movew %2,%0@+"
-				: "=a" (lspr) : "0" (lspr), "d" (datawords), "d" (delta), "d" (bits));
-#else
-			*(lspr + delta) = (u_short) (datawords >> (16 + bits));
-			*lspr++ = (u_short) ((datawords & 0x0000ffff) >> bits);
-#endif
-		}
-		while (--words >= 0) {
-#ifdef __mc68000__
-			asm volatile ("moveql #0,%%d0 ; movew %%d0,%0@(%2:w:2) ; movew %%d0,%0@+"
-				: "=a" (lspr) : "0" (lspr), "d" (delta) : "d0");
-#else
-			*(lspr + delta) = 0;
-			*lspr++ = 0;
-#endif
-		}
-#ifdef __mc68000__
-		asm volatile ("lea %0@(%4:w:2),%0 ; tstl %1 ; jeq 1f ; exg %0,%1\n1:"
-			: "=a" (lspr), "=a" (sspr) : "0" (lspr), "1" (sspr), "d" (delta));
-#else
-		lspr += delta;
-		if (sspr) {
-			u_short *tmp = lspr;
-			lspr = sspr;
-			sspr = tmp;
-		}
-#endif
-	}
-	par->crsr.height = var->height;
-	par->crsr.width = var->width;
-	par->crsr.spot_x = var->xspot;
-	par->crsr.spot_y = var->yspot;
-	par->crsr.fmode = fmode;
-	if (IS_AGA) {
-		par->fmode &= ~(FMODE_SPAGEM | FMODE_SPR32);
-		par->fmode |= sprfetchmode[fmode];
-		custom.fmode = par->fmode;
-	}
-	return 0;
-}
-
-static int ami_get_cursorstate(struct fb_cursorstate *state)
-{
-	struct amifb_par *par = &currentpar;
-
-	state->xoffset = par->crsr.crsr_x;
-	state->yoffset = par->crsr.crsr_y;
-	state->mode = cursormode;
-	return 0;
-}
-
-static int ami_set_cursorstate(struct fb_cursorstate *state)
-{
-	struct amifb_par *par = &currentpar;
-
-	par->crsr.crsr_x = state->xoffset;
-	par->crsr.crsr_y = state->yoffset;
-	if ((cursormode = state->mode) == FB_CURSOR_OFF)
-		cursorstate = -1;
-	do_cursor = 1;
-	return 0;
-}
-
-static void ami_set_sprite(void)
-{
-	struct amifb_par *par = &currentpar;
-	copins *copl, *cops;
-	u_short hs, vs, ve;
-	u_long pl, ps, pt;
-	short mx, my;
-
-	cops = copdisplay.list[currentcop][0];
-	copl = copdisplay.list[currentcop][1];
-	ps = pl = ZTWO_PADDR(dummysprite);
-	mx = par->crsr.crsr_x - par->crsr.spot_x;
-	my = par->crsr.crsr_y - par->crsr.spot_y;
-	if (!(par->vmode & FB_VMODE_YWRAP)) {
-		mx -= par->xoffset;
-		my -= par->yoffset;
-	}
-	if (!is_blanked && cursorstate > 0 && par->crsr.height > 0 &&
-	    mx > -(short)par->crsr.width && mx < par->xres &&
-	    my > -(short)par->crsr.height && my < par->yres) {
-		pl = ZTWO_PADDR(lofsprite);
-		hs = par->diwstrt_h + (mx << par->clk_shift) - 4;
-		vs = par->diwstrt_v + (my << par->line_shift);
-		ve = vs + (par->crsr.height << par->line_shift);
-		if (par->bplcon0 & BPC0_LACE) {
-			ps = ZTWO_PADDR(shfsprite);
-			lofsprite[0] = spr2hw_pos(vs, hs);
-			shfsprite[0] = spr2hw_pos(vs + 1, hs);
-			if (mod2(vs)) {
-				lofsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs, hs, ve);
-				shfsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs + 1, hs, ve + 1);
-				pt = pl; pl = ps; ps = pt;
-			} else {
-				lofsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs, hs, ve + 1);
-				shfsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs + 1, hs, ve);
-			}
-		} else {
-			lofsprite[0] = spr2hw_pos(vs, hs) | (IS_AGA && (par->fmode & FMODE_BSCAN2) ? 0x80 : 0);
-			lofsprite[1 << par->crsr.fmode] = spr2hw_ctl(vs, hs, ve);
-		}
-	}
-	copl[cop_spr0ptrh].w[1] = highw(pl);
-	copl[cop_spr0ptrl].w[1] = loww(pl);
-	if (par->bplcon0 & BPC0_LACE) {
-		cops[cop_spr0ptrh].w[1] = highw(ps);
-		cops[cop_spr0ptrl].w[1] = loww(ps);
-	}
-}
-
-
-	/*
-	 * Initialise the Copper Initialisation List
-	 */
-
-static void __init ami_init_copper(void)
-{
-	copins *cop = copdisplay.init;
-	u_long p;
-	int i;
-
-	if (!IS_OCS) {
-		(cop++)->l = CMOVE(BPC0_COLOR | BPC0_SHRES | BPC0_ECSENA, bplcon0);
-		(cop++)->l = CMOVE(0x0181, diwstrt);
-		(cop++)->l = CMOVE(0x0281, diwstop);
-		(cop++)->l = CMOVE(0x0000, diwhigh);
-	} else
-		(cop++)->l = CMOVE(BPC0_COLOR, bplcon0);
-	p = ZTWO_PADDR(dummysprite);
-	for (i = 0; i < 8; i++) {
-		(cop++)->l = CMOVE(0, spr[i].pos);
-		(cop++)->l = CMOVE(highw(p), sprpt[i]);
-		(cop++)->l = CMOVE2(loww(p), sprpt[i]);
-	}
-
-	(cop++)->l = CMOVE(IF_SETCLR | IF_COPER, intreq);
-	copdisplay.wait = cop;
-	(cop++)->l = CEND;
-	(cop++)->l = CMOVE(0, copjmp2);
-	cop->l = CEND;
-
-	custom.cop1lc = (u_short *)ZTWO_PADDR(copdisplay.init);
-	custom.copjmp1 = 0;
-}
-
-static void ami_reinit_copper(void)
-{
-	struct amifb_par *par = &currentpar;
-
-	copdisplay.init[cip_bplcon0].w[1] = ~(BPC0_BPU3 | BPC0_BPU2 | BPC0_BPU1 | BPC0_BPU0) & par->bplcon0;
-	copdisplay.wait->l = CWAIT(32, par->diwstrt_v - 4);
-}
-
-	/*
-	 * Build the Copper List
-	 */
-
-static void ami_build_copper(void)
-{
-	struct amifb_par *par = &currentpar;
-	copins *copl, *cops;
-	u_long p;
-
-	currentcop = 1 - currentcop;
-
-	copl = copdisplay.list[currentcop][1];
-
-	(copl++)->l = CWAIT(0, 10);
-	(copl++)->l = CMOVE(par->bplcon0, bplcon0);
-	(copl++)->l = CMOVE(0, sprpt[0]);
-	(copl++)->l = CMOVE2(0, sprpt[0]);
-
-	if (par->bplcon0 & BPC0_LACE) {
-		cops = copdisplay.list[currentcop][0];
-
-		(cops++)->l = CWAIT(0, 10);
-		(cops++)->l = CMOVE(par->bplcon0, bplcon0);
-		(cops++)->l = CMOVE(0, sprpt[0]);
-		(cops++)->l = CMOVE2(0, sprpt[0]);
-
-		(copl++)->l = CMOVE(diwstrt2hw(par->diwstrt_h, par->diwstrt_v + 1), diwstrt);
-		(copl++)->l = CMOVE(diwstop2hw(par->diwstop_h, par->diwstop_v + 1), diwstop);
-		(cops++)->l = CMOVE(diwstrt2hw(par->diwstrt_h, par->diwstrt_v), diwstrt);
-		(cops++)->l = CMOVE(diwstop2hw(par->diwstop_h, par->diwstop_v), diwstop);
-		if (!IS_OCS) {
-			(copl++)->l = CMOVE(diwhigh2hw(par->diwstrt_h, par->diwstrt_v + 1,
-					    par->diwstop_h, par->diwstop_v + 1), diwhigh);
-			(cops++)->l = CMOVE(diwhigh2hw(par->diwstrt_h, par->diwstrt_v,
-					    par->diwstop_h, par->diwstop_v), diwhigh);
-#if 0
-			if (par->beamcon0 & BMC0_VARBEAMEN) {
-				(copl++)->l = CMOVE(vtotal2hw(par->vtotal), vtotal);
-				(copl++)->l = CMOVE(vbstrt2hw(par->vbstrt + 1), vbstrt);
-				(copl++)->l = CMOVE(vbstop2hw(par->vbstop + 1), vbstop);
-				(cops++)->l = CMOVE(vtotal2hw(par->vtotal), vtotal);
-				(cops++)->l = CMOVE(vbstrt2hw(par->vbstrt), vbstrt);
-				(cops++)->l = CMOVE(vbstop2hw(par->vbstop), vbstop);
-			}
-#endif
-		}
-		p = ZTWO_PADDR(copdisplay.list[currentcop][0]);
-		(copl++)->l = CMOVE(highw(p), cop2lc);
-		(copl++)->l = CMOVE2(loww(p), cop2lc);
-		p = ZTWO_PADDR(copdisplay.list[currentcop][1]);
-		(cops++)->l = CMOVE(highw(p), cop2lc);
-		(cops++)->l = CMOVE2(loww(p), cop2lc);
-		copdisplay.rebuild[0] = cops;
-	} else {
-		(copl++)->l = CMOVE(diwstrt2hw(par->diwstrt_h, par->diwstrt_v), diwstrt);
-		(copl++)->l = CMOVE(diwstop2hw(par->diwstop_h, par->diwstop_v), diwstop);
-		if (!IS_OCS) {
-			(copl++)->l = CMOVE(diwhigh2hw(par->diwstrt_h, par->diwstrt_v,
-					    par->diwstop_h, par->diwstop_v), diwhigh);
-#if 0
-			if (par->beamcon0 & BMC0_VARBEAMEN) {
-				(copl++)->l = CMOVE(vtotal2hw(par->vtotal), vtotal);
-				(copl++)->l = CMOVE(vbstrt2hw(par->vbstrt), vbstrt);
-				(copl++)->l = CMOVE(vbstop2hw(par->vbstop), vbstop);
-			}
-#endif
-		}
-	}
-	copdisplay.rebuild[1] = copl;
-
-	ami_update_par();
-	ami_rebuild_copper();
-}
-
-	/*
-	 * Rebuild the Copper List
-	 *
-	 * We only change the things that are not static
-	 */
-
-static void ami_rebuild_copper(void)
-{
-	struct amifb_par *par = &currentpar;
-	copins *copl, *cops;
-	u_short line, h_end1, h_end2;
-	short i;
-	u_long p;
-
-	if (IS_AGA && maxfmode + par->clk_shift == 0)
-		h_end1 = par->diwstrt_h - 64;
-	else
-		h_end1 = par->htotal - 32;
-	h_end2 = par->ddfstop + 64;
-
-	ami_set_sprite();
-
-	copl = copdisplay.rebuild[1];
-	p = par->bplpt0;
-	if (par->vmode & FB_VMODE_YWRAP) {
-		if ((par->vyres - par->yoffset) != 1 || !mod2(par->diwstrt_v)) {
-			if (par->yoffset > par->vyres - par->yres) {
-				for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
-					(copl++)->l = CMOVE(highw(p), bplpt[i]);
-					(copl++)->l = CMOVE2(loww(p), bplpt[i]);
-				}
-				line = par->diwstrt_v + ((par->vyres - par->yoffset) << par->line_shift) - 1;
-				while (line >= 512) {
-					(copl++)->l = CWAIT(h_end1, 510);
-					line -= 512;
-				}
-				if (line >= 510 && IS_AGA && maxfmode + par->clk_shift == 0)
-					(copl++)->l = CWAIT(h_end1, line);
-				else
-					(copl++)->l = CWAIT(h_end2, line);
-				p = par->bplpt0wrap;
-			}
-		} else
-			p = par->bplpt0wrap;
-	}
-	for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
-		(copl++)->l = CMOVE(highw(p), bplpt[i]);
-		(copl++)->l = CMOVE2(loww(p), bplpt[i]);
-	}
-	copl->l = CEND;
-
-	if (par->bplcon0 & BPC0_LACE) {
-		cops = copdisplay.rebuild[0];
-		p = par->bplpt0;
-		if (mod2(par->diwstrt_v))
-			p -= par->next_line;
-		else
-			p += par->next_line;
-		if (par->vmode & FB_VMODE_YWRAP) {
-			if ((par->vyres - par->yoffset) != 1 || mod2(par->diwstrt_v)) {
-				if (par->yoffset > par->vyres - par->yres + 1) {
-					for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
-						(cops++)->l = CMOVE(highw(p), bplpt[i]);
-						(cops++)->l = CMOVE2(loww(p), bplpt[i]);
-					}
-					line = par->diwstrt_v + ((par->vyres - par->yoffset) << par->line_shift) - 2;
-					while (line >= 512) {
-						(cops++)->l = CWAIT(h_end1, 510);
-						line -= 512;
-					}
-					if (line > 510 && IS_AGA && maxfmode + par->clk_shift == 0)
-						(cops++)->l = CWAIT(h_end1, line);
-					else
-						(cops++)->l = CWAIT(h_end2, line);
-					p = par->bplpt0wrap;
-					if (mod2(par->diwstrt_v + par->vyres -
-					    par->yoffset))
-						p -= par->next_line;
-					else
-						p += par->next_line;
-				}
-			} else
-				p = par->bplpt0wrap - par->next_line;
-		}
-		for (i = 0; i < (short)par->bpp; i++, p += par->next_plane) {
-			(cops++)->l = CMOVE(highw(p), bplpt[i]);
-			(cops++)->l = CMOVE2(loww(p), bplpt[i]);
-		}
-		cops->l = CEND;
-	}
-}
 
 static int __exit amifb_remove(struct platform_device *pdev)
 {
-- 
1.7.0.4

