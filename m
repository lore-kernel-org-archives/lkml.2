Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2LTVuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:50:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2LTVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:50:17 -0500
Date: Thu, 20 Dec 2012 22:50:08 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121220215008.GA30491@avionic-0098.adnet.avionic-design.de>
References: <50CB5205.1030303@wwwdotorg.org>
 <50CB850F.9090704@nvidia.com>
 <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de>
 <50D2D792.1050401@nvidia.com>
 <50D34775.5010606@wwwdotorg.org>
 <50D34F00.4080308@nvidia.com>
 <50D3511F.2090308@wwwdotorg.org>
 <50D35287.3040509@nvidia.com>
 <20121220203059.GA12977@avionic-0098.adnet.avionic-design.de>
 <50D38462.3060302@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <50D38462.3060302@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VarOdApt+L4qFvcEaYety1eQDqmzz+ka/q7mP8w73KP
 /6FsAk2eJV4wgQ5UcLxyjUpoeAfUJ0PdjWdr5iIwc6oNde9mNp
 ARxcf4S2tJLbjaRwQYYDVnTeq5RGA608bvUwsSG5DlEV5xNF89
 xGHKtMWskSPOVDIG+EYRoHB3iKKU8JQaJ/rKoalw0wzM8xpUyL
 0o5Dv23ujskbyDSn25+eRTXbn0vq02t0t3F376fPHr7fW8aGGy
 NjO8V8BGEIu1sSMPk2s4pIQ61dk7OjUo8YjbDLj7ClBWmRub78
 jOd1uoAh/9MXPvVDZ6W/lJJd3hpjYMrfRqgEnlThC2uxlp38qO
 QMHlQMkGoouZsAafxessEbXF3CULsPlxlPEUdZnsWgO3o32CHz
 O0JGB97+etw9OEKBjDjNyVPBlXaglAPqATkOPxQQnbaB38/7KL
 2qKQs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2012 at 11:34:26PM +0200, Terje Bergstr=C3=B6m wrote:
> On 20.12.2012 22:30, Thierry Reding wrote:
> > The problem with your proposed solution is that, even any of Stephen's
> > valid objections aside, it won't work. Once the tegra-drm module is
> > unloaded, the driver's data will be left in the current state and the
> > link to the dummy device will be lost.
>=20
> The dummy device is created by tegradrm's module init, because it's used
> only by tegradrm. When tegradrm is unloaded, all the tegradrm devices
> and drivers are unloaded and freed, including the dummy one.

No, the children platform devices of host1x are not freed, so their
driver data will still contain the data set by the previous call to
their driver's .probe() function.

But reading what you said again, you were proposing to set the children
driver data from the tegra-drm dummy device's .probe(). In that case it
would probably work.

> > And quite frankly given how all the various host1x components are
> > interlinked I think having a single function that gets the DRM dummy
> > device for DRM-related clients isn't that bad.
>=20
> I like clear responsibilities. tegradrm is responsible for the DRM
> interface, and host1x driver is responsible for host1x. tegradrm owns
> its data, and can pass its pointers to the functions that need it.
>=20
> But fine, I still don't like it, but I'll add host1x_set_tegradrm() and
> host1x_get_tegradrm(), which act as setter and getter for tegradrm's
> global data. I still think it's a solution to a problem we don't have,
> but we've wasted an order of magnitude more time debating it than it
> takes to implement.

As Stephen already pointed out, since the host1x driver will already
instantiate the dummy device, there's no point in adding a function to
set the pointer to that device.

Adding a getter should be enough. And it should return a pointer to the
dummy platform devices .dev field. Calling it host1x_get_drm_device()
may make it more obvious about what it returns.

Thierry

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ04gQAAoJEN0jrNd/PrOhbYMQAJUjaTAI7SgC0p0mbwcXRDrb
c7jtdTG9cMrWmVNguAxMcuJyRVERoxK6sXT9y7RKlOAPpFq3UpllY4lC1c6mjCMo
y+hFx1Z2Ac9K3NGDolfhi6VWY0MvO1jfxix8MywPPfPUMxr2K58OfUqI2uQktr7W
e1e2SI7nRPgcM0uMLNHGa0H4f5KMWVyHh18OZ5k8aDzNSvWjLur1NoaQKPcTIl7Y
3BsAbvk+whu4si3QNhRx5Hkx5eimm3x6rhf7HFXrAp2NdCNLxevppJKPuFamY/Dv
BhIAGRXdBxYpwuT2ZaAZ/U5iTpCCYEmFK2Vz31pbqyCuo6X6Y1Y6Io3IjluN/We5
JWqx0+1eKjXOPJGlI0myzWDlDjHCH9C/KlHGZfVz2qs5MooFQ/0kskHZWYP+9qlt
tntjf+lQxudU6ZXveAcu/iuvYLBUy41UwpBkb/iQUcs+3cROjvIHC8GkudJRCN1B
NsLVhlD2YsJWUsumUtYhaSs/ORYZwROYFREl9/C49fMdH83T90r8lOsyCba53Llw
Vtl+N346ZOxsqRSseiZPPfPRIHj/vFtS51deHympefo6Ln71oxP/l06kyDUp4CnW
tH0HObJjveeuqIudTLnojZ0M1DZJ37KZl3mZgu3uNg/Al5z0No7p0856GiJUWnlE
u1oENt0rG8hxv85WZXOK
=gqLj
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
