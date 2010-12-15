Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0LOLSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 06:18:36 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:39110 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0LOLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 06:18:34 -0500
Date: Wed, 15 Dec 2010 12:17:41 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Liu Ying <liu.y.victor@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver
Message-ID: <20101215111741.GB6017@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-6-git-send-email-s.hauer@pengutronix.de> <AANLkTikZowDCK4JPiCyEou1ekRuYA1qGnKrBPT5dXB+8@mail.gmail.com> <20101213113830.GE6017@pengutronix.de> <AANLkTikwTjUUzc6BovFKXq-FverNMqg-ustodk+sKUCY@mail.gmail.com> <20101214084546.GT6017@pengutronix.de> <AANLkTimG644a0-dKejs1gidboa+0NJBB9XC3ohkF2xs4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimG644a0-dKejs1gidboa+0NJBB9XC3ohkF2xs4@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:16:50 up 165 days,  2:27, 60 users,  load average: 0.87, 1.32,
	0.81
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX1+22wnjhQzBjijXcxJO14DzK8qv1UVMXN4XHGuF
	FzfI3MFrOVs0R2A8YVEFEoVMb+z05qJsnU+Z/na+JcYLMvU+ci
	y3/7qeSoY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 09:23:30PM +0800, Liu Ying wrote:
> 2010/12/14 Sascha Hauer <s.hauer@pengutronix.de>:
> > On Tue, Dec 14, 2010 at 02:40:09PM +0800, Liu Ying wrote:
> >> Hello, Sascha,
> >>
> >> Please find my feedback with [LY] embedded.
> >>
> >> And, a bug related with this patch:
> >> 1) Bootup the babbage board.
> >> 2) echo U:640x480p-60 > /sys/class/graphics/fb0/mode
> >> 3) cat /sys/class/graphics/fb0/virtual_size, it shows '640,480'.
> >> 4) echo 640,960 > /sys/class/graphics/fb0/virtual_size, change virtual
> >> yres to be 960.
> >> 5) cat /sys/class/graphics/fb0/virtual_size, it still shows '640,480'.
> >> I think this is caused by 'var->yres_virtual = var->yres;' in custom
> >> fb_set_par() function(Sorry, I cannot make the comment inline this
> >> time, as I don't find the original code within the mail I am
> >> replying). This makes fb0 use only one block of memory whose size is
> >> equal to screen size, so pan display can not really play her role and
> >> screen tearing issue may happen.
> 
> Sascha,
> 
> Just would like to know if you've caught this bug.

Yes, it will be fixed in the next series. It was the framebuffer driver
forcing yres_virtual to yres in set_par.

Sascha

> 
> >>
> >> Best Regards,
> >> Liu Ying
> >>
> >> 2010/12/13 Sascha Hauer <s.hauer@pengutronix.de>:
> >> > On Sun, Dec 12, 2010 at 02:13:40PM +0800, Liu Ying wrote:
> >> >> Hello, Sascha,
> >> >>
> >> >> I have following comments to this patch:
> >> >> 1) Please modify the commit message, as IPUv3 is not embedded in i.MX50 SoC.
> >> >
> >> > ok.
> >> >
> >> >> 2) ADC is not supported yet in the framebuffer driver, so please
> >> >> modify this comment:
> >> >>    > + * Framebuffer Framebuffer Driver for SDC and ADC.
> >> >
> >> > ok.
> >> >
> >> >> 3) 'ipu_dp_set_window_pos()' is called only once in
> >> >> imx_ipu_fb_set_par_overlay(). So, the framebuffer driver doesn't
> >> >> support to change the overlay framebuffer position. Need a
> >> >> mechanism/interface for users to change the overlay framebuffer
> >> >> position.
> >> >
> >> > Yes. The overlay support is currently only present in the driver because
> >> > I didn't want to break it in general. There is no generic overlay API in
> >> > the kernel and I didn't want to invent the n+1 API. Currently the
> >> > possible use cases of the overlay support are not clear to me. Number
> >> > one use case would probably be to display video output, but the
> >> > corresponding driver would be a v4l2 driver, so in this case we would
> >> > only need an in-kernel API.
> >> > Anyway, I have not the resources to implement complete overlay support.
> >> > So either we keep it like it is and it more has an example character
> >> > or we remove it completely from the driver for now.
> >> >
> >> >> 4) Need to make sure the framebuffer on DP-FG is blanked before the
> >> >> framebuffer on DP-BG is blanked. Meanwhile, the framebuffer on DP-FG
> >> >> should be unblanked after the framebuffer on DP-BG is unblanked
> >> >> 5) Need to check the framebuffer on DP-FG doesn't run out of the range
> >> >> of the framebuffer on DP-BG.
> >> >
> >> > I tend to remove the overlay support.
> >> >
> >> >> 6) I prefer to find the video mode in modedb first, and if we cannot
> >> >> find the video mode in common video mode data base, we can find a
> >> >> video mode in custom video mode data base which is defined in platform
> >> >> data. In this way, we don't need to export common modefb.
> >> >
> >> > I exported the modedb to be able to show the different modes under
> >> > /sys/class/graphics/fb0/modes and to set it with
> >> > /sys/class/graphics/fb0/mode. If you want this there is no way around
> >> > exporting it. The ioctl interface for mode setting is independent of the
> >> > specific modes anyway.
> >> [LY]  Just a concern. If a platform choose to add the generic video
> >> mode data base to IPUv3 framebuffer modelist, 'cat
> >> /sys/class/graphics/fb0/modes' will show all the video modes in the
> >> generic data base to users. I am not sure whether showing them to
> >> users means the IPUv3 framebuffer driver acknowledges to support all
> >> of them or not. I tried to do 'echo U:1800x1440p-70 >
> >> /sys/class/graphics/fb0/mode' with the kernel on ipuv3 branch, there
> >> will be a kernel dump(seems it can not allocate enough memory).
> >
> > We'll have to increase the dma coherent size (and max zone order) for
> > these resolutions to work. I have patches for this in my local tree but
> > decided to wait until some contiguous memory allocator hits the tree.
> > Also, the fb driver should sanity check the generic modes before adding
> > them to the list. FOr example the IPU can't do 1920x1200@60. This code
> > is missing currently.
> >
> > Sascha
> >
> >
> > --
> > Pengutronix e.K.                           |                             |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> > Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> >
> 
> 
> 
> -- 
> Best Regards,
> Liu Ying
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
