Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0DVVdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:33:21 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:41981 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab0DVVdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:33:19 -0400
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 17:33:18 EDT
Date: Thu, 22 Apr 2010 23:08:40 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [170/197] lockdep: fix incorrect percpu usage
Message-ID: <20100422210840.GB6856@nik-comp.linuxbox.cz>
References: <20100422191857.GA13268@kroah.com>
 <20100422190922.618832798@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <20100422190922.618832798@kvm.kroah.org>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 3688405 records(08-04-2010)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
hmm,
this one seems to break compilation for me:
kernel/lockdep.c: In function =E2=80=98static_obj=E2=80=99:
kernel/lockdep.c:595: error: invalid use of array with unspecified bounds
kernel/lockdep.c:595: error: invalid use of array with unspecified bounds
make[1]: *** [kernel/lockdep.o] Error 1

I'm using gcc-4.1.2
regards
nik

On Thu, Apr 22, 2010 at 12:10:21PM -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>=20
> The mainline kernel as of 2.6.34-rc5 is not affected by this problem beca=
use
> commit 10fad5e46f6c7bdfb01b1a012380a38e3c6ab346 fixed it by refactoring.
>=20
> lockdep fix incorrect percpu usage
>=20
> Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is=
 needed
> for per cpu pointers).
>=20
> git blame points to commit:
>=20
> lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d
>=20
> But it's really just moving the code around. But it's enough to say that =
the
> problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.=
6.23.
>=20
> It should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
> stable branches are still maintained).
>=20
> (tested on 2.6.33.1 x86_64)
>=20
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Tejun Heo <tj@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  kernel/lockdep.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -591,9 +591,9 @@ static int static_obj(void *obj)
>  	 * percpu var?
>  	 */
>  	for_each_possible_cpu(i) {
> -		start =3D (unsigned long) &__per_cpu_start + per_cpu_offset(i);
> -		end   =3D (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
> -					+ per_cpu_offset(i);
> +		start =3D (unsigned long) per_cpu_ptr(&__per_cpu_start, i);
> +		end   =3D (unsigned long) per_cpu_ptr(&__per_cpu_start
> +						    + PERCPU_ENOUGH_ROOM, i);
> =20
>  		if ((addr >=3D start) && (addr < end))
>  			return 1;
>=20
>=20
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFL0LrY3xdJJrLygV4RAoFjAKCGRsu2j/68jFg9+e6bmBnQ9gD2qgCdGHd4
8TrlQwLBmM0gA0aK+lh8wEo=
=OLCt
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
