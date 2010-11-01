Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0KAOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:22:30 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:58541 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab0KAOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:22:27 -0400
Message-ID: <4CCECD17.3080303@web.de>
Date: Mon, 01 Nov 2010 15:22:15 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: kvm <kvm@vger.kernel.org>, Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash on kvm_iommu_map_pages
References: <4CCEB7CF.8030207@web.de> <4CCEB946.7070103@web.de> <20101101132127.GF20959@amd.com> <4CCEBFAC.1000809@web.de> <20101101135322.GG20959@amd.com>
In-Reply-To: <20101101135322.GG20959@amd.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA73B27D803A202FCBEB11C8D"
X-Provags-ID: V01U2FsdGVkX18cCsKuj7FeaEzq5uuV4NgkjkJa4gQgENlDTERp
	MFUO5SBut7Bf4+vAumpx2AmbE7rwcCyjWr7AIDahdibh0Z46rx
	irH8R8v6M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA73B27D803A202FCBEB11C8D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.11.2010 14:53, Roedel, Joerg wrote:
> On Mon, Nov 01, 2010 at 09:25:00AM -0400, Jan Kiszka wrote:
>> Am 01.11.2010 14:21, Roedel, Joerg wrote:
>>> The registers rax and rbx contain non-canonical addresses (if
>>> interpreted as pointers). The instruction where this happens is a mov=
 so
>>> I guess that the #GP is because of an non-canonical address.
>>> Can you find out the code-line where this happens and the exact
>>> assembler instruction? (haven't managed to decode the registers used)=
=2E
>>
>> In pfn_to_dma_pte, line 710:
>>
>>                 if (!dma_pte_present(pte)) {
>> ffffffff8121de8c:       f6 03 03                testb  $0x3,(%rbx)
>> ffffffff8121de8f:       0f 85 d8 00 00 00       jne    ffffffff8121df6=
d <pfn_to_dma_pte+0x154>
>>
>> The first instruction raises the fault.
>=20
> Ok, so it seems that my understanding of the Code: field in the
> crash-message was wrong :)
> Anyway, the testb uses rbx as an address which has a non-canonical
> value. This means the the address of 'pte' is invalid. Since rax also
> contains a wrong address the 'parent' variable probably already contain=
s
> the wrong address. Does the attached patch help?
>=20
> diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remappin=
g.h
> index 5619f85..ca46f24 100644
> --- a/include/linux/dma_remapping.h
> +++ b/include/linux/dma_remapping.h
> @@ -6,7 +6,7 @@
>   */
>  #define VTD_PAGE_SHIFT		(12)
>  #define VTD_PAGE_SIZE		(1UL << VTD_PAGE_SHIFT)
> -#define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
> +#define VTD_PAGE_MASK		((((u64)-1) << VTD_PAGE_SHIFT) & ((1ULL << 52) =
- 1))
>  #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAGE_=
MASK)
> =20
>  #define DMA_PTE_READ (1)
>=20

Crashes during early boot while initializing dmar. If you need the
trace, I could set up some debug console.

Jan


--------------enigA73B27D803A202FCBEB11C8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzOzRsACgkQitSsb3rl5xRbYQCglxRFVl6Tf0z78gyJBPyC78eX
EfcAnjfOFvXVgRfWHjvqus/spVXoFANk
=sHp9
-----END PGP SIGNATURE-----

--------------enigA73B27D803A202FCBEB11C8D--
