Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0JaWsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:48:07 -0400
Received: from frost.carfax.org.uk ([212.13.194.111]:2127 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0JaWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:48:05 -0400
Date: Sun, 31 Oct 2010 22:47:57 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: cwillu <cwillu@cwillu.com>, Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: Horrible btrfs performance due to fragmentation
Message-ID: <20101031224757.GA2430@selene>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	cwillu <cwillu@cwillu.com>, Calvin Walton <calvin.walton@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
 <AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
 <AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd0.lon.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Mon, Nov 01, 2010 at 12:36:58AM +0200, Felipe Contreras
	wrote: > On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
	> > btrfs fi defrag isn't recursive. "btrfs filesystem defrag /home" will
	> > defragment the space used to store the folder, without touching the >
	> space used to store files in that folder. > > Yes, that came up on the
	IRC, but: > > 1) It doesn't make sense: "btrfs filesystem" doesn't allow a
	fileystem > as argument? Why would anyone want it to be _non_ recursive?
	[...] 
	Content analysis details:   (-0.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
	domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 01, 2010 at 12:36:58AM +0200, Felipe Contreras wrote:
> On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
> > btrfs fi defrag isn't recursive. =A0"btrfs filesystem defrag /home" will
> > defragment the space used to store the folder, without touching the
> > space used to store files in that folder.
>=20
> Yes, that came up on the IRC, but:
>=20
> 1) It doesn't make sense: "btrfs filesystem" doesn't allow a fileystem
> as argument? Why would anyone want it to be _non_ recursive?

   You missed the subsequent discussion on IRC about the interaction
of COW with defrag. Essentially, if you've got two files that are COW
copies of each other, and one has had something written to it since,
it's *impossible* for both files to be defragmented, without making a
full copy of both:

Start with a file (A, etc are data blocks on the disk):

file1 =3D ABCDEF

Cow copy it:

file1 =3D ABCDEF
file2 =3D ABCDEF

Now write to one of them:

file1 =3D ABCDEF
file2 =3D ABCDxF

   So, either file1 is contiguous, and file2 is fragmented (with the
block x somewhere else on disk), or file2 is contiguous, and file1 is
fragmented (with E somewhere else on disk). In fact, we've determined
by experiment that when you defrag a file that's sharing blocks with
another one, the file gets copied in its entirety, thus separating the
blocks of the file and its COW duplicate.

> 2) The filesystem should not degrade performance so horribly no matter
> how long the it has been used. Even git has automatic garbage
> collection.

   Since, I believe, btrfs uses COW very heavily internally for
ensuring consistency, you can end up with fragmenting files and
directories very easily. You probably need some kind of scrubber that
goes looking for non-COW files that are fragmented, and defrags them
in the background.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---  =20

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMzfIcIKyzvlFcI40RAjomAKC7h8axNIS0H47H2uYyIDBvFngUYwCfRUkH
TPgHcU2xv8BDUzNjRJ4iaCw=
=iX+7
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
