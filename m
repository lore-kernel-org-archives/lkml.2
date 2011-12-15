Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab1LOElD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 23:41:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50199 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1LOElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 23:41:01 -0500
Date: Thu, 15 Dec 2011 15:40:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: build failure after merge of the iommu tree
Message-Id: <20111215154051.e8bb4a174259e910a3045f0e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_15_40_51_+1100_8KAKPi3nGqY19w6_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_15_40_51_+1100_8KAKPi3nGqY19w6_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

After merging the iommu tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/iommu/amd_iommu.c: In function 'pci_iommuv2_capable':
drivers/iommu/amd_iommu.c:179:3: error: 'PCI_PRI_CAP' undeclared (first use=
 in this function)
drivers/iommu/amd_iommu.c:180:3: error: 'PCI_PASID_CAP' undeclared (first u=
se in this function)
drivers/iommu/amd_iommu.c: In function 'pri_reset_while_enabled':
drivers/iommu/amd_iommu.c:1981:38: error: 'PCI_PRI_CAP' undeclared (first u=
se in this function)
drivers/iommu/amd_iommu.c:1981:2: warning: passing argument 2 of 'pci_find_=
ext_capability' makes integer from pointer without a cast [enabled by defau=
lt]
include/linux/pci.h:712:5: note: expected 'int' but argument is of type 'co=
nst int *'
drivers/iommu/amd_iommu.c: In function 'pci_pri_tlp_required':
drivers/iommu/amd_iommu.c:2045:38: error: 'PCI_PRI_CAP' undeclared (first u=
se in this function)
drivers/iommu/amd_iommu.c:2045:2: warning: passing argument 2 of 'pci_find_=
ext_capability' makes integer from pointer without a cast [enabled by defau=
lt]
include/linux/pci.h:712:5: note: expected 'int' but argument is of type 'co=
nst int *'

Caused by commit 56288ab6e949 ("PCI: Fix PRI and PASID consistency") from
the pci tree interacting with various commits from the iommu tree.

I have added the following merge fix patch (and can carry it as
necessary).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 15 Dec 2011 15:35:23 +1100
Subject: [PATCH] iommu: fix for pci identifier changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/iommu/amd_iommu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 32fc99c..b1f155e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -176,8 +176,8 @@ static bool pci_iommuv2_capable(struct pci_dev *pdev)
 {
 	static const int caps[] =3D {
 		PCI_EXT_CAP_ID_ATS,
-		PCI_PRI_CAP,
-		PCI_PASID_CAP,
+		PCI_EXT_CAP_ID_PRI,
+		PCI_EXT_CAP_ID_PASID,
 	};
 	int i, pos;
=20
@@ -1978,7 +1978,7 @@ static int pri_reset_while_enabled(struct pci_dev *pd=
ev)
 	u16 control;
 	int pos;
=20
-	pos =3D pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos =3D pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return -EINVAL;
=20
@@ -2042,7 +2042,7 @@ bool pci_pri_tlp_required(struct pci_dev *pdev)
 	u16 control;
 	int pos;
=20
-	pos =3D pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos =3D pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return false;
=20
--=20
1.7.7.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_15_40_51_+1100_8KAKPi3nGqY19w6_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6XpTAAoJEECxmPOUX5FEXgIP/iMAzmO4ch9Q8QrzfzHldeZ1
Z0v/SILmJ0apSwFt5UDO+NqaMBgOYY/O3B5Mc51fpyTwQZbrHwiUMi6yMVXH3aEm
gIBP44rsRWW4CAd9lBByko/FEkHnEZ9hbPE9qcWy8Tje7u5TLJK2IBOCM6Dq/Uil
Ihy8/b9/lK/pV6zpIAnu+A/jXqOKdocmXUN3+/K0GfXPnSqQOktA4pax49NqkMhU
5MR7feMaMGujbhTOyiearAyuXxEEXMRmvPk6Zs+27NDm45m7JaOveWG0mgBEyvZQ
doMBTRjPyHFBA10fbV+yfPOVR4O4YB3+uErMIEqiIgft/VcDUjOqnxmu3w4xhFKw
2g+iWvV9XMAW+CFwRnsdgnIK/Gwc27Ri5Z0Hs2pNoWmE+55FbXKNZVrkCxJW3e4o
rVWGftFs0ZNAd3b82LazRhkloqYHekGsPPg4RuZSXWRDUfd6SUFZvYdoTPwQ8jbU
6ywVM/7IusFrNr22b5EBWRL59fgGX3owXObNVfoONIhbUwb4i/v0wk08UzecDHw6
j2Xi+mi6DjTNOFbqGZy9695Uvmhn9dtZ4JlPAexPe03LNy18PDp+yzMLKAAaTI6e
uIXAXAucqLs3Mu8RuBBRqYU+TjlrSrQxKZdSF0BmR9kk++qFOPIc8lhvrn2SvMg8
2mmnbFuvXbwFOdTFCcqD
=sdFe
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_15_40_51_+1100_8KAKPi3nGqY19w6_--
