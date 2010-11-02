Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0KBHqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:46:22 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:56001 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0KBHqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:46:14 -0400
Message-ID: <4CCFC1C3.4070807@web.de>
Date: Tue, 02 Nov 2010 08:46:11 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] intel-iommu: Fix use after release during device attach
References: <4CCFB84F.6050102@web.de> <201011021531.22886.sheng@linux.intel.com>
In-Reply-To: <201011021531.22886.sheng@linux.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7F4A4AF728D72190404B831F"
X-Provags-ID: V01U2FsdGVkX1/tZWi1KOmEQRfv5fxWmuUfd0fw/DyzCfEE7BaL
	YpubK/MtDqDlDoRoE2AWm3xqNL9rQM9582XpJ26LyZfxrnnxDm
	svXJSKYkM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7F4A4AF728D72190404B831F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.11.2010 08:31, Sheng Yang wrote:
> On Tuesday 02 November 2010 15:05:51 Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> Obtail the new pgd pointer before releasing the page containing this
>> value.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>
>> Who is taking care of this? The kvm tree?
>>
>>  drivers/pci/intel-iommu.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>> index 4789f8e..35463dd 100644
>> --- a/drivers/pci/intel-iommu.c
>> +++ b/drivers/pci/intel-iommu.c
>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
>> iommu_domain *domain,
>>
>>  		pte =3D dmar_domain->pgd;
>>  		if (dma_pte_present(pte)) {
>> -			free_pgtable_page(dmar_domain->pgd);
>>  			dmar_domain->pgd =3D (struct dma_pte *)
>>  				phys_to_virt(dma_pte_addr(pte));
>> +			free_pgtable_page(pte);
>>  		}
>>  		dmar_domain->agaw--;
>>  	}
>=20
> Reviewed-by: Sheng Yang <sheng@linux.intel.com>
>=20
> CC iommu mailing list and David.
>=20
> OK, Jan, I got your meaning now. And it's not the exactly swap. :)
>=20
> I think the old code is safe, seems it's broken(exposed) by:=20
>=20
> commit 1a8bd481bfba30515b54368d90a915db3faf302f
> Author: David Woodhouse <David.Woodhouse@intel.com>
> Date:   Tue Aug 10 01:38:53 2010 +0100
>=20
>     intel-iommu: Fix 32-bit build warning with __cmpxchg()
>    =20
>     drivers/pci/intel-iommu.c: In function 'dma_pte_addr':
>     drivers/pci/intel-iommu.c:239: warning: passing argument 1 of '__cm=
pxchg64'=20
> from incompatible pointer typ
>    =20
>     It seems that __cmpxchg64() now cares about the type of its pointer=
 argument,
>     so give it a (uint64_t *) instead of a pointer to a structure which=
 contains
>     only that.
>    =20
>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>=20
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index c9171be..603cdc0 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -236,7 +236,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)=

>         return pte->val & VTD_PAGE_MASK;
>  #else
>         /* Must have a full atomic 64-bit read */
> -       return  __cmpxchg64(pte, 0ULL, 0ULL) & VTD_PAGE_MASK;
> +       return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
>  #endif
>  }
>=20
> Seems here is the only affected code?

CONFIG_64BIT is on here, so this change did not make a difference for me.=


Jan


--------------enig7F4A4AF728D72190404B831F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzPwcMACgkQitSsb3rl5xRZPACg1F/I2qbIMWFNmTSurth+pe2Y
NnwAn2VWE1UaS/vBY3tDLyX8d5ivLYUr
=uy48
-----END PGP SIGNATURE-----

--------------enig7F4A4AF728D72190404B831F--
