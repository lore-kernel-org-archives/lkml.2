Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0KALl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 07:41:27 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:43386 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab0KALlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 07:41:23 -0400
Message-ID: <4CCEA761.90501@web.de>
Date: Mon, 01 Nov 2010 12:41:21 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Crash in intel_iommu_assign_device
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig23DDEB05B3DB580A79978CFC"
X-Provags-ID: V01U2FsdGVkX1+CRO6qI12NOiORYXyiaJf8rDEdZjgWzvC8AWYf
	2iD00wOe5iG2vuA09DJ1t/Dod5XoLsuPfiY0GSswJbC0G6mX96
	uJ/GKfw8M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig23DDEB05B3DB580A79978CFC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Sheng,

I'm not claiming to understand the details, but this looks like use
(dereference of pte via dma_pte_addr) after release (free_pgtable_page
of dmar_domain->pgd aka pte) to me:

static int intel_iommu_attach_device(struct iommu_domain *domain,
				     struct device *dev)
{
	[...]
		pte =3D dmar_domain->pgd;
		if (dma_pte_present(pte)) {
			free_pgtable_page(dmar_domain->pgd);
			dmar_domain->pgd =3D (struct dma_pte *)
				phys_to_virt(dma_pte_addr(pte));
		}

At least it crashes here right on pte->val access. Swap both lines?

Jan


--------------enig23DDEB05B3DB580A79978CFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzOp2EACgkQitSsb3rl5xSdOwCgsIx3Az50hzochjariFjdie6T
G1MAni4HlDU3pf3/fB+4yC0BvPKOpxti
=aCuo
-----END PGP SIGNATURE-----

--------------enig23DDEB05B3DB580A79978CFC--
