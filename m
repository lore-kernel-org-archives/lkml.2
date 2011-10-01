Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1JATkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:40:39 -0400
Received: from mail.southpole.se ([193.12.106.18]:41868 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1JATkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:40:31 -0400
Message-ID: <1317497922.23899.6.camel@satguru>
Subject: Re: RFD: x32 ABI system call numbers
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Tobias Klauser <tklauser@distanz.ch>
Date: Sat, 01 Oct 2011 21:38:42 +0200
In-Reply-To: <201109011335.05663.arnd@arndb.de>
References: <4E582577.2060805@zytor.com>
	 <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com>
	 <4E5E71A8.8090209@zytor.com> <201109011335.05663.arnd@arndb.de>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-idjHVYwXtq3zhAzvU/JF"
X-Mailer: Evolution 3.2.0- 
Mime-Version: 1.0
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-idjHVYwXtq3zhAzvU/JF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-09-01 at 13:35 +0200, Arnd Bergmann wrote:
> On Wednesday 31 August 2011, H. Peter Anvin wrote:
> > On 08/31/2011 10:19 AM, Linus Torvalds wrote:
> > >=20
> > > I think tv_nsec was just overlooked, and people thought "it has no
> > > legacy users that were 'int', so we'll just leave it at 'long', which
> > > is guaranteed to be enough for nanoseconds that only needs a range of
> > > 32 bits".
> > >=20
> > > In contrast, tv_usec probably does have legacy users that are "int".
> > >=20
> > > So POSIX almost certainly only looked backwards, and never thought
> > > about users who would need to make it "long long" for compatibility
> > > reasons.
> > >=20
> > > The fact that *every*other*related*field* in POSIX/SuS has a typedef
> > > exactly for these kinds of reasons just shows how stupid that "long
> > > tv_nsec" thing is.
> > >=20
> > > I suspect that on Linux we can just say "tv_nsec" is suseconds_t too.
> > > Then we can make time_t and suseconds_t just match, and be "__s64" on
> > > all new platforms.
> > >=20
> >=20
> > Let me see if I can raise this with the POSIX committee.
>=20
> Shall we go ahead with this patch for 3.1 in the meantime? This is the
> least invasive way I can see to let OpenRISC use 64 bit time_t in the
> released kernel.

Was there any consensus reached on this matter?  A couple of days left
to try to sneak this in, if this is what everyone agrees is the right
way forward...

The patch is fine as far as OpenRISC is concerned.

/Jonas



>=20
> The worst thing that can happen is that we will have to change it again
> if this patch breaks something on OpenRISC, but if we don't do it now,
> then we have one more architecture stuck with 32 bit time_t or we will
> have to break its ABI.
>=20
> I'm not completely convinced about the type we should use for tv_nsec
> and tv_usec. The main worry I have is that common implementations
> of timeval_add() or similar will require an expensive 64 bit division
> on 32 bit systems, which they would not need with a 32 bit suseconds_t.
> Should we use explicit padding instead in that case?
>=20
> Interestingly, I noticed that parisc always uses a 32 bit suseconds_t,
> even for its 64 bit ABI (which is not used all that much), so it has
> implicit padding.
>=20
> 8<----
> OpenRISC: change time_t and suseconds_t to 64 bit
>=20
> time_t should really be 64 bit wide for all new ABIs including 32 bit
> architectures, to allow having timestamps beyond 2038. For now, we
> leave the default in asm-generic/posix-types to 32 bit wide, but the
> plan is to change that in the next merge window so we reduce the
> risk of breaking other architectures in the process.
>=20
> In order to allow struct timespec/timeval to be free of padding, we
> need suseconds_t to be the same size, and change the second member
> of struct timespec to also be suseconds_t instead of long.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>=20
> diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm=
/Kbuild
> index 11162e6..77bcc02 100644
> --- a/arch/openrisc/include/asm/Kbuild
> +++ b/arch/openrisc/include/asm/Kbuild
> @@ -38,7 +38,6 @@ generic-y +=3D msgbuf.h
>  generic-y +=3D pci.h
>  generic-y +=3D percpu.h
>  generic-y +=3D poll.h
> -generic-y +=3D posix_types.h
>  generic-y +=3D resource.h
>  generic-y +=3D rmap.h
>  generic-y +=3D scatterlist.h
> diff --git a/arch/openrisc/include/asm/posix_types.h b/arch/openrisc/incl=
ude/asm/posix_types.h
> new file mode 100644
> index 0000000..f0b2944
> --- /dev/null
> +++ b/arch/openrisc/include/asm/posix_types.h
> @@ -0,0 +1,12 @@
> +#ifndef __OPENRISC_POSIX_TIME_T
> +#define __OPENRISC_POSIX_TIME_T
> +
> +typedef long long __kernel_suseconds_t;
> +#define __kernel_suseconds_t __kernel_suseconds_t
> +
> +typedef long long __kernel_time_t;
> +#define __kernel_time_t __kernel_time_t
> +
> +#include <asm-generic/posix_types.h>
> +
> +#endif
> diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posi=
x_types.h
> index 3dab008..0c53135 100644
> --- a/include/asm-generic/posix_types.h
> +++ b/include/asm-generic/posix_types.h
> @@ -39,6 +39,10 @@ typedef unsigned int	__kernel_gid_t;
>  typedef long		__kernel_suseconds_t;
>  #endif
> =20
> +#ifndef __kernel_time_t
> +typedef long		__kernel_time_t;
> +#endif
> +
>  #ifndef __kernel_daddr_t
>  typedef int		__kernel_daddr_t;
>  #endif
> @@ -78,7 +82,6 @@ typedef long		__kernel_ptrdiff_t;
>   */
>  typedef long		__kernel_off_t;
>  typedef long long	__kernel_loff_t;
> -typedef long		__kernel_time_t;
>  typedef long		__kernel_clock_t;
>  typedef int		__kernel_timer_t;
>  typedef int		__kernel_clockid_t;
> diff --git a/include/linux/time.h b/include/linux/time.h
> index b306178..207c0aa 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -12,8 +12,8 @@
>  #ifndef _STRUCT_TIMESPEC
>  #define _STRUCT_TIMESPEC
>  struct timespec {
> -	__kernel_time_t	tv_sec;			/* seconds */
> -	long		tv_nsec;		/* nanoseconds */
> +	__kernel_time_t		tv_sec;		/* seconds */
> +	__kernel_suseconds_t	tv_nsec;	/* nanoseconds */
>  };
>  #endif
> =20


--=-idjHVYwXtq3zhAzvU/JF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6HbEMACgkQ70gcjN2673P5kwCfSmbpQSqXhGRBqy2Xsd3r4XkU
u0IAn3sBj26mOHGWJk+XbdV9EqTiWNZX
=ygzW
-----END PGP SIGNATURE-----

--=-idjHVYwXtq3zhAzvU/JF--

