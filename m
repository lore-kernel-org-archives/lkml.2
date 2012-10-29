Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2J2OlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:41:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48247 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757646Ab2J2OlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:41:20 -0400
Message-ID: <1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
From: Ben Hutchings <ben@decadent.org.uk>
To: Mark Lord <kernel@teksavvy.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 29 Oct 2012 14:40:58 +0000
In-Reply-To: <508E913D.2080104@teksavvy.com>
References: <508E002B.4090200@teksavvy.com> <20121029064643.GE574@1wt.eu>
	 <508E913D.2080104@teksavvy.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dHk3BuIqbFbS2VqcCJfi"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dHk3BuIqbFbS2VqcCJfi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-29 at 10:22 -0400, Mark Lord wrote:
> On 12-10-29 02:46 AM, Willy Tarreau wrote:
> > On Mon, Oct 29, 2012 at 12:03:55AM -0400, Mark Lord wrote:
> >> My server here runs the 3.4.xx series of "stable" kernels.
> >> Until today, it was running 3.4.9.
> >> Today I tried to upgrade it to 3.4.16.
> >> It hangs in setup.c.
> >>
> >> I've isolated the fault down to this specific change
> >> that was made between 3.4.9 and 3.4.16.
> >> Reverting this change allows the system to boot/run normally again.
> >>
> >>
> >> --- linux-3.4.9/arch/x86/kernel/setup.c	2012-08-15 11:17:17.000000000 =
-0400
> >> +++ linux-3.4.16/arch/x86/kernel/setup.c	2012-10-28 13:36:33.000000000=
 -0400
> >> @@ -927,8 +927,21 @@
> >>
> >>  #ifdef CONFIG_X86_64
> >>  	if (max_pfn > max_low_pfn) {
> >> -		max_pfn_mapped =3D init_memory_mapping(1UL<<32,
> >> -						     max_pfn<<PAGE_SHIFT);
> >> +		int i;
> >> +		for (i =3D 0; i < e820.nr_map; i++) {
> >> +			struct e820entry *ei =3D &e820.map[i];
> >> +
> >> +			if (ei->addr + ei->size <=3D 1UL << 32)
> >> +				continue;
> >> +
> >> +			if (ei->type =3D=3D E820_RESERVED)
> >> +				continue;
> >> +
> >> +			max_pfn_mapped =3D init_memory_mapping(
> >> +				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
> >> +				ei->addr + ei->size);
> >> +		}
> >> +
> >>  		/* can we preseve max_low_pfn ?*/
> >>  		max_low_pfn =3D max_pfn;
> >>  	}
> >=20
> > For the record, it is this commit introduced in 3.4.16 :
> >=20
> > commit efd5fa0c1a1d1b46846ea6e8d1a783d0d8a6a721
> > Author: Jacob Shin <jacob.shin@amd.com>
> > Date:   Thu Oct 20 16:15:26 2011 -0500
> >=20
> >     x86: Exclude E820_RESERVED regions and memory holes above 4 GB from=
 direct mapping.
> >    =20
> >     commit 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a upstream.
> >    =20
> >     On systems with very large memory (1 TB in our case), BIOS may repo=
rt a
> >     reserved region or a hole in the E820 map, even above the 4 GB rang=
e. Exclude
> >     these from the direct mapping.
> >    =20
> >     [ hpa: this should be done not just for > 4 GB but for everything a=
bove the legacy
> >       region (1 MB), at the very least.  That, however, turns out to re=
quire significant
> >       restructuring.  That work is well underway, but is not suitable f=
or rc/stable. ]
> >    =20
> >     Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> >     Link: http://lkml.kernel.org/r/1319145326-13902-1-git-send-email-ja=
cob.shin@amd.com
> >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > Willy
>=20
>=20
> Thanks, Willy.
>=20
> I've also now downloaded linux-3.7.0-rc3, and it boots/runs without need =
for patching.
> So there's a fix somewhere in between that perhaps could also get backpor=
ted to -stable.

Might well be:

commit 1f2ff682ac951ed82cc043cf140d2851084512df
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Mon Oct 22 16:35:18 2012 -0700

    x86, mm: Use memblock memory loop instead of e820_RAM

However I'm not sure that this loop is correct either.  Yinghai, does
your version definitely iterate in increasing pfn order?  If not then
the max_pfn_mapped assignment must be conditional.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-dHk3BuIqbFbS2VqcCJfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUI6Veue/yOyVhhEJAQpJFQ//cP9n3NWElCd3MvMVFhOWTXmcQN05Wb36
WMOm3bDTN0/OBm4NVH5pVaPZOa1j9w3SvSvG0KUKp1FZDlYH/MOYZIEseNonsDlR
26m0/twoNbYbfYOFi8QgjZRlKJ1aAkmjE9szN73nE0oisEIwLQMWwJSTj8INoqf5
33x0AAt6V76ArXholgQ9jssDoD4Sc+OaBEBE0Rj+qgeTCnF0zE/6T66IiaHkGKYI
Nz0/6qO7GTxeiCfl9ijegP5qb+J/iiaUs67cWWmYfHrOx3G+ymc1MTvXBBLEgAxN
QuwMqyGGeyhqp5bTq4u7mPpXaa2TkaYIjonYE+tA9SIlIT3x1DLtj30VQ/Td4K74
Bp29ls7ZoM77LBFqVSNmmbzWmv3fR/IwQ32rtKTzsUsYJPt9t73VaWLFHvDyWlhz
efgSwjWgdD3tkPKGZBguhyfIWDAilwu4YB37TfjZvPUW/cgD5Y7llQj1Wv6QiPEQ
zjJOFzAJ1ZHSnOpoebJLIrV8q7ibS95LoKbJjjdNOfo2lrJge/DdxG1rAttbxg8A
4fykqWsf4g1pmQE19V+fcnAHhdbuaUT6ySfZ44+jV+hUDyj/phKRnoOcecXurXCD
veYv+likJGU4/Y3ZYUbPAcRWG4IrvKhaYd58ZSFiuz9QmAr9oUklUuQIp21/NXxj
JtmQrHxZ3s4=
=6jSB
-----END PGP SIGNATURE-----

--=-dHk3BuIqbFbS2VqcCJfi--
