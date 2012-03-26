Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2CZPAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:00:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:33226 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746Ab2CZPAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:00:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="125219532"
Message-ID: <1332774201.22278.47.camel@sauron.fi.intel.com>
Subject: Re: [patch] Add design document for UBIFS secure deletion
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 18:03:21 +0300
In-Reply-To: <alpine.DEB.2.00.1203231705500.22944@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	    <1329152067.22240.214.camel@sauron.fi.intel.com>
	    <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
	    <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
	   <1331277476.22872.2.camel@sauron.fi.intel.com>
	   <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net>
	  <1332346218.14983.20.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203231448520.22944@eristoteles.iwoars.net>
	 <1332517132.18717.102.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203231705500.22944@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-17E376cia7Evqx5wh8qA"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-17E376cia7Evqx5wh8qA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-23 at 17:38 +0100, Joel Reardon wrote:
> I'll answer some quickly here now while they're fresh in mind and add the=
m
> to the doc later.
>=20
> >
> > > In particular, it does not behave like a
> > > +log-structured file system: when a KSA LEB is updated, its contents =
are
> > > +written to a new physical location on the flash memory, UBI's logica=
l map is
> > > +then updated to this new physical address and the previous version o=
f the KSA
> > > +LEB is then erased.
> >
> > Am I right that you basically wanted to say that when you update a KSA
> > LEB, you make sure that the physical flash does not contain the old
> > contents of this LEB? Would be nice to re-phrase.
> >
> > Side question - how do you do this?
>=20
> Here I'm just spelling out atomic update, so nothing fancy except
> leb_change() to replace the keys.

This will write the new data to a different PEB, and schedule the old
PEB for erasure in background. If the UBI thread is alive, it will
schedule the erasure soon. But if it is stopped or dead, the erasure may
happen only when there is a need in an empty PEB.

To make sure the old contents are really erased, you'd have to call
'ubi_sync()'. But the problem with this is that it will force erasure of
_all_ the scheduled PEBs, so it may block for long time, especially on
NOR.

For the security things you'd probably need to extend 'ubi_leb_change()'
and add a 'sync' parameter which would make sure the previous PEB is
synchronously erased before 'ubi_leb_change()' returns. I think it is
very easy to do.

> Protected as in the kernel stops joe user from reading raw from /dev/mtd,
> no?

No, I think both UBI volumes and MTD devices are world-readable.


> > Hmm, why is it necessary to re-initialize unused keys?
> >
>=20
> This can be a mount option actually, it was a response to  attack that wa=
s
> proposed to me about the design. The idea here is that, suppose the
> attacker reads the drive at time X with sufficient privilages to read the
> keys. Then the attacker will know for certain that those keys will
> eventually be used to encrypt data. So they can compromise not only the
> current data, but also future data. By replacing unused keys, the attacke=
r
> is limited only to compromizing current data.

Would be nice to put this to the doc, and I do not think we need a mount
option for this.

> Ah, yes! Any other tool?

No, just this one.

> > Hmm, interesting how you manage checkpoints. I guess the easiest would
> > be to have a special inode (not visible for users) and store checkpoint=
s
> > there?
> >
>=20
> The first block of the KSA stores only checkpoints, so KSA size is 1 +
> minrequired + some slack. So this may need the multiple LEB
> approach for one of the other UBIFS areas when its size is too big, but I
> havn't done that since its generally so highly compressable that it
> wasn't ever a concern.

But I guess the larger is the volume the larger the checkpoint is? Also,
would you please rename it to something else because checkpoint is a
very common word with more or less commonly understood meaning, and
using it for something else in context of file-systems is asking for
troubles. Even if you call it 'backpack' (random word from my head) -
I'll be happier :-) But something more sensible is more appreciated of
course :-)

--=20
Best Regards,
Artem Bityutskiy

--=-17E376cia7Evqx5wh8qA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPcIU5AAoJECmIfjd9wqK0O70P+wcg8PYwrxe6KfVeJuEqdBCj
mc77SSvlbj67qRrTp+7mdr6QGpeOU4RoaoVghOCFaTe83WOjumP2WZBPrNQ8xnSR
sJhGuA1o9ySMoOpWPVffwt9IhBvlGhv9Vfv7pGpqJwqXmDEzfUAsxE6TGwo5rM/e
1pCgrPdFoVNCrnkXiYHSJaOFWAfEwoypM8VtyM+SxiQsuaob2YudPOVUQY1fWfUv
MDjFGy6Cy+ivZVDCdmLQW/P4rxYAsk0E9kKKEEQMiuH3J9hl63Fgd5KFBUCY4JKm
ofPpKAT+rhuvQbC1sESc0J31NcTzSIyUtvks43q5NYniW0dB+N3J8hygrFXVyA2g
soNlLcFbqyMNExQVlsrJHsPBoa6bIbpupFL8r9Cxb139FWmZA5rcT9q+PSIe7b0O
qYGZ5sF17aOqkk2nHO54hiJDyg/cKOzmx1Q2luZsyJBOnXf0L1EzjUsoymvglrH+
f/fcyZC5otBD6E/4uodpwCJD8AB79nuEWzVS8Is0Khwz14tevJc71no5yVNDP62e
un8mqfAps8vVab2gK+1TFVTQWasPSAZI5iPFjuUW5weN71vsPaNAj1NB5p9plB2S
Tr+an5r4uji/TYkgl7wN8emO7Tb4RZ05oYZWI/M8jIpkp//NXUxM32fJQYFx67fg
LIpyXzA3MnV6gz3Wa77h
=5Pdr
-----END PGP SIGNATURE-----

--=-17E376cia7Evqx5wh8qA--

