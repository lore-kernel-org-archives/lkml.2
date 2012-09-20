Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2ITGch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:32:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39300 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2ITGcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:32:36 -0400
Date: Thu, 20 Sep 2012 16:32:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IktyenlzenRvZiBIYcWCYXNhIg==?= <khc@pm.waw.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the ixp4xx tree with the arm-soc tree
Message-Id: <20120920163227.c6d8f1559b9cde971a376abf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Sep_2012_16_32_27_+1000_9hTQdOshvu/RPS_w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Sep_2012_16_32_27_+1000_9hTQdOshvu/RPS_w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

Today's linux-next merge of the ixp4xx tree got conflicts in
arch/arm/mach-ixp4xx/common.c and
arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h between commit
13ec32f47cb4 ("ARM: ixp4xx: use __iomem pointers for MMIO") from the
arm-soc tree and commits 43690ab7543a ("IXP4xx: Always ioremap() Queue
Manager MMIO region at boot") and f62736b567ff ("IXP4xx: map CPU config
registers within VMALLOC region") from the ixp4xx tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ixp4xx/common.c
index fdf91a1,8f75b25..0000000
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@@ -67,15 -67,12 +67,12 @@@ static struct map_desc ixp4xx_io_desc[
  		.pfn		=3D __phys_to_pfn(IXP4XX_PCI_CFG_BASE_PHYS),
  		.length		=3D IXP4XX_PCI_CFG_REGION_SIZE,
  		.type		=3D MT_DEVICE
- 	},
- #ifdef CONFIG_DEBUG_LL
- 	{	/* Debug UART mapping */
- 		.virtual	=3D (unsigned long)IXP4XX_DEBUG_UART_BASE_VIRT,
- 		.pfn		=3D __phys_to_pfn(IXP4XX_DEBUG_UART_BASE_PHYS),
- 		.length		=3D IXP4XX_DEBUG_UART_REGION_SIZE,
+ 	}, {	/* Queue Manager */
 -		.virtual	=3D IXP4XX_QMGR_BASE_VIRT,
++		.virtual	=3D (unsigned long)IXP4XX_QMGR_BASE_VIRT,
+ 		.pfn		=3D __phys_to_pfn(IXP4XX_QMGR_BASE_PHYS),
+ 		.length		=3D IXP4XX_QMGR_REGION_SIZE,
  		.type		=3D MT_DEVICE
- 	}
- #endif
+ 	},
  };
 =20
  void __init ixp4xx_map_io(void)
diff --cc arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
index eb68b61,d7f6032..0000000
--- a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
+++ b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
@@@ -42,39 -42,31 +42,31 @@@
  /*
   * Queue Manager
   */
- #define IXP4XX_QMGR_BASE_PHYS		(0x60000000)
- #define IXP4XX_QMGR_REGION_SIZE		(0x00004000)
+ #define IXP4XX_QMGR_BASE_PHYS		0x60000000
 -#define IXP4XX_QMGR_BASE_VIRT		0xFEF15000
++#define IXP4XX_QMGR_BASE_VIRT		IOMEM(0xFEF15000)
+ #define IXP4XX_QMGR_REGION_SIZE		0x00004000
 =20
  /*
-  * Expansion BUS Configuration registers
+  * Peripheral space, including debug UART. Must be section-aligned so that
+  * it can be used with the low-level debug code.
   */
- #define IXP4XX_EXP_CFG_BASE_PHYS	(0xC4000000)
- #define IXP4XX_EXP_CFG_BASE_VIRT	IOMEM(0xFFBFE000)
- #define IXP4XX_EXP_CFG_REGION_SIZE	(0x00001000)
+ #define IXP4XX_PERIPHERAL_BASE_PHYS	0xC8000000
 -#define IXP4XX_PERIPHERAL_BASE_VIRT	0xFEF00000
++#define IXP4XX_PERIPHERAL_BASE_VIRT	IOMEM(0xFEF00000)
+ #define IXP4XX_PERIPHERAL_REGION_SIZE	0x00013000
 =20
  /*
   * PCI Config registers
   */
- #define IXP4XX_PCI_CFG_BASE_PHYS	(0xC0000000)
- #define	IXP4XX_PCI_CFG_BASE_VIRT	IOMEM(0xFFBFF000)
- #define IXP4XX_PCI_CFG_REGION_SIZE	(0x00001000)
-=20
- /*
-  * Peripheral space
-  */
- #define IXP4XX_PERIPHERAL_BASE_PHYS	(0xC8000000)
- #define IXP4XX_PERIPHERAL_BASE_VIRT	IOMEM(0xFFBEB000)
- #define IXP4XX_PERIPHERAL_REGION_SIZE	(0x00013000)
+ #define IXP4XX_PCI_CFG_BASE_PHYS	0xC0000000
 -#define IXP4XX_PCI_CFG_BASE_VIRT	0xFEF13000
++#define IXP4XX_PCI_CFG_BASE_VIRT	IOMEM(0xFEF13000)
+ #define IXP4XX_PCI_CFG_REGION_SIZE	0x00001000
 =20
  /*
-  * Debug UART
-  *
-  * This is basically a remap of UART1 into a region that is section
-  * aligned so that it * can be used with the low-level debug code.
+  * Expansion BUS Configuration registers
   */
- #define	IXP4XX_DEBUG_UART_BASE_PHYS	(0xC8000000)
- #define	IXP4XX_DEBUG_UART_BASE_VIRT	IOMEM(0xffb00000)
- #define	IXP4XX_DEBUG_UART_REGION_SIZE	(0x00001000)
+ #define IXP4XX_EXP_CFG_BASE_PHYS	0xC4000000
 -#define IXP4XX_EXP_CFG_BASE_VIRT	0xFEF14000
++#define IXP4XX_EXP_CFG_BASE_VIRT	IOMEM(0xFEF14000)
+ #define IXP4XX_EXP_CFG_REGION_SIZE	0x00001000
 =20
  #define IXP4XX_EXP_CS0_OFFSET	0x00
  #define IXP4XX_EXP_CS1_OFFSET   0x04

--Signature=_Thu__20_Sep_2012_16_32_27_+1000_9hTQdOshvu/RPS_w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWrh7AAoJEECxmPOUX5FEV+oP/RBgEw+w+fwCXYza0lqlHo4W
2IHDjxgFChSFhJ+in9YfZ/p6FUdiPAn//ATEbqubHmNnaL5o4kLZ1VMvkXcI+47S
apZm21A28hPvSEVzCdWQCSk6R06H549Uefw5qG8EhZrpd7vw7DGAjc1jxcvAyDpy
bXnnab6UB63enHLGBo4ahDaQSWHsOjWPN2hLKeVFH1Sab+OWAfinnZW53O0KLFVc
9e3IN62NItkQnM2+rKmRpWDyyzjE+uZA75zTUQkEBzJ91ej/oMc60SBMd0R7ekg/
vXQZMD9S74hx79UbLEqoqdTPRCs3cU00L7HPqdyglL2CdbNyLtx69y8w6SZ51iD8
mYKyX8upKIQAkKBlfH/xRL2vfBrI9oPYYiLDBUiwpdhHtP9zpUR0asTwtN2wVo4A
2B/ea5iXeoy1+XZlvFkjXZbY4SgzaULkxHuEr++9Iv5XUEQCI/4Mp7SOORdr95r2
S2MLbD6jmCUl+r21PbtZ2gVYl2Rjh+XTw87X00Ajg48hQl78QeJTXZ34+mTRqCeW
poPKSEVtOCCBbh+Q78y8mfpKtulyohOHFbxNF1TXENENS+YNoeE8ZL9kuajfXtHa
9XBvKq0FPMMCYWbL1b6bB5tkKYRvcNtXnDGbeHoDRI+61j5Fny3ZDi0la7LEtOno
uwI+b7jbVxNrRuYSkQU9
=dN/9
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Sep_2012_16_32_27_+1000_9hTQdOshvu/RPS_w--
