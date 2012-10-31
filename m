Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2KHTyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:54:17 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:47086 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab2KHTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:15 -0500
Message-Id: <80ce7f830bd3fd131da4aff9e33d6c0dc2c359a8.1352400580.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1352400580.git.josh.cartwright@ni.com>
References: <cover.1352400580.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Wed, 31 Oct 2012 13:28:49 -0600
Subject: [PATCH v2 4/5] serial: xilinx_uartps: get clock rate info from dts
To: Alan Cox <alan@linux.intel.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        John Linn <john.linn@xilinx.com>, arm@kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize complete at 11/08/2012 01:54:07 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-08_04:2012-11-08,2012-11-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for specifying clock information for the uart clk via the
device tree.  This eliminates the need to hardcode rates in the device
tree.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi   |  4 ++--
 drivers/tty/serial/xilinx_uartps.c | 30 +++++++++++++++++-------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index bb3085c..c975c2d 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -44,14 +44,14 @@
 			compatible = "xlnx,xuartps";
 			reg = <0xE0000000 0x1000>;
 			interrupts = <0 27 4>;
-			clock = <50000000>;
+			clocks = <&uart_clk 0>;
 		};
 
 		uart1: uart@e0001000 {
 			compatible = "xlnx,xuartps";
 			reg = <0xE0001000 0x1000>;
 			interrupts = <0 50 4>;
-			clock = <50000000>;
+			clocks = <&uart_clk 1>;
 		};
 
 		slcr: slcr@f8000000 {
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 23efe17..adfecbc 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -17,6 +17,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/console.h>
+#include <linux/clk.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -944,18 +945,20 @@ static int __devinit xuartps_probe(struct platform_device *pdev)
 	int rc;
 	struct uart_port *port;
 	struct resource *res, *res2;
-	int clk = 0;
+	struct clk *clk;
 
-	const unsigned int *prop;
-
-	prop = of_get_property(pdev->dev.of_node, "clock", NULL);
-	if (prop)
-		clk = be32_to_cpup(prop);
+	clk = of_clk_get(pdev->dev.of_node, 0);
 	if (!clk) {
 		dev_err(&pdev->dev, "no clock specified\n");
 		return -ENODEV;
 	}
 
+	rc = clk_prepare_enable(clk);
+	if (rc) {
+		dev_err(&pdev->dev, "could not enable clock\n");
+		return -EBUSY;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
@@ -978,7 +981,8 @@ static int __devinit xuartps_probe(struct platform_device *pdev)
 		port->mapbase = res->start;
 		port->irq = res2->start;
 		port->dev = &pdev->dev;
-		port->uartclk = clk;
+		port->uartclk = clk_get_rate(clk);
+		port->private_data = clk;
 		dev_set_drvdata(&pdev->dev, port);
 		rc = uart_add_one_port(&xuartps_uart_driver, port);
 		if (rc) {
@@ -1000,14 +1004,14 @@ static int __devinit xuartps_probe(struct platform_device *pdev)
 static int __devexit xuartps_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = dev_get_drvdata(&pdev->dev);
-	int rc = 0;
+	struct clk *clk = port->private_data;
+	int rc;
 
 	/* Remove the xuartps port from the serial core */
-	if (port) {
-		rc = uart_remove_one_port(&xuartps_uart_driver, port);
-		dev_set_drvdata(&pdev->dev, NULL);
-		port->mapbase = 0;
-	}
+	rc = uart_remove_one_port(&xuartps_uart_driver, port);
+	dev_set_drvdata(&pdev->dev, NULL);
+	port->mapbase = 0;
+	clk_disable_unprepare(clk);
 	return rc;
 }
 
-- 
1.8.0


