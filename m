Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2LMI55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:57:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2LMI5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:57:55 -0500
Date: Thu, 13 Dec 2012 09:57:50 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
 <50BF1DAA.8030805@nvidia.com>
 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
 <50BF345A.8050201@nvidia.com>
 <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
 <50C5CAB5.3040000@nvidia.com>
 <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de>
 <50C99677.6090306@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <50C99677.6090306@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:m264fbwh1PhoYRI1OcIKJf8eDRyVcAqE+VZzBN4xJ0H
 Z8m63dZPXeM5sgLKrQGvhBdR2n9AO2WT51u/XTjZ1SURC0rMU2
 x51EUeOK0Xvl1A5PXA1d+OwMCsUI1T1fsxqdpl5turg6e8zA2g
 d+k5GTJDxBg4aT3EM1NBNMicDpQndnXSN1JWs6djndT8v5OKpY
 KBkpjErKfIgTIDUHB4Ta3/tyfb5GVExsoEpFuBi3RZxpQqwMRz
 QaSwXMn25FnLXn2k7sPe4iWgTrOnZ3VXby4O0KCNlAp8LHVbc2
 PyYt/YLLgNfjgNdzQYecAK/F5vB8e5W/pcIdmZoujySjieRtYj
 6vqE8rlTfFAk4DmHSvULwUh0iTg6TndbS6SHSeq1Kv2NMQfgC8
 ajoBIjMSjUJVYNgkiVdnxRzZv+pEBKSd08=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 10:48:55AM +0200, Terje Bergstr=C3=B6m wrote:
> On 12.12.2012 18:08, Thierry Reding wrote:
> > I've briefly discussed this with Stephen on IRC because I thought I had
> > remembered him objecting to the idea of adding a dummy device just for
> > this purpose. It turns out, however, that what he didn't like was to add
> > a dummy node to the DT just to make this happen, but he has no (strong)
> > objections to a dummy platform device.
> >=20
> > While I'm not very happy about that solution, I've been going over it
> > for a week now and haven't come up with any better alternative that
> > doesn't have its own disadvantages. So perhaps we should go ahead and
> > implement that. For the host1x driver this really just means creating a
> > platform device and adding it to the system, with some of the fields
> > tweaked to make things work.
>=20
> Even the virtual device is not too beautiful. The problem is that the
> virtual device is not physical parent for DC, HDMI, etc, so
> dev_get_drvdata(pdev->dev.parent) returns the data from host1x device,
> not the virtual device.
>=20
> We'll post with something that goes around this, but it's not going to
> be too pretty. Let's try to find the solution once we get the code out.

After some more discussion with Stephen on IRC we came to the conclusion
that the easiest might be to have tegra-drm call into host1x with
something like:

	void host1x_set_drm_device(struct host1x *host1x, struct device *dev);

Once the dummy device has been properly set up and have each client use

	struct device *host1x_get_drm_device(struct host1x *host1x);

to obtain a pointer to the dummy device, such that it can receive the
driver-private data using dev_get_drvdata() on the returned device. As
long as tegra-drm hasn't registered with host1x yet, the above function
could return ERR_PTR(-EPROBE_DEFER), so that dependencies are
automatically handled. This is required because, tegra-drm not being the
parent of the child devices, it can be guaranteed that it is probed
before any of the children.

That way we should be able to get around any circular dependencies,
since we only call into host1x from tegra-drm but not the other way
around.

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQyZiOAAoJEN0jrNd/PrOhaxMP/RQ2ZKTm+6W/Sx36u5DmxvRf
kINCtKJfLoNCghZHSuNOW3g/9DZmObk6I/gNuAEyq9BtNqUToP53ysvnuexGt0Ke
DVepnPaOM+E1bNSesXyTpwTxBOtNQGPA8DU8WSKbfzcX29I7kNRaJDviOIG2zR3F
yX1r11D7wejO3ZWIC2HmBht+uq9PRfpOkNaK54GbdAibGtgSqftm3WmZL+uGZwFw
u+QS7wh+lEIxG+Dm0bhqFOvtQF3fRlACQDJsxLnMnGQC1Br71n1Rd/LKqWhlneVf
qnBZ1ePSSccCWzn+n6cRKgKkChGWfIxwRHAhksymrd79HsoDPpxHxfivlrKgrB46
q6z2rOm/mPqAcDszLaHZZgF/LCR+WiQavb1l+/SjJep8khcwQ2OpeF13UH/94CcB
NMzoEDBdkamGXbg4QzLJ/uxqQMV7UQwUPlibVQxf9aL9LQbIgdMTaayAbu1lytvZ
P2HwTLenfX7DdPEHKtRnW79l55MV3AEup+yG95k9M6vtdpoL3LmIyu1YT/2KkIgV
ypbjZSYpatY1ONXkWPCRZDa6+OJ7zfLlz3QUsbBV8iWEjVzfuI5F5SW/lmTGr1LR
hmTMNLetR4qxsM2jGCTVfi0JMpqLbQIAyLNYdavWboiYWfYnRzq8AvH4nFCn1lki
mOYK7BIFUos5YfnRESEw
=txuH
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
