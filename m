Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab0FJTPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:15:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759732Ab0FJTPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc;
        b=u5arixOsGFG0veNGU/YtYhXvr8LadKUcabfEwne2I5cCrtbfFVKrSS7c1VeNTq2Ife
         HcqhnKWuQBPmf+cK5ieMYYDMHUR0G3cL028uFUxF6f3DnOnk5PFFvm6k+Sl6oSCft1j5
         9cRuKTz5KV2sU1+o10taI7E2lZK9mGE+DlEck=
Message-ID: <4c1139ba.0d01df0a.42a6.1368@mx.google.com>
Date: Thu, 10 Jun 2010 22:12:55 +0300
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Subject: [PATCH] Marvell OpenRD-Ultimate machine support
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Alexander Clouter <alex@digriz.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
This patch adds support for the OpenRD Ultimate machine(could be found at http://www.arm.linux.org.uk/developer/machines/list.php?id=2884)

Besides adding machine description this patch adds correction for PHY address for Ultimate version.

Differences from the previous attempt:
 - Correctly filled instances of mv643xx_eth_platform_data in case of ultimate version.
 - Do PCIE initialization for Ultimate version along with Base and Client
 - Init ge01 if (!openrd-base) to make the code cleaner

Regards,

-- Dmytro Milinevskyy

Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
---
 arch/arm/mach-kirkwood/Kconfig        |    7 +++++++
 arch/arm/mach-kirkwood/openrd-setup.c |   27 ++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
index 29b2163..110a3b8 100644
--- a/arch/arm/mach-kirkwood/Kconfig
+++ b/arch/arm/mach-kirkwood/Kconfig
@@ -75,6 +75,13 @@ config MACH_OPENRD_CLIENT
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell OpenRD Client Board.
 
+config MACH_OPENRD_ULTIMATE
+	bool "Marvell OpenRD Ultimate Board"
+	select MACH_OPENRD
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Marvell OpenRD Ultimate Board.
+
 config MACH_NETSPACE_V2
 	bool "LaCie Network Space v2 NAS Board"
 	help
diff --git a/arch/arm/mach-kirkwood/openrd-setup.c b/arch/arm/mach-kirkwood/openrd-setup.c
index ad3f1ec..284b00f 100644
--- a/arch/arm/mach-kirkwood/openrd-setup.c
+++ b/arch/arm/mach-kirkwood/openrd-setup.c
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-kirkwood/openrd-setup.c
  *
- * Marvell OpenRD (Base|Client) Board Setup
+ * Marvell OpenRD (Base|Client|Ultimate) Board Setup
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2.  This program is licensed "as is" without any
@@ -73,9 +73,15 @@ static void __init openrd_init(void)
 
 	kirkwood_ehci_init();
 
+	if (machine_is_openrd_ultimate()) {
+		openrd_ge00_data.phy_addr = MV643XX_ETH_PHY_ADDR(0);
+		openrd_ge01_data.phy_addr = MV643XX_ETH_PHY_ADDR(1);
+	}
+
 	kirkwood_ge00_init(&openrd_ge00_data);
-	if (machine_is_openrd_client())
+	if (!machine_is_openrd_base())
 		kirkwood_ge01_init(&openrd_ge01_data);
+
 	kirkwood_sata_init(&openrd_sata_data);
 	kirkwood_sdio_init(&openrd_mvsdio_data);
 
@@ -84,7 +90,9 @@ static void __init openrd_init(void)
 
 static int __init openrd_pci_init(void)
 {
-	if (machine_is_openrd_base() || machine_is_openrd_client())
+	if (machine_is_openrd_base() ||
+		machine_is_openrd_client() ||
+		machine_is_openrd_ultimate())
 		kirkwood_pcie_init();
 
 	return 0;
@@ -116,3 +124,16 @@ MACHINE_START(OPENRD_CLIENT, "Marvell OpenRD Client Board")
 	.timer		= &kirkwood_timer,
 MACHINE_END
 #endif
+
+#ifdef CONFIG_MACH_OPENRD_ULTIMATE
+MACHINE_START(OPENRD_ULTIMATE, "Marvell OpenRD Ultimate Board")
+	/* Maintainer: Dhaval Vasa <dhaval.vasa@einfochips.com> */
+	.phys_io	= KIRKWOOD_REGS_PHYS_BASE,
+	.io_pg_offst	= ((KIRKWOOD_REGS_VIRT_BASE) >> 18) & 0xfffc,
+	.boot_params	= 0x00000100,
+	.init_machine	= openrd_init,
+	.map_io		= kirkwood_map_io,
+	.init_irq	= kirkwood_init_irq,
+	.timer		= &kirkwood_timer,
+MACHINE_END
+#endif
-- 
1.7.1

