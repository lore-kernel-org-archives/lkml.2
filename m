Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2LELNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:13:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2LELNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:13:39 -0500
Date: Wed, 5 Dec 2012 12:13:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <50BF1DAA.8030805@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7UQCxkeYBP3wD1r8Y+mf67aRHAj2Pb65auB9YqZJAzF
 20JeujFCu9dZtcg6oVUs5Xl7Ip8tV9ZI414chfgcVYkuxSKCgA
 7PSVeY0HqbdOw4E2BeQ0tHDDAFOxzall+n60W35yDVbHaSHgS+
 5yNTVixnMi/d6Iopitw0njdHDX2CwhF5PSWDVakmICim84Cej9
 UdgH99o+2obsIGifATSW+q8mo33vkC/LZdEa3Fj4dVTWNPJiNZ
 jVKd0uARQagSSqKGj++fuoFWaF+tnj87nyhip2BMTKz3yrqVVt
 It+THF2gZkpr5/azbh1M/MoTrxqyMNSb0EIuZQMsjEgUnuWbqV
 Pd5zOoJaDGs4thI6iCiKYfl4IF/o4dtvDCvY8XJhgu66JrRAK4
 63jOM35IfLlgxGoirqc5EHHnd961y5XPAL30ln2K/JnvXox8Dd
 ml+Rk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2012 at 12:10:50PM +0200, Terje Bergstr=C3=B6m wrote:
> On 05.12.2012 10:33, Thierry Reding wrote:
> > I've been thinking about this some more and came to the conclusion that
> > since we will already have a tight coupling between host1x and tegra-drm
> > we may just as well keep the client registration code in host1x. The way
> > I imagine this to work would be to export a public API from tegra-drm,
> > say tegra_drm_init() and tegra_drm_exit(), that could be called in place
> > of drm_platform_init() and drm_platform_exit() in the current code.
> >=20
> > tegra_drm_init() could then be passed the host1x platform device to bind
> > to. The only thing that would need to be done is move the fields in the
> > host1x structure specific to DRM into a separate structure. host1x would
> > have to export host1x_drm_init/exit() which the DRM can invoke to have
> > all DRM clients register to the DRM subsystem.
> >=20
> > From a hierarchical point of view this makes sense, with host1x being
> > the parent of all DRM subdevices. It allows us to reuse the current code
> > from tegra-drm that has been tested and works properly even for module
> > unload/reload. We also get to keep the proper encapsulation and the
> > switch to the separate host1x driver will require a much smaller patch.
> >=20
> > Does anybody see a disadvantage in this approach?
>=20
> I'm a bit confused about the scope. You mention host1x several times,
> but I'm not sure if you mean the file drivers/gpu/drm/tegra/host1x.c or
> the host1x driver. So I might be babbling when I answer this. Could you
> please clarify that?

What I propose is to move the client registration code that is currently
in drivers/gpu/drm/tegra/host1x.c to the host1x driver, which may or may
not end up in drivers/gpu/host1x.

> host1x hardware access must be encapsulated in host1x driver
> (drivers/gpu/host1x if that's the location we prefer). As for the
> management of the list of DRM clients, we proposed the move to drm.c,
> because host1x hardware would anyway be controlled by a different
> driver. Having file called host1x.c in tegradrm didn't sound logical, as
> its not really controlling host1x, and its probe wouldn't be called.

Oh well, at the time nobody from NVIDIA was involved so I wrote that
code in preparation for proper host1x support that I thought I would
have to add myself at some point. I'm more than glad that I don't have
to do this all by myself. However the patch proposed in this series
breaks a number of requirements such as proper encapsulation, which I
already mentioned in more detail in another mail.

> If your proposal is that we'd move the management of the list of host1x
> devices from tegradrm to host1x driver, we'd have a tight circular
> dependency between two drivers and that's almost always a bad idea. So
> far all ideas have revolved around tegradrm calling host1x, and host1x
> calling a bit of DRM (for CMA, would be fixed in later version) but not
> host1x calling tegradrm.

The problem that this solves is that the DRM driver needs to be bound to
a specific platform device. None of the DRM subdevices are suitable
because they are only part of the whole DRM device. I think that host1x
is the only device that fits here.

Note that this is only an administrative problem. It shouldn't interfere
with the way host1x works. The goal is that the DRM device is registered
at the proper hierarchical location.

The circular dependency is indeed a problem, though. Quite frankly I
have no idea how to solve this. However the approach taken in the
current patch will break several other requirements as I already
explained.

Thierry

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvyxcAAoJEN0jrNd/PrOh6PgP/16pT2/qV9KJQutd4zMAUai0
hFsIEOJcK8ZXaknE9/3D5CYwSJFSN+wOxbSjnMw7C0SqoW0IYPfmwLESQspaQKgd
o2QfIsnGOSVhLbTUWECoZF5c+oFrHYcEOjGCeSsoszSXZxqaW5q34XgmKVv6Aih+
WNXzQ0xaJ19OZFb2SZ66r1UbD1nkcvm6uR5t90wII6ED5IFywgQEmRBf6KvVFlWo
zeU3TSSTKW55wTY6WwxA8VV+0CyHeVjF92QwZyzXeinvA6sPmfKGpidpMZpmEN6w
/3789gfEEopX0RhPaNKXQb/vSL2n2cPqRxz2+dKR6HveLLEN6fzxafwLNY5pHX/D
IBBGZh2VH0aA1ruf9p+nVyxAWLUp3PyA1XdL9QYVL8PeG3ehsjLguGpE343+aGMF
73BKaVGFhlSdAu6m4l4eXi9+mcTtZHQ7+lrOYo+5R66w3CRBKRwLy3idaaCMNt7p
pgU93TuiDeqU8RQKch/hMm8J/M9/myA7UGO2AgkwyQme9Y6mjs9c3MJuZe752rPE
BOcYCGzYnH05CEYPGJb4etwWlo8lDov4Yi5z1yoHqUFBsNBmn+9KEOxlPMVqFO22
rN0Pyksq0CvgLNx0mzKEt9YSOq1e2GJx8gD6SFISB9ndiR4IR/GAGfYEvcaU6H0k
7LfVedglw3k3DUEewMe6
=bW0l
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
