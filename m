Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2IKFDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:03:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2IKFDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:03:34 -0400
Date: Tue, 11 Sep 2012 15:03:26 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v2 13/26] raid5: use bio_reset()
Message-ID: <20120911150326.79f066c0@notabene.brown>
In-Reply-To: <1347322957-25260-14-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-14-git-send-email-koverstreet@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GuKwZFHvt3YJqbNxrq9M8j+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GuKwZFHvt3YJqbNxrq9M8j+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 17:22:24 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> Had to shuffle the code around a bit (where bi_rw and bi_end_io were
> set), but shouldn't really be anything tricky here
>=20
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/raid5.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7c19dbe..ebe43f7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -561,14 +561,6 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  		bi =3D &sh->dev[i].req;
>  		rbi =3D &sh->dev[i].rreq; /* For writing to replacement */
> =20
> -		bi->bi_rw =3D rw;
> -		rbi->bi_rw =3D rw;
> -		if (rw & WRITE) {
> -			bi->bi_end_io =3D raid5_end_write_request;
> -			rbi->bi_end_io =3D raid5_end_write_request;
> -		} else
> -			bi->bi_end_io =3D raid5_end_read_request;
> -
>  		rcu_read_lock();
>  		rrdev =3D rcu_dereference(conf->disks[i].replacement);
>  		smp_mb(); /* Ensure that if rrdev is NULL, rdev won't be */
> @@ -643,7 +635,14 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
> =20
>  			set_bit(STRIPE_IO_STARTED, &sh->state);
> =20
> +			bio_reset(bi);
>  			bi->bi_bdev =3D rdev->bdev;
> +			bi->bi_rw =3D rw;
> +			bi->bi_end_io =3D (rw & WRITE)
> +				? raid5_end_write_request
> +				: raid5_end_read_request;
> +			bi->bi_private =3D sh;
> +
>  			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
>  				__func__, (unsigned long long)sh->sector,
>  				bi->bi_rw, i);
> @@ -657,12 +656,9 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>  				bi->bi_rw |=3D REQ_FLUSH;
> =20
> -			bi->bi_flags =3D 1 << BIO_UPTODATE;
> -			bi->bi_idx =3D 0;
>  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
>  			bi->bi_io_vec[0].bv_offset =3D 0;
>  			bi->bi_size =3D STRIPE_SIZE;
> -			bi->bi_next =3D NULL;
>  			if (rrdev)
>  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
>  			generic_make_request(bi);
> @@ -674,7 +670,14 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
> =20
>  			set_bit(STRIPE_IO_STARTED, &sh->state);
> =20
> +			bio_reset(rbi);
>  			rbi->bi_bdev =3D rrdev->bdev;
> +			rbi->bi_rw =3D rw;
> +			rbi->bi_end_io =3D (rw & WRITE)
> +				? raid5_end_write_request
> +				: raid5_end_read_request;

'rbi->bi_end_io' can only ever be raid5_end_write_request.  We only get here
on a write.
I'd be OK with=20
    BUG_ON(!(rw & WRITE));
but I don't want the condition in the assignment.

The rest looks quite sane.

Thanks
NeilBrown


--Sig_/GuKwZFHvt3YJqbNxrq9M8j+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE7GHjnsnt1WYoG5AQL6kBAAmgyeYyjUqOlRvWLVaXtHo9arv6VWhlsf
rfEj057kWkSCOAoIrg8VCXnlzAxJtb5SDDS8QGHlx1Y1m9uLBPNN0osUgnhTWAO7
AqH4LypQ/uqwk4JcSd5p+dnGyXizr7oRlPNp1DrIlbnlpqBa0yBdLO+qljfcMVID
Dn5vwK/1XwIPfuPhpsjtse/GgFPUTmVcBSQcrP03uaiYqgpO4EJgLTmAju1WYnMS
LcO4Vsd+TfqKz3IjoBPPuom0cm2tX116TWIkI7M4TR4iircph+LkBjqpysXm4VVO
WrDY0vyqSFyo0jQJtd3jrfV8l83m5/D6Y59wvbjbovCcnwJucNzjsI6BeVjgg9PB
xmsSIYlsxnQuxXAjPkfR9bADnat40clp/hY8ZIrmEugS3fcTa9qmqKF9a28RhNut
4ft6pt0q+wLOjAJ9JhHgbKwgRumxQ/4jORlieDO2LVYHk9oQ+JonqDCnF3q1ZAo1
c/HxFAy5ARu9Fz28O+bPQGJ14fvsG8NhQ+KKqmIKGBJa0DyScwCreLZdMeO4uO0E
8gmaRImIkKvr3V7H1AucTYdW4n96ZPPC1Tzqx6Bu+sUv2k5ipDCiuTfstCfLWWo5
obLM03El8IjYSNcrB3j1+oiGXPz6AuCKaJqx9GpznhmnyHu5dOW8sHSyTEpSuuNn
5SwE7qRS/Q0=
=vViI
-----END PGP SIGNATURE-----

--Sig_/GuKwZFHvt3YJqbNxrq9M8j+--
