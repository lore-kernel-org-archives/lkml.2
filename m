Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2K0Pgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:36:31 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59891 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2K0Pg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:36:29 -0500
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
Date: Tue, 27 Nov 2012 16:37:32 +0100
Message-ID: <3136860.Z3VvKjeKpU@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50B4D9E9.8070607@ti.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <6982060.HfOokt4dIn@avalon> <50B4D9E9.8070607@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1423338.6jACMuZm55"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1423338.6jACMuZm55
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Tuesday 27 November 2012 17:19:05 Tomi Valkeinen wrote:
> On 2012-11-27 17:08, Laurent Pinchart wrote:
> > On Wednesday 21 November 2012 14:04:17 Tomi Valkeinen wrote:
> >> On 2012-11-21 13:40, Thierry Reding wrote:
> > [snip]
> > 
> >>> One thing that's not very clear is how the backlight subsystem should be
> >>> wired up with the display framework. I have a patch on top of the Tegra
> >>> DRM driver which adds some ad-hoc display support using this power
> >>> sequences series and the pwm-backlight.
> >> 
> >> I think that's a separate issue: how to associate the lcd device and
> >> backlight device together. I don't have a clear answer to this.
> >> 
> >> There are many ways the backlight may be handled. In some cases the
> >> panel and the backlight are truly independent, and you can use the other
> >> without using the other (not very practical, though =).
> > 
> > From a control point of view that's always the case for DPI panels (as
> > those panels have no control bus, the backlight control bus is by
> > definition separate) and is the case for the two DBI panels I've seen
> > (but I won't claim that's a significative number of panels).
> 
> They may have a control bus, I2C, SPI, etc. In some cases that can be
> used to control the backlight. But yes, it's separate from the video bus.
> 
> >> But then with some LCDs the backlight may be controlled by sending
> >> commands to the panel, and in this case the two may be quite linked.
> >> Changing the backlight requires the panel driver to be up and running,
> >> and sometimes the sending the backlight commands may need to be (say, DSI
> >> display, with backlight commands going over the DSI bus).
> > 
> > When you write "sending commands to the panel", do you mean on the same
> > control bus that the panel use ? Or would that also include for instance
> > an I2C backlight controller integrated inside a DSI panel module ? In the
> > later
>
> I mean the same control bus that is used to control the panel, be it shared
> with video bus like DSI, or separate like I2C.
> 
> > case there might still be dependencies between the panel controller and
> > the backlight controller (let's say for instance that the panel controller
> > has a DSI-controller GPIO wired to the backlight controller reset signal),
> > but in practice I don't know if that's ever the case.
> > 
> >> So my feeling is that the panel driver should know about the related
> >> backlight device. In the first case the panel driver would just call
> >> enable/disable in the backlight device when the panel is turned on.
> > 
> > That makes sense. Unless I'm mistaken a backlight is always associated
> > with a panel (it would be called a light if there was no panel in front
> > of it). We can thus expose backlight operations in the panel CDF
> > (in-kernel) API. The panel driver would need a way to retrieve a pointer
> > to the associated backlight device.
> 
> I agree.
> 
> >> In the second case of the DSI panel... I'm not sure. I've implemented it
> >> so that the panel driver creates the backlight device, and implements
> >> the backlight callbacks. It then sends the DSI commands from those
> >> callbacks.
> > 
> > If we decide to make the panel expose backlight operations we could get
> > rid of the backlight device in this case.
> 
> Do you mean there would be a real backlight device only when there's a
> totally independent backlight for the panel?

I'm toying with that idea.

I see two reasons for having backlight devices in the kernel right now.

- Integration with the fbdev API to control the backlight automatically on 
fbdev blank/unblank/suspend/resume. That's something I want to get rid of, 
backlight should not depend on fbdev. If the backlight in-kernel API is 
exposed by the panel through CDF operations we won't need this anymore.

- Exposing backlight control to userspace in sysfs. That's quite probably 
something we want to keep, if only for compatibility reasons. Backlight on/off 
should be controlled through the display APIs through DPMS control, but we 
have no way that I'm aware of to control the backlight brightness in the FBDEV 
and KMS APIs. It might make sense to add a backlight API to KMS for the 
future.

One possibly crazy idea I had was to replace backlight devices as we know them 
with LED devices (a LED driver IC shouldn't be supported by different APIs 
depending on whether the LEDs it drives are used as a backlight or not), and 
have the panel hook up with the associated LED device to expose backlight 
operations through the CDF. Panels with a backlight controller tied to the 
panel controller (control through DSI for instance) would implement the 
backlight operations directly without instantiating a LED device. This still 
leaves the question of the userspace backlight brightness API open.

-- 
Regards,

Laurent Pinchart

--nextPart1423338.6jACMuZm55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQtN48AAoJEIkPb2GL7hl1U6wH/RWMBxe8hYLFenNw7IyFJJ8k
eENfy30S8fKlzWNLSDGHjdKgO0Tgp3xFHlA3fi8UDq8JA1+5ZaBJIVL1J5DJOSpZ
c3OwlRylDYHgNuVV8k3gGA1y5Kstcbf4uzHZWOAqzSHtL6gVQtt5b2Qd4W3zUyfA
8gleihjvnzGmlavi9fTmHHOfcFt/Z2YVx0uveMq3q9QA1NqEoJbQ8ckPI7nZzg3o
Iwg5tPtBHxT7lHB/5L2WcnFxM0dB063eUC+NnHAKzxdti9CLXy1c0X2hhCEu8oPl
3hfCa8a4xNxDor8r5iYcIsWHNUXYCsNvMQW3GYFs0zzAf3NOZOFspOGyl3Uh4ks=
=fEkJ
-----END PGP SIGNATURE-----

--nextPart1423338.6jACMuZm55--

