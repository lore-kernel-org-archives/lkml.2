Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2HTACI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 20:02:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2HTACG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 20:02:06 -0400
Date: Mon, 20 Aug 2012 10:01:34 +1000
From: NeilBrown <neilb@suse.de>
To: stan@hardwarefreak.com
Cc: David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>,
        Miquel van Smoorenburg <mikevs@xs4all.net>,
        Linux RAID <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT to md raid 6 is slow
Message-ID: <20120820100134.22b2b056@notabene.brown>
In-Reply-To: <50317804.9010701@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
	<502B8D1F.7030706@anonymous.org.uk>
	<CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
	<201208152307.q7FN7hMR008630@xs8.xs4all.nl>
	<502CD3F8.70001@hardwarefreak.com>
	<502D6B0A.6090508@xs4all.net>
	<502DF357.8090205@hardwarefreak.com>
	<502E2817.8040306@xs4all.net>
	<502F237D.6060806@hardwarefreak.com>
	<502F698C.9010507@msgid.tls.msk.ru>
	<50305AB9.5080302@hardwarefreak.com>
	<5030F1C6.90205@hesbynett.no>
	<50317804.9010701@hardwarefreak.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0N9hsM4MjZ3jmA/QtzDraEI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0N9hsM4MjZ3jmA/QtzDraEI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Aug 2012 18:34:28 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 8/19/2012 9:01 AM, David Brown wrote:
> > I'm sort of jumping in to this thread, so my apologies if I repeat
> > things other people have said already.
>=20
> I'm glad you jumped in David.  You made a critical statement of fact
> below which clears some things up.  If you had stated it early on,
> before Miquel stole the thread and moved it to LKML proper, it would
> have short circuited a lot of this discussion.  Which is:
>=20
> > AFAIK, there is scope for a few performance optimisations in raid6.  One
> > is that for small writes which only need to change one block, raid5 uses
> > a "short-cut" RMW cycle (read the old data block, read the old parity
> > block, calculate the new parity block, write the new data and parity
> > blocks).  A similar short-cut could be implemented in raid6, though it
> > is not clear how much a difference it would really make.
>=20
> Thus my original statement was correct, or at least half correct[1], as
> it pertained to md/RAID6.  Then Miquel switched the discussion to
> md/RAID5 and stated I was all wet.  I wasn't, and neither was Dave
> Chinner.  I was simply unaware of this md/RAID5 single block write RMW
> shortcut.  I'm copying lkml proper on this simply to set the record
> straight.  Not that anyone was paying attention, but it needs to be in
> the same thread in the archives.  The takeaway:
>=20

Since we are trying to set the record straight....

> md/RAID6 must read all devices in a RMW cycle.

md/RAID6 must read all data devices (i.e. not parity devices) which it is n=
ot
going to write to, in an RWM cycle (which the code actually calls RCW -
reconstruct-write).

>=20
> md/RAID5 takes a shortcut for single block writes, and must only read
> one drive for the RMW cycle.

md/RAID5 uses an alternate mechanism when the number of data blocks that ne=
ed
to be written is less than half the number of data blocks in a stripe.  In
this alternate mechansim (which the code calls RMW - read-modify-write),
md/RAID5 reads all the blocks that it is about to write to, plus the parity
block.  It then computes the new parity and writes it out along with the new
data.

>=20
> [1}The only thing that's not clear at this point is if md/RAID6 also
> always writes back all chunks during RMW, or only the chunk that has
> changed.

Do you seriously imagine anyone would write code to write out data which it
is known has not changed?  Sad. :-)

NeilBrown


--Sig_/0N9hsM4MjZ3jmA/QtzDraEI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDF+bDnsnt1WYoG5AQJUUBAAhEMa0DZiiHnheaBDYjQt4aawGitDlu4h
9h/snaOnhImm28/foxd8qdAIhp/7ukXOaJdrx5Amx7Yc1GBBHw4fpll5Zgk2t87W
MaYaYBZt+TCeQ7dZ1FSEzWWNUPsHCYKYkNXcKkVjHod47jD0MLjU6ToS81Cpceza
UiCki7o9w7ROO3U/MHwYFEH++WT+cOlA1vOp/Z9JyFTySdgopC0NGyB/dV/YM9jd
6G69I5ry+Lu99aiH6D7F81hyp7G1LEAdwknrdMJQ9FTK7PEvFXm6123n3Y54FDhU
jH7PC+tjwSjbRZP//U0Dx/iOgulHZ3Rz1yfIDDaDBAIZRRCbEPar8nuFiNeRsD8w
nJhlK9XMZiyDEIH29mvcwJSHm7yHQchYYyauBgv+V/Ao8YsdRH3W7ylZ68rObqP3
vhYPz+F4jTSoAjMqj9jK9hwD2oYF93UDqp0okLGldngg95750i4qGmtUGWErFEyU
No3jTo76j0zHqWZ2IwmVndVx4NMKIi+/GdQf/ZHw7VbPDYOn+VUrqKCkDx4ynNPR
IEguwwMv69M93/YiUA+azD/HEi89v0WkmFi4DT9/gyYYitsh+eGTxXR0duKEn2Sj
geHXN4yTtOYoqMfswfMeEUjP0NPnMKcBXlrui3gJXfPDw2k33wkPrcieyLiIcRy2
jnuov4q5xps=
=mvmN
-----END PGP SIGNATURE-----

--Sig_/0N9hsM4MjZ3jmA/QtzDraEI--
