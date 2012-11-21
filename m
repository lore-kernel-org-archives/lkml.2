Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2KUMFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:05:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39051 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab2KUMFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:05:03 -0500
Message-ID: <50ACC341.3090204@ti.com>
Date: Wed, 21 Nov 2012 14:04:17 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tomi Valkeinen <tomba@iki.fi>, Alex Courbot <acourbot@nvidia.com>,
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
        Alexandre Courbot <gnurou@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost> <13540495.epaCf4JVn9@percival> <50ACB59B.4090404@iki.fi> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigBA0C6782130B92F7F6253164"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigBA0C6782130B92F7F6253164
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-21 13:40, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:

(sorry for bouncing back and forth with my private and my @ti addresses.
I can't find an option in thunderbird to only use one sender address,
and I always forget to change it when responding...)

>> My suggestion would be to go forward with an in-driver solution, and
>> look at the DT based solution later if we are seeing an increasing blo=
at
>> in the drivers.
>=20
> Assuming we go with your approach, what's the plan? We're actually
> facing this problem right now for Tegra. Basically we have a DRM driver=

> that can drive the panel, but we're still missing a way to hook up the
> backlight and panel enabling code. So we effectively can't support any
> of the LVDS devices out there without this series.

Could you describe the hardware setup you have related to the LCD and
backlight? Is it a public board with public schematics?

I've understood that you don't have anything special in your board, just
an LCD and a backlight, and the power sequences are related to powering
up the LCD and the backlight, without anything board specific. If so,
there's no need for board specific code, but just improving the panel
and backlight drivers to support the models you use.

> As I understand it, what you propose is similar to what ASoC does. For =
a
> specific board, you'd have to write a driver, presumably for the new
> panel/display framework, that provides code to power the panel on and
> off. That means we'll have to have a driver for each panel out there
> basically, or we'd need to write generic drivers that can be configured=

> to some degree (via platform data or DT). This is similar to how ASoC
> works, where we have a driver that provides support for a specific code=
c
> connected to the Tegra SoC. For the display framework things could be
> done in a similar way I suppose, so that Tegra could have one display
> driver to handle all aspects of powering on and off the various panels
> for the various boards out there.

I think we should only need the board drivers for very special cases. If
there's just a panel and a backlight, without any special dynamic muxing
or other trickery needed, I don't see a need for a board driver. I
presume this is the case for most of the boards.

> Obviously, a lot of the code will be similar for other SoCs, but maybe
> that's just the way things are if we choose that approach. There's also=

> the potential for factoring out large chunks of common code later on
> once we start to see common patterns.
>=20
> One thing that's not very clear is how the backlight subsystem should b=
e
> wired up with the display framework. I have a patch on top of the Tegra=

> DRM driver which adds some ad-hoc display support using this power
> sequences series and the pwm-backlight.

I think that's a separate issue: how to associate the lcd device and
backlight device together. I don't have a clear answer to this.

There are many ways the backlight may be handled. In some cases the
panel and the backlight are truly independent, and you can use the other
without using the other (not very practical, though =3D).

But then with some LCDs the backlight may be controlled by sending
commands to the panel, and in this case the two may be quite linked.
Changing the backlight requires the panel driver to be up and running,
and sometimes the sending the backlight commands may need to be (say,
DSI display, with backlight commands going over the DSI bus).

So my feeling is that the panel driver should know about the related
backlight device. In the first case the panel driver would just call
enable/disable in the backlight device when the panel is turned on.

In the second case of the DSI panel... I'm not sure. I've implemented it
so that the panel driver creates the backlight device, and implements
the backlight callbacks. It then sends the DSI commands from those
callbacks.

> From reading the proposal for the panel/display framework, it sounds
> like a lot more is planned than just enabling or disabling panels, but
> it also seems like a lot of code needs to be written to support things
> like DSI, DBI or other control busses.
>=20
> At least for Tegra, and I think the same holds for a wide variety of
> other SoCs, dumb panels would be enough for a start. In the interest of=

> getting a working solution for those setups, maybe we can start small
> and add just enough framework to register dumb panel drivers to along
> with code to wire up a backlight to light up the display. Then we could=

> possibly still make it to have a proper solution to support the various=

> LVDS panels for Tegra with 3.9.

Yes, we (Laurent and me) both agree that we should start simple.

However, the common panel framework is not strictly needed for this. I'm
not sure of the current architecture for Tegra, but for OMAP we already
have panel drivers (omap specific ones, though). The panel drivers may
support multiple models, (for example,
drivers/video/omap2/displays/panel-generic-dpi.c).

I don't see any problem with adding small Tegra specific panel drivers
for the time being, with the intention of converting to common panel
framework when that's available.

Of course, the DT side is an issue. If you now create DT bindings for a
temporary model, and need to change it again later, you'll have some
headaches trying managing that without breaking the old bindings... This
is why I haven't pushed DT bindings for OMAP, as I know I have to change
them in the near future.

 Tomi



--------------enigBA0C6782130B92F7F6253164
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrMNBAAoJEPo9qoy8lh71mM8P/1Phj5ZXucIt6yiaqeYVJk1S
A6hELegvncLVOlCpiW5/DneMv2yY5Up6ovyfrXE7OvxLLVnTLKR32cGlv9fZI5lm
1USyQ4NwctedIEAaUV/Ri4fMYsk1OmRPiQUEfxxy0iK0awtIhVSKzJocsPKEUmU/
mi8zikJhdnL2rvPpuD4k78F3dIV4klbv2Y43/11YOVxSCX7x+LVWzi0tWF4KtOhV
zc/gT3J2HMcXwuYJZGf5/vFnSz8EUtCCc+nlCCF/XPe9CHFR7dQ10CWCScxz0XTm
+/tGikGIxWytdUuk/UByWzhaknpzPWGOm//LUVg82Szb0zpEK332qGNAFRT0PBA1
1YoGs0jo0uYK83O0hdED/efa5HPn8SDetWraRaLcI8aKVGRoK+zja+UJt9KfLwqD
69F5ROIZXB+6+a3RtVCEc/YR3qf5YtUMolvTTo4xSdeYqTR6JYhZQvuVUQu+FxEN
N0s5+cEY7KYyjQNWk84pZz9btnIUor+JP0hNqgvuUSxI7OM2ng4uRIJ+tgxpn3TY
5FfjKVlLjhrueXEEqNKpngtGxwMsL+2IyCRNxOgYXhV7BNd7n4vIx123SMq4wG0i
EXU418kpczXF0w/DXHgWsFyyGLaOuDLKcqU+e675n3IwhF0WwDrLMoYmnhLx7yIM
MXW8qiC7d4qjGI7/aB1O
=8x2N
-----END PGP SIGNATURE-----

--------------enigBA0C6782130B92F7F6253164--
