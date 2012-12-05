Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2LEN2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:28:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2LEN2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:28:51 -0500
Date: Wed, 5 Dec 2012 14:28:43 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121205132843.GA2834@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
 <50BF345A.8050201@nvidia.com>
 <CAKMK7uGPf=TEW8DL-K1KYPhMZALTZhFsSb2DBxDVgFct1kUjSA@mail.gmail.com>
 <20121205122209.GB29943@avionic-0098.adnet.avionic-design.de>
 <CAKMK7uFy=Hkqqqom=yOZ8dgSGjRT4JCJuJK7coJ+i=OyovKcYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CAKMK7uFy=Hkqqqom=yOZ8dgSGjRT4JCJuJK7coJ+i=OyovKcYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+mp5hx2Hfpa07UqxYlHf+HFtuUK6d5un7QyOP1ZRwtM
 BnV6AWO0LZ8IFrtUtFCxM4qhb2T7/qRMiLI6yXQvKJY3lVUGIp
 BwQSuRTR3YLLhnR/aVbGCf7PHQoBNY3m+01Nial6H/4oKVyETg
 Iv0VMsWelz8idQYYYBmctQNJFN23vrgQ+pHwRc8XCjCSiR/U7o
 5cekSLRfMIMHO6iPo7gjfVERuf3bcBW/lU7LkdO/vZD+bGVxeX
 wc2Kl4+9seA4mB3e/oHp8BvYYVE+Xq16cxVGzvvTPByGeAfHRi
 cAUgMZq0Jw1g48MNmoixvOQB4mSgGIrBUn9LsgNWMq9i9tqfZP
 V9qJ8uGmNQArPS67N89KfmlGDnSYB/mwslWvxoIt+mZ1d4a8ie
 1AjqtyKpqs01aAGpUvFYE8VxZR7q9RYaho=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2012 at 01:31:54PM +0100, Daniel Vetter wrote:
> On Wed, Dec 5, 2012 at 1:22 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > Maybe something more elaborate could help, though. Suppose we add
> > functionality to DRM to instantiate a DRM device. We could call such a
> > function from the host1x driver to add a device which the tegra-drm
> > driver could bind to. This would entail something like a small bus
> > implementation for DRM that would allow matching DRM devices to DRM
> > drivers much like the platform or PCI busses. This could automatically
> > take care of registering the DRM device with the proper parent so that
> > host1x clients can lookup the host1x via dev->parent.
> >
> > Perhaps something as simple as
> >
> >         int drm_device_register(struct device *parent, const char *name=
, int id);
> >
> > could work. Or something more elaborate such as allocating a device with
> >
> >         struct drm_device *drm_device_alloc(const char *name, int id);
> >
> > paired with
> >
> >         int drm_device_register(struct drm_device *dev);
> >
> > would be more flexible in that drivers could modify the DRM device in
> > between the two calls.
>=20
> Imo that's worse, since now drm manages even more of the driver->hw
> binding process. In my dream world the drm driver just registers a
> normal driver at module load time directly with whatever bus it's
> interested in, and then, from it the bus' ->probe callback setups up
> the entire driver, calling down into drm to setup up interfaces to
> userspace (dev node, sysfs, and whatever is required to implement the
> ioctls) and uses the various helper libraries provided. So host1x
> providing a virtual device that tegradrm can match sounds much better
> (if that helps in decoupling from host1x).

Okay, now I see where you're going. You want to replace the various
drm_*_init() functions with something more fine-grained that does the
initialization manually in each driver. Is that it? The obvious
disadvantage is that a lot of code would have to be duplicated, though
that can presumably be factored out into further helpers if necessary.

On that note, I just noticed that drm_platform_init() actually binds a
single platform_device to the drm_driver, which isn't going to work very
well in case there are two devices that want to use the same driver. It
would be nice to get rid of that limitation as well while at it.

> Or simply call the tegradrm setup from host1x directly, creating a
> depency on the tegradrm module. When trying to unload host1x it can
> then also call down into tegradrm to tear down the drm device.
> Afterwards you should be able to unload tegradrm without fuzz. And if
> the hard dependcy is an issue for other host1x clients this
> setup/teardown could be wrapped into an #ifdef CONFIG_TEGRADRM.

This is what I originally proposed. However, since tegra-drm will need
to call functions provided by host1x we have a cyclic dependency.
Wouldn't that prevent either module from being unloaded?

Thierry

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQv0wLAAoJEN0jrNd/PrOh1oUQAJ7KdT6Ztn9YiRnHO1p+yu/l
XHpw+wAfR6ssxgo3nOzPM323AwGjt5T7vPDXruZSmQeRnBqCh3en0wgnH+ynVLax
OpUAqwL2JLeU0NguA12CDAs9mlc+6ARKiTc+swTvNtmLRie4yD+0rUVaOBXnTzw2
UFzFeuMFo4hSrDTMEnBZNW7aQI9tKzp6aj0QzH6ebpH6T68t6CrIxtYwp6Is9kva
XZgw0AoUWWeryUlUeVjQ/L3SJRQRvPlP+cqOnMsq0Lx8FXTkn0AuFcZ8JaHlilcq
08OjTF03M48NWfZG3zNHSdfn3faQ/qwkYecJQDkm6mmvdngfPoeswsowACqnaFTq
SozQ8e3nXgBu50BtuhM7nI+Qmf9p9lIQHlf0753bDSvjuVq3i8n7keDPOHVlC1jk
SuxGaAdEdKp2MFiP/X+tJUM7FUiLNo5O0sKK5V007TWHEvtHqVuzljKVQrvzDdZ3
tbR3cgcljMlCBFiJSeJz86Ug2x4sf0mOMpmdxGZi2o3ImJBmeBFTCXrLq9P0j5WT
QBmA29pbwyecizKULhtSbL/M74iQco8/xcipolJicenXMaS2PDTU867drcctUPM3
gJ/mFYp87HVxsrmZQjRPPyewkGXilSzecIyhrIsfisKa/ZcN/589BYDWKerCSV/t
wNh+g5hMABqJCX4wnYkQ
=zby3
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
