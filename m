Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2J0Q2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:28:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57865 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653Ab2J0Q2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:28:07 -0400
Message-ID: <1351355275.4834.10.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 18/85] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
From: Ben Hutchings <ben@decadent.org.uk>
To: Jacob Shin <jacob.shin@amd.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Oct 2012 17:27:55 +0100
In-Reply-To: <20121026000032.951798157@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
	 <20121026000032.951798157@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UZ691iJJwveAoWpc2krh"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UZ691iJJwveAoWpc2krh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-25 at 17:05 -0700, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Jacob Shin <jacob.shin@amd.com>
>=20
> commit 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a upstream.
>=20
> On systems with very large memory (1 TB in our case), BIOS may report a
> reserved region or a hole in the E820 map, even above the 4 GB range. Exc=
lude
> these from the direct mapping.
>=20
> [ hpa: this should be done not just for > 4 GB but for everything above t=
he legacy
>   region (1 MB), at the very least.  That, however, turns out to require =
significant
>   restructuring.  That work is well underway, but is not suitable for rc/=
stable. ]
[...]
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -919,8 +919,21 @@ void __init setup_arch(char **cmdline_p)
> =20
>  #ifdef CONFIG_X86_64
>  	if (max_pfn > max_low_pfn) {
> -		max_pfn_mapped =3D init_memory_mapping(1UL<<32,
> -						     max_pfn<<PAGE_SHIFT);
> +		int i;
> +		for (i =3D 0; i < e820.nr_map; i++) {
> +			struct e820entry *ei =3D &e820.map[i];
> +
> +			if (ei->addr + ei->size <=3D 1UL << 32)
> +				continue;
> +
> +			if (ei->type =3D=3D E820_RESERVED)
> +				continue;
> +
> +			max_pfn_mapped =3D init_memory_mapping(
> +				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
> +				ei->addr + ei->size);

Is it safe to assume that the e820 entries are sorted?  If not, this
assignment needs to be conditional.

Ben.

> +		}
> +
>  		/* can we preseve max_low_pfn ?*/
>  		max_low_pfn =3D max_pfn;
>  	}

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-UZ691iJJwveAoWpc2krh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIwLi+e/yOyVhhEJAQpUiQ//SSbE5o8WCMdPNidtg2Ak5R9+Zv07a7Fm
DVgvbWSuV0tqTWeHAiTVGPeDfvxfZUpcPpsDFi9Qqu905/mQoR3UgVClQ6v2PcoP
BWHr0NGUnF/p7FqrezxuUd4xuQ0OK8Ca7h/lZL5H7cGyb1Ijf2Ooh+w+QCcOeydm
fAccjuZpg5A2+aU34JuUn0E2l2mauB9snKrbwYzJeoOfE3/fFDDXJLbgwNSt1fiF
C3EYg4ebQWjZkBP5AavrKCsyEFx1ASO9l6wSfvFICbixIgVhhIUdfjqElcbBSB1w
w77RFznwuRJfVYlSOIkQ4NjEHcV6KRodWSTkyIZixp15WrgK3qm+b7b6XriLi/tk
hXY3Jf7wf36pF8QUcsSrYERJ9NhY/Y7pcZxQuyhvfqetyXC8f20Ba7QVe/YzrCAb
93VX7DxPuqFeVk5TPxD61rq6SCpkV56feCP0mTjxplunGIIgZOaBy8D0r6posk+K
G+HM9EW7bMgNHtsIRTDbmztSOpmoGW4KQqsvOSMOj6r2NEj4EEPuOLaWZzQ00bMV
V63nvrMyXnZtokojTiz/MZEGqKJhdTFraVvqBAArX4EEoRhvCTSokDvpPs4yCE/m
1u/dObTqADG14sicchvoraQ7kWfJNfhLwvgCFaF64KiILWwZzBsMXW05u4PEOk88
HftjmVxV1R0=
=HyTY
-----END PGP SIGNATURE-----

--=-UZ691iJJwveAoWpc2krh--
