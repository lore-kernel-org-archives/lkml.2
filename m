Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KJVB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 16:01:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2KJVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 16:01:27 -0500
Date: Sat, 10 Nov 2012 22:01:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Christian =?utf-8?B?S8O2bmln?= <deathsimple@vodafone.de>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-tegra@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
Message-ID: <20121110210118.GA26809@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
 <1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
 <CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
 <509D28B6.3060207@vodafone.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <509D28B6.3060207@vodafone.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:yqsP6XMVdIgWf+9CZag8YtwGEWbi/q/kjnBZtbD/Rit
 NsMLUcDY142oLSyz2xRhLwJsEK00m3/iYRDG6loRJIMe/pRuN6
 X5hbROo3SOkbzRpl45j06CcF0YJckAGWIH4jSRIrY2CZY9ad0R
 zqM3KRAFE2Nl8M82mDXFsnjpi61mtSWDf3b8sFSVvXw6sTPT2e
 2MC3IAu8Ggo2auXGa020WwnU42CTM/vRjeKtehTOZm/OoquIUT
 QLraKX1EVVdte4Fr5ElKVpb/JRxoOkXXcWETDSfP5yPyGL8Gx8
 /BAQnAaxecJ/7Gtgb5dZVtlUksguonTm1hnh4f+9GmXqTbEjfC
 e42mJd/8cGSWXIdXkRVCOgyAvIib053jQ6s6ZOglb1guFJakZp
 9zeK/UYXm8wyp7KL3DvhF5j2wnAzAxN2GJMMBb1ipp9k7LTbmU
 sclze
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 05:00:54PM +0100, Christian K=C3=B6nig wrote:
> On 09.11.2012 16:45, Rafa=C5=82 Mi=C5=82ecki wrote:
> >2012/11/9 Thierry Reding <thierry.reding@avionic-design.de>:
> >>+/* all fields little endian */
> >>+struct hdmi_audio_infoframe {
> >>+       /* PB0 */
> >>+       u8 csum;
> >>+
> >>+       /* PB1 */
> >>+       unsigned cc:3; /* channel count */
> >>+       unsigned res1:1;
> >>+       unsigned ct:4; /* coding type */
> >>+
> >>+       /* PB2 */
> >>+       unsigned ss:2; /* sample size */
> >>+       unsigned sf:3; /* sample frequency */
> >>+       unsigned res2:3;
> >>+
> >>+       /* PB3 */
> >>+       unsigned cxt:5; /* coding extention type */
> >>+       unsigned res3:3;
> >>+
> >>+       /* PB4 */
> >>+       u8 ca; /* channel/speaker allocation */
> >>+
> >>+       /* PB5 */
> >>+       unsigned res5:3;
> >>+       unsigned lsv:4; /* level shift value */
> >>+       unsigned dm_inh:1; /* downmix inhibit */
> >>+
> >>+       /* PB6-10 reserved */
> >>+       u8 res6;
> >>+       u8 res7;
> >>+       u8 res8;
> >>+       u8 res9;
> >>+       u8 res10;
> >>+} __packed;
> >I was told it won't work on different endian devices. See
> >[RFC][PATCH] drm/radeon/hdmi: define struct for AVI infoframe
> >http://lists.freedesktop.org/archives/dri-devel/2012-May/022544.html
>=20
> Yeah, that's indeed true. And honestly adding just another
> implementation of the HDMI info frames sounds like somebody should
> finally sit down and implement it in a common drm_hdmi.c

So I've been looking at what most other implementations do and it seems
a lot just fill the AVI infoframe with zeroes while only a few actually
try to put useful information in them. Still in order to plan for a
generic solution, I thought maybe something like the below set of
structures and functions could work:

/*
 * Structure that contains the infoframe fields in a form that allows them =
to
 * be easily accessed from C code.
 */
struct hdmi_avi_infoframe;

/*
 * DRM helper to fill a struct hdmi_avi_infoframe with information taken fr=
om
 * a struct drm_display_mode. Fields that cannot automatically be derived by
 * looking at a struct drm_display_mode are set to the default values.
 */
int drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *fra=
me,
					     struct drm_display_mode *mode);

/*
 * Packs the struct hdmi_avi_infoframe into a binary buffer that can be
 * programmed to the hardware-specific registers.
 */
ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame,
				void *buffer, size_t size);

Such a scheme would allow DRM drivers to call the helper and tweak the
fields in the structure if the want or need to and call the packing
function to obtain a buffer that they can write to the controller.

Does that sound at all reasonable?

Thierry

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnsCeAAoJEN0jrNd/PrOh19YQAJ6NFDJs0Eo2FmvW43kYco/j
IqH5wOVtigyoraJonY8HK76hXmE5FvovSQGbJRiPN2o0OcQ9xxC9mlDHn8Vewa8V
PtNvkNODz5rTNz2qBawQeuPReomNqs80AXrmlCZ/ym6Dhm4hM36ZeDw3zGR6WLQB
8Jg+9+8C5ahuve7DMKdbpFTp3bqwwDqKQTg4tg+OwMe+YvTBYIoOM0ZNnQGYBCsY
bI4VgQfb9C6YcMtUysrGYlGj4DKEdQBB935T4kPO7W7SlS77sTiYvJNIID3lck4o
qspdKYXjRtpatTfnwlyFcpxyfrejoDPYC0Wb8ZQ84lHu2kW+jKcorIxY+J11iM3y
QSm9XH2fDoutKYw1QfZtKVrY2cnvhxcJjIPVzy95jbBJMgCtTmJgsHe8me3zaD+X
MMgUJPCB4oPhN4I/SQBrg7iZJNV4xJQB+1V+OcaV9baTtEXvJA4ra89Mjg6QnqEJ
XVHPkiuFK8HgMGV9W/3HGqhcFuzvSKr6QGnK2CPUMgIMWn1v0Ygr2NYOZf/liLgS
TW6J36dwKjWB97mtPeGD2idzIdOGBY5QNf78ojdXv6U4u4QnVvxKnPdJJI/mI7D6
g/6sgd5JFZcz2M7DuMnduTaOxkWU/3gmJQdE+YCqFn16+bw+B2tFrA4BeoAhKya2
Kaa6RyX4aCt8EN7B+CyN
=B3jL
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
