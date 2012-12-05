Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2LEMWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:22:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2LEMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:22:20 -0500
Date: Wed, 5 Dec 2012 13:22:12 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121205122209.GB29943@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
 <50BF345A.8050201@nvidia.com>
 <CAKMK7uGPf=TEW8DL-K1KYPhMZALTZhFsSb2DBxDVgFct1kUjSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <CAKMK7uGPf=TEW8DL-K1KYPhMZALTZhFsSb2DBxDVgFct1kUjSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7E6RdJHfZ3+2IrOPTMZqC0+GGpdfPuHY8HYFBVhlOs/
 JGoNHa4007wek23+gE8S7to0CujJQUSOLxp7B/xQgwoEvSZ94n
 aj5gik9pLrj8c3kXSEjYyr3PtXuEPrUM9fLMOGoMQMbmMPv8nn
 /wPJmWfC4KvLMxPvntrEXXUT9y5vvXYB/VSM/oH73z6Umb4Q4O
 eYH2yZFONUct/exSLC+X24lc/KtuhByPoMA1/c4bjKSBUlWCl5
 zdVt9nj5ZrcTqnnYuy6hC3495ZqyLUoipuclPXPr/sbCWRWccX
 KsTnp5MUJR4xrM5uBomrz633BBqB2ipmdp3zLApMkqJpMTv3O2
 OTChj5X5hsHIh4/LuN174pO9VuxQSxsjT1RA2uj4zb95MPJX8k
 QTHID4EHG+jEIsRTe5auv99b/c/vHi0MSk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2012 at 01:03:14PM +0100, Daniel Vetter wrote:
> On Wed, Dec 5, 2012 at 12:47 PM, Terje Bergstr=C3=B6m <tbergstrom@nvidia.=
com> wrote:
> > You're right in that binding to a sub-device is not a nice way. DRM
> > framework just needs a "struct device" to bind to. exynos seems to solve
> > this by introducing a virtual device and bind to that. I'm not sure if
> > this is the best way, but worth considering?
>=20
> Note that I'm not too happy about the fact that drm wants a struct
> device to register a drm device. This all made a lot of sense back in
> the days when drm drivers this this fancy shadow attaching to allow
> drm to use a driver for rendering cooperatively with a fbdev driver.
> Today there's not much reason for that anymore imo, and I'd welcome
> patches to allow drivers to simply register a drm device (and remove
> all the newer registration functions for usb/platform/whatever
> drivers, moving the device handling into drivers). Note that it's a
> bit work, since not-really-required abstraction (which was useful back
> when the drm drivers have been shared with *BSD, but pointless now)
> like the drm irq support needs to be moved away to a pci-dev legacy
> thing only - it doesn't really buy a kms driver anything above&beyond
> calling request_irq() itself.
>=20
> So feel free to burn this down, I'll be happy to carry wood to the
> pyre in the from of reviews (not much time for more right now ...).

This wouldn't solve the problem at hand, though, since we'd still need
to instantiate the DRM driver somehow. Currently this is triggered
ultimately by the host1x's .probe().

Maybe something more elaborate could help, though. Suppose we add
functionality to DRM to instantiate a DRM device. We could call such a
function from the host1x driver to add a device which the tegra-drm
driver could bind to. This would entail something like a small bus
implementation for DRM that would allow matching DRM devices to DRM
drivers much like the platform or PCI busses. This could automatically
take care of registering the DRM device with the proper parent so that
host1x clients can lookup the host1x via dev->parent.

Perhaps something as simple as

	int drm_device_register(struct device *parent, const char *name, int id);

could work. Or something more elaborate such as allocating a device with

	struct drm_device *drm_device_alloc(const char *name, int id);

paired with

	int drm_device_register(struct drm_device *dev);

would be more flexible in that drivers could modify the DRM device in
between the two calls.

Thierry

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvzxxAAoJEN0jrNd/PrOh2zwQALZk5MuaEE3XSAgeg7DrMc9R
upkPqnlVyMXGwX90Xug+oHSVx9xgHUFIcms+nICUtF2Ap7im3yDtSF7VgQgEUYWj
uJp6y86xDe62P79dMgpDz8/48JZao2EbRK8auEM0EPLkqNBKazTxQTeE9Si6LDOc
Zf3WtaKc+QOifQ58CCnaaZSP0MPmRzbP77q43wm9UjWHjFyj+XCCPKzAG2oKk/2h
aSnuzt963JsSqFLR8q4h9kVZOYU6qZvKfy+OhyRKraj/SrHE/lCokY9yzRtuJr+V
dmxejFSnLE7rPWzX9PLddCJnVDnvYit1iDNvpGSVQXNGyXE/3mLDJYhGMDWrhahv
v/vgo8/sr2VfrAVQGfv6XUFPM1I0l6PIAc2tB+2cfDqkjTTvPfdzZeaBIb8A55by
/FUeeXbAU28IqTwFsWyuAkNYANK0vXNdAPRZwXiL6MoL75EOoaiFug1d33CyRUoc
Q/nCS4jjL//srz2qhDoaCSNN575UwCMr9xZES00y2+omVr/rgoVZLTXP5iGzZq2e
bT9I5ZgoSFabNp1JmShmYS19UHKBHGHGxAvJ2CspyTEqaPbqrtpo5uNWNRfv7TKf
AcwMLNZ71GZ7UoXWkVv1/Hf5PYyk/Hk87mOJFUeCOExPbJ5c5DZwZdbjdIBFyoor
xOGrk75ke2L+QvU1XORb
=z1kY
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
