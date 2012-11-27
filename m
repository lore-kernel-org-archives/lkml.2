Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2K0PHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:07:24 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:34388 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2K0PHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:07:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomba@iki.fi>, Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Tue, 27 Nov 2012 16:08:23 +0100
Message-ID: <6982060.HfOokt4dIn@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50ACC341.3090204@ti.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de> <50ACC341.3090204@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart15047295.rgReblTnmU"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart15047295.rgReblTnmU
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Wednesday 21 November 2012 14:04:17 Tomi Valkeinen wrote:
> On 2012-11-21 13:40, Thierry Reding wrote:

[snip]

> > One thing that's not very clear is how the backlight subsystem should be
> > wired up with the display framework. I have a patch on top of the Tegra
> > DRM driver which adds some ad-hoc display support using this power
> > sequences series and the pwm-backlight.
> 
> I think that's a separate issue: how to associate the lcd device and
> backlight device together. I don't have a clear answer to this.
> 
> There are many ways the backlight may be handled. In some cases the
> panel and the backlight are truly independent, and you can use the other
> without using the other (not very practical, though =).

>From a control point of view that's always the case for DPI panels (as those 
panels have no control bus, the backlight control bus is by definition 
separate) and is the case for the two DBI panels I've seen (but I won't claim 
that's a significative number of panels).

> But then with some LCDs the backlight may be controlled by sending commands
> to the panel, and in this case the two may be quite linked. Changing the
> backlight requires the panel driver to be up and running, and sometimes the
> sending the backlight commands may need to be (say, DSI display, with
> backlight commands going over the DSI bus).

When you write "sending commands to the panel", do you mean on the same 
control bus that the panel use ? Or would that also include for instance an 
I2C backlight controller integrated inside a DSI panel module ? In the later 
case there might still be dependencies between the panel controller and the 
backlight controller (let's say for instance that the panel controller has a 
DSI-controller GPIO wired to the backlight controller reset signal), but in 
practice I don't know if that's ever the case.

> So my feeling is that the panel driver should know about the related
> backlight device. In the first case the panel driver would just call
> enable/disable in the backlight device when the panel is turned on.

That makes sense. Unless I'm mistaken a backlight is always associated with a 
panel (it would be called a light if there was no panel in front of it). We 
can thus expose backlight operations in the panel CDF (in-kernel) API. The 
panel driver would need a way to retrieve a pointer to the associated 
backlight device.

> In the second case of the DSI panel... I'm not sure. I've implemented it
> so that the panel driver creates the backlight device, and implements
> the backlight callbacks. It then sends the DSI commands from those
> callbacks.

If we decide to make the panel expose backlight operations we could get rid of 
the backlight device in this case.

> > From reading the proposal for the panel/display framework, it sounds
> > like a lot more is planned than just enabling or disabling panels, but
> > it also seems like a lot of code needs to be written to support things
> > like DSI, DBI or other control busses.
> > 
> > At least for Tegra, and I think the same holds for a wide variety of
> > other SoCs, dumb panels would be enough for a start. In the interest of
> > getting a working solution for those setups, maybe we can start small
> > and add just enough framework to register dumb panel drivers to along
> > with code to wire up a backlight to light up the display. Then we could
> > possibly still make it to have a proper solution to support the various
> > LVDS panels for Tegra with 3.9.
> 
> Yes, we (Laurent and me) both agree that we should start simple.
> 
> However, the common panel framework is not strictly needed for this. I'm
> not sure of the current architecture for Tegra, but for OMAP we already
> have panel drivers (omap specific ones, though). The panel drivers may
> support multiple models, (for example,
> drivers/video/omap2/displays/panel-generic-dpi.c).
> 
> I don't see any problem with adding small Tegra specific panel drivers
> for the time being, with the intention of converting to common panel
> framework when that's available.

I'm fine with that, but using the CDF would be even better :-)

> Of course, the DT side is an issue. If you now create DT bindings for a
> temporary model, and need to change it again later, you'll have some
> headaches trying managing that without breaking the old bindings... This
> is why I haven't pushed DT bindings for OMAP, as I know I have to change
> them in the near future.

-- 
Regards,

Laurent Pinchart

--nextPart15047295.rgReblTnmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQtNdnAAoJEIkPb2GL7hl1nbYH/0PgIwsNiH9EHYVVj54jSoy+
SbMqePchdc7XAvYO4b+69BT/Dy4mQ1+zMkcIi6yzUPUnj6lenF/1B8J+K3eFfdpE
XxANCRaUXZApHYBW3gIRw8MhKRKdlFQtELll4SCoZfpzEY9Ctdoo+gk/yV26kX1E
0kexepEdcbRgqG23ljows1qlVu4y+SMY6mBGidZloVkwMsHHwj4g0MdmQQXtlblX
ZXl/Ds4kG5YIWAAh1WFGu2OiS4NdzKq6kKbZMz6fStNulSntL8zZS+VmYkRaOgy3
LQbHJPnconn1XwBQaV7XvtSQxuVNKWB3cQIp7sDJqdha8wfzdgRYNTujOHM76Y8=
=cJOR
-----END PGP SIGNATURE-----

--nextPart15047295.rgReblTnmU--

