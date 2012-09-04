Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2IDB7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 21:59:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60483 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2IDB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 21:59:12 -0400
Date: Tue, 4 Sep 2012 11:59:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuval Mintz <yuvalmin@broadcom.com>, Ariel Elior <ariele@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20120904115900.9df1ae8f3f608975293dc715@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_11_59_00_+1000_L4Ce02nUY153oi=Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_11_59_00_+1000_L4Ce02nUY153oi=Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c between commit
8eee694c3e66 ("bnx2x: fix unload previous driver flow when flr-capable")
from Linus' tree and commit 2a80eebcbf3e ("bnx2x: Use PCI Express
Capability accessors") from the pci tree.

The former removes the function updated by the latter, so I just removed
the function (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2105498,281cf3f..0000000
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@@ -9372,29 -9378,28 +9366,25 @@@ static int __devinit bnx2x_prev_mark_pa
  	return rc;
  }
 =20
 -static bool __devinit bnx2x_can_flr(struct bnx2x *bp)
 -{
 -	u32 cap;
 -	struct pci_dev *dev =3D bp->pdev;
 -
 -	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
 -	if (!(cap & PCI_EXP_DEVCAP_FLR))
 -		return false;
 -
 -	return true;
 -}
 -
  static int __devinit bnx2x_do_flr(struct bnx2x *bp)
  {
- 	int i, pos;
+ 	int i;
  	u16 status;
  	struct pci_dev *dev =3D bp->pdev;
 =20
 -	/* probe the capability first */
 -	if (bnx2x_can_flr(bp))
 -		return -ENOTTY;
 +
 +	if (CHIP_IS_E1x(bp)) {
 +		BNX2X_DEV_INFO("FLR not supported in E1/E1H\n");
 +		return -EINVAL;
 +	}
 +
 +	/* only bootcode REQ_BC_VER_4_INITIATE_FLR and onwards support flr */
 +	if (bp->common.bc_ver < REQ_BC_VER_4_INITIATE_FLR) {
 +		BNX2X_ERR("FLR not supported by BC_VER: 0x%x\n",
 +			  bp->common.bc_ver);
 +		return -EINVAL;
 +	}
 =20
- 	pos =3D pci_pcie_cap(dev);
- 	if (!pos)
- 		return -ENOTTY;
-=20
  	/* Wait for Transaction Pending bit clean */
  	for (i =3D 0; i < 4; i++) {
  		if (i)

--Signature=_Tue__4_Sep_2012_11_59_00_+1000_L4Ce02nUY153oi=Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRWBkAAoJEECxmPOUX5FEQIYQAJSKfYLkzr7IliacfPg7TYOx
amYUeMXu3qdtuOaYdHK+J/jIzdNW/ItcV8dHUFGdRFnGtcauVLvbVG0MqWSr0NrX
pQdSoFQu4NCVqFbFnda5oLsmOg0hTgzYPR9C3p4vR5A6HyuoC9jO4GnKG4QNdHKA
E/FPMxpwkgf0vM+IxqTUz6ZdrAbU++mijVElvBxyRqusJ4vVEmAb9lYvQ4BI5i9b
yip6JZT+1J/e6VWKXVZ4r4ObUBmoQuGbmEcDFPduYbnNUYimnDCoXzj8ai6ijNOp
yJB3SGnamyp1LDaa/j9TRP9rNXq1hDwiE6v0j5WTGuY9/SwsjJuVcO694FKxHkP2
ZCF9rXnQi91G+xrVurDZ4Q16a587rOoHpmRQFGi2BFsLF3uRJzBI2QhWO8ApVhSg
e1sgJaVdju3b0xAtoI4CbLfzbBh6QI8eCyDjmVVxGrz3d/Dma83kUzrtzJgX3Wa1
3scMWJawF9GY2BeDly4QPG0xECy1v0wMNJvsXxghMcDAeU4EDKJ1SxJhp94criyr
AP8plCu3A63YkIQE03ulOd3Ds1S0+ugDy1Ttskk4Te27gHg0AbPwXh+TsoW+b6rz
ue9RxGhWXjrWdAku3T47UQ2Q00GrlsvyGP5WFDusAtE5ejejKT0XMJFKpDS4VNiz
iWDpOwV8xpw5tG5LM7n0
=9tr3
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_11_59_00_+1000_L4Ce02nUY153oi=Z--
