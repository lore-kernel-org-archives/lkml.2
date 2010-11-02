Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab0KBHHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:07:16 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:58492 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0KBHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:07:11 -0400
Message-ID: <4CCFB898.5030200@web.de>
Date: Tue, 02 Nov 2010 08:07:04 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash in intel_iommu_assign_device
References: <4CCEA761.90501@web.de> <201011021452.19525.sheng@linux.intel.com>
In-Reply-To: <201011021452.19525.sheng@linux.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF196ADE705D8A99002D34CF6"
X-Provags-ID: V01U2FsdGVkX1/cKiav6EM7zf/TILMzNDM1Db2Cs3eXCV7vayju
	qu+z0PXX3TRB6zWc8zfX12RT7cJZnAk/8Eh63opyTMoW0KpV49
	1B8AQuxco=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF196ADE705D8A99002D34CF6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.11.2010 07:52, Sheng Yang wrote:
> On Monday 01 November 2010 19:41:21 Jan Kiszka wrote:
>> Hi Sheng,
>>
>> I'm not claiming to understand the details, but this looks like use
>> (dereference of pte via dma_pte_addr) after release (free_pgtable_page=

>> of dmar_domain->pgd aka pte) to me:
>>
>> static int intel_iommu_attach_device(struct iommu_domain *domain,
>> 				     struct device *dev)
>> {
>> 	[...]
>> 		pte =3D dmar_domain->pgd;
>> 		if (dma_pte_present(pte)) {
>> 			free_pgtable_page(dmar_domain->pgd);
>> 			dmar_domain->pgd =3D (struct dma_pte *)
>> 				phys_to_virt(dma_pte_addr(pte));
>> 		}
>>
>> At least it crashes here right on pte->val access. Swap both lines?
>=20
> I think code is right.
>=20
> The comment above indicate the case: the code want to decrease the leve=
l of page=20
> table. Mostly it is a 4 level page table, and the code would turn it in=
to 3 levels=20
> pagetable. What the code did is just get the first entry of the old pag=
etable level=20
> 4, then free the level 4 pagetable's page, and make the pagetable to a =
level 3=20
> pagetable.
>=20
> Seems it make no sense to swap the lines...

It fixes the crash here, and I'm convinced the current code is wrong.
See the patch I've just sent out.

Jan


--------------enigF196ADE705D8A99002D34CF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzPuJ0ACgkQitSsb3rl5xTqnQCfVybg1Tgb+t9SF1xvTWkffmV+
O9EAoO77a2s94wuaYzEhfawIpsGm3e9R
=YaYo
-----END PGP SIGNATURE-----

--------------enigF196ADE705D8A99002D34CF6--
