Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2ISXrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:47:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab2ISXrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:47:10 -0400
Date: Thu, 20 Sep 2012 09:46:48 +1000
From: NeilBrown <neilb@suse.de>
To: hank <pyu@redhat.com>
Cc: miku@iki.fi, jakob@ostenfeld.dk, ptb@it.uc3m.es,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug
 in fix_read_error function
Message-ID: <20120920094648.3997ecac@notabene.brown>
In-Reply-To: <50517B51.4000805@redhat.com>
References: <5045708C.10705@redhat.com>
	<505144D0.4080908@redhat.com>
	<20120913154417.3f886f8d@notabene.brown>
	<50517B51.4000805@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/C3Uxdg0ZpWqjcSFQ_5g2fNn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/C3Uxdg0ZpWqjcSFQ_5g2fNn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Sep 2012 14:21:05 +0800 hank <pyu@redhat.com> wrote:

> On 09/13/2012 01:44 PM, NeilBrown wrote:
>=20
> > On Thu, 13 Sep 2012 10:28:32 +0800 hank <pyu@redhat.com> wrote:
> >=20
> >> On 09/04/2012 11:07 AM, hank wrote:
> >>
> >>> From 0ba5879082544dc3aa13807087563b1258124b1e Mon Sep 17 00:00:00 2001
> >>> From: hank <pyu@redhat.com>
> >>> Date: Tue, 4 Sep 2012 10:23:45 +0800
> >>> Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug in
> >>>  fix_read_error function
> >>>
> >>> in fix_read_error function, the conf->mirrors[read_disk].rdev may
> >>> become NULL, as in this function, rdev->nr_pending may be zero, anyone
> >>> can delete it. So should check if it is NULL before use.
> >>>
> >>> Signed-off-by: hank <pyu@redhat.com>
> >>> ---
> >>>  drivers/md/raid1.c |    2 +-
> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >>> index 611b5f7..fd8de28 100644
> >>> --- a/drivers/md/raid1.c
> >>> +++ b/drivers/md/raid1.c
> >>> @@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf,=
 int read_disk,
> >>>  		if (!success) {
> >>>  			/* Cannot read from anywhere - mark it bad */
> >>>  			struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
> >>> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
> >>> +			if (!rdev || !rdev_set_badblocks(rdev, sect, s, 0))
> >>>  				md_error(mddev, rdev);
> >>>  			break;
> >>>  		}
> >>
> >>
> >>
> >> Anyone can review this patch? I think it is a bug and should be fixed.
> >=20
> > I agree there is a bug there but I don't think this is the right fix.
> > If rdev could be NULL there, then it could also be NULL in
> > 		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
> > in handle_read_error().
> > I think we should just hold on to the reference to the rdev until we are
> > done with it, like the follow.
> >=20
> > Would you agree?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 611b5f7..eb1f8a3 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -333,9 +333,10 @@ static void raid1_end_read_request(struct bio *bio=
, int error)
> >  		spin_unlock_irqrestore(&conf->device_lock, flags);
> >  	}
> > =20
> > -	if (uptodate)
> > +	if (uptodate) {
> >  		raid_end_bio_io(r1_bio);
> > -	else {
> > +		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
> > +	} else {
> >  		/*
> >  		 * oops, read error:
> >  		 */
> > @@ -349,9 +350,8 @@ static void raid1_end_read_request(struct bio *bio,=
 int error)
> >  			(unsigned long long)r1_bio->sector);
> >  		set_bit(R1BIO_ReadError, &r1_bio->state);
> >  		reschedule_retry(r1_bio);
> > +		/* don't drop the reference on read_disk yet */
> >  	}
> > -
> > -	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
> >  }
> > =20
> >  static void close_write(struct r1bio *r1_bio)
> > @@ -2220,6 +2220,7 @@ static void handle_read_error(struct r1conf *conf=
, struct r1bio *r1_bio)
> >  		unfreeze_array(conf);
> >  	} else
> >  		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
> > +	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
> > =20
> >  	bio =3D r1_bio->bios[r1_bio->read_disk];
> >  	bdevname(bio->bi_bdev, b);
>=20
>=20
> The md_error function will check if rdev is NULL, if it is NULL,
> md_error will return directly, so I think it is doesn't matther if we
> pass a NULL rdev to md_error function.
>=20
> But anyway, I can't find any problem in your patch, it is correct doubtle=
ss.

Thanks.
I've queued it for the next merge window.

Thanks,
NeilBrown


--Sig_/C3Uxdg0ZpWqjcSFQ_5g2fNn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFpZaDnsnt1WYoG5AQI6Ew//WlvrNWJ+Tupu/MMLYtX0O2lwo2P7X00c
Yuzdrz8VCsndkdd5bnNQUWrlqn1x1ywiool7uQCKIVCPFOVtBf+hWAUpw+4l8E0m
/DPs29eXcj0J3y2xEQuZabMsuLD9zlZO7Od37N4vSEz3ilXw+qdpkMzTTLbpPyQl
JOuIZ2oFdvEY6+msemxrDw7Zfc4OLKhkAxIcBtYAHK7unDJK8S5tL6UKEOiOxxnh
jbqmLWEdEk/j/C+Viqss8XPSxseti4en3I2hiwPtMUcVT5qSRHdHpE+i8s5isBS7
DwnUZ4wCGTP+quQs1m9wSWquilAX66o6Lh2Ufim/iNri8446rni94jAmAgNx3tEm
mqPXb1Pg9UP7V3i/TLrCUffYavC4tqXI+rbeFxUofrnRLquGumUBHwV4J2OE426M
/vvEZjV21Qfuhd8vmHmdHnqcosjOAtSowgMXRZnOpTNiDK7El1QfgUo3R9G6jnbK
fq1qldlHL7oYjowJ+nVLHMUonjPRDDANzCc4oGs6nkL7m76iiEfA6cjBFHsFaAFC
oRdfti76lcNTvyg/2jhNyxOMNFGjw3nJhDXJkr66q1sp0/fRKUjlsYhhYL4o64TI
FTlMZd0X/BIJtne2c+Pf4RCutw3L5mtgX+G6+VjanJ7PI1PbYBRKmNuIw8UO6p2x
+mwj09NgE1w=
=GDDg
-----END PGP SIGNATURE-----

--Sig_/C3Uxdg0ZpWqjcSFQ_5g2fNn--
