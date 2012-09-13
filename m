Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2IMFo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:44:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab2IMFo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:44:27 -0400
Date: Thu, 13 Sep 2012 15:44:17 +1000
From: NeilBrown <neilb@suse.de>
To: hank <pyu@redhat.com>
Cc: miku@iki.fi, jakob@ostenfeld.dk, ptb@it.uc3m.es,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug
 in fix_read_error function
Message-ID: <20120913154417.3f886f8d@notabene.brown>
In-Reply-To: <505144D0.4080908@redhat.com>
References: <5045708C.10705@redhat.com>
	<505144D0.4080908@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rdCyL2KT+tH7YNKV+Q__sb1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rdCyL2KT+tH7YNKV+Q__sb1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Sep 2012 10:28:32 +0800 hank <pyu@redhat.com> wrote:

> On 09/04/2012 11:07 AM, hank wrote:
>=20
> > From 0ba5879082544dc3aa13807087563b1258124b1e Mon Sep 17 00:00:00 2001
> > From: hank <pyu@redhat.com>
> > Date: Tue, 4 Sep 2012 10:23:45 +0800
> > Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug in
> >  fix_read_error function
> >=20
> > in fix_read_error function, the conf->mirrors[read_disk].rdev may
> > become NULL, as in this function, rdev->nr_pending may be zero, anyone
> > can delete it. So should check if it is NULL before use.
> >=20
> > Signed-off-by: hank <pyu@redhat.com>
> > ---
> >  drivers/md/raid1.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 611b5f7..fd8de28 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf, i=
nt read_disk,
> >  		if (!success) {
> >  			/* Cannot read from anywhere - mark it bad */
> >  			struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
> > -			if (!rdev_set_badblocks(rdev, sect, s, 0))
> > +			if (!rdev || !rdev_set_badblocks(rdev, sect, s, 0))
> >  				md_error(mddev, rdev);
> >  			break;
> >  		}
>=20
>=20
>=20
> Anyone can review this patch? I think it is a bug and should be fixed.

I agree there is a bug there but I don't think this is the right fix.
If rdev could be NULL there, then it could also be NULL in
		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
in handle_read_error().
I think we should just hold on to the reference to the rdev until we are
done with it, like the follow.

Would you agree?

Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 611b5f7..eb1f8a3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -333,9 +333,10 @@ static void raid1_end_read_request(struct bio *bio, in=
t error)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
=20
-	if (uptodate)
+	if (uptodate) {
 		raid_end_bio_io(r1_bio);
-	else {
+		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+	} else {
 		/*
 		 * oops, read error:
 		 */
@@ -349,9 +350,8 @@ static void raid1_end_read_request(struct bio *bio, int=
 error)
 			(unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
+		/* don't drop the reference on read_disk yet */
 	}
-
-	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 }
=20
 static void close_write(struct r1bio *r1_bio)
@@ -2220,6 +2220,7 @@ static void handle_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
 		unfreeze_array(conf);
 	} else
 		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
=20
 	bio =3D r1_bio->bios[r1_bio->read_disk];
 	bdevname(bio->bi_bdev, b);

--Sig_/rdCyL2KT+tH7YNKV+Q__sb1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFFysTnsnt1WYoG5AQKf4xAAwMbVHdvAGfXwEdLJQkDQc9nCRS4JMqSY
+ewl9AlNwFx4YKkaX/tWNSrLSD4b5F+bTEhXK0hhkUI4J37svGAhkZiaFICW6RQg
DEIjNyNvHdv0q+YXLNizKyZuf5RG7f7IYAMtAXNazT0uAuxjdmgOQHreE/9pUxFA
6uiF9oc5vG0PUdS/qV66AryTM9B4DaeEl4SNdpjuOPbu//9V1gFydY/OEyxE5LOF
m2HN2bcGSDnU/6edZ2uM13Ijbu4JDzzgmUH6jOVrktE8P/iEMldIKmPZVeSZW305
BkYVg9nCs4X4lcvNrfSTCUSvNtiS/bSpSoLMpmcE9SJ8DRZAFIhrxSD2RnrOJ6is
rYagGw3J7tJlOVgle/vsrlQA54zc5wFElTIjxdJJhFmaGbtDMh6DAJEeqaa1DMlh
TdOtXQNJB23+F/OyyM4CCy/xt4INxceQz6543WZgnWO1nvXwfErOLAvFfztdyJWV
minSEDD65WKIzqXA1bfQhnxMF/dRPT7WoUR3BqyZHC599ZmKtQBvDds+L7A74UXm
SuP6G74+yxxX8M2Fpn7sRWujcGZvg1z6QPvLWvcHUmhhvgXj91DKx3hsd06fAZla
WXDyGr7SCw2naZ4zoBh4dquEl/7YGFAD2gytBuxf+xe6HRWToiW+o0tukYZIxdsS
R+0C9oMhZtE=
=aMBx
-----END PGP SIGNATURE-----

--Sig_/rdCyL2KT+tH7YNKV+Q__sb1--
