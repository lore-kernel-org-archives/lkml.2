Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0ETKWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:22:35 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50289 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab0ETKWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:22:34 -0400
Date: Thu, 20 May 2010 12:22:27 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100520122227.16ea1cbc@mjolnir.ossman.eu>
In-Reply-To: <4BF50405.4070706@kernel.org>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
	<20100519232906.3be82279@mjolnir.ossman.eu>
	<20100519233408.7436bd9b@mjolnir.ossman.eu>
	<20100520091429.192d560c@mjolnir.ossman.eu>
	<4BF4F979.4070903@kernel.org>
	<20100520112945.61bf9705@mjolnir.ossman.eu>
	<4BF50405.4070706@kernel.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-4156-1274350951-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-4156-1274350951-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 May 2010 11:42:29 +0200
Tejun Heo <tj@kernel.org> wrote:

> > randomly flipped bits? I don't know if you saw the first couple of
> > mails (before linux-ide was added), but the problem is data being moved
> > around, not just randomly changed.
>=20
> I ony saw your previous posting.  TLP corruption can happen during
> command setup phase and bit flipping in the command address part is
> definitely possible, so reads and writes can be headed at wrong places
> in both memory and disk.  I don't know whether this would fit your
> symptom tho.
>=20

Ah. Here's the problem description from a previous mail:

The corruption is 104 bytes. Somewhat odd number. I would have expected
something more fundamental like a sector or a page.

The data in question seems to come from another part of the file.

The shifts are 015d1380 =3D> 015d0f80 (-1024 bytes) and 02210380 =3D>
0220ff80 (also -1024 bytes). At least the offset is a nice, sane power
of two number.

Noteworthy is also that the last three nibbles of the corruption are
always the same (xxxxx380 =3D> xxxxxf80).

</recap>

Note that the above analysis is from files, so it involves the entire
stack. I've since focused on raw disks. See below.

> > Another note is that the problem seems to worsen under load. I'm
> > running the dd thing in the background, which seems to make read errors
> > more common on my test files on the filesystem level.
>=20
> It would be great if you can try a different controller in similar
> setup.

I only stock sil3132 cards as those are the only decent add-on cards
I've found. AHCI stuff all seems to be onboard.

> But please keep trying to narrow down the problem and if
> possible please remove filesystem from the stack and test against the
> block device directly.

That's what I've been doing the last couple of runs. From a previous
mail:

I did some more testing though, and this might be a low level issue. I
did the following multiple times:

# dd if=3D/dev/sde skip=3D4k bs=3D4M count=3D500 | md5sum

And the results were:

13aa29adcd16f8d0faf3cb5c39f43826
d1e3df33c0b0d03c61f880a8f2bb6cfb
13aa29adcd16f8d0faf3cb5c39f43826
13aa29adcd16f8d0faf3cb5c39f43826
13aa29adcd16f8d0faf3cb5c39f43826
13aa29adcd16f8d0faf3cb5c39f43826
7a746328b60a63b76847c3e1319a8534
13aa29adcd16f8d0faf3cb5c39f43826

</recap2>

Since the amount of data is much larger here and the incidents more
rare, I haven't been able to confirm that the corruption is identical
to what I've seen in the files. I'm working on the assumption that it
is...

I've since constructed a script that keeps re-running the above over
all relevant disks and keeps track of how many unique md5 values we
get. It's been running for about 1.5 hours right now, and here are the
results so far:

sdd - 3, sde - 4, sdf - 1, sdb - 1, sdc - 1,=20

sdd and sde are both on the same controller, so the problem you
mentioned could be relevant.

I'll let the test run for a few more hours and try moving things off
that controller later tonight.


Thanks for looking at this. Unstable data storage is one of those
things that can keep you up at night. :/

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-4156-1274350951-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv1DWYACgkQ7b8eESbyJLiymwCfdo7vtkhLgEa8FPk+NBlBili1
04UAnjwr7r6lTgFWXzoM0hpH8N6DzbtV
=pvxB
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-4156-1274350951-0001-2--
