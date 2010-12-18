Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0LRBHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:07:48 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:34538 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0LRBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:07:47 -0500
X-Spam-ASN: 
Date: Sat, 18 Dec 2010 04:07:38 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 07/16] pps: move idr stuff to pps.c
Message-ID: <20101218040738.64ab69f6@apollo.gnet>
In-Reply-To: <20101217161328.457ac8e6.akpm@linux-foundation.org>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<8f66dc7613bb4a7d34e6d76465df3bf6bb2f66a8.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161328.457ac8e6.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/fckbppP=/W.AYRJzVNs3W4W"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fckbppP=/W.AYRJzVNs3W4W
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 17 Dec 2010 16:13:28 -0800
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Fri, 17 Dec 2010 22:54:31 +0300
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > Since now idr is only used to manage char device id's and not used in
> > kernel API anymore it should be moved to pps.c. This also makes it
> > possible to release id only at actual device freeing so nobody can
> > register a pps device with the same id while our device is not freed
> > yet.
> >=20
> > ...
> >
> >  int pps_register_cdev(struct pps_device *pps)
> >  {
> >  	int err;
> >  	dev_t devt;
> > =20
> > +	/* Get new ID for the new PPS source */
> > +	if (idr_pre_get(&pps_idr, GFP_KERNEL) =3D=3D 0)
> > +		return -ENOMEM;
> > +
> > +	/* Now really allocate the PPS source.
> > +	 * After idr_get_new() calling the new source will be freely available
> > +	 * into the kernel.
> > +	 */
> > +	spin_lock_irq(&pps_idr_lock);
> > +	err =3D idr_get_new(&pps_idr, pps, &pps->id);
> > +	spin_unlock_irq(&pps_idr_lock);
> > +
> > +	if (err < 0)
> > +		return err;
>=20
> The IDR interface really sucks :(
>=20
> What this code should be doing is
>=20
> retry:
> 	if (idr_pre_get(&pps_idr, GFP_KERNEL) =3D=3D 0)
> 		return -ENOMEM;
> 	spin_lock_irq(&pps_idr_lock);
> 	err =3D idr_get_new(&pps_idr, pps, &pps->id);
> 	spin_unlock_irq(&pps_idr_lock);
> 	if (err < 0) {
> 		if (err =3D=3D -EAGAIN)
> 			goto retry;
> 		return err;
> 	}
>=20
> this way it correctly handles the case where the idr_pre_get()
> succeeded in precharging the pool, but some other task cam in and stole
> your reservation.

Yeah, I see. Maybe switching from spin lock to mutex and protecting the
whole thing with it can do? Like this:

...
mutex_lock(&pps_idr_lock);
if (idr_pre_get(&pps_idr, GFP_KERNEL) =3D=3D 0) {
	mutex_unlock(&pps_idr_lock);
	return -ENOMEM;
}
err =3D idr_get_new(&pps_idr, pps, &pps->id);
mutex_unlock(&pps_idr_lock);

if (err < 0)
	return err;
...

--=20
  Alexander

--Sig_/fckbppP=/W.AYRJzVNs3W4W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNDAlaAAoJEElrwznyooJbOs0H/3OFNnJE/o0ixyv+yOxhe3+K
NuPHDaJH0ZYFKWigcczIKcs3w8/YzAGGgZv8IPfrBrG6U6Apb9D3bSkoxCfV6eVP
1bKJP8zBAynTLV6r39Yt1UH36fVOz31GkZDE4uPi1hl3bAG0kfvh6Y9cG4wurtLL
5dDdNhM07lfnCRUzH7WVLv47P8BwfRcUl3q9kv7x+4tiynPNTsSize5OzfaKUmPR
f15aeOkYpYkKvwiDw5g/YPEfnMB0uicP6K0zTJqTlJ3oxvavY4jLkkS1f6kDW5jG
GAelb31k4x5jzUj+tEFwdSB2wFrZ8SKtIXGMT5sLcWH0wy3+WSGunDeINBjlAqY=
=0qxF
-----END PGP SIGNATURE-----

--Sig_/fckbppP=/W.AYRJzVNs3W4W--
