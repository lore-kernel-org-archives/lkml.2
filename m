Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2IKVRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:17:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab2IKVRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:17:48 -0400
Date: Wed, 12 Sep 2012 07:17:36 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v2 12/26] raid1: use bio_reset()
Message-ID: <20120912071736.715627f0@notabene.brown>
In-Reply-To: <20120911182825.GG19739@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-13-git-send-email-koverstreet@google.com>
	<20120911145913.3f8a0a30@notabene.brown>
	<20120911182825.GG19739@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gUZHsiirQy8go3/VlnJ1049"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gUZHsiirQy8go3/VlnJ1049
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Sep 2012 11:28:25 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> On Tue, Sep 11, 2012 at 02:59:13PM +1000, NeilBrown wrote:
> > On Mon, 10 Sep 2012 17:22:23 -0700 Kent Overstreet <koverstreet@google.=
com>
> > wrote:
> >=20
> > > I couldn't figure out what sbio->bi_end_io in process_checks() was
> > > supposed to be, so I took the easy way out.
> >=20
> > Almost.
> > You save 'sbio->bi_end_io' to 'bi_end_io', then do nothing with it...
>=20
> Whoops :) I think I must've gotten distracted and forgot to finish with
> that patch, I wasn't setting bi_private either.
>=20
> >=20
> > A little way above the 'fixup the bio for reuse' comment you'll find:
> >=20
> > 		struct bio *sbio =3D r1_bio->bios[i];
> > ....
> > 		if (r1_bio->bios[i]->bi_end_io !=3D end_sync_read)
> > 			continue;
> >=20
> > which implies that if we don't 'continue', then sbio->bi_end_io =3D=3D
> > end_sync_read.
>=20
> Ahh. I remember reading that, but I missed that that was sbio that was
> being checked.
>=20
> >=20
> > So I suspect you want to add
> >     sbio->bi_end_io =3D end_sync_read;
> > somewhere after the 'bio_reset()'.
> >=20
> > If you happened to also fix that 'if' that I quoted so that it reads:
> >=20
> >      if (sbio->bi_end_io !=3D end_sync_read)
> >            continue;
>=20
> Will do! How's this look?

Looks good.

Acked-by: NeilBrown <neilb@suse.de>

NeilBrown


>=20
>=20
> commit 40a4645a4346edd040066baedcf2184ac4211ba7
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Tue Sep 11 11:26:12 2012 -0700
>=20
>     raid1: use bio_reset()
>    =20
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
>     CC: Jens Axboe <axboe@kernel.dk>
>     CC: NeilBrown <neilb@suse.de>
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ee85154..df68691 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1851,7 +1851,7 @@ static int process_checks(struct r1bio *r1_bio)
>  		struct bio *sbio =3D r1_bio->bios[i];
>  		int size;
> =20
> -		if (r1_bio->bios[i]->bi_end_io !=3D end_sync_read)
> +		if (sbio->bi_end_io !=3D end_sync_read)
>  			continue;
> =20
>  		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
> @@ -1876,16 +1876,15 @@ static int process_checks(struct r1bio *r1_bio)
>  			continue;
>  		}
>  		/* fixup the bio for reuse */
> +		bio_reset(sbio);
>  		sbio->bi_vcnt =3D vcnt;
>  		sbio->bi_size =3D r1_bio->sectors << 9;
> -		sbio->bi_idx =3D 0;
> -		sbio->bi_phys_segments =3D 0;
> -		sbio->bi_flags &=3D ~(BIO_POOL_MASK - 1);
> -		sbio->bi_flags |=3D 1 << BIO_UPTODATE;
> -		sbio->bi_next =3D NULL;
>  		sbio->bi_sector =3D r1_bio->sector +
>  			conf->mirrors[i].rdev->data_offset;
>  		sbio->bi_bdev =3D conf->mirrors[i].rdev->bdev;
> +		sbio->bi_end_io =3D end_sync_read;
> +		sbio->bi_private =3D r1_bio;
> +
>  		size =3D sbio->bi_size;
>  		for (j =3D 0; j < vcnt ; j++) {
>  			struct bio_vec *bi;
> @@ -2426,18 +2425,7 @@ static sector_t sync_request(struct mddev *mddev, =
sector_t sector_nr, int *skipp
>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
>  		struct md_rdev *rdev;
>  		bio =3D r1_bio->bios[i];
> -
> -		/* take from bio_init */
> -		bio->bi_next =3D NULL;
> -		bio->bi_flags &=3D ~(BIO_POOL_MASK-1);
> -		bio->bi_flags |=3D 1 << BIO_UPTODATE;
> -		bio->bi_rw =3D READ;
> -		bio->bi_vcnt =3D 0;
> -		bio->bi_idx =3D 0;
> -		bio->bi_phys_segments =3D 0;
> -		bio->bi_size =3D 0;
> -		bio->bi_end_io =3D NULL;
> -		bio->bi_private =3D NULL;
> +		bio_reset(bio);
> =20
>  		rdev =3D rcu_dereference(conf->mirrors[i].rdev);
>  		if (rdev =3D=3D NULL ||


--Sig_/gUZHsiirQy8go3/VlnJ1049
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE+qcDnsnt1WYoG5AQJEFg//Y4BmNeQ/5ijba8iQlMFc+w6yynLCCnI+
vZxkbJjTAuhBxjmHvXK9lx1Gc4np4fejhlwE2AI/KqoCQIZnOg0wWyT4zXBl/CCn
NgcqITYbgiSfJ9vYuG1dnTOx1iUcug62HKS7erntvaOmV/TMo2jGLGKE6HR95Blz
GJYgmD6zEtVrJFSi/6zERmuMGxvu6W8jk6e9p4m3xNKlBPwKKpiB4eX1POKUPv5c
19pME0DFqz6dwljlPidJ9XyHHSzncRVac8x+PS4ajidkv1srq9Jqd0yuy71JAYxX
+3+pGAqmvF1s93myJVrGKKsQ0xqRmp5ZdSEBLOBNLZm6SnCz+xhEErMPWakhCFMk
WzE9rCOVsZakVztQF+9OOiPTlHrQTHKdTtS/UIaYHH9a6/tlclynR/N4O0HHOinA
jVAISIjZq7g55IQHT2kAKfTrCUY2Lx9+Cn4TWt3xYaAfQXjYiEJQ1ZF1Pb48sv9c
+BLGXOTWeGADXY+/uzRNig6pw346v2OA07Z25rbRYKHfIRSBsGkhf0qoal8dr464
vrQYXBiORwxDKbj+ZDFJZj5INTrkwSKp7p4BQJDAjjhXTtGVyncYgsEv4UQWNZRR
MuUlLR11xZ1YIynkZnXquXHWDZoOYgk/xcrwIkEAdy8Zu3vO1ca0c/EqBOsd1LMr
MTiIptdYVLA=
=Ik4f
-----END PGP SIGNATURE-----

--Sig_/gUZHsiirQy8go3/VlnJ1049--
