Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2JCDar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:30:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2JCDaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:30:46 -0400
Date: Wed, 3 Oct 2012 13:30:45 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
Message-ID: <20121003133045.272dd564@notabene.brown>
In-Reply-To: <20121002210923.GU26488@google.com>
References: <20120924145639.3b65fd8b@notabene.brown>
	<20120928162343.GF22647@google.com>
	<20121002162201.2f5d0f91@notabene.brown>
	<20121002210923.GU26488@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Sgme9LiNPe1GYhq/PtrMOhE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Sgme9LiNPe1GYhq/PtrMOhE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Oct 2012 14:09:23 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> On Tue, Oct 02, 2012 at 04:22:01PM +1000, NeilBrown wrote:
> > On Fri, 28 Sep 2012 09:23:43 -0700 Kent Overstreet <koverstreet@google.=
com>
> > wrote:
> >=20
> > > On Mon, Sep 24, 2012 at 02:56:39PM +1000, NeilBrown wrote:
> > > >=20
> > > > Hi Jens,
> > > >  this patch has been sitting in my -next tree for a little while an=
d I was
> > > >  hoping for it to go in for the next merge window.
> > > >  It simply allows bio_split() to be used on bios without a payload,=
 such as
> > > >  'discard'.
> > >=20
> > > Thing is, at some point in the stack a discard bio is going to have d=
ata
> > > - see blk_add_rquest_payload(), and it used to be the single page was
> > > added to discard bios above generic_make_request(), in
> > > blkdev_issue_discard() or whatever it's called.
> > >=20
> > > So while I'm sure your code works, it's just a fragile way of doing i=
t.
> > >=20
> > > There's also other types of bios where bi_size has nothing to do with
> > > the amount of data in the bi_io_vec - actually I think this is a new
> > > thing, since Martin Petersen just added REQ_WRITE_SAME and I don't th=
ink
> > > there were any other instances besides REQ_DISCARD before.
> > >=20
> > > So my preference would be defining a mask (REQ_DISCARD|REQ_WRITE_SAME=
),
> > > and if bio->bi_rw & that mask is true, just duplicate the bvec or
> > > whatever.
> >=20
> > Hi Kent,
> >  I'm afraid I don't see the relevance of your comments to the patch.
> >=20
> > The current bio_split code can successfully split a bio with zero or one
> > bi_vec entry.  If there are more than that, we cannot split.
> >=20
> > How does it matter whether the bio is a DISCARD or a WRITE_SAME or a DA=
TA or
> > whatever?
>=20
> Hrm, I think I didn't explain very well.
>=20
> After your change, if bio->bi_vcnt !=3D 0, then it splits the bvec.
>=20
> The trouble is that discard bios do under certain circumstances have
> bio->bi_vcnt !=3D 0, in which case splitting the bvec is the wrong thing
> to do - first_sectors will quite likely be bigger than the bvec.
>=20
> In practice this isn't currently a problem for discard bios, because
> since Christoph added blk_add_request_payload(), discard bios won't have
> that bvec added until they hit the scsi layer which will be after any
> splitting. But this is a fairly recent and unrelated change, and IMO not
> the kind of behaviour I'd want to rely on.
>=20
> WRITE_SAME is a problem for the same reason - bio_sectors(bio) may be
> large, but the bio will always have a single bvec and splitting the bvec
> is always the wrong thing to do for WRITE_SAME.
>=20
> So, I think it makes more sense to make the splitting conditional on
> !(bio->bi_rw & (REQ_DISCARD|REQ_WRITE_SAME)), in addition to
> bio->bi_vcnt =3D=3D 1.
>=20
> ..That make more sense?

Yes, that does make some more sense, thanks.  However it doesn't convince me
that we need to change the patch.

I guess my position is that once we get to this code, we absolutely have to
split the bio - it maps to two separate devices in a RAID0 or similar so
not-splitting is not an option.

Maybe various md devices need to detect and reject REQ_DISCARD requests that
have a payload and REQ_WRITE_SAME requests?  Or would they need to explicit=
ly
set a flag to say they accept them?

So maybe there is something to fix, but I don't think it is in bit_split,
except maybe to add WARN_ON ??

Thanks,
NeilBrown

--Sig_/Sgme9LiNPe1GYhq/PtrMOhE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGuxZTnsnt1WYoG5AQKDrA/7BYkgJKn7Q17f9FdJFlz/pOEtEtSxPwTd
fyPJvLJyQMQhcvGZk4+fVxvA1YuQ0JN9ewYUTLspRHXhCJPPGfEwCKpKg9QfdJE+
JfFLCtLYCRYeLrr/Hkowo5yzQOaN7ILrJySsgWH2SqksKU/3vM10paUALclW53ds
XGuYJHimx4Nvq66Eu9DedqqtXq2I9vs+/0IHaG3pYNbLzWEhXomqnRlL/vSeeRrM
BCM6T2YAzd1/UqumRZPF7nPEsgbfXHjynNJehXXeeVizj2dl1W18fbV728w7CIgP
M6AtMFhJGTScfYh9z7I5ZW6JsfGHOIotojFLiNhMP39h/5l47ff10e0OMb8ZjDz0
5wSTQfhgioZ2DFsRfLU5s1GDoG32NhCVPyBN+GvF4MrxtICQnGwRpNOOAPf8YAU7
yZK45FbQZ2E4pcEHrzEMvV4Ho3lQQlCNp5jXKJK7tO1Iz0z7U1ttiUghuhlD7/Wo
1kTDahL//hu0k+MndKNPnSOjK2Mys4mhtFr39KHLKpjqjEcN3zXN6i6BPopgvQBP
f8wAP3cX4wWbPbrCGc+cUICBsaJh01EZ135vndbAeLL3UyCyGJ2v2e3PepUhUdFF
mgXm/qfbzvWjsH9B46Vc6B0IR23N9PIH073pa8jlbMc7WJYnnTLTenG7EQB1c6ca
kchQ2PHO4to=
=fgyk
-----END PGP SIGNATURE-----

--Sig_/Sgme9LiNPe1GYhq/PtrMOhE--
