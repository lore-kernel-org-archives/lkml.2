Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab2ESKsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:48:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62001 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897Ab2ESKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:48:12 -0400
Message-ID: <1337424475.2041.8.camel@koala>
Subject: Re: [PATCH V2] UBI: add ubi_lnum_purge function to clear work queue
 for a lnum
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 19 May 2012 13:47:55 +0300
In-Reply-To: <alpine.DEB.2.00.1205191140280.19017@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net>
	 <1337082012.2528.181.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205191140280.19017@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-n43SKifXr4KfxWXBZ7k7"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-n43SKifXr4KfxWXBZ7k7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-19 at 11:46 +0200, Joel Reardon wrote:
> > Take the work_sem at the beginning. Release at the very end.
> >
> > Then you can do something like this:
> >
> > int found =3D 1;
> >
> > while (found) {
> > 	found =3D 0;
> >
> > 	spin_lock(&ubi->wl_lock);
> > 	list_for_each_entry(wrk, tmp, &ubi->works, list) {
> > 		if (wrk->lnum =3D=3D lnum) {
> > 			list_del(&wrk->list);
> > 			ubi->works_count -=3D 1;
> > 			ubi_assert(ubi->works_count >=3D 0);
> > 			spin_unlock(&ubi->wl_lock);
> >
> > 			err =3D wrk->func(ubi, wrk, 0);
> > 			if (err)
> > 				return err;
> >
> > 			spin_lock(&ubi->wl_lock);
> > 			found =3D 1;
> > 			break;
> > 	}
> > 	spin_unlock(&ubi->wl_lock);
> > }
> >
>=20
>=20
> If I use list_for_each_entry_safe(), it protects against deleting as it
> iterates.

Yes, but do not be confused, it does not protect against concurrent
deleting. I would not use word "protect" at all - it is just a version
of list_for_each_entry() which we use when we delete list elements
inside the loop. It requires another temporary variable.

>  If I take the work_sem first, is it okay to do a simple
> traversal instead of one traversal per removed item?

No, work_sem does not protect the list. It is just a bit unusual way of
syncing with all the processes which are performing UBI works. Take a
closer look - there is only one single place where we take it for
writing - ubi_wl_flush(). Everywhere else we take it for reading which
means that many processes may enter the critical section, and may
concurrently add/remove elements to/from the list. The list is protected
by the spinlock.

>  Even if another
> thread adds new work for the same vol_id/lnum, its okay, because the
> caller of this function only cares about vol_id/lnums erasures that
> it knows are currently on the worklist.

If you walk the list and read pointers, and someone else modifies them,
you may be in trouble. You cannot traverse the list without the
spinlock. And once you dropped the spinlock - you have to start over
because your 'wrk' pointer may point to a non-existing object, because
this object might have been already freed. This is why I added 2 loops.

--=20
Best Regards,
Artem Bityutskiy

--=-n43SKifXr4KfxWXBZ7k7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPt3pbAAoJECmIfjd9wqK0D7QQAKAH6VKmBr1CBNXeWNDCowTo
4Cc8ARBKTC3m2WWOMpT9MwV8GR15LEP2oBQ+vUrYzspo2+WJ+fuhjdbZpqlTXYTm
uDNFYIpVZSrTTgAYvQRmlOEdwpX4H4Fp5S/tmL9bfm6fzdtAng0+L4gMsaopm+3s
X22MeHrZjQJsb1k2pW+N8ZIhwJ6yjvjgqYM+Go0Cf7AHbIwZXjQxl7YdyynLmun/
4ZlfqZbVChJBx9kGzb3YNF6Z3J4rlDakrAZRrE2rOw4DiDacU2dfAyJ3wEBlK4nH
6R7SiUIrSi2+ajD+XT6o3ATKcgzpYBpVgcRqJ2nJmTZUZ6HNKyRUmlzBN+YeK8TY
B1QeZCWp8DSHJ9lOM7YNdQWYfVTghjq92onclXWV/iDKdi11OjIJUzoJG73KIgGx
WJzRFF5lmYBPe2b0dGVuX32cA2kY+aGNsY+Q+K+nZYxb+5iGKV56Yrhx38gFuVCF
qq/sTLGn9zakaUAJRvWcYrWstyZqxz1zoGuQx3LrBsdf3Kxo0i1e1Bcr6JeBfwrb
YWoi+RdeAK86zmr7IOVYKA3uoqUSh3kMxkrrRjbBQGNyZ1A+QpNCrsrz2yjA7vZs
K8Q6T2FHSgFSB0kEjMfZgv039OpTK672vy2gB3OH/u39J8FiGJ7ItD2hKgecmQvP
I+hjAcLyO5ERp4A/vApK
=8Ur2
-----END PGP SIGNATURE-----

--=-n43SKifXr4KfxWXBZ7k7--

