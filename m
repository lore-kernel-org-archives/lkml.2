Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1AFEtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:49:03 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53114 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1AFEtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:49:01 -0500
Date: Thu, 6 Jan 2011 13:47:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] video, sm501: add OF binding to support SM501
Message-ID: <20110106044702.GO23889@linux-sh.org>
References: <1291451028-22532-1-git-send-email-hs@denx.de> <1292049075-1809-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292049075-1809-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 07:31:15AM +0100, Heiko Schocher wrote:
> - add binding to OF, compatible name "smi,sm501"
> 
> - add read/write functions for using this driver
>   also on powerpc plattforms
> 
> - add commandline options:
>   sm501.fb_mode:
>     Specify resolution as "<xres>x<yres>[-<bpp>][@<refresh>]"
>   sm501.bpp:
>     Specify bit-per-pixel if not specified mode
> 
> - Add support for encoding display mode information
>   in the device tree using verbatim EDID block.
> 
>   If the "edid" entry in the "smi,sm501" node is present,
>   the driver will build mode database using EDID data
>   and allow setting the display modes from this database.
> 
> Signed-off-by: Heiko Schocher <hs@denx.de>
> cc: linux-fbdev@vger.kernel.org
> cc: devicetree-discuss@ozlabs.org
> cc: Ben Dooks <ben@simtec.co.uk>
> cc: Vincent Sanders <vince@simtec.co.uk>
> cc: Samuel Ortiz <sameo@linux.intel.com>
> cc: linux-kernel@vger.kernel.org
> 
> ---
> - changes since v1:
>   add Ben Dooks, Vincent Sanders and Samuel Ortiz to cc, as suggested from
>   Paul Mundt.
> 
>  Documentation/kernel-parameters.txt          |    7 +
>  Documentation/powerpc/dts-bindings/sm501.txt |   30 +++
>  drivers/mfd/sm501.c                          |  141 ++++++++------
>  drivers/video/sm501fb.c                      |  264 +++++++++++++++++---------
>  include/linux/sm501.h                        |    8 +
>  5 files changed, 299 insertions(+), 151 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt
> 
So has this stalled out? If Samuel wants to ack the MFD bits I don't mind
taking it through the fbdev tree. I can dust off an SM501 board to make
sure it still works for the non-OF case, although most of the changes
look fairly mechanical, so I don't forsee too much difficulty.

A few minor notes however. For starters, it would be nice to see this
patch split out a bit more logically. All of the items in your changelog
are more or less independent logical changes, and should really be
independent patches. As such, I'd like to see the EDID support as one
patch, the OF binding support layered on top of that, the documentation
split out as a trivial patch, and the I/O routine thing dealt with
separately. This should also make it easier for Samuel to simply ack the
OF bindings part that touch the MFD driver without having to be bothered
with any of the other stuff should regressions pop up at a later point in
time via a bisection.

As far as the DTS bindings documentation goes, I'm not sure what the best
way to split that out is. Perhaps simply lumping it in with the OF
bindings makes the most logical sense, and it's obviously a dependency
for the architecture-specific portion as well.

> @@ -1698,6 +1727,9 @@ static int sm501fb_init_fb(struct fb_info *fb,
>  	fb->fbops = &par->ops;
>  	fb->flags = FBINFO_FLAG_DEFAULT | FBINFO_READS_FAST |
>  		FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
> +#if defined(CONFIG_PPC_MPC52xx)
> +		FBINFO_FOREIGN_ENDIAN |
> +#endif
>  		FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
>  
>  	/* fixed data */

This is now getting in to deep hack territory. It's also not entirely
obvious how you expect things like the imageblit op to work given that
you're not selecting any of FB_{BIG,LITTLE,BOTH,FOREIGN}_ENDIAN, which
leads me to suspect you are manually doing this in your .config in a
relatively fragile way.

In the OF case I suppose you probably want something like:

#ifdef __BIG_ENDIAN
        if (of_get_property(dp, "little-endian", NULL))
                foreign_endian = FBINFO_FOREIGN_ENDIAN;
#else
        if (of_get_property(dp, "big-endian", NULL))
                foreign_endian = FBINFO_FOREIGN_ENDIAN;
#endif

and then simply hide the details in the DTS file in order to get rid of
CPU-specific hacks.

> +#if defined(CONFIG_PPC_MPC52xx)
> +#define smc501_readl(addr)	__do_readl_be((addr))
> +#define smc501_writel(val, addr)	__do_writel_be((val), (addr))
> +#else
> +#define smc501_readl(addr)		readl(addr)
> +#define smc501_writel(val, addr)	writel(val, addr)
> +#endif

Based on the Kconfig option for endianness you could probably just wrap these
to ioread/write32{,be} and hide the semantics in your iomap implementation?
