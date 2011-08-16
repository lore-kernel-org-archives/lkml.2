Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1HPRxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:53:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17614 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1HPRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:52:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110727525"
From: David Brown <davidb@codeaurora.org>
To: Randy Dunlap <rdunlap@xenotime.net>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 2/4] msm_serial: Add devicetree support
Date: Tue, 16 Aug 2011 10:52:14 -0700
Message-Id: <1313517136-27414-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313517136-27414-1-git-send-email-davidb@codeaurora.org>
References: <1313517136-27414-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree support to the msm_serial driver.  Clocks are still
queried by direct name from the driver until device tree clock support
is implemented.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 .../devicetree/bindings/tty/serial/msm_serial.txt  |   22 ++++++++++++++++++++
 drivers/tty/serial/msm_serial.c                    |   14 ++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt

diff --git a/Documentation/devicetree/bindings/tty/serial/msm_serial.txt b/Documentation/devicetree/bindings/tty/serial/msm_serial.txt
new file mode 100644
index 0000000..1b72e79
--- /dev/null
+++ b/Documentation/devicetree/bindings/tty/serial/msm_serial.txt
@@ -0,0 +1,22 @@
+* Qualcomm MSM UART
+
+Required properties:
+- compatible :
+	- "qcom,msm-uart"
+- reg : offset and length of the register set for the device
+	for the hsuart operating in compatible mode, there should be a
+	second pair describing the gsbi registers.
+- interrupts : should contain the uart interrupt.
+
+There are two different UART blocks in MSM devices, "qcom,msm-uart"
+and "qcom,msm-hsuart".  The msm-serial driver is able to handle both
+of these devices.
+
+Example:
+
+	uart@19c400000 {
+		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
+		reg = <0x19c40000 0x1000>,
+		      <0x19c00000 0x1000>;
+		interrupts = <195>;
+	};
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index d9863b2..7767902 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -19,6 +19,7 @@
 # define SUPPORT_SYSRQ
 #endif
 
+#include <linux/atomic.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <linux/io.h>
@@ -33,6 +34,8 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include "msm_serial.h"
 
@@ -856,6 +859,8 @@ static struct uart_driver msm_uart_driver = {
 	.cons = MSM_CONSOLE,
 };
 
+static atomic_t msm_uart_next_id = ATOMIC_INIT(0);
+
 static int __init msm_serial_probe(struct platform_device *pdev)
 {
 	struct msm_port *msm_port;
@@ -863,6 +868,9 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	struct uart_port *port;
 	int irq;
 
+	if (pdev->id == -1)
+		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
+
 	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
 		return -ENXIO;
 
@@ -920,11 +928,17 @@ static int __devexit msm_serial_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id msm_match_table[] = {
+	{ .compatible = "qcom,msm-uart" },
+	{}
+};
+
 static struct platform_driver msm_platform_driver = {
 	.remove = msm_serial_remove,
 	.driver = {
 		.name = "msm_serial",
 		.owner = THIS_MODULE,
+		.of_match_table = msm_match_table,
 	},
 };
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

