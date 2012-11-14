Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423283Ab2KNUEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:04:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422810Ab2KNUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:04:22 -0500
Date: Wed, 14 Nov 2012 21:04:15 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
Message-ID: <20121114200415.GA10335@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
 <50A357D3.9080002@nvidia.com>
 <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de>
 <50A3712E.7000104@nvidia.com>
 <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de>
 <50A3C485.7080704@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <50A3C485.7080704@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3UugrLoOSF+sGTnWcrYuA/x0blenNOdEhxIGGLqqPv3
 EdijnOgfIhOS53CluJq76Uyza7NVRcVGmsc24VYrLN7HuD/OlF
 KB/Yb72OPL3+XxIx755ZeVywFPh8jWa1vXlSOfeTBfp2u4fuSH
 5cVPJhHZ0DUCzH49ClkGRDDs+GyPv2wFMyVhmcwrCVHYgw0YyT
 uwHxlofcDmNm9jTSJ3NpiRnzPyCuM1u+TYus3zqnDDz4Jcrc3S
 wKogb0vCZekta1M60X/lPqc0zkE51kdHNwCMZbO/vRkBJInnNl
 Fxz7UJK2pEmKvkCaO/iMhvHn/zE7zHaL/hYlbNyTSm8OWPS0uE
 +F1Go20EpL2b7elAwOEIYWWNHCHs5cgh+XW/LrzlTLlSqM0MOV
 HFYLfdrGy7IStkRKz7tuXctyq/LXeqgGaF/XHqmrlRfkhHwAcC
 DmFUu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 09:19:17AM -0700, Stephen Warren wrote:
> On 11/14/2012 03:54 AM, Thierry Reding wrote:
> > On Wed, Nov 14, 2012 at 12:23:42PM +0200, Terje Bergstr=C3=B6m wrote:
> >> On 14.11.2012 10:49, Thierry Reding wrote:
> >>> Can you find out how the host1x clock is setup without this
> >>> change? I was told that freezes can occur when you try to
> >>> access the registers without the host1x clock being enabled.
> >>> However, the host1x driver should take care to properly setup
> >>> the clock.
> >>>=20
> >>> To find out if the non-running clock is the issue, can you try
> >>> to patch that line and make the final element true instead of
> >>> false? That should enable the clock on boot so that it should
> >>> always be running.
> >>=20
> >> I tried with fastboot and U-Boot, and whenever that line is
> >> there, kernel boot will halt at nvhost init. Same happens if I
> >> just change the false to true.
> >>=20
> >> nvhost will enable the clock and disable as it need. Also, part
> >> of host1x initialization did proceed, but it ended up hanging
> >> after a few registers were initialized. So it's not a case of
> >> host1x being off, but host1x hanging after a while.
> >>=20
> >> If I change this line to:
> >>=20
> >> { "host1x",     "pll_p",        216000000,      false },
> >>=20
> >> it will also work properly. It looks like we have some problem
> >> with pll_c in Tegra20, or clock configuration with your patch. In
> >> Tegra30, pll_c with 144MHz seems to work fine, but on Tegra20, it
> >> doesn't.
> >>=20
> >> In internal kernel, we use pll_c for host1x, so hardware
> >> shouldn't be the problem here.
> >=20
> > I suppose that if things work properly without this line, then we
> > should probably just drop it. Stephen, any objections?
>=20
> I'd rather initialize it explicitly. If setting it to 216MHz works
> fine as Terje indicated, we may as well just do that.
>=20
> I suspect the issue with the original code:
>=20
> > { "host1x",     "pll_c",        144000000,      false },
>=20
> ... is that perhaps the requested 144MHz can't be generated from
> pll_c's 600MHz rate, since there's a simple U7.1 divider there (you
> could get 120, 133.333, 150), so the clock ends up being programmed to
> some incorrect value. In the pll_p/216MHz case, pll_p is programmed to
> generate 216MHz anyway, so requesting the same rate for host1x yields
> a divider of 1 exactly which works fine.

According to tegra20_clocks_data.c, the maximum clock frequency for
host1x is 166 MHz, so 216 is probably not a good idea. 150 MHz sounds
sensible, though.

I was going to send a new version of the patch set tonight, but I'll
wait until I can test it tomorrow and once Terje has reported back that
things work fine.

Thierry

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo/k/AAoJEN0jrNd/PrOhoX8P/i2KPOgP4IVcIO4EkG3bLZGg
2NtFGRbChwD6uhkGm9W1MJzEnJGenJl0NPxih41uzYKyY0nPjqbRdC7rfuQUesav
QoR00aM1unNzM6HUAC4OcGeKZ1s2cOQHVo5M9Y7O4XQDLDmPL8F8tHd2sW89ui/a
KoMM8IqvXIsLYwikRqJ0elz/M4uuX+zxvQVvb/qaMNXqnaVs4QbpmhrkXv3ZhqNP
xyNs9qvLTOv+ZkrA08CS/4suQDE5QaMX9NejRtQWOdscwbR7P7PoRToALg6GB3ew
h1XI75zitvqKoDqqintsKpWPSe7+ysT+qUpyA//VQsgaFMKLOeamSoiGSZO8Ox0v
JbbRhlFK2kobj3ZZeduEBizrOJzyCuXJ7T7I3YlrymWnHfDAQG1M5Sycy5uzjdHR
jhk0Pd8KXmbE528uGYSlStOhLqM0O5orjkfo2MlKj0u0BEtCIlHKQo418u4kw8rw
nks4rhXY/9FTJTjEWdVDRWj8kevzKig4EpIkKJTN59MK/NA/T/+H0PkuoFgLgRjb
6USqCaP7cOuYN7royNwUwqh6YZw+FOBU/VhdeQ7mnr66U5kGqhVsjWaQmi74VsHX
7gRQNxgZHj6KlX5KtfHUaKPYa4p5cuzT6bqrKGyYSa8kILc16wk9Z+2xQee3wkoj
OaXSc3vo2bzVHBXZzfXC
=W3nU
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
