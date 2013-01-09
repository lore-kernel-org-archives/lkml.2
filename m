Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab3AIUrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:47:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934191Ab3AIUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:34 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 13/14] ARM: tegra: harmony: Initialize PCIe from DT
Date: Wed,  9 Jan 2013 21:43:13 +0100
Message-Id: <1357764194-12677-14-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:qcg+gQHLpcz4qvXrZFuMYwXmWEPCtKlIcQfZ71vOXd3
 8ZfLDfhG8J5jlLk3ue/iEEGhydDJIBymf/TcRUfNlGqiMvh3OU
 81AuoxPjrN7zvyqXpyVkjTJf3ysjRD3aBSZBor9ZL84/oj0qaM
 8V62lrKlTeRlw4hRA34HEX07t1eYLVYsmSr4WQHOuAK5LsL9WM
 NWyP3IcXvu20e2s6S2jQLDxIuueOI45GUEaaJgnxpnIN/ONg4F
 vVCUodFFns8ekz6/nf7y2nT/w+qFfq5OJckuQ5uu9cNiFf/Nqe
 UoMKZwIfoK+wDcnmAfli1Hck0XUzA7XxrXuE4pauFU2/GIAJRA
 fIm3o4ZDPho2uPtQTvLLNVe/FEM8DhkW4iPWS/IdrIsY/Nnc6E
 stxjJymTMB9RkgoyYQbKmZQYLEvuhpezeAYbvMc3hN1ssCtjlK
 FYvgA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the device tree support in place, probe the PCIe controller from
the device tree and remove the corresponding workaround in the board
file.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-harmony.dts    | 20 ++++++--
 arch/arm/mach-tegra/Makefile             |  2 -
 arch/arm/mach-tegra/board-dt-tegra20.c   | 12 -----
 arch/arm/mach-tegra/board-harmony-pcie.c | 88 --------------------------------
 4 files changed, 16 insertions(+), 106 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/board-harmony-pcie.c

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index b506de9..e5b3aec 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -335,7 +335,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				pci_clk_reg: ldo0 {
 					regulator-name = "vdd_ldo0,vddio_pex_clk";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
@@ -419,6 +419,20 @@
 		nvidia,invert-interrupt;
 	};
 
+	pcie-controller {
+		pex-clk-supply = <&pci_clk_reg>;
+		vdd-supply = <&pci_vdd_reg>;
+		status = "okay";
+
+		pci@1,0 {
+			status = "okay";
+		};
+
+		pci@2,0 {
+			status = "okay";
+		};
+	};
+
 	usb@c5000000 {
 		status = "okay";
 	};
@@ -481,7 +495,7 @@
 			enable-active-high;
 		};
 
-		regulator@3 {
+		pci_vdd_reg: regulator@3 {
 			compatible = "regulator-fixed";
 			reg = <3>;
 			regulator-name = "vdd_1v05";
@@ -489,8 +503,6 @@
 			regulator-max-microvolt = <1050000>;
 			gpio = <&pmic 2 0>;
 			enable-active-high;
-			/* Hack until board-harmony-pcie.c is removed */
-			status = "disabled";
 		};
 
 		regulator@4 {
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 463a77e..9003d05 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -33,6 +33,4 @@ obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
 
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-harmony-pcie.o
-
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-paz00.o
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 5644dfb..9e8256ab 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -152,17 +152,6 @@ static void __init trimslice_init(void)
 #endif
 }
 
-static void __init harmony_init(void)
-{
-#ifdef CONFIG_TEGRA_PCI
-	int ret;
-
-	ret = harmony_pcie_init();
-	if (ret)
-		pr_err("harmony_pcie_init() failed: %d\n", ret);
-#endif
-}
-
 static void __init paz00_init(void)
 {
 	tegra_paz00_wifikill_init();
@@ -173,7 +162,6 @@ static struct {
 	void (*init)(void);
 } board_init_funcs[] = {
 	{ "compulab,trimslice", trimslice_init },
-	{ "nvidia,harmony", harmony_init },
 	{ "compal,paz00", paz00_init },
 };
 
diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
deleted file mode 100644
index 94c0529..0000000
--- a/arch/arm/mach-tegra/board-harmony-pcie.c
+++ /dev/null
@@ -1,88 +0,0 @@
-/*
- * arch/arm/mach-tegra/board-harmony-pcie.c
- *
- * Copyright (C) 2010 CompuLab, Ltd.
- * Mike Rapoport <mike@compulab.co.il>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/gpio.h>
-#include <linux/err.h>
-#include <linux/of_gpio.h>
-#include <linux/regulator/consumer.h>
-
-#include <asm/mach-types.h>
-
-#include <mach/pci-tegra.h>
-
-#include "board.h"
-
-#ifdef CONFIG_TEGRA_PCI
-static int harmony_pcie_board_init(struct platform_device *pdev)
-{
-	struct device_node *np;
-	int en_vdd_1v05;
-	struct regulator *regulator = NULL;
-	int err;
-
-	np = of_find_node_by_path("/regulators/regulator@3");
-	if (!np) {
-		pr_err("%s: of_find_node_by_path failed\n", __func__);
-		return -ENODEV;
-	}
-
-	en_vdd_1v05 = of_get_named_gpio(np, "gpio", 0);
-	if (en_vdd_1v05 < 0) {
-		pr_err("%s: of_get_named_gpio failed: %d\n", __func__,
-		       en_vdd_1v05);
-		return en_vdd_1v05;
-	}
-
-	err = gpio_request(en_vdd_1v05, "EN_VDD_1V05");
-	if (err) {
-		pr_err("%s: gpio_request failed: %d\n", __func__, err);
-		return err;
-	}
-
-	gpio_direction_output(en_vdd_1v05, 1);
-
-	regulator = regulator_get(NULL, "vdd_ldo0,vddio_pex_clk");
-	if (IS_ERR_OR_NULL(regulator)) {
-		pr_err("%s: regulator_get failed: %d\n", __func__,
-		       (int)PTR_ERR(regulator));
-		goto err_reg;
-	}
-
-	regulator_enable(regulator);
-
-	return 0;
-
-err_reg:
-	gpio_free(en_vdd_1v05);
-
-	return err;
-}
-
-int __init harmony_pcie_init(void)
-{
-	tegra_pcie_pdata.init = harmony_pcie_board_init;
-	platform_device_register(&tegra_pcie_device);
-
-	return 0;
-}
-#else
-int __init harmony_pcie_init(void)
-{
-	return 0;
-}
-#endif
-- 
1.8.1

