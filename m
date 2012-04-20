Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2DTOqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:46:05 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45828 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2DTOqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:46:03 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: vinod.koul@intel.com
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] dmaengine: dw_dma: add Device Tree probing capability
Date: Fri, 20 Apr 2012 20:15:34 +0530
Message-Id: <35e64128140409833be8ca543b9640c2dac39796.1334933079.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPEAr platforms now support DT and so must convert all drivers to support DT.
This patch adds DT probing support for Synopsys DMA controller and updates its
documentation too.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 Documentation/devicetree/bindings/dma/snps-dma.txt |   17 +++++++++++++++++
 drivers/dma/dw_dmac.c                              |   10 ++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/snps-dma.txt

diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
new file mode 100644
index 0000000..c0d85db
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/snps-dma.txt
@@ -0,0 +1,17 @@
+* Synopsys Designware DMA Controller
+
+Required properties:
+- compatible: "snps,dma-spear1340"
+- reg: Address range of the DMAC registers
+- interrupt-parent: Should be the phandle for the interrupt controller
+  that services interrupts for this device
+- interrupt: Should contain the DMAC interrupt number
+
+Example:
+
+	dma@fc000000 {
+		compatible = "snps,dma-spear1340";
+		reg = <0xfc000000 0x1000>;
+		interrupt-parent = <&vic1>;
+		interrupts = <12>;
+	};
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 300d976..13b9298 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -1592,12 +1593,21 @@ static const struct dev_pm_ops dw_dev_pm_ops = {
 	.poweroff_noirq = dw_suspend_noirq,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id dw_dma_id_table[] = {
+	{ .compatible = "snps,dma-spear1340" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, dw_dma_id_table);
+#endif
+
 static struct platform_driver dw_driver = {
 	.remove		= __exit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.driver = {
 		.name	= "dw_dmac",
 		.pm	= &dw_dev_pm_ops,
+		.of_match_table = of_match_ptr(dw_dma_id_table),
 	},
 };
 
-- 
1.7.9

