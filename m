Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2JBGWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:22:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab2JBGWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:22:04 -0400
Date: Tue, 2 Oct 2012 16:22:01 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
Message-ID: <20121002162201.2f5d0f91@notabene.brown>
In-Reply-To: <20120928162343.GF22647@google.com>
References: <20120924145639.3b65fd8b@notabene.brown>
	<20120928162343.GF22647@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/17rNVyK.vNCDsO/7eIdAiQV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/17rNVyK.vNCDsO/7eIdAiQV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Sep 2012 09:23:43 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> On Mon, Sep 24, 2012 at 02:56:39PM +1000, NeilBrown wrote:
> >=20
> > Hi Jens,
> >  this patch has been sitting in my -next tree for a little while and I =
was
> >  hoping for it to go in for the next merge window.
> >  It simply allows bio_split() to be used on bios without a payload, suc=
h as
> >  'discard'.
>=20
> Thing is, at some point in the stack a discard bio is going to have data
> - see blk_add_rquest_payload(), and it used to be the single page was
> added to discard bios above generic_make_request(), in
> blkdev_issue_discard() or whatever it's called.
>=20
> So while I'm sure your code works, it's just a fragile way of doing it.
>=20
> There's also other types of bios where bi_size has nothing to do with
> the amount of data in the bi_io_vec - actually I think this is a new
> thing, since Martin Petersen just added REQ_WRITE_SAME and I don't think
> there were any other instances besides REQ_DISCARD before.
>=20
> So my preference would be defining a mask (REQ_DISCARD|REQ_WRITE_SAME),
> and if bio->bi_rw & that mask is true, just duplicate the bvec or
> whatever.

Hi Kent,
 I'm afraid I don't see the relevance of your comments to the patch.

The current bio_split code can successfully split a bio with zero or one
bi_vec entry.  If there are more than that, we cannot split.

How does it matter whether the bio is a DISCARD or a WRITE_SAME or a DATA or
whatever?

NeilBrown


>=20
> That way it's much more explicit and less likely to trip someone else
> up later.
>=20
> (I've actually got a patch in my tree that does just that, but it's
> special cased in bio_advance() which makes things work out really
> nicely).
>=20
> >  Are you happy with it going in though my 'md' tree, or would you rathe=
r take
> >  it though your 'block' tree?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > From: Shaohua Li <shli@fusionio.com>
> > Date: Thu, 20 Sep 2012 09:36:03 +1000
> > Subject: [PATCH] block: makes bio_split support bio without data
> >=20
> > discard bio hasn't data attached. We hit a BUG_ON with such bio. This m=
akes
> > bio_split works for such bio.
> >=20
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 71072ab..dbb7a6c 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1501,7 +1501,7 @@ struct bio_pair *bio_split(struct bio *bi, int fi=
rst_sectors)
> >  	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
> >  				bi->bi_sector + first_sectors);
> > =20
> > -	BUG_ON(bi->bi_vcnt !=3D 1);
> > +	BUG_ON(bi->bi_vcnt !=3D 1 && bi->bi_vcnt !=3D 0);
> >  	BUG_ON(bi->bi_idx !=3D 0);
> >  	atomic_set(&bp->cnt, 3);
> >  	bp->error =3D 0;
> > @@ -1511,17 +1511,19 @@ struct bio_pair *bio_split(struct bio *bi, int =
first_sectors)
> >  	bp->bio2.bi_size -=3D first_sectors << 9;
> >  	bp->bio1.bi_size =3D first_sectors << 9;
> > =20
> > -	bp->bv1 =3D bi->bi_io_vec[0];
> > -	bp->bv2 =3D bi->bi_io_vec[0];
> > -	bp->bv2.bv_offset +=3D first_sectors << 9;
> > -	bp->bv2.bv_len -=3D first_sectors << 9;
> > -	bp->bv1.bv_len =3D first_sectors << 9;
> > +	if (bi->bi_vcnt !=3D 0) {
> > +		bp->bv1 =3D bi->bi_io_vec[0];
> > +		bp->bv2 =3D bi->bi_io_vec[0];
> > +		bp->bv2.bv_offset +=3D first_sectors << 9;
> > +		bp->bv2.bv_len -=3D first_sectors << 9;
> > +		bp->bv1.bv_len =3D first_sectors << 9;
> > =20
> > -	bp->bio1.bi_io_vec =3D &bp->bv1;
> > -	bp->bio2.bi_io_vec =3D &bp->bv2;
> > +		bp->bio1.bi_io_vec =3D &bp->bv1;
> > +		bp->bio2.bi_io_vec =3D &bp->bv2;
> > =20
> > -	bp->bio1.bi_max_vecs =3D 1;
> > -	bp->bio2.bi_max_vecs =3D 1;
> > +		bp->bio1.bi_max_vecs =3D 1;
> > +		bp->bio2.bi_max_vecs =3D 1;
> > +	}
> > =20
> >  	bp->bio1.bi_end_io =3D bio_pair_end_1;
> >  	bp->bio2.bi_end_io =3D bio_pair_end_2;
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/17rNVyK.vNCDsO/7eIdAiQV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqICTnsnt1WYoG5AQKC3Q/+J2kUUoMaOE1hvKhP6WKRdtY1pIvppq2f
ZmQEVuoMYBCvoWyreOS7FDrK9x50DWxvMzdi40b3kfyU8BxcOHdPr6tHYVOOPIc6
22rO9yVFuyUCVrEwGfs2kdJWt9nzKEx2l89TUvgNeJmRJS2HtbRhX97MUfqeZkdy
SFtFTq0vg3ZgRf3lCPZrvGIIeFkM86JV3iwIyzxuDC1Bu21N6Jz+6GBjaExdWs7P
yC/QZxKjio9+ofudPyaRV7KgZUVufAeIlJfnZGgyhQvo3IXkk8pFImFT2RXdCA0A
Aj8E9q1WI+l+qmM33wWu6QXm9fZ79VmmdPmAzp4RYgBpklAkLzzMLKhdOFgR3kJq
5nU2UiYEN3IocWarbxVGwOeLYRni0gN5NwkvwlHhAilFcDFpgFg3HFqQMruuUaEC
84Sz5sIA7vRSEWYlqIjvXZVi4FV0WP7r9z5vD6YyhSJDYB1ybfyJCWqbSux2xCEL
x8YubHdOSSIoIvf95XVmU9MhVglI8iI26HYDN7g0q6WD8lmyvhLBTazuwUziBJwF
AgJ9FGvvdIc/5RGkx5dC0WQOzKytKeT8iLFOnNmqeeP/ueoI8HBwv2pkgNRcRqwo
caxzsMSLB5qCZau9IKkNqele6ZvMLkqjvYOUxahvmCEce+A2VI9QXmPhKpJ8+qcv
ZEXgErGshSM=
=uvCv
-----END PGP SIGNATURE-----

--Sig_/17rNVyK.vNCDsO/7eIdAiQV--
