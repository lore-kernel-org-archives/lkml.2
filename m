Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2AWXS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:18:26 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:58622 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2AWXSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:18:23 -0500
To: linux-fbdev@vger.kernel.org
Subject: [PATCH v5] Resurrect Intel740 driver: i740fb
Cc: Andrey Ulanov <drey@rt.mipt.ru>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 24 Jan 2012 00:17:18 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201240017.23975.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resurrection of an old (like 2.4.19) out-of-tree driver for
Intel740 graphics cards and adaptation for recent kernels. The old driver by
Andrey Ulanov is located at: http://sourceforge.net/projects/i740fbdev/files/

This is a new driver based on skeletonfb, using most of the low level HW code
from the old driver. The DDC code is completely new.

The driver was tested on two 8MB cards: Protac AG240D and Diamond Stealth II
G460.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
Changes in v5:
 - fixed checkpatch problems
 - added Kconfig dependency on FB_DDC
 - cleaned up i740_calc_vclk()
 - fixed SDRAM/SGRAM detection
 - fixed wrong colors in 16bpp mode when neither 555 nor 565 specified

--- linux-3.2.1-orig/drivers/video/Kconfig	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1/drivers/video/Kconfig	2012-01-23 20:52:32.000000000 +0100
@@ -1123,6 +1123,18 @@ config FB_RIVA_BACKLIGHT
 	help
 	  Say Y here if you want to control the backlight of your display.
 
+config FB_I740
+	tristate "Intel740 support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && FB && PCI
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VGASTATE
+	select FB_DDC
+	help
+	  This driver supports graphics cards based on Intel740 chip.
+
 config FB_I810
 	tristate "Intel 810/815 support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && FB && PCI && X86_32 && AGP_INTEL
--- linux-3.2.1-orig/drivers/video/Makefile	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1/drivers/video/Makefile	2012-01-23 20:52:32.000000000 +0100
@@ -37,6 +37,7 @@ obj-$(CONFIG_FB_GRVGA)            += grv
 obj-$(CONFIG_FB_PM2)              += pm2fb.o
 obj-$(CONFIG_FB_PM3)		  += pm3fb.o
 
+obj-$(CONFIG_FB_I740)		  += i740fb.o
 obj-$(CONFIG_FB_MATROX)		  += matrox/
 obj-$(CONFIG_FB_RIVA)		  += riva/
 obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
--- /dev/null	2012-01-24 00:06:39.330222901 +0100
+++ linux-3.2.1/drivers/video/i740fb.c	2012-01-24 00:01:54.000000000 +0100
@@ -0,0 +1,1337 @@
+/*
+ * i740fb - framebuffer driver for Intel740
+ * Copyright (c) 2011 Ondrej Zary
+ *
+ * Based on old i740fb driver (c) 2001-2002 Andrey Ulanov <drey@rt.mipt.ru>
+ * which was partially based on:
+ *  VGA 16-color framebuffer driver (c) 1999 Ben Pfaff <pfaffben@debian.org>
+ *	and Petr Vandrovec <VANDROVE@vc.cvut.cz>
+ *  i740 driver from XFree86 (c) 1998-1999 Precision Insight, Inc., Cedar Park,
+ *	Texas.
+ *  i740fb by Patrick LERDA, v0.9
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include <linux/console.h>
+#include <video/vga.h>
+
+#ifdef CONFIG_MTRR
+#include <asm/mtrr.h>
+#endif
+
+#include "i740_reg.h"
+
+static char *mode_option __devinitdata;
+
+#ifdef CONFIG_MTRR
+static int mtrr __devinitdata = 1;
+#endif
+
+struct i740fb_par {
+	unsigned char __iomem *regs;
+	bool has_sgram;
+#ifdef CONFIG_MTRR
+	int mtrr_reg;
+#endif
+	bool ddc_registered;
+	struct i2c_adapter ddc_adapter;
+	struct i2c_algo_bit_data ddc_algo;
+	u32 pseudo_palette[16];
+	struct mutex open_lock;
+	unsigned int ref_count;
+
+	u8 crtc[VGA_CRT_C];
+	u8 atc[VGA_ATT_C];
+	u8 gdc[VGA_GFX_C];
+	u8 seq[VGA_SEQ_C];
+	u8 misc;
+	u8 vss;
+
+	/* i740 specific registers */
+	u8 display_cntl;
+	u8 pixelpipe_cfg0;
+	u8 pixelpipe_cfg1;
+	u8 pixelpipe_cfg2;
+	u8 video_clk2_m;
+	u8 video_clk2_n;
+	u8 video_clk2_mn_msbs;
+	u8 video_clk2_div_sel;
+	u8 pll_cntl;
+	u8 address_mapping;
+	u8 io_cntl;
+	u8 bitblt_cntl;
+	u8 ext_vert_total;
+	u8 ext_vert_disp_end;
+	u8 ext_vert_sync_start;
+	u8 ext_vert_blank_start;
+	u8 ext_horiz_total;
+	u8 ext_horiz_blank;
+	u8 ext_offset;
+	u8 interlace_cntl;
+	u32 lmi_fifo_watermark;
+	u8 ext_start_addr;
+	u8 ext_start_addr_hi;
+};
+
+#define DACSPEED8	203
+#define DACSPEED16	163
+#define DACSPEED24_SG	136
+#define DACSPEED24_SD	128
+#define DACSPEED32	86
+
+static struct fb_fix_screeninfo i740fb_fix __devinitdata = {
+	.id =		"i740fb",
+	.type =		FB_TYPE_PACKED_PIXELS,
+	.visual =	FB_VISUAL_TRUECOLOR,
+	.xpanstep =	8,
+	.ypanstep =	1,
+	.accel =	FB_ACCEL_NONE,
+};
+
+static inline void i740outb(struct i740fb_par *par, u16 port, u8 val)
+{
+	vga_mm_w(par->regs, port, val);
+}
+static inline u8 i740inb(struct i740fb_par *par, u16 port)
+{
+	return vga_mm_r(par->regs, port);
+}
+static inline void i740outreg(struct i740fb_par *par, u16 port, u8 reg, u8 val)
+{
+	vga_mm_w_fast(par->regs, port, reg, val);
+}
+static inline u8 i740inreg(struct i740fb_par *par, u16 port, u8 reg)
+{
+	vga_mm_w(par->regs, port, reg);
+	return vga_mm_r(par->regs, port+1);
+}
+static inline void i740outreg_mask(struct i740fb_par *par, u16 port, u8 reg,
+				   u8 val, u8 mask)
+{
+	vga_mm_w_fast(par->regs, port, reg, (val & mask)
+		| (i740inreg(par, port, reg) & ~mask));
+}
+
+#define REG_DDC_DRIVE	0x62
+#define REG_DDC_STATE	0x63
+#define DDC_SCL		(1 << 3)
+#define DDC_SDA		(1 << 2)
+
+static void i740fb_ddc_setscl(void *data, int val)
+{
+	struct i740fb_par *par = data;
+
+	i740outreg_mask(par, XRX, REG_DDC_DRIVE, DDC_SCL, DDC_SCL);
+	i740outreg_mask(par, XRX, REG_DDC_STATE, val ? DDC_SCL : 0, DDC_SCL);
+}
+
+static void i740fb_ddc_setsda(void *data, int val)
+{
+	struct i740fb_par *par = data;
+
+	i740outreg_mask(par, XRX, REG_DDC_DRIVE, DDC_SDA, DDC_SDA);
+	i740outreg_mask(par, XRX, REG_DDC_STATE, val ? DDC_SDA : 0, DDC_SDA);
+}
+
+static int i740fb_ddc_getscl(void *data)
+{
+	struct i740fb_par *par = data;
+
+	i740outreg_mask(par, XRX, REG_DDC_DRIVE, 0, DDC_SCL);
+
+	return !!(i740inreg(par, XRX, REG_DDC_STATE) & DDC_SCL);
+}
+
+static int i740fb_ddc_getsda(void *data)
+{
+	struct i740fb_par *par = data;
+
+	i740outreg_mask(par, XRX, REG_DDC_DRIVE, 0, DDC_SDA);
+
+	return !!(i740inreg(par, XRX, REG_DDC_STATE) & DDC_SDA);
+}
+
+static int __devinit i740fb_setup_ddc_bus(struct fb_info *info)
+{
+	struct i740fb_par *par = info->par;
+
+	strlcpy(par->ddc_adapter.name, info->fix.id,
+		sizeof(par->ddc_adapter.name));
+	par->ddc_adapter.owner		= THIS_MODULE;
+	par->ddc_adapter.class		= I2C_CLASS_DDC;
+	par->ddc_adapter.algo_data	= &par->ddc_algo;
+	par->ddc_adapter.dev.parent	= info->device;
+	par->ddc_algo.setsda		= i740fb_ddc_setsda;
+	par->ddc_algo.setscl		= i740fb_ddc_setscl;
+	par->ddc_algo.getsda		= i740fb_ddc_getsda;
+	par->ddc_algo.getscl		= i740fb_ddc_getscl;
+	par->ddc_algo.udelay		= 10;
+	par->ddc_algo.timeout		= 20;
+	par->ddc_algo.data		= par;
+
+	i2c_set_adapdata(&par->ddc_adapter, par);
+
+	return i2c_bit_add_bus(&par->ddc_adapter);
+}
+
+static int i740fb_open(struct fb_info *info, int user)
+{
+	struct i740fb_par *par = info->par;
+
+	mutex_lock(&(par->open_lock));
+	par->ref_count++;
+	mutex_unlock(&(par->open_lock));
+
+	return 0;
+}
+
+static int i740fb_release(struct fb_info *info, int user)
+{
+	struct i740fb_par *par = info->par;
+
+	mutex_lock(&(par->open_lock));
+	if (par->ref_count == 0) {
+		printk(KERN_ERR "fb%d: release called with zero refcount\n",
+			info->node);
+		mutex_unlock(&(par->open_lock));
+		return -EINVAL;
+	}
+
+	par->ref_count--;
+	mutex_unlock(&(par->open_lock));
+
+	return 0;
+}
+
+static u32 i740_calc_fifo(struct i740fb_par *par, u32 freq, int bpp)
+{
+	/*
+	 * Would like to calculate these values automatically, but a generic
+	 * algorithm does not seem possible.  Note: These FIFO water mark
+	 * values were tested on several cards and seem to eliminate the
+	 * all of the snow and vertical banding, but fine adjustments will
+	 * probably be required for other cards.
+	 */
+
+	u32 wm;
+
+	switch (bpp) {
+	case 8:
+		if	(freq > 200)
+			wm = 0x18120000;
+		else if (freq > 175)
+			wm = 0x16110000;
+		else if (freq > 135)
+			wm = 0x120E0000;
+		else
+			wm = 0x100D0000;
+		break;
+	case 15:
+	case 16:
+		if (par->has_sgram) {
+			if	(freq > 140)
+				wm = 0x2C1D0000;
+			else if (freq > 120)
+				wm = 0x2C180000;
+			else if (freq > 100)
+				wm = 0x24160000;
+			else if (freq >  90)
+				wm = 0x18120000;
+			else if (freq >  50)
+				wm = 0x16110000;
+			else if (freq >  32)
+				wm = 0x13100000;
+			else
+				wm = 0x120E0000;
+		} else {
+			if	(freq > 160)
+				wm = 0x28200000;
+			else if (freq > 140)
+				wm = 0x2A1E0000;
+			else if (freq > 130)
+				wm = 0x2B1A0000;
+			else if (freq > 120)
+				wm = 0x2C180000;
+			else if (freq > 100)
+				wm = 0x24180000;
+			else if (freq >  90)
+				wm = 0x18120000;
+			else if (freq >  50)
+				wm = 0x16110000;
+			else if (freq >  32)
+				wm = 0x13100000;
+			else
+				wm = 0x120E0000;
+		}
+		break;
+	case 24:
+		if (par->has_sgram) {
+			if	(freq > 130)
+				wm = 0x31200000;
+			else if (freq > 120)
+				wm = 0x2E200000;
+			else if (freq > 100)
+				wm = 0x2C1D0000;
+			else if (freq >  80)
+				wm = 0x25180000;
+			else if (freq >  64)
+				wm = 0x24160000;
+			else if (freq >  49)
+				wm = 0x18120000;
+			else if (freq >  32)
+				wm = 0x16110000;
+			else
+				wm = 0x13100000;
+		} else {
+			if	(freq > 120)
+				wm = 0x311F0000;
+			else if (freq > 100)
+				wm = 0x2C1D0000;
+			else if (freq >  80)
+				wm = 0x25180000;
+			else if (freq >  64)
+				wm = 0x24160000;
+			else if (freq >  49)
+				wm = 0x18120000;
+			else if (freq >  32)
+				wm = 0x16110000;
+			else
+				wm = 0x13100000;
+		}
+		break;
+	case 32:
+		if (par->has_sgram) {
+			if	(freq >  80)
+				wm = 0x2A200000;
+			else if (freq >  60)
+				wm = 0x281A0000;
+			else if (freq >  49)
+				wm = 0x25180000;
+			else if (freq >  32)
+				wm = 0x18120000;
+			else
+				wm = 0x16110000;
+		} else {
+			if	(freq >  80)
+				wm = 0x29200000;
+			else if (freq >  60)
+				wm = 0x281A0000;
+			else if (freq >  49)
+				wm = 0x25180000;
+			else if (freq >  32)
+				wm = 0x18120000;
+			else
+				wm = 0x16110000;
+		}
+		break;
+	}
+
+	return wm;
+}
+
+/* clock calculation from i740fb by Patrick LERDA */
+
+#define I740_RFREQ		1000000
+#define TARGET_MAX_N		30
+#define I740_FFIX		(1 << 8)
+#define I740_RFREQ_FIX		(I740_RFREQ / I740_FFIX)
+#define I740_REF_FREQ		(6667 * I740_FFIX / 100)	/* 66.67 MHz */
+#define I740_MAX_VCO_FREQ	(450 * I740_FFIX)		/* 450 MHz */
+
+static void i740_calc_vclk(u32 freq, struct i740fb_par *par)
+{
+	const u32 err_max    = freq / (200  * I740_RFREQ / I740_FFIX);
+	const u32 err_target = freq / (1000 * I740_RFREQ / I740_FFIX);
+	u32 err_best = 512 * I740_FFIX;
+	u32 f_err, f_vco;
+	int m_best = 0, n_best = 0, p_best = 0, d_best = 0;
+	int m, n;
+
+	p_best = min(15, ilog2(I740_MAX_VCO_FREQ / (freq / I740_RFREQ_FIX)));
+	d_best = 0;
+	f_vco = (freq * (1 << p_best)) / I740_RFREQ_FIX;
+	freq = freq / I740_RFREQ_FIX;
+
+	n = 2;
+	do {
+		n++;
+		m = ((f_vco * n) / I740_REF_FREQ + 2) / 4;
+
+		if (m < 3)
+			m = 3;
+
+		{
+			u32 f_out = (((m * I740_REF_FREQ * (4 << 2 * d_best))
+				 / n) + ((1 << p_best) / 2)) / (1 << p_best);
+
+			f_err = (freq - f_out);
+
+			if (abs(f_err) < err_max) {
+				m_best = m;
+				n_best = n;
+				err_best = f_err;
+			}
+		}
+	} while ((abs(f_err) >= err_target) &&
+		 ((n <= TARGET_MAX_N) || (abs(err_best) > err_max)));
+
+	if (abs(f_err) < err_target) {
+		m_best = m;
+		n_best = n;
+	}
+
+	par->video_clk2_m = (m_best - 2) & 0xFF;
+	par->video_clk2_n = (n_best - 2) & 0xFF;
+	par->video_clk2_mn_msbs = ((((n_best - 2) >> 4) & VCO_N_MSBS)
+				 | (((m_best - 2) >> 8) & VCO_M_MSBS));
+	par->video_clk2_div_sel =
+		((p_best << 4) | (d_best ? 4 : 0) | REF_DIV_1);
+}
+
+static int i740fb_decode_var(const struct fb_var_screeninfo *var,
+			     struct i740fb_par *par, struct fb_info *info)
+{
+	/*
+	 * Get the video params out of 'var'.
+	 * If a value doesn't fit, round it up, if it's too big, return -EINVAL.
+	 */
+
+	u32 xres, right, hslen, left, xtotal;
+	u32 yres, lower, vslen, upper, ytotal;
+	u32 vxres, xoffset, vyres, yoffset;
+	u32 bpp, base, dacspeed24, mem;
+	u8 r7;
+	int i;
+
+	dev_dbg(info->device, "decode_var: xres: %i, yres: %i, xres_v: %i, xres_v: %i\n",
+		  var->xres, var->yres, var->xres_virtual, var->xres_virtual);
+	dev_dbg(info->device, "	xoff: %i, yoff: %i, bpp: %i, graysc: %i\n",
+		  var->xoffset, var->yoffset, var->bits_per_pixel,
+		  var->grayscale);
+	dev_dbg(info->device, "	activate: %i, nonstd: %i, vmode: %i\n",
+		  var->activate, var->nonstd, var->vmode);
+	dev_dbg(info->device, "	pixclock: %i, hsynclen:%i, vsynclen:%i\n",
+		  var->pixclock, var->hsync_len, var->vsync_len);
+	dev_dbg(info->device, "	left: %i, right: %i, up:%i, lower:%i\n",
+		  var->left_margin, var->right_margin, var->upper_margin,
+		  var->lower_margin);
+
+
+	bpp = var->bits_per_pixel;
+	switch (bpp) {
+	case 1 ... 8:
+		bpp = 8;
+		if ((1000000 / var->pixclock) > DACSPEED8) {
+			dev_err(info->device, "requested pixclock %i MHz out of range (max. %i MHz at 8bpp)\n",
+				1000000 / var->pixclock, DACSPEED8);
+			return -EINVAL;
+		}
+		break;
+	case 9 ... 15:
+		bpp = 15;
+	case 16:
+		if ((1000000 / var->pixclock) > DACSPEED16) {
+			dev_err(info->device, "requested pixclock %i MHz out of range (max. %i MHz at 15/16bpp)\n",
+				1000000 / var->pixclock, DACSPEED16);
+			return -EINVAL;
+		}
+		break;
+	case 17 ... 24:
+		bpp = 24;
+		dacspeed24 = par->has_sgram ? DACSPEED24_SG : DACSPEED24_SD;
+		if ((1000000 / var->pixclock) > dacspeed24) {
+			dev_err(info->device, "requested pixclock %i MHz out of range (max. %i MHz at 24bpp)\n",
+				1000000 / var->pixclock, dacspeed24);
+			return -EINVAL;
+		}
+		break;
+	case 25 ... 32:
+		bpp = 32;
+		if ((1000000 / var->pixclock) > DACSPEED32) {
+			dev_err(info->device, "requested pixclock %i MHz out of range (max. %i MHz at 32bpp)\n",
+				1000000 / var->pixclock, DACSPEED32);
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	xres = ALIGN(var->xres, 8);
+	vxres = ALIGN(var->xres_virtual, 16);
+	if (vxres < xres)
+		vxres = xres;
+
+	xoffset = ALIGN(var->xoffset, 8);
+	if (xres + xoffset > vxres)
+		xoffset = vxres - xres;
+
+	left = ALIGN(var->left_margin, 8);
+	right = ALIGN(var->right_margin, 8);
+	hslen = ALIGN(var->hsync_len, 8);
+
+	yres = var->yres;
+	vyres = var->yres_virtual;
+	if (yres > vyres)
+		vyres = yres;
+
+	yoffset = var->yoffset;
+	if (yres + yoffset > vyres)
+		yoffset = vyres - yres;
+
+	lower = var->lower_margin;
+	vslen = var->vsync_len;
+	upper = var->upper_margin;
+
+	mem = vxres * vyres * ((bpp + 1) / 8);
+	if (mem > info->screen_size) {
+		dev_err(info->device, "not enough video memory (%d KB requested, %ld KB avaliable)\n",
+			mem >> 10, info->screen_size >> 10);
+		return -ENOMEM;
+	}
+
+	if (yoffset + yres > vyres)
+		yoffset = vyres - yres;
+
+	xtotal = xres + right + hslen + left;
+	ytotal = yres + lower + vslen + upper;
+
+	par->crtc[VGA_CRTC_H_TOTAL] = (xtotal >> 3) - 5;
+	par->crtc[VGA_CRTC_H_DISP] = (xres >> 3) - 1;
+	par->crtc[VGA_CRTC_H_BLANK_START] = ((xres + right) >> 3) - 1;
+	par->crtc[VGA_CRTC_H_SYNC_START] = (xres + right) >> 3;
+	par->crtc[VGA_CRTC_H_SYNC_END] = (((xres + right + hslen) >> 3) & 0x1F)
+		| ((((xres + right + hslen) >> 3) & 0x20) << 2);
+	par->crtc[VGA_CRTC_H_BLANK_END] = ((xres + right + hslen) >> 3 & 0x1F)
+		| 0x80;
+
+	par->crtc[VGA_CRTC_V_TOTAL] = ytotal - 2;
+
+	r7 = 0x10;	/* disable linecompare */
+	if (ytotal & 0x100)
+		r7 |= 0x01;
+	if (ytotal & 0x200)
+		r7 |= 0x20;
+
+	par->crtc[VGA_CRTC_PRESET_ROW] = 0;
+	par->crtc[VGA_CRTC_MAX_SCAN] = 0x40;	/* 1 scanline, no linecmp */
+	if (var->vmode & FB_VMODE_DOUBLE)
+		par->crtc[VGA_CRTC_MAX_SCAN] |= 0x80;
+	par->crtc[VGA_CRTC_CURSOR_START] = 0x00;
+	par->crtc[VGA_CRTC_CURSOR_END] = 0x00;
+	par->crtc[VGA_CRTC_CURSOR_HI] = 0x00;
+	par->crtc[VGA_CRTC_CURSOR_LO] = 0x00;
+	par->crtc[VGA_CRTC_V_DISP_END] = yres-1;
+	if ((yres-1) & 0x100)
+		r7 |= 0x02;
+	if ((yres-1) & 0x200)
+		r7 |= 0x40;
+
+	par->crtc[VGA_CRTC_V_BLANK_START] = yres + lower - 1;
+	par->crtc[VGA_CRTC_V_SYNC_START] = yres + lower - 1;
+	if ((yres + lower - 1) & 0x100)
+		r7 |= 0x0C;
+	if ((yres + lower - 1) & 0x200) {
+		par->crtc[VGA_CRTC_MAX_SCAN] |= 0x20;
+		r7 |= 0x80;
+	}
+
+	/* disabled IRQ */
+	par->crtc[VGA_CRTC_V_SYNC_END] =
+		((yres + lower - 1 + vslen) & 0x0F) & ~0x10;
+	/* 0x7F for VGA, but some SVGA chips require all 8 bits to be set */
+	par->crtc[VGA_CRTC_V_BLANK_END] = (yres + lower - 1 + vslen) & 0xFF;
+
+	par->crtc[VGA_CRTC_UNDERLINE] = 0x00;
+	par->crtc[VGA_CRTC_MODE] = 0xC3 ;
+	par->crtc[VGA_CRTC_LINE_COMPARE] = 0xFF;
+	par->crtc[VGA_CRTC_OVERFLOW] = r7;
+
+	par->vss = 0x00;	/* 3DA */
+
+	for (i = 0x00; i < 0x10; i++)
+		par->atc[i] = i;
+	par->atc[VGA_ATC_MODE] = 0x81;
+	par->atc[VGA_ATC_OVERSCAN] = 0x00;	/* 0 for EGA, 0xFF for VGA */
+	par->atc[VGA_ATC_PLANE_ENABLE] = 0x0F;
+	par->atc[VGA_ATC_COLOR_PAGE] = 0x00;
+
+	par->misc = 0xC3;
+	if (var->sync & FB_SYNC_HOR_HIGH_ACT)
+		par->misc &= ~0x40;
+	if (var->sync & FB_SYNC_VERT_HIGH_ACT)
+		par->misc &= ~0x80;
+
+	par->seq[VGA_SEQ_CLOCK_MODE] = 0x01;
+	par->seq[VGA_SEQ_PLANE_WRITE] = 0x0F;
+	par->seq[VGA_SEQ_CHARACTER_MAP] = 0x00;
+	par->seq[VGA_SEQ_MEMORY_MODE] = 0x06;
+
+	par->gdc[VGA_GFX_SR_VALUE] = 0x00;
+	par->gdc[VGA_GFX_SR_ENABLE] = 0x00;
+	par->gdc[VGA_GFX_COMPARE_VALUE] = 0x00;
+	par->gdc[VGA_GFX_DATA_ROTATE] = 0x00;
+	par->gdc[VGA_GFX_PLANE_READ] = 0;
+	par->gdc[VGA_GFX_MODE] = 0x02;
+	par->gdc[VGA_GFX_MISC] = 0x05;
+	par->gdc[VGA_GFX_COMPARE_MASK] = 0x0F;
+	par->gdc[VGA_GFX_BIT_MASK] = 0xFF;
+
+	base = (yoffset * vxres + (xoffset & ~7)) >> 2;
+	switch (bpp) {
+	case 8:
+		par->crtc[VGA_CRTC_OFFSET] = vxres >> 3;
+		par->ext_offset = vxres >> 11;
+		par->pixelpipe_cfg1 = DISPLAY_8BPP_MODE;
+		par->bitblt_cntl = COLEXP_8BPP;
+		break;
+	case 15: /* 0rrrrrgg gggbbbbb */
+	case 16: /* rrrrrggg gggbbbbb */
+		par->pixelpipe_cfg1 = (var->green.length == 6) ?
+			DISPLAY_16BPP_MODE : DISPLAY_15BPP_MODE;
+		par->crtc[VGA_CRTC_OFFSET] = vxres >> 2;
+		par->ext_offset = vxres >> 10;
+		par->bitblt_cntl = COLEXP_16BPP;
+		base *= 2;
+		break;
+	case 24:
+		par->crtc[VGA_CRTC_OFFSET] = (vxres * 3) >> 3;
+		par->ext_offset = (vxres * 3) >> 11;
+		par->pixelpipe_cfg1 = DISPLAY_24BPP_MODE;
+		par->bitblt_cntl = COLEXP_24BPP;
+		base &= 0xFFFFFFFE; /* ...ignore the last bit. */
+		base *= 3;
+		break;
+	case 32:
+		par->crtc[VGA_CRTC_OFFSET] = vxres >> 1;
+		par->ext_offset = vxres >> 9;
+		par->pixelpipe_cfg1 = DISPLAY_32BPP_MODE;
+		par->bitblt_cntl = COLEXP_RESERVED; /* Unimplemented on i740 */
+		base *= 4;
+		break;
+	}
+
+	par->crtc[VGA_CRTC_START_LO] = base & 0x000000FF;
+	par->crtc[VGA_CRTC_START_HI] = (base & 0x0000FF00) >>  8;
+	par->ext_start_addr =
+		((base & 0x003F0000) >> 16) | EXT_START_ADDR_ENABLE;
+	par->ext_start_addr_hi = (base & 0x3FC00000) >> 22;
+
+	par->pixelpipe_cfg0 = DAC_8_BIT;
+
+	par->pixelpipe_cfg2 = DISPLAY_GAMMA_ENABLE | OVERLAY_GAMMA_ENABLE;
+	par->io_cntl = EXTENDED_CRTC_CNTL;
+	par->address_mapping = LINEAR_MODE_ENABLE | PAGE_MAPPING_ENABLE;
+	par->display_cntl = HIRES_MODE;
+
+	/* Set the MCLK freq */
+	par->pll_cntl = PLL_MEMCLK_100000KHZ; /* 100 MHz -- use as default */
+
+	/* Calculate the extended CRTC regs */
+	par->ext_vert_total = (ytotal - 2) >> 8;
+	par->ext_vert_disp_end = (yres - 1) >> 8;
+	par->ext_vert_sync_start = (yres + lower) >> 8;
+	par->ext_vert_blank_start = (yres + lower) >> 8;
+	par->ext_horiz_total = ((xtotal >> 3) - 5) >> 8;
+	par->ext_horiz_blank = (((xres + right) >> 3) & 0x40) >> 6;
+
+	par->interlace_cntl = INTERLACE_DISABLE;
+
+	/* Set the overscan color to 0. (NOTE: This only affects >8bpp mode) */
+	par->atc[VGA_ATC_OVERSCAN] = 0;
+
+	/* Calculate VCLK that most closely matches the requested dot clock */
+	i740_calc_vclk((((u32)1e9) / var->pixclock) * (u32)(1e3), par);
+
+	/* Since we program the clocks ourselves, always use VCLK2. */
+	par->misc |= 0x0C;
+
+	/* Calculate the FIFO Watermark and Burst Length. */
+	par->lmi_fifo_watermark =
+		i740_calc_fifo(par, 1000000 / var->pixclock, bpp);
+
+	return 0;
+}
+
+static int i740fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	switch (var->bits_per_pixel) {
+	case 8:
+		var->red.offset	= var->green.offset = var->blue.offset = 0;
+		var->red.length	= var->green.length = var->blue.length = 8;
+		break;
+	case 16:
+		switch (var->green.length) {
+		default:
+		case 5:
+			var->red.offset = 10;
+			var->green.offset = 5;
+			var->blue.offset = 0;
+			var->red.length	= 5;
+			var->green.length = 5;
+			var->blue.length = 5;
+			break;
+		case 6:
+			var->red.offset = 11;
+			var->green.offset = 5;
+			var->blue.offset = 0;
+			var->red.length = var->blue.length = 5;
+			break;
+		}
+		break;
+	case 24:
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->red.length	= var->green.length = var->blue.length = 8;
+		break;
+	case 32:
+		var->transp.offset = 24;
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->transp.length = 8;
+		var->red.length = var->green.length = var->blue.length = 8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (var->xres > var->xres_virtual)
+		var->xres_virtual = var->xres;
+
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
+
+	if (info->monspecs.hfmax && info->monspecs.vfmax &&
+	    info->monspecs.dclkmax && fb_validate_mode(var, info) < 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void vga_protect(struct i740fb_par *par)
+{
+	/* disable the display */
+	i740outreg_mask(par, VGA_SEQ_I, VGA_SEQ_CLOCK_MODE, 0x20, 0x20);
+
+	i740inb(par, 0x3DA);
+	i740outb(par, VGA_ATT_W, 0x00);	/* enable pallete access */
+}
+
+static void vga_unprotect(struct i740fb_par *par)
+{
+	/* reenable display */
+	i740outreg_mask(par, VGA_SEQ_I, VGA_SEQ_CLOCK_MODE, 0, 0x20);
+
+	i740inb(par, 0x3DA);
+	i740outb(par, VGA_ATT_W, 0x20);	/* disable pallete access */
+}
+
+static int i740fb_set_par(struct fb_info *info)
+{
+	struct i740fb_par *par = info->par;
+	u32 itemp;
+	int i;
+
+	i = i740fb_decode_var(&info->var, par, info);
+	if (i)
+		return i;
+
+	memset(info->screen_base, 0, info->screen_size);
+
+	vga_protect(par);
+
+	i740outreg(par, XRX, DRAM_EXT_CNTL, DRAM_REFRESH_DISABLE);
+
+	mdelay(1);
+
+	i740outreg(par, XRX, VCLK2_VCO_M, par->video_clk2_m);
+	i740outreg(par, XRX, VCLK2_VCO_N, par->video_clk2_n);
+	i740outreg(par, XRX, VCLK2_VCO_MN_MSBS, par->video_clk2_mn_msbs);
+	i740outreg(par, XRX, VCLK2_VCO_DIV_SEL, par->video_clk2_div_sel);
+
+	i740outreg_mask(par, XRX, PIXPIPE_CONFIG_0,
+			par->pixelpipe_cfg0 & DAC_8_BIT, 0x80);
+
+	i740inb(par, 0x3DA);
+	i740outb(par, 0x3C0, 0x00);
+
+	/* update misc output register */
+	i740outb(par, VGA_MIS_W, par->misc | 0x01);
+
+	/* synchronous reset on */
+	i740outreg(par, VGA_SEQ_I, VGA_SEQ_RESET, 0x01);
+	/* write sequencer registers */
+	i740outreg(par, VGA_SEQ_I, VGA_SEQ_CLOCK_MODE,
+			par->seq[VGA_SEQ_CLOCK_MODE] | 0x20);
+	for (i = 2; i < VGA_SEQ_C; i++)
+		i740outreg(par, VGA_SEQ_I, i, par->seq[i]);
+
+	/* synchronous reset off */
+	i740outreg(par, VGA_SEQ_I, VGA_SEQ_RESET, 0x03);
+
+	/* deprotect CRT registers 0-7 */
+	i740outreg(par, VGA_CRT_IC, VGA_CRTC_V_SYNC_END,
+			par->crtc[VGA_CRTC_V_SYNC_END]);
+
+	/* write CRT registers */
+	for (i = 0; i < VGA_CRT_C; i++)
+		i740outreg(par, VGA_CRT_IC, i, par->crtc[i]);
+
+	/* write graphics controller registers */
+	for (i = 0; i < VGA_GFX_C; i++)
+		i740outreg(par, VGA_GFX_I, i, par->gdc[i]);
+
+	/* write attribute controller registers */
+	for (i = 0; i < VGA_ATT_C; i++) {
+		i740inb(par, VGA_IS1_RC);		/* reset flip-flop */
+		i740outb(par, VGA_ATT_IW, i);
+		i740outb(par, VGA_ATT_IW, par->atc[i]);
+	}
+
+	i740inb(par, VGA_IS1_RC);
+	i740outb(par, VGA_ATT_IW, 0x20);
+
+	i740outreg(par, VGA_CRT_IC, EXT_VERT_TOTAL, par->ext_vert_total);
+	i740outreg(par, VGA_CRT_IC, EXT_VERT_DISPLAY, par->ext_vert_disp_end);
+	i740outreg(par, VGA_CRT_IC, EXT_VERT_SYNC_START,
+			par->ext_vert_sync_start);
+	i740outreg(par, VGA_CRT_IC, EXT_VERT_BLANK_START,
+			par->ext_vert_blank_start);
+	i740outreg(par, VGA_CRT_IC, EXT_HORIZ_TOTAL, par->ext_horiz_total);
+	i740outreg(par, VGA_CRT_IC, EXT_HORIZ_BLANK, par->ext_horiz_blank);
+	i740outreg(par, VGA_CRT_IC, EXT_OFFSET, par->ext_offset);
+	i740outreg(par, VGA_CRT_IC, EXT_START_ADDR_HI, par->ext_start_addr_hi);
+	i740outreg(par, VGA_CRT_IC, EXT_START_ADDR, par->ext_start_addr);
+
+	i740outreg_mask(par, VGA_CRT_IC, INTERLACE_CNTL,
+			par->interlace_cntl, INTERLACE_ENABLE);
+	i740outreg_mask(par, XRX, ADDRESS_MAPPING, par->address_mapping, 0x1F);
+	i740outreg_mask(par, XRX, BITBLT_CNTL, par->bitblt_cntl, COLEXP_MODE);
+	i740outreg_mask(par, XRX, DISPLAY_CNTL,
+			par->display_cntl, VGA_WRAP_MODE | GUI_MODE);
+	i740outreg_mask(par, XRX, PIXPIPE_CONFIG_0, par->pixelpipe_cfg0, 0x9B);
+	i740outreg_mask(par, XRX, PIXPIPE_CONFIG_2, par->pixelpipe_cfg2, 0x0C);
+
+	i740outreg(par, XRX, PLL_CNTL, par->pll_cntl);
+
+	i740outreg_mask(par, XRX, PIXPIPE_CONFIG_1,
+			par->pixelpipe_cfg1, DISPLAY_COLOR_MODE);
+
+	itemp = readl(par->regs + FWATER_BLC);
+	itemp &= ~(LMI_BURST_LENGTH | LMI_FIFO_WATERMARK);
+	itemp |= par->lmi_fifo_watermark;
+	writel(itemp, par->regs + FWATER_BLC);
+
+	i740outreg(par, XRX, DRAM_EXT_CNTL, DRAM_REFRESH_60HZ);
+
+	i740outreg_mask(par, MRX, COL_KEY_CNTL_1, 0, BLANK_DISP_OVERLAY);
+	i740outreg_mask(par, XRX, IO_CTNL,
+			par->io_cntl, EXTENDED_ATTR_CNTL | EXTENDED_CRTC_CNTL);
+
+	if (par->pixelpipe_cfg1 != DISPLAY_8BPP_MODE) {
+		i740outb(par, VGA_PEL_MSK, 0xFF);
+		i740outb(par, VGA_PEL_IW, 0x00);
+		for (i = 0; i < 256; i++) {
+			itemp = (par->pixelpipe_cfg0 & DAC_8_BIT) ? i : i >> 2;
+			i740outb(par, VGA_PEL_D, itemp);
+			i740outb(par, VGA_PEL_D, itemp);
+			i740outb(par, VGA_PEL_D, itemp);
+		}
+	}
+
+	/* Wait for screen to stabilize. */
+	mdelay(50);
+	vga_unprotect(par);
+
+	info->fix.line_length =
+			info->var.xres_virtual * info->var.bits_per_pixel / 8;
+	if (info->var.bits_per_pixel == 8)
+		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+	else
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+
+	return 0;
+}
+
+static int i740fb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	u32 r, g, b;
+
+	dev_dbg(info->device, "setcolreg: regno: %i, red=%d, green=%d, blue=%d, transp=%d, bpp=%d\n",
+		regno, red, green, blue, transp, info->var.bits_per_pixel);
+
+	switch (info->fix.visual) {
+	case FB_VISUAL_PSEUDOCOLOR:
+		if (regno >= 256)
+			return -EINVAL;
+		i740outb(info->par, VGA_PEL_IW, regno);
+		i740outb(info->par, VGA_PEL_D, red >> 8);
+		i740outb(info->par, VGA_PEL_D, green >> 8);
+		i740outb(info->par, VGA_PEL_D, blue >> 8);
+		break;
+	case FB_VISUAL_TRUECOLOR:
+		if (regno >= 16)
+			return -EINVAL;
+		r = (red >> (16 - info->var.red.length))
+			<< info->var.red.offset;
+		b = (blue >> (16 - info->var.blue.length))
+			<< info->var.blue.offset;
+		g = (green >> (16 - info->var.green.length))
+			<< info->var.green.offset;
+		((u32 *) info->pseudo_palette)[regno] = r | g | b;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int i740fb_pan_display(struct fb_var_screeninfo *var,
+				 struct fb_info *info)
+{
+	struct i740fb_par *par = info->par;
+	u32 base = (var->yoffset * info->var.xres_virtual
+		 + (var->xoffset & ~7)) >> 2;
+
+	dev_dbg(info->device, "pan_display: xoffset: %i yoffset: %i base: %i\n",
+		var->xoffset, var->yoffset, base);
+
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		break;
+	case 15:
+	case 16:
+		base *= 2;
+		break;
+	case 24:
+		/*
+		 * The last bit does not seem to have any effect on the start
+		 * address register in 24bpp mode, so...
+		 */
+		base &= 0xFFFFFFFE; /* ...ignore the last bit. */
+		base *= 3;
+		break;
+	case 32:
+		base *= 4;
+		break;
+	}
+
+	par->crtc[VGA_CRTC_START_LO] = base & 0x000000FF;
+	par->crtc[VGA_CRTC_START_HI] = (base & 0x0000FF00) >>  8;
+	par->ext_start_addr_hi = (base & 0x3FC00000) >> 22;
+	par->ext_start_addr =
+			((base & 0x003F0000) >> 16) | EXT_START_ADDR_ENABLE;
+
+	i740outreg(par, VGA_CRT_IC, VGA_CRTC_START_LO,  base & 0x000000FF);
+	i740outreg(par, VGA_CRT_IC, VGA_CRTC_START_HI,
+			(base & 0x0000FF00) >> 8);
+	i740outreg(par, VGA_CRT_IC, EXT_START_ADDR_HI,
+			(base & 0x3FC00000) >> 22);
+	i740outreg(par, VGA_CRT_IC, EXT_START_ADDR,
+			((base & 0x003F0000) >> 16) | EXT_START_ADDR_ENABLE);
+
+	return 0;
+}
+
+static int i740fb_blank(int blank_mode, struct fb_info *info)
+{
+	struct i740fb_par *par = info->par;
+
+	unsigned char SEQ01;
+	int DPMSSyncSelect;
+
+	switch (blank_mode) {
+	case FB_BLANK_UNBLANK:
+	case FB_BLANK_NORMAL:
+		SEQ01 = 0x00;
+		DPMSSyncSelect = HSYNC_ON | VSYNC_ON;
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+		SEQ01 = 0x20;
+		DPMSSyncSelect = HSYNC_ON | VSYNC_OFF;
+		break;
+	case FB_BLANK_HSYNC_SUSPEND:
+		SEQ01 = 0x20;
+		DPMSSyncSelect = HSYNC_OFF | VSYNC_ON;
+		break;
+	case FB_BLANK_POWERDOWN:
+		SEQ01 = 0x20;
+		DPMSSyncSelect = HSYNC_OFF | VSYNC_OFF;
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* Turn the screen on/off */
+	i740outb(par, SRX, 0x01);
+	SEQ01 |= i740inb(par, SRX + 1) & ~0x20;
+	i740outb(par, SRX, 0x01);
+	i740outb(par, SRX + 1, SEQ01);
+
+	/* Set the DPMS mode */
+	i740outreg(par, XRX, DPMS_SYNC_SELECT, DPMSSyncSelect);
+
+	/* Let fbcon do a soft blank for us */
+	return (blank_mode == FB_BLANK_NORMAL) ? 1 : 0;
+}
+
+static struct fb_ops i740fb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_open	= i740fb_open,
+	.fb_release	= i740fb_release,
+	.fb_check_var	= i740fb_check_var,
+	.fb_set_par	= i740fb_set_par,
+	.fb_setcolreg	= i740fb_setcolreg,
+	.fb_blank	= i740fb_blank,
+	.fb_pan_display	= i740fb_pan_display,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+/* ------------------------------------------------------------------------- */
+
+static int __devinit i740fb_probe(struct pci_dev *dev,
+				  const struct pci_device_id *ent)
+{
+	struct fb_info *info;
+	struct i740fb_par *par;
+	int ret, tmp;
+	bool found = false;
+	u8 *edid;
+
+	info = framebuffer_alloc(sizeof(struct i740fb_par), &(dev->dev));
+	if (!info) {
+		dev_err(&(dev->dev), "cannot allocate framebuffer\n");
+		return -ENOMEM;
+	}
+
+	par = info->par;
+	mutex_init(&par->open_lock);
+
+	info->var.activate = FB_ACTIVATE_NOW;
+	info->var.bits_per_pixel = 8;
+	info->fbops = &i740fb_ops;
+	info->pseudo_palette = par->pseudo_palette;
+
+	ret = pci_enable_device(dev);
+	if (ret) {
+		dev_err(info->device, "cannot enable PCI device\n");
+		goto err_enable_device;
+	}
+
+	ret = pci_request_regions(dev, info->fix.id);
+	if (ret) {
+		dev_err(info->device, "error requesting regions\n");
+		goto err_request_regions;
+	}
+
+	info->screen_base = pci_ioremap_bar(dev, 0);
+	if (!info->screen_base) {
+		dev_err(info->device, "error remapping base\n");
+		ret = -ENOMEM;
+		goto err_ioremap_1;
+	}
+
+	par->regs = pci_ioremap_bar(dev, 1);
+	if (!par->regs) {
+		dev_err(info->device, "error remapping MMIO\n");
+		ret = -ENOMEM;
+		goto err_ioremap_2;
+	}
+
+	/* detect memory size */
+	if ((i740inreg(par, XRX, DRAM_ROW_TYPE) & DRAM_ROW_1)
+							== DRAM_ROW_1_SDRAM)
+		i740outb(par, XRX, DRAM_ROW_BNDRY_1);
+	else
+		i740outb(par, XRX, DRAM_ROW_BNDRY_0);
+	info->screen_size = i740inb(par, XRX + 1) * 1024 * 1024;
+	/* detect memory type */
+	tmp = i740inreg(par, XRX, DRAM_ROW_CNTL_LO);
+	par->has_sgram = !((tmp & DRAM_RAS_TIMING) ||
+			   (tmp & DRAM_RAS_PRECHARGE));
+
+	printk(KERN_INFO "fb%d: Intel740 on %s, %ld KB %s\n", info->node,
+		pci_name(dev), info->screen_size >> 10,
+		par->has_sgram ? "SGRAM" : "SDRAM");
+
+	info->fix = i740fb_fix;
+	info->fix.mmio_start = pci_resource_start(dev, 1);
+	info->fix.mmio_len = pci_resource_len(dev, 1);
+	info->fix.smem_start = pci_resource_start(dev, 0);
+	info->fix.smem_len = info->screen_size;
+	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
+
+	if (i740fb_setup_ddc_bus(info) == 0) {
+		par->ddc_registered = true;
+		edid = fb_ddc_read(&par->ddc_adapter);
+		if (edid) {
+			fb_edid_to_monspecs(edid, &info->monspecs);
+			kfree(edid);
+			if (!info->monspecs.modedb)
+				dev_err(info->device,
+					"error getting mode database\n");
+			else {
+				const struct fb_videomode *m;
+
+				fb_videomode_to_modelist(
+					info->monspecs.modedb,
+					info->monspecs.modedb_len,
+					&info->modelist);
+				m = fb_find_best_display(&info->monspecs,
+							 &info->modelist);
+				if (m) {
+					fb_videomode_to_var(&info->var, m);
+					/* fill all other info->var's fields */
+					if (!i740fb_check_var(&info->var, info))
+						found = true;
+				}
+			}
+		}
+	}
+
+	if (!mode_option && !found)
+		mode_option = "640x480-8@60";
+
+	if (mode_option) {
+		ret = fb_find_mode(&info->var, info, mode_option,
+				   info->monspecs.modedb,
+				   info->monspecs.modedb_len,
+				   NULL, info->var.bits_per_pixel);
+		if (!ret || ret == 4) {
+			dev_err(info->device, "mode %s not found\n",
+				mode_option);
+			ret = -EINVAL;
+		}
+	}
+
+	fb_destroy_modedb(info->monspecs.modedb);
+	info->monspecs.modedb = NULL;
+
+	/* maximize virtual vertical size for fast scrolling */
+	info->var.yres_virtual = info->fix.smem_len * 8 /
+			(info->var.bits_per_pixel * info->var.xres_virtual);
+
+	if (ret == -EINVAL)
+		goto err_find_mode;
+
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret) {
+		dev_err(info->device, "cannot allocate colormap\n");
+		goto err_alloc_cmap;
+	}
+
+	ret = register_framebuffer(info);
+	if (ret) {
+		dev_err(info->device, "error registering framebuffer\n");
+		goto err_reg_framebuffer;
+	}
+
+	printk(KERN_INFO "fb%d: %s frame buffer device\n",
+		info->node, info->fix.id);
+	pci_set_drvdata(dev, info);
+#ifdef CONFIG_MTRR
+	if (mtrr) {
+		par->mtrr_reg = -1;
+		par->mtrr_reg = mtrr_add(info->fix.smem_start,
+				info->fix.smem_len, MTRR_TYPE_WRCOMB, 1);
+	}
+#endif
+	return 0;
+
+err_reg_framebuffer:
+	fb_dealloc_cmap(&info->cmap);
+err_alloc_cmap:
+err_find_mode:
+	if (par->ddc_registered)
+		i2c_del_adapter(&par->ddc_adapter);
+	pci_iounmap(dev, par->regs);
+err_ioremap_2:
+	pci_iounmap(dev, info->screen_base);
+err_ioremap_1:
+	pci_release_regions(dev);
+err_request_regions:
+/*	pci_disable_device(dev); */
+err_enable_device:
+	framebuffer_release(info);
+	return ret;
+}
+
+static void __devexit i740fb_remove(struct pci_dev *dev)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+
+	if (info) {
+#ifdef CONFIG_MTRR
+		struct i740fb_par *par = info->par;
+
+		if (par->mtrr_reg >= 0) {
+			mtrr_del(par->mtrr_reg, 0, 0);
+			par->mtrr_reg = -1;
+		}
+#endif
+		unregister_framebuffer(info);
+		fb_dealloc_cmap(&info->cmap);
+		if (par->ddc_registered)
+			i2c_del_adapter(&par->ddc_adapter);
+		pci_iounmap(dev, par->regs);
+		pci_iounmap(dev, info->screen_base);
+		pci_release_regions(dev);
+/*		pci_disable_device(dev); */
+		pci_set_drvdata(dev, NULL);
+		framebuffer_release(info);
+	}
+}
+
+#ifdef CONFIG_PM
+static int i740fb_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	struct i740fb_par *par = info->par;
+
+	/* don't disable console during hibernation and wakeup from it */
+	if (state.event == PM_EVENT_FREEZE || state.event == PM_EVENT_PRETHAW)
+		return 0;
+
+	console_lock();
+	mutex_lock(&(par->open_lock));
+
+	/* do nothing if framebuffer is not active */
+	if (par->ref_count == 0) {
+		mutex_unlock(&(par->open_lock));
+		console_unlock();
+		return 0;
+	}
+
+	fb_set_suspend(info, 1);
+
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	mutex_unlock(&(par->open_lock));
+	console_unlock();
+
+	return 0;
+}
+
+static int i740fb_resume(struct pci_dev *dev)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	struct i740fb_par *par = info->par;
+
+	console_lock();
+	mutex_lock(&(par->open_lock));
+
+	if (par->ref_count == 0)
+		goto fail;
+
+	pci_set_power_state(dev, PCI_D0);
+	pci_restore_state(dev);
+	if (pci_enable_device(dev))
+		goto fail;
+
+	i740fb_set_par(info);
+	fb_set_suspend(info, 0);
+
+fail:
+	mutex_unlock(&(par->open_lock));
+	console_unlock();
+	return 0;
+}
+#else
+#define i740fb_suspend NULL
+#define i740fb_resume NULL
+#endif /* CONFIG_PM */
+
+#define I740_ID_PCI 0x00d1
+#define I740_ID_AGP 0x7800
+
+static DEFINE_PCI_DEVICE_TABLE(i740fb_id_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, I740_ID_PCI) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, I740_ID_AGP) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, i740fb_id_table);
+
+static struct pci_driver i740fb_driver = {
+	.name		= "i740fb",
+	.id_table	= i740fb_id_table,
+	.probe		= i740fb_probe,
+	.remove		= __devexit_p(i740fb_remove),
+	.suspend	= i740fb_suspend,
+	.resume		= i740fb_resume,
+};
+
+#ifndef MODULE
+static int  __init i740fb_setup(char *options)
+{
+	char *opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((opt = strsep(&options, ",")) != NULL) {
+		if (!*opt)
+			continue;
+#ifdef CONFIG_MTRR
+		else if (!strncmp(opt, "mtrr:", 5))
+			mtrr = simple_strtoul(opt + 5, NULL, 0);
+#endif
+		else
+			mode_option = opt;
+	}
+
+	return 0;
+}
+#endif
+
+int __init i740fb_init(void)
+{
+#ifndef MODULE
+	char *option = NULL;
+
+	if (fb_get_options("i740fb", &option))
+		return -ENODEV;
+	i740fb_setup(option);
+#endif
+
+	return pci_register_driver(&i740fb_driver);
+}
+
+static void __exit i740fb_exit(void)
+{
+	pci_unregister_driver(&i740fb_driver);
+}
+
+module_init(i740fb_init);
+module_exit(i740fb_exit);
+
+MODULE_AUTHOR("(c) 2011 Ondrej Zary <linux@rainbow-software.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("fbdev driver for Intel740");
+
+module_param(mode_option, charp, 0444);
+MODULE_PARM_DESC(mode_option, "Default video mode ('640x480-8@60', etc)");
+
+#ifdef CONFIG_MTRR
+module_param(mtrr, int, 0444);
+MODULE_PARM_DESC(mtrr, "Enable write-combining with MTRR (1=enable, 0=disable, default=1)");
+#endif
--- /dev/null	2012-01-24 00:06:39.330222901 +0100
+++ linux-3.2.1/drivers/video/i740_reg.h	2012-01-23 22:55:57.000000000 +0100
@@ -0,0 +1,309 @@
+/**************************************************************************
+
+Copyright 1998-1999 Precision Insight, Inc., Cedar Park, Texas.
+All Rights Reserved.
+
+Permission is hereby granted, free of charge, to any person obtaining a
+copy of this software and associated documentation files (the
+"Software"), to deal in the Software without restriction, including
+without limitation the rights to use, copy, modify, merge, publish,
+distribute, sub license, and/or sell copies of the Software, and to
+permit persons to whom the Software is furnished to do so, subject to
+the following conditions:
+
+The above copyright notice and this permission notice (including the
+next paragraph) shall be included in all copies or substantial portions
+of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
+IN NO EVENT SHALL PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR
+ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
+TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
+SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+
+**************************************************************************/
+
+/*
+ * Authors:
+ *   Kevin E. Martin <kevin@precisioninsight.com>
+ */
+
+/* I/O register offsets */
+#define SRX VGA_SEQ_I
+#define GRX VGA_GFX_I
+#define ARX VGA_ATT_IW
+#define XRX 0x3D6
+#define MRX 0x3D2
+
+/* VGA Color Palette Registers */
+#define DACMASK		0x3C6
+#define DACSTATE	0x3C7
+#define DACRX		0x3C7
+#define DACWX		0x3C8
+#define DACDATA		0x3C9
+
+/* CRT Controller Registers (CRX) */
+#define START_ADDR_HI		0x0C
+#define START_ADDR_LO		0x0D
+#define VERT_SYNC_END		0x11
+#define EXT_VERT_TOTAL		0x30
+#define EXT_VERT_DISPLAY	0x31
+#define EXT_VERT_SYNC_START	0x32
+#define EXT_VERT_BLANK_START	0x33
+#define EXT_HORIZ_TOTAL		0x35
+#define EXT_HORIZ_BLANK		0x39
+#define EXT_START_ADDR		0x40
+#define EXT_START_ADDR_ENABLE	0x80
+#define EXT_OFFSET		0x41
+#define EXT_START_ADDR_HI	0x42
+#define INTERLACE_CNTL		0x70
+#define INTERLACE_ENABLE	0x80
+#define INTERLACE_DISABLE	0x00
+
+/* Miscellaneous Output Register */
+#define MSR_R		0x3CC
+#define MSR_W		0x3C2
+#define IO_ADDR_SELECT	0x01
+
+#define MDA_BASE	0x3B0
+#define CGA_BASE	0x3D0
+
+/* System Configuration Extension Registers (XRX) */
+#define IO_CTNL		0x09
+#define EXTENDED_ATTR_CNTL	0x02
+#define EXTENDED_CRTC_CNTL	0x01
+
+#define ADDRESS_MAPPING	0x0A
+#define PACKED_MODE_ENABLE	0x04
+#define LINEAR_MODE_ENABLE	0x02
+#define PAGE_MAPPING_ENABLE	0x01
+
+#define BITBLT_CNTL	0x20
+#define COLEXP_MODE		0x30
+#define COLEXP_8BPP		0x00
+#define COLEXP_16BPP		0x10
+#define COLEXP_24BPP		0x20
+#define COLEXP_RESERVED		0x30
+#define CHIP_RESET		0x02
+#define BITBLT_STATUS		0x01
+
+#define DISPLAY_CNTL	0x40
+#define VGA_WRAP_MODE		0x02
+#define VGA_WRAP_AT_256KB	0x00
+#define VGA_NO_WRAP		0x02
+#define GUI_MODE		0x01
+#define STANDARD_VGA_MODE	0x00
+#define HIRES_MODE		0x01
+
+#define DRAM_ROW_TYPE	0x50
+#define DRAM_ROW_0		0x07
+#define DRAM_ROW_0_SDRAM	0x00
+#define DRAM_ROW_0_EMPTY	0x07
+#define DRAM_ROW_1		0x38
+#define DRAM_ROW_1_SDRAM	0x00
+#define DRAM_ROW_1_EMPTY	0x38
+#define DRAM_ROW_CNTL_LO 0x51
+#define DRAM_CAS_LATENCY	0x10
+#define DRAM_RAS_TIMING		0x08
+#define DRAM_RAS_PRECHARGE	0x04
+#define DRAM_ROW_CNTL_HI 0x52
+#define DRAM_EXT_CNTL	0x53
+#define DRAM_REFRESH_RATE	0x03
+#define DRAM_REFRESH_DISABLE	0x00
+#define DRAM_REFRESH_60HZ	0x01
+#define DRAM_REFRESH_FAST_TEST	0x02
+#define DRAM_REFRESH_RESERVED	0x03
+#define DRAM_TIMING	0x54
+#define DRAM_ROW_BNDRY_0 0x55
+#define DRAM_ROW_BNDRY_1 0x56
+
+#define DPMS_SYNC_SELECT 0x61
+#define VSYNC_CNTL		0x08
+#define VSYNC_ON		0x00
+#define VSYNC_OFF		0x08
+#define HSYNC_CNTL		0x02
+#define HSYNC_ON		0x00
+#define HSYNC_OFF		0x02
+
+#define PIXPIPE_CONFIG_0 0x80
+#define DAC_8_BIT		0x80
+#define DAC_6_BIT		0x00
+#define HW_CURSOR_ENABLE	0x10
+#define EXTENDED_PALETTE	0x01
+
+#define PIXPIPE_CONFIG_1 0x81
+#define DISPLAY_COLOR_MODE	0x0F
+#define DISPLAY_VGA_MODE	0x00
+#define DISPLAY_8BPP_MODE	0x02
+#define DISPLAY_15BPP_MODE	0x04
+#define DISPLAY_16BPP_MODE	0x05
+#define DISPLAY_24BPP_MODE	0x06
+#define DISPLAY_32BPP_MODE	0x07
+
+#define PIXPIPE_CONFIG_2 0x82
+#define DISPLAY_GAMMA_ENABLE	0x08
+#define DISPLAY_GAMMA_DISABLE	0x00
+#define OVERLAY_GAMMA_ENABLE	0x04
+#define OVERLAY_GAMMA_DISABLE	0x00
+
+#define CURSOR_CONTROL	0xA0
+#define CURSOR_ORIGIN_SCREEN	0x00
+#define CURSOR_ORIGIN_DISPLAY	0x10
+#define CURSOR_MODE		0x07
+#define CURSOR_MODE_DISABLE	0x00
+#define CURSOR_MODE_32_4C_AX	0x01
+#define CURSOR_MODE_128_2C	0x02
+#define CURSOR_MODE_128_1C	0x03
+#define CURSOR_MODE_64_3C	0x04
+#define CURSOR_MODE_64_4C_AX	0x05
+#define CURSOR_MODE_64_4C	0x06
+#define CURSOR_MODE_RESERVED	0x07
+#define CURSOR_BASEADDR_LO 0xA2
+#define CURSOR_BASEADDR_HI 0xA3
+#define CURSOR_X_LO	0xA4
+#define CURSOR_X_HI	0xA5
+#define CURSOR_X_POS		0x00
+#define CURSOR_X_NEG		0x80
+#define CURSOR_Y_LO	0xA6
+#define CURSOR_Y_HI	0xA7
+#define CURSOR_Y_POS		0x00
+#define CURSOR_Y_NEG		0x80
+
+#define VCLK2_VCO_M	0xC8
+#define VCLK2_VCO_N	0xC9
+#define VCLK2_VCO_MN_MSBS 0xCA
+#define VCO_N_MSBS		0x30
+#define VCO_M_MSBS		0x03
+#define VCLK2_VCO_DIV_SEL 0xCB
+#define POST_DIV_SELECT		0x70
+#define POST_DIV_1		0x00
+#define POST_DIV_2		0x10
+#define POST_DIV_4		0x20
+#define POST_DIV_8		0x30
+#define POST_DIV_16		0x40
+#define POST_DIV_32		0x50
+#define VCO_LOOP_DIV_BY_4M	0x00
+#define VCO_LOOP_DIV_BY_16M	0x04
+#define REF_CLK_DIV_BY_5	0x02
+#define REF_DIV_4		0x00
+#define REF_DIV_1		0x01
+
+#define PLL_CNTL	0xCE
+#define PLL_MEMCLK_SEL		0x03
+#define PLL_MEMCLK__66667KHZ	0x00
+#define PLL_MEMCLK__75000KHZ	0x01
+#define PLL_MEMCLK__88889KHZ	0x02
+#define PLL_MEMCLK_100000KHZ	0x03
+
+/* Multimedia Extension Registers (MRX) */
+#define ACQ_CNTL_1	0x02
+#define ACQ_CNTL_2	0x03
+#define FRAME_CAP_MODE		0x01
+#define CONT_CAP_MODE		0x00
+#define SINGLE_CAP_MODE		0x01
+#define ACQ_CNTL_3	0x04
+#define COL_KEY_CNTL_1		0x3C
+#define BLANK_DISP_OVERLAY	0x20
+
+/* FIFOs */
+#define LP_FIFO		0x1000
+#define HP_FIFO		0x2000
+#define INSTPNT		0x3040
+#define LP_FIFO_COUNT	0x3040
+#define HP_FIFO_COUNT	0x3041
+
+/* FIFO Commands */
+#define CLIENT		0xE0000000
+#define CLIENT_2D	0x60000000
+
+/* Command Parser Mode Register */
+#define COMPARS		0x3038
+#define TWO_D_INST_DISABLE		0x08
+#define THREE_D_INST_DISABLE		0x04
+#define STATE_VAR_UPDATE_DISABLE	0x02
+#define PAL_STIP_DISABLE		0x01
+
+/* Interrupt Control Registers */
+#define IER		0x3030
+#define IIR		0x3032
+#define IMR		0x3034
+#define ISR		0x3036
+#define VMIINTB_EVENT		0x2000
+#define GPIO4_INT		0x1000
+#define DISP_FLIP_EVENT		0x0800
+#define DVD_PORT_DMA		0x0400
+#define DISP_VBLANK		0x0200
+#define FIFO_EMPTY_DMA_DONE	0x0100
+#define INST_PARSER_ERROR	0x0080
+#define USER_DEFINED		0x0040
+#define BREAKPOINT		0x0020
+#define DISP_HORIZ_COUNT	0x0010
+#define DISP_VSYNC		0x0008
+#define CAPTURE_HORIZ_COUNT	0x0004
+#define CAPTURE_VSYNC		0x0002
+#define THREE_D_PIPE_FLUSHED	0x0001
+
+/* FIFO Watermark and Burst Length Control Register */
+#define FWATER_BLC	0x00006000
+#define LMI_BURST_LENGTH	0x7F000000
+#define LMI_FIFO_WATERMARK	0x003F0000
+#define AGP_BURST_LENGTH	0x00007F00
+#define AGP_FIFO_WATERMARK	0x0000003F
+
+/* BitBLT Registers */
+#define SRC_DST_PITCH	0x00040000
+#define DST_PITCH		0x1FFF0000
+#define SRC_PITCH		0x00001FFF
+#define COLEXP_BG_COLOR	0x00040004
+#define COLEXP_FG_COLOR	0x00040008
+#define MONO_SRC_CNTL	0x0004000C
+#define MONO_USE_COLEXP		0x00000000
+#define MONO_USE_SRCEXP		0x08000000
+#define MONO_DATA_ALIGN		0x07000000
+#define MONO_BIT_ALIGN		0x01000000
+#define MONO_BYTE_ALIGN		0x02000000
+#define MONO_WORD_ALIGN		0x03000000
+#define MONO_DWORD_ALIGN	0x04000000
+#define MONO_QWORD_ALIGN	0x05000000
+#define MONO_SRC_INIT_DSCRD	0x003F0000
+#define MONO_SRC_RIGHT_CLIP	0x00003F00
+#define MONO_SRC_LEFT_CLIP	0x0000003F
+#define BITBLT_CONTROL	0x00040010
+#define BLTR_STATUS		0x80000000
+#define DYN_DEPTH		0x03000000
+#define DYN_DEPTH_8BPP		0x00000000
+#define DYN_DEPTH_16BPP		0x01000000
+#define DYN_DEPTH_24BPP		0x02000000
+#define DYN_DEPTH_32BPP		0x03000000	/* Unimplemented on the i740 */
+#define DYN_DEPTH_ENABLE	0x00800000
+#define PAT_VERT_ALIGN		0x00700000
+#define SOLID_PAT_SELECT	0x00080000
+#define PAT_IS_IN_COLOR		0x00000000
+#define PAT_IS_MONO		0x00040000
+#define MONO_PAT_TRANSP		0x00020000
+#define COLOR_TRANSP_ROP	0x00000000
+#define COLOR_TRANSP_DST	0x00008000
+#define COLOR_TRANSP_EQ		0x00000000
+#define COLOR_TRANSP_NOT_EQ	0x00010000
+#define COLOR_TRANSP_ENABLE	0x00004000
+#define MONO_SRC_TRANSP		0x00002000
+#define SRC_IS_IN_COLOR		0x00000000
+#define SRC_IS_MONO		0x00001000
+#define SRC_USE_SRC_ADDR	0x00000000
+#define SRC_USE_BLTDATA		0x00000400
+#define BLT_TOP_TO_BOT		0x00000000
+#define BLT_BOT_TO_TOP		0x00000200
+#define BLT_LEFT_TO_RIGHT	0x00000000
+#define BLT_RIGHT_TO_LEFT	0x00000100
+#define BLT_ROP			0x000000FF
+#define BLT_PAT_ADDR	0x00040014
+#define BLT_SRC_ADDR	0x00040018
+#define BLT_DST_ADDR	0x0004001C
+#define BLT_DST_H_W	0x00040020
+#define BLT_DST_HEIGHT		0x1FFF0000
+#define BLT_DST_WIDTH		0x00001FFF
+#define SRCEXP_BG_COLOR	0x00040024
+#define SRCEXP_FG_COLOR	0x00040028
+#define BLTDATA		0x00050000



-- 
Ondrej Zary
