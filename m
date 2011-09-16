Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab1IPGjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:39:07 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51867 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab1IPGjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:39:06 -0400
Subject: Re: Proposal for a low-level Linux display framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
In-Reply-To: <yunfwjxwbjq.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	 <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari>
	 <yun8vpp7qk7.fsf@aiko.keithp.com> <1316107275.23214.99.camel@deskari>
	 <yunfwjxwbjq.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 09:38:59 +0300
Message-ID: <1316155139.2487.49.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 19:55 -0500, Keith Packard wrote:
> On Thu, 15 Sep 2011 20:21:15 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> 
> > 2) panel drivers, handles panel specific things. Each panel may support
> > custom commands and features, for which we need a dedicated driver. And
> > this driver is not platform specific, but should work with any platform
> > which has the output used with the panel.
> 
> Right, we've got DDC ports (which are just i2c) and DisplayPort aux
> channel stuff.
> 
> The DDC stuff is abstracted out and shared across the drivers, but the
> DisplayPort aux channel code is not -- it's duplicated in every output
> driver. 

I feel that you are still talking about the output driver, not the
panel. DDC and DP aux are part of the connector-entity in DRM, right?
But there's no separate display-entity behind the connector, which would
handle the peculiarities for a particular panel/display, say DSI panel
model L33T from AcmeCorp.

So, as I see it, DDC and DP aux are on the output driver, and the panel
driver uses those to do whatever is needed for a particular panel.

> > DSI bus is a half-duplex serial bus, and while it's designed for
> > displays you could use it easily for any communication between the SoC
> > and the peripheral.
> 
> Yeah, HDMI uses DDC for all kinds of crazy stuff in the CE world.

But that is still more or less standard HDMI stuff, isn't it? So you
implement it once for HDMI, and then it works with all HDMI monitors?

Or is there some way to implement custom behavior for one particular
HDMI monitor? Is this custom behavior in a kernel driver or handled in
userspace?

> > The point is that we cannot have standard "MIPI DSI command mode panel
> > driver" which would work for all DSI cmd mode panels, but we need (in
> > the worst case) separate driver for each panel.
> 
> It sounds like we do want to share code for those bits, much like we
> have DDC split out now. And, we should do something about the
> DisplayPort aux channel stuff to avoid duplicating it everywhere.

Yep. What I had in mind for DSI with my low-level fmwk would be a
mipi_dsi component that offers services to use the DSI bus. Each
platform which supports DSI would implement the DSI support for their
HW. Then the DSI panel driver could do things like:

dsi->write(dev, virtual_channel_id, buf, len);

dsi->set_max_return_packet_size(dev, 10);
dsi->read(dev, virtual_channel_id, read_cmd, recv_buf, len);

An example DSI command mode panel driver can be found from
drivers/video/omap2/displays/panel-taal.c, which uses omapdss' dsi
functions directly but could quite easily use a common DSI interface and
thus be platform independent.

> I'm not sure a common interface to all of these different
> channels makes sense, but surely a DSI library and an aux channel
> library would fit nicely alongside the existing DDC library.

What do you mean with "channel"? Any video or command bus going to the
display? Yes, I think they are quite different and I don't see a point
in trying to make a common interface for them. 

DSI is in many ways a real bus. You can connect multiple peripherals to
one DSI bus (but it needs a DSI hub), and communicate with them by using
their virtual channel ID. And quite often there are DSI chips that
transform the DSI packets to some other form. Some real example
configurations:

Plain DSI panel:

[SoC] ---DSI--- [DSI panel]

DSI-2-DisplayPort converter chip:

[SoC] ---DSI--- [DSI chip] ---DP--- [DP monitor]

DSI buffer chip supporting to DSI panels:

[SoC] ---DSI--- [DSI chip] +--DSI--- [DSI panel 1]
                           |--DSI--- [DSI panel 2]

It would be nice to be able to model this somehow neatly with device
drivers. For example, the DSI panel from the first example could be used
in the two-panel configuration, and if (and when) the panel requires
custom configuration, the same panel driver could be used in both cases.
In the first case the panel driver would use DSI support from the Soc,
in the third case the panel driver would use the DSI support from the
DSI chip (which would, in turn, use DSI support from the SoC).

 Tomi



