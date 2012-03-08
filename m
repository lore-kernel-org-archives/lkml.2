Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2CHEob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:44:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59427 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2CHEnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:43:46 -0500
Date: Thu, 8 Mar 2012 15:43:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] powerpc: clean up vio.c
Message-Id: <20120308154310.6d7b1741d2821619b835af81@canb.auug.org.au>
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_15_43_10_+1100_GF_AcIWe4vnDakNb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_15_43_10_+1100_GF_AcIWe4vnDakNb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This cleans up vio.c after the removal of the legacy iSeries platform.
It also removes some no longer referenced include files.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/iseries/hv_call_event.h |  201 ----------------
 arch/powerpc/include/asm/iseries/hv_lp_event.h   |  162 -------------
 arch/powerpc/include/asm/iseries/iommu.h         |   37 ---
 arch/powerpc/include/asm/iseries/vio.h           |  265 ------------------=
----
 arch/powerpc/kernel/vio.c                        |   18 +--
 5 files changed, 1 insertions(+), 682 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call_event.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_lp_event.h
 delete mode 100644 arch/powerpc/include/asm/iseries/iommu.h
 delete mode 100644 arch/powerpc/include/asm/iseries/vio.h

diff --git a/arch/powerpc/include/asm/iseries/hv_call_event.h b/arch/powerp=
c/include/asm/iseries/hv_call_event.h
deleted file mode 100644
index cc029d3..0000000
diff --git a/arch/powerpc/include/asm/iseries/hv_lp_event.h b/arch/powerpc/=
include/asm/iseries/hv_lp_event.h
deleted file mode 100644
index 8f5da7d..0000000
diff --git a/arch/powerpc/include/asm/iseries/iommu.h b/arch/powerpc/includ=
e/asm/iseries/iommu.h
deleted file mode 100644
index 1b9692c..0000000
diff --git a/arch/powerpc/include/asm/iseries/vio.h b/arch/powerpc/include/=
asm/iseries/vio.h
deleted file mode 100644
index f9ac0d0..0000000
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 8b08629..bca3fc4 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -34,11 +34,6 @@
 #include <asm/abs_addr.h>
 #include <asm/page.h>
 #include <asm/hvcall.h>
-#include <asm/iseries/vio.h>
-#include <asm/iseries/hv_types.h>
-#include <asm/iseries/hv_lp_config.h>
-#include <asm/iseries/hv_call_xm.h>
-#include <asm/iseries/iommu.h>
=20
 static struct bus_type vio_bus_type;
=20
@@ -1042,7 +1037,6 @@ static void vio_cmo_sysfs_init(void)
 	vio_bus_type.bus_attrs =3D vio_cmo_bus_attrs;
 }
 #else /* CONFIG_PPC_SMLPAR */
-/* Dummy functions for iSeries platform */
 int vio_cmo_entitlement_update(size_t new_entitlement) { return 0; }
 void vio_cmo_set_dev_desired(struct vio_dev *viodev, size_t desired) {}
 static int vio_cmo_bus_probe(struct vio_dev *viodev) { return 0; }
@@ -1060,9 +1054,6 @@ static struct iommu_table *vio_build_iommu_table(stru=
ct vio_dev *dev)
 	struct iommu_table *tbl;
 	unsigned long offset, size;
=20
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return vio_build_iommu_table_iseries(dev);
-
 	dma_window =3D of_get_property(dev->dev.of_node,
 				  "ibm,my-dma-window", NULL);
 	if (!dma_window)
@@ -1195,8 +1186,7 @@ static void __devinit vio_dev_release(struct device *=
dev)
 {
 	struct iommu_table *tbl =3D get_iommu_table_base(dev);
=20
-	/* iSeries uses a common table for all vio devices */
-	if (!firmware_has_feature(FW_FEATURE_ISERIES) && tbl)
+	if (tbl)
 		iommu_free_table(tbl, dev->of_node ?
 			dev->of_node->full_name : dev_name(dev));
 	of_node_put(dev->of_node);
@@ -1244,12 +1234,6 @@ struct vio_dev *vio_register_device_node(struct devi=
ce_node *of_node)
 	viodev->name =3D of_node->name;
 	viodev->type =3D of_node->type;
 	viodev->unit_address =3D *unit_address;
-	if (firmware_has_feature(FW_FEATURE_ISERIES)) {
-		unit_address =3D of_get_property(of_node,
-				"linux,unit_address", NULL);
-		if (unit_address !=3D NULL)
-			viodev->unit_address =3D *unit_address;
-	}
 	viodev->dev.of_node =3D of_node_get(of_node);
=20
 	if (firmware_has_feature(FW_FEATURE_CMO))
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_15_43_10_+1100_GF_AcIWe4vnDakNb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWDjeAAoJEECxmPOUX5FEgKsP/33FZJyaCMMaaf0DkmB7dqvq
mmuH+R5KVd9JmEjY9jaRiGd0RS3cLzL215XYRiK+n9GCHZnNDejpzxuEUk2EbpKL
jqybPFPAdCpXFIwuJzBgOKcEHth1LFE5bo/UPBLMzleKikgZTo1Eb48rZhUp4+Yy
A3eQzZG8T9ICwTrU66dB3e2JeO70ve69dsmjAXL7cuHkcmg8AJaz7xTM104adGsQ
+tJFQZInsWahCvZ2us+0mxGZVlcXvPFOxbsrtE8LdfvNo803SKYlGdiMQ3Lsb927
XS1lFGu0i9MJ/JjeixbOlEsxiBxM+6SChfFBzjyxUVC6CIxftcqW000I8/sxEeCo
zpPZ1+AyJhtr6ta56IJpguDqiZ4tmAOOz3t6AV3gNfU+NygOsb9DhfRbi5eX2X47
CyLmZl0SfBhcytJSfIQ6WXf+yk65UaZDQzoyn/VeFvGE7hswRhWk7JuhNN8Sj0XJ
erouEY+/aT+NxTcmHAZKwN9+6odVPbjV0sFwT456l7TU9JUpoBkWPgguzY9JXnpU
Kn/11GawJtZtjMpIG9LBOYXdzL87VhEbMBS5sMTyN14k22ul+ThhRskPN4pTb3Mq
/FBY4O/6ZtjOIBMNejW/EGgCf10mNVylZ5bqXOv7UJbG+94D46PaVVftP+nTQhwq
UcLWBbd7jucQGeT2poX7
=4YRW
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_15_43_10_+1100_GF_AcIWe4vnDakNb--
