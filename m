Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0DVWCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:02:54 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57015 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751671Ab0DVWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:02:53 -0400
Date: Thu, 22 Apr 2010 18:02:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [170/197] lockdep: fix incorrect percpu usage
Message-ID: <20100422220249.GB15195@Krystal>
References: <20100422191857.GA13268@kroah.com> <20100422190922.618832798@kvm.kroah.org> <20100422210840.GB6856@nik-comp.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20100422210840.GB6856@nik-comp.linuxbox.cz>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:00:33 up 90 days, 37 min, 10 users,  load average: 0.03, 0.07,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Nikola Ciprich (nikola.ciprich@linuxbox.cz) wrote:
> Hi,
> hmm,
> this one seems to break compilation for me:
> kernel/lockdep.c: In function =E2=80=98static_obj=E2=80=99:
> kernel/lockdep.c:595: error: invalid use of array with unspecified bounds
> kernel/lockdep.c:595: error: invalid use of array with unspecified bounds
> make[1]: *** [kernel/lockdep.o] Error 1
>=20
> I'm using gcc-4.1.2
> regards
> nik
>=20

Oh, you are right. I tweaked a few config options and got your error. Here =
is an
updated patch.

Greg, this v2 should replace the original patch you have. Sorry about the
trouble.

lockdep fix incorrect percpu usage (v2)

Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is n=
eeded
for per cpu pointers).

Changelog since v1:
- Move PERCPU_ENOUGH_ROOM outside of per_cpu_ptr(), where it belongs.

git blame points to commit:

lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d

But it's really just moving the code around. But it's enough to say that the
problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.=
23.

This patch applies to mainline as of 2.6.34-rc2. It also should be applied =
to
stable 2.6.23.x to 2.6.33.x (or whichever of these stable branches are still
maintained).

(based on 2.6.33.1, also applies to 2.6.34-rc2 -tip)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: stable <stable@kernel.org>
---
 kernel/lockdep.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/lockdep.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6-lttng.orig/kernel/lockdep.c	2010-04-22 17:51:28.000000000 -04=
00
+++ linux-2.6-lttng/kernel/lockdep.c	2010-04-22 17:55:02.000000000 -0400
@@ -600,9 +600,9 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start =3D (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   =3D (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
-					+ per_cpu_offset(i);
+		start =3D (unsigned long) per_cpu_ptr(&__per_cpu_start, i);
+		end   =3D (unsigned long) per_cpu_ptr(&__per_cpu_start, i)
+					+ PERCPU_ENOUGH_ROOM;
=20
 		if ((addr >=3D start) && (addr < end))
 			return 1;

--=20
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFL0MeJPyWo/juummgRAql4AKCRhkjWSCQfaVpzFq6kAOIDAMuP4wCfQi4L
HW270q/qIYMuKYx+2N5Atw0=
=ICfp
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
