Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1AYJCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 04:02:16 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57363 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1AYJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 04:02:13 -0500
Date: Tue, 25 Jan 2011 18:02:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unicore32: add framebuffer driver for unigfx engine in PKUnity SoC
Message-ID: <20110125090203.GA17883@linux-sh.org>
References: <01cf01cbba1f$49f84130$dde8c390$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01cf01cbba1f$49f84130$dde8c390$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 06:29:45PM +0800, Guan Xuetao wrote:
> diff --git a/drivers/video/puv3_fb.c b/drivers/video/puv3_fb.c
> new file mode 100644
> index 0000000..d938a73
> --- /dev/null
> +++ b/drivers/video/puv3_fb.c
[snip]

> +static unsigned long unifb_regs[10];
> +
This is probably something that you will want to move in to platform
data.

> +#define VIDEOMEMSIZE	(SZ_4M)		/* 4 MB for 1024*768*32b */
> +
> +static void *videomemory;
> +static u_long videomemorysize = VIDEOMEMSIZE;
> +module_param(videomemorysize, ulong, 0);
> +
Along with these, given that they're not dynamically acquired by the
driver.

> +static int unifb_enable __initdata = 1;	/* enable by default */
> +module_param(unifb_enable, bool, 0);
> +
No need for this, you can use fb_get_options() and -ENODEV out in the
init path then simply use the generic "off" parsing done by the fbmem
code.

> +#ifdef CONFIG_PUV3_UNIGFX_HWACCEL
> +static void unifb_sync(void)
> +{
> +	/* TODO: may, this can be replaced by interrupt */
> +	int cnt;
> +
> +	for (cnt = 0; cnt < 0x10000000; cnt++) {
> +		if (UGE_COMMAND & 0x1000000)
> +			return;
> +	}
> +
> +	if (cnt > 0x8000000)
> +		printk(KERN_WARNING "Warning: UniGFX GE time out ...\n");
> +}
> +
In addition to switching to platform data for the I/O offsets, you can
also use dev_warn() here on the device pointer (fb_info->device).

> +static struct fb_ops unifb_ops = {
> +	.fb_read        = fb_sys_read,
> +	.fb_write       = fb_sys_write,
> +	.fb_check_var	= unifb_check_var,
> +	.fb_set_par	= unifb_set_par,
> +	.fb_setcolreg	= unifb_setcolreg,
> +	.fb_pan_display	= unifb_pan_display,
> +#ifdef CONFIG_PUV3_UNIGFX_HWACCEL
> +	.fb_fillrect	= unifb_fillrect,
> +	.fb_copyarea	= unifb_copyarea,
> +	.fb_imageblit   = unifb_imageblit,
> +#else
> +	.fb_fillrect	= sys_fillrect,
> +	.fb_copyarea	= sys_copyarea,
> +	.fb_imageblit	= sys_imageblit,
> +#endif
> +	.fb_mmap	= unifb_mmap,
> +};
> +
There's no need for the ifdef here, all of your accel routines manually
check if acceleration is disabled or not and fall back on the sys_xxx()
paths, so it's safe to always reference them.

> +static int unifb_set_par(struct fb_info *info)
> +{
> +	int hTotal, vTotal, hSyncStart, hSyncEnd, vSyncStart, vSyncEnd;
> +	int format;
> +
> +#ifdef CONFIG_PUV3_PM
> +	struct clk *clk_vga;
> +	u32 pixclk = 0;
> +	int i;
> +
> +	for (i = 0; i <= 10; i++) {
> +		if    (info->var.xres         == unifb_modes[i].xres
> +		    && info->var.yres         == unifb_modes[i].yres
> +		    && info->var.upper_margin == unifb_modes[i].upper_margin
> +		    && info->var.lower_margin == unifb_modes[i].lower_margin
> +		    && info->var.left_margin  == unifb_modes[i].left_margin
> +		    && info->var.right_margin == unifb_modes[i].right_margin
> +		    && info->var.hsync_len    == unifb_modes[i].hsync_len
> +		    && info->var.vsync_len    == unifb_modes[i].vsync_len) {
> +			pixclk = unifb_modes[i].pixclock;
> +			break;
> +		}
> +	}
> +
> +	/* set clock rate */
> +	clk_vga = clk_get(NULL, "VGA_CLK");
> +	i = 0;

You can pass info->device to clk_get() instead of NULL. This will make it
easier to match specific clocks and lookups per device in the future.

You'll presumably also want to check if clk_get() returned an error and
handle that accordingly.

> +	if (pixclk != 0) {
> +		if (clk_set_rate(clk_vga, pixclk) == 0)
> +			i = 1;
> +	}
> +
> +	if (i == 0) {           /* set clock failed */
> +		info->fix = unifb_fix;
> +		info->var = unifb_default;
> +		clk_set_rate(clk_vga, unifb_default.pixclock);
> +	}

If clk_set_rate() can fail the first time, it can fail the second time
too. You'll want more error handling here.

> +	/* Truecolor has hardware independent palette */
> +	if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
> +		u32 v;
> +
> +		if (regno >= 16)
> +			return 1;
> +
> +		v = (red << info->var.red.offset) |
> +		    (green << info->var.green.offset) |
> +		    (blue << info->var.blue.offset) |
> +		    (transp << info->var.transp.offset);
> +		switch (info->var.bits_per_pixel) {
> +		case 8:
> +			break;
> +		case 16:
> +			((u32 *) (info->pseudo_palette))[regno] = v;
> +			break;
> +		case 24:
> +		case 32:
> +			((u32 *) (info->pseudo_palette))[regno] = v;
> +			break;
> +		}

The 16 case is no different than the 24/32 case.

The default case should also return 1 to indicate an error.

> +#ifndef MODULE
> +/*
> + * The virtual framebuffer driver is only enabled if explicitly
> + * requested by passing 'video=unifb:' (or any actual options).
> + */
> +static int __init unifb_setup(char *options)
> +{
> +	char *this_opt;
> +
> +	unifb_enable = 0;
> +
> +	if (!options)
> +		return 1;
> +
> +	unifb_enable = 1;
> +
> +	if (!*options)
> +		return 1;
> +
> +	while ((this_opt = strsep(&options, ",")) != NULL) {
> +		if (!*this_opt)
> +			continue;
> +		/* Test disable for backwards compatibility */
> +		if (!strcmp(this_opt, "disable"))
> +			unifb_enable = 0;
> +	}
> +	return 1;
> +}
> +#endif  /*  MODULE  */
> +
Just kill all of this and use the generic "off" handling.

> +static int unifb_probe(struct platform_device *dev)
> +{
> +	struct fb_info *info;
> +	int retval = -ENOMEM;
> +
> +	/*
> +	 * For real video cards we use ioremap.
> +	 */
> +	videomemory = (void *)KUSER_UNIGFX_BASE;
> +
> +	/*
> +	 * VFB could clear memory to prevent kernel info
> +	 * leakage into userspace and set black screen
> +	 * VGA-based drivers MUST NOT clear memory if
> +	 * they want to be able to take over vgacon
> +	 */
> +	/* memset(videomemory, 0, videomemorysize); */
> +
This is a remnant from a vmalloc acquired framebuffer base, so can be
killed off.

> +	info = framebuffer_alloc(sizeof(u32)*256, &dev->dev);
> +	if (!info)
> +		goto err;
> +
> +	info->screen_base = (char __iomem *)videomemory;

> +	unifb_fix.smem_start = PKUNITY_UNIGFX_MMAP_BASE;
> +	unifb_fix.smem_len = videomemorysize;
> +	unifb_fix.mmio_start = PKUNITY_UNIGFX_BASE;

All of these should be passed in via your platform device resources, with
necessary remapping.

> +	info->fix = unifb_fix;
> +	info->pseudo_palette = info->par;
> +	info->par = NULL;
> +	info->flags = FBINFO_FLAG_DEFAULT;
> +#ifdef CONFIG_PUV3_UNIGFX_HWACCEL
> +	info->fix.accel = FB_ACCEL_PUV3_UNIGFX;
> +	info->flags |= FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
> +#else
> +	info->flags |= FBINFO_HWACCEL_DISABLED;
> +#endif
> +
The accel flag is deprecated, so just drop it completely.

What happened to FBINFO_HWACCEL_IMAGEBLIT?

> +#ifdef CONFIG_PM
> +static int unifb_resume(struct platform_device *dev)
> +{
> +	int rc = 0;
> +
> +	if (dev->dev.power.power_state.event == PM_EVENT_ON)
> +		return 0;
> +
> +	acquire_console_sem();
> +
> +	if (dev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
> +		UDE_FSA = unifb_regs[0];
> +		UDE_LS  = unifb_regs[1];
> +		UDE_PS  = unifb_regs[2];
> +		UDE_HAT = unifb_regs[3];
> +		UDE_HBT = unifb_regs[4];
> +		UDE_HST = unifb_regs[5];
> +		UDE_VAT = unifb_regs[6];
> +		UDE_VBT = unifb_regs[7];
> +		UDE_VST = unifb_regs[8];
> +		UDE_CFG = unifb_regs[9];
> +	}

This is probably worth abstracting through platform data.

> +
> +static int __init unifb_init(void)
> +{
> +	int ret = 0;
> +
> +#ifndef MODULE
> +	if (fb_get_options("unifb", &unifb_option))
> +		return -ENODEV;
> +	unifb_setup(unifb_option);
> +#endif
> +
> +	if (!unifb_enable)
> +		return -ENXIO;
> +

All of this can just be replaced with:

	if (fb_get_options("unifb", NULL))
		return -ENODEV;

> +	ret = platform_driver_register(&unifb_driver);
> +
> +	if (!ret) {
> +		unifb_device = platform_device_alloc("unifb", 0);
> +
> +		if (unifb_device)
> +			ret = platform_device_add(unifb_device);
> +		else
> +			ret = -ENOMEM;
> +
> +		if (ret) {
> +			platform_device_put(unifb_device);
> +			platform_driver_unregister(&unifb_driver);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
And if your architecture will then register a platform device with the
platform data filled out, all of this can be turned in to just a simple
platform_driver_register().

> +module_init(unifb_init);
> +
> +#ifdef MODULE
> +static void __exit unifb_exit(void)
> +{
> +	platform_device_unregister(unifb_device);
> +	platform_driver_unregister(&unifb_driver);
> +}
> +
> +module_exit(unifb_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +#endif

No need for the ifdef here, either.
