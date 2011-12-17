Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1LQTQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 14:16:00 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42354 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1LQTP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 14:15:58 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/7] Add conditional oopsing with annotation
Date: Sat, 17 Dec 2011 14:15:55 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0-atsc; KDE/4.6.5; x86_64; ; )
Cc: linux-arch@vger.kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2035331.fz8ENegvqb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201112171415.57601.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2035331.fz8ENegvqb
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 16 December 2011 09:13:57 David Howells wrote:
> --- a/arch/x86/include/asm/bug.h
> +++ b/arch/x86/include/asm/bug.h
>=20
> +extern const void __arch_annotated_bug;
> +#define arch_annotated_bug(desc)				\
> +	do {							\
> +		asm volatile(".globl __arch_annotated_bug\n"	\
> +			     "__arch_annotated_bug:\n"		\
> +			     "	ud2\n"				\
> +			     : : "d" (desc));			\
> +		unreachable();					\
> +	} while (0)
> +
> +#define is_arch_annotated_bug(regs)					\
> +	({ ((const void *)regs->ip =3D=3D &__arch_annotated_bug) ?		\
> +			(struct annotated_bug *)regs->dx : NULL; })

seems like this is making arches duplicate a bit of logic they shouldn't ha=
ve=20
to ... you could have asm-generic/bug.h do:

#ifdef arch_annotated_bug_fail

extern const void __arch_annotated_bug;
# define ARCH_ANNOTATED_SYM_STR CONFIG_SYMBOL_PREFIX"__arch_annotated_bug"

# define arch_annotated_bug(desc) \
	do { \
		asm volatile(".globl " ARCH_ANNOTATED_SYM ";\n" \
			ARCH_ANNOTATED_SYM_STR":\n"); \
		arch_annotated_bug_fail(desc) ; \
		unreachable(); \
	} while (0)

# define is_arch_annotated_bug(regs) \
	({ (instruction_pointer(regs) =3D=3D &__arch_annotated_bug) ? \
		(struct annotated_bug *)arch_annotated_bug_struct(regs) : \
		NULL; })

#endif

so now arches have to define two small bits.  in the x86 case:
#define arch_annotated_bug_fail(desc) asm volatile("ud2;" : : "d" (desc))
#define arch_annotated_bug_struct(regs) (regs)->dx
=2Dmike

--nextPart2035331.fz8ENegvqb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJO7OptAAoJEEFjO5/oN/WB0JAP/A7DhFNB2RDD55RMMK6i6uWd
YsGd446EQ+4Pw8l6sUYA4x8JahFQcBCujCYXzfhbY/uW80DVAAnD2x/Hmw06uEv2
z9fPsA/cZNxkUXqHqb0mTdZwI7Nck3AFZJe0k7172vJBuNUpED84ej5uY0kBo/QG
gOp4OZq6jTs1qmAGHYgV4rko6c8kVeVvSRgcCLtTNyXF4GMM0wR51XKjcXzx148E
XbPvvIkVnzFSHpUIc+tsvCnUCNpsgag+KWhEh8lljhk9Ntcz0tbnII+B6JI21E4m
TdF4XCHQ/PFbODQ/QWlmgt276k///qRIPaNNiCq7D5x3gtKZVN9iPgGbc321MaZ6
3Kozx6qVwvszSz+zRrOYF+zxX47XQvzCW3156aXd/3ytQoIgYUDKbjUEN+KFllqh
Os4eIB02wGznCBPL1MfUvpU+eoPaOM46exycgH2ax6uquDIlXtIrsv6Ie7ZK9rpt
DQ9fSQUIwkFgVJJBh3K3Gcy8kc7B+F4+UtOjzPs/vbAssE6N9bw0HfgKy/YZ29WX
L6wJ8lepL1V4pB6dtt/vsJO5lhXEidoEKKXaEAWIu2ZBh5RZp7G5/Dov5Vuisnt1
nUX0WTsXYDcextlKQnLhC4gdi7rc+ZP2flaUPxPKG4T1wLmFal23gOPJrhHDYKoc
EJkPdvfqh5m4ql8Mubac
=XUpS
-----END PGP SIGNATURE-----

--nextPart2035331.fz8ENegvqb--
