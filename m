Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2HCFEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:04:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2HCFED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:04:03 -0400
Date: Fri, 3 Aug 2012 07:03:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: samsung: fix the number of PWMs
Message-ID: <20120803050352.GA2908@avionic-0098.adnet.avionic-design.de>
References: <002401cd708c$b3c09ed0$1b41dc70$%han@samsung.com>
 <20120802095354.GA18945@avionic-0098.adnet.avionic-design.de>
 <001001cd7105$0e465d40$2ad317c0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <001001cd7105$0e465d40$2ad317c0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:wnuOk9vESlmWASz/US6hDAWRH6LnH3DKrcAN/UPFcWz
 Qg16S+SE4wbDTHyCFBxCZWM+2626uvtqNAe8VSb2/h2Lz+ubQk
 zf/8BMV99QU53Fti7BjY7453G9g3pldjnMFdWWUIpzRHQbXzc/
 lZrykR14N/1b74+3nq42QS0vdMbYGxG+Ow48pWJeZzn8E/Ue6+
 m1sCsmGcwFsluD3Y66OYWAlwfhhwJqmrK7dpddVR00ydUlHXD7
 y0vXWmzY7zwCRmdWgCxZNgtwrdr3TRZhFJTFwP44vBxQTduT9u
 xDR4M8EuixgZ5DzZ2jGdCXuTnlQY8rNtkR9g/WNyRdDNXPRdXq
 qPKvkoXiu0PityvSbKRy9EkIdZrxc4eb1+PUhmtWHmMrdFeix/
 xtxJyJ0knIlX+VpF7sKgLv7uZP/AQtUxUY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03, 2012 at 08:17:59AM +0900, Jingoo Han wrote:
> On Thursday, August 02, 2012 6:54 PM Thierry Reding wrote:
> >=20
> > On Thu, Aug 02, 2012 at 05:56:27PM +0900, Jingoo Han wrote:
> > > Samsung SoC can provide 4 PWMs; thus, the number of PWMs should be
> > > set as 4.
> > >
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > > ---
> > >  drivers/pwm/pwm-samsung.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
> > > index e5187c0..32562c6 100644
> > > --- a/drivers/pwm/pwm-samsung.c
> > > +++ b/drivers/pwm/pwm-samsung.c
> > > @@ -228,7 +228,7 @@ static int s3c_pwm_probe(struct platform_device *=
pdev)
> > >  	s3c->chip.dev =3D &pdev->dev;
> > >  	s3c->chip.ops =3D &s3c_pwm_ops;
> > >  	s3c->chip.base =3D -1;
> > > -	s3c->chip.npwm =3D 1;
> > > +	s3c->chip.npwm =3D 4;
> >=20
> > I don't think this is correct. The driver seems to be using the platform
> > device id as index currently, which indicates that the driver is bound
> > against 4 different platform devices, each representing a single PWM. If
> > you want to service multiple PWM devices by a single instance you need
> > to make further changes to the driver. For instance the tcon_base is
> > initialized based on the platform id. This could easily be replaced by
> > making it depend on the .hwpwm member of pwm_device.
>=20
> I just want to use pwm backlight on Samsung SoC boards.
> After moving samusng pwm driver from 'arch/arm/plat-samsung/'
> to 'drivers/pwm/', pwm bakclight does not work properly.
>=20
> When pwm_id is '1' and PWM backlight calls pwm_request(data->pwm_id,
> "pwm-backlight"), pwm_to_device() returns NULL.

I don't have the hardware to test, but I'll take a look at the code to
see if there's something obvious as to why this fails. I have at least
tested the legacy paths on Tegra and they still work. In fact the PWM
framework is specifically designed such that the transition shouldn't
cause any side-effects.

Just as a quick check, you could add debug output to find out at what
point in time the s3c_pwm_probe() function is called. AFAICT the only
reason why pwm_to_device() would return NULL is if pwmchip_add() hasn't
been called. You could also attach output from dmesg, which may be
useful to diagnose the problem.

> Then, do you mean that?
> 	s3c->chip.npwm =3D id + 1;

No. If your PWM controller support more than one PWM device (sometimes
also called channels), then you should be setting .npwm to that number
(in your case this seems to be 4). Look for example at the pwm-tegra
driver, which does just that.

> > You may also want to consider making the driver a proper module if that
> > works on the platforms that need it. I see that it is currently an
> > arch_initcall, but it might be cleaner to use deferred driver probe
> > instead.
>=20
> Sorry, I cannot understand what you say.

pwm-samsung is currently not a proper module. It uses arch_initcall() to
initialize the module. If possible it should be converted to using
module_platform_driver().

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQG1u4AAoJEN0jrNd/PrOhICkP/ipUfXpvQW0VkgMJ5Z67kJl5
A5KVUVvQ7Q6av5zutAPJ0GFLNmkrclUqU5On31TvDHG7i2EcDYVXPvj4ojMT9Wo5
qQMTV2owKzD3ECn0bi8d1i7IpStYPy4K3sY+wwztx9SGq/Mkw4CTS/JClK3s2HOP
whHTgpPNNwQwGCVYRzgyraJtUNsaSOiUlmyQ+WEKcFA8Rwp9WEriFn19Hk4jw17V
FPqv4UCbsggUKIh8rKrow89f7Evj4ON7mPan7HJg+uCtHdpf4ozNk8wiI5c84u8v
gQgWwYiHBzn4wvhcAmLNtTqmnUT/WJ04st+VdNmThdjBC7wkBHo9ciCVFjaVwljS
dOXb8JC2jVj1aXSaWWJKwu1Pl4iJN2VvMbbEHEOzRzfxhCJ2DWcJCYWlgRc+PIRj
J/cwGCc0178Rf/adSDEKo1WzwXz627gUMAglqzlsTur+F5rYzLIsvhcsEqSQcZ3o
R3/5BmUuSYIl4R1Y+D2DzRtDzH0yuCaeDoZrP3DWN0j52SEZsbGdTBQundrkv6F3
CBwM5k3smqfz0VJUcftdBjHUbNlKQsKmSbAn2VSDjM97xTOQXipF+wR6x5xBFlsL
AyMMH7rdW8/6o8dwTXdlDnFEY0cbshGw1nd41bq/OHz24besVqq1baAhu/4JUdp1
1T39LGjrp03fw2NeTPrV
=RFPb
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
