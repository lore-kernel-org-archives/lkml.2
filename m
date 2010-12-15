Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0LOOkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:40:16 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:40864 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0LOOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:40:15 -0500
Date: Wed, 15 Dec 2010 15:38:44 +0100
From: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To: Chen Jie-B02280 <B02280@freescale.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver
Message-ID: <20101215143844.GE6017@pengutronix.de>
References: <33F32152BE7EC740BC2C838D2836AC8704A957@039-SN1MPN1-002.039d.mgd.msft.net> <33F32152BE7EC740BC2C838D2836AC8704A9F5@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33F32152BE7EC740BC2C838D2836AC8704A9F5@039-SN1MPN1-002.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:31:29 up 165 days,  5:42, 62 users,  load average: 0.30, 1.26,
	1.10
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX1/gXAv2uyHiIwMEaj2SJRyemoOh0drHj95J0eXU
	JxDYxZSFVwT0OiTKKo1HjKksR5C/lRH/rqdzQXlpGoSavG7BBI
	VvicDrUp4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:38:08PM +0000, Chen Jie-B02280 wrote:
> Hi, Sascha,
> 
> Few comments inline with [Jason]

Please consider switching to a sane mailer which is able to quote correctly.

> 
> I have following comments to this patch:
> 1) Please modify the commit message, as IPUv3 is not embedded in i.MX50 SoC.
> 2) ADC is not supported yet in the framebuffer driver, so please
> modify this comment:
>   > + * Framebuffer Framebuffer Driver for SDC and ADC.
> 3) 'ipu_dp_set_window_pos()' is called only once in
> imx_ipu_fb_set_par_overlay(). So, the framebuffer driver doesn't
> support to change the overlay framebuffer position. Need a
> mechanism/interface for users to change the overlay framebuffer
> position.
> [Jason] DP-FG should be one fb device, sequence ioctl should be added
> after it, like global alpha , color key etc.

As said before, I have no interest in making the overlay fully
functional atm. So either we'll leave it here for reference if someone
ever tries to implement it properly or I'll remove it completely.

> > +static int imx_ipu_fb_set_par(struct fb_info *fbi)
> > +{
> > +       int ret;
> > +       struct ipu_di_signal_cfg sig_cfg;
> > +       struct imx_ipu_fb_info *mxc_fbi = fbi->par;
> > +       u32 out_pixel_fmt;
> > +       int interlaced = 0;
> > +       struct fb_var_screeninfo *var = &fbi->var;
> > +       int enabled = mxc_fbi->enabled;
> > +
> > +       dev_dbg(fbi->device, "Reconfiguring framebuffer %dx%d-%d\n",
> > +               fbi->var.xres, fbi->var.yres, fbi->var.bits_per_pixel);
> > +
> > +       if (enabled)
> > +               imx_ipu_fb_disable(fbi);
> > +
> > +       fbi->fix.line_length = var->xres_virtual * var->bits_per_pixel / 8;
> > +
> > +       var->yres_virtual = var->yres;
> > +
> > +       ret = imx_ipu_fb_map_video_memory(fbi);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (var->vmode & FB_VMODE_INTERLACED)
> > +               interlaced = 1;
> > +
> > +       memset(&sig_cfg, 0, sizeof(sig_cfg));
> > +       out_pixel_fmt = mxc_fbi->ipu_di_pix_fmt;
> > +
> > +       if (var->vmode & FB_VMODE_INTERLACED)
> > +               sig_cfg.interlaced = 1;
> > +       if (var->vmode & FB_VMODE_ODD_FLD_FIRST) /* PAL */
> > +               sig_cfg.odd_field_first = 1;
> > +       if (var->sync & FB_SYNC_EXT)
> > +               sig_cfg.ext_clk = 1;
> [Jason] FB_SYNC_EXT has not be used in FSL kernel mainline, it
> represent SYNC ext, should not be flag of ext clk. Some application
> for example X-server could not recognize it.

Ok, I'll remove it.


> > +static int imx_ipu_fb_pan_display(struct fb_var_screeninfo *var,
> > +               struct fb_info *info)
> > +{
> > +       struct imx_ipu_fb_info *mxc_fbi = info->par;
> > +       unsigned long base;
> > +       int ret;
> > +
> > +       if (info->var.yoffset == var->yoffset)
> > +               return 0;       /* No change, do nothing */
> > +
> > +       base = var->yoffset * var->xres_virtual * var->bits_per_pixel / 8;
> > +       base += info->fix.smem_start;
> > +
> > +       ret = ipu_wait_for_interrupt(IPU_IRQ_EOF(mxc_fbi->ipu_channel_num), 100);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (ipu_idmac_update_channel_buffer(mxc_fbi->ipu_ch, 0, base)) {
> > +               dev_err(info->device,
> > +                       "Error updating SDC buf to address=0x%08lX\n", base);
> > +       }
> [Jason] It's better to enable double -buffer for fb which could avoid tearing issue.

There is no tearing as the switching is done during vsync.


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
