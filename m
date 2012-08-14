Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2HNCBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:01:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44887 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984Ab2HNCBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:01:38 -0400
Message-ID: <1344909681.824.168.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 1/6] floppy: don't call alloc_ordered_workqueue
 inside the alloc_disk loop
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 14 Aug 2012 03:01:21 +0100
In-Reply-To: <1344881787-6422-2-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
	 <1344881787-6422-2-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YOWTRDqbGkmy7XIDtgq9"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YOWTRDqbGkmy7XIDtgq9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> Since commit 070ad7e ("floppy: convert to delayed work and single-thread
> wq"), we end up calling alloc_ordered_workqueue multiple times inside
> the loop, which shouldn't be intended. Besides the leak, other side
> effect in the current code is if blk_init_queue fails, we would end up
> calling unregister_blkdev even if we didn't call yet register_blkdev.
>=20
> Just moved the allocation of floppy_wq before the loop, and adjusted the
> code accordingly.
>=20
> Cc: stable@vger.kernel.org # 3.5+
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

> ---
>  drivers/block/floppy.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index a7d6347..c8d9e68 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4138,6 +4138,10 @@ static int __init do_floppy_init(void)
> =20
>  	raw_cmd =3D NULL;
> =20
> +	floppy_wq =3D alloc_ordered_workqueue("floppy", 0);
> +	if (!floppy_wq)
> +		return -ENOMEM;
> +
>  	for (dr =3D 0; dr < N_DRIVE; dr++) {
>  		disks[dr] =3D alloc_disk(1);
>  		if (!disks[dr]) {
> @@ -4145,16 +4149,10 @@ static int __init do_floppy_init(void)
>  			goto out_put_disk;
>  		}
> =20
> -		floppy_wq =3D alloc_ordered_workqueue("floppy", 0);
> -		if (!floppy_wq) {
> -			err =3D -ENOMEM;
> -			goto out_put_disk;
> -		}
> -
>  		disks[dr]->queue =3D blk_init_queue(do_fd_request, &floppy_lock);
>  		if (!disks[dr]->queue) {
>  			err =3D -ENOMEM;
> -			goto out_destroy_workq;
> +			goto out_put_disk;
>  		}
> =20
>  		blk_queue_max_hw_sectors(disks[dr]->queue, 64);
> @@ -4318,8 +4316,6 @@ out_release_dma:
>  out_unreg_region:
>  	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
>  	platform_driver_unregister(&floppy_driver);
> -out_destroy_workq:
> -	destroy_workqueue(floppy_wq);
>  out_unreg_blkdev:
>  	unregister_blkdev(FLOPPY_MAJOR, "fd");
>  out_put_disk:
> @@ -4335,6 +4331,7 @@ out_put_disk:
>  		}
>  		put_disk(disks[dr]);
>  	}
> +	destroy_workqueue(floppy_wq);
>  	return err;
>  }
> =20

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-YOWTRDqbGkmy7XIDtgq9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUAUCmxcue/yOyVhhEJAQo1Sw/3WqyO00YvPAvjF771x3IZKve4OCfCI0lF
zccOxpoNIxH0DvGfcjqucTljAI1muojQDtd2KR2qPtS3tlqjPseJg3692vcaAeqd
5Q6NNr0GVriiVlp8FSs+w+TQKeE3C4BoRFjeHggU/w4+fbmcIkxSOADgveghUaql
b6/wd5ymAv4ETyna2EeJfilmWimat9DY3Ao9AbdlrpijM3KLdoqcuF0tbR5f2XwC
xeIdtYco2r2WNmyXzNxGkk5SS+naicOwhlsCkPt4+VUmDVwtNppCjYMiFpM/JOGx
5tAxzQOY4/xAElQHLERhC/sqmc9Hx3IrWKJpPJCJHXeCF5trR1UiqMO6wOqlOO5M
8Ocqn+M1x78gDvuyogey5LlsxFfFF8xNblu9IA5oJQwM6KxgXGrpr3uiYbr/pL93
qXDioNwQ27QD/M3K0E0kTkUf6t4+MMuBPwtyPbNFjMQ695E6k/AHUaJ1jKp6oDA5
o9gBf2N03U7LU6zx4AQEm9j4M+fPdL/KK3o3CpnxRAETaMAZs3cnIm3LrUshZCsW
kbrHR9ZMdHyZI9y76aWfKiGyEGRw2cLZ1KqZvmJ9UbrBJqxoB+2SHAFrLwqvFtSC
+y+6gsfwT5UU0bxN1g4RJyJ0we1A7V60ldjUfKNtE4qEJearlIt6AC2QF0fL2Lym
rXvk26eQjA==
=vzQK
-----END PGP SIGNATURE-----

--=-YOWTRDqbGkmy7XIDtgq9--
