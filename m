Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982Ab1IOPDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:03:40 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37640 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab1IOPDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:03:38 -0400
MIME-Version: 1.0
In-Reply-To: <1316088425.11294.78.camel@lappyti>
References: <1316088425.11294.78.camel@lappyti>
Date: Fri, 16 Sep 2011 00:03:37 +0900
X-Google-Sender-Auth: Q14nZm-HVgH5W6FswJDlsNCFNZY
Message-ID: <CAH9JG2XHZC4RoALXKtZtyRx1hEu+J+pT_j8+jP3SOUKUEnQRVQ@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Kyungmin Park <kmpark@infradead.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        Archit Taneja <archit@ti.com>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Thu, Sep 15, 2011 at 9:07 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi,
>
> I am the author of OMAP display driver, and while developing it I've
> often felt that there's something missing in Linux's display area. I've
> been planning to write a post about this for a few years already, but I
> never got to it. So here goes at last!
>
> ---
>
> First I want to (try to) describe shortly what we have on OMAP, to give
> a bit of a background for my point of view, and to have an example HW.
>
> The display subsystem (DSS) hardware on OMAP handles only showing pixels
> on a display, so it doesn't contain anything that produces pixels like
> 3D stuff or accelerated copying. All it does is fetch pixels from SDRAM,
> possibly do some modifications for them (color format conversions etc),
> and output them to a display.
>
> The hardware has multiple overlays, which are like hardware windows.
> They fetch pixels from SDRAM, and output them in a certain area on the
> display (possibly with scaling). Multiple overlays can be composited
> into one output.
>
> So we may have something like this, when all overlays read pixels from
> separate areas in the memory, and all overlays are on LCD display:
>
>  .-----.         .------.           .------.
>  | mem |-------->| ovl0 |-----.---->| LCD  |
>  '-----'         '------'     |     '------'
>  .-----.         .------.     |
>  | mem |-------->| ovl1 |-----|
>  '-----'         '------'     |
>  .-----.         .------.     |     .------.
>  | mem |-------->| ovl2 |-----'     |  TV  |
>  '-----'         '------'           '------'
>
Same feature at samsung display subsystem.

> The LCD display can be rather simple one, like a standard monitor or a
> simple panel directly connected to parallel RGB output, or a more
> complex one. A complex panel needs something else than just
> turn-it-on-and-go. This may involve sending and receiving messages
> between OMAP and the panel, but more generally, there's need to have
> custom code that handles the particular panel. And the complex panel is
> not necessarily a panel at all, it may be a buffer chip between OMAP and
> the actual panel.
>
> The software side can be divided into three parts: the lower level
> omapdss driver, the lower level panel drivers, and higher level drivers
> like omapfb, v4l2 and omapdrm.

Current omapdrm codes use the omapfb and omapdss codes even though
omapdrm is located drivers/staging, some time later it should be
drivers/gpu/gem/omap. but it still uses the drivers/video/omap2/dss
codes.
In case of samsung DRM, it has almost similar codes for lowlevel
access from the drivers/video/s3c-fb.c for FIMD and
drivers/media/video/s5p-tv for HDMI.


>
> The omapdss driver handles the OMAP DSS hardware, and offers a kernel
> internal API which the higher level drivers use. The omapdss does not
> know anything about fb or drm, it just offers core display services.
>
> The panel drivers handle particular panels/chips. The panel driver may
> be very simple in case of a conventional display, basically doing pretty
> much nothing, or bigger piece of code, handling communication with the
> panel.
>
> The higher level drivers handle buffers and tell omapdss things like
> where to find the pixels, what size the overlays should be, and use the
> omapdss API to turn displays on/off, etc.
>
> ---
>
> There are two things that I'm proposing to improve the Linux display
> support:
>
> First, there should be a bunch of common video structs and helpers that
> are independent of any higher level framework. Things like video
> timings, mode databases, and EDID seem to be implemented multiple times
> in the kernel. But there shouldn't be anything in those things that
> depend on any particular display framework, so they could be implemented
> just once and all the frameworks could use them.
>
> Second, I think there could be use for a common low level display
> framework. Currently the lower level code (display HW handling, etc.)
> and higher level code (buffer management, policies, etc) seem to be
> usually tied together, like the fb framework or the drm. Granted, the
> frameworks do not force that, and for OMAP we indeed have omapfb and
> omapdrm using the lower level omapdss. But I don't see that it's
> anything OMAP specific as such.

So I suggest the create the drivers/graphics for lowlevel codes and
each framework, DRM, V4L2 and FB uses these lowlevel codes.

Thank you,
Kyungmin Park
>
> I think the lower level framework could have components something like
> this (the naming is OMAP oriented, of course):
>
> overlay - a hardware "window", gets pixels from memory, possibly does
> format conversions, scaling, etc.
>
> overlay compositor - composes multiple overlays into one output,
> possibly doing things like translucency.
>
> output - gets the pixels from overlay compositor, and sends them out
> according to particular video timings when using conventional video
> interface, or via any other mean when using non-conventional video buses
> like DSI command mode.
>
> display - handles an external display. For conventional displays this
> wouldn't do much, but for complex ones it does whatever needed by that
> particular display.
>
> This is something similar to what DRM has, I believe. The biggest
> difference is that the display can be a full blown driver for a complex
> piece of HW.
>
> This kind of low level framework would be good for two purposes: 1) I
> think it's a good division generally, having the low level HW driver
> separate from the higher level buffer/policy management and 2) fb, drm,
> v4l2 or any possible future framework could all use the same low level
> framework.
>
> ---
>
> Now, I'm quite sure the above framework could work quite well with any
> OMAP like hardware, with unified memory (i.e. the video buffers are in
> SDRAM) and 3D chips and similar components are separate. But what I'm
> not sure is how desktop world's gfx cards change things. Most probably
> all the above components can be found from there also in some form, but
> are there some interdependencies between 3D/buffer management/something
> else and the video output side?
>
> This was a very rough and quite short proposal, but I'm happy to improve
> and extend it if it's not totally shot down.
>
>  Tomi
>
>
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
>
