Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2K3HrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:47:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2K3HrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:47:03 -0500
Date: Fri, 30 Nov 2012 08:46:58 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 3/8] video: tegra: host: Add channel and client support
Message-ID: <20121130074658.GG26474@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com>
 <20121129100405.GB28781@avionic-0098.adnet.avionic-design.de>
 <50B74058.9020904@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
Content-Disposition: inline
In-Reply-To: <50B74058.9020904@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MrVlMFbVFoW/AAJ01lEHTUjKmSqm567kuHg+igmwW86
 zc9D0vbtTS2kg872uQalINCcstkIzJfm7jE0UQo+fIJZxRNDyE
 RStIulFGRWPR4Zfibzgr/ZK+4n8PCjGqyATvwNIU7mUzYaz9kx
 GR+0FsEVtKn3QkJF30Q5leuAtg/Vs9P20eG2IYRwhIsYSZNQq6
 BcMSlzVO/nynoz1mE5SOSjSpNYrY4ARyClol7ktkwqV5jpkAJY
 aqXdLqV1vkV4l8gs138soJ+pdDJufdYRlRRhRtNvLVGKOw9cnZ
 LKdOmvIrfl4TjsVpujlNIDKX7UETkuYnLG2G6+mxpyBD9BSKtk
 4LIghHhVaE2BsMBordRdFiJjd3Xv2A2ni3etoMr7NFBXkaPiUY
 uFPRC7JzFACpO5cNVFFdZ/51zMfQbl/++LmDg7CubIVSz/u2JR
 cY/2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 01:00:40PM +0200, Terje Bergstr=C3=B6m wrote:
> On 29.11.2012 12:04, Thierry Reding wrote:
> > Looking some more at how this is used, I'm starting to think that it
> > might be easier to export the various handlers and allow them to be
> > passed to the nvhost_intr_add_action() explicitly.
>=20
> Oh, so you mean like "nvhost_intr_add_action(intr, id, threshold,
> nvhost_intr_action_submit_complete, channel, waiter, priv), and
> nvhost_intr_action_submit_complete is the function pointer?
>=20
> There's one case to take care of: we merge the waits for the jobs into
> one waiter to save us from having too many irq calls. Perhaps that could
> be handled by a flag, or something like that.

Yes, something like ACTION_MERGE or something should work fine.
Alternatively you could handle it by providing two public functions, one
which adds to the list of jobs that can be merged, the other that adds
to the list that cannot be merged.

> >> +struct nvhost_job *nvhost_job_alloc(struct nvhost_channel *ch,
> >> +             int num_cmdbufs, int num_relocs, int num_waitchks)
> >> +{
> >> +     struct nvhost_job *job =3D NULL;
> >> +     size_t size =3D job_size(num_cmdbufs, num_relocs, num_waitchks);
> >> +
> >> +     if (!size)
> >> +             return NULL;
> >> +     job =3D vzalloc(size);
> >=20
> > Why vzalloc()?
>=20
> I guess it's basically moot, but we tried that when we had some memory
> fragmentation issues and it was left even though we did find out it's
> not needed.

I think kzalloc() would be a better choice here. Also, while at it you
may want to make the num_* parameters unsigned.

> >> +     }
> >> +
> >> +     /* get current syncpt values for waitchk */
> >> +     for_each_set_bit(i, &waitchk_mask[0], sizeof(waitchk_mask))
> >> +             nvhost_syncpt_update_min(sp, i);
> >=20
> > Or since you only use the mask here, why not move the
> > nvhost_syncpt_update_min() into the above loop?
>=20
> I want to call nvhost_syncpt_update_min() only once per syncpt register.
> If the job has 100 sync point increments for 2D sync point, I'd read the
> value from hardware 100 times, which is expensive.

Right, hadn't thought about the fact that you can have multiple waits
for a single syncpoint in the job.

Looking at the code again, I see that you use sizeof(waitchk_mask) as
the third parameter to the for_each_set_bit() macro. However the size
parameter is to be specified in bits, not bytes.

Also the name nvhost_syncpt_update_min() has had me confused. So say it
is used to update the value that you've cached in software from the real
value in the register. However I interpret update_min() as "update the
minimum value in the register". Maybe something like *_load_min() would
be clearer.

> Thanks. I've collected a massive amount of feedback already. v3 will
> take quite a while to appear after we've finished all the reviews of v2.

Yes, that should keep you busy for quite a while. =3D) But I also think
we've made good progress so far.

Thierry

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuGRyAAoJEN0jrNd/PrOh4VwP/0ftQPQkOhyBEjqodU/A8tyM
n8GyYOiXBMw9C5GOs4KbVb+U9xKy+Q+2EDu2ra74rd0ypAwA63vyIDKccpIZHys1
8SJegy/VS3RAJpaRgWKFkXVUgBYB42cQxj6Lu7d2FAqhxcCMniXtIz6lT+Xkqx+b
30J+ff+zUrCsT3Q8PZEm8upfSGqem+KuwuyrZtpcortmK8p7Uo8YAulZc9UOotww
OZtzc5iwumbQy2FAK51jj2/7U/mh/oP8sYAl/sWwkhQuIdabqjxgYVP9v9gQhs/K
07Y6CqPBlJDSlBsjzvbSJLePrhBABUp0iwwQtpOL0hV5s4SmCqf66lLX+Z0FHfF0
B29rl2HMXRYO0oX4EoYL1w8rUnchUiRomRHWcWPNfJqn1HZ1krZFxHJxVW+aikOL
kHndO/h0dbsmnwVNwKPZdZspejp7cJtmBvxFZzPWIuR1tPPVaZBazD+AYNjV7vtj
C+YHbOqFXaUBhPtjb4clZQLb4+NitRlEYmz5r8a+x5bdBCABXG/8TFkefxp7IGKQ
NgnvmdYQaBD6GibkJN7Hu4sGHLQek7mu3JWTc5ZiLt7TBo6Op25xXSwPZToRanU5
9268aQUNo0OhMyFSzegjeprfWoR/PYanIPacC3RuEVoWrgcrGy8nx9bMxxUT8PmQ
rRSzOpWZagrMz+P1bF3j
=68BK
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
