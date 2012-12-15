Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094Ab2LOSkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 13:40:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47064 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab2LOSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 13:40:47 -0500
Message-ID: <1355596839.18807.12.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 135/241] md/raid10: close race that lose writes lost
 when replacement completes.
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Date: Sat, 15 Dec 2012 18:40:39 +0000
In-Reply-To: <1355407206-17100-136-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-136-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WIQy3fWW+iRW9D5euAho"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WIQy3fWW+iRW9D5euAho
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: NeilBrown <neilb@suse.de>
>=20
> commit e7c0c3fa29280d62aa5e11101a674bb3064bd791 upstream.
>=20
> When a replacement operation completes there is a small window
> when the original device is marked 'faulty' and the replacement
> still looks like a replacement.  The faulty should be removed and
> the replacement moved in place very quickly, bit it isn't instant.
>=20
> So the code write out to the array must handle the possibility that
> the only working device for some slot in the replacement - but it
> doesn't.  If the primary device is faulty it just gives up.  This
> can lead to corruption.
>=20
> So make the code more robust: if either  the primary or the
> replacement is present and working, write to them.  Only when
> neither are present do we give up.
>=20
> This bug has been present since replacement was introduced in
> 3.3, so it is suitable for any -stable kernel since then.

This is missing from 3.4, so Greg will presumably want to apply this (if
the backport is correct).

Ben.

> Reported-by: "George Spelvin" <linux@horizon.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> [ herton: hairy code adjustment on 3rd hunk (conf->copies for loop) ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
> ---
>  drivers/md/raid10.c |  113 +++++++++++++++++++++++++++------------------=
------
>  1 file changed, 59 insertions(+), 54 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 17fae37..0920adf 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1267,18 +1267,21 @@ retry_write:
>  			blocked_rdev =3D rrdev;
>  			break;
>  		}
> +		if (rdev && (test_bit(Faulty, &rdev->flags)
> +			     || test_bit(Unmerged, &rdev->flags)))
> +			rdev =3D NULL;
>  		if (rrdev && (test_bit(Faulty, &rrdev->flags)
>  			      || test_bit(Unmerged, &rrdev->flags)))
>  			rrdev =3D NULL;
> =20
>  		r10_bio->devs[i].bio =3D NULL;
>  		r10_bio->devs[i].repl_bio =3D NULL;
> -		if (!rdev || test_bit(Faulty, &rdev->flags) ||
> -		    test_bit(Unmerged, &rdev->flags)) {
> +
> +		if (!rdev && !rrdev) {
>  			set_bit(R10BIO_Degraded, &r10_bio->state);
>  			continue;
>  		}
> -		if (test_bit(WriteErrorSeen, &rdev->flags)) {
> +		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;
>  			sector_t dev_sector =3D r10_bio->devs[i].addr;
>  			int bad_sectors;
> @@ -1320,8 +1323,10 @@ retry_write:
>  					max_sectors =3D good_sectors;
>  			}
>  		}
> -		r10_bio->devs[i].bio =3D bio;
> -		atomic_inc(&rdev->nr_pending);
> +		if (rdev) {
> +			r10_bio->devs[i].bio =3D bio;
> +			atomic_inc(&rdev->nr_pending);
> +		}
>  		if (rrdev) {
>  			r10_bio->devs[i].repl_bio =3D bio;
>  			atomic_inc(&rrdev->nr_pending);
> @@ -1377,58 +1382,58 @@ retry_write:
>  	for (i =3D 0; i < conf->copies; i++) {
>  		struct bio *mbio;
>  		int d =3D r10_bio->devs[i].devnum;
> -		if (!r10_bio->devs[i].bio)
> -			continue;
> -
> -		mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
> -		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
> -			    max_sectors);
> -		r10_bio->devs[i].bio =3D mbio;
> -
> -		mbio->bi_sector	=3D (r10_bio->devs[i].addr+
> -				   choose_data_offset(r10_bio,
> -						      conf->mirrors[d].rdev));
> -		mbio->bi_bdev =3D conf->mirrors[d].rdev->bdev;
> -		mbio->bi_end_io	=3D raid10_end_write_request;
> -		mbio->bi_rw =3D WRITE | do_sync | do_fua;
> -		mbio->bi_private =3D r10_bio;
> -
> -		atomic_inc(&r10_bio->remaining);
> -		spin_lock_irqsave(&conf->device_lock, flags);
> -		bio_list_add(&conf->pending_bio_list, mbio);
> -		conf->pending_count++;
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		if (!mddev_check_plugged(mddev))
> -			md_wakeup_thread(mddev->thread);
> -
> -		if (!r10_bio->devs[i].repl_bio)
> -			continue;
> +		if (r10_bio->devs[i].bio) {
> +			struct md_rdev *rdev =3D conf->mirrors[d].rdev;
> +			mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
> +			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
> +				    max_sectors);
> +			r10_bio->devs[i].bio =3D mbio;
> +
> +			mbio->bi_sector	=3D (r10_bio->devs[i].addr+
> +					   choose_data_offset(r10_bio,
> +							      rdev));
> +			mbio->bi_bdev =3D rdev->bdev;
> +			mbio->bi_end_io =3D raid10_end_write_request;
> +			mbio->bi_rw =3D WRITE | do_sync | do_fua;
> +			mbio->bi_private =3D r10_bio;
> =20
> -		mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
> -		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
> -			    max_sectors);
> -		r10_bio->devs[i].repl_bio =3D mbio;
> +			atomic_inc(&r10_bio->remaining);
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			bio_list_add(&conf->pending_bio_list, mbio);
> +			conf->pending_count++;
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			if (!mddev_check_plugged(mddev))
> +				md_wakeup_thread(mddev->thread);
> +		}
> =20
> -		/* We are actively writing to the original device
> -		 * so it cannot disappear, so the replacement cannot
> -		 * become NULL here
> -		 */
> -		mbio->bi_sector	=3D (r10_bio->devs[i].addr +
> -				   choose_data_offset(
> -					   r10_bio,
> -					   conf->mirrors[d].replacement));
> -		mbio->bi_bdev =3D conf->mirrors[d].replacement->bdev;
> -		mbio->bi_end_io	=3D raid10_end_write_request;
> -		mbio->bi_rw =3D WRITE | do_sync | do_fua;
> -		mbio->bi_private =3D r10_bio;
> +		if (r10_bio->devs[i].repl_bio) {
> +			struct md_rdev *rdev =3D conf->mirrors[d].replacement;
> +			if (rdev =3D=3D NULL) {
> +				/* Replacement just got moved to main 'rdev' */
> +				smp_mb();
> +				rdev =3D conf->mirrors[d].rdev;
> +			}
> +			mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
> +			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
> +				    max_sectors);
> +			r10_bio->devs[i].repl_bio =3D mbio;
> +
> +			mbio->bi_sector =3D (r10_bio->devs[i].addr +
> +					   choose_data_offset(
> +						   r10_bio, rdev));
> +			mbio->bi_bdev =3D rdev->bdev;
> +			mbio->bi_end_io =3D raid10_end_write_request;
> +			mbio->bi_rw =3D WRITE | do_sync | do_fua;
> +			mbio->bi_private =3D r10_bio;
> =20
> -		atomic_inc(&r10_bio->remaining);
> -		spin_lock_irqsave(&conf->device_lock, flags);
> -		bio_list_add(&conf->pending_bio_list, mbio);
> -		conf->pending_count++;
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		if (!mddev_check_plugged(mddev))
> -			md_wakeup_thread(mddev->thread);
> +			atomic_inc(&r10_bio->remaining);
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			bio_list_add(&conf->pending_bio_list, mbio);
> +			conf->pending_count++;
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			if (!mddev_check_plugged(mddev))
> +				md_wakeup_thread(mddev->thread);
> +		}
>  	}
> =20
>  	/* Don't remove the bias on 'remaining' (one_write_done) until

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-WIQy3fWW+iRW9D5euAho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMzEKOe/yOyVhhEJAQokoBAApgHzzSDB64588dBk8AXqsL3MXrSAczAp
nROr4/iipMWVrOgITPTFn+RWu3t4cwKK1k1j7vRPAeCNjOy2ERGTFClkWmGtpTeo
ilm1NJj7hFg/lW/1wWilaIyk3OHKdy6uZP/BdspkiZHI7MtI90/jZYDXvEIH5tnI
ybjmjkIMFbZ8no0YMaqaLE94VYP3eh7kpmN+rNDuxP6sPnxn1O2KVN/u5cQ7kTRP
LXvw7p28xZNSTxxPGcWi/KBowCU6gdB3rsaiZs0lsYCGoPJKtfKjoLwD53TaA8xZ
78VJbJETyanKz1E2Aj7nQ6f6TWBxmXuEGUuM+QtN6PDrvDVedpSCjIzE8QMQZO4e
SvSauji21VUl3imWRZcgCUe4Y0IsO4+o8NCz0zlGacPMioUpL6ixVxOw+S5hKmf4
TguR52O5rNy74uA9tF+c7Q4MgiLGETLl6RqVevVVuVnALn8ICMzUctk4ZVIrzBUA
r32Wk5siFQ7BYOWu5mDcJVOx39VxZDx8a+SXafObGg8a2C84vyvi7gqCk2uVfZzN
mldYDrOt7VPxAdj8T0QEXfRo8AJVsYpv77e338ttphujOfrIgqUEDfrOsAnPTixh
BMuM/96we9ZpWyR4LA5EejNFRsePeDTOrS8Mv20IaTzB+wrd3BEz3iCQV5vgfDhl
egkuVpru5Tw=
=bywK
-----END PGP SIGNATURE-----

--=-WIQy3fWW+iRW9D5euAho--
