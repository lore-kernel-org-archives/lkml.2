Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1KUUze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:55:34 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:33892 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab1KUUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 8/8] fbdev/amifb: Use framebuffer_alloc()
Date: Mon, 21 Nov 2011 21:53:59 +0100
Message-Id: <1321908839-11419-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
References: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use framebuffer_alloc() instead of static fb_info and currentpar variables.
Also sanitize the error path and cleanup code (e.g. missing free_irq()).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c |  286 +++++++++++++++++++++++++------------------------
 1 files changed, 146 insertions(+), 140 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 2bfaf1b..f23cae0 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -710,7 +710,7 @@ static u_short *lofsprite, *shfsprite, *dummysprite;
 	 * Current Video Mode
 	 */
 
-static struct amifb_par {
+struct amifb_par {
 
 	/* General Values */
 
@@ -773,15 +773,6 @@ static struct amifb_par {
 	/* Additional AGA Hardware Registers */
 
 	u_short fmode;		/* vmode */
-} currentpar;
-
-
-static struct fb_info fb_info = {
-	.fix = {
-		.id		= "Amiga ",
-		.visual		= FB_VISUAL_PSEUDOCOLOR,
-		.accel		= FB_ACCEL_AMIGABLITT
-	}
 };
 
 
@@ -1130,8 +1121,8 @@ static u_short sprfetchmode[3] = {
 	 * it up, if it's too big, return -EINVAL.
 	 */
 
-static int ami_decode_var(struct fb_var_screeninfo *var,
-			  struct amifb_par *par)
+static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
+			  const struct fb_info *info)
 {
 	u_short clk_shift, line_shift;
 	u_long maxfetchstop, fstrt, fsize, fconst, xres_n, yres_n;
@@ -1449,14 +1440,14 @@ static int ami_decode_var(struct fb_var_screeninfo *var,
 	if (amifb_ilbm) {
 		par->next_plane = div8(upx(16 << maxfmode, par->vxres));
 		par->next_line = par->bpp * par->next_plane;
-		if (par->next_line * par->vyres > fb_info.fix.smem_len) {
+		if (par->next_line * par->vyres > info->fix.smem_len) {
 			DPRINTK("too few video mem\n");
 			return -EINVAL;
 		}
 	} else {
 		par->next_line = div8(upx(16 << maxfmode, par->vxres));
 		par->next_plane = par->vyres * par->next_line;
-		if (par->next_plane * par->bpp > fb_info.fix.smem_len) {
+		if (par->next_plane * par->bpp > info->fix.smem_len) {
 			DPRINTK("too few video mem\n");
 			return -EINVAL;
 		}
@@ -1519,8 +1510,8 @@ static int ami_decode_var(struct fb_var_screeninfo *var,
 	 * other values read out of the hardware.
 	 */
 
-static int ami_encode_var(struct fb_var_screeninfo *var,
-			  struct amifb_par *par)
+static void ami_encode_var(struct fb_var_screeninfo *var,
+			   struct amifb_par *par)
 {
 	u_short clk_shift, line_shift;
 
@@ -1596,8 +1587,6 @@ static int ami_encode_var(struct fb_var_screeninfo *var,
 		var->sync |= FB_SYNC_EXT;
 	if (par->vmode & FB_VMODE_YWRAP)
 		var->vmode |= FB_VMODE_YWRAP;
-
-	return 0;
 }
 
 
@@ -1605,9 +1594,9 @@ static int ami_encode_var(struct fb_var_screeninfo *var,
 	 * Update hardware
 	 */
 
-static int ami_update_par(void)
+static void ami_update_par(struct fb_info *info)
 {
-	struct amifb_par *par = &currentpar;
+	struct amifb_par *par = info->par;
 	short clk_shift, vshift, fstrt, fsize, fstop, fconst,  shift, move, mod;
 
 	clk_shift = par->clk_shift;
@@ -1649,11 +1638,11 @@ static int ami_update_par(void)
 		par->bpl1mod = par->bpl2mod;
 
 	if (par->yoffset) {
-		par->bplpt0 = fb_info.fix.smem_start +
+		par->bplpt0 = info->fix.smem_start +
 			      par->next_line * par->yoffset + move;
 		if (par->vmode & FB_VMODE_YWRAP) {
 			if (par->yoffset > par->vyres - par->yres) {
-				par->bplpt0wrap = fb_info.fix.smem_start + move;
+				par->bplpt0wrap = info->fix.smem_start + move;
 				if (par->bplcon0 & BPC0_LACE &&
 				    mod2(par->diwstrt_v + par->vyres -
 					 par->yoffset))
@@ -1661,12 +1650,10 @@ static int ami_update_par(void)
 			}
 		}
 	} else
-		par->bplpt0 = fb_info.fix.smem_start + move;
+		par->bplpt0 = info->fix.smem_start + move;
 
 	if (par->bplcon0 & BPC0_LACE && mod2(par->diwstrt_v))
 		par->bplpt0 += par->next_line;
-
-	return 0;
 }
 
 
@@ -1677,9 +1664,9 @@ static int ami_update_par(void)
 	 * in `var'.
 	 */
 
-static void ami_pan_var(struct fb_var_screeninfo *var)
+static void ami_pan_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	struct amifb_par *par = &currentpar;
+	struct amifb_par *par = info->par;
 
 	par->xoffset = var->xoffset;
 	par->yoffset = var->yoffset;
@@ -1689,15 +1676,13 @@ static void ami_pan_var(struct fb_var_screeninfo *var)
 		par->vmode &= ~FB_VMODE_YWRAP;
 
 	do_vmode_pan = 0;
-	ami_update_par();
+	ami_update_par(info);
 	do_vmode_pan = 1;
 }
 
 
-static void ami_update_display(void)
+static void ami_update_display(const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
-
 	custom.bplcon1 = par->bplcon1;
 	custom.bpl1mod = par->bpl1mod;
 	custom.bpl2mod = par->bpl2mod;
@@ -1709,9 +1694,8 @@ static void ami_update_display(void)
 	 * Change the video mode (called by VBlank interrupt)
 	 */
 
-static void ami_init_display(void)
+static void ami_init_display(const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
 	int i;
 
 	custom.bplcon0 = par->bplcon0 & ~BPC0_LACE;
@@ -1764,9 +1748,8 @@ static void ami_init_display(void)
 	 * (Un)Blank the screen (called by VBlank interrupt)
 	 */
 
-static void ami_do_blank(void)
+static void ami_do_blank(const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
 #if defined(CONFIG_FB_AMIGA_AGA)
 	u_short bplcon3 = par->bplcon3;
 #endif
@@ -1843,10 +1826,9 @@ static void ami_do_blank(void)
 	is_blanked = do_blank > 0 ? do_blank : 0;
 }
 
-static int ami_get_fix_cursorinfo(struct fb_fix_cursorinfo *fix)
+static int ami_get_fix_cursorinfo(struct fb_fix_cursorinfo *fix,
+				  const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
-
 	fix->crsr_width = fix->crsr_xsize = par->crsr.width;
 	fix->crsr_height = fix->crsr_ysize = par->crsr.height;
 	fix->crsr_color1 = 17;
@@ -1854,9 +1836,10 @@ static int ami_get_fix_cursorinfo(struct fb_fix_cursorinfo *fix)
 	return 0;
 }
 
-static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data)
+static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var,
+				  u_char __user *data,
+				  const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
 	register u_short *lspr, *sspr;
 #ifdef __mc68000__
 	register u_long datawords asm ("d2");
@@ -1929,9 +1912,9 @@ static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *
 	return 0;
 }
 
-static int ami_set_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *data)
+static int ami_set_var_cursorinfo(struct fb_var_cursorinfo *var,
+				  u_char __user *data, struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
 	register u_short *lspr, *sspr;
 #ifdef __mc68000__
 	register u_long datawords asm ("d2");
@@ -2047,20 +2030,18 @@ static int ami_set_var_cursorinfo(struct fb_var_cursorinfo *var, u_char __user *
 	return 0;
 }
 
-static int ami_get_cursorstate(struct fb_cursorstate *state)
+static int ami_get_cursorstate(struct fb_cursorstate *state,
+			       const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
-
 	state->xoffset = par->crsr.crsr_x;
 	state->yoffset = par->crsr.crsr_y;
 	state->mode = cursormode;
 	return 0;
 }
 
-static int ami_set_cursorstate(struct fb_cursorstate *state)
+static int ami_set_cursorstate(struct fb_cursorstate *state,
+			       struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
-
 	par->crsr.crsr_x = state->xoffset;
 	par->crsr.crsr_y = state->yoffset;
 	if ((cursormode = state->mode) == FB_CURSOR_OFF)
@@ -2069,9 +2050,8 @@ static int ami_set_cursorstate(struct fb_cursorstate *state)
 	return 0;
 }
 
-static void ami_set_sprite(void)
+static void ami_set_sprite(const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
 	copins *copl, *cops;
 	u_short hs, vs, ve;
 	u_long pl, ps, pt;
@@ -2153,10 +2133,8 @@ static void __init ami_init_copper(void)
 	custom.copjmp1 = 0;
 }
 
-static void ami_reinit_copper(void)
+static void ami_reinit_copper(const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
-
 	copdisplay.init[cip_bplcon0].w[1] = ~(BPC0_BPU3 | BPC0_BPU2 | BPC0_BPU1 | BPC0_BPU0) & par->bplcon0;
 	copdisplay.wait->l = CWAIT(32, par->diwstrt_v - 4);
 }
@@ -2168,9 +2146,8 @@ static void ami_reinit_copper(void)
 	 * We only change the things that are not static
 	 */
 
-static void ami_rebuild_copper(void)
+static void ami_rebuild_copper(const struct amifb_par *par)
 {
-	struct amifb_par *par = &currentpar;
 	copins *copl, *cops;
 	u_short line, h_end1, h_end2;
 	short i;
@@ -2182,7 +2159,7 @@ static void ami_rebuild_copper(void)
 		h_end1 = par->htotal - 32;
 	h_end2 = par->ddfstop + 64;
 
-	ami_set_sprite();
+	ami_set_sprite(par);
 
 	copl = copdisplay.rebuild[1];
 	p = par->bplpt0;
@@ -2259,9 +2236,9 @@ static void ami_rebuild_copper(void)
 	 * Build the Copper List
 	 */
 
-static void ami_build_copper(void)
+static void ami_build_copper(struct fb_info *info)
 {
-	struct amifb_par *par = &currentpar;
+	struct amifb_par *par = info->par;
 	copins *copl, *cops;
 	u_long p;
 
@@ -2326,8 +2303,8 @@ static void ami_build_copper(void)
 	}
 	copdisplay.rebuild[1] = copl;
 
-	ami_update_par();
-	ami_rebuild_copper();
+	ami_update_par(info);
+	ami_rebuild_copper(info->par);
 }
 
 
@@ -2405,7 +2382,8 @@ static int amifb_check_var(struct fb_var_screeninfo *var,
 	struct amifb_par par;
 
 	/* Validate wanted screen parameters */
-	if ((err = ami_decode_var(var, &par)))
+	err = ami_decode_var(var, &par, info);
+	if (err)
 		return err;
 
 	/* Encode (possibly rounded) screen parameters */
@@ -2417,15 +2395,18 @@ static int amifb_check_var(struct fb_var_screeninfo *var,
 static int amifb_set_par(struct fb_info *info)
 {
 	struct amifb_par *par = info->par;
+	int error;
 
 	do_vmode_pan = 0;
 	do_vmode_full = 0;
 
 	/* Decode wanted screen parameters */
-	ami_decode_var(&info->var, par);
+	error = ami_decode_var(&info->var, par, info);
+	if (error)
+		return error;
 
 	/* Set new videomode */
-	ami_build_copper();
+	ami_build_copper(info);
 
 	/* Set VBlank trigger */
 	do_vmode_full = 1;
@@ -2471,10 +2452,12 @@ static int amifb_set_par(struct fb_info *info)
 static int amifb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 			   u_int transp, struct fb_info *info)
 {
+	const struct amifb_par *par = info->par;
+
 	if (IS_AGA) {
 		if (regno > 255)
 			return 1;
-	} else if (currentpar.bplcon0 & BPC0_SHRES) {
+	} else if (par->bplcon0 & BPC0_SHRES) {
 		if (regno > 3)
 			return 1;
 	} else {
@@ -2501,7 +2484,7 @@ static int amifb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 	if (regno || !is_blanked) {
 #if defined(CONFIG_FB_AMIGA_AGA)
 		if (IS_AGA) {
-			u_short bplcon3 = currentpar.bplcon3;
+			u_short bplcon3 = par->bplcon3;
 			VBlankOff();
 			custom.bplcon3 = bplcon3 | (regno << 8 & 0xe000);
 			custom.color[regno & 31] = rgb2hw8_high(red, green,
@@ -2515,7 +2498,7 @@ static int amifb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 		} else
 #endif
 #if defined(CONFIG_FB_AMIGA_ECS)
-		if (currentpar.bplcon0 & BPC0_SHRES) {
+		if (par->bplcon0 & BPC0_SHRES) {
 			u_short color, mask;
 			int i;
 
@@ -2572,7 +2555,7 @@ static int amifb_pan_display(struct fb_var_screeninfo *var,
 		    var->yoffset + info->var.yres > info->var.yres_virtual)
 			return -EINVAL;
 	}
-	ami_pan_var(var);
+	ami_pan_var(var, info);
 	info->var.xoffset = var->xoffset;
 	info->var.yoffset = var->yoffset;
 	if (var->vmode & FB_VMODE_YWRAP)
@@ -3418,7 +3401,7 @@ static int amifb_ioctl(struct fb_info *info,
 
 	switch (cmd) {
 	case FBIOGET_FCURSORINFO:
-		i = ami_get_fix_cursorinfo(&crsr.fix);
+		i = ami_get_fix_cursorinfo(&crsr.fix, info->par);
 		if (i)
 			return i;
 		return copy_to_user(argp, &crsr.fix,
@@ -3426,7 +3409,8 @@ static int amifb_ioctl(struct fb_info *info,
 
 	case FBIOGET_VCURSORINFO:
 		i = ami_get_var_cursorinfo(&crsr.var,
-			((struct fb_var_cursorinfo __user *)arg)->data);
+			((struct fb_var_cursorinfo __user *)arg)->data,
+			info->par);
 		if (i)
 			return i;
 		return copy_to_user(argp, &crsr.var,
@@ -3436,10 +3420,11 @@ static int amifb_ioctl(struct fb_info *info,
 		if (copy_from_user(&crsr.var, argp, sizeof(crsr.var)))
 			return -EFAULT;
 		return ami_set_var_cursorinfo(&crsr.var,
-			((struct fb_var_cursorinfo __user *)arg)->data);
+			((struct fb_var_cursorinfo __user *)arg)->data,
+			info->par);
 
 	case FBIOGET_CURSORSTATE:
-		i = ami_get_cursorstate(&crsr.state);
+		i = ami_get_cursorstate(&crsr.state, info->par);
 		if (i)
 			return i;
 		return copy_to_user(argp, &crsr.state,
@@ -3448,7 +3433,7 @@ static int amifb_ioctl(struct fb_info *info,
 	case FBIOPUT_CURSORSTATE:
 		if (copy_from_user(&crsr.state, argp, sizeof(crsr.state)))
 			return -EFAULT;
-		return ami_set_cursorstate(&crsr.state);
+		return ami_set_cursorstate(&crsr.state, info->par);
 	}
 	return -EINVAL;
 }
@@ -3479,32 +3464,34 @@ static int flash_cursor(void)
 
 static irqreturn_t amifb_interrupt(int irq, void *dev_id)
 {
+	struct amifb_par *par = dev_id;
+
 	if (do_vmode_pan || do_vmode_full)
-		ami_update_display();
+		ami_update_display(par);
 
 	if (do_vmode_full)
-		ami_init_display();
+		ami_init_display(par);
 
 	if (do_vmode_pan) {
 		flash_cursor();
-		ami_rebuild_copper();
+		ami_rebuild_copper(par);
 		do_cursor = do_vmode_pan = 0;
 	} else if (do_cursor) {
 		flash_cursor();
-		ami_set_sprite();
+		ami_set_sprite(par);
 		do_cursor = 0;
 	} else {
 		if (flash_cursor())
-			ami_set_sprite();
+			ami_set_sprite(par);
 	}
 
 	if (do_blank) {
-		ami_do_blank();
+		ami_do_blank(par);
 		do_blank = 0;
 	}
 
 	if (do_vmode_full) {
-		ami_reinit_copper();
+		ami_reinit_copper(par);
 		do_vmode_full = 0;
 	}
 	return IRQ_HANDLED;
@@ -3549,23 +3536,13 @@ static inline void chipfree(void)
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
 	/*
 	 * Initialisation
 	 */
 
 static int __init amifb_probe(struct platform_device *pdev)
 {
+	struct fb_info *info;
 	int tag, i, err = 0;
 	u_long chipptr;
 	u_int defmode;
@@ -3581,10 +3558,20 @@ static int __init amifb_probe(struct platform_device *pdev)
 #endif
 	custom.dmacon = DMAF_ALL | DMAF_MASTER;
 
+	info = framebuffer_alloc(sizeof(struct amifb_par), &pdev->dev);
+	if (!info) {
+		dev_err(&pdev->dev, "framebuffer_alloc failed\n");
+		return -ENOMEM;
+	}
+
+	strcpy(info->fix.id, "Amiga ");
+	info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+	info->fix.accel = FB_ACCEL_AMIGABLITT;
+
 	switch (amiga_chipset) {
 #ifdef CONFIG_FB_AMIGA_OCS
 	case CS_OCS:
-		strcat(fb_info.fix.id, "OCS");
+		strcat(info->fix.id, "OCS");
 default_chipset:
 		chipset = TAG_OCS;
 		maxdepth[TAG_SHRES] = 0;	/* OCS means no SHRES */
@@ -3592,13 +3579,13 @@ default_chipset:
 		maxdepth[TAG_LORES] = 6;
 		maxfmode = TAG_FMODE_1;
 		defmode = amiga_vblank == 50 ? DEFMODE_PAL : DEFMODE_NTSC;
-		fb_info.fix.smem_len = VIDEOMEMSIZE_OCS;
+		info->fix.smem_len = VIDEOMEMSIZE_OCS;
 		break;
 #endif /* CONFIG_FB_AMIGA_OCS */
 
 #ifdef CONFIG_FB_AMIGA_ECS
 	case CS_ECS:
-		strcat(fb_info.fix.id, "ECS");
+		strcat(info->fix.id, "ECS");
 		chipset = TAG_ECS;
 		maxdepth[TAG_SHRES] = 2;
 		maxdepth[TAG_HIRES] = 4;
@@ -3612,15 +3599,15 @@ default_chipset:
 						     : DEFMODE_NTSC;
 		if (amiga_chip_avail() - CHIPRAM_SAFETY_LIMIT >
 		    VIDEOMEMSIZE_ECS_2M)
-			fb_info.fix.smem_len = VIDEOMEMSIZE_ECS_2M;
+			info->fix.smem_len = VIDEOMEMSIZE_ECS_2M;
 		else
-			fb_info.fix.smem_len = VIDEOMEMSIZE_ECS_1M;
+			info->fix.smem_len = VIDEOMEMSIZE_ECS_1M;
 		break;
 #endif /* CONFIG_FB_AMIGA_ECS */
 
 #ifdef CONFIG_FB_AMIGA_AGA
 	case CS_AGA:
-		strcat(fb_info.fix.id, "AGA");
+		strcat(info->fix.id, "AGA");
 		chipset = TAG_AGA;
 		maxdepth[TAG_SHRES] = 8;
 		maxdepth[TAG_HIRES] = 8;
@@ -3629,20 +3616,20 @@ default_chipset:
 		defmode = DEFMODE_AGA;
 		if (amiga_chip_avail() - CHIPRAM_SAFETY_LIMIT >
 		    VIDEOMEMSIZE_AGA_2M)
-			fb_info.fix.smem_len = VIDEOMEMSIZE_AGA_2M;
+			info->fix.smem_len = VIDEOMEMSIZE_AGA_2M;
 		else
-			fb_info.fix.smem_len = VIDEOMEMSIZE_AGA_1M;
+			info->fix.smem_len = VIDEOMEMSIZE_AGA_1M;
 		break;
 #endif /* CONFIG_FB_AMIGA_AGA */
 
 	default:
 #ifdef CONFIG_FB_AMIGA_OCS
 		printk("Unknown graphics chipset, defaulting to OCS\n");
-		strcat(fb_info.fix.id, "Unknown");
+		strcat(info->fix.id, "Unknown");
 		goto default_chipset;
 #else /* CONFIG_FB_AMIGA_OCS */
 		err = -ENODEV;
-		goto amifb_error;
+		goto release;
 #endif /* CONFIG_FB_AMIGA_OCS */
 		break;
 	}
@@ -3672,44 +3659,43 @@ default_chipset:
 	}
 
 	if (amifb_hfmin) {
-		fb_info.monspecs.hfmin = amifb_hfmin;
-		fb_info.monspecs.hfmax = amifb_hfmax;
-		fb_info.monspecs.vfmin = amifb_vfmin;
-		fb_info.monspecs.vfmax = amifb_vfmax;
+		info->monspecs.hfmin = amifb_hfmin;
+		info->monspecs.hfmax = amifb_hfmax;
+		info->monspecs.vfmin = amifb_vfmin;
+		info->monspecs.vfmax = amifb_vfmax;
 	} else {
 		/*
 		 *  These are for a typical Amiga monitor (e.g. A1960)
 		 */
-		fb_info.monspecs.hfmin = 15000;
-		fb_info.monspecs.hfmax = 38000;
-		fb_info.monspecs.vfmin = 49;
-		fb_info.monspecs.vfmax = 90;
+		info->monspecs.hfmin = 15000;
+		info->monspecs.hfmax = 38000;
+		info->monspecs.vfmin = 49;
+		info->monspecs.vfmax = 90;
 	}
 
-	fb_info.fbops = &amifb_ops;
-	fb_info.par = &currentpar;
-	fb_info.flags = FBINFO_DEFAULT;
-	fb_info.device = &pdev->dev;
+	info->fbops = &amifb_ops;
+	info->flags = FBINFO_DEFAULT;
+	info->device = &pdev->dev;
 
-	if (!fb_find_mode(&fb_info.var, &fb_info, mode_option, ami_modedb,
+	if (!fb_find_mode(&info->var, info, mode_option, ami_modedb,
 			  NUM_TOTAL_MODES, &ami_modedb[defmode], 4)) {
 		err = -EINVAL;
-		goto amifb_error;
+		goto release;
 	}
 
 	fb_videomode_to_modelist(ami_modedb, NUM_TOTAL_MODES,
-				 &fb_info.modelist);
+				 &info->modelist);
 
 	round_down_bpp = 0;
-	chipptr = chipalloc(fb_info.fix.smem_len + SPRITEMEMSIZE +
+	chipptr = chipalloc(info->fix.smem_len + SPRITEMEMSIZE +
 			    DUMMYSPRITEMEMSIZE + COPINITSIZE +
 			    4 * COPLISTSIZE);
 	if (!chipptr) {
 		err = -ENOMEM;
-		goto amifb_error;
+		goto release;
 	}
 
-	assignchunk(videomemory, u_long, chipptr, fb_info.fix.smem_len);
+	assignchunk(videomemory, u_long, chipptr, info->fix.smem_len);
 	assignchunk(spritememory, u_long, chipptr, SPRITEMEMSIZE);
 	assignchunk(dummysprite, u_short *, chipptr, DUMMYSPRITEMEMSIZE);
 	assignchunk(copdisplay.init, copins *, chipptr, COPINITSIZE);
@@ -3721,14 +3707,15 @@ default_chipset:
 	/*
 	 * access the videomem with writethrough cache
 	 */
-	fb_info.fix.smem_start = (u_long)ZTWO_PADDR(videomemory);
-	videomemory = (u_long)ioremap_writethrough(fb_info.fix.smem_start,
-						   fb_info.fix.smem_len);
+	info->fix.smem_start = (u_long)ZTWO_PADDR(videomemory);
+	videomemory = (u_long)ioremap_writethrough(info->fix.smem_start,
+						   info->fix.smem_len);
 	if (!videomemory) {
-		printk("amifb: WARNING! unable to map videomem cached writethrough\n");
-		fb_info.screen_base = (char *)ZTWO_VADDR(fb_info.fix.smem_start);
+		dev_warn(&pdev->dev,
+			 "Unable to map videomem cached writethrough\n");
+		info->screen_base = (char *)ZTWO_VADDR(info->fix.smem_start);
 	} else
-		fb_info.screen_base = (char *)videomemory;
+		info->screen_base = (char *)videomemory;
 
 	memset(dummysprite, 0, DUMMYSPRITEMEMSIZE);
 
@@ -3743,36 +3730,55 @@ default_chipset:
 	custom.dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER |
 			DMAF_BLITTER | DMAF_SPRITE;
 
-	if (request_irq(IRQ_AMIGA_COPPER, amifb_interrupt, 0,
-			"fb vertb handler", &currentpar)) {
-		err = -EBUSY;
-		goto amifb_error;
-	}
+	err = request_irq(IRQ_AMIGA_COPPER, amifb_interrupt, 0,
+			  "fb vertb handler", info->par);
+	if (err)
+		goto disable_dma;
 
-	err = fb_alloc_cmap(&fb_info.cmap, 1 << fb_info.var.bits_per_pixel, 0);
+	err = fb_alloc_cmap(&info->cmap, 1 << info->var.bits_per_pixel, 0);
 	if (err)
-		goto amifb_error;
+		goto free_irq;
 
-	if (register_framebuffer(&fb_info) < 0) {
-		err = -EINVAL;
-		goto amifb_error;
-	}
+	dev_set_drvdata(&pdev->dev, info);
+
+	err = register_framebuffer(info);
+	if (err)
+		goto unset_drvdata;
 
 	printk("fb%d: %s frame buffer device, using %dK of video memory\n",
-	       fb_info.node, fb_info.fix.id, fb_info.fix.smem_len>>10);
+	       info->node, info->fix.id, info->fix.smem_len>>10);
 
 	return 0;
 
-amifb_error:
-	amifb_deinit(pdev);
+unset_drvdata:
+	dev_set_drvdata(&pdev->dev, NULL);
+	fb_dealloc_cmap(&info->cmap);
+free_irq:
+	free_irq(IRQ_AMIGA_COPPER, info->par);
+disable_dma:
+	custom.dmacon = DMAF_ALL | DMAF_MASTER;
+	if (videomemory)
+		iounmap((void *)videomemory);
+	chipfree();
+release:
+	framebuffer_release(info);
 	return err;
 }
 
 
 static int __exit amifb_remove(struct platform_device *pdev)
 {
-	unregister_framebuffer(&fb_info);
-	amifb_deinit(pdev);
+	struct fb_info *info = dev_get_drvdata(&pdev->dev);
+
+	unregister_framebuffer(info);
+	dev_set_drvdata(&pdev->dev, NULL);
+	fb_dealloc_cmap(&info->cmap);
+	free_irq(IRQ_AMIGA_COPPER, info->par);
+	custom.dmacon = DMAF_ALL | DMAF_MASTER;
+	if (videomemory)
+		iounmap((void *)videomemory);
+	chipfree();
+	framebuffer_release(info);
 	amifb_video_off();
 	return 0;
 }
-- 
1.7.0.4

