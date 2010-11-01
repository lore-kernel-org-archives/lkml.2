Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0KAPav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:30:51 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:59048 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0KAPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:30:48 -0400
Message-ID: <4CCEDCD7.1000908@web.de>
Date: Mon, 01 Nov 2010 16:29:27 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, kvm <kvm@vger.kernel.org>,
        Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash on kvm_iommu_map_pages
References: <4CCEB7CF.8030207@web.de> <4CCEB946.7070103@web.de> <20101101132127.GF20959@amd.com> <4CCEBFAC.1000809@web.de> <20101101135322.GG20959@amd.com> <4CCECD17.3080303@web.de> <20101101143526.GD2987@8bytes.org>
In-Reply-To: <20101101143526.GD2987@8bytes.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig02FD11B9308E5FAE76F82E84"
X-Provags-ID: V01U2FsdGVkX1+S9OYJM+RAvQedC5Uhq9T6/zpz9mk4IUWGOCco
	C0CZi1SfcjYhayK/dtRo5bk3b1oyBhVLHbueUheriqDpdiBmbs
	T1CFINZDA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig02FD11B9308E5FAE76F82E84
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.11.2010 15:35, Joerg Roedel wrote:
> On Mon, Nov 01, 2010 at 03:22:15PM +0100, Jan Kiszka wrote:
>> Am 01.11.2010 14:53, Roedel, Joerg wrote:
>>> On Mon, Nov 01, 2010 at 09:25:00AM -0400, Jan Kiszka wrote:
>>>> Am 01.11.2010 14:21, Roedel, Joerg wrote:
>>>>> The registers rax and rbx contain non-canonical addresses (if
>>>>> interpreted as pointers). The instruction where this happens is a m=
ov so
>>>>> I guess that the #GP is because of an non-canonical address.
>>>>> Can you find out the code-line where this happens and the exact
>>>>> assembler instruction? (haven't managed to decode the registers use=
d).
>>>>
>>>> In pfn_to_dma_pte, line 710:
>>>>
>>>>                 if (!dma_pte_present(pte)) {
>>>> ffffffff8121de8c:       f6 03 03                testb  $0x3,(%rbx)
>>>> ffffffff8121de8f:       0f 85 d8 00 00 00       jne    ffffffff8121d=
f6d <pfn_to_dma_pte+0x154>
>>>>
>>>> The first instruction raises the fault.
>>>
>>> Ok, so it seems that my understanding of the Code: field in the
>>> crash-message was wrong :)
>>> Anyway, the testb uses rbx as an address which has a non-canonical
>>> value. This means the the address of 'pte' is invalid. Since rax also=

>>> contains a wrong address the 'parent' variable probably already conta=
ins
>>> the wrong address. Does the attached patch help?
>>>
>>> diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapp=
ing.h
>>> index 5619f85..ca46f24 100644
>>> --- a/include/linux/dma_remapping.h
>>> +++ b/include/linux/dma_remapping.h
>>> @@ -6,7 +6,7 @@
>>>   */
>>>  #define VTD_PAGE_SHIFT		(12)
>>>  #define VTD_PAGE_SIZE		(1UL << VTD_PAGE_SHIFT)
>>> -#define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
>>> +#define VTD_PAGE_MASK		((((u64)-1) << VTD_PAGE_SHIFT) & ((1ULL << 52=
) - 1))
>>>  #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAG=
E_MASK)
>>> =20
>>>  #define DMA_PTE_READ (1)
>>>
>>
>> Crashes during early boot while initializing dmar. If you need the
>> trace, I could set up some debug console.
>=20
> Hmm, no. This was only a guess. The VTD_PAGE_MASK does not mask out the=

> bits 52-63 of the pte. According to the VT-d spec it is allowed to set
> these bits, some are marked as AVL and some have special meanings. If a=

> pte has one of these bits set the phys_addr calculated will be wrong an=
d
> the virt_addr calculated from it too (probably non-canonical, leading t=
o
> the GPF).=20
>=20
> Probably masking out these bits in dma_pte_addr helps.=20
>=20

Nope. But I just noticed a fatal thinko in my fix to
intel_iommu_attach_device - probably that was the key. Need to boot the
test kernel...

Jan


--------------enig02FD11B9308E5FAE76F82E84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzO3NsACgkQitSsb3rl5xRwmQCgxnkCeVq6++Jt69HbYlWAodOg
xcEAnRQE47S7lw+985sOaF35bkkEGxPZ
=l7/p
-----END PGP SIGNATURE-----

--------------enig02FD11B9308E5FAE76F82E84--
