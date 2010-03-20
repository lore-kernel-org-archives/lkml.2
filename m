Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0CTXBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 19:01:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508Ab0CTXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 19:01:48 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yolqC06826W4xry0le3s"
Date: Sat, 20 Mar 2010 23:01:37 +0000
Message-ID: <1269126097.18314.111.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/4] pci/dmar: Combine the BIOS DMAR table warning messages
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yolqC06826W4xry0le3s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We have nearly the same code for warnings repeated four times.  Move
it into a separate function.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/dmar.c |   48 ++++++++++++++----------------------------------
 1 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index ffe22bc..f101057 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -613,7 +613,15 @@ int __init dmar_table_init(void)
 	return 0;
 }
=20
-static int bios_warned;
+static void warn_invalid_dmar(u64 addr, const char *message)
+{
+	WARN_ONCE(1, "Your BIOS is broken; DMAR reported at address %llx%s!\n"
+		  "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+		  addr, message,
+		  dmi_get_system_info(DMI_BIOS_VENDOR),
+		  dmi_get_system_info(DMI_BIOS_VERSION),
+		  dmi_get_system_info(DMI_PRODUCT_VERSION));
+}
=20
 int __init check_zero_address(void)
 {
@@ -639,13 +647,7 @@ int __init check_zero_address(void)
=20
 			drhd =3D (void *)entry_header;
 			if (!drhd->address) {
-				/* Promote an attitude of violence to a BIOS engineer today */
-				WARN(1, "Your BIOS is broken; DMAR reported at address zero!\n"
-				     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-				     dmi_get_system_info(DMI_BIOS_VENDOR),
-				     dmi_get_system_info(DMI_BIOS_VERSION),
-				     dmi_get_system_info(DMI_PRODUCT_VERSION));
-				bios_warned =3D 1;
+				warn_invalid_dmar(0, "");
 				goto failed;
 			}
=20
@@ -658,14 +660,8 @@ int __init check_zero_address(void)
 			ecap =3D dmar_readq(addr + DMAR_ECAP_REG);
 			early_iounmap(addr, VTD_PAGE_SIZE);
 			if (cap =3D=3D (uint64_t)-1 && ecap =3D=3D (uint64_t)-1) {
-				/* Promote an attitude of violence to a BIOS engineer today */
-				WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns al=
l ones!\n"
-				     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-				      drhd->address,
-				      dmi_get_system_info(DMI_BIOS_VENDOR),
-				      dmi_get_system_info(DMI_BIOS_VERSION),
-				      dmi_get_system_info(DMI_PRODUCT_VERSION));
-				bios_warned =3D 1;
+				warn_invalid_dmar(drhd->address,
+						  " returns all ones");
 				goto failed;
 			}
 		}
@@ -730,14 +726,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	int msagaw =3D 0;
=20
 	if (!drhd->reg_base_addr) {
-		if (!bios_warned) {
-			WARN(1, "Your BIOS is broken; DMAR reported at address zero!\n"
-			     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-			     dmi_get_system_info(DMI_BIOS_VENDOR),
-			     dmi_get_system_info(DMI_BIOS_VERSION),
-			     dmi_get_system_info(DMI_PRODUCT_VERSION));
-			bios_warned =3D 1;
-		}
+		warn_invalid_dmar(0, "");
 		return -EINVAL;
 	}
=20
@@ -757,16 +746,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	iommu->ecap =3D dmar_readq(iommu->reg + DMAR_ECAP_REG);
=20
 	if (iommu->cap =3D=3D (uint64_t)-1 && iommu->ecap =3D=3D (uint64_t)-1) {
-		if (!bios_warned) {
-			/* Promote an attitude of violence to a BIOS engineer today */
-			WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all=
 ones!\n"
-			     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-			     drhd->reg_base_addr,
-			     dmi_get_system_info(DMI_BIOS_VENDOR),
-			     dmi_get_system_info(DMI_BIOS_VERSION),
-			     dmi_get_system_info(DMI_PRODUCT_VERSION));
-			bios_warned =3D 1;
-		}
+		warn_invalid_dmar(drhd->reg_base_addr, " returns all ones");
 		goto err_unmap;
 	}
=20
--=20
1.7.0




--=-yolqC06826W4xry0le3s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6VTx+e/yOyVhhEJAQKuchAAhaJ3LErJuyHoBKsgU2l+V5FKCNuMFiX1
zsoe2UHXhELxQ1KAyGKo6ePyyB9E/o31AWsu8SZgktXfYR07hii2zhrVvhU0D7iQ
7JiMv3YL/HJy3LrAPGaYGlFDg1zn9+JNvGW2uIM+0jNZS2yaM928r7EnIGorLBl2
OP5Z8kZbicVS5Jm5L1ykHkMq25/wJQLys/Pjh/nlq4oLk6Kp4v4lLrdAd2K56yIY
XeltO6qvGZSnN9UGhONBfmC8sm+ApLKbWxvP9K+w4QQ91ks0aHhSnqrrUwdPAGRC
8lq+dPsGm5hTqZ23N/zxCc6QLtCbPlMdQHVBUTyRvDO2lysbQgDX4dwhPE5Je/43
WTxYRI2OYQSUbHsldFCrULh+VLcxKpE7kX+YmUz7rQgm1v8CqrSax3AXoHJJLGDL
T6QROUvj75MTXwg9S81Rane0Z7PZhSPZBgEUjo54LNsZLVnSzdvcf679QKhezTHH
I60TCdEtq6QcZlOquaCC/sso3cpsD/8AQWFJ59nJ+qo/4yt0z5DOM6lx1oi1frvs
9Q+vB/ZpMlgJFhlamPK4H5BvsoS04BffQk7bE1aOjOsI3StuJXYtwe9gSJWqE5he
Jz90eK5JERivMt0wpY8CLoYE16QzrkhDKHjH4ZFuOmgFQw5MhY0/A/stzyNDEN9m
889KBYNGmF8=
=kIi4
-----END PGP SIGNATURE-----

--=-yolqC06826W4xry0le3s--
