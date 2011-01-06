Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1AFOnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:43:15 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:44152 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1AFOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:43:13 -0500
Date: Thu, 6 Jan 2011 15:42:55 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110106144254.GC8803@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20110104125722.GC27114@darkside.kls.lan>
 <20110104224238.GA4978@gondor.apana.org.au>
 <20110104230644.GJ27114@darkside.kls.lan>
 <20110105003020.GA5751@gondor.apana.org.au>
 <20110105035222.GA8762@darkside.kls.lan>
 <20110105054735.GA7773@gondor.apana.org.au>
 <20110105131621.GA24769@darkside.kls.lan>
 <20110106061241.GA18939@gondor.apana.org.au>
 <20110106131516.GB8803@darkside.kls.lan>
 <20110106133541.GA22030@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <20110106133541.GA22030@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: multipart/mixed; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 07, 2011 at 12:35:41AM +1100, Herbert Xu wrote:
> On Thu, Jan 06, 2011 at 02:15:16PM +0100, Mario 'BitKoenig' Holbe wrote:
> > 1. Having ECX on the clobber-list is not really necessary.
> > XSTORE doesn't touch ECX at all.
> > REP XSTORE would touch it, but for this ECX would be an input anyways.
>=20
> The documentation wasn't clear whether ECX would be updated without
> the REP prefix so I included it to be on the safe side.  Unfortunately
> my only VIA machine is on another continent at the moment so I can't
> test it myself.  Can you verify that ECX isn't changed without the
> REP prefix?

session-log (including small test case) attached: ECX is not changed.

> > 2. Would you mind doing the same for EDX as you did for EDI?
> According to my documentation EDX isn't be modified (nor would it
> make sense as it would break REP XSTORE).  Are you seeing anything
> different?

http://linux.via.com.tw/support/beginDownload.action?eleid=3D181&fid=3D261
VIA PadLock Programming Guide, v1.66, 4th August 2005
2.1 XSTORE Instructions (page 9)
RNG Quality Factor: EDX
[...] Only the lower two bits of EDX are meaningful; the upper 30 bits
are ignored by the instruction and may be set to zero.
                                   ^^^^^^^^^^^^^^^^^^

http://hackipedia.org/Hardware/CPU/x86/chip,%20VIA/nano/Padlock,%20quick%20=
reference%20v0.95%20(July%2025th,%202008).pdf
PadLock Quick Reference, v0.95, 25th July 2008
RANDOM NUMBER GENERATION (page 3)
Register Usage: Output
EDX Bits 0:1 are unchanged, all higher order bits are zero.
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

See the attached session-log as well: those EDX bits are indeed zeroed.


Btw: I believe both documents are quite clear regarding ECX for XSTORE.


Mario
--=20
User sind wie ideale Gase - sie verteilen sich gleichmaessig ueber alle Pla=
tten

--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="via-rng-test.out"
Content-Transfer-Encoding: quoted-printable

holbe@ideapad ~ % cat via-rng-test.c
#include <stdio.h>
#include <string.h>

static inline unsigned long xstore(unsigned long *addr, unsigned long edx)
{
	unsigned long eax_out;
	unsigned long ecx =3D 0xaa55aa55;
	int ts_state;

	printf("ecx: %08lx\tedx: %08lx\tedi: %p\n", ecx, edx, addr);

	asm(".byte 0x0F,0xA7,0xC0 /* xstore %%edi (addr=3D%0) */"
		: "=3Dm" (*addr), "=3Da" (eax_out), "+D" (addr), "+d" (edx), "+c" (ecx));

	printf("ecx: %08lx\tedx: %08lx\tedi: %p\n", ecx, edx, addr);

	return eax_out;
}

int main(void) {
	unsigned long addr[8];

	memset(addr, 0, sizeof(addr));

	printf("%p: %08lx\n", addr, *(unsigned long *)addr);
	xstore(addr, 0xffffff03); /* 8 rand bits, 32 stored bits */
	printf("%p: %08lx\n", addr, *(unsigned long *)addr);

	return 0;
}
holbe@ideapad ~ % gcc -o via-rng-test via-rng-test.c
holbe@ideapad ~ % ./via-rng-test
0xbff09d40: 00000000
ecx: aa55aa55   edx: ffffff03   edi: 0xbff09d40
ecx: aa55aa55   edx: 00000003   edi: 0xbff09d48
0xbff09d40: 339d4525
holbe@ideapad ~ %=20

--eHhjakXzOLJAF9wJ--

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSXU7hS+e2HeSPbpAQIeSgf+MYwpGWC2YJzt7u//+8jUvRuwWxm0yWyp
WFWiqUTqGRdgSnIvHkcELFM5sX1xcvqYQwF9CinynoKOUxYjAqekmd0jlneLVZXG
eDudLBL9+6IUaBavCuv3b6pK82rS3RQojjge/omm9af8C94cTkOHoumYW+WSwgxl
4FkeC2cUV06jCqBQpKEEtRS6ztDn/3TRTU4PUpqSGCTkzfemN+vNeus0cclo6+1O
eBbudsWl6iVGRiKHJoIscxQgvNDmJPARvOlSeo/38e8j+rbE1NiI5KWpfyFdj0dk
BrQxXw/nohY9DPeor9wDyrGJsnAN9bUWBpMml82C85ifXAd0h153mQ==
=/ngJ
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
