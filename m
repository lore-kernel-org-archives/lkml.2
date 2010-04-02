Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab0DBND3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 09:03:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:39572 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757728Ab0DBNDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 09:03:22 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18AVmhq1/8AkkVUH8ATp8Dzq/2vuifHs9ZrAfM45s
	lvENZ+1co6Y5lz
Message-ID: <4BB5EB16.8010408@gmx.de>
Date: Fri, 02 Apr 2010 15:03:18 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: akpm@linux-foundation.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, JBeulich@novell.com,
       ben.collins@canonical.com
Subject: Re: + fbdev-section-cleanup-in-vesafb.patch added to -mm tree
References: <201003312144.o2VLifB0010456@imap1.linux-foundation.org> <4BB5E2E3.20802@nachtwindheim.de>
In-Reply-To: <4BB5E2E3.20802@nachtwindheim.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Henrik Kretzschmar schrieb:
> Please also drop from you tree the fbdev-section-cleanup-in-vesafb.patch
> 
> I wrote it in the believe that it's a module, which is not the case in mainline.
> So my patch would make the section mismatch warnings go away,
> but hides that theres more work than that to do.
> 
> Jan Beulich wrote on linux-fbdev-ml a patch which assumes that vesafb is builtin (1st patch).
> Ben Collins from Canonical had patched their lucid-kernel that vesafb is a module instead (2nd patch).
> So the first question is if it makes sense to have the vesafb driver as a module,
> before deciding what comes in which section.
> 
> Does someone have an idea about that?

I don't know VESA too well but if I understand it right its as the 
header of vesafb states:
"switching to graphics mode happens at boot time (while running in real 
mode, see arch/i386/boot/video.S)."
that means that most of the work is done during boot and that's why a 
module based on this probably won't work. Was the Ubuntu module tested 
successfully?
That's also the reason for vesafb not supporting mode switching as it 
can only select the mode during boot as long as the VESA BIOS is 
available. There is an alternative uvesafb in the kernel which doesn't 
have these limitations but requires some userspace tools to work (AFAIK 
they execute/emulate the VESA BIOS there)


Regards,

Florian Tobias Schandinat

> From: Jan Beulich <JBeulich@novell.com>
> Date: Fri, Mar 26, 2010 at 17:48
> Subject: [PATCH] vesafb: use platform_driver_probe() instead of
> platform_driver_register()
> To: u.kleine-koenig@pengutronix.de, gregkh@suse.de
> Cc: linux-kernel@vger.kernel.org
> 
> 
> Commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b introduced a huge
> amount of section mismatch warnings in vesafb code. Rather than
> converting all of the annotations, do the obvious and revert the
> __init -> __devinit change, and use the recommended (in that patch)
> alternative to calling platform_driver_register(): vesafb depends on
> information obtained from by kernel at boot time, cannot be a module,
> and no post-boot devices can ever show up.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  drivers/video/vesafb.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> --- linux-2.6.34-rc2/drivers/video/vesafb.c
> +++ 2.6.34-rc2-vesafb-init/drivers/video/vesafb.c
> @@ -226,7 +226,7 @@ static int __init vesafb_setup(char *opt
>        return 0;
>  }
> 
> -static int __devinit vesafb_probe(struct platform_device *dev)
> +static int __init vesafb_probe(struct platform_device *dev)
>  {
>        struct fb_info *info;
>        int i, err;
> @@ -477,7 +477,6 @@ err:
>  }
> 
>  static struct platform_driver vesafb_driver = {
> -       .probe  = vesafb_probe,
>        .driver = {
>                .name   = "vesafb",
>        },
> @@ -493,20 +492,21 @@ static int __init vesafb_init(void)
>        /* ignore error return of fb_get_options */
>        fb_get_options("vesafb", &option);
>        vesafb_setup(option);
> -       ret = platform_driver_register(&vesafb_driver);
> 
> +       vesafb_device = platform_device_alloc("vesafb", 0);
> +       if (!vesafb_device)
> +               return -ENOMEM;
> +
> +       ret = platform_device_add(vesafb_device);
>        if (!ret) {
> -               vesafb_device = platform_device_alloc("vesafb", 0);
> +               ret = platform_driver_probe(&vesafb_driver, vesafb_probe);
> +               if (ret)
> +                       platform_device_del(vesafb_device);
> +       }
> 
> -               if (vesafb_device)
> -                       ret = platform_device_add(vesafb_device);
> -               else
> -                       ret = -ENOMEM;
> -
> -               if (ret) {
> -                       platform_device_put(vesafb_device);
> -                       platform_driver_unregister(&vesafb_driver);
> -               }
> +       if (ret) {
> +               platform_device_put(vesafb_device);
> +               vesafb_device = NULL;
>        }
> 
>        return ret;
> 
> 
> 
> --
> 
> commit 0afa62be6d93770801581d915667d89f38a60d37
> Author: Ben Collins <ben.collins@canonical.com>
> Date:   Tue Oct 14 11:30:10 2008 -0400
> 
>     UBUNTU: SAUCE: (no-up) Modularize vesafb
>     
>     Signed-off-by: Ben Collins <ben.collins@canonical.com>
> 
> diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
> index bd37ee1..0bcae3c 100644
> --- a/drivers/video/vesafb.c
> +++ b/drivers/video/vesafb.c
> @@ -28,6 +28,12 @@
>  #define dac_reg	(0x3c8)
>  #define dac_val	(0x3c9)
>  
> +struct vesafb_info
> +{
> +	u32 pseudo_palette[256];
> +	int mtrr_hdl;
> +};
> +
>  /* --------------------------------------------------------------------- */
>  
>  static struct fb_var_screeninfo vesafb_defined __initdata = {
> @@ -47,16 +53,37 @@ static struct fb_fix_screeninfo vesafb_fix __initdata = {
>  	.accel	= FB_ACCEL_NONE,
>  };
>  
> +#ifndef MODULE
>  static int   inverse    __read_mostly;
> +#endif
>  static int   mtrr       __read_mostly;		/* disable mtrr */
>  static int   vram_remap __initdata;		/* Set amount of memory to be used */
>  static int   vram_total __initdata;		/* Set total amount of memory */
>  static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
> +static int	redraw		__read_mostly;
>  static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
> +static int	ywrap		__read_mostly;
>  static void  (*pmi_start)(void) __read_mostly;
>  static void  (*pmi_pal)  (void) __read_mostly;
>  static int   depth      __read_mostly;
>  static int   vga_compat __read_mostly;
> +
> +module_param(redraw, bool, 0);
> +module_param(ypan, bool, 0);
> +module_param(ywrap, bool, 0);
> +module_param_named(vgapal, pmi_setpal, invbool, 0);
> +MODULE_PARM_DESC(vgapal, "Use VGA for setting palette (default)");
> +module_param_named(pmipal, pmi_setpal, bool, 0);
> +MODULE_PARM_DESC(pmipal, "Use PMI for setting palette");
> +module_param(mtrr, bool, 0);
> +MODULE_PARM_DESC(mtrr, "Enable MTRR support (default)");
> +module_param_named(nomtrr, mtrr, invbool, 0);
> +MODULE_PARM_DESC(nomtrr, "Disable MTRR support");
> +module_param(vram_remap, int, 0);
> +MODULE_PARM_DESC(vram_remap, "Set total amount of memory to be used");
> +module_param(vram_total, int, 0);
> +MODULE_PARM_DESC(vram_total, "Total amount of memory");
> +
>  /* --------------------------------------------------------------------- */
>  
>  static int vesafb_pan_display(struct fb_var_screeninfo *var,
> @@ -192,6 +219,7 @@ static struct fb_ops vesafb_ops = {
>  	.fb_imageblit	= cfb_imageblit,
>  };
>  
> +#ifndef MODULE
>  static int __init vesafb_setup(char *options)
>  {
>  	char *this_opt;
> @@ -225,6 +253,7 @@ static int __init vesafb_setup(char *options)
>  	}
>  	return 0;
>  }
> +#endif
>  
>  static int __init vesafb_probe(struct platform_device *dev)
>  {
> @@ -476,8 +505,28 @@ err:
>  	return err;
>  }
>  
> +static int __exit vesafb_remove(struct platform_device *device)
> +{
> +	struct fb_info *info = dev_get_drvdata(&device->dev);
> +
> +	unregister_framebuffer(info);
> +#ifdef CONFIG_MTRR
> +	{
> +		struct vesafb_info *vfb_info = (struct vesafb_info *) info->par;
> +		if (vfb_info->mtrr_hdl >= 0)
> +			mtrr_del(vfb_info->mtrr_hdl, 0, 0);
> +	}
> +#endif
> +	iounmap(info->screen_base);
> +	framebuffer_release(info);
> +	release_mem_region(vesafb_fix.smem_start, vesafb_fix.smem_len);
> +
> +	return 0;
> +}
> +
>  static struct platform_driver vesafb_driver = {
>  	.probe	= vesafb_probe,
> +	.remove = vesafb_remove,
>  	.driver	= {
>  		.name	= "vesafb",
>  	},
> @@ -488,11 +537,18 @@ static struct platform_device *vesafb_device;
>  static int __init vesafb_init(void)
>  {
>  	int ret;
> +#ifndef MODULE
>  	char *option = NULL;
>  
>  	/* ignore error return of fb_get_options */
>  	fb_get_options("vesafb", &option);
>  	vesafb_setup(option);
> +#else
> +	if (redraw)
> +		ypan = 0;
> +	if (ywrap)
> +		ypan = 2;
> +#endif
>  	ret = platform_driver_register(&vesafb_driver);
>  
>  	if (!ret) {
> @@ -511,6 +567,14 @@ static int __init vesafb_init(void)
>  
>  	return ret;
>  }
> +
> +static void __exit vesafb_exit(void)
> +{
> +	platform_device_unregister(vesafb_device);
> +	platform_driver_unregister(&vesafb_driver);
> +}
> +
>  module_init(vesafb_init);
> +module_exit(vesafb_exit);
>  
>  MODULE_LICENSE("GPL");
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

