Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1IORVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:21:23 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48183 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756494Ab1IORVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:21:20 -0400
Subject: Re: Proposal for a low-level Linux display framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
In-Reply-To: <yun8vpp7qk7.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	 <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari>
	 <yun8vpp7qk7.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 20:21:15 +0300
Message-ID: <1316107275.23214.99.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 10:50 -0500, Keith Packard wrote:
> On Thu, 15 Sep 2011 18:29:54 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> 
> > 1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
> > the plan is to make DRM the core Linux display framework, upon which
> > everything else is built, and fb and v4l2 are changed to use DRM.
> 
> I'd like to think we could make DRM the underlying display framework;
> it already exposes an fb interface, and with overlays, a bit more of the
> v4l2 stuff is done as well. Certainly eliminating three copies of mode
> setting infrastructure would be nice...

Ok, sounds good to me. We (as in OMAP display people) are already
planning to take DRM into use, so no problem there.

> > But even if it was done like that, I see that it's combining two
> > separate things: 1) the lower level HW control, and 2) the upper level
> > buffer management, policies and userspace interfaces.
> 
> Those are split between the DRM layer and the underlying device driver,
> which provides both kernel (via fb) and user space interfaces.

I'm not so familiar with DRM, but with device driver you mean a driver
for the the hardware which handles display output (gfx cards or whatever
it is on that platform)?

If so, it sounds good. That quite well matches what omapdss driver does
currently for us. But we still have semi-complex omapdrm between omapdss
and the standard drm layer.

Rob, would you say omapdrm is more of a DRM wrapper for omapdss than a
real separate entity? If so, then we could possibly in the future (when
nobody else uses omapdss) change omapdss to support DRM natively. (or
make omapdrm support omap HW natively, which ever way =).

> > 2) It's missing the panel driver part. This is rather important on
> > embedded systems, as the panels often are not "dummy" panels, but they
> > need things like custom initialization, sending commands to adjust
> > backlight, etc.
> 
> We integrate the panel (and other video output) drivers into the device
> drivers. With desktop chips, they're not easily separable. None of the
> desktop output drivers are simple; things like DisplayPort require link
> training, and everyone needs EDID. We share some of that code in the DRM
> layer today, and it would be nice to share even more.

I don't think we speak of similar panel drivers. I think there are two
different drivers here:

1) output drivers, handles the output from the SoC / gfx card. For
example DVI, DisplayPort, MIPI DPI/DBI/DSI.

2) panel drivers, handles panel specific things. Each panel may support
custom commands and features, for which we need a dedicated driver. And
this driver is not platform specific, but should work with any platform
which has the output used with the panel.

As an example, DSI command mode displays can be quite complex:

DSI bus is a half-duplex serial bus, and while it's designed for
displays you could use it easily for any communication between the SoC
and the peripheral.

The panel could have a feature like content adaptive backlight control,
and this would be configured via the DSI bus, sending a particular
command to the panel (possibly by first reading something from the
panel). The panel driver would accomplish this more or less the same way
one uses, say, i2c, so it would use the platform's DSI support to send
and receive packets.

Or a more complex scenario (but still a realistic scenario, been there,
done that) is sending the image to the panel in multiple parts, and
between each part sending configuration commands to the panel. (and
still getting it done in time so we avoid tearing).

And to complicate things more, there are DSI bus features like LP mode
(low power, basically low speed mode) and HS mode (high speed), virtual
channel IDs, and whatnot, which each panel may need to be used in
particular manner. Some panels may require initial configuration done in
LP, or configuration commands sent to a certain virtual channel ID.

The point is that we cannot have standard "MIPI DSI command mode panel
driver" which would work for all DSI cmd mode panels, but we need (in
the worst case) separate driver for each panel.

The same goes to lesser extent for other panels also. Some are
configured via i2c or spi.

 Tomi


