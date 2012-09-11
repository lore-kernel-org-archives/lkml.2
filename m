Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab2IKE7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 00:59:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab2IKE7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 00:59:23 -0400
Date: Tue, 11 Sep 2012 14:59:13 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v2 12/26] raid1: use bio_reset()
Message-ID: <20120911145913.3f8a0a30@notabene.brown>
In-Reply-To: <1347322957-25260-13-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-13-git-send-email-koverstreet@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RDdTm0fG.7iEMRmf1C_a4VQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RDdTm0fG.7iEMRmf1C_a4VQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 17:22:23 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> I couldn't figure out what sbio->bi_end_io in process_checks() was
> supposed to be, so I took the easy way out.

Almost.
You save 'sbio->bi_end_io' to 'bi_end_io', then do nothing with it...

A little way above the 'fixup the bio for reuse' comment you'll find:

		struct bio *sbio =3D r1_bio->bios[i];
....
		if (r1_bio->bios[i]->bi_end_io !=3D end_sync_read)
			continue;

which implies that if we don't 'continue', then sbio->bi_end_io =3D=3D
end_sync_read.

So I suspect you want to add
    sbio->bi_end_io =3D end_sync_read;
somewhere after the 'bio_reset()'.

If you happened to also fix that 'if' that I quoted so that it reads:

     if (sbio->bi_end_io !=3D end_sync_read)
           continue;

I wouldn't complain at all :-)

Thanks,
NeilBrown


>=20
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/raid1.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ee85154..bd3e3b9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1835,6 +1835,7 @@ static int process_checks(struct r1bio *r1_bio)
>  	int primary;
>  	int i;
>  	int vcnt;
> +	bio_end_io_t *bi_end_io;
> =20
>  	for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
>  		if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read &&
> @@ -1876,13 +1877,11 @@ static int process_checks(struct r1bio *r1_bio)
>  			continue;
>  		}
>  		/* fixup the bio for reuse */
> +		bi_end_io =3D sbio->bi_end_io;
> +		bio_reset(sbio);
> +
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


--Sig_/RDdTm0fG.7iEMRmf1C_a4VQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE7FITnsnt1WYoG5AQL2gA//cp6Q4m70OasVsD53jaT/MGMgFAHBxrfX
YGnMtHmiFOG+sTo8h7uXPWOo9N1kGVFgWnWLOmTCghn2bXU4fGmIO2k4WaQF9tvb
m4AA3JUFpP4Su80iFYb87JWF9gs8y/Yf9Ycbip+6QyF+MocltD7NLGUbOaRj2Ldu
sNRwlUYtizTznQE3d/x6sxQqo+8XqHjXRx9gHip77PVc261lAXOl9rKbX6aNfNNk
A+K2QTgh8DI+M08M+lozY8/675msxVoFq1LXjz3yFPRN0HPkazYUKkMXOForJDH+
vi6VpCcQymTty5bwSvGH3zldk3ZvXbegkWu2PggeezEyVAROzxPZO4o7mqu4jD0k
Vy2B8m0/lVfyYd9rF1sk/6DcwCBph0qE0LxsbYMBdlAgMswQ8idUnlDIC5Y+u3ww
n/E5OzUaMtFlWLJLGDmr5vFs7b1GhfhxM9jgugKXV+yb4SnL0leGW0LSTUW8Nuo/
WGOVf0LpoUwfPAOhYJtt405xPIA5wV0j0zLR8wgS8kbSYI8lDCNqtOiG3v1v7+Sd
zHMLzkLnLncU9EJVcMvxNDdxm5q3bmDctoitwERCipiVgmAxEVKhy6rcczfGk+cK
7ZUQ5xJ6rnHIHWOi54vQLaWtm0OWTOpSArHE7TJMMldu0cXCInuTvll/HxvuK/y9
Fkgz4mVJ7Ic=
=/+mb
-----END PGP SIGNATURE-----

--Sig_/RDdTm0fG.7iEMRmf1C_a4VQ--
