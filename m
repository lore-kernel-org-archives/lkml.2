Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1AXX2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:28:53 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:55852 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1AXX2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:28:52 -0500
X-Spam-ASN: 
Date: Tue, 25 Jan 2011 02:28:34 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
Message-ID: <20110125022834.559a97f5@desktopvm.lvknet>
In-Reply-To: <20110121194317.GA8908@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	<20110119083916.GA2166@elte.hu>
	<20110121174438.7521539f@tornado.gnet>
	<AANLkTi=p3=MkGevrW1YU0v_V5iXLw7iLDuWeb7Rf8Xx_@mail.gmail.com>
	<20110121194317.GA8908@elte.hu>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/DVFuYcRzhp_NQT3./phw+5p"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DVFuYcRzhp_NQT3./phw+5p
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 21 Jan 2011 20:43:17 +0100
Ingo Molnar <mingo@elte.hu> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

>=20
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
> > HOWEVER, even then I think you should see the lockdep message as a
> > problem. The automated toolchain is great because it shows problems
> > that it thinks might happen - not when they happen, but based on a
> > simpler theoretical model. Ignoring the error because there is some
> > rule in place that is hard to explain to the automated toolchain is
> > the wrong thing to do, because it makes the lockdep automation less
> > reliable.
>=20
> Yeah. Also, inevitably the false positives have a higher likelyhood
> of making it into a released kernel, often because the bugs where
> there was a real lockup as well got noticed via other means.
>=20
> It's similar with compiler warnings as well: the questionable ones where
> GCC is wrong or at least confused accumulate.
>=20
> Also note that here there's a real lockup here as well, shortly after the=
 lockdep=20
> message - the boot never continues, the box keep spewing the PPS debug me=
ssages:
>=20
> [   76.240020] pps pps0: PPS event at 4294911356
> [   76.244380] pps pps0: PPS event at 1295471377.240018362
> [   76.249608] pps pps0: capture assert seq #2
> [   77.252019] pps pps0: PPS event at 4294911609
> [   77.256379] pps pps0: PPS event at 1295471378.252017372
> [   77.261604] pps pps0: capture assert seq #3
> [   78.264021] pps pps0: PPS event at 4294911862
> [   78.268387] pps pps0: PPS event at 1295471379.264018619
> [   78.273621] pps pps0: capture assert seq #4
> [   79.276018] pps pps0: PPS event at 4294912115
> [   79.280384] pps pps0: PPS event at 1295471380.276016791
> [   79.285619] pps pps0: capture assert seq #5
>=20
> But nothing happens, the boot never continues.

I think I was able to reproduce the lockup by compiling parport,
parport_pc, pps_parport and pps_gen_parport into the kernel. Both
pps_parport and pps_gen_parport use parport_claim_or_block() to claim
the parallel port. They compete for the parallel port at bootup. One
of them gets it. The other one then lockups the system.

After reading the docs I decided to just add PARPORT_FLAG_EXCL and it
worked. The patch follows. Does it help with the lockup you experience?

--=20
  Alexander

--Sig_/DVFuYcRzhp_NQT3./phw+5p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNPgsiAAoJEElrwznyooJbztcIAIUosMSQwzo1Y8kwRUqczZ2n
pRo2433qLDacNfYLE0sgCeV/2LXV/YrEzCVZLbAlp141Ob8yh+3fGZ1pOcbioDYz
g6Yo7pMkNLzoR6uWrdWzRni5JzgjcHeTfeNpENGzcMzWhJhY7DzldvfP+WeZjAOn
rz/jANwpQ5cDt3hFjkBejv6/L3k74dq8/hV10wf21KJjvL3XWjkxnqlc96q79bG2
EeJsKTkcY77aG2uMXxInwgfGfuFMvBl0ZaevyzBO8Ut8CALlugCqSHLVj2Vcm5XJ
HA6APGIF+QiVKG9abnpiP09BLw0pba8t3kO2PLMpmyu9+jSmsgAdObK/KWRPE7c=
=sfy8
-----END PGP SIGNATURE-----

--Sig_/DVFuYcRzhp_NQT3./phw+5p--
