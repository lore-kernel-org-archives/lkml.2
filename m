Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0FHTuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:50:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33273 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0FHTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc;
        b=QkWPsTolCR4O+HelYCPtvmAveg0BIN3e5UM933UqmqcD1DcqA8hgf2PI5OxPxfbemZ
         xe4rkD0Sz9C3HtK8uiZora6zCHC/3gj+dFuND7PmxbQkY+7sb6AqGff8Eoj/G6f7MUFY
         xuUaBD4Map0r0E0HQNwhIegxiKLNxL0/aKQbk=
Message-ID: <4c0e9ee6.8704df0a.2e71.ffffdf65@mx.google.com>
Date: Tue, 08 Jun 2010 22:47:47 +0300
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
 - Applied suggestion from Lennert Buytenhek to change PHY addresses in instances of mv643xx_eth_platform_data in case of ultimate version.

Regards,

-- Dmytro Milinevskyy

Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
---
 arch/arm/mach-kirkwood/Kconfig        |    7 ++++++
 arch/arm/mach-kirkwood/openrd-setup.c |   34 +++++++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

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
index ad3f1ec..5d6797a 100644
--- a/arch/arm/mach-kirkwood/openrd-setup.c
+++ b/arch/arm/mach-kirkwood/openrd-setup.c
@@ -47,6 +47,14 @@ static struct mv643xx_eth_platform_data openrd_ge01_data = {
 	.phy_addr	= MV643XX_ETH_PHY_ADDR(24),
 };
 
+static struct mv643xx_eth_platform_data openrd_ultimate_ge00_data = {
+	.phy_addr	= MV643XX_ETH_PHY_ADDR(0),
+};
+
+static struct mv643xx_eth_platform_data openrd_ultimate_ge01_data = {
+	.phy_addr	= MV643XX_ETH_PHY_ADDR(1),
+};
+
 static struct mv_sata_platform_data openrd_sata_data = {
 	.n_ports	= 2,
 };
@@ -73,9 +81,14 @@ static void __init openrd_init(void)
 
 	kirkwood_ehci_init();
 
-	kirkwood_ge00_init(&openrd_ge00_data);
-	if (machine_is_openrd_client())
-		kirkwood_ge01_init(&openrd_ge01_data);
+	if (machine_is_openrd_ultimate()) {
+		kirkwood_ge00_init(&openrd_ultimate_ge00_data);
+		kirkwood_ge01_init(&openrd_ultimate_ge01_data);
+	} else {
+		kirkwood_ge00_init(&openrd_ge00_data);
+		if (machine_is_openrd_client())
+			kirkwood_ge01_init(&openrd_ge01_data);
+	}
 	kirkwood_sata_init(&openrd_sata_data);
 	kirkwood_sdio_init(&openrd_mvsdio_data);
 
@@ -84,7 +97,7 @@ static void __init openrd_init(void)
 
 static int __init openrd_pci_init(void)
 {
-	if (machine_is_openrd_base() || machine_is_openrd_client())
+	if (machine_is_openrd_base() || machine_is_openrd_client() || machine_is_openrd_ultimate())
 		kirkwood_pcie_init();
 
 	return 0;
@@ -116,3 +129,16 @@ MACHINE_START(OPENRD_CLIENT, "Marvell OpenRD Client Board")
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

