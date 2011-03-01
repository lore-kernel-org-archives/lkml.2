Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab1CATSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:18:45 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53234 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757134Ab1CATSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:18:43 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH 4/5]: s3fb: enable DTPC
Date: Tue, 1 Mar 2011 20:18:35 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103012018.37764.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Data Transfer Position Control (DTPC). This is needed at least on
Virge/DX to correctly display at higher pixclocks.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.38-rc4-/drivers/video/s3fb.c	2011-02-28 17:28:27.000000000 +0100
+++ linux-2.6.38-rc4/drivers/video/s3fb.c	2011-02-28 18:53:00.000000000 +0100
@@ -126,6 +126,8 @@
 static const struct vga_regset s3_start_address_regs[]  = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x31, 4, 5}, {0x51, 0, 1}, VGA_REGSET_END};
 static const struct vga_regset s3_offset_regs[]         = {{0x13, 0, 7}, {0x51, 4, 5}, VGA_REGSET_END}; /* set 0x43 bit 2 to 0 */
 
+static const struct vga_regset s3_dtpc_regs[]		= {{0x3B, 0, 7}, {0x5D, 6, 6}, VGA_REGSET_END};
+
 static const struct svga_timing_regs s3_timing_regs     = {
 	s3_h_total_regs, s3_h_display_regs, s3_h_blank_start_regs,
 	s3_h_blank_end_regs, s3_h_sync_start_regs, s3_h_sync_end_regs,
@@ -485,6 +487,7 @@
 	struct s3fb_info *par = info->par;
 	u32 value, mode, hmul, offset_value, screen_size, multiplex, dbytes;
 	u32 bpp = info->var.bits_per_pixel;
+	u32 htotal, hsstart;
 
 	if (bpp != 0) {
 		info->fix.ypanstep = 1;
@@ -604,7 +607,9 @@
 	if (par->chip == CHIP_360_TRIO3D_1X ||
 	    par->chip == CHIP_362_TRIO3D_2X ||
 	    par->chip == CHIP_368_TRIO3D_2X ||
-	    par->chip == CHIP_365_TRIO3D) {
+	    par->chip == CHIP_365_TRIO3D    ||
+	    par->chip == CHIP_375_VIRGE_DX  ||
+	    par->chip == CHIP_385_VIRGE_GX) {
 		dbytes = info->var.xres * ((bpp+7)/8);
 		vga_wcrt(par->state.vgabase, 0x91, (dbytes + 7) / 8);
 		vga_wcrt(par->state.vgabase, 0x90, (((dbytes + 7) / 8) >> 8) | 0x80);
@@ -612,6 +617,16 @@
 		vga_wcrt(par->state.vgabase, 0x66, 0x81);
 	}
 
+	if (par->chip == CHIP_356_VIRGE_GX2  ||
+	    par->chip == CHIP_357_VIRGE_GX2P ||
+	    par->chip == CHIP_359_VIRGE_GX2P ||
+	    par->chip == CHIP_360_TRIO3D_1X ||
+	    par->chip == CHIP_362_TRIO3D_2X ||
+	    par->chip == CHIP_368_TRIO3D_2X)
+		vga_wcrt(par->state.vgabase, 0x34, 0x00);
+	else	/* enable Data Transfer Position Control (DTPC) */
+		vga_wcrt(par->state.vgabase, 0x34, 0x10);
+
 	svga_wcrt_mask(par->state.vgabase, 0x31, 0x00, 0x40);
 	multiplex = 0;
 	hmul = 1;
@@ -745,9 +760,14 @@
 			 hmul, info->node);
 
 	/* Set interlaced mode start/end register */
-	value = info->var.xres + info->var.left_margin + info->var.right_margin + info->var.hsync_len;
-	value = ((value * hmul) / 8) - 5;
-	vga_wcrt(par->state.vgabase, 0x3C, (value + 1) / 2);
+	htotal = info->var.xres + info->var.left_margin + info->var.right_margin + info->var.hsync_len;
+	htotal = ((htotal * hmul) / 8) - 5;
+	vga_wcrt(par->state.vgabase, 0x3C, (htotal + 1) / 2);
+
+	/* Set Data Transfer Position */
+	hsstart = ((info->var.xres + info->var.right_margin) * hmul) / 8;
+	value = clamp((htotal + hsstart + 1) / 2, hsstart + 4, htotal + 1);
+	svga_wcrt_multi(par->state.vgabase, s3_dtpc_regs, value);
 
 	memset_io(info->screen_base, 0x00, screen_size);
 	/* Device and screen back on */

-- 
Ondrej Zary
