Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1ISH33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:29:29 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51281 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab1ISH32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:29:28 -0400
Subject: Re: Proposal for a low-level Linux display framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Keith Packard <keithp@keithp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
In-Reply-To: <yunfwjtauqg.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	 <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari>
	 <yun8vpp7qk7.fsf@aiko.keithp.com> <1316107275.23214.99.camel@deskari>
	 <yunfwjxwbjq.fsf@aiko.keithp.com>
	 <20110916175326.54567b14@lxorguk.ukuu.org.uk>
	 <1316414014.1978.12.camel@deskari>  <yunfwjtauqg.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 10:29:21 +0300
Message-ID: <1316417361.1978.48.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-18 at 23:53 -0700, Keith Packard wrote:
> On Mon, 19 Sep 2011 09:33:34 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> 
> > I think it's a bit more complex than that. True, there are MIPI
> > standards, for the video there are DPI, DBI, DSI, and for the commands
> > there is DCS. And, as you mentioned, many panels need custom
> > initialization, or support only parts of the DCS, or have other
> > quirks.
> 
> So DSI is more like i2c than the DisplayPort aux channel or DDC. That

Well, not quite. DSI is like DisplayPort and DisplayPort aux combined;
there's only one bus, DSI, which is used to transfer video data and
commands.

For DSI video mode, the transfer is somewhat like traditional displays,
and video data is send according to a pixel clock as a constant stream.
However, before the video stream is enabled the bus can be used in
bi-directional communication. And even when the video stream is enabled,
there can be other communication in the blanking periods.

For DSI command mode the transfer is a bit like high speed i2c; messages
are sent when needed (when the userspace gives the command to update),
without any strict timings. In practice this means that the peripheral
needs to have a framebuffer memory of its own, which it uses to refresh
the actual panel (or send the pixels forward to another peripheral).

As the use patterns of these two types of displays are quite different,
we have the terms auto-update and manual-update displays for them.

> seems fine; you can create a DSI infrastructure like the i2c
> infrastructure and then just have your display drivers use it to talk to
> the panel. We might eventually end up with some shared DRM code to deal
> with common DSI functions for display devices, like the EDID code
> today, but that doesn't need to happen before you can write your first
> DSI-using display driver.

One difference with i2c and DSI is that i2c is independent of the video
path, so it's easy to keep that separate from DRM. But for DSI the data
is produced by the video hardware using the overlays, encoders etc. I
don't quite see how we could have an i2c-like separate DSI API, which
wasn't part of DRM.

And even in simpler case MIPI DPI, which is a traditional parallel RGB
interface, a panel may need custom configuration via, say, i2c or spi.
We can, of course, create a i2c device driver for the panel, but how is
that then connected to DRM? The i2c driver may need to know things like
when the display is enabled/disabled, about backlight changes, or any
other display related event.

Is there a way for the i2c driver to get these events, and add new
properties to the DRM (say, if the panel has a feature configured via
i2c, but we'd like it to be visible to the userspace via the DRM
driver)?

 Tomi


