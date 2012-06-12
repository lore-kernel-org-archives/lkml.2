Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab2FLCdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:33:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2FLCch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:32:37 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: mchehab@redhat.com, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v2 3/3] edac: add support for Calxeda highbank L2 cache ecc
Date: Mon, 11 Jun 2012 21:32:14 -0500
Message-Id: <1339468334-9927-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
References: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add support for L2 ECC on Calxeda highbank platform.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/arm/calxeda/l2ecc.txt      |   17 +++
 arch/arm/boot/dts/highbank.dts                     |    6 +
 drivers/edac/Kconfig                               |    7 +
 drivers/edac/Makefile                              |    2 +
 drivers/edac/highbank_l2_edac.c                    |  149 ++++++++++++++++++++
 5 files changed, 181 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
 create mode 100644 drivers/edac/highbank_l2_edac.c

diff --git a/Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt b/Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
new file mode 100644
index 0000000..f71e898
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
@@ -0,0 +1,17 @@
+Calxeda Highbank L2 cache ECC
+
+Properties:
+- compatible : Should be "calxeda,hb-sregs-l2-ecc"
+- reg : Address and size for ECC error interrupt clear registers.
+- interrupts : Should be single bit error interrupt, then double bit error
+	interrupt.
+
+Example:
+
+	sregs@fff3c200 {
+		compatible = "calxeda,hb-sregs-l2-ecc";
+		reg = <0xfff3c200 0x100>;
+		interrupts = <0 71 4  0 72 4>;
+	};
+
+
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index d4b4941..4d641ea 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -194,6 +194,12 @@
 			reg = <0xfff3c000 0x1000>;
 		};
 
+		sregs@fff3c200 {
+			compatible = "calxeda,hb-sregs-l2-ecc";
+			reg = <0xfff3c200 0x100>;
+			interrupts = <0 71 4  0 72 4>;
+		};
+
 		dma@fff3d000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0xfff3d000 0x1000>;
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index f7efa8b..409b92b 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -309,4 +309,11 @@ config EDAC_HIGHBANK_MC
 	  Support for error detection and correction on the
 	  Calxeda Highbank memory controller.
 
+config EDAC_HIGHBANK_L2
+	tristate "Highbank L2 Cache"
+	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
+	help
+	  Support for error detection and correction on the
+	  Calxeda Highbank memory controller.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 44f2044..a227c7f 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -57,3 +57,5 @@ obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
 obj-$(CONFIG_EDAC_TILE)			+= tile_edac.o
 
 obj-$(CONFIG_EDAC_HIGHBANK_MC)	+= highbank_mc_edac.o
+obj-$(CONFIG_EDAC_HIGHBANK_L2)	+= highbank_l2_edac.o
+
diff --git a/drivers/edac/highbank_l2_edac.c b/drivers/edac/highbank_l2_edac.c
new file mode 100644
index 0000000..e599b00
--- /dev/null
+++ b/drivers/edac/highbank_l2_edac.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright 2011-2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/edac.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
+
+#include "edac_core.h"
+#include "edac_module.h"
+
+#define SR_CLR_SB_ECC_INTR	0x0
+#define SR_CLR_DB_ECC_INTR	0x4
+
+struct hb_l2_drvdata {
+	void __iomem *base;
+	int sb_irq;
+	int db_irq;
+};
+
+static irqreturn_t highbank_l2_err_handler(int irq, void *dev_id)
+{
+	struct edac_device_ctl_info *dci = dev_id;
+	struct hb_l2_drvdata *drvdata = dci->pvt_info;
+
+	if (irq == drvdata->sb_irq) {
+		writel(1, drvdata->base + SR_CLR_SB_ECC_INTR);
+		edac_device_handle_ce(dci, 0, 0, dci->ctl_name);
+	}
+	if (irq == drvdata->db_irq) {
+		writel(1, drvdata->base + SR_CLR_DB_ECC_INTR);
+		edac_device_handle_ue(dci, 0, 0, dci->ctl_name);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit highbank_l2_err_probe(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci;
+	struct hb_l2_drvdata *drvdata;
+	struct resource *r;
+	int res = 0;
+
+	dci = edac_device_alloc_ctl_info(sizeof(*drvdata), "cpu",
+		1, "L", 1, 2, NULL, 0, 0);
+	if (!dci)
+		return -ENOMEM;
+
+	drvdata = dci->pvt_info;
+	dci->dev = &pdev->dev;
+	platform_set_drvdata(pdev, dci);
+
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "Unable to get mem resource\n");
+		res = -ENODEV;
+		goto err;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, r->start,
+				     resource_size(r), dev_name(&pdev->dev))) {
+		dev_err(&pdev->dev, "Error while requesting mem region\n");
+		res = -EBUSY;
+		goto err;
+	}
+
+	drvdata->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+	if (!drvdata->base) {
+		dev_err(&pdev->dev, "Unable to map regs\n");
+		res = -ENOMEM;
+		goto err;
+	}
+
+	drvdata->db_irq = platform_get_irq(pdev, 0);
+	res = devm_request_irq(&pdev->dev, drvdata->db_irq,
+			       highbank_l2_err_handler,
+			       0, dev_name(&pdev->dev), dci);
+	if (res < 0)
+		goto err;
+
+	drvdata->sb_irq = platform_get_irq(pdev, 1);
+	res = devm_request_irq(&pdev->dev, drvdata->sb_irq,
+			       highbank_l2_err_handler,
+			       0, dev_name(&pdev->dev), dci);
+	if (res < 0)
+		goto err;
+
+	dci->mod_name = dev_name(&pdev->dev);
+	dci->dev_name = dev_name(&pdev->dev);
+
+	if (edac_device_add_device(dci))
+		goto err;
+
+	devres_close_group(&pdev->dev, NULL);
+	return 0;
+err:
+	devres_release_group(&pdev->dev, NULL);
+	edac_device_free_ctl_info(dci);
+	return res;
+}
+
+static int highbank_l2_err_remove(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci = platform_get_drvdata(pdev);
+
+	edac_device_del_device(&pdev->dev);
+	edac_device_free_ctl_info(dci);
+	return 0;
+}
+
+static const struct of_device_id hb_l2_err_of_match[] = {
+	{ .compatible = "calxeda,hb-sregs-l2-ecc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, hb_l2_err_of_match);
+
+static struct platform_driver highbank_l2_edac_driver = {
+	.probe = highbank_l2_err_probe,
+	.remove = highbank_l2_err_remove,
+	.driver = {
+		.name = "hb_l2_edac",
+		.of_match_table = hb_l2_err_of_match,
+	},
+};
+
+module_platform_driver(highbank_l2_edac_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Calxeda, Inc.");
+MODULE_DESCRIPTION("EDAC Driver for Calxeda Highbank L2 Cache");
-- 
1.7.9.5

