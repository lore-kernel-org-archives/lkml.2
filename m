Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2ISDjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:39:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54513 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440Ab2ISDju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:39:50 -0400
Message-ID: <1348025970.4836.38.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 117/135] NFS: return error from decode_getfh in decode open
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Weston Andros Adamson <dros@netapp.com>
Date: Wed, 19 Sep 2012 04:39:30 +0100
In-Reply-To: <20120919012623.GA17910@herton-Z68MA-D2H-B3>
References: <20120917003625.784119135@decadent.org.uk>
	 <20120917003642.413673073@decadent.org.uk>
	 <20120919012623.GA17910@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7IiO8642EHKoNn4eV35L"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7IiO8642EHKoNn4eV35L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-18 at 22:26 -0300, Herton Ronaldo Krzesinski wrote:
> On Mon, Sep 17, 2012 at 01:38:22AM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > I'm not sure whether my expansion of the fix is correct here.
> >=20
> > ------------------
> >=20
> > From: Weston Andros Adamson <dros@netapp.com>
> >=20
> > commit 01913b49cf1dc6409a07dd2a4cc6af2e77f3c410 upstream.
> >=20
> > If decode_getfh failed, nfs4_xdr_dec_open would return 0 since the last
> > decode_* call must have succeeded.
> >=20
> > Signed-off-by: Weston Andros Adamson <dros@netapp.com>
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > [bwh: Backported to 3.2: this function makes two more function calls
> >  (no longer present in mainline) with the same issue, so fix them up
> >  similarly.]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  fs/nfs/nfs4xdr.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > --- a/fs/nfs/nfs4xdr.c
> > +++ b/fs/nfs/nfs4xdr.c
> > @@ -6113,12 +6113,15 @@ static int nfs4_xdr_dec_open(struct rpc_
> >  	status =3D decode_open(xdr, res);
> >  	if (status)
> >  		goto out;
> > -	if (decode_getfh(xdr, &res->fh) !=3D 0)
> > +	status =3D decode_getfh(xdr, &res->fh);
> > +	if (status)
> >  		goto out;
> > -	if (decode_getfattr(xdr, res->f_attr, res->server,
> > -				!RPC_IS_ASYNC(rqstp->rq_task)) !=3D 0)
> > +	status =3D decode_getfattr(xdr, res->f_attr, res->server,
> > +				 !RPC_IS_ASYNC(rqstp->rq_task));
>=20
> I'm also not sure about the expansion of the fix here, not knowing very
> much about nfs. It seems that the code in some cases want to discard the
> status from decode_getfattr, for example nfs4_xdr_dec_rename is one case
> which does the same. Is it ok to return the status of decode_getfattr on
> nfs4_xdr_dec_open here? Or should it remain like it was before?

It looks like we try to get the file and directory attributes, and those
are nice to have but the open operation is still successful even if we
can't get them.  So my extra 'fixes' here are wrong.  Trond, is this
right?

Ben.

> > +	if (status)
> >  		goto out;
> > -	if (decode_restorefh(xdr) !=3D 0)
> > +	status =3D decode_restorefh(xdr);
> > +	if (status)
> >  		goto out;
> >  	decode_getfattr(xdr, res->dir_attr, res->server,
> >  			!RPC_IS_ASYNC(rqstp->rq_task));
>=20

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-7IiO8642EHKoNn4eV35L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFk+cue/yOyVhhEJAQokJA/9FtqgAFiFcz595FyXr+AIRtcdGI3adlpM
TqH01lwysrtWT4OVxETXMAOUpC98COZgACKXwxHbCntrnCQOcElV7fRefA2GUWC/
4F/cFu79Eqsd6t7ye/vXEm/AUBP0LuHMXDWr+zdUjTgy5ba6d1E71gEO8aQujIKE
GkzKk50QVpHNImKvDl7vXjhI0is/daUIteh23ke8Ir1ZD7vsxOdbK7HICDK/y8kz
Xi9aKulg+DgiGCRmDOpO7ueZsvzC/sDTcFtqqz29NZY7MO+Q1sKQuE3r9ACQC2a0
9n0e+szyyOucOCvVPZxNWJrme3NHgeFwGe6OmC5EBNg1ItXeTrYUvpzkNzRuuLVs
O2h0SXHd+hMLUGyQLmhKoH5j9cG3bgOwkakffSTILFz39M+3Ducd9ZFPRQb+ZHp/
ew46XXwbQfJs6B2gbYT3Ld488iTgvwYkUAtHBzNydjXXGsH7/IFloZjceVU3NT/D
9fd+YOpQbPuWqvk/IZh1gYgswGl9rvoofZHNk4BIO+AuDfwpTgrAGGPBKBkFhAx9
+9AMR+fJ6Ry1yojMFirTEGvknCUhIFWQYSChSh4wvuCMSS2Y2r4Aks26YphkL8zS
HLH5g60/Cgzk+z3UcG4JNTCvrbZFtMCXNrHEntENY6YTBIO9oApPi3vCTkzuYSPo
BBwXrn9kDFk=
=fNts
-----END PGP SIGNATURE-----

--=-7IiO8642EHKoNn4eV35L--
