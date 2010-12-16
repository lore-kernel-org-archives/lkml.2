Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0LPCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:05:36 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:32843
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754715Ab0LPCFd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:05:33 -0500
X-SpamScore: -26
X-BigFish: VS-26(zz542N1432N98dN9371Pzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
From: Chen Jie-B02280 <B02280@freescale.com>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>
Subject: RE: [PATCH 5/9] Add i.MX5 framebuffer driver
Thread-Topic: [PATCH 5/9] Add i.MX5 framebuffer driver
Thread-Index: AQHLnGYJ0AqBV9CVwU6HZN0MbQMiY5OiUOBg
Date: Thu, 16 Dec 2010 02:07:03 +0000
Message-ID: <33F32152BE7EC740BC2C838D2836AC8704B2F3@039-SN1MPN1-002.039d.mgd.msft.net>
References: <33F32152BE7EC740BC2C838D2836AC8704A957@039-SN1MPN1-002.039d.mgd.msft.net>
 <33F32152BE7EC740BC2C838D2836AC8704A9F5@039-SN1MPN1-002.039d.mgd.msft.net>
 <20101215143844.GE6017@pengutronix.de>
In-Reply-To: <20101215143844.GE6017@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sascha,



Jason Chen / Chen Jie
NMG / MAD
Freescale Semiconductor (China) Ltd.
2F, Building B, 177#, Bi Bo Rd
Pu Dong New District Shanghai 201203
Tel:     021-28937178 
Fax:     021-28937444
E-mail:  Jason.Chen@freescale.com


-----Original Message-----
From: saschahauer@web.de [mailto:saschahauer@web.de] On Behalf Of s.hauer@pengutronix.de
Sent: Wednesday, December 15, 2010 10:39 PM
To: Chen Jie-B02280
Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org; Zhang Lily-R58066; arnaud.patard@rtp-net.org
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver

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

As said before, I have no interest in making the overlay fully functional atm. So either we'll leave it here for reference if someone ever tries to implement it properly or I'll remove it completely.
[Jason] Ok, then pls keep it as reference.

> > +static int imx_ipu_fb_set_par(struct fb_info *fbi) {
> > +       int ret;
> > +       struct ipu_di_signal_cfg sig_cfg;
> > +       struct imx_ipu_fb_info *mxc_fbi = fbi->par;
> > +       u32 out_pixel_fmt;
> > +       int interlaced = 0;
> > +       struct fb_var_screeninfo *var = &fbi->var;
> > +       int enabled = mxc_fbi->enabled;
> > +
> > +       dev_dbg(fbi->device, "Reconfiguring framebuffer %dx%d-%d\n",
> > +               fbi->var.xres, fbi->var.yres, 
> > + fbi->var.bits_per_pixel);
> > +
> > +       if (enabled)
> > +               imx_ipu_fb_disable(fbi);
> > +
> > +       fbi->fix.line_length = var->xres_virtual * 
> > + var->bits_per_pixel / 8;
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
> > +               struct fb_info *info) {
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
[Jason] Yes, you are right.


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


